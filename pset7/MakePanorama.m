% Problem 1e

function [ im ] = MakePanorama( im1, im2, H )
% Makes a panorama
% im1 and im2 should be of same size
% H - given homography from im2 to im1

%Transform im2 with corresponding homography
T=maketform('projective',H);
[im2t,xdataim2t,ydataim2t]=imtransform(im2,T,'XYScale',1);

%figure, imshow(im2t);

% xdataim2t and ydataim2t store the bounds of the transformed im2
% We want extreme bounds for each transformed image.  Helps to blend when
% output images same size.
xdataout=[min(1,xdataim2t(1)) max(size(im1,2),xdataim2t(2))];
ydataout=[min(1,ydataim2t(1)) max(size(im1,1),ydataim2t(2))];

% Transform both images with the computed xdata and ydata
im2t=imtransform(im2,T,'XData',xdataout,'YData',ydataout,'XYScale',1);
im1t=imtransform(im1,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout,'XYScale',1);

im2t_mask = logical(im2single(rgb2gray(im2t)));
im1t_mask = logical(im2single(rgb2gray(im1t)));

im = im1t.*repmat((im1t_mask & ~im2t_mask), [1,1,3]) + ...
     im2t.*repmat((im2t_mask & ~im1t_mask), [1,1,3]) + ...
     (im1t/2 + im2t/2).*repmat((im1t_mask & im2t_mask), [1,1,3]);

%im = max(im1t, im2t);
%figure, imshow(im);

end