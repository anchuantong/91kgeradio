package com.ywit.radio91.constant{
	import com.ywit.radio91.util.Register;
	import com.ywit.radio91.view.HallView;
	import com.ywit.radio91.view.LoginView;
	import com.ywit.radio91.view.RoomView;
	import com.ywit.radio91.view.SystemInfoView;

/**
 * 用来注册可调用视图的注册界面
 * 该常量用于viewHelper工具
 * @author keynes 
 * @data   2010-11-11
 */ 	
public class ViewRegister extends Register  {
		public function ViewRegister() {
			registe(LOGIN_VIEW,LoginView);
			registe(HALL_VIEW,HallView);
			registe(SYSTEM_INFO_VIEW,SystemInfoView);
			registe(ROOM_VIEW,RoomView);
		}
		
		public static const LOGIN_VIEW:String="LoginView";
		public static const MAIN_STAGE_VIEW:String="MainStageView";
		public static const HALL_VIEW:String="HallView";
		public static const SYSTEM_INFO_VIEW:String="SystemInfoView";
		public static const ROOM_VIEW:String="RoomView";
	}
}