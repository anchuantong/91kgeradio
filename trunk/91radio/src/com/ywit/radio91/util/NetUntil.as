package com.ywit.radio91.util
{
	import com.serialization.json.JSON;
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.event.CommonEvent;
	import com.ywit.radio91.gen.data.AbsPlayerData;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;

	public class NetUntil extends EventDispatcher
	{
		
		public var  socket:XMLSocket=new XMLSocket();
		public static const NAME:String = "NetUntil";
		private static var _instance:NetUntil ;
		//jsonSessionId,每次都是通过网页动态获取的
		public  var jsonSessionId:String;
		public static function getInstance():NetUntil{
			if(_instance == null){
				_instance = new NetUntil();
			}
			return _instance;
		}
		public function NetUntil() {
//			if(facade.hasProxy(NAME)){
//				facade.registerProxy(this);
//			}
//			
//			
//			
			configureListeners(socket);
			
		}
		private var isNeedReConnet:Boolean = false;
		private var _host:String;
		private var _port:int;
		public function connect(host:String,port:int):void{
//			socket.connect(UModelLocal.getInstance().xmlSocket,UModelLocal.getInstance().xmlSocketPost);
			_host = host;
			_port = port;
			isNeedReConnet = true;
			connectHandel();
		}
		private function connectHandel():void{
			socket.connect(_host,_port);
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CLOSE, closeHandler);
			dispatcher.addEventListener(Event.CONNECT, connectHandler);
			dispatcher.addEventListener(DataEvent.DATA, dataHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
			var commEvent:CommonEvent = new CommonEvent(AbsPlayerData.EVENT_PUSH_pushErrorConnection,true,false);
			dispatchEvent(commEvent);
		}
		
		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
			dispatchEvent(event);
			isNeedReConnet = true;
		}
		
		private function dataHandler(event:DataEvent):void {
			trace("datahandler:"+event.text);
			if(event.text==""){
				return;
			}
			var data:Object = JSON.deserialize(event.text);
			trace("method: " + data["method"]);
			PlayerData.getInstance()[data["method"]](data["result"]);
		}
		private var connetCount:int = 3;
		private function ioErrorHandler(event:IOErrorEvent):void {
			connetCount--;
			trace("ioErrorHandler: " + event);
			if(isNeedReConnet&&connetCount>=0){
				trace("连接失败,尝试第二次连接!");
				connectHandel();
				return;
			}
			var commEvent:CommonEvent = new CommonEvent(AbsPlayerData.EVENT_PUSH_pushErrorConnection,true,false);
			dispatchEvent(commEvent);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
			var commEvent:CommonEvent = new CommonEvent(AbsPlayerData.EVENT_PUSH_pushErrorConnection,true,false);
			dispatchEvent(commEvent);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
			var commEvent:CommonEvent = new CommonEvent(AbsPlayerData.EVENT_PUSH_pushErrorConnection,true,false);
			dispatchEvent(commEvent);
		}
		
		public function send(data:String):void {
			socket.send(data);
		}
		
		public function listRoom(data:Object):void{
			trace("listRoom:"+data);
		}
		
	}
	
				
}