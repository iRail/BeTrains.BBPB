package be.irail.betrains.playbook.data {

	import be.irail.api.data.stations.IRStation;

	[RemoteClass(alias="betrains.playbook.FavouriteConnection")]
	public class FavouriteConnection {

		public function FavouriteConnection(from:IRStation = null, to:IRStation = null):void {
			this.from = from;
			this.to = to;
		}

		// ----------------------------
		// from
		// ----------------------------

		private var _from:IRStation;

		public function get from():IRStation {
			return _from;
		}

		public function set from(value:IRStation):void {
			if (value != _from) {
				_from = value;
			}
		}


		// ----------------------------
		// to
		// ----------------------------

		private var _to:IRStation;

		public function get to():IRStation {
			return _to;
		}

		public function set to(value:IRStation):void {
			if (value != _to) {
				_to = value;
			}
		}
	}
}