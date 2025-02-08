%% 실습1 QAM16_mapper 함수 작성
%실행 코드
clc
clear

N=1000;

data_bit = randint(1, N);
symbol = QAM16_mapper(data_bit);
plot(symbol, 'bo');

%% fading으로 constellation 확장
clear all;
close all;

N = 10000;
SNR = 20;
x = randint(1,N);
y = QAM16_mapper(x);
r = fading(y, SNR);

plot(r, '.');
title('fading constellation');
axis([-1.5 1.5 -1.5 1.5]);
%% AWGN으로 constellation 확장
clear all;
close all;

N = 10000;
SNR = 20;
x = randint(1,N);
y = QAM16_mapper(x);
r = AWGN(y, SNR);

plot(r, '.');
title('AWGN constellation');
axis([-1.5 1.5 -1.5 1.5]);
%% 실습2 QAM16_demapper 함수 실행 코드
clc
clear

N = 1000;
SNR=20;
data_bit = randint(1,N);
symbol=QAM16_mapper(data_bit);
r = AWGN(symbol, SNR);
s = QAM16_demapper(r);

err_bit=sum(abs(data_bit-s));
plot(r, 'b.')

%% 실습3-1 16QAM에서 AWGN BER graph
clear all
close all

N = 200000;
SNR = 0:2:20;
BER1 = zeros(size(SNR));
BER2 = zeros(size(SNR));

R2 = 3;

for SNR_loop = 1:length(SNR)

    data_bit = randint(1, N);
    FEC2 = FEC_enc(data_bit, R2);
    symbol1=QAM16_mapper(data_bit);
    symbol2=QAM16_mapper(FEC2);
   

    r1 = AWGN(symbol1, SNR(SNR_loop));
    r2 = AWGN(symbol2, SNR(SNR_loop));
   

    x_bit_1 = QAM16_demapper(r1);
    x_bit_2 = QAM16_demapper(r2);
    


    FEC_dec2 = FEC_dec(x_bit_2, R2);
    
    err_bit_1 = sum(abs(data_bit-x_bit_1));
    err_bit_2 = sum(abs(data_bit-FEC_dec2));

    BER1(SNR_loop)=err_bit_1/N;
    BER2(SNR_loop)=err_bit_2/N;
    
end

title('AWGN BER')
semilogy(SNR, BER1, 'r-')
hold on
semilogy(SNR, BER2, 'b-')
hold on
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('AWGN, 16QAM without FEC','AWGN, 16QAM with FEC 1/3')
axis([0 20 10^-4 1 ])
%% 실습3-2 16QAM에서 fading chanell BER graph
clear all
close all

N = 200000;
SNR = 0:3:30;
BER1 = zeros(size(SNR));
BER2 = zeros(size(SNR));

R2 = 3;

for SNR_loop = 1:length(SNR)

    data_bit = randint(1, N);
    FEC2 = FEC_enc(data_bit, R2);
    symbol1=QAM16_mapper(data_bit);
    symbol2=QAM16_mapper(FEC2);
   

    r1 = fading(symbol1, SNR(SNR_loop));
    r2 = fading(symbol2, SNR(SNR_loop));
   

    x_bit_1 = QAM16_demapper(r1);
    x_bit_2 = QAM16_demapper(r2);
    


    FEC_dec2 = FEC_dec(x_bit_2, R2);
    
    err_bit_1 = sum(abs(data_bit-x_bit_1));
    err_bit_2 = sum(abs(data_bit-FEC_dec2));

    BER1(SNR_loop)=err_bit_1/N;
    BER2(SNR_loop)=err_bit_2/N;
    
end

title('AWGN BER')
semilogy(SNR, BER1, 'r-')
hold on
semilogy(SNR, BER2, 'b-')
hold on
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('fading, 16QAM without FEC','fading, 16QAM with FEC 1/3')
axis([0 30 1e-5 1 ])
%% 16QAM과 QPSK 성능 비교

clear all
close all

N = 200000;
%SNR1 = 0:10;
SNR1 = 0:2:20;
BER1 = zeros(size(SNR1));
BER2 = zeros(size(SNR1));

R = 3;

for SNR_loop = 1:length(SNR1)

    data_bit = randint(1, N);
   
    QPSK_symbol1 = QPSK_mapper(data_bit);

    r1 = AWGN(QPSK_symbol1, SNR1(SNR_loop));

    x_bit_1 = QPSK_demapper(r1);

    err_bit_1 = sum(abs(data_bit-x_bit_1));
    
    BER1(SNR_loop)=err_bit_1/N;
   
end



for SNR_loop = 1:length(SNR1)

    data_bit = randint(1, N);
   
    QAM16_symbol1 = QAM16_mapper(data_bit);

    r2 = AWGN(QAM16_symbol1, SNR1(SNR_loop));

    x_bit_2 = QAM16_demapper(r2);

    err_bit_2 = sum(abs(data_bit-x_bit_2));
    
    
    BER2(SNR_loop)=err_bit_2/N;
   
end

title('16QAM, QPSK')
semilogy(SNR1, BER1, 'r-')
hold on
semilogy(SNR1, BER2, 'b-')
hold on

xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('QPSK','16QAM')
axis([0 20 1e-6 1 ])

%%
clear all
close all

N = 200000;
SNR1 = 0:2:20;

BER1 = zeros(size(SNR1));
BER2 = zeros(size(SNR1));

R = 3;

for SNR_loop = 1:length(SNR1)

    data_bit = randint(1, N);
    FEC2 = FEC_enc(data_bit, R);
   
    QPSK_symbol1 = QPSK_mapper(FEC2);

    r1 = AWGN(QPSK_symbol1, SNR1(SNR_loop));

    x_bit_1 = QPSK_demapper(r1);
    FEC_dec2 = FEC_dec(x_bit_1, R);

    err_bit_1 = sum(abs(data_bit-FEC_dec2));
    BER1(SNR_loop)=err_bit_1/N;
   
end

for SNR_loop = 1:length(SNR1)

    data_bit = randint(1, N);
    FEC2 = FEC_enc(data_bit, R);
    QAM16_symbol1 = QAM16_mapper(FEC2);

    r2 = AWGN(QAM16_symbol1, SNR1(SNR_loop));

    x_bit_2 = QAM16_demapper(r2);
    FEC_dec2 = FEC_dec(x_bit_2, R);

    err_bit_2 = sum(abs(data_bit-FEC_dec2));
    
    BER2(SNR_loop)=err_bit_2/N;
   
end

title('16QAM, QPSK')
semilogy(SNR1, BER1, 'r-')
hold on
semilogy(SNR1, BER2, 'b-')
hold on

xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('QPSK','16QAM')
axis([0 20 1e-6 1 ])
%%
clear all
close all

N = 200000;
SNR = 0:10:100;
BER_QPSK = zeros(size(SNR));
BER_16QAM = zeros(size(SNR));

R = 3;

for SNR_loop = 1:length(SNR)

    data_bit = randint(1, N);
    FEC_data = FEC_enc(data_bit, R);

    % QPSK Modulation
    QPSK_symbol = QPSK_mapper(FEC_data);
    r_QPSK = AWGN(QPSK_symbol, SNR(SNR_loop));
    x_bit_QPSK = QPSK_demapper(r_QPSK);
    FEC_dec_QPSK = FEC_dec(x_bit_QPSK, R);
    err_bit_QPSK = sum(abs(data_bit - FEC_dec_QPSK));
    BER_QPSK(SNR_loop) = err_bit_QPSK / N;

    % 16QAM Modulation
    QAM16_symbol = QAM16_mapper(FEC_data);
    r_16QAM = AWGN(QAM16_symbol, SNR(SNR_loop));
    x_bit_16QAM = QAM16_demapper(r_16QAM);
    FEC_dec_16QAM = FEC_dec(x_bit_16QAM, R);
    err_bit_16QAM = sum(abs(data_bit - FEC_dec_16QAM));
    BER_16QAM(SNR_loop) = err_bit_16QAM / N;

end

figure;
semilogy(SNR, BER_QPSK, 'r-')
hold on
semilogy(SNR, BER_16QAM, 'b-')

xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('QPSK', '16QAM')
title('QPSK vs. 16QAM Performance')