﻿package com.ywit.radio91.center
{
	
/**
 * 整个程序使用的数据中心类
 * 所有有关全局的配置相关的数据都记录在这里
 * 使用单例模式
 */ 
	public class UModelLocal
	{
		private static var _uModelLocal:UModelLocal;
		public function UModelLocal()
		{
		}
		
		public static function getInstance():UModelLocal{
			if(_uModelLocal == null){
				_uModelLocal = new UModelLocal();
			}
			return _uModelLocal;
		}
		
		public var ip:String = "gelila.gicp.net";
//		public var ip:String = "radio.91kge.com";
		
		public var port:int = 5227;
//		public var jsessionid:String;
		public var uid:int = 0;
		//0本地调试，1远程调试(发布)
		public var debug:int = 1;
		//TODO可能需要写在外部的config
		//程序使用的资源地址
		private var _resourceURL:String = "http://rtmpxn.91kge.com/res/sns/xn/fv1/";
		
		public function get resourceURL():String{
			if(debug == 0){
				return "";
			}
			
			return _resourceURL;
		}
	}
}