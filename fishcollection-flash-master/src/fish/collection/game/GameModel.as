package fish.collection.game
{
	import fish.collection.MainDelegate;
	
	import pigglife.view.ViewContainer;

	public class GameModel
	{
		private var _idelegate:GameInternalDelegate;
		private var _container:ViewContainer;
		private var _gameView:GameView;
		
		public function GameModel()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(delegate:MainDelegate, container:ViewContainer):void
		{
			_idelegate = new GameInternalDelegate();
			_idelegate.initialize(this, delegate);
			_container = container;
		}
		
		public function showGame():void
		{
			_gameView = new GameView();
			_gameView.initialize(_idelegate);
			_container.addUI(_gameView.view);
			
			trace('ゲーム開始');
		}
	}
}