package fish.collection.net
{
	
	import flash.utils.ByteArray;
	
	import pigglife.util.Executor;

	/**
	 *	シンプルなwebsocketClientラッパー
	 */
	public class SimpleSocketClient implements WebSocketHandler
	{
		private var _model:ISimpleSocketModel;
		private var _websocket:FishClientWebSocket;
		
		private var _connectWaiting:Boolean;
		
		//=========================================================
		// CONSTRUCTOR
		//=========================================================
		private var _isReconnecWait:Boolean;
		
		public function SimpleSocketClient()
		{
		}
		
		//===========================================================
		// GETTER / SETTER
		//===========================================================
		public function set model(model:ISimpleSocketModel):void
		{
			_model = model;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function initialize():void
		{
			_websocket = new FishClientWebSocket(this);
			open();
		}
		
		public function open():void
		{
			log("再接続開始");
			_connectWaiting = false;
			_websocket.open();
		}
		
		//===========================================================
		// IMPLEMENTATION METHODS
		//===========================================================
		
		public function onOpen():void
		{
			log();
			_isReconnecWait = false;
			Executor.cancelByName("reconnection");
		}
		
		public function onClose():void
		{
			log();



			_model.destroy();
			reconnection();
		}
		
		/**
		 * 再コネクション
		 */
		private function reconnection():void
		{
			if (_isReconnecWait) return;
			_isReconnecWait = true;
			log("5秒後に再コネクションを試みます");
			Executor.executeAfterWithName(5*24, "reconnection", reconnectWaitEnd);
		}
		
		public function onMessage(data:String):void
		{
			log();
			_model.updateMessage(data);
		}
		
		public function onData(frame:int, data:ByteArray):void
		{
			log();
		}
		
		public function onSocketError(e:Error):void
		{
			log("接続失敗::" + e.message);
			reconnection();
		}
		
		private function reconnectWaitEnd():void
		{
			_isReconnecWait = false;
			open();
		}
		
		public function onHandleError(e:Error):void
		{
			log();
		}
	}
}