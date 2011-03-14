package be.irail.betrains.playbook.collection {

	import be.irail.api.data.stations.IRStation;

	import mx.collections.ArrayCollection;

	public class StationCollection extends ArrayCollection {
		public function StationCollection(source:Array = null) {
			super(source);
		}

		public function getStationById(id:String):IRStation {
			var numStation:int = this.length, station:IRStation;
			while (--numStation > -1) {
				station = getItemAt(numStation) as IRStation;
				if (station.id == id) {
					return station;
				}
				station = null;
			}
			return null;
		}

	}
}