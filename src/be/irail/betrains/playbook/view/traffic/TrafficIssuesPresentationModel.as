package be.irail.betrains.playbook.view.traffic {

	import be.irail.betrains.playbook.controller.AppSettings;

	import com.adobe.utils.XMLUtil;
	import com.adobe.xml.syndication.rss.RSS20;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	import mx.collections.ArrayCollection;

	import qnx.locale.LocaleManager;

	[Event(name="rssFeedChange", type="flash.events.Event")]
	[Event(name="rssFeedLoading", type="flash.events.Event")]
	public class TrafficIssuesPresentationModel extends EventDispatcher {

		private var loader:URLLoader;

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
				dispatchEvent(new Event("rssFeedChange"));
			}
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

			var items:Array = rss.items;
			rssFeed = new ArrayCollection(items);
		}

		private function onIOError(e:IOErrorEvent):void {
			rssFeed = new ArrayCollection();
			trace("IOError : " + e.text);
		}

		private function onSecurityError(e:SecurityErrorEvent):void {
			rssFeed = new ArrayCollection();
			trace("SecurityError : " + e.text);
		}

	}
}