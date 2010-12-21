package com.ywit.radio91.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElement;
	
	
	public class ViewHelper
	{
		public static var register:Register;
		private static var activeViews:Dictionary = new Dictionary();
		
		public static var _main:Main;
		
		public static function addView(view:String, parent:DisplayObjectContainer):DisplayObject {
			var oldView:DisplayObject = activeViews[view];
			if(oldView!=null){
				removeView(view);
			}
			var newView:DisplayObject = createView(view);
			activeViews[view] = newView;
			parent.addChild(newView);
			return newView;
		}
	
		public static function getView(view:String):DisplayObject {
			var oldView:DisplayObject = activeViews[view];
			if(oldView == null){
				oldView = createView(view);
			}
			return oldView;
		}		
		public static function navigate(view_from:String, view_to:String, parent:DisplayObjectContainer):DisplayObject {
			var view:DisplayObject = addView(view_to, parent);
			if(activeViews[view_from]!=null){
				removeView(view_from);
			}
			return view;
		}
		
		public static function removeView(view:String):void {
//			var viewObject:* = activeViews[view];
//			if(viewObject){
//				var parent:* = viewObject["parent"];
//				if(parent != null && parent is Group){
//					Group(parent).removeElement(viewObject);
//				}
//				if(parent != null && parent is SkinnableContainer){
//					SkinnableContainer(parent).removeElement(viewObject);
//				}
//			}
			activeViews[view].destory();
			activeViews[view] = null;
		}		
		public static function createView(view:String):DisplayObject {
			var cls:Class = register.locateUnit(view) as Class;
			if(cls!=null){
				return new cls();
			}else {
				throw new Error("can't locate view: "+view);
			}

		}	
		
		public static function popView(view:String,parent:DisplayObjectContainer, width:Number=0,height:Number=0):DisplayObject {
			var sprite:Sprite = new Sprite();
			parent.addChild(sprite);
			var popedView:DisplayObject = addView(view, sprite);
			sprite.graphics.beginFill(0x000000,0.5);
			sprite.graphics.drawRect(0, 0, width, height);
			sprite.graphics.endFill();
			popedView.x = (sprite.width - popedView.width)/2;
//			popedView.y = (sprite.height - popedView.height)/2;
			popedView.y = sprite.height/2-popedView.height*3/2;
			
			return popedView;
			
		}
		
		public static function removePopView(view:String):void{
			var popView:DisplayObject = getView(view);
			if(popView&&popView.parent&&popView.parent.parent){
				popView.parent.parent.removeChild(popView.parent);
			}
			removeView(view);
			
		}	

	}
}