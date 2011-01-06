package com.ywit.radio91.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElement;
	
/**
 * 导航界面使用的工具类，使得在任何地方都可以引用管理界面
 * 使用该工具产生的view在同一时刻只能存在一个实例，以前存在的实例将被立即销毁
 */ 	
	public class ViewHelper
	{
		public static var register:Register;
		private static var activeViews:Dictionary = new Dictionary();
		
		public static var _main:Main;
		/**
		 * 添加一个view实例到父容器
		 */ 
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
	/**
	 *  得到一个已经存在的view实例
	 */ 
		public static function getView(view:String):DisplayObject {
			var oldView:DisplayObject = activeViews[view];
			if(oldView == null){
				oldView = createView(view);
			}
			return oldView;
		}		
		
		/**
		 * 从一个实例导航到另一个实例并且销毁以前的实例
		 */ 
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
		
		/**
		 * 
		 * 弹出一个view实例并且作为有模式的具有灰色背景的窗口，居中对齐。
		 */ 
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
		
		/**
		 *  删除弹出的窗口
		 */ 
		public static function removePopView(view:String):void{
			var popView:DisplayObject = getView(view);
			if(popView&&popView.parent&&popView.parent.parent){
				popView.parent.parent.removeChild(popView.parent);
			}
			removeView(view);
			
		}	

	}
}