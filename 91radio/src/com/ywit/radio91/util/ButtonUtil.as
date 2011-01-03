/**
 * 这个类是将一个button类包装成另一个有效果的button类*/
package com.ywit.radio91.util
{
	
	import com.ywit.radio91.component.Button;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
/**
 * 如果需要为按钮加入移动上去的辉光效果请使用改类提供的静态方法changeButton。
 */ 
	public class ButtonUtil {
		/**
		 * 下面的button类是指定的效果*/
		public static function changeButton(button:DisplayObject):Button{
			var newButton :Button = new Button();
			
//			newButton.x = button.x;
//			newButton.y = button.y;
//			newButton.oldX = button.x;
//			newButton.oldY = button.y;
//			
//			button.x = newButton.width - button.width /2;
//			button.y = newButton.height - button.height /2;
			if(button.parent!==null){
				button.parent.addChild(newButton);
				button.parent.removeChild(button);
			}
			newButton.addChild(button);
			return newButton;
		}
	}
}