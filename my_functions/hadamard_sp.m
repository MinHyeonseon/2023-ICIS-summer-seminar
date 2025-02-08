function y = hadamard_sp(x, SG, idx)
L = length(x);
y = zeros(1, L*SG);
H = hadamard(SG);
code = H(idx,:);

for n=1:L
    y(SG*(n-1)+1:SG*n) = x(n)*code;
end