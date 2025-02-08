function matrix = randint(M, N)
    % 무작위 0 또는 1의 원소로 채워진 MxN 행렬 생성
    matrix = randi([0, 1], M, N);
end