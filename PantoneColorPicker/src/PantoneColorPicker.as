package
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	[SWF(width=700, height=600)]
	public class PantoneColorPicker extends Sprite
	{
		private var loader:URLLoader;
		private var xmlPath:URLRequest = new URLRequest("config.xml");
		private var xmlList:XMLList;
		
		private var colorBoxList:Vector.<ColorBox>;
		
		private var curPage:uint;
		private var totalPages:uint;
		private var perPageNum:uint = 20;
		private var perRowNum:uint = 4;
		
		private var nextBtn:Button;
		private var preBtn:Button;
		private var searchBtn:Button;
		private var returnBtn:Button;
		private var showPage:TextField;
		private var searchTxt:TextField;
		
		private var pageFlipGroup:Sprite;
		
		private var curState:String = "normal";
		
		public function PantoneColorPicker()
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, configXML_loadCompleteHandler);
			loader.load(xmlPath);
		}
		private function configXML_loadCompleteHandler(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, configXML_loadCompleteHandler);
			var xml:XML = XML(event.target.data);
			loader = null;
			xmlPath = null;
			xmlList = xml.children();
			curPage = 1;
			totalPages = uint(xmlList.length() / perPageNum) + 1;
			colorBoxList = new Vector.<ColorBox>();
			
			pageFlipGroup = new Sprite();
			
			showPage = new TextField();
			showPage.autoSize = TextFieldAutoSize.LEFT;
			showPage.text = curPage + " / " + totalPages;
			
			nextBtn = new Button();
			nextBtn.textField.autoSize = TextFieldAutoSize.CENTER;
			nextBtn.label = "下一页";
			
			preBtn = new Button();
			preBtn.textField.autoSize = TextFieldAutoSize.CENTER;
			preBtn.label = "上一页";
			
			preBtn.x = 0;
			preBtn.y = 0;
			
			nextBtn.x = preBtn.x + preBtn.width + 10;
			nextBtn.y = preBtn.y;
			
			showPage.x = nextBtn.x + nextBtn.width + 10;
			showPage.y = nextBtn.y + (nextBtn.height - showPage.textHeight) / 2;
			
			searchTxt = new TextField();
			searchTxt.border = true;
			searchTxt.type = TextFieldType.INPUT;
			searchTxt.width = 100;
			searchTxt.height = 17;
			searchTxt.x = showPage.x + 50;
			searchTxt.y = nextBtn.y + (nextBtn.height - searchTxt.height) / 2;
			
			searchBtn = new Button();
			searchBtn.label = "搜 索";
			searchBtn.width = 40;
			searchBtn.textField.autoSize = TextFieldAutoSize.CENTER;
			searchBtn.x = searchTxt.x + searchTxt.width + 10;
			searchBtn.y = nextBtn.y;
			
			returnBtn = new Button();
			returnBtn.label = "返 回";
			returnBtn.width = 40;
			returnBtn.textField.autoSize = TextFieldAutoSize.CENTER;
			returnBtn.x = searchBtn.x + searchBtn.width + 10;
			returnBtn.y = searchBtn.y;
			
			pageFlipGroup.addChild(preBtn);
			pageFlipGroup.addChild(nextBtn);
			pageFlipGroup.addChild(showPage);
			pageFlipGroup.addChild(searchTxt);
			pageFlipGroup.addChild(searchBtn);
			pageFlipGroup.addChild(returnBtn);
			
			preBtn.addEventListener(MouseEvent.CLICK, preBtn_mouseClickHandler);
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtn_mouseClickHandler);
			searchBtn.addEventListener(MouseEvent.CLICK, searchBtn_mouseClickHandler);
			returnBtn.addEventListener(MouseEvent.CLICK, returnBtn_mouseClickHandler);
			
			addChild(pageFlipGroup);
			pageFlipGroup.x = (stage.stageWidth - pageFlipGroup.width) / 2;
			pageFlipGroup.y = stage.stageHeight - pageFlipGroup.height - 20;
			
			listColorBox(xmlList);
		}
		private function returnBtn_mouseClickHandler(event:MouseEvent):void
		{
			if(curState == "normal"){
				
				return;
				
			}
			curState = "normal";
			searchTxt.text = "";
			curPage = 1;
			totalPages = uint(xmlList.length() / perPageNum) + 1;
			showPage.text = curPage + " / " + totalPages;
			listColorBox(xmlList);
		}
		private function preBtn_mouseClickHandler(event:MouseEvent):void
		{
			if(curPage <= 1){
				
				return;
				
			}
			curPage --;
			showPage.text = curPage + " / " + totalPages;
			listColorBox(xmlList);
		}
		private function nextBtn_mouseClickHandler(event:MouseEvent):void
		{
			if(curPage >= totalPages){
				
				return;
				
			}
			curPage ++;
			showPage.text = curPage + " / " + totalPages;
			listColorBox(xmlList);
		}
		private function listColorBox(xmlResult:XMLList):void
		{
			if(this.numChildren > 1){
				
				var totalNum:uint = this.numChildren - 1;
				for(var j:uint = 0; j < totalNum; j++){
					
					this.removeChildAt(1);
					
				}
				
			}
			var start:uint = (curPage - 1) * perPageNum;
			var end:uint = curPage * perPageNum;
			for(var i:uint = start; i < end; i++){
				
				if(!xmlResult[i]){
					
					continue;
					
				}
				var item:XML;
				item = XML(xmlResult[i]);
				var colorBox:ColorBox = new ColorBox(item.@hex + "", item.@pantone, 150, 50);
				addChild(colorBox);
				colorBoxList.push(colorBox);
				colorBox.x = ((i - start) % perRowNum) * (colorBox.width + 10) + 10;
				colorBox.y = uint((i - start) / perRowNum) * (colorBox.height + 10) + 10;
				
			}
		}
		private function searchBtn_mouseClickHandler(event:MouseEvent):void
		{
			var txt:String = searchTxt.text.toUpperCase();
			txt = txt.replace(/\s+/g, "");
			if(txt == ""){
				
				return;
				
			}
			curState = "search";
			var tempList:XML = new XML("<result></result>");
			for each(var item:XML in xmlList){
				
				if(item.@pantone == txt){
					
					tempList.appendChild(item);
					
				}
				
			}
			totalPages = uint(tempList.children().length() / perPageNum) + 1;
			curPage = totalPages? 1 : 0;
			showPage.text = curPage + " / " + totalPages;
			listColorBox(tempList.children());
		}
	}
}