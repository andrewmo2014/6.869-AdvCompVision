% 6.869 Advances in Computer Vision
% Andrew Moran
% PSET 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pset2main

%%
%Problem 2.1 (a)
img = imread('apple.png');
LapPyrA(img);
%%
%Problem 2.1 (b)
im1 = imread('andremo_pic.jpg');
im2 = imread('toast.jpg');
mask = imread('andremo_sand_mask.jpg');
mask = mask(:,:,1);

LapPyrA(im1);
LapPyrA(im2);
figure
imshow(mask)
axis('off'); axis('equal')
title('Mask')
PyrBlend(im1, im2, mask);
%%
%Problem 2.2
im1 = imread('husky.jpg');
im2 = imread('andremo_pic.jpg');
%Close pic
out = HybridIm(im1, im2);

%Far pic - Downsampled version
sampleDn = blurDn(im2double(out), 3);
width = size(sampleDn,2)/3;
c = mat2cell(sampleDn, [size(sampleDn,1)], [width, width, width]);

smallIm = im2double(c{1}*0.0);
smallIm = repmat(smallIm, [1,1,3]);
smallIm(:,:,1) = c{1};
smallIm(:,:,2) = c{2};
smallIm(:,:,3) = c{3};

figure
imshow(smallIm);
axis('off'); axis('equal')
title('Far Hybrid image')

%%
%Problem 2.4
im = imread('einstein.png');
SteerableFiltersEx(im);

end