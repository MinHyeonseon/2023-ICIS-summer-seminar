function y = QAM16_mapper(data)
N = length(data);
y = zeros(1, N/4);

for n = 1:length(y)
    input =data(4*n-3:4*n);
    if input ==[0 0 0 0]
        y(n) = -3-3j;
    elseif input ==[0 0 0 1]
        y(n) = -3-1j;
    elseif input ==[0 0 1 0]
        y(n) = -3+3j;
    elseif input ==[0 0 1 1]
        y(n) = -3+1j;
    elseif input ==[0 1 0 0]
        y(n) = -1-3j;
    elseif input ==[0 1 1 0]
        y(n) = -1+3j;
    elseif input ==[0 1 1 1]
        y(n) = -1+1j;
    elseif input ==[1 0 0 0]
        y(n) = 3-3j;
    elseif input ==[1 0 0 1]
        y(n) = 3-1j;
    elseif input ==[1 0 1 0]
        y(n) = 3+3j;
    elseif input ==[1 0 1 1]
        y(n) = 3+1j;
    elseif input ==[1 1 0 0]
        y(n) = 1-3j;
    elseif input ==[1 1 0 1]
        y(n) = 1-1j;
    elseif input ==[1 1 1 0]
        y(n) = 1+3j;
    elseif input ==[0 1 0 1]
        y(n) = -1-1j;
    else
        y(n) = 1+1j;
    end
end
y = y/sqrt(10);
end

