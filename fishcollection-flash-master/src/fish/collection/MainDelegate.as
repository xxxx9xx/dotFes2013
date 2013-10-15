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
		public function set model(model:MainModel):void
		{
			_model = model;
		}
		
		public function set mainFacade(mainFacade:MainFacade):void
		{
			_mainFacade = mainFacade;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MainDelegate()
		{
		}
		
		public function showEntry():void
		{
			_model.showEntry();
		}
	}
}