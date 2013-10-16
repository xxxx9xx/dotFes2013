package fish.collection.entry
{
	import fish.collection.MainDelegate;

	/**
	 * 
	 * @author A12697
	 */
	public class EntryInternalDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _model:EntryModel;
		private var _delegate:MainDelegate;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function EntryInternalDelegate(model:EntryModel, delegate:MainDelegate)
		{
			_model = model;
			_delegate = delegate;
		}
		// とりあえずゲーム画面に行く
		public function showGame():void
		{
			_delegate.showGame();
		}
	}
}