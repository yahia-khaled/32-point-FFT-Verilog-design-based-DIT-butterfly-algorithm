clc; clear all; close all;
%% parameters
num_of_samples = 32;
numeber_of_FFT_points = 32;
number_fraction = 8;
number_int = 8;
total_bit = number_int + number_fraction;
%% generate real random samples for 32 point FFT
% Seed based on current time (different each run)
rng('shuffle');
% generate FFT points
FFT_points = randi([-2^7 2^7-1],num_of_samples,numeber_of_FFT_points)/16;

%% perform FFT using butterfly
FFT_build_in = fft(FFT_points,[],2);
FFT_butterflt_res = fft_butterfly_32(FFT_points);

[FFT_max_real,~] = max(max(real(FFT_butterflt_res)));

[FFT_max_imag,~] = max(max(imag(FFT_butterflt_res)));
print input stimulus
fileID = fopen("fft_points.txt","w");
FFT_points_mod = FFT_points * 16;
for i = 1 : num_of_samples
    for j = 1 : numeber_of_FFT_points
        % Ensure integer value (round/floor/ceil if needed)
        int_val = round(FFT_points_mod(i, numeber_of_FFT_points-j+1));
        fprintf(fileID, '%s', signed_dec2bin(int_val,8)); % Write 8-bit binary string
    end
    fprintf(fileID,"\n");
end
fclose(fileID);

% print exact values
fileID1 = fopen("MATLAB_result_real_exact.txt","w");
fileID2 = fopen("MATLAB_result_imag_exact.txt","w");
for i = 1 : num_of_samples
    for j = 1 : numeber_of_FFT_points
        fprintf(fileID1, '%0f ',real(FFT_butterflt_res(i,j))); 
        fprintf(fileID2, '%0f ',imag(FFT_butterflt_res(i,j))); 
    end
    fprintf(fileID1,"\n");
    fprintf(fileID2,"\n");
end
fclose(fileID1);
fclose(fileID2);
% twiddle factor
W_32 = (exp((-2*pi*1i)/32)) .^(0:15);

twiddle_factor_real = dec2bin(round(real(W_32 * 2^number_fraction)),total_bit) - '0';

twiddle_factor_imag = dec2bin(round(imag(W_32 *  2^number_fraction)),total_bit) - '0';

%% print twiddle factor
% print real part twiddle factors
fileID = fopen("twiddle_fac_real_part.txt","w");
for i = 1 : size(twiddle_factor_real,1)
    for j = 1 : size(twiddle_factor_real,2)
        fprintf(fileID,"%0d",twiddle_factor_real(i,j));
    end
    fprintf(fileID,"\n");
end
fclose(fileID);
% print imag part twiddle factors
fileID = fopen("twiddle_fac_imag_part.txt","w");
for i = 1 : size(twiddle_factor_imag,1)
    for j = 1 : size(twiddle_factor_imag,2)
        fprintf(fileID,"%0d",twiddle_factor_imag(i,j));
    end
    fprintf(fileID,"\n");
end
fclose(fileID);
%% print ROM content
fileID_1 = fopen("Twiddle_factor_ROM_real.txt","w");
fileID_2 = fopen("Twiddle_factor_ROM_imag.txt","w");
W_32 = W_32 * 2^number_fraction;
for i = 1 : 16
    print_twiddle_factor(W_32(1),fileID_1,fileID_2,total_bit);
end
fprintf(fileID_1,"\n");
fprintf(fileID_2,"\n");
for i = 1 : 8
    print_twiddle_factor(W_32(9),fileID_1,fileID_2,total_bit);
    print_twiddle_factor(W_32(1),fileID_1,fileID_2,total_bit);
end
fprintf(fileID_1,"\n");
fprintf(fileID_2,"\n");
for i = 1 : 4
    for j = 1 : 4
        print_twiddle_factor(W_32(17-4*j),fileID_1,fileID_2,total_bit);
    end
end
fprintf(fileID_1,"\n");
fprintf(fileID_2,"\n");
for i = 1 : 2
    for j = 1 : 8
        print_twiddle_factor(W_32(16-2*j+1),fileID_1,fileID_2,total_bit);
    end
end

fprintf(fileID_1,"\n");
fprintf(fileID_2,"\n");
for i = 1 : 16
    print_twiddle_factor(W_32(16-i+1),fileID_1,fileID_2,total_bit);
end