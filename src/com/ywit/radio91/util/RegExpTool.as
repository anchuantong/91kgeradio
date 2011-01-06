package com.ywit.radio91.util
{
	public class RegExpTool
	{
		public function RegExpTool()
		{
		}
		/**
		 * 删除掉字符串中的/n以及/r
		 */ 
		public static function deleteLineChanger(str:String):String{
			var regExp:RegExp = /\n|\r/g;
			str = str.replace(regExp,"");
			return str;
		}	
	}
}