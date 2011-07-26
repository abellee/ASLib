// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.managers {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.core.UIComponent;	
	import flash.system.Capabilities;
	import flash.utils.*;
	
	/**
	 *  The FocusManager class manages focus for a set of components that are navigated by mouse 
	 *  or keyboard as a <em>tab loop</em>. 
	 *
	 *  <p>A tab loop is typically navigated by using the Tab key; focus moves between the components 
	 *  in the tab loop in a circular pattern from the first component that has focus, to the last, 
	 *  and then back again to the first. A tab loop includes all the components and tab-enabled
	 *  components in a container. An application can contain numerous tab loops.</p>
	 *  
	 *  <p>A FocusManager instance is responsible for a single tab loop; an application uses
	 *  a different FocusManager instance to manage each tab loop that it contains, although
	 *  a main application is always associated with at least one FocusManager instance. An
	 *  application may require additional FocusManager instances if it includes a popup window,
	 *  for example, that separately contains one or more tab loops of components.</p> 
	 * 
	 *  <p>All components that can be managed by a FocusManager instance must implement the
	 *  fl.managers.IFocusManagerComponent interface. Objects for which Flash Player
	 *  manages focus are not required to implement the IFocusManagerComponent interface.</p>  
	 *
	 *  <p>The FocusManager class also manages how the default button is implemented. A default button 
	 *  dispatches a <code>click</code> event when the Enter key is pressed on a form, 
	 *  depending on where focus is at the time.  The default button does not dispatch the
	 *  <code>click</code> event if a text area has focus or if a value is being edited in
	 *  a component, for example, in a ComboBox or NumericStepper component.</p>
	 * 
	 * @see IFocusManager
	 * @see IFocusManagerComponent
     *
     * @includeExample examples/FocusManagerExample.as -noswf
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	public class FocusManager implements IFocusManager {

		/**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _form:DisplayObjectContainer;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var focusableObjects:Dictionary;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var focusableCandidates:Array;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var activated:Boolean = false;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var calculateCandidates:Boolean = true;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var lastFocus:InteractiveObject;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _showFocusIndicator:Boolean = true;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var lastAction:String;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var defButton:Button;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _defaultButton:Button;


        /**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _defaultButtonEnabled:Boolean = true;

		/**
		 *  Creates a new FocusManager instance.
		 *
		 *  <p>A focus manager manages focus within the children of a 
		 *  DisplayObjectContainer object.</p>
		 *
		 *  @param container A DisplayObjectContainer that hosts the focus manager, 
         *  or <code>stage</code>.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function FocusManager(container:DisplayObjectContainer) {
			focusableObjects = new Dictionary(true);
			if(container != null) {
				_form = container;
				activate();
			}
		}

		/**
		 *  @private
         *  Listen for children being added and see if they are focus candidates.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function addedHandler(event:Event):void {
			var target:DisplayObject = DisplayObject(event.target);
			// if it is truly parented, add it, otherwise it will get added 
			// when the top of the tree gets parented
			if (target.stage) {
				addFocusables(DisplayObject(event.target));
			}
		}
		
		/**
		 *  @private
         *  Listen for children being removed.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function removedHandler(event:Event):void {
			var i:int;
			var o:DisplayObject = DisplayObject(event.target);
			if (o is IFocusManagerComponent && focusableObjects[o] == true) {
				if (o == lastFocus) {
					IFocusManagerComponent(lastFocus).drawFocus(false);
					lastFocus = null;
				}
				o.removeEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false);
				delete focusableObjects[o];
				calculateCandidates = true;					
			} else if(o is InteractiveObject && focusableObjects[o] == true) {
				var io:InteractiveObject = o as InteractiveObject;
				if(io) {
					if (io == lastFocus) {
						lastFocus = null;
					}
					delete focusableObjects[io];
					calculateCandidates = true;
				}
				o.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false, 0, true);
			}
			removeFocusables(o);
		}
		
		/**
		 *  @private
         *  Do a tree walk and add all children you can find.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function addFocusables(o:DisplayObject, skipTopLevel:Boolean = false):void {
			if(!skipTopLevel) {
				if (o is IFocusManagerComponent) {
					var focusable:IFocusManagerComponent = IFocusManagerComponent(o);
					if (focusable.focusEnabled) {
						if (focusable.tabEnabled && isTabVisible(o)) {
							focusableObjects[o] = true;
							calculateCandidates = true;
						}
						o.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false, 0, true);
						o.addEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler, false, 0, true);
					}
				} else if(o is InteractiveObject) {
					var io:InteractiveObject = o as InteractiveObject;
					if(io && io.tabEnabled && findFocusManagerComponent(io) == io) {
						focusableObjects[io] = true;
						calculateCandidates = true;
					}
					io.addEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false, 0, true);
					io.addEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler, false, 0, true);
				}
			}
			if (o is DisplayObjectContainer) {
				var doc:DisplayObjectContainer = DisplayObjectContainer(o);
				o.addEventListener(Event.TAB_CHILDREN_CHANGE, tabChildrenChangeHandler, false, 0, true);
				var docParent:DisplayObjectContainer = null;
				try {
					docParent = doc.parent;
				} catch (se:SecurityError) {
					docParent = null;
				}
				if (doc is Stage || docParent is Stage || doc.tabChildren) {
					var i:int;
					for (i = 0; i < doc.numChildren; i++) {
						try {
							var child:DisplayObject = doc.getChildAt(i);
							if(child != null) {
								addFocusables(doc.getChildAt(i));
							}
						} catch(error:SecurityError) {
							// Ignore this child if we can't access it
						}
					}
				}
			}
		}

		/**
		 *  @private
         *  Removes the DisplayObject and all its children.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function removeFocusables(o:DisplayObject):void {
			if (o is DisplayObjectContainer) {
				o.removeEventListener(Event.TAB_CHILDREN_CHANGE, tabChildrenChangeHandler, false);
				o.removeEventListener(Event.TAB_INDEX_CHANGE, tabIndexChangeHandler, false);
				for (var p:Object in focusableObjects) {
					var dob:DisplayObject = DisplayObject(p);
					if (DisplayObjectContainer(o).contains(dob)) {
						if (dob == lastFocus) {
							lastFocus = null;
						}
						dob.removeEventListener(Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler, false);
						delete focusableObjects[p];
						calculateCandidates = true;
					}
				}
			}
		}

		/**
		 *  @private
         *  Checks if the DisplayObject is visible for the tab loop.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function isTabVisible(o:DisplayObject):Boolean {
			try {
				var p:DisplayObjectContainer = o.parent;
				while (p && !(p is Stage) && !(p.parent && p.parent is Stage)) {
					if (!p.tabChildren) {
						return false;
					}
					p = p.parent;
				}
			} catch (se:SecurityError) {
			}
			return true;
		}

		/**
		 *  @private
         *  Checks if the DisplayObject is a valid candidate for the tab loop.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function isValidFocusCandidate(o:DisplayObject, groupName:String):Boolean {
			if (!isEnabledAndVisible(o)) {
				return false;
			}
			if (o is IFocusManagerGroup) {
				var tg:IFocusManagerGroup = IFocusManagerGroup(o);
				if (groupName == tg.groupName) {
					return false;
				}
			}
			return true;
		}

		/**
		 *  @private
		 *  Checks if the DisplayObject is enabled and visible, or
         *  a selectable or input TextField
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function isEnabledAndVisible(o:DisplayObject):Boolean {
			try {
				var formParent:DisplayObjectContainer = DisplayObject(form).parent;
				while (o != formParent) {
					if (o is UIComponent) {
						if (!UIComponent(o).enabled) {
							// The DO is a disabled UIComponent
							return false;
						}
					} else if(o is TextField) {
						var tf:TextField = TextField(o);
						if(tf.type == TextFieldType.DYNAMIC || !tf.selectable) {
							// The DO is a dynamic or non-selectable TextField
							return false;
						}
					} else if(o is SimpleButton) {
						var sb:SimpleButton = SimpleButton(o);
						if(!sb.enabled) {
							// The DO is a disabled SimpleButton
							return false;
						}
					}
					if (!o.visible) {
						// The DO is not visible
						return false;
					}
					o = o.parent;
				}
			} catch (se:SecurityError) {
			}
			return true;
		}
		
		/**
		 *  @private
         *  Add or remove object if tabbing properties change.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function tabEnabledChangeHandler(event:Event):void {
			calculateCandidates = true;
			var o:InteractiveObject = InteractiveObject(event.target);
			var registeredFocusableObject:Boolean = (focusableObjects[o] == true);
			if (o.tabEnabled) {
				if (!registeredFocusableObject && isTabVisible(o)) {
					if(!(o is IFocusManagerComponent)) {
						o.focusRect = false;
					}
					focusableObjects[o] = true;
					
				}
			} else {
				if (registeredFocusableObject) {
					delete focusableObjects[o];
				}
			}
		}

		/**
		 *  @private
         *  Called when a focusable object's <code>tabIndex</code> property changes.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function tabIndexChangeHandler(event:Event):void {
			calculateCandidates = true;
		}

		/**
		 *  @private
         *  Add or remove object if tabbing properties change.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function tabChildrenChangeHandler(event:Event):void {
			if (event.target != event.currentTarget) {
				return;
			}
			calculateCandidates = true;
			var o:DisplayObjectContainer = DisplayObjectContainer(event.target);
			if (o.tabChildren) {
				addFocusables(o, true);
			} else {
				removeFocusables(o);
			}
		}


		/**
		 *  Activates the FocusManager instance.
		 *
		 *  <p>The FocusManager instance adds event handlers that allow it to monitor
         *  focus-related keyboard and mouse activity.</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function activate():void {
			if (activated) {
				return;
			}
			addFocusables(form);
			// Listen for focus changes, use weak references for the stage.
			form.addEventListener(Event.ADDED, addedHandler,false,0,true);
			form.addEventListener(Event.REMOVED, removedHandler,false,0,true);
			try {
				form.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
				form.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
				form.stage.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
				form.stage.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
			} catch (se:SecurityError) {
				// if we cannot add event listeners to the stage, add them to form
				form.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
				form.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
				form.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
				form.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
			}
			form.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, true, 0, true);
			form.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true, 0, true);
			form.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true); 
			form.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true, 0, true);
			activated = true;
			// Restore focus to the last component that had it if there was one.
			if (lastFocus) {
				setFocus(lastFocus);
			}
		}

		/**
		 *  Deactivates the FocusManager.
		 *
		 *  <p>The FocusManager removes the event handlers that allow it to monitor
         *  focus-related keyboard and mouse activity.</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function deactivate():void
		{
			if (!activated) {
				return;
			}
			focusableObjects = new Dictionary(true);
			focusableCandidates = null;
			lastFocus = null;
			defButton = null;
			form.removeEventListener(Event.ADDED, addedHandler,false);
			form.removeEventListener(Event.REMOVED, removedHandler,false);
			try {
				form.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false);
				form.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false);
				form.stage.removeEventListener(Event.ACTIVATE, activateHandler, false);
				form.stage.removeEventListener(Event.DEACTIVATE, deactivateHandler, false);
			} catch (se:SecurityError) {
			}
			form.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false);
			form.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false);
			form.removeEventListener(Event.ACTIVATE, activateHandler, false);
			form.removeEventListener(Event.DEACTIVATE, deactivateHandler, false);
			form.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
			form.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
			form.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false); 
			form.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
			activated = false;
		}
		

		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function focusInHandler(event:FocusEvent):void {
			if (!activated) return;
			var target:InteractiveObject = InteractiveObject(event.target);
			if (form.contains(target)) {
				lastFocus = findFocusManagerComponent(InteractiveObject(target));
				// handle default button here
				if (lastFocus is Button) {
					var x:Button = Button(lastFocus);
					// if we have marked some other button as a default button
					if (defButton) {
						// change it to be this button
						defButton.emphasized = false;
						defButton = x;
						x.emphasized = true;
					}
				} else {
					// restore the default button to be the original one
					if (defButton && defButton != _defaultButton) {
						defButton.emphasized = false;
						defButton = _defaultButton;
						_defaultButton.emphasized = true;
					}
				}
			}
		}

		/**
		 *  @private
         *  Useful for debugging.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function focusOutHandler(event:FocusEvent):void {
			if (!activated) return;
			var target:InteractiveObject = event.target as InteractiveObject;
		}


		/**
		 *  @private
         *  Restore focus to the element that had it last.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function activateHandler(event:Event):void {
			if (!activated) return;
			var target:InteractiveObject = InteractiveObject(event.target);
			if (lastFocus) {
				if(lastFocus is IFocusManagerComponent) {
					IFocusManagerComponent(lastFocus).setFocus();
				} else {
					form.stage.focus = lastFocus;
				}
			}
			lastAction = "ACTIVATE";
		}
	
		/**
		 *  @private
         *  Useful for debugging.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function deactivateHandler(event:Event):void {
			if (!activated) return;
			var target:InteractiveObject = InteractiveObject(event.target);
		}

		/**
		 *  @private
		 *  This gets called when mouse clicks on a focusable object.
         *  We block Flash Player behavior.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function mouseFocusChangeHandler(event:FocusEvent):void {
			if (!activated) return;
			if (event.relatedObject is TextField) {
				return; // pass it on
			}
			event.preventDefault();
		}

		/**
		 *  @private
         *  This function is called when the tab key is hit.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function keyFocusChangeHandler(event:FocusEvent):void {
			if (!activated) return;
			showFocusIndicator = true;
			if ((event.keyCode == Keyboard.TAB || event.keyCode == 0) && !event.isDefaultPrevented()) {
				setFocusToNextObject(event);
				event.preventDefault();
			}
		}

		/**
		 *  @private
         *  Watch for the Enter key.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function keyDownHandler(event:KeyboardEvent):void {
			if (!activated) return;
			if (event.keyCode == Keyboard.TAB) {
				lastAction = "KEY";
				// this makes and orders the focusableCandidates array
				if (calculateCandidates) {
					sortFocusableObjects();
					calculateCandidates = false;
				}
			}
			if (defaultButtonEnabled && event.keyCode == Keyboard.ENTER && defaultButton && defButton.enabled) {
				sendDefaultButtonEvent();
			}
		}

		/**
		 *  @private
		 *  This gets called when the focus changes due to a mouse click.
		 *
         *  <p><strong>Note:</strong> If focus is moving to a TextField, it is not
         *  necessary to call <code>setFocus()</code> on it because the player handles it;
         *  calling <code>setFocus()</code> on a TextField that has scrollable text
		 *  causes the text to auto-scroll to the end, making the
         *  mouse click set the insertion point in the wrong place.</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function mouseDownHandler(event:MouseEvent):void {
			if (!activated) return;
			if (event.isDefaultPrevented()) {
				return;
			}
			var o:InteractiveObject = getTopLevelFocusTarget(InteractiveObject(event.target));
			if (!o) {
				return;
			}
			showFocusIndicator = false;
			// Make sure the containing component gets notified.
			// As the note above says, we don't set focus to a TextField ever
			// because the player already did and took care of where
			// the insertion point is, and we also don't call setfocus
			// on a component that last the last object with focus unless
			// the last action was just to activate the player and didn't
			// involve tabbing or clicking on a component
			if ((o != lastFocus || lastAction == "ACTIVATE") && !(o is TextField)) {
				setFocus(o);
			}
			lastAction = "MOUSEDOWN";
		}


		/**
		 * Gets or sets the current default button.
		 *
		 * <p>The default button is the button on a form that dispatches a
		 * <code>click</code> event when the Enter key is pressed,
         * depending on where focus is at the time.</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get defaultButton():Button {
			return _defaultButton;
		}

		/**
         *  @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set defaultButton(value:Button):void {
			var button:Button = value ? Button(value) : null;
			if (button != _defaultButton) {
				if (_defaultButton) {
					_defaultButton.emphasized = false;
				}
				if (defButton) {
					defButton.emphasized = false;
				}
				_defaultButton = button;
				defButton = button;
				if (button) {
					button.emphasized = true;
				}
			}
		}

		/**
		 *  @private 
		 *  Call this method to make the system
         *  think the Enter key was pressed and the default button was clicked.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function sendDefaultButtonEvent():void {
			defButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function setFocusToNextObject(event:FocusEvent):void {
			if (!hasFocusableObjects()) { return; }
			var o:InteractiveObject = getNextFocusManagerComponent(event.shiftKey);
			if (o) {
				setFocus(o);
			}
		}
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function hasFocusableObjects():Boolean {
			for(var o:Object in focusableObjects) {
				return true;
			}
			return false;
		}

		/**
		 *  Retrieves the interactive object that would receive focus
		 *  if the user pressed the Tab key to navigate to the next object.
		 *  This method retrieves the object that currently has focus
		 *  if there are no other valid objects in the application.
		 *
		 *  @param backward If this parameter is set to <code>true</code>, 
		 *  focus moves in a backward direction, causing this method to retrieve
		 *  the object that would receive focus next if the Shift+Tab key combination
		 *  were pressed. 
		 *
		 *  @return The next component to receive focus.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function getNextFocusManagerComponent(backward:Boolean = false):InteractiveObject {
			if (!hasFocusableObjects()) { return null; }
			if (calculateCandidates) {
				sortFocusableObjects();
				calculateCandidates = false;
			}
			// get the object that has the focus
			var o:DisplayObject = form.stage.focus;
			o = DisplayObject(findFocusManagerComponent(InteractiveObject(o)));
			var g:String = "";
			if (o is IFocusManagerGroup) {
				var tg:IFocusManagerGroup = IFocusManagerGroup(o);
				g = tg.groupName;
			}
			var i:int = getIndexOfFocusedObject(o);
			var bSearchAll:Boolean = false;
			var start:int = i;
			if (i == -1) {
				// we didn't find it
				if (backward) {
					i = focusableCandidates.length;
				}
				bSearchAll = true;
			}
			var j:int = getIndexOfNextObject(i, backward, bSearchAll, g);
			return findFocusManagerComponent(focusableCandidates[j]);
		}
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function getIndexOfFocusedObject(o:DisplayObject):int {
			var n:int = focusableCandidates.length;
			var i:int = 0;
			for (i = 0; i < n; i++) {
				
				if (focusableCandidates[i] == o) {
					return i;
				}
			}
			return -1;
		}

		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function getIndexOfNextObject(i:int, shiftKey:Boolean, bSearchAll:Boolean, groupName:String):int {
			var n:int = focusableCandidates.length;
			var start:int = i;
			while (true) {
				if (shiftKey) {
					i--;
				} else {
					i++;
				}
				if (bSearchAll) {
					if (shiftKey && i < 0) {
						break;
					}
					if (!shiftKey && i == n) {
						break;
					}
				} else {
					i = (i + n) % n;
					// came around and found the original
					if (start == i) {
						break;
					}
				}
				if (isValidFocusCandidate(focusableCandidates[i], groupName)) {
					var o:DisplayObject = DisplayObject(findFocusManagerComponent(focusableCandidates[i]));		
					if (o is IFocusManagerGroup) {
						// look around to see if there's a selected member in the tabgroup
						// otherwise use the first one we found.
						var tg1:IFocusManagerGroup = IFocusManagerGroup(o);
						for (var j:int = 0; j < focusableCandidates.length; j++) {
							var obj:DisplayObject = focusableCandidates[j];
							if (obj is IFocusManagerGroup) {
								var tg2:IFocusManagerGroup = IFocusManagerGroup(obj);
								if (tg2.groupName == tg1.groupName && tg2.selected) {
									i = j;
									break;
								}
							}
						}
					}
					return i;
				}
			}
			return i;
		}

		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function sortFocusableObjects():void {
			focusableCandidates = [];
			for (var o:Object in focusableObjects) {
				var c:InteractiveObject = InteractiveObject(o);
				if (c.tabIndex && !isNaN(Number(c.tabIndex)) && c.tabIndex > 0) {
					sortFocusableObjectsTabIndex();
					return;
				}
				focusableCandidates.push(c);
			}
			focusableCandidates.sort(sortByDepth);
		}

		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function sortFocusableObjectsTabIndex():void {
			focusableCandidates = [];
			for (var o:Object in focusableObjects) {
				var c:InteractiveObject = InteractiveObject(o);
				if (c.tabIndex && !isNaN(Number(c.tabIndex))) {
					// if we get here, it is a candidate
					focusableCandidates.push(c);
				}
			}
			focusableCandidates.sort(sortByTabIndex);
		}

		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function sortByDepth(aa:InteractiveObject, bb:InteractiveObject):Number {
			var val1:String = "";
			var val2:String = "";
			var index:int;
			var tmp:String;
			var tmp2:String;
			var zeros:String = "0000";
			var a:DisplayObject = DisplayObject(aa);
			var b:DisplayObject = DisplayObject(bb);
			try {
				while (a != DisplayObject(form) && a.parent) {
					index = getChildIndex(a.parent, a);
					tmp = index.toString(16);
					if (tmp.length < 4) {
						tmp2 = zeros.substring(0, 4 - tmp.length) + tmp;
					}
					val1 = tmp2 + val1;
					a = a.parent;
				}
			} catch (se1:SecurityError) {
			}
			try {
				while (b != DisplayObject(form) && b.parent) {
					index = getChildIndex(b.parent, b);
					tmp = index.toString(16);
					if (tmp.length < 4) {
						tmp2 = zeros.substring(0, 4 - tmp.length) + tmp;
					}
					val2 = tmp2 + val2;
					b = b.parent;
				}
			} catch (se2:SecurityError) {
			}
			return val1 > val2 ? 1 : val1 < val2 ? -1 : 0;
		}

		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function getChildIndex(parent:DisplayObjectContainer, child:DisplayObject):int {
			return parent.getChildIndex(child);
		}

		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function sortByTabIndex(a:InteractiveObject, b:InteractiveObject):int {
			return (a.tabIndex > b.tabIndex ? 1 : a.tabIndex < b.tabIndex ? -1 : sortByDepth(a, b));
		}


		/**
		 *  @copy fl.managers.IFocusManager#defaultButtonEnabled
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get defaultButtonEnabled():Boolean {
			return _defaultButtonEnabled;
		}
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set defaultButtonEnabled(value:Boolean):void {
			_defaultButtonEnabled = value;
		}

		/**
         *  Gets the next unique tab index to use in this tab loop.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get nextTabIndex():int {
			return 0;
		}
		
		/**
         *  Gets or sets a value that indicates whether a component that has focus should be marked with a visual indicator of focus.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get showFocusIndicator():Boolean {
			return _showFocusIndicator;
		}
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set showFocusIndicator(value:Boolean):void {
			_showFocusIndicator = value;
		}

		/**
         * Base DisplayObjectContainer for the IFocusManager, usually the stage.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function get form():DisplayObjectContainer {
			return _form;
		}
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set form(value:DisplayObjectContainer):void {
			_form = value;
		}


		/**
		 *  Gets the interactive object that currently has focus.
		 *  Adobe recommends calling this method instead of using the Stage object 
		 *  because this method indicates which component has focus.
		 *  The Stage might return a subcomponent in that component.
		 *
         *  @return The interactive object that currently has focus.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function getFocus():InteractiveObject {
			var o:InteractiveObject = form.stage.focus;
			return findFocusManagerComponent(o);
		}
	
		/**
		 *  Sets focus on an IFocusManagerComponent component. This method does
		 *  not check for component visibility, enabled state, or other conditions.
		 *
		 *  @param component An object that can receive focus.
		 * 
		 *  @internal Do you guys have a code snippet/test case/sample you could give us for this? (rberry(at)adobe.com)
         *  Adobe: [LM] {StyleManager.setFocus(myBtn);}
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function setFocus(component:InteractiveObject):void {
			if(component is IFocusManagerComponent) {
				IFocusManagerComponent(component).setFocus();
			} else {
				form.stage.focus = component;
			}
		}
	
		/**
		 *  Sets the <code>showFocusIndicator</code> value to <code>true</code>
         *  and draws the visual focus indicator on the object with focus, if any.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function showFocus():void {
		}
	
		/**
		 *  Sets the <code>showFocusIndicator</code> value to <code>false</code>
         *  and removes the visual focus indicator from the object that has focus, if any.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function hideFocus():void {
		}
	
		/**
		 *  Retrieves the interactive object that contains the given object, if any.
		 *  The player can set focus to a subcomponent of a Flash component;
		 *  this method determines which interactive object has focus from
		 *  the component perspective.
		 *
		 *  @param component An object that can have player-level focus.
		 *
		 *  @return The object containing the <code>component</code> or, if one is
		 *  not found, the <code>component</code> itself.
		 * 
		 * @internal Description needs explanation of relationship between interactive object (param and return type) and
		 * FocusManagerComponent, which the function claims to be finding. Do you guys have a code snippet/test 
		 * case/sample you could give us for this? (rberry(at)adobe.com)
         * Metaliq: Anybody?
		 * Adobe: [LM] Changed description to InteractiveObject.  This was changed to InteractiveObject because the FocusManager supports native flash objects too.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function findFocusManagerComponent(component:InteractiveObject):InteractiveObject {
			var p:InteractiveObject = component;
			try {
				while (component) {
					if (component is IFocusManagerComponent && IFocusManagerComponent(component).focusEnabled) {
						return component;
					}
					component = component.parent;
				}
			} catch (se:SecurityError) {
			}
			// tab was set somewhere else
			return p;
		}
	
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function getTopLevelFocusTarget(o:InteractiveObject):InteractiveObject {
			try {
				while (o != InteractiveObject(form)) {
					if (o is IFocusManagerComponent &&
						IFocusManagerComponent(o).focusEnabled &&
						IFocusManagerComponent(o).mouseFocusEnabled &&
						UIComponent(o).enabled) {
						return o;
					}
					o = o.parent;
					if (o == null) {
						break;
					}
				}
			} catch (se:SecurityError) {
			}
			return null;
		}
	}
}
