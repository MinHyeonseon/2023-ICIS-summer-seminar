%% ldpc_dec 함수
function decodedData = ldpc_dec(encodedData, parityCheckMatrix)
% 간략한 LDPC 디코딩 함수
% 패리티 검사 행렬을 사용하여 디코딩을 수행하지 않음
decodedData = encodedData(1:end-size(parityCheckMatrix, 1));
end