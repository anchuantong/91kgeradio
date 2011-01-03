/**
 * swf的加载,用来加载表情和礼物*/
package com.ywit.radio91.util
{
	import com.ywit.radio91.center.UModelLocal;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class SwfDataLoader {
		public static var isGiftLoadComplete:Boolean = false;
		//这个是加载的地址
		public static var _giftUrl:String = "resources/gift/chatPresent.swf";
		private static var _loader:Loader = new Loader();
		private static var _giftLoadInfo:LoaderInfo ;
		//这个类务必要在 网络连接的时候加载,
		public function SwfDataLoader() {
			_loader.load(new URLRequest(UModelLocal.getInstance().resourceURL+_giftUrl));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandel);
		}
		//根据在fla中定义的元件名字来取得当前的类
		public static function getGiftClass(className:String):Class{
			if(!isGiftLoadComplete){
				return null
			}
			if(_giftsMap.getValue(className)){
				return _giftsMap.getValue(className) as Class;
			}
			var cl:Class = _giftLoadInfo.applicationDomain.getDefinition(className) as Class;
			if(cl){
				_giftsMap.put(className,cl);
				return cl;
			}
			return null;
		}
		private function completeHandel(e:Event):void{
			isGiftLoadComplete = true;
			_giftLoadInfo = e.target as LoaderInfo;
		}
		public static var _giftsMap:HashMap = new HashMap();
	}
}