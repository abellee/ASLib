package com.iabel.data.Collections
{
	public class Padding
	{
		protected var _paddingLeft:Number = 0;
		protected var _paddingTop:Number = 0;
		protected var _paddingRight:Number = 0;
		protected var _paddingBottom:Number = 0;
		public function Padding(pl:Number = 0, pt:Number = 0, pr:Number = 0, pb:Number = 0)
		{
			_paddingLeft = pl;
			_paddingTop = pt;
			_paddingRight = pr;
			_paddingBottom = pb;
		}
		
		public function equals(p:Padding):Boolean
		{
			return true;
		}

		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}

		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}

		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}

		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}

	}
}