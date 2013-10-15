package fish.collection.net
{
	import flash.utils.ByteArray;

	public interface WebSocketHandler
	{
		/**
		 * ソケットオープン時
		 */
		function onOpen():void;
		
		/**
		 * ソケットクローズ時
		 */
		function onClose():void;
		
		/**
		 * メッセージ受信時
		 */
		function onMessage(data:String):void;
		
		/**
		 * バイナリデータ受信時
		 */
		function onData(frame:int, data:ByteArray):void;
		
		/**
		 * 通信エラー発生時
		 */
		function onSocketError(e:Error):void;
		
		/**
		 * ハンドラ系エラー発生時
		 */
		function onHandleError(e:Error):void;
	}
}