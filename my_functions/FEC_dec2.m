function y = FEC_dec2(x, R)
    % 수신 데이터의 길이 계산
    received_length = numel(x);

    % FEC 코드로 인코딩된 데이터의 길이 계산
    encoded_length = received_length / R;

    % 복원된 데이터를 저장할 배열 초기화
    y = zeros(1, encoded_length);

    % 입력 데이터를 R개의 비트씩 그룹화하여 복원
    for i = 1:R:received_length
        % 그룹화된 R개의 비트를 XOR하여 복원
        group_bits = x(i:i+R-1);
        restored_bit = bitxor(group_bits(1), bitxor(group_bits(2:end), 1));
        y((i-1)/R + 1) = restored_bit;
    end
end