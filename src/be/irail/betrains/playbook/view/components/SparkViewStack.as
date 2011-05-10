package be.irail.betrains.playbook.view.components {

	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	import spark.components.BorderContainer;
	import spark.events.IndexChangeEvent;

	[DefaultProperty("content")]
	[Event(name="change", type="spark.events.IndexChangeEvent")]
	[Event(name="changing", type="spark.events.IndexChangeEvent")]
	public class SparkViewStack extends BorderContainer {

		[ArrayElementType("mx.core.IVisualElement")]
		protected var _content:Array;

		protected var _selectedIndex:int = -1;

		protected var _selectedChild:IVisualElement;

		protected var _pendingSelectedIndex:int = -1;

		public function SparkViewStack():void {
			setStyle("backgroundAlpha", 0);
		}

		override protected function commitProperties():void {

			super.commitProperties();

			// if pending change to selectedIndex property

			if (_pendingSelectedIndex != -1) {
				// commit the change

				// dispatch index change
				var event:IndexChangeEvent = new IndexChangeEvent(
					IndexChangeEvent.CHANGING,
					false, false,
					_selectedIndex, _pendingSelectedIndex);

				dispatchEvent(event);

				updateSelectedIndex(_pendingSelectedIndex);

				// set pending back to default
				_pendingSelectedIndex = -1;
			}

		}


		protected function updateSelectedIndex(index:int):void {
			// store old for event
			var oldIndex:int = _selectedIndex;

			// set new
			_selectedIndex = index;

			// remove old element
			if (content[oldIndex]) {
				content[oldIndex].visible = false;
				content[oldIndex].scrollRect = new Rectangle(0, 0, 1, 1);
			}

			content[_selectedIndex].visible = true;
			content[_selectedIndex].scrollRect = null;

			// add new element
			selectedChild = _content[_selectedIndex];

			// dispatch index change
			var event:IndexChangeEvent = new IndexChangeEvent(
				IndexChangeEvent.CHANGE,
				false, false,
				oldIndex, _selectedIndex);

			dispatchEvent(event);
		}


		private function getElementIndexFromContent(element:IVisualElement):int {
			if (_content == null) {
				return -1;
			}

			var i:int = _content.length;
			var contentElement:IVisualElement;

			while (--i > -1) {
				contentElement = _content[i] as IVisualElement;

				if (contentElement == element) {
					break;
				}
			}

			return i;

		}

		[Bindable]
		[ArrayElementType("mx.core.IVisualElement")]
		public function get content():Array /*IVisualElement*/ {
			return _content;
		}

		public function set content(value:Array /*IVisualElement*/):void {
			_content = value;

			while (numElements) {
				removeElementAt(0);
			}

			var numContentElements:int = value.length,
				i:int = 0;
			for (i = 0; i < numContentElements; i++) {
				addElementAt(value[i], i);
				value[i].visible = false;
				value[i].scrollRect = new Rectangle(0, 0, 1, 1);
			}

			selectedIndex = _pendingSelectedIndex == -1 ? 0 : _pendingSelectedIndex;
		}

		private function onElementCreated(e:FlexEvent):void {
			this.removeElement(e.currentTarget as IVisualElement)
		}

		[Bindable]
		public function get selectedIndex():int {
			return _pendingSelectedIndex == -1 ? _selectedIndex : _pendingSelectedIndex;
		}

		public function set selectedIndex(value:int):void {

			if (_selectedIndex == value) {
				return;
			}

			_pendingSelectedIndex = value;
			invalidateProperties();
		}


		[Bindable]
		public function get selectedChild():IVisualElement {
			return _selectedChild;
		}

		public function set selectedChild(value:IVisualElement):void {
			if (_selectedChild == value) {
				return;
			}

			// if not pending operation on selectedIndex, induce

			if (_pendingSelectedIndex == -1) {

				var proposedIndex:int = getElementIndexFromContent(value);

				selectedIndex = proposedIndex;

			} else {
				_selectedChild = value;
			}
		}


		override public function getElementAt(index:int):IVisualElement {
			return _content[index];
		}
	}
}