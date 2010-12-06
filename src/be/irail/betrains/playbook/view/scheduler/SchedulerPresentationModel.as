package be.irail.betrains.playbook.view.scheduler {

	import be.irail.api.data.stations.IRStation;
	import be.irail.api.event.IRailResultEvent;
	import be.irail.api.methodgroup.Scheduler;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.collections.ArrayCollection;

	[Event(name="connectionsChange", type="flash.events.Event")]
	public class SchedulerPresentationModel extends EventDispatcher {
		private var _schedule:Scheduler;

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
			if (value !== _isLoading) {
				_isLoading = value;
				dispatchEvent(new Event("isLoadingChange"));
			}
		}

		public function SchedulerPresentationModel() {
			_schedule = new Scheduler();
		}

		public function getSchedule(from:IRStation, to:IRStation, when:Date, dateArrDep:String = "depart"):void {
			_schedule.addEventListener(IRailResultEvent.SCHEDULER_RESULT, onSchedulerResult);
			_schedule.getRoutes(from, to, when, true, dateArrDep, ["train"]);
			isLoading = true;
		}

		private function onSchedulerResult(event:IRailResultEvent):void {
			_schedule.removeEventListener(IRailResultEvent.SCHEDULER_RESULT, onSchedulerResult);
			_connections = new ArrayCollection(event.result.data as Array);
			isLoading = false;

			dispatchEvent(new Event("connectionsChange"));
		}

	}
}