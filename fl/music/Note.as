/* Copyright (c) 2009, 2014 Eric Brisson

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




	public class Note
	{

		// Unique integer identifier for given pitch class in a given register
		public var id:int;

		/* Letter name can only be between 'a' = 0 and 'g' = 6
		a = 0
		b = 1
		...
		*/
		private var letter:int;

		/*
		-2 = double-flat
		-1 = flat
		0 = natural
		1 = sharp
		2 = double-sharp
		*/
		//private var accidental:int;


		public function Note(letterName:String,accidentalStr:String,register=4)
		{

			this.letter = letterToInt(letterName);
			this.id = getPitchClass(this.letter,accidentalToInt(accidentalStr),false) + register * 12;

		}

		public function toNote(noteStr:String):Note
		{
			var arr = stringToArray(noteStr);

			return new Note(arr[0],arr[1],arr[2]);
		}

		private function stringToArray(noteStr:String):Array
		{
			if (noteStr.length == 0)
			{
				return null;
			}
			var ltr:String = noteStr.substring(0,1);
			var acc:String;
			var reg:String;
			switch (noteStr.length)
			{
				case 2 :
					acc = "";
					reg = noteStr.substring(1,2);
					break;
				case 3 :
					acc = noteStr.substring(1,2);
					reg = noteStr.substring(2,3);
					break;
				case 4 :
					acc = noteStr.substring(1,3);
					reg = noteStr.substring(3,4);
					break;
			}
			return new Array(ltr,acc,reg);
		}

		private function accidental(myID:int,myLetter:int,myRegister:int):int
		{
			return myID - (getPitchClass(myLetter,0,false) + myRegister * 12);
		}

		private function register(myID:int,myLetter:int):int
		{

			if (((myLetter == 0) && (myID % 12) > 2))
			{
				return Math.floor((myID / 12)) + 1;
			}
			else if (((myLetter == letterToInt("b")) && ((myID % 12) < 9)))
			{
				return Math.floor((myID / 12)) - 1;
			}
			else
			{
				return Math.floor((myID / 12));
			}

		}

		public function alter(alterDelta:int):void
		{
			this.id +=  alterDelta;
		}

		/* INTERVAL FUNCTIONS */

		/* interval = "[+-][MmDA][1-13]" */
		/* returns null if accidental doesn't exist */
		public function getNoteFromInterval(intval:Interval):Note
		{
			var newNoteID:int = id + intval.getIntHSDelta();
			var sizeDifferential:int = intval.getSize() - 1;

			if (intval.getDir() == "-")
			{
				sizeDifferential =  -  sizeDifferential;
			}


			var newLetter:int = this.letter + sizeDifferential % 7;
			if ((newLetter < 0))
			{
				newLetter +=  7;
			}

			var newRegister:int = register(newNoteID,newLetter);

			if ((intToAccidental(accidental(newNoteID,newLetter,newRegister)) == "error"))
			{
				return null;
			}
			else
			{
				return new Note(intToLetter(newLetter),intToAccidental(accidental(newNoteID,newLetter,newRegister)),newRegister);
			}
		}

		public function getSizeDifferential(note:Note):int
		{
			var lowestNote:Note;
			var highestNote:Note;
			if (this.greaterThanLetterRegister(note.getLetter(),note.getRegister()) <= 0)
			{
				lowestNote = this;
				highestNote = note;
			}
			else
			{
				lowestNote = note;
				highestNote = this;
			}
			return letterToInt(highestNote.getLetter()) + Math.abs(highestNote.getRegister() - lowestNote.getRegister()) - 1 * 7 + (8 - letterToInt(lowestNote.getLetter()));
		}

		/* OUTPUT FUNCTIONS */

		public function toString():String
		{

			return intToLetter(letter) + intToAccidental(accidental(id,letter,register(this.id,this.letter))) + register(this.id,this.letter);
		}

		public function getLetterAccidental():String
		{
			return intToLetter(this.letter) + intToAccidental(accidental(id,letter,register(this.id,this.letter)));
		}

		public function getLetter():String
		{
			return intToLetter(letter);
		}

		public function getRegister():int
		{
			return register(this.id,this.letter);
		}

		public function getAccidental():String
		{
			return intToAccidental(accidental(this.id,this.letter,register(this.id,this.letter)));
		}

		public function getAccidentalInt():int
		{
			return accidental(this.id,this.letter,this.getRegister());
		}

		/* COMPARISON FUNCTIONS */

		// Returns 1 if note is greater than this, 0 if equal, and -1 if smaller
		public function greaterThan(note:Note,spellingWise:Boolean):int
		{
			if (note.id == this.id)
			{
				if (spellingWise)
				{
					if ((letterToInt(note.getLetter()) == this.letter))
					{
						return 0;
					}
					else if ((((letterToInt(note.getLetter()) > this.letter) && note.getRegister() == this.getRegister()) || note.getRegister() > this.getRegister()))
					{
						return 1;
					}
					else
					{
						return -1;
					}
				}
				else
				{
					return 0;
				}
			}
			else if (note.id > this.id)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}

		public function greaterThanLetterRegister(let:String,regist:int):int
		{
			if ((regist == this.getRegister()))
			{
				if ((letter == letterToInt(let)))
				{
					return 0;
				}
				else if ((letter > letterToInt(let)))
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else if (this.getRegister() > regist)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}

		public function equals(note:Note,letterRegisterOnly:Boolean=false):Boolean
		{
			if (letterRegisterOnly)
			{
				if (this.getLetter() == note.getLetter() && this.getRegister() == note.getRegister())
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if (this.id == note.id && this.getLetter() == note.getLetter())
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}


		/* UTILITIES */

		private function letterToInt(letterName:String):int
		{
			switch (letterName.toLowerCase())
			{
				case "a" :
					return 5;
					break;
				case "b" :
					return 6;
					break;
				case "c" :
					return 0;
					break;
				case "d" :
					return 1;
					break;
				case "e" :
					return 2;
					break;
				case "f" :
					return 3;
					break;
				case "g" :
					return 4;
					break;
				default :
					return -1;
			}
		}

		private function intToLetter(letterInt:int):String
		{
			switch (letterInt)
			{
				case 0 :
					return "C";
					break;
				case 1 :
					return "D";
					break;
				case 2 :
					return "E";
					break;
				case 3 :
					return "F";
					break;
				case 4 :
					return "G";
					break;
				case 5 :
					return "A";
					break;
				case 6 :
					return "B";
					break;
				default :
					return "Error";
			}
		}

		private function accidentalToInt(accidentalStr:String):int
		{
			switch (accidentalStr)
			{
				case "" :
					return 0;
					break;
				case "#" :
					return 1;
					break;
				case "x" :
					return 2;
					break;
				case "b" :
					return -1;
					break;
				case "bb" :
					return -2;
					break;
				default :
					return -3;
			}
		}

		private function intToAccidental(accidentalInt:int):String
		{

			switch (accidentalInt)
			{
				case 0 :
					return "";
					break;
				case 1 :
					return "#";
					break;
				case 2 :
					return "x";
					break;
				case -1 :
					return "b";
					break;
				case -2 :
					return "bb";
					break;
				default :
					return "error";
			}
		}

		// If absolute = true, pitch classes outside the octave (e.g. Cb, Bx) will be returned
		// as absolute numbers (e.g. Cb = 11, Bx = 2 rather than Cb = -1 and Bx = 13)
		private function getPitchClass(myLetter:int,accidentalInt:int,absolute:Boolean):int
		{
			var pitchClass:int;

			switch (intToLetter(myLetter))
			{
				case "A" :
					pitchClass = 9 + accidentalInt;
					break;
				case "B" :
					pitchClass = 11 + accidentalInt;
					break;
				case "C" :
					pitchClass = 0 + accidentalInt;
					break;
				case "D" :
					pitchClass = 2 + accidentalInt;
					break;
				case "E" :
					pitchClass = 4 + accidentalInt;
					break;
				case "F" :
					pitchClass = 5 + accidentalInt;
					break;
				case "G" :
					pitchClass = 7 + accidentalInt;
					break;
				default :
					pitchClass = 0;
			}

			if (absolute)
			{
				if ((pitchClass < 0))
				{
					pitchClass +=  12;
				}
				else if ((pitchClass > 11))
				{
					pitchClass -=  12;
				}
			}

			return pitchClass;
		}

		// Checks if both notes fit on one staff. 
		//Returns 1 if treble, -1 if bass, 0 if grand staff only
		public function notesFitInStaff(notes:Array,chosenClef:String):String
		{
			var fitInTreble:Boolean = true;
			var fitInBass:Boolean = true;
			var i:int;
			for (i = 0; i < notes.length; i++)
			{
				if (Note(notes[i]).greaterThanLetterRegister("E",3) < 0)
				{
					fitInTreble = false;
				}
			}

			for (i = 0; i < notes.length; i++)
			{
				if (Note(notes[i]).greaterThanLetterRegister("A",4) > 0)
				{
					fitInBass = false;
				}
			}
			if ((fitInTreble && fitInBass))
			{
				return chosenClef;
			}
			if (fitInTreble)
			{
				return "treble";
			}
			if (fitInBass)
			{
				return "bass";
			}
			return "grand";
		}


	}

}