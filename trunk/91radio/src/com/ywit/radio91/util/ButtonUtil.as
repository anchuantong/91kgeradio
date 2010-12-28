package com.ywit.radio91.util
{
	
	import com.ywit.radio91.component.Button;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;

	public class ButtonUtil {

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