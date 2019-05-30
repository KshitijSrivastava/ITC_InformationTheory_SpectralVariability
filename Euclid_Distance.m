function [euclid_dist] = Euclid_Distance(Si,Sj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
euclid_dist =  sqrt(sum(power(Si-Sj,2)));
end

