module MixColumns( input wire [127:0]in,output reg [127:0]out);
	
	reg [7:0] x0,x1,x2,x3,x4,x5,x6,x7;
	reg [1:0]b1=2'b01;
	reg [1:0]b2=2'b10;
	reg [1:0]b3=2'b11;
	reg [7:0] y0,y1,y2,y3;
	reg [7:0] z0,z1,z2,z3;
	

	integer c=0;
	always @ (in)
	begin
		for (c=0 ; c<4 ; c=c+1)
			begin : gen_loop
				
				//R0-> 31+32*c:24+32*c
				//R1-> 23+32*c:16+32*c
				//R2-> 15+32*c:8+32*c
				//R3-> 7+32*c:32*c
				
				y0=in[(31+32*c)-:8];
				y1=in[(23+32*c)-:8];
				y2=in[(15+32*c)-:8];
				y3=in[(7+32*c)-:8];
				
				x0 = (y0[7]==1'b1)? ({y0[6:0],1'b0}^(8'h1b)):({y0[6:0],(1'b0)});
				z0 = (y1[7]==1'b1)? ({y1[6:0],1'b0}^(8'h1b)):({y1[6:0],(1'b0)});
				x1 = z0^y1;
				out[(31+32*c)-:8] = x0^x1^y2^y3;
				
				x2 = (y1[7]==1'b1)? ({y1[6:0],1'b0}^(8'h1b)):({y1[6:0],(1'b0)});
				z1 = (y2[7]==1'b1)? ({y2[6:0],1'b0}^(8'h1b)):({y2[6:0],(1'b0)});
				x3 = z1^y2;
				out[(23+32*c)-:8] = y0^x2^x3^y3;
				
				x4 = (y2[7]==1'b1)? ({y2[6:0],1'b0}^(8'h1b)):({y2[6:0],(1'b0)});
				z2 = (y3[7]==1'b1)? ({y3[6:0],1'b0}^(8'h1b)):({y3[6:0],(1'b0)});
				x5 = z2^y3;
				out[(15+32*c)-:8] = y0^y1^x4^x5;
				
				x6 = (y3[7]==1'b1)? ({y3[6:0],1'b0}^(8'h1b)):({y3[6:0],(1'b0)});
				z3 = (y0[7]==1'b1)? ({y0[6:0],1'b0}^(8'h1b)):({y0[6:0],(1'b0)});
				x7 = z3^y0;
				out[(7+32*c)-:8] = x7^y1^y2^x6;
				
			end
		end
endmodule
//==================================================================================
module mixCol(Col,output_Col,Round
);

input [31:0] Col;
input [3:0] Round; 
wire [7:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15;
output wire [31:0] output_Col;
wire [31:0] outputCol;

/* Advanced Multiplcation */ 
/* 
mul with 09 = xor(x3,x0)    8+1
mul with 0B = xor(x3,x1,x0) 8+2+1
mul with 0d = xor(x3,x2,x0) 8+4+1
mul with 0E = xor(x3,x2,x1) 8+4+2
*/ 
 
assign  x0 = Col[7:0];
assign	x1 = (x0[7]==1'b1)? ({x0[6:0],1'b0}^(8'h1b)):({x0[6:0],1'b0}); //x0 * 2
assign	x2 = (x1[7]==1'b1)? ({x1[6:0],1'b0}^(8'h1b)):({x1[6:0],1'b0}); //x0 * 4
assign	x3 = (x2[7]==1'b1)? ({x2[6:0],1'b0}^(8'h1b)):({x2[6:0],1'b0}); //x0 * 8
   
assign  x4 = Col[15:8];
assign	x5 = (x4[7]==1'b1)? ({x4[6:0],1'b0}^(8'h1b)):({x4[6:0],1'b0}); //x4 * 2
assign	x6 = (x5[7]==1'b1)? ({x5[6:0],1'b0}^(8'h1b)):({x5[6:0],1'b0}); //x4 * 4
assign	x7 = (x6[7]==1'b1)? ({x6[6:0],1'b0}^(8'h1b)):({x6[6:0],1'b0}); //x4 * 8
	
assign  x8 = Col[23:16];
assign	x9  = (x8[7]==1'b1)? ({x8[6:0],1'b0}^(8'h1b)):({x8[6:0],1'b0});//x8 * 2
assign	x10 = (x9[7]==1'b1)? ({x9[6:0],1'b0}^(8'h1b)):({x9[6:0],1'b0});//x8 * 4
assign	x11 = (x10[7]==1'b1)? ({x10[6:0],1'b0}^(8'h1b)):({x10[6:0],1'b0});//x8 * 8
	
assign  x12 = Col[31:24];
assign	x13 = (x12[7]==1'b1)? ({x12[6:0],1'b0}^(8'h1b)):({x12[6:0],1'b0});//x12 * 2
assign	x14 = (x13[7]==1'b1)? ({x13[6:0],1'b0}^(8'h1b)):({x13[6:0],1'b0});//x12 * 4
assign	x15 = (x14[7]==1'b1)? ({x14[6:0],1'b0}^(8'h1b)):({x14[6:0],1'b0});//x12 * 8



/*
Inverse matrix

0E	0B	0D	09
09	0E	0B	0D
0D	09	0E	0B
0B	0D	09	0E
*/

assign outputCol[31:24]  =(x15^x14^x13)^(x11^x9^x8)^(x7^x6^x4)^(x3^x0); //first elem*0E + second elem*0B + third elem*0D + fourth elem*09 
assign outputCol[23:16]  =(x15^x12)^(x11^x9^x10)^(x7^x5^x4)^(x3^x2^x0); //first elem*09 + second elem*0E + third elem*0B + fourth elem*0D
assign outputCol[15:8]   =(x15^x14^x12)^(x11^x8)^(x7^x6^x5)^(x3^x0^x1); //first elem*0D + second elem*09 + third elem*0E + fourth elem*0B
assign outputCol[7:0]    =(x15^x13^x12)^(x11^x10^x8)^(x7^x4)^(x3^x2^x1);//first elem*0B + second elem*0D + third elem*09 + fourth elem*0E
				
//output=input at round 10 and 0
assign output_Col  = (Round == 4'b1010 || Round == 4'b0000) ? Col : outputCol;

endmodule
//=======================================================================================

module inverse_mix_columns(
   input wire [127:0] present_state,
	output wire [127:0] next_state
	
);

mixCol Column1 (present_state[127:96], next_state[127:96], 1);
mixCol Column2 (present_state[95 :64], next_state[95 :64], 1);
mixCol Column3 (present_state[63 :32], next_state[63 :32], 1);
mixCol Column4 (present_state[31 :0 ], next_state[31 :0 ], 1);

endmodule 
//=====================================================================================================