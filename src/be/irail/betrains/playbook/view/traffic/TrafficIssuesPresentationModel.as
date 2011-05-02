package be.irail.betrains.playbook.view.traffic {

	import be.irail.betrains.playbook.controller.AppSettings;
	import be.irail.betrains.playbook.controller.ModelLocator;

	import com.adobe.utils.XMLUtil;
	import com.adobe.xml.syndication.rss.IImage;
	import com.adobe.xml.syndication.rss.RSS20;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;

	import mx.collections.ArrayCollection;

	import qnx.events.ImageCacheEvent;
	import qnx.locale.LocaleManager;

	[Event(name="rssFeedChange", type="flash.events.Event")]
	[Event(name="rssFeedLoading", type="flash.events.Event")]
	[Event(name="rssFeedError", type="flash.events.Event")]
	public class TrafficIssuesPresentationModel extends EventDispatcher {
		private var _model:ModelLocator = ModelLocator.getInstance();

		private var _refreshTimer:Timer;

		private var _providerImage:IImage;

		private var loader:URLLoader;

		private var _imgWidth:Number;

		private var _imgHeight:Number;

		public var maxImageHeight:Number = 80;

		public var maxImageWidth:Number = 100;


		// ----------------------------
		// rssFeed
		// ----------------------------

		private var _rssFeed:ArrayCollection;

		[Bindable(event="rssFeedChange")]
		public function get rssFeed():ArrayCollection {
			return _rssFeed;
		}

		public function set rssFeed(value:ArrayCollection):void {
			if (value != _rssFeed) {
				_rssFeed = value;
			}
			dispatchEvent(new Event("rssFeedChange"));
		}

		// ----------------------------
		// imageData
		// ----------------------------

		private var _imageData:BitmapData;

		[Bindable(event="imageDataChange")]
		public function get imageData():BitmapData {
			return _imageData;
		}

		[Bindable(event="imageDataChange")]
		public function get imageDataWidth():Number {
			if (!_imageData) {
				return 0;
			}

			return _imgWidth;
		}

		[Bindable(event="imageDataChange")]
		public function get imageDataHeight():Number {
			if (!_imageData) {
				return 0;
			}

			return _imgHeight;
		}

		public function set imageData(value:BitmapData):void {
			if (value != _imageData) {

				if (value) {
					_imageData = resize(value, maxImageHeight, maxImageWidth);
				} else {
					_imageData = null;
				}

				dispatchEvent(new Event("imageDataChange"));
			}
		}

		private function resize(data:BitmapData, maximumHeight:int, maximumWidth:int):BitmapData {
			var thisWidth:int = data.width,
				thisHeight:int = data.height,
				ratio:Number = thisHeight / thisWidth;

			if (thisWidth > maximumWidth) {
				thisWidth = maximumWidth;
				thisHeight = Math.round(thisWidth * ratio);
			}
			if (thisHeight > maximumHeight) {
				thisHeight = maximumHeight;
				thisWidth = Math.round(thisHeight / ratio);
			}

			var rW:Number = thisWidth / data.width,
				rH:Number = thisHeight / data.height,
				m:Matrix = new Matrix();

			m.scale(rW, rH);

			var tmp:BitmapData = new BitmapData(thisWidth, thisHeight, true, 0xFF0000);
			tmp.draw(data, m);

			return tmp;
		}

		[Bindable(event="providerImageChange")]
		public function get providerImageLink():String {
			if (!_providerImage) {
				return "";
			}
			return _providerImage.link;
		}

		public function loadRSSFeed():void {
			loader = new URLLoader();

			var feedURL:String;

			switch (true) {
				case LocaleManager.localeManager.getCurrentLocale().substr(0, 3) == "nl_":
					feedURL = AppSettings.RSS_URL_NL;
					break;
				case LocaleManager.localeManager.getCurrentLocale().substr(0, 3) == "fr_":
					feedURL = AppSettings.RSS_URL_FR;
					break;
				case LocaleManager.localeManager.getCurrentLocale().substr(0, 3) == "de_":
					feedURL = AppSettings.RSS_URL_DE;
					break;
				default:
					feedURL = AppSettings.RSS_URL_EN;
					break;
			}

			var request:URLRequest = new URLRequest(feedURL);
			request.method = URLRequestMethod.GET;

			loader.addEventListener(Event.COMPLETE, onDataLoad);

			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			loader.load(request);

			dispatchEvent(new Event("rssFeedLoading"));
		}

		public function startRefreshTimer():void {
			stopRefreshTimer();

			_refreshTimer = new Timer(AppSettings.RSS_REFRESH_INTERVAL * 1000);
			_refreshTimer.addEventListener(TimerEvent.TIMER, onRefreshTimer);
			_refreshTimer.start();
		}

		public function stopRefreshTimer():void {
			if (_refreshTimer) {
				if (_refreshTimer.running) {
					_refreshTimer.stop();
				}
				_refreshTimer.removeEventListener(TimerEvent.TIMER, onRefreshTimer);
				_refreshTimer = null;
			}
		}

		private function onRefreshTimer(event:TimerEvent):void {
			loadRSSFeed();
		}

		//called once the data has loaded from the feed
		private function onDataLoad(e:Event):void {
			//get the raw string data from the feed
			var rawRSS:String = URLLoader(e.target).data;

			//parse it as RSS
			parseRSS(rawRSS);

		}

		private function parseRSS(data:String):void {

			if (!XMLUtil.isValidXML(data)) {
				return;
			}

			var rss:RSS20 = new RSS20();
			rss.parse(data);

			setProviderImage(rss.image);

			var items:Array = rss.items;
			rssFeed = new ArrayCollection(items);
		}

		private function setProviderImage(image:IImage):void {
			_providerImage = image;

			imageData = _model.imageCache.getImage(_providerImage.url, true);

			if (!imageData) {
				_model.imageCache.addEventListener(ImageCacheEvent.IMAGE_LOADED, onImageLoaded);
			}

			dispatchEvent(new Event("providerImageChange"));
		}

		private function onImageLoaded(event:ImageCacheEvent):void {
			if (event.url == _providerImage.url) {
				_model.imageCache.removeEventListener(ImageCacheEvent.IMAGE_LOADED, onImageLoaded);
				imageData = _model.imageCache.getImage(_providerImage.url, true);
			}
		}

		private function onIOError(e:IOErrorEvent):void {
			if (!rssFeed || rssFeed.length == 0) {
				rssFeed = new ArrayCollection();
				dispatchEvent(new Event("rssFeedError"));
			}
			trace("IOError : " + e.text);
		}

		private function onSecurityError(e:SecurityErrorEvent):void {
			if (!rssFeed || rssFeed.length == 0) {
				rssFeed = new ArrayCollection();
				dispatchEvent(new Event("rssFeedError"));
			}

			trace("SecurityError : " + e.text);
		}
	}
}