package fish.collection
{
	import fish.collection.entry.EntryModel;
	import fish.collection.game.GameModel;
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
		private var _gameModel:GameModel;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set client(value:FishClient):void
		{
			_client = value;
		}
		
		public function set delegate(value:MainDelegate):void
		{
			_delegate = value;
		}
		
		public function set facade(value:MainFacade):void
		{
			_facade = value;
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
		
		/**
		 * トップを表示 
		 */
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
		
		/**
		 * エントリーを表示 
		 */
		public function showEntry():void
		{
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
		
		/**
		 * ゲームモジュールを表示
		 */
		public function showGame():void
		{
			if (!_gameModel)
			{
				_gameModel = new GameModel();
				_gameModel.initialize(_delegate, _container);
			}
			_gameModel.showGame();
		}
		
		public function request():void
		{
			_facade.request();
		}
		
		/**
		 * スタート 
		 */
		public function start():void
		{
			openClient();
		}
		
		/**
		 *　ソケットサーバーを開く 
		 */
		public function openClient():void
		{
			//_client.open('ws://172.22.245.248:8888', '*');
		}
		
		public function showError(error:Error, block:Boolean = false):void
		{
			log(error);
		}
	}
}