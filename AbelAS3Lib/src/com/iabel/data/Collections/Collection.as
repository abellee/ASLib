package com.iabel.data.Collections
{
	import com.iabel.Iterator.ArrayIterator;
	import com.iabel.Iterator.IIterator;
	import com.iabel.core.ALObject;
	
	public class Collection extends ALObject implements ICollection
	{
		/**
		 * 集合的数据;
		 */
		protected var _data:Array;
		
		public function Collection()
		{
			super();
			
			_data = [];
		}
		
		/**
		 * 批量添加元素至集合;
		 */
		public function addElements(...arg):void
		{
			for each(var element:Object in arg){
				
				_data[_data.length] = element;
				
			}
		}
		
		/**
		 * 添加单个元素至指定索引处;
		 */
		public function addElementAt(index:uint, element:Object):void
		{
			_data.splice(index, 0, element);
		}
		
		/**
		 * 批量移除元素
		 */
		public function removeElements(...arg):void
		{
			for each(var element:Object in arg){
				
				var len:uint = _data.length;
				for(var i:uint = 0; i < len; i++){
					
					var obj:Object = _data[i];
					if(element == obj){
						
						_data.splice(i, 1);
						
					}
					
				}
				
			}
		}
		
		/**
		 * 移除指定索引处的元素, 并返回;
		 */
		public function removeElementAt(index:uint):Object
		{
			return _data.splice(index, 1);
		}
		
		/**
		 * 返回该集合数据长度
		 */
		public function get length():uint
		{	
			return _data.length;
		}
		
		/**
		 * 返回集合的迭代器
		 */
		public function get iterator():IIterator
		{
			return new ArrayIterator(_data);
		}
		
		/**
		 * 内存回收
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