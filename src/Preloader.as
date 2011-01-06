package
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	public class Preloader extends MovieClip
	{
//		private var _assetLoader:Loader = new Loader();
		[Embed(@source="resources/fillBG.png")]
		private var _fillBg:Class;
		public function Preloader()
		{
			super();
			createChildren();
			init();
			stage.scaleMode = StageScaleMode.NO_SCALE;
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
		
		private function init():void
		{
			fillBg();
			addEventListener(Event.ADDED_TO_STAGE,added,false,0,true);
			added(null);
		}
		private var tf:TextField;
		
		private var progressBar:Shape;
		private function createChildren():void
		{
//			this.graphics.beginFill(0xA6D4FF);
//			this.graphics.drawRect(0,0,800,800);
//			this.graphics.endFill();
			
			tf = new TextField();
			tf.width = 200;
			tf.height = 100;
			tf.text = "";
			addChild(tf);
			
			progressBar = new Shape();
			
			addChild(progressBar);
			with(progressBar.graphics)
			{
				beginFill(Math.random() * 0xFFFFFF);
				drawRect(0,0,100,5);
			}

		}
		
		private function added(evt:Event = null):void
		{
			var loaderInfo:LoaderInfo;
			if(stage)
			{
				removeEventListener(Event.ADDED_TO_STAGE,added);
				loaderInfo = root.loaderInfo;
//				loaderInfo.addEventListener(ProgressEvent.PROGRESS , MainProgress,false,0,true);
//				loaderInfo.addEventListener(Event.COMPLETE,MainComplete,false,0,true);
				this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
				progressBar.x = (stage.stageWidth - 100 ) / 2 ;
				progressBar.y = (stage.stageHeight - progressBar.height ) / 2 ;
				tf.x = progressBar.x ;
				tf.y = progressBar.y + progressBar.height + 5 ;
			}
		}
		
		private function enterFrameHandler(e:Event):void{
			
			var rate:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
			if(rate < 1){
				progressBar.width = Math.round(rate * 200);
				tf.text = " 主程序当前已加载:" + Math.round(rate*100);
			}
			var clazz:Class ;
			var main:DisplayObject;
			if(ApplicationDomain.currentDomain.hasDefinition("Main"))
			{
				this.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
				clazz = getDefinitionByName("Main") as Class;
				main = new clazz();
				stage.addChildAt(main,0);
				this.parent.removeChild(this);
			}			
		}
		
//		private function MainProgress(evt:ProgressEvent):void
//		{
//			var rate:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
//			progressBar.width = Math.round(rate * 200);
//			tf.text = " 主程序当前已加载:" + Math.round(rate*100);
//		}
//		
//		private function MainComplete(evt:Event):void
//		{
//			
//			var clazz:Class ;
//			var main:DisplayObject;
//			if(ApplicationDomain.currentDomain.hasDefinition("Main"))
//			{
//				clazz = getDefinitionByName("Main") as Class;
//				main = new clazz();
//				stage.addChildAt(main,0);
//			}			
			
			
//			_assetLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,assetProgressHandler);
//			_assetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,assetCompleteHandler);
//			var ldrContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
//			_assetLoader.load(new URLRequest("resources/asset.swf"),ldrContext);
			//			trace(evt);
//		}
		
//		private function assetProgressHandler(evt:ProgressEvent):void
//		{
//			var assetRate:Number = LoaderInfo(evt.target).bytesLoaded/ LoaderInfo(evt.target).bytesTotal;
//			progressBar.width = Math.round(assetRate * 200);
//			tf.text = " 资源当前已加载:" + Math.round(assetRate*100);
//		}
//		
//		private function assetCompleteHandler(evt:Event):void
//		{
//			
//		}
		
	}
}