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

	import fl.controls.Button;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class KeySignatureToolbar extends AccidentalToolbar
	{

		public function KeySignatureToolbar():void
		{
			super();
		}

		public override function render(ulCorner:Point,padding:int,bWidth:int,bHeight:int):void
		{

			btnArr = new Array  ;

			btnArr.push(addButton(ulCorner,bWidth,bHeight,"sharpToolbar"));
			btnArr.push(addButton(new Point(ulCorner.x,ulCorner.y + bHeight + padding),bWidth,bHeight,"flatToolbar"));

			Button(btnArr[0]).emphasized = true;

		}

		protected override function clickHandler(evt:MouseEvent):void
		{
			var btn:Button = evt.currentTarget as Button;
			if (btn.emphasized)
			{
				return;
			}
			var i:int;
			for (i = 0; i < btnArr.length; i++)
			{
				if (((Button(btnArr[i]) != btn) && Button(btnArr[i]).emphasized))
				{
					Button(btnArr[i]).emphasized = false;
				}
			}
			btn.emphasized = true;

		}

		public override function accidentalSelected():int
		{
			if (Button(btnArr[0]).emphasized)
			{
				return 1;
			}
			else if (Button(btnArr[1]).emphasized)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}

		public override function clickButton(accidental:int)
		{
			switch (accidental)
			{
				case 1 :
					Button(btnArr[0]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case -1 :
					Button(btnArr[1]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
			}
		}

	}
}