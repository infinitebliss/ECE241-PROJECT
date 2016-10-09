module project(
        CLOCK_50,                       //  On Board 50 MHz
        // Your inputs and outputs here
        KEY,
        SW,
		  PS2_CLK,
		  PS2_DAT,
		  LEDR,
        // The ports below are for the VGA output.  Do not change.
        VGA_CLK,                        //  VGA Clock
        VGA_HS,                         //  VGA H_SYNC
        VGA_VS,                         //  VGA V_SYNC
        VGA_BLANK,                      //  VGA BLANK
        VGA_SYNC,                       //  VGA SYNC
        VGA_R,                          //  VGA Red[9:0]
        VGA_G,                          //  VGA Green[9:0]
        VGA_B                           //  VGA Blue[9:0]
    );
	 
	 input           CLOCK_50;               //  50 MHz
    
    // Declare your inputs and outputs here
	 input   [3:0]   KEY;
	 input   [9:0]   SW;
	 input PS2_CLK, PS2_DAT;
	 output [5:0]LEDR;
	 
    // Do not change the following outputs
    output          VGA_CLK;                //  VGA Clock
    output          VGA_HS;                 //  VGA H_SYNC
    output          VGA_VS;                 //  VGA V_SYNC
    output          VGA_BLANK;              //  VGA BLANK
    output          VGA_SYNC;               //  VGA SYNC
    output  [9:0]   VGA_R;                  //  VGA Red[9:0]
    output  [9:0]   VGA_G;                  //  VGA Green[9:0]
    output  [9:0]   VGA_B;                  //  VGA Blue[9:0]
    
    
    wire resetn;
    assign resetn = KEY[0];
    
    // Create the colour, x, y and writeEn wires that are inputs to the controller.

    wire [2:0] colour;
    wire [7:0] x;
    wire [6:0] y;
    wire writeEn;

    // Create an Instance of a VGA controller - there can be only one!
    // Define the number of colours as well as the initial background
    // image file (.MIF) for the controller.
    vga_adapter VGA(
            .resetn(resetn),
            .clock(CLOCK_50),
            .colour(colour),
            .x(x),
            .y(y),
            .plot(writeEn),
            /* Signals for the DAC to drive the monitor. */
            .VGA_R(VGA_R),
            .VGA_G(VGA_G),
            .VGA_B(VGA_B),
            .VGA_HS(VGA_HS),
            .VGA_VS(VGA_VS),
            .VGA_BLANK(VGA_BLANK),
            .VGA_SYNC(VGA_SYNC),
            .VGA_CLK(VGA_CLK));
        defparam VGA.RESOLUTION = "160x120";
        defparam VGA.MONOCHROME = "FALSE";
        defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
        defparam VGA.BACKGROUND_IMAGE = "background.mif";
		  
		  
            
    // Put your code here. Your code should produce signals x,y,colour and writeEn
    // for the VGA controller, in addition to any other functionality your design may require.
    
	 //Instance of keyboard
	PS2_Controller KEYBOARD (
				.CLOCK_50(CLOCK_50),
				.reset(resetn),
				//.the_command(),
				//.send_command(),
				.PS2_CLK(PS2_CLK),
				.PS2_DAT(PS2_DAT),
				//.command_was_sent(),
				//.error_communication_timed_out,
				.received_data(received_data),
				.received_data_en(received_data_en)
	
	);
	 wire [6:0]Sel;
	 wire shift, clear;
	 wire [15:0]XY_CORD;
	 wire [89:0] A;
	 wire [29:0]draw_enable;
	 
	 wire [7:0] received_data;
	 wire received_data_en;
	 wire [5:0]d0;
	 wire[5:0] alphabet;
	 
	 alph_converter u0(alphabet, received_data);
	 
	 
    // Instanciate datapath
	 datapath u1 (x, y, color, d0, Sel, enable_draw, writeEn, shift, clear, CLOCK_50);
	 
    // Instanciate FSM control
	 controlpath u2(LEDR, Sel, enable_draw, shift, writeEn, clear, alphabet, received_data_en, d0, CLOCK_50, resetn, KEY[3]);
	 
endmodule

