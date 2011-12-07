package com.kge.maths {
	/**
	 * 上、下、左、右的填充值
	 * @author Abel
	 */
	public class Padding {
		/**
		 * 上方填充值
		 */
		private var _paddingTop : int = 0;
		/**
		 * 右方填充值
		 */
		private var _paddingRight : int = 0;
		/**
		 * 下方填充值
		 */
		private var _paddingBottom : int = 0;
		/**
		 * 左方填充值
		 */
		private var _paddingLeft : int = 0;

		/**
		 * 创建一个新的Padding实例
		 */
		public function Padding() {
		}

		/**
		 * 获取上方填充值
		 */
		public function get paddingTop() : int {
			return _paddingTop;
		}

		/**
		 * 设置上方填充值
		 * @param paddingTop 上方填充值
		 */
		public function set paddingTop(paddingTop : int) : void {
			if(_paddingTop != paddingTop) _paddingTop = paddingTop;
		}

		/**
		 * 获取右方填充值
		 * @return 右方填充值
		 */
		public function get paddingRight() : int {
			return _paddingRight;
		}

		/**
		 * 设置右方填充值
		 * @param paddingRight 右方填充值
		 */
		public function set paddingRight(paddingRight : int) : void {
			_paddingRight = paddingRight;
		}

		/**
		 * 获取下方填充值
		 * @return 下方填充值
		 */
		public function get paddingBottom() : int {
			return _paddingBottom;
		}

		/**
		 * 设置下方填充值
		 * @param paddingBottom 下方填充值
		 */
		public function set paddingBottom(paddingBottom : int) : void {
			_paddingBottom = paddingBottom;
		}

		/**
		 * 获取左方填充值
		 * @return 左方填充值
		 */
		public function get paddingLeft() : int {
			return _paddingLeft;
		}

		/**
		 * 设置左方填充值
		 * @param paddingLeft 左方填充值
		 */
		public function set paddingLeft(paddingLeft : int) : void {
			_paddingLeft = paddingLeft;
		}
		
		/**
		 * 检测是否与传入的Padding相同
		 * @param padding 另一个Padding对象
		 * @return 返回true/false 表示是否相同
		 */
		 public function isEqual(padding:Padding):Boolean
		 {
			return padding && padding.paddingBottom == _paddingBottom && padding.paddingLeft == _paddingLeft &&
				   padding.paddingRight == _paddingRight && padding.paddingTop == _paddingTop;
		 }
	}
}
