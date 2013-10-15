package fish.collection.top
{
	import fish.collection.MainDelegate;
	import fish.collection.fish.FishView;
	import fish.collection.fish.data.FishData;
	
	import pigglife.data.common.AvatarData;
	import pigglife.view.ViewContainer;

	/**
	 * 
	 * @author A12697
	 */
	public class TopModel
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:TopInternalDelegate;
		private var _container:ViewContainer;
		private var _topView:TopView;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function TopModel()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(delegate:MainDelegate, container:ViewContainer):void
		{
			_idelegate = new TopInternalDelegate(this, delegate);
			_container = container;
			
			_topView = new TopView(_idelegate);
			_topView.initialize();
			_container.addUI(_topView.view);
			
			var fishView:FishView = new FishView();
			fishView.initialize(createFishData());
			fishView.show();
			fishView.view.x = 100;
			fishView.view.y = 100;
			_container.addUI(fishView.view);
		}
		
		private function createFishData():FishData
		{
			var obj:Object ={
				code:"fish1", 
				name:"わたしだ", 
				part:{
					head:{x:0, y:1},
					body:{x:0, y:1},
					r_hand:{x:0, y:1},
					l_hand:{x:0, y:1},
					tail:{x:0, y:1}
				}
			};
			var data:FishData = new FishData(obj);
			
			return data;
		}
		
		public function showTop():void
		{
			_topView.show();
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			_topView.clean();
		}
	}
}