package fish.collection
{
	public class MainDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _model:MainModel;
		private var _mainFacade:MainFacade;
	
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set model(value:MainModel):void
		{
			_model = value;
		}
		
		public function set mainFacade(value:MainFacade):void
		{
			_mainFacade = value;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MainDelegate()
		{
		}
		
		public function request():void
		{
			_model.request();
		}
		
		/**
		 * エントリーを表示 
		 */
		public function showEntry():void
		{
			_model.showEntry();
		}
		
		/**
		 * ゲームビューを表示
		 */
		public function showGame():void
		{
			_model.showGame();
		}
	}
}