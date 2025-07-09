module Register_file #(parameter WIDTH = 16)(
    input 		wire					  		 	clk,
	input 		wire 				    			enable, 
	input 		wire			    				rst_n,  
	input 		wire		[WIDTH*32-1:0]			in_real,  
	input 		wire		[WIDTH*32-1:0]			in_imag,
    input       wire                        		finish_flag,  
	output  	reg 		[WIDTH*32-1:0]			output_FFT_real,  
	output 		reg	    	[WIDTH*32-1:0]			output_FFT_imag,
    output  	reg		    [WIDTH*32-1:0]			feedback_real,  
	output 		reg		    [WIDTH*32-1:0]			feedback_imag
);


reg			[2:0] 	counter;


// sample output for FFT output

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		output_FFT_real <= 0;
		output_FFT_imag <= 0;
	end
	else begin
		if (counter == 0 && finish_flag) begin
			output_FFT_real <= in_real;
			output_FFT_imag <= in_imag;
		end
		else if (counter == 0 && ~finish_flag) begin
			output_FFT_real <= 0;
			output_FFT_imag <= 0;
		end
	end
end
// sample output for feedback

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		feedback_real <= 0;
		feedback_imag <= 0;
	end
	else if (enable) begin
		feedback_real <= in_real;
		feedback_imag <= in_imag;
	end
end

// counter to output every 5 clock cycle
	always @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			counter <= 0;
		end else begin
			if (counter == 0 && finish_flag) begin
				counter <= counter + 1;
			end
			else if (counter == 4) begin
				counter <= 0;
			end
			else if (counter != 0) begin
				counter <= counter + 1;
			end
			else begin
				counter <= 0;
			end
		end
	end
endmodule