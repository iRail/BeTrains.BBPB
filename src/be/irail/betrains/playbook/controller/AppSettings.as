package be.irail.betrains.playbook.controller {

	import flash.filesystem.File;

	public class AppSettings {
		public static const supportedLanguagesLocale:Array = ["en_US"];

		// Cached stationslist location
		public static const STATIONSLIST_STORAGE_LOCATION:File = File.applicationDirectory.resolvePath("data/stations.bpd");

		// Recent scheduler location 
		public static const RECENT_STORAGE_LOCATION:File = File.applicationStorageDirectory.resolvePath("recents.bpd");

		// Maximum number of stored recents
		public static const MAX_NUM_STORED_RECENTS:int = 10;

		// Liveboard refresh interval in seconds
		public static const LIVEBOARD_REFRESH_INTERVAL:int = 10;
	}
}