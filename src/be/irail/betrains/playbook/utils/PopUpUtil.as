package be.irail.betrains.playbook.utils {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;

	public class PopUpUtil {
		private static const bgColor:uint = 0x060606;

		private static const bgAlpha:Number = .4;

		private static var popups:Vector.<Object> = new Vector.<Object>();

		private static var parent:DisplayObjectContainer = FlexGlobals.topLevelApplication as DisplayObjectContainer;

		public static function get hasOpenPopUps():Boolean {
			return (popups != null) && popups.length > 0;
		}

		public static function openPopUp(window:DisplayObject, center:Boolean):void {
			addPopupToIndex(window, center);
		}

		public static function removePopUp(popup:DisplayObject, dispatchEvent:Boolean = true):void {
			removePopupToIndex(popup, dispatchEvent);
		}

		public static function registerPopUpParent(parentCandidate:DisplayObjectContainer):void {
			if (parentCandidate) {
				parent = parentCandidate;
			} else {
				parent = FlexGlobals.topLevelApplication as DisplayObjectContainer;
			}
		}

		public static function clearPopUpParent():void {
			clearParent();
			parent = FlexGlobals.topLevelApplication as DisplayObjectContainer;
		}

		private static function addPopupToIndex(popup:DisplayObject, center:Boolean = true):void {
			popup.addEventListener(CloseEvent.CLOSE, onCloseEvent);
			popups.push({window: popup, center: center});

			drawWindows();
		}

		private static function clearParent():void {
			while (parent.numChildren) {
				parent.removeChildAt(0);
			}
		}

		private static function drawWindows():void {
			clearParent();

			if (popups.length > 0) {
				var bg:Sprite = new Sprite();
				bg.graphics.beginFill(bgColor, bgAlpha);
				bg.graphics.drawRect(0, 0, parent.width, parent.height);
				bg.graphics.endFill();

				parent.addChild(bg);

				for each (var popupData:Object in popups) {
					var window:DisplayObject = popupData.window;

					if (popupData.center) {
						window.x = (parent.width / 2) - (window.width / 2);
						window.y = (parent.height / 2) - (window.height / 2);
					}

					parent.addChild(window);
				}
			}
		}

		private static function onCloseEvent(event:CloseEvent):void {
			removePopupToIndex(event.currentTarget as DisplayObject);
		}

		private static function removePopupToIndex(popup:DisplayObject, dispatchEvent:Boolean = true):void {
			popup.removeEventListener(CloseEvent.CLOSE, onCloseEvent);

			if (dispatchEvent) {
				var e:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
				e.detail = 0x0008;
				popup.dispatchEvent(e);
			}

			var popupIndex:int;

			for (var i:int = 0; i < popups.length; i++) {
				if (popups[i].window == popup) {
					popupIndex = i;
					break;
				}
			}

			if (popupIndex > -1) {
				popups.splice(popupIndex, 1);
			}

			drawWindows();
		}

	}
}