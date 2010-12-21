package com.ywit.radio91.view
{
	import flash.display.Sprite;
	
	/**
	 * 所有注册view的父类
	 */ 
	public class AbsView extends Sprite
	{
		public function AbsView()
		{
			super();
			initView();
			addChildren();
			configEventListener();
		}
		
		/**
		 * 所有页面的初始化的view都在这里做
		 */ 
		protected function initView():void{
			
		}
		
		/**
		 * 所有添加孩子的方法都在这里做
		 */ 
		protected function addChildren():void{
			
		}
		/**
		 * 所有的侦听都在这里做
		 */ 
		protected function configEventListener():void{
			
		}
		
		public function destory():void{
			if(this.parent != null){
				this.parent.removeChild(this);
			}
		}
	}
}