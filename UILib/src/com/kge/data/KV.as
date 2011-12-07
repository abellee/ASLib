package com.kge.data {
	/**
	 * 存储key、value
	 * @author Abel
	 */
	public class KV {
		/**
		 * 键名
		 */
		private var _key : * = null;
		/**
		 * 键值
		 */
		private var _value : * = null;

		/**
		 * 创建一个新的KV实例。
		 */
		public function KV(key : String, value : String) {
			_key = key;
			_value = value;
		}

		/**
		 * 获取键名
		 * @return 返回键名
		 */
		public function get key() : * {
			return _key;
		}

		/**
		 * 设置键名
		 * @param key 键名
		 */
		public function set key(key : *) : void {
			if (_key != key) _key = key;
		}

		/**
		 * 获取键值
		 * @return 返回键值
		 */
		public function get value() : * {
			return _value;
		}

		/**
		 * 设置任何类型的键值
		 * @param value 任何类型的键值
		 */
		public function set value(value : *) : void {
			if (_value != value) _value = value;
		}

		/**
		 * 与另一个KV对象进行对比是否相同
		 * @return 返回比较结果true/false
		 */
		public function isEqual(kv : KV) : Boolean {
			return kv && kv.key == _key && kv.value == _value;
		}

		/**
		 * 在不进行重新创建对象的前提下重新构建类内部数据。
		 * 如果需要完全清空类内数据，以等待垃圾回收，请调用dealloc()。
		 * @see #dealloc()
		 */
		public function rebuild() : void {
			_key = null;
			_value = null;
		}

		/**
		 * 完全清除自身所有数据，以等待垃圾回收。
		 * 如果只是希望重构类内数据，不重新创建对象，请调用rebuild()。
		 * @see #rebuild()
		 */
		public function dealloc() : void {
			_key = null;
			_value = null;
		}
	}
}
