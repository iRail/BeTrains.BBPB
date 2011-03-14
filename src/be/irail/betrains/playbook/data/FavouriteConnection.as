package be.irail.betrains.playbook.data {

	import be.irail.api.data.stations.IRStation;

	[RemoteClass(alias="betrains.playbook.FavouriteConnection")]
	public class FavouriteConnection {

		public function FavouriteConnection(from:IRStation = null, to:IRStation = null):void {
			this.fromStationId = "" + (from ? from.id : -1);
			this.toStationId = "" + (to ? to.id : -1);
		}

		// ----------------------------
		// fromStationId
		// ----------------------------

		private var _fromStationId:String;

		public function get fromStationId():String {
			return _fromStationId;
		}

		public function set fromStationId(value:String):void {
			if (value !== _fromStationId) {
				_fromStationId = value;
			}
		}

		// ----------------------------
		// toStationId
		// ----------------------------

		private var _toStationId:String;

		public function get toStationId():String {
			return _toStationId;
		}

		public function set toStationId(value:String):void {
			if (value !== _toStationId) {
				_toStationId = value;
			}
		}
	}
}