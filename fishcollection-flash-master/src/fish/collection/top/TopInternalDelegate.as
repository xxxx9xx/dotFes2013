package fish.collection.top
{
	import fish.collection.MainDelegate;

	/**
	 * 
	 * @author A12697
	 */
	public class TopInternalDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _model:TopModel;
		private var _delegate:MainDelegate;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function TopInternalDelegate(model:TopModel, delegate:MainDelegate)
		{
			_model = model;
			_delegate = delegate;
		}
		
		public function clean():void
		{
			_model.clean();
		}
		
		public function showEntry():void
		{
			_delegate.showEntry();
		}
	}
}