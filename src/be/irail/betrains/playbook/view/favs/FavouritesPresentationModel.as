package be.irail.betrains.playbook.view.favs {

	import be.irail.betrains.playbook.data.FavouriteConnection;
	import be.irail.betrains.playbook.utils.DataStorageUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.collections.ArrayCollection;

	[Event(name="favouritesChange", type="flash.events.Event")]
	public class FavouritesPresentationModel extends EventDispatcher {
		public function FavouritesPresentationModel() {
		}

		// ----------------------------
		// favourites
		// ----------------------------

		private var _favourites:ArrayCollection;

		[Bindable(event="favouritesChange")]
		public function get favourites():ArrayCollection {
			return _favourites;
		}

		public function set favourites(value:ArrayCollection):void {
			if (value != _favourites) {
				_favourites = value;
			}
			dispatchEvent(new Event("favouritesChange"));
		}

		public function deleteFav(fav:FavouriteConnection):void {
			favourites.removeItemAt(favourites.getItemIndex(fav));
			dispatchEvent(new Event("favouritesChange"));

			DataStorageUtil.writeFavourites();
		}
	}
}