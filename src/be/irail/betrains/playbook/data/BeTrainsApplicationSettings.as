package be.irail.betrains.playbook.data {

	[RemoteClass(alias="betrains.playbook.Settings")]
	public class BeTrainsApplicationSettings {
		// ----------------------------
		// language
		// ----------------------------

		private var _language:String;

		public function get language():String {
			return _language;
		}

		public function set language(value:String):void {
			if (value !== _language) {
				_language = value;
			}
		}

		// ----------------------------
		// maxRecents
		// ----------------------------

		private var _maxRecents:int;

		public function get maxRecents():int {
			return _maxRecents > 5 ? _maxRecents : 5;
		}

		public function set maxRecents(value:int):void {
			if (value !== _maxRecents) {
				_maxRecents = value;
			}
		}

	}
}