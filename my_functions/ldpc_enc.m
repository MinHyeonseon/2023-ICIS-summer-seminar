%% ldpc_enc 함수
function encodedData = ldpc_enc(data, parityCheckMatrix)
% 간략한 LDPC 인코딩 함수
% 여기서는 패리티 비트를 직접 계산하지 않고, 데이터에 추가
encodedData = [data, zeros(1, size(parityCheckMatrix, 1))];
end