function [IMGS, sequence, ids] = load_dataset(path)
  
  folder = sprintf("%s/svpi2018_TP1_img_???_??.png", path);
  
  imgs = dir(folder);
  
  for i=1:size(imgs,1)
    
    val = sscanf(imgs(i).name, "svpi2018_TP1_img_%d_%d", 2);
    
    sequence{i} = val(1);
    ids{i} = val(2);
    
    IMGS{i} = im2double(imread(sprintf("%s/%s", path, imgs(i).name)));
  end
  
end