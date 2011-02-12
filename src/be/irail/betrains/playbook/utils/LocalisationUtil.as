package be.irail.betrains.playbook.utils {

	import be.irail.api.core.LanguageCode;

	public class LocalisationUtil {
		public static function getLocalisationByDeviceLocale(deviceLocale:String):String {
			var lang:String = deviceLocale.substr(0, 2).toLowerCase();
			switch (lang) {
				case "nl":
					return "nl_NL";
					break;
				case "fr":
					return "fr_FR";
					break;
				default:
					return "en_US";
					break;
			}
		}

		public static function getIRailLangByDeviceLocale(deviceLocale:String):String {
			var lang:String = deviceLocale.substr(0, 2).toLowerCase();
			switch (lang) {
				case "nl":
					return LanguageCode.DUTCH;
					break;
				case "fr":
					return LanguageCode.FRENCH;
					break;
				case "de":
					return LanguageCode.GERMAN;
					break;
				default:
					return LanguageCode.ENGLISH;
					break;
			}
		}

	}
}