//datapath module
module datapath (x, y, colour, d0, Sel, enable_draw, writeEn, shift, clear, clk);
	input [5:0]Sel;
	input shift, writeEn, clear, clk, enable_draw;
	output [5:0]d0;
	output [2:0]colour;
	output [7:0]x;
	output [6:0]y;
	
	reg [5:0] letter;
	wire [4:0]counter_alphabet;
	wire [4:0]counter_box;
	reg [7:0]x_start;
	reg [6:0]y_start;
	
	
	wire [5:0]d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20,
	d21, d22, d23, d24, d25, d26, d27, d28, d29;
	
	parameter A = 6'b0, B = 6'b000001, C = 6'b000010, D = 6'b000011, E = 6'b000100, F = 6'b000101, G = 6'b000110,
	H = 6'b000111, I = 6'b001000, J = 6'b001001, K = 6'b001010, L = 6'b001011, M = 6'b001100, N = 6'b001101,
	O = 6'b001110, P = 6'b001111, Q = 6'b010000, R = 6'b010001, S = 6'b010010, T = 6'b010011, U = 6'b010100, 
	V = 6'b010101, W = 6'b010110, X = 6'b010111, Y = 6'b011000, Z = 6'b011001, BLANK = 6'b011010, PERIOD = 6'b011011;
	
	//getXY u0(clk, reset, Sel, XY_CORD);
	
	
	upcount_alphabet ua(enable, Clock, counter_alphabet);
	
	upcount_box upbox (enable, Clock, counter_box);
	
	draw draw0 (x, y, colour, letter, x_start, y_start, enable_draw, clk);//12
	
	always @ (*)
    begin
        case(counter_box)
			5'b00000://0
				begin
					letter = d0;
					x_start = 8'd9;
					y_start = 7'd80;
				end
			5'b00001://1
				begin
					letter = d1;
					x_start = 8'd15;
					y_start = 7'd80;
				end
			5'b00010://2
				begin
					letter = d2;
					x_start = 8'd21;
					y_start = 7'd80;
				end
			5'b00011://3
				begin
					letter = d3;
					x_start = 8'd27;
					y_start = 7'd80;
				end
			5'b00100://4
				begin
					letter = d4;
					x_start = 8'd33;
					y_start = 7'd80;
				end
			5'b00101://5
				begin
					letter = d5;
					x_start = 8'd39;
					y_start = 7'd80;
				end
			5'b00110://6
				begin
					letter = d6;
					x_start = 8'd45;
					y_start = 7'd80;
				end
			5'b00111://7
				begin
					letter = d7;
					x_start = 8'd51;
					y_start = 7'd80;
				end
			5'b01000://8
				begin
					letter = d8;
					x_start = 8'd57;
					y_start = 7'd80;
				end
			5'b01001://9
				begin
					letter = d9;
					x_start = 8'd63;
					y_start = 7'd80;
				end
			5'b01010://10
				begin
					letter = d10;
					x_start = 8'd69;
					y_start = 7'd80;
				end
			5'b01011://11
				begin
					letter = d11;
					x_start = 8'd75;
					y_start = 7'd80;
				end
			5'b01100://12
				begin
					letter = d12;
					x_start = 8'd81;
					y_start = 7'd80;
				end
			5'b01101://13
				begin
					letter = d13;
					x_start = 8'd87;
					y_start = 7'd80;
				end
			5'b01110://14
				begin
					letter = d14;
					x_start = 8'd93;
					y_start = 7'd80;
				end
			5'b01111://15
				begin
					letter = d15;
					x_start = 8'd99;
					y_start = 7'd80;
				end
			5'b10000://16
				begin
					letter = d16;
					x_start = 8'd105;
					y_start = 7'd80;
				end
			5'b10001://17
				begin
					letter = d17;
					x_start = 8'd111;
					y_start = 7'd80;
				end
			5'b10010://18
				begin
					letter = d18;
					x_start = 8'd117;
					y_start = 7'd80;
				end
			5'b10011://19
				begin
					letter = d19;
					x_start = 8'd123;
					y_start = 7'd80;
				end
			5'b10100://20
				begin
					letter = d20;
					x_start = 8'd129;
					y_start = 7'd80;
				end
			5'b10101://21
				begin
					letter = d21;
					x_start = 8'd135;
					y_start = 7'd80;
				end
			5'b10110://22
				begin
					letter = d22;
					x_start = 8'd141;
					y_start = 7'd80;
				end
			5'b10111://23
				begin
					letter = d23;
					x_start = 8'd147;
					y_start = 7'd80;
				end
		  endcase
    end
	
	
	
	shiftRegister u1(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20,
	d21, d22, d23, d24, d25, d26, d27, d28, d29, CLOCK_50, reset, shift);
	
endmodule

