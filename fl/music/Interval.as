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

	public class Interval
	{

		private var size:int;
		private var quality:String;
		private var dir:String;

		public function Interval(myDir:String,myQuality:String,mySize:int):void
		{
			this.dir = myDir;
			this.quality = myQuality;
			this.size = mySize;
		}

		public function getSize():int
		{
			return size;
		}

		public function getDir():String
		{
			return dir;
		}

		public function getQuality():String
		{
			return quality;
		}

		public function toString():String
		{
			return dir + quality + size;
		}

		public function getIntHSDelta():int
		{

			var dlta:int = 0;

			switch (size)
			{
				case 1 :
					if ((quality == "P"))
					{
						dlta = 0;
					}
					else if ((quality == "D"))
					{
						dlta = -1;
					}
					else if ((quality == "A"))
					{
						dlta = 1;
					}
					break;

				case 2 :
					if ((quality == "M"))
					{
						dlta = 2;
					}
					else if ((quality == "m"))
					{
						dlta = 1;
					}
					else if ((quality == "A"))
					{
						dlta = 3;
					}
					else if ((quality == "D"))
					{
						dlta = 0;
					}

					break;

				case 3 :
					if ((quality == "M"))
					{
						dlta = 4;
					}
					else if ((quality == "m"))
					{
						dlta = 3;
					}
					else if ((quality == "A"))
					{
						dlta = 5;
					}
					else if ((quality == "D"))
					{
						dlta = 2;
					}
					break;

				case 4 :
					if ((quality == "P"))
					{
						dlta = 5;
					}
					else if ((quality == "D"))
					{
						dlta = 4;
					}
					else if ((quality == "A"))
					{
						dlta = 6;
					}
					break;

				case 5 :
					if ((quality == "P"))
					{
						dlta = 7;
					}
					else if ((quality == "D"))
					{
						dlta = 6;
					}
					else if ((quality == "A"))
					{
						dlta = 8;
					}
					break;

				case 6 :
					if ((quality == "M"))
					{
						dlta = 9;
					}
					else if ((quality == "m"))
					{
						dlta = 8;
					}
					else if ((quality == "A"))
					{
						dlta = 10;
					}
					else if ((quality == "D"))
					{
						dlta = 7;
					}

					break;

				case 7 :
					if ((quality == "M"))
					{
						dlta = 11;
					}
					else if ((quality == "m"))
					{
						dlta = 10;
					}
					else if ((quality == "A"))
					{
						dlta = 12;
					}
					else if ((quality == "D"))
					{
						dlta = 9;
					}

					break;

				case 8 :
					if ((quality == "P"))
					{
						dlta = 12;
					}
					else if ((quality == "D"))
					{
						dlta = 11;
					}
					else if ((quality == "A"))
					{
						dlta = 13;
					}
					break;

				case 9 :
					if ((quality == "M"))
					{
						dlta = 14;
					}
					else if ((quality == "m"))
					{
						dlta = 13;
					}
					else if ((quality == "A"))
					{
						dlta = 15;
					}
					else if ((quality == "D"))
					{
						dlta = 12;
					}

					break;

				case 10 :
					if ((quality == "M"))
					{
						dlta = 16;
					}
					else if ((quality == "m"))
					{
						dlta = 15;
					}
					else if ((quality == "A"))
					{
						dlta = 17;
					}
					else if ((quality == "D"))
					{
						dlta = 14;
					}
					break;

				case 11 :
					if ((quality == "P"))
					{
						dlta = 17;
					}
					else if ((quality == "D"))
					{
						dlta = 16;
					}
					else if ((quality == "A"))
					{
						dlta = 18;
					}
					break;

				case 12 :
					if ((quality == "P"))
					{
						dlta = 19;
					}
					else if ((quality == "D"))
					{
						dlta = 18;
					}
					else if ((quality == "A"))
					{
						dlta = 20;
					}
					break;

				case 13 :
					if ((quality == "M"))
					{
						dlta = 21;
					}
					else if ((quality == "m"))
					{
						dlta = 20;
					}
					else if ((quality == "A"))
					{
						dlta = 22;
					}
					else if ((quality == "D"))
					{
						dlta = 19;
					}

					break;

				default :
					dlta = 0;
			}

			if (this.dir == "-")
			{
				dlta =  -  dlta;
			}

			return dlta;
		}


	}

}