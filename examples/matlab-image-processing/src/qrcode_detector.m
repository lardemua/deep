function [valid] = qrcode_detector(I)
  
  padding{1,1} = find(sum(~I,1) > 5)(1);
  padding{1,2} = find(sum(~I,1) > 5)(end);
  padding{2,1} = find(sum(~I,2) > 5)(1);
  padding{2,2} = find(sum(~I,2) > 5)(end);
  
  Q = I( padding{2,1}:padding{2,2}, padding{1,1}:padding{1,2} );

  SQUARE = [
    0,0,0,0,0,0,0;
    0,1,1,1,1,1,0;
    0,1,0,0,0,1,0;
    0,1,0,0,0,1,0;
    0,1,0,0,0,1,0;
    0,1,1,1,1,1,0;
    0,0,0,0,0,0,0;
  ];

  [w, h] = size(I);
  
  for i=1:ceil(log2(h)-1)
    F = kron(SQUARE, ones(i));
    s = size(F, 1);
    corner{1,1} = Q(1:s, 1:s);
    corner{1,2} = Q(1:s, (end-s+1):end);
    corner{2,1} = Q((end-s+1):end, 1:s);;
    corner{2,2} = Q((end-s+1):end, (end-s+1):end);
    
    match{1,1} = sum((corner{1,1} == F)(:)) > (s*s) * 0.8;
    match{1,2} = sum((corner{1,2} == F)(:)) > (s*s) * 0.8;
    match{2,1} = sum((corner{2,1} == F)(:)) > (s*s) * 0.8;
    match{2,2} = sum((corner{2,2} == F)(:)) > (s*s) * 0.8;
    
    valid = sum(sum(cell2mat(match)));
    
    if valid == 3
      break;
    end
  end

end