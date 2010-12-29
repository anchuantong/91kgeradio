/**
 * 12-3
 * 遗留问题
 * 1。  comboBox中增加私聊方法
 *     处理:增加一个事件监听,收到事件监听后创建OBJ到DP
 * 2。聊天发送给服务器就断开了服务器连接问题.
 * 3。礼物的发送.
 * 4。表情和礼物分别用swc编译.
 * 5。用户TIP显示
 * 6。用户列表中的头像大小,图标大小.
 * 7。 最大化
 * 8。返回房间
 * 9。我的歌本
 */	

package com.ywit.radio91.view
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.ywit.radio91.center.UModelLocal;
	import com.ywit.radio91.component.MyTileList;
	import com.ywit.radio91.constant.ViewRegister;
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.event.CommonEvent;
	import com.ywit.radio91.event.GiftCellEvent;
	import com.ywit.radio91.event.OperateSongEvent;
	import com.ywit.radio91.event.UserEvent;
	import com.ywit.radio91.gen.data.AbsPlayerData;
	import com.ywit.radio91.util.BaseInteract;
	import com.ywit.radio91.util.ButtonUtil;
	import com.ywit.radio91.util.HashMap;
	import com.ywit.radio91.util.NetUntil;
	import com.ywit.radio91.util.RegExpTool;
	import com.ywit.radio91.util.ViewHelper;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IMEEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.system.IMEConversionMode;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import ghostcat.display.transfer.BookTransfer;
	

	/**
	 * startUser接口 是不是 push
	 * EVENT_RES_GetNotice接口是不是push
	 * 关注接口没有
	 */ 
	public class RoomView extends AbsView {
		public var ui_RoomView:UI_RoomView = new UI_RoomView();
		private var _playerData:PlayerData =PlayerData.getInstance();
		private var _roomId:int = 1;//房间id
		private var roomName:String = "";
		private var uid:int  ;//uid
		private var _changeHeight:int = 205;
		
		private var targetUser:UserEvent;
		private var songInfoLay:SongInfoLay = new SongInfoLay();
		
		private var privateChatView:MyTextOut = new MyTextOut(489,81);
		private var publicChatView:MyTextOut = new MyTextOut(489,86);
		private var watchChatView:MyTextOut = new MyTextOut(489,175);
		private var chatViewPanel:ChatViewPanelView = new ChatViewPanelView(489,175);
		
		
		
		private var ui_GiftListView:UI_GiftListView = new UI_GiftListView();
		public  var ui_GiftTipView:UI_GiftTipView = new UI_GiftTipView();
		public  var ui_SendGiftView:UI_SendGiftView = new UI_SendGiftView();
//		public  var ui_ConfirmView:UI_ConfirmView = new UI_ConfirmView();
		private var _starSingerTimer:Timer = new Timer(1000);
		
		private var _currentStarUserResObj:Object;
		public  var roomUserInfoTip:RoomUserInfoTip = new RoomUserInfoTip();
		
		//当前星级歌手唱的时间
		private var _curStarUserSingTime:int;
		
		private var _smileyContainer:Sprite;	//表情容器
		
		private var page:int=1;
		private var pcount:int=1;
		
		private var selectGift:Object;//当前选择的礼物
		private var giftMap:HashMap = new HashMap();
		
		private var _allPlayerUserMap:HashMap = new HashMap();
		
//		private var allSingerUserMap:HashMap = new HashMap();
		//		private var allUserMap:HashMap = new HashMap();
		private var noViewUserArray:Array = new Array();
		
		private var ui_roomBroadCast:UI_roomBroadCast = new UI_roomBroadCast();
		
		private var timer:Timer = new Timer(2000);
		
		private var broadCastMessageArray:Array = new Array();
//		private var broadCastTime:Timer = new Timer(30000);
//		private var broadCastTime:Timer = new Timer(3000);
		//当前传过来的房间内的列表包括唱歌的和观众
		private var _curAllRoomUserList:Array;
		
	
		//当前列举的用户
		private const ROOM_USER_TYPE_SINGER:String = "ROOM_USER_TYPE_SING";
		//观众
		private const ROOM_USER_TYPE_VIEWER:String = "ROOM_USER_TYPE_VIEWER";
		
		private var _curRoomUserType:String = ROOM_USER_TYPE_SINGER;
		
		//要转到的另一个房间的id
		private var _anotherRoomId:int;
		
		/**
		 * 送礼物的目标uid
		 */ 
		private var _sendGifTargetUID:int;
		/**
		 * 送礼物的目标名称
		 */ 
		private var _sendGifTargetName:String;
		public function RoomView() {
			this.uid = _playerData.playerObj["uid"];
			
			super();
//			setUpStyle();
			loadData();
		}
		private function loadData():void{
		
			_roomId = _playerData.initRoomObj["roomId"];
			var obj:Object = _playerData.fetchRoomObj(_roomId);
			roomName = obj.roomName;
			
			
			singerListButHandel();
//			userListButHandel();
			initGiftListView();
			
			var roomId:String;
			if(_roomId < 10){
				roomId = "00"+_roomId;
			}else if(_roomId < 99){
				roomId = "0"+_roomId;
			}
			
			ui_RoomView.tf_roomNum.text = roomId;
			ui_RoomView.tf_roomName.text=roomName;
			//test 星级歌手唱歌
		
			_playerData.cs_ListAllUser(_roomId);
			
		}
		
		/**
		 * 将播放器加载进来
		 */ 
		public function addKPlayer(disObj:DisplayObject):void{
			ui_RoomView.mc_roomBg.mc_KPlayerBg.addChild(disObj);
		}
		
		override protected function initView():void{
			songInfoLay.x = 165;
			songInfoLay.y = -23;
			
			ui_roomBroadCast.x = Main.KG_WIDTH/2-ui_roomBroadCast.width/2;
			ui_roomBroadCast.y = Main.KG_HEIGHT/2-ui_roomBroadCast.height*3/2+32;
			
			initBroadCastView();
			
			privateChatView.x = 2;
//			privateChatView.y = 123;
			
			ButtonUtil.changeButton(ui_RoomView.broadCast.but_sendMessage);
			ButtonUtil.changeButton(ui_RoomView.btn_changeSizeBtn);
			ui_RoomView.roomUserList.pdphListBut.visible = false;
			
			//关注主播暂时不显示，等到收听某人唱歌的时候显示
			ui_RoomView.roomChat.tb_watchSinger.visible = false;
			//悄悄话默认是不启用的，因为目标默认是所有人
			ui_RoomView.roomChat.cb_isPrivateChat.enabled = false
//			ui_RoomView.roomChat.targetComboBox.width = 100;
			
			
			_myTileListUserInfoList.setStyle("upArrowDisabledSkin",UpArrowUpSkin2);
			_myTileListUserInfoList.setStyle("upArrowUpSkin",UpArrowUpSkin2);
			_myTileListUserInfoList.setStyle("upArrowOverSkin",UpArrowOverSkin2);
			_myTileListUserInfoList.setStyle("upArrowDownSkin",UpArrowDownSkin2);
			_myTileListUserInfoList.setStyle("trackDisabledSkin",TrackUpSkin2);
			_myTileListUserInfoList.setStyle("trackUpSkin",TrackUpSkin2);
			_myTileListUserInfoList.setStyle("trackOverSkin",TrackOverSkin2);
			_myTileListUserInfoList.setStyle("trackDownSkin",TrackDownSkin2);
			_myTileListUserInfoList.setStyle("thumbDisabledSkin",ThumbUpSkin2);
			_myTileListUserInfoList.setStyle("thumbUpSkin",ThumbUpSkin2);
			_myTileListUserInfoList.setStyle("thumbOverSkin",ThumbOverSkin2);
			_myTileListUserInfoList.setStyle("thumbDownSkin",ThumbDownSkin2);
			_myTileListUserInfoList.setStyle("downArrowDisabledSkin",DownArrowDownSkin2);
			_myTileListUserInfoList.setStyle("downArrowDownSkin",DownArrowDownSkin2);
			_myTileListUserInfoList.setStyle("downArrowOverSkin",DownArrowOverSkin2);
			_myTileListUserInfoList.setStyle("downArrowUpSkin",DownArrowUpSkin2);
			
//			_scrollPanePrivate.source = privateChatView;
//			_scrollPanePrivate.width = 489;
//			_scrollPanePrivate.height = 81;
//			_scrollPanePrivate.horizontalScrollPolicy = "off";
			
			
			publicChatView.x = 2;
			publicChatView.y = 24;
			chatViewPanel.y = 24;
			
			watchChatView.x = 2;
			watchChatView.y = 24;
			watchChatView.visible = false;
			
			initSmileys();
			initGifts();
			_smileyContainer = new Sprite();
			_smileyContainer.x = 323;
			_smileyContainer.y = 20;
			_smileyContainer.visible = false;
			createSmileys();
			
			
			ui_GiftTipView.visible = false;
			roomUserInfoTip.visible = false;
			
			initSendGiftView();
//			initConfirmView();
//			refreshTargetComboBox();
			
			ButtonUtil.changeButton(ui_RoomView.btn_backHall);
			ButtonUtil.changeButton(ui_RoomView.btn_singerInHall);
			ButtonUtil.changeButton(ui_RoomView.roomChat.mc_popFace);
			ButtonUtil.changeButton(ui_RoomView.roomChat.mc_popPresent);
			ButtonUtil.changeButton(ui_RoomView.roomChat.btn_sendChat);
			ButtonUtil.changeButton(ui_GiftListView.nextPage);
			ButtonUtil.changeButton(ui_GiftListView.prePage);
			ButtonUtil.changeButton(ui_GiftListView.sendGift);
			
			TweenPlugin.activate([FramePlugin]);
			ui_RoomView.roomChat.tb_publicChat.buttonMode = true;
			ui_RoomView.roomChat.tb_gift.buttonMode = true;
			ui_RoomView.roomChat.tb_mySongs.buttonMode = true;
			ui_RoomView.roomChat.tb_watchSinger.buttonMode = true;
			
			ui_RoomView.roomUserList.singerListBut.buttonMode = true;
			ui_RoomView.roomUserList.userListBut.buttonMode = true;
			ui_RoomView.roomUserList.pdphListBut.buttonMode = true;
			
//			ButtonUtil.changeButton(ui_RoomView.roomChat.clearPublicScreenBtn);
//			ButtonUtil.changeButton(ui_RoomView.roomChat.clearPrivateScreenBtn);
			ui_RoomView.roomChat.clearPublicScreenBtn.buttonMode = true;
			ui_RoomView.roomChat.clearPrivateScreenBtn.buttonMode = true;
//			
			
			
//			cb_isPrivateChat
			
			ui_RoomView.roomChat.targetComboBox.setStyle("upArrowDisabledSkin",UpArrowUpSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("upArrowUpSkin",UpArrowUpSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("upArrowOverSkin",UpArrowOverSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("upArrowDownSkin",UpArrowDownSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("trackDisabledSkin",TrackUpSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("trackUpSkin",TrackUpSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("trackOverSkin",TrackOverSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("trackDownSkin",TrackDownSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("thumbDisabledSkin",ThumbUpSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("thumbUpSkin",ThumbUpSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("thumbOverSkin",ThumbOverSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("thumbDownSkin",ThumbDownSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("downArrowDisabledSkin",DownArrowDownSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("downArrowDownSkin",DownArrowDownSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("downArrowOverSkin",DownArrowOverSkin2);
			ui_RoomView.roomChat.targetComboBox.setStyle("downArrowUpSkin",DownArrowUpSkin2);
			
			_myTileListUserInfoList.x = 506.5;
			_myTileListUserInfoList.y = 400;
			_myTileListUserInfoList.verticalScrollPolicy = "on";
			_myTileListUserInfoList.horizontalScrollPolicy = "off";
			_myTileListUserInfoList._columnCount=1;
			_myTileListUserInfoList._columnWidth = 243;
			_myTileListUserInfoList._rowHeight = 30;
			
			_myTileListUserInfoList.width = 266;
			_myTileListUserInfoList.height = 186;
			
			
			_mySongs_tileList._columnWidth=476;
			_mySongs_tileList._rowHeight = 25;
			_mySongs_tileList.width=480;
			_mySongs_tileList.height=123;
			_mySongs_tileList.x = 9;
			_mySongs_tileList.y = 48.35;
			_mySongs_tileList.visible = false;
			
			_mySongs_tileList.setStyle("upArrowDisabledSkin",UpArrowUpSkin2);
			_mySongs_tileList.setStyle("upArrowUpSkin",UpArrowUpSkin2);
			_mySongs_tileList.setStyle("upArrowOverSkin",UpArrowOverSkin2);
			_mySongs_tileList.setStyle("upArrowDownSkin",UpArrowDownSkin2);
			_mySongs_tileList.setStyle("trackDisabledSkin",TrackUpSkin2);
			_mySongs_tileList.setStyle("trackUpSkin",TrackUpSkin2);
			_mySongs_tileList.setStyle("trackOverSkin",TrackOverSkin2);
			_mySongs_tileList.setStyle("trackDownSkin",TrackDownSkin2);
			_mySongs_tileList.setStyle("thumbDisabledSkin",ThumbUpSkin2);
			_mySongs_tileList.setStyle("thumbUpSkin",ThumbUpSkin2);
			_mySongs_tileList.setStyle("thumbOverSkin",ThumbOverSkin2);
			_mySongs_tileList.setStyle("thumbDownSkin",ThumbDownSkin2);
			_mySongs_tileList.setStyle("downArrowDisabledSkin",DownArrowDownSkin2);
			_mySongs_tileList.setStyle("downArrowDownSkin",DownArrowDownSkin2);
			_mySongs_tileList.setStyle("downArrowOverSkin",DownArrowOverSkin2);
			_mySongs_tileList.setStyle("downArrowUpSkin",DownArrowUpSkin2);
			
			_mySongs_tileList.verticalScrollPolicy="on";
			_mySongs_tileList.horizontalScrollPolicy = "off";
			
			dragLineMoveHandel();
		}
		
		/**
		 * 刷新当前的用户列表combox
		 */ 
		private function refreshTargetComboBox():void{
			var object:Object;
			var dp:DataProvider = new DataProvider();
			object = new Object();
			object.label = "所有人";//用户名字
			object.data = "0";//uid
			dp.addItem(object);
			
			//当前应选择的item
			var curSelectedItem:Object;
			
			for each(var ele:Object in _allPlayerUserMap.values()){
				object = new Object();
				object.label = ele["uname"];
				object.data  = ele["uid"];
				dp.addItem(object);
				
				if(ui_RoomView.roomChat.targetComboBox.selectedItem != null && ui_RoomView.roomChat.targetComboBox.selectedItem.data == ele["uid"]){
					curSelectedItem = object;
				}
			}
			
			ui_RoomView.roomChat.targetComboBox.dataProvider = dp;
			if(curSelectedItem != null){
				ui_RoomView.roomChat.targetComboBox.selectedItem =  curSelectedItem;
			}
				var tft:TextFormat = new TextFormat();
			// 设置其字体大小为32
			tft.size = 12;
			// 设置ComboBox的样式
			tft.font = "宋体";
			
			ui_RoomView.roomChat.targetComboBox.textField.setStyle('textFormat', tft);
			ui_RoomView.roomChat.targetComboBox.dropdown.setRendererStyle('textFormat', tft);
		}
		
		/**
		 * 当下拉框改变的时候触发事件
		 */ 
		private function targetComboBoxSelectHandler(e:Event):void{
			if(ComboBox(e.target).selectedItem.data > "0"){
				ui_RoomView.roomChat.cb_isPrivateChat.enabled = true;
				_sendGifTargetUID = ComboBox(e.target).selectedItem.data;
				_sendGifTargetName = ComboBox(e.target).selectedLabel;
			}else{
				ui_RoomView.roomChat.cb_isPrivateChat.enabled = false;
				ui_RoomView.roomChat.cb_isPrivateChat.selected = false;
				
			}
		}
		/**
		 * 根据uid选择目标comboBox的选项
		 */ 
		public function selectTargetComboBoxByUID(uid:int):void{
			for each(var ele:Object in  ui_RoomView.roomChat.targetComboBox.dataProvider.toArray()){
				if(ele.data == uid){
					ui_RoomView.roomChat.targetComboBox.selectedItem = ele;
					if(uid > 0){
						ui_RoomView.roomChat.cb_isPrivateChat.selected = true;
						ui_RoomView.roomChat.cb_isPrivateChat.enabled = true;
					}
					return;
				}
			}
		}
		private function createSmileys():void {
			var _smileys:Array = MyTextOut._smileysMap.values();
			var boold:int = 5;
			for (var i:int = 0; i < _smileys.length; i++) {
				var obj:Object = _smileys[i];
				var smiley:Sprite = new (obj.src as Class)() as Sprite;
				smiley.name = obj.name;
				_smileyContainer.addChild(smiley);
				smiley.x = boold+(i % 6) * 28;
				smiley.y = boold+Math.floor(i / 6) * 28;
				smiley.buttonMode = true;
				smiley.addEventListener(MouseEvent.CLICK, insertSmiley);			
			}
			
			_smileyContainer.graphics.lineStyle(1,0x5EA7DC,1);
			_smileyContainer.graphics.beginFill(0xFFFFFF,1);
			_smileyContainer.graphics.drawRoundRect(0,0,_smileyContainer.width+boold*2,_smileyContainer.height+boold*2,20,20);
			_smileyContainer.graphics.endFill();
		}
		public function insertSmiley(evt:MouseEvent):void {
			smileyClickHandel(evt);//
			ui_RoomView.roomChat.tf_chatInput.appendText(evt.target.name);
		}
		
		
		private function smileyClickHandel(e:Event):void{
			_smileyContainer.visible = !_smileyContainer.visible;
			if(_smileyContainer.visible){
				ui_RoomView.roomChat.addChild(_smileyContainer);
			}
		}
		
		private function viewGiftList(obj:Object):void{
			this.page = obj["curPage"] as int;
			this.pcount = obj["pcount"] as int;
//			if(!targetUser){
//				var errorViewResSendBroadCast:ErrorView = new ErrorView("没有选中目标用户.");
//				addChild(errorViewResSendBroadCast);
//				return;
//			}
			
			ui_GiftListView.visible = true;
			roomUserInfoTip.visible = false;
			if(ui_GiftListView.visible){
//				new BangBangTang();
				ui_GiftListView.kmoney.text = _playerData.playerObj["kmoney"]+"K币";
				ui_GiftListView.count.text = "1";
				ui_GiftListView.totalMoney.text = "0K币";
				ui_GiftListView.recName.text = _sendGifTargetName;
				
				var array:Array = obj["giftList"] as Array;
				for (var i:int=0 ;i<8;i++ ){
					var mc:MovieClip = UI_GiftCellView(ui_GiftListView["giftCell"+(i+1)]).giftData;
					var giftVo:Object =  array[i];
					GiftCellViewUtil.addGift2GiftList(mc,giftVo);
					if(giftVo){
						giftMap.put(giftVo["imgUrl"],giftVo);
					}
					
					mc.addEventListener(GiftCellEvent.GIFT_MOUSE_OVER,function mouseOverHandel(e:GiftCellEvent):void{
						ui_GiftTipView.x= ui_RoomView.mouseX;
						ui_GiftTipView.y= ui_RoomView.mouseY;
						ui_GiftTipView.title.text = e.data["title"];
						ui_GiftTipView.price.text = e.data["price"]+"K币";
						ui_GiftTipView.award.text = "+"+e.data["award"];
						ui_GiftTipView.exp.text = "+"+e.data["exp"];
						ui_GiftTipView.description.text = "+"+e.data["description"];
						
						ui_GiftTipView.visible = true;
					});
					mc.addEventListener(GiftCellEvent.GIFT_MOUSE_OUT,function mouseOutHandel(e:GiftCellEvent):void{
						ui_GiftTipView.visible = false;
					});
					mc.addEventListener(GiftCellEvent.GIFT_MOUSE_CLICK,function mouseClickHandel(e:GiftCellEvent):void{
						ui_GiftTipView.visible = false;
						for(var y:int =1;y<9;y++){
							MovieClip(ui_GiftListView["giftCell"+y]).gotoAndStop(1);
						}
						selectGift = e.data;
						MovieClip(MovieClip(e.target).parent).gotoAndStop(2);
						ui_GiftListView.totalMoney.text = int(int(e.data["price"])*int(ui_GiftListView.count.text))+"K币";;
					});
				}
				
			}
		}
		
		/**
		 * 被外部调用的弹出礼物面板
		 */ 
		public function popPresentPannel(uid:int):void{
			_sendGifTargetUID = uid;
			var object:Object = _allPlayerUserMap.getValue(uid);
			if(object == null){
				var errorViewResSendMessage:ErrorView = new ErrorView("当前用户不在房间");
				addChild(errorViewResSendMessage);
				return;
			}
			_sendGifTargetName =  object["uname"];
			giftButClickHandel();
		}
		
		private function giftButClickHandel(e:Event=null):void{
/*			if(targetUser == null){
				var errorViewResSendMessage:ErrorView = new ErrorView("您没有选择目标用户.");
				addChild(errorViewResSendMessage);
				return;
			}*/
			
			if(_sendGifTargetUID <=0 ){
				var errorViewResSendMessage:ErrorView = new ErrorView("您没有选择目标用户.");
				addChild(errorViewResSendMessage);
				return;
			}
			
			_playerData.cs_UserInfo(uid);//更新当前用户缓存
			for(var y:int =1;y<9;y++){
				MovieClip(ui_GiftListView["giftCell"+y]).gotoAndStop(1);
			}
			selectGift = null;
			_playerData.cs_ListGift(page);
			
		}
		
		//表情初始化
		private function initSmileys():void{
			var _smileysMap:HashMap = new HashMap();
			//初始化表情
			_smileysMap.put("#01",{name:"#01",src:BQ_01,index:null});
			_smileysMap.put("#02",{name:"#02",src:BQ_02,index:null});
			_smileysMap.put("#03",{name:"#03",src:BQ_03,index:null});
			_smileysMap.put("#04",{name:"#04",src:BQ_04,index:null});
			_smileysMap.put("#05",{name:"#05",src:BQ_05,index:null});
			_smileysMap.put("#06",{name:"#06",src:BQ_06,index:null});
			_smileysMap.put("#07",{name:"#07",src:BQ_07,index:null});
			_smileysMap.put("#08",{name:"#08",src:BQ_08,index:null});
			_smileysMap.put("#09",{name:"#09",src:BQ_09,index:null});
			_smileysMap.put("#10",{name:"#10",src:BQ_10,index:null});
			_smileysMap.put("#11",{name:"#11",src:BQ_11,index:null});
			_smileysMap.put("#12",{name:"#12",src:BQ_12,index:null});
			_smileysMap.put("#13",{name:"#13",src:BQ_13,index:null});
			_smileysMap.put("#14",{name:"#14",src:BQ_14,index:null});
			_smileysMap.put("#15",{name:"#15",src:BQ_15,index:null});
			_smileysMap.put("#16",{name:"#16",src:BQ_16,index:null});
			_smileysMap.put("#17",{name:"#17",src:BQ_17,index:null});
			_smileysMap.put("#18",{name:"#18",src:BQ_18,index:null});
			_smileysMap.put("#19",{name:"#19",src:BQ_19,index:null});
			_smileysMap.put("#20",{name:"#20",src:BQ_20,index:null});
			_smileysMap.put("#21",{name:"#21",src:BQ_21,index:null});
			_smileysMap.put("#22",{name:"#22",src:BQ_22,index:null});
			_smileysMap.put("#23",{name:"#23",src:BQ_23,index:null});
			_smileysMap.put("#24",{name:"#24",src:BQ_24,index:null});
			_smileysMap.put("#25",{name:"#25",src:BQ_25,index:null});
			_smileysMap.put("#26",{name:"#26",src:BQ_26,index:null});
			_smileysMap.put("#27",{name:"#27",src:BQ_27,index:null});
			_smileysMap.put("#28",{name:"#28",src:BQ_28,index:null});
			_smileysMap.put("#29",{name:"#29",src:BQ_29,index:null});
			_smileysMap.put("#30",{name:"#30",src:BQ_30,index:null});
			_smileysMap.put("#31",{name:"#31",src:BQ_31,index:null});
			_smileysMap.put("#32",{name:"#32",src:BQ_32,index:null});
			_smileysMap.put("#33",{name:"#33",src:BQ_33,index:null});
			_smileysMap.put("#34",{name:"#34",src:BQ_34,index:null});
			
			
			MyTextOut._smileysMap = _smileysMap;
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

//			MyTextOut._giftsMap = _giftsMap;
		}
		override protected function addChildren():void{
			addChild(ui_RoomView);
			ui_RoomView.addChild(songInfoLay);
			
//			ui_RoomView.roomChat.addChildAt(privateChatView,0);
//			ui_RoomView.roomChat.addChildAt(publicChatView,0);
			chatViewPanel.addPlane(ChatViewPanelView.PANEL_1,publicChatView);
			chatViewPanel.addPlane(ChatViewPanelView.PANEL_2,privateChatView);
			
			ui_RoomView.roomChat.addChildAt(chatViewPanel,0);
			
			
			ui_RoomView.roomChat.addChildAt(watchChatView,0);
			ui_RoomView.roomChat.addChildAt(_mySongs_tileList,0);
			
			
			ui_GiftListView.x = (Main.KG_WIDTH - ui_GiftListView.width)/2;
			ui_GiftListView.y = (Main.KG_HEIGHT - ui_GiftListView.height)/2;
			ui_RoomView.addChild(ui_SendGiftView);
//			ui_RoomView.addChild(ui_ConfirmView);
			ui_RoomView.addChild(_myTileListUserInfoList);
			ui_RoomView.addChild(roomUserInfoTip);
			ui_RoomView.addChild(ui_GiftListView);
			ui_RoomView.addChild(ui_GiftTipView);
		}
		
		
		override protected function configEventListener():void{
			NetUntil.getInstance().addEventListener(AbsPlayerData.EVENT_PUSH_pushErrorConnection,commonEventHandler);
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushAddRoom,commonEventHandler);//广播玩家进入的消息
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushBroadCast,commonEventHandler);//广播玩家喇叭消息
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushErrorConnection,commonEventHandler);//广播连接状态
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushGiftMessage,commonEventHandler);//礼物消息
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushLevelRoom,commonEventHandler);//广播玩家离开消息
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushPrivateMessage,commonEventHandler);//私聊
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushPublicMessage,commonEventHandler);//公聊
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushSingerInRoom,commonEventHandler);//更新房间内的唱歌者信息
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushListenInRoom,commonEventHandler);//更新房间内的唱歌者信息
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushGetNotice,commonEventHandler);//公告处理
			_playerData.addEventListener(AbsPlayerData.EVENT_PUSH_pushStarUser,commonEventHandler);//房间内最高分信息
			
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_ListAllUser,commonEventHandler);//所有用户列表
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_ListGift,commonEventHandler);//礼物列表
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_ListSingerUser,commonEventHandler);//房间内唱歌用户列表
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_ListUser,commonEventHandler);//房间内观众列表
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_ListUserGift,commonEventHandler);//用户收到的礼物列表信息
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_ListUserSongs,commonEventHandler);//我（用户）的歌本
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_SendBroadCast,commonEventHandler);//发送广播信息
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_SendGift,commonEventHandler);//发送礼物
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_SendMessage,commonEventHandler);//发送信息
			
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_InitRoom,resInitAnotherRoomHandler);//在房间里面进入房间的处理函数
		
			_playerData.addEventListener(AbsPlayerData.EVENT_RES_UserInfo,commonEventHandler);//请求用户返回
		
			_playerData.addEventListener(UserEvent.USER_SELECT_CHAT,commonEventHandler);//玩家选中
			_playerData.addEventListener(UserEvent.USER_SELECT_PRESENT,commonEventHandler);//玩家选中
			
			
			_playerData.addEventListener(OperateSongEvent.EVENT_SING,commonEventHandler);//玩家选中
			_playerData.addEventListener(OperateSongEvent.EVENT_LISTEN,commonEventHandler);//玩家选中
		
			//用户列表切换按钮监听
			ui_RoomView.roomUserList.singerListBut.butBg.visible = true;
			ui_RoomView.roomUserList.userListBut.butBg.visible = false;
			ui_RoomView.roomUserList.pdphListBut.butBg.visible = false;
			
			ui_RoomView.roomUserList.singerListBut.addEventListener(MouseEvent.CLICK,singerListButHandel);
			ui_RoomView.roomUserList.userListBut.addEventListener(MouseEvent.CLICK,userListButHandel);

			ui_RoomView.roomUserList.pdphListBut.addEventListener(MouseEvent.CLICK,pdphListButHandel);//暂时不做
			
			//广播按钮监听
			ui_RoomView.broadCast.but_sendMessage.addEventListener(MouseEvent.CLICK,wantBroadCastButHandel);
			
			ButtonUtil.changeButton(ui_roomBroadCast.button_sendMessage).addEventListener(MouseEvent.CLICK,sendBroadCastMessage);
		
			//房间聊天信息
			ui_RoomView.roomChat.tb_publicChat.tb_bg.visible = true;
			ui_RoomView.roomChat.tb_gift.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_mySongs.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_watchSinger.tb_bg.visible = false;
		
			ui_RoomView.roomChat.tb_publicChat.addEventListener(MouseEvent.CLICK,publicChatButHandel);
			ui_RoomView.roomChat.tb_gift.addEventListener(MouseEvent.CLICK,giftButHandel);
			ui_RoomView.roomChat.tb_mySongs.addEventListener(MouseEvent.CLICK,mySongsButHandel);
			ui_RoomView.roomChat.tb_watchSinger.addEventListener(MouseEvent.CLICK,watchSingerButHandel);
		
			//消息发送
			ui_RoomView.roomChat.btn_sendChat.addEventListener(MouseEvent.CLICK,sendChatmessageHandel);
			//清屏
			ui_RoomView.roomChat.clearPrivateScreenBtn.addEventListener(MouseEvent.CLICK,clearScreenBtnHandel,false,0,true);
			ui_RoomView.roomChat.clearPublicScreenBtn.addEventListener(MouseEvent.CLICK,clearScreenBtnHandel,false,0,true);
			//显示表情
			ui_RoomView.roomChat.mc_popFace.addEventListener(MouseEvent.CLICK,smileyClickHandel);
			
			//礼物按钮
			ui_RoomView.roomChat.mc_popPresent.addEventListener(MouseEvent.CLICK,giftButClickHandel);
			
			//最大化
			ui_RoomView.btn_changeSizeBtn.addEventListener(MouseEvent.CLICK,changeSizeHandler);
			
			ui_RoomView.btn_backHall.addEventListener(MouseEvent.CLICK,backHallHandler);
			
			ui_RoomView.btn_singerInHall.addEventListener(MouseEvent.CLICK,startSingingHandler);
			
			ui_RoomView.roomChat.targetComboBox.addEventListener(Event.CHANGE,targetComboBoxSelectHandler);
			
			//礼物列表中的修改count
			ui_GiftListView.count.addEventListener(Event.CHANGE,changeTextHandel);
			
			ui_GiftListView.sendGift.addEventListener(MouseEvent.CLICK,sendGiftHandel);
			
			//礼物下上页
			ui_GiftListView.nextPage.addEventListener(MouseEvent.CLICK,giftnextPageHandel);
			ui_GiftListView.prePage.addEventListener(MouseEvent.CLICK,giftPrePageHandel);
			
			
			_starSingerTimer.addEventListener(TimerEvent.TIMER,timerHandler);
			
			//好友搜索
			ui_RoomView.roomUserList.search.tf_search.addEventListener(Event.CHANGE,searchRoomUserList);
