package com.iabel.controls
{
	import com.iabel.core.InvalidationType;
	import com.iabel.core.UIComponent;
	import com.iabel.event.ALEvent;
	import com.iabel.utils.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ALButton extends UIComponent
	{
		protected var _outSkin:DisplayObject;
		protected var _overSkin:DisplayObject;
		protected var _downSkin:DisplayObject;
		protected var _disabledSkin:DisplayObject;
		protected var _selectedSkin:DisplayObject;
		
		protected var _toggle:Boolean = false;
		protected var _enable:Boolean = true;
		
		protected var _alLabel:ALLabel;
		
		protected var _label:String = "Button";
		protected var _currentState:String = ALButtonState.OUT;
		protected var _htmlText:String = null;
		
		public function ALButton(outSkin:DisplayObject, overSkin:DisplayObject, downSkin:DisplayObject, disabledSkin:DisplayObject, selectedSkin:DisplayObject)
		{
			this.outSkin = outSkin;
			this.overSkin = overSkin;
			this.downSkin = downSkin;
			this.disabledSkin = disabledSkin;
			this.selectedSkin = selectedSkin;
			mouseChildren = false;
			super();
		}

		public function get htmlText():String
		{
			return _htmlText;
		}

		public function set htmlText(value:String):void
		{
			if(_htmlText == value) return;
			_label = null;
			_htmlText = value;
			invalidation(InvalidationType.SIZE, resize);
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			if(_label == value) return;
			_htmlText = null;
			_label = value;
			invalidation(InvalidationType.SIZE, resize);
		}

		public function get currentState():String
		{
			return _currentState;
		}

		public function set currentState(value:String):void
		{
			if(_currentState == value) return;
			_currentState = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get toggle():Boolean
		{
			return _toggle;
		}

		public function set toggle(value:Boolean):void
		{
			if(_toggle == value) return;
			_toggle = value;
		}

		public function get selectedSkin():DisplayObject
		{
			return _selectedSkin;
		}

		public function set selectedSkin(value:DisplayObject):void
		{
			if(_selectedSkin == value) return;
			_selectedSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get disabledSkin():DisplayObject
		{
			return _disabledSkin;
		}

		public function set disabledSkin(value:DisplayObject):void
		{
			if(_disabledSkin == value) return;
			_disabledSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get downSkin():DisplayObject
		{
			return _downSkin;
		}

		public function set downSkin(value:DisplayObject):void
		{
			if(!value) throw new ArgumentError("downSkin can not be null!");
			if(_downSkin == value) return;
			_downSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get overSkin():DisplayObject
		{
			return _overSkin;
		}

		public function set overSkin(value:DisplayObject):void
		{
			if(!value) throw new ArgumentError("overSkin can not be null!");
			if(_overSkin == value) return;
			_overSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get outSkin():DisplayObject
		{
			return _outSkin;
		}

		public function set outSkin(value:DisplayObject):void
		{
			if(!value) throw new ArgumentError("outSkin can not be null!");
			if(_outSkin == value) return;
			_outSkin = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void
		{
			if(_enable == value) return;
			_enable = value;
			if(!_enable){
				_currentState = ALButtonState.DISABLED;
			}else{
				_currentState = ALButtonState.OUT;
			}
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.ALL))
			{
				drawDefaultSkin();
				addListener();
				initLabel();
				super.draw();
			}
			if(isInvalid(InvalidationType.STYLE)){
				drawDefaultSkin();
				drawStyle();
			}
			if(isInvalid(InvalidationType.SIZE)) resize();
		}
		
		override protected function resize():void
		{
			if(_outSkin){
				_outSkin.width = this.width;
				_outSkin.height = this.height;
			}
			if(_overSkin){
				_overSkin.width = this.width;
				_overSkin.height = this.height;
			}
			if(_downSkin){
				_downSkin.width = this.width;
				_downSkin.height = this.height;
			}
			if(_disabledSkin){
				_disabledSkin.width = this.width;
				_disabledSkin.height = this.height;
			}
			if(_selectedSkin){
				_selectedSkin.width = this.width;
				_selectedSkin.height = this.height;
			}
		}
		
		protected function initLabel():void
		{
			if((!_label || _label == "") && (!_htmlText || _htmlText == ""))
			{
				if(_alLabel){
					if(this.contains(_alLabel)){
						this.removeChild(_alLabel);
					}
					_alLabel = null;
				}
				return;
			}
			if(!_alLabel) _alLabel = new ALLabel("");
			if(_label) _alLabel.label = _label;
			if(_htmlText) _alLabel.htmlText = _htmlText;
			_alLabel.width = this.width;
			_alLabel.height = this.height;
			if(!this.contains(_alLabel)) addChild(_alLabel);
			_alLabel.x = 0;
			_alLabel.y = 0;
		}
		
		protected function drawDefaultSkin():void
		{
			if(_outSkin){
				if(!this.contains(_outSkin)) addChildAt(_outSkin, 0);
				_outSkin.visible = false;
			}
			if(_overSkin){
				if(!this.contains(_overSkin)) addChildAt(_overSkin, 0);
				_overSkin.visible = false;
			}
			if(_downSkin){
				if(!this.contains(_downSkin)) addChildAt(_downSkin, 0);
				_downSkin.visible = false;
			}
			if(_disabledSkin){
				if(!this.contains(_disabledSkin)) addChildAt(_disabledSkin, 0);
				_disabledSkin.visible = false;
			}
			if(_selectedSkin){
				if(!this.contains(_selectedSkin)) addChildAt(_selectedSkin, 0);
				_selectedSkin.visible = false;
			}
		}
		
		private function addListener():void
		{
			if(!this.hasEventListener(MouseEvent.MOUSE_OVER)) this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			if(!this.hasEventListener(MouseEvent.MOUSE_OUT)) this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			if(!this.hasEventListener(MouseEvent.MOUSE_DOWN)) this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if(!this.hasEventListener(MouseEvent.MOUSE_UP)) this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function removeListener():void
		{
			if(this.hasEventListener(MouseEvent.MOUSE_OVER)) this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			if(this.hasEventListener(MouseEvent.MOUSE_OUT)) this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			if(this.hasEventListener(MouseEvent.MOUSE_DOWN)) this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if(this.hasEventListener(MouseEvent.MOUSE_UP)) this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			_currentState = ALButtonState.OVER;
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			_currentState = ALButtonState.OUT;
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(this.toggle) _currentState = ALButtonState.SELECTED;
			else _currentState = ALButtonState.DOWN;
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_currentState = ALButtonState.UP;
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		override protected function drawStyle():void
		{
			switch(_currentState){
				
				case ALButtonState.OVER:
					if(_overSkin){
						addChildAt(_overSkin, 0);
						_overSkin.visible = true;
					}
					break;
				case ALButtonState.OUT:
					if(_outSkin){
						addChildAt(_outSkin, 0);
						_outSkin.visible = true;
					}
					addListener();
					break;
				case ALButtonState.DOWN:
					if(_downSkin){
						addChildAt(_downSkin, 0);
						_downSkin.visible = true;
					}
					break;
				case ALButtonState.UP:
					if(_overSkin){
						addChildAt(_overSkin, 0);
						_overSkin.visible = true;
					}
					break;
				case ALButtonState.SELECTED:
					if(_selectedSkin){
						addChildAt(_selectedSkin, 0);
						_selectedSkin.visible = true;
					}
					removeListener();
					break;
				case ALButtonState.DISABLED:
					if(_disabledSkin){
						addChildAt(_disabledSkin, 0);
						_disabledSkin.visible = true;
					}
					removeListener();
					break;
				default:
					if(_outSkin){
						addChildAt(_outSkin, 0);
						_outSkin.visible = true;
					}
					addListener();
					break;
				
			}
		}

		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			_outSkin = null;
			_overSkin = null;
			_downSkin = null;
			_disabledSkin = null;
			_selectedSkin = null;
			_currentState = null;
			
			_alLabel = null;
			_label = null;
			_currentState = null;
			_htmlText = null;
		}

	}
}