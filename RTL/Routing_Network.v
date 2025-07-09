module Routing_Network #(parameter WIDTH = 16) (
	input		wire			[WIDTH*32-1:0]			Real_inputs,
	input		wire			[WIDTH*32-1:0]			imag_inputs,
	input		wire			[2:0]					SB,		
	output		reg				[WIDTH*32-1:0]			Real_outputs,
	output		reg				[WIDTH*32-1:0]			imag_outputs
);

integer i,j;

always @(*) begin
	case (SB)
		3'b000:
		begin
				Real_outputs[0 +: WIDTH] = Real_inputs[0 +: WIDTH];
				Real_outputs[WIDTH +: WIDTH] = Real_inputs[WIDTH*16 +: WIDTH];
				Real_outputs[WIDTH*2 +: WIDTH] = Real_inputs[WIDTH*8 +: WIDTH];
				Real_outputs[WIDTH*3 +: WIDTH] = Real_inputs[WIDTH*24 +: WIDTH];
				Real_outputs[WIDTH*4 +: WIDTH] = Real_inputs[WIDTH*4 +: WIDTH];
				Real_outputs[WIDTH*5 +: WIDTH] = Real_inputs[WIDTH*20 +: WIDTH];
				Real_outputs[WIDTH*6 +: WIDTH] = Real_inputs[WIDTH*12 +: WIDTH];
				Real_outputs[WIDTH*7 +: WIDTH] = Real_inputs[WIDTH*28 +: WIDTH];
				Real_outputs[WIDTH*8 +: WIDTH] = Real_inputs[WIDTH*2 +: WIDTH];
				Real_outputs[WIDTH*9 +: WIDTH] = Real_inputs[WIDTH*18 +: WIDTH];
				Real_outputs[WIDTH*10 +: WIDTH] = Real_inputs[WIDTH*10 +: WIDTH];
				Real_outputs[WIDTH*11 +: WIDTH] = Real_inputs[WIDTH*26 +: WIDTH];
				Real_outputs[WIDTH*12 +: WIDTH] = Real_inputs[WIDTH*6 +: WIDTH];
				Real_outputs[WIDTH*13 +: WIDTH] = Real_inputs[WIDTH*22 +: WIDTH];
				Real_outputs[WIDTH*14 +: WIDTH] = Real_inputs[WIDTH*14 +: WIDTH];
				Real_outputs[WIDTH*15 +: WIDTH] = Real_inputs[WIDTH*30 +: WIDTH];
				Real_outputs[WIDTH*16 +: WIDTH] = Real_inputs[WIDTH +: WIDTH];
				Real_outputs[WIDTH*17 +: WIDTH] = Real_inputs[WIDTH*17 +: WIDTH];
				Real_outputs[WIDTH*18 +: WIDTH] = Real_inputs[WIDTH*9 +: WIDTH];
				Real_outputs[WIDTH*19 +: WIDTH] = Real_inputs[WIDTH*25 +: WIDTH];
				Real_outputs[WIDTH*20 +: WIDTH] = Real_inputs[WIDTH*5 +: WIDTH];
				Real_outputs[WIDTH*21 +: WIDTH] = Real_inputs[WIDTH*21 +: WIDTH];
				Real_outputs[WIDTH*22 +: WIDTH] = Real_inputs[WIDTH*13 +: WIDTH];
				Real_outputs[WIDTH*23 +: WIDTH] = Real_inputs[WIDTH*29 +: WIDTH];
				Real_outputs[WIDTH*24 +: WIDTH] = Real_inputs[WIDTH*3 +: WIDTH];
				Real_outputs[WIDTH*25 +: WIDTH] = Real_inputs[WIDTH*19 +: WIDTH];
				Real_outputs[WIDTH*26 +: WIDTH] = Real_inputs[WIDTH*11 +: WIDTH];
				Real_outputs[WIDTH*27 +: WIDTH] = Real_inputs[WIDTH*27 +: WIDTH];
				Real_outputs[WIDTH*28 +: WIDTH] = Real_inputs[WIDTH*7 +: WIDTH];
				Real_outputs[WIDTH*29 +: WIDTH] = Real_inputs[WIDTH*23 +: WIDTH];
				Real_outputs[WIDTH*30 +: WIDTH] = Real_inputs[WIDTH*15 +: WIDTH];
				Real_outputs[WIDTH*31 +: WIDTH] = Real_inputs[WIDTH*31 +: WIDTH];
		end
		3'b001:
		begin
			for (i = 0; i < 8; i = i + 1) begin
				for (j = 0; j < 2; j = j + 1) begin
					Real_outputs[i*WIDTH*4+(j*2)*WIDTH +: WIDTH] = Real_inputs[j*WIDTH+i*WIDTH*4 +: WIDTH];
					Real_outputs[i*WIDTH*4+(j*2+1)*WIDTH +: WIDTH] = Real_inputs[(j+2)*WIDTH+i*WIDTH*4 +: WIDTH];
				end
			end
		end
		3'b010:
		begin
			for (i = 0; i < 4; i = i + 1) begin
				for (j = 0; j < 4; j = j + 1) begin
					Real_outputs[i*WIDTH*8+(j*2)*WIDTH +: WIDTH] = Real_inputs[j*WIDTH+i*WIDTH*8 +: WIDTH];
					Real_outputs[i*WIDTH*8+(j*2+1)*WIDTH +: WIDTH] = Real_inputs[(j+4)*WIDTH+i*WIDTH*8 +: WIDTH];
				end
			end
		end
		3'b011:
		begin
			for (i = 0; i < 2; i = i + 1) begin
				for (j = 0; j < 8; j = j + 1) begin
					Real_outputs[i*WIDTH*16+(j*2)*WIDTH +: WIDTH] = Real_inputs[j*WIDTH+i*WIDTH*16 +: WIDTH];
					Real_outputs[i*WIDTH*16+(j*2+1)*WIDTH +: WIDTH] = Real_inputs[(j+8)*WIDTH+i*WIDTH*16 +: WIDTH];
				end
			end
		end
		3'b100:
		begin
			for (j = 0; j < 16; j = j + 1) begin
				Real_outputs[(j*2)*WIDTH +: WIDTH] = Real_inputs[j*WIDTH +: WIDTH];
				Real_outputs[(j*2+1)*WIDTH +: WIDTH] = Real_inputs[(j+16)*WIDTH +: WIDTH];
			end
		end
		default: Real_outputs = 0;
	endcase
