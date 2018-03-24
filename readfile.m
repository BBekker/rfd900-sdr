function [out,Fs] = readfile(filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [y, Fs] = audioread(filename);
    out = y(:,1) + 1i*y(:,2);
end

