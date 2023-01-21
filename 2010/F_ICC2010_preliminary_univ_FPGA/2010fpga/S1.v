module S1(clk,
	  rst,
	  RB1_RW,
	  RB1_A,
	  RB1_D,
	  RB1_Q,
	  sen,
	  sd);

  input clk, rst;
  output RB1_RW;      // control signal for RB1: Read/Write
  output [4:0] RB1_A; // control signal for RB1: address
  output [7:0] RB1_D; // data path for RB1: input port
  input [7:0] RB1_Q;  // data path for RB1: output port
  output sen, sd;
  

endmodule
