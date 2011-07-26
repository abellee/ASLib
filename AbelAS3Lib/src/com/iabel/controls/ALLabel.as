package com.iabel.controls
{
	import com.iabel.core.InvalidationType;
	import com.iabel.core.UIComponent;
	import com.iabel.system.CoreSystem;
	
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
			this.label = str;
			init();
			super();
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
			if(_htmlText == value) return;
			_label = null;
			_htmlText = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get wordWrap():Boolean
		{
			return _wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			if(_wordWrap == value) return;
			_wordWrap = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		public function get selectable():Boolean
		{
			return _selectable;
		}

		public function set selectable(value:Boolean):void
		{
			if(_selectable == value) return;
			_selectable = value;
			invalidation(InvalidationType.STYLE, drawStyle);
		}

		private function init():void
		{
			this.width = 50;
			this.height = 22;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			var obj:TextFormat = CoreSystem.getStyle("textFormat") as TextFormat;
			if(obj) this.txtFormat = obj;
		}

		override public function set txtFormat(value:TextFormat):void
		{
			if(_txtFormat == value) return;
			_txtFormat = value;
			invalidation(InvalidationType.STYLE, drawStyle);
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
			invalidation(InvalidationType.STYLE, drawStyle);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.ALL))
			{
				if(!_textField) _textField = new TextField();
				if(_txtFormat) _textField.defaultTextFormat = _txtFormat;
				_textField.autoSize = TextFieldAutoSize.LEFT;
				if(_label) _textField.text = _label;
				if(_htmlText) _textField.htmlText = _htmlText;
				_textField.selectable = _selectable;
				_textField.wordWrap = _wordWrap;
				_textField.mouseEnabled = _selectable;
				_textField.mouseWheelEnabled = false;
				if(!this.contains(_textField)) addChild(_textField);
				super.draw();
			}
			if(isInvalid(InvalidationType.STYLE)) drawStyle();
			if(isInvalid(InvalidationType.SIZE)) resize();
		}
		
		override protected function drawStyle():void
		{
			if(_textField){
				if(_label) _textField.text = _label;
				if(_htmlText) _textField.htmlText = _htmlText;
				_textField.selectable = _selectable;
				_textField.wordWrap = _wordWrap;
				_textField.mouseEnabled = _selectable;
			}
		}
		
		override protected function resize():void
		{
			if(_textField){
				if(this.width <= 0){
					this.width = _textField.textWidth;
				}
				if(this.height <= 0){
					this.height = _textField.textHeight;
				}
				if (_wordWrap) _textField.width = this.width;
				trace(this.width, this.height);
				_textField.x = (this.width - _textField.textWidth) / 2;
				_textField.y = (this.height - _textField.textHeight) / 2;
			}
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			_textField = null;
			_label = null;
			_htmlText = null;
		}

	}
}