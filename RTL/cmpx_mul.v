module cmpx_mul #(parameter M = 8) (
	input	wire	signed	[M-1:0]		num1_real_part,
	input	wire	signed	[M-1:0]		num1_imag_part,   
	input	wire	signed	[M-1:0]		num2_real_part,
	input	wire	signed	[M-1:0]		num2_imag_part, 
	output	reg		signed	[2*M:0]		result_real,
	output	reg		signed 	[2*M:0]		result_imag      
);


// complex multiplication by constant complex number
always @(*) begin
	result_real = num1_real_part * num2_real_part - num1_imag_part * num2_imag_part;
	result_imag = num1_imag_part * num2_real_part + num1_real_part * num2_imag_part;
end

endmodule