package fish.collection.poi
{
	import fish.collection.common.FontNames;
	import fish.collection.poi.data.PoiData;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import pigglife.util.ButtonHelper;

	/**
	 * ポイ 
	 * @author bamba misaki
	 */
	public class PoiView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:PoiInternalDelegate;
		private var _container:Sprite;
		private var _data:PoiData;
		private var _buttonHelper:ButtonHelper;
		private var _score:Object;
		private var _poi:Sprite;
		private var _userName:TextField;
		private var _userLife:Sprite;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function get view():Sprite {return _container;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function PoiView(idelegate:PoiInternalDelegate)
		{
			_idelegate = idelegate;
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			_container = new Sprite();
			addChild(_container);
		}
		
		/**
		 * ポイを表示 
		 */
		public function show(data:PoiData):void
		{
			_data = data;
			
			// スコアJSON読み込み
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onLoadScore);
			urlLoader.load(new URLRequest("scorelist.json"));
			
			// ポイ本体の表示
			_poi = new Sprite();
			_poi.addChild(createPoiBitmap());
			_container.addChild(_poi);
			
			// ユーザー名
			createName();
			
			// ポイの残数
			createLife();
			
			// 仮　マウス位置取得
			addEventListener(Event.ENTER_FRAME,function (e:Event):void
			{
				// スプライト上のマウスカーソルの位置を取得
				var mouse_x:Number = _container.mouseX;
				var mouse_y:Number = _container.mouseY;
				
				_poi.x = mouse_x;
				_poi.y = mouse_y;
			});
			
			_buttonHelper = new ButtonHelper(_container).click(onClick);
		}
		
		public function clean():void
		{
			removeAllChild(this);
			if (_container)
			{
				removeAllChild(_container);
				removeFromParent(_container);
			}
			_container = null;
			if (_buttonHelper)
				_buttonHelper.clean();
			_buttonHelper = null;
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		private function onClick():void
		{
			// スコアJSON読み込み
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onLoadSendfish);
			urlLoader.load(new URLRequest("sendfish.json"));
		}
		
		private function onLoadScore(event:Event):void
		{
			var json:String = URLLoader(event.currentTarget).data;
			_score = JSON.parse(json);
			trace(_score["type1"].normal, _score["type2"].normal, _score["type3"].normal, _score["type4"].normal);
		}
		
		private function onLoadSendfish(event:Event):void
		{
			var json:String = URLLoader(event.currentTarget).data;
			var data:Object = JSON.parse(json);
			data.t_id = "p1";
			data.fish_info.size = "small";
			data.fish_info.score = _score["type1"];
			
			log(data.fish_info.score)
			//送信
			_idelegate.sendFish(data);
			
		}
		
		/**
		 * タイプに応じたポイのbitmapを生成 
		 * @return 
		 */
		private function createPoiBitmap():Bitmap
		{
			var poi:Bitmap;
			poi = new Bitmap(new Poi1);
			return poi
		}
		
		/**
		 * ユーザー名を表示 
		 */
		private function createName():void
		{
			// TextFormat
			var format:TextFormat = new TextFormat();
			format.size = 24;
			format.font = FontNames.HELVETICA;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			
			// TextField
			_userName = new TextField();
			_userName.defaultTextFormat = format;
			_userName.text = _data.t_id + " " + _data.name;
			_userName.width = 200;
			
			_userName.x = int((_poi.width - _userName.width) *.5);
			_userName.y = _poi.y - 40;
			
			_poi.addChild(_userName);
		}
		
		/**
		 * ポイの残数表示 
		 */
		private function createLife():void
		{
			_userLife = new Sprite();
			
			// TextFormat
			var format:TextFormat = new TextFormat();
			format.size = 20;
			format.font = FontNames.HELVETICA;
			format.bold = true;
			
			// TextField
			var name:TextField = new TextField();
			name.defaultTextFormat = format;
			name.text = "残り" + 3;
			name.width = 200;
			
			name.x = int((_poi.width - name.width) *.5);
			name.y = _poi.y - 20;
			_poi.addChild(name);
		}
	}
}