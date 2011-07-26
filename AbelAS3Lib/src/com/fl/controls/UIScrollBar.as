// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.controls {

	import Error;
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import flash.display.DisplayObject;
	import fl.events.ScrollEvent;
	import flash.events.Event;
	import flash.events.TextEvent;
		
    //--------------------------------------
    //  Class description
    //--------------------------------------    
	/**
	 * The UIScrollBar class includes all of the scroll bar functionality, but 
     * adds a <code>scrollTarget</code> property so it can be attached
	 * to a TextField instance or a TLFTextField instance.
	 *
	 * <p><strong>Note:</strong> When you use ActionScript to update properties of 
	 * the TextField or TLFTextField instance that affect the text layout, you must call the 
	 * <code>update()</code> method on the UIScrollBar component instance to refresh its scroll 
	 * properties. Examples of text layout properties that belong to the TextField or TLFTextField
	 * instance include <code>width</code>, <code>height</code>, and <code>wordWrap</code>.</p>
	 *
     * @includeExample examples/UIScrollBarExample.as -noswf
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0

	 *  @productversion Flash CS3
	 */
	public class UIScrollBar extends ScrollBar {
		
		/**
         * @private (private)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _scrollTarget:DisplayObject;

		/**
         * @private (private)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var inEdit:Boolean = false;	

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var inScroll:Boolean = false;

		/**
		 * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _targetScrollProperty:String;

		/**
		 * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _targetMaxScrollProperty:String;
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object = {};
		
        /**
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0

         *  @productversion Flash CS3
         */
		public static function getStyleDefinition():Object { 
			return UIComponent.mergeStyles(defaultStyles, ScrollBar.getStyleDefinition()); 
		}
		
		/**
         * Creates a new UIScrollBar component instance.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function UIScrollBar() {
			super();
		}
		
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set minScrollPosition(minScrollPosition:Number):void {
			super.minScrollPosition = (minScrollPosition<0)?0:minScrollPosition;
		}
		
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set maxScrollPosition(maxScrollPosition:Number):void {
			var maxScrollPos:Number = maxScrollPosition;
			if (_scrollTarget != null) { 
				maxScrollPos = Math.min(maxScrollPos, _scrollTarget[_targetMaxScrollProperty]);
			}
			super.maxScrollPosition = maxScrollPos;
		}
		
		/**
		 * Registers a TextField instance or a TLFTextField instance with the ScrollBar component instance.
         *
         * @includeExample examples/UIScrollBar.scrollTarget.1.as -noswf
         *
         * @see #update()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get scrollTarget():DisplayObject {
			return _scrollTarget;
		}
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set scrollTarget(target:DisplayObject):void {
			if (_scrollTarget != null) {
				_scrollTarget.removeEventListener(Event.CHANGE,handleTargetChange,false);
				_scrollTarget.removeEventListener(TextEvent.TEXT_INPUT,handleTargetChange,false);
				_scrollTarget.removeEventListener(Event.SCROLL,handleTargetScroll,false);
			}
			_scrollTarget = target;

			// deal with switch to or away from bidi or vertical target
			var blockProg:String = null;
			var textDir:String = null;
			var hasPixelVS:Boolean = false;
			if (_scrollTarget != null) {
				try {
					if (_scrollTarget.hasOwnProperty("blockProgression")) blockProg = _scrollTarget["blockProgression"];
					if (_scrollTarget.hasOwnProperty("direction")) textDir = _scrollTarget["direction"];
					if (_scrollTarget.hasOwnProperty("pixelScrollV")) hasPixelVS = true;
				} catch (e:Error) {
					blockProg = null;
					textDir = null;
				}
			}
			var scrollHoriz:Boolean = (this.direction == ScrollBarDirection.HORIZONTAL);
			var rot:Number = Math.abs(this.rotation);
			if (scrollHoriz && (blockProg == "rl" || textDir == "rtl")) {
				// flip it around and shift it for right to left text
				if (getScaleY() > 0 && rotation == 90) x += width;
				setScaleY(-1);
			} else if (!scrollHoriz && blockProg == "rl" && textDir == "rtl") {
				// flip it around it for right to left vertical text
				if (getScaleY() > 0 && rotation != 90) y += height;
				setScaleY(-1);
			} else {
				if (getScaleY() < 0) {
					if (scrollHoriz) {
						if (rotation == 90) x -= width;
					} else {
						if (rotation != 90) y -= height;
					}
				}
				setScaleY(1);
			}
			// determine which APIs we call, horizontal or vertical
			setTargetScrollProperties(scrollHoriz, blockProg, hasPixelVS);

			// add event listeners if necessary
			if (_scrollTarget != null) {
				_scrollTarget.addEventListener(Event.CHANGE,handleTargetChange,false,0,true);
				_scrollTarget.addEventListener(TextEvent.TEXT_INPUT,handleTargetChange,false,0,true);
				_scrollTarget.addEventListener(Event.SCROLL,handleTargetScroll,false,0,true);
			}	
			invalidate(InvalidationType.DATA);
		}
		
		[Inspectable()]
		/**
		 * @private (internal)
         * @internal For specifying in inspectable, and setting dropTarget
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		public function get scrollTargetName():String {
			return _scrollTarget.name;	
		}
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set scrollTargetName(target:String):void {
			try {
				scrollTarget = parent.getChildByName(target);
			} catch (error:Error) {
				throw new Error("ScrollTarget not found, or is not a valid target");
			}
		}
		
		[Inspectable(defaultValue="vertical", type="list", enumeration="vertical,horizontal")]
		/**
		 * @copy fl.controls.ScrollBar#direction
         *
         * @default ScrollBarDirection.VERTICAL
         *
         * @includeExample examples/UIScrollBar.direction.1.as -noswf
         * @includeExample examples/UIScrollBar.direction.2.as -noswf
         *
         * @see ScrollBarDirection
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */		
		override public function get direction():String { return super.direction; }


		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set direction(dir:String):void {
			// in live preview mode always render vertical
			if (isLivePreview) return;
			// if shifted and flipped for right to left and/or top to bottom, fix that first
			var cacheScrollTarget:DisplayObject;
			if (!componentInspectorSetting && _scrollTarget != null) {
				cacheScrollTarget = _scrollTarget;
				scrollTarget = null;
			}
			super.direction = dir;
			if (cacheScrollTarget != null) {
				scrollTarget = cacheScrollTarget;
			} else {
				updateScrollTargetProperties();
			}
		}
		
		/**
		 * Forces the scroll bar to update its scroll properties immediately.  
         * This is necessary after text in the specified <code>scrollTarget</code> text field
		 * is added using ActionScript, and the scroll bar needs to be refreshed.
         *
         * @see #scrollTarget
         *
         * @includeExample examples/UIScrollBar.update.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function update():void {
			inEdit = true;
			updateScrollTargetProperties();
			inEdit = false;
		}
		
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function draw():void {
			if (isInvalid(InvalidationType.DATA)) {
				updateScrollTargetProperties();
			}
			super.draw();
		}
		
	    /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function updateScrollTargetProperties():void {
			if (_scrollTarget == null) {
				setScrollProperties(pageSize,minScrollPosition,maxScrollPosition);
				scrollPosition = 0;
			} else {
				var blockProg:String = null;
				var hasPixelVS:Boolean = false;
				try {
					if (_scrollTarget.hasOwnProperty("blockProgression")) blockProg = _scrollTarget["blockProgression"];
					if (_scrollTarget.hasOwnProperty("pixelScrollV")) hasPixelVS = true;
				} catch (e1:Error) {
				}
				setTargetScrollProperties(this.direction == ScrollBarDirection.HORIZONTAL, blockProg, hasPixelVS);

				var pageSize:Number;
				var minScroll:Number;
				if (_targetScrollProperty == "scrollH") {
					minScroll = 0;
					try {
						if (_scrollTarget.hasOwnProperty("controller") && _scrollTarget["controller"].hasOwnProperty("compositionWidth")) {
							pageSize = _scrollTarget["controller"]["compositionWidth"];
						} else {
							pageSize = _scrollTarget.width;
						}
					} catch (e2:Error) {
						pageSize = _scrollTarget.width;
					}
				} else {
					try {
						// hasOwnProperty will fail because it is in a namespace, so assume blockProg != null
						// means we are TLF and it will be there, and if not just catch error
						if (blockProg != null) {
							namespace local_tlf_internal = "http://ns.adobe.com/textLayout/internal/2008";
							use namespace local_tlf_internal;
							var minScrollVValue:* = _scrollTarget["pixelMinScrollV"];
							if (minScrollVValue is int) {
								minScroll = minScrollVValue;
							} else {
								minScroll = 1;
							}
						} else {
							minScroll = 1;
						}
					} catch (e3:Error) {
						minScroll = 1;
					}
					pageSize = 10;					
				}
				setScrollProperties(pageSize, minScroll, scrollTarget[_targetMaxScrollProperty]);
				scrollPosition = _scrollTarget[_targetScrollProperty];
			}
		}
		
		/**
		 * @copy fl.controls.ScrollBar#setScrollProperties()
         *
         * @see ScrollBar#pageSize ScrollBar.pageSize
         * @see ScrollBar#minScrollPosition ScrollBar.minScrollPosition
         * @see ScrollBar#maxScrollPosition ScrollBar.maxScrollPosition
         * @see ScrollBar#pageScrollSize ScrollBar.pageScrollSize
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		override public function setScrollProperties(pageSize:Number,minScrollPosition:Number,maxScrollPosition:Number,pageScrollSize:Number=0):void {
			var maxScrollPos:Number = maxScrollPosition;
			var minScrollPos:Number  = (minScrollPosition<0)?0:minScrollPosition;
			
			if (_scrollTarget != null) {
				maxScrollPos = Math.min(maxScrollPosition, _scrollTarget[_targetMaxScrollProperty]);
			}
			super.setScrollProperties(pageSize,minScrollPos,maxScrollPos,pageScrollSize);
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function setScrollPosition(scrollPosition:Number, fireEvent:Boolean=true):void {
			super.setScrollPosition(scrollPosition, fireEvent);
			if (!_scrollTarget) { inScroll = false; return; }
			updateTargetScroll();
		}

		// event default is null, so when user calls setScrollPosition, the text is updated, and we don't pass an event
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function updateTargetScroll(event:ScrollEvent=null):void {
			if (inEdit) { return; } // Update came from the user input. Ignore.
			_scrollTarget[_targetScrollProperty] = scrollPosition;
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function handleTargetChange(event:Event):void {
			inEdit = true;
			setScrollPosition(_scrollTarget[_targetScrollProperty], true);
			updateScrollTargetProperties();
			inEdit = false;
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function handleTargetScroll(event:Event):void {
			if (inDrag) { return; }
			if (!enabled) { return; }		
			inEdit = true;
			updateScrollTargetProperties(); // This needs to be done first! 
			
			scrollPosition = _scrollTarget[_targetScrollProperty];
			inEdit = false;
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function setTargetScrollProperties(scrollHoriz:Boolean, blockProg:String, hasPixelVS:Boolean = false):void
		{
			if (blockProg == "rl") {
				if (scrollHoriz) {
					_targetScrollProperty = hasPixelVS ? "pixelScrollV" : "scrollV";
					_targetMaxScrollProperty = hasPixelVS ? "pixelMaxScrollV" : "maxScrollV";
				} else {
					_targetScrollProperty = "scrollH";
					_targetMaxScrollProperty = "maxScrollH";
				}
			} else {
				if (scrollHoriz) {
					_targetScrollProperty = "scrollH";
					_targetMaxScrollProperty = "maxScrollH";
				} else {
					_targetScrollProperty = hasPixelVS ? "pixelScrollV" : "scrollV";
					_targetMaxScrollProperty = hasPixelVS ? "pixelMaxScrollV" : "maxScrollV"
				}
			}
		}

	}
}
