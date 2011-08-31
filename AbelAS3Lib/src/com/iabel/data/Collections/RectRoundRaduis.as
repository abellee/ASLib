package com.iabel.data.Collections
{
	public class RectRoundRaduis
	{
		protected var _topLeftRadius:Number = 0;
		protected var _topRightRadius:Number = 0;
		protected var _bottomLeftRadius:Number = 0;
		protected var _bottomRightRadius:Number = 0;
		public function RectRoundRaduis()
		{
		}
		
		public function equals(r:RectRoundRaduis):Boolean
		{
			return true;
		}

		public function get bottomRightRadius():Number
		{
			return _bottomRightRadius;
		}

		public function set bottomRightRadius(value:Number):void
		{
			_bottomRightRadius = value;
		}

		public function get bottomLeftRadius():Number
		{
			return _bottomLeftRadius;
		}

		public function set bottomLeftRadius(value:Number):void
		{
			_bottomLeftRadius = value;
		}

		public function get topRightRadius():Number
		{
			return _topRightRadius;
		}

		public function set topRightRadius(value:Number):void
		{
			_topRightRadius = value;
		}

		public function get topLeftRadius():Number
		{
			return _topLeftRadius;
		}

		public function set topLeftRadius(value:Number):void
		{
			_topLeftRadius = value;
		}
		
		public function dealloc():void
		{
			
		}

	}
}