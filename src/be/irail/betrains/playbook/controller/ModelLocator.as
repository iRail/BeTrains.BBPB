package be.irail.betrains.playbook.controller {

	import be.irail.betrains.playbook.data.RecentQueriesCollection;

	import flash.errors.IllegalOperationError;

	import mx.collections.ArrayCollection;

	public class ModelLocator {
		private static var _instance:ModelLocator;

		private static var _instanceAllowed:Boolean;

		[Bindable]
		public var stations:ArrayCollection;

		[Bindable]
		public var recentSchedulerQueries:RecentQueriesCollection;

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