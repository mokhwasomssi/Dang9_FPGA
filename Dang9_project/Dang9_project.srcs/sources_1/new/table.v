module table_mod(
    input clk, 
    input rst, 
    
    input [9:0] x, 
    input [9:0] y, 
    
    output table_on
    );

wire table_out_on, table_in_on;

assign table_out_on = (x >= `TABLE_OUT_L && x <= `TABLE_OUT_R - 1 && y >= `TABLE_OUT_T && y <= `TABLE_OUT_B - 1);
assign table_in_on = (x >= `TABLE_IN_L && x <= `TABLE_IN_R - 1 && y >= `TABLE_IN_T && y <= `TABLE_IN_B - 1);

assign table_on = (table_out_on == 1 && table_in_on == 0) ? 1 : 0;

endmodule
