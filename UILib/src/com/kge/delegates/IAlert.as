package com.kge.delegates {
	/**
	 * Alert代理
	 * @author Abel
	 */
	public interface IAlert {
		/**
		 * 点击确定
		 */
		function enter() : void;

		/**
		 * 点击取消
		 */
		function cancel() : void;
	}
}
