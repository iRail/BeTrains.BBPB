package be.irail.betrains.playbook.controller {

	import flash.filesystem.File;

	public class AppSettings {
		public static const supportedLanguagesLocale:Array = ["en_US"];

		// Cached stationslist location
		public static const STATIONSLIST_STORAGE_LOCATION:File = File.applicationDirectory.resolvePath("data/stations.bpd");

		// Recent scheduler location 
		public static const RECENT_STORAGE_LOCATION:File = File.documentsDirectory.resolvePath("recents.bpd");

		// Favourites  location 
		public static const FAVOURITES_STORAGE_LOCATION:File = File.documentsDirectory.resolvePath("favourites.bpd");

		public static const ABOUT_PAGE_URL:String = "http://www.betrains.com";

		public static const RSS_URL_NL:String = "http://www.railtime.be/website/RSS/RssInfoBar_nl.xml";

		public static const RSS_URL_FR:String = "http://www.railtime.be/website/RSS/RssInfoBar_fr.xml";

		public static const RSS_URL_EN:String = "http://www.railtime.be/website/RSS/RssInfoBar_en.xml";

		public static const RSS_URL_DE:String = "http://www.railtime.be/website/RSS/RssInfoBar_de.xml";

		// Maximum number of stored recents
		public static const MAX_NUM_STORED_RECENTS:int = 10;

		// Liveboard refresh interval in seconds
		public static const LIVEBOARD_REFRESH_INTERVAL:int = 10;

		// RSS refresh interval in seconds
		public static const RSS_REFRESH_INTERVAL:int = 10;

	}
}