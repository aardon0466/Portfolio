//DFF Module
module DFF0(data_in,clock,reset, data_out);
input data_in;
input clock,reset;

output reg data_out;

always@(posedge clock)
	begin
		if(reset)
			data_out<=1'b0;
		else
			data_out<=data_in;
	end	

endmodule

module TFF0 (
data  , // Data Input
clk   , // Clock Input
reset , // Reset input
q       // Q output
);
//-----------Input Ports---------------
input data, clk, reset ; 
//-----------Output Ports---------------
output q;
//------------Internal Variables--------
reg q;
//-------------Code Starts Here---------
always @ ( posedge clk or posedge reset)
if (reset) begin
  q <= 1'b0;
end else if (data) begin
  q <= !q;
end
endmodule
   
//Clock Divider Module
module clk_divider(clock, rst, clk_out);
input clock, rst;
output clk_out;
 
wire [18:0] din;
wire [18:0] clkdiv;
 
DFF0 dff_inst0(
    .data_in(din[0]),
	 .clock(clock),
	 .reset(rst),
    .data_out(clkdiv[0])
);
 
genvar i;
generate
//Original Value: 26. New Value: 19
for (i = 1; i < 19; i=i+1) 
	begin : dff_gen_label
		 DFF0 dff_inst (
			  .data_in (din[i]),
			  .clock(clkdiv[i-1]),
			  .reset(rst),
			  .data_out(clkdiv[i])
		 );
		 end
endgenerate
 
assign din = ~clkdiv;
 
assign clk_out = clkdiv[18];
 
endmodule

//Half-adder Module
module halfAdder(X, Y, S, C);
input X, Y;
output S, C;

assign S = X ^ Y;
assign C = X & Y;

endmodule

//RCA Module
module RippleCarryAdder(A, Cin, Sum);
input [3:0]A;
input Cin;
output [3:0]Sum;
wire [3:0] C;

halfAdder a1(.X (A[0]), .Y (Cin), .S (Sum[0]), .C(C[0]));
halfAdder a2(.X (A[1]), .Y (C[0]), .S (Sum[1]), .C(C[1]));
halfAdder a3(.X (A[2]), .Y (C[1]), .S (Sum[2]), .C(C[2]));
halfAdder a4(.X (A[3]), .Y (C[2]), .S (Sum[3]), .C(C[3]));

endmodule

//4-bit DFF Module
module DFF4(data_in,clock,reset, data_out);
input [3:0]data_in;
input clock,reset;

output reg [3:0]data_out;

always@(posedge clock)
	begin
		if(reset)
			data_out<=4'b0000;
		else
			data_out<=data_in;
	end	

endmodule

//Count10 Module
module Count10(inc, clk, reset, Count, Ceq9);
input clk, reset, inc;
output [3:0]Count;
output Ceq9;
wire [3:0] RCA_out;
wire w1, rst;

assign Ceq9= (Count==4'b1001)?1:0;

RippleCarryAdder comp1 (Count, inc, RCA_out);
DFF4 comp2 (RCA_out, clk, rst, Count);
and g1 (w1, inc, Ceq9);
or g2 (rst, w1, reset);

endmodule

//Count6 Module
module Count6(inc, clk, reset, Count, Ceq9);
input clk, reset, inc;
output [3:0]Count;
output Ceq9;
wire [3:0] RCA_out;
wire w1, rst;

assign Ceq9= (Count==4'b0101)?1:0;

RippleCarryAdder comp1 (Count, inc, RCA_out);
DFF4 comp2 (RCA_out, clk, rst, Count);
and g1 (w1, inc, Ceq9);
or g2 (rst, w1, reset);

endmodule

//Display Module
module sevenSegmentDisplay(A,O);
input [3:0] A;
output [6:0] O;
wire [3:0] N;

assign N[0] = ~(A[0]);
assign N[1] = ~(A[1]);
assign N[2] = ~(A[2]); 
assign N[3] = ~(A[3]);

assign O[0] = (A[2] & N[0]) | ( N[3] & N[2] & N[1] & A[0]);
//assign O[0] = A[0] | A[2] | (A[1] & A[3]) | (N[1] & N[3]);
assign O[1] = A[2] & (A[1] ^ A[0]);
//assign O[1] = A[1] | (N[2] & N[3]) | (A[2] & A[3]);
assign O[2] = N[2] & A[1] & N[0];
assign O[3] = (A[2] & N[1] & N[0]) | (N[2] & N[1] & A[0]) | (A[2] & A[1] & A[0]);
assign O[4] = A[0] | (A[2] & N[1]);
assign O[5] = (A[1] & A[0]) | (N[3] & N[2] & A[0]) | (N[2] & A[1]); 
assign O[6] = (N[3] & N[2] & N[1]) | (A[2] & A[1] & A[0]);

endmodule

//Counter Module
module Counter(Clock, inc, reset, Display0, Display1, Display2, Display3);
input Clock, inc, reset;
output [6:0]Display0;
output [6:0]Display1;
output [6:0]Display2;
output [6:0]Display3;
wire clk, Ceq9_0, Ceq9_1, Ceq9_2, Ceq9_3, inc0, inc1, in2, inc3, toggle;
wire [3:0] Count0;
wire [3:0] Count1;
wire [3:0] Count2;
wire [3:0] Count3;

//Clock divider
clk_divider Comp0 (Clock, 1'b0, clk);

//Toggle
TFF0 Comp (1'b1, inc, 1'b0, inc0);

//100th
Count10 Comp1 (inc0, clk, reset, Count0, Ceq9_0);
sevenSegmentDisplay Comp2 (Count0, Display0);
assign inc1 = Ceq9_0 & inc0;

//10th 
Count10 Comp3 (inc1, clk, reset, Count1, Ceq9_1);
sevenSegmentDisplay Comp4 (Count1, Display1);
assign inc2 = Ceq9_1 & inc1;

//Second
Count10 Comp5 (inc2, clk, reset, Count2, Ceq9_2);
sevenSegmentDisplay Comp6 (Count2, Display2);
assign inc3 = Ceq9_2 & inc2;

//10
Count6 Comp7 (inc3, clk, reset, Count3, Ceq9_3);
sevenSegmentDisplay Comp8 (Count3, Display3);

endmodule