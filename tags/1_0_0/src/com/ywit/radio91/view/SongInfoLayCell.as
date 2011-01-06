/**
 * 由名字可以知道这个类是房间顶部的滚动条中显示的对象*/
package com.ywit.radio91.view
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.ywit.radio91.constant.ViewRegister;
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.util.BaseInteract;
	import com.ywit.radio91.util.ViewHelper;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Timer;

	public class SongInfoLayCell extends Sprite {
		private var _songInfo:mc_songInfo = new mc_songInfo();
		private var _buttonMask:Sprite = new Sprite();
		public var _obj:Object;
		private var timer:Timer = new Timer(1000);
		public var isShow:Boolean = false;
		private var overFilters:Array = [new ColorMatrixFilter([1,0,0,0,30,0,1,0,0,30,0,0,1,0,30,0,0,0,1,0])];
		
		public function SongInfoLayCell() {
			this.addChild(_songInfo);
			_buttonMask.graphics.beginFill(0xffffff,0);
			_buttonMask.graphics.drawRect(0,0,_songInfo.width,_songInfo.height);
			_buttonMask.graphics.endFill();
			this.addChild(_buttonMask);

			setNoUser();
			timer.addEventListener(TimerEvent.TIMER,timerHandel);
			_buttonMask.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_buttonMask.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function overHandler(e:MouseEvent):void{
			if(this._obj == null){
				return;
			}
			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:1},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:2}});
		}
		
		private function outHandler(e:MouseEvent):void{
			if(this._obj == null){
				return;
			}
			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:0.7},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:0}});
		}
		
		public function setUser(obj:Object):void{
			if(obj == null||obj.status == 1){
				setNoUser();
				return;
			}
			this._obj = obj;
			var endTimestp:Number = obj["endTimestp"];
			var nowClientTimestp:int= int((new Date().time/1000));
			_songInfo.tf_songInfo.text = _obj.uname+"--"+_obj.songsName;
			trace("用户名:"+_obj.uname+"        歌曲名字:"+_obj.songsName);
			trace("进入房间的服务端时间:"+PlayerData.getInstance().serverTimerstp);
			trace("进入房间的客户端时间:"+PlayerData.getInstance().clientTimerstp);
			trace("当前显示的时间:"+nowClientTimestp);
			trace("歌曲结束的时间:"+endTimestp);
			trace("歌曲总长度:"+_obj.songsTime);
			trace("当前显示的服务端时间"+(nowClientTimestp-PlayerData.getInstance().clientTimerstp+PlayerData.getInstance().serverTimerstp));
			_singerTime = _obj.songsTime-endTimestp+nowClientTimestp+PlayerData.getInstance().clientTimerstp-PlayerData.getInstance().serverTimerstp
			trace("当前已经唱了"+_singerTime+"/"+_obj.songsTime);
//			var singerTime:int =_obj.songsTime-(endTimestp-PlayerData.getInstance().serverTimerstp-PlayerData.getInstance().clientTimerstp+int((new Date()).time/1000));
			
			timerHandel();
			
//			TweenLite.to(_songInfo.mc_songInfoProgressBar, _obj.songsTime-singerTime, {frame:100 ,onComplete:setNoUser});
			
			_buttonMask.buttonMode = true;
			
			if(!_buttonMask.hasEventListener(MouseEvent.CLICK)){
				_buttonMask.addEventListener(MouseEvent.CLICK,clickSongInfoHandel);
			}
			
			if(!timer.running){
				timer.start();
			}
			isShow = true;
		}
		private var _singerTime:int =0;
		private function timerHandel(e:Event=null):void{
			_singerTime++;
			
			var fram:int = int((_singerTime /_obj.songsTime)*100);
			if(fram>100){
				fram = 100;
			}
			_songInfo.mc_songInfoProgressBar.gotoAndStop(fram);
			_songInfo.userStuats.visible = true;
			
			if(_obj.micStatus == 1){
				_songInfo.userStuats.gotoAndStop(2);
			}else{
				_songInfo.userStuats.gotoAndStop(1);
			}
		}
		public function setNoUser():void{
			_songInfo.userStuats.visible = false;
			_songInfo.tf_songInfo.text = "";
			_songInfo.stop();
//			TweenLite.killTweensOf(_songInfo.mc_songInfoProgressBar);
			
			_songInfo.mc_songInfoProgressBar.gotoAndStop(1);
			if(_buttonMask.hasEventListener(MouseEvent.CLICK)){
				_buttonMask.removeEventListener(MouseEvent.CLICK,clickSongInfoHandel);
			}
			timer.stop();
			isShow = false;
			_buttonMask.buttonMode = false;
		}
		public function clickSongInfoHandel(e:Event):void{
			//#####
			if(PlayerData.getInstance().playerObj.uid == _obj.uid){
				return;
			}
			ConfirmView.show("收听 "+_obj.uname+" 的 "+_obj.songsName+" 吗?",ViewHelper._main,listenSongHandel,e,true);
			
		}
		private function listenSongHandel(e:Event):void{
			BaseInteract.baseStartListen(_obj["uid"]);
			var roomView:RoomView = ViewHelper.getView(ViewRegister.ROOM_VIEW) as RoomView;
			if(roomView){
				roomView.focusInWatchSinger();
			}
		}
	}
}