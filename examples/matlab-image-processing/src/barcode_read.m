function [valid, value, encoding, rotation, flipped] = barcode_read(I)
  
  BARCODE_BEGIN = [0,0,1,0,1,1,0,1,1,1,0];
  BARCODE_END   = [0,1,1,1,0,0,0,1,0,1,0,0];
  
  [i,j] = size(I);
  sum_i = sum(I,2)' / j;
  sum_j = sum(I,1)  / i;
  noise_i = abs(diff(sum_i, 5));
  noise_j = abs(diff(sum_j, 5));
  flat_i = noise_i < 0.3;
  flat_j = noise_j < 0.3;
  n_i = nnz(flat_i) / size(flat_i, 2);
  n_j = nnz(flat_j) / size(flat_j, 2);
  pos_i = mean(find(flat_i)) / i;
  pos_j = mean(find(flat_j)) / j;
  
  direction = n_i < n_j;
  
  if direction
    I = I';
    pos = pos_j;
  else
    pos = pos_i;
  end
  
  flipped_ud = pos > 0.5;
  
  if flipped_ud
    I = flipud(I);
    pos = 1 - pos;
  end
  
  
  slice = I(ceil(pos * size(I,1)) + (-2:2), :);
  slice = mean(slice,1) > 0.5;
  
  crop_begin = find(slice == 0)(1);
  crop_end   = find(slice == 0)(end);
  slice = slice(crop_begin:crop_end);
  
  flipped_lr = ...
    all(flip(slice(end-10:end)) == BARCODE_BEGIN) ...
    || flip(slice(end-21:end)) == kron(BARCODE_BEGIN, ones(1,2))...
    || flip(slice(end-32:end)) == kron(BARCODE_BEGIN, ones(1,3));
  
  if flipped_lr
    I = fliplr(I);
    slice = fliplr(slice);
  end
  
  for scale=1:3
    if slice(1:(11*scale)) == kron(BARCODE_BEGIN, ones(1,scale))
      break;
    end
  end
  
  slice = slice(1:scale:end);
  
  
  if direction
    flipped = xor(flipped_ud, ~flipped_lr);
    rotation = direction + 2 * flipped_lr;
  else
    flipped = xor(flipped_ud, flipped_lr);
    rotation = direction + 2 * flipped_ud;
  end
  
  if ~flipped
    rotation = mod(4 - rotation, 4);  
  end
  
%  figure(); imshow(I);
%  subplot(2,1,1); imshow(I);
%  subplot(2,1,2); imshow(slice);
  
  [valid, value, encoding] = barcode_decode(slice);

end
