package fish.collection
{
	import fish.collection.net.FishClient;
	
	import pigglife.util.Callback;

	/**
	 * 
	 * @author A12697
	 */
	public class MainFacade
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _client:FishClient;
		private var _config:Configuration;
		private var _model:MainModel;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set client(value:FishClient):void 
		{
			_client = value; 
		}
		
		public function set config(value:Configuration):void 
		{
			_config = value; 
		}
		public function set model(value:MainModel):void 
		{ 
			_model = value; 
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MainFacade()
		{
		}
		
		/**
		 * 接続後のログイン処理
		 */
		public function request():void
		{
			log();
			//_client.send('test', {}, new Callback(onGet).onError(errorLogin));
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		private function onGet(data:Object):void
		{
			log(data);
		}
		
		private function errorLogin(err:Error):void
		{
			log(err);
		}
	}
}