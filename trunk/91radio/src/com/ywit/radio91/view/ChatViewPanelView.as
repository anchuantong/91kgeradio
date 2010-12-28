package com.ywit.radio91.view
{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class ChatViewPanelView extends Sprite {
		private var _height:int ;
		private var _wight:int ;
		private var sprite2:MainRoomInfoFrame_dragLine = new MainRoomInfoFrame_dragLine();
		private var mouseHitArea:Sprite = new Sprite();
		private var startDrop:Boolean = false;
		public static const PANEL_1:int = 1;
		public static const PANEL_2:int = 2;
		
		private var displayObject1:MyTextOut;
		private var displayObject2:MyTextOut;
		
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
		override public function set height(height:Number):void{
			this._height= height;
			sprite2.y = 78;
			updateSize();
			
			this.graphics.clear();
			this.graphics.lineStyle(0,0,0);
			this.graphics.beginFill(0,0.1);
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
		private function mouseMoveHandel(e:MouseEvent):void{
			if(startDrop){
				if(_height-mouseHitArea.mouseY-sprite2.height>=30&&mouseHitArea.mouseY >=30){
					sprite2.y = mouseHitArea.mouseY-sprite2.height/2;
					updateSize();
				}
			}
		}
		
		public function addPlane(location:int,displayObject:MyTextOut):void{
			switch(location){
				case PANEL_1:
					if(displayObject1){
						removeChild(displayObject);
					}
					displayObject1 = displayObject;
					addChild(displayObject);
					break;
				case PANEL_2:
					if(displayObject2){
						removeChild(displayObject);
					}
					displayObject2 = displayObject;
					addChild(displayObject);
					break;
			}
			updateSize();
		}
		
		private function updateSize():void{
			if(displayObject1){
				displayObject1.y = 0;
				displayObject1.updateHight(sprite2.y);
			}
			if(displayObject2){
				displayObject2.y = sprite2.y+sprite2.height;
				displayObject2.updateHight(_height-sprite2.y-sprite2.height);
			}
		}
	}
}