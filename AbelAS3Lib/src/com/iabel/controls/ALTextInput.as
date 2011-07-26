package com.iabel.controls
{
	import com.iabel.core.InvalidationType;
	import com.iabel.core.UIComponent;
	import com.iabel.data.Collections.BackgroundStyle;
	import com.iabel.data.Collections.BorderStyle;
	import com.iabel.data.Collections.Padding;
	import com.iabel.data.Collections.RectRoundRaduis;
	import com.iabel.data.Collections.Size;
	import com.iabel.system.CoreSystem;
	import com.iabel.utils.ScaleBitmap;
	import com.iabel.widget.StyleWidget;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class ALTextInput extends UIComponent
	{
		protected var _textField:TextField;
		
		protected var _padding:Padding;
		
		protected var _roundRect:RectRoundRaduis;
		
		protected var _background:DisplayObject;
		
		protected var _backgroundStyle:BackgroundStyle;
		protected var _borderStyle:BorderStyle;
		
		protected var _displayAsPassword:Boolean = false;
		
		protected var _defaultText:String = null;
		
		protected var _defaultTextFormat:TextFormat = null;
		public function ALTextInput()
		{
			init();
			super();
		}
		
		private function init():void
		{
			_roundRect = new RectRoundRaduis();
			_backgroundStyle = new BackgroundStyle();
			_borderStyle = new BorderStyle(false, 1.0, 1);
			var obj:TextFormat = CoreSystem.getStyle("textFormat") as TextFormat;
			if(obj) this.txtFormat = obj;
			else this.txtFormat = new TextFormat(null, 12, 0x000000);
			this.padding = new Padding();
			this.width = 100;
			this.height = 24;
		}
		
		override public function set txtFormat(value:TextFormat):void
		{
			if(_txtFormat == value) return;
			_txtFormat = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		override protected function resize():void
		{
			renderBackground();
			if(_textField){
				_textField.width = this.width - this.padding.paddingLeft - this.padding.paddingRight;
				_textField.height = this.height - this.padding.paddingTop - this.padding.paddingBottom;
				_textField.x = (this.width - _textField.width) / 2;
				_textField.y = (this.height - _textField.height) / 2;
			}
		}
		
		override protected function drawStyle():void
		{
			if(_textField){
				_textField.displayAsPassword = _displayAsPassword;
				if(!isEmpty() && _txtFormat){
					_textField.defaultTextFormat = _txtFormat;
					_textField.text = _textField.text;
				}
				if(_defaultText){
					
					if(this.isEmpty()){
						initDefaultTextFormat();
						_textField.defaultTextFormat = _defaultTextFormat;
						_textField.text = _defaultText;
					}
					addListener();
					
				}
			}
			if(_background)
				renderBackground();
			else
				drawBackground();
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.ALL))
			{
				if(!_textField){
					_textField = new TextField();
					_textField.type = TextFieldType.INPUT;
					_textField.mouseWheelEnabled = false;
					_textField.multiline = false;
					_textField.wordWrap = false;
				}
				if(!this.contains(_textField)) addChild(_textField);
				super.draw();
			}
			if(isInvalid(InvalidationType.STYLE)) drawStyle();
			if(isInvalid(InvalidationType.SIZE)) resize();
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			if(_textField){
				if(_textField.hasEventListener(FocusEvent.FOCUS_IN)) _textField.removeEventListener(FocusEvent.FOCUS_IN, textField_FocusHandler);
				if(_textField.hasEventListener(FocusEvent.FOCUS_OUT)) _textField.removeEventListener(FocusEvent.FOCUS_OUT, textField_FocusHandler);
				_textField = null;
			}
			if(_padding) _padding = null;
			if(_background) _background = null;
			if(_defaultText) _defaultText = null;
			if(_defaultTextFormat) _defaultTextFormat = null;
			if(_roundRect){
				_roundRect.dealloc();
				_roundRect = null;
			}
			if(_backgroundStyle){
				_backgroundStyle.dealloc();
				_backgroundStyle = null;
			}
			if(_borderStyle){
				_borderStyle.dealloc();
				_borderStyle = null;
			}
		}
		
		private function renderBackground():void
		{
			//trace(this.width, this.height);
			if(_background){
				addChildAt(_background, 0);
				_background.alpha = _backgroundStyle.backgroundAlpha;
				_background.width = this.width;
				_background.height = this.height;
			}else
				drawBackground();
		}
		
		private function drawBackground():void
		{
			if(this.numChildren >= 2){
				var child:DisplayObject = this.getChildAt(0);
				if(child){
					if(child is ScaleBitmap) (child as ScaleBitmap).dealloc();
					else if(child is Bitmap) (child as Bitmap).bitmapData.dispose();
					child = null;
					this.removeChild(child);
				}
			}
			this.graphics.clear();
			if(!isNaN(_backgroundStyle.backgroundColor))
				StyleWidget.drawRoundRectComplex(this, new Point(0, 0), new Size(this.width, this.height), _borderStyle, _backgroundStyle, _roundRect);
			
			
		}
		
		private function addListener():void
		{
			if(_textField){
				
				if(!_textField.hasEventListener(FocusEvent.FOCUS_IN)) _textField.addEventListener(FocusEvent.FOCUS_IN, textField_FocusHandler);
				if(!_textField.hasEventListener(FocusEvent.FOCUS_OUT)) _textField.addEventListener(FocusEvent.FOCUS_OUT, textField_FocusHandler);
				
			}
		}
		
		private function textField_FocusHandler(event:FocusEvent):void
		{
			var str:String = _textField.text.replace(/\s+/g, "");
			switch(event.type){
				
				case FocusEvent.FOCUS_IN:
					if(_textField.text == _defaultText){
						if(_txtFormat) _textField.defaultTextFormat = _txtFormat;
						_textField.text = "";
					}
					break;
				case FocusEvent.FOCUS_OUT:
					if(_textField.text == ""){
						initDefaultTextFormat();
						_textField.defaultTextFormat = _defaultTextFormat;
						_textField.text = _defaultText;
					}
					break;
				
			}
		}
		
		private function initDefaultTextFormat():void
		{
			if(!_defaultTextFormat){
				_defaultTextFormat = new TextFormat();
				_defaultTextFormat.size = 12;
				_defaultTextFormat.color = 0xd6d6d6;
			}
		}
		
		public function isEmpty():Boolean
		{
			var str:String = _textField.text.replace(/\s+/g, "");
			return (str == "" || str == this._defaultText);
		}
		
		public function get padding():Padding
		{
			return _padding;
		}

		public function set padding(value:Padding):void
		{
			if(_padding && _padding.equals(value)) return;
			_padding = value;
			if(_textField) invalidation(InvalidationType.SIZE, resize);
			else invalidation(InvalidationType.ALL, draw);
		}

		public function get background():DisplayObject
		{
			return _background;
		}

		public function set background(value:DisplayObject):void
		{
			if(_background == value) return;
			_background = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		public function get text():String
		{
			if(!_textField) return null;
			return _textField.text;
		}
		
		public function set text(str:String):void
		{
			_textField.text = str;
		}

		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}

		public function set displayAsPassword(value:Boolean):void
		{
			if(_displayAsPassword == value) return;
			_displayAsPassword = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get defaultText():String
		{
			return _defaultText;
		}

		public function set defaultText(value:String):void
		{
			if(_defaultText == value) return;
			_defaultText = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get defaultTextFormat():TextFormat
		{
			return _defaultTextFormat;
		}

		public function set defaultTextFormat(value:TextFormat):void
		{
			if(_defaultTextFormat == value) return;
			_defaultTextFormat = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get backgroundColor():Number
		{
			return _backgroundStyle.backgroundColor;
		}

		public function set backgroundColor(value:Number):void
		{
			if(!isNaN(_backgroundStyle.backgroundColor) && _backgroundStyle.backgroundColor == value) return;
			_backgroundStyle.backgroundColor = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get backgroundAlpha():Number
		{
			return _backgroundStyle.backgroundAlpha;
		}

		public function set backgroundAlpha(value:Number):void
		{
			if(!isNaN(_backgroundStyle.backgroundAlpha) && _backgroundStyle.backgroundAlpha == value) return;
			_backgroundStyle.backgroundAlpha = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get roundRect():RectRoundRaduis
		{
			return _roundRect;
		}

		public function set roundRect(value:RectRoundRaduis):void
		{
			if(_roundRect.equals(value)) return;
			_roundRect = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}


	}
}