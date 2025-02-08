%% 실습1: 확산 이득 hadamard with awgn ber
clc
clear
close all

SNR=-10:10;
SG = 8;
idx=2;
N=100000;
BER=zeros(1, length(SNR));
BER_=zeros(1, length(SNR));
for SNR_loop=1:length(SNR)
    data_bit=randint(1, N);
    x = QPSK_mapper(data_bit);
    y = hadamard_sp(x, SG, idx);
    z = AWGN(y, SNR(SNR_loop));
    z1=AWGN(x, SNR(SNR_loop));
    x_=hadamard_desp(z, SG, idx);
    s = QPSK_demapper(x_);
    s1 = QPSK_demapper(z1); 
    err_bit = sum(abs(data_bit-s));
    BER(SNR_loop)=err_bit/N;
    err_bit1=sum(abs(data_bit-s1));
    BER_(SNR_loop)=err_bit1/N;
end

title('hadamard awgn ber')
semilogy(SNR, BER, 'r-')
hold on
semilogy(SNR, BER_, 'b-')
hold on
%snr이 9dB 정도 차이남

xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('with hadamard','without hadamard')

%% 실습1: 확산 이득 hadamard with fading ber
clc
clear
close all

SNR=-10:10;
SG = 8;
idx=2;
N=100000;
BER=zeros(1, length(SNR));
BER_=zeros(1, length(SNR));
for SNR_loop=1:length(SNR)
    data_bit=randint(1, N);
    x = QPSK_mapper(data_bit);
    y = hadamard_sp(x, SG, idx);
    z = fading(y, SNR(SNR_loop));
    z1=fading(x, SNR(SNR_loop));
    x_=hadamard_desp(z, SG, idx);
    s = QPSK_demapper(x_);
    s1 = QPSK_demapper(z1);
    err_bit = sum(abs(data_bit-s));
    BER(SNR_loop)=err_bit/N;
    err_bit1=sum(abs(data_bit-s1));
    BER_(SNR_loop)=err_bit1/N;
end
title('hadamard fading ber')
semilogy(SNR, BER, 'r-')
hold on
semilogy(SNR, BER_, 'b-')
hold on 

xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('with hadamard','without hadamard')


%% 실습2: 확산 이득 PN with awgn ber
clc
clear
close all

SNR=-10:10;
SG = 8;
idx=2;
N=100000;
BER=zeros(1, length(SNR));
BER_=zeros(1, length(SNR));
for SNR_loop=1:length(SNR)
    data_bit=randint(1, N);
    x = QPSK_mapper(data_bit);
    y = PN_sp(x, SG, idx);
    z = awgn(y, SNR(SNR_loop));
    z1=awgn(x, SNR(SNR_loop));
    x_=PN_desp(z, SG, idx);
    s = QPSK_demapper(x_);
    s1 = QPSK_demapper(z1);
    err_bit = sum(abs(data_bit-s));
    BER(SNR_loop)=err_bit/N;
    err_bit1=sum(abs(data_bit-s1));
    BER_(SNR_loop)=err_bit1/N;
end
title('PN awgn ber')
semilogy(SNR, BER, 'r-')
hold on
semilogy(SNR, BER_, 'b-')
hold on 

xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('with PN','without PN')

%% 실습2: 확산 이득 PN with fading ber
clc
clear
close all

SNR=-10:10;
SG = 8;
idx=2;
N=100000;
BER=zeros(1, length(SNR));
BER_=zeros(1, length(SNR));
for SNR_loop=1:length(SNR)
    data_bit=randint(1, N);
    x = QPSK_mapper(data_bit);
    y = PN_sp(x, SG, idx);
    z = fading(y, SNR(SNR_loop));
    z1=fading(x, SNR(SNR_loop));
    x_=PN_desp(z, SG, idx);
    s = QPSK_demapper(x_);
    s1 = QPSK_demapper(z1);
    err_bit = sum(abs(data_bit-s));
    BER(SNR_loop)=err_bit/N;
    err_bit1=sum(abs(data_bit-s1));
    BER_(SNR_loop)=err_bit1/N;
