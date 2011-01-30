package be.irail.betrains.playbook.view.components {

	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import mx.containers.ViewStack;
	import mx.core.ContainerCreationPolicy;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	import spark.components.Group;
	import spark.events.IndexChangeEvent;

	/**
	 * Dispatched on change to selectedIndex property value.
	 */
	[Event(name="change", type="spark.events.IndexChangeEvent")]

	/**
	 * Basic implementation of a ViewStack container targeting the Spark environment.
	 * SparkViewStack inherently supports deferred instantiation. All methods and properties
	 * have been made protected in order to subclass and implement any desired creation
	 * policy.
	 *
	 * Child content cannot be added in markup due to the black-boxing of the mxmlContent and
	 * mxmlContentFactory properties and corresponding methods. As such, supply content to the
	 * SparkViewStack using the <b>content</b> property. The <b>content</b> property is an array
	 * of declared IVisibleElement instances.
	 *
	 * To enable scrolling of content added to the display list of SparkViewStack, it is recommended
	 * the either programatically control the viewport with an external scrollbar or wrap the
	 * container in a <s:Scroller> instance.
	 *
	 * The <b>content</b> and <b>selectedIndex</b> properties can be set in-line in MXML.
	 * The <b>selectedChild</b> property can only be set within ActionScript.
	 */
	[DefaultProperty("content")]
	public class SparkViewStack extends Group {

		/**
		 * Represents the collection of IVisualElement instances to be displayed.
		 */
		[ArrayElementType("mx.core.IVisualElement")]
		protected var _content:Vector.<IVisualElement> = new Vector.<IVisualElement>();

		protected var _arrayChildren:Dictionary = new Dictionary();

		/**
		 * The index within the colleciton of IVisualElements to be added to the display list.
		 */
		protected var _selectedIndex:int = -1;

		/**
		 * Represents the current IVisualElement on the display list.
		 */
		protected var _selectedChild:IVisualElement

		/**
		 * Held value for selectedIndex.
		 */
		protected var _pendingSelectedIndex:int = -1;

		public var previousViewIndex:int = 0;

		override public function set visible(value:Boolean):void {
			var view:UIComponent = _arrayChildren[selectedIndex] as UIComponent;
			if (view) {
				view.visible = value;
				if (value) {
					this.scrollRect = new Rectangle(0, 0, width, height);
				} else {
					this.scrollRect = new Rectangle(0, 0, 1, 1);
				}
			}
			super.visible = value;
		}

		// ----------------------------
		// animateSelectedItemChange
		// ----------------------------

		private var _animateSelectedItemChange:Boolean = true;

		public function get animateSelectedItemChange():Boolean {
			return _animateSelectedItemChange;
		}

		public function set animateSelectedItemChange(value:Boolean):void {
			if (value !== _animateSelectedItemChange) {
				_animateSelectedItemChange = value;
			}
		}

		public function get numContentChildren():int {
			if (!content) {
				return 0;
			}

			return content.length;
		}

		/**
		 * @private
		 *
		 * Override to update selectedIndex and subsequently content on the display list.
		 */
		override protected function commitProperties():void {
			super.commitProperties();
			// if pending change to selectedIndex property.
			if (_pendingSelectedIndex != -1) {
				// commit the change.
				updateSelectedIndex(_pendingSelectedIndex);
				// set pending back to default.
				_pendingSelectedIndex = -1;
			}
		}

		/**
		 * Updates the selectedIndex value and subsequent display.
		 * @param index int The value representing the selected child index within the content property.
		 */
		protected function updateSelectedIndex(index:int):void {
			//store old for event.
			var oldIndex:int = _selectedIndex;
			previousViewIndex = oldIndex;

			if (animateSelectedItemChange) {
				//4,6,1
				//3,5,0
				var animationFadeOutDuration:Number = 4;
				var animationFadeInDuration:Number = 6;
				var animationFadeOutFadeInDelay:Number = 0;

				if (oldIndex > -1 && _content[oldIndex] != null) {
					_content[oldIndex].alpha = .7;
					TweenLite.to(_content[oldIndex], animationFadeOutDuration, {alpha: 0, useFrames: true, overwrite: true, onComplete: function():void {
										 updateIndexChangeHandler(oldIndex, index);
										 setTimeout(function():void {
											 TweenLite.to(_content[index], animationFadeInDuration, {alpha: 1, delay: animationFadeOutFadeInDelay, overwrite: false, useFrames: true});
										 }, 50);
									 }});

				} else {
					updateIndexChangeHandler(oldIndex, index);
					setTimeout(function():void {
						_content[index].alpha = 0;
						TweenLite.to(_content[index], animationFadeInDuration, {alpha: 1, useFrames: true, overwrite: true});
					}, 50);
				}
			} else {
				updateIndexChangeHandler(oldIndex, index);
			}
		}

		private function updateIndexChangeHandler(oldIndex:int, newIndex:int):void {
			_selectedIndex = newIndex;

			var oldSelectedElement:UIComponent = _arrayChildren[oldIndex],
				selectedElement:UIComponent = _arrayChildren[_selectedIndex];

			// hide old element
			if (oldSelectedElement) {
				oldSelectedElement.visible = false;
				oldSelectedElement.scrollRect = new Rectangle(0, 0, 1, 1);
			}

			// show new element if exists
			if (selectedElement) {
				if (animateSelectedItemChange) {
					selectedElement.alpha = 0;
				} else {
					selectedElement.alpha = 1;
				}
				selectedElement.scrollRect = null;
				selectedElement.visible = true;
			} else {
				if (animateSelectedItemChange) {
					_content[_selectedIndex].alpha = 0;
				} else {
					_content[_selectedIndex].alpha = 1;
				}

				selectedElement = _content[_selectedIndex] as UIComponent;

				_arrayChildren[_selectedIndex] = selectedElement;

				selectedElement.scrollRect = null;
				selectedElement.visible = true;

				selectedElement.dispatchEvent(new FlexEvent(FlexEvent.SHOW));
			}

			selectedChild = _content[_selectedIndex];
			dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CHANGE, false, false, oldIndex, _selectedIndex));
		}


		/**
		 * Returns the elemental index of the IVisualElement from the content array.
		 * @param element IVisualElement The IVisualElement instance to find in the content array.
		 * @return int The elemental index in which the IVisualElement resides. If not available returns -1.
		 *
		 */
		private function getElementIndexFromContent(element:IVisualElement):int {
			if (_content == null) {
				return -1;
			}

			var i:int = _content.length,
				contentElement:IVisualElement;
			while (--i > -1) {
				contentElement = _content[i] as IVisualElement;
				if (contentElement == element) {
					break;
				}
			}
			return i;
		}

		/**
		 * Sets the array of IVisualElement instances to display based on selectedIndex and selectedChild.
		 * @return Vector.<IVisualElement>
		 */
		[Bindable]
		public function get content():Vector.<IVisualElement> /*IVisualElement*/ {
			return _content;
		}

		public function set content(value:Vector.<IVisualElement> /*IVisualElement*/):void {
			_content = value;
			// update selected index based on pending operations.

			while (numElements) {
				removeElementAt(0);
			}

			var i:int = -1;
			while (++i < content.length) {
				var element:IVisualElement = content[i],
					uic:UIComponent = UIComponent(element);

				uic.scrollRect = new Rectangle(0, 0, 1, 1);
				uic.setVisible(false, true);

				uic.addEventListener(FlexEvent.CREATION_COMPLETE, onComponentCreationComplete);
				addElementAt(element, i);
			}

			createChildren();

			selectedIndex = _pendingSelectedIndex == -1 ? 0 : _pendingSelectedIndex;
		}

		/**
		 * Sets the selectedIndex to be used to add an IVisualElement instance from the content property
		 * to the display list.
		 * @return int
		 */
		[Bindable]
		public function get selectedIndex():int {
			return _pendingSelectedIndex != -1 ? _pendingSelectedIndex : _selectedIndex;
		}

		public function set selectedIndex(value:int):void {
			if (selectedChild && _selectedIndex == value) {
				selectedChild.dispatchEvent(new FlexEvent(FlexEvent.SHOW));
				return;
			}

			_pendingSelectedIndex = value;
			invalidateProperties();
		}

		/**
		 * Sets the selectedChild to be added to the display list form the content array.
		 * SelectedChild can only be set in ActionScript and will not be properly updated
		 * if added inline in MXML declaration.
		 * @return IVisualElement
		 */
		[Bindable]
		public function get selectedChild():IVisualElement {
			return _selectedChild;
		}

		public function set selectedChild(value:IVisualElement):void {
			if (_selectedChild == value) {
				return;
			}

			// if not pending operation on selectedIndex, induce.
			if (_pendingSelectedIndex == -1) {
				var proposedIndex:int = getElementIndexFromContent(value);
				selectedIndex = proposedIndex;
			}
			// else just hold a reference for binding update.
			_selectedChild = value;
		}


		private function onComponentCreationComplete(event:FlexEvent):void {
			event.currentTarget.removeEventListener(FlexEvent.CREATION_COMPLETE, onComponentCreationComplete);
		}

		override public function addElementAt(element:IVisualElement, index:int):IVisualElement {
			if (element.visible) {
				UIComponent(element).setVisible(false, true);
			}
			return super.addElementAt(element, index);
		}

	}
}