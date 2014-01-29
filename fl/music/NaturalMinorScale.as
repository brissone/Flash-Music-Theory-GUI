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

	public class NaturalMinorScale extends MinorScale
	{

		public function NaturalMinorScale(myTonic:Note)
		{
			super(myTonic);

			var int_1:Interval = new Interval("+","P",1);
			var int_2:Interval = new Interval("+","M",2);
			var int_3:Interval = new Interval("+","m",3);
			var int_4:Interval = new Interval("+","P",4);
			var int_5:Interval = new Interval("+","P",5);
			var int_6:Interval = new Interval("+","m",6);
			var int_7:Interval = new Interval("+","m",7);
			var int_8:Interval = new Interval("+","P",8);

			intSequence.push(int_1);
			intSequence.push(int_2);
			intSequence.push(int_3);
			intSequence.push(int_4);
			intSequence.push(int_5);
			intSequence.push(int_6);
			intSequence.push(int_7);
			intSequence.push(int_8);
		}

		public override function getName()
		{
			return tonic.getLetterAccidental() + " natural minor";
		}

	}

}