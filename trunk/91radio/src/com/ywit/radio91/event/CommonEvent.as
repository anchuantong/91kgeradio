package com.ywit.radio91.event
{
	import flash.events.Event;
	
	/**
	 * 类说明：一个携带数据的高度抽象的事件
	 * 只携带数据和事件类型
	 * @time 2010-11-26 下午02:17:38
	 * @author keynes
	 */
	public class CommonEvent extends Event
	{
		public var data:Object;
		public function CommonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}