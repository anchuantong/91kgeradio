package com.ywit.radio91.view
{
	import com.ywit.radio91.center.UModelLocal;
	import com.ywit.radio91.component.Button;
	import com.ywit.radio91.component.MyTileList;
	import com.ywit.radio91.constant.ViewRegister;
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.event.CommonEvent;
	import com.ywit.radio91.event.EnterRoomEvent;
	import com.ywit.radio91.gen.data.AbsPlayerData;
	import com.ywit.radio91.util.BaseInteract;
	import com.ywit.radio91.util.ButtonUtil;
	import com.ywit.radio91.util.HashMap;
	import com.ywit.radio91.util.RegExpTool;
	import com.ywit.radio91.util.SwfDataLoader;
	import com.ywit.radio91.util.ViewHelper;
	
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class HallView extends AbsView
	{
		public var ui_MovieClip_Hall:UI_MovieClip_Hall = new UI_MovieClip_Hall();
		private var _playerData:PlayerData =PlayerData.getInstance();
		private var roomViewMap:HashMap = new HashMap();//当前的房间view
		public var ui_BroadCastContextView:UI_BroadCastContextView = new UI_BroadCastContextView();
		public var ui_RoomCreate:UI_RoomCreate = new UI_RoomCreate();
		//当前频道得到房间列表的数组数据
		private var _curRoomItemList:Array;//房间列表的缓存
		
		
		private var _listRoomResOb:Object;//服务器返回中的数据
		private var curPage:int;//当前页面
		private var pcount:int;//总页面
		
		private var broadCastMessageArray:Array = new Array();
		private var time:Timer = new Timer(30000);//广播显示的时间,下面一行显示持续15秒,上面一行持续15秒,共30 秒
//		private var time:Timer = new Timer(3000);//广播显示的时间,下面一行显示持续15秒,上面一行持续15秒,共30 秒
		private var _uid:int = UModelLocal.getInstance().uid;//UID
		
		private var _curRoomId:int;//当前请求的roomId；
		
		
		
		private var userInfoTextOut:MyUserInfoTextOut = new MyUserInfoTextOut(205,181);
		
		public function HallView() {
			super();
			loadData();
		}
		override protected function initView():void{
//			initGifts();
			new SwfDataLoader();
			
			initBroadCastContext();
			initCreateRoomView();
			addChild(ui_MovieClip_Hall);
						
			ui_BroadCastContextView.x = Main.KG_WIDTH/2-ui_BroadCastContextView.width/2;
			ui_BroadCastContextView.y = Main.KG_HEIGHT/2-ui_BroadCastContextView.height*3/2;
			
			ui_RoomCreate.x = Main.KG_WIDTH/2-ui_RoomCreate.width/2;
			ui_RoomCreate.y = Main.KG_HEIGHT/2-ui_RoomCreate.height*3/2;
			
			ui_MovieClip_Hall.tab_bar_channel.zdypd.gotoAndStop(3);
			ui_MovieClip_Hall.tab_bar_channel.wdpd.gotoAndStop(3);
			
			userInfoTextOut.x = 2;
			userInfoTextOut.y = 23;
			
			ui_MovieClip_Hall.allPlayerInfo.addChild(userInfoTextOut);
			
			
			ButtonUtil.changeButton(ui_MovieClip_Hall.friendList.button_prePage);
			ButtonUtil.changeButton(ui_MovieClip_Hall.friendList.button_nextPage);
			ui_MovieClip_Hall.tab_bar_channel.gfpd.buttonMode = true;

			
			_tileList_roomList._columnWidth=255;
			_tileList_roomList.width = 534;
			_tileList_roomList.height = 403;
			_tileList_roomList._rowHeight =95
			_tileList_roomList.x = 8;
			_tileList_roomList.y = 86;
			_tileList_roomList._columnCount =2;
//			_tileList_roomList.setStyle("disabledSkin",UI_RoomViewBG);
			_tileList_roomList.setStyle("upSkin",UI_RoomViewBG);
			_tileList_roomList.setStyle("contentPadding",2);
			_tileList_roomList.verticalScrollPolicy = "on";
			_tileList_roomList.horizontalScrollPolicy = "off";
			
			ui_MovieClip_Hall.addChild(_tileList_roomList);
		}
		
		
		//礼物初始化
		private function initGifts():void{
//			var _giftsMap:HashMap = new HashMap();
//			//初始化表情
//			_giftsMap.put("ZhuanJie",{name:"ZhuanJie",src:ZhuanJie,index:null});
//			_giftsMap.put("YuanBao",{name:"YuanBao",src:YuanBao,index:null});
//			_giftsMap.put("YiJianChuanXin",{name:"YiJianChuanXin",src:YiJianChuanXin,index:null});
//			_giftsMap.put("XueJia",{name:"XueJia",src:XueJia,index:null});
//			_giftsMap.put("XiangLian",{name:"XiangLian",src:XiangLian,index:null});
//			_giftsMap.put("XiangWen",{name:"XiangWen",src:XiangWen,index:null});
//			_giftsMap.put("XiangShui",{name:"XiangShui",src:XiangShui,index:null});
//			_giftsMap.put("ShuiGuo",{name:"ShuiGuo",src:ShuiGuo,index:null});
//			_giftsMap.put("ShouBiao",{name:"ShouBiao",src:ShouBiao,index:null});
//			_giftsMap.put("QiaoKeLi",{name:"QiaoKeLi",src:QiaoKeLi,index:null});
//			_giftsMap.put("QianBao",{name:"QianBao",src:QianBao,index:null});
//			_giftsMap.put("PiJiu",{name:"PiJiu",src:PiJiu,index:null});
//			_giftsMap.put("MeiGui",{name:"MeiGui",src:MeiGui,index:null});
//			_giftsMap.put("LiWu",{name:"LiWu",src:LiWu,index:null});
//			_giftsMap.put("KaFei",{name:"KaFei",src:KaFei,index:null});
//			_giftsMap.put("HuaSu",{name:"HuaSu",src:HuaSu,index:null});
//			_giftsMap.put("HongXin2",{name:"HongXin2",src:HongXin2,index:null});
//			_giftsMap.put("HongXin",{name:"HongXin",src:HongXin,index:null});
//			_giftsMap.put("DianGeWaWa",{name:"DianGeWaWa",src:DianGeWaWa,index:null});
//			_giftsMap.put("DanGao",{name:"DanGao",src:DanGao,index:null});
//			_giftsMap.put("BangBangTang",{name:"BangBangTang",src:BangBangTang,index:null});
//			
//			MyTextOut._giftsMap = _giftsMap;
		}
		
		
		override protected function configEventListener():void{
			//房间选择监听
			
			
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_ListRoom,commonEventHandler);//请求房间返回
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_UserInfo,commonEventHandler);//请求用户返回
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_Friends,commonEventHandler);////请求好友返回
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_SendBroadCast,commonEventHandler);////请求发送喇叭返回
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushErrorConnection,commonEventHandler);//动态信息推送
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushSingerInRoom,commonEventHandler);//动态信息推送
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushAddRoom,commonEventHandler);//动态信息推送
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushGiftMessage,commonEventHandler);//礼物消息
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushLevelRoom,commonEventHandler);//动态信息推送
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushBroadCast,commonEventHandler);//喇叭信息推送
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_GetRoom,commonEventHandler);//喇叭信息推送
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_InitRoom,commonEventHandler);//喇叭信息推送
			
			_playerData.addEventListener(EnterRoomEvent.ENTER_ROOM,enterRoomEventHandel);//点击聊天内容进入房间
			
			ui_MovieClip_Hall.text_findRoom.addEventListener(Event.CHANGE,findRoomInputHandler);
			
			//切换按钮
			ui_MovieClip_Hall.addEventListener("HallTabBarClicked",tabBarSwitchHandler);
			//广播按钮
			ButtonUtil.changeButton(ui_MovieClip_Hall.broadCastView.button_wantBroad).addEventListener(MouseEvent.CLICK,broadCastBtnHandel);
			ButtonUtil.changeButton(ui_BroadCastContextView.button_sendMessage).addEventListener(MouseEvent.CLICK,sendBroadCastMessage);
			
			
