module abs_mod(
    input [9:0] abs_in, 
    output [9:0] abs_out
    );
//input [9:0] abs_in;   // absolute unit input 10bit
  // output [9:0] abs_out;  // absolute unit output 10bit
   //if abs_in MSB is '0' then abs_in = positive
   //   abs_in MSB is '1' then abs_in = negative
   assign abs_out = abs_in[9]? ~(abs_in-1):abs_in;
   
endmodule