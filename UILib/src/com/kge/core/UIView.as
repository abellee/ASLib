package com.kge.core {
	import com.kge.delegates.IUIView;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 所有可视对象的基类
	 * @author Abel
	 */
	public class UIView extends Sprite {
		/**
		 * 事件监听列表
		 * 需要在dealloc时清除所有监听事件
		 * 结构为：{eventType:[function, function]};
		 */
		private var _listenerList : Object = {};
		/**
		 * 确定当前容器中的内容是否已被改变
		 */
		protected var _changed : Boolean = false;
		/**
		 * 代理
		 * @see com.kge.delegates.IUIView
		 */
		public var delegate : IUIView = null;

		/**
		 * 创建一个新的UIView实例
		 */
		public function UIView() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event : Event) : void {
			trace("********| " + this + " |******** received ADDED_TO_STAGE message!");
			stage.addEventListener(Event.RENDER, onRender);
			if (_changed) stage.invalidate();
		}

		/**
		 * 覆写addChild方法
		 * 当添加子对象时，设置该容器已被改变
		 */
		override public function addChild(child : DisplayObject) : DisplayObject {
			super.addChild(child);
			hasChanged();
			return child;
		}

		/**
		 * 覆写removeChild方法
		 * 当移除子对象时，设置该容器已被改变
		 */
		override public function removeChild(child : DisplayObject) : DisplayObject {
			super.removeChild(child);
			hasChanged();
			return child;
		}

		/**
		 * 接收到RENDER事件
		 */
		protected function onRender(event : Event) : void {
			trace("on render:" + _changed);
			if (_changed) {
				doChange();
				_changed = false;
			}
		}

		/**
		 * 视图发生变化，进行相关处理。
		 */
		protected function doChange() : void {
			// override in child class
			if (delegate) delegate.changingFinished();
		}

		/**
		 * 设置当前容器已被改变
		 */
		protected function hasChanged() : void {
			_changed = true;
			if (stage) stage.invalidate();
		}

		/**
		 * 覆写超类的addEventListener
		 * 以达到自行管理事件监听的目的
		 */
		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (_listenerList[type]) {
				var funcsList : Array = _listenerList[type] as Array;
				if (funcsList.indexOf(listener) != -1) return;
				funcsList.push(listener);
			} else {
				_listenerList[type] = [listener];
			}
		}

		/**
		 * 覆写超类的removeEventListener
		 * 以达到自行管理移除事件监听的目的
		 */
		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			if (_listenerList[type]) {
				var funcsList : Array = _listenerList[type] as Array;
				if (funcsList) {
					for each (var func:Function in funcsList) {
						super.removeEventListener(type, listener, useCapture);
					}
					delete _listenerList[type];
				}
			}
		}

		/**
		 * 重置当前所有数据
		 * 用于重新构建对象之用
		 * 请在此处清空或重置重构该对象的相关数据
		 * 如果想完全重建对象，请调用dealloc()方法，然后再new UIView();重新创建
		 * @see dealloc();
		 */
		public function rebuild() : void {
			// reset variables in here
		}

		/**
		 * 垃圾回收
		 * 一旦调用该方法，将销毁一切资源等待虚拟机的垃圾回收。
		 * 如果只是想重新构造对象，请调用rebuild()方法。
		 * @see rebuild()
		 */
		public function dealloc() : void {
			for (var eventType:String in _listenerList) {
				var funcsList : Array = _listenerList[eventType];
				if (funcsList) {
					for each (var func:Function in funcsList)
						removeEventListener(eventType, func);
				}
			}
			_listenerList = null;
		}
	}
}
