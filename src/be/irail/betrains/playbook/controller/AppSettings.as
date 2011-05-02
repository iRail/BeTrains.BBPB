package be.irail.betrains.playbook.controller {

	import flash.filesystem.File;

	public class AppSettings {
		public static const supportedLanguagesLocale:Array = ["en_US", "fr_FR", "nl_NL"];

		//prefix to indicate compatible data storages
		public static const FILE_VERSION_PREFIX:String = "1.1_";

		// Cached stationslist location
		public static const STATIONSDATA_STORAGE_LOCATION:File = File.applicationStorageDirectory.resolvePath("data/");

		// Recent scheduler location 
		public static const RECENT_STORAGE_LOCATION:File = File.applicationStorageDirectory.resolvePath(FILE_VERSION_PREFIX + "recents.bpd");

		// Favourites  location 
		public static const FAVOURITES_STORAGE_LOCATION:File = File.applicationStorageDirectory.resolvePath(FILE_VERSION_PREFIX + "favourites.bpd");

		// Settings  location 
		public static const SETTINGS_STORAGE_LOCATION:File = File.applicationStorageDirectory.resolvePath(FILE_VERSION_PREFIX + "settings.bpd");

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