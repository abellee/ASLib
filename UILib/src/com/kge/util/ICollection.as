package com.kge.util {
	/**
	 * 集合接口
	 * @author Abel
	 */
	public interface ICollection {
		/**
		 * 生成集合的迭代器
		 * @return 返回生成的集合的迭代器
		 */
		function iterator() : IIterator;

		/**
		 * 检测是否包含某个元素
		 * @return 返回true/false
		 */
		function contains(obj : Object) : Boolean;

		/**
		 * 添加一个Object
		 * 当已存在该键时，将返回false。
		 * 否则返回true，
		 * @param obj 一个对象
		 * @return 返回true/false, 表示添加成功/失败
		 */
		function add(obj : Object) : Boolean;
		
		/**
		 * 删除指定的Object, 并返回该对象
		 * @param obj 指定要删除的一个对象
		 * @return 返回被删除的对象或者null
		 */
		function removeItem(obj : Object) : Object;

		/**
		 * 删除指定索引处的对象
		 * @param index 指定的索引值
		 * @return 返回被删除的对象
		 */
		function removeItemAt(index : int) : Object;

		/**
		 * 返回指定索引的对象
		 * @param index 索引值
		 * @return 返回指定索引的对象
		 */
		function getItemAt(index : int) : Object;

		/**
		 * 添加对象到队列尾
		 * @param obj 指定的对象
		 * @return 返回添加的对象
		 */
		function addItem(obj : Object) : Object;

		/**
		 * 将对象添加到指定的索引
		 * @param obj 指定的对象
		 * @param index 指定的索引值
		 * @return 返回该对象
		 */
		function addItemAt(obj : Object, index : int) : Object;

		/**
		 * 清空当前集合
		 */
		function clear() : void;

		/**
		 * 检测列表是否为空
		 * @return 返回true/false
		 */
		function isEmpty() : Boolean;

		/**
		 * 获取当前列表的大小
		 * @return 返回列表的大小
		 */
		function get size() : int;

		/**
		 * 将另一个集合与当前集合进行合并
		 * @param collection 另一个集合
		 */
		function union(collection : Collection) : void;
		
		/**
		 * 清除自身数据，以等待垃圾回收
		 */
		function dealloc() : void;
	}
}
