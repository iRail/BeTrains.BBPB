package be.irail.betrains.playbook.utils {

	import flash.display.DisplayObject;

	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class PopUpUtil {
		private static var popups:Vector.<IFlexDisplayObject> = new Vector.<IFlexDisplayObject>();

		private static var parent:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;

		public static function get hasOpenPopUps():Boolean {
			return (popups != null) && popups.length > 0;
		}

		public static function createPopUp(clazz:Class, center:Boolean):IFlexDisplayObject {
			var window:IFlexDisplayObject = PopUpManager.createPopUp(parent, clazz, true);
			addPopupToIndex(window);

			if (center) {
				PopUpManager.centerPopUp(window);
			}

			return window;
		}

		public static function openPopUp(window:IFlexDisplayObject, center:Boolean):void {
			PopUpManager.addPopUp(window, parent, true);

			if (center) {
				PopUpManager.centerPopUp(window);
			}

			addPopupToIndex(window);
		}

		public static function removePopUp(popup:IFlexDisplayObject):void {
			removePopupToIndex(popup);
			PopUpManager.removePopUp(popup);
		}

		public static function registerPopUpParent(parentCandidate:DisplayObject):void {
			if (parentCandidate) {
				parent = parentCandidate;
			} else {
				parent = FlexGlobals.topLevelApplication as DisplayObject;
			}
		}

		public static function clearPopUpParent():void {
			parent = FlexGlobals.topLevelApplication as DisplayObject;
		}

		private static function addPopupToIndex(popup:IFlexDisplayObject):void {
			popup.addEventListener(CloseEvent.CLOSE, onCloseEvent);
			popups.push(popup);
		}

		private static function onCloseEvent(event:CloseEvent):void {
			removePopupToIndex(event.currentTarget as IFlexDisplayObject);
		}

		private static function removePopupToIndex(popup:IFlexDisplayObject):void {
			popup.removeEventListener(CloseEvent.CLOSE, onCloseEvent);

			var e:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
			e.detail = 0x0008;
			popup.dispatchEvent(e);

			var popupIndex:int = popups.indexOf(popup);
			if (popupIndex > -1) {
				popups.splice(popupIndex, 1);
			}
		}

	}
}