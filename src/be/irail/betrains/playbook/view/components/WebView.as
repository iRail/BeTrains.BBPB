package be.irail.betrains.playbook.view.components {

	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import mx.core.UIComponent;

	import qnx.media.QNXStageWebView;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	public class WebView extends UIComponent {

		protected var myStage:Stage;

		private var _url:String;

		private var _text:String;

		private var _stageWebView:QNXStageWebView;

		public function WebView() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		public function set url(url:String):void {
			_url = url;

			if (_stageWebView) {
				_stageWebView.loadURL(url);
			}
		}

		public function set text(text:String):void {
			_text = text;

			if (_stageWebView) {
				_stageWebView.loadString(text);
			}
		}

		public function hide():void {
			if (_stageWebView) {
				_stageWebView.stage = null;
			}
		}

		public function show():void {
			if (_stageWebView && stage) {
				_stageWebView.stage = stage;
			}
		}

		public function dispose():void {
			_stageWebView.loadString("");
			setTimeout(doDispose, 100)
		}

		private function doDispose():void {
			_stageWebView.stage = null;
			_stageWebView = null;
		}

		protected function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			_stageWebView = new QNXStageWebView();
			_stageWebView.stage = stage;

			var position:Point = new Point(x, y);
			position = localToGlobal(position);

			_stageWebView.viewPort = new Rectangle(position.x, position.y, width, height);

			_stageWebView.addEventListener(Event.COMPLETE, completeHandler);
			_stageWebView.addEventListener(ErrorEvent.ERROR, errorHandler);

			if (_url) {
				_stageWebView.loadURL(_url);
			} else if (_text) {
				_stageWebView.loadString(_text);
			}
		}

		protected function completeHandler(event:Event):void {
			dispatchEvent(event.clone());
		}


		protected function errorHandler(event:ErrorEvent):void {
			dispatchEvent(event.clone());
		}

	}
}
