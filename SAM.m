function [dist] = SAM(Si,Sj)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    value = sum(Si.*Sj)/ ( sqrt(sum(power(Si,2))) * sqrt(sum(power(Sj,2))) );
    dist = acos(value);
end

