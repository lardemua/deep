
if exist('OCTAVE_VERSION', 'builtin') > 0
  pkg load image
end

dataset = getenv('DATASET');
output = getenv('OUTPUT');
save_processed_images = strcmp(getenv('SAVE_PROCESSED_IMAGES'), 'true');

printf('[Setup] dataset = %s\n', dataset);
printf('[Setup] output = %s\n', output);
printf('[Setup] save_processed_images = %d\n', save_processed_images);

printf('[Loading] Loading dataset %s\n', dataset)

[IMGS, seq, id] = load_dataset(dataset);

for i = 1:size(IMGS,2)
 
 printf('[Processing] Processing image %d/%d \n', i, size(IMGS, 2));
 
  if save_processed_images
    fig = display_processed_image(IMGS{i});
    out_fig = sprintf('%s/processed_img_%d.jpg', output, i);
    printf('[Processing] Saving processed image %d\n', i);
    saveas(fig, out_fig);
  end
 

  [READ BB] = segment(IMGS{i});
  
  qrcodes = 0; barcodes = 0; invalid = 0;
  rotations = [0 0 0 0];
  valid_without_reflexion = 0;
  barcode_invalid = 0;
  barcode_digits = 0;
  encodings = [0 0 0];
  middle_digits = [];
  
  for j=1:size(READ,2)
    if barcode_detector(READ{j})
      barcodes = barcodes + 1;
      [valid, value, encoding, rotation, flipped] = barcode_read(READ{j});
      rotations(rotation+1) = rotations(rotation+1) + 1;
      if ~valid
        barcode_invalid = barcode_invalid + 1;  
      end
      if valid && flipped
        valid_without_reflexion = valid_without_reflexion + 1;
      end
      if valid
        barcode_digits = barcode_digits + size(value, 2);
        encodings(encoding) = encodings(encoding) + 1;
        middle_digits = [middle_digits value(ceil(end/2))];
      end
      
    elseif qrcode_detector(READ{j})
      qrcodes = qrcodes + 1;
    else
      invalid = invalid + 1;
    end
  end
  
  middle_digits = sort(middle_digits);
  digit_string{i} = sprintf("%d", middle_digits);
  
  data(i,:) = [
    0 ...
    seq{i} id{i}...
    invalid barcodes qrcodes...
    rotations...
    valid_without_reflexion...
    barcode_invalid...
    barcode_digits...
    encodings
  ];

end

% write to file
out_file = sprintf("%s/results.txt", output);

printf('[Finish] Saving results to %s\n', out_file);

f = fopen(out_file, 'w');

for i = 1:size(data, 1)
  fprintf(f, "%d,", data(i,:));
  fprintf(f, "%s\n", digit_string{i});
end

fclose(f);