end



always @(*) begin
	case (SB)
		3'b000:
		begin
				imag_outputs[0 +: WIDTH] = imag_inputs[0 +: WIDTH];
				imag_outputs[WIDTH +: WIDTH] = imag_inputs[WIDTH*16 +: WIDTH];
				imag_outputs[WIDTH*2 +: WIDTH] = imag_inputs[WIDTH*8 +: WIDTH];
				imag_outputs[WIDTH*3 +: WIDTH] = imag_inputs[WIDTH*24 +: WIDTH];
				imag_outputs[WIDTH*4 +: WIDTH] = imag_inputs[WIDTH*4 +: WIDTH];
				imag_outputs[WIDTH*5 +: WIDTH] = imag_inputs[WIDTH*20 +: WIDTH];
				imag_outputs[WIDTH*6 +: WIDTH] = imag_inputs[WIDTH*12 +: WIDTH];
				imag_outputs[WIDTH*7 +: WIDTH] = imag_inputs[WIDTH*28 +: WIDTH];
				imag_outputs[WIDTH*8 +: WIDTH] = imag_inputs[WIDTH*2 +: WIDTH];
				imag_outputs[WIDTH*9 +: WIDTH] = imag_inputs[WIDTH*18 +: WIDTH];
				imag_outputs[WIDTH*10 +: WIDTH] = imag_inputs[WIDTH*10 +: WIDTH];
				imag_outputs[WIDTH*11 +: WIDTH] = imag_inputs[WIDTH*26 +: WIDTH];
				imag_outputs[WIDTH*12 +: WIDTH] = imag_inputs[WIDTH*6 +: WIDTH];
				imag_outputs[WIDTH*13 +: WIDTH] = imag_inputs[WIDTH*22 +: WIDTH];
				imag_outputs[WIDTH*14 +: WIDTH] = imag_inputs[WIDTH*14 +: WIDTH];
				imag_outputs[WIDTH*15 +: WIDTH] = imag_inputs[WIDTH*30 +: WIDTH];
				imag_outputs[WIDTH*16 +: WIDTH] = imag_inputs[WIDTH +: WIDTH];
				imag_outputs[WIDTH*17 +: WIDTH] = imag_inputs[WIDTH*17 +: WIDTH];
				imag_outputs[WIDTH*18 +: WIDTH] = imag_inputs[WIDTH*9 +: WIDTH];
				imag_outputs[WIDTH*19 +: WIDTH] = imag_inputs[WIDTH*25 +: WIDTH];
				imag_outputs[WIDTH*20 +: WIDTH] = imag_inputs[WIDTH*5 +: WIDTH];
				imag_outputs[WIDTH*21 +: WIDTH] = imag_inputs[WIDTH*21 +: WIDTH];
				imag_outputs[WIDTH*22 +: WIDTH] = imag_inputs[WIDTH*13 +: WIDTH];
				imag_outputs[WIDTH*23 +: WIDTH] = imag_inputs[WIDTH*29 +: WIDTH];
				imag_outputs[WIDTH*24 +: WIDTH] = imag_inputs[WIDTH*3 +: WIDTH];
				imag_outputs[WIDTH*25 +: WIDTH] = imag_inputs[WIDTH*19 +: WIDTH];
				imag_outputs[WIDTH*26 +: WIDTH] = imag_inputs[WIDTH*11 +: WIDTH];
				imag_outputs[WIDTH*27 +: WIDTH] = imag_inputs[WIDTH*27 +: WIDTH];
				imag_outputs[WIDTH*28 +: WIDTH] = imag_inputs[WIDTH*7 +: WIDTH];
				imag_outputs[WIDTH*29 +: WIDTH] = imag_inputs[WIDTH*23 +: WIDTH];
				imag_outputs[WIDTH*30 +: WIDTH] = imag_inputs[WIDTH*15 +: WIDTH];
				imag_outputs[WIDTH*31 +: WIDTH] = imag_inputs[WIDTH*31 +: WIDTH];
		end
		3'b001:
		begin
			for (i = 0; i < 8; i = i + 1) begin
				for (j = 0; j < 2; j = j + 1) begin
					imag_outputs[i*WIDTH*4+(j*2)*WIDTH +: WIDTH] = imag_inputs[j*WIDTH+i*WIDTH*4 +: WIDTH];
					imag_outputs[i*WIDTH*4+(j*2+1)*WIDTH +: WIDTH] = imag_inputs[(j+2)*WIDTH+i*WIDTH*4 +: WIDTH];
				end
			end
		end
		3'b010:
		begin
			for (i = 0; i < 4; i = i + 1) begin
				for (j = 0; j < 4; j = j + 1) begin
					imag_outputs[i*WIDTH*8+(j*2)*WIDTH +: WIDTH] = imag_inputs[j*WIDTH+i*WIDTH*8 +: WIDTH];
					imag_outputs[i*WIDTH*8+(j*2+1)*WIDTH +: WIDTH] = imag_inputs[(j+4)*WIDTH+i*WIDTH*8 +: WIDTH];
				end
			end
		end
		3'b011:
		begin
			for (i = 0; i < 2; i = i + 1) begin
				for (j = 0; j < 8; j = j + 1) begin
					imag_outputs[i*WIDTH*16+(j*2)*WIDTH +: WIDTH] = imag_inputs[j*WIDTH+i*WIDTH*16 +: WIDTH];
					imag_outputs[i*WIDTH*16+(j*2+1)*WIDTH +: WIDTH] = imag_inputs[(j+8)*WIDTH+i*WIDTH*16 +: WIDTH];
				end
			end
		end
		3'b100:
		begin
			for (j = 0; j < 16; j = j + 1) begin
				imag_outputs[(j*2)*WIDTH +: WIDTH] = imag_inputs[j*WIDTH +: WIDTH];
				imag_outputs[(j*2+1)*WIDTH +: WIDTH] = imag_inputs[(j+16)*WIDTH +: WIDTH];
			end
		end
		default: imag_outputs = 0;
	endcase
end


endmodule