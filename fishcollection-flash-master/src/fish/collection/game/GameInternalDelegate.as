package fish.collection.game
{
	import fish.collection.MainDelegate;

	public class GameInternalDelegate
	{
		private var _model:GameModel;
		private var _delegate:MainDelegate;
		
		public function GameInternalDelegate()
		{
		}
		
		/**
		 * 初期化
		 */
		public function initialize(model:GameModel, delegate:MainDelegate):void
		{
			_model = model;
			_delegate = delegate;
		}
	}
}