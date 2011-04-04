package be.irail.betrains.playbook.view.scheduler {

	import be.irail.api.data.stations.IRStation;
	import be.irail.api.event.IRailErrorEvent;
	import be.irail.api.event.IRailResultEvent;
	import be.irail.api.methodgroup.Scheduler;
	import be.irail.betrains.playbook.controller.ModelLocator;
	import be.irail.betrains.playbook.data.FavouriteConnection;
	import be.irail.betrains.playbook.data.SchedulerQuery;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.collections.ArrayCollection;

	[Event(name="connectionsChange", type="flash.events.Event")]
	public class SchedulerPresentationModel extends EventDispatcher {
		private var _schedule:Scheduler;

		private var _model:ModelLocator = ModelLocator.getInstance();

		private var _query:SchedulerQuery;

		// ----------------------------
		// from
		// ----------------------------

		private var _from:IRStation;

		[Bindable(event="fromChange")]
		public function get from():IRStation {
			return _from;
		}

		public function set from(value:IRStation):void {
			if (value != _from) {
				_from = value;
				dispatchEvent(new Event("fromChange"));
			}
		}

		// ----------------------------
		// to
		// ----------------------------

		private var _to:IRStation;

		[Bindable(event="toChange")]
		public function get to():IRStation {
			return _to;
		}

		public function set to(value:IRStation):void {
			if (value != _to) {
				_to = value;
				dispatchEvent(new Event("toChange"));
			}
		}

		// ----------------------------
		// date
		// ----------------------------

		private var _date:Date;

		[Bindable(event="dateChange")]
		public function get when():Date {
			return _date;
		}

		public function set when(value:Date):void {
			_date = value;
			dispatchEvent(new Event("dateChange"));
		}

		// ----------------------------
		// connections (read-only)
		// ----------------------------

		private var _connections:ArrayCollection;

		[Bindable(event="connectionsChange")]
		public function get connections():ArrayCollection {
			return _connections;
		}

		[Bindable(event="connectionsChange")]
		public function get hasConnections():Boolean {
			return _connections && _connections.length > 0 && !isLoading;
		}

		// ----------------------------
		// isLoading
		// ----------------------------

		private var _isLoading:Boolean;

		[Bindable(event="isLoadingChange")]
		public function get isLoading():Boolean {
			return _isLoading;
		}

		public function set isLoading(value:Boolean):void {
			if (value != _isLoading) {
				_isLoading = value;
				dispatchEvent(new Event("isLoadingChange"));
			}
		}

		// ----------------------------
		// canAddToFavourites (read-only)
		// ----------------------------
		[Bindable(event="toChange")]
		[Bindable(event="fromChange")]
		[Bindable(event="connectionFavd")]
		public function get canAddToFavourites():Boolean {
			if (from == null || to == null)
				return false;

			var doesNotExist:Boolean = !_model.favourites.containsConnection(from, to);
			return doesNotExist;
		}

		public function SchedulerPresentationModel() {
			_schedule = new Scheduler();
		}

		[Bindable(event="toChange")]
		[Bindable(event="fromChange")]
		[Bindable(event="dateChange")]
		public function get isValid():Boolean {
			return from != null && to != null && when != null;
		}

		public function getSchedule(dateArrDep:String = "depart"):void {
			_schedule.getRoutes(from, to, when, true, dateArrDep, ["train"]);
			_schedule.addEventListener(IRailResultEvent.SCHEDULER_RESULT, onSchedulerResult);
			_schedule.addEventListener(IRailErrorEvent.IO_ERROR, onIoError);
			_schedule.addEventListener(IRailErrorEvent.API_ERROR, onIoError);

			_query = new SchedulerQuery(from, to, when, dateArrDep);
			isLoading = true;
		}

		private function onIoError(event:IRailErrorEvent):void {
			isLoading = false;
			_connections = new ArrayCollection();
			dispatchEvent(new Event("connectionsChange"));
		}

		public function favCurrentConnection():void {
			if (from != null && to != null) {
				_model.favourites.addItem(new FavouriteConnection(from, to));
				dispatchEvent(new Event("connectionFavd"));
			}
		}

		private function onSchedulerResult(event:IRailResultEvent):void {
			_schedule.removeEventListener(IRailResultEvent.SCHEDULER_RESULT, onSchedulerResult);
			isLoading = false;

			_connections = new ArrayCollection(event.result.data as Array);

			if (_connections.length) {
				_query.result = event.result;
				_model.recentSchedulerQueries.addItem(_query);
			}

			_query = null;
			dispatchEvent(new Event("connectionsChange"));
		}

	}
}