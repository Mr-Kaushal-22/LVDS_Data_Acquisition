`timescale 1ns / 1ps


module TESTBENCH();
  wire [9:0]ADDRESS;
  wire CLK;
  wire [15:0]DATA_WORD;
  reg DDR_CLK_N;
  reg DDR_CLK_P;
  reg IO_RST;
  reg LVDS_N0;
  reg LVDS_P0;
  wire WRITE_EN;


Acquisition_module_wrapper TEST
   (ADDRESS,
    CLK,
    DATA_WORD,
    DDR_CLK_N,
    DDR_CLK_P,
    IO_RST,
    LVDS_N0,
    LVDS_P0,
    WRITE_EN);

integer i,i1;
reg [11:0]buffer;
parameter SOL = 48'hFFF_000_000_800;
parameter SOF = 48'hFFF_000_000_9D0;
parameter EOL = 48'hFFF_000_000_AB0;
parameter EOF = 48'hFFF_000_000_B60;
parameter TP = 12'hA5B;

    
initial
begin
    #1000 DDR_CLK_N = 0;
       DDR_CLK_P = 1;
       LVDS_P0 = 0;
       LVDS_N0 = ~LVDS_P0;
       IO_RST = 1;
    #20 IO_RST = 0;

    
    for(i=0; i<100; i=i+1)
    begin
        #5  LVDS_P0 = 1;
            LVDS_N0 = ~LVDS_P0;
    end
    
    for(i=0; i<5; i=i+1)
    begin
        for(i1=0; i1<12; i1=i1+1)
        begin
        #5  LVDS_P0 = TP[i1];
            LVDS_N0 = ~LVDS_P0;
        end
    end
    for(i=0; i<12; i=i+1)
    begin
        #5  LVDS_P0 = 1;
            LVDS_N0 = ~LVDS_P0;
    end
    for(i=0; i<=47; i=i+1)
    begin
        #5  LVDS_P0 = SOF[i];
            LVDS_N0 = ~LVDS_P0;
    end
    
    for(i=0; i<30; i=i+1)
    begin
        buffer = i;
        for(i1=0; i1<12; i1=i1+1)
        begin
            #5  LVDS_P0 = buffer[i1];
                LVDS_N0 = ~LVDS_P0;
        end
    end
    
    for(i=0; i<48; i=i+1)
    begin
        #5  LVDS_P0 = EOL[i];
            LVDS_N0 = ~LVDS_P0;
    end
    
    for(i=0; i<48; i=i+1)
    begin
        #5  LVDS_P0 = 1;
            LVDS_N0 = ~LVDS_P0;
    end
    
    for(i=0; i<5; i=i+1)
    begin
        for(i1=0; i1<12; i1=i1+1)
        begin
        #5  LVDS_P0 = TP[i1];
            LVDS_N0 = ~LVDS_P0;
        end
    end
    for(i=0; i<12; i=i+1)
    begin
        #5  LVDS_P0 = 1;
            LVDS_N0 = ~LVDS_P0;
    end
    for(i=0; i<=47; i=i+1)
    begin
        #5  LVDS_P0 = SOL[i];
            LVDS_N0 = ~LVDS_P0;
    end
    
    for(i=0; i<30; i=i+1)
    begin
        buffer = i;
        for(i1=0; i1<12; i1=i1+1)
        begin
            #5  LVDS_P0 = buffer[i1];
                LVDS_N0 = ~LVDS_P0;
        end
    end
    
    for(i=0; i<48; i=i+1)
    begin
        #5  LVDS_P0 = EOF[i];
            LVDS_N0 = ~LVDS_P0;
    end
    
end 
always 
begin 
    #5 DDR_CLK_N = ~DDR_CLK_N;
       DDR_CLK_P = ~DDR_CLK_P; 
end
endmodule
