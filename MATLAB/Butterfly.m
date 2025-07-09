%% -------------------------------
clc; clear; close all;

%% Parameters and Fixed-Point Settings
N = 32;  % FFT size

% Fixed-point configuration: signed, 32-bit word, 12-bit fraction
word_length = 16;
frac_length = 8;
T = numerictype(1, word_length, frac_length);
F = fimath('RoundingMethod', 'Nearest', ...
           'OverflowAction', 'Saturate', ...
           'ProductMode', 'SpecifyPrecision', ...
           'ProductWordLength', word_length, ...
           'ProductFractionLength', frac_length, ...
           'SumMode', 'SpecifyPrecision', ...
           'SumWordLength', word_length, ...
           'SumFractionLength', frac_length);

%% Generate 8-bit Integer Input (Simulate ADC)
adc_input = randi([-128, 127], N, 1)/16;  % 8-bit signed ADC
x_fixed = fi(adc_input, T, 'fimath', F);

%% Bit-Reverse Order Input
bit_rev_idx = bitrevorder(1:N);
x_reordered = x_fixed(bit_rev_idx);

%% Precompute Twiddle Factors
W = exp(-2j * pi * (0:N/2-1)/N);  % W_N^k
W_fixed = fi(W, T, 'fimath', F);

%% FFT Stages
X = x_reordered;

for stage = 1:log2(N)
    span = 2^stage;
    half = span / 2;
    
    for start = 1:span:N
        for k = 0:(half-1)
            i = start + k;
            j = i + half;
            twiddle_idx = k * N / span + 1;  % index for W
            w = W_fixed(twiddle_idx);
            
            temp = fi(w * X(j), T, 'fimath', F);
            u = X(i);
            
            X(i) = fi(u + temp, T, 'fimath', F);
            X(j) = fi(u - temp, T, 'fimath', F);
        end
    end
end

X_fixed_result = X;
X_fixed_result_real=bin(real(X));
X_fixed_result_imag=bin(imag(X));

%% Floating-Point MATLAB FFT for Comparison
X_float = fft(double(adc_input));
X_fixed_double_real=dec2bin(real(X_float));
X_fixed_double_imag=dec2bin(imag(X_float));
%% -----------------------
%      PLOTS SECTION
% -----------------------

k = 0:N-1;

% 1. Real part comparison
figure;
stem(k, real(X_float), 'r', 'filled'); hold on;
stem(k, real(X), 'b'); 
legend('Floating-Point (Real)', 'Fixed-Point (Real)');
xlabel('Frequency Bin'); ylabel('Real Part');
title('FFT Real Part Comparison');
grid on;

% 2. Real part error
figure;
stem(k, real(X_float) - real(X), 'k', 'filled');
legend('Error in Real Part');
xlabel('Frequency Bin'); ylabel('Error');
title('Real Part Error');
grid on;

% 3. Imaginary part comparison
figure;
stem(k, imag(X_float), 'r', 'filled'); hold on;
stem(k, imag(X), 'b'); 
legend('Floating-Point (Imag)', 'Fixed-Point (Imag)');
xlabel('Frequency Bin'); ylabel('Imaginary Part');
title('FFT Imaginary Part Comparison');
grid on;

% 4. Imaginary part error
figure;
stem(k, imag(X_float) - imag(X), 'k', 'filled');
legend('Error in Imaginary Part');
xlabel('Frequency Bin'); ylabel('Error');
title('Imaginary Part Error');
grid on;

% 5. Magnitude comparison
figure;
stem(k, abs(X_float), 'r', 'filled'); hold on;
stem(k, sqrt(real(double(X)).^2+imag(double(X)).^2), 'b'); 
legend('Floating-Point |X(k)|', 'Fixed-Point |X(k)|');
xlabel('Frequency Bin'); ylabel('Magnitude');
title('FFT Magnitude Comparison');
grid on;

% 6. Magnitude error
figure;
stem(k, abs(X_float) - sqrt(real(double(X)).^2+imag(double(X)).^2), 'k', 'filled');
legend('Error in Magnitude');
xlabel('Frequency Bin'); ylabel('Error');
title('Magnitude Error');
grid on;