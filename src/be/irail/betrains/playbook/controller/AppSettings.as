package be.irail.betrains.playbook.controller {

	import flash.filesystem.File;

	public class AppSettings {
		public static const supportedLanguagesLocale:Array = ["en_US", "fr_FR", "nl_NL"];

		// Cached stationslist location
		public static const STATIONSDATA_STORAGE_LOCATION:File = File.applicationDirectory.resolvePath("data/");

		// Recent scheduler location 
		public static const RECENT_STORAGE_LOCATION:File = File.documentsDirectory.resolvePath("recents.bpd");

		// Favourites  location 
		public static const FAVOURITES_STORAGE_LOCATION:File = File.documentsDirectory.resolvePath("favourites.bpd");

		// Settings  location 
		public static const SETTINGS_STORAGE_LOCATION:File = File.documentsDirectory.resolvePath("settings.bpd");

		public static const ABOUT_PAGE_URL:String = "http://www.betrains.com/api/iphone_app_pages/about_playbook.php";

		public static const RSS_URL_NL:String = "http://www.railtime.be/website/RSS/RssInfoBar_nl.xml";

		public static const RSS_URL_FR:String = "http://www.railtime.be/website/RSS/RssInfoBar_fr.xml";

		public static const RSS_URL_EN:String = "http://www.railtime.be/website/RSS/RssInfoBar_en.xml";

		public static const RSS_URL_DE:String = "http://www.railtime.be/website/RSS/RssInfoBar_de.xml";

		// Liveboard refresh interval in seconds
		public static const LIVEBOARD_REFRESH_INTERVAL:int = 30;

		// RSS refresh interval in seconds
		public static const RSS_REFRESH_INTERVAL:int = 30;

		// Maximum number of stored recents
		public static var MAX_NUM_STORED_RECENTS:int = 5;
	}
}