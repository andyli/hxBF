/*
	hxBF, BrainFuck interpreter written in haXe
	Based on the as3 version I've written some time ago: http://blog.onthewings.net/2009/10/08/brainflash-the-as3-brainfuck-interpreter

	Copyright (c) 2010, Andy Li
	All rights reserved.

	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	Neither the name of onthewings.net nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package hxBF;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.Input;
import haxe.io.Output;
import haxe.io.StringInput;

class BrainFuck {
	public var memory:Bytes;
	public var pointer:Int;
	public var input:Input;
	public var output:Output;
	public var program:String;
	public var programPosition:Int;

	public var showInput:Bool;
	
	public function new(?program:String = "", ?input:Input, ?output:Output, ?memory:Bytes):Void {
		this.program = program;
		this.input = input == null ? new StringInput("") : input;
		this.output = output == null ? new BytesOutput() : output;
		this.memory = memory == null ? Bytes.alloc(30000) : memory;

		showInput = false;
		programPosition = 0;
		pointer = 0;
	}

	public function run():BrainFuck {
		while (programPosition < this.program.length){
			runCommand(program.charAt(programPosition));
		}

		return this;
	}

	private function runCommand(command:String):Void {
		switch (command) {
			case '>': //Increment the pointer.
				++pointer;
				moveToNextCommand();
			case '<': //Decrement the pointer.
				--pointer;
				moveToNextCommand();
			case '+': //Increment the byte at the pointer.
				memory.set(pointer,Std.int(Math.min(memory.get(pointer)+1,255)));
				moveToNextCommand();
			case '-': //Decrement the byte at the pointer.
				memory.set(pointer,Std.int(Math.max(memory.get(pointer)-1,0)));
				moveToNextCommand();
			case '.': //Output the byte at the pointer.
				output.writeByte(memory.get(pointer));
				moveToNextCommand();
			case ',': //Input a byte and store it in the byte at the pointer.
				var val = input.readByte();
				if (showInput){
					output.writeByte(val);
				}
				memory.set(pointer,val);
				moveToNextCommand();
			case '[': //Jump forward past the matching ] if the byte at the pointer is zero.
				var val = memory.get(pointer);
				if (val == 0){
					var count = 1;
					var c = moveToNextCommand();
					while (c != null){
						if (c == '[') ++count;
						if (c == ']') --count;
						if (count == 0){
							moveToNextCommand();
							break;
						}
						c = moveToNextCommand();
					}
				} else {
					moveToNextCommand();
				}
			case ']': //Jump backward to the matching [ unless the byte at the pointer is zero.
				var val = memory.get(pointer);
				if (val > 0){
					var count = 1;
					var c = moveToPrevCommand();
					while (c != null){
						if (c == '[') --count;
						if (c == ']') ++count;
						if (count == 0){
							break;
						}
						c = moveToPrevCommand();
					}
				} else {
					moveToNextCommand();
				}
			default:
				moveToNextCommand();
		}
	}

	private function moveToNextCommand():String {
		return (++programPosition) >= program.length ? null : program.charAt(programPosition);
	}
	
	private function moveToPrevCommand():String {
		return (--programPosition < 0) ? null : program.charAt(programPosition);
	}
}
