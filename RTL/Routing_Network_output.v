module Routing_Network_output #(parameter WIDTH = 16)(
    input		wire			[WIDTH*32-1:0]			Real_inputs,
	input		wire			[WIDTH*32-1:0]			imag_inputs,
	input		wire			[2:0]		  	        SB,		
	output		reg				[WIDTH*32-1:0]			Real_outputs,
	output		reg				[WIDTH*32-1:0]			imag_outputs
);

integer i,j;


always @(*) begin
    case (SB)
        3'b000:
        begin
            Real_outputs = Real_inputs;
        end
        3'b001:
        begin
            for ( i=0; i<8; i = i + 1) begin
                for (j=0; j<2; j = j + 1) begin
                    Real_outputs[i*4*WIDTH+j*WIDTH +: WIDTH] = Real_inputs[i*4*WIDTH+2*j*WIDTH +: WIDTH];
                    Real_outputs[i*4*WIDTH+(j+2)*WIDTH +: WIDTH] = Real_inputs[i*4*WIDTH+(2*j+1)*WIDTH  +: WIDTH];
                end
            end
        end
        3'b010:
        begin
            for ( i=0; i<4; i = i + 1) begin
                for (j=0; j<4; j = j + 1) begin
                    Real_outputs[i*8*WIDTH+j*WIDTH +: WIDTH] = Real_inputs[i*8*WIDTH+(2*j)*WIDTH +: WIDTH];
                    Real_outputs[i*8*WIDTH+(j+4)*WIDTH +: WIDTH] = Real_inputs[i*8*WIDTH+(2*j+1)*WIDTH +: WIDTH];
                end
            end
        end
        3'b011:
        begin
            for ( i=0; i<2; i = i + 1) begin
                for (j=0; j<8; j = j + 1) begin
                    Real_outputs[i*16*WIDTH+j*WIDTH +: WIDTH] = Real_inputs[i*16*WIDTH+(2*j)*WIDTH +: WIDTH];
                    Real_outputs[i*16*WIDTH+(j+8)*WIDTH +: WIDTH] = Real_inputs[i*16*WIDTH+(2*j+1)*WIDTH +: WIDTH];
                end
            end
        end
        3'b100:
        begin
            for (j=0; j<16; j = j + 1) begin
                Real_outputs[j*WIDTH +: WIDTH] = Real_inputs[(2*j)*WIDTH +: WIDTH];
                Real_outputs[(j+16)*WIDTH +: WIDTH] = Real_inputs[(2*j+1)*WIDTH +: WIDTH];
            end
        end 
        default:  Real_outputs = 0;
    endcase
end


always @(*) begin
    case (SB)
        3'b000:
        begin
            imag_outputs = imag_inputs;
        end
        3'b001:
        begin
            for ( i=0; i<8; i = i + 1) begin
                for (j=0; j<2; j = j + 1) begin
                    imag_outputs[i*4*WIDTH+j*WIDTH +: WIDTH] = imag_inputs[i*4*WIDTH+2*j*WIDTH +: WIDTH];
                    imag_outputs[i*4*WIDTH+(j+2)*WIDTH +: WIDTH] = imag_inputs[i*4*WIDTH+(2*j+1)*WIDTH  +: WIDTH];
                end
            end
        end
        3'b010:
        begin
            for ( i=0; i<4; i = i + 1) begin
                for (j=0; j<4; j = j + 1) begin
                    imag_outputs[i*8*WIDTH+j*WIDTH +: WIDTH] = imag_inputs[i*8*WIDTH+(2*j)*WIDTH +: WIDTH];
                    imag_outputs[i*8*WIDTH+(j+4)*WIDTH +: WIDTH] = imag_inputs[i*8*WIDTH+(2*j+1)*WIDTH +: WIDTH];
                end
            end
        end
        3'b011:
        begin
            for ( i=0; i<2; i = i + 1) begin
                for (j=0; j<8; j = j + 1) begin
                    imag_outputs[i*16*WIDTH+j*WIDTH +: WIDTH] = imag_inputs[i*16*WIDTH+(2*j)*WIDTH +: WIDTH];
                    imag_outputs[i*16*WIDTH+(j+8)*WIDTH +: WIDTH] = imag_inputs[i*16*WIDTH+(2*j+1)*WIDTH +: WIDTH];
                end
            end
        end
        3'b100:
        begin
            for (j=0; j<16; j = j + 1) begin
                imag_outputs[j*WIDTH +: WIDTH] = imag_inputs[(2*j)*WIDTH +: WIDTH];
                imag_outputs[(j+16)*WIDTH +: WIDTH] = imag_inputs[(2*j+1)*WIDTH +: WIDTH];
            end
        end 
        default:  imag_outputs = 0;
    endcase
end
    
endmodule