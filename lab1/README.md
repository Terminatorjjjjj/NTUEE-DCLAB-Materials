# Guideline
## Synthesizable Verilog
In Verilog, only a subset of syntax can be compiled to hardware,
and we call them the *synthesizable* code.
Here is some guidelines about the recommended synthesizable code.

## Register and the Sequential Block
The ONLY way you should use to generate registers is:

    always_ff (posedge clk or negedge rst) if (!rst)
      a_r <= 1'b0;
      b_r <= '0;
    else begin
      a_r <= a_w;
      b_r <= b_w;
    end

Note that I prefer to write *if reset* right after the first line,
which can prevent an extra indent.
Using an extra condition is also OK.
In fact, it's a simple techique for power saving.

    always_ff (posedge clk or negedge rst) if (!rst)
      a_r <= 1'b0;
      b_r <= '0;
    else if (cond) begin
      a_r <= a_w;
      b_r <= b_w;
    end

## Register (Sequential Blocks) and Combinational Blocks
If you follow the X\_r and X\_w naming conventions,
always keep in mind that X\_r is a register.
And NEVER use X\_r in the left hand side of combinational blocks.

    always_comb begin
      a_r = XXX ? ZZZ : YYY; // very possibly wrong
    end
    assign a_r = AAA ? BBB : CCC; // very possibly wrong

Simliarly, also always keep in mind that X\_w is usually not a register.
NEVER use X\_w in the left hand side of sequential blocks.
And be careful when X\_w appears in right hand side of combinational blocks.

    always_comb begin
      a_w = b_w + 1; // possibly wrong
    end
    always_ff (posedge clk or negedge rst) if (!rst)
      a_w <= 0; // definitely wrong
    else if (cond) begin
      a_w <= ...; // definitely wrong
    end

## A Working Example
Add this lines in Top.sv, compile (Ctrl+L) and program it to DE2-115.
Guess and observe what will happen?

    logic random_out_w;
    always_comb begin
      if (i_start) begin
        random_out_w = (o_random_out == 4'b5) ? 4'b0 : (o_random_out + 4'b1);
      end else begin
        random_out_w = o_random_out;
      end
    end
    always_ff (posedge i_clk or negedge i_rst) if (!i_rst)
      o_random_out <= 4'b0;
    else if (i_start) begin
      o_random_out <= random_out_w;
    end

# FAQ
## My Verilog Pass the Simulation, but It Doesn't Work.
Again, in Verilog, only a subset of syntax can be compiled to hardware.
If you see any WARNING about *Combinational Loop* or *Infered Latch*,
then you should modify your source code.

Or you can use nLint to check your Verilog (see also appendix).
If you pass the simulation but encounter these warnings/errors,
please double check your code.

* 22011 Combinational Loop
* 22013 Asynchronous Loop
* 22014 Synchronous Loop
* 22051 (Verilog) Generated Reset
* 22052 (Verilog) Generated Clock
* 22082 Port Not Connected
* 23003 Inferred Latch
* 23006 (Verilog) Incomplete Case Expression with Default Clause
* 23007 (Verilog) Case Statement Not Fully Specified
* 25001 Signal with No Driver

## Compile Fails at Fitter/Generate Program File Stage
If synthesis passes but you encounter a weird error,
please follow these steps:

* (in the left panel) Hierarchy
* (right click) Device
* (button) Device and pin options
* Dual-Purpose pins
* nCEO: Choose *Use as regular I/O*

# Appendix
## File Structure

* src/DE2\_115
	* All files related to the FPGA
* include/
	* Verilog files which only contain include lines
	* Not necessary for Quartus
* sim/ and lint/
	* Working directories

## nLint
Verilog coding style checking

    cd lab1/lint/
    make Top

## Simulation
Simulate the core file(s)

    cd lab1/sim/
    make -f ../../Makefile Top

And you can use nWave to check the signals of your Verilog code.

    nWave &
