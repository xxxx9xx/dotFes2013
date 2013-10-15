package fish.collection.fish
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import fish.collection.fish.configuration.BodyConfiguration;
	
	/**
	 * 金魚の骨組みを生成
	 * @author bamba misaki
	 */
	public class BaseFishView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _baseHead:Head;
		private var _baseBody:Body;
		private var _baseRHand:RHand;
		private var _baseLHand:LHand;
		private var _baseTail:Tail;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function get head():MovieClip {return _baseHead;}
		public function get body():MovieClip {return _baseBody;}
		public function get rHand():MovieClip {return _baseRHand;}
		public function get lHand():MovieClip {return _baseLHand;}
		public function get tail():MovieClip {return _baseTail;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function BaseFishView()
		{
			// 各パーツの下地 
			_baseHead = new Head();
			_baseBody = new Body();
			_baseRHand = new RHand();
			_baseLHand = new LHand();
			_baseTail = new Tail();
			
			getPos(_baseHead, BodyConfiguration.HEAD);
			getPos(_baseBody, BodyConfiguration.BODY);
			getPos(_baseRHand, BodyConfiguration.R_HAND);
			getPos(_baseLHand, BodyConfiguration.L_HAND);
			getPos(_baseTail, BodyConfiguration.TAIL);
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			_baseHead = null;
			_baseBody = null;
			_baseRHand = null;
			_baseLHand = null;
			_baseTail = null;
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
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


