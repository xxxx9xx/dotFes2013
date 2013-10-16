package fish.collection.fish
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import fish.collection.fish.configuration.BodyConfiguration;
	
	/**
	 * 金魚のタイプごとに骨組みを生成
	 * @author bamba misaki
	 */
	public class BaseFishView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _fishType:String;
		private var _baseFish:MovieClip;

		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set type(value:String):void
		{
			_fishType = value;
		}
		
		//public function get head():MovieClip {return _baseFish.head_whole;}
		public function get body():MovieClip {return _baseFish.body_whole;}
		//public function get rFin():MovieClip {return _baseFish.rFin_whole;}
		//public function get lFin():MovieClip {return _baseFish.lFin_whole;}
		public function get tail():MovieClip {return _baseFish.tail_whole;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function BaseFishView()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			switch(_fishType)
			{
				case "deme":
					_baseFish =  new Deme();
					break;
				default:
					break;
			}
			
//			getPos(_baseFish.head_whole, BodyConfiguration.HEAD);
			getPos(_baseFish.body_whole, BodyConfiguration.BODY);
//			getPos(_baseFish.rFin_whole, BodyConfiguration.R_FIN);
//			getPos(_baseFish.lFin_whole, BodyConfiguration.L_FIN);
			getPos(_baseFish.tail_whole, BodyConfiguration.TAIL);	
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			_fishType = null;
			_baseFish = null;
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


