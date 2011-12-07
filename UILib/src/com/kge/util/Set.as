package com.kge.util {
	import com.kge.util.Collection;

	/**
	 * 集合类, 不能出现重复元素，也不能出现null, 如果有需要加入null，请使用Nil类
	 * @author Abel
	 */
	public class Set extends Collection {
		/**
		 * 创建一个新的Set实例。
		 */
		public function Set() {
			super();
		}
		/**
		 * @inheritDoc
		 */
		override public function addItem(obj:Object) : Object {
			if (contains(obj) || !obj) return null;
			else {
				_list.push(obj);
				return obj;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addItemAt(obj : Object, index : int) : Object {
			if (contains(obj) || !obj) return null;
			return _list.splice(index, 0, obj);
		}
	}
}
