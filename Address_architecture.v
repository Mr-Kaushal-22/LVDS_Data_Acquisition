`timescale 1ns / 1ps

module Address_architecture(Data_Word,Address,W_EN,Pixel_count,Write_EN,SDR_CLK,Pixel_data);
input SDR_CLK;
input Write_EN;
input [11:0] Pixel_data;
input [9:0] Pixel_count;
output [9:0] Address;
output [15:0] Data_Word;
output W_EN;

parameter max_pixel = 8'h40;
reg [9:0] Base_addr = 0;
reg [9:0] Address_reg = 0;
reg [11:0] Data_reg = 0;
reg W_EN_reg = 0;
always @(posedge SDR_CLK)
begin
    Address_reg <= Base_addr + Pixel_count;
    Data_reg <= Pixel_data;
    W_EN_reg <= Write_EN;
end


always @(negedge Write_EN)
if(Pixel_count != 0)
begin
    Base_addr <= Base_addr + max_pixel;
end

assign Address = Address_reg;
assign Data_Word = {4'b0000,Data_reg};
assign W_EN = W_EN_reg;
endmodule
