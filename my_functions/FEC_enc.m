function output = FEC_enc(x, R)
   L = length(x);
   output = zeros(1, L*R);
   for n=1:R
       output((n-1)*L+1:n*L)=x;
   end

