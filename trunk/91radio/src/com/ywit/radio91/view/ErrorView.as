/**
 * 错误界面的显示*/
package com.ywit.radio91.view
{
	import com.ywit.radio91.util.ButtonUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ErrorView extends AbsView
	{
		private var ui_ErrorView:UI_ErrorView = new UI_ErrorView();
		//functionHandel:是点击确定后所调用的方法
		public function ErrorView(str:String,functionHandel:Function=null)
		{
			ui_ErrorView.x = Main.KG_WIDTH/2-ui_ErrorView.width/2;
			ui_ErrorView.y = Main.KG_HEIGHT/2-ui_ErrorView.height*3/2;
			ui_ErrorView.text_errorContext.text = str;
			if(functionHandel==null){
				ButtonUtil.changeButton(ui_ErrorView.button_srue).addEventListener(MouseEvent.CLICK,function srueHandel(e:Event):void{
					if(ui_ErrorView.parent!=null){
						ui_ErrorView.parent.removeChild(ui_ErrorView);
					}
				});
			}else{
				ButtonUtil.changeButton(ui_ErrorView.button_srue).addEventListener(MouseEvent.CLICK,functionHandel);
			}
			
			addChild(ui_ErrorView);
		}
		
		override public function destory():void{
			super.destory();
		}
	}
}