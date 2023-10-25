`timescale 1ns / 1ps


module Word_allignment(Pixel_count,Write_EN,Pixel_data,data_12bit,SDR_CLK);
input [11:0] data_12bit;
input SDR_CLK;
output Write_EN;
output [9:0] Pixel_count;
output [11:0] Pixel_data;

reg Write_EN_reg;
reg [11:0] pixel_data_reg;
reg [47:0] compare_data =0;
reg [9:0] Pixel_count_reg=0;

parameter SOL = 48'hFFF_000_000_800;
parameter SOF = 48'hFFF_000_000_9D0;
parameter EOL = 48'hFFF_000_000_AB0;
parameter EOF = 48'hFFF_000_000_B60;

initial Write_EN_reg=0;
initial pixel_data_reg =0;

always @(posedge SDR_CLK)
begin
    compare_data <= (compare_data >>12);
    compare_data[47:36] <= data_12bit;
    
    case(compare_data)
        SOL:  Write_EN_reg = 1; 
        SOF:  Write_EN_reg = 1; 
        EOL:  Write_EN_reg = 0; 
        EOF:  Write_EN_reg = 0; 
    endcase
    
    Pixel_count_reg <= (Write_EN_reg) ? (Pixel_count_reg+1) : 0;
    
    if(Write_EN_reg)
    begin
        pixel_data_reg <= data_12bit;
    end
    else
    begin
        pixel_data_reg <= 12'hxxx;
    end
end

assign Write_EN = Write_EN_reg;
assign Pixel_data = pixel_data_reg;
assign Pixel_count = Pixel_count_reg;
endmodule
