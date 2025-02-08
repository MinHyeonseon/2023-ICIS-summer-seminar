function output=FEC_dec(x, R)
L=length(x);
output=zeros (1 ,L/R);
temp=zeros (R,L/R) ;
for n=1:R
    temp (n, :)=x((n-1)*L/R+1:n*L/R);
end 

t = R/2;
for n=1:L/R
    output(n)=sum(temp(:,n)) >= t;
end