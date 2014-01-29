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

package fl.music {
	
	import flash.display.Sprite;
	import flash.display.CapsStyle;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;


	public class Staff extends Sprite {
		
		// --------------------------------------------- 
		//					CONSTANTS 
		// --------------------------------------------- 
		   
		protected const padding:int = 3;
		protected const lineDistance:int = 10;
		protected const slineWeight = 1;
		protected const clefWidth:int = 30;
		protected const accidentalDistance:int = 12;
		protected const maxAccidentalWidth = 16;
		protected const firstAccidentalColumnOffset = 4;
		protected const maxNoteheadsBetweenStaves:int = 8;
		protected const ledgerLineWidth = 20;
		protected const ledgerLimitAboveTreble:Note = new Note("G", "x", 5);
		protected const ledgerLimitBelowTreble:Note = new Note("D", "", 4);
		protected const ledgerLimitAboveBass:Note = new Note("B", "", 3);
		protected const ledgerLimitBelowBass:Note = new Note("F", "", 2);
		
		// --------------------------------------------- 
		//			      CLASS VARIABLES 
		// --------------------------------------------- 
		
		protected var keySign:KeySignature;
		protected var inputParams:Array;
		protected var inputColumnWidth:int = 85;
		protected var type:String;
		protected var stateArray:Array;
		protected var outputArray:Array;
		protected var hotSpotLocationArray:Array = new Array();
		protected var noteheadHolder:Bitmap;
		protected var sharpHolder:Bitmap;
		protected var doublesharpHolder:Bitmap;
		protected var flatHolder:Bitmap;
		protected var doubleflatHolder:Bitmap;
		protected var naturalHolder:Bitmap;
		protected var linesAboveTopStaff:Array;
		protected var linesBelowTopStaff:Array;
		protected var linesAboveBottomStaff:Array;
		protected var linesBelowBottomStaff:Array;
		protected var stageWidth:int;
		protected var stageHeight:int;
		protected var moveNoteRightOffset = 7;
		
		
		// --------------------------------------------- 
		//				   INITIALIZATION 
		// --------------------------------------------- 
		
		// Staff()
		//Type = "treble", "bass" or "grand"
		/* inputParams: Array of integers giving number of notes expected in each input column */
		public function Staff():void {

		}
		
		// setParams()
		public function setParams(type:String, keySign:KeySignature, inputParams:Array, inputColWidth:int, 
								  stageWidth:int = 550, stageHeight:int = 400):void {
			this.type = type;
			this.keySign = keySign;
			this.inputParams = inputParams;
			this.inputColumnWidth = inputColWidth;
			outputArray = new Array(inputParams.length);
			var i:int;
			for (i=0; i < outputArray.length; i++) {
				outputArray[i] = new Array();
			}
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
		}
		
		// initState()
		// Creates Array containing hotspots. Must be called after Staff is in display list
		protected function initState() {
			
			stateArray = new Array(inputParams.length);
			
			linesAboveTopStaff = new Array(inputParams.length);
			linesBelowTopStaff = new Array(inputParams.length);
			linesAboveBottomStaff = new Array(inputParams.length);
			linesBelowBottomStaff = new Array(inputParams.length);
			
			
			
			var i:int;
			for (i = 0; i<inputParams.length; i++) {
				stateArray[i] = new Array();
				
				if (type == "bass") {
					(stateArray[i] as Array).push(new Array());
					(stateArray[i][0] as Array).push(new Array());
					stateArray[i][0][0] = addHotSpots("bass", stateArray[i][0][0], i, 0);
					
					
				}
				else {
					(stateArray[i] as Array).push(new Array());
					(stateArray[i][0] as Array).push(new Array());
					stateArray[i][0][0] = addHotSpots("treble", stateArray[i][0][0], i, 0);
					
				}
				
				if (type == "grand") {
					(stateArray[i] as Array).push(new Array());
					(stateArray[i][1] as Array).push(new Array());
					stateArray[i][1][0] = addHotSpots("bass", stateArray[i][1][0], i, 1);
				}	
				
				 
			}
			
			i -= i;
			// Add hotspot over input area for mouse cursor
			var ulc:Point = new Point(Sprite(stateArray[0][0][0][stateArray[0][0][0].length - 1][2]).x, 
									   Sprite(stateArray[0][0][0][stateArray[0][0][0].length - 1][2]).y);
			var width_:int = inputParams.length * inputColumnWidth + 100;
			var height_:int = Sprite(stateArray[i][stateArray[i].length-1][0][0][2]).y - 
							  ulc.y + 100;
			
			var spot:Sprite = new Sprite();
			spot.y = ulc.y - 50;
			spot.x = ulc.x - 50;
			parent.addChild(spot); 
			parent.setChildIndex(spot, 0);
			spot.graphics.lineStyle(0, 0, 0);
			spot.graphics.beginFill(0x222222, 0);
			spot.graphics.drawRect(0, 0, width_, height_); 
    		spot.graphics.endFill();
			spot.addEventListener(MouseEvent.ROLL_OVER, mouseShow);
		}
		
		// addHotSpots()
		protected function addHotSpots(clef:String, noteParamArray:Array, inputColumn:int, staff:int):Array {
			var whiteNotes:Array = getWhiteNotes(clef);
			var j:int;
			var ulCorner:Point = getULCorner();
			if (clef == "bass" && this.type == "grand") {
				ulCorner.y = ulCorner.y + (4 + maxNoteheadsBetweenStaves) * lineDistance;
			}
			
			var spotY:int;
			if (clef == "bass") {
				spotY = ulCorner.y + (lineDistance * 8.25);
			}
			else {
				spotY = ulCorner.y + (lineDistance * 7.25);
			}
			var color:Boolean = false;
			for (j = 0; j < whiteNotes.length; j++) {
				
						
				// Add hotspot
				var spot:Sprite = new Sprite();
						
				spot.y = spotY;
				spot.x = getColumnX(inputColumn)
				parent.addChild(spot); 
				spot.graphics.lineStyle(0, 0, 0);
				if (color) {
    				spot.graphics.beginFill(0, 0); 
					color = false;
				}
				else {
					spot.graphics.beginFill(0, 0);
					color = true;
				}
				spot.graphics.drawRect(0, 0, inputColumnWidth, lineDistance/2); 
    			spot.graphics.endFill();
				
				spot.addEventListener(MouseEvent.ROLL_OVER, noteRollOver);
				spot.addEventListener(MouseEvent.ROLL_OUT, noteRollOut);
				spot.addEventListener(MouseEvent.MOUSE_DOWN, noteMouseDown)
				
				noteParamArray.push(new Array(whiteNotes[j], inputColumn, spot, clef));
				hotSpotLocationArray[spot.x + "-" + spot.y] = new Array(inputColumn, staff, j);
				spotY -= lineDistance/2;
					
			}
			
			return noteParamArray;
		}
		
		// --------------------------------------------- 
		//				   EVENT HANDLING 
		// --------------------------------------------- 
		
		protected function mouseShow(event:MouseEvent):void { 
			Mouse.show();
		}
		
		protected function noteAlreadyInOutput(note:Note, inputColumn:int, clef:String):Note {
			var i:int;
			var n:Note;
			var noteAlreadyIn:Boolean = false;
			for (i=0; i<outputArray[inputColumn].length; i++) {
				n = Note(outputArray[inputColumn][i][0]);
				if (note.greaterThanLetterRegister(n.getLetter(), n.getRegister()) == 0 && 
					clef == String(outputArray[inputColumn][i][2])) {
					return n;
				}
						
			}
			return note;
		}
		
		// noteMouseDown()
		protected function noteMouseDownParam(event:MouseEvent):void { 
			var noteArray:Array = getNoteArrayFromSpot(Sprite(event.target));
			var note:Note = noteArray[0];
			var inputCol:int = noteArray[1];
			var clef:String = noteArray[3];
			
			switch (AccidentalToolbar(MovieClip(parent).accToolbar).accidentalSelected()) {
				case 1:
					note = new Note(note.getLetter(), "#", note.getRegister());
					break;
				case 2:
					note = new Note(note.getLetter(), "x", note.getRegister());
					break;
				case -1:
					note = new Note(note.getLetter(), "b", note.getRegister());
					break;
				case -2:
					note = new Note(note.getLetter(), "bb", note.getRegister());
					break;
				case 0:
					note = new Note(note.getLetter(), "", note.getRegister());
					break;
				default:
					if (keySign.isInKeySignature(note, true)){
						if (keySign.hasSharps()) {
							note = new Note(note.getLetter(), "#", note.getRegister());
						}
						else {
							note = new Note(note.getLetter(), "b", note.getRegister());
						}
					}
					break;
			}
			
			
			if (!inputColumnIsFull(inputCol, clef)) {
				var spot:Sprite = Sprite(event.target);
				var center:Point = new Point(spot.x + spot.width/2, spot.y + spot.height/2);
				var noteBitmapArray:Array = getNoteBitmapArray(note, "", center, inputCol); 
				
				var i:int;
				for (i=0; i<noteBitmapArray.length; i++) {
					if (noteBitmapArray[i] is Bitmap) {
						parent.addChild(Bitmap(noteBitmapArray[i]));
						parent.setChildIndex(Bitmap(noteBitmapArray[i]), 0);
					}
					else if (noteBitmapArray[i] is Sprite) {
						var bm:Sprite = Sprite(noteBitmapArray[i]);
						parent.addChild(bm);
						parent.setChildIndex(bm, 0);
					}
				}
				
				note = noteAlreadyInOutput(note, inputCol, clef);
				addNoteToOutput(note, inputCol, clef, noteBitmapArray, true);
				rearrangeOutputColumn(inputCol);
				
			}
			else {
				removeNoteFromOutput(note, inputCol, clef, true);
				rearrangeOutputColumn(inputCol);
			}
			
			
		}
		
		// noteMouseDown()
		protected function noteMouseDown(event:MouseEvent):void { 
			var noteArray:Array = getNoteArrayFromSpot(Sprite(event.target));
			var note:Note = noteArray[0];
			var inputCol:int = noteArray[1];
			var clef:String = noteArray[3];
			
			switch (AccidentalToolbar(MovieClip(parent).accToolbar).accidentalSelected()) {
				case 1:
					note = new Note(note.getLetter(), "#", note.getRegister());
					break;
				case 2:
					note = new Note(note.getLetter(), "x", note.getRegister());
					break;
				case -1:
					note = new Note(note.getLetter(), "b", note.getRegister());
					break;
				case -2:
					note = new Note(note.getLetter(), "bb", note.getRegister());
					break;
				case 0:
					note = new Note(note.getLetter(), "", note.getRegister());
					break;
				default:
					if (keySign.isInKeySignature(note, true)){
						if (keySign.hasSharps()) {
							note = new Note(note.getLetter(), "#", note.getRegister());
						}
						else {
							note = new Note(note.getLetter(), "b", note.getRegister());
						}
					}
					break;
			}
			
			
			if (!noteInOutput(note, inputCol, clef, true) && !inputColumnIsFull(inputCol, clef)) {
				var spot:Sprite = Sprite(event.target);
				var center:Point = new Point(spot.x + spot.width/2, spot.y + spot.height/2);
				var noteBitmapArray:Array = getNoteBitmapArray(note, "", center, inputCol); 
				
				var i:int;
				for (i=0; i<noteBitmapArray.length; i++) {
					if (noteBitmapArray[i] is Bitmap) {
						parent.addChild(Bitmap(noteBitmapArray[i]));
						parent.setChildIndex(Bitmap(noteBitmapArray[i]), 0);
					}
					else if (noteBitmapArray[i] is Sprite) {
						var bm:Sprite = Sprite(noteBitmapArray[i]);
						parent.addChild(bm);
						parent.setChildIndex(bm, 0);
					}
				}
				
				note = noteAlreadyInOutput(note, inputCol, clef);
				addNoteToOutput(note, inputCol, clef, noteBitmapArray, false);
				rearrangeOutputColumn(inputCol);
				Mouse.show();
			}
			else {
				removeNoteFromOutput(note, inputCol, clef, true);
				rearrangeOutputColumn(inputCol);
			}
			
			
		}
		
		
		// noteRollOver()
		protected function noteRollOverLocked(event:MouseEvent):void {
			Mouse.show();
			
		}
		
		protected function noteRollOver(event:MouseEvent):void { 
			
			var spot:Sprite = Sprite(event.target);
			var noteArray:Array = getNoteArrayFromSpot(spot);
			var col:int = int(noteArray[1]);
			var note:Note = Note(noteArray[0]);
			var clef:String = String(noteArray[3]);
			
			if (inputColumnIsFull(col) || noteInOutput(note, col, clef, true)) {
				Mouse.show();
				return;
			}
			
			Mouse.hide();
			
			// Show notehead
            noteheadHolder.x = spot.x + spot.width/2 - noteheadHolder.width/2;
			noteheadHolder.y = spot.y + spot.height/2 - noteheadHolder.height/2;
			noteheadHolder.visible = true;
			
			
			
			switch (AccidentalToolbar(MovieClip(parent).accToolbar).accidentalSelected()) {
				case 0:
					if (keySign.isInKeySignature(note)) {
						naturalHolder.x = spot.x + spot.width/2  - firstAccidentalColumnOffset - maxAccidentalWidth - naturalHolder.width/2;
						naturalHolder.y = spot.y + spot.height/2 - naturalHolder.height/2;
						naturalHolder.visible = true;
					}
					break;
				case 1:
					if (!keySign.isInKeySignature(new Note(note.getLetter(), "#", note.getRegister()), false)) {
						sharpHolder.x = spot.x + Math.floor(spot.width/2) - firstAccidentalColumnOffset - maxAccidentalWidth - sharpHolder.width/2;
						sharpHolder.y = spot.y + spot.height/2 - sharpHolder.height/2;
						sharpHolder.visible = true;
					}
					break;
				case -1:
					if (!keySign.isInKeySignature(new Note(note.getLetter(), "b", note.getRegister()), false)) {
						flatHolder.x = spot.x + spot.width/2 -  firstAccidentalColumnOffset - maxAccidentalWidth - flatHolder.width/2;
						flatHolder.y = spot.y + spot.height/2 - flatHolder.height/2;
						flatHolder.visible = true;
					}
					break;
				case 2:
					doublesharpHolder.x = spot.x + spot.width/2 - firstAccidentalColumnOffset - maxAccidentalWidth - doublesharpHolder.width/2;
					doublesharpHolder.y = spot.y + spot.height/2 - doublesharpHolder.height/2;
					doublesharpHolder.visible = true;
					break;
				case -2:
					doubleflatHolder.x = spot.x + spot.width/2 - firstAccidentalColumnOffset - maxAccidentalWidth - doubleflatHolder.width/2;
					doubleflatHolder.y = spot.y + spot.height/2 - doubleflatHolder.height/2;
					doubleflatHolder.visible = true;
					break;
				default:
					break;
				
			}
		
			
			
			if (String(noteArray[3]) == "treble") {
				if (ledgerLimitAboveTreble.greaterThan(Note(noteArray[0]), true) > 0) {
					
					switch (Note(noteArray[0]).getLetter()) {
						case "A":
						case "B":
							
							if (Note(noteArray[0]).getRegister() < 6) {
								showHideLines(linesAboveTopStaff[noteArray[1]], 1, true);
							}
							else {
								showHideLines(linesAboveTopStaff[noteArray[1]], 4, true);	
							}
							break;
						
						case "C": 
						case "D":
							showHideLines(linesAboveTopStaff[noteArray[1]], 2, true);
							break;
						case "E":
						case "F":
							showHideLines(linesAboveTopStaff[noteArray[1]], 3, true);
							break;
						case "G":
							showHideLines(linesAboveTopStaff[noteArray[1]], 4, true);
							break;
					}
				}
				else if (ledgerLimitBelowTreble.greaterThan(Note(noteArray[0]), true) < 0) {
					
					switch (Note(noteArray[0]).getLetter()) {
						case "E":
						case "F":
								showHideLines(linesBelowTopStaff[noteArray[1]], 3, true);
							break;
						case "G": 
						case "A":
							showHideLines(linesBelowTopStaff[noteArray[1]], 2, true);
							break;
						case "B":
						case "C":
							showHideLines(linesBelowTopStaff[noteArray[1]], 1, true);
							break;
					}
				}
				
			}
			
			else if (String(noteArray[3]) == "bass") {
				if (ledgerLimitAboveBass.greaterThan(Note(noteArray[0]), true) > 0) {
					
					switch (Note(noteArray[0]).getLetter()) {
						case "C":
						case "D":
							showHideLines(linesAboveBottomStaff[noteArray[1]], 1, true);
							break;
						case "E": 
						case "F":
							showHideLines(linesAboveBottomStaff[noteArray[1]], 2, true);
							break;
						case "G":
						case "A":
							showHideLines(linesAboveBottomStaff[noteArray[1]], 3, true);
							break;
					}
				}
				else if (ledgerLimitBelowBass.greaterThan(Note(noteArray[0]), true) < 0) {
					
					switch (Note(noteArray[0]).getLetter()) {
						case "E":
							if (Note(noteArray[0]).getRegister() > 1) {
								showHideLines(linesBelowBottomStaff[noteArray[1]], 1, true);
							}
							else {
								showHideLines(linesBelowBottomStaff[noteArray[1]], 4, true);
							}
						case "D":
							showHideLines(linesBelowBottomStaff[noteArray[1]], 1, true);
							break;
						case "C": 
						case "B":
							showHideLines(linesBelowBottomStaff[noteArray[1]], 2, true);
							break;
						case "A":
						case "G":
							showHideLines(linesBelowBottomStaff[noteArray[1]], 3, true);
							break;
						case "F":
							showHideLines(linesBelowBottomStaff[noteArray[1]], 4, true);
							break;
					}
				}
				
			}
			
    	} 
		
		// noteRollOut()
		protected function noteRollOut(event:MouseEvent):void {
			//Mouse.show();
			
			noteheadHolder.visible = false;
			switch (AccidentalToolbar(MovieClip(parent).accToolbar).accidentalSelected()) {
				case 0:
					naturalHolder.visible = false;
					break;
				case 1:
					sharpHolder.visible = false;
					break;
				case -1:
					flatHolder.visible = false;
					break;
				case 2:
					doublesharpHolder.visible = false;
					break;
				case -2:
					doubleflatHolder.visible = false;
					break;
			}
			
			
			var spot:Sprite = Sprite(event.target);
			var locationArray:Array = hotSpotLocationArray[spot.x + "-" + spot.y] as Array;
			var noteArray:Array =  (stateArray [locationArray[0]] [locationArray[1]] [0] [locationArray[2]]) as Array;
			
			if (String(noteArray[3]) == "treble") {
				if (ledgerLimitAboveTreble.greaterThan(Note(noteArray[0]), true) > 0) {
					switch (Note(noteArray[0]).getLetter()) {
						case "A":
						case "B":
							
							if (Note(noteArray[0]).getRegister() < 6) {
								showHideLines(linesAboveTopStaff[noteArray[1]], 1, false);
							}
							else {
								showHideLines(linesAboveTopStaff[noteArray[1]], 4, false);	
							}
							break;
						
						case "C": 
						case "D":
							showHideLines(linesAboveTopStaff[noteArray[1]], 2, false);
							break;
						case "E":
						case "F":
							showHideLines(linesAboveTopStaff[noteArray[1]], 3, false);
							break;
						case "G":
							showHideLines(linesAboveTopStaff[noteArray[1]], 4, false);
							break;
					}
					
				}
				else if (ledgerLimitBelowTreble.greaterThan(Note(noteArray[0]), false) < 0) {
					
					switch (Note(noteArray[0]).getLetter()) {
						case "E":
						case "F":
								showHideLines(linesBelowTopStaff[noteArray[1]], 3, false);
							break;
						case "G": 
						case "A":
							showHideLines(linesBelowTopStaff[noteArray[1]], 2, false);
							break;
						case "B":
						case "C":
							showHideLines(linesBelowTopStaff[noteArray[1]], 1, false);
							break;
				}
					
				}
				
				
			}
			
			else if (String(noteArray[3]) == "bass") {
				if (ledgerLimitAboveBass.greaterThan(Note(noteArray[0]), true) > 0) {
					
					switch (Note(noteArray[0]).getLetter()) {
						case "C":
						case "D":
							showHideLines(linesAboveBottomStaff[noteArray[1]], 1, false);
							break;
						case "E": 
						case "F":
							showHideLines(linesAboveBottomStaff[noteArray[1]], 2, false);
							break;
						case "G":
						case "A":
							showHideLines(linesAboveBottomStaff[noteArray[1]], 3, false);
							break;
					}
				}
				else if (ledgerLimitBelowBass.greaterThan(Note(noteArray[0]), false) < 0) {
					
					switch (Note(noteArray[0]).getLetter()) {
						case "E":
							if (Note(noteArray[0]).getRegister() > 1) {
								showHideLines(linesBelowBottomStaff[noteArray[1]], 1, false);
							}
							else {
								showHideLines(linesBelowBottomStaff[noteArray[1]], 4, false);
							}
						case "D":
							showHideLines(linesBelowBottomStaff[noteArray[1]], 1, false);
							break;
						case "C": 
						case "B":
							showHideLines(linesBelowBottomStaff[noteArray[1]], 2, false);
							break;
						case "A":
						case "G":
							showHideLines(linesBelowBottomStaff[noteArray[1]], 3, false);
							break;
						case "F":
							showHideLines(linesBelowBottomStaff[noteArray[1]], 4, false);
							break;
					}
				}
				
			}
			
			
			
		}
		
		// --------------------------------------------- 
		//				   DRAWING 
		// ---------------------------------------------
		
		// render()
		public function render():void {

			initState();
			
			drawStaves();
			
			
			
			
			// add selecting notehead
			noteheadHolder = new Bitmap();
			var my_notehead:wholenote = new wholenote(44, 28);//pass the width and height of the bitmap
			noteheadHolder.bitmapData = my_notehead;
			noteheadHolder.visible = false;
			parent.addChild(noteheadHolder);
			parent.setChildIndex(noteheadHolder, 0);
			
			// add selecting sharp
			sharpHolder = new Bitmap();
			var mySharp:sharp = new sharp(44, 28);//pass the width and height of the bitmap
			sharpHolder.bitmapData = mySharp;
			sharpHolder.visible = false;
			parent.addChild(sharpHolder);
			parent.setChildIndex(sharpHolder, 0);
			
			// add selecting doublesharp
			doublesharpHolder = new Bitmap();
			var mydoubleSharp:doublesharp = new doublesharp(44, 28);//pass the width and height of the bitmap
			doublesharpHolder.bitmapData = mydoubleSharp;
			doublesharpHolder.visible = false;
			parent.addChild(doublesharpHolder);
			parent.setChildIndex(doublesharpHolder, 0);
			
			// add selecting flat
			flatHolder = new Bitmap();
			var myFlat:flat = new flat(44, 28);//pass the width and height of the bitmap
			flatHolder.bitmapData = myFlat;
			flatHolder.visible = false;
			parent.addChild(flatHolder);
			parent.setChildIndex(flatHolder, 0);
			
			// add selecting doubleflat
			doubleflatHolder = new Bitmap();
			var mydoubleFlat:doubleflat = new doubleflat(44, 28);//pass the width and height of the bitmap
			doubleflatHolder.bitmapData = mydoubleFlat;
			doubleflatHolder.visible = false;
			parent.addChild(doubleflatHolder);
			parent.setChildIndex(doubleflatHolder, 0);
			
			// add selecting natural
			naturalHolder = new Bitmap();
			var myNatural:natural = new natural(44, 28);//pass the width and height of the bitmap
			naturalHolder.bitmapData = myNatural;
			naturalHolder.visible = false;
			parent.addChild(naturalHolder);
			parent.setChildIndex(naturalHolder, 0);
			
			// Add all notes given in constructor parameters
			var i:int;
			var j:int;
			for (i=0; i<inputParams.length; i++) {
				if (inputParams[i].length > 2) {
					for (j=2; j<inputParams[i].length; j++) {
						addParameterNote(Note(inputParams[i][j]), i);
					}
				}
			}
			
		} 
		
		// Add input parameter notes
		protected function addParameterNote(note:Note, inputCol:int, staff:String = "treble") {
			
			var notes:Array;
			if (stateArray[inputCol].length > 1) {
				if (staff == "bass") {
					notes = stateArray[inputCol][1][0].concat(stateArray[inputCol][0][0]);
				}
				else {
					notes = stateArray[inputCol][0][0].concat(stateArray[inputCol][1][0]);
				}
			}
			else {
				notes = stateArray[inputCol][0][0];
			}
			var i:int;
			var arrayNote:Note;
			
			for (i=0; i<notes.length; i++) {
				arrayNote = Note(notes[i][0]);
				if (arrayNote.getLetter() == note.getLetter() && 
					arrayNote.getRegister() == note.getRegister()) {
					var sp:Sprite = Sprite(notes[i][2]);
					AccidentalToolbar(MovieClip(parent).accToolbar).clickButton(note.getAccidentalInt());
					sp.removeEventListener(MouseEvent.MOUSE_DOWN, noteMouseDown);
					sp.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
					sp.addEventListener(MouseEvent.MOUSE_DOWN, noteMouseDownParam);
					// Rollover hides mouse
					Mouse.show();
					sp.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					sp.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
					sp.removeEventListener(MouseEvent.MOUSE_DOWN, noteMouseDownParam);
					
					AccidentalToolbar(MovieClip(parent).accToolbar).clickButton(note.getAccidentalInt());
					break;
				}
				
			}
			
		}
		
		// Add input parameter notes
		public function addNonParameterNote(note:Note, inputCol:int, staff:String = "treble") {
			
			var notes:Array;
			
			if (type == "grand") {
				if (staff == "bass") {
					notes = stateArray[inputCol][1][0].concat(stateArray[inputCol][0][0]);
				}
				else {
					notes = stateArray[inputCol][0][0].concat(stateArray[inputCol][1][0]);
				}
			}
			else {
					notes = stateArray[inputCol][0][0];
			}
			
			var i:int;
			var arrayNote:Note;
			
			for (i=0; i<notes.length; i++) {
				arrayNote = Note(notes[i][0]);
				if (arrayNote.getLetter() == note.getLetter() && 
					arrayNote.getRegister() == note.getRegister()) {
					var sp:Sprite = Sprite(notes[i][2]);
					AccidentalToolbar(MovieClip(parent).accToolbar).clickButton(note.getAccidentalInt());
					sp.removeEventListener(MouseEvent.ROLL_OVER, noteRollOverLocked);
					sp.addEventListener(MouseEvent.ROLL_OVER, noteRollOver);
					sp.addEventListener(MouseEvent.ROLL_OUT, noteRollOut);
					sp.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
					// Rollover hides mouse
					Mouse.show();
					sp.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					sp.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
					AccidentalToolbar(MovieClip(parent).accToolbar).clickButton(note.getAccidentalInt());
					break;
				}
				
			}
			
		}
		
		
		// drawStaves()
		protected function drawStaves():void {
			
			var ulCorner:Point = getULCorner();
			
			// Draw first staff (there will always be one)
			
			if (this.type == "bass") {
				drawStaff(ulCorner, "bass");
			}
			else {
				drawStaff(ulCorner, "treble");
			}
			
			// Draw bass staff if grand staff
			if (type == "grand") {
				ulCorner.y = ulCorner.y + lineDistance * 4 + lineDistance * maxNoteheadsBetweenStaves;
				drawStaff(ulCorner, "bass");;
			}
			
			ulCorner = getULCorner();
			
			var slineLeft:Sprite = new Sprite();
			var slineRight1:Sprite = new Sprite();
			var slineRight2:Sprite = new Sprite();
			
			slineLeft.graphics.lineStyle(slineWeight);  
			slineLeft.x = ulCorner.x;
			slineLeft.y = ulCorner.y; 
			slineLeft.graphics.lineTo(0, getSystemHeight());
			
			slineRight1.graphics.lineStyle(slineWeight+4, 1, 1.0, false, "normal", CapsStyle.NONE);  
			slineRight1.x = ulCorner.x + getSystemWidth();
			slineRight1.y = ulCorner.y; 
			slineRight1.graphics.lineTo(0, getSystemHeight()+1);
			
			slineRight2.graphics.lineStyle(slineWeight);  
			slineRight2.x = ulCorner.x + getSystemWidth() - 7;
			slineRight2.y = ulCorner.y; 
			slineRight2.graphics.lineTo(0, getSystemHeight());
			
			parent.addChild(slineLeft);
			parent.setChildIndex(slineLeft, 0);
			parent.addChild(slineRight1);
			parent.setChildIndex(slineRight1, 0);
			parent.addChild(slineRight2);
			parent.setChildIndex(slineRight2, 0);
			
		}
		
		// drawStaff()
		// clef = "treble" or "bass"
		protected function drawStaff(ulCorner:Point, clef:String):void {
			var sWidth:int = getSystemWidth();
			var sline4:Sprite = new Sprite();
			var sline3:Sprite = new Sprite();
			var sline2:Sprite = new Sprite();
			var sline1:Sprite = new Sprite();
			var sline0:Sprite = new Sprite();
			
			sline4.graphics.lineStyle(slineWeight);  
			sline4.x = ulCorner.x;
			sline4.y = ulCorner.y;		 
			sline4.graphics.lineTo(sWidth, 0);
	
			sline3.graphics.lineStyle(slineWeight);  
			sline3.x = ulCorner.x;
			sline3.y = ulCorner.y + lineDistance;		 
			sline3.graphics.lineTo(sWidth, 0);
	
			sline2.graphics.lineStyle(slineWeight);  
			sline2.x = ulCorner.x;
			sline2.y = ulCorner.y + lineDistance*2;		 
			sline2.graphics.lineTo(sWidth, 0);
	
			sline1.graphics.lineStyle(slineWeight);  
			sline1.x = ulCorner.x;
			sline1.y = ulCorner.y + lineDistance*3;		 
			sline1.graphics.lineTo(sWidth, 0);
	
			sline0.graphics.lineStyle(slineWeight);  
			sline0.x = ulCorner.x;
			sline0.y = ulCorner.y + lineDistance*4;		 
			sline0.graphics.lineTo(sWidth, 0);
			
			
			
	
			parent.addChild(sline4);
			parent.addChild(sline3);
			parent.addChild(sline2);
			parent.addChild(sline1);
			parent.addChild(sline0);
			
			parent.setChildIndex(sline0, 0);
			parent.setChildIndex(sline1, 0);
			parent.setChildIndex(sline2, 0);
			parent.setChildIndex(sline3, 0);
			parent.setChildIndex(sline4, 0);
			
			
			// Add clef
			if (clef == "treble") {
				var t_clef_holder:Bitmap = new Bitmap();
				var my_t_clef:t_clef = new t_clef(169, 412);//pass the width and height of the bitmap
				t_clef_holder.bitmapData = my_t_clef;
				t_clef_holder.x = getClefX();
				t_clef_holder.y = ulCorner.y + lineDistance*2 - t_clef_holder.height/2;
				parent.addChild(t_clef_holder);
				parent.setChildIndex(t_clef_holder, 0);
			 
			}
			else {
				var b_clef_holder:Bitmap = new Bitmap();
				var my_b_clef:b_clef = new b_clef(27, 34);//pass the width and height of the bitmap
				b_clef_holder.bitmapData = my_b_clef;
				b_clef_holder.x = getClefX() + padding;
				b_clef_holder.y = ulCorner.y;
				parent.addChild(b_clef_holder);
				parent.setChildIndex(b_clef_holder, 0);
			}
			
			// Add key signature
			addKeySignature(clef, new Point(getKSX(), ulCorner.y));
			
			// Add rollover ledger lines
			var i:int;
			var linesAbove:Array;
			var linesBelow:Array;
			for (i=0; i < inputParams.length; i++) {
				if (clef == "treble") {
					linesAboveTopStaff[i] = createLedgerLines(4, ulCorner.y - lineDistance, 
													getColumnX(i) + inputColumnWidth/2, true); 
					linesBelowTopStaff[i] = createLedgerLines(3, ulCorner.y + lineDistance * 7, 
													getColumnX(i) + inputColumnWidth/2, false); 
				}
				else {
					linesAboveBottomStaff[i] = createLedgerLines(3, ulCorner.y - lineDistance, 
													getColumnX(i) + inputColumnWidth/2, true); 
					linesBelowBottomStaff[i] = createLedgerLines(4, ulCorner.y + lineDistance * 8, 
													getColumnX(i) + inputColumnWidth/2, false);
				}
				
			}
			
		}
		
		// addKeySignature()
		// Adds a keysign on a single staff. ulCorner = upper left corner of key signature start
		protected function addKeySignature(clef:String, ulCorner:Point):void {
			
			var myAcc:Array = keySign.getSignatureTreble();
			var accType:String = "flat";
			if (myAcc.length > 0) {
				if (Note(myAcc[0]).getAccidental() == "#") {
					accType = "sharp";
				}
			}
			var accY:int;
			if (clef == "treble") {
				switch (myAcc.length) {
					case 7:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 2: ulCorner.y + lineDistance * 3.5;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 6 + accidentalDistance/2, accY), accType);
					case 6:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 0.5: ulCorner.y + lineDistance * 1.5;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 5 + accidentalDistance/2, accY), accType);
					case 5:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 2.5: ulCorner.y + lineDistance * 3;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 4 + accidentalDistance/2, accY), accType);
					case 4:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 1: ulCorner.y + lineDistance * 1;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 3 + accidentalDistance/2, accY), accType);
					case 3:
						accY = (accType == "sharp") ? ulCorner.y - lineDistance * 0.5: ulCorner.y + lineDistance * 2.5;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 2 + accidentalDistance/2, accY), accType);
					case 2:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 1.5: ulCorner.y + lineDistance * 0.5;
						addAccidental(new Point(ulCorner.x + accidentalDistance + accidentalDistance/2, accY), accType);
					case 1:
						accY = (accType == "sharp") ? ulCorner.y: ulCorner.y + lineDistance * 2;
						addAccidental(new Point(ulCorner.x + accidentalDistance/2, accY), accType);
				}
			}
			else if (clef == "bass") {
				switch (myAcc.length) {
					case 7:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 3: ulCorner.y + lineDistance * 4.5;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 6 + accidentalDistance/2, accY), accType);
					case 6:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 1.5: ulCorner.y + lineDistance * 2.5;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 5 + accidentalDistance/2, accY), accType);
					case 5:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 3.5: ulCorner.y + lineDistance * 4;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 4 + accidentalDistance/2, accY), accType);
					case 4:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 2: ulCorner.y + lineDistance * 2;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 3 + accidentalDistance/2, accY), accType);
					case 3:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 0.5: ulCorner.y + lineDistance * 3.5;
						addAccidental(new Point(ulCorner.x + accidentalDistance * 2 + accidentalDistance/2, accY), accType);
					case 2:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 2.5: ulCorner.y + lineDistance * 1.5;
						addAccidental(new Point(ulCorner.x + accidentalDistance + accidentalDistance/2, accY), accType);
					case 1:
						accY = (accType == "sharp") ? ulCorner.y + lineDistance * 1: ulCorner.y + lineDistance * 3;
						addAccidental(new Point(ulCorner.x + accidentalDistance/2, accY), accType);
				}
			}
		}
		
		// addAccidental()
		// acc = "sharp", "flat", "doublesharp", "doubleflat", "natural"
		protected function addAccidental(center:Point, acc:String):Bitmap {
			var accHolder:Bitmap = new Bitmap;
			switch (acc) {
				case "sharp":
					accHolder.bitmapData = new sharp(10, 10);
					break;
				case "flat":
					accHolder.bitmapData = new flat(10, 10);
					break;
				case "doublesharp":
					accHolder.bitmapData = new doublesharp(10, 10);
					break;
				case "doubleflat":
					accHolder.bitmapData = new doubleflat(10, 10);
					break;
			}
			
			accHolder.x = center.x - accHolder.width/2;
			accHolder.y = center.y - accHolder.height/2;
			parent.addChild(accHolder);
			parent.setChildIndex(accHolder, 0);
			return accHolder;
		
		}
		
		// addNote()
		protected function getNoteBitmapArray(note:Note, accidental:String, center:Point, 
											inputColumn:int, clef:String = "treble"):Array {
				
				var sprites:Array = new Array();
				var noteHolder:Bitmap = new Bitmap();
				var myNote:wholenote = new wholenote(44, 28);
				noteHolder.bitmapData = myNote;
            	noteHolder.x = center.x - myNote.width/2;
				noteHolder.y = center.y - myNote.height/2;
				sprites.push(noteHolder);
				
				
				var accHolder:Bitmap; 
				var myAcc;
				switch (AccidentalToolbar(MovieClip(parent).accToolbar).accidentalSelected()) {
				case 0:
					if (keySign.isInKeySignature(note)) {
						accHolder = new Bitmap();
						myAcc = new natural(10, 10);
						accHolder.bitmapData = myAcc;
						accHolder.x = center.x - accHolder.width/2 - firstAccidentalColumnOffset- maxAccidentalWidth;
						accHolder.y = center.y - accHolder.height/2;
						sprites.push(accHolder);
					}
					break;
				case 1:
					if (!keySign.isInKeySignature(new Note(note.getLetter(), "#", note.getRegister()), false)) {
						accHolder = new Bitmap();
						myAcc = new sharp(10, 10);
						accHolder.bitmapData = myAcc;
						accHolder.x = center.x - accHolder.width/2 - firstAccidentalColumnOffset- maxAccidentalWidth;
						accHolder.y = center.y - accHolder.height/2;
						sprites.push(accHolder);
					}
					break;
				case -1:
					if (!keySign.isInKeySignature(new Note(note.getLetter(), "b", note.getRegister()), false)) {
						accHolder = new Bitmap();
						myAcc = new flat(10, 10);
						accHolder.bitmapData = myAcc;
						accHolder.x = center.x - accHolder.width/2 - firstAccidentalColumnOffset - maxAccidentalWidth;
						accHolder.y = center.y - accHolder.height/2;
						sprites.push(accHolder);
					}
					break;
				case 2:
					accHolder = new Bitmap();
					myAcc = new doublesharp(10, 10);
					accHolder.bitmapData = myAcc;
					accHolder.x = center.x - accHolder.width/2 - firstAccidentalColumnOffset- maxAccidentalWidth;
					accHolder.y = center.y - accHolder.height/2;
					sprites.push(accHolder);
					break;
				case -2:
					accHolder = new Bitmap();
					myAcc = new doubleflat(10, 10);
					accHolder.bitmapData = myAcc;
					accHolder.x = center.x - accHolder.width/2 - firstAccidentalColumnOffset -maxAccidentalWidth;
					accHolder.y = center.y - accHolder.height/2;
					sprites.push(accHolder);
					break;
				default:
					break;
				
				}
				
				
				sprites = sprites.concat(getCopyOfVisibleLedgerLines(linesAboveTopStaff, inputColumn));
				sprites = sprites.concat(getCopyOfVisibleLedgerLines(linesBelowTopStaff, inputColumn));
				sprites = sprites.concat(getCopyOfVisibleLedgerLines(linesAboveBottomStaff, inputColumn));
				sprites = sprites.concat(getCopyOfVisibleLedgerLines(linesBelowBottomStaff, inputColumn));
				return sprites;
		}
		
		// createLedgerLines()
		// Returns an array of sprites
		protected function createLedgerLines(numLines:int, lowY:int, centerX:int, ascending:Boolean):Array {
			// Create temporary ledger lines
			var line:Sprite;
			var arr:Array = new Array();
			var i:int;
			for (i=0; i < numLines; i++) {
				line = new Sprite();
				line.graphics.lineStyle(slineWeight);  
				line.x = centerX - ledgerLineWidth/2 + 1;
				line.y = lowY;		 
				line.graphics.lineTo(ledgerLineWidth, 0);
				line.visible = false;
				parent.addChild(line);
				parent.setChildIndex(line, 0);
				lowY -= lineDistance;
				arr.push(line);
			}
			if (!ascending) {
				arr = arr.reverse();
			}
			return arr;
		}
		
		// showHideLines()
		protected function showHideLines(lineArray:Array, numLines:int, makeVisible:Boolean):void {
			var i:int;
			for (i=0; i<numLines; i++) {
				Sprite(lineArray[i]).visible = makeVisible;
			}
		}
		
		protected function getCopyOfVisibleLedgerLines(ledgerArray:Array, inputColumn:int):Array {
			var i:int;
			var sprites:Array = new Array();	
			if (ledgerArray[inputColumn] == null) {
				return new Array();
			}
			for (i=0; i< ledgerArray[inputColumn].length; i++) {
				 if (Sprite(ledgerArray[inputColumn][i]).visible) {
					 var line:Sprite = new Sprite();
					 var orig:Sprite =  Sprite(ledgerArray[inputColumn][i]);
					 line.graphics.lineStyle(slineWeight);  
					 line.x = orig.x;
					 line.y = orig.y;		 
					 line.graphics.lineTo(ledgerLineWidth, 0);
					 line.visible = true;
					 sprites.push(line);
				}
			}
			return sprites;
		}
		
		// Rearranges noteheads and accidentals depending in an output column
		protected function rearrangeOutputColumn(outputColumn:int):void {
			rearrangeAccidentals(outputColumn);

		}
		
		
		// Reformat accidentals to avoid overlap
		protected function rearrangeAccidentals(outputColumn:int):void {
			var notes:Array = outputArray[outputColumn];
			var lowNote:Note;
			var highNote:Note;
			var lowClef:String;
			var highClef:String;
			var sp:Sprite;
			var noteCenter:int = Math.floor(getInputAreaX() + (outputColumn) * inputColumnWidth + 
				inputColumnWidth/2);
			
			// Rearrange noteheads
			
			var i:int;
			var j:int;
			
			var onLeft:Boolean = true;
			
			// Align noteheads to original pos
			for (j = 0; j<notes.length; j++) {
				Bitmap(notes[j][1][0]).x = getInputAreaX() + (outputColumn) * inputColumnWidth + 
				inputColumnWidth/2 - Bitmap(notes[j][1][0]).width/2;
				
				// shrink back long ledger lines
				if (notes[j][1][notes[j][1].length-1] is Sprite) {
					sp = Sprite(notes[j][1][notes[j][1].length-1]);
					var spNew = new Sprite();
					spNew.graphics.lineStyle(slineWeight);  
					spNew.x = sp.x;
					spNew.y = sp.y; 
					spNew.graphics.lineTo(ledgerLineWidth, 0);
					parent.removeChild(sp);
					parent.addChild(spNew);
					notes[j][1][notes[j][1].length-1] = spNew;
			    }
			}
			
			// find the first note with an accidental, if any - align all accidentals to original pos
			notes.reverse();
			var currSixth:int = 1000;
			for (i = 0; i<notes.length; i++) {
				if (notes[i][1][1] is Bitmap) {
					Bitmap(notes[i][1][1]).x = noteCenter - firstAccidentalColumnOffset - maxAccidentalWidth - Bitmap(notes[i][1][1]).width/2;
					if (currSixth > i) {
						currSixth = i;
					}
				}
			}
			notes.reverse();
			
			
			i = 0;
			for (j = 1; j<notes.length; j++) {
				lowNote = Note(notes[i][0]);
				highNote = Note(notes[j][0]);
				lowClef = String(notes[i][2]);
				highClef = String(notes[j][2]);
				
				
				if (lowNote.getSizeDifferential(highNote) == 2 && lowClef == highClef) {
					if (onLeft) {
						var lowbm = Bitmap(notes[i][1][0]);
						var bm = Bitmap(notes[j][1][0]);
						if (lowbm.x == bm.x) {
							bm.x = bm.x + bm.width/2 + moveNoteRightOffset;
							parent.setChildIndex(bm, 0);
							if (notes[j][1][notes[j][1].length-1] is Sprite) {
								sp = Sprite(notes[j][1][notes[j][1].length-1]);
								sp.graphics.lineTo(ledgerLineWidth*1.75, 0);
							}
							
						}
						onLeft = false;
					}
					else {
						onLeft = true;
					}
					
				}
				else {
					onLeft = true;
				}
				i++;
			}
			
			
			
			// Rearrange accidentals
			notes.reverse();
			
			if (currSixth > notes.length - 2) {
				notes.reverse();
				return;
			}
			
			
			var currAccCol:int = 2;
			for (j = currSixth + 1; j<notes.length; j++) {
				highNote = Note(notes[currSixth][0]);
				lowNote = Note(notes[j][0]);
				
				// Check if low note has accidental
				if (notes[j][1][1] is Bitmap) {
					
					if (lowNote.getSizeDifferential(Note(notes[currSixth][0])) <= 6 &&
						clefComparison(String(notes[j][2]), String(notes[currSixth][2])) == 0) {
						Bitmap(notes[j][1][1]).x = noteCenter  - firstAccidentalColumnOffset - 
												   Bitmap(notes[j][1][1]).width/2 - (maxAccidentalWidth*currAccCol);
						currAccCol++;
					}
					else {
						currSixth = j;
						currAccCol = 2;
					}
				}
				
			}
			
			notes.reverse();
		
		}
		
		
		// --------------------------------------------- 
		//				   OUTPUT 
		// ---------------------------------------------
		
		protected function addNoteToOutput(note:Note, inputColumn:int, clef:String, 
										   bitmaps:Array, paramNote:Boolean = false):void {
			var arr:Array = new Array(3);
			arr[0] = note;
			arr[1] = bitmaps;
			arr[2] = clef;
			arr[3] = paramNote;
			
			
			if (outputArray[inputColumn].length == 0) {
				outputArray[inputColumn].push(arr);
				// Send callback to parent whenever a note is added to output
				(parent as MovieClip).processNewInput();
				return;
			}
			
			
			var i:int;
			for (i=0; i<outputArray[inputColumn].length; i++) {
					
					if (clefComparison(String(outputArray[inputColumn][i][2]), clef) < 0) {
						outputArray[inputColumn].splice(i, 0, new Array());
						outputArray[inputColumn][i] = arr;
						// Send callback to parent whenever a note is added to output
						(parent as MovieClip).processNewInput();
						return;
					}
					else if (clefComparison(String(outputArray[inputColumn][i][2]), clef) == 0) {
						if (Note(outputArray[inputColumn][i][0]).greaterThanLetterRegister(note.getLetter(), note.getRegister()) >= 0 ){
							outputArray[inputColumn].splice(i, 0, new Array());
							outputArray[inputColumn][i] = arr;
							// Send callback to parent whenever a note is added to output
							(parent as MovieClip).processNewInput();
							return;
						}	
					}
					
			}
			// if we get here note is the highest - put at the end
			outputArray[inputColumn].push(arr);
			
			// Send callback to parent whenever a note is added to output
			(parent as MovieClip).processNewInput();
		}
		
		protected function removeNoteFromOutput(note:Note, inputColumn:int, clef:String, letterRegisterOnly:Boolean):void {
			var i:int;
			var arr:Array = new Array();
			
			for (i=0; i<outputArray[inputColumn].length; i++) {
				if (Note(outputArray[inputColumn][i][0]).equals(note, letterRegisterOnly) &&
					clef == outputArray[inputColumn][i][2] && (!Boolean(outputArray[inputColumn][i][3]))) {
					
					var noteBitmapArray:Array = outputArray[inputColumn][i][1] as Array;
					var j:int;
					for (j=0; j<noteBitmapArray.length; j++) {
					if (noteBitmapArray[j] is Bitmap) {
						parent.removeChild(Bitmap(noteBitmapArray[j]));
					}
					else if (noteBitmapArray[j] is Sprite) {
						var bm:Sprite = Sprite(noteBitmapArray[j]);
						parent.removeChild(bm);
						}
					}
					outputArray[inputColumn].splice(i,1);
					
					// Send callback to parent whenever a note is removed to output
					(parent as MovieClip).processNewInput();
					
					break;
					//}
					
				}
			}
			
			
		}
		
		protected function noteInOutput(note:Note, inputColumn:int, clef:String, letterRegisterOnly:Boolean):Boolean {
			var i:int;
			
			for (i=0; i<outputArray[inputColumn].length; i++) {
				
				if (Note(outputArray[inputColumn][i][0]).equals(note, letterRegisterOnly) &&
					clef == outputArray[inputColumn][i][2]) {
					
					return true;
				}
			}
			return false;
		}
		
		
		
		// --------------------------------------------- 
		//				   UTILITIES 
		// ---------------------------------------------
		
		//Check if input column is full
		protected function inputColumnIsFull(inputCol:int, staff:String = "t"):Boolean {
			if (Boolean(inputParams[inputCol][1]) && 
				outputArray[inputCol].length >= int(inputParams[inputCol][0])) {
					return true;
			}
			return false; 
		}
		
		// getColumnX
		protected function getColumnX(col:int):int {
			return getInputAreaX() + (col * inputColumnWidth);
		}
		
		// getWhiteNotes()
		// Clef = "treble" or "bass" - returns an array of white notes in correct input range
		// for clef
		protected function getWhiteNotes(clef:String):Array {
			var wnArr:Array;
			
			// E3 - A6
			if (clef == "treble") {
				wnArr = new MajorScale(new Note("C", "", 3)).getScaleDegrees().slice(2, 7);
				wnArr = wnArr.concat(new MajorScale(new Note("C", "", 4)).getScaleDegrees().slice(0,7));
				wnArr = wnArr.concat(new MajorScale(new Note("C", "", 5)).getScaleDegrees().slice(0,7));
				wnArr = wnArr.concat(new MajorScale(new Note("C", "", 6)).getScaleDegrees().slice(0,6));
			}
			
			// E1 - A4
			else {
			    wnArr = new MajorScale(new Note("C", "", 1)).getScaleDegrees().slice(2, 7);
				wnArr = wnArr.concat(new MajorScale(new Note("C", "", 2)).getScaleDegrees().slice(0,7));
				wnArr = wnArr.concat(new MajorScale(new Note("C", "", 3)).getScaleDegrees().slice(0,7));
				wnArr = wnArr.concat(new MajorScale(new Note("C", "", 4)).getScaleDegrees().slice(0,6));
			}
		
			return wnArr;
		}
		
		// getULCorner()
		protected function getULCorner():Point {
			var center:Point = new Point (stageWidth/2, stageHeight/2);
			
			
			var ulCorner:Point = new Point (center.x - getSystemWidth()/2, 
											center.y - getSystemHeight()/2);
			
			return ulCorner;
		}
		
		// getSystemHeight()
		protected function getSystemHeight():int {
			if (this.type == "grand") {
				return maxNoteheadsBetweenStaves * lineDistance + lineDistance * 8;
			}
			else {
				return lineDistance * 4;
			}
		}
		
		// getClefX
		protected function getClefX():int {
			return getULCorner().x + padding*2;
		}
		
		protected function getKSX():int {
			return getClefX() + clefWidth + padding * 3;
		}
		
		protected function getInputAreaX():int {
			return getKSX() + getKeySignWidth() + padding*16;
		}
		
		// getKeySignWidth()
		protected function getKeySignWidth():int {
			return keySign.getSignatureTreble().length *(accidentalDistance);
		}
		
		// getSystemWidth()
		protected function getSystemWidth():int {
			return padding*2 + clefWidth + padding * 3 + getKeySignWidth() + padding*16 +
				   inputColumnWidth*inputParams.length + padding*8;
		}
		
		protected function getNoteArrayFromSpot(spot:Sprite):Array {
			var locationArray:Array = hotSpotLocationArray[spot.x + "-" + spot.y] as Array;
			return (stateArray [locationArray[0]] [locationArray[1]] [0] [locationArray[2]]) as Array;
		}
		
		// returns 0 if clefs are the same - otherwise return cl2 > cl1
		protected function clefComparison(cl1:String, cl2:String):int {
			
			if (cl1 == cl2) {
				return 0;
			}
			else if (cl2 == "treble") {
				return 1;
			}
			else {
				return -1;
			}
		}
		
		
		// --------------------------------------------- 
		//				   QUIZ 
		// ---------------------------------------------
		
		public function getAnswers():Array {
			return outputArray;
		}
		
	}
}