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
	import flash.display.CapsStyle;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class KeySignatureStaff extends Staff
	{

		public function KeySignatureStaff():void
		{
			super();
		}

		protected override function getNoteBitmapArray(note:Note,accidental:String,center:Point,inputColumn:int,clef:String="treble"):Array
		{

			var sprites:Array = new Array  ;

			var accHolder:Bitmap;
			var myAcc;
			switch (AccidentalToolbar(MovieClip(parent).accToolbar).accidentalSelected())
			{
				case 1 :
					if (! keySign.isInKeySignature(new Note(note.getLetter(),"#",note.getRegister()),false))
					{
						accHolder = new Bitmap  ;
						myAcc = new sharp(10,10);
						accHolder.bitmapData = myAcc;
						accHolder.x = center.x - accHolder.width / 2 - maxAccidentalWidth;
						accHolder.y = center.y - accHolder.height / 2;
						sprites.push(accHolder);
					}
					break;
				case -1 :
					if (! keySign.isInKeySignature(new Note(note.getLetter(),"b",note.getRegister()),false))
					{
						accHolder = new Bitmap  ;
						myAcc = new flat(10,10);
						accHolder.bitmapData = myAcc;
						accHolder.x = center.x - accHolder.width / 2 - maxAccidentalWidth;
						accHolder.y = center.y - accHolder.height / 2;
						sprites.push(accHolder);
					}
					break;
				default :
					break;

			}


			sprites = sprites.concat(getCopyOfVisibleLedgerLines(linesAboveTopStaff,inputColumn));
			sprites = sprites.concat(getCopyOfVisibleLedgerLines(linesBelowTopStaff,inputColumn));
			sprites = sprites.concat(getCopyOfVisibleLedgerLines(linesAboveBottomStaff,inputColumn));
			sprites = sprites.concat(getCopyOfVisibleLedgerLines(linesBelowBottomStaff,inputColumn));
			return sprites;
		}



		protected override function noteRollOver(event:MouseEvent):void
		{

			Mouse.hide();

			var spot:Sprite = Sprite(event.target);
			var noteArray:Array = getNoteArrayFromSpot(spot);
			var note:Note = Note(noteArray[0]);

			switch (AccidentalToolbar(MovieClip(parent).accToolbar).accidentalSelected())
			{
				case 1 :
					if (! keySign.isInKeySignature(new Note(note.getLetter(),"#",note.getRegister()),false))
					{
						sharpHolder.x = spot.x + spot.width / 2 - sharpHolder.width / 2;
						sharpHolder.y = spot.y + spot.height / 2 - sharpHolder.height / 2;
						sharpHolder.visible = true;
					}
					break;
				case -1 :
					if (! keySign.isInKeySignature(new Note(note.getLetter(),"b",note.getRegister()),false))
					{
						flatHolder.x = spot.x + spot.width / 2 - flatHolder.width / 2;
						flatHolder.y = spot.y + spot.height / 2 - flatHolder.height / 2;
						flatHolder.visible = true;
					}
					break;
				default :
					break;

			}



			if ((String(noteArray[3]) == "treble"))
			{
				if (ledgerLimitAboveTreble.greaterThan(Note(noteArray[0]),true) > 0)
				{

					switch (Note(noteArray[0]).getLetter())
					{
						case "A" :
						case "B" :

							if (Note(noteArray[0]).getRegister() < 6)
							{
								showHideLines(linesAboveTopStaff[noteArray[1]],1,true);
							}
							else
							{
								showHideLines(linesAboveTopStaff[noteArray[1]],4,true);
							}
							break;

						case "C" :
						case "D" :
							showHideLines(linesAboveTopStaff[noteArray[1]],2,true);
							break;
						case "E" :
						case "F" :
							showHideLines(linesAboveTopStaff[noteArray[1]],3,true);
							break;
						case "G" :
							showHideLines(linesAboveTopStaff[noteArray[1]],4,true);
							break;
					}
				}
				else if (ledgerLimitBelowTreble.greaterThan(Note(noteArray[0]),true) < 0)
				{

					switch (Note(noteArray[0]).getLetter())
					{
						case "E" :
						case "F" :
							showHideLines(linesBelowTopStaff[noteArray[1]],3,true);
							break;
						case "G" :
						case "A" :
							showHideLines(linesBelowTopStaff[noteArray[1]],2,true);
							break;
						case "B" :
						case "C" :
							showHideLines(linesBelowTopStaff[noteArray[1]],1,true);
							break;
					}
				}

			}
			else if ((String(noteArray[3]) == "bass"))
			{
				if (ledgerLimitAboveBass.greaterThan(Note(noteArray[0]),true) > 0)
				{

					switch (Note(noteArray[0]).getLetter())
					{
						case "C" :
						case "D" :
							showHideLines(linesAboveBottomStaff[noteArray[1]],1,true);
							break;
						case "E" :
						case "F" :
							showHideLines(linesAboveBottomStaff[noteArray[1]],2,true);
							break;
						case "G" :
						case "A" :
							showHideLines(linesAboveBottomStaff[noteArray[1]],3,true);
							break;
					}
				}
				else if (ledgerLimitBelowBass.greaterThan(Note(noteArray[0]),true) < 0)
				{

					switch (Note(noteArray[0]).getLetter())
					{
						case "E" :
							if (Note(noteArray[0]).getRegister() > 1)
							{
								showHideLines(linesBelowBottomStaff[noteArray[1]],1,true);
							}
							else
							{
								showHideLines(linesBelowBottomStaff[noteArray[1]],4,true);
							}
						case "D" :
							showHideLines(linesBelowBottomStaff[noteArray[1]],1,true);
							break;
						case "C" :
						case "B" :
							showHideLines(linesBelowBottomStaff[noteArray[1]],2,true);
							break;
						case "A" :
						case "G" :
							showHideLines(linesBelowBottomStaff[noteArray[1]],3,true);
							break;
						case "F" :
							showHideLines(linesBelowBottomStaff[noteArray[1]],4,true);
							break;
					}
				}

			}

		}

		protected override function getInputAreaX():int
		{
			return getKSX();
		}

		protected override function getKeySignWidth():int
		{
			return 0;
		}

		protected override function getSystemWidth():int
		{
			return padding * 2 + clefWidth + padding * 3 + inputColumnWidth * inputParams.length + padding * 8;
		}


	}
}