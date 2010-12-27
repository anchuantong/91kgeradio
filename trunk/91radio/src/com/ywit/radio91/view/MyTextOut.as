package com.ywit.radio91.view
{
	
	import com.ywit.radio91.util.HashMap;
	import com.ywit.radio91.util.SwfDataLoader;
	
	import fl.containers.ScrollPane;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.engine.TextBaseline;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import flashx.textLayout.container.DisplayObjectContainerController;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.BaselineOffset;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	

	public class MyTextOut extends ScrollPane{
		private var _textFlow:TextFlow;
		private var _controller :DisplayObjectContainerController ;
		public static var _smileysMap:HashMap ;
//		public static var _giftsMap:HashMap ;
		private var _selectManager:SelectionManager;
		
		public function MyTextOut(weight:int,hight:int) {
			super();
			_textFlow = new TextFlow();
			
			_textFlow.fontSize = 12;
			
			_textFlow.fontFamily = "宋体";
			_textFlow.format
			
			_selectManager = new SelectionManager();
			
			var sprite:Sprite = new Sprite();
			_controller = new DisplayObjectContainerController(sprite,weight-15,NaN);
			this.source = sprite;
			
			this.width = weight;
			this.height = hight;
			
			_textFlow.flowComposer.addController(_controller);
//			_textFlow.interactionManager = new EditManager();
			_textFlow.flowComposer.updateAllContainers();
			
			
			
//			this.graphics.lineStyle(0,0,0);
//			this.graphics.beginFill(0,0.3);
//			this.graphics.drawRect(0,0,weight,hight);
//			this.graphics.endFill();
			setStly();
//			StyleManager.setComponentStyle(ScrollPane,"upArrowUpSkin", UpArrowUpSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"upArrowOverSkin", UpArrowOverSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"upArrowDownSkin", UpArrowDownSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"trackUpSkin", TrackUpSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"trackOverSkin", TrackOverSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"trackDownSkin", TrackDownSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"thumbUpSkin", ThumbUpSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"thumbOverSkin", ThumbOverSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"thumbDownSkin", ThumbDownSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"downArrowDownSkin", DownArrowDownSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"downArrowOverSkin", DownArrowOverSkin2);
//			StyleManager.setComponentStyle(ScrollPane,"downArrowUpSkin", DownArrowUpSkin2);

		}
		public function setStly():void{
			this.filters = [];
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy="on";
			this.setStyle("upArrowDisabledSkin",UpArrowUpSkin2);
			this.setStyle("upArrowUpSkin",UpArrowUpSkin2);
			this.setStyle("upArrowOverSkin",UpArrowOverSkin2);
			this.setStyle("upArrowDownSkin",UpArrowDownSkin2);
			this.setStyle("trackDisabledSkin",TrackUpSkin2);
			this.setStyle("trackUpSkin",TrackUpSkin2);
			this.setStyle("trackOverSkin",TrackOverSkin2);
			this.setStyle("trackDownSkin",TrackDownSkin2);
			this.setStyle("thumbDisabledSkin",ThumbUpSkin2);
			this.setStyle("thumbUpSkin",ThumbUpSkin2);
			this.setStyle("thumbOverSkin",ThumbOverSkin2);
			this.setStyle("thumbDownSkin",ThumbDownSkin2);
			this.setStyle("downArrowDisabledSkin",DownArrowDownSkin2);
			this.setStyle("downArrowDownSkin",DownArrowDownSkin2);
			this.setStyle("downArrowOverSkin",DownArrowOverSkin2);
			this.setStyle("downArrowUpSkin",DownArrowUpSkin2);
		}
		public function cleanAll():void{
			var num:int  = _textFlow.numChildren;
			for(var i:int=0;i<num;i++){
				_textFlow.removeChildAt(0);
			}
			
			_textFlow.flowComposer.updateAllContainers();
			this.update();
			this.verticalScrollPosition= this.maxVerticalScrollPosition;
		}
		public static const MATH_COUNT:String = "0123456789";
		public static function isCharMath(char:String):Boolean{
			if(char==null){
				return false;
			}
			return (MATH_COUNT.indexOf(char)!=-1);
		}
		
		// [公告] 12:00 公告内容  noticeMessage
		
		// [房间] XXX进入了X号XXX房间. roomMessage
		// [房间] XXX离开了X号XXX房间.
		
		// [房间] XXX开始唱XXX歌.	singerMessage
		// [房间] XXX唱完了XXX歌.
		
		// [房间] XXX听XXX人唱歌.	listenerMessage
		
		// [系统] 您发送给XXX 礼物X个.	giftMessage
		// [系统] 您收到XXX 礼物X个.
		
		public static const NOTICE_MESSAGE:String = "NoticeMessage";
		public static const ROOM_MESSAGE:String = "RoomMessage";
//		public static const SINGER_MESSAGE:String = "SingerMessage";
//		public static const LISTENER_MESSAGE:String = "ListenerMessage";
		public static const GIFT_MESSAGE:String = "GiftMessage";
		public static const PUBLIC_MESSAGE:String = "PublicMessage";
		public static const PRIVATE_MESSAGE:String = "privateMessage";
		
		public static const STOP_SINGING_MESSAGE:String = "STOP_SINGING_MESSAGE";
		public static const START_SINGING_MESSAGE:String = "START_SINGING_MESSAGE";
		public static const START_LISTEN_MESSAGE:String = "START_LISTEN_MESSAGE";
		
		
		
		/**
		 * 开始唱歌
		 */ 
		public function startSingingHandler(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			var link:LinkElement;
//			var inlineGraphic:InlineGraphicElement;
			
			var created:String = object["created"];
			var uid:int = object["uid"];
			var uname:String = object["uname"];
			var songsId:int = object["songsId"];
			var songsName:String = object["songsName"];
			
			span = new SpanElement();
			span.text=created+" ";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(uid,uname));
			
			span = new SpanElement();
			span.text="开始唱";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addListenSongLink(uid,songsId,songsName,object["endTimestp"]));
			
			return p;
		}
		
		/**
		 * 停止唱歌
		 */ 
		public function stopSingingHandler(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			
			var created:String = object["created"];
			var uid:int = object["uid"];
			var uname:String = object["uname"];
			var songsId:int = object["songsId"];
			var songsName:String = object["songsName"];
			var score:int = object["score"];
			
			
			span = new SpanElement();
			span.text=created+" ";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(uid,uname));
			
			span = new SpanElement();
			span.text="唱完";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addSingSongLink(uid,songsId,songsName));
			
			span = new SpanElement();
			span.text=",得分";
			span.color = 0;
			p.addChild(span);
			
			span = new SpanElement();
			span.text= score+"";
			span.color = 0xFFCC00;
			p.addChild(span);
			
			return p;
		}
		
		
		/**
		 * 开始收听
		 */ 
		public function startListenHandler(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			//			var link:LinkElement;
			//			var inlineGraphic:InlineGraphicElement;
			var created:String = object["created"];
			var listenUid:int = object["listenUid"];
			var listenUname:String = object["listenUname"];
			var singerUid:int = object["singerUid"];
			var singerUname:String = object["singerUname"];
			var songsId:int = object["songsId"];
			var songsName:String = object["songsName"];
			
			span = new SpanElement();
			span.text=created+" ";
			span.color = 0;
			p.addChild(span);
			
			
			p.addChild(LinkElementUtil.addUserLink(listenUid,listenUname));
			
			span = new SpanElement();
			span.text="开始听";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(singerUid,singerUname));
			span = new SpanElement();
			span.text="唱";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addListenSongLink(singerUid,songsId,songsName,object["endTimestp"]));
			
			return p;
		}
		
		public function privateMessageHandel(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			var inlineGraphic:InlineGraphicElement;
			
			var str:String  = object["created"];
			var sendUid:int = object["sendUid"];
			var sendUname:String = object["sendUname"];
			var recUid:int = object["recUid"];
			var recUname:String = object["recUname"];
			var content:String = object["content"];
			
//			span = new SpanElement();
//			span.text=str+" ";
//			span.color = 0;
//			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(sendUid,sendUname));
			
			span = new SpanElement();
			span.text="对";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(recUid,recUname));
			
			span = new SpanElement();
			span.text="说:";
			span.color = 0;
			p.addChild(span);
			
			//用户发送的信息
			
			var isReadPic:Boolean = false;
			var isEndofStr:Boolean = false;
			var picname:String = "";
			var messageContext:String = "";
			for (var i:int = 0;i < content.length; i++) {
				var char:String = content.charAt(i);
				var nextChar:String;
				if(i+1==content.length){
					isEndofStr = true;
					nextChar = null;
				}else{
					nextChar = content.charAt(i+1);
				}
				
				if(char == "#"&& !isEndofStr && isCharMath(nextChar)){
					isReadPic = true;
					picname +=char;
					picname +=nextChar;
				}else if(isReadPic&&!isEndofStr&&isCharMath(nextChar)){
					picname+=nextChar;
				}else if(isReadPic&&(isEndofStr||!isCharMath(nextChar))){
					isReadPic = false;
					trace("解析出来的聊天表情名字:"+picname);
					var obj:Object = _smileysMap.getValue(picname);
					if(obj){
						inlineGraphic = new InlineGraphicElement();
						inlineGraphic.source=obj.src as Class;
						inlineGraphic.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
						p.addChild(inlineGraphic);
					}
					picname = "";
				}else if(nextChar==null||nextChar == "#"){
					messageContext+=char;
					span = new SpanElement();
					span.text=messageContext;
					span.color = 0xCC00FF;
					p.addChild(span);
					
					messageContext="";
				}else{
					messageContext+=char;
				}
			}
			return p;
		}
		private function publicMessageHandel(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			var inlineGraphic:InlineGraphicElement;
			
			var str:String  = object["created"];
			var sender:String = object["sendUname"];
			var sendUid:int = object["sendUid"];
			var recUid:int = object["recUid"];
			var target:String = object["recUname"];
			var message:String = object["content"];
			
			span = new SpanElement();
			span.text=str+" ";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(sendUid,sender));
			
			if(recUid != 0){
				span = new SpanElement();
				span.text="对";
				span.color = 0;
				p.addChild(span);
				
				p.addChild(LinkElementUtil.addUserLink(recUid,target));
			
				span = new SpanElement();
				span.text="说";
				span.color = 0;
				p.addChild(span);
			
			}else{
				span = new SpanElement();
				span.text="说";
				span.color = 0;
				p.addChild(span);
			}
			
			span = new SpanElement();
			span.text="：";
			span.color = 0;
			p.addChild(span);
			
			//用户发送的信息
			
			var isReadPic:Boolean = false;
			var isEndofStr:Boolean = false;
			var picname:String = "";
			var messageContext:String = "";
			for (var i:int = 0;i < message.length; i++) {
				var char:String = message.charAt(i);
				var nextChar:String;
				if(i+1==message.length){
					isEndofStr = true;
					nextChar = null;
				}else{
					nextChar = message.charAt(i+1);
				}
				
				if(char == "#"&& !isEndofStr && isCharMath(nextChar)){
					isReadPic = true;
					picname +=char;
					picname +=nextChar;
				}else if(isReadPic&&!isEndofStr&&isCharMath(nextChar)){
					picname+=nextChar;
				}else if(isReadPic&&(isEndofStr||!isCharMath(nextChar))){
					isReadPic = false;
					trace("解析出来的聊天表情名字:"+picname);
					var obj:Object = _smileysMap.getValue(picname);
					if(obj){
						inlineGraphic = new InlineGraphicElement();
						inlineGraphic.source=obj.src as Class;
						inlineGraphic.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
						p.addChild(inlineGraphic);
					}
					picname = "";
				}else if(nextChar==null||nextChar == "#"){
					messageContext+=char;
					span = new SpanElement();
					span.text=messageContext;
					span.color = 0;
					p.addChild(span);
					
					messageContext="";
				}else{
					messageContext+=char;
				}
			}
			
			return p;
		}
		public function noticeMessageHandel(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			var link:LinkElement;
			var inlineGraphic:InlineGraphicElement;
			
			var str:String  = "【公告】";
			var created:String = object["created"];
			var content:String = object["content"];
			
			span = new SpanElement();
			span.text=str+" ";
			span.color = 0xFF0000;
			p.addChild(span);
			
			span = new SpanElement();
			span.text=created+" ";
			span.color = 0;
			p.addChild(span);
			
			span = new SpanElement();
			span.text=content;
			span.color = 0xFF0000;
			p.addChild(span);
			
			return p;
		}
		public function roomMessageHandel(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			var link:LinkElement;
			var inlineGraphic:InlineGraphicElement;
			
			
			var str:String  = object["created"];
			var uid:int = object["uid"];
			var uname:String = object["uname"];
			var roomId:String = object["roomId"];
			var roomName:String = object["roomName"];
			
			span = new SpanElement();
			span.text=str+" ";
			span.color = 0x000000;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(uid,uname));
			
			if(object["isLevel"]){
				span = new SpanElement();
				span.text="离开了";
				span.color = 0x000000;
				p.addChild(span);
			}else{
				span = new SpanElement();
				span.text="进入了";
				span.color = 0x000000;
				p.addChild(span);
			}
			
			span = new SpanElement();
			span.text="房间";
			span.color = 0x000000;
			p.addChild(span);
			
			return p;
		}
		
