module ShiftRows(State,OutState);

input [127:0] State;
output [127:0] OutState;

assign OutState[127:96] = {State[127:120],State[87:80],State[47:40],State[7:0]};
assign OutState[95:64] = {State[95:88],State[55:48],State[15:8],State[103:96]};
assign OutState[63:32] = {State[63:56],State[23:16],State[111:104],State[71:64]};
assign OutState[31:0] = {State[31:24],State[119:112],State[79:72],State[39:32]};


endmodule
//====================================================================================




module InvShiftRows(State,OutState);

input [127:0] State;
output [127:0] OutState;

assign OutState[127 : 120] = State[127 : 120];
assign OutState[119 : 112]  = State[23:16];
assign OutState[111 : 104] = State[47:40];
assign OutState[103 : 96] = State[71:64];

assign OutState[95 : 88] = State[95 : 88];
assign OutState[87 : 80] = State[119:112];
assign OutState[79 : 72] = State[15:8];
assign OutState[71 : 64] = State[39:32];

assign OutState[63 : 56] = State[63 : 56];
assign OutState[55 : 48] = State[87:80];
assign OutState[47 : 40] = State[111:104];
assign OutState[39 : 32] = State[7:0];

assign OutState[31 : 24] = State[31 : 24];
assign OutState[23 : 16] = State[55:48];
assign OutState[15 : 8] = State[79:72];
assign OutState[7  : 0] = State[103:96];


endmodule 
