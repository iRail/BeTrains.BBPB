import flash.events.Event;

import qnx.locale.LocaleManager;

/**
 * Convenience function to return a localized string
 * */
[Bindable("localeChange")]
public function r(resourceName:String, ... parameters):String {
	return LocaleManager.localeManager.getResource(resourceName, parameters);
}

override protected function createChildren():void {
	super.createChildren();
	LocaleManager.localeManager.addEventListener(Event.CHANGE, dispatchLocaleChange);
}

private function dispatchLocaleChange(event:Event):void {
	dispatchEvent(new Event("localeChange"));
}
