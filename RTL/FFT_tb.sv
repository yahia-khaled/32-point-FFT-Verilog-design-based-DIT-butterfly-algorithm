`timescale 1ns/1ps
module FFT_tb();

parameter WIDTH = 16;
parameter FRACTION_BITS = 8;
// DUT instantiation
FFT #(.WIDTH(WIDTH),.FRACTION_BITS(FRACTION_BITS))DUT (.*);

logic                                           clk;
logic                                           enable;
logic                                           rst_n;
logic                   [255:0]                 fft_points;
logic       signed      [WIDTH*32-1:0]          real_output;
logic       signed      [WIDTH*32-1:0]          imag_output;
logic                                           valid;

// Test bench signals
bit                   [255:0]                    fft_points_input           [0:31];
bit        signed     [WIDTH*32-1:0]             fft_result_real_desgin     [0:31];
bit        signed     [WIDTH*32-1:0]             fft_result_imag_design     [0:31];
real MATLAB_real_result [0:31][0:31];
real MATLAB_imag_result [0:31][0:31];

real DUT_real_result [0:31][0:31];
real DUT_imag_result [0:31][0:31];


real MSE_real,MSE_imag;

integer loop,success,fileID,file_1,file_2,file_3,file_4,file_5,fileID2;
integer file_handle1,file_handle2;


initial begin
    clk = 0;
    forever begin
        #(5) clk = ~clk;
    end
end

initial begin
     // Open the file
    file_handle1 = $fopen("MATLAB_result_imag_exact.txt", "r");
    file_handle2 = $fopen("MATLAB_result_real_exact.txt", "r");
    // Read data into the 2D array
    for (int row = 0; row < 32; row++) begin
      for (int col = 0; col < 32; col++) begin
        if ($fscanf(file_handle2, "%f", MATLAB_real_result[row][col]) != 1) begin
          $display("Error reading data at row=%0d, col=%0d", row, col);
          $finish;
        end
        if ($fscanf(file_handle1, "%f", MATLAB_imag_result[row][col]) != 1) begin
          $display("Error reading data at row=%0d, col=%0d", row, col);
          $finish;
        end
      end
    end
    $fclose(file_handle1);
    $fclose(file_handle2);
end


initial begin
    $readmemb("fft_points.txt",fft_points_input);
    enable = 0;
    fft_points = 0;
    assert_reset();
    repeat(10) begin
        @(negedge clk);
    end
    fork
        begin
            for (int i=0; i<32; i++) begin
                fft_points = fft_points_input[i];
                enable = 1;
                repeat(5) begin
                    @(negedge clk);
                end
            end
            enable = 0;
        end
        begin
            loop = 0;
            while(loop < 32) begin
                repeat(5) begin
                    @(negedge clk);
                end
                if (valid) begin
                    fft_result_real_desgin[loop] = real_output;
                    fft_result_imag_design[loop] = imag_output;
                    loop++;
                end
            end
        end
    join 
    file_1 = $fopen("FFT_real_des_decimal.txt","w" );
    file_2 = $fopen("FFT_real_MATLAB_decimal.txt","w" );
    file_4 = $fopen("FFT_imag_MATLAB_decimal.txt","w" );
    file_3 = $fopen("FFT_imag_des_decimal.txt","w" );
    file_5 = $fopen("FFT_points_input.txt","w" );
    for (int i=0; i<32; i++) begin
        for (int j=0; j<32; j++) begin
            DUT_real_result[i][j] = $signed(fft_result_real_desgin[i][j*WIDTH +: WIDTH])/(2.0**FRACTION_BITS);
            DUT_imag_result[i][j] = $signed(fft_result_imag_design[i][j*WIDTH +: WIDTH])/(2.0**FRACTION_BITS);
            $fwrite(file_1,"FFT result real design[%0d][%0d] = %0f\n",i,j,DUT_real_result[i][j]);
            $fwrite(file_3,"FFT result imag design[%0d][%0d] = %0f\n",i,j,DUT_imag_result[i][j]);
            $fwrite(file_2,"MATLAB result real design[%0d][%0d] = %0f\n",i,j,MATLAB_real_result[i][j]);
            $fwrite(file_4,"MATLAB result imag design[%0d][%0d] = %0f\n",i,j,MATLAB_imag_result[i][j]);
            $fwrite(file_5,"FFT input point [%0d][%0d] = %0f\n",i,j,$signed(fft_points_input[i][j*8 +: 8])/(2.0**4)); 
        end
    end
    $fclose(file_1);
    $fclose(file_2);
    $fclose(file_4);
    $fclose(file_3);
    $fclose(file_5);
    // measure mean square error
    for (int i = 0; i < 32; i++) begin
        for (int j = 0; j < 32; j++) begin
           MSE_real = MSE_real + (DUT_real_result[i][j] - MATLAB_real_result[i][j])**2;
           MSE_imag = MSE_imag + (DUT_imag_result[i][j] - MATLAB_imag_result[i][j])**2;
        end
    end
    // Normalize by number of elements (32x32 = 1024)
    MSE_real /= (32 * 32);
    MSE_imag /= (32 * 32);

    // Open file and write results with formatting
    file_1 = $fopen("MSE_results.txt", "w");
    if (!file_1) begin
        $display("Error: Could not open MSE_results.txt!");
        $finish;
    end

    // print Mean square error result for both real and imaginary parts
    $fwrite(file_1, "============================================\n");
    $fwrite(file_1, "       MEAN SQUARE ERROR (MSE) REPORT        \n");
    $fwrite(file_1, "============================================\n");
    $fwrite(file_1, "  Real Part MSE      : %0.15f\n", MSE_real);
    $fwrite(file_1, "  Imaginary Part MSE : %0.15f\n", MSE_imag);
    $fwrite(file_1, "--------------------------------------------\n");
    $fwrite(file_1, "  Total MSE          : %0.15f\n", MSE_real + MSE_imag);
    $fwrite(file_1, "============================================\n");
    $fclose(file_1);

    $stop;
end


task assert_reset;
    begin
        rst_n = 0;
        @(negedge clk)
        rst_n = 1;
        @(negedge clk);
    end
endtask




endmodule