end
title('PN fading ber')
semilogy(SNR, BER, 'r-')
hold on
semilogy(SNR, BER_, 'b-')
hold on 

xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('with PN','without PN')

%% hadamard vs PN 

clc
clear
close all

SNR=-10:10;
SG = 8;
idx=2;
N=100000;
BER_ha =zeros(1, length(SNR));
BER_PN =zeros(1, length(SNR));

for SNR_loop = 1:length(SNR)
    x = randint(1, N);
    y = QPSK_mapper(x);
    y1 = hadamard_sp(y, SG, idx);
    y2 = PN_sp(y, SG, idx);
    z1 = awgn(y1, SNR(SNR_loop));
    z2 = awgn(y2, SNR(SNR_loop));

    r1 = hadamard_desp(z1, SG, idx);
    r2 = PN_desp(z2, SG, idx);

    s1 = QPSK_demapper(r1);
    s2=QPSK_demapper(r2);

    err_bit1=sum(abs(x-s1));
    err_bit2=sum(abs(x-s2));

    BER_ha(SNR_loop)=err_bit1/N;
    BER_PN(SNR_loop)=err_bit2/N;
    
end
title('hadamard vs PN')
semilogy(SNR, BER_ha)
hold on
semilogy(SNR, BER_PN)
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('hadamard','PN')

%% 실습3: Two user CDMA 송수신기 with hadamard
clc
clear
close all

SNR=-10:10;
SG = 8;
idx1=2;
idx2=3;
N=100000;
BER_ha =zeros(1, length(SNR));

for SNR_loop = 1:length(SNR)
    x1 = randint(1, N);
    x2 = randint(1, N);
    y1 = QPSK_mapper(x1);
    y2 = QPSK_mapper(x2);
    y_1 = hadamard_sp(y1, SG, idx1);
    y_2 = hadamard_sp(y2, SG, idx2);
    y_= y_1+y_2;
    z1 = awgn(y_, SNR(SNR_loop));

    r1 = hadamard_desp(z1, SG, idx1);
    s1 = QPSK_demapper(r1);
  
    err_bit1=sum(abs(x1-s1));

    BER_ha(SNR_loop)=err_bit1/N; 
    
end

title('Twouser_hadamard')
semilogy(SNR, BER_ha)
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('hadamard')

%% 실습4: Two user CDMA 송수신기 with PN
clc
clear
close all

SNR=-10:10;
SG = 8;
idx1=2;
idx2=3;
N=100000;

BER_PN =zeros(1, length(SNR));

for SNR_loop = 1:length(SNR)
    x1 = randint(1, N);
    x2 = randint(1, N);
    y1 = QPSK_mapper(x1);
    y2 = QPSK_mapper(x2);
    y_1 = PN_sp(y1, SG, idx1);
    y_2 = PN_sp(y2, SG, idx2);
    y_= y_1+y_2;
    z1 = awgn(y_, SNR(SNR_loop));

    r1 = PN_desp(z1, SG, idx1);
    s1 = QPSK_demapper(r1);
  
    err_bit1=sum(abs(x1-s1));

    BER_PN(SNR_loop)=err_bit1/N; 
    
end
title('Twouser_PN')
semilogy(SNR, BER_PN)
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('PN')

%% Two user CDMA 송수신기(hadamard vs PN)
clc
clear
close all

SNR=-10:10;
SG = 8;
idx1=2;
idx2=3;
N=100000;
BER_ha =zeros(1, length(SNR));
BER_PN =zeros(1, length(SNR));

