/**
 * WebSocket ActionScript Client 1.0 by Alexey Y. Bondar. January 31, 2010
 * http://github.com/y8/websocket-as
 * @author Alexey Y. Bondar (y8 at ya dot ru), 2010.
 * @see LICENSE http://github.com/y8/websocket-as/raw/master/LICENSE
 */

package fish.collection.net
{
	import com.adobe.net.URI;
	import com.adobe.net.URIEncodingBitmap;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import fish.collection.net.event.WebSocketErrorEvent;
	import fish.collection.net.event.WebSocketEvent;
	
	[Event(name="open", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="error", type="pigglife.net.event.WebSocketErrorEvent")]
	[Event(name="message", type="pigglife.net.event.WebSocketEvent")]
	/**
	 * WebSocket class
	 *
	 * @author                    y8
	 * @version                   1.0
	 * @playerversion             Flash 9
	 */
	public class WebSocket extends EventDispatcher{
		
		/**
		 * 
		 */
		private static var OPENING:String = "opening";
		
		/**
		 * @private
		 */
		private static var WAIT:String = "waiting";
		
		/**
		 * @private
		 */
		private static var PROCESS:String = "processing";
		
		/**
		 * @private
		 */
		private static var CLOSE:String = "closing";
		
		/**
		 * @private
		 */
		private var socket:Socket;
		
		/**
		 * @private
		 */
		private var headers_buffer:String;
		
		/**
		 * @private
		 */
		private var state:String = WAIT;
		
		/**
		 * @private
		 */
		private var uri:URI;
		
		/**
		 * @private
		 */
		private var location:String;
		
		/**
		 * @private
		 */
		private var origin:String;
		
		/**
		 * @private
		 */
		private var path:String;
		
		/**
		 * @private
		 */
		private var host:String;
		
		/**
		 * @private
		 */
		private var port:Number;
		
		/**
		 * @private
		 */
		private var reading:Boolean = false;
		
		/**
		 * @private
		 */
		private var frame:ByteArray;
		
		/**
		 * タイムアウト時ID
		 */
		private var _timeoutId:uint;
		
		/**
		 * Creates a new WebSocket object.
		 */
		public function WebSocket() {
			this.headers_buffer = '';
			this.reading = false;
			this.state = OPENING;
			this.frame = new ByteArray();
			this.socket = new Socket();
			this.socket.addEventListener(Event.CONNECT, onConnect);
			this.socket.addEventListener(Event.CLOSE, onClose);
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			this.socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		/**
		 * WebSocket のステートを取得
		 */
		public function getState():String
		{
			return this.state;
		}
		
		/**
		 * WebSocket のオープン状態を取得
		 */
		public function get isOpen():Boolean
		{
			return this.state === PROCESS;
		}
		
		/**
		 * WebSocket が接続中であるかを取得
		 */
		public function get isOpening():Boolean
		{
			return this.state === OPENING;
		}
		
		/**
		 * WebSocket がヘッダ待機中であるか取得
		 */
		public function get isWaiting():Boolean
		{
			return this.state == WAIT;
		}
		
		/**
		 * Opens WebSocket connection to given uri.
		 *
		 * @param uri:String — WebSocket URI pointing to server, only "ws" scheme supported.
		 * @param origin:String — WebSocket request origin. Set to URI of source page, where this class used.
		 *
		 * @event open:Event  — Dispatched after handshake complete.
		 * @event close:Event — Dispatched when WebSocket connection closed.
		 * @event error:WebSocketErrorEvent — Dispatched on WebSocket error
		 * @event message:WebSocketEvent — Dispatched websocket dataframe recivied.
		 */
		public function open(uri:String, origin:String):void {
			
			this.uri = new URI(uri);
			
			//Check for scheme. Secure not supported.
			if(this.uri.scheme.toLowerCase() != "ws") {
				dispatchError("Wrong url scheme for WebSocket: " + this.uri.scheme);
			}

			//Uri fragment not permited.
			if(this.uri.fragment) {
				dispatchError("URL has fragment component: " + uri);
			}
			
//			//Setting connection varibles.
			this.host = this.uri.authority;
			this.port = 80; //80 is default port
			this.origin = origin;
			this.path = this.uri.path || '/';        // '/' is default path
//			
//			//Saving uri for future handshake validations
			this.location = uri;
			
			//Force policy file loading.
			// Security.loadPolicyFile("http://" + this.host + ":" + this.port + "/crossdomain.xml");
			
			parseUrl();
			
			//Open socket connection
			this.socket.connect(this.host, this.port);
			
			_timeoutId = setTimeout(onTimeout, 5000);
		}
		
		/**
		 * Closes WebSocket connection.
		 */
		public function close():void {
			this.state = CLOSE;
			resetTimeout();
			try {
				this.socket.close();
			} catch(error:Error) {
				dispatchError(error.message);
			}
			this.socket.removeEventListener(Event.CONNECT, onConnect);
			this.socket.removeEventListener(Event.CLOSE, onClose);
			this.socket.removeEventListener(ProgressEvent.SOCKET_DATA, onData);
			this.socket.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		/**
		 * Sends data to server
		 *
		 * @param data:String — data to send
		 */
		public function send(data:String):void {
			if(this.state == PROCESS) {
				this.socket.writeByte(0x00);
				this.socket.writeUTFBytes(data);
				this.socket.writeByte(0xFF);
				this.socket.flush();
			} else {
				super.dispatchEvent(new WebSocketErrorEvent(WebSocketErrorEvent.ERROR, false, false, "WebSocket not ready."));
			}
		}
		
		private function parseUrl():void {
			this.host = this.uri.authority;
			this.port = 80;
			
			var tempPort:uint = parseInt(this.uri.port, 10);
			if (!isNaN(tempPort) && tempPort !== 0) {
				this.port = tempPort;
			}
			var path:String = URI.fastEscapeChars(this.uri.path, new URIEncodingBitmap(URI.URIpathEscape));
			if (path.length === 0) {
				path = "/";
			}
			var query:String = this.uri.queryRaw;
			if (query.length > 0) {
				query = "?" + query;
			}
		}
		
		/**
		 * @private
		 */
		private function onConnect(event:Event):void {
			this.state = WAIT;
			this.socket.writeUTFBytes(this.handshake());
			
			log(this.handshake());
		}
		
		/**
		 * @private
		 */
		private function onClose(event:Event):void {
			log();
			resetTimeout();
			this.state = CLOSE;
			super.dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * @private
		 */
		private function onData(event:ProgressEvent):void {
			//Data recived, dispatching
			switch(this.state) {
				case WAIT:
					//Bufferizing data
					this.headers_buffer = this.headers_buffer + socket.readUTFBytes(event.bytesLoaded);
					//Waiting for HTTP headers.
					waitHeaders();
					break;
				case PROCESS:
					//Processing data-frame
					processData();
					break;
				case CLOSE:
					//Do nothing
					break;
				default:
					throw("WebSocket in unknown state:" + state);
			}
		}
		
		/**
		 * 
		 */
		private function onTimeout():void
		{
			log();
			_timeoutId = 0;
			super.dispatchEvent(new WebSocketErrorEvent(WebSocketErrorEvent.ERROR, false, false, 'Timeout'));
		}
		
		/**
		 * @private
		 */
		private function onSecurityError(event:SecurityErrorEvent):void {
			log();
			resetTimeout();
			super.dispatchEvent(new WebSocketErrorEvent(WebSocketErrorEvent.ERROR, false, false, event.text));
		}
		
		/**
		 * @private
		 */
		private function onError(event:IOErrorEvent):void {
			log(event);
			resetTimeout();
			super.dispatchEvent(new WebSocketErrorEvent(WebSocketErrorEvent.ERROR, false, false, event.text));
		}
		
		/**
		 * @private
		 */
		private function waitHeaders():void {
			if(this.headers_buffer.indexOf("\r\n\r\n") >= 0) {
				//Getting heders
				var request:Array = this.headers_buffer.split("\r\n\r\n")[0].split("\r\n");
				this.headers_buffer = null;
				
				//Getggin response status line
				var status:String = request.shift();
				
				//Cheking response status
				if(status != "HTTP/1.1 101 Web Socket Protocol Handshake") {
					dispatchError("Wrong WebSocket handshake respons status: " + status);
					try { this.socket.close(); } catch(error:Error) {};
				}
				
				//Parsing headers
				var headers:Object = parseHeaders(request);
				
				//Checking websocket-origin to match origin
//				if(headers['websocket-origin'].toLowerCase() != this.origin.toLowerCase()) {
//					dispatchError("Websocket-Origin mismatch. Expected: " + this.origin + ", got: " + headers['websocket-origin']);
//					try { this.socket.close(); } catch(error:Error) {};
//				}
				
				//Checking websocket-location to match location
//				if(headers['websocket-location'] != this.location) {
//					dispatchError("WebSocket-Location mismatch. Expected: " + this.location + ", got: " + headers['websocket-location']);
//					try { this.socket.close(); } catch(error:Error) {};
//				}
				
				//Connection established.
				this.state = PROCESS;
				super.dispatchEvent(new Event(Event.OPEN));
				resetTimeout();
			}
		}
		
		/**
		 * @private
		 */
		private function parseHeaders(request:Array):Object {
			var headers:Object = new Object();
			for each (var line:String in request) {
				var header:Array = line.split(/:\s+/);
				headers[header[0].toLowerCase()] = header[1];
			}
			return headers;
		}
		
		/**
		 * @private
		 */
		private function handshake():String {
//			var handshake:Array = new Array();
//			
//			handshake.push("GET " + this.path + " HTTP/1.1");
//			handshake.push("Upgrade: WebSocket");
//			handshake.push("Connection: Upgrade");
//			if (this.port == 80) {
//				handshake.push("Host: " + this.host);
//			} else {
//				handshake.push("Host: " + this.host + ":" + this.port);
//			}
//			handshake.push("Origin: " + this.origin);
//			handshake.push("\r\n");
//			
//			return handshake.join("\r\n");
			
			var text:String = "";
			text += "GET " + '/' + " HTTP/1.1\r\n";
			text += "Host: " + this.host + "\r\n";
			text += "Upgrade: websocket\r\n";
			text += "Connection: Upgrade\r\n";
			text += "Sec-WebSocket-Key: " + null + "\r\n";
			if (this.origin) {
				text += "Origin: " + this.origin + "\r\n";
			}
			text += "Sec-WebSocket-Version: 13\r\n";
//			if (_protocols) {
//				var protosList:String = _protocols.join(", ");
//				text += "Sec-WebSocket-Protocol: " + protosList + "\r\n";
//			}
			// TODO: Handle Extensions
			text += "\r\n";
			
			return text;
		}
		
		/**
		 * @private
		 */
		private function processData():void {
			if (!this.socket.connected)
			{
				if (this.state != CLOSE)
				{
					close();
				}
				return;
			}
			while (this.socket.connected && this.socket.bytesAvailable) {
				var byte:uint = this.socket.readUnsignedByte();
				
				if(byte == 0x00) {
					if(this.reading) {
						dispatchError("Unexpected data frame begin mark while reading");
						try { close(); return; } catch(error:Error) {};
					}
					this.frame.length = 0;
					this.reading = true;
				} else if (byte == 0xFF) {
					if(!this.reading) {
						dispatchError("Data frame must strart with begin mark, but got end mark");
						try { close(); return; } catch(error:Error) {};
					}
					this.frame.position = 0;
					super.dispatchEvent(new WebSocketEvent(WebSocketEvent.MESSAGE, false, false, this.frame.readUTFBytes(frame.length)));
					this.reading = false;
				} else {
					if(reading) {
						this.frame.writeByte(byte);
					} else {
						dispatchError("Data frame must starts with begin mark.");
						try { close(); return; } catch(error:Error) {};
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchError(text:String):void {
			super.dispatchEvent(new WebSocketErrorEvent(WebSocketErrorEvent.ERROR, false, false, text));
		}
		
		/**
		 * @private
		 */
		private function destroy():void {
			this.socket.removeEventListener(Event.CONNECT, onConnect);
			this.socket.removeEventListener(Event.CLOSE, onClose);
			this.socket.removeEventListener(ProgressEvent.SOCKET_DATA, onData);
			
			this.socket.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			this.socket = null;
		}
		
		/**
		 * タイムアウト処理のクリアを行います。
		 */
		private function resetTimeout():void
		{
			log();
			if (_timeoutId > 0) {
				clearTimeout(_timeoutId);
				_timeoutId = 0;
			}
		}
		
	}
}