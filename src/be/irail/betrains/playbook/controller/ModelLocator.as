package be.irail.betrains.playbook.controller {

	import be.irail.betrains.playbook.collection.FavouriteConnectionCollection;
	import be.irail.betrains.playbook.collection.RecentQueriesCollection;
	import be.irail.betrains.playbook.collection.StationCollection;

	import flash.errors.IllegalOperationError;

	import mx.collections.ArrayCollection;

	import qnx.utils.ImageCache;

	public class ModelLocator {
		private static var _instance:ModelLocator;

		private static var _instanceAllowed:Boolean;

		[Bindable]
		public var loggedIn:Boolean;

		[Bindable]
		public var stations:StationCollection;

		[Bindable]
		public var recentSchedulerQueries:RecentQueriesCollection;

		[Bindable]
		public var favourites:FavouriteConnectionCollection;

		public var imageCache:ImageCache = new ImageCache();

		public function ModelLocator() {
			if (!_instanceAllowed) {
				throw new IllegalOperationError("Cannot initialize a Singleton-class, use getInstance.")
			}
		}

		public static function getInstance():ModelLocator {
			if (!_instance) {
				_instanceAllowed = true;
				_instance = new ModelLocator();
				_instanceAllowed = false;
			}
			return _instance;
		}
	}
}