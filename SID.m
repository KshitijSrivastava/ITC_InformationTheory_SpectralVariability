function [sid_dist] = SID(p,q)
%Calculates the Spectral Information Divergence
% p, q are the probability vector 

%Relative Entropy of y with respect to x
D_xy = sum(p.*(log10(p ./ q)));
%Relative Entropy of x with respect to y
D_yx = sum(q.*(log10(q./p)));
sid_dist = D_xy +D_yx;
end

