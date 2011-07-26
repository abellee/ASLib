package com.iabel.controls
{
	import com.iabel.core.UIComponent;
	import com.iabel.system.System;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	public class ALLabel extends UIComponent
	{
		protected var _textField:TextField;
		protected var _label:String = null;
		protected var _selectable:Boolean = false;
		protected var _wordWrap:Boolean = false;
		protected var _htmlText:String = null;
		public function ALLabel(str:String)
		{
			super();
			
			this.label = str;
			init();
		}
		
		public function get textWidth():Number
		{
			if(!_textField) return 0;
			return _textField.textWidth;
		}
		
		public function get textHeight():Number
		{
			if(!_textField) return 0;
			return _textField.textHeight;
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

		public function get wordWrap():Boolean
		{
			return _wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			_wordWrap = value;
			callLater(draw);
		}

		public function get selectable():Boolean
		{
			return _selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			callLater(draw);
		}

		private function init():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			var obj:TextFormat = System.getStyle("textFormat") as TextFormat;
			if(obj) this.txtFormat = obj;
		}

		override public function set txtFormat(value:TextFormat):void
		{
			_txtFormat = value;
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
		
		override protected function callLater(func:Function):void
		{
			super.callLater(func);
		}
		
		override protected function draw():void
		{
			super.draw();
			if(!_textField) _textField = new TextField();
			if(_txtFormat) _textField.defaultTextFormat = _txtFormat;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			if(_label) _textField.text = _label;
			if(_htmlText) _textField.htmlText = _htmlText;
			_textField.selectable = _selectable;
			_textField.wordWrap = _wordWrap;
			_textField.mouseEnabled = _selectable;
			_textField.mouseWheelEnabled = false;
			if(!this.width || !this.height){
				
				this.width = _textField.textWidth;
				this.height = _textField.textHeight;
				
			}
			if (_wordWrap) _textField.width = this.width;
				
			_textField.x = (this.width - _textField.textWidth) / 2;
			_textField.y = (this.height - _textField.textHeight) / 2;
			
			if(!this.contains(_textField)) addChild(_textField);
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(_textField && this.contains(_textField)){
				
				_textField.defaultTextFormat = null;
				removeChild(_textField);
				_textField = null;
				
			}
			_label = null;
			_htmlText = null;
		}

	}
}