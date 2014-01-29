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

	public class KeySignature
	{

		private var KSTreble:Array;
		private var KSBass:Array;
		private var tonic:Note;
		private var isMaj:Boolean;

		public function KeySignature(myTonic:Note,isMajor:Boolean)
		{
			tonic = myTonic;
			this.isMaj = isMajor;

			KSTreble = new Array  ;
			KSBass = new Array  ;

			if (! isMajor)
			{
				myTonic = myTonic.getNoteFromInterval(new Interval("+","m",3));
			}

			switch (myTonic.getLetterAccidental())
			{
				case "Cb" :
					KSTreble.unshift(new Note("F","b",4));
					KSBass.unshift(new Note("F","b",2));
				case "Gb" :
					KSTreble.unshift(new Note("C","b",5));
					KSBass.unshift(new Note("C","b",3));
				case "Db" :
					KSTreble.unshift(new Note("G","b",4));
					KSBass.unshift(new Note("G","b",2));
				case "Ab" :
					KSTreble.unshift(new Note("D","b",5));
					KSBass.unshift(new Note("D","b",3));
				case "Eb" :
					KSTreble.unshift(new Note("A","b",4));
					KSBass.unshift(new Note("A","b",2));
				case "Bb" :
					KSTreble.unshift(new Note("E","b",5));
					KSBass.unshift(new Note("E","b",3));
				case "F" :
					KSTreble.unshift(new Note("B","b",4));
					KSBass.unshift(new Note("B","b",2));
					break;
			}

			switch (myTonic.getLetterAccidental())
			{
				case "C#" :
					KSTreble.unshift(new Note("B","#",4));
					KSBass.unshift(new Note("B","#",2));
				case "F#" :
					KSTreble.unshift(new Note("E","#",5));
					KSBass.unshift(new Note("E","#",3));
				case "B" :
					KSTreble.unshift(new Note("A","#",4));
					KSBass.unshift(new Note("A","#",2));
				case "E" :
					KSTreble.unshift(new Note("D","#",5));
					KSBass.unshift(new Note("D","#",3));
				case "A" :
					KSTreble.unshift(new Note("G","#",5));
					KSBass.unshift(new Note("G","#",3));
				case "D" :
					KSTreble.unshift(new Note("C","#",5));
					KSBass.unshift(new Note("C","#",3));
				case "G" :
					KSTreble.unshift(new Note("F","#",5));
					KSBass.unshift(new Note("F","#",3));
					break;
			}

		}

		public function getSignatureTreble():Array
		{
			return KSTreble;
		}

		public function getSignatureBass():Array
		{
			return KSBass;
		}

		// check if letter in note is in key signature
		public function isInKeySignature(note:Note,considerLetterOnly:Boolean=true):Boolean
		{
			var i:int;
			for (i = 0; i < KSTreble.length; i++)
			{
				if ((considerLetterOnly && Note(KSTreble[i]).getLetter() == note.getLetter()))
				{
					return true;
				}
				else if (! considerLetterOnly && Note(KSTreble[i]).getLetter() == note.getLetter() && Note(KSTreble[i]).getAccidental() == note.getAccidental())
				{
					return true;
				}
			}
			return false;
		}

		public function hasSharps():Boolean
		{
			if (KSTreble.length > 0)
			{
				if (Note(KSTreble[0]).getAccidental() == "#")
				{
					return true;
				}
			}
			return false;
		}

	}

}