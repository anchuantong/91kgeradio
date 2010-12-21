package com.ywit.radio91.component
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.TweenPlugin;
	import com.ywit.radio91.util.TransformAroundCenterPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	

	public class Button extends Sprite
	{
		public var id:Number = 0;
		public var oldX:int = x;
		public var oldY:int = y;
		private static var overFilters:Array = [new ColorMatrixFilter([1,0,0,0,30,0,1,0,0,30,0,0,1,0,30,0,0,0,1,0])];
		
		public function Button():void
		{
//			TweenPlugin.activate([TransformAroundCenterPlugin]);
//			var oldX:int = this.x;
//			var oldY:int = this.y;
				
//			stop();
			this.buttonMode = true;
			this.useHandCursor = true;
//			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			
//			var matrix:Matrix = this.transform.matrix;
//			matrix.tx = 0;
//			matrix.ty = 0;
//			matrix.translate(-1*this.width/2,-1*this.height/2);
			
		}
		

//		public function addClick(callback:Function=null):void{
//			this.addEventListener(MouseEvent.CLICK,callback);
////			this.gotoAndStop(1);
//			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:0.7},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:0}});
//		}
		private function onOver(evt:MouseEvent):void{
//			if(evt.target.mouseEnabled){
//				TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:1},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:2}});
//				TweenMax.to(this, 0.4, {TransformAroundCenterPlugin:{scaleX:1.2,scaleY:1.2}});
//				this.x = oldX-(Number(this.width)*0.2/2);
//				this.y = oldY-(Number(this.height)*0.2/2);
//				this.scaleX = 1.2;
//				this.scaleY = 1.2;
//				TweenMax.to(this, 0.4, {scaleX:1.2, scaleY:1.2});//中点缩放
//				evt.target.gotoAndPlay("show");
//				this.scaleX = 1.2;
//				this.scaleY = 1.2;
//			this.filters = overFilters;
			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:1},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:2}});
//			}
		}
		private function onOut(evt:MouseEvent):void{
//			if(evt.target.mouseEnabled){
//				TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:0.7},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:0}});
//				this.x = oldX;
//				this.y = oldY;
//				this.scaleX = 1;
//				this.scaleY = 1;
//				TweenMax.to(this, 0.4, {scaleX:1, scaleY:1});//中点缩放
//				evt.target.gotoAndPlay("hide");
//			this.scaleX = 1;
//			this.scaleY = 1;
//			}
//			this.filters = null;
			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:0.7},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:0}});
		}
//		public function setOver():void{
//			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:1},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:2}});
//			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:1},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:2}});
//			mouseEnabled = false;
//		}
//		public function setDisabled():void{
//			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:0}});
//			this.mouseEnabled = false;
//		}
//		public function setEnabled():void{
//			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:1}});
//			this.mouseEnabled = true;
//		}
//		public function setOut():void{
//			TweenMax.to(this, 0.4, {colorMatrixFilter:{saturation:0.7},glowFilter:{color:0x66ff99, alpha:1, blurX:5, blurY:5, strength:0}});
//			mouseEnabled = true;
//			this.gotoAndStop(1);
//		}
	}
}