package com.kge.core {
	/**
	 * 所有数据模型的基类
	 * @author Abel
	 */
	public class Data {
		/**
		 * @private
		 * ID
		 */
		protected var _id : int = 0;

		/**
		 * 创建一个新的Data实例。
		 */
		public function Data() {
		}

		/**
		 * 获取道具id(property id)
		 * @return 返回道具的id
		 */
		public function get id() : int {
			return _id;
		}

		/**
		 * 设置道具的id(property id)
		 * @param id 道具id
		 * @default 0
		 */
		public function set id(id : int) : void {
			if (_id != id) _id = id;
		}

		/**
		 * 取得数据模型中所有key
		 * @return 包含了所有key的一个Vector
		 */
		public function keys() : Vector {
			return new Vector.<String>(["id"]);
		}

		/**
		 * 进入数据的重构。
		 * 如果想要清空类内所有数据，以等待垃圾回收，请调用dealloc()。
		 * @see #dealloc()
		 */
		public function rebuild() : void {
			id = 0;
		}

		/**
		 * 清除自身内部数据及相关引用、事件监听等，以等待垃圾回收。
		 * 如果只是想要重建该类，并不需要重新创建一个新的实例，请调用rebuild()
		 * @see #rebuild();
		 */
		public function dealloc() : void {
		}
	}
}
