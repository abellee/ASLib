package com.iabel.controls
{
	import com.iabel.core.UIComponent;
	
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
		protected var _enable:Boolean = false;
		
		protected var _alLabel:ALLabel;
		
		protected var _label:String = "Button";
		protected var _currentState:String = ALButtonState.OUT;
		protected var _htmlText:String = null;
		
		public function ALButton(outSkin:DisplayObject, overSkin:DisplayObject, downSkin:DisplayObject, disabledSkin:DisplayObject, selectedSkin:DisplayObject)
		{
			super();
			
			this.outSkin = outSkin;
			this.overSkin = overSkin;
			this.downSkin = downSkin;
			this.disabledSkin = disabledSkin;
			this.selectedSkin = selectedSkin;
		}

		public function get htmlText():String
		{
			return _htmlText;
		}

		public function set htmlText(value:String):void
		{
			_label = null;
			_htmlText = value;
			callLater(draw);
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_htmlText = null;
			_label = value;
			callLater(draw);
		}

		public function get currentState():String
		{
			return _currentState;
		}

		public function set currentState(value:String):void
		{
			_currentState = value;
			callLater(resetCurrentState);
		}

		public function get toggle():Boolean
		{
			return _toggle;
		}

		public function set toggle(value:Boolean):void
		{
			_toggle = value;
			
			if(!_toggle){
				draw();
			}else{
				_currentState = ALButtonState.SELECTED;
			}
		}

		public function get selectedSkin():DisplayObject
		{
			return _selectedSkin;
		}

		public function set selectedSkin(value:DisplayObject):void
		{
			_selectedSkin = value;
			callLater(draw);
		}

		public function get disabledSkin():DisplayObject
		{
			return _disabledSkin;
		}

		public function set disabledSkin(value:DisplayObject):void
		{
			_disabledSkin = value;
			callLater(draw);
		}

		public function get downSkin():DisplayObject
		{
			return _downSkin;
		}

		public function set downSkin(value:DisplayObject):void
		{
			_downSkin = value;
			callLater(draw);
		}

		public function get overSkin():DisplayObject
		{
			return _overSkin;
		}

		public function set overSkin(value:DisplayObject):void
		{
			_overSkin = value;
			callLater(draw);
		}

		public function get outSkin():DisplayObject
		{
			return _outSkin;
		}

		public function set outSkin(value:DisplayObject):void
		{
			_outSkin = value;
			callLater(draw);
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void
		{
			_enable = value;
			if(!_enable){
				_currentState = ALButtonState.DISABLED;
			}else{
				draw();
			}
			callLater(resetCurrentState);
		}
		
		override protected function draw():void
		{
			super.draw();
			drawDefaultSkin();
			mouseChildren = false;
			_currentState = ALButtonState.OUT;
			resetCurrentState();
			
			if(!_alLabel) _alLabel = new ALLabel(null);
			if(_label) _alLabel.label = _label;
			if(_htmlText) _alLabel.htmlText = _htmlText;
			_alLabel.width = this.width;
			_alLabel.height = this.height;
			addChild(_alLabel);
			_alLabel.x = 0;
			_alLabel.y = 0;
			
			addListener();
		}
		
		override protected function callLater(func:Function):void
		{
			super.callLater(func);
		}
		
		private function drawDefaultSkin():void
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
			callLater(resetCurrentState);
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			_currentState = ALButtonState.OUT;
			callLater(resetCurrentState);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(this.toggle) _currentState = ALButtonState.SELECTED;
			else _currentState = ALButtonState.DOWN;
			callLater(resetCurrentState);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_currentState = ALButtonState.UP;
			callLater(resetCurrentState);
		}
		
		protected function resetCurrentState():void
		{
			drawDefaultSkin();
			switch(_currentState){
				
				case ALButtonState.OVER:
					if(_overSkin){
						if(!this.contains(_overSkin)) addChildAt(_overSkin, 0);
						_overSkin.visible = true;
					}
					break;
				case ALButtonState.OUT:
					if(_outSkin){
						if(!this.contains(_outSkin)) addChildAt(_outSkin, 0);
						_outSkin.visible = true;
					}
					break;
				case ALButtonState.DOWN:
					if(_downSkin){
						if(!this.contains(_downSkin)) addChildAt(_downSkin, 0);
						_downSkin.visible = true;
					}
					break;
				case ALButtonState.UP:
					if(_overSkin){
						if(!this.contains(_overSkin)) addChildAt(_overSkin, 0);
						_overSkin.visible = true;
					}
					break;
				case ALButtonState.SELECTED:
					if(_selectedSkin){
						if(!this.contains(_selectedSkin)) addChildAt(_selectedSkin, 0);
						_selectedSkin.visible = true;
					}
					removeListener();
					break;
				case ALButtonState.DISABLED:
					if(_disabledSkin){
						if(!this.contains(_disabledSkin)) addChildAt(_disabledSkin, 0);
						_disabledSkin.visible = true;
					}
					removeListener();
					break;
				default:
					if(_outSkin){
						if(!this.contains(_outSkin)) addChildAt(_outSkin, 0);
						_outSkin.visible = true;
					}
					break;
				
			}
		}

		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(_outSkin && (_outSkin is Bitmap)) (_outSkin as Bitmap).bitmapData.dispose();
			if(_overSkin && (_overSkin is Bitmap)) (_overSkin as Bitmap).bitmapData.dispose();
			if(_downSkin && (_downSkin is Bitmap)) (_downSkin as Bitmap).bitmapData.dispose();
			if(_disabledSkin && (_disabledSkin is Bitmap)) (_disabledSkin as Bitmap).bitmapData.dispose();
			if(_selectedSkin && (_selectedSkin is Bitmap)) (_selectedSkin as Bitmap).bitmapData.dispose();
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