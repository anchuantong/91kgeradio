/***
 * Author: ATHER Shu 2008.7.17
 * MargueeText工具，跑马灯文本
 * 功能：
 * 1.直接将某TextField转换为跑马灯文本 changeTextFieldToMarqueeText 
 * 2.动态设定显示宽度 width
 * 3.动态设定一次移动间隔时间 delay
 * 4.动态设定一次移动间隔距离 step
 * 5.设定默认文本显示样式 defaultTextFormat
 * 6.动态设定文本显示样式 setTextFormat
 * http://www.asarea.cn
 * ATHER Shu(AS)
 ***/
package com.ywit.radio91.util
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class MarqueeText extends Sprite
	{
		private var m_rect:Rectangle;
		private var m_txt:TextField;
		private var m_timer:Timer;
		//每次移动距离
		private var m_step:Number;
		//左移右移tmpflag
		private var m_bleftflag:Boolean;
		//
		public function MarqueeText(text:String="", width:Number=100, delay:Number=1000, step:Number=10)
		{
			super();
			//
			m_txt = new TextField();
			m_txt.x = m_txt.y = 0;
			m_txt.selectable = false;
			m_txt.wordWrap = false;
			m_txt.multiline = false;
			m_txt.autoSize = TextFieldAutoSize.LEFT;
			m_txt.htmlText = text;
			addChild(m_txt);
			//
			m_rect = new Rectangle(0, 0, width, m_txt.height);
			m_txt.scrollRect = m_rect;
			//
			m_timer = new Timer(delay);
			m_step = step;
			m_bleftflag = true;
			//
			checkNeedTimer();
		}
		//只要是有可能改变文本的宽度或者scrollrect宽度的方法都应该调用该方法以刷新走马灯
		private function checkNeedTimer():void
		{
			//reset
			m_timer.stop();
			if(m_timer.hasEventListener(TimerEvent.TIMER))
				m_timer.removeEventListener(TimerEvent.TIMER, timerhandler);
			m_rect.x = 0;
			m_rect.height = m_txt.height;
			m_txt.scrollRect = m_rect;
			m_bleftflag = true;
			//test and set
			if(m_rect.width < m_txt.textWidth)
			{
				m_timer.addEventListener(TimerEvent.TIMER, timerhandler);
				m_timer.start();
			}
		}
		private function timerhandler(evt:TimerEvent):void
		{
			if(m_bleftflag)
			{
				if((m_rect.x + m_rect.width) < m_txt.textWidth)
					m_rect.x += m_step;
				else
					m_bleftflag = false;
			}
			else
			{
				if(m_rect.x > 0)
					m_rect.x -= m_step;
				else
					m_bleftflag = true;
			}
			//
			m_txt.scrollRect = m_rect;
		}
		public function set text(text:String):void
		{
			m_txt.text = text;
			checkNeedTimer(); 
		}
		public function get text():String
		{
			return m_txt.text;
		}
		public function set delay(delay:Number):void
		{
			m_timer.delay = delay;
		}
		public function set step(step:Number):void
		{
			m_step = step;
		}
		public override function set width(width:Number):void
		{
			m_rect.width = width;
			m_txt.scrollRect = m_rect;
			checkNeedTimer();
		}
		
		public override function get width():Number{
			return m_rect.width;
		}
		public function set defaultTextFormat(format:TextFormat):void
		{
			m_txt.defaultTextFormat = format;
			setTextFormat(format);
		}
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void
		{
			m_txt.setTextFormat(format, beginIndex, endIndex);
			checkNeedTimer();
		}
		//直接把textfield转换为margueetext，对于一些中文字体用textformat无法正常显示的情况此方法特别有效，只需在舞台上建立一个中文字体的文本框转换过来
		public static function changeTextFieldToMarqueeText(tf:TextField, width:Number=100, delay:Number=1000, step:Number=10):MarqueeText
		{
			var returnMT:MarqueeText = new MarqueeText("", width, delay, step);
			with(returnMT)
			{
				removeChild(m_txt);
				m_txt = tf;
				m_txt.selectable = false;
				m_txt.wordWrap = false;
				m_txt.multiline = false;
				m_txt.autoSize = TextFieldAutoSize.LEFT;
				checkNeedTimer();
			}
			return returnMT;
		}
	}
}