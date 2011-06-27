package com.iabel.data.Collections
{
	public class ArrayCollection extends Collection
	{
		public function ArrayCollection()
		{
			super();
		}
		public function set source(arr:Array):void
		{
			_data = null;
			_data = source;
		}
		
		public function get source():Array
		{
			return _data;
		}
	}
}