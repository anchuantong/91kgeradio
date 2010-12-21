package com.ywit.radio91.view
{
	import com.ywit.radio91.util.BaseInteract;
	import com.ywit.radio91.util.ButtonUtil;
	import com.ywit.radio91.util.ViewHelper;
	
	import fl.events.ListEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MySongCellView extends Sprite {
		
		public var ui_MySongCell:UI_MySongCell = new UI_MySongCell();
		public var _obj:Object;
		public function MySongCellView(obj:Object) {
			this._obj = obj;
			
			ui_MySongCell.mySongCellBg.visible = false;
			ui_MySongCell.songsName.text = _obj["songsName"];
			ui_MySongCell.songsSinger.text = _obj["songsSinger"];
			addChild(ui_MySongCell);
			
			ButtonUtil.changeButton(ui_MySongCell.btn_startSinging).addEventListener(MouseEvent.CLICK,startSingHandel);
			ui_MySongCell.btn_startSinging.buttonMode = true;
		}
		public function startSingHandel(e:Event=null):void{
			ConfirmView.show("开始唱 "+ui_MySongCell.songsName.text+" 吗?",ViewHelper._main,mySongs_itemDoubleClickHandel2,e,true);
		}
		private function mySongs_itemDoubleClickHandel2(e:ListEvent):void{
			BaseInteract.baseStartSing(_obj["songsId"]);
		}
	}
}