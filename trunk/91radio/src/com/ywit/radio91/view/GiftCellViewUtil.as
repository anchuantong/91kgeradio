package com.ywit.radio91.view
{
	import com.ywit.radio91.center.UModelLocal;
	import com.ywit.radio91.event.GiftCellEvent;
	import com.ywit.radio91.util.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class GiftCellViewUtil
	{
		public static var allGift:HashMap = new HashMap();
		public static function getHaveGiftClass(giftName:String):Class{
			return allGift.getValue(giftName) as Class;
		}
		public static function addGift2UserGiftList(x:int,y:int,movieClip:MovieClip,giftObj:Object):void {
			var giftName:String = giftObj["imgUrl"];
			var cl:Class = getHaveGiftClass(giftName);
			var ui_GiftCellView:UI_GiftCellView = new UI_GiftCellView();
			if(cl != null){
				var disObj:DisplayObject = new cl();
				disObj.width = 45;
				disObj.height = 45;
				disObj.x = 3+x;
				disObj.y = 3+y;
//				ui_GiftCellView.x = x;
//				ui_GiftCellView.y = y;
//				ui_GiftCellView.addChild(disObj);
				movieClip.addChild(disObj);
			}else{
				var loader:Loader = new Loader();
				trace("resources/gift/icon/Icon_"+giftName+".swf");
				loader.load(new URLRequest(UModelLocal.getInstance().resourceURL + "resources/gift/icon/Icon_"+giftName+".swf"));
				var giftCellEvent:GiftCellEvent;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function completeHandel(e:Event):void{
					var cl:Class = e.target.applicationDomain.getDefinition("Icon_"+giftName+"") as Class;
					var disObj:DisplayObject = new cl();
					disObj.width = 45;
					disObj.height = 45;
//					disObj.x = 3;
//					disObj.y = 3;
//					ui_GiftCellView.x = x;
//					ui_GiftCellView.y = y;
//					ui_GiftCellView.addChild(disObj);
//					movieClip.addChild(ui_GiftCellView);
					disObj.x = 3+x;
					disObj.y = 3+y;
					movieClip.addChild(disObj);
					
					allGift.put(giftName,cl);
				});
			}
		}
		public static function addGift2GiftList(movieClip:MovieClip,giftObj:Object=null):void {
			if(giftObj == null){
				removeGift(movieClip);
				return;
			}
			var giftName:String = giftObj["imgUrl"];
			var cl:Class = getHaveGiftClass(giftName);
			if(cl != null){
				var disObj:DisplayObject = new cl();
				disObj.width = 45;
				disObj.height = 45;
				disObj.x = 3;
				disObj.y = 3;
				removeGift(movieClip);
				movieClip.addChild(disObj);
			}else{
				var loader:Loader = new Loader();
				var url:String = UModelLocal.getInstance().resourceURL + "resources/gift/icon/Icon_"+giftName+".swf";
				trace(url);
				loader.load(new URLRequest(url));
				var giftCellEvent:GiftCellEvent;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function completeHandel(e:Event):void{
					var cl:Class = e.target.applicationDomain.getDefinition("Icon_"+giftName+"") as Class;
					var disObj:DisplayObject = new cl();
					disObj.width = 45;
					disObj.height = 45;
					disObj.x = 3;
					disObj.y = 3;
					removeGift(movieClip);
					movieClip.addChild(disObj);
					
					allGift.put(giftName,cl);
				});
			}
			movieClip.addEventListener(MouseEvent.MOUSE_OVER,function mouseOverHandel(e:Event):void{
				giftCellEvent = new GiftCellEvent(GiftCellEvent.GIFT_MOUSE_OVER);
				giftCellEvent.data = giftObj;
				movieClip.dispatchEvent(giftCellEvent);
			});
			movieClip.addEventListener(MouseEvent.MOUSE_OUT,function mouseOutHandel(e:Event):void{
				giftCellEvent = new GiftCellEvent(GiftCellEvent.GIFT_MOUSE_OUT);
				giftCellEvent.data = giftObj;
				movieClip.dispatchEvent(giftCellEvent);
			});
			movieClip.addEventListener(MouseEvent.CLICK,function mouseOutHandel(e:Event):void{
				giftCellEvent = new GiftCellEvent(GiftCellEvent.GIFT_MOUSE_CLICK);
				giftCellEvent.data = giftObj;
				movieClip.dispatchEvent(giftCellEvent);
			});
		}
		public static function removeGift(movieClip:MovieClip):void{
			var num:int = movieClip.numChildren;
			for (var i:int=0;i<num;i++){
				movieClip.removeChildAt(0);
			}
			
		}
	}
}