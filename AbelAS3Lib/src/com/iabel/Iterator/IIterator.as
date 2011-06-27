package com.iabel.Iterator
{
	public interface IIterator
	{
		function hasNext():Boolean;
		function hasPreviouse():Boolean;
		function next():Object;
		function previouse():Object;
		function get index():uint;
		function set index(value:uint):void;
		function reset():void;
		
		function gc():void;
	}
}