package
{
	import com.greensock.plugins.TweenPlugin;
	import com.ywit.radio91.center.UModelLocal;
	import com.ywit.radio91.constant.ViewRegister;
	import com.ywit.radio91.data.PlayerData;
	import com.ywit.radio91.gen.data.AbsPlayerData;
	import com.ywit.radio91.util.NetUntil;
	import com.ywit.radio91.util.TransformAroundCenterPlugin;
	import com.ywit.radio91.util.ViewHelper;
	import com.ywit.radio91.view.RoomView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	//[Frame(factoryClass="Preloader")] 
	/**
	 * 主程序启动入口
	 * 主舞台入口
	 * base调用的main方法所在类
	 * 舞台宽高固定设置为800*800
	 * 帧数为24
	 */ 
	[SWF(width="800",height="800",rate="24",backgroundColor="0xA6D4FF")]
	public class Main extends Sprite
	{
		public static const KG_WIDTH:int = 800;
		public static const KG_HEIGHT:int = 800;
		
		
		private var assetLoader:Loader = new Loader();
		private var _playerData:PlayerData = PlayerData.getInstance();
		//填充背景的png
		[Embed(@source="resources/fillBG.png")]
		private var _fillBg:Class;
		
		public function Main()
		{
			ViewHelper.register = new ViewRegister();
			ViewHelper._main = this;
			UModelLocal.getInstance();
			Security.allowDomain("*");
			fillBg();
			NetUntil.getInstance().addEventListener(Event.CONNECT,connectHandler);

//			this.x += 10;
//			var cls:Class = AssetRegister.UserInfoUI;
//			
//			var userInfoUI:DisplayObject = new cls();
//			this.addChild(userInfoUI);
			
//			var mainStage:MainStageView = ViewHelper.addView(ViewRegister.MAIN_STAGE_VIEW,this) as MainStageView;
			//				ViewHelper.addView(ViewRegister.LOGIN_VIEW,mainStage);
//			facade.startup(this);
//			this.x=0;
//			this.y=0;
//			this.graphics.lineStyle(0,0,0);
//			this.graphics.beginFill(0,0.4);
//			this.graphics.drawRect(0,0,1000,600);
//			this.graphics.endFill();
//			
//			this.scaleX=1;
			
//			ViewHelper.addView(ViewRegister.HALL_VIEW,this);
//			addChild(ViewHelper.getView(ViewRegister.HALL_VIEW));
//			init();
			
			if(UModelLocal.getInstance().debug == 0){
//				var array:Array = [711857534,223941411,228024525,255694631,313580428,327886643,334406883,338935147];
				var array:Array = [711857534];
				
				var uid:int = array[Math.round(Math.random()*(array.length-1))];
				PlayerData.getInstance().jsessionid = uid+"_browser_sessionid";
				UModelLocal.getInstance().uid = uid;
				initRadio(uid+"_browser_sessionid",UModelLocal.getInstance().ip,UModelLocal.getInstance().port);
				return;	
			}
		}
		
		public function initRadio(jsessionid:String,ip:String,port:int):void{
			ViewHelper.popView(ViewRegister.SYSTEM_INFO_VIEW,this,Main.KG_WIDTH,Main.KG_HEIGHT);
			_playerData.jsessionid = jsessionid;
			UModelLocal.getInstance().ip = ip;
			UModelLocal.getInstance().port = port;
			NetUntil.getInstance().connect(UModelLocal.getInstance().ip,UModelLocal.getInstance().port);
			
		}
		
		/**
		 * 加载外部的kplayer播放器
		 */ 
		public function addKplayer(disObj:DisplayObject):void{
			var roomView:RoomView = RoomView(ViewHelper.getView(ViewRegister.ROOM_VIEW));  
			if(roomView == null){
				throw new Error("add kplayer failed!! case by roomView is null");
				return;
			}
			roomView.addKPlayer(disObj);
		}
		
		/**
		 * 被外部呼叫调用的弹出礼物面板
		 */ 
		public function sendGift(uid:int):void{
			var roomView:RoomView = RoomView(ViewHelper.getView(ViewRegister.ROOM_VIEW));  
			if(roomView == null){
				throw new Error("sendGift failed!! case by roomView is null");
				return;
			}
			roomView.popPresentPannel(uid);
		}
		
		/**
		 * 被外部呼叫调用的设置私聊面板
		 */ 
		public function sendPrivateMessage(uid:int):void{
			var roomView:RoomView = RoomView(ViewHelper.getView(ViewRegister.ROOM_VIEW));  
			if(roomView == null){
				throw new Error("sendPrivateMessage failed!! case by roomView is null");
				return;
			}
			roomView.selectTargetComboBoxByUID(uid);
		}
		
		/**
		 * 为房间加载一个底部的显示对象
		 */ 
		public function addRoomBottom(disObj:DisplayObject):void{
			var roomView:RoomView = ViewHelper.getView(ViewRegister.ROOM_VIEW) as RoomView;
			roomView.addRoomBottom(disObj);
		}
		
		/**
		 *提供socket 
		 */
		public function send(data:String):void{
			NetUntil.getInstance().send(data);
			
		}
		
		private function fillBg():void{
			var img_target:DisplayObject = new _fillBg();
			var bmpData:BitmapData = new BitmapData(img_target.width, img_target.height);
			bmpData.draw(img_target);
			var graphic:Graphics = this.graphics;
			graphic.beginBitmapFill(bmpData);
			graphic.drawRect(0,0,800,800);
			graphic.endFill();
		}
		
//		private function init():void{
//			fillBg();
//			_playerData.jsessionid = "711857534_browser_sessionid";//tip 这里需要设置 jsessionid,当重新登录的时候要获取最新的jsessionid并设置在这里
//			NetUntil.getInstance().addEventListener(Event.CONNECT,connectHandler);
//			ViewHelper.popView(ViewRegister.SYSTEM_INFO_VIEW,this,Main.KG_WIDTH,Main.KG_HEIGHT);
//			NetUntil.getInstance().connect(UModelLocal.getInstance().xmlSocket,UModelLocal.getInstance().xmlSocketPost);
//			_playerData.cs_UserInfo(255694631);
//			_playerData.cs_Friends(255694631,1);
//			NetUntil.getInstance().send("{\"jsessionid\":\"711857534_browser_sessionid\",\"method\":\"friends\",\"uid\":\"255694631\",\"curPage\":\"1\"}");
//			NetUntil.getInstance().send("{jsessionid:711857534_browser_sessionid,method:userInfo,uid:255694631}");
//		}
		
		private function connectHandler(e:Event):void{
			ViewHelper.removePopView(ViewRegister.SYSTEM_INFO_VIEW);
			var disObj:DisplayObject = ViewHelper.addView(ViewRegister.HALL_VIEW,this);
			disObj.x += 12;
			dispatchEvent(e);
		}
		
		
//		public function showLoginView():void{
			//考虑mainStageView可以不需要 
//			var mainStage:MainStageView  = ViewHelper.getView(ViewRegister.MAIN_STAGE_VIEW) as MainStageView;
//			addChild(ViewHelper.getView(ViewRegister.LOGIN_VIEW));
//		}
//		public function showHallView():void{
//			ViewHelper.removeView(ViewRegister.SYSTEM_INFO_VIEW);
//			var disObj:DisplayObject = addChild(ViewHelper.getView(ViewRegister.HALL_VIEW));
//			
//			
//		}
//		public function showConnectionView():void{
//			addChild(ViewHelper.getView(ViewRegister.SYSTEM_INFO_VIEW));
//		}
	}
}