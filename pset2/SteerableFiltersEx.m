% 6.869 Advances in Computer Vision
% Andrew Moran
% PSET 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SteerableFiltersEx(im)
if ~isa(im,'double')
    im = im2double(im);
end
if size(im,3)>1
    im = rgb2gray(im);
end

% Problem 2.4
% Part A, B
figure
imagesc(im);
axis('equal'); axis('off')
title('Input gray')
colormap(gray)

[G2a,G2b,G2c] = G2(im);
[H2a,H2b,H2c,H2d] = H2(im);
[C1,C2,C3] = FourierG2(G2a,G2b,G2c,H2a,H2b,H2c,H2d);

thetaD = (atan2(C3, C2))/2.0;
thetaP = thetaD + pi/2.0;

kd_a = (cos(thetaD)).^2;
kd_b = -2*(cos(thetaD).*sin(thetaD));
kd_c = (sin(thetaD)).^2;

kp_a = (cos(thetaP)).^2;
kp_b = -2*(cos(thetaP).*sin(thetaP));
kp_c = (sin(thetaP)).^2;

G2dom = kd_a.*G2a + kd_b.*G2b + kd_c.*G2c;
G2per = kp_a.*G2a + kp_b.*G2b + kp_c.*G2c;

figure
imagesc(G2dom);
axis('equal'); axis('off')
title('G2 dominant')
colormap(gray)

figure
imagesc(G2per);
axis('equal'); axis('off')
title('G2 perpendicular')
colormap(gray)

% Part C, D
s = sqrt((C2).^2 + (C3).^2);
epsilon = 0.1;

G2dom_norm = G2dom./(s + epsilon);
G2per_norm = G2per./(s + epsilon);

figure
imagesc(G2dom_norm);
axis('equal'); axis('off')
title('G2 dominant norm')
colormap(gray)

figure
imagesc(G2per_norm);
axis('equal'); axis('off')
title('G2 perpendicular norm')
colormap(gray)

% Part E
mean = ones(3)/9;

G2_dom_norm_mean = conv2(G2dom, mean, 'same');
G2_dom_norm_mean = G2_dom_norm_mean./(s + .1);

G2_per_norm_mean = conv2(G2per, mean, 'same');
G2_per_norm_mean = G2_per_norm_mean./(s + .1);

figure
imagesc(G2_dom_norm_mean);
axis('equal'); axis('off')
title('G2 dominant norm mean')
colormap(gray)

figure
imagesc(G2_per_norm_mean);
axis('equal'); axis('off')
title('G2 perpendicular norm mean')
colormap(gray)

%--------------------------------------------------------------------------
% Steerable filters

% Computes the image response to the second derivative Gaussian filter (G2) basis set 
% using the 9-tap filter kernels derived in Freeman and Adelson (1991), table IV
function [G2a,G2b,G2c] = G2(im)

f1 = [0.0094 0.1148 0.3964 -0.0601 -0.9213 -0.0601 0.3964 0.1148 0.0094];
f2 = [0.0008 0.0176 0.1660 0.6383 1.0 0.6383 0.1660 0.0176 0.0008];
f3 = [-0.0028 -0.0480 -0.3020 -0.5806 0.0 0.5806 0.3020 0.0480 0.0028]; 

G2a = conv2(f2,f1,im,'same');
G2b = conv2(f3,f3,im,'same');
G2c = conv2(f1,f2,im,'same');

% Computes the image response to the Hilbert transform of the second derivative Gaussian filter (H2) basis set 
% using the 9-tap filter kernels derived in Freeman and Adelson (1991), table VI
function [H2a,H2b,H2c,H2d] = H2(im)

f1 = [-0.0098 -0.0618 0.0998 0.7551 0.0 -0.7551 -0.0998 0.0618 0.0098];
f2 = [0.0008 0.0176 0.1660 0.6383 1.0 0.6383 0.1660 0.0176 0.0008];
f3 = [-0.0020 -0.0354 -0.2225 -0.4277 0.0 0.4277 0.2225 0.0354 0.0020];
f4 = [0.0048 0.0566 0.1695 -0.1889 -0.7349 -0.1889 0.1695 0.0566 0.0048];

H2a = conv2(f2,f1,im,'same');
H2b = conv2(f3,f4,im,'same');
H2c = conv2(f4,f3,im,'same');
H2d = conv2(f1,f2,im,'same');

function [C1,C2,C3] = FourierG2(G2a,G2b,G2c,H2a,H2b,H2c,H2d)
% Returns coefficients [C1, C2, C3] that can be used to estimate the
% oriented energy as a function of angle:
%
% E = C1 + c2*cos(2*theta) + C3*sin(2*theta) + (higher-order terms).
%
% Please refer to Section V.A. and Table XI for details.  This
% function takes as input the image response to the basis of the G2
% and H2 steerable filters.

C1 = 0.5*G2b.^2 + 0.25*G2a.*G2c + 0.375*(G2a.^2 + G2c.^2) + ...
     0.3125*(H2a.^2 + H2d.^2) + 0.5625*(H2b.^2 + H2c.^2) + ...
     0.375*(H2a.*H2c + H2b.*H2d);
 
C2 = 0.5*(G2a.^2 - G2c.^2) + 0.46875*(H2a.^2 - H2d.^2) + ...
     0.28125*(H2b.^2 - H2c.^2) + 0.1875*(H2a.*H2c - H2b.*H2d);
 
C3 = -G2a.*G2b - G2b.*G2c - ...
     0.9375*(H2c.*H2d + H2a.*H2b) - ...
     1.6875*H2b.*H2c - 0.1875*H2a.*H2d;
