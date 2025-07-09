function X = fft_butterfly_32(x)
    [row,col] = size(x);
    X = zeros(row,col);
    % calculate twiddle factors
    W_32 = (exp((-2*pi*1i)/32)) .^(0:31);
    % intermediate var
    temp = zeros(1,col);
    % bit reversal
    numbers = (0:31)';
    order_revers = bitrevorder(numbers) + 1;
    
    % butterfly core
    for i = 1 : row
        % select row for processing
        in_vec = x(i,:);
        
        % stage 1
        for j = 1 : 16
            temp(2*(j-1)+1) = in_vec(order_revers(2*(j-1)+1)) + W_32(1) * in_vec(order_revers(2*(j-1)+2));
            temp(2*(j-1)+2) = in_vec(order_revers(2*(j-1)+1)) - W_32(1) * in_vec(order_revers(2*(j-1)+2));
        end
        
        % stage 2
        in_vec = temp;
        for j = 1 : 8
            temp(4*j-3) = in_vec(4*j-3) + W_32(1) * in_vec(4*j-1);
            temp(4*j-2) = in_vec(4*j-2) + W_32(9) * in_vec(4*j);
            temp(4*j-1) = in_vec(4*j-3) - W_32(1) * in_vec(4*j-1);
            temp(4*j)   = in_vec(4*j-2) - W_32(9) * in_vec(4*j);
        end
        
        % stage 3
        in_vec = temp;
        for j = 1 : 4
            temp(8*j-7) = in_vec(8*j-7) + W_32(1) * in_vec(8*j-3);
            temp(8*j-6) = in_vec(8*j-6) + W_32(5) * in_vec(8*j-2);
            temp(8*j-5) = in_vec(8*j-5) + W_32(9) * in_vec(8*j-1);
            temp(8*j-4) = in_vec(8*j-4) + W_32(13) * in_vec(8*j);
            temp(8*j-3) = in_vec(8*j-7) - W_32(1) * in_vec(8*j-3);
            temp(8*j-2) = in_vec(8*j-6) - W_32(5) * in_vec(8*j-2);
            temp(8*j-1) = in_vec(8*j-5) - W_32(9) * in_vec(8*j-1);
            temp(8*j)   = in_vec(8*j-4) - W_32(13) * in_vec(8*j);
        end
        
        % stage 4 (fixed by adding in_vec = temp)
        in_vec = temp;
        for j = 1 : 2
            temp(16*j-15) = in_vec(16*j-15) + W_32(1) * in_vec(16*j-7);
            temp(16*j-14) = in_vec(16*j-14) + W_32(3) * in_vec(16*j-6);
            temp(16*j-13) = in_vec(16*j-13) + W_32(5) * in_vec(16*j-5);
            temp(16*j-12) = in_vec(16*j-12) + W_32(7) * in_vec(16*j-4);
            temp(16*j-11) = in_vec(16*j-11) + W_32(9) * in_vec(16*j-3);
            temp(16*j-10) = in_vec(16*j-10) + W_32(11) * in_vec(16*j-2);
            temp(16*j-9)  = in_vec(16*j-9) + W_32(13) * in_vec(16*j-1);
            temp(16*j-8)  = in_vec(16*j-8) + W_32(15) * in_vec(16*j);
            temp(16*j-7)  = in_vec(16*j-15) - W_32(1) * in_vec(16*j-7);
            temp(16*j-6)  = in_vec(16*j-14) - W_32(3) * in_vec(16*j-6);
            temp(16*j-5)  = in_vec(16*j-13) - W_32(5) * in_vec(16*j-5);
            temp(16*j-4)  = in_vec(16*j-12) - W_32(7) * in_vec(16*j-4);
            temp(16*j-3)  = in_vec(16*j-11) - W_32(9) * in_vec(16*j-3);
            temp(16*j-2)  = in_vec(16*j-10) - W_32(11) * in_vec(16*j-2);
            temp(16*j-1)  = in_vec(16*j-9) - W_32(13) * in_vec(16*j-1);
            temp(16*j)    = in_vec(16*j-8) - W_32(15) * in_vec(16*j);
        end
        
        % stage 5 
        in_vec = temp;
        for j = 1 : 16
            temp(j) = in_vec(j) + W_32(j) * in_vec(j+16);
            temp(j+16) = in_vec(j) - W_32(j) * in_vec(j+16);
        end
        
        X(i,:) = temp; 
    end
end