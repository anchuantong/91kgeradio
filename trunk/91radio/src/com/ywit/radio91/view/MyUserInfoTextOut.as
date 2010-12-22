package com.ywit.radio91.view
{
	import com.ywit.radio91.util.SwfDataLoader;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;

	public class MyUserInfoTextOut extends MyTextOut {
		public function MyUserInfoTextOut(weight:int,hight:int) {
			super(weight,hight);
		}
		
		override public function giftMessageHandel(object:Object):ParagraphElement{
			//ui_RoomView.roomChat.ta_publicChat.text += "开始听歌："+e.data.uname+"开始听"+e.data.listenUname+"唱歌\n";
			
			var str:String  = object["created"];
			var count:int = object["count"];
			
			var sendUname:String = object["sendUname"];
			var recUname:String = object["recUname"];
			var giftName:String = object["giftName"];
			var recUid:int = object["recUid"];
			var sendUid:int = object["sendUid"];
			var giftImgUrl:String = object["giftImgUrl"];
			
			var roomId:int= object["roomId"];
			var roomName:String = object["roomName"];

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
			
			p.addChild(LinkElementUtil.addUserLink(sendUid,sendUname,false));
			span = new SpanElement();
			span.text="给";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(recUid,recUname,false));
			
			span = new SpanElement();
			span.text="送了";
			span.color = 0;
			p.addChild(span);
			
			span = new SpanElement();
			span.text=""+count+"个";
			span.color = 0x000000;
			p.addChild(span);
			
			span = new SpanElement();
			span.text=giftName;
			span.color = 0xFF0000;
			p.addChild(span);
			
			
			span = new SpanElement();
			span.text="(在";
			span.color = 0x000000;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addRoomNameLink(roomId,roomName));
			
			span = new SpanElement();
			span.text=")";
			span.color = 0x000000;
			p.addChild(span);
			
//			inlineGraphic = new InlineGraphicElement();
//			
//			inlineGraphic.source=SwfDataLoader.getGiftClass(giftImgUrl);
//			p.addChild(inlineGraphic);
			
			
			return p;
		}
		override public function setStly():void{
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy="auto";
		}
		override public function roomMessageHandel(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			var inlineGraphic:InlineGraphicElement;
			
			
			var str:String  = object["created"];
			var uid:int = object["uid"];
			var uname:String = object["uname"];
			var roomId:int = object["roomId"];
			var roomName:String = object["roomName"];
			
			span = new SpanElement();
			span.text=str+" ";
			span.color = 0x000000;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(uid,uname,false));
			
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
			
			p.addChild(LinkElementUtil.addRoomNameLink(roomId,roomName));
			
			return p;
		}
		
		/**
		 * 开始唱歌
		 */ 
		override public function startSingingHandler(object:Object):ParagraphElement{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			
			var created:String = object["created"];
			var uid:int = object["uid"];
			var uname:String = object["uname"];
			var songsId:int = object["songsId"];
			var songsName:String = object["songsName"];
			
			span = new SpanElement();
			span.text=created+" ";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(uid,uname,false));
			
			span = new SpanElement();
			span.text="开始唱";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addListenSongLink(uid,songsId,songsName,object["endTimestp"],false));
			
			return p;
		}
		
		/**
		 * 停止唱歌
		 */ 
		override public function stopSingingHandler(object:Object):ParagraphElement{
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
			
			p.addChild(LinkElementUtil.addSingSongLink(uid,songsId,songsName,false));
			
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
		override public function startListenHandler(object:Object):ParagraphElement{
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
			
			
			p.addChild(LinkElementUtil.addUserLink(listenUid,listenUname,false));
			
			span = new SpanElement();
			span.text="开始听";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addUserLink(singerUid,singerUname,false));
			span = new SpanElement();
			span.text="唱";
			span.color = 0;
			p.addChild(span);
			
			p.addChild(LinkElementUtil.addListenSongLink(singerUid,songsId,songsName,object["endTimestp"],false));
			
			return p;
		}
	}
}