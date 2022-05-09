module GenerateKey6(InKey,Round,OutKey);

input [191:0] InKey;
output [191:0] OutKey;
input [3:0] Round;

wire [31:0] LastCol;
wire [31:0] FirstCol;

assign LastCol = InKey[31:0];
assign FirstCol = InKey[191:160];

wire [31:0] RCon;
assign RCon = Round == 1 ? 32'b00000001000000000000000000000000 :
				  Round == 2 ? 32'b00000010000000000000000000000000 :
				  Round == 3 ? 32'b00000100000000000000000000000000 :
				  Round == 4 ? 32'b00001000000000000000000000000000 :
				  Round == 5 ? 32'b00010000000000000000000000000000 :
				  Round == 6 ? 32'b00100000000000000000000000000000 :
				  Round == 7 ? 32'b01000000000000000000000000000000 :
				  Round == 8 ? 32'b10000000000000000000000000000000 :
				  Round == 9 ? 32'b00011011000000000000000000000000 :
				  Round == 10 ? 32'b00110110000000000000000000000000 : 0;


wire [31:0] newCol = {LastCol[23:0] , LastCol[31:24]};
wire [31:0] SubCol;
SubBytes SB(newCol,SubCol);
assign OutKey[191:160] = SubCol ^ FirstCol ^ RCon;
assign OutKey[159:128] = InKey[159:128] ^ OutKey[191:160];
assign OutKey[127:96]  = InKey[127:96]  ^ OutKey[159:128];
assign OutKey[95:64]   = InKey[95:64]   ^ OutKey[127:96];
assign OutKey[63:32]   = InKey[63:32]   ^ OutKey[95:64];
assign OutKey[31:0]    = InKey[31:0]    ^ OutKey[63:32];

endmodule 

//==========================================================================================

module KeysGeneration6 (OriginalKey , OutKeys);
input [191:0] OriginalKey;
output [1663:0] OutKeys;  // 11 4*4 Key

wire [191:0] Key1;
wire [191:0] Key2;
wire [191:0] Key3;
wire [191:0] Key4;
wire [191:0] Key5;
wire [191:0] Key6;
wire [191:0] Key7;
wire [191:0] Key8;

assign OutKeys[1663 : 1472] = OriginalKey;
GenerateKey6 K1   (OriginalKey,1, Key1);
GenerateKey6 K2   (Key1, 2, Key2);
GenerateKey6 K3   (Key2, 3, Key3);
GenerateKey6 K4   (Key3, 4, Key4);
GenerateKey6 K5   (Key4, 5, Key5);
GenerateKey6 K6   (Key5, 6, Key6);
GenerateKey6 K7   (Key6, 7, Key7); 
GenerateKey6 K8   (Key7, 8, Key8);

assign OutKeys[1471:1280] = Key1;
assign OutKeys[1279:1088] = Key2;
assign OutKeys[1087:896]  = Key3;
assign OutKeys[895:704]   = Key4;
assign OutKeys[703:512]   = Key5;
assign OutKeys[511:320]   = Key6;
assign OutKeys[319:128]   = Key7;
assign OutKeys[127:0]     = Key8[191:64];
endmodule

//==========================================================================================
module EncryptNK6 (PlainText,Key,Encryption); 

input  [127:0] PlainText;
input  [192:0] Key;
output [127:0] Encryption;

wire [1663:0] WorkingKeys;
KeysGeneration6 KG6 (Key,WorkingKeys);

wire [127:0] Key0;
wire [127:0] Key1;
wire [127:0] Key2;
wire [127:0] Key3;
wire [127:0] Key4;
wire [127:0] Key5;
wire [127:0] Key6;
wire [127:0] Key7;
wire [127:0] Key8;
wire [127:0] Key9;
wire [127:0] Key10;
wire [127:0] Key11;
wire [127:0] Key12;

assign Key0 = WorkingKeys[1663:1536];
assign Key1 = WorkingKeys[1535:1408];
assign Key2 = WorkingKeys[1407:1280];
assign Key3 =  WorkingKeys[1279:1152];
assign Key4 =  WorkingKeys[1151:1024];
assign Key5 =  WorkingKeys[1023:896];
assign Key6 =  WorkingKeys[895:768];
assign Key7 =  WorkingKeys[767:640];
assign Key8 =  WorkingKeys[639:512];
assign Key9 =  WorkingKeys[511:384];
assign Key10 =  WorkingKeys[383:256];
assign Key11 =  WorkingKeys[255:128];
assign Key12 = WorkingKeys[127:0];

