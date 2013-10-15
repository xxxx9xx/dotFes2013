package fish.collection.entry
{
	import fish.collection.MainDelegate;
	import fish.collection.entry.view.EntryView;
	
	import pigglife.view.ViewContainer;

	public class EntryModel
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:EntryInternalDelegate;
		private var _container:ViewContainer;
		private var _entryView:EntryView;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function EntryModel()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(delegate:MainDelegate, container:ViewContainer):void
		{
			_idelegate = new EntryInternalDelegate(this, delegate);
			_container = container;
			
			_entryView = new EntryView(_idelegate);
			_entryView.initialize();
			_container.addUI(_entryView.view);
		}
		
		public function showEntry():void
		{
			_entryView.show()
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			
		}
	}
}