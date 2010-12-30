package com.ywit.radio91.util
{
	import com.ywit.radio91.center.UModelLocal;
	
	import flash.display.Sprite;

	/**
	 * main.swf对外调用base.swf的方法集合
	 */ 
	public class BaseInteract
	{
		//调用外部接口的句柄
		//目前使用main的父方法调用
		private static var _invoker:* = ViewHelper._main.parent;
		private static var _debug:int = UModelLocal.getInstance().debug;
		public function BaseInteract()
		{
		}
		/**
		 * 点击频道开唱按钮，需要调用base.swf的时间,baseStartSongCheck
		 */ 
		public static function baseStartSongCheck():void{
			if(_debug == 0){
				trace("baseStartSongCheck");
				return;
			}
			_invoker["baseStartSongCheck"]();
		}
		/**
		 * 在我的歌本，点击开始唱歌按钮，请调用base.swf的baseStartSing事件，传入songsId参数
		 */ 	
		public static function baseStartSing(songsId:int):void{
			if(_debug == 0){
				trace("baseStartSing");
				return;
			}
			_invoker["baseStartSing"](songsId);
		}
		/**
		 * 公聊中，如果是开始唱歌是调用baseStartListen，如果是唱完则是调用base.swf的baseStartSing事件
		 */ 
		public static function baseStartListen(uid:int):void{
			if(_debug == 0){
				trace("baseStartListen");
				return;
			}
			_invoker["baseStartListen"](uid);
		}
		
		/**
		 * 离开房间的时候调用,baseLeaveRoom
		 */ 
		public static function baseLeaveRoom(roomId:int):void{
			if(_debug == 0){
				trace("baseLeaveRoom");
				return;
			}
			_invoker["baseLeaveRoom"](roomId);
		}
		
		/**
		 * 进入房间的时候调用,baseLeaveRoom
		 */ 
		public static function baseInitRoom(roomId:int):void{
			if(_debug == 0){
//				var sprite:Sprite = new Sprite();
//				sprite.graphics.beginFill(0x000000);
//				sprite.graphics.drawRect(0,0,800,600);
//				sprite.graphics.endFill();
//				ViewHelper._main.addRoomBottom(sprite);
//				
//				ViewHelper._main.addKplayer(sprite);
				return;
			}
			_invoker["baseInitRoom"](roomId);
		}
		
		/**
		 * 取消的时候调用外部的方法,移除并返回应用的上一层
		 */ 
		public static function cancelRadioSocket():void{
			if(_debug == 0){
				trace("cancelRadioSocket");
				return;
			}
			_invoker["cancelRadioSocket"]();
		}
		
		
	}
}