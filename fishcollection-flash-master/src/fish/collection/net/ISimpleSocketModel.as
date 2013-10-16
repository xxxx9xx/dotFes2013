package fish.collection.net
{
	/**
	 *	
	 *	@author atsumo
	 *	@since 2013/06/20
	 */
	public interface ISimpleSocketModel
	{
		//データがupdateされたらそのStringを受け取るためのメソッド
		function updateMessage(message:String):void;
		
		function destroy():void;
	}
}