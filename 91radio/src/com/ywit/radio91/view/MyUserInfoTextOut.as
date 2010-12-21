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
			
			inlineGraphic = new InlineGraphicElement();
			
			inlineGraphic.source=SwfDataLoader.getGiftClass(giftImgUrl);
			p.addChild(inlineGraphic);
			
			
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
			
			p.addChild(LinkElementUtil.addRoomNameLink(roomId,roomName));
			
			return p;
		}
	}
}