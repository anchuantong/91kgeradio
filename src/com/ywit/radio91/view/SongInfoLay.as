/**
 * 这个一个类描述的是在房间顶部那个滚动条*/
package com.ywit.radio91.view
{
	import com.greensock.TweenLite;
	import com.ywit.radio91.util.HashMap;
	
	import flash.display.Sprite;

	public class SongInfoLay extends Sprite {
		private var songInfo1:SongInfoLayCell = new SongInfoLayCell();
		private var songInfo2:SongInfoLayCell = new SongInfoLayCell();
		public var songInfo3:SongInfoLayCell = new SongInfoLayCell();
		public var songInfo4:SongInfoLayCell = new SongInfoLayCell();
		public var songInfo5:SongInfoLayCell = new SongInfoLayCell();
		public var songInfo6:SongInfoLayCell = new SongInfoLayCell();
		
		public var songInfoBuf1:SongInfoLayCell ;
		public var songInfoBuf2:SongInfoLayCell ;
		
		public var position1:SongInfoLayCell;
		public var position2:SongInfoLayCell;
		public var position3:SongInfoLayCell;
		public var position4:SongInfoLayCell;
		
		public var positionKey1:String;
		public var positionKey2:String;
		public var positionKey3:String;
		public var positionKey4:String;
		
		public var maskSprite:Sprite = new Sprite();
		
		
		public function addDataSongInfo(obj:Object):Boolean{
			if(!position1.isShow){
				isViewingMap.put(positionKey1,obj);
				position1.setUser(obj);
				return true;
			}
			if(!position2.isShow){
				isViewingMap.put(positionKey2,obj);
				position2.setUser(obj);
				return true;
			}
			if(!position3.isShow){
				isViewingMap.put(positionKey3,obj);
				position3.setUser(obj);
				return true;
			}
			if(!position4.isShow){
				isViewingMap.put(positionKey4,obj);
				position4.setUser(obj);
				return true;
			}
			return false;
		}
		public function updateSongInfo():void{
			refersh();
			TweenLite.to(songInfo5,1,{y:songInfo5.y-36});
			TweenLite.to(songInfo6,1,{y:songInfo6.y-36});
			
			TweenLite.to(songInfo3,1,{y:songInfo3.y-36});
			TweenLite.to(songInfo4,1,{y:songInfo4.y-36});
			
			TweenLite.to(songInfo1,1,{y:songInfo1.y-36});
			TweenLite.to(songInfo2,1,{y:songInfo2.y-36});
		}
		private function refersh():void{
			if(songInfo1.y <= 36){
				songInfo1.y =7+36+36+36;
				songInfoBuf1 = songInfo3;
				key = "songInfo3";
				isViewingMap.remove(key);
				songInfo3.buttonMode = false;
//				trace("删除:"+key);
				
				position1 = songInfo5;
				position2 = songInfo6;
				position3 = songInfo1;
				position4 = songInfo2;
				
				positionKey1 = "songInfo5";
				positionKey2 = "songInfo6";
				positionKey3 = "songInfo1";
				positionKey4 = "songInfo2";
			}
			
			if(songInfo2.y <= 36){
				songInfo2.y =7+36+36+36;
				songInfoBuf2 = songInfo4;
				key2 = "songInfo4";
				isViewingMap.remove(key2);
				songInfo4.buttonMode = false;
//				trace("删除:"+key2);
			}
			if(songInfo3.y <= 36){
				songInfo3.y =7+36+36+36;
				songInfoBuf1 = songInfo5;
				key = "songInfo5";
				isViewingMap.remove(key);
				songInfo5.buttonMode = false;
//				trace("删除:"+key);
				
				position1 = songInfo1;
				position2 = songInfo2;
				position3 = songInfo3;
				position4 = songInfo4;
				
				positionKey1 = "songInfo1";
				positionKey2 = "songInfo2";
				positionKey3 = "songInfo3";
				positionKey4 = "songInfo4";
			}
			if(songInfo4.y <= 36){
				songInfo4.y =7+36+36+36;
				songInfoBuf2 = songInfo6;
				key2 = "songInfo6";
				isViewingMap.remove(key2);
				songInfo6.buttonMode = false;
//				trace("删除:"+key2);
			}
			if(songInfo5.y <= 36){
				songInfo5.y =7+36+36+36;
				songInfoBuf1 = songInfo1;
				key = "songInfo1";
				isViewingMap.remove(key);
				songInfo1.buttonMode = false;
//				trace("删除:"+key);
				
				position1 = songInfo3;
				position2 = songInfo4;
				position3 = songInfo5;
				position4 = songInfo6;
				
				positionKey1 = "songInfo3";
				positionKey2 = "songInfo4";
				positionKey3 = "songInfo5";
				positionKey4 = "songInfo6";
			}
			if(songInfo6.y <= 36){
				songInfo6.y =7+36+36+36;
				songInfoBuf2 = songInfo2;
				key2 = "songInfo2";
				isViewingMap.remove(key2);
				songInfo2.buttonMode = false;
//				trace("删除:"+key2);
			}
		}
		public var key:String ="songInfo1";
		public var key2:String ="songInfo2";
		
		public var isViewingMap:HashMap = new HashMap();
		public function SongInfoLay() {
			songInfo1.x = 10;
			songInfo1.y = 7;
				
			songInfo2.x = 200;
			songInfo2.y = 7;
				
			songInfo3.x = 10;
			songInfo3.y = 7+36;
			
			songInfo4.x = 200;
			songInfo4.y = 7+36;
			
			songInfo5.x = 10;
			songInfo5.y = 7+36+36;
			
			songInfo6.x = 200;
			songInfo6.y = 7+36+36;
			
			songInfoBuf1 = songInfo1;
			songInfoBuf2 = songInfo2;
			
			addChild(songInfo1);
			addChild(songInfo2);
			addChild(songInfo3);
			addChild(songInfo4);
			addChild(songInfo5);
			addChild(songInfo6);
			
			addChild(maskSprite);
			this.mask = maskSprite;
			
			this.graphics.lineStyle(0,0,0);
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,385,115);
			this.graphics.endFill();
			
			maskSprite.y=38;
			maskSprite.graphics.lineStyle(0,0,0);
			maskSprite.graphics.beginFill(0,0.3);
			maskSprite.graphics.drawRect(0,0,385,81);
			maskSprite.graphics.endFill();
			
//			songInfo1.userStuats.visible = false;
//			songInfo2.userStuats.visible = false;
//			songInfo3.userStuats.visible = false;
//			songInfo4.userStuats.visible = false;
//			songInfo5.userStuats.visible = false;
//			songInfo6.userStuats.visible = false;
			
			position1 = songInfo3;
			position2 = songInfo4;
			position3 = songInfo5;
			position4 = songInfo6;
			
			positionKey1 = "songInfo3";
			positionKey2 = "songInfo4";
			positionKey3 = "songInfo5";
			positionKey4 = "songInfo6";
		}
		public function isViewing(obj:Object):Boolean{
			for each(var viewObj:Object in isViewingMap.values()){
				if(viewObj.uid == obj.uid){
					return true;
				}
			}
			return false;
		}
		public function isViewingMapDelete(obj:Object):void{
			for each(var key:String in isViewingMap.keys()){
				var viewObj:Object = isViewingMap.getValue(key);
				if(viewObj!=null &&viewObj.uid == obj.uid){
					isViewingMap.remove(key);
					return;
				}
			}
		}
		public function levelHandel(obj:Object):void{
			if(!obj){
				return;
			}
			setLevel(obj,songInfo1);
			setLevel(obj,songInfo2);
			setLevel(obj,songInfo3);
			setLevel(obj,songInfo4);
			setLevel(obj,songInfo5);
			setLevel(obj,songInfo6);
			
			isViewingMapDelete(obj);
		}
		private function setLevel(obj:Object,songInfoLayCell:SongInfoLayCell):void{
			if(songInfoLayCell._obj == null || obj == null){
				return;
			}
			if(obj.uid != songInfoLayCell._obj.uid){
				return;
			}
			
			songInfoLayCell.setNoUser();
			
		}
	}
}