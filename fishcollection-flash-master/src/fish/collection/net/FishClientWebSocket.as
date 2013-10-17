package fish.collection.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	public class FishClientWebSocket
	{
		private var _websocket:WebSocket;
		private var _handler:WebSocketHandler;
		
		private var pings:Object = {};
		
		private var dumbIncrementValue:int = 0;
		
		public function FishClientWebSocket(handler:WebSocketHandler)
		{
			_handler = handler;
		}
		
		/**
		 * 通信開始 
		 * @param url
		 * @param origin
		 */
		public function open():void
		{
			if (_websocket != null)
			{
				_websocket.close();
			}
			_websocket = new WebSocket("ws://localhost:8888", "*", "lws-mirror-protocol", 5000);
			_websocket.debug = true;
			_websocket.connect();
			_websocket.addEventListener(WebSocketEvent.CLOSED, handleWebSocketClosed);
			_websocket.addEventListener(WebSocketEvent.OPEN, handleWebSocketOpen);
			_websocket.addEventListener(WebSocketEvent.MESSAGE, handleWebSocketMessage);
			_websocket.addEventListener(WebSocketEvent.PONG, handlePong);
			_websocket.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_websocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			_websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail);
		}
		
		private function handleWebSocketClosed(event:WebSocketEvent):void {
			WebSocket.logger("Websocket closed.");
		}
		
		private function handleWebSocketOpen(event:WebSocketEvent):void {
			WebSocket.logger("Websocket Connected");
		}
		
		private function handleWebSocketMessage(event:WebSocketEvent):void {
			if (event.message.type === WebSocketMessage.TYPE_UTF8) {
				if (_websocket.protocol === 'lws-mirror-protocol') {
					var commands:Array = event.message.utf8Data.split(';');
					for each (var command:String in commands) {
						if (command.length < 1) { continue; }
						var fields:Array = command.split(' ');
						var commandName:String = fields[0];
						if (commandName === 'c' || commandName === 'd') {
							var color:uint = parseInt(String(fields[1]).slice(1), 16);
							var startX:int = parseInt(fields[2], 10);
							var startY:int = parseInt(fields[3], 10);
							//drawCanvas.graphics.lineStyle(1, color, 1, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
							if (commandName === 'c') {
								// c #7A9237 487 181 14;
								var radius:int = parseInt(fields[4], 10);
								//drawCanvas.graphics.drawCircle(startX, startY, radius);
							}
							else if (commandName === 'd') {
								var endX:int = parseInt(fields[4], 10);
								var endY:int = parseInt(fields[5], 10);
								//drawCanvas.graphics.moveTo(startX, startY);
								//drawCanvas.graphics.lineTo(endX, endY);
							}
							
						}
						else if (commandName === 'clear') {
							//drawCanvas.graphics.clear();
						}
						else {
							WebSocket.logger("Unknown Command: '" + fields.join(' ') + "'");
						}
					}
				}
				else if (_websocket.protocol === 'dumb-increment-protocol') {
					dumbIncrementValue = parseInt(event.message.utf8Data, 10);
				}
				else {
					WebSocket.logger(event.message.utf8Data);
				}
			}
			else if (event.message.type === WebSocketMessage.TYPE_BINARY) {
				WebSocket.logger("Binary message received.  Length: " + event.message.binaryData.length);
			}
		}
		
		private function handlePong(event:WebSocketEvent):void {
			if (event.frame.length === 4) {
				var id:uint = event.frame.binaryPayload.readUnsignedInt();
				var startTime:Date = pings[id];
				if (startTime) {
					var latency:uint = (new Date()).valueOf() - startTime.valueOf();
					WebSocket.logger("Ping latency " + latency + " ms");
					delete pings[id];
				}
			}
			else {
				WebSocket.logger("Unsolicited pong received");
			}
		}
		
		private function handleIOError(event:IOErrorEvent):void {
			log();
		}
		
		private function handleSecurityError(event:SecurityErrorEvent):void {
			
		}
		
		private function handleConnectionFail(event:WebSocketErrorEvent):void {
			WebSocket.logger("Connection Failure: " + event.text);
		}
		
		public function get isOpen():Boolean
		{
			//			return _websocket != null && _websocket.isOpen;
			return _websocket != null;
		}
		
		//		public function get isOpening():Boolean
		//		{
		//			return _websocket != null && _websocket.isOpening;
		//		}
		//		
		//		public function get isWaiting():Boolean
		//		{
		//			return _websocket != null && _websocket.isWaiting;
		//		}
		//		
		public function send(message:String):void
		{
			_websocket.sendUTF(message);
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
	}
}