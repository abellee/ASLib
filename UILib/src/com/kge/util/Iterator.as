package com.kge.util {
	/**
	 * 迭代器
	 * @author Abel
	 */
	public class Iterator implements IIterator {
		/**
		 * 数据集合
		 */
		private var _collection : Array;
		/**
		 * 指针
		 */
		private var _count : int = 0;

		/**
		 * 创建一个新的Iterator实例。
		 */
		public function Iterator(collection : Array) {
			_collection = collection;
		}

		/**
		 * 检测是否存在下一个元素
		 * @return 返回true/false
		 */
		public function hasNext() : Boolean {
			if (!_collection) return false;
			return _count < _collection.length;
		}

		/**
		 * 获取下一个元素
		 * @return 返回下一个元素
		 */
		public function next() : Object {
			if (!_collection) return false;
			return _collection[_count++];
		}

		/**
		 * 重置迭代器指针
		 */
		public function reset() : void {
			_count = 0;
		}

		/**
		 * 清除自身数据，以等待垃圾回收
		 */
		public function dealloc() : void {
			_collection = null;
		}
	}
}
