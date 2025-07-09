% clc; clear; close all;

%% Parameters
N = 32;  % FFT size
word_length = 16;
num_trials = 10;
frac_range = 8;

% Initialize error storage
avg_error_pos_only = zeros(length(frac_range), 1);
avg_error_pos_neg = zeros(length(frac_range), 1);

for f_idx = 1:length(frac_range)
    frac_length = frac_range(f_idx);
    fprintf('Running for frac_length = %d\n', frac_length);
    
    error_pos = 0;
    error_signed = 0;
    
    for trial = 1:num_trials
        % Numeric type and fimath config
        T = numerictype(1, word_length, frac_length);
        F = fimath('RoundingMethod', 'Nearest', ...
                   'OverflowAction', 'Saturate', ...
                   'ProductMode', 'SpecifyPrecision', ...
                   'ProductWordLength', word_length, ...
                   'ProductFractionLength', frac_length, ...
                   'SumMode', 'SpecifyPrecision', ...
                   'SumWordLength', word_length, ...
                   'SumFractionLength', frac_length);

        %% ---------- Test Case 1: Positive Inputs ----------
        adc_input_pos = randi([0, 127], N, 1)/16;
        x_fixed_pos = fi(adc_input_pos, T, 'fimath', F);
        bit_rev_idx = bitrevorder(1:N);
        x_reordered = x_fixed_pos(bit_rev_idx);
        W = exp(-2j * pi * (0:N/2-1)/N);
        W_fixed = fi(W, T, 'fimath', F);
        X = x_reordered;
        
        for stage = 1:log2(N)
            span = 2^stage;
            half = span / 2;
            for start = 1:span:N
                for k = 0:(half-1)
                    i = start + k;
                    j = i + half;
                    w = W_fixed(k * N / span + 1);
                    temp = fi(w * X(j), T, 'fimath', F);
                    u = X(i);
                    X(i) = fi(u + temp, T, 'fimath', F);
                    X(j) = fi(u - temp, T, 'fimath', F);
                end
            end
        end
        X_fixed_double = double(X);
        X_float = fft(adc_input_pos);
        error_pos = error_pos + mean(abs(abs(X_float) - abs(X_fixed_double)));

        %% ---------- Test Case 2: Signed Inputs ----------
        adc_input_signed = randi([-128, 127], N, 1)/16;
        x_fixed_signed = fi(adc_input_signed, T, 'fimath', F);
        x_reordered = x_fixed_signed(bitrevorder(1:N));
        X = x_reordered;
        
        for stage = 1:log2(N)
            span = 2^stage;
            half = span / 2;
            for start = 1:span:N
                for k = 0:(half-1)
                    i = start + k;
                    j = i + half;
                    w = W_fixed(k * N / span + 1);
                    temp = fi(w * X(j), T, 'fimath', F);
                    u = X(i);
                    X(i) = fi(u + temp, T, 'fimath', F);
                    X(j) = fi(u - temp, T, 'fimath', F);
                end
            end
        end
        X_fixed_double = double(X);
        X_float = fft(double(adc_input_signed));
        error_signed = error_signed + mean(abs(abs(X_float) - abs(X_fixed_double)));
    end
    
    avg_error_pos_only(f_idx) = error_pos / num_trials;
    avg_error_pos_neg(f_idx) = error_signed / num_trials;
end

%% Plot Results
figure;
semilogy(frac_range, avg_error_pos_only, 'r-o', 'LineWidth', 2);
hold on;
semilogy(frac_range, avg_error_pos_neg, 'b-s', 'LineWidth', 2);
xlabel('Fraction Length (bits)');
ylabel('Average Magnitude Error');
title('Fraction Length vs. Avg Magnitude Error (40 Trials)');
legend('Positive Inputs [0,127]', 'Signed Inputs [-128,127]');
grid on;

[min_pos_error, idx1] = min(avg_error_pos_only);
[min_signed_error, idx2] = min(avg_error_pos_neg);
fprintf('\nBest Fraction Length (Positive Only): %d (Error = %.5f)\n', frac_range(idx1), min_pos_error);
fprintf('Best Fraction Length (Signed): %d (Error = %.5f)\n', frac_range(idx2), min_signed_error);
