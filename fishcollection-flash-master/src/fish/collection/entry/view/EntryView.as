package fish.collection.entry.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import fish.collection.entry.EntryInternalDelegate;
	
	import pigglife.util.ButtonHelper;
	
	/**
	 * 
	 * @author A12697
	 */
	public class EntryView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:EntryInternalDelegate;
		private var _container:Sprite;
		private var _buttonHelper:ButtonHelper;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function get view():Sprite {return _container;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function EntryView(idelegate:EntryInternalDelegate)
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
			logo.x = 24; logo.y = 32;
			_container.addChild(logo);
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
		
		// とりあえずロゴクリックでゲーム画面に行く
		private function onClick():void
		{
			clean();
			_idelegate.showGame();			
		}
	}
}