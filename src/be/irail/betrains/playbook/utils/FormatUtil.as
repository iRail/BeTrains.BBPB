package be.irail.betrains.playbook.utils {

	public class FormatUtil {

		public static function formatTime(date:Date):String {
			var hours:String = "" + date.getHours(),
				hoursPrefix:String = (hours.length == 1) ? "0" : "";

			hours = hoursPrefix + hours;

			var minutes:String = "" + date.getMinutes(),
				minutesPrefix:String = (minutes.length == 1) ? "0" : "";

			minutes = minutesPrefix + minutes;

			return hours + ":" + minutes;
		}

		public static function secondsToHoursMinutes(seconds:int):String {
			var timeOut:String;
			var hours:int = int(seconds / 3600);
			var mins:int = int((seconds - (hours * 3600)) / 60)
			var secs:int = seconds % 60;

			if (isNaN(hours) || isNaN(mins) || isNaN(secs)) {
				return "--:--";
			}

			var minS:String = (mins < 10) ? "0" + mins : String(mins);

			var hourS:String = String(hours);
			timeOut = hourS + ":" + minS;
			return timeOut;
		}
	}
}