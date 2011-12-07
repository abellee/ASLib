package com.kge.util {
	/**
	 * 集合类。
	 * @author Abel
	 */
	public class Collection implements ICollection {
		/**
		 * @private
		 * 键值列表
		 */
		protected var _list : Array = [];

		/**
		 * 创建一个新的Collection实例。
		 */
		public function Collection() {
		}

		/**
		 * 检测是否存在某个Object
		 * @param obj 检测的对象
		 * @return 返回true/false，表示是否存在指定Object
		 */
		public function contains(obj : Object) : Boolean {
			if (_list.indexOf(obj) == -1) return false;
			else return true;
		}

		/**
		 * 添加一个Object
		 * 当已存在该键时，将返回false。
		 * 否则返回true，
		 * @param obj 一个对象
		 * @return 返回true/false, 表示添加成功/失败
		 */
		public function add(obj : Object) : Boolean {
			_list.push(obj);
			return true;
		}

		/**
		 * 删除指定的Object, 并返回该对象
		 * @param obj 指定要删除的一个对象
		 * @return 返回被删除的对象或者null
		 */
		public function removeItem(obj : Object) : Object {
			if (!contains(obj)) {
				return null;
			} else {
				var index : int = _list.indexOf(obj);
				return _list.splice(index, 1);
			}
		}

		/**
		 * 删除指定索引处的对象
		 * @param index 指定的索引值
		 * @return 返回被删除的对象
		 */
		public function removeItemAt(index : int) : Object {
			if (index > _list.length) return null;
			else return _list.splice(index, 1);
		}

		/**
		 * 返回指定索引的对象
		 * @param index 索引值
		 * @return 返回指定索引的对象
		 */
		public function getItemAt(index : int) : Object {
			if (index > _list.length) return null;
			else return _list[index];
		}

		/**
		 * 添加对象到队列尾
		 * @param obj 指定的对象
		 * @return 返回添加的对象
		 */
		public function addItem(obj : Object) : Object {
			_list.push(obj);
			return obj;
		}

		/**
		 * 将对象添加到指定的索引
		 * @param obj 指定的对象
		 * @param index 指定的索引值
		 * @return 返回该对象
		 */
		public function addItemAt(obj : Object, index : int) : Object {
			return _list.splice(index, 0, obj);
		}

		/**
		 * 清空当前集合
		 */
		public function clear() : void {
			_list.length = 0;
		}

		/**
		 * 检测列表是否为空
		 * @return 返回true/false
		 */
		public function isEmpty() : Boolean {
			return Boolean(_list.length);
		}

		/**
		 * 获取当前列表的大小
		 * @return 返回列表的大小
		 */
		public function get size() : int {
			return _list.length;
		}

		/**
		 * 将另一个集合与当前集合进行合并
		 * @param collection 另一个集合
		 */
		public function union(collection : Collection) : void {
			if (collection) _list = _list.concat(collection);
		}

		/**
		 * 获取当前集合的迭代器
		 * @return 返回当前集合的迭代器
		 */
		public function iterator() : IIterator {
			var iterator : IIterator = new Iterator(_list);
			return iterator;
		}
		
		/**
		 * 清除自身数据，以等待垃圾回收
		 */
		public function dealloc() : void {
			_list = null;
		}
	}
}
