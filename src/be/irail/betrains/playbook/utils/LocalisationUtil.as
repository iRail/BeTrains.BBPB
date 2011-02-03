package be.irail.betrains.playbook.utils {

	public class LocalisationUtil {
		public static function getLocalisationByDeviceLocale(deviceLocale:String):String {
			var lang:String = deviceLocale.substr(0, 2).toLowerCase();
			switch (lang) {
				case "en":
					return "en_US";
					break;
				case "nl":
					return "nl_NL";
					break;
				case "fr":
					return "fr_FR";
					break;
				case "de":
					return "de_DE";
					break;
			}
			return "en_US";
		}

	}
}