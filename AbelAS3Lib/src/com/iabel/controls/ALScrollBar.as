package com.iabel.controls
{
	import com.iabel.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class ALScrollBar extends UIComponent
	{
		protected var _scrollBar:ALButton;
		protected var _view:DisplayObject;
		protected var _maxScrollPosition:Number = 0;
		protected var _lineScrollSize:Number = 0;
		protected var _scrollPosition:Number = 0;
		protected var _scrollRect:Rectangle = null;
		public function ALScrollBar()
		{
			super();
		}

		public function get view():DisplayObject
		{
			return _view;
		}

		public function set view(value:DisplayObject):void
		{
			_view = value;
		}

		public function get maxScrollPosition():Number
		{
			return _maxScrollPosition;
		}

		public function set maxScrollPosition(value:Number):void
		{
			_maxScrollPosition = value;
		}

		public function get scrollRect():Rectangle
		{
			return _scrollRect;
		}

		public function set scrollRect(value:Rectangle):void
		{
			_scrollRect = value;
		}

		public function get lineScrollSize():Number
		{
			return _lineScrollSize;
		}

		public function set lineScrollSize(value:Number):void
		{
			_lineScrollSize = value;
		}

		public function get scrollPosition():Number
		{
			return _scrollPosition;
		}

		public function set scrollPosition(value:Number):void
		{
			_scrollPosition = value;
		}


	}
}