`timescale 1ns / 1ps


module Bit_allignment(data_12bit,SDR_CLK, Test_N, CLK_IN,serial_data);
input serial_data;          // STREAMED SERIAL DATA FROM DATA SERIALIZER
input CLK_IN;
input Test_N;
output [11:0] data_12bit;
output SDR_CLK;


wire bit_alligned_data;   // ALIIGNED DATA WITH THE TRAINING PATTERN AS THE P
wire allign_ack;
reg [3:0] count;
reg clk_cnt;
reg [11:0] data_out_reg;
reg [11:0] buf_12bit;
reg [3:0] state;

parameter TP = 12'hA5B;
parameter idle = 4'h0;
parameter bit1 = 4'h1;
parameter bit2 = 4'h2;
parameter bit3 = 4'h3;
parameter bit4 = 4'h4;
parameter bit5 = 4'h5;
parameter bit6 = 4'h6;
parameter bit7 = 4'h7;
parameter bit8 = 4'h8;
parameter bit9 = 4'h9;
parameter bit10 = 4'hA;
parameter bit11 = 4'hB;
parameter verified = 4'hC;

initial state = idle;

always @(posedge CLK_IN)
if(Test_N)
begin
    state <= idle;
end
else
begin

// COMPARING THE SERIALIZED DATA TO ALLIGN THE 12-BIT SAMPLE START AND END FOR WORD SAMPLING
    case(state)
        idle: state <= (serial_data == TP[0]) ? bit1 : idle;
        bit1: state <= (serial_data == TP[1]) ? bit2 : idle;
        bit2: state <= (serial_data == TP[2]) ? bit3 : bit2; // This state of the sequence detector is modified with respect to training pattern = A5B
        bit3: state <= (serial_data == TP[3]) ? bit4 : idle;
        bit4: state <= (serial_data == TP[4]) ? bit5 : idle;
        bit5: state <= (serial_data == TP[5]) ? bit6 : idle;
        bit6: state <= (serial_data == TP[6]) ? bit7 : idle;
        bit7: state <= (serial_data == TP[7]) ? bit8 : idle;
        bit8: state <= (serial_data == TP[8]) ? bit9 : idle;
        bit9: state <= (serial_data == TP[9]) ? bit10 : idle;
        bit10: state <= (serial_data == TP[10]) ? bit11 : idle;
        bit11: state <= (serial_data == TP[11]) ? verified : idle;
        verified: state <= (serial_data) ? verified : verified;
        
        default: state <= idle;
    endcase 
    
// BASED UPON THE ACKNOWLEDMENT OF THE SERIALIZED DATA BIT ALLIGNMENT PERFORMING 12 BIT WORD SAMPLING    
    if(!allign_ack)
    begin 
        count =0;
        clk_cnt =1;   
    end
    else 
    begin
            
        // STORING THE DATA INTO THE BUFFER TO SAMPLE AS A 12-BIT PACKET
        data_out_reg[count] <= serial_data;
        
        // CONVERTING THE DDR TO SDR WITH 12 BIT DATA SAMPLE
        if(count == 4'hB)
            begin
            count <= 0;
            clk_cnt <= ~ clk_cnt;
          end  
            
          if(count == 4'h5)
          begin
            clk_cnt <= ~ clk_cnt;
          end
            
          count = count + 1; // It's necessary to write count in bloking passion
    end
end



// ALLIGNING THE 12 BIT SAMPLED DATA WITH SDR CLOCK
always @(posedge SDR_CLK)
begin
     buf_12bit <= data_out_reg;
end

assign allign_ack = (state == verified) ? 1 : 0;
//assign bit_alligned_data = (allign_ack) ? serial_data : 1'bx;
assign data_12bit = buf_12bit;
assign SDR_CLK = clk_cnt;

endmodule
