package fish.collection.game.util
{
	public class Util
	{
		public function Util()
		{
		}
		
		
		/**
		 * スムースムーブ関数
		 * @param changeVal 変更した値
		 * @param zoomVal 目標値
		 * @param smoothVal スムースの変化度合い
		 * @return 変化後の値
		 */
		public static function smoothMoveFunc(changeVal:Number, zoomVal:Number, smoothVal:Number):Number
		{
			var resultVal:Number = 0;
			var margin:Number = zoomVal - changeVal;
			if(Math.abs(margin) < 1.0) {
				resultVal = zoomVal;
			} else {
				resultVal = changeVal + margin * smoothVal;
			}
			return resultVal;
		}
		
	}
}