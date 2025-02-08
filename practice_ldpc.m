%% LDPC code 구현 1

% QPSK와 AWGN을 사용하여 구현함
% 임의로 랜덤 비트 생성

clear all
close all
clc

% LDPC 설정
m = 5000; % 원하는 행의 수
n = 10000; % 원하는 열의 수 (numBits와 같거나 큰 값을 선택하세요)
parityCheckMatrix = randint(m,n); 

% 변수 설정
EbNo = 0:1:10; % Eb/No 범위 설정 (dB)
numBits = 10000; % 시뮬레이션에 사용할 비트의 수. 시뮬레이션에서 사용하는 비트 수가 많아질 수록 BER 곡선의 변동성 감소. 더 부드러워짐.
ber = zeros(size(EbNo));

for idx = 1:length(EbNo)
    
    % 무작위 비트 생성
    data = randint(1, numBits);
    
    % LDPC 인코딩
    encodedData = ldpc_enc(data, parityCheckMatrix);
    
    % QPSK 변조
    modSignal = QPSK_mapper(encodedData.');
    
    % AWGN 채널 통과
    noisySignal = awgn(modSignal, EbNo(idx));
    
    % QPSK 복조
    demodSignal = QPSK_demapper(noisySignal);
    
    % LDPC 디코딩
    decodedData = ldpc_dec(demodSignal, parityCheckMatrix);
    
    % 오류율 계산
    numErrors = sum(xor(data, decodedData));
    ber(idx) = numErrors/numBits;
end

% BER 그래프 플롯
semilogy(EbNo, ber, '-o');
grid on;
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER Performance with LDPC');
legend('BER with LDPC');


%% LDPC code 구현 2
% QPSK와 AWGN을 사용하여 구현함
% 희소 행렬 생성

clear all
close all
clc

% LDPC 설정
m = 5000; % 원하는 행의 수
n = 10000; % 원하는 열의 수 (numBits와 같거나 큰 값을 선택하세요)

% 희소 행렬 생성
values = ones(1,m); % 행렬에 들어갈 값
rows = 1:m; % 각 값의 행 위치
cols = randperm(m); % 각 값의 열 위치를 무작위로 섞습니다.

% sparse 함수를 사용하여 희소 행렬을 생성합니다.
parityCheckMatrix = sparse(rows, cols, values, m, n);

% 변수 설정
EbNo = 0:1:10; % Eb/No 범위 설정 (dB)
numBits = 10000; % 시뮬레이션에 사용할 비트의 수. 시뮬레이션에서 사용하는 비트 수가 많아질 수록 BER 곡선의 변동성 감소. 더 부드러워짐.
ber = zeros(size(EbNo));

for idx = 1:length(EbNo)
    
    % 무작위 비트 생성
    data = randi([0 1], 1, numBits);
    
    % LDPC 인코딩
    encodedData = ldpc_enc(data, parityCheckMatrix);
    
    % QPSK 변조
    modSignal = QPSK_mapper(encodedData.');
    
    % AWGN 채널 통과
    noisySignal = awgn(modSignal, EbNo(idx));
    
    % QPSK 복조
    demodSignal = QPSK_demapper(noisySignal);
    
    % LDPC 디코딩
    decodedData = ldpc_dec(demodSignal, parityCheckMatrix);
    
    % 오류율 계산
    numErrors = sum(xor(data, decodedData));
    ber(idx) = numErrors/numBits;
end

% BER 그래프 플롯
semilogy(EbNo, ber, '-o');
grid on;
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER Performance with LDPC');
legend('BER with LDPC');


%% LDPC code와 repetition code BER 비교

%% QPSK BER code
clear all
close all

N = 200000;
SNR = 0:2:20;

BER2 = zeros(size(SNR));

R = 3;

for SNR_loop = 1:length(SNR)

    data_bit = randint(1, N);
    FEC = FEC_enc(data_bit, R);
 
    symbol2=QPSK_mapper(FEC);
    
    r = AWGN(symbol2, SNR(SNR_loop));
    
    x_bit_2 = QPSK_demapper(r);

    FEC_dec2 = FEC_dec(x_bit_2, R);
    
    err_bit_2 = sum(abs(data_bit-FEC_dec2));

    BER2(SNR_loop)=err_bit_2/N;
    
end

title('BER Performance with FEC')
semilogy(SNR, BER2, 'b-')
hold on
xlabel('SNR(dB)')
ylabel('BER')
grid on
legend('BER with FEC')


%% ldpc vs fec ber
clear all
close all
clc

% LDPC 설정
m = 5000; % 원하는 행의 수
n = 10000; % 원하는 열의 수

% 희소 행렬 생성
values = ones(1,m); % 행렬에 들어갈 값
rows = 1:m; % 각 값의 행 위치
cols = randperm(m); % 각 값의 열 위치를 무작위로 섞습니다.
parityCheckMatrix = sparse(rows, cols, values, m, n); % sparse 함수를 사용하여 희소 행렬을 생성합니다.

% 변수 설정
EbNo = 0:1:10; % Eb/No 범위 설정 (dB)
numBits = 10000; % 시뮬레이션에 사용할 비트의 수
ber_ldpc = zeros(size(EbNo));
ber_fec = zeros(size(EbNo));

R = 3; % FEC 코드 비율

for idx = 1:length(EbNo)
    % 무작위 비트 생성
    data = randi([0 1], 1, numBits);
    
    % LDPC 인코딩 및 디코딩
    encodedData_ldpc = ldpc_enc(data, parityCheckMatrix);
    modSignal_ldpc = QPSK_mapper(encodedData_ldpc.');
    noisySignal_ldpc = awgn(modSignal_ldpc, EbNo(idx));
    demodSignal_ldpc = QPSK_demapper(noisySignal_ldpc);
    decodedData_ldpc = ldpc_dec(demodSignal_ldpc, parityCheckMatrix);
    
    % FEC 인코딩 및 디코딩
    encodedData_fec = FEC_enc(data, R);
    modSignal_fec = QPSK_mapper(encodedData_fec.');
    noisySignal_fec = awgn(modSignal_fec, EbNo(idx));
    demodSignal_fec = QPSK_demapper(noisySignal_fec);
    decodedData_fec = FEC_dec(demodSignal_fec, R);
    
    % 오류율 계산
    numErrors_ldpc = sum(xor(data, decodedData_ldpc));
    ber_ldpc(idx) = numErrors_ldpc/numBits;
    
    numErrors_fec = sum(xor(data, decodedData_fec));
    ber_fec(idx) = numErrors_fec/numBits;
end

% BER 그래프 플롯
semilogy(EbNo, ber_ldpc, '-o');
hold on
semilogy(EbNo, ber_fec, '-x');
grid on;
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER Performance Comparison between LDPC and FEC');
legend('BER with LDPC', 'BER with FEC');

%% ldpc 내장함수 사용
% 파라미터 설정
EbNo_range = 0:1:10; % Eb/No 범위 설정 (dB)
numData = 32400; % DVB-S.2 rate 1/2의 원 데이터 비트 길이
numBits = 64800; % 총 비트 길이
ber = zeros(size(EbNo_range));

% LDPC 설정
H = dvbs2ldpc(1/2); % DVB-S.2 rate 1/2의 행렬
ldpcEncoder = comm.LDPCEncoder(H);
ldpcDecoder = comm.LDPCDecoder(H, 'IterationTerminationCondition', 'Parity check satisfied');

% 메인 루프
for i = 1:length(EbNo_range)
    % 원본 데이터 생성
    dataBits = randint(numData, 1);

    % LDPC 인코딩
    encodedData = ldpcEncoder(dataBits);

    % QPSK 변조
    modSignal = QPSK_mapper(encodedData.');

    % AWGN 채널 추가
    noisySignal = awgn(modSignal, EbNo_range(i));

    % QPSK 복조
    demodSignal = QPSK_demapper(noisySignal);

    % LDPC 디코딩
    decodedData = ldpcDecoder(demodSignal.');

    % BER 계산
    numErrors = sum(xor(dataBits, decodedData(1:numData)));
    ber(i) = numErrors/numData;
end

% 결과 플롯
semilogy(EbNo_range, ber, '-o');
xlabel('Eb/No (dB)');
ylabel('BER');
title('LDPC with QPSK over AWGN');
grid on;

%% LDPC code 구현 3
clear all;
close all;
clc;

% LDPC 설정
m = 5000; % 원하는 행의 수
n = 10000; % 원하는 열의 수
parityCheckMatrix = randi([0, 1], m, n);  % For demonstration purposes

% 변수 설정
EbNo = 0:1:10; % Eb/No 범위 설정 (dB)
numBits = 5000; % 데이터 비트의 수
ber = zeros(size(EbNo));

for idx = 1:length(EbNo)
    
    % 무작위 비트 생성
    data = randi([0 1], 1, numBits);
    
    % LDPC 인코딩
    encodedData = ldpc_enc(data, parityCheckMatrix);
    
    % QPSK 변조
    modSignal = QPSK_mapper(encodedData.');
    
    % AWGN 채널 통과
    noisySignal = awgn(modSignal, EbNo(idx));
    
    % QPSK 복조
    demodSignal = QPSK_demapper(noisySignal);
    
    % LDPC 디코딩
    try
        decodedData = ldpc_dec(demodSignal, parityCheckMatrix);
    catch
        % Decoding error occurred, treat entire block as error
        decodedData = zeros(1, numBits);
    end
    
    % 오류율 계산
    numErrors = sum(xor(data, decodedData));
    ber(idx) = numErrors/numBits;
end

% BER 그래프 플롯
semilogy(EbNo, ber, '-o');
grid on;
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER Performance with LDPC');
legend('BER with LDPC');
