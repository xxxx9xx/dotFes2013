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
		public static const R_HAND:String = "r_hand";
		public static const L_HAND:String = "l_hand";
		public static const TAIL:String = "tail";
		
		public static const PARTS_NAMES:Vector.<String> = new Vector.<String>();
		PARTS_NAMES[0] = "head";
		PARTS_NAMES[1] = "body";
		PARTS_NAMES[2] = "r_hand";
		PARTS_NAMES[3] = "l_hand";
		PARTS_NAMES[4] = "tail";
			
		public static const DEFAULT_POSITION:Object = {
			"head"	: new Point(80, 0),
			"body"	: new Point(80, 130),
			"r_hand": new Point(170, 100),
			"l_hand"	: new Point(0, 100),
			"tail"	: new Point(80, 300)
		}
		
		// ボディ部のアタッチパーツ名一覧
		public static const BODY_ATTACH_PARTS:Object = {
			"head"	: true,
			"body"	: true,
			"r_hand"	: true,
			"l_hand"	: true,
			"tail"	: true
		}
			
		public function BodyConfiguration()
		{
		}
	}
}