package com.iabel.container
{
	import com.iabel.data.Collections.Size;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public interface IFillMethod
	{
		function fillBackground(container:Sprite, size:Size, item:DisplayObject, fillMode:String):void;
	}
}