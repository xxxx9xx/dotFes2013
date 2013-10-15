package fish.collection.net
{
	import flash.events.Event;
	import fish.collection.net.event.WebSocketErrorEvent;
	import fish.collection.net.event.WebSocketEvent;

	/**
	 * WebSocketのhelperクラス
	 * @author A12697
	 */
	public class FishClientWebSocket
	{
		private var _websocket:WebSocket;
		private var _handler:WebSocketHandler;
		
		public function FishClientWebSocket(handler:WebSocketHandler)
		{
			_handler = handler;
		}
		
		/**
		 * 通信開始 
		 * @param url
		 * @param origin
		 */
		public function open(url:String, origin:String):void
		{
			log(url, origin);
			if (_websocket != null)
			{
				_websocket.close();
			}
			_websocket = new WebSocket();
			_websocket.addEventListener(Event.OPEN, handleOpen);
			_websocket.addEventListener(Event.CLOSE, handleClose);
			_websocket.addEventListener(WebSocketEvent.MESSAGE, handleMessage);
			_websocket.addEventListener(WebSocketErrorEvent.ERROR, handleError);
			_websocket.open(url, origin);
		}
		
		public function get isOpen():Boolean
		{
			return _websocket != null && _websocket.isOpen;
		}
		
		public function get isOpening():Boolean
		{
			return _websocket != null && _websocket.isOpening;
		}
		
		public function get isWaiting():Boolean
		{
			return _websocket != null && _websocket.isWaiting;
		}
		
		public function send(message:String):void
		{
			_websocket.send(message);
		}
		
		public function close():void
		{
			_websocket.close();
		}
		
		private function handleOpen(e:Event):void
		{
			if (_handler !== null)
			{
				_handler.onOpen();
			}
		}
		
		private function handleClose(e:Event):void
		{
			if (_handler !== null)
			{
				_handler.onClose();
			}
		}
		
		private function handleMessage(e:WebSocketEvent):void
		{
			if (_handler !== null)
			{
				_handler.onMessage(e.data);
			}
		}
		
		private function handleError(e:WebSocketErrorEvent):void
		{
			if (_handler !== null)
			{
				_handler.onSocketError(new Error(e.error));
			}
		}
	}
}