for SNR_loop = 1:length(SNR)
    x1 = randint(1, N);
    x2 = randint(1, N);
    y1 = QPSK_mapper(x1);
    y2 = QPSK_mapper(x2);
    y_1 = hadamard_sp(y1, SG, idx1);
    y_2 = hadamard_sp(y2, SG, idx2);
    y_= y_1+y_2;
    z1 = awgn(y_, SNR(SNR_loop));

    r1 = hadamard_desp(z1, SG, idx1);
    s1 = QPSK_demapper(r1);
  
    err_bit1=sum(abs(x1-s1));

    BER_ha(SNR_loop)=err_bit1/N; 
    
end

for SNR_loop = 1:length(SNR)
    x1 = randint(1, N);
    x2 = randint(1, N);
    y1 = QPSK_mapper(x1);
    y2 = QPSK_mapper(x2);
    y_1 = PN_sp(y1, SG, idx1);
    y_2 = PN_sp(y2, SG, idx2);
    y_= y_1+y_2;
    z1 = awgn(y_, SNR(SNR_loop));

    r1 = PN_desp(z1, SG, idx1);
    s1 = QPSK_demapper(r1);
  
    err_bit1=sum(abs(x1-s1));

    BER_PN(SNR_loop)=err_bit1/N; 
    
end
title('hadamard vs PN')
semilogy(SNR, BER_ha)
hold on
semilogy(SNR, BER_PN)
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('hadamard','PN')

%% Two user CDMA 송수신기(hadamard vs PN) 주석 ver.

% SNR 범위 정의
SNR=-10:10;
% 스프레드 시퀀스의 길이, 데이터의 길이가 SG배 됨
SG = 8;

idx1=2;
idx2=3;
% 전송될 데이터의 총 비트 수
N=100000;

% BER 초기화
BER_ha =zeros(1, length(SNR));
BER_PN =zeros(1, length(SNR));

% 하다마드 스프레딩 기법을 사용하여 BER 계산
for SNR_loop = 1:length(SNR)
    % 무작위 데이터 생성
    x1 = randint(1, N);
    x2 = randint(1, N);
    % 데이터를 QPSK로 매핑
    y1 = QPSK_mapper(x1);
    y2 = QPSK_mapper(x2);
    % 하다마드 스프레딩
    y_1 = hadamard_sp(y1, SG, idx1);
    y_2 = hadamard_sp(y2, SG, idx2);
    % 두 스프레드 시그널 합성
    y_= y_1+y_2;
    % AWGN 채널을 통한 전송
    z1 = awgn(y_, SNR(SNR_loop));

    % 하다마드 디스프레딩
    r1 = hadamard_desp(z1, SG, idx1);
    % QPSK 디매핑
    s1 = QPSK_demapper(r1);
  
    % 오류 비트 수 계산
    err_bit1=sum(abs(x1-s1));
    % BER 계산
    BER_ha(SNR_loop)=err_bit1/N; 
end

% PN 스프레딩 기법을 사용하여 BER 계산
for SNR_loop = 1:length(SNR)
    % 무작위 데이터 생성
    x1 = randint(1, N);
    x2 = randint(1, N);
    % 데이터를 QPSK로 매핑
    y1 = QPSK_mapper(x1);
    y2 = QPSK_mapper(x2);
    % PN 스프레딩
    y_1 = PN_sp(y1, SG, idx1);
    y_2 = PN_sp(y2, SG, idx2);
    % 두 스프레드 시그널 합성
    y_= y_1+y_2;
    % AWGN 채널을 통한 전송
    z1 = awgn(y_, SNR(SNR_loop));

    % PN 디스프레딩
    r1 = PN_desp(z1, SG, idx1);
    % QPSK 디매핑
    s1 = QPSK_demapper(r1);
  
    % 오류 비트 수 계산
    err_bit1=sum(abs(x1-s1));
    % BER 계산
    BER_PN(SNR_loop)=err_bit1/N; 
end

% 결과 시각화
title('hadamard vs PN')
semilogy(SNR, BER_ha) % 하다마드 BER
hold on
semilogy(SNR, BER_PN) % PN BER
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('hadamard','PN')

