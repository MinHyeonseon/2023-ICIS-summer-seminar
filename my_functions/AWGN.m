function output = AWGN(data, SNR)
    N = length(data);
    noise=sqrt(0.5*10^(-SNR/10))*(randn(1,N)+1i*randn(1,N));
    output=data+noise;
end
