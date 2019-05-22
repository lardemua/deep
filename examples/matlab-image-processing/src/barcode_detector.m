function [value] = barcode_detector(I)

  K = [1 1 1 1 1] / 5;
  F_i = filter2(K, I) == 0;
  F_j = filter2(K', I) == 0;

  n = size(I, 1) * size(I,2);
  n_i = xor(F_i, F_j) == F_i;
  n_j = xor(F_i, F_j) == F_j;

  lines_i = sum(~n_i(:)) / n;
  lines_j = sum(~n_j(:)) / n;
  
  null_lines = lines_i < 0.2 || lines_j < 0.2;
  
  if null_lines
    value = abs(lines_i - lines_j) > 0.1;
  else
    value = 0;
  end

end