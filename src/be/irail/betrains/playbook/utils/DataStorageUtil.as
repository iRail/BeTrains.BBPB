package be.irail.betrains.playbook.utils {

	import be.irail.betrains.playbook.controller.AppSettings;
	import be.irail.betrains.playbook.controller.ModelLocator;
	import be.irail.betrains.playbook.data.BeTrainsApplicationSettings;

	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	import qnx.locale.LocaleManager;

	public class DataStorageUtil {
		private static var _model:ModelLocator = ModelLocator.getInstance();

		public static function writeRecents():void {
			if (AppSettings.RECENT_STORAGE_LOCATION.exists) {
				AppSettings.RECENT_STORAGE_LOCATION.deleteFile();
			}

			if (_model.recentSchedulerQueries.length > 0) {
				var stream:FileStream = new FileStream();
				var ba:ByteArray = SerializeUtil.serialize(_model.recentSchedulerQueries.toArray());
				stream.open(AppSettings.RECENT_STORAGE_LOCATION, FileMode.WRITE);
				stream.writeBytes(ba);
			}
		}

		public static function writeFavourites():void {
			if (AppSettings.FAVOURITES_STORAGE_LOCATION.exists) {
				AppSettings.FAVOURITES_STORAGE_LOCATION.deleteFile();
			}

			if (_model.favourites.length > 0) {
				var stream:FileStream = new FileStream();
				var ba:ByteArray = SerializeUtil.serialize(_model.favourites.toArray());
				stream.open(AppSettings.FAVOURITES_STORAGE_LOCATION, FileMode.WRITE);
				stream.writeBytes(ba);
			}
		}

		public static function writeSettings():void {
			if (AppSettings.SETTINGS_STORAGE_LOCATION.exists) {
				AppSettings.SETTINGS_STORAGE_LOCATION.deleteFile();
			}

			var stream:FileStream = new FileStream();
			var settings:BeTrainsApplicationSettings = new BeTrainsApplicationSettings();

			settings.language = LocaleManager.localeManager.getCurrentLocale();
			settings.maxRecents = AppSettings.MAX_NUM_STORED_RECENTS;

			var ba:ByteArray = SerializeUtil.serialize(settings);
			stream.open(AppSettings.SETTINGS_STORAGE_LOCATION, FileMode.WRITE);
			stream.writeBytes(ba);
		}
	}
}