//		public function listenerMessageHandel(object:Object):ParagraphElement{
//			var p:ParagraphElement = new ParagraphElement();
//			var span:SpanElement;
//			var link:LinkElement;
//			var inlineGraphic:InlineGraphicElement;
			
			
			//ui_RoomView.roomChat.ta_publicChat.text += "开始听歌："+e.data.uname+"开始听"+e.data.listenUname+"唱歌\n";
			
//			var str:String  = "[开始听歌]";
//			var status:int = object["status"];
//			var listenUname:String = object["listenUname"];
//			var singerUname:String = object["singerUname"];
//			
//			//开始唱歌：${uname}开始唱${songsName};结束唱歌:
//			//0:开始唱歌;1：结束唱歌"
//			if(status == 0){
//				str = "[开始听歌]";
//			}else{
//				str = "[结束听歌]";
//			}
//			
//			span = new SpanElement();
//			span.text=str;
//			span.color = 0x888888;
//			p.addChild(span);
//			
//			span = new SpanElement();
//			span.text=listenUname;
//			span.color = 0x888778;
//			p.addChild(span);
//			
//			if(status == 0){
//				span = new SpanElement();
//				span.text="开始听";
//				span.color = 0x888778;
//				p.addChild(span);
//			}else{
//				span = new SpanElement();
//				span.text="听完了";
//				span.color = 0x888778;
//				p.addChild(span);
//			}
//			span = new SpanElement();
//			span.text=singerUname;
//			span.color = 0x338888;
//			p.addChild(span);
//			
//			span = new SpanElement();
//			span.text= "的歌曲.";
//			span.color = 0x338888;
//			p.addChild(span);
//			
//			return p;
//		}
		
		private var timer:Timer = new Timer(200);
		private var giftArray:Array = new Array();
		public static function clone(obj:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(obj);
			copier.position = 0;
			return copier.readObject();
		}
		
		private function addGiftMessageHandel(object:Object):void{
			giftArray.push(clone(object));
			if(giftArray.length>=0  && !timer.running){
				if(!timer.hasEventListener(TimerEvent.TIMER)){
					timer.addEventListener(TimerEvent.TIMER,giftMessageTimerHandel);
				}
				timer.start();
				giftMessageTimerHandel(new Event(""));
			}
		}
		public function giftMessageTimerHandel(e:Event):void{
			var obj:Object = giftArray.shift();
			if(!obj){
				timer.stop();
				return;
			}
			
			var p:ParagraphElement = giftMessageHandel(obj);
			p.marginLeft = 5;
			p.marginBottom = 5;
			_textFlow.addChild(p);
			_textFlow.flowComposer.updateAllContainers();
			this.update();
			this.verticalScrollPosition= this.maxVerticalScrollPosition;
		}
		
		public function giftMessageHandel(object:Object):ParagraphElement{
			//ui_RoomView.roomChat.ta_publicChat.text += "开始听歌："+e.data.uname+"开始听"+e.data.listenUname+"唱歌\n";
			
			var str:String  = object["created"];
			var count:int = object["count"];
			
			var sendUname:String = object["sendUname"];
			var recUname:String = object["recUname"];
			var giftName:String = object["giftName"];
			var recUid:int = object["recUid"];
			var sendUid:int = object["sendUid"];
			var giftImgUrl:String = object["giftImgUrl"];
			var nowCount:int = object["nowCount"];
			
			
			//XXX收到XXX赠送的礼物
				var p:ParagraphElement = new ParagraphElement();
				var span:SpanElement;
				var inlineGraphic:InlineGraphicElement;
				
				if(!SwfDataLoader.isGiftLoadComplete){
					return p;
				}
				
				span = new SpanElement();
				span.text=str+" ";
				span.color = 0;
				p.addChild(span);
				
				p.addChild(LinkElementUtil.addUserLink(sendUid,sendUname));
				span = new SpanElement();
				span.text="给";
				span.color = 0;
				p.addChild(span);
				
				p.addChild(LinkElementUtil.addUserLink(recUid,recUname));
				
				span = new SpanElement();
				span.text="送了";
				span.color = 0;
				p.addChild(span);
				
				span = new SpanElement();
				span.text="第"+nowCount+"个"+giftName;
				span.color = 0x800080;
				p.addChild(span);
				
				inlineGraphic = new InlineGraphicElement();
				
//				inlineGraphic.source=_giftsMap.getValue(giftImgUrl)["src"] as Class;
				inlineGraphic.source=SwfDataLoader.getGiftClass(giftImgUrl);
//				inlineGraphic.firstBaselineOffset = BaselineOffset.AUTO;
//				inlineGraphic.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
				p.addChild(inlineGraphic);				
			return p;
		}
		
