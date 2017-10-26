function F = feature_set1(img)
    
    % Conversion from RGB to Gray and HSV
    hsv_img = double(rgb2hsv(img));
    gray_img = double(rgb2gray(img));
  
	% Each channel of HSV image 
    H = hsv_img(:,:,1);
    S = hsv_img(:,:,2);
    V = hsv_img(:,:,3);
    
    % Use of light
    f1 = mean2(V);
    
    % HSV statistics
    f2 = mean2(S);
    f3 = std2(V);
    f4 = std2(S);
    
    % Entropy of RGB image
    f5 = entropy(img);
    
    % Aspect ratio of the image
    X = size(img,2);%width
    Y = size(img,1);%height
    f6 = X/Y; % Aspect ratio
    
    % Rule of thirds
    start_X = ceil(X/3);
    end_X = ceil(2*(X/3));  
    start_Y = ceil(Y/3);
    end_Y = ceil(2*(Y/3));
    
    f7 = mean2(H(start_Y:end_Y,start_X:end_X));
    f8 = mean2(S(start_Y:end_Y,start_X:end_X));
    f9 = mean2(V(start_Y:end_Y,start_X:end_X));
    
    % Hue Circular Variance 
    % Default, H contain values [0 1]. So convert it to radian by multiplying 2pi.
    A = sum(sum(cos(H.*(2*pi))));   
    B = sum(sum(sin(H.*(2*pi))));
    N = X * Y;  
    f10 = 1 - (sqrt((A^2)+(B^2))/N);
    
    % Canny edge pixels count
    bin = edge(gray_img,'canny');
    f11 = sum(sum(double(bin)))/N;
    
    % Emotion based
    f12 = mean2(( 0.69 .* V) + (0.22 .* S)); % Pleasure
    f13 = mean2((-0.31 .* V) + (0.60 .* S)); % Arousal
    f14 = mean2(( 0.76 .* V) + (0.32 .* S)); % Dominance
    
    % Colorfulness (by Hasler and Susstrunk, 2003)
    f15 = colorfulness(img);
      
    % Tamura http://wiki.jmbanda.com/docs/comp1_results_8/file40.html
    all_tamura = tamura(gray_img);
    f16 = all_tamura(1,1);% Coarseness
    f17 = all_tamura(1,5);% Directionality
    f18 = all_tamura(1,6);% Contrast
    
    
    % Wavelet Textures in H, S, V channels
    % First do it in H channel, Then S channel, and Finally V channel
    [C,M] = wavedec2(H,3,'db4'); % Hue Channel
    cH3 = detcoef2('h',C,M,3);
    cV3 = detcoef2('v',C,M,3);
    cD3 = detcoef2('d',C,M,3);
    f19 = (sum(sum(cH3)) + sum(sum(cV3)) + sum(sum(cD3)))/(3*size(cH3,1)*size(cH3,2));
    
    cH2 = detcoef2('h',C,M,2);
    cV2 = detcoef2('v',C,M,2);
    cD2 = detcoef2('d',C,M,2);
    f20 = (sum(sum(cH2)) + sum(sum(cV2)) + sum(sum(cD2)))/(3*size(cH2,1)*size(cH2,2));
     
    cH1 = detcoef2('h',C,M,1);
    cV1 = detcoef2('v',C,M,1);
    cD1 = detcoef2('d',C,M,1);
    f21 = (sum(sum(cH1)) + sum(sum(cV1)) + sum(sum(cD1)))/(3*size(cH1,1)*size(cH1,2));
    
    f22 = f19+f20+f21;
    
    [C,M] = wavedec2(S,3,'db4'); % Saturation Channel
    cH3 = detcoef2('h',C,M,3);
    cV3 = detcoef2('v',C,M,3);
    cD3 = detcoef2('d',C,M,3);
    f23 = (sum(sum(cH3)) + sum(sum(cV3)) + sum(sum(cD3)))/(3*size(cH3,1)*size(cH3,2));
    
    cH2 = detcoef2('h',C,M,2);
    cV2 = detcoef2('v',C,M,2);
    cD2 = detcoef2('d',C,M,2);
    f24 = (sum(sum(cH2)) + sum(sum(cV2)) + sum(sum(cD2)))/(3*size(cH2,1)*size(cH2,2));
     
    cH1 = detcoef2('h',C,M,1);
    cV1 = detcoef2('v',C,M,1);
    cD1 = detcoef2('d',C,M,1);
    f25 = (sum(sum(cH1)) + sum(sum(cV1)) + sum(sum(cD1)))/(3*size(cH1,1)*size(cH1,2));
    
    f26 = f23+f24+f25;
    
    [C,M] = wavedec2(V,3,'db4'); % Value Channel
    cH3 = detcoef2('h',C,M,3);
    cV3 = detcoef2('v',C,M,3);
    cD3 = detcoef2('d',C,M,3);
    f27 = (sum(sum(cH3)) + sum(sum(cV3)) + sum(sum(cD3)))/(3*size(cH3,1)*size(cH3,2));
    
    cH2 = detcoef2('h',C,M,2);
    cV2 = detcoef2('v',C,M,2);
    cD2 = detcoef2('d',C,M,2);
    f28 = (sum(sum(cH2)) + sum(sum(cV2)) + sum(sum(cD2)))/(3*size(cH2,1)*size(cH2,2));
     
    cH1 = detcoef2('h',C,M,1);
    cV1 = detcoef2('v',C,M,1);
    cD1 = detcoef2('d',C,M,1);
    f29 = (sum(sum(cH1)) + sum(sum(cV1)) + sum(sum(cD1)))/(3*size(cH1,1)*size(cH1,2));
    
    f30 = f27+f28+f29;
    
    % 3 features from low depth of field (DOF)
    [C,M] = wavedec2(H,3,'db4'); % Hue Channel
    cH3 = detcoef2('h',C,M,3);
    cV3 = detcoef2('v',C,M,3);
    cD3 = detcoef2('d',C,M,3);
    
    w = size(cH3,2);%width
    h = size(cH3,1);%height
    
    start_X = ceil(w/4);
    end_X = ceil(3*(w/4));
    start_Y = ceil(h/4);
    end_Y = ceil(3*(h/4));
    
    add1 = sum(sum(cH3(start_Y:end_Y,start_X:end_X)))+sum(sum(cV3(start_Y:end_Y,start_X:end_X)))+sum(sum(cD3(start_Y:end_Y,start_X:end_X)));
    add2 = sum(sum(cH3)) + sum(sum(cV3)) + sum(sum(cD3));
    if add2 ~= 0
        f31 = add1/add2;
    else
        f31 = 0;
    end
    
    [C,M] = wavedec2(S,3,'db4'); % Saturation Channel
    cH3 = detcoef2('h',C,M,3);
    cV3 = detcoef2('v',C,M,3);
    cD3 = detcoef2('d',C,M,3);
    
    add1 = sum(sum(cH3(start_Y:end_Y,start_X:end_X)))+sum(sum(cV3(start_Y:end_Y,start_X:end_X)))+sum(sum(cD3(start_Y:end_Y,start_X:end_X)));
    add2 = sum(sum(cH3)) + sum(sum(cV3)) + sum(sum(cD3));
    if add2 ~= 0
        f32 = add1/add2;
    else
        f32 = 0;
    end
    
    [C,M] = wavedec2(V,3,'db4'); % Value Channel
    cH3 = detcoef2('h',C,M,3);
    cV3 = detcoef2('v',C,M,3);
    cD3 = detcoef2('d',C,M,3);
    
    add1 = sum(sum(cH3(start_Y:end_Y,start_X:end_X)))+sum(sum(cV3(start_Y:end_Y,start_X:end_X)))+sum(sum(cD3(start_Y:end_Y,start_X:end_X)));
    add2 = sum(sum(cH3)) + sum(sum(cV3)) + sum(sum(cD3));
     if add2 ~= 0
        f33 = add1/add2;
    else
        f33 = 0;
    end
    
    % GLCM texture features for H,S and V channels   
    glcms = graycomatrix(H);
    stats = graycoprops(glcms,'all');
    f34 = stats.Contrast;
    f35 = stats.Correlation; %It become NaN
    if isnan(f35)
       f35 = 0; 
    end
    f36 = stats.Energy;
    f37 = stats.Homogeneity;
    
    glcms = graycomatrix(S);
    stats = graycoprops(glcms,'all');
    f38 = stats.Contrast;
    f39 = stats.Correlation; %It become NaN
    if isnan(f39)
       f39 = 0; 
    end
    f40 = stats.Energy;
    f41 = stats.Homogeneity;
    
    glcms = graycomatrix(V);
    stats = graycoprops(glcms,'all');
    f42 = stats.Contrast;
    f43 = stats.Correlation; %It become NaN
    if isnan(f43)
       f43 = 0; 
    end
    f44 = stats.Energy;
    f45 = stats.Homogeneity;
    
    % Colornames %Use http://www.color-blindness.com/color-name-hue/   
    Hue = H .* 360; % Represented in 360 deg (H) cylinder, height of cylinder = S (0 to 1), radius of cylinder = V (0 to 1)
    
    black = V <= 0.15;
    f46 = sum(sum(black))/N;
    
    white = (S <= 0.05) & (V >= 0.85);
    f47 = sum(sum(white))/N;
    
    gray = (S <= 0.05) & (V < 0.85) & (V > 0.15);
    f48 = sum(sum(gray))/N;
    
    red = ((Hue >= 0 & Hue <= 12) | (Hue >= 339 & Hue <= 360)) & (S >= 0.8) & (V >= 0.5);
    f49 = sum(sum(red))/N;
   
    orange = (Hue >= 13 & Hue <= 41) & (S >= 0.8) & (V >= 0.5);
    f50 = sum(sum(orange))/N;
    
    yellow = (Hue >= 42 & Hue <= 71) & (S >= 0.8) & (V >= 0.5);
    f51 = sum(sum(yellow))/N;
    
    green = (Hue >= 72 & Hue <= 155) & (S >= 0.8) & (V >= 0.5);
    f52 = sum(sum(green))/N;
    
    cyan = (Hue >= 156 & Hue <= 185) & (S >= 0.8) & (V >= 0.5);
    f53 = sum(sum(cyan))/N;
    
    blue = (Hue >= 186 & Hue <= 250) & (S >= 0.8) & (V >= 0.5);
    f54 = sum(sum(blue))/N;
    
    purple = (Hue >= 251 & Hue <= 299) & (S >= 0.8) & (V >= 0.5);
    f55 = sum(sum(purple))/N;
    
    magenta = (Hue >= 300 & Hue <= 326) & (S >= 0.8) & (V >= 0.5);
    f56 = sum(sum(magenta))/N;
    
    pink = (Hue >= 327 & Hue <= 338) & (S >= 0.8) & (V >= 0.5);
    f57 = sum(sum(pink))/N;
    
    
    
    F = [f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,...
         f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,...
         f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,...
         f31,f32,f33,f34,f35,f36,f37,f38,f39,f40,...
         f41,f42,f43,f44,f45,f46,f47,f48,f49,f50,...
         f51,f52,f53,f54,f55,f56,f57];
end

