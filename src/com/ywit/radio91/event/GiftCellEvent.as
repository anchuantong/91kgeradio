/**
 * 用在礼物列表中的事件*/
package com.ywit.radio91.event
{
	import flash.events.Event;

	public class GiftCellEvent extends Event {
		public var data:Object;
		public static const GIFT_MOUSE_CLICK:String = "GiftMouseClick";
		public static const GIFT_MOUSE_OVER:String = "GiftOverClick";
		public static const GIFT_MOUSE_OUT:String = "GiftOutClick";
		public function GiftCellEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}