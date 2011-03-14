package be.irail.betrains.playbook.view.favs {

	import flash.events.Event;

	public class FavouriteEvent extends Event {
		public static const DELETE:String = "deleteFavourite";

		public static const SCHEDULE_ROUTE:String = "useFavourite";

		public static const SEE_STATION:String = "seeStation";

		// ----------------------------
		// data (read-only)
		// ----------------------------

		private var _data:Object;

		public function get data():Object {
			return _data;
		}

		public function FavouriteEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_data = data;
		}
	}
}