//			ui_RoomView.roomUserList.search.tf_search.addEventListener(TextEvent.TEXT_INPUT,inputSearchRoomUserListHandler);
			ui_RoomView.roomUserList.search.tf_search.addEventListener(FocusEvent.FOCUS_IN,function(e:FocusEvent):void{ui_RoomView.roomUserList.search.tf_search.text = ""});
			ui_RoomView.roomUserList.search.tf_search.addEventListener(FocusEvent.FOCUS_OUT,function(e:FocusEvent):void{ui_RoomView.roomUserList.search.tf_search.text = "好友搜索"});
//			ui_RoomView.broadCast.enterRoom.addEventListener(MouseEvent.CLICK,broadCastRoomIdLindClickHandler);
			
			//发送礼物确认框
			//enter发送消息

			ui_RoomView.roomChat.tf_chatInput.addEventListener(KeyboardEvent.KEY_UP,keyUpHandel);
			//解决搜狗输入法冲突问题
			ui_RoomView.roomChat.tf_chatInput.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			
			
			chatViewPanel.addEventListener(ChatViewPanelView.DRAG_LINE_MOVE,dragLineMoveHandel);
		}
		private function dragLineMoveHandel(e:Event=null):void{
			if(ui_RoomView.roomChat.clearPublicScreenBtn){
				ui_RoomView.roomChat.clearPublicScreenBtn.y	= chatViewPanel.y+publicChatView.y+publicChatView.height-15;
			}
		}
		/**
		 * 输入字符搜索的时候
		 */ 
