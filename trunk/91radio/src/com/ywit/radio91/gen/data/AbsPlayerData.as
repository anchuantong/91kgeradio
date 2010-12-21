package com.ywit.radio91.gen.data{
import com.ywit.radio91.event.CommonEvent;
import flash.events.EventDispatcher;
import com.ywit.radio91.util.NetUntil;
/**
生成日期:Thu Dec 9 2010
作者:keynes
**/
public class AbsPlayerData extends EventDispatcher{
			private var _netUtil:NetUntil = NetUntil.getInstance();
			public var  jsessionid:String;
			private static var  _instance:AbsPlayerData;
   	    public static var EVENT_RES_Friends:String = "event_res_Friends";
   	    public static var EVENT_RES_UserInfo:String = "event_res_UserInfo";
   	    public static var EVENT_RES_ListRoom:String = "event_res_ListRoom";
   	    public static var EVENT_RES_SendBroadCast:String = "event_res_SendBroadCast";
   	    public static var EVENT_RES_InitRoom:String = "event_res_InitRoom";
   	    public static var EVENT_RES_LevelRoom:String = "event_res_LevelRoom";
   	    public static var EVENT_RES_GetRoom:String = "event_res_GetRoom";
   	    public static var EVENT_RES_ListSingerUser:String = "event_res_ListSingerUser";
   	    public static var EVENT_RES_ListUser:String = "event_res_ListUser";
   	    public static var EVENT_RES_ListAllUser:String = "event_res_ListAllUser";
   	    public static var EVENT_RES_ListUserGift:String = "event_res_ListUserGift";
   	    public static var EVENT_RES_ListUserSongs:String = "event_res_ListUserSongs";
   	    public static var EVENT_RES_ListGift:String = "event_res_ListGift";
   	    public static var EVENT_RES_SendMessage:String = "event_res_SendMessage";
   	    public static var EVENT_RES_SendGift:String = "event_res_SendGift";
   	    public static var EVENT_RES_CreateNewRoom:String = "event_res_CreateNewRoom";
//以下为push方法的事件;
   		public static var EVENT_PUSH_pushBroadCast:String = "event_push_pushBroadCast";
   		public static var EVENT_PUSH_pushSingerInRoom:String = "event_push_pushSingerInRoom";
   		public static var EVENT_PUSH_pushListenInRoom:String = "event_push_pushListenInRoom";
   		public static var EVENT_PUSH_pushGiftMessage:String = "event_push_pushGiftMessage";
   		public static var EVENT_PUSH_pushAddRoom:String = "event_push_pushAddRoom";
   		public static var EVENT_PUSH_pushLevelRoom:String = "event_push_pushLevelRoom";
   		public static var EVENT_PUSH_pushPublicMessage:String = "event_push_pushPublicMessage";
   		public static var EVENT_PUSH_pushPrivateMessage:String = "event_push_pushPrivateMessage";
   		public static var EVENT_PUSH_pushGetNotice:String = "event_push_pushGetNotice";
   		public static var EVENT_PUSH_pushStarUser:String = "event_push_pushStarUser";
   		public static var EVENT_PUSH_pushErrorConnection:String = "event_push_pushErrorConnection";
   		public function cs_Friends(uid:int,curPage:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:Friends"+",uid:"+uid+","+"curPage:"+curPage+'}');
}
  	 	public function responseFriends(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_Friends);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_UserInfo(uid:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:UserInfo"+",uid:"+uid+'}');
}
  	 	public function responseUserInfo(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_UserInfo);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_ListRoom(category:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:ListRoom"+",category:"+category+'}');
}
  	 	public function responseListRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_ListRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_SendBroadCast(content:String,sendLink:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:SendBroadCast"+",content:"+content+","+"sendLink:"+sendLink+'}');
}
  	 	public function responseSendBroadCast(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_SendBroadCast);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_InitRoom(roomId:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:InitRoom"+",roomId:"+roomId+'}');
}
  	 	public function responseInitRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_InitRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_LevelRoom():void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:LevelRoom"+'}');
}
  	 	public function responseLevelRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_LevelRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_GetRoom(roomId:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:GetRoom"+",roomId:"+roomId+'}');
}
  	 	public function responseGetRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_GetRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_ListSingerUser(roomId:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:ListSingerUser"+",roomId:"+roomId+'}');
}
  	 	public function responseListSingerUser(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_ListSingerUser);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_ListUser(roomId:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:ListUser"+",roomId:"+roomId+'}');
}
  	 	public function responseListUser(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_ListUser);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_ListAllUser(roomId:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:ListAllUser"+",roomId:"+roomId+'}');
}
  	 	public function responseListAllUser(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_ListAllUser);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_ListUserGift(uid:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:ListUserGift"+",uid:"+uid+'}');
}
  	 	public function responseListUserGift(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_ListUserGift);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_ListUserSongs(uid:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:ListUserSongs"+",uid:"+uid+'}');
}
  	 	public function responseListUserSongs(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_ListUserSongs);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_ListGift(curPage:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:ListGift"+",curPage:"+curPage+'}');
}
  	 	public function responseListGift(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_ListGift);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_SendMessage(content:String,recUid:int,isPrivate:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:SendMessage"+",content:"+content+","+"recUid:"+recUid+","+"isPrivate:"+isPrivate+'}');
}
  	 	public function responseSendMessage(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_SendMessage);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_SendGift(recUid:int,giftId:int,count:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:SendGift"+",recUid:"+recUid+","+"giftId:"+giftId+","+"count:"+count+'}');
}
  	 	public function responseSendGift(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_SendGift);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
   		public function cs_CreateNewRoom(roomName:String,pawword:String,maxUser:int,limits:int):void{
					_netUtil.send("{jsessionid:"+jsessionid+",method:CreateNewRoom"+",roomName:"+roomName+","+"pawword:"+pawword+","+"maxUser:"+maxUser+","+"limits:"+limits+'}');
}
  	 	public function responseCreateNewRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_RES_CreateNewRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushBroadCast(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushBroadCast);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushSingerInRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushSingerInRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushListenInRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushListenInRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushGiftMessage(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushGiftMessage);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushAddRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushAddRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushLevelRoom(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushLevelRoom);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushPublicMessage(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushPublicMessage);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushPrivateMessage(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushPrivateMessage);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushGetNotice(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushGetNotice);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushStarUser(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushStarUser);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
  	 	public function pushErrorConnection(resObj:Object):void{
   			var commEvent:CommonEvent = new CommonEvent(EVENT_PUSH_pushErrorConnection);
   				commEvent.data        = resObj;
   				dispatchEvent(commEvent);
   			}
			public static function getInstance():AbsPlayerData{
							if (_instance == null) {
								_instance = new AbsPlayerData();
								}
							return _instance;
				}

     } 
}