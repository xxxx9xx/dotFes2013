package fish.collection
{
	import fish.collection.net.FishClient;
	import pigglife.util.Callback;

	/**
	 * データ送受信
	 * @author bamba misaki
	 */
	public class MainFacade
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _client:FishClient;
		private var _model:MainModel;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set client(value:FishClient):void 
		{
			_client = value; 
		}
		
		public function set model(value:MainModel):void 
		{ 
			_model = value; 
		}
		
		public function get name():String
		{
			return 'fish';
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
			_client.send({id : "test", data : ""}, new Callback(onData));
		}
		
		/**
		 * データ受信 
		 * @param data
		 */
		public function onData(data:Object):void
		{
			switch(data.id)
			{
				case 'poi':
				{
					_model.showEntry();
					break;
				}
					
				default:
				{
					break;
				}
			}
			log('onGetonGetonGetonGetonGetonGetonGetonGetonGetonGetonGetonGetonGet', data);
		}
	}
}