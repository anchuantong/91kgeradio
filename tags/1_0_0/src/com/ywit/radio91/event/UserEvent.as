/**
 * 用在房间界面右下角的用户列表事件*/
package com.ywit.radio91.event
{
	import flash.events.Event;
	
	import ghostcat.display.transfer.BookTransfer;

	public class UserEvent extends Event {
		public var uid:int;
		public var uName:String;
		public var isSelected:Boolean = false;
		//选择用户发送礼物
		public static const USER_SELECT_PRESENT:String = "USER_SELECT_PRESENT";
		//选择用户聊天
		public static const USER_SELECT_CHAT:String = "USER_SELECT_CHAT";
		public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}