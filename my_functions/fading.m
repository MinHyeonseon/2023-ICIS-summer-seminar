function eq_out=fading(y,SNR)
z=sqrt(0.5*10^(-SNR/10))*(randn(1,length(y))+1j*randn(1,length(y)));
h=sqrt(0.5)*randn(1,length(y))+1j*randn(1,length(y));
r=h.*y+z;

eq_out=r./h;
end