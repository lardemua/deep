function [fig]=display_processed_image(IMG)
  
  [IMGS BB] = segment(IMG);
  
    

  fig = figure('Visible', 'off');
  imshow(IMG);
  hold on;
  
  for i=1:size(IMGS,2)
    if barcode_detector(IMGS{i})
      rectangle("Position", BB{i}, "EdgeColor", "b", "LineWidth", 2);
    elseif qrcode_detector(IMGS{i})
      rectangle("Position", BB{i}, "EdgeColor", "r", "LineWidth", 2);
    else
      rectangle("Position", BB{i}, "EdgeColor", "g", "LineWidth", 2);
    end
  end


  
end
