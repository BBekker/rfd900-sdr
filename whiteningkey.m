function [k] = whiteningkey(k)
%WHITENINGKEY Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:8
        c = xor(xor(k(1), k(5)),k(9));
        k = [k(2) k(3) k(4) k(5) k(6) k(7) k(8) k(9) c];
        %newkey = [c k(9) k(8) k(7) k(6) k(5) k(4) k(3) k(2)];
    end
end

