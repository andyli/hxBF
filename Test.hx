import hxBF.BrainFuck;

import haxe.io.BytesOutput;
import haxe.io.StringInput;

/*
	Tests are from http://www.lordalcol.com/brainfuckjs/
*/
class Test extends haxe.unit.TestCase{
	function testHelloWorld():Void {
		var p = 
				"++++++++++
				[
				   >+++++++>++++++++++>+++>+<<<<-
				]
				>++. Loop iniziale (dopo viene stampata una H)
				>+. e
				+++++++. l
				. l
				+++. o
				>++.
				<<+++++++++++++++.
				>.
				+++.
				------.
				--------.
				>+.
				>.";
		
		var out = new BytesOutput();
		var bf = new BrainFuck(out).run(p);
		this.assertEquals("Hello World!\n", out.getBytes().toString());
	}
	
	function testAddition():Void {
		var p = ",>++++++[<-------->-],,[<+>-]<.";
		
		var out = new BytesOutput();
		var bf = new BrainFuck(new StringInput("3+2"), out).run(p);
		this.assertEquals("5", out.getBytes().toString());
	}

	function testMultiplication():Void {
		var p = 
			",>,,>++++++++[<------<------>>-]
			<<[>[>+>+<<-]>>[<<+>>-]<<<-]
			>>>++++++[<++++++++>-]<.";
		
		var out = new BytesOutput();
		var bf = new BrainFuck(new StringInput("2*4"), out).run(p);
		this.assertEquals("8", out.getBytes().toString());
	}

	function testDivision():Void {
		var p = 
			",>,,>++++++[-<--------<-------->>] Store 2 numbers from keyboard in (0) and (1); and subtract 48 from each
			<<[                               This is the main loop which continues until the dividend in (0) is zero
			>[->+>+<<]                        Destructively copy the divisor from (1) to (2) and (3); setting (1) to zero
			>[-<<-                            Subtract the divisor in (2) from the dividend in (0); the difference is stored in (0) and (2) is cleared
			[>]>>>[<[>>>-<<<[-]]>>]<<]        If the dividend in (0) is zero; exit the loop
			>>>+                              Add one to the quotient in (5)
			<<[-<<+>>]                        Destructively copy the divisor in (3) to (1)
			<<<]                              Move the stack pointer to (0) and go back to the start of the main loop
			>[-]>>>>[-<<<<<+>>>>>]            Destructively copy the quotient in (5) to (0) (not necessary; but cleaner)
			<<<<++++++[-<++++++++>]<.         Add 48 and print result";
		
		var out = new BytesOutput();
		var bf = new BrainFuck(new StringInput("6/2"), out).run(p);
		this.assertEquals("3", out.getBytes().toString());
	}

	function testUpperCaseAString():Void {
		var p = ",----------[----------------------.,----------]";
		
		var out = new BytesOutput();
		var bf = new BrainFuck(new StringInput("lordalcol\n"), out).run(p);
		this.assertEquals("LORDALCOL", out.getBytes().toString());
	}

	function testBFInterpreter():Void {
		var p = 
			">>>+[[-]>>[-]++>+>+++++++[<++++>>++<-]++>>+>+>+++++[>++>++++++<<-]+>>>,<++[[>[
			->>]<[>>]<<-]<[<]<+>>[>]>[<+>-[[<+>-]>]<[[[-]<]++<-[<+++++++++>[<->-]>>]>>]]<<
			]<]<[[<]>[[>]>>[>>]+[<<]<[<]<+>>-]>[>]+[->>]<<<<[[<<]<[<]+<<[+>+<<-[>-->+<<-[>
			+<[>>+<<-]]]>[<+>-]<]++>>-->[>]>>[>>]]<<[>>+<[[<]<]>[[<<]<[<]+[-<+>>-[<<+>++>-
			[<->[<<+>>-]]]<[>+<-]>]>[>]>]>[>>]>>]<<[>>+>>+>>]<<[->>>>>>>>]<<[>.>>>>>>>]<<[
			>->>>>>]<<[>,>>>]<<[>+>]<<[+<<]<]

			input a brainfuck program and its input separated by an exclamation point";
		
		var out = new BytesOutput();
		var bf = new BrainFuck(new StringInput(",.+.>,++.>,+++.<<+++.+. !000"), out).run(p);
		this.assertEquals("012345", out.getBytes().toString());
	}
	
	static public function main():Void {
		var runner = new haxe.unit.TestRunner();
		runner.add(new Test());
		runner.run();
	}
}
