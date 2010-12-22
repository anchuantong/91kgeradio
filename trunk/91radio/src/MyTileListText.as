package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MyTileListText extends Sprite {
		public var myTileList:MyTileList = new MyTileList();
		
		public function MyTileListText() {
			
			myTileList.width = 523;
			myTileList.height = 300;
			
			var array:Array = new Array();
			
			myTileList.horizontalScrollPolicy = "off";
			myTileList.verticalScrollPolicy = "on";
			
			
			array.push(getRoomView());
			array.push(getRoomView());
			array.push(getRoomView());
			array.push(getRoomView());
			array.push(getRoomView());
			array.push(getRoomView());
			array.push(getRoomView());
			array.push(getRoomView());
			array.push(getRoomView());
			
			
			myTileList._columnCount =2;
			myTileList._columnWidth=254;
			myTileList._rowHeight=95;
			myTileList.dataProvider = array;
			
			addChild(myTileList);
		}
		
		private function getRoomView():UI_MovieClip_Room{
			var ui_MovieClip_Room:UI_MovieClip_Room = new UI_MovieClip_Room();
			ui_MovieClip_Room.buttonMode = true;
			ui_MovieClip_Room.mouseChildren = false;
			ui_MovieClip_Room.gotoAndStop(1);
			ui_MovieClip_Room.roomSelect_Bg.stop();
			ui_MovieClip_Room.movie_font.gotoAndStop(1);//可加入
			ui_MovieClip_Room.movie_roomMark.gotoAndStop(1);
			ui_MovieClip_Room.addEventListener(MouseEvent.MOUSE_OVER,overHandel);
			ui_MovieClip_Room.addEventListener(MouseEvent.MOUSE_OUT,outHandel);
			
			return ui_MovieClip_Room;
		}
		private function overHandel(e:Event):void{
			UI_MovieClip_Room(e.target).roomSelect_Bg.gotoAndStop(2);
		}
		
		private function outHandel(e:Event):void{
			UI_MovieClip_Room(e.target).roomSelect_Bg.gotoAndStop(1);
		}
	}
}