package be.irail.betrains.playbook.collection {

	import be.irail.api.data.stations.IRStation;
	import be.irail.betrains.playbook.data.FavouriteConnection;

	import mx.collections.ArrayCollection;

	public class FavouriteConnectionCollection extends ArrayCollection {
		public function FavouriteConnectionCollection(source:Array = null) {
			super(source);
		}

		public function containsConnection(from:IRStation, to:IRStation):Boolean {
			var numFavs:int = length;
			while (--numFavs > -1) {
				var fav:FavouriteConnection = FavouriteConnection(getItemAt(numFavs));
				if (fav.fromStationId == from.id && fav.toStationId == to.id) {
					return true;
				}
			}
			return false;
		}
	}
}