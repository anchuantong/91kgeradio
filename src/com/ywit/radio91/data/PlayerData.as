package com.ywit.radio91.data
{
	import com.ywit.radio91.gen.data.AbsPlayerData;
/**
 * 继承了 absPlayerData,作为所有页面调用的方法的接收和发送的类
 * 必要的时候要进行复写，完成父类所不能完成的缓存数据的方法
 * 自动根据接口包装生成了send参数以及方法
 * 该类缓存了运行时各种需要缓存的数据
 */ 
	public class PlayerData extends AbsPlayerData
	{
		//请求房间列表返回的对象
		public var _listRoomResObj:Object;
		//初始化好房间以后得到的对象
		public var initRoomObj:Object;
		//请求当前用户返回的对象，格式请参考xml接口描述文档，client_server.xml
		public var playerObj:Object;
		
		public var serverTimerstp:int;
		public var clientTimerstp:int;
		
		public var broadCastPrice:int;
		
		private static var _instance:PlayerData;
		
				
		public static function getInstance():PlayerData {
		
			if (_instance == null) {
				_instance = new PlayerData();
			}
			return _instance;
			
			
		}
		public function fetchRoomObj(roomId:int):Object{
			//更新房间人数
			for each(var obj:Object in _listRoomResObj['roomList']){
				if(obj.roomId == roomId){
					return obj;
				}
			}
			return null;
		}
		
		override public function responseInitRoom(resObj:Object):void{
			initRoomObj = resObj;
			super.responseInitRoom(resObj);
		}
		
		/**
		 * 复写返回房间列表的方法
		 */ 	
		override public function responseListRoom(resObj:Object):void{
			_listRoomResObj = resObj;
			super.responseListRoom(resObj);
		}
		
		public function get listRoomResObj():Object{
			return _listRoomResObj
		}
	}
}