//			ButtonUtil.changeButton(ui_BroadCastContextView.button_sendMessage).addEventListener(MouseEvent.CLICK,sendBroadCastMessage);
			
			//好友列表中的按钮
//			ButtonUtil.changeButton(ui_MovieClip_Hall.friendList.button_prePage);
//			ButtonUtil.changeButton(ui_MovieClip_Hall.friendList.button_nextPage)
			ui_MovieClip_Hall.friendList.button_prePage.addEventListener(MouseEvent.CLICK,turnPageHandler);
			ui_MovieClip_Hall.friendList.button_nextPage.addEventListener(MouseEvent.CLICK,turnPageHandler);
			
			//房间创建
			ButtonUtil.changeButton(ui_MovieClip_Hall.button_createRoom).addEventListener(MouseEvent.CLICK,roomCreateBtnHandel);
			ButtonUtil.changeButton(ui_RoomCreate.button_sendMessage).addEventListener(MouseEvent.CLICK,createRoomHandel);
			
			//刷新按钮
			ButtonUtil.changeButton(ui_MovieClip_Hall.button_refershRoom).addEventListener(MouseEvent.CLICK,refershRoomBtnHandel);
			
			//搜索
		}
		
		private function enterRoomEventHandel(e:EnterRoomEvent):void{
			enterRoom(e.roomId);
		}
		private function loadData():void{
			_playerData.cs_UserInfo(_uid);
		}
		
		private function addListener():void{
			
		}
		
		private function findRoomInputHandler(e:Event):void{
			var text:String = TextField(e.target).text;
			var dp:Array;
//			var oldDP:DataProvider = DataProvider(_tileList_roomList.dataProvider);
//			oldDP.removeAll();
			_tileList_roomList.dataProvider = new Array();
			
			
			if(text == "" || text == null){
				_tileList_roomList.dataProvider = _curRoomItemList;
				return;
			}
			
			
			dp = new Array();
			//搜索房间号 以及房间名
			for each(var item:Object in _curRoomItemList){
				var room:HallRoomCellView = HallRoomCellView(item);
				if(room.ui_MovieClip_Room.text_roomId.text.search(text) != -1 || room.ui_MovieClip_Room.text_roomName.text.search(text) != -1){
					dp.push(item);
				}
			}
			_tileList_roomList.dataProvider = dp;
			
			
		}
		private var category:int = 1;
		
		private function refershRoomBtnHandel(e:Event):void{
			_listRoomResOb = null;
			refershRoomListView();
			
			if(category == 1){
				hallTabBar_GFPDHandel();
			}else if(category == 2){
				hallTabBar_ZDYPDHandel();
			}else if(category == 3){
				hallTabBar_WDPDHandel();
			}else{
				hallTabBar_GFPDHandel();
			}
		}
		public function refershFriendList(mc:MovieClip,friendListObj:Object=null):void{
			if(!friendListObj){
				mc.text_uname.text = "";
				mc.text_roomName.text = "";
			}else{
				mc.text_uname.text = friendListObj.uname;
				mc.text_roomName.text = friendListObj.roomName;
				mc.text_roomName.addEventListener(MouseEvent.CLICK,function friendListRoomNameClickHandel(e:Event):void{
					enterRoom(friendListObj.roomId);
					trace(friendListObj.roomId);
				});
			}
			mc.visible = true;	
		}
		private function closeApplictionHandel(e:Event):void{
			BaseInteract.cancelRadioSocket();
		}
		public function commonEventHandler( e:CommonEvent):void {
			switch (e.type) {
				case AbsPlayerData.EVENT_RES_Friends:
					trace("更新好友列表");
					var friendList:Array = e.data["friendList"];
					curPage = e.data["curPage"] as int;
					pcount = e.data["pcount"] as int;
					for (var i:int;i<= 7;i++){
						var friendListObj:Object = friendList[i];
						refershFriendList(ui_MovieClip_Hall.friendList["friend"+i],friendListObj);
					}
					ui_MovieClip_Hall.friendList.text_page.text = curPage+"/"+pcount;
					
					break;
				case AbsPlayerData.EVENT_RES_UserInfo:
					var userInfoObj:Object =  e.data;
					_playerData.playerObj = userInfoObj;//缓存当前的用户
					trace(_playerData.playerObj["uid"]);
					if(UModelLocal.getInstance().debug == 0){
							
					}else if(UModelLocal.getInstance().debug == 1){
						UModelLocal.getInstance().uid = userInfoObj["uid"];
					}
					ui_MovieClip_Hall.playerInfo.text_uname.selectable = false;
					ui_MovieClip_Hall.playerInfo.text_title.selectable = false;
					ui_MovieClip_Hall.playerInfo.text_exp.selectable = false;
					
					ui_MovieClip_Hall.playerInfo.text_uname.text = (userInfoObj.uname==null?"":userInfoObj.uname);
					ui_MovieClip_Hall.playerInfo.text_title.text = (userInfoObj.title==null?"":userInfoObj.title);
					ui_MovieClip_Hall.playerInfo.text_exp.text = userInfoObj.exp+"";
					ui_MovieClip_Hall.playerInfo.loader_userInfoImg.source = userInfoObj.headimg;
					
					
					_playerData.cs_Friends(_uid,1);
					hallTabBar_GFPDHandel();
					break;
				
				case AbsPlayerData.EVENT_RES_ListRoom:
					_playerData.broadCastPrice = e.data.broadCastPrice;
					_listRoomResOb = e.data
					refershRoomListView();
					break;
				
				case AbsPlayerData.EVENT_PUSH_pushBroadCast:
					var broadCastObj:Object		=  e.data;
					broadCastMessageArray.push(broadCastObj);
					refershTimer();
					break;
				case AbsPlayerData.EVENT_PUSH_pushErrorConnection:
					var errorContext:String = "你已经和服务器断开连接.";
					if(CommonEvent(e).data){
						errorContext = CommonEvent(e).data.content
					}
					var errorViewResSendMessage:ErrorView = new ErrorView(errorContext,closeApplictionHandel);
					addChild(errorViewResSendMessage);
					break;
				case AbsPlayerData.EVENT_PUSH_pushSingerInRoom:
					var singerInRoomObj:Object = e.data;
//					var htmlStr:String ="<font color='#0133c1'><font color='#0133c1'>"+singerInRoomObj.uname+"</font><font color='#131313'>唱完</font>"+singerInRoomObj.songsName+"<font color='#131313'>得</font><font color='#0133c1'>"+singerInRoomObj.score+"<font color='#131313'>分.(在</font><font color='#131313'>"+singerInRoomObj.roomId+"</font><font color='#131313'>号房间)</font>";
//					addMessageToAllPlayerInfo(htmlStr);
					
					var status:int = singerInRoomObj.status;
					
					if(status == 1){//结束唱歌
						userInfoTextOut.addMessage(MyTextOut.STOP_SINGING_MESSAGE,singerInRoomObj);
						//结束星级唱歌信息的处理
					}else{//开始唱歌
						userInfoTextOut.addMessage(MyTextOut.START_SINGING_MESSAGE,singerInRoomObj);
					}					
					
					
					
					
					
					
					
					
					//更新房间人数
//					var obj:Object = _playerData.fetchRoomObj(addRoomObj.roomId);
//					if(obj!= null){
//						obj.currentSinger -= 1;
//						refershRoomListView();
//					}
					
					break;
				case AbsPlayerData.EVENT_PUSH_pushGiftMessage:
					var object:Object = e.data;
					var count:int = object["count"];
					userInfoTextOut.addMessage(MyTextOut.GIFT_MESSAGE,object);
					break;
				
				case AbsPlayerData.EVENT_PUSH_pushAddRoom:
					//改变room信息没有完成
					var addRoomObj:Object = e.data
//					var htmlStrAddRoom:String ="<font color='#0133c1'>"+addRoomObj.uname+"</font><font color='#131313'>进入了</font><font color='#0133c1'>"+addRoomObj.roomId+"</font><font color='#131313'>号房间.</font>";
				
					userInfoTextOut.addMessage(MyTextOut.ROOM_MESSAGE,addRoomObj);
//					//更新房间人数
//					var objAdd:Object = _playerData.fetchRoomObj(addRoomObj.roomId);
//					if(objAdd!= null){
//						objAdd.currentUser += 1;
//						refershRoomListView();
//					}
					
//					addMessageToAllPlayerInfo(htmlStrAddRoom);
					break;
				case AbsPlayerData.EVENT_PUSH_pushLevelRoom:
					var roomObj:Object = e.data;
//					var htmlStrLevelRoom:String ="<font color='#0133c1'>"+roomObj.uname+"</font><font color='#131313'>离开了</font><font color='#0133c1'>"+roomObj.roomId+"</font><font color='#131313'>号房间.</font>";
//					addMessageToAllPlayerInfo(htmlStrLevelRoom);
					userInfoTextOut.addMessage(MyTextOut.ROOM_MESSAGE,roomObj);
//					//更新房间人数
//					var objItem:Object = _playerData.fetchRoomObj(addRoomObj.roomId);
//					if(objItem!= null){
//						objItem.currentUser -= 1;
//						refershRoomListView();
//					}
//					
					break;
				
				case AbsPlayerData.EVENT_RES_InitRoom:
					ViewHelper.removePopView(ViewRegister.SYSTEM_INFO_VIEW);
					var status2:int = e.data.status as int;
					var message:String = e.data.message;
					_playerData.initRoomObj["roomId"] = _curRoomId;
					if(status2 == 200){
						//登入成功;
						//通知外部容器
						_playerData.serverTimerstp = e.data.timestp as int;
						_playerData.clientTimerstp = int((new Date()).time/1000);
						ViewHelper.removeView(ViewRegister.HALL_VIEW);
						var disObj:DisplayObject = ViewHelper.addView(ViewRegister.ROOM_VIEW,ViewHelper._main);
						disObj.x += 10;
//						if(UModelLocal.getInstance().debug ==1){
							BaseInteract.baseInitRoom(_playerData.initRoomObj["roomId"]);
//						}
						return;
					}
					var errorView:ErrorView = new ErrorView(message);
					addChild(errorView);
					break;
					
				case AbsPlayerData.EVENT_RES_SendBroadCast:
					var statusResSendBroadCast:int = e.data.status as int;
					var messageResSendBroadCast:String = e.data.message;
					if(statusResSendBroadCast == 200){
						return;
					}
					//503：服务器异常；403：没有权限操作；200保存成功
					
					var errorViewResSendBroadCast:ErrorView = new ErrorView(messageResSendBroadCast);
					addChild(errorViewResSendBroadCast);
					break;
				
				
			}
		}
		private function refershTimer():void{
//			if(broadCastMessageArray.length >= 0&&!time.running){
//				time.addEventListener(TimerEvent.TIMER,refersh);
//				time.start();
//				refersh(new Event(""));
//			}
			refreshBroadCastMessage();
		}
		
		