//		private function inputSearchRoomUserListHandler(e:TextEvent):void{
//			
//		}
		
		private var _enterInput:Boolean = false;
		private function textInputHandler(e:TextEvent):void{
			_enterInput = true;
		}

		private function keyUpHandel(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.ENTER && !_enterInput){
				sendChatmessageHandel();
			}
			_enterInput = false;
		}
		private function giftnextPageHandel(e:Event):void{
			page++;
			if(page>pcount){
				page = pcount;
			}
			for(var y:int =1;y<9;y++){
				MovieClip(ui_GiftListView["giftCell"+y]).gotoAndStop(1);
			}
			selectGift = null;
			_playerData.cs_ListGift(page);
		}
		private function giftPrePageHandel(e:Event):void{
			page--;
			if(page<=1){
				page =1;
			}
			for(var y:int =1;y<9;y++){
				MovieClip(ui_GiftListView["giftCell"+y]).gotoAndStop(1);
			}
			selectGift = null;
			_playerData.cs_ListGift(page);
		}
		//礼物列表界面中数量修改时调用的方法
		private function changeTextHandel(e:Event):void{
			var count:int = int(ui_GiftListView.count.selectedLabel);
			if(count<0){
				count = 0;
				ui_GiftListView.count.text = "0";
			}else if(count>111){
				count = 111;
				ui_GiftListView.count.selectedIndex = 4;
			}
			if(selectGift){
				ui_GiftListView.totalMoney.text = int(int(selectGift["price"])*int(ui_GiftListView.count.selectedLabel))+"K币";;
			}else{
				ui_GiftListView.totalMoney.text = "0K币";
			}
		}
		
		/**
		 * 频道开唱按钮事件处理
		 */ 
		private function startSingingHandler(e:MouseEvent):void{
			BaseInteract.baseStartSongCheck();
			if(isCurrentChangeSizeBig()){
				changeSizeSmall();
			}
		}
		
		private function searchRoomUserList(e:Event):void{
			
			var text:String = TextField(e.target).text;
			var dp:Array;
			_myTileListUserInfoList.dataProvider = new Array();
			
			if(text == "" || text == null){
//				dp = new DataProvider();
//				dp.addItems(_curAllRoomUserList);
				_myTileListUserInfoList.dataProvider = _curAllRoomUserList;	
				return;
			}
		
			dp = new Array();
			
			//搜索房间号 以及房间名
			for each(var item:Object in _curAllRoomUserList){
				var cell:RoomUserInfoCell = item as RoomUserInfoCell;
				if(cell.roomUserInfo.singInfo.text.search(text) != -1){
					dp.push(item);
				}
			}
			
			_myTileListUserInfoList.dataProvider = dp;
			
		}
		
		/**
		 * 星级歌手面板是否显示歌手信息
		 * 默认为不显示
		 * 不显示就显示为点击开唱部分
		 * 同时处理侦听项目
		 */ 
		private function starInfoShowStar(boolean:Boolean):void{
			if(boolean){
				ui_RoomView.starInfo.gotoAndStop(2);
				ui_RoomView.starInfo.mc_listenSong.visible = true;
				ui_RoomView.starInfo.mc_sendPresent.visible = true;
				ui_RoomView.starInfo.mc_chat.visible = true;
				ButtonUtil.changeButton(ui_RoomView.starInfo.mc_listenSong);
				ButtonUtil.changeButton(ui_RoomView.starInfo.mc_sendPresent);
				ButtonUtil.changeButton(ui_RoomView.starInfo.mc_chat);
				//收听的鼠标事件
				if(!ui_RoomView.starInfo.mc_listenSong.hasEventListener(MouseEvent.CLICK)){
					ui_RoomView.starInfo.mc_listenSong.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
						if(_currentStarUserResObj != null && _currentStarUserResObj.uid == _playerData.playerObj["uid"]){
							
							var errorViewResSendMessage:ErrorView = new ErrorView("不能收听自己歌曲",null);
							addChild(errorViewResSendMessage);
							return;
						}
						BaseInteract.baseStartListen(_currentStarUserResObj.uid);
						focusInWatchSinger()});
				}
				//添加送礼物鼠标点击事件
				if(!ui_RoomView.starInfo.mc_sendPresent.hasEventListener(MouseEvent.CLICK)){
					ui_RoomView.starInfo.mc_sendPresent.addEventListener(MouseEvent.CLICK,
						function(e:MouseEvent):void{
//							selectTargetComboBoxByUID(_currentStarUserResObj.uid);
							_sendGifTargetUID = _currentStarUserResObj.uid;
							_sendGifTargetName = _currentStarUserResObj.uname;
//							ui_RoomView.roomChat.mc_popPresent.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
							giftButClickHandel();
						});
				}
				
				if(!ui_RoomView.starInfo.mc_chat.hasEventListener(MouseEvent.CLICK)){
					ui_RoomView.starInfo.mc_chat.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
						
						ui_RoomView.roomChat.cb_isPrivateChat.selected = false;
						selectTargetComboBoxByUID(_currentStarUserResObj.uid);
						focusInChat();
					});
				}
			}else{
				
				_starSingerTimer.stop();
				_starSingerTimer.reset();
				ui_RoomView.starInfo.tf_title.text = "";
				ui_RoomView.starInfo.tf_singerName.text = "";
				ui_RoomView.starInfo.tf_songName.text = "";
				ui_RoomView.starInfo.loader_userImg.source = null;
				ui_RoomView.starInfo.mc_listenSong.visible = false;
				ui_RoomView.starInfo.mc_sendPresent.visible = false;
				ui_RoomView.starInfo.mc_chat.visible = false;
				ui_RoomView.starInfo.gotoAndStop(1);
				if(!ui_RoomView.starInfo.btn_clickToSing.hasEventListener(MouseEvent.CLICK)){
					ui_RoomView.starInfo.btn_clickToSing.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
//						BaseInteract.baseStartSing(_currentStarUserResObj.songsId);
						BaseInteract.baseStartSongCheck();
						if(isCurrentChangeSizeBig()){
							changeSizeSmall();
						}
					})
				}
				_currentStarUserResObj = null;
				
			}
		}
		
		/**
		 * 用来侦听星级歌手的信息的动作
		 */ 
		private function timerHandler(e:TimerEvent):void{
			_curStarUserSingTime++;
//			if(_currentStarUserResObj == null || _curStarUserSingTime >= _currentStarUserResObj.songsTime){
//				_starSingerTimer.stop();
//				starInfoShowStar(false);
//				_curStarUserSingTime = 0;
//				return;
//			}
			if(ui_RoomView.starInfo.currentFrame == 2 && _currentStarUserResObj != null){
				ui_RoomView.starInfo.mc_songInfoProgressBar.gotoAndStop(Math.round(_curStarUserSingTime / _currentStarUserResObj.songsTime*100));
			}
			
			if(UModelLocal.getInstance().debug == 0){
				if(Math.round(_curStarUserSingTime / _currentStarUserResObj.songsTime*100) == 100){
//					starInfoShowStar(false);
					NetUntil.getInstance().send("{jsessionid:711857534_browser_sessionid,method:EndSing,sid:" + _currentStarUserResObj.songsId+",singTime:0,songsTime:180,score:0,songsName:爱我别走,songsSinger:张震 岳}");
					trace("{jsessionid:711857534_browser_sessionid,method:EndSing,sid:" + _currentStarUserResObj.songsId+",singTime:0,songsTime:180,score:0,songsName:爱我别走,songsSinger:张震 岳}");

				}
			}
			
		}
		