// Pre-Rounds
wire [127:0] XOR0;
AddRoundKey ARK0 (PlainText,Key0,XOR0);
//==========================================
//Round 1
wire [127:0] Sub1;
FullSubBytes S1(XOR0 , Sub1);
wire [127:0] Shift1;
ShiftRows Sh1(Sub1,Shift1);
wire [127:0] Mix1;
MixColumns MC1(Shift1,Mix1);
wire [127:0] XOR1;
AddRoundKey ARK1(Mix1,Key1,XOR1);
//==========================================
//Round 2
wire [127:0] Sub2;
FullSubBytes S2(XOR1 , Sub2);
wire [127:0] Shift2;
ShiftRows Sh2(Sub2,Shift2);
wire [127:0] Mix2;
MixColumns MC2(Shift2,Mix2);
wire [127:0] XOR2;
AddRoundKey ARK2(Mix2,Key2,XOR2);
//==========================================
//Round 3
wire [127:0] Sub3;
FullSubBytes S3(XOR2 , Sub3);
wire [127:0] Shift3;
ShiftRows Sh3(Sub3,Shift3);
wire [127:0] Mix3;
MixColumns MC3(Shift3,Mix3);
wire [127:0] XOR3;
AddRoundKey ARK3(Mix3,Key3,XOR3);
//==========================================
//Round 4
wire [127:0] Sub4;
FullSubBytes S4(XOR3 , Sub4);
wire [127:0] Shift4;
ShiftRows Sh4(Sub4,Shift4);
wire [127:0] Mix4;
MixColumns MC4(Shift4,Mix4);
wire [127:0] XOR4;
AddRoundKey ARK4(Mix4,Key4,XOR4);
//==========================================
//Round 5
wire [127:0] Sub5;
FullSubBytes S5(XOR4 , Sub5);
wire [127:0] Shift5;
ShiftRows Sh5(Sub5,Shift5);
wire [127:0] Mix5;
MixColumns MC5(Shift5,Mix5);
wire [127:0] XOR5;
AddRoundKey ARK5(Mix5,Key5,XOR5);
//==========================================
//Round 6
wire [127:0] Sub6;
FullSubBytes S6(XOR5 , Sub6);
wire [127:0] Shift6;
ShiftRows Sh6(Sub6,Shift6);
wire [127:0] Mix6;
MixColumns MC6(Shift6,Mix6);
wire [127:0] XOR6;
AddRoundKey ARK6(Mix6,Key6,XOR6);
//==========================================
//Round 7
wire [127:0] Sub7;
FullSubBytes S7(XOR6 , Sub7);
wire [127:0] Shift7;
ShiftRows Sh7(Sub7,Shift7);
wire [127:0] Mix7;
MixColumns MC7(Shift7,Mix7);
wire [127:0] XOR7;
AddRoundKey ARK7(Mix7,Key7,XOR7);
//==========================================
//Round 8
wire [127:0] Sub8;
FullSubBytes S8(XOR7 , Sub8);
wire [127:0] Shift8;
ShiftRows Sh8(Sub8,Shift8);
wire [127:0] Mix8;
MixColumns MC8(Shift8,Mix8);
wire [127:0] XOR8;
AddRoundKey ARK8(Mix8,Key8,XOR8);
//==========================================
//Round 9
wire [127:0] Sub9;
FullSubBytes S9(XOR8 , Sub9);
wire [127:0] Shift9;
ShiftRows Sh9(Sub9,Shift9);
wire [127:0] Mix9;
MixColumns MC9(Shift9,Mix9);
wire [127:0] XOR9;
AddRoundKey ARK9(Mix9,Key9,XOR9);
//==========================================
//Round 10
wire [127:0] Sub10;
FullSubBytes S10(XOR9 , Sub10);
wire [127:0] Shift10;
ShiftRows Sh10(Sub10,Shift10);
wire [127:0] Mix10;
MixColumns MC10(Shift10,Mix10);
wire [127:0] XOR10;
AddRoundKey ARK10(Mix10,Key10,XOR10);
//==========================================
//Round 11
wire [127:0] Sub11;
FullSubBytes S11(XOR10 , Sub11);
wire [127:0] Shift11;
ShiftRows Sh11(Sub11,Shift11);
wire [127:0] Mix11;
MixColumns MC11(Shift11,Mix11);
wire [127:0] XOR11;
AddRoundKey ARK11(Mix11,Key11,XOR11);
//==========================================
//Round 12
wire [127:0] Sub12;
FullSubBytes S12(XOR11 , Sub12);
wire [127:0] Shift12;
ShiftRows Sh12(Sub12,Shift12);
wire [127:0] XOR12;
AddRoundKey ARK12(Shift12,Key12,XOR12);
assign Encryption = XOR12;
endmodule
//==============================================================================
module Inv_Keys_Generation6 (OriginalKey , OutKeys);
input [191:0] OriginalKey;
output [1663:0] OutKeys;  // 11 4*4 Key