//		private function refersh(e:Event):void{
//			var broadCastObj:Object = broadCastMessageArray.shift();
//			ui_MovieClip_Hall.broadCastView.text_message1.htmlText =ui_MovieClip_Hall.broadCastView.text_message2.htmlText;
//			if(broadCastObj == null){
//				ui_MovieClip_Hall.broadCastView.text_message2.htmlText = "";
//			}else{
//				ui_MovieClip_Hall.broadCastView.text_message2.htmlText ="<font color='#654533'>"+broadCastObj.uname+":"+broadCastObj.content+"</font>";
//			}
//			if(ui_MovieClip_Hall.broadCastView.text_message1.htmlText == "" &&ui_MovieClip_Hall.broadCastView.text_message2.htmlText == ""  ){
//				time.stop();
//			}
//			
//		}
		
		
		//广播里面使用的广播一行的对象
		private var _bcLineView1:BroadCastLineView;
		
//		广播里面使用的广播一行的对象
		private var _bcLineView2:BroadCastLineView;
		
		private var _bcLineView3:BroadCastLineView;
		
		/**
		 * 布局_bcLineView1和_bcLineView2
		 */ 
		private function layoutAllBcLineView():void{
			if(_bcLineView1 != null){
				_bcLineView1.x = 66;
				_bcLineView1.y = 8;
			}
			
			if(_bcLineView2 != null){
				_bcLineView2.x = 66;
				_bcLineView2.y = 29;
			}
		}
		
		
		private function deleteBcLineView(bcLineView:BroadCastLineView):void{
			if(!bcLineView){
				return;
			}
			if(_bcLineView3&&_bcLineView3.parent){
				_bcLineView3.parent.removeChild(bcLineView);
			}
			_bcLineView3 = bcLineView;
			if(_bcLineView3){
				_bcLineView3.visible = false;
			}
			
		}
		private function uprefreshBroadCastt(e:Event=null):void{
			if(_bcLineView1){
				_bcLineView1.destory();
			}
			_bcLineView1 = null;
			if(_bcLineView2){
				_bcLineView1 = _bcLineView2;
				if(_bcLineView1.hasEventListener(Event.COMPLETE)){
					_bcLineView1.removeEventListener(Event.COMPLETE,refreshBroadCastMessage);
				}
				_bcLineView2 = null;
			}
//			layoutAllBcLineView();
		}
		private function refreshBroadCastMessage(e:Event=null):void{
			var broadCastObj:Object;
//			if(_bcLineView2&&_bcLineView2._isRollingOver){
////				deleteBcLineView(_bcLineView1);
//				if(_bcLineView1){
//					_bcLineView1.destory();
//				}
//				_bcLineView1 = null;
//				if(_bcLineView2){
//					_bcLineView1 = _bcLineView2;
//					if(_bcLineView1.hasEventListener(Event.COMPLETE)){
//						_bcLineView1.removeEventListener(Event.COMPLETE,refreshBroadCastMessage);
//					}
//				}
//				broadCastObj = broadCastMessageArray.shift();
//			}else if(!_bcLineView2){
//				broadCastObj = broadCastMessageArray.shift();
//			}
			if(_bcLineView2==null){
				broadCastObj = broadCastMessageArray.shift();
			}else if(_bcLineView2._isRollingOver){
				uprefreshBroadCastt();
				broadCastObj = broadCastMessageArray.shift();
			}else{
				broadCastObj =null;
			}
			
			
			if(broadCastObj){
				_bcLineView2 = BroadCastLineView.setBroadCastLineView(broadCastObj,true);
				_bcLineView2.addEventListener(Event.COMPLETE,refreshBroadCastMessage);
				_bcLineView2.addEventListener(BroadCastLineView.EVENT_ENTER_ROOM,enterBroadCastRoomHandler,false,0,true);
				ui_MovieClip_Hall.broadCastView.addChild(_bcLineView2);
				_bcLineView2.x = 44;
				
				ui_MovieClip_Hall.broadCastView.broadcastanimationHallview.gotoAndPlay(2);
//			}else{
//				_bcLineView2 = BroadCastLineView.setBroadCastLineView(broadCastObj,true);
				
				//#####
				//有新的消息需要显示的时候调用的方法.
				//闪动边框的
			}
			layoutAllBcLineView();
		}
		/**
		 * 15秒刷新一次视图，将新的对象push进入，旧的对象删除掉
		 */ 
		private function refersh(e:Event):void{
			var broadCastObj:Object = broadCastMessageArray.shift();
			
			deleteBcLineView(_bcLineView1);
			_bcLineView1 = null;
			_bcLineView1 =_bcLineView2;
			if(broadCastObj == null){
				if(_bcLineView2 != null){
//					deleteBcLineView(_bcLineView2);
//					ui_MovieClip_Hall.broadCastView.removeChild(_bcLineView2);
					_bcLineView2 = null;
				}
			}else{
//				_bcLineView2 = new BroadCastLineView("<font color='#654533'>"+broadCastObj.uname+": "+broadCastObj.content+"</font>",388,1000,10,broadCastObj.roomId);
//				_bcLineView2.addEventListener(BroadCastLineView.EVENT_ENTER_ROOM,enterBroadCastRoomHandler,false,0,true);
//				ui_MovieClip_Hall.broadCastView.addChild(_bcLineView2);
				
				_bcLineView2 = new BroadCastLineView("<font color='#FF0099'>"+broadCastObj.uname+": </font><font color='#654533'>"+broadCastObj.content+"</font>",300,1000,5,broadCastObj.roomId);
				_bcLineView2.addEventListener(Event.COMPLETE,refersh);
				_bcLineView2.addEventListener(BroadCastLineView.EVENT_ENTER_ROOM,enterBroadCastRoomHandler,false,0,true);
				ui_MovieClip_Hall.broadCastView.addChild(_bcLineView2);
				_bcLineView2.x = 44;
			}
			
			layoutAllBcLineView();
			if(_bcLineView1 == null && _bcLineView2 == null  ){
				time.stop();
			}
						
		}
		
		/**
		 * 进入播报中房间的事件处理
		 */ 
		private function enterBroadCastRoomHandler(e:Event):void{
			_curRoomId = BroadCastLineView(e.target).roomId;		
			if(_curRoomId<1){
				return;
			}
			
			enterRoom(_curRoomId);
			
		}
		
		
		private function turnPageHandler(e:MouseEvent):void{
			switch(e.target){
				case ui_MovieClip_Hall.friendList.button_prePage:
					//TODO 请求上一页的好友数据
					curPage--;
					break;
				case ui_MovieClip_Hall.friendList.button_nextPage:
					//TODO 请求下一页的好友数据
					curPage++;
					break;
			}
			
			if(curPage<=1){
				curPage = 1;
			}
			if(curPage>=pcount){
				curPage = pcount ;
			}
			_playerData.cs_Friends(_uid,curPage);
		}
		
		private function sendBroadCastMessage(e:Event):void{
//			NetUntil.getInstance().send("{\"jsessionid\":\"711857534_browser_sessionid\",\"method\":\"sendBroadCast\",\"content\":\""+hallView.ui_BroadCastContextView.text_broadCastContext.text+"\",\"sendLink\":0}");
			
			_playerData.cs_SendBroadCast(RegExpTool.deleteLineChanger(ui_BroadCastContextView.text_broadCastContext.text),0);
			if(ui_BroadCastContextView.parent){
				removeChild(ui_BroadCastContextView);
			}
		}
