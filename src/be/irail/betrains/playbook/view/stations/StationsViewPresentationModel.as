package be.irail.betrains.playbook.view.stations {

	import be.irail.api.data.stations.IRStation;
	import be.irail.betrains.playbook.controller.ModelLocator;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.collections.ArrayCollection;

	public class StationsViewPresentationModel extends EventDispatcher {
		private var _model:ModelLocator = ModelLocator.getInstance();

		private var _stationList:ArrayCollection;

		private var _nameFilter:String;

		// ----------------------------
		// selectedStation
		// ----------------------------

		private var _selectedStation:IRStation;

		[Bindable(event="selectedStationChange")]
		public function get selectedStation():IRStation {
			return _selectedStation;
		}

		[Bindable(event="selectedStationChange")]
		public function get hasStation():Boolean {
			return _selectedStation != null;
		}

		public function set selectedStation(value:IRStation):void {
			_selectedStation = value;
			dispatchEvent(new Event("selectedStationChange"));
		}

		[Bindable(event="stationListChange")]
		public function get stations():ArrayCollection {
			return _stationList;
		}

		public function init():void {
			_stationList = new ArrayCollection(_model.stations.toArray());
			_stationList.filterFunction = filterList;
			refreshList();
		}

		public function updateFilter(text:String):void {
			_nameFilter = text;
		}

		private function filterList(obj:Object):Boolean {
			if (!_nameFilter || _nameFilter.length == 0) {
				return true;
			}

			var name:String = String(obj.name).toLowerCase().substr(0, _nameFilter.length),
				test:RegExp = new RegExp(_nameFilter, "ig"),
				result:Array = name.match(test);

			return (result && result.length > 0);
		}

		public function refreshList():void {
			_stationList = new ArrayCollection(_model.stations.toArray());
			_stationList.filterFunction = filterList;
			_stationList.refresh();

			dispatchEvent(new Event("stationListChange"));

		}

	}
}