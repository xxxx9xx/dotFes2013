package fish.collection
{
	import fish.collection.entry.EntryModel;
	import fish.collection.net.FishClient;
	import fish.collection.top.TopModel;
	
	import pigglife.view.ViewContainer;

	public class MainModel
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _client:FishClient;
		private var _config:Configuration;
		private var _delegate:MainDelegate;
		private var _facade:MainFacade;
		private var _container:ViewContainer;
		private var _topModel:TopModel;
		private var _entryModel:EntryModel;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set client(client:FishClient):void
		{
			_client = client;
		}
		
		public function set delegate(delegate:MainDelegate):void
		{
			_delegate = delegate;
		}
		
		public function set facade(facade:MainFacade):void
		{
			_facade = facade;
		}
		
		public function set container(value:ViewContainer):void
		{
			_container = value;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MainModel()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			showTop();
		}
		
		public function showTop():void
		{
			if (!_topModel)
			{
				_topModel = new TopModel();
				_topModel.initialize(_delegate, _container);
			}
			_topModel.showTop();
		}
		
		public function cleanTop():void
		{
			
		}
		
		public function showEntry():void
		{
			request();
			if (!_entryModel)
			{
				_entryModel = new EntryModel();
				_entryModel.initialize(_delegate, _container);
			}
			_entryModel.showEntry();
		}
		
		public function cleanEntry():void
		{
			
		}
		
		public function request():void
		{
			_facade.request();
		}
//		
//		/**
//		 * スタート 
//		 */
//		public function start():void
//		{
//			openClient();
//		}
//		
//		/**
//		 *　ソケットサーバーを開く 
//		 */
//		public function openClient():void
//		{
//			_client.open(_config.serverUrl, _config.serverOrigin);
//		}
//		
//		public function showError(error:Error, block:Boolean = false):void
//		{
//			log(error);
//		}
	}
}