//FSM module
module controlpath (LEDR, Sel, enable_draw, shift, writeEn, clear, received_data, received_data_en, d0, clk, reset, next);
	input clk, reset, next, received_data_en;
	input [7:0]received_data;
	input [5:0]d0;
	output reg enable_draw;
	output reg [5:0]Sel;
	output reg shift, writeEn, clear;
	output reg [5:0]LEDR;
	
	reg [5:0]PresentState, NextState;
	parameter RESET_S = 6'b000000, CLEAR_S = 6'b000001, FIRST_S = 6'b000010, SECOND_S = 6'b000011,
	THIRD_S = 6'b000100, FOURTH_S = 6'b000101, FIFTH_S = 6'b000110, SIXTH_S = 6'b000111, SEVENTH_S = 6'b001000,
	EIGHTH_S = 6'b001001, NINTH_S = 6'b001010, TENTH_S = 6'b001011, ELEVENTH_S = 6'b001100, TWELTH_S = 6'b001101,
	THIRTEENTH_S = 6'b001110, FOURTEENTH_S = 6'b001111, FIFTEENTH_S = 6'b010000, SIXTEENTH_S = 6'b010001,
	SEVENTEENTH_S = 6'b010010, EIGHTEENTH_S = 6'b010011, NINETEETH_S = 6'b010100, TWENTIETH_S = 6'b010101,
	TWENTYFIRST_S = 6'b010110, TWENTYSECOND_S = 6'b010111, TWENTYTHIRD_S = 6'b011000, TWENTYFOURTH_S = 6'b011001,
	SHIFT_S = 6'b011010, TWENTYSIXTH_S = 6'b011011, TWENTYSEVENTH_S = 6'b011100, TWENTYEIGHTH_S = 6'b011101,
	TWENTYNINTH_S = 6'b011110, THIRTIETH_S = 6'b011111;
	
	//state table
    always@(*)
    begin: state_table
        case(PresentState)
			RESET_S:
				begin
					if(next == 1'b0)
						NextState = FIRST_S;
					else
						NextState = RESET_S;
				end
			CLEAR_S:
				if(next == 1'b0)
					NextState = SHIFT_S;
				else
					NextState = CLEAR_S;
			FIRST_S:
				if(next==1'b0)
					NextState = SECOND_S;
				else
					NextState = FIRST_S;
			SECOND_S:
				if(next==1'b0)
					NextState = THIRD_S;
				else
					NextState = SECOND_S;
			THIRD_S:
				if(next==1'b0)
					NextState = FOURTH_S;
				else
					NextState = THIRD_S;
			FOURTH_S:
				if(next==1'b0)
					NextState = FIFTH_S;
				else
					NextState = FOURTH_S;
			FIFTH_S:
				if(next==1'b0)
					NextState = SIXTH_S;
				else
					NextState = FIFTH_S;
			SIXTH_S:
				if(next==1'b0)
					NextState = SEVENTH_S;
				else
					NextState = SIXTH_S;
			SEVENTH_S:
				if(next==1'b0)
					NextState = EIGHTH_S;
				else
					NextState = SEVENTH_S;
			EIGHTH_S:
				if(next==1'b0)
					NextState = NINTH_S;
				else
					NextState = EIGHTH_S;
			NINTH_S:
				if(next==1'b0)
					NextState = TENTH_S;
				else
					NextState = NINTH_S;
			TENTH_S:
				if(next==1'b0)
				NextState = ELEVENTH_S;
				else
					NextState = TENTH_S;
			ELEVENTH_S:
				if(next==1'b0)
				NextState = TWELTH_S;
				else
					NextState = ELEVENTH_S;
			TWELTH_S:
				if(next==1'b0)
				NextState = THIRTEENTH_S;
				else
					NextState = TWELTH_S;
			THIRTEENTH_S:
				if(next==1'b0)
				NextState = FOURTEENTH_S;
				else
					NextState = THIRTEENTH_S;
			FOURTEENTH_S:
				if(next==1'b0)
				NextState = FIFTEENTH_S;
				else
					NextState = FOURTEENTH_S;
			FIFTEENTH_S:
				if(next==1'b0)
				NextState = SIXTEENTH_S;
				else
					NextState = FIFTEENTH_S;
			SIXTEENTH_S: 
				if(next==1'b0)
				NextState =  SEVENTEENTH_S;
				else
					NextState = SIXTEENTH_S;
			SEVENTEENTH_S: 
				if(next==1'b0)
				NextState = EIGHTEENTH_S;
				else
					NextState = SEVENTEENTH_S;
			EIGHTEENTH_S:
				if(next==1'b0)
				NextState = NINETEETH_S;
				else
					NextState = EIGHTEENTH_S;
			NINETEETH_S:
				if(next==1'b0)
				NextState = TWENTIETH_S;
				else
					NextState = NINETEETH_S;
			TWENTIETH_S:
				if(next==1'b0)
				NextState = TWENTYFIRST_S;
				else
					NextState = TWENTIETH_S;
			TWENTYFIRST_S:
				if(next==1'b0)
					NextState = TWENTYSECOND_S;
					else
					NextState = TWENTYFIRST_S;
			TWENTYSECOND_S:
				if(next==1'b0)
				NextState = TWENTYTHIRD_S;
				else
					NextState = TWENTYSECOND_S;
			TWENTYTHIRD_S:
				if(next==1'b0)
				NextState = TWENTYFOURTH_S;
				else
					NextState = TWENTYTHIRD_S;
			TWENTYFOURTH_S:
				if(received_data_en && received_data[0] == d0)
					NextState = CLEAR_S;
					else
					NextState = TWENTYFOURTH_S;
			SHIFT_S:
					NextState = FIRST_S;
				default: NextState = RESET_S;
			endcase
		end // state_table
		
		//state registers
    always@(posedge clk)
    begin: state_FFs
        if(reset == 1'b0)
            PresentState <= RESET_S;
        else
            PresentState <= NextState;
    end //state_FFs
	 
	 //output logic
    always@(*)
    begin: output_logic
        case(PresentState)
			RESET_S:
				begin
					Sel = 6'b000000;
					shift = 0;
					writeEn = 0;
					clear = 1;
					enable_draw = 0;
					LEDR = RESET_S;
				end
			CLEAR_S:
				begin
					Sel = 6'b000000;
					shift = 0;
					writeEn = 0;
					clear = 1;
					enable_draw = 0;
					LEDR = CLEAR_S;
				end
			FIRST_S:
				begin
					Sel = 6'b000000;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = FIRST_S;
				end
			SECOND_S:
				begin
					Sel = 6'b000001;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = SECOND_S;
				end
			THIRD_S:
				begin
					Sel = 6'b000010;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = THIRD_S;
				end
			FOURTH_S:
				begin
					Sel = 6'b000011;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = FOURTH_S;
				end
			FIFTH_S:
				begin
					Sel = 6'b000100;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = FIFTH_S;
				end
			SIXTH_S:
				begin
					Sel = 6'b000101;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = SIXTH_S;
				end
			SEVENTH_S:
				begin
					Sel = 6'b000110;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = SEVENTH_S;
				end
			EIGHTH_S:
				begin
					Sel = 6'b000111;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = EIGHTH_S;
				end
			NINTH_S:
				begin
					Sel = 6'b001000;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = NINTH_S;
				end
			TENTH_S:
				begin
					Sel = 6'b001001;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = TENTH_S;
				end
			ELEVENTH_S:
				begin
					Sel = 6'b001010;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = ELEVENTH_S;
				end
			TWELTH_S:
				begin
					Sel = 6'b001011;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = TWELTH_S;
				end
			THIRTEENTH_S:
				begin
					Sel = 6'b001100;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = THIRTEENTH_S;
				end
			FOURTEENTH_S:
				begin
					Sel = 6'b001101;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = FOURTEENTH_S;
				end
			FIFTEENTH_S:
				begin
					Sel = 6'b001110;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = FIFTEENTH_S;
				end
			SIXTEENTH_S:
				begin
					Sel = 6'b001111;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = SIXTEENTH_S;
				end
			SEVENTEENTH_S:
				begin
					Sel = 6'b010000;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = SEVENTEENTH_S;
				end
			EIGHTEENTH_S:
				begin
					Sel = 6'b010001;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = EIGHTEENTH_S;
				end
			NINETEETH_S:
				begin
					Sel = 6'b010010;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = NINETEETH_S;
				end
			TWENTIETH_S:
				begin
					Sel = 6'b010011;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = TWENTIETH_S;
				end
			TWENTYFIRST_S:
				begin
					Sel = 6'b010100;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = TWENTYFIRST_S;
				end
			TWENTYSECOND_S:
				begin
					Sel = 6'b010101;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = TWENTYSECOND_S;
				end
			TWENTYTHIRD_S:
				begin
					Sel = 6'b010110;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = TWENTYTHIRD_S;
				end
			TWENTYFOURTH_S:
				begin
					Sel = 6'b010111;
					shift = 0;
					writeEn = 1;
					clear = 0;
					enable_draw = 1;
					LEDR = TWENTYFOURTH_S;
				end
			SHIFT_S:
				begin
					Sel = 6'b0;
					shift = 1;
					writeEn = 0;
					clear = 1;
					enable_draw = 0;
					LEDR = SHIFT_S;
				end
		  endcase
	end
endmodule


module shiftRegister (d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20,
	d21, d22, d23, d24, d25, d26, d27, d28, d29, CLOCK_50, reset, shift);
	input CLOCK_50, reset, shift;
	//input [43:0];
	output [5:0]d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20,
	d21, d22, d23, d24, d25, d26, d27, d28, d29;
	
	parameter A = 6'b0, B = 6'b000001, C = 6'b000010, D = 6'b000011, E = 6'b000100, F = 6'b000101, G = 6'b000110,
	H = 6'b000111, I = 6'b001000, J = 6'b001001, K = 6'b001010, L = 6'b001011, M = 6'b001100, N = 6'b001101,
	O = 6'b001110, P = 6'b001111, Q = 6'b010000, R = 6'b010001, S = 6'b010010, T = 6'b010011, U = 6'b010100, 
	V = 6'b010101, W = 6'b010110, X = 6'b010111, Y = 6'b011000, Z = 6'b011001, BLANK = 6'b011010, PERIOD = 6'b011011;
	
	mux2to1 m43 (d43, PERIOD , SPACE, shift); // input empty space for y
	D_FF dff43 (q43, CLOCK_50, reset, d43);
	
	mux2to1 m42 (d42, G, q43, shift);
	D_FF dff42 (q42, CLOCK_50, reset, d42);
	
	mux2to1 m41 (d41, O, q42, shift);
	D_FF dff41 (q41, CLOCK_50, reset, d41);
	
	mux2to1 m40 (d40, D, q41, shift);
	D_FF dff40 (q40, CLOCK_50, reset, d40);
	
	mux2to1 m39 (d39, SPACE, q40, shift);
	D_FF dff39 (q39, CLOCK_50, reset, d39);
	
	mux2to1 m38 (d38, Y, q39, shift);
	D_FF dff38 (q38, CLOCK_50, reset, d38);
	
	mux2to1 m37 (d37, Z, q38, shift);
	D_FF dff37 (q37, CLOCK_50, reset, d37);
	
	mux2to1 m36 (d36, A, q37, shift);
	D_FF dff36 (q36, CLOCK_50, reset, d36);
	
	mux2to1 m35 (d35, L, q36, shift);
	D_FF dff35 (q35, CLOCK_50, reset, d35);
	
	mux2to1 m34 (d34, SPACE, q35, shift);
	D_FF dff34 (q34, CLOCK_50, reset, d34);
	
	mux2to1 m33 (d33, E, q34, shift);
	D_FF dff33 (q33, CLOCK_50, reset, d33);
	
	mux2to1 m32 (d32, H, q33, shift);
	D_FF dff32 (q32, CLOCK_50, reset, d32);
	
	mux2to1 m31 (d31, T, q32, shift);
	D_FF dff31 (q31, CLOCK_50, reset, d31);
	
	mux2to1 m30 (d30, SPACE, q31, shift);
	D_FF dff30 (q30, CLOCK_50, reset, d30);
	
	mux2to1 m29 (d29, R, q30, shift);
	D_FF dff29 (q29, CLOCK_50, reset, d29);
	
	mux2to1 m28 (d28, V, q29, shift);
	D_FF dff28 (q28, CLOCK_50, reset, d28);
	
	mux2to1 m27 (d27, E, q28, shift);
	D_FF dff27 (q27, CLOCK_50, reset, d27);
	
	mux2to1 m26 (d26, O, q27, shift);
	D_FF dff26 (q26, CLOCK_50, reset, d26);
	
	mux2to1 m25 (d25, SPACE, q26, shift);
	D_FF dff25 (q25, CLOCK_50, reset, d25);
	
	mux2to1 m24 (d24, S, q25, shift);
	D_FF dff24 (q24, CLOCK_50, reset, d24);
	
	mux2to1 m23 (d23, P, q24, shift);
	D_FF dff23 (q23, CLOCK_50, reset, d23);
	
	mux2to1 m22 (d22, M, q23, shift);
	D_FF dff22 (q22, CLOCK_50, reset, d22);
	
	mux2to1 m21 (d21, U, q22, shift);
	D_FF dff21 (q21, CLOCK_50, reset, d21);
	
	mux2to1 m20 (d20, J, q21, shift);
	D_FF dff20 (q20, CLOCK_50, reset, d20);
	
	mux2to1 m19 (d19, SPACE, q20, shift);
	D_FF dff19 (q19, CLOCK_50, reset, d19);
	
	mux2to1 m18 (d18, X, q19, shift);
	D_FF dff18 (q18, CLOCK_50, reset, d18);
	
	mux2to1 m17 (d17, O, q18, shift);
	D_FF dff17 (q17, CLOCK_50, reset, d17);
	
	mux2to1 m16 (d16, F, q17, shift);
	D_FF dff16 (q16, CLOCK_50, reset, d16);
	
	mux2to1 m15 (d15, SPACE, q16, shift);
	D_FF dff15 (q15, CLOCK_50, reset, d15);
	
	mux2to1 m14 (d14, N, q15, shift);
	D_FF dff14 (q14, CLOCK_50, reset, d14);
	
	mux2to1 m13 (d13, W, q14, shift);
	D_FF dff13 (q13, CLOCK_50, reset, d13);
	
	mux2to1 m12 (d12, O, q13, shift);
	D_FF dff12 (q12, CLOCK_50, reset, d12);
	
	mux2to1 m11 (d11, R, q12, shift);
	D_FF dff11 (q11, CLOCK_50, reset, d11);
	
	mux2to1 m10 (d10, B, q11, shift);
	D_FF dff10 (q10, CLOCK_50, reset, d10);
	
	mux2to1 m9 (d9, SPACE, q10, shift);
	D_FF dff9 (q9, CLOCK_50, reset, d9);
	
	mux2to1 m8 (d8, K, q9, shift);
	D_FF dff8 (q8, CLOCK_50, reset, d8);
	
	mux2to1 m7 (d7, C, q8, shift);
	D_FF dff7 (q7, CLOCK_50, reset, d7);
	
	mux2to1 m6 (d6, I, q7, shift);
	D_FF dff6 (q6, CLOCK_50, reset, d6);
	
	mux2to1 m5 (d5, U, q6, shift);
	D_FF dff5 (q5, CLOCK_50, reset, d5);
	
	mux2to1 m4 (d4, Q, q5, shift);
	D_FF dff4 (q4, CLOCK_50, reset, d4);
	
	mux2to1 m3 (d3, SPACE, q4, shift);
	D_FF dff3 (q3, CLOCK_50, reset, d3);
	
	mux2to1 m2 (d2, E, q3, shift);
	D_FF dff2 (q2, CLOCK_50, reset, d2);
	
	mux2to1 m1 (d1, H, q2, shift);
	D_FF dff1 (q1, CLOCK_50, reset, d1);
	
	mux2to1 m0 (d0, T, q1, shift);
	D_FF dff0 (q0, CLOCK_50, reset, d0);
	
endmodule

module mux2to1(z, x, y, s); 
	input [24:0]x, y;
	input s;
	output [24:0]z;
	
	assign z = s? y : x;
endmodule

module D_FF (q, clk, reset, enable, d);
    input clk, reset, enable;
    input [5:0]d;
    output reg [5:0]q;
    always @ (posedge clk)
    begin
        if (reset == 1'b0)
            q <= 0;
        else
            q <= d;
    end
endmodule


module upcount_alphabet (enable, Clock, Q);
    input Clock, enable;
     output reg [4:0] Q;
    
    always @(posedge Clock)
        if (Q > 5'd30)
            Q <= 0;
      else if (enable)
            Q <= Q + 1;
endmodule

module upcount_box (enable, Clock, Q);
    input Clock, enable;
     output reg [4:0] Q;
    
    always @(posedge Clock)
        if (Q > 5'd24)
            Q <= 0;
      else if (enable)
            Q <= Q + 1;
endmodule


module upcount_X (enable, Clock, enable_y, Q);
    input Clock, enable;
	 output reg enable_y;
     output reg [2:0] Q;
    
    always @(posedge Clock)
        if (Q > 3'b101)
			begin
            Q <= 0;
				enable_y <= 1'b1;
			end
      else if (enable)
			begin
            Q <= Q + 1;
				enable_y <= 1'b0;
			end
endmodule

module upcount_Y (enable, Clock, Q);
    input Clock, enable;
     output reg [2:0] Q;
    
    always @(posedge Clock)
        if (Q > 3'b101)
            Q <= 0;
      else if (enable)
            Q <= Q + 1;
endmodule

module draw (x_out, y_out, colour, letter, x_start, y_start, enable_draw, clk);
	input enable_draw, clk;
	input [5:0]letter;
	input [7:0]x_start;
	input [6:0]y_start;
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] colour;
	reg [9:0] memory;
	
	wire [4:0] counter_alphabet;
	
	parameter A = 6'b0, B = 6'b000001, C = 6'b000010, D = 6'b000011, E = 6'b000100, F = 6'b000101, G = 6'b000110,
	H = 6'b000111, I = 6'b001000, J = 6'b001001, K = 6'b001010, L = 6'b001011, M = 6'b001100, N = 6'b001101,
	O = 6'b001110, P = 6'b001111, Q = 6'b010000, R = 6'b010001, S = 6'b010010, T = 6'b010011, U = 6'b010100, 
	V = 6'b010101, W = 6'b010110, X = 6'b010111, Y = 6'b011000, Z = 6'b011001, BLANK = 6'b011010, PERIOD = 6'b011011;
	
	upcount_X u0(enable_draw, clk, enable_y, x_cord); //X coordinate to draw
	upcount_Y u1(enable_y, clk, y_cord); //Y coordinate to draw
	
	assign x_out = x_start + x_cord;
	assign y_out = y_start + y_cord;
	
	upcount_alphabet u2(enable, Clock, counter_alphabet);
	
	rom840x3 u3 (memory, clk, colour);
	
	always@(*)
	begin
		case(letter)
			A:
				begin
					memory = {5'b0, counter_alphabet} + 10'b0;
					//rom840x3 A({5'b0, counter_alphabet} + 10'b0, clk, q);
				end
			B:
				begin
					memory = {5'b0, counter_alphabet} + 10'b0000011110;
				end
			C:
				begin
					memory = {5'b0, counter_alphabet} + 10'b0000111100;
					//rom840x3 = C({4'b0, counter_alphabet} + 60, clk, colour);
				end
			D:
				begin
					memory = {4'b0, counter_alphabet} + 10'd90;
					//rom840x3 = D({4'b0, counter_alphabet} + 90, clk, colour);
				end
			E:
				begin
					memory = {4'b0, counter_alphabet} + 10'd120;
					//rom840x3 = E({4'b0, counter_alphabet} + 120, clk, colour);
				end
			F:
				begin
					memory = {4'b0, counter_alphabet} + 10'd150;
					//rom840x3 = F({4'b0, counter_alphabet} + 150, clk, colour);
				end
			G:
				begin
					memory = {4'b0, counter_alphabet} + 10'd180;
					//rom840x3 = G({4'b0, counter_alphabet} + 180, clk, colour);
				end
			H:
				begin
					memory = {4'b0, counter_alphabet} + 10'd210;
					//rom840x3 = H({4'b0, counter_alphabet} + 210, clk, colour);
				end
			I:
				begin
					memory = {4'b0, counter_alphabet} + 10'd240;
					//rom840x3 = I({4'b0, counter_alphabet} + 240, clk, colour);
				end
			J:
				begin
					memory = {4'b0, counter_alphabet} + 10'd270;
					//rom840x3 = J(counter_alphabet + 270, clk, colour);
				end
			K:
				begin
					memory = {4'b0, counter_alphabet} + 10'd300;
					//rom840x3 = K(counter_alphabet + 300, clk, colour);
				end
			L:
				begin
					memory = {4'b0, counter_alphabet} + 10'd330;
					//rom840x3 = L(counter_alphabet + 330, clk, colour);
				end
			M:
				begin
					memory = {4'b0, counter_alphabet} + 10'd360;
					//rom840x3 = M(counter_alphabet + 360, clk, colour);
				end
			N:
				begin
					memory = {4'b0, counter_alphabet} + 10'd390;
					//rom840x3 = N(counter_alphabet + 390, clk, colour);
				end
			O:
				begin
					memory = {4'b0, counter_alphabet} + 10'd420;
					//rom840x3 = (counter_alphabet + 420, clk, colour);
				end
			P:
				begin
					memory = {4'b0, counter_alphabet} + 10'd450;
					//rom840x3 = P(counter_alphabet + 450, clk, colour);
				end
			Q:
				begin
					memory = {4'b0, counter_alphabet} + 10'd480;
				end
			R:
				begin
					memory = {4'b0, counter_alphabet} + 10'd510;
				end
			S:
				begin
					memory = {4'b0, counter_alphabet} + 10'd540;
				end
			T:
				begin
					memory = {4'b0, counter_alphabet} + 10'd570;
				end
			U:
				begin
					memory = {4'b0, counter_alphabet} + 10'd600;
				end
			V:
				begin
					memory = {4'b0, counter_alphabet} + 10'd630;
				end
			W:
				begin
					memory = {4'b0, counter_alphabet} + 10'd660;
				end
			X:
				begin
					memory = {4'b0, counter_alphabet} + 10'd690;;
				end
			Y:
				begin
					memory = {4'b0, counter_alphabet} + 10'd720;
				end
			Z:
				begin
					memory = {4'b0, counter_alphabet} + 10'd750;
				end
			BLANK:
				begin
					memory = {4'b0, counter_alphabet} + 10'd780;
				end
			PERIOD:
				begin
					memory = {4'b0, counter_alphabet} + 10'd810;
				end
			default:
			memory = 10'b0;
		endcase
		end
endmodule

module alph_converter(alphabet, received_data);
    input [7:0]received_data;
    output reg [5:0]alphabet;
    
    parameter A = 6'b0, B = 6'b000001, C = 6'b000010, D = 6'b000011, E = 6'b000100, F = 6'b000101, G = 6'b000110,
    H = 6'b000111, I = 6'b001000, J = 6'b001001, K = 6'b001010, L = 6'b001011, M = 6'b001100, N = 6'b001101,
    O = 6'b001110, P = 6'b001111, Q = 6'b010000, R = 6'b010001, S = 6'b010010, T = 6'b010011, U = 6'b010100, 
    V = 6'b010101, W = 6'b010110, X = 6'b010111, Y = 6'b011000, Z = 6'b011001, BLANK = 6'b011010, PERIOD = 6'b011011;
    
    always@(*)
    begin
        if(received_data == 8'h1C)
            alphabet = A;
        else if (received_data == 8'h32)
            alphabet = B;
        else if (received_data == 8'h21)
            alphabet = C;
        else if (received_data == 8'h23)
            alphabet = D;
        else if (received_data == 8'h24)
            alphabet = E;
        else if (received_data == 8'h2B)
            alphabet = F;
        else if (received_data == 8'h34)
            alphabet = G;
        else if (received_data == 8'h33)
            alphabet = H;
        else if (received_data == 8'h43)
            alphabet = I;
        else if (received_data == 8'h3B)
            alphabet = J;
        else if (received_data == 8'h42)
            alphabet = K;
        else if (received_data == 8'h4B)
            alphabet = L;
        else if (received_data == 8'h3A)
            alphabet = M;
        else if (received_data == 8'h31)
            alphabet = N;
        else if (received_data == 8'h44)
            alphabet = O;
        else if (received_data == 8'h4D)
            alphabet = P;
        else if (received_data == 8'h15)
            alphabet = Q;
        else if (received_data == 8'h2D)
            alphabet = R;
        else if (received_data == 8'h1B)
            alphabet = S;
        else if (received_data == 8'h2C)
            alphabet = T;
        else if (received_data == 8'h3C)
            alphabet = U;
        else if (received_data == 8'h2A)
            alphabet = V;
        else if (received_data == 8'h1D)
            alphabet = W;
        else if (received_data == 8'h22)
            alphabet = X;    
        else if (received_data == 8'h35)
            alphabet = Y;
        else if (received_data == 8'h1A)
            alphabet = Z;
        else if (received_data == 8'h29)
            alphabet = BLANK;
        else if (received_data == 8'h49)
            alphabet = PERIOD;    
    end
endmodule

/*module getXY(clk, reset, Sel, BusWires);
	parameter n = 15;
	input clk, reset;
	input [5:0]Sel;
	output reg [n-1:0]BusWires;
	
	wire [n-1:0]XY_CORD1, XY_CORD2, XY_CORD3, XY_CORD4, XY_CORD5, XY_CORD6, XY_CORD7, XY_CORD8, XY_CORD9,
	XY_CORD10, XY_CORD11, XY_CORD12, XY_CORD13, XY_CORD14, XY_CORD15, XY_CORD16, XY_CORD17,XY_CORD18,
	XY_CORD19, XY_CORD20, XY_CORD21, XY_CORD22, XY_CORD23, XY_CORD24, XY_CORD25, XY_CORD26, XY_CORD27,
	XY_CORD28,XY_CORD29, XY_CORD30;
	
	//instanciate 30 blocks of registers of alphabet on the screen
	D_FF_XY dff1 (XY_CORD1, clk, reset, {8'b00000110, 7'b01010000}); // coordinates of the 1st letter
	D_FF_XY dff2 (XY_CORD2, clk, reset, {8'b00001100, 7'b01010000}); // coordinates of the 2nd letter
	D_FF_XY dff3 (XY_CORD3, clk, reset, {8'b00000110, 7'b01010000}); // coordinates of the 3rd letter
	D_FF_XY dff4 (XY_CORD4, clk, reset, {8'b00000110, 7'b01010000}); // coordinates of the 4th letter
	D_FF_XY dff5 (XY_CORD5, clk, reset, {15'b0}); // coordinates of the 5th letter
	D_FF_XY dff6 (XY_CORD6, clk, reset, {15'b0}); // coordinates of the 6th letter
	D_FF_XY dff7 (XY_CORD7, clk, reset, {15'b0}); // coordinates of the 7th letter
	D_FF_XY dff8 (XY_CORD8, clk, reset, {15'b0}); // coordinates of the 8th letter
	D_FF_XY dff9 (XY_CORD9, clk, reset, {15'b0}); // coordinates of the 9th letter
	D_FF_XY dff10 (XY_CORD10, clk, reset, {15'b0}); // coordinates of the 10th letter
	D_FF_XY dff11 (XY_CORD11, clk, reset, {15'b0}); // coordinates of the 11th letter
	D_FF_XY dff12 (XY_CORD12, clk, reset, {15'b0}); // coordinates of the 12th letter
	D_FF_XY dff13 (XY_CORD13, clk, reset, {15'b0}); // coordinates of the 13th letter
	D_FF_XY dff14 (XY_CORD14, clk, reset, {15'b0}); // coordinates of the 14th letter
	D_FF_XY dff15 (XY_CORD15, clk, reset, {15'b0}); // coordinates of the 15th letter
	D_FF_XY dff16 (XY_CORD16, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff17 (XY_CORD17, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff18 (XY_CORD18, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff19 (XY_CORD19, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff20 (XY_CORD20, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff21 (XY_CORD21, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff22 (XY_CORD22, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff23 (XY_CORD23, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff24 (XY_CORD24, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff25 (XY_CORD25, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff26 (XY_CORD26, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff27 (XY_CORD27, clk, reset, {15'b0}); // coordinates of the first letter
	D_FF_XY dff28 (XY_CORD28, clk, reset, {15'b0});
	D_FF_XY dff29 (XY_CORD29, clk, reset, {15'b0});
	D_FF_XY dff30 (XY_CORD30, clk, reset, {15'b0});
	
	// Instantiate tri-state drivers
	always @(*)
	begin
		case(Sel)
		6'b000000: BusWires = XY_CORD1;
		6'b000001: BusWires = XY_CORD2;
		6'b000010: BusWires = XY_CORD3;
		6'b000011: BusWires = XY_CORD4;
		6'b000100: BusWires = XY_CORD5;
		6'b000101: BusWires = XY_CORD6;
		6'b000110: BusWires = XY_CORD7;
		6'b000111: BusWires = XY_CORD8;
		6'b001000: BusWires = XY_CORD9;
		6'b001001: BusWires = XY_CORD10;
		6'b001010: BusWires = XY_CORD11;
		6'b001011: BusWires = XY_CORD12;
		6'b001100: BusWires = XY_CORD13;
		6'b001101: BusWires = XY_CORD14;
		6'b001110: BusWires = XY_CORD15;
		6'b001111: BusWires = XY_CORD16;
		6'b010000: BusWires = XY_CORD17;
		6'b010001: BusWires = XY_CORD18;
		6'b010010: BusWires = XY_CORD19;
		6'b010011: BusWires = XY_CORD20;
		6'b010100: BusWires = XY_CORD21;
		6'b010101: BusWires = XY_CORD22;
		6'b010110: BusWires = XY_CORD23;
		6'b010111: BusWires = XY_CORD24;
		6'b011000: BusWires = XY_CORD25;
		6'b011001: BusWires = XY_CORD26;
		6'b011010: BusWires = XY_CORD27;
		6'b011011: BusWires = XY_CORD28;
		6'b011100: BusWires = XY_CORD29;
		6'b011101: BusWires = XY_CORD30;
		default: BusWires = 15'b0;
		endcase
	end
endmodule
*/

/*module trin (Y, E, F);
	parameter n=15;
	input [n-1:0]Y;
	input E;
	output wire [n-1:0] F;
	assign F = E?Y: 'bz;
endmodule
*/

/*module D_FF_XY (q, clk, reset, d);
    input clk, reset;
    input [14:0]d;
    output reg [14:0]q;
    always @ (posedge clk)
    begin
        if (reset == 1'b0)
            q <= 0;
        else
            q <= d;
    end
endmodule
*/