/**
 * 一个房间的显示对象,包含人满的判断等*/
package com.ywit.radio91.view
{
	import flash.display.Sprite;

	public class HallRoomCellView extends Sprite {
		public var ui_MovieClip_Room:UI_MovieClip_Room = new UI_MovieClip_Room();
		public var _obj:Object;
		public function setRoomObject(roomObj:Object):void{
			if(!roomObj){
				return ;
			}
			this._obj = roomObj;
			
			ui_MovieClip_Room.mouseChildren = false;
			ui_MovieClip_Room.mouseEnabled = false;
			
			var roomId:String = String(roomObj.roomId);
			if(roomObj.roomId < 10){
				roomId = "00"+roomObj.roomId;
			}else if(roomObj.roomId < 99){
				roomId = "0"+roomObj.roomId;
			}
			
			ui_MovieClip_Room.text_roomId.text = roomId;
			ui_MovieClip_Room.text_roomName.text = (roomObj.roomName==null?"":roomObj.roomName);
			ui_MovieClip_Room.text_userInfo.text = roomObj.currentUser+"/"+roomObj.maxUser;
			ui_MovieClip_Room.text_Singer.text = roomObj.currentSinger+"/"+roomObj.currentUser;
			
			ui_MovieClip_Room.roomSelect_Bg.stop();
			ui_MovieClip_Room.movie_font.gotoAndStop(1);//可加入
			ui_MovieClip_Room.movie_roomMark.gotoAndStop(1);
			if(int(roomObj.currentUser)>=int(roomObj.maxUser)){
				ui_MovieClip_Room.movie_font.gotoAndStop(2);//满员
				ui_MovieClip_Room.movie_roomMark.gotoAndStop(2);
			}
			
		}
		public function HallRoomCellView() {
			addChild(ui_MovieClip_Room);
		}
	}
}