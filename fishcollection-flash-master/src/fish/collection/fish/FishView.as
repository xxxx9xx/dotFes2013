package fish.collection.fish
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;
	
	import fish.collection.fish.configuration.BodyConfiguration;
	import fish.collection.fish.data.BodyPositionData;
	import fish.collection.fish.data.FishData;

	/**
	 * 金魚を生成
	 * @author bamba misaki
	 */
	public class FishView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _container:Sprite;
		private var _data:FishData;
		private var _positionData:BodyPositionData;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function get view():Sprite {return _container;}

		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function FishView()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(data:FishData):void
		{
			// データ
			_data = data;
			
			_container = new Sprite();
			addChild(_container);
		}
		
		/**
		 * 金魚を表示 
		 */
		public function show():void
		{
			while (numChildren > 0)
				removeChildAt(0);

			_container.addChild(addParts(_data.type, BodyConfiguration.HEAD));
			_container.addChild(addParts(_data.type, BodyConfiguration.BODY));
			_container.addChild(addParts(_data.type, BodyConfiguration.R_FIN));
			_container.addChild(addParts(_data.type, BodyConfiguration.L_FIN));
			_container.addChild(addParts(_data.type, BodyConfiguration.TAIL));
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			removeAllChild(this);
			if (_container)
				removeAllChild(_container);
			_container = null;
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		/**
		 * MCを各パーツにアタッチ 
		 * @param code
		 * @param part
		 * @return 
		 */
		private function addParts(type:String, part:String):MovieClip
		{
			deme_body_1;
			deme_head_1;
			deme_rFin_1;
			deme_lFin_1;
			deme_tail_1;
			
			var mcName:String = type + "_" + part + "_" + "1";
			var myClass:Class = Class(getDefinitionByName(mcName));
			var mc:MovieClip = new myClass(); 
			getPos(mc, part)
			return mc;
		}
		
		/**
		 * 各パーツの位置を調整 
		 * @param part
		 * @param name
		 */
		private function getPos(part:DisplayObject, name:String):void
		{
			part.x = BodyConfiguration.DEFAULT_POSITION[name].x;
			part.y = BodyConfiguration.DEFAULT_POSITION[name].y;	
		}
	}
}