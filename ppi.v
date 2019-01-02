`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:40:35 11/28/2018 
// Design Name: 
// Module Name:    PPI 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ppi(PORTA_IO, PORTB_IO, PORTC_IO, PORTD_IO, RD_, WR_, A, RESET, CS_);

//8-bit Bi-directional wires connecting the ports to the bus
inout[7:0] PORTA_IO, PORTB_IO, PORTC_IO;

//8-bit Tri-state output data bus
reg [7:0] PORTA, PORTB, PORTC;

//8-bit Bi-directional wires connecting the data lines to the bus
inout[7:0] PORTD_IO;

//8-bit Tri-state output data bus
reg[7:0] PORTD;


//Control Register
reg[7:0] CTRL_REG;

//Single lines driven by the processor to control the chip
input RD_, WR_; //Specify read or write (active low)
input[1:0] A; // 00 -> portA, 01 -> portB, 10 -> portC, 11 -> portD
input RESET; //Sets all ports (A, B, C) to inputs when set
input CS_; //Chip select (active low)

reg Input_A, Input_B, Input_C, Input_D;

assign PORTA_IO = (Input_A)? 8'bzzzz_zzzz: PORTA;
assign PORTB_IO = (Input_B)? 8'bzzzz_zzzz: PORTB;
assign PORTC_IO = (Input_C)? 8'bzzzz_zzzz: PORTC;
assign PORTD_IO = (Input_D)? 8'bzzzz_zzzz: PORTD;



initial
begin
	CTRL_REG <= 8'b10011011;
	PORTA <= 8'h??;
	PORTB <= 8'h??;
	PORTC <= 8'h??;
	PORTD <= 8'h??;
	Input_A <= 1'b1;
	Input_B <= 1'b1;
	Input_C <= 1'b1;
	Input_D <= 1'b1;
end





always@(WR_ or RD_ or A or CTRL_REG or RESET or PORTA_IO or PORTB_IO or PORTD_IO or PORTC_IO)
begin
	if(RESET == 1)
	begin
	CTRL_REG = 8'b10011011;
	PORTA = 8'h??;
	PORTB = 8'h??;
	PORTC = 8'h??;
	PORTD = 8'h??;
	Input_A = 1'b1;
	Input_B = 1'b1;
	Input_C = 1'b1;
	Input_D = 1'b1;
	end
	else if(A == 3 && WR_ == 0) 
	begin
	Input_D = 1'b1;
	CTRL_REG = PORTD_IO; //If the CTRL_REG is chosen transfer the data from the datapath to the CTRL_REG
	end
	else if(CTRL_REG[7] == 0) //BSR Mode
	begin
		Input_C = 1'b0;
		case(CTRL_REG[3:1])
		0: PORTC[0] = CTRL_REG[0];
		1: PORTC[1] = CTRL_REG[0];
		2: PORTC[2] = CTRL_REG[0]; 
		3: PORTC[3] = CTRL_REG[0];
		4: PORTC[4] = CTRL_REG[0];
		5: PORTC[5] = CTRL_REG[0];
		6: PORTC[6] = CTRL_REG[0];
		7: PORTC[7] = CTRL_REG[0];
		endcase
	end
	else if(CTRL_REG[7] == 1) //Input/Output Mode
	begin
		if(A == 0) //If PORTA is selected
		begin
			if(CTRL_REG[6:5] == 0) //Check if GROUPA is in mode 0
			begin
				//Check if read is active, transfer data from PORTA to PORTD(data bus)
				if(RD_ == 0 && WR_ == 1 && CTRL_REG[4] == 1) 
				begin	
				Input_A = 1'b1;
				Input_D = 1'b0;
				PORTD = PORTA_IO;
				end
				//Check if write is active, transfer data from PORTD(data bus) to PORTA
				else if(RD_ == 1 && WR_ == 0 && CTRL_REG[4] == 0) 
				begin
				Input_A = 1'b0;
				Input_D = 1'b1;
				PORTA = PORTD_IO;
				end
			end
		end
		else if(A == 1) //If PORTB is selected
		begin
			if(CTRL_REG[2] == 0) //Check if GROUPB is in mode 0
			begin
				if(RD_ == 0 && WR_ == 1 && CTRL_REG[1] == 1)
				begin
				Input_B = 1'b1;
				Input_D = 1'b0;
				PORTD = PORTB_IO;
				end
				else if(RD_ == 1 && WR_ == 0 && CTRL_REG[1] == 0) 
				begin
				Input_B = 1'b0;
				Input_D = 1'b1;
				PORTB = PORTD_IO;
				end
			end
		end
		else if(A == 2) //If PORTC is selected
		begin
			if(CTRL_REG[6:5] == 0 && CTRL_REG[2] == 0) //Check if GROUPA & GROUPB are in mode 0
			begin
				if(RD_ == 0 && WR_ == 1 && CTRL_REG[3] == 1 && CTRL_REG[0] == 1)
				begin 
				Input_C = 1'b1;
				Input_D = 1'b0;
				PORTD = PORTC_IO;
				end
				else if(RD_ == 1 && WR_ == 0 && CTRL_REG[3] == 0 && CTRL_REG[0] == 0) 
				begin
				Input_C = 1'b0;
				Input_D = 1'b1;
				PORTC = PORTD_IO;
				end
		end
		end


	end
end
endmodule
