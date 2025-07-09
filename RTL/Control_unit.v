module Control_unit (
	input 		wire					clk,   
	input 		wire 					enable, 
	input 		wire					rst_n,  
	output		reg			[2:0]		SB,
	output		reg						ISL,
	output		reg						valid,
	output		reg						valid_comb
);


(*fsm_encoding = "sequential"*) reg				[2:0]				current_state;
(*fsm_encoding = "sequential"*) reg				[2:0]				next_state;

reg			[2:0] 	counter;




localparam 		IDLE		=		3'b000;
localparam 		Stage_0		=		3'b001;
localparam 		Stage_1		=		3'b011;
localparam 		Stage_2		=		3'b010;
localparam 		Stage_3		=		3'b110;





always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		current_state <= IDLE;
	end else begin
		current_state <= next_state;
	end
end

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		valid <= 0;
	end else begin
		if (counter == 0 && valid_comb) begin
			valid <= 1;
		end
		else if(counter == 0 && ~valid_comb) begin
			valid <= 0;
		end
	end
end

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		counter <= 0;
	end else begin
		if (counter == 0 && valid_comb) begin
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



always @(*) begin
	case (current_state)
		IDLE: 
		begin
			if (enable) begin
				next_state = Stage_0;
			end
			else begin
				next_state = IDLE;
			end
		end
		Stage_0: next_state = Stage_1;
		Stage_1: next_state = Stage_2;
		Stage_2: next_state = Stage_3;
		Stage_3: next_state = IDLE;
		default: next_state = IDLE;
	endcase
end

always @(*) begin
	case (current_state)
		IDLE:
		begin
			ISL = 0;
			SB = 0;
			valid_comb = 0;
		end
		Stage_0: 
		begin
			ISL = 1;
			SB = 1;
			valid_comb = 0;
		end
		Stage_1: 
		begin
			ISL = 1;
			SB = 2;
			valid_comb = 0;
		end
		Stage_2: 
		begin
			ISL = 1;
			SB = 3;
			valid_comb = 0;
		end
		Stage_3: 
		begin
			ISL = 1;
			SB = 4;
			valid_comb = 1;
		end
		default:
		begin
		 	ISL = 0;
			SB = 0;
			valid_comb = 0;
	 	end 
	endcase
end

endmodule