//		private function ddddd(e:Event=null):void{
//			
//		}
		private function createRoomHandel(e:Event):void{
			//			NetUntil.getInstance().send("{\"jsessionid\":\"711857534_browser_sessionid\",\"method\":\"sendBroadCast\",\"content\":\""+hallView.ui_BroadCastContextView.text_broadCastContext.text+"\",\"sendLink\":0}");
			var userCount:int = 5;
			if(ui_RoomCreate.cb_peopleCount.selectedIndex == 0){
				userCount = 5;
			}else{
				userCount = 25;
			}
			var limits:int = 1;
			if(ui_RoomCreate.rb_drgb.selected){
				limits = 1;
			}else if(ui_RoomCreate.rb_zygb.selected){
				limits = 2;
			}else{
				limits = 3;
			}
			trace(userCount+":"+limits);
			_playerData.cs_CreateNewRoom(ui_RoomCreate.text_RoomName.text,ui_RoomCreate.text_RoomPassword.text,userCount,limits);
			//ViewHelper.popView(ViewRegister.SYSTEM_INFO_VIEW,this.stage,800,800);
			
			if(ui_RoomCreate.parent){
				removeChild(ui_RoomCreate);
			}
		}
		private function roomCreateBtnHandel(e:Event):void{
			ui_RoomCreate.text_RoomName.text = "";
			ui_RoomCreate.text_RoomPassword.text = "";
			addChild(ui_RoomCreate);
		}
		private function broadCastBtnHandel(e:Event):void{
			_playerData.cs_UserInfo(_uid);
			
			ui_BroadCastContextView.needCost.text = _playerData.broadCastPrice+"";
			ui_BroadCastContextView.kmoney.text = _playerData.playerObj.kmoney+"";
			ui_BroadCastContextView.text_broadCastContext.text = "";
			addChild(ui_BroadCastContextView);
			
		}
		private function hallTabBar_GFPDHandel():void{
			trace("HallTabBar_GFPD");
			category = 1;
			ui_MovieClip_Hall.button_refershRoom.visible=true;
			ui_MovieClip_Hall.button_createRoom.visible = false;
			_playerData.cs_ListRoom(1);
//			NetUntil.getInstance().send("{\"jsessionid\":\"711857534_browser_sessionid\",\"method\":\"listRoom\",\"category\":\"1\"}");
		}
		private function hallTabBar_ZDYPDHandel():void{
			trace("HallTabBar_ZDYPD");
			category = 2;
			ui_MovieClip_Hall.button_refershRoom.visible=true;
			ui_MovieClip_Hall.button_createRoom.visible = true;
			_playerData.cs_ListRoom(2);
//			NetUntil.getInstance().send("{\"jsessionid\":\"711857534_browser_sessionid\",\"method\":\"listRoom\",\"category\":\"2\"}");
		}
		private function hallTabBar_WDPDHandel():void{
			trace("HallTabBar_ZDYPD");
			category = 3;
			ui_MovieClip_Hall.button_refershRoom.visible=true;
			ui_MovieClip_Hall.button_createRoom.visible = true;
			_playerData.cs_ListRoom(3);
			//			NetUntil.getInstance().send("{\"jsessionid\":\"711857534_browser_sessionid\",\"method\":\"listRoom\",\"category\":\"2\"}");
		}
		private function tabBarSwitchHandler(e:MouseEvent):void{
//			var _roomListVO:RoomListVO = DataCenter.getInstance().playerData._roomListVO;
//			_roomListVO.items = new Array();
			_listRoomResOb = null;
			refershRoomListView();
			
			if(e.relatedObject is HallTabBar_GFPD){
				hallTabBar_GFPDHandel();
				return;
			}
			
			if(e.relatedObject is HallTabBar_WDPD){
				
				trace("HallTabBar_WDPD");
				hallTabBar_WDPDHandel();
			}
			
			if(e.relatedObject is HallTabBar_ZDYPD){
				
				hallTabBar_ZDYPDHandel();
			}
			
			
		}
		
		private function refershRoomListView():void{
			roomViewMap.clear();
//			var _roomListVO:RoomListVO = DataCenter.getInstance().playerData.;
//			var roomList :DataProvider = new DataProvider();
//			_roomListVO.items.sort(sortOnRoomId);
			var roomObjList:Array;
			if(_listRoomResOb == null){
				roomObjList = new Array();
			}else{
				roomObjList = _listRoomResOb['roomList'];
			}
			
			
			
//			roomObjList.sortOn("roomId",Array.NUMERIC);
			var roomList :Array = new Array();
			for each (var roomObj:Object in roomObjList){
				var hallRoomCellView: HallRoomCellView = new HallRoomCellView();
				hallRoomCellView.setRoomObject(roomObj);
				
				roomList.push(hallRoomCellView);
				roomViewMap.put(roomObj.roomId,hallRoomCellView);
				hallRoomCellView.buttonMode=true;
				
				if(!hallRoomCellView.hasEventListener(MouseEvent.MOUSE_OVER)){
					hallRoomCellView.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandel);
				}
				if(!hallRoomCellView.hasEventListener(MouseEvent.MOUSE_OUT)){
					hallRoomCellView.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandel);
				}
				if(!hallRoomCellView.hasEventListener(MouseEvent.CLICK)){
					hallRoomCellView.addEventListener(MouseEvent.CLICK,itemClickHandel);
				}
				
			}
			_curRoomItemList = roomList;
			_tileList_roomList.dataProvider = roomList;
			
			
			
		}
		private var _tileList_roomList:MyTileList = new MyTileList();
		private function itemClickHandel(e:MouseEvent):void{
			_curRoomId = int(HallRoomCellView(e.target)._obj["roomId"]) as int;
			trace(_curRoomId);
			enterRoom(_curRoomId)
		}
		
		private function enterRoom(roomId:int):void{
			_curRoomId = roomId;
			if(_curRoomId<1){
				return;
			}
			_playerData.cs_InitRoom(_curRoomId);
			ViewHelper.popView(ViewRegister.SYSTEM_INFO_VIEW,this,Main.KG_WIDTH,Main.KG_HEIGHT);
//			_playerData.initRoomObj = roomId;
//			_playerData.cs_GetRoom(e.item.source.text_roomId.text);
		}
		
		private function itemOverHandel(e:MouseEvent):void{
			var room: HallRoomCellView = HallRoomCellView(e.target);
			room.ui_MovieClip_Room.roomSelect_Bg.gotoAndStop(2);
			
			room.filters = [new ColorMatrixFilter([1,0,0,0,30,0,1,0,0,30,0,0,1,0,30,0,0,0,1,0])];
			//f1bd05
			//0d3566
		}
		
		private function itemOutHandel(e:MouseEvent):void{
			var room: HallRoomCellView = HallRoomCellView(e.target);
			room.ui_MovieClip_Room.roomSelect_Bg.gotoAndStop(1);
			
			room.filters = null;
			//f1bd05
			//0d3566
		}
		
		private function initBroadCastContext():void{
			ButtonUtil.changeButton(ui_BroadCastContextView.button_cancal).addEventListener(MouseEvent.CLICK,function cancalHandel(e:Event):void{
				if(ui_BroadCastContextView.parent){
					ui_BroadCastContextView.parent.removeChild(ui_BroadCastContextView);
				}
			});
		}
		
		private function initCreateRoomView():void{
			ButtonUtil.changeButton(ui_RoomCreate.button_cancal).addEventListener(MouseEvent.CLICK,function cancalHandel(e:Event):void{
				if(ui_RoomCreate.parent){
					ui_RoomCreate.parent.removeChild(ui_RoomCreate);
				}
			});
		}
		
		private function addMessageToAllPlayerInfo(htmlStr:String):void{
			ui_MovieClip_Hall.allPlayerInfo.tf_allPlayerInfo.htmlText+=htmlStr;
		}
		
		override public function destory():void{
			super.destory();
			//房间选择监听
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_ListRoom,commonEventHandler);//请求房间返回
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_UserInfo,commonEventHandler);//请求用户返回
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_Friends,commonEventHandler);////请求好友返回
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_SendBroadCast,commonEventHandler);////请求发送喇叭返回
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushSingerInRoom,commonEventHandler);//动态信息推送
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushAddRoom,commonEventHandler);//动态信息推送
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushGiftMessage,commonEventHandler);//礼物消息
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushLevelRoom,commonEventHandler);//动态信息推送
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushBroadCast,commonEventHandler);//喇叭信息推送
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_GetRoom,commonEventHandler);//喇叭信息推送
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_InitRoom,commonEventHandler);//喇叭信息推送
			ui_MovieClip_Hall.text_findRoom.removeEventListener(Event.CHANGE,findRoomInputHandler);
			
			//切换按钮
			ui_MovieClip_Hall.removeEventListener("HallTabBarClicked",tabBarSwitchHandler);
			//广播按钮
			ButtonUtil.changeButton(ui_MovieClip_Hall.broadCastView.button_wantBroad).removeEventListener(MouseEvent.CLICK,broadCastBtnHandel);
			ButtonUtil.changeButton(ui_BroadCastContextView.button_sendMessage).removeEventListener(MouseEvent.CLICK,sendBroadCastMessage);
			
			//好友列表中的按钮
			ButtonUtil.changeButton(ui_MovieClip_Hall.friendList.button_prePage).removeEventListener(MouseEvent.CLICK,turnPageHandler);
			ButtonUtil.changeButton(ui_MovieClip_Hall.friendList.button_nextPage).removeEventListener(MouseEvent.CLICK,turnPageHandler);
			
			//房间创建
			ButtonUtil.changeButton(ui_MovieClip_Hall.button_createRoom).removeEventListener(MouseEvent.CLICK,roomCreateBtnHandel);
			ButtonUtil.changeButton(ui_RoomCreate.button_sendMessage).removeEventListener(MouseEvent.CLICK,createRoomHandel);
			
			//刷新按钮
			ButtonUtil.changeButton(ui_MovieClip_Hall.button_refershRoom).removeEventListener(MouseEvent.CLICK,refershRoomBtnHandel);
			
			//搜索
		}
	}
}