package com.kge.delegates {
	import flash.display.MovieClip;
	/**
	 * 模块加载委托
	 * @author Abel
	 */
	public interface IUILoadingViewController extends IUIViewController {
		/**
		 * 模块加载完成
		 * @param module 加载完成的模块
		 */
		function loadModuleComplete(module:MovieClip):void;
	}
}
