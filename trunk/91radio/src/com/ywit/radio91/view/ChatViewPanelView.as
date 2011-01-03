/**
 * 这个类是为了制作公聊和私聊之间的滚动效果而设计的*/
package com.ywit.radio91.view
{
	
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class ChatViewPanelView extends Sprite {
		private var _height:int ;
		private var _wight:int ;
		//中间可以拖动的样式
		private var sprite2:MainRoomInfoFrame_dragLine = new MainRoomInfoFrame_dragLine();
		//用来监听鼠标响应事件
		private var mouseHitArea:Sprite = new Sprite();
		private var startDrop:Boolean = false;
		public static const PANEL_1:int = 1;
		public static const PANEL_2:int = 2;
		
		private var displayObject1:MyTextOut;
		private var displayObject2:MyTextOut;
		
		//只有分上下 两个区域
		public function ChatViewPanelView(wight:int,height:int) {
			this._wight= wight;
			this.height= height;
			mouseHitArea.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandel);
			sprite2.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandel);
			sprite2.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandel);
			sprite2.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandel);
			mouseHitArea.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandel);
			
			addChild(sprite2);
		}
		//设置这个类的高度,同是调整两个界面的高度
		override public function set height(height:Number):void{
			this._height= height;
			sprite2.y = 78;
			updateSize();
			
			this.graphics.clear();
			this.graphics.lineStyle(0,0,0);
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,_wight,_height);
			this.graphics.endFill();
			
			mouseHitArea.graphics.clear();
			mouseHitArea.graphics.lineStyle(0,0,0);
			mouseHitArea.graphics.beginFill(0,0);
			mouseHitArea.graphics.drawRect(0,0,_wight,_height);
			mouseHitArea.graphics.endFill();
		}
		private function mouseOverHandel(e:MouseEvent):void{
			Mouse.cursor = MouseCursor.HAND;
		}
		private function mouseOutHandel(e:MouseEvent):void{
			Mouse.cursor = MouseCursor.AUTO;
		}
		private function mouseDownHandel(e:MouseEvent):void{
			startDrop = true;
			addChild(mouseHitArea);
			mouseHitArea.addEventListener(MouseEvent.MOUSE_OUT,mouseUpHandel);
		}
		private function mouseUpHandel(e:MouseEvent):void{
			startDrop = false;
			Mouse.cursor = MouseCursor.AUTO;
			if(	mouseHitArea.hasEventListener(MouseEvent.MOUSE_OUT)){
				mouseHitArea.removeEventListener(MouseEvent.MOUSE_OUT,mouseUpHandel);
			}
			if(contains(mouseHitArea)){
				removeChild(mouseHitArea);
			}
		}
		public static const DRAG_LINE_MOVE:String = "DragLineMove";
		private function mouseMoveHandel(e:MouseEvent):void{
			if(startDrop){
				if(_height-mouseHitArea.mouseY-sprite2.height>=15&&mouseHitArea.mouseY >=30){
					sprite2.y = mouseHitArea.mouseY-sprite2.height/2;
					dispatchEvent(new Event(DRAG_LINE_MOVE));
					updateSize();
				}
			}
		}
		/**
		 * location:是往哪个界面里添加,,会讲目标界面原有的对象移除掉在添加*/
		public function addPlane(location:int,displayObject:MyTextOut):void{
			switch(location){
				case PANEL_1:
					if(displayObject1){
						removeChild(displayObject);
					}
					displayObject1 = displayObject;
					addChildAt(displayObject,0);
					break;
				case PANEL_2:
					if(displayObject2){
						removeChild(displayObject);
					}
					displayObject2 = displayObject;
					addChildAt(displayObject,0);
					break;
			}
			updateSize();
		}
		//跟新两个界面的高度
		private function updateSize():void{
			if(displayObject1){
				displayObject1.y = 0;
				displayObject1.updateHight(sprite2.y+5);
			}
			if(displayObject2){
				displayObject2.y = sprite2.y+sprite2.height-5;
				displayObject2.updateHight(_height-sprite2.y-sprite2.height+5);
			}
		}
	}
}