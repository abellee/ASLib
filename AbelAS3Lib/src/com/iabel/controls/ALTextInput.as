package com.iabel.controls
{
	import com.iabel.core.UIComponent;
	import com.iabel.data.Collections.Padding;
	import com.iabel.system.System;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class ALTextInput extends UIComponent
	{
		protected var _textField:TextField;
		protected var _padding:Padding;
		protected var _background:DisplayObject;
		protected var _displayAsPassword:Boolean = false;
		protected var _defaultText:String = null;
		protected var _defaultTextFormat:TextFormat = null;
		public function ALTextInput()
		{
			super();
			init();
		}
		
		private function init():void
		{
			var obj:TextFormat = System.getStyle("textFormat") as TextFormat;
			if(obj) this.txtFormat = obj;
			else this.txtFormat = new TextFormat(null, 12, 0x000000);
			this.padding = new Padding();
			this.width = 100;
			this.height = 24;
		}
		
		override public function set txtFormat(value:TextFormat):void
		{
			_txtFormat = value;
			callLater(draw);
		}
		
		override protected function draw():void
		{
			super.draw();
			if(_background){
				addChildAt(_background, 0);
				this.width = _background.width;
				this.height = _background.height;
			}
			if(!_textField) _textField = new TextField();
			_textField.type = TextFieldType.INPUT;
			_textField.displayAsPassword = _displayAsPassword;
			_textField.mouseWheelEnabled = false;
			_textField.multiline = false;
			_textField.wordWrap = false;
			_textField.width = this.width - this.padding.paddingLeft - this.padding.paddingRight;
			_textField.height = this.height - this.padding.paddingTop - this.padding.paddingBottom;
			_textField.x = (this.width - _textField.width) / 2;
			_textField.y = (this.height - _textField.height) / 2;
			if(_defaultText){
				
				initDefaultTextFormat();
				_textField.defaultTextFormat = _defaultTextFormat;
				_textField.text = _defaultText;
				addListener();
				
			}
			if(!this.contains(_textField)) addChild(_textField);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			
			_textField.defaultTextFormat = null;
			_textField = null;
			if(_padding) _padding = null;
			if(_background && (_background is Bitmap)) (_background as Bitmap).bitmapData.dispose();
			_background = null;
			_defaultText = null;
			_defaultTextFormat = null;
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
		
		public function get padding():Padding
		{
			return _padding;
		}

		public function set padding(value:Padding):void
		{
			_padding = value;
			callLater(draw);
		}
		

		public function get background():DisplayObject
		{
			return _background;
		}

		public function set background(value:DisplayObject):void
		{
			_background = value;
			callLater(draw);
		}

		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}

		public function set displayAsPassword(value:Boolean):void
		{
			_displayAsPassword = value;
			callLater(draw);
		}

		public function get defaultText():String
		{
			return _defaultText;
		}

		public function set defaultText(value:String):void
		{
			_defaultText = value;
			callLater(draw);
		}

		public function get defaultTextFormat():TextFormat
		{
			return _defaultTextFormat;
		}

		public function set defaultTextFormat(value:TextFormat):void
		{
			_defaultTextFormat = value;
			callLater(draw);
		}


	}
}