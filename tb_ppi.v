module tb_ppi();
reg[7:0] PORTA, PORTB, PORTC, PORTD;
wire[7:0] PORTA_IO, PORTB_IO, PORTC_IO, PORTD_IO;
reg RD_, WR_, RESET, CS_;
reg[1:0] A;
reg TB_Input_A, TB_Input_B, TB_Input_C, TB_Input_D;

assign PORTA_IO = (TB_Input_A)? 8'bzzzz_zzz:PORTA;
assign PORTB_IO = (TB_Input_B)? 8'bzzzz_zzz:PORTB;
assign PORTC_IO = (TB_Input_C)? 8'bzzzz_zzz:PORTC;
assign PORTD_IO = (TB_Input_D)? 8'bzzzz_zzz:PORTD;


//Used in testing the BSR
integer i;

initial
begin
RESET <= 1'b0;


//BSR TESTING
$display("BSR_MODE");
TB_Input_C <= 1'b1;
TB_Input_D <= 1'b0;
for(i = 0; i < 9; i = i + 1)
begin
#2 
RD_ <= 1;
WR_ <= 1;
#2
A <= 3;
WR_ <= 0;
PORTD <= (i << 1);
$display("Data sent on PORTD: %b, Data received from PORTC: %b", PORTD_IO, PORTC_IO);
end



//MODE 0:Input Mode
   //PORTA as Input (we read from PORTD)
TB_Input_D <= 1'b0;
#2 
RD_ <= 1;
WR_ <= 1;
#2
A <= 3;
WR_ <= 0;
PORTD <= 8'b100_11_011;
#2
TB_Input_A <= 1'b0;
TB_Input_D <= 1'b1;
RD_ <= 1;
WR_ <= 1;
#2
A <= 0;
RD_ <= 0;
PORTA <= 8'b1110_0111;
#10
$display("MODE_0:PORTA:INPUT_MODE");
$display("Data sent on PORTA: %b, Data received from PORTD: %b", PORTA_IO, PORTD_IO);
   //PORTB as Input (we read from PORTD)
#2
TB_Input_B <= 1'b0;
TB_Input_D <= 1'b1;
RD_ <= 1;
WR_ <= 1;
#2
A <= 1;
RD_ <= 0;
PORTB <= 8'b1100_0011;
#10
$display("MODE_0:PORTB:INPUT_MODE");
$display("Data sent on PORTB: %b, Data received from PORTD: %b", PORTB_IO, PORTD_IO);

#2
RESET <= 1'b1;
#2
RESET <= 1'b0;

   //PORTC as Input (we read from PORTD)
#2
TB_Input_C <= 1'b0;
TB_Input_D <= 1'b1;
RD_ <= 1;
WR_ <= 1;
#2
A <= 2;
RD_ <= 0;
PORTC <= 8'b1000_0001;
#10
$display("MODE_0:PORTC:INPUT_MODE");
$display("Data sent on PORTC: %b, Data received from PORTD: %b", PORTC_IO, PORTD_IO);



#2
RESET <= 1'b1;
#2
RESET <= 1'b0;


//MODE 0:Output Mode
   //PORTA as Output (we write from PORTD)
//Configure the CHIP ports to be in output mode
#2
TB_Input_D <= 1'b0;
#2 
RD_ <= 1;
WR_ <= 1;
#2
A <= 3;
WR_ <= 0;
PORTD <= 8'b100_00_000;
#2
TB_Input_A <= 1'b1;
TB_Input_D <= 1'b0;
RD_ <= 1;
WR_ <= 1;
#2
A <= 0;
WR_ <= 0;
PORTD <= 8'b0111_1110;
#10
$display("MODE_0:PORTA:OUTPUT_MODE");
$display("Data sent on PORTD: %b, Data received from PORTA: %b", PORTD_IO, PORTA_IO);
#2
TB_Input_B <= 1'b1;
TB_Input_D <= 1'b0;
RD_ <= 1;
WR_ <= 1;
#2
A <= 1;
WR_ <= 0;
PORTD <= 8'b0011_1100;
#10
$display("MODE_0:PORTB:OUTPUT_MODE");
$display("Data sent on PORTD: %b, Data received from PORTB: %b", PORTD_IO, PORTB_IO);
#2
TB_Input_C <= 1'b1;
TB_Input_D <= 1'b0;
RD_ <= 1;
WR_ <= 1;
#2
A <= 2;
WR_ <= 0;
PORTD <= 8'b0001_1000;
#10
$display("MODE_0:PORTC:OUTPUT_MODE");
$display("Data sent on PORTD: %b, Data received from PORTC: %b", PORTD_IO, PORTC_IO);
$display("End of Simulation!");



end
ppi test_ppi(PORTA_IO, PORTB_IO, PORTC_IO, PORTD_IO, RD_, WR_, A, RESET, CS_);
endmodule
