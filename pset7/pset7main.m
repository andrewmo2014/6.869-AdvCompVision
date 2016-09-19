%%
%Problem 1a

x = linspace(0, 10, 30);
y = (2*x + 1) + 4*rand(size(x,1), size(x,2));

x = [x 2 5 10];
y = [y 20 0 10];

RANSAC2D_Prob1a(x,y);

%%
%Problem 1b - 
Prob1b;

%%
% Problem 1c
% Look at FitHomography
%%
% Rest of Problem 1
im1 = imread('ims/seoul1.jpg');
im2 = imread('ims/seoul2.jpg');

% Problem 1f Test
finalIm = PhotoMerge(im1, im2);
figure, imshow(finalIm);

%%
% Problem 1g
im1 = imread('ims/seoul1.jpg');
im2 = imread('ims/seoul2.jpg');
im3 = imread('ims/seoul3.jpg');

finalIm = PanoramaN({im1, im2, im3});
figure, imshow(finalIm);

%%
% Problem 1g
im1 = imread('ims/class-pics/IMG_2876.JPG');
im2 = imread('ims/class-pics/IMG_2877.JPG');
im3 = imread('ims/class-pics/IMG_2878.JPG');
im4 = imread('ims/class-pics/IMG_2879.JPG');
im5 = imread('ims/class-pics/IMG_2880.JPG');

%finalIm = PanoramaN({im1, im2, im3, im4, im5});
%figure, imshow(finalIm);

%%
% Problem 1g
% http://www.visualsize.com/mosaic3d/sample/chester_riverside/
im1 = imread('ims/riverside1.jpg');
im2 = imread('ims/riverside2.jpg');
im3 = imread('ims/riverside3.jpg');
im4 = imread('ims/riverside4.jpg');
im5 = imread('ims/riverside5.jpg');
im6 = imread('ims/riverside6.jpg');
im7 = imread('ims/riverside7.jpg');

%finalIm = PanoramaN({im1, im2, im3, im4, im5, im6, im7});
finalIm = PanoramaN({im4, im5, im6, im7});
figure, imshow(finalIm);