//		private function timerCompleteHandler(e:TimerEvent):void{
//			
//		}
		
		private function backHallHandler(e:MouseEvent):void{
			ConfirmView.show("确定返回大厅吗?",ViewHelper._main,backHallHandler2,e,true);
		}
		private function backHallHandler2(e:MouseEvent):void{
			BaseInteract.baseLeaveRoom(_roomId);
			_playerData.cs_LevelRoom();
			var disObj:DisplayObject = ViewHelper.navigate(ViewRegister.ROOM_VIEW,ViewRegister.HALL_VIEW,ViewHelper._main) as DisplayObject;
			disObj.x += 10;
		}
		private function sendGiftHandel(e:Event):void{
//			var count:int = int(ui_GiftListView.count.text);
//			var giftId:int = selectGift["giftId"];
//			var giftName:String = selectGift["title"];
////			var uid:int = ui_RoomView.roomChat.targetComboBox.selectedItem.data;
//			var uname:String = _sendGifTargetName;
//			
//			ui_SendGiftView.visible = true;
//			ui_GiftListView.visible = false;
//			
//			ui_SendGiftView.targetName.text=uname;
//			ui_SendGiftView.context.text=count+"个"+giftName+"吗?";
//			if(!ui_SendGiftView.button_sendGift.hasEventListener(MouseEvent.CLICK)){
//				ui_SendGiftView.button_sendGift.addEventListener(MouseEvent.CLICK,function sendGiftHandelFinal(e:Event):void{
//					_playerData.cs_SendGift(_sendGifTargetUID,selectGift["giftId"],int(ui_GiftListView.count.text));
//					ui_SendGiftView.visible = false;
//				});
//			}
			if(!selectGift){
				return;
			}
			_playerData.cs_SendGift(_sendGifTargetUID,selectGift["giftId"],int(ui_GiftListView.count.text));
			ui_SendGiftView.visible = false;
			ui_GiftListView.visible = false;
		}
