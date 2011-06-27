package com.iabel.Iterator
{
	import com.iabel.core.ALObject;
	
	public class Iterator extends ALObject implements IIterator
	{
		/**
		 * 迭代器的数据
		 */
		private var _data:Array;
		
		/**
		 * 迭代器的指针
		 */
		private var _index:uint = 0;
		public function Iterator(data:Array = null)
		{
			super();
			
			if(data) _data = data;
			else _data = [];
		}
		
		/**
		 * 迭代器是否存在下一个元素;
		 */
		public function hasNext():Boolean
		{
			return _index < _data.length;
		}
		
		/**
		 * 迭代器是否存在上一个元素;
		 */
		public function hasPreviouse():Boolean
		{
			return _index > 0;
		}
		
		/**
		 * 迭代器指针往后移动一位，并返回该位置上的元素;
		 */
		public function next():Object
		{
			return _data[_index++];
		}
		
		/**
		 * 迭代器指针往前移动一位，并返回该位置上的元素;
		 */
		public function previouse():Object
		{
			return _data[_index--];
		}
		
		/**
		 * 返回迭代器当前指针的位置;
		 */
		public function get index():uint
		{
			return _index;
		}
		
		/**
		 * 设置迭代器当前指针的位置;
		 */
		public function set index(value:uint):void
		{
		}
		
		/**
		 * 重置迭代器指针位置;
		 */
		public function reset():void
		{
		}
		
		/**
		 * 内存回收;
		 */
		public function gc():void
		{	
			dealloc();
		}
		
		override protected function dealloc():void
		{
			super.dealloc();
			_data = null;
		}
	}
}