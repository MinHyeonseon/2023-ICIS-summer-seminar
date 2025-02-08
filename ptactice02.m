%% 실습 1
% 실습 1-1
clear all;
close all;
% 이진 벡터 입력
x = [1 0 1 1 0 1 0 0];

% QPSK symbol mapping
y = QPSK_mapper(x);

% 결과 출력
disp('입력 x:');
disp(x);
disp('출력 y:');
disp(y);
%%
% 실습 1-2
clear all;
close all;

N = 1000;
M = 1;
x = randint(M, N);

% QPSK symbol mapping
y = QPSK_mapper(x);

% 결과 출력
disp('입력 x:');
disp(x);
disp('출력 y:');
disp(y);
%% 
% 실습 1-3
clear all;
close all;

N = 1000;
M = 1;
x = randi([0, 1], M, N);

% QPSK symbol mapping
y = QPSK_mapper(x);

% 결과 출력
disp('입력 x:');
disp(x);
disp('출력 y:');
disp(y);
%% 실습 2
% 실습 2-1
clear all;
close all;

N = 1000;
M = 1;
x = randi([0, 1], M, N);

% QPSK symbol mapping
y = QPSK_mapper(x);

%AWGN 잡음 삽입
SNR = 20; % SNR in dB
L  = length(y);
z = sqrt(0.5*10^(-SNR/10))*(randn(1, length(y))+1j*randn(1, length(y)));
r = y+z;

disp(r);
%%
% 실습 2-2
clear all;
close all;

N = 1000;
M = 1;
x = randi([0, 1], M, N);

% QPSK symbol mapping
y = QPSK_mapper(x);

% AWGN 잡음 삽입 
SNR = 20;
r = AWGN(y, SNR);

% 결과 출력
disp('입력 x:');
disp(x);
disp('출력 y:');
disp(y);
disp('출력 r (AWGN 적용 후):');
disp(r);

% 입력 x plot
subplot(4, 1, 1);
stem(x, 'filled');
title('입력 x');
xlabel('Symbol Index');
ylabel('Symbol Value');
axis([0 N+1 -0.5 1.5]);

% 출력 y plot
subplot(4, 1, 2);
stem(y, 'filled');
title('출력 y');
xlabel('Symbol Index');
ylabel('Symbol Value');
axis([0 N+1 -1.5 1.5]);

% 출력 r plot
subplot(4, 1, 3);
stem(r, 'filled');
title('출력 r (AWGN 적용 후)');
xlabel('Symbol Index');
ylabel('Symbol Value');
axis([0 N+1 -1.5 1.5]);
%%
% 실습 2-3
clear all;
close all;

N = 1000;
M = 1;
x = randi([0, 1], M, N);

% QPSK symbol mapping
y = QPSK_mapper(x);

% CH_out의 constellation plot (추가)
subplot(2, 1, 1);
plot(real(y), imag(y), '.');
title('CH_out Constellation (Before AWGN)');
xlabel('Real Part');
ylabel('Imaginary Part');
axis([-1.5 1.5 -1.5 1.5]);
grid on;

% AWGN 잡음 삽입 
SNR = 10;
r = AWGN(y, SNR);

% 결과 출력
disp('입력 x:');
disp(x);
disp('출력 y:');
disp(y);
disp('출력 r (AWGN 적용 후):');
disp(r);

% CH_out의 constellation plot
subplot(2, 1, 2);
plot(real(r), imag(r), '.');
title('CH_out Constellation');
xlabel('Real Part');
ylabel('Imaginary Part');
axis([-1.5 1.5 -1.5 1.5]);
grid on;

%%
% QPSK 수신신호를 복원하는 함수 작성

% AWGN 잡음 삽입 함수
r = AWGN(y, SNR);

L = length(r);
x_hat = zeros(1, 2*L);
for n=1:L
    if real(r(n))>=0 && imag(r(n)) >= 0
        x_hat(2*(n-1)+1:2*n) = [0 0];
    elseif real(r(n)) < 0 && imag(r(n)) >= 0
        x_hat(2*(n-1)+1:2*n) = [0 1];
    elseif real(r(n)) < 0 && imag(r(n)) < 0
        x_hat(2*(n-1)+1:2*n) = [1 1];
    else
        x_hat(2*(n-1)+1:2*n) = [1 0];
    end
end
%%
% QPSK 수신신호를 복원하는 함수 사용
% 수신 복소수
clear all;
close all;

N = 1000;
M = 1;
x = randi([0, 1], M, N);
disp(x);

% QPSK symbol mapping
y = QPSK_mapper(x);
disp(y);

% AWGN 잡음 삽입 
SNR = 20;
r = AWGN(y, SNR);

disp('AWGN이 추가된 비트 시퀀스:');
disp(r);

% QPSK 신호 복원
x_hat = QPSK_demapper(r);

% 복원된 비트 시퀀스 출력
disp('복원된 비트 시퀀스:');
disp(x_hat);
%% BER Curve for AWGN Channel
clear all;
close all;

N = 1000000; 
M = 1; 
SNR_dB = 1:1:11; % 시뮬레이션할 SNR(dB) 범위
SNR = 10.^(SNR_dB/10); % SNR(dB)를 선형 스케일로 변환

BER = zeros(size(SNR)); % BER 초기화

for i = 1:length(SNR_dB)
    x = randint(1, N);
    y = QPSK_mapper(x);
    r = AWGN(y, SNR(i));
    x_hat = QPSK_demapper(r);
    
    % 비트 오류 계산
    numErrors = sum(x(:) ~= x_hat(:)); % 오류 비트 수
    BER(i) = numErrors / (N * 1); % 비트 에러율 계산
end

% BER 곡선 플롯
semilogy(SNR_dB, BER, 'bo-');
title('BER Curve');
xlabel('SNR(dB)');
ylabel('BER');
grid on;


% BER (Bit Error Rate)은 디지털 통신 시스템에서 전송된 비트 중에서 수신측에서 정확하게 복원하지 못한 오류 비트의 비율을 나타내는 지표
% QPSK 심볼을 AWGN 채널을 통과시키고, 다양한 SNR 값에서의 비트 에러율 (BER)을 계산하여 그래프로 그림
% 시뮬레이션할 SNR 값 범위와 BER 결과를 저장할 배열 BER를 미리 설정
% 반복문을 통해 각 SNR 값에 대해 전송 심볼을 생성하고, AWGN 채널을 통과시킨 후 수신 심볼을 복원
% 이후 비트 오류를 계산하여 BER을 구하고, 결과를 그래프로 표시
% BER 값이 낮을 수록 좋은 성능

