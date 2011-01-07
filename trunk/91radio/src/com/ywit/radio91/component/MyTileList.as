/**
 * 这个类是一个列表类 ,用在房间列表,房间界面右下角的用户列表,歌本列表.
 */
package com.ywit.radio91.component
{
	import fl.containers.ScrollPane;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class MyTileList extends ScrollPane {
		/**
		 * 用来存放内容的容器*/
		private  var _context:Sprite;
		/**
		 * 这个数组中存放的是需要显示的元素*/
		private var _dataProvider:Array;
		/**
		 * 多少列,默认是1*/
		public var _columnCount:int = 1;
		/**
		 * 显示单位的高度*/
		public var rowHeight:int = 30;
		/**
		 * 显示单位的宽度*/
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
		
		/**
		 * 这个方法是刷新显示的方法 在,
		 * */
		public function set dataProvider(dataProvider:Array):void{
			deleteAllCell();
			var xNow:int = 0;
			var yNow:int = 0;
			//按照当前的规则算坐标添加
			for (var i:int=0;i<dataProvider.length;i++){
				var cell:DisplayObject = dataProvider[i] as DisplayObject;
				
				if(!cell){
					continue;
				}
				xNow = (i%_columnCount*_columnWidth);
				yNow = (int(i/_columnCount)*rowHeight);
				cell.x = xNow;
				cell.y = yNow;
				_context.addChild(cell);
			}
			
			this.update();
		}
		//清空内容
		/**
		 * 将当前显示的所有内容全部清除*/
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