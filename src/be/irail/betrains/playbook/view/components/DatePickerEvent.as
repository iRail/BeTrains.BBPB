package be.irail.betrains.playbook.view.components {
	import flash.events.Event;

	public class DatePickerEvent extends Event {
		public static const DATE_PICKER_SET:String = 'datePickerSet';
		public static const DATE_PICKER_CANCEL:String = 'datePickerCancel';

		public var date:Date;

		public function DatePickerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}