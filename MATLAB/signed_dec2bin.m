function bin_str = signed_dec2bin(dec_val, num_bits)
    if dec_val < 0
        bin_str = dec2bin(2^num_bits + dec_val, num_bits);
    else
        bin_str = dec2bin(dec_val, num_bits);
    end
end

