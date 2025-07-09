module FFT #(parameter WIDTH = 16,FRACTION_BITS = 8)(
	input 		wire									clk,  
	input		wire									enable, 
	input		wire									rst_n,  // Asynchronous reset active low
	input		wire				[255:0]				fft_points,
	output 		wire				[WIDTH*32-1:0]		real_output,
	output 		wire 				[WIDTH*32-1:0]		imag_output,
	output 		wire									valid
);

integer i;

reg				[WIDTH*32-1:0]			fft_point_sign_extended;
wire			[WIDTH*32-1:0]			mux_outputs_real;
wire			[WIDTH*32-1:0]			mux_outputs_imag;
wire									ISL_top;
wire			[2:0]					SB_top;
wire 			[WIDTH*16-1:0]			Twiddle_factors_real;
wire 			[WIDTH*16-1:0]			Twiddle_factors_imag;
wire			[WIDTH*32-1:0]			feedback_real;
wire			[WIDTH*32-1:0]			feedback_imag;
wire									finish_flag;
wire			[WIDTH*32-1:0]			Routing_Network_out_real;
wire			[WIDTH*32-1:0]			Routing_Network_out_imag;



always @(*) begin
	for (i = 0; i < 32; i = i + 1) begin
		fft_point_sign_extended[i*WIDTH +: WIDTH] = {{(WIDTH-4-FRACTION_BITS){fft_points[i*8+7]}},fft_points[i*8 +: 8],{(FRACTION_BITS-4){1'b0}}};
	end
end



// generate input mux
genvar j;
generate
	for (j = 0; j < 32; j = j + 1) begin
		mux #(.WIDTH(WIDTH)) mux_inst (
			.IN0    (fft_point_sign_extended[j*WIDTH +: WIDTH]),
			.IN1    (feedback_real[j*WIDTH +: WIDTH]),
			.sel    (ISL_top),
			.mux_out(mux_outputs_real[j*WIDTH +: WIDTH])
		);
	end
endgenerate

assign mux_outputs_imag = ISL_top ? feedback_imag : 'b0;

// Routing network

wire		[WIDTH*32-1:0]			Routing_Network_real;
wire		[WIDTH*32-1:0]			Routing_Network_imag;


Routing_Network #(.WIDTH(WIDTH)) NET_1 (
	.Real_inputs (mux_outputs_real),
	.imag_inputs (mux_outputs_imag),
	.SB          (SB_top),
	.Real_outputs(Routing_Network_real),
	.imag_outputs(Routing_Network_imag)
);

// MAC units
wire		[WIDTH*32-1:0]			MAC_real;
wire		[WIDTH*32-1:0]			MAC_imag;

		
genvar k;
generate
	for (k = 0; k < 16; k = k + 1) begin
		MAC_unit #(.WIDTH(WIDTH),.FRACTION_BITS(FRACTION_BITS)) MAC_ints (
			.in_1_real            (Routing_Network_real[2*k*WIDTH +: WIDTH]),
			.in_1_imag            (Routing_Network_imag[2*k*WIDTH +: WIDTH]),
			.in_2_real            (Routing_Network_real[(2*k+1)*WIDTH +: WIDTH]),
			.in_2_imag            (Routing_Network_imag[(2*k+1)*WIDTH +: WIDTH]),
			.twiddle_factor_real  (Twiddle_factors_real[k*WIDTH +: WIDTH]),
			.twiddle_factor_imag  (Twiddle_factors_imag[k*WIDTH +: WIDTH]),
			.result_Even_part_real(MAC_real[2*k*WIDTH +: WIDTH]),
			.result_Odd_part_real (MAC_real[(2*k+1)*WIDTH +: WIDTH]),
			.result_Even_part_imag(MAC_imag[2*k*WIDTH +: WIDTH]),
			.result_Odd_part_imag (MAC_imag[(2*k+1)*WIDTH +: WIDTH])
		);
	end
endgenerate

// Routing Network output of MAC

Routing_Network_output #(.WIDTH(WIDTH)) u_Routing_Network_output(
	.Real_inputs  	(MAC_real   ),
	.imag_inputs  	(MAC_imag   ),
	.SB           	(SB_top            ),
	.Real_outputs 	(Routing_Network_out_real  ),
	.imag_outputs 	(Routing_Network_out_imag  )
);


// control unit

Control_unit CTRL_inst (
	.enable(enable),
	.SB    (SB_top),
	.clk   (clk),
	.rst_n (rst_n),
	.ISL   (ISL_top),
	.valid_comb (finish_flag),
	.valid (valid)
);


// twiddle factor ROM

Twiddle_factor_real_ROM #(.WIDTH(WIDTH)) ROM_real (
	.address        (SB_top),
	.Twiddle_factors(Twiddle_factors_real)
);


Twiddle_factor_imag_ROM #(.WIDTH(WIDTH)) ROM_imag (
	.Twiddle_factors(Twiddle_factors_imag),
	.address        (SB_top)
);


// register file

Register_file #(.WIDTH(WIDTH)) u_Register_file(
	.clk             	(clk              ),
	.enable          	(enable           ),
	.rst_n           	(rst_n            ),
	.in_real         	(Routing_Network_out_real          ),
	.in_imag         	(Routing_Network_out_imag          ),
	.finish_flag     	(finish_flag      ),
	.output_FFT_real 	(real_output  ),
	.output_FFT_imag 	(imag_output  ),
	.feedback_real   	(feedback_real    ),
	.feedback_imag   	(feedback_imag    )
);




endmodule