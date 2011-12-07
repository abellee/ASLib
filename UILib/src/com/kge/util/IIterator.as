package com.kge.util {
	/**
	 * 迭代器接口
	 * @author Abel
	 */
	public interface IIterator {
		function reset() : void;

		function next() : Object;

		function hasNext() : Boolean;

		function dealloc() : void;
	}
}
