package com.iabel.core
{

	public class AbstractObject extends Object
	{
		/**
		 * 一个静态基类 请不要直接实例化
		 */
		public function AbstractObject()
		{
			super();
			if(Object(this).constructor == AbstractObject){
				
				throw new Error("You can't instance an abstract class!");
				
			}
		}
		
		public function dealloc():void
		{
			return;
		}
	}
}