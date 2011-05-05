package be.irail.betrains.playbook.collection {

	import be.irail.api.data.stations.IRStation;

	import mx.collections.ArrayCollection;

	public class StationCollection extends ArrayCollection {
		public function StationCollection(source:Array = null) {
			super(source);
		}

		public function getStationById(id:String):IRStation {
			if (!id) {
				return null;
			}

			var numStation:int = this.length, station:IRStation;
			while (--numStation > -1) {
				station = getItemAt(numStation) as IRStation;
				if (station && station.id == id) {
					return station;
				}
				station = null;
			}
			return null;
		}

	}
}