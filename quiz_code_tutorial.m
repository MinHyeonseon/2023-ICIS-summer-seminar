%%% ICIS tutorial code
%%% convolutional encoding, LDCP encoding
%%% reference links
%%% [1] LDPC encoding: https://kr.mathworks.com/help/comm/ref/ldpcencode.html
%%% [2] LDPC decoding: https://kr.mathworks.com/help/comm/ref/ldpcdecode.html#mw_016f2a8c-905d-4a76-a1a6-881750fb00eb
clear all; close all; clc;

dBToLinear = @(x)( 10.^(x./10) );
LinearTodB = @(x)( 10*log10(x) );

%% random binary data
M = 4;      % Modulation order
k = log2(M); % Number of bits per symbol
n = 1000;   % Number of symbols per frame
bit_frame_length = n*k;

%%% Data bit generation
Bit_dataIn = randi([0 1],n*k,1); % Generate vector of binary data

%%% channel coding: encoding
%%% LDPC
P = [16 17 22 24  9  3 14 -1  4  2  7 -1 26 -1  2 -1 21 -1  1  0 -1 -1 -1 -1
     25 12 12  3  3 26  6 21 -1 15 22 -1 15 -1  4 -1 -1 16 -1  0  0 -1 -1 -1
     25 18 26 16 22 23  9 -1  0 -1  4 -1  4 -1  8 23 11 -1 -1 -1  0  0 -1 -1
      9  7  0  1 17 -1 -1  7  3 -1  3 23 -1 16 -1 -1 21 -1  0 -1 -1  0  0 -1
     24  5 26  7  1 -1 -1 15 24 15 -1  8 -1 13 -1 13 -1 11 -1 -1 -1 -1  0  0
      2  2 19 14 24  1 15 19 -1 21 -1  2 -1 24 -1  3 -1  2  1 -1 -1 -1 -1  0
    ];
blockSize = 27;
maxnumiter = 10;

pcmatrix = ldpcQuasiCyclicMatrix(blockSize,P);

cfgLDPCEnc = ldpcEncoderConfig(pcmatrix);

bit_length = length(Bit_dataIn);


ldpc_input_length = cfgLDPCEnc.NumInformationBits;
num_iteration = ceil( bit_length / ldpc_input_length );
blk_length = cfgLDPCEnc.BlockLength;

codeword = zeros(blk_length*num_iteration,1);
bit_sample = zeros(ldpc_input_length,1);

for i1=1:num_iteration

    idx_start = (i1-1)*ldpc_input_length+1;
    idx_code_start = (i1-1)*blk_length+1;

    if(i1==num_iteration)
        %%% zero-padding
       last_blk = length(Bit_dataIn(idx_start:end));
       bit_sample(1:last_blk)=Bit_dataIn(idx_start:end);
        %%% LDPC encoding
    else
       bit_sample = Bit_dataIn(idx_start:(idx_start+ldpc_input_length-1));
      
      
    end
    %%%codeword<<---codeword_sample
    codeword_sample = ldpcEncode(bit_sample, cfgLDPCEnc);
    codeword_sample=(idx_code_start:(idx_code_start+blk_length-1));
end


% codeword = Bit_dataIn;

dataSymbolsIn = bit2int(codeword,k);
frame_length = length(dataSymbolsIn);
%%% modulation: Gray-encoded, unit-power
%%% qam
% TxSignal = qammod(dataSymbolsIn,M,'UnitAveragePower',true);

%%% psk
TxSignal = pskmod(dataSymbolsIn,M); % BPSK only


%%% Channel 
%%% seed
rng(20230823);

SNR_dB = 10;

noise_power = 1/dBToLinear(SNR_dB);

%%% CHANNEL
AWGN = sqrt(noise_power/2)*(randn(frame_length,1) + 1j*randn(frame_length,1) ) ;
RxSignal = TxSignal + AWGN;
% RxSignal = TxSignal;



