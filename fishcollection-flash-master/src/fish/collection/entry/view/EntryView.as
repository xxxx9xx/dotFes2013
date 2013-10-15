package fish.collection.entry.view
{
	import fish.collection.entry.EntryInternalDelegate;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
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
		}

		public function show():void
		{
			// ロゴ
			var logo:Bitmap = new Bitmap(new Logo);
			logo.x = 24; logo.y = 32;
			_container.addChild(logo);
		}
	}
}