//		private function showBroadCastMessage(e:Event):void{
//			ui_roomBroadCast.visible = false;
//			ui_ConfirmView.visible = true;
////			ui_SendGiftView.context.text="发送喇叭需要消耗1K币,确定要发送吗?";
//			if(!ui_ConfirmView.button_send.hasEventListener(MouseEvent.CLICK)){
//				ui_ConfirmView.button_send.addEventListener(MouseEvent.CLICK,function sendHandelFinal(e:Event):void{
//					sendBroadCastMessage();
//					ui_ConfirmView.visible = false;
//				});
//			}
//		}
		
		
		/**
		 * 当前的状态是放大状态吗
		 * true表示为放大状态
		 */ 
		private function isCurrentChangeSizeBig():Boolean{
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 1){
				return false;
			}
			
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 2){
				return true;	
			}
			return true;
		}
		/**
		 *
		 * 将当前的放大的面板缩小
		 * 
		 */ 
		private function changeSizeSmall():void{
			ui_RoomView.btn_changeSizeBtn.gotoAndStop(1);
			ui_RoomView.mc_mainRoomInfoFrameBg.gotoAndStop(1);
			ui_RoomView.broadCast.y += _changeHeight;
			ui_RoomView.roomChat.tb_publicChat.y += _changeHeight;
			ui_RoomView.roomChat.tb_gift.y += _changeHeight;
			ui_RoomView.roomChat.tb_mySongs.y += _changeHeight;
			ui_RoomView.roomChat.tb_watchSinger.y += _changeHeight;
			if(ui_RoomView.roomChat.mc_dragLine != null){
				ui_RoomView.roomChat.mc_dragLine.y = 110;
			}
//			ui_RoomView.btn_backHall.y += _changeHeight;
//			ui_RoomView.btn_singerInHall.y += _changeHeight;
			ui_RoomView.roomUserList.y += _changeHeight;
			_myTileListUserInfoList.y    += _changeHeight;
			ui_RoomView.btn_changeSizeBtn.y += _changeHeight;
//			if(ui_RoomView.roomChat.clearPublicScreenBtn != null){
//				ui_RoomView.roomChat.clearPublicScreenBtn.y += 50;
//			}
//			privateChatView.y                  = 123;  
//			publicChatView.y                   = 24;
			watchChatView.y                    = 24;
			chatViewPanel.y = 24;
			watchChatView.height			   = 175;
			chatViewPanel.height = 175;
//			publicChatView.height              = 86; 
//			privateChatView.height                  = 81; 
			
			roomUserInfoTip.roomUserInfoTipBaseY = 390;
			if(ui_RoomView.roomChat.tileList_gift != null){
				ui_RoomView.roomChat.tileList_gift.y += _changeHeight;
				ui_RoomView.roomChat.tileList_gift.height = 175;
			}
			
			if(ui_RoomView.roomChat.mysongs_tilelistHead != null){
				ui_RoomView.roomChat.mysongs_tilelistHead.y += _changeHeight;
			}
			if(_mySongs_tileList !=null){
				_mySongs_tileList.y     += _changeHeight;
				_mySongs_tileList.height = 150;
			}
			if(_myTileListUserInfoList){
				_myTileListUserInfoList.height = 185;
			}
		}
		
		
		
		/**
		 * 将当前的缩小的面板放大
		 */ 
		private function changeSizeBig():void{
			ui_RoomView.btn_changeSizeBtn.gotoAndStop(2);
			ui_RoomView.broadCast.y -= _changeHeight;
			ui_RoomView.roomChat.tb_publicChat.y -= _changeHeight;
			ui_RoomView.roomChat.tb_gift.y -= _changeHeight;
			ui_RoomView.roomChat.tb_mySongs.y -= _changeHeight;
			ui_RoomView.roomChat.tb_watchSinger.y -= _changeHeight;
			if(ui_RoomView.roomChat.mc_dragLine != null){
				ui_RoomView.roomChat.mc_dragLine.y = 60;
			}
//			ui_RoomView.btn_backHall.y -= _changeHeight;
//			ui_RoomView.btn_singerInHall.y -= _changeHeight;
			ui_RoomView.roomUserList.y -= _changeHeight;
			_myTileListUserInfoList.y    -= _changeHeight;
			ui_RoomView.btn_changeSizeBtn.y -= _changeHeight;
			ui_RoomView.mc_mainRoomInfoFrameBg.gotoAndStop(2);
//			if(ui_RoomView.roomChat.clearPublicScreenBtn != null){
//				ui_RoomView.roomChat.clearPublicScreenBtn.y -= 50;
//			}
//			privateChatView.y                    = 79;  
//			publicChatView.y                     = -185;   
			chatViewPanel.y = -185;
			watchChatView.y                      = -185;
			watchChatView.height			     = 385;
//			publicChatView.height                = 247; 
//			privateChatView.height               = 127; 
			chatViewPanel.height = 385;
			
			if(_myTileListUserInfoList){
				_myTileListUserInfoList.height = 390;
			}
			roomUserInfoTip.roomUserInfoTipBaseY = 390-roomUserInfoTip.cellUserInfoHight;
			if(ui_RoomView.roomChat.tileList_gift != null){
				ui_RoomView.roomChat.tileList_gift.y -= _changeHeight;
				ui_RoomView.roomChat.tileList_gift.height = 385;
			}
			
			if(ui_RoomView.roomChat.mysongs_tilelistHead != null){
				ui_RoomView.roomChat.mysongs_tilelistHead.y -= _changeHeight;
				_mySongs_tileList.y     -= _changeHeight;
				_mySongs_tileList.height = 360;
			}
			
			
			roomUserInfoTip.visible = false;
			return;
		}
		private function changeSizeHandler(e:MouseEvent):void{
			if(isCurrentChangeSizeBig()){
				changeSizeSmall();
			}else{
				changeSizeBig();
			}
			dragLineMoveHandel();
		}
		
		private function clearScreenBtnHandel(e:Event):void{
			
			switch(e.target){
				case ui_RoomView.roomChat.clearPrivateScreenBtn:
					privateChatView.cleanAll();			
					break;
				case ui_RoomView.roomChat.clearPublicScreenBtn:
					publicChatView.cleanAll();
					break;
			}
		}
		private function sendChatmessageHandel(e:Event=null):void{
			var isPrivate:int = 0;
			if(ui_RoomView.roomChat.cb_isPrivateChat.selected){
				isPrivate = 1;
			}else{
				isPrivate = 0;
			}
			trace("isPrivate"+isPrivate);
			_playerData.cs_SendMessage("'"+ui_RoomView.roomChat.tf_chatInput.text+"'",ui_RoomView.roomChat.targetComboBox.selectedItem["data"],isPrivate);
			ui_RoomView.roomChat.tf_chatInput.text = "";
			//ui_RoomView.roomChat.targetComboBox.selectedItem.data
			
		}
		private function publicChatButHandel(e:Event):void{
			_smileyContainer.visible = false; 
		
			ui_RoomView.roomChat.tb_publicChat.tb_bg.visible = true;
			ui_RoomView.roomChat.tb_gift.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_mySongs.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_watchSinger.tb_bg.visible = false;
			ui_RoomView.roomChat.gotoAndStop(1);
			if(ui_RoomView.roomChat.clearPublicScreenBtn){
				ui_RoomView.roomChat.clearPublicScreenBtn.buttonMode = true;
			}
			if(ui_RoomView.roomChat.clearPrivateScreenBtn){
				ui_RoomView.roomChat.clearPrivateScreenBtn.buttonMode = true;
			}
//			_scrollPanePrivate.visible = true;
//			_scrollPanePublic.visible = true;
//			_scrollPaneWatch.visible = false;
//			ButtonUtil.changeButton(ui_RoomView.roomChat.clearPublicScreenBtn);
//			ButtonUtil.changeButton(ui_RoomView.roomChat.clearPrivateScreenBtn);
			
			if(!ui_RoomView.roomChat.clearPrivateScreenBtn.hasEventListener(MouseEvent.CLICK)){
				ui_RoomView.roomChat.clearPrivateScreenBtn.addEventListener(MouseEvent.CLICK,clearScreenBtnHandel,false,0,true);
			}
			
			if(ui_RoomView.roomChat.clearPublicScreenBtn){
				if(!ui_RoomView.roomChat.clearPublicScreenBtn.hasEventListener(MouseEvent.CLICK)){
					ui_RoomView.roomChat.clearPublicScreenBtn.addEventListener(MouseEvent.CLICK,clearScreenBtnHandel,false,0,true);
				}
			}
			
//			privateChatView.visible = true;
//			publicChatView.visible = true;
			chatViewPanel.visible = true;
			watchChatView.visible = false;
			_mySongs_tileList.visible = false;

			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 1){
//				ui_RoomView.roomChat.mc_dragLine.y = 110;
//				privateChatView.y                  = 123; 
//				publicChatView.y                   = 24;
//				publicChatView.height              = 86; 
//				privateChatView.height             = 81; 
				
				chatViewPanel.y = 24;
				chatViewPanel.height = 167;
				
//				ui_RoomView.roomChat.clearPublicScreenBtn.y = 89.6;
			}
			
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 2){
//				ui_RoomView.roomChat.mc_dragLine.y = 60;
				
//				privateChatView.y                  = 79;  
//				publicChatView.y                   = -185;
//				publicChatView.height                = 247; 
//				privateChatView.height               = 127; 
				chatViewPanel.y = -185;
				chatViewPanel.height = 374;
//				ui_RoomView.roomChat.clearPublicScreenBtn.y = 89.6 - 50;
			}
			
		}
		private function giftButHandel(e:Event):void{
			_smileyContainer.visible = false;
			
			ui_RoomView.roomChat.tb_publicChat.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_gift.tb_bg.visible = true;
			ui_RoomView.roomChat.tb_mySongs.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_watchSinger.tb_bg.visible = false;
			
//			_scrollPanePrivate.visible = false;
//			_scrollPanePublic.visible = false;
//			_scrollPaneWatch.visible = false;
			
//			privateChatView.visible = false;
//			publicChatView.visible = false;
			chatViewPanel.visible = false;
			
			watchChatView.visible = false;
			_mySongs_tileList.visible = false;
			
			ui_RoomView.roomChat.gotoAndStop(2);
			_playerData.cs_ListUserGift(uid);
			
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 1){
				ui_RoomView.roomChat.tileList_gift.y = 22;
			}
			
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 2){
				ui_RoomView.roomChat.tileList_gift.y = 22 - _changeHeight;
			}
		}
		private function mySongsButHandel(e:Event):void{
			_smileyContainer.visible = false;
			
			ui_RoomView.roomChat.tb_publicChat.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_gift.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_mySongs.tb_bg.visible = true;
			ui_RoomView.roomChat.tb_watchSinger.tb_bg.visible = false;
			ui_RoomView.roomChat.gotoAndStop(3);
//			_scrollPanePrivate.visible = false;
//			_scrollPanePublic.visible = false;
//			_scrollPaneWatch.visible = false;
			
			_mySongs_tileList.visible = true;
//			privateChatView.visible = false;
//			publicChatView.visible = false;
			chatViewPanel.visible = false;
			watchChatView.visible = false;
			
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 1){
				_mySongs_tileList.y = 48.35;
				ui_RoomView.roomChat.mysongs_tilelistHead.y = 24.15;
			}
			
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 2){
				_mySongs_tileList.y = 48.35 - _changeHeight;
				ui_RoomView.roomChat.mysongs_tilelistHead.y = 24.15 - _changeHeight;
			}
			_playerData.cs_ListUserSongs(uid);
		}
		private function watchSingerButHandel(e:Event):void{
			_smileyContainer.visible = false;
			
			ui_RoomView.roomChat.tb_publicChat.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_gift.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_mySongs.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_watchSinger.tb_bg.visible = true;
//			_scrollPanePrivate.visible = true;
//			_scrollPanePublic.visible = false;
//			_scrollPaneWatch.visible = true;
			
//			privateChatView.visible = false;
//			publicChatView.visible = false;
			chatViewPanel.visible = false;
			watchChatView.visible = true;
			_mySongs_tileList.visible = false;
			
			ui_RoomView.roomChat.gotoAndStop(4);
			if(ui_RoomView.roomChat.clearScreenBtn){
				ui_RoomView.roomChat.clearScreenBtn.buttonMode = true;
			}
			if(!ui_RoomView.roomChat.clearScreenBtn.hasEventListener(MouseEvent.CLICK)){
				ui_RoomView.roomChat.clearScreenBtn.addEventListener(MouseEvent.CLICK,clearWatchSingerScreenHandler);
			}
			
		}
		/**
		 * 清除关注主播聊天框信息
		 */ 
		private function clearWatchSingerScreenHandler(e:MouseEvent):void{
			watchChatView.cleanAll();
		}
		
		
		
		private function initBroadCastView():void{
			ButtonUtil.changeButton(ui_roomBroadCast.button_cancal).addEventListener(MouseEvent.CLICK,function cancalHandel(e:Event):void{
				if(ui_roomBroadCast.parent){
					ui_roomBroadCast.parent.removeChild(ui_roomBroadCast);
				}
			});
		}
		private function initSendGiftView():void{
			ui_SendGiftView.visible = false;
			
			ui_SendGiftView.x = 300;
			ui_SendGiftView.y = 300;
			
			ButtonUtil.changeButton(ui_SendGiftView.button_cancal).addEventListener(MouseEvent.CLICK,function cancalHandel(e:Event):void{
				ui_SendGiftView.visible = false;
			});
		}
