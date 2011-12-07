package com.kge.containers {
	import com.kge.core.UIView;

	import flash.display.DisplayObject;

	/**
	 * 水平布局容器
	 * @see com.kge.containers.VGroup
	 * @see com.kge.containers.TileGroup
	 * @author Abel
	 */
	public class HGroup extends UIView {
		/**
		 * @private
		 * 间隔
		 */
		protected var _gap : int = 5;

		/**
		 * 创建一个新的HGroup实例。
		 */
		public function HGroup() {
			super();
		}

		/**
		 * @private
		 */
		override protected function doChange() : void {
			layoutContainer();
			super.doChange();
		}

		/**
		 * @private
		 * 在容器中的内容被改变后调用此方法，重新布局。
		 */
		protected function layoutContainer() : void {
			trace("layout");
			if (this.numChildren) {
				var len : int = this.numChildren;
				for (var i : int = 0; i < len; i++) {
					var child : DisplayObject = this.getChildAt(i);
					if (i) {
						var preChild : DisplayObject = this.getChildAt(i - 1);
						child.x = preChild.x + preChild.width + _gap;
					} else {
						child.x = 0;
					}
				}
			}
		}

		/**
		 * @private
		 * 自身重构
		 */
		override public function rebuild() : void {
			super.rebuild();
		}

		/**
		 * @private
		 * 自身清除
		 */
		override public function dealloc() : void {
			super.dealloc();
		}

		/**
		 * 获取间隔大小
		 * @default 5
		 * @return 返回间隔大小
		 */
		public function get gap() : int {
			return _gap;
		}

		/**
		 * 设置间隔大小
		 * @default 5
		 */
		public function set gap(gap : int) : void {
			if (_gap != gap) {
				_gap = gap;
				hasChanged();
			}
		}
	}
}
