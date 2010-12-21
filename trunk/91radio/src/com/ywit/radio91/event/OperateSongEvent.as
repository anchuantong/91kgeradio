package com.ywit.radio91.event
{
	import flash.events.Event;
	/**
	 * 操作歌曲的事件
	 * 分别两个动作，听和接收
	 */ 
	public class OperateSongEvent extends Event
	{
		public static var EVENT_SING:String = "EVENT_SING";
		public static var EVENT_LISTEN:String = "EVENT_LISTEN";
		
		public var songId:int;
		public var songName:String;
		//歌者id
		public var uid:int;
		
		public function OperateSongEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}