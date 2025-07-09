function print_twiddle_factor(twiddle_factor,file_real,file_imag,num_bits)
    % Ensure integer values (round to nearest)
    real_val = round(real(twiddle_factor));
    imag_val = round(imag(twiddle_factor));
    % Write to files (no automatic formatting)
    fprintf(file_real, '%s', signed_dec2bin(real_val,num_bits));
    fprintf(file_imag, '%s', signed_dec2bin(imag_val,num_bits));
end

