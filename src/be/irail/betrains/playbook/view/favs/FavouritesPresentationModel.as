package be.irail.betrains.playbook.view.favs {

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
			if (value !== _favourites) {
				_favourites = value;
				dispatchEvent(new Event("favouritesChange"));
			}
		}
	}
}