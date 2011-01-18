package be.irail.betrains.playbook.view.components.preloader {

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;

	import mx.events.RSLEvent;
	import mx.preloaders.SparkDownloadProgressBar;

	public class BeTrainsLoader extends SparkDownloadProgressBar {

		[Embed(source="splash.png")]
		[Bindable]
		public var imgCls:Class;

		private var _loading:Boolean;

		public function BeTrainsLoader() {
			super();
		}

		override public function get backgroundImage():Object {
			return imgCls;
		}

		override public function get backgroundSize():String {
			return "100%";
		}

		override protected function showDisplayForInit(elapsedTime:int, count:int):Boolean {
			return true;
		}

		override protected function showDisplayForDownloading(elapsedTime:int, event:ProgressEvent):Boolean {
			return true;
		}

		override protected function createChildren():void {
			if (backgroundImage != null && !_loading) {
				_loading = true;
				loadBackgroundImage(backgroundImage);
			}
		}

		/**
		 *  @private
		 */
		private function loadBackgroundImage(classOrString:Object):void {
			var cls:Class;

			// The "as" operator checks to see if classOrString
			// can be coerced to a Class
			if (classOrString && classOrString as Class) {
				// Load background image given a class pointer
				cls = Class(classOrString);
				initBackgroundImage(new cls());
			} else if (classOrString && classOrString is String) {
				try {
					cls = Class(getDefinitionByName(String(classOrString)));
				} catch (e:Error) {
					// ignore
				}

				if (cls) {
					var newStyleObj:DisplayObject = new cls();
					initBackgroundImage(newStyleObj);
				} else {
					// Loading the image is slightly different
					// than in Loader.loadContent()... is this on purpose?

					// Load background image from external URL
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);

					var loaderContext:LoaderContext = new LoaderContext();
					loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					loader.load(new URLRequest(String(classOrString)), loaderContext);
				}
			}

		}

		/**
		 *  @private
		 */
		private function loader_completeHandler(event:Event):void {
			var target:DisplayObject = DisplayObject(LoaderInfo(event.target).loader);
			initBackgroundImage(target);
		}

		/**
		 *  @private
		 */
		private function loader_ioErrorHandler(event:IOErrorEvent):void {
			// Swallow the error
		}

		/**
		 *  @private
		 */
		private function initBackgroundImage(image:DisplayObject):void {
			addChildAt(image, 0);
			var backgroundImageWidth:Number = image.width;
			var backgroundImageHeight:Number = image.height;

			// Scale according to backgroundSize
			var percentage:Number = calcBackgroundSize();
			if (isNaN(percentage)) {
				var sX:Number = 1.0;
				var sY:Number = 1.0;
			} else {
				var scale:Number = percentage * 0.01;
				sX = scale * stageWidth / backgroundImageWidth;
				sY = scale * stageHeight / backgroundImageHeight;
			}

			image.scaleX = sX;
			image.scaleY = sY;

			// Center everything.
			// Use a scrollRect to position and clip the image.
			var offsetX:Number = Math.round(0.5 * (stageWidth - backgroundImageWidth * sX));
			var offsetY:Number = Math.round(0.5 * (stageHeight - backgroundImageHeight * sY));

			image.x = offsetX;
			image.y = offsetY;


		}

		/**
		 *  @private
		 */
		private function calcBackgroundSize():Number {
			var percentage:Number = NaN;

			if (backgroundSize) {
				var index:int = backgroundSize.indexOf("%");
				if (index != -1)
					percentage = Number(backgroundSize.substr(0, index));
			}

			return percentage;
		}

		override protected function initCompleteHandler(event:Event):void {
			setTimeout(passCompleted, 2000)
		}

		private function passCompleted():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}

		override protected function rslProgressHandler(evt:RSLEvent):void {
		}

		override protected function setDownloadProgress(completed:Number, total:Number):void {
		}

		override protected function setInitProgress(completed:Number, total:Number):void {
		}

		override protected function initProgressHandler(event:Event):void {
		}
	}
}