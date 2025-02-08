%%% ICIS tutorial code
%%% convolutional encoding, LDCP encoding
%%% reference links
%%% [1] LDPC encoding: https://kr.mathworks.com/help/comm/ref/ldpcencode.html
%%% [2] LDPC decoding: https://kr.mathworks.com/help/comm/ref/ldpcdecode.html#mw_016f2a8c-905d-4a76-a1a6-881750fb00eb
clear all; 
close all; 
clc;

dBToLinear = @(x)( 10.^(x./10) );
LinearTodB = @(x)( 10*log10(x) );

load('quiz_data.mat');

%%% demodulation: Gray-encoded, unit-power
%%% qam
% decoded_Sym = qamdemod(RxSignal,M);

%%% psk
decoded_Sym = pskdemod(RxSignal,M,OutputType='approxllr');

decoded_codeword = decoded_Sym;

cfgLDPCDec = ldpcDecoderConfig(pcmatrix);


decoded_codeword_sample = zeros(blk_length,1);
decoded_bit = zeros(ldpc_input_length*num_iteration,1);

%%% TODO start
%%% 

for i1 = 1:num_iteration

    idx_start = (i1-1)*ldpc_input_length + 1;
    idx_code_start = (i1-1)*blk_length + 1;

    codeword_sample_received = decoded_codeword(idx_code_start:(idx_code_start + blk_length - 1));

    decoded_bit_sample = ldpcDecode(codeword_sample_received, cfgLDPCDec, maxnumiter);

    if i1 == num_iteration
        last_blk = length(Bit_dataIn(idx_start:end));
        decoded_bit(idx_start:(idx_start + last_blk - 1)) = decoded_bit_sample(1:last_blk);
    else
        decoded_bit(idx_start:(idx_start + ldpc_input_length - 1)) = decoded_bit_sample;
    end
end

%%%
%%% TODO end

decoded_bit = decoded_bit(1:n*k);


%%% error checking
num_error = biterr(Bit_dataIn, decoded_bit);
disp(num_error);

%%% binary to string
decoded_bit_msg = decoded_bit(1:string_length);
rx_bit_stream = dec2bin(decoded_bit_msg) ; % transpose is required
rx_bit_stream_perChar = reshape(rx_bit_stream,[],7);
rx_bit_stream_perChar = bin2dec(rx_bit_stream_perChar);

rx_data = char(rx_bit_stream_perChar);
fprintf('Received message: %s\n', rx_data);


