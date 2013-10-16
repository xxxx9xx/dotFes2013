package fish.collection.entry.mock
{
	import fish.collection.MainDelegate;
	import fish.collection.entry.EntryModel;
	import fish.collection.net.ISimpleSocketModel;
	
	import pigglife.font.FontNames;
	import pigglife.view.RootStage;
	import pigglife.view.ViewContainer;
	import pigglife.view.button.PiggButton;

	/**
	 * エントリーのモック 
	 * @author bamba misaki
	 */
	public class MockEntryDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _main:ISimpleSocketModel;
		private var _model:EntryModel;
		private var _delegate:MainDelegate;
		private var _container:ViewContainer;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set main(value:ISimpleSocketModel):void
		{
			_main = value;
		}
		
		public function set delegate(delegate:MainDelegate):void
		{
			_delegate = delegate;
		}
		
		public function set container(value:ViewContainer):void
		{
			_container = value;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MockEntryDelegate()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			_model = new EntryModel();
			_model.initialize(_delegate, _container);
			
			new PiggButton(12, FontNames.Sans).text('TEST').size(100, 30).position(0, 0).onClick(show).appendTo(RootStage.stage);
		}
		
		/**
		 * 表示 
		 */
		private function show():void
		{
			_model.showEntry();
		}
	}
}