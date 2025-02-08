%% 실습 1
%equalizer output
clear all;
close all;

N = 1000;
SNR = 10;
x = randint(1,N);
y = QPSK_mapper(x);
r = fading(y, SNR);

plot(r, '.');
title('Equalizer Output');
axis([-1.5 1.5 -1.5 1.5]);
%%
%equalizer input
N = 1000;
SNR = 15;
x = randint(1,N);
y = QPSK_mapper(x);
r = fading(y, SNR);

plot(r, '.');
title('Equalizer Output');
axis([-1.5 1.5 -1.5 1.5]);

%% Fading channel 환경에서 BER curve 그리기

clear all;
close all;

N=10000;

x=randint(1,N);

SNR = 0:2:20; 
BER = zeros(size(SNR));

for i = 1:length(SNR)
    % QPSK 변조
    y = QPSK_mapper(x);

    % Fading channel 환경 설정
   eq_out = fading(y,SNR(i));

    % QPSK 복조
    x_hat = QPSK_demapper(eq_out);

    % BER 계산
    % bit_errors = sum(data(:) ~= y(:));
    bit_errors = sum(xor(x, x_hat));
    BER(i) = bit_errors / N;
end

% Plot BER 
semilogy(SNR, BER, 'bo-');
xlabel('SNR(dB)');
ylabel('BER');
title('Fading Channel BER')
grid on;
ylim([10^(-3) 1]);
%% 실습2. AWGN과 Fading 채널의 비교
clc
clear;
close all;

SNR_dB = 0:0.1:20; % 시뮬레이션할 SNR(dB) 범위
SNR = 10.^(SNR_dB/10); % SNR(dB)를 선형 스케일로 변환

% AWGN Channel
N = 100000;
AWGN_BER = zeros(size(SNR)); % AWGN 채널의 BER 초기화

for i = 1:length(SNR_dB)
    x = randint(1, N);
    y = QPSK_mapper(x);
    r = AWGN(y, SNR(i));
    x_hat = QPSK_demapper(r);
    
    % 비트 오류 계산
    numErrors = sum(x(:) ~= x_hat(:)); % 오류 비트 수
    AWGN_BER(i) = numErrors / (N * 1); % 비트 에러율 계산
end

% Fading Channel
N = 100000;

Fading_BER = zeros(size(SNR)); % Fading 채널의 BER 초기화

for i = 1:length(SNR_dB)
    x = randint(1, N);
    y = QPSK_mapper(x);
    r = fading(y, SNR(i));
    x_hat = QPSK_demapper(r);
    numErrors = sum(x(:) ~= x_hat(:));
    Fading_BER(i) = numErrors / N;
end

% 그래프 그리기
semilogy(SNR_dB, AWGN_BER, 'r-', 'DisplayName', 'AWGN Channel');
hold on;
semilogy(SNR_dB, Fading_BER, 'b-', 'DisplayName', 'Fading Channel');
title('BER Curve');
axis([0 20 10^-4 10^0]);
xlabel('SNR (dB)');
ylabel('BER');
grid on;
legend;
%% FEC_enc, FEC_dec 함수 테스트
clear all
close all
x = [1, 0, 0, 1, 1, 1, 1, 1, 0];
R = 3;

y = FEC_dec2(x, R);
disp(y);
%%
clear all
close all
N = 8;

msg = randint(1, N);

R = 3;
% L = length(msg);
% x_r = zeros(1, L*R);
% for n = 1:R
%     x_r((L*(n-1)+1):(L*n)) = msg;
% end
x_r = FEC_enc(msg, R);

y = QPSK_mapper(x_r);

SNR = 20;

% z=sqrt(0.5*10^(-SNR/10))*(randn(1,length(y))+1j*randn(1,length(y)));
% h=sqrt(0.5)*randn(1,length(y))+1j*randn(1,length(y));
% r=h.*y+z;

