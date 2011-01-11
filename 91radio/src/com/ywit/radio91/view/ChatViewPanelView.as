/**
 * 这个类是为了制作公聊和私聊之间的滚动效果而设计的
 * */
package com.ywit.radio91.view
{
	
	import flash.display.MovieClip;
	import flash.display.Shape;
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
		
		private var mouseShap:MovieClip = new MovieClip();
		
		//只有分上下 两个区域
		public function ChatViewPanelView(wight:int,height:int) {
			this._wight= wight;
			this.height= height;
			addChild(sprite2);
			drapMouse();
			
			mouseHitArea.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandel);
			sprite2.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandel);
			sprite2.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandel);
			sprite2.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandel);
			mouseHitArea.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandel);
			
			addEventListener(Event.ENTER_FRAME,updateSize);
			mouseShap.mouseEnabled=false;
			mouseShap.mouseChildren=false;
			mouseShap.x = mouseX;
			mouseShap.y = mouseY-10;
			
			addEventListener(MouseEvent.MOUSE_MOVE,function move(evt:MouseEvent):void{
				mouseShap.x = mouseX;
				mouseShap.y = mouseY-10;
				evt.updateAfterEvent();
			});
			
			setDropHeightDefault();
		}
		public function setDropHeightDefault():void{
			sprite2.y = this._height-dropHeight;
		}
		private function drapMouse():void
		{
			mouseShap.graphics.clear();
			
			mouseShap.graphics.lineStyle(1,0x000000,0.8);
			mouseShap.graphics.moveTo(0,5);
			mouseShap.graphics.lineTo(5,0);
			mouseShap.graphics.lineTo(10,5);
			mouseShap.graphics.lineTo(6,5);
			mouseShap.graphics.lineTo(6,20);
			mouseShap.graphics.lineTo(10,20);
			mouseShap.graphics.lineTo(5,25);
			mouseShap.graphics.lineTo(0,20);
			mouseShap.graphics.lineTo(4,20);
			mouseShap.graphics.lineTo(4,5);
			mouseShap.graphics.lineTo(4,5);
			mouseShap.graphics.lineTo(0,5);
			mouseShap.graphics.endFill();
			this.addChild(mouseShap);
			mouseShap.visible  = false;
		}
		private var dropHeight:int = 80;
		//设置这个类的高度,同是调整两个界面的高度
		override public function set height(height:Number):void{
			this._height= height;
			
//			updateSize();
			
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
			//Mouse.cursor = MouseCursor.HAND;
			Mouse.hide();
			mouseShap.visible = true;
			
		}
		private function mouseOutHandel(e:MouseEvent):void{
			Mouse.show();
			mouseShap.visible = false;
			Mouse.cursor = MouseCursor.AUTO;
		}
		private function mouseDownHandel(e:MouseEvent):void{
			
			//Mouse.cursor = MouseCursor.HAND;
			startDrop = true;
			addChild(mouseHitArea);
			mouseHitArea.addEventListener(MouseEvent.MOUSE_OUT,mouseUpHandel);
		}
		private function mouseUpHandel(e:MouseEvent):void{
			mouseShap.visible = false;
			Mouse.show();
			startDrop = false;
			//Mouse.cursor = MouseCursor.HAND;
			if(	mouseHitArea.hasEventListener(MouseEvent.MOUSE_OUT)){
				mouseHitArea.removeEventListener(MouseEvent.MOUSE_OUT,mouseUpHandel);
			}
			if(contains(mouseHitArea)){
				removeChild(mouseHitArea);
			}
		}
		public static const DRAG_LINE_MOVE:String = "DragLineMove";
		private function mouseMoveHandel(e:MouseEvent):void{
			//Mouse.cursor = MouseCursor.HAND;
			trace("move")
			if(startDrop){
				if(_height-mouseHitArea.mouseY-sprite2.height>=15&&mouseHitArea.mouseY >=30){
					sprite2.y = mouseHitArea.mouseY-sprite2.height/2;
//					dispatchEvent(new Event(DRAG_LINE_MOVE));
//					updateSize();
					
					if(displayObject1){
						displayObject1.update();
						displayObject1.verticalScrollPosition= displayObject1.maxVerticalScrollPosition;
					}
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
//			updateSize();
		}
		//跟新两个界面的高度
		private function updateSize(event:Event=null):void{
			var ischange:Boolean =  false;
			if(displayObject1&&displayObject1.height!=sprite2.y+5){
				displayObject1.y = 0;
				displayObject1.updateHight(sprite2.y+5);
				ischange = true;
			}
			if(displayObject2&&displayObject2.height!=(_height-sprite2.y-sprite2.height+5)){
				displayObject2.y = sprite2.y+sprite2.height-5;
				displayObject2.updateHight(_height-sprite2.y-sprite2.height+5);
				ischange = true;
			}
			
			if(ischange){
				dispatchEvent(new Event(DRAG_LINE_MOVE));
			}
		}
	}
}