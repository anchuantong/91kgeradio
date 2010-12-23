package com.ywit.radio91.view
{
	import com.ywit.radio91.component.Button;
	import com.ywit.radio91.util.BaseInteract;
	import com.ywit.radio91.util.ButtonUtil;
	import com.ywit.radio91.util.ViewHelper;
	
	import fl.events.ListEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MySongCellView extends Sprite {
		
		public var ui_MySongCell:UI_MySongCell = new UI_MySongCell();
		public var _obj:Object;
		private var button:Button;
		public function MySongCellView(obj:Object) {
			this._obj = obj;
			
			ui_MySongCell.mySongCellBg.visible = false;
			ui_MySongCell.songsName.text = _obj["songsName"];
			ui_MySongCell.songsSinger.text = _obj["songsSinger"];
			addChild(ui_MySongCell);
			
			
			button = ButtonUtil.changeButton(ui_MySongCell.btn_startSinging);
			button.addEventListener("CLICK_HUATONG",startSingHandel);
			this.addChild(button);
//			ButtonUtil.changeButton(ui_MySongCell.btn_startSinging);
			
			if(!this.hasEventListener(MouseEvent.MOUSE_OVER)){
				this.addEventListener(MouseEvent.MOUSE_OVER,mySongs_itemOverHandel);
			}
			if(!this.hasEventListener(MouseEvent.MOUSE_OUT)){
				this.addEventListener(MouseEvent.MOUSE_OUT,mySongs_itemOutHandel);
			}
			
			if(!ui_MySongCell.hasEventListener(MouseEvent.DOUBLE_CLICK)){
				ui_MySongCell.doubleClickEnabled = true;
				ui_MySongCell.mouseChildren = false;
				ui_MySongCell.addEventListener(MouseEvent.DOUBLE_CLICK,mySongs_itemDoubleClickHandel);
			}
		}
		private function mySongs_itemOutHandel(e:MouseEvent):void{
			this.ui_MySongCell.mySongCellBg.visible = false;
		}
		private function mySongs_itemOverHandel(e:MouseEvent):void{
			this.ui_MySongCell.mySongCellBg.visible = true;
		}
		private function mySongs_itemDoubleClickHandel(e:MouseEvent):void{
			startSingHandel();
		}
		public function startSingHandel(e:Event=null):void{
			ConfirmView.show("开始唱 "+ui_MySongCell.songsName.text+" 吗?",ViewHelper._main,mySongs_itemDoubleClickHandel2,e,true);
		}
		private function mySongs_itemDoubleClickHandel2(e:Event):void{
			BaseInteract.baseStartSing(_obj["songsId"]);
		}
	}
}