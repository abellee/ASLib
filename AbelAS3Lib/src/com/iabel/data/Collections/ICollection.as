package com.iabel.data.Collections
{
	import com.iabel.Iterator.IIterator;
	public interface ICollection
	{
		function addElements(...arg):void;
		function addElementAt(index:uint, element:Object):void;
		
		function removeElements(...arg):void;
		function removeElementAt(index:uint):Object;
		
		function get length():uint;
		function get iterator():IIterator;
		
		function gc():void;
	}
}