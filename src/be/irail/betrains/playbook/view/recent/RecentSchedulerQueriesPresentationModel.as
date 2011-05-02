package be.irail.betrains.playbook.view.recent {

	import be.irail.betrains.playbook.collection.RecentQueriesCollection;
	import be.irail.betrains.playbook.controller.AppSettings;
	import be.irail.betrains.playbook.data.SchedulerQuery;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.collections.ArrayCollection;

	public class RecentSchedulerQueriesPresentationModel extends EventDispatcher {
		// ----------------------------
		// recents
		// ----------------------------

		private var _recents:RecentQueriesCollection;

		[Bindable(event="recentsChange")]
		public function get recents():RecentQueriesCollection {
			if (!_recents) {
				return null;
			}

			var num:int = _recents.length;

			while (num > AppSettings.MAX_NUM_STORED_RECENTS) {
				_recents.removeItemAt(--num);
			}

			return _recents;
		}

		public function set recents(value:RecentQueriesCollection):void {
			_recents = value;
			dispatchEvent(new Event("recentsChange"));
		}

		/// ----------------------------
		// selectedConnection
		// ----------------------------

		private var _selectedQuery:SchedulerQuery;

		[Bindable(event="selectedConnectionChange")]
		public function get selectedQuery():SchedulerQuery {
			return _selectedQuery;
		}

		public function set selectedQuery(value:SchedulerQuery):void {
			if (value != _selectedQuery) {
				_selectedQuery = value;
				dispatchEvent(new Event("selectedConnectionChange"));
			}
		}

		// ----------------------------
		// schedulerItems (read-only)
		// ----------------------------

		[Bindable(event="selectedConnectionChange")]
		public function get schedulerItems():ArrayCollection {
			return new ArrayCollection(selectedQuery.result.data as Array);
		}

	}
}