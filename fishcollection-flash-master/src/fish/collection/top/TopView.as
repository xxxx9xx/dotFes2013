package fish.collection.top
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import fish.collection.poi.PoiView;
	
	import pigglife.util.ButtonHelper;
	import pigglife.view.RootStage;

	/**
	 *　トップ画面
	 * @author bamba misaki
	 */
	public class TopView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:TopInternalDelegate;
		private var _container:Sprite;
		private var _buttonHelper:ButtonHelper;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function get view():Sprite {return _container;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function TopView(idelegate:TopInternalDelegate)
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
			_buttonHelper = new ButtonHelper(_container).click(onClick);
		}
		
		public function show():void
		{
			// ロゴ
			createLogo();
		}
		
		/**
		 * clean 
		 */
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
			_idelegate.showEntry()
			_idelegate.request();	
		}
		
		/**
		 * ロゴを表示 
		 */
		private function createLogo():void
		{
			var logo:Bitmap = new Bitmap(new Logo);
			logo.x = int((RootStage.stageWidth - logo.width) *.5);
			logo.y = int((RootStage.stageHeight - logo.height) *.5);
			_container.addChild(logo);
		}
	}
}