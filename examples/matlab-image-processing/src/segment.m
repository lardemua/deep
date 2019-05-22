function [IMGS, BB] = segment(A)

  [H,W] = size(A);

  B = A < 0.01;
  
  C = bwfill(B, "holes");
  
  [L,n] = bwlabel(C);
  
  [I,J] = meshgrid(1:W,1:H);
  
  for idx=1:n
    F = L == idx;
    is = I(F);
    js = J(F);
    imin = min(is(:));
    imax = max(is(:));
    jmin = min(js(:));
    jmax = max(js(:));
    
    BB{idx} = [imin jmin imax-imin jmax-jmin];
  
    O = A(jmin+2:jmax-2, imin+2:imax-2);

    t = graythresh(O, "otsu");
    O = O > t;
    
    IMGS{idx} = O;

  end
  
end