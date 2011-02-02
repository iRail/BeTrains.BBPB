package be.irail.betrains.playbook.view.favs {

	import flash.events.Event;

	public class FavouriteEvent extends Event {
		public static const DELETE:String = "deleteFavourite";

		public static const SCHEDULE_ROUTE:String = "useFavourite";

		public function FavouriteEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}