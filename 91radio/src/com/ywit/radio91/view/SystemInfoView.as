package com.ywit.radio91.view
{
	import com.ywit.radio91.util.BaseInteract;
	import com.ywit.radio91.util.ButtonUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	

	public class SystemInfoView extends AbsView
	{
		private var ui_Movieclip_NetCont:UI_Movieclip_NetCont = new UI_Movieclip_NetCont();
		public function SystemInfoView()
		{
//			ui_Movieclip_NetCont.x = Main.KG_WIDTH/2-ui_Movieclip_NetCont.width/2;
//			ui_Movieclip_NetCont.y = Main.KG_HEIGHT/2-ui_Movieclip_NetCont.height*3/2;
			addChild(ui_Movieclip_NetCont);
			ButtonUtil.changeButton(ui_Movieclip_NetCont.but_cancel).addEventListener(MouseEvent.CLICK,butCancalHandel);
		}
	
		private function butCancalHandel(e:Event):void{
			BaseInteract.cancelRadioSocket();
		}
		override public function destory():void{
			super.destory();
		}
	}
}