/**
 * 这个类是弹出一个确认框
 * 
 * */
package com.ywit.radio91.view
{
	import com.ywit.radio91.util.ViewHelper;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ConfirmView extends Sprite {
		private var ui_ConfirmView:UI_ConfirmView = new UI_ConfirmView();
		
		public function ConfirmView(sprite:Sprite=null,uix:int=0,uiy:int=0) {
			if(sprite){
				this.addChild(sprite);
			}
			ui_ConfirmView.x= uix;
			ui_ConfirmView.y= uiy;
			this.addChild(ui_ConfirmView);
			
			ui_ConfirmView.button_cancal.addEventListener(MouseEvent.CLICK,cancalButHandel);
			ui_ConfirmView.button_send.addEventListener(MouseEvent.CLICK,sendButHandel);
		}

		private function cancalButHandel(e:Event=null):void{
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
		private var _functionHandel:Function;
		private var _event:Event;
		private function sendButHandel(e:Event):void{
			cancalButHandel();
			_functionHandel(_event);
		}
		
		
		
		
		//	ConfirmView.show("asdasd",this,ddddd,true,800,800);
		//直接调用show,用法如上,
		//其中 functionHandel:是只点击了"确定"后所要做的事情
		public static function show(context:String,container:DisplayObjectContainer,functionHandel:Function,event:Event=null,canOtherNotDoing:Boolean=false,width:int=800,height:int = 800):void{
			var sprite:Sprite;
			if(canOtherNotDoing){
				sprite = new Sprite()
				sprite.graphics.beginFill(0x000000,0.5);
				sprite.graphics.drawRect(0, 0, width, height);
				sprite.graphics.endFill();
			}
			var confirmView:ConfirmView = new ConfirmView(sprite,250,280);
			
			container.addChild(confirmView);
			confirmView.ui_ConfirmView.context.text = context;
			confirmView._functionHandel = functionHandel;
			confirmView._event = event;
		}
	}
}