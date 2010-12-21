package com.ywit.radio91.event
{
	import flash.events.Event;
	/**
	 * 操作歌曲的事件
	 * 分别两个动作，听和接收
	 */ 
	public class EnterRoomEvent extends Event
	{
		public static var ENTER_ROOM:String = "EnterRoom";
		
		public var roomId:int;
		public var roomName:String;
		
		public function EnterRoomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}