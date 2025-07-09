%MSE
clc; clear; close all;

%% Parameters
N = 32;  % FFT size
word_length = 16;
num_trials = 32;
frac_range = 8;

avg_magnitude_errors = zeros(length(frac_range), 1);
mse_real = zeros(length(frac_range), 1);
mse_imag = zeros(length(frac_range), 1);

%% Loop over fractional lengths
for f_idx = 1:length(frac_range)
    frac_length = frac_range(f_idx);
    fprintf('Running for frac_length = %d\n', frac_length);
    
    total_magnitude_error = 0;
    total_mse_real = 0;
    total_mse_imag = 0;
    
    % Repeat multiple trials
    for trial = 1:num_trials
        % Step 1: Fixed-point type and fimath
        T = numerictype(1, word_length, frac_length);
        F = fimath('RoundingMethod', 'Nearest', ...
                   'OverflowAction', 'Saturate', ...
                   'ProductMode', 'SpecifyPrecision', ...
                   'ProductWordLength', word_length, ...
                   'ProductFractionLength', frac_length, ...
                   'SumMode', 'SpecifyPrecision', ...
                   'SumWordLength', word_length, ...
                   'SumFractionLength', frac_length);
        
        % Step 2: Random 8-bit input (full range)
        adc_input = randi([-128, 127], N, 1) / 16;
        x_fixed = fi(adc_input, T, 'fimath', F);
        
        % Step 3: Bit-reverse
        bit_rev_idx = bitrevorder(1:N);
        x_reordered = x_fixed(bit_rev_idx);
        
        % Step 4: Twiddle factors
        W = exp(-2j * pi * (0:N/2-1)/N);
        W_fixed = fi(W, T, 'fimath', F);
        
        % Step 5: FFT computation
        X = x_reordered;
        for stage = 1:log2(N)
            span = 2^stage;
            half = span / 2;
            
            for start = 1:span:N
                for k = 0:(half-1)
                    i = start + k;
                    j = i + half;
                    twiddle_idx = k * N / span + 1;
                    w = W_fixed(twiddle_idx);
                    
                    temp = fi(w * X(j), T, 'fimath', F);
                    u = X(i);
                    
                    X(i) = fi(u + temp, T, 'fimath', F);
                    X(j) = fi(u - temp, T, 'fimath', F);
                end
            end
        end
        
        % Step 6: Floating-point FFT and error computation
        X_float = fft(double(adc_input));
        X_fixed_double = double(X);
        
        % Magnitude error
        magnitude_error = mean(abs(abs(X_float) - abs(X_fixed_double)));
        total_magnitude_error = total_magnitude_error + magnitude_error;
        
        % Real and Imaginary Mean Squared Error
        mse_real_trial = mean((real(X_float) - real(X_fixed_double)).^2);
        mse_imag_trial = mean((imag(X_float) - imag(X_fixed_double)).^2);
        total_mse_real = total_mse_real + mse_real_trial;
        total_mse_imag = total_mse_imag + mse_imag_trial;
    end
    
    % Average over trials
    avg_magnitude_errors(f_idx) = total_magnitude_error / num_trials;
    mse_real(f_idx) = total_mse_real / num_trials;
    mse_imag(f_idx) = total_mse_imag / num_trials;
end


%% Print MSE
fprintf('\nMean Squared Error for Real Part (per frac length):\n');
disp(mse_real);

fprintf('Mean Squared Error for Imag Part (per frac length):\n');
disp(mse_imag);
