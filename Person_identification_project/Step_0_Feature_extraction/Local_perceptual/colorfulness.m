function C = colorfulness(im)
    [W, H, RGB] = size(im);   
    
    R = double(im(:,:,1));
    G = double(im(:,:,2));
    B = double(im(:,:,3));
    
    rg = abs(R - G);
    yb = abs(((1/2).*(R + G)) - B);
    
    stdRG = std2(rg);
    meanRG = mean2(rg);
    
    stdYB = std2(yb);
    meanYB = mean2(yb);
    
    stdRGYB = sqrt((stdRG)^2 + (stdYB)^2);
    meanRGYB = sqrt((meanRG)^2 + (meanYB)^2);
    
    C = stdRGYB + 0.3 * meanRGYB; 
end