package fish.collection.net
{
	/**
	 * VisionClient を経由してサーバーから送信されるデータを
	 * 受け取ったときのコールバック処理を定義するデリゲートクラスです。
	 */
	public interface IFishClientDelegate
	{
		/**
		 * このクラスのデリゲートメソッドのプリフィクス文字列を取得します。
		 * プリフィクス文字列は、サーバーからのメソッドコールの前方部分に
		 * 一致する必要があります。
		 * 例) user, area, item ...
		 */
		function get name():String;
	}
}