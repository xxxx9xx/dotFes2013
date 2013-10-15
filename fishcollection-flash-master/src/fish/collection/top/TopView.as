package fish.collection.top
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import pigglife.util.ButtonHelper;
	import pigglife.view.RootStage;

	/**
	 * 
	 * @author A12697
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
			var logo:Bitmap = new Bitmap(new Logo);
			logo.x = int((RootStage.stageWidth - logo.width) *.5);
			logo.y = int((RootStage.stageHeight - logo.height) *.5);
			_container.addChild(logo);
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			removeAllChild(this);
			if (_container)
				removeAllChild(_container);
			_container = null;
			if (_buttonHelper)
				_buttonHelper.clean();
			_buttonHelper = null;
		}

		private function onClick():void
		{
			clean();
			_idelegate.showEntry();			
		}
	}
}