//		private function initConfirmView():void{
//			ui_ConfirmView.visible = false;
//			
//			ui_ConfirmView.x = 250;
//			ui_ConfirmView.y = 220;
//			
//			ButtonUtil.changeButton(ui_ConfirmView.button_cancal).addEventListener(MouseEvent.CLICK,function cancalHandel(e:Event):void{
//				ui_ConfirmView.visible = false;
//			});
//		}
		
		
		private function initGiftListView():void{
			ui_GiftListView.x = 250;
			ui_GiftListView.y = 240;
			ui_GiftListView.visible = false;
			
			ButtonUtil.changeButton(ui_GiftListView.button_cancal).addEventListener(MouseEvent.CLICK,function cancalHandel(e:Event):void{
				ui_GiftListView.visible = false;
			});
		}
		private function wantBroadCastButHandel(e:Event):void{
			PlayerData.getInstance().cs_UserInfo(uid);
			
			ui_roomBroadCast.needCost.text = _playerData.broadCastPrice+"";
			ui_roomBroadCast.kmoney.text = _playerData.playerObj.kmoney+"";
			
			ui_roomBroadCast.text_broadCastContext.text = "";
			ui_roomBroadCast.visible = true;
			addChild(ui_roomBroadCast);
		}
		private function sendBroadCastMessage(e:Event=null):void{
			var sendValue:int = ui_roomBroadCast.isAddRoomLink.selected?1:0;
			_playerData.cs_SendBroadCast(RegExpTool.deleteLineChanger(ui_roomBroadCast.text_broadCastContext.text),sendValue);
			if(ui_roomBroadCast.parent){
				removeChild(ui_roomBroadCast);
			}
		}
		//刷新唱歌歌者列表
		private function singerListButHandel(e:Event=null):void{
			ui_RoomView.roomUserList.singerListBut.butBg.visible = true;
			ui_RoomView.roomUserList.userListBut.butBg.visible = false;
			ui_RoomView.roomUserList.pdphListBut.butBg.visible = false;
			ui_RoomView.roomUserList.gotoAndStop(1);
			_curRoomUserType = ROOM_USER_TYPE_SINGER;
			refreshRoomUser();
//			_playerData.cs_ListSingerUser(_roomId);
		}
		//刷新观众列表
		private function userListButHandel(e:Event=null):void{
			ui_RoomView.roomUserList.singerListBut.butBg.visible = false;
			ui_RoomView.roomUserList.userListBut.butBg.visible = true;
			ui_RoomView.roomUserList.pdphListBut.butBg.visible = false;
//			ui_RoomView.roomUserList.gotoAndStop(2);
			_curRoomUserType = ROOM_USER_TYPE_VIEWER;
			refreshRoomUser();
//			_playerData.cs_ListUser(_roomId);
		}
		private function pdphListButHandel(e:Event):void{
			ui_RoomView.roomUserList.singerListBut.butBg.visible = false;
			ui_RoomView.roomUserList.userListBut.butBg.visible = false;
			ui_RoomView.roomUserList.pdphListBut.butBg.visible = false;
			ui_RoomView.roomUserList.gotoAndStop(3);
			refreshRoomUser();
		}
		private function showSongInfoHandel(songInfo:SongInfoLayCell,singer:Object,key:String):void{
			songInfoLay.isViewingMap.put(key,singer);
//			trace("显示位置:"+key+"  uname:"+singer.uname);
			songInfo.setUser(singer);
		}
		
		private function viewSinger(e:Event):void{
			if(noViewUserArray.length == 0){
				noViewUserArray = getSingerList();
			}
			//如果没有人,则
			
			var singer1:Object= shiftNoViewUser();
			if(!singer1){
				return;
			}
			if(songInfoLay.addDataSongInfo(singer1)){
				return;
			}
			showSongInfoHandel(songInfoLay.songInfoBuf1,singer1,songInfoLay.key);
			
			var singer2:Object = shiftNoViewUser();
			if(singer2){
//				songInfoLay.isViewingMap.put(songInfoLay.key2,singer2);
//				songInfoLay.songInfoBuf2.tf_songInfo.text = singer2.uname+"--"+singer2.songsName;
//				songInfoLay.songInfoBuf2.mc_songInfoProgressBar.gotoAndStop(Math.round(singer2.singerTime / singer2.songsTime*100));
//				
//				TweenLite.to(songInfoLay.songInfoBuf2.mc_songInfoProgressBar, singer2.songsTime-singer2.singerTime, {frame:100});
//				songInfoLay.songInfoBuf2.userStuats.visible = true;
//				if(singer2.micStatus == 1){
//					songInfoLay.songInfoBuf2.userStuats.gotoAndStop(2);
//				}else{
//					songInfoLay.songInfoBuf2.userStuats.gotoAndStop(1);
//				}
				showSongInfoHandel(songInfoLay.songInfoBuf2,singer2,songInfoLay.key2);
			}else{
				songInfoLay.songInfoBuf2.setNoUser();
			}
			songInfoLay.updateSongInfo();
			
		}
		private function shiftNoViewUser():Object{
			for(var i:int=0;i<noViewUserArray.length;i++){
				var obj:Object = noViewUserArray.shift();
				if(!songInfoLay.isViewing(obj)){
					return obj;
				}
			}
			return null;
		}
		
		private function refershTimer():void{
			if(noViewUserArray.length == 0){
				noViewUserArray = getSingerList();
			}
			if(noViewUserArray.length!=0&&!timer.running){
				timer.start();
				timer.addEventListener(TimerEvent.TIMER,viewSinger);
			}
		}
		
		
		private function removeNoViewUserArray(uid:int):void{
			var newArray:Array = new Array();
			for each(var obj:Object in noViewUserArray){
				if(obj != null && obj.uid != uid ){
					newArray.push(obj);
				}
			}
			noViewUserArray = newArray;
		}
		private function isNoViewUserArrayContain(uid:int):Boolean{
			for each(var obj:Object in noViewUserArray){
				if(obj != null && obj.uid == uid ){
					return true;
				}
			}
			return false;
		}
		private var _mySongs_tileList:MyTileList = new MyTileList();
		private function refershMySongs(obj:Object):void{
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 1){
				_mySongs_tileList.height = 150;
			}else if (ui_RoomView.btn_changeSizeBtn.currentFrame == 2){
				_mySongs_tileList.height = 360;
			}
			var songsList :Array = new Array();
			var i:int =0;
			for each (var songCell:Object in obj.songList){
				i++;
				var mySongCellView: MySongCellView = new MySongCellView(songCell);
				
				mySongCellView.ui_MySongCell.songsId.text = i+"";
				songsList.push(mySongCellView);
			}
			_mySongs_tileList.dataProvider = songsList;	
		}
		private function refershUserGift(obj:Object):void{
			if(!ui_RoomView.roomChat.tileList_gift){
				return;
			}
			if(ui_RoomView.btn_changeSizeBtn.currentFrame == 1){
				ui_RoomView.roomChat.tileList_gift.height = 175;
			}else if (ui_RoomView.btn_changeSizeBtn.currentFrame == 2){
				ui_RoomView.roomChat.tileList_gift.height = 385;
			}
			var roomList :DataProvider = new DataProvider();
			for each (var giftCell:Object in obj.giftList){
				var item:Object = new Object();
				var roomGiftCell: mc_RoomGiftCell = new mc_RoomGiftCell();
				roomGiftCell.senderName.text = giftCell.sendUname;
				roomGiftCell.giftCount.text = giftCell.count;
				if(giftCell.imgUrl&&giftCell.imgUrl!=""){
					GiftCellViewUtil.addGift2UserGiftList(215,0,roomGiftCell,giftCell);
				}
				item["source"]=roomGiftCell; 
				roomList.addItem(item);
			
			}
			ui_RoomView.roomChat.tileList_gift.columnWidth=472;
			ui_RoomView.roomChat.tileList_gift.rowHeight = 50;
			ui_RoomView.roomChat.tileList_gift.dataProvider = roomList;	
		}
		
		/**
		 * 当广播的时候，如果广播内容附带了roomId那么进入该房间
		 */ 
		private function broadCastRoomIdLindClickHandler(e:MouseEvent):void{
			if(broadCastMessageArray != null && broadCastMessageArray.length > 0){
				var roomId:int = broadCastMessageArray[0]["roomId"];
				if(roomId < 0){
					return;
				}
				
				_playerData.cs_InitRoom(broadCastMessageArray[0]["roomId"]);
				
			}
		} 
		private function closeApplictionHandel(e:Event):void{
			BaseInteract.cancelRadioSocket();
		}
		public function commonEventHandler( e:Event):void {
			switch (e.type) {
				case AbsPlayerData.EVENT_PUSH_pushAddRoom:
//					CommonEvent(e).data["isLevel"] = false;
					var data:Object = CommonEvent(e).data;
					publicChatView.addMessage(MyTextOut.ROOM_MESSAGE,data);
					_allPlayerUserMap.put(data.uid,data);
					refreshRoomUser();
					break;
				case AbsPlayerData.EVENT_PUSH_pushBroadCast:
					var broadCastObj:Object		=  CommonEvent(e).data;
					broadCastMessageArray.push(broadCastObj);
					refershBroadCastTimer();
					break;
				case AbsPlayerData.EVENT_PUSH_pushErrorConnection:
 					var errorContext:String = "你已经和服务器断开连接.";
					if(CommonEvent(e).data){
						errorContext = CommonEvent(e).data.content
						var errorViewResSendMessage:ErrorView = new ErrorView(errorContext,closeApplictionHandel);
						addChild(errorViewResSendMessage);
					}
					break;
				case AbsPlayerData.EVENT_PUSH_pushGiftMessage:
					var object:Object = CommonEvent(e).data;
					var count:int = object["count"];
					for( var i:int;i<count;i++){
						object["nowCount"] = i+1;
						publicChatView.addMessage(MyTextOut.GIFT_MESSAGE,object);
						if(CommonEvent(e).data["follow"] == 1){
							watchChatView.addMessage(MyTextOut.GIFT_MESSAGE,object);
						}
					}
					break;
				case AbsPlayerData.EVENT_PUSH_pushLevelRoom:
					CommonEvent(e).data["isLevel"] = true;
					publicChatView.addMessage(MyTextOut.ROOM_MESSAGE,CommonEvent(e).data);
					
//					var levelRoomObj:Object = new Object();
//					if(!_roomId == levelRoomObj.roomId){
//						return;
//					}
					_allPlayerUserMap.remove(CommonEvent(e).data["uid"]);
					removeNoViewUserArray(CommonEvent(e).data["uid"]);
					refreshRoomUser();
					
					songInfoLay.levelHandel(CommonEvent(e).data)
					
					break;
				case AbsPlayerData.EVENT_PUSH_pushPrivateMessage:
					privateChatView.addMessage(MyTextOut.PRIVATE_MESSAGE,CommonEvent(e).data);
					if(CommonEvent(e).data["follow"] == 1){
						privateChatView.addMessage(MyTextOut.PRIVATE_MESSAGE,CommonEvent(e).data);
					}
					focusInChat();
					break;
				case AbsPlayerData.EVENT_PUSH_pushPublicMessage:
					publicChatView.addMessage(MyTextOut.PUBLIC_MESSAGE,CommonEvent(e).data);
					if(CommonEvent(e).data["follow"] == 1){
						watchChatView.addMessage(MyTextOut.PUBLIC_MESSAGE,CommonEvent(e).data);
					}
					break;
				case AbsPlayerData.EVENT_PUSH_pushSingerInRoom:
				
					var status:int = CommonEvent(e).data.status;
					var uid:int = CommonEvent(e).data.uid;
					
					object = _allPlayerUserMap.getValue(uid);
					if(object == null){
						return;
					}
					
					object.status  =  status;
					object.songsId =  CommonEvent(e).data.songsId;
					object.songsName  =  CommonEvent(e).data.songsName;
					object.songsSinger  =  CommonEvent(e).data.songsSinger;
					object.singerTime  =  CommonEvent(e).data.singerTime;
					object.songsTime  =  CommonEvent(e).data.songsTime;
					object.score  =  CommonEvent(e).data.score;
					object.endTimestp  =  CommonEvent(e).data.endTimestp;
					object.created  =  CommonEvent(e).data.created;
					
					
					if(status == 1){//结束唱歌
						publicChatView.addMessage(MyTextOut.STOP_SINGING_MESSAGE,CommonEvent(e).data);
						if(CommonEvent(e).data["follow"] == 1){
							watchChatView.addMessage(MyTextOut.STOP_SINGING_MESSAGE,CommonEvent(e).data);
							focusInWatchSinger();
						}
						removeNoViewUserArray(uid);
//						object["songsId"]   = 0;	
						
//						if(allSingerUserMap.containsKey(uid)){
//							allSingerUserMap.remove(uid);
//						}
						//如果结束唱歌的人是星级歌手，视图转到点击开唱界面
						if(_currentStarUserResObj != null && uid == _currentStarUserResObj.uid){
							
							
//							if(objStarUser.singerTime < objStarUser.songsTime){
//								_starSingerTimer.reset();
//								_starSingerTimer.stop();
//							}
							
//							ui_RoomView.starInfo.userStatus.gotoAndStop(1);
							starInfoShowStar(false);
						}
//						if(uid == _playerData.playerObj["uid"]){//如果我结束了唱那么关注
//							ui_RoomView.roomChat.tb_watchSinger.visible = false;
//						}
						
						//结束星级唱歌信息的处理
						songInfoLay.levelHandel(CommonEvent(e).data)
					}else{//开始唱歌
						
						publicChatView.addMessage(MyTextOut.START_SINGING_MESSAGE,CommonEvent(e).data);
						if(CommonEvent(e).data["follow"] == 1){
							watchChatView.addMessage(MyTextOut.START_SINGING_MESSAGE,CommonEvent(e).data);
							focusInWatchSinger();
						}
						if(!isNoViewUserArrayContain(CommonEvent(e).data.uid)){
							noViewUserArray.push(CommonEvent(e).data);
						}
//						if(!allSingerUserMap.containsKey(uid)){
//							allSingerUserMap.put(uid,CommonEvent(e).data);
//						}
//						object["songsId"] = CommonEvent(e).data.songsId;
					}
//					updateRoomUserByUID(uid);
//					_allPlayerUserMap.put(uid,CommonEvent(e).data);
					refreshRoomUser();
					refershTimer();
					break;
				case AbsPlayerData.EVENT_PUSH_pushListenInRoom:
					publicChatView.addMessage(MyTextOut.START_LISTEN_MESSAGE,CommonEvent(e).data);
					if(CommonEvent(e).data["follow"] == 1){
						watchChatView.addMessage(MyTextOut.START_LISTEN_MESSAGE,CommonEvent(e).data);
						focusInWatchSinger();
					}
					
					break;
				case AbsPlayerData.EVENT_PUSH_pushGetNotice:
					privateChatView.addMessage(MyTextOut.NOTICE_MESSAGE,CommonEvent(e).data);
					watchChatView.addMessage(MyTextOut.START_LISTEN_MESSAGE,CommonEvent(e).data);
					break;
				case AbsPlayerData.EVENT_RES_ListAllUser://把所有房间的人列举出来并且默认将列表显示为正在唱歌的人
					var listAllUserData:Object = CommonEvent(e).data.userList;
					_allPlayerUserMap.clear();
					for each(var objItem:Object in listAllUserData){
						_allPlayerUserMap.put(objItem.uid,objItem);
					}
					refreshRoomUser();
					refershTimer();
					if(UModelLocal.getInstance().debug == 0){
						NetUntil.getInstance().send("{jsessionid:711857534_browser_sessionid,method:StartSing,sid:1,singTime:0,songsTime:180,score:0,songsName:爱我别走,songsSinger:张震 岳}");
					}
					//公聊信息
					break;
				case AbsPlayerData.EVENT_RES_ListGift:
					viewGiftList(CommonEvent(e).data);
					break;
				case AbsPlayerData.EVENT_RES_ListSingerUser:
//					var listSingerUserData:Object = CommonEvent(e).data.listUser;
//					allSingerUserMap.clear();
//					var lcount:int = 0;
//					for each(var objItem:Object in listSingerUserData){
//						allSingerUserMap.put(objItem.uid,objItem);
//						lcount++;
//					}
//					refershTimer();
//					refershRoomUser(allSingerUserMap.values());
					//公聊信息
//					ui_RoomView.roomUserList.singerListBut.tf_singerList.text = "唱歌("+lcount+")";
					break;
				case AbsPlayerData.EVENT_RES_ListUser:
//					var data:Array = CommonEvent(e).data.listUser as Array;
//					refershRoomUser(data);
//					ui_RoomView.roomUserList.userListBut.tf_userList.text = "观众("+(data==null?0:data.length)+")";
					break;
				case AbsPlayerData.EVENT_RES_ListUserGift:
					refershUserGift(CommonEvent(e).data);
					break;
				case AbsPlayerData.EVENT_RES_ListUserSongs:
//					trace(e.data.songsId);
//					trace(e.data.songsName);
//					trace(e.data.songsSinger);
					refershMySongs(CommonEvent(e).data);
					break;
				case AbsPlayerData.EVENT_RES_SendBroadCast:
					var statusResSendBroadCast:int = CommonEvent(e).data.status as int;
					var messageResSendBroadCast:String = CommonEvent(e).data.message;
					if(statusResSendBroadCast == 200){
						return;
					}
					var errorViewResSendBroadCast:ErrorView = new ErrorView(messageResSendBroadCast);
					addChild(errorViewResSendBroadCast);
					break;
				case AbsPlayerData.EVENT_RES_SendGift:
					var statusResSendSendGift:int = CommonEvent(e).data.status as int;
					var messageResSendSendGift:String = CommonEvent(e).data.message;
					if(statusResSendSendGift == 200){
						return;
					}
					var errorViewResSendSendGift:ErrorView = new ErrorView(messageResSendSendGift);
					addChild(errorViewResSendSendGift);
					break;
				case AbsPlayerData.EVENT_RES_SendMessage:
					var statusResSendMessage:int = CommonEvent(e).data.status as int;
					var messageResSendMessage:String = CommonEvent(e).data.message;
					if(statusResSendMessage == 200){
						return;
					}
					var errorViewResSendMessage2:ErrorView = new ErrorView(messageResSendMessage);
					addChild(errorViewResSendMessage2);
					break;
				case AbsPlayerData.EVENT_PUSH_pushStarUser:
					var objStarUser:Object = CommonEvent(e).data;
					_currentStarUserResObj = objStarUser;
					
					var endTimestp:Number = objStarUser["endTimestp"];
					var nowClientTimestp:int= int((new Date().time/1000));
					trace("用户名:"+objStarUser.uname+"        歌曲名字:"+objStarUser.songsName);
					trace("进入房间的服务端时间:"+PlayerData.getInstance().serverTimerstp);
					trace("进入房间的客户端时间:"+PlayerData.getInstance().clientTimerstp);
					trace("当前显示的时间:"+nowClientTimestp);
					trace("歌曲结束的时间:"+endTimestp);
					trace("歌曲总长度:"+objStarUser.songsTime);
					trace("当前显示的服务端时间"+(nowClientTimestp-PlayerData.getInstance().clientTimerstp+PlayerData.getInstance().serverTimerstp));
					var singerTime:int = objStarUser.songsTime-endTimestp+nowClientTimestp+PlayerData.getInstance().clientTimerstp-PlayerData.getInstance().serverTimerstp
					
					_curStarUserSingTime   = singerTime;
					starInfoShowStar(true);
					ui_RoomView.starInfo.tf_title.text = objStarUser.title;
					ui_RoomView.starInfo.tf_singerName.text = objStarUser.uname;
					ui_RoomView.starInfo.tf_songName.text = objStarUser.songsName;
					ui_RoomView.starInfo.loader_userImg.source = objStarUser.headimg;
					if(objStarUser.singerTime < objStarUser.songsTime){
						_starSingerTimer.start();
					}
					if(objStarUser.micStatus == 0){
						ui_RoomView.starInfo.userStatus.gotoAndStop(1);
					}else{
						ui_RoomView.starInfo.userStatus.gotoAndStop(2);
					}
					break;
				case UserEvent.USER_SELECT_CHAT:
//					if(UserEvent(e).uid != PlayerData.getInstance().playerObj["uid"]){
//						var obj:Object = new Object();
						targetUser = UserEvent(e);
//						obj["label"] =targetUser.uName;//用户名字
//						obj["data"] = targetUser.uid;//uid
						
						selectTargetComboBoxByUID(targetUser.uid);
						_sendGifTargetUID = targetUser.uid;
						_sendGifTargetName = targetUser.uName;
						ui_RoomView.roomChat.cb_isPrivateChat.selected = targetUser.isSelected;
						ui_RoomView.roomChat.cb_isPrivateChat.enabled = true;
//						ui_RoomView.roomChat.mc_popPresent.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//					}
					break;
				case UserEvent.USER_SELECT_PRESENT:
					//					if(UserEvent(e).uid != PlayerData.getInstance().playerObj["uid"]){
					//						var obj:Object = new Object();
					targetUser = UserEvent(e);
					//						obj["label"] =targetUser.uName;//用户名字
					//						obj["data"] = targetUser.uid;//uid
					
//					selectTargetComboBoxByUID(targetUser.uid);
					_sendGifTargetUID = targetUser.uid;
					_sendGifTargetName = targetUser.uName;
					giftButClickHandel();
//					ui_RoomView.roomChat.mc_popPresent.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					//					}
					break;
				case OperateSongEvent.EVENT_LISTEN://开始听什么歌
					 BaseInteract.baseStartListen(OperateSongEvent(e).uid);
					 focusInWatchSinger();
					break;
				case OperateSongEvent.EVENT_SING://开始唱什么歌
					BaseInteract.baseStartSing(OperateSongEvent(e).songId);
					focusInWatchSinger();
					break;
				case AbsPlayerData.EVENT_RES_UserInfo:
					var userInfoObj:Object = CommonEvent(e).data;
					_playerData.playerObj = userInfoObj;//缓存当前的用户
					trace(_playerData.playerObj["uid"]);
					if(UModelLocal.getInstance().debug == 0){
						
					}else if(UModelLocal.getInstance().debug == 1){
						UModelLocal.getInstance().uid = userInfoObj["uid"];
					}
					break;
			}
		}
		
		public function focusInWatchSinger():void{
			ui_RoomView.roomChat.tb_watchSinger.visible = true;//什么时候将他们隐藏掉呢
			ui_RoomView.roomChat.tb_watchSinger.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		/**
		 * 转到公聊框
		 */ 
		public function focusInChat():void{
			ui_RoomView.roomChat.tb_publicChat.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		/**
		 * 得到正在唱歌的人的列表
		 */ 
		private function getSingerList():Array{
			var array:Array = [];
			for each(var ele:Object in _allPlayerUserMap.values()){
				if(ele["status"] == 0){
					array.push(ele);
				}
			}
			return array;
		}
		
		/**
		 * 得到没有唱歌的观众的列表
		 */ 
		private function getViewerList():Array{
			var array:Array = [];
			for each(var ele:Object in _allPlayerUserMap.values()){
				if(ele["status"] == 1){
					array.push(ele);
				}
			}
			return array;
		}
		public var _myTileListUserInfoList:MyTileList = new MyTileList();
		/**
		 * 更新当前的房间用户中的roomUser列表
		 */ 
		private function refreshRoomUser():void{
//			if(list == null ){
//				
//				if(_myTileList.dataProvider != null){
//					_myTileList.dataProvider.removeAll();
//				}
//				
//				return;
//			
//			}
			var list:Array  = [];
			if(_curRoomUserType == ROOM_USER_TYPE_SINGER){
				list = getSingerList();
			}
			
			if(_curRoomUserType == ROOM_USER_TYPE_VIEWER){
				list = getViewerList();
			}
			
			list.sortOn("micStatus",Array.DESCENDING | Array.NUMERIC);
			ui_RoomView.roomUserList.singerListBut.tf_singerList.text = "唱歌("+ getSingerList().length +")";
			ui_RoomView.roomUserList.userListBut.tf_userList.text = "观众("+getViewerList().length+")";
			ui_RoomView.roomUserList.singerListBut.tf_singerList.mouseEnabled = false;
			ui_RoomView.roomUserList.userListBut.tf_userList.mouseEnabled = false;
			
			var roomList :Array = new Array();
			for each (var roomObj:Object in list){
				var roomUserInfoCell:RoomUserInfoCell = new RoomUserInfoCell(roomObj);
				roomUserInfoCell.mouseChildren = false;
				
				if(!roomUserInfoCell.hasEventListener(MouseEvent.MOUSE_OVER)){
					roomUserInfoCell.addEventListener(MouseEvent.MOUSE_OVER,roomUse_itemOverHandel);
				}
				if(!roomUserInfoCell.hasEventListener(MouseEvent.MOUSE_OUT)){
					roomUserInfoCell.addEventListener(MouseEvent.MOUSE_OUT,roomUse_itemOutHandel);
				}
//				if(!roomUserInfoCell.hasEventListener(MouseEvent.CLICK)){
//					roomUserInfoCell.addEventListener(MouseEvent.CLICK,roomUse_itemDoubleHandel);
//				}
				if(!roomUserInfoCell.hasEventListener(MouseEvent.DOUBLE_CLICK)){
					roomUserInfoCell.doubleClickEnabled = true;
					roomUserInfoCell.addEventListener(MouseEvent.DOUBLE_CLICK,roomUse_itemDoubleHandel);
				}
				
				roomList.push(roomUserInfoCell);
			}
			_curAllRoomUserList = roomList;
			_myTileListUserInfoList.dataProvider = roomList;
			refreshTargetComboBox();
		}
		private function roomUse_itemDoubleHandel(e:MouseEvent):void{
			var roomUserInfoCell:RoomUserInfoCell = RoomUserInfoCell(e.target);
//			var roomUserInfoCell:RoomUserInfoCell = RoomUserInfoCell(e.item["source"]);
			if(uid == roomUserInfoCell.object.uid){
				return;
			}
			if(_curRoomUserType == ROOM_USER_TYPE_SINGER){
				BaseInteract.baseStartListen(roomUserInfoCell.object["uid"]);
				focusInWatchSinger();
			}else{
				roomUserInfoCell.setChatTarget();
			}
		}
		private function roomUse_itemOverHandel(e:MouseEvent):void{
			var roomUserInfoCell:RoomUserInfoCell = RoomUserInfoCell(e.target);
			roomUserInfoCell.roomUserInfo.roomUserInfoBg.visible = true;
			roomUserInfoTip.show(roomUserInfoCell);
		}
		private function roomUse_itemOutHandel(e:MouseEvent):void{
			RoomUserInfoCell(e.target).roomUserInfo.roomUserInfoBg.visible = false;
			roomUserInfoTip.startUnShowTimer();
		}
		
		/**
		 * 寻找当前列表里面是否存在uid的用户，如果存在更新当前列表
		 */ 
//		private function updateRoomUserByUID(uid:int):void{
//			for each(var ele:Object in _myTileList.dataProvider.toArray()){
//				if(RoomUserInfoCell(ele["source"]).object["uid"] == uid){
//					_myTileList.dataProvider = _myTileList.dataProvider;//该死的玩意不知道怎么更新，先设置一个原先的试试
//					return;
//				}
//			}
//		}
		
//		private function roomUse_itemOutHandel(e:ListEvent):void{
//			var roomUserInfo: mc_roomUserInfo;
//			roomUserInfo = mc_roomUserInfo(e.item["source"].roomUserInfo);
//			roomUserInfo.gotoAndStop(1);
//			
//			ui_PlayerInfoTipView.visible = false;
//		}
		
//		//用户列表中划过信息
//		private function roomUse_itemClickHandel(e:ListEvent):void{
////			ui_PlayerInfoTipView.visible = !ui_PlayerInfoTipView.visible;
//			roomUserInfoTip.show(e.item["source"]);
//		}
		
		//广播里面使用的广播一行的对象
		private var _bcLineView:BroadCastLineView;
		
		private function refershBroadCastTimer():void{
//			if(broadCastMessageArray.length >= 0&&!broadCastTime.running){
//				broadCastTime.addEventListener(TimerEvent.TIMER,refersh);
//				broadCastTime.start();
//				refersh(new Event(""));
//			}
			
			if(_bcLineView == null){
				refersh(new Event(""));
			}
			
		}
		
		/**
		 * 进入另一个房间的事件处理
		 */ 
		private function enterAnotherRoomHandler(e:Event):void{
			_anotherRoomId = BroadCastLineView(e.target).roomId;		
			if(_anotherRoomId<1 || _anotherRoomId == _roomId){
				return;
			}
		
			ViewHelper.popView(ViewRegister.SYSTEM_INFO_VIEW,this,Main.KG_WIDTH,Main.KG_HEIGHT);
			_playerData.cs_InitRoom(_anotherRoomId);
			
		}
		
		/**
		 * 进入另一个房间的方法
		 */ 
		private function resInitAnotherRoomHandler(e:CommonEvent):void{
			ViewHelper.removePopView(ViewRegister.SYSTEM_INFO_VIEW);
			var status:int = e.data.status as int;
			var message:String = e.data.message;
			_playerData.initRoomObj["roomId"] = _anotherRoomId;
			if(status == 200){
				//登入成功;
				//通知外部容器
				
				ViewHelper.removeView(ViewRegister.ROOM_VIEW);
				ViewHelper.addView(ViewRegister.ROOM_VIEW,ViewHelper._main);
				if(UModelLocal.getInstance().debug ==1){
					BaseInteract.baseInitRoom(_playerData.initRoomObj["roomId"]);
				}
				return;
			}
			var errorView:ErrorView = new ErrorView(status+":"+message);
			addChild(errorView);
		}
		
		private function refersh(e:Event):void{
			var broadCastObj:Object = broadCastMessageArray.shift();
			
			if(_bcLineView != null && ui_RoomView.broadCast.contains(_bcLineView)){
				_bcLineView.destory();
				_bcLineView = null;
			}
			
			if(broadCastObj == null){
//				broadCastTime.stop();
				return;
				
			}else{
				_bcLineView = new BroadCastLineView("<font color='#FF0099'>"+broadCastObj.uname+": </font><font color='#000000'>"+broadCastObj.content+"</font><font color='#6CCAFF'>"+broadCastObj.created+"</font>",650,1000,5,broadCastObj.roomId);
				_bcLineView.y = 5;
				ui_RoomView.broadCast.broadcastAnimation.gotoAndPlay(2);
				_bcLineView.addEventListener(Event.COMPLETE,refersh);
				_bcLineView.addEventListener(BroadCastLineView.EVENT_ENTER_ROOM,enterAnotherRoomHandler);
				ui_RoomView.broadCast.addChild(_bcLineView);
				_bcLineView.x = 44;
//				ui_RoomView.broadCast.tf_broadcastMessage.htmlText ="<font color='#654533'>"+broadCastObj.uname+" 使用大喇叭: "+broadCastObj.content+"</font>";
			}
//			if(_bcLineView == null){
//				
//			}
			
		}
		
		public function addRoomBottom(disObj:DisplayObject):void{
			this.addChildAt(disObj,0);
		}
		
		/**
		 * 清除掉所有侦听
		 */ 
		override public function destory():void{
			super.destory();
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushAddRoom,commonEventHandler);//广播玩家进入的消息
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushBroadCast,commonEventHandler);//广播玩家喇叭消息
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushErrorConnection,commonEventHandler);//广播连接状态
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushGiftMessage,commonEventHandler);//礼物消息
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushLevelRoom,commonEventHandler);//广播玩家离开消息
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushPrivateMessage,commonEventHandler);//私聊
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushPublicMessage,commonEventHandler);//公聊
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushSingerInRoom,commonEventHandler);//更新房间内的唱歌者信息
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushListenInRoom,commonEventHandler);//更新房间内的唱歌者信息
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushGetNotice,commonEventHandler);//公告处理
			_playerData.removeEventListener(AbsPlayerData.EVENT_PUSH_pushStarUser,commonEventHandler);//房间内最高分信息
			
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_ListAllUser,commonEventHandler);//所有用户列表
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_ListGift,commonEventHandler);//礼物列表
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_ListSingerUser,commonEventHandler);//房间内唱歌用户列表
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_ListUser,commonEventHandler);//房间内观众列表
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_ListUserGift,commonEventHandler);//用户收到的礼物列表信息
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_ListUserSongs,commonEventHandler);//我（用户）的歌本
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_SendBroadCast,commonEventHandler);//发送广播信息
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_SendGift,commonEventHandler);//发送礼物
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_SendMessage,commonEventHandler);//发送信息
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_InitRoom,resInitAnotherRoomHandler);//在房间里面进入房间的处理函数
			
			_playerData.removeEventListener(UserEvent.USER_SELECT_CHAT,commonEventHandler);//玩家选中
			_playerData.removeEventListener(UserEvent.USER_SELECT_PRESENT,commonEventHandler);//玩家选中
			
			_playerData.removeEventListener(OperateSongEvent.EVENT_SING,commonEventHandler);//玩家选中
			_playerData.removeEventListener(OperateSongEvent.EVENT_LISTEN,commonEventHandler);//玩家选中

			ui_RoomView.roomUserList.pdphListBut.removeEventListener(MouseEvent.CLICK,pdphListButHandel);//暂时不做
			
			//广播按钮监听
			ui_RoomView.broadCast.but_sendMessage.removeEventListener(MouseEvent.CLICK,wantBroadCastButHandel);
			ButtonUtil.changeButton(ui_roomBroadCast.button_sendMessage).removeEventListener(MouseEvent.CLICK,sendBroadCastMessage);
			
			//房间聊天信息
			ui_RoomView.roomChat.tb_publicChat.tb_bg.visible = true;
			ui_RoomView.roomChat.tb_gift.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_mySongs.tb_bg.visible = false;
			ui_RoomView.roomChat.tb_watchSinger.tb_bg.visible = false;
			
			ui_RoomView.roomChat.tb_publicChat.removeEventListener(MouseEvent.CLICK,publicChatButHandel);
			ui_RoomView.roomChat.tb_gift.removeEventListener(MouseEvent.CLICK,giftButHandel);
			ui_RoomView.roomChat.tb_mySongs.removeEventListener(MouseEvent.CLICK,mySongsButHandel);
			ui_RoomView.roomChat.tb_watchSinger.removeEventListener(MouseEvent.CLICK,watchSingerButHandel);
			
			//消息发送
			ui_RoomView.roomChat.btn_sendChat.removeEventListener(MouseEvent.CLICK,sendChatmessageHandel);
			//清屏
			if(ui_RoomView.roomChat.clearPrivateScreenBtn != null){
				ui_RoomView.roomChat.clearPrivateScreenBtn.removeEventListener(MouseEvent.CLICK,clearScreenBtnHandel);
			}
			if(ui_RoomView.roomChat.clearPublicScreenBtn != null){
				ui_RoomView.roomChat.clearPublicScreenBtn.removeEventListener(MouseEvent.CLICK,clearScreenBtnHandel);
			}
			//显示表情
			ui_RoomView.roomChat.mc_popFace.removeEventListener(MouseEvent.CLICK,smileyClickHandel);
			
			//礼物按钮
			ui_RoomView.roomChat.mc_popPresent.removeEventListener(MouseEvent.CLICK,giftButClickHandel);
			
			//最大化
			ui_RoomView.btn_changeSizeBtn.removeEventListener(MouseEvent.CLICK,changeSizeHandler);
			
			ui_RoomView.btn_backHall.removeEventListener(MouseEvent.CLICK,backHallHandler);
			
			ui_RoomView.btn_singerInHall.removeEventListener(MouseEvent.CLICK,startSingingHandler);
			
			ui_RoomView.roomChat.targetComboBox.removeEventListener(Event.CHANGE,targetComboBoxSelectHandler);
			
			//礼物列表中的修改count
			ui_GiftListView.count.removeEventListener(Event.CHANGE,changeTextHandel);
			
			ui_GiftListView.sendGift.removeEventListener(MouseEvent.CLICK,sendGiftHandel);
			
			//礼物下上页
			ui_GiftListView.nextPage.removeEventListener(MouseEvent.CLICK,giftnextPageHandel);
			ui_GiftListView.prePage.removeEventListener(MouseEvent.CLICK,giftPrePageHandel);
			
			
			_starSingerTimer.removeEventListener(TimerEvent.TIMER,timerHandler);
			
			ui_RoomView.roomUserList.search.tf_search.removeEventListener(Event.CHANGE,searchRoomUserList);
			
			_playerData.removeEventListener(AbsPlayerData.EVENT_RES_UserInfo,commonEventHandler);//请求用户返回
		}
		
	}
}