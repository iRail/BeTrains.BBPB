package be.irail.betrains.playbook.view.components {

	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	import qnx.media.QNXStageWebView;

	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="locationChanging", type="flash.events.LocationChangeEvent")]
	[Event(name="locationChange", type="flash.events.LocationChangeEvent")]

	/**
	 * A UIComponent wrapper around the QNXStageWebView
	 * To use,
	 *
	 * Loading a URL:
	 * <local:WebView source="http://google.com/" top="5" width="400" height="300"/>
	 *
	 * Loading HTML text (not tested):
	 * <local:WebView content="...html code here..." top="5" width="400" height="300"/>
	 *
	 * Credits: myself and code from Soenke's post, http://soenkerohde.com/2010/11/air-mobile-QNXStageWebView-uicomponent/
	 * */
	public class WebView extends UIComponent {

		/**
		 * When set to true the source URL will be loaded when it is set. Default is true.
		 * */
		[Bindable]
		public var autoLoad:Boolean = true;


		public function WebView() {
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

			// not sure if this is the place to give it a minimum size
			// if we don't do this without a defined size its 0 x 0
			width = 480;
			height = 300;
		}

		private function onCreationComplete(event:FlexEvent):void {
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedToStageHandler);
		}

		/**
		 * When the stage property is available add it to the web view
		 * */
		public function addedToStageHandler(event:Event):void {
		}

		public function removedToStageHandler(event:Event):void {
		}

		/**
		 * Load the URL passed in or load the URL specified in the source property
		 * */
		public function load(URL:String = ""):void {

			if (URL) {
				webView.loadURL(URL);
				_source = URL;
			} else if (source) {
				webView.loadString(source);
			}

		}

		/**
		 * Load the text passed in
		 * */
		public function loadString(value:String, mimeType:String = "text/html"):void {
			content = value;
			if (webView) {
				webView.loadString(value, mimeType);
			}
		}

		private var _webView:QNXStageWebView;

		/**
		 * @private
		 * */
		public function get webView():QNXStageWebView {
			return _webView;
		}

		/**
		 * Stage Web View is a window to the native browser. It accepts a URL location or text.
		 * To pass in a URL set the source property. To set the text set the text property.
		 * */
		[Bindable]
		public function set webView(value:QNXStageWebView):void {
			_webView = value;
		}

		private var _source:String;

		/**
		 * @private
		 * */
		public function get source():String {
			return _source;
		}

		/**
		 * Source URL for stage web view. If autoLoad is set to true then the URL is loaded automatically.
		 * If not use load method to load the source URL
		 * */
		[Bindable]
		public function set source(value:String):void {
			_source = value;

			if (webView && autoLoad) {
				_loadSucces = false;
				webView.loadURL(source);
			}
		}

		private var _content:String;

		/**
		 * Sets the content of the webview. Default mime type is text/html.
		 * This feature has not been tested.
		 * */
		[Bindable]
		public function set content(value:String):void {
			_content = value;

			if (webView) {
				_loadSucces = false;
				webView.loadString(value, mimeType);
			}
		}

		public function get content():String {
			return _content;
		}

		private var _mimeType:String = "text/html";

		/**
		 * MIME type of the web view content. Default is "text/html"
		 * */
		public function get mimeType():String {
			return _mimeType;
		}

		/**
		 * @private
		 */
		public function set mimeType(value:String):void {
			_mimeType = value;
		}

		/**
		 * Hides the web view
		 * */
		public function hide():void {
			if (webView && webView.stage != null)
				webView.stage = null;
		}

		/**
		 * Displays the web view
		 * */
		public function show():void {
			if (webView && webView.stage == null)
				webView.stage = stage;
		}

		/**
		 * Disposes of the webview content
		 * */
		public function dispose():void {
			if (webView) {
				webView.dispose();
			}
		}


		/**
		 * Add event listeners to stage web view events
		 * */
		override protected function createChildren():void {
			super.createChildren();

			webView = new QNXStageWebView();

			webView.addEventListener(Event.COMPLETE, completeHandler);
			webView.addEventListener(ErrorEvent.ERROR, errorHandler);

			_loadSucces = false;

			// load URL or text if available
			if (autoLoad && source) {
				webView.loadURL(source);
			} else if (content) {
				webView.loadString(content, mimeType);
			}
		}

		private var _loadSucces:Boolean;

		/**
		 * Dispatched when the page or web content has been fully loaded
		 * */
		protected function completeHandler(event:Event):void {
			_loadSucces = true;

			show();

			dispatchEvent(event.clone());
		}

		/**
		 * Dispatched when an error occurs
		 * */
		protected function errorHandler(event:ErrorEvent):void {
			_loadSucces = false;
			hide();
			dispatchEvent(event.clone());
		}

		/**
		 * Draws the object and/or sizes and positions its children.
		 * */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {

			// because the webview is positioned according to the stage rather than the container 
			// the component is apart of we get the adjusted position
			reposition(unscaledWidth, unscaledHeight);
		}

		public function reposition(w:Number = -1, h:Number = -1):void {
			if (w < 0)
				w = unscaledWidth;

			if (h < 0)
				h = unscaledHeight;

			if (webView) {
				var position:Point = new Point(this.x, this.y);
				position = localToGlobal(position);
				webView.viewPort = new Rectangle(position.x, position.y, w, h);
			}
		}

	}
}
