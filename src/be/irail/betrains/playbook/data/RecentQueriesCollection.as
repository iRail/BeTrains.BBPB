package be.irail.betrains.playbook.data {

	import be.irail.betrains.playbook.controller.AppSettings;

	import mx.collections.ArrayCollection;

	public class RecentQueriesCollection extends ArrayCollection {

		public function RecentQueriesCollection(source:Array = null) {
			super(source);
		}

		override public function addItem(item:Object):void {
			if ((this.length + 1) > AppSettings.MAX_NUM_STORED_RECENTS) {
				var diff:int = (this.length + 1) - AppSettings.MAX_NUM_STORED_RECENTS;
				while (diff--) {
					removeItemAt(0);
				}
			}

			super.addItem(item);
		}
	}
}