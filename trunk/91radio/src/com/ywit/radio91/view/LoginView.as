package com.ywit.radio91.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class LoginView extends AbsView
	{
		public var username:TextField = new TextField();
		
		public var password:TextField = new TextField();
		
		public var loginBut:MovieClip;
		
		
		
		public function LoginView() {
			
			username.text = "用户名:";
			addChild(username);
						
			password.text = "密码:";
			password.y = 40;
			addChild(password);
			
			loginBut.y = 60;
			addChild(loginBut);
		}
		override public function destory():void{
			super.destory();
		}
		
	}
}