package com.ywit.radio91.view
{
	import com.ywit.radio91.constant.ViewRegister;
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.util.MarqueeText;
	import com.ywit.radio91.util.ViewHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	/**
	 * 一行滚动的播放条
	 * 可以附加一个显示一个房间链接 
	 */ 
	public class BroadCastLineView extends AbsView
	{
	
		private var _rollingMsg:RollingMsg;
		public var _isRollingOver:Boolean=false;
		//进入房间的链接
		private var _enterRoomBtn:UI_EnterRoomFromBC;
		public var roomId:int;
		
		public static var EVENT_ENTER_ROOM:String = "EVENT_ENTER_ROOM";
		public function BroadCastLineView(text:String,width:Number,delay:Number=1000,step:Number=10,roomId:int = 0,isout:Boolean=false)
		{
			this.roomId = roomId;
//			_marqueeTf = new MarqueeText(text,width,delay,step);
			
			_rollingMsg = new RollingMsg(text,width,step,isout);
			_rollingMsg.addEventListener(Event.COMPLETE,completeHandler);
			if(roomId >0){
				_enterRoomBtn = new UI_EnterRoomFromBC();
				_enterRoomBtn.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			super();
			
		}
		public var _broadCastObj:Object;
		public static function setBroadCastLineView(broadCastObj:Object,isOut:Boolean = false):BroadCastLineView{
			if(broadCastObj == null){
				return null;
			}
			var broadCastLineView:BroadCastLineView = new BroadCastLineView("<font color='#FF0099'>"+broadCastObj.uname+": </font><font color='#654533'>"+broadCastObj.content+"</font><font color='#6CCAFF'>"+broadCastObj.created+"</font>",430,1000,5,broadCastObj.roomId,isOut);
			broadCastLineView._broadCastObj = broadCastObj;
			return broadCastLineView;
		}
		
		private function completeHandler(e:Event):void{
			_isRollingOver = true;
			dispatchEvent(e);
		}
		
		private function clickHandler(e:MouseEvent):void{
			ConfirmView.show("准备进入 "+roomId+" 号房间吗?",ViewHelper._main,enterRoomHandel,e,true,800,800)
		}
		
		
		private function enterRoomHandel(e:MouseEvent):void{
			dispatchEvent(new Event(EVENT_ENTER_ROOM));
		}
		
		
		override protected function addChildren():void{

			this.addChild(_rollingMsg);
			if(_enterRoomBtn != null){
				this.addChild(_enterRoomBtn);
				_enterRoomBtn.x = _rollingMsg.x + _rollingMsg.width + 2;
				_enterRoomBtn.y = 0;
				_enterRoomBtn.buttonMode = true;
			}
		}
		
		override public function destory():void{
			super.destory();
			if(_enterRoomBtn != null){
				_enterRoomBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
			}
			
			
		}
		

	}
}
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.clearInterval;
import flash.utils.clearTimeout;
import flash.utils.setInterval;
import flash.utils.setTimeout;

/**
 * 滚动的消息
 * 第一次出现显示3秒
 * 然后自左向右滚动出去，
 * 第二次从右往左滚动，显示5秒然后自右向左滚动出去
 */ 
class RollingMsg extends Sprite{
	private var _tfMask:Sprite = new Sprite();
	private var m_txt:TextField = new TextField();
	//每次移动距离
	private var _step:Number = 10;
	private var _intervalId:int;
	private var _timeOutId:int;
	private var _maskWidth:Number;
	private var _isout:Boolean;
	public function RollingMsg(text:String,width:Number,step:int,isout:Boolean = false):void{
		_step = step
		this._isout = isout;
//		this.width = width;
		_maskWidth = width;
		_step = step;
		m_txt = new TextField();
		m_txt.selectable = false;
		m_txt.wordWrap = false;
		m_txt.multiline = false;
		m_txt.autoSize = TextFieldAutoSize.LEFT;
		m_txt.htmlText = text;
		addChild(m_txt);
		
		_tfMask.graphics.beginFill(0x000000);
		_tfMask.graphics.drawRect(0,0,width,100);
		_tfMask.graphics.endFill();
		
//		this.graphics.beginFill(0x000000);
//		this.graphics.drawRect(0,0,width,100);
//		this.graphics.endFill();
		
		this.addChild(_tfMask);
		m_txt.mask = _tfMask;
		startRolling();
	}
	
	public function startRolling():void{
		_timeOutId = setTimeout(rollingFirstTime,3000);
	} 
	
	private function rollingFirstTime():void{
		clearTimeout(_timeOutId);
		_intervalId = setInterval(function():void{
			if(m_txt.x <= -m_txt.width){
				clearInterval(_intervalId);
				rollingSeconedTime();
			}
			m_txt.x -= _step;
			trace("rollingFirstTime===>"+m_txt.x);
		
		},100);
	}
	
	/**
	 * 滚动完了第一遍，滚动第二遍的处理
	 */ 
	private function rollingSeconedTime():void{
		m_txt.x = this._maskWidth;
		_intervalId = setInterval(function():void{
			if(m_txt.x <= 5){
				clearInterval(_intervalId);
				if(_isout){
					dispatchEvent(new Event(Event.COMPLETE));
				}else{
					_timeOutId = setTimeout(rollingThirdTime,5000);
				}
			}
			m_txt.x -= _step;
			trace("rollingSeconedTime===>"+m_txt.x);
			
		},100);
	}
	
	private function rollingThirdTime():void{
		clearTimeout(_timeOutId);
		_intervalId = setInterval(function():void{
			if(m_txt.x <= -m_txt.width){
				clearInterval(_intervalId);
				dispatchEvent(new Event(Event.COMPLETE));
				trace("rolling is completed");
			}
			m_txt.x -= _step;
			trace("rollingThirdTime===>"+m_txt.x);
			
		},100);
	}
	
	
}