wire [191:0] Key1;
wire [191:0] Key2;
wire [191:0] Key3;
wire [191:0] Key4;
wire [191:0] Key5;
wire [191:0] Key6;
wire [191:0] Key7;
wire [191:0] Key8;


GenerateKey6 K1   (OriginalKey,1, Key1);
GenerateKey6 K2   (Key1, 2, Key2);
GenerateKey6 K3   (Key2, 3, Key3);
GenerateKey6 K4   (Key3, 4, Key4);
GenerateKey6 K5   (Key4, 5, Key5);
GenerateKey6 K6   (Key5, 6, Key6);
GenerateKey6 K7   (Key6, 7, Key7); 
GenerateKey6 K8   (Key7, 8, Key8);

assign OutKeys[1663 -: 128] = Key8[191:64];
assign OutKeys[1535 -: 192] = Key7;
assign OutKeys[1343 -: 192] = Key6;
assign OutKeys[1151 -: 192]  = Key5;
assign OutKeys[959  -: 192]   = Key4;
assign OutKeys[767 -: 192]   = Key3;
assign OutKeys[575 -: 192]   = Key2;
assign OutKeys[383 -: 192]   = Key1;
assign OutKeys[191 : 0]     = OriginalKey;
endmodule
//=============================================================================
module DecryptNK6 (PlainText,Key,Decryption); 

input  [127:0] PlainText;
input  [192:0] Key;
output [127:0] Decryption;

wire [1663:0] WorkingKeys;
Inv_Keys_Generation6 KG6 (Key,WorkingKeys);

wire [127:0] Key0;
wire [127:0] Key1;
wire [127:0] Key2;
wire [127:0] Key3;
wire [127:0] Key4;
wire [127:0] Key5;
wire [127:0] Key6;
wire [127:0] Key7;
wire [127:0] Key8;
wire [127:0] Key9;
wire [127:0] Key10;
wire [127:0] Key11;
wire [127:0] Key12;

assign Key0 = WorkingKeys[1663:1536];
assign Key1 = WorkingKeys[1535:1408];
assign Key2 = WorkingKeys[1407:1280];
assign Key3 =  WorkingKeys[1279:1152];
assign Key4 =  WorkingKeys[1151:1024];
assign Key5 =  WorkingKeys[1023:896];
assign Key6 =  WorkingKeys[895:768];
assign Key7 =  WorkingKeys[767:640];
assign Key8 =  WorkingKeys[639:512];
assign Key9 =  WorkingKeys[511:384];
assign Key10 =  WorkingKeys[383:256];
assign Key11 =  WorkingKeys[255:128];
assign Key12 = WorkingKeys[127:0];

