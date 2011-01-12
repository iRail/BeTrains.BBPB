package be.irail.betrains.playbook.data {

	import be.irail.api.data.stations.IRStation;
	import be.irail.api.event.IRailResult;

	[RemoteClass(alias="betrains.playbook.SchedulerQuery")]
	public class SchedulerQuery {
		public function SchedulerQuery(from:IRStation = null, to:IRStation = null, date:Date = null, arrDep:String = "") {
			this.from = from;
			this.to = to;
			this.when = date;
			this.departArrival = arrDep;
		}

		// ----------------------------
		// from
		// ----------------------------

		private var _from:IRStation;

		public function get from():IRStation {
			return _from;
		}

		public function set from(value:IRStation):void {
			if (value != _from) {
				_from = value;
			}
		}

		// ----------------------------
		// to
		// ----------------------------

		private var _to:IRStation;

		public function get to():IRStation {
			return _to;
		}

		public function set to(value:IRStation):void {
			if (value != _to) {
				_to = value;
			}
		}

		// ----------------------------
		// when
		// ----------------------------

		private var _when:Date;

		public function get when():Date {
			return _when;
		}

		public function set when(value:Date):void {
			if (value != _when) {
				_when = value;
			}
		}

		// ----------------------------
		// departArrival
		// ----------------------------

		private var _departArrival:String;

		public function get departArrival():String {
			return _departArrival;
		}

		public function set departArrival(value:String):void {
			if (value != _departArrival) {
				_departArrival = value;
			}
		}

		// ----------------------------
		// result
		// ----------------------------

		private var _result:IRailResult;

		public function get result():IRailResult {
			return _result;
		}

		public function set result(value:IRailResult):void {
			if (value !== _result) {
				_result = value;
			}
		}
	}
}