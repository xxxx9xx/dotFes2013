package fish.collection.net
{
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.describeType;
	
	import fish.collection.MainModel;
	
	import pigglife.util.Callback;
	import pigglife.util.Messages;

	/**
	 * ネットワーククライアント
	 * WebSocket を使いソケット通信を実現します。
	 * @author atsumo
	 */
	public class FishClient implements WebSocketHandler
	{
		// MainModel
		private var _model:MainModel;
		// WebSocket
		private var _websocket:FishClientWebSocket;
		// Server URL
		private var _url:String;
		// Origin URL
		private var _origin:String;
		// Trying Count
		private var _tryCount:int;
		
		// Timeout
		private var _timeout:Number;
		
		// メソッド一覧
		private var _methods:Object;
		// コールバック一覧
		private var _callbacks:Object;
		// ハートビートタイマー
		private var _heartbeatTimer:Timer;
		
		public function FishClient()
		{
			_methods = {};
			_methods['error'] = _onError;
			_callbacks = {};
			_heartbeatTimer = new Timer(10000);
			_heartbeatTimer.addEventListener(TimerEvent.TIMER, sendHeartbeat);
		}
		
		public function set model(model:MainModel):void
		{
			_model = model;
		}
		
		public function get isOpen():Boolean
		{
			return _websocket != null && _websocket.isOpen;
		}
		
		/**
		 * クライアント接続をオープンします。
		 * @param host 接続先URL
		 * @param port 接続先ポート名
		 */
		public function open(url:String, origin:String):void
		{
			_url = url;
			_origin = origin;
			_tryCount = 0;
			log("opening connection to", url);
			openNext();
		}
		
		private function openNext():void
		{
			log();
			if (_websocket != null)
			{
				// 既に存在する接続はとじておく
				_websocket.close();
			}
			if (_tryCount >= _url.length) {
				// 接続失敗とする
				var error:Error = new Error();
				error.name = 'error.disconnected';
				error.message = Messages.of('error.disconnected')
				showError(error)
				return;
			}
			_websocket = new FishClientWebSocket(this);
			_websocket.open();
			// 試行カウントを１増やしておく
			_tryCount++;
		}
		
		/**
		 * クライアント接続をクローズします。
		 */
		public function close():void
		{
			log("closing connection");
			if (_websocket != null)
			{
				_websocket.close();
			}
		}
		
		/**
		 * サーバーメソッドのコールを送信します
		 */
		public function send(data:Object, callback:Callback = null):void
		{
			// WebSocketがオープンしていない場合は無視
			if (!_websocket.isOpen)
			{
				onSocketError(new Error(Messages.of('error.disconnected')));
				return;
			}
			
			if (callback != null)
			{
				// リクエストIDとしてコールバックIDを付与
				data._req = callback.id;
				addCallback(callback);
			}
			var json:String = JSON.stringify(data);
			log(json);
		//	_websocket.send(json);
		}
		
		/**
		 * デリゲートインスタンスを追加し、
		 * コールバックマッピングにメソッドを登録します。
		 * @param delegate デリゲートインスタンス
		 */
		public function addDelegate(delegate:IFishClientDelegate):void
		{
			log('Add delegate', delegate);
			var xml:XML = describeType(delegate);
			var methods:XMLList = xml.method;
			for (var i:int = 0; i < methods.length(); i++)
			{
				var methodXml:XML = methods[i];
				if (Object(delegate).hasOwnProperty(methodXml.@name))
				{
					var func:Function = delegate[methodXml.@name] as Function;
					if (func != null && func.length == 1)
					{
						// prefix + method
						var name:String = delegate.name + '.' + methodXml.@name;
						log('-- add handler', name);
						_methods[name] = func;
					}
				}
			}
		}
		
		/**
		 * 接続オープン時
		 */
		public function onOpen():void
		{
			log();
			//Loading.unblock();
			// 試行カウントをリセット
			_tryCount = 0;
			// 接続オープン後、ログイン開始
			//_model.request();
			_heartbeatTimer.start();
			sendHeartbeat(null);
		}
		
		/**
		 * 接続クローズ時
		 */
		public function onClose():void
		{
			log('close');
			// ハートビートタイマー停止
			_heartbeatTimer.stop();
		}
		
		/**
		 * メッセージ受信時
		 */
		public function onMessage(message:String):void
		{
			// メッセージの受信
			log(message);
			try
			{
				var colon:int = message.indexOf(':');
				var method:String = message.substring(0, colon);
				var jsonText:String = message.substring(colon+1);
				var json:Object = JSON.parse(jsonText);//JSON.(jsonText);
				
				//緊急エラー or アメーバメンテナンスエラー
				if (method == 'error')
				{　
					if (json.name == "maintenance.ameba")
					{
						//errorwindowを表示
						//_model.showError(json);
						log(json);
					}
					else if (json.name == 'maintenance.emergency')
					{
						_onError({name:json.name, message:Messages.of('error.'+json.name)});
						return;
					}
				}
				
				//通常時
				if (json._req != null)
				{
					// リクエスト時のIDが存在する場合は、レスポンスコールバック
					var callback:Callback = _callbacks[json._req];
					if (callback != null)
					{
						callback.args.unshift(json);
						if (method == 'error') {
							if (callback.hasErrorHandler) {
								// エラーハンドラが定義されている場合は、エラーハンドラ起動
								var error:Error = new Error();
								error.name = json.name;
								error.message = Messages.of('error.'+json.name);
								callback.error(error);
							} else {
								// エラーハンドラ定義が存在しない場合は、エラー表示をしてコールバック除去
								_expireCallback(callback);
								_onError({name:json.name, message:Messages.of('error.'+json.name)});
							}
						} else {
							// コールバックを実行します
							callback.call();
						}
						return;
					}
				}
				var func:Function = _methods[method];
				if (func != null)
				{
					func.call(null, json);
				}
				else
				{
					throw new Error('No such method \''+ method + '\'');
				}
			}
			catch (e:Error)
			{
				log(e.getStackTrace());
				_onError({name:e.name, message:(e.message)? e.message: ''});
			}
		}
		
		public function onData(frame:int, data:ByteArray):void
		{
			// バイナリデータ受信は未実装
			throw new Error('not implemented yet');
		}
		
		/**
		 * ソケットエラー発生時
		 */
		public function onSocketError(e:Error):void
		{
			log(e.message);
//			if (_websocket.isOpening || _websocket.isWaiting) {
//				// 接続中の場合は、次のURL接続を試みる
//				openNext();
//			} else {
//				//_model.showErrorTemporary(e.message);
//				e.name = 'error.soketError';
//				e.message = Messages.of('error.soketError');
//				showError(e);
//			}
		}
		
		/**
		 * ハンドラのエラー処理
		 */
		public function onHandleError(e:Error):void
		{
			log(e.message, e.getStackTrace());
			showError(e);
		}
		
		private function _onError(data:Object):void
		{
			log();
			var error:Error = new Error();
			error.name  = data.name;
			error.message = (data.messaeg)? data.message : Messages.of('error.'+data.name);
			showError(error);
		}
		
		private function showError(error:Error):void
		{
			log(error);
		}
		
		/**
		 * リクエストIDに対するコールバックを追加します
		 */
		public function addCallback(callback:Callback):void
		{
			_callbacks[callback.id] = callback;
			callback.onExpire(_expireCallback);
		}
		
		/**
		 * コールバックのクリーニング
		 */
		private function _expireCallback(callback:Callback):void
		{
			delete _callbacks[callback.id];
			callback.clean();
		}
		
		/**
		 * ハートビートを送信します
		 */
		private function sendHeartbeat(e:TimerEvent = null):void
		{
			if (_websocket.isOpen)
			{
				try
				{
					//_model.requestHeartbeat();
				}
				catch (e:Error)
				{
					// 送信に失敗した場合は、接続が切断されているのでハートビートを停止
					_heartbeatTimer.stop();
				}
			}
			else
			{
				_heartbeatTimer.stop();
			}
		}
	}
}