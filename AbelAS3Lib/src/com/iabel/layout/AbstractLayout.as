package com.iabel.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class AbstractLayout implements ILayout
	{
		public function AbstractLayout()
		{
			if(Object(this).constructor == AbstractLayout){
				
				throw new Error("You can't instance an abstract class!");
				
			}
		}
		public function layout(view:DisplayObjectContainer):void
		{
			return;
		}
	}
}