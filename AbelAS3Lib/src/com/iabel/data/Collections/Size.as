package com.iabel.data.Collections
{
	public class Size
	{
		private var _width:Number;
		private var _height:Number;
		public function Size(w:int, h:int)
		{
			_width = w;
			_height = h;
		}
		/**
		 * 宽度
		 */
		public function set width(value:Number):void
		{
			_width = value;
		}
		public function get width():Number
		{
			return _width;
		}
		/**
		 * 高度
		 */
		public function set height(value:Number):void
		{
			_height = value;
		}
		public function get height():Number
		{
			return _height;
		}
	}
}