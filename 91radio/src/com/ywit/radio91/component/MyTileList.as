package com.ywit.radio91.component
{
	import fl.containers.ScrollPane;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class MyTileList extends ScrollPane {
		private  var _context:Sprite;
		private var _dataProvider:Array;
		public var _columnCount:int = 1;
		public var _rowHeight:int = 30;
		public var _columnWidth:int = 248;
		public function MyTileList() {
			super();
			_context = new Sprite();
			this.source = _context;
			_dataProvider = new Array();
			
		}
		
		public function get  dataProvider():Array{
			return _dataProvider;
		}
		
		public function set dataProvider(dataProvider:Array):void{
			deleteAllCell();
			var xNow:int = 0;
			var yNow:int = 0;
			for (var i:int=0;i<dataProvider.length;i++){
				var cell:DisplayObject = dataProvider[i] as DisplayObject;
				
				if(!cell){
					continue;
				}
				xNow = (i%_columnCount*_columnWidth);
				yNow = (int(i/_columnCount)*_rowHeight);
				cell.x = xNow;
				cell.y = yNow;
				_context.addChild(cell);
			}
			
			this.update();
		}
		//清空内容
		public function deleteAllCell():void{
			if(!_context){
				return;
			}
			var num:int = _context.numChildren;
			for(var i:int=0;i<num;i++){
				_context.removeChildAt(0);
			}
		}
		public function addCell(cell:Sprite):void{
			_context.addChild(cell);
			this.update();
		}
		
		
	}
}