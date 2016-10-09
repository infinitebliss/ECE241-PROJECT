module upcount (Clear, enable, Clock, Q);
    input Clear, Clock, enable;
     output reg [3:0] Q;
    
    always @(posedge Clock)
        if (!Clear || Q > 4'b1110)
            Q <= 0;
      else if (enable)
            Q <= Q + 1;
endmodule




module alphabets(counter, );
input [3:0] counter;
parameter A = 5'd1, B = 5'd2, C = 5'd3, D = 5'd4, E = 5'd5, F = 5'd6, G = 5'd7, H = 5'd8, 
			I = 5'd9, J = 5'd10, K = 5'd11, L = 5'd12, M = 5'd13, N = 5'd14, O = 5'd15, P = 5'd16,
			Q = 5'd17, R = 5'd18, S = 5'd19, T = 5'd20, U = 5'd21, V = 5'd22, W = 5'd23, X = 5'd24, Y = 5'd25, Z = 5'd26;
			

always@(*)
begin:
	case
		A:
			begin:
			//coordinates: colour (black = 1)
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 1
				1010: 1
				1011: 1
				1100: 1
				1101: 0
				1110: 0
				1111: 1
			end
	  B:
		begin:
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 0
				0110: 1
				0111: 1
				1000: 1
				1001: 1
				1010: 0
				1011: 1
				1100: 1
				1101: 1
				1110: 1
				1111: 1
		end
		C:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 0
				1000: 1
				1001: 0
				1010: 0
				1011: 0
				1100: 1
				1101: 1
				1110: 1
				1111: 1		
		end
		D:
		begin	
				0000: 1
				0001: 1
				0010: 1
				0011: 0
				0100: 1
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 0
				1010: 0
				1011: 1
				1100: 1
				1101: 1
				1110: 1
				1111: 1		
			end
		E:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 1
				0110: 0
				0111: 0
				1000: 1
				1001: 0
				1010: 0
				1011: 0
				1100: 1
				1101: 1
				1110: 1
				1111: 1		
		end
		F:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 0
				1000: 1
				1001: 1
				1010: 1
				1011: 0
				1100: 1
				1101: 0
				1110: 0
				1111: 0
		end
		G:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 0
				0100: 1
				0101: 0
				0110: 0
				0111: 0
				1000: 1
				1001: 0
				1010: 0
				1011: 1
				1100: 1
				1101: 1
				1110: 1
				1111: 1		
		end
		H:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 1
				0100: 1
				0101: 1
				0110: 1
				0111: 1
				1000: 1
				1001: 0
				1010: 0
				1011: 1
				1100: 1
				1101: 0
				1110: 0
				1111: 1
		end
		I:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 0
				0101: 1
				0110: 1
				0111: 0
				1000: 0
				1001: 1
				1010: 1
				1011: 0
				1100: 1
				1101: 1
				1110: 1
				1111: 1		
		end
		J:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 0
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 0
				1010: 0
				1011: 1
				1100: 0
				1101: 1
				1110: 1
				1111: 0		
		end
		K:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 1
				0100: 1
				0101: 1
				0110: 1
				0111: 0
				1000: 1
				1001: 1
				1010: 1
				1011: 0
				1100: 1
				1101: 0
				1110: 1
				1111: 1		
		end
		L:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 0
				0100: 1
				0101: 0
				0110: 0
				0111: 0
				1000: 1
				1001: 0
				1010: 0
				1011: 0
				1100: 1
				1101: 1
				1110: 1
				1111: 1
		end
		M:
		begin
				0000: 1
				0001: 0
				0010: 1
				0011: 1
				0100: 1
				0101: 1
				0110: 1
				0111: 1
				1000: 1
				1001: 1
				1010: 0
				1011: 1
				1100: 1
				1101: 0
				1110: 0
				1111: 1
		end
		N:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 1
				0100: 1
				0101: 1
				0110: 0
				0111: 1
				1000: 1
				1001: 0
				1010: 1
				1011: 1
				1100: 1
				1101: 0
				1110: 0
				1111: 1
		end
		O:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 0
				1010: 0
				1011: 1
				1100: 1
				1101: 1
				1110: 1
				1111: 1
		end
		P:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 1
				1010: 1
				1011: 1
				1100: 1
				1101: 0
				1110: 0
				1111: 0
		end
		Q:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 0
				1010: 1
				1011: 1
				1100: 1
				1101: 1
				1110: 1
				1111: 1
		end
		R:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 1
				1010: 1
				1011: 0
				1100: 1
				1101: 0
				1110: 1
				1111: 1
		end
		S:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 1
				0101: 1
				0110: 0
				0111: 0
				1000: 0
				1001: 0
				1010: 1
				1011: 1
				1100: 1
				1101: 1
				1110: 1
				1111: 1
		end	
		T:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 0
				0101: 1
				0110: 1
				0111: 0
				1000: 0
				1001: 1
				1010: 1
				1011: 0
				1100: 0
				1101: 1
				1110: 1
				1111: 0
		end
		U:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 0
				1010: 0
				1011: 1
				1100: 1
				1101: 1
				1110: 1
				1111: 1
		end
		V:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 1
				0100: 1
				0101: 0
				0110: 0
				0111: 1
				1000: 1
				1001: 0
				1010: 0
				1011: 1
				1100: 0
				1101: 1
				1110: 1
				1111: 0
		end
		W:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 1
				0100: 1
				0101: 0
				0110: 1
				0111: 1
				1000: 1
				1001: 1
				1010: 1
				1011: 1
				1100: 1
				1101: 1
				1110: 0
				1111: 1		
		end
		X:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 1
				0100: 0
				0101: 1
				0110: 1
				0111: 0
				1000: 0
				1001: 1
				1010: 1
				1011: 0
				1100: 1
				1101: 0
				1110: 0
				1111: 1
		end
		Y:
		begin
				0000: 1
				0001: 0
				0010: 0
				0011: 1
				0100: 1
				0101: 1
				0110: 1
				0111: 1
				1000: 0
				1001: 1
				1010: 1
				1011: 0
				1100: 0
				1101: 1
				1110: 1
				1111: 0
		end
		Z:
		begin
				0000: 1
				0001: 1
				0010: 1
				0011: 1
				0100: 0
				0101: 0
				0110: 1
				0111: 1
				1000: 1
				1001: 1
				1010: 0
				1011: 0
				1100: 1
				1101: 1
				1110: 1
				1111: 1
		end
		
endmodule



module controlpath(LEDR, enable, plot, black, go, counter, counter_black, reset, clk, KEY[2]);
    input go, reset, clk;
	 input [3:0] counter;
	 input [14:0] counter_black;
     input [2:2]KEY;
    output reg enable, plot, black;
	 output reg [3:0]LEDR;
    
    reg [3:0]PresentState, NextState;
    parameter RESET_S = 4'b0000, BOX_S = 4'b0001, BLACK_S = 4'b0010, EXIT_S = 4'b0011;
    
    //state table
    always@(*)
    begin: state_table
        case(PresentState)
            RESET_S: 
                begin
                    if (go == 1'b0)
                        NextState = BOX_S;
                    else if(KEY[2] == 1'b0)
                         NextState = BLACK_S;
                    else
                        NextState = RESET_S;
                end
            BOX_S:
                begin
                    if (counter <= 4'b1110)//14 in binary
                        NextState = BOX_S;
                    else
                        NextState = EXIT_S;
                end
                BLACK_S:
						if(counter_black <=15'b111111111111111)
							NextState = BLACK_S;
							else
                    NextState = EXIT_S;
            EXIT_S:
                begin
						if(go == 1'b1)
                    NextState = RESET_S;
						else
							NextState = EXIT_S;
                end
            default:
                NextState = RESET_S;
        endcase
    end//state_table
    
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
                    enable = 0;
                    plot = 0;
                          black = 0;
								  LEDR = RESET_S;
                end
            BOX_S:
                begin
                    enable = 1;
                    plot = 1;
                          black = 0;
								  LEDR = BOX_S;
                end
                BLACK_S:
                    begin
                        enable =1;
                        plot = 1;
                        black = 1;
								LEDR = BLACK_S;
                    end
            EXIT_S:
                begin
                    enable = 0;
                    plot = 1;
                          black = 0;
								  LEDR = EXIT_S;
                end
            endcase
        end
endmodule

