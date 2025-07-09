module MAC_unit #(parameter WIDTH = 8, FRACTION_BITS = 5) ( 
	input 	wire	signed		[WIDTH-1:0]			in_1_real,
	input 	wire	signed		[WIDTH-1:0]			in_1_imag,
	input 	wire	signed		[WIDTH-1:0]			in_2_real,
	input 	wire	signed		[WIDTH-1:0]			in_2_imag,
	input 	wire	signed		[WIDTH-1:0]			twiddle_factor_real,
	input 	wire	signed		[WIDTH-1:0]			twiddle_factor_imag,
	output	reg		signed		[WIDTH-1:0]			result_Even_part_real,
	output	reg		signed		[WIDTH-1:0]			result_Odd_part_real,
	output	reg		signed		[WIDTH-1:0]			result_Even_part_imag,
	output	reg		signed		[WIDTH-1:0]			result_Odd_part_imag
);


wire		signed	[2*WIDTH:0]		cmpx_real_out;
wire		signed	[2*WIDTH:0]		cmpx_imag_out;
wire		signed	[WIDTH-1:0]		temp1,temp2;


assign temp1 = cmpx_real_out>>>FRACTION_BITS;
assign temp2 = cmpx_imag_out>>>FRACTION_BITS;


always @(*) begin
	result_Even_part_real = in_1_real + temp1;
	result_Even_part_imag = in_1_imag + temp2;
	result_Odd_part_real  = in_1_real - temp1;
	result_Odd_part_imag  = in_1_imag - temp2;
end

cmpx_mul #(.M(WIDTH)) MUL_1(
.num1_real_part(in_2_real),
.num1_imag_part(in_2_imag),
.num2_real_part(twiddle_factor_real),
.num2_imag_part(twiddle_factor_imag),
.result_real   (cmpx_real_out),
.result_imag   (cmpx_imag_out)
);


endmodule