//		public function singerMessageHandel(object:Object):ParagraphElement{
//			var p:ParagraphElement = new ParagraphElement();
//			var span:SpanElement;
//			var inlineGraphic:InlineGraphicElement;
//			
//			var str:String;
//			var status:int = object["status"];
//			var uname:String = object["uname"];
//			var songsName:String = object["songsName"];
//			var score:String = object["score"];
			
			//开始唱歌：${uname}开始唱${songsName};结束唱歌:
			//0:开始唱歌;1：结束唱歌"
//			if(status == 0){
//				str = "[开始唱歌]";
//			}else{
//				str = "[结束唱歌]";
//			}
//			
//			span = new SpanElement();
//			span.text=str;
//			span.color = 0x888888;
//			p.addChild(span);
//			
//			span = new SpanElement();
//			span.text=uname;
//			span.color = 0x888778;
//			p.addChild(span);
//			
//			if(status == 0){
//				span = new SpanElement();
//				span.text="开始唱";
//				span.color = 0x888778;
//				p.addChild(span);
//			}else{
//				span = new SpanElement();
//				span.text="唱完了";
//				span.color = 0x888778;
//				p.addChild(span);
//			}
//			span = new SpanElement();
//			span.text=songsName;
//			span.color = 0x338888;
//			p.addChild(span);
//			
//			span = new SpanElement();
//			span.text="歌曲.";
//			span.color = 0x338888;
//			p.addChild(span);
//			
//			
//			if(status == 0){
//				
//			}else{
//				span = new SpanElement();
//				span.text="得分:";
//				span.color = 0x888778;
//				p.addChild(span);
//				
//				span = new SpanElement();
//				span.text=score;
//				span.color = 0x338888;
//				p.addChild(span);
//			}
//			
//			return p;
//		}
		public function addMessage(messageType:String , obj:Object):void{
			var p:ParagraphElement
			switch(messageType){
				case NOTICE_MESSAGE:
					p = noticeMessageHandel(obj);
					break;
				case ROOM_MESSAGE:
					p = roomMessageHandel(obj);
					break;
//				case SINGER_MESSAGE:
//					p = singerMessageHandel(obj);
//					break;
//				case LISTENER_MESSAGE:
//					p = listenerMessageHandel(obj);
//					break;
				case STOP_SINGING_MESSAGE:
					p = stopSingingHandler(obj);
					break;
				case START_SINGING_MESSAGE:
					p = startSingingHandler(obj);
					break;
				case START_LISTEN_MESSAGE:
					p = startListenHandler(obj);
					break;
				case GIFT_MESSAGE:
//					p = giftMessageHandel(obj);
					
				 	addGiftMessageHandel(obj);
					return;
//					break;
				case PUBLIC_MESSAGE:
					p = publicMessageHandel(obj);
					break;
				case PRIVATE_MESSAGE:
					p = privateMessageHandel(obj);
					break;
			}
			

			p.marginLeft = 5;
			p.marginBottom = 5;
			_textFlow.addChild(p);
			_textFlow.flowComposer.updateAllContainers();
			this.update();
			this.verticalScrollPosition= this.maxVerticalScrollPosition;
			
		}
	}
}