// Pre-Rounds
wire [127:0] XOR0;
AddRoundKey ARK0 (PlainText,Key0,XOR0);
//==========================================
//Round 1
wire [127:0] Sub1;
Inv_Full_SubBytes S1(XOR0 , Sub1);
wire [127:0] Shift1;
InvShiftRows Sh1(Sub1,Shift1);
wire [127:0] Mix1;
inverse_mix_columns MC1(Shift1,Mix1);
wire [127:0] XOR1;
AddRoundKey ARK1(Mix1,Key1,XOR1);
//==========================================
//Round 2
wire [127:0] Sub2;
Inv_Full_SubBytes S2(XOR1 , Sub2);
wire [127:0] Shift2;
InvShiftRows Sh2(Sub2,Shift2);
wire [127:0] Mix2;
inverse_mix_columns MC2(Shift2,Mix2);
wire [127:0] XOR2;
AddRoundKey ARK2(Mix2,Key2,XOR2);
//==========================================
//Round 3
wire [127:0] Sub3;
Inv_Full_SubBytes S3(XOR2 , Sub3);
wire [127:0] Shift3;
InvShiftRows Sh3(Sub3,Shift3);
wire [127:0] Mix3;
inverse_mix_columns MC3(Shift3,Mix3);
wire [127:0] XOR3;
AddRoundKey ARK3(Mix3,Key3,XOR3);
//==========================================
//Round 4
wire [127:0] Sub4;
Inv_Full_SubBytes S4(XOR3 , Sub4);
wire [127:0] Shift4;
InvShiftRows Sh4(Sub4,Shift4);
wire [127:0] Mix4;
inverse_mix_columns MC4(Shift4,Mix4);
wire [127:0] XOR4;
AddRoundKey ARK4(Mix4,Key4,XOR4);
//==========================================
//Round 5
wire [127:0] Sub5;
Inv_Full_SubBytes S5(XOR4 , Sub5);
wire [127:0] Shift5;
InvShiftRows Sh5(Sub5,Shift5);
wire [127:0] Mix5;
inverse_mix_columns MC5(Shift5,Mix5);
wire [127:0] XOR5;
AddRoundKey ARK5(Mix5,Key5,XOR5);
//==========================================
//Round 6
wire [127:0] Sub6;
Inv_Full_SubBytes S6(XOR5 , Sub6);
wire [127:0] Shift6;
InvShiftRows Sh6(Sub6,Shift6);
wire [127:0] Mix6;
MixColumns MC6(Shift6,Mix6);
wire [127:0] XOR6;
AddRoundKey ARK6(Mix6,Key6,XOR6);
//==========================================
//Round 7
wire [127:0] Sub7;
Inv_Full_SubBytes S7(XOR6 , Sub7);
wire [127:0] Shift7;
InvShiftRows Sh7(Sub7,Shift7);
wire [127:0] Mix7;
inverse_mix_columns MC7(Shift7,Mix7);
wire [127:0] XOR7;
AddRoundKey ARK7(Mix7,Key7,XOR7);
//==========================================
//Round 8
wire [127:0] Sub8;
Inv_Full_SubBytes S8(XOR7 , Sub8);
wire [127:0] Shift8;
InvShiftRows Sh8(Sub8,Shift8);
wire [127:0] Mix8;
inverse_mix_columns MC8(Shift8,Mix8);
wire [127:0] XOR8;
AddRoundKey ARK8(Mix8,Key8,XOR8);
//==========================================
//Round 9
wire [127:0] Sub9;
Inv_Full_SubBytes S9(XOR8 , Sub9);
wire [127:0] Shift9;
InvShiftRows Sh9(Sub9,Shift9);
wire [127:0] Mix9;
inverse_mix_columns MC9(Shift9,Mix9);
wire [127:0] XOR9;
AddRoundKey ARK9(Mix9,Key9,XOR9);
//==========================================
//Round 10
wire [127:0] Sub10;
Inv_Full_SubBytes S10(XOR9 , Sub10);
wire [127:0] Shift10;
InvShiftRows Sh10(Sub10,Shift10);
wire [127:0] Mix10;
inverse_mix_columns MC10(Shift10,Mix10);
wire [127:0] XOR10;
AddRoundKey ARK10(Mix10,Key10,XOR10);
//==========================================
//Round 11
wire [127:0] Sub11;
Inv_Full_SubBytes S11(XOR10 , Sub11);
wire [127:0] Shift11;
InvShiftRows Sh11(Sub11,Shift11);
wire [127:0] Mix11;
inverse_mix_columns MC11(Shift11,Mix11);
wire [127:0] XOR11;
AddRoundKey ARK11(Mix11,Key11,XOR11);
//==========================================
//Round 12
wire [127:0] Sub12;
Inv_Full_SubBytes S12(XOR11 , Sub12);
wire [127:0] Shift12;
InvShiftRows Sh12(Sub12,Shift12);
wire [127:0] XOR12;
AddRoundKey ARK12(Shift12,Key12,XOR12);
assign Encryption = XOR12;
endmodule 