% eq_out = r/h;
eq_out= fading(y, SNR);

x_hat = QPSK_demapper(eq_out);
%% AWGN 채널 BER 비교
clear all
close all

N = 200000;
SNR = 0:10;
BER1 = zeros(size(SNR));
BER2 = zeros(size(SNR));
BER3 = zeros(size(SNR));

R2 = 3;
R3 = 5;
for SNR_loop = 1:length(SNR)

    data_bit = randint(1, N);
    FEC2 = FEC_enc(data_bit, R2);
    FEC3 = FEC_enc(data_bit, R3);
    QPSK_symbol1 = QPSK_mapper(data_bit);
    QPSK_symbol2 = QPSK_mapper(FEC2);
    QPSK_symbol3 = QPSK_mapper(FEC3);

    r1 = AWGN(QPSK_symbol1, SNR(SNR_loop));
    r2 = AWGN(QPSK_symbol2, SNR(SNR_loop));
    r3 = AWGN(QPSK_symbol3, SNR(SNR_loop));

    x_bit_1 = QPSK_demapper(r1);
    x_bit_2 = QPSK_demapper(r2);
    x_bit_3 = QPSK_demapper(r3);


    FEC_dec2 = FEC_dec(x_bit_2, R2);
    FEC_dec3 = FEC_dec(x_bit_3, R3);

    err_bit_1 = sum(abs(data_bit-x_bit_1));
    err_bit_2 = sum(abs(data_bit-FEC_dec2));
    err_bit_3 = sum(abs(data_bit-FEC_dec3));

    BER1(SNR_loop)=err_bit_1/N;
    BER2(SNR_loop)=err_bit_2/N;
    BER3(SNR_loop)=err_bit_3/N;
end

title('AWGN BER')
semilogy(SNR, BER1, 'r-')
hold on
semilogy(SNR, BER2, 'b-')
hold on
semilogy(SNR, BER3, 'g-')
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('No FEC','FEC R=3','FEC R=5')
axis([0 10 1e-4 1 ])



%% Fading 채널 BER 비교
clear all
close all

N = 200000;
SNR = 0:10;
BER1 = zeros(size(SNR));
BER2 = zeros(size(SNR));
BER3 = zeros(size(SNR));

R2 = 3;
R3 = 5;
for SNR_loop = 1:length(SNR)

    data_bit = randint(1, N);
    FEC2 = FEC_enc(data_bit, R2);
    FEC3 = FEC_enc(data_bit, R3);
    QPSK_symbol1 = QPSK_mapper(data_bit);
    QPSK_symbol2 = QPSK_mapper(FEC2);
    QPSK_symbol3 = QPSK_mapper(FEC3);

    r1 = fading(QPSK_symbol1, SNR(SNR_loop));
    r2 = fading(QPSK_symbol2, SNR(SNR_loop));
    r3 = fading(QPSK_symbol3, SNR(SNR_loop));

    x_bit_1 = QPSK_demapper(r1);
    x_bit_2 = QPSK_demapper(r2);
    x_bit_3 = QPSK_demapper(r3);


    FEC_dec2 = FEC_dec(x_bit_2, R2);
    FEC_dec3 = FEC_dec(x_bit_3, R3);

    err_bit_1 = sum(abs(data_bit-x_bit_1));
    err_bit_2 = sum(abs(data_bit-FEC_dec2));
    err_bit_3 = sum(abs(data_bit-FEC_dec3));

    BER1(SNR_loop)=err_bit_1/N;
    BER2(SNR_loop)=err_bit_2/N;
    BER3(SNR_loop)=err_bit_3/N;
end

semilogy(SNR, BER1, 'r-')
hold on
semilogy(SNR, BER2, 'b-')
hold on
semilogy(SNR, BER3, 'g-')
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('fading without FEC','fading FEC R=3','fading FEC R=5')
axis([0 10 1e-4 1 ])