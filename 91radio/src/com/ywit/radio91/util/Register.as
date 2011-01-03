package com.ywit.radio91.util
{
	import flash.utils.Dictionary;
/**
 * 用来注册界面的注册器
 */ 	
	public class Register
	{
		protected var dict : Dictionary = new Dictionary();

		public function Register()
		{
		}
		
		public function registe(name:*, obj:Object):void {
			dict[name] = obj;
		}
		
		public function unregiste(name:*):void {
			dict[name] = null;
		}
		
		public function hasUnit(name:*):Boolean {
			if(dict[name]==undefined||dict[name]==null){
				return false;
			}else{
				return true;
			}
		}
		
		public function locateUnit(name:*):Object {
			if(dict[name]==undefined||dict[name]==null){
				throw new Error( "can't locate unit: "+name );
			}else{
				return dict[name];
			}			
		}
		

		
	}
}