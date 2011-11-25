package com.kge.containers {
	import com.kge.core.UIView;

	/**
	 * 布局容器
	 * 通过LayoutForm设置布局方式
	 * @see com.kge.container.LayoutForm
	 * @author Abel
	 */
	public class Group extends UIView {
		/**
		 * 当前Group的布局方式
		 */
		private var _layout : int = 0;

		/**
		 * 创建一个新的Group实例。
		 */
		public function Group(layoutForm : int = 0) {
			super();
			_layout = layoutForm;
		}

		override protected function doChange() : void {
			layoutContainer();
			super.doChange();
		}

		/**
		 * 在容器中的内容被改变后调用此方法，重新布局。
		 */
		public function layoutContainer() : void {
			if (_changed) {
				trace("layout container");
				switch(_layout) {
					case LayoutForm.HORIZONTAL:
						layoutHorizontally();
						break;
					case LayoutForm.VERTICAL:
						layoutVertically();
						break;
					default:
						break;
				}
			}
		}

		/**
		 * 垂直布局
		 */
		private function layoutVertically() : void {
			// layout
		}

		/**
		 * 水平布局
		 */
		private function layoutHorizontally() : void {
		}

		/**
		 * 取得当前的布局方式
		 */
		public function get layout() : int {
			return _layout;
		}

		/**
		 * 设置新的布局方式
		 */
		public function set layout(layout : int) : void {
			if (_layout != layout) {
				trace("set layout!");
				_layout = layout;
				hasChanged();
			}
		}

		override public function rebuild() : void {
			super.rebuild();
		}

		override public function dealloc() : void {
			super.dealloc();
		}
	}
}
