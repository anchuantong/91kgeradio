package com.ywit.radio91.view
{
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.event.EnterRoomEvent;
	import com.ywit.radio91.event.OperateSongEvent;
	import com.ywit.radio91.event.UserEvent;
	import com.ywit.radio91.util.ViewHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.SpanElement;
/**
 * 提供程序中使用到的link功能的工具类，比如聊天里的人名连接，歌曲链接等等。
 */ 
	public class LinkElementUtil {
		
		public static function addUserLink(uid:int,uName:String,linkable:Boolean=true):FlowElement{
			var link:LinkElement = new LinkElement();
			link.setStyle("linkNormalFormat", new Dictionary());
			var span:SpanElement = new SpanElement();
			if(uid == PlayerData.getInstance().playerObj["uid"]){
				span.text="你";
				span.color = 0;
				return span;
			}
			span.text=uName;
			span.color = 0xFF0099;
			link.addChild(span);
			if(linkable){
				link.addEventListener(MouseEvent.CLICK,function customClickHandler(e:Event):void{
					var userEvent:UserEvent = new UserEvent(UserEvent.USER_SELECT_CHAT);
					userEvent.uid = uid;
					userEvent.uName = uName;
					userEvent.isSelected = false;
					
					PlayerData.getInstance().dispatchEvent(userEvent);
				});
			}
			return link;
		}
		
		/**
		 * 添加点击便唱的歌曲
		 */ 
		public static function addSingSongLink(uid:int,songId:int,songName:String,linkable:Boolean=true):FlowElement{
			var link:LinkElement = new LinkElement();
			link.setStyle("linkNormalFormat", new Dictionary());
			var span:SpanElement = new SpanElement();
				span.text=songName;
				span.color = 0x0099FF;
			
				link.addChild(span);
				if(linkable){
					link.addEventListener(MouseEvent.CLICK,function linkClickHandler(e:Event):void{
						var evt:OperateSongEvent = new OperateSongEvent(OperateSongEvent.EVENT_SING);
						evt.songId = songId;
						evt.songName = songName;
						evt.uid = uid;
						ConfirmView.show("是否开始唱 "+evt.songName+" .",ViewHelper._main,confirmViewHandel,evt,true,800,800)
					});
				}
				
			return link;
		}
		private static function confirmViewHandel(evt:Event):void{
			PlayerData.getInstance().dispatchEvent(evt);
		}
		
		/**
		 * 添加点击便收听的歌曲
		 */ 
		public static function addListenSongLink(uid:int,songId:int,songName:String,endTimerStr:int,linkable:Boolean=true):FlowElement{
			var link:LinkElement = new LinkElement();
			link.setStyle("linkNormalFormat", new Dictionary());
			var span:SpanElement = new SpanElement();
			span.text=songName;
			span.color = 0x0099FF;
			link.addChild(span);
			if(linkable){
				link.addEventListener(MouseEvent.CLICK,function customClickHandler(e:Event):void{
					var nowClientTimestp:int= int((new Date().time/1000));
					if((nowClientTimestp-PlayerData.getInstance().clientTimerstp+PlayerData.getInstance().serverTimerstp) >= endTimerStr){
						//已经唱完了.
					}else{
						var evt:OperateSongEvent = new OperateSongEvent(OperateSongEvent.EVENT_LISTEN);
						evt.songId = songId;
						evt.songName = songName;
						evt.uid = uid;
						if(uid == PlayerData.getInstance().playerObj["uid"]){
							ConfirmView.show("不能收听自己歌曲",ViewHelper._main,confirmViewHandel,evt,true,800,800);
						}else{
							ConfirmView.show("是否开始听 "+evt.songName+" .",ViewHelper._main,confirmViewHandel,evt,true,800,800)
						}
					}
				});
			}
			return link;
		}
		
		/**
		 * 添加有连接的房间名字
		 */ 
		public static function addRoomNameLink(roomId:int,roomName:String,linkable:Boolean=true):FlowElement{
			var link:LinkElement = new LinkElement();
			link.setStyle("linkNormalFormat", new Dictionary());
			var span:SpanElement = new SpanElement();
			span.text=roomName;
			span.color = 0x0032BF;
			link.addChild(span);
			if(linkable){
				link.addEventListener(MouseEvent.CLICK,function customClickHandler(e:Event):void{
					var evt:EnterRoomEvent = new EnterRoomEvent(EnterRoomEvent.ENTER_ROOM);
					evt.roomId = roomId;
					evt.roomName = roomName;
					ConfirmView.show("是进入 "+roomId+" 号房间.",ViewHelper._main,confirmViewHandel,evt,true,800,800)
				});
			}
			return link;
		}
		
		/**
		 * 添加一条带url指向的链接文字
		 */ 
		public static function addURLLink(urlStr:String,url:String):FlowElement{
			return null;
		}
	
	}
}