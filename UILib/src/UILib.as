package {
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;

	import com.kge.controls.Alert;
	import com.kge.controls.AlertOption;
	import com.kge.core.UIView;
	import com.kge.core.UIViewController;
	import com.kge.delegates.IUIView;

	import flash.display.Sprite;
	import flash.events.Event;

	
	public class UILib extends Sprite implements IUIView
	{
		/**
		* 所有可视图形的基类
		* <code>
		* var uilb:UILib = new UILib();
		* </code>
		* @param num 传入数字
		* @see someOtherMethod
		*/
		public function UILib()
		{
			var alert:Alert = Alert.instance;
			addChild(alert);
			alert.option = AlertOption.YES | AlertOption.NO;
			var button:Button = new Button();
			button.mouseChildren = false;
			addChild(button);
			var checkbox:CheckBox = new CheckBox();
			checkbox.mouseChildren = false;
			checkbox.setStyle("downSkin", getSprite());
			addChild(checkbox);
			checkbox.x = 200;
			var rb:RadioButton = new RadioButton();
			rb.setStyle("icon", getSprite());
			addChild(rb);
			
			var viewController:UIViewController = new UIViewController();
			viewController.view.delegate = this;
		}
		
		public function changingFinished(view:UIView):void
		{
			
		}
		
		private function getSprite():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(Math.random() * 0xFFFFFF);
			sp.graphics.drawRect(0, 0, 100, 30);
			sp.graphics.endFill();
			return sp;
		}

		private function onRemoved(event : Event) : void {
			trace("removed");
		}

		private function onRemovedFromStage(event : Event) : void {
			trace("removed from stage");
		}
	}
}