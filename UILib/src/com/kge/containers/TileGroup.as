package com.kge.containers {
	import flash.display.DisplayObject;
	import com.kge.containers.HGroup;

	/**
	 * 行、列排列的容器
	 * @see com.kge.containers.HGroup
	 * @see com.kge.containers.VGroup
	 * @author Abel
	 */
	public class TileGroup extends HGroup {
		/**
		 * 单元格的宽度
		 */
		private var _tileWidth : int = 20;
		/**
		 * 单元格的高度
		 */
		private var _tileHeight : int = 20;
		/**
		 * 列数
		 */
		private var _columnCount : int = 2;

		/**
		 * 创建一个新的TileGroup实例
		 */
		public function TileGroup() {
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
					var child:DisplayObject = this.getChildAt(i);
					child.x = (i % _columnCount) * (_tileWidth + _gap);
					child.y = int(i / _columnCount) * (_tileHeight + _gap);
				}
			}
		}

		/**
		 * 获取列数
		 */
		public function get columnCount() : int {
			return _columnCount;
		}

		/**
		 * 设置列数
		 * @param columnCount 列数
		 */
		public function set columnCount(columnCount : int) : void {
			if (_columnCount != columnCount) {
				_columnCount = columnCount;
				hasChanged();
			}
		}

		/**
		 * 获取单元格的宽度
		 * @default 20
		 * @return 返回单元格的宽度
		 */
		public function get tileWidth() : int {
			return _tileWidth;
		}

		/**
		 * 设置单元格的宽度
		 * @default 20
		 * @param tileWidth 单元格的宽度值
		 */
		public function set tileWidth(tileWidth : int) : void {
			_tileWidth = tileWidth;
		}

		/**
		 * 获取单元格的高度
		 * @default 20
		 * @return 返回单元的高度
		 */
		public function get tileHeight() : int {
			return _tileHeight;
		}

		/**
		 * 设置单元格的高度
		 * @default 20
		 * @param tileHeight 单元格的高度值
		 */
		public function set tileHeight(tileHeight : int) : void {
			_tileHeight = tileHeight;
		}
	}
}
