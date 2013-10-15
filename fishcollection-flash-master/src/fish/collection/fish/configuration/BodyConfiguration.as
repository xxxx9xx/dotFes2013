package fish.collection.fish.configuration
{
	import flash.geom.Point;

	/**
	 * 金魚生成時のパーツ情報 
	 * @author bamba misaki
	 */
	public class BodyConfiguration
	{
		public static const HEAD:String = "head";
		public static const BODY:String = "body";
		public static const R_FIN:String = "rFin";
		public static const L_FIN:String = "lFin";
		public static const TAIL:String = "tail";
		
		public static const PARTS_NAMES:Vector.<String> = new Vector.<String>();
		PARTS_NAMES[0] = "head";
		PARTS_NAMES[1] = "body";
		PARTS_NAMES[2] = "rFin";
		PARTS_NAMES[3] = "lFin";
		PARTS_NAMES[4] = "tail";
			
		public static const DEFAULT_POSITION:Object = {
			"head"	: new Point(0, 0),
			"body"	: new Point(0, 0),
			"rFin": new Point(0, 0),
			"lFin": new Point(0, 0),
			"tail"	: new Point(0, 50)
		}
		
		// ボディ部のアタッチパーツ名一覧
		public static const BODY_ATTACH_PARTS:Object = {
			"head"	: true,
			"body"	: true,
			"r_Fin"	: true,
			"l_Fin"	: true,
			"tail"	: true
		}
			
		public function BodyConfiguration()
		{
		}
	}
}