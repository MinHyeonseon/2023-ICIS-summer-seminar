function PN = PN_gen(SP_gain, idx)


if idx == 1
    register =[1 1 1 1 1 1 0 1];
elseif idx ==2
        register = [1 1 1 1 1 1 1 1];
else
    temp = dec2bin(idx, 8);
    register = temp - '0';
end

PN = zeros(1, SP_gain);
for i=1:SP_gain
    PN(i) = register(8);
    temp = register(4)+register(5) + register(6) + register(8);
    temp = mod(temp, 2);
    for k=8:-1:2
        register(k) = register(k-1);
    end
    register(1) = temp;
end
PN = -2*PN+1;