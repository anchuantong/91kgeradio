package com.ywit.radio91.view
{
	import com.greensock.TweenLite;
	import com.ywit.radio91.constant.ViewRegister;
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.event.UserEvent;
	import com.ywit.radio91.util.BaseInteract;
	import com.ywit.radio91.util.ButtonUtil;
	import com.ywit.radio91.util.ViewHelper;
	
	import fl.managers.FocusManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.events.Request;

	/**
	 * 显示点击了用户信息的界面
	 * 主页部分写死这个链接:http://www.renren.com/profile.do?id=223282141 
	 * 其中id就是uid
	 */ 
	public class RoomUserInfoTip extends Sprite{
		public var ui_PlayerInfoTipView: UI_PlayerInfoTipView = new UI_PlayerInfoTipView(); 
		public var roomUserInfoCell:RoomUserInfoCell;
		
		public function RoomUserInfoTip(){
			ui_PlayerInfoTipView.but_privateChat.mouseChildren= false;
			ui_PlayerInfoTipView.but_privateChat.addEventListener(MouseEvent.CLICK,privateButHandel);
			ui_PlayerInfoTipView.btn_startListen.addEventListener(MouseEvent.CLICK,startListen,false,0,true);
			ui_PlayerInfoTipView.btn_openWebPage.addEventListener(MouseEvent.CLICK,openWebPageHandler,false,0,true);
			ui_PlayerInfoTipView.btn_sendGift.addEventListener(MouseEvent.CLICK,sendGiftHandler,false,0,true);
			
			ButtonUtil.changeButton(ui_PlayerInfoTipView.but_privateChat);
			ButtonUtil.changeButton(ui_PlayerInfoTipView.btn_startListen);
			ButtonUtil.changeButton(ui_PlayerInfoTipView.btn_openWebPage);
			ButtonUtil.changeButton(ui_PlayerInfoTipView.btn_sendGift);
			
			ui_PlayerInfoTipView.userInfoTipBg.alpha=0;
//			ui_PlayerInfoTipView.addChild(ui_PlayerInfoTipView.userInfoTipBg);
			this.addEventListener(MouseEvent.MOUSE_OUT,startUnShowTimer);
			this.addEventListener(MouseEvent.MOUSE_OVER,stopUnShowTimer);
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,unShow);
		}
		
		/**
		 * 点击收听的时候的处理方法
		 */ 
		public function privateButHandel(e:MouseEvent):void{
			roomUserInfoCell.setChatTarget();
			
			var roomView:RoomView = ViewHelper.getView(ViewRegister.ROOM_VIEW) as RoomView;
			if(roomView){
				roomView.focusInChat();
			}
		}
		
		/**
		 * 点击收听的时候的处理方法
		 */ 
		public function startListen(e:MouseEvent):void{
			BaseInteract.baseStartListen(roomUserInfoCell.object["uid"]);
			RoomView(ViewHelper.getView(ViewRegister.ROOM_VIEW)).focusInWatchSinger();
		}
		/**
		 * 点击打开个人主页的方法
		 */ 
		private function openWebPageHandler(e:MouseEvent):void{
			navigateToURL(new URLRequest("http://www.renren.com/profile.do?id=" + roomUserInfoCell.object["uid"]));
		}
		
		private function sendGiftHandler(e:MouseEvent):void{
			roomUserInfoCell.setPresentTarget();
		}
		
		
		public function show(roomUserInfoCell:RoomUserInfoCell):void {
			this.visible = true;
			this.isOver = false;
			this.addChild(ui_PlayerInfoTipView);
			ui_PlayerInfoTipView.text_uname.mouseEnabled = false;
			ui_PlayerInfoTipView.text_title.mouseEnabled = false;
			ui_PlayerInfoTipView.text_manifesto.mouseEnabled = false;
			ui_PlayerInfoTipView.loader_userInfoImg.mouseChildren = false;
			this.roomUserInfoCell = roomUserInfoCell;
			var roomUserInfo: mc_roomUserInfo;
			roomUserInfo = mc_roomUserInfo(roomUserInfoCell.roomUserInfo);
			roomUserInfo.gotoAndStop(2);
			var obj:Object = roomUserInfoCell.object;
			setLocation(mouseX,mouseY);
			ui_PlayerInfoTipView.loader_userInfoImg.source = obj["headimg"];
			ui_PlayerInfoTipView.text_uname.text = obj["uname"];
			ui_PlayerInfoTipView.text_title.text = obj["title"]+"("+obj["lv"]+")";
			if(obj["manifesto"]){
				ui_PlayerInfoTipView.text_manifesto.text = obj["manifesto"];
			}
			
			
			
			
			
			if( obj["uid"] == PlayerData.getInstance().playerObj["uid"]){
				ui_PlayerInfoTipView.btn_startListen.visible = false;
			}else{
				if(obj["status"] == 0){
					ui_PlayerInfoTipView.btn_startListen.visible = true;
				}else if(obj["status"] == 1){
					ui_PlayerInfoTipView.btn_startListen.visible = false;
				}
			}
			
			
//			startUnShowTimer();
			timer.stop();
		}
		
		public function startUnShowTimer(e:Event=null):void{
//			if(isOver){
//				timer.stop();
//				unShow();
//				return;
//			}
			timer.reset();
			timer.start();
			trace("start");
		}
		private var timer:Timer = new Timer(500,1);
		private var isOver:Boolean = false;
		private function stopUnShowTimer(e:Event):void{
			timer.stop();
			trace("stop");
			isOver = true;
		}
		public function unShow(e:Event=null):void{
			this.visible = false;
		}
		public var roomUserInfoTipBaseY:int = 390;
		public var cellUserInfoHight:int = 30;
		public function setLocation(mouseX:int,mouseY:int):void{
			ui_PlayerInfoTipView.x = 270;
//			ui_PlayerInfoTipView.y = roomUserInfoTipBaseY+cellUserInfoHight*int((mouseY-407)/this.cellUserInfoHight);
			var gPoint:Point = roomUserInfoCell.parent.localToGlobal(new Point(roomUserInfoCell.x,roomUserInfoCell.y));
			var lPoint:Point = ui_PlayerInfoTipView.parent.globalToLocal(gPoint);
//			ui_PlayerInfoTipView.parent.globalToLocal(roomUserInfoCell.localToGlobal(new Point(roomUserInfoCell.x,roomUserInfoCell.y));
//			ui_PlayerInfoTipView.y = roomUserInfoCell.y+roomUserInfoCell.parent.parent.parent.y-15;
			ui_PlayerInfoTipView.y = lPoint.y - 15;
		}
	}
}