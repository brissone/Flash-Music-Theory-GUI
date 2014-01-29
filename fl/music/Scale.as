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

	public class Scale
	{

		protected var tonic:Note;
		protected var intSequence:Array;

		public function Scale(myTonic:Note):void
		{
			this.tonic = myTonic;
			intSequence = new Array  ;
		}

		public function getScaleDegree(degree:int,alteration:int=0):Note
		{
			var myNote:Note;
			myNote = this.tonic.getNoteFromInterval(Interval(intSequence[degree - 1]));
			myNote.alter(alteration);
			return myNote;
		}

		public function getScaleDegrees():Array
		{
			var degrees:Array = new Array  ;
			degrees.push(getScaleDegree(1));
			degrees.push(getScaleDegree(2));
			degrees.push(getScaleDegree(3));
			degrees.push(getScaleDegree(4));
			degrees.push(getScaleDegree(5));
			degrees.push(getScaleDegree(6));
			degrees.push(getScaleDegree(7));
			degrees.push(getScaleDegree(8));
			return degrees;
		}

		// overridden in subclasses
		public function getName()
		{
			return "";
		}

	}

}