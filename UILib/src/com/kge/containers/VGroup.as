package com.kge.containers {
	import flash.display.DisplayObject;

	/**
	 * 垂直布局容器
	 * @see com.kge.containers.HGroup
	 * @see com.kge.containers.TileGroup
	 * @author Abel
	 */
	public class VGroup extends HGroup {
		/**
		 * 创建一个新的VGroup实例
		 */
		public function VGroup() {
			super();
		}
		
		/**
		 * @private
		 * 在容器中的内容被改变后调用此方法，重新布局。
		 */
		override protected function layoutContainer() : void {
			if (this.numChildren) {
				var len : int = this.numChildren;
				for (var i : int = 0; i < len; i++) {
					var child : DisplayObject = this.getChildAt(i);
					if (i) {
						var preChild : DisplayObject = this.getChildAt(i - 1);
						child.y = preChild.y + preChild.height + _gap;
					} else {
						child.y = 0;
					}
				}
			}
		}
	}
}
