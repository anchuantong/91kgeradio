/**
 * 
 * 房间界面右下角用户列表中显示的单元对象*/
package com.ywit.radio91.view
{
	import com.ywit.radio91.constant.ViewRegister;
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.event.UserEvent;
	import com.ywit.radio91.util.ViewHelper;
	
	import flash.display.Sprite;

	public class RoomUserInfoCell extends Sprite{
		public var roomUserInfo: mc_roomUserInfo = new mc_roomUserInfo(); 
		public var object:Object;
		public function RoomUserInfoCell(object:Object) {
			if(object.micStatus == 1){
				roomUserInfo.userStuats.gotoAndStop(2);
			}else{
				roomUserInfo.userStuats.gotoAndStop(1);
			}
			roomUserInfo.userStuats.width = 15;
			roomUserInfo.userStuats.height = 15;
			
			this.object = object;
			if(object.status == "0"){
				roomUserInfo.singInfo.text = object.uname+"--"+object.songsName;
			}else{
				roomUserInfo.singInfo.text = object.uname;
			}
			roomUserInfo.loader_userImg.source = object.headimg;
			roomUserInfo.stop();
			roomUserInfo.roomUserInfoBg.visible = false;
			this.addChild(roomUserInfo);
		}
		
		public function setPresentTarget():void{
			var userEvent:UserEvent = new UserEvent(UserEvent.USER_SELECT_PRESENT);
			userEvent.uid = object["uid"];
			userEvent.uName = object["uname"];
			PlayerData.getInstance().dispatchEvent(userEvent);
		}
		
		public function setChatTarget():void{
			var userEvent:UserEvent = new UserEvent(UserEvent.USER_SELECT_CHAT);
			userEvent.uid = object["uid"];
			userEvent.uName = object["uname"];
			userEvent.isSelected = true;
			PlayerData.getInstance().dispatchEvent(userEvent);

			
		}
	}
}