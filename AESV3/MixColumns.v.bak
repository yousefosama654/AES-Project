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


module inverse_mix_columns(
   input wire [127:0] present_state,
	output reg [127:0] next_state,
	input clock,enable,reset
	
);
	integer i,j,k,l;

reg [7:0] present_state_matrix [0:3] [0:3];
reg [7:0] next_state_matrix [0:3] [0:3];
reg [7:0] inverse_multiplication_matrix [0:3] [0:3];
reg [7:0] initial_state;
reg [15:0] multiplication;
reg [15:0] multiplication_temp [7:0];






always @ (posedge clock)
begin
inverse_multiplication_matrix [0] [0] = 8'd14;
inverse_multiplication_matrix [0] [1] = 8'd11;
inverse_multiplication_matrix [0] [2] = 8'd13;
inverse_multiplication_matrix [0] [3] = 8'd09;
inverse_multiplication_matrix [1] [0] = 8'd09;
inverse_multiplication_matrix [1] [1] = 8'd14;
inverse_multiplication_matrix [1] [2] = 8'd11;
inverse_multiplication_matrix [1] [3] = 8'd13;
inverse_multiplication_matrix [2] [0] = 8'd13;
inverse_multiplication_matrix [2] [1] = 8'd09;
inverse_multiplication_matrix [2] [2] = 8'd14;
inverse_multiplication_matrix [2] [3] = 8'd11;
inverse_multiplication_matrix [3] [0] = 8'd11;
inverse_multiplication_matrix [3] [1] = 8'd13;
inverse_multiplication_matrix [3] [2] = 8'd09;
inverse_multiplication_matrix [3] [3] = 8'd14;


if (enable)
   begin	
	for (i = 0; i < 3; i = i + 1)
	   begin
		for (j = 0; j < 3; j = j + 1)
		   begin
		      k = 15 - (4*i - j);
			   present_state_matrix [j] [i] = present_state [k*8 +: 8];
		   end
		end
	
	
	
	
	
	
	
	   for (i = 0; i < 4; i = i + 1)
		   begin
		   for (j = 0; j < 4; j = j + 1)
			   begin
				   initial_state = 0;
					for (k = 0; k < 4; k = k + 1)
					   begin
						multiplication = 0;
					   for (l = 0; l < 7; l = l + 1)
						   begin
							if (present_state_matrix [k] [j] [l] == 1)
							   multiplication_temp[l] = (inverse_multiplication_matrix [i] [k]) * (2**l);
							else
							   multiplication_temp[l] = 0;
							end
						for (l = 0; l < 8; l = l + 1)
						   multiplication = multiplication ^  multiplication_temp[l];
						initial_state = initial_state ^ multiplication;
						end
					next_state_matrix [j] [i] = initial_state;
				end
		   end
	   
		
		
		
		
		
		
		for (i = 0; i < 3; i = i + 1)
	      begin
		   for (j = 0; j < 3; j = j + 1)
		      begin
		         k = 15 - (4*i - j);
			      next_state [k*8 +: 8] = next_state_matrix [j] [i];
		      end
		   end
	
		
		
		
		
		
   end

else if (reset)
   next_state = 0;	

end
endmodule
				