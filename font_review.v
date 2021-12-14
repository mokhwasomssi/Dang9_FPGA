/*---------------------------------------------------------*/
// text on screen 
/*---------------------------------------------------------*/
// P1_win region
wire [6:0] char_addr1;
reg [6:0] char_addr1_s1;
wire [2:0] bit_addr1;
reg [2:0] bit_addr1_s1;
wire [3:0] row_addr1, row_addr1_s1; 
wire P2_win_on1;

wire font_bit1;
wire [7:0] font_word1;
wire [10:0] rom_addr1;

font_rom_vhd font_rom_inst1 (clk, rom_addr1, font_word11);

assign rom_addr1 = {char_addr1, row_addr1};
assign font_bit1 = font_word1[~bit_addr1]; //화면 x좌표는 왼쪽이 작은데, rom의 bit는 오른쪽이 작으므로 reverse

assign char_addr1 = (P2_win_on1)? char_addr1_s1 : 0;
assign row_addr1  = (P2_win_on1)? row_addr1_s1  : 0; 
assign bit_addr1  = (P2_win_on1)? bit_addr1_s1  : 0; 

// LINE1
wire [9:0] P1_win_x_l1, P1_win_y_t1;
assign P1_win_x_l1 = 100; 
assign P1_win_y_t1 = 0; 
assign P1_win_on1 = (y>=P1_win_y_t1 && y<P1_win_y_t1+16 && x>=P1_win_x_l1 && x<P1_win_x_l1+8*4)? 1 : 0; 
assign row_addr1_s1 = y-P1_win_y_t1;
always @ (*) begin
    if (x>=P1_win_x_l1+8*0 && x<P1_win_x_l1+8*1)      begin bit_addr1_s1 = x-P1_win_x_l-8*0; char_addr1_s1 = 7'b1010011; end // S x53    
    else if (x>=P1_win_x_l1+8*1 && x<P1_win_x_l1+8*2) begin bit_addr1_s1 = x-P1_win_x_l-8*1; char_addr1_s1 = 7'b0111010; end // : x3a
    else if (x>=P1_win_x_l1+8*2 && x<P1_win_x_l1+8*3) begin bit_addr1_s1 = x-P1_win_x_l-8*2; char_addr1_s1 = 7'b1010011; end // S x53
    else if (x>=P1_win_x_l1+8*3 && x<P1_win_x_l1+8*4) begin bit_addr1_s1 = x-P1_win_x_l-8*3; char_addr1_s1 = 7'b1010011; end // S x53 
    else if (x>=P1_win_x_l1+8*4 && x<P1_win_x_l1+8*5) begin bit_addr1_s1 = x-P1_win_x_l-8*4; char_addr1_s1 = 7'b0111010; end // : x3a
    else if (x>=P1_win_x_l1+8*5 && x<P1_win_x_l1+8*6) begin bit_addr1_s1 = x-P1_win_x_l-8*5; char_addr1_s1 = 7'b1010011; end // S x53 
    else if (x>=P1_win_x_l1+8*6 && x<P1_win_x_l1+8*7) begin bit_addr1_s1 = x-P1_win_x_l-8*6; char_addr1_s1 = 7'b1010011; end // S x53 
    else begin bit_addr1_s1 = 0; char_addr1_s1 = 0; end                         
end

// P2_win region
wire [6:0] char_addr2;
reg [6:0] char_addr2_s1;
wire [2:0] bit_addr2;
reg [2:0] bit_addr2_s1;
wire [3:0] row_addr2, row_addr2_s1; 
wire P2_win_on1;

wire font_bit2;
wire [7:0] font_word2;
wire [10:0] rom_addr2;

font_rom_vhd font_rom_inst2 (clk, rom_addr2, font_word21);

assign rom_addr2 = {char_addr2, row_addr2};
assign font_bit2 = font_word2[~bit_addr2]; //화면 x좌표는 왼쪽이 작은데, rom의 bit는 오른쪽이 작으므로 reverse

assign char_addr2 = (P2_win_on1)? char_addr2_s1 : 0;
assign row_addr2  = (P2_win_on1)? row_addr2_s1  : 0; 
assign bit_addr2  = (P2_win_on1)? bit_addr2_s1  : 0; 

// LINE1
wire [9:0] P2_win_x_l1, P2_win_y_t1;
assign P2_win_x_l1 = 100; 
assign P2_win_y_t1 = 0; 
assign P2_win_on1 = (y>=P2_win_y_t1 && y<P2_win_y_t1+16 && x>=P2_win_x_l1 && x<P2_win_x_l1+8*4)? 1 : 0; 
assign row_addr2_s1 = y-P2_win_y_t1;
always @ (*) begin
    if (x>=P2_win_x_l1+8*0 && x<P2_win_x_l1+8*1)      begin bit_addr2_s1 = x-P1_win_x_l-8*0; char_addr2_s1 = 7'b1010011; end // S x53    
    else if (x>=P2_win_x_l1+8*1 && x<P2_win_x_l1+8*2) begin bit_addr2_s1 = x-P1_win_x_l-8*1; char_addr2_s1 = 7'b0111010; end // : x3a
    else if (x>=P2_win_x_l1+8*2 && x<P2_win_x_l1+8*3) begin bit_addr2_s1 = x-P1_win_x_l-8*2; char_addr2_s1 = 7'b1010011; end // S x53
    else if (x>=P2_win_x_l1+8*3 && x<P2_win_x_l1+8*4) begin bit_addr2_s1 = x-P1_win_x_l-8*3; char_addr2_s1 = 7'b1010011; end // S x53 
    else if (x>=P2_win_x_l1+8*4 && x<P2_win_x_l1+8*5) begin bit_addr2_s1 = x-P1_win_x_l-8*4; char_addr2_s1 = 7'b0111010; end // : x3a
    else if (x>=P2_win_x_l1+8*5 && x<P2_win_x_l1+8*6) begin bit_addr2_s1 = x-P1_win_x_l-8*5; char_addr2_s1 = 7'b1010011; end // S x53 
    else if (x>=P2_win_x_l1+8*6 && x<P2_win_x_l1+8*7) begin bit_addr2_s1 = x-P1_win_x_l-8*6; char_addr2_s1 = 7'b1010011; end // S x53 
    else begin bit_addr2_s1 = 0; char_addr2_s1 = 0; end                         
end
