function [classes] = classify(imgs)
    
  for i=1:size(imgs, 2)
    if qrcode_detector(imgs{i})
      classes(i) = 3;
    elseif barcode_detector(imgs{i})
      classes(i) = 2;
    else
      classes(i) = 1;
    end
  end

end