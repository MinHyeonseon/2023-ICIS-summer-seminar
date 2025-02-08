function y = QAM16_demapper(data)
N = length(data);
y = zeros(1, N*4);

data = data*sqrt(10);

data_bit = [0,0,0,0;
            0,0,0,1;
            0,0,1,1;
            0,0,1,0;
            0,1,0,0;
            0,1,0,1;
            0,1,1,1;
            0,1,1,0;
            1,1,1,0;
            1,1,1,1;
            1,1,0,1;
            1,1,0,0;
            1,0,0,0;
            1,0,0,1;
            1,0,1,1;
            1,0,1,0;];
symbol = [-3-3j,-3-1j,-3+1j,-3+3j,-1-3j,-1-1j,-1+1j,-1+3j,1+3j,1+1j,1-1j,1-3j,3-3j,3-1j,3+1j,3+3j];
for n = 1:N
    [Y, idx]=min(abs(data(n)-symbol));
    y(4*n-3:4*n)=data_bit(idx, :);
end
end

