function y = PN_desp(x, SG, idx)
L = length(x);
y = zeros(1, L/SG);
code = PN_gen(SG, idx);

for n=1:L/SG
    y(n) = x(SG*(n-1)+1:SG*n)*code'/SG;
end