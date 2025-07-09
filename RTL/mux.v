module mux #(parameter WIDTH = 13) (
	input		wire		[WIDTH-1:0]			IN0,
	input		wire		[WIDTH-1:0]			IN1,			
	input		wire							sel,
	output 		reg			[WIDTH-1:0]			mux_out
);

always @(*) begin 
	if (sel) begin
		mux_out = IN1;
	end
	else begin
		mux_out = IN0;
	end
end

endmodule