package fish.collection.poi
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * ポイ 
	 * @author bamba misaki
	 */
	public class PoiView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _container:Sprite;
		private var _poi:Sprite;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function get view():Sprite {return _container;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function PoiView()
		{
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
		public function show():void
		{
			_poi = new Sprite();
			var poi1:Bitmap = new Bitmap(new Poi1);
			_poi.addChild(poi1);
			_container.addChild(_poi);
			
			addEventListener(Event.ENTER_FRAME,function (e:Event):void{
				
				// スプライト上のマウスカーソルの位置を取得
				var mouse_x : Number = _container.mouseX;
				var mouse_y : Number = _container.mouseY;
				
				_poi.x = mouse_x;
				_poi.y = mouse_y;
				trace(mouse_x,mouse_y);
			});
			
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
	}
}