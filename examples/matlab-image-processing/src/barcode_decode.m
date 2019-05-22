function [valid, value, encoding] = barcode_decode(code)
  
  BARCODE_BEGIN = [0,0,1,0,1,1,0,1,1,1,0];
  BARCODE_END   = [0,1,1,1,0,0,0,1,0,1,0,0];
  value = [];
  encoding = 1;
  
  valid = code(1:11) == BARCODE_BEGIN && code(end-11:end) == BARCODE_END;
  
  if valid
    meat = code(12:end-12);
    n_digits = size(meat,2) / 7;
    digits_code = reshape(meat, 7, n_digits)';
  else
    return;
  end
 
  L = digits_code(:,1);
  R = digits_code(:,end);
  digits_code = digits_code(:,2:end-1);
  
  if L == 1 && R == 0
    % L or G codification; nothing to be done;
    [valid, value] = decode_digits(digits_code);
    if valid
      encoding = 1;
    else
      encoding = 3;
      [valid, value] = decode_digits(~fliplr(digits_code));  
    end
  elseif L == 0 && R == 1
    % R codification;
    % negate values;
    encoding = 2;
    digits_code = ~digits_code;
    [valid, value] = decode_digits(digits_code);
  else
    valid = false;
    break;
  end
  
  
end

function [valid, value] = decode_digits(encoded)
  
  valid = true;
  value = [];
  
  BARCODE_CODE = [
    1,1,0,0,1;
    1,0,0,1,1;
    1,0,1,1,0;
    0,0,0,0,1;
    0,1,1,1,0;
    0,0,1,1,1;
    0,1,0,0,0;
    0,0,0,1,0;
    0,0,1,0,0;
    1,1,0,1,0;
  ];
  
  for d=1:size(encoded, 1)
  
    found = false;
  
    for i=1:10
      if BARCODE_CODE(i,:) == encoded(d,:)
        value(d) = i - 1;
        found = true;
        break;
      end
    end
    
    if ~found
      valid = false;
      return;
    end
    
  
  end
  
end
