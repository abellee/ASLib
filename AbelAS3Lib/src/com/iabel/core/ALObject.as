package com.iabel.core
{
	public class ALObject extends Object
	{
		/**
		 * 一个静态基类 请不要直接实例化
		 */
		public function ALObject()
		{
			super();
			if(Object(this).constructor == ALObject){
				
				throw new Error("You can't instance an abstract class!");
				
			}
		}
		
		/**
		 * 垃圾回收，调用各子类中的gc(), 请不要直接调用该方法;
		 */
		protected function dealloc():void
		{
			
		}
	}
}