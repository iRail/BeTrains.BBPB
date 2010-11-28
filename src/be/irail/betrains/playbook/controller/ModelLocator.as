package be.irail.betrains.playbook.controller {
	import flash.errors.IllegalOperationError;

	import mx.collections.ArrayCollection;

	public class ModelLocator {
		private static var _instance:ModelLocator;
		private static var _instanceAllowed:Boolean;

		public var stations:ArrayCollection;

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