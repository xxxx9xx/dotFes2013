package fish.collection.poi.mock
{
	import fish.collection.MainDelegate;
	import fish.collection.poi.PoiModel;
	import fish.collection.poi.PoiView;
	import fish.collection.poi.data.PoiData;
	
	import pigglife.view.ViewContainer;

	/**
	 * 
	 * @author A12697
	 */
	public class MockPoiDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _delegate:MainDelegate;
		private var _container:ViewContainer;
		private var _poiModel:PoiModel;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set delegate(value:MainDelegate):void
		{
			_delegate = value;
		}
		
		public function set container(value:ViewContainer):void
		{
			_container = value;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MockPoiDelegate()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			_poiModel = new PoiModel();
			_poiModel.initialize(_delegate, _container);
			_poiModel.showPoi(createPoiData());
		}
		
		private function showDeme():void
		{
		}
		
		/**
		 * テストデータ 
		 * @return 
		 */
		private function createPoiData():PoiData
		{
			var obj:Object ={
				t_id:"p1", 
				name:"小栗旬"
			};
			var data:PoiData = new PoiData(obj);
			
			return data;
		}
	}
}