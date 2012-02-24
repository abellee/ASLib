package com.kge.delegates {
	import com.kge.core.UIView;
	/**
	 * 所有视图的代理
	 * @author Abel
	 */
	public interface IUIView {
		/**
		 * 刷新视图完成
		 * @param view 完成重绘的视图
		 */
		function changingFinished(displayObjectContainer:UIView) : void;
	}
}
