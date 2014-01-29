/* Copyright (c) 2009, 2013 Eric Brisson

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE. */

package fl.music
{

	import flash.display.Sprite;
	import flash.geom.Point;
	import fl.controls.Button;
	import flash.events.MouseEvent;

	public class AccidentalToolbar extends Sprite
	{

		protected var btnArr:Array;

		public function AccidentalToolbar():void
		{
			super();
		}

		public function hide()
		{
			var i:int;
			for (i = 0; i < btnArr.length; i++)
			{
				Button(btnArr[i]).visible = false;
			}
		}

		protected function addButton(ulCorner:Point,bWidth:int,bHeight:int,iconStr:String):Button
		{

			var button:Button = new Button  ;
			button.x = this.x + ulCorner.x;
			button.y = this.y + ulCorner.y;
			button.setSize(bWidth,bHeight);
			button.emphasized = false;
			button.selected = false;
			button.setStyle("emphasizedSkin","Button_selectedOverSkin");
			button.setStyle("icon",iconStr);
			button.label = "";

			button.addEventListener(MouseEvent.CLICK,clickHandler);

			parent.addChild(button);
			return button;
		}

		protected function clickHandler(event_:MouseEvent):void
		{
			var button:Button = event_.currentTarget as Button;
			if (button.emphasized)
			{
				button.emphasized = false;
				return;
			}
			var i:int;
			for (i = 0; i < btnArr.length; i++)
			{
				if (((Button(btnArr[i]) != button) && Button(btnArr[i]).emphasized))
				{
					Button(btnArr[i]).emphasized = false;
				}
			}
			button.emphasized = true;

		}

		public function accidentalSelected():int
		{
			var i:int = arrayIndexSelected();
			switch (i)
			{
				case 0 :
					return 0;
				case 1 :
					return 1;
				case 2 :
					return -1;
				case 3 :
					return 2;
				case 4 :
					return -2;
				default :
					return -100;

			}

		}

		private function arrayIndexSelected():int
		{
			var i:int;
			for (i = 0; i < btnArr.length; i++)
			{
				if (Button(btnArr[i]).emphasized)
				{
					break;
				}
			}
			return i;
		}

		public function clickButton(accidental:int)
		{
			switch (accidental)
			{
				case 1 :
					Button(btnArr[1]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case -1 :
					Button(btnArr[2]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case 2 :
					Button(btnArr[3]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case -2 :
					Button(btnArr[4]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case 0 :
					Button(btnArr[0]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;

			}

		}

		public function render(ulCorner:Point,padding:int,bWidth:int,bHeight:int):void
		{

			btnArr = new Array  ;

			btnArr.push(addButton(ulCorner,bWidth,bHeight,"naturalToolbar"));
			btnArr.push(addButton(new Point(ulCorner.x,ulCorner.y + bHeight + padding),bWidth,bHeight,"sharpToolbar"));
			btnArr.push(addButton(new Point(ulCorner.x,ulCorner.y + bHeight * 2 + padding * 2),bWidth,bHeight,"flatToolbar"));
			btnArr.push(addButton(new Point(ulCorner.x,ulCorner.y + bHeight * 3 + padding * 3),bWidth,bHeight,"doublesharpToolbar"));
			btnArr.push(addButton(new Point(ulCorner.x,ulCorner.y + bHeight * 4 + padding * 4),bWidth,bHeight,"doubleflatToolbar"));
		}

	}
}