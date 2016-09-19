% RETINEX - pset 4
%
% Implement a simple version of the retinex algorithm
img = mean(im2double(imread('simpleworld.jpg')),3);

% Derivation filters
clear fn
fn(:,:,1) = [0 0 0; -1 1 0; 0 0 0];
fn(:,:,2) = [0 0 0; -1 1 0; 0 0 0]';

% Compute derivatives
log_img = log(img+0.001);
out = convFn(log_img, fn);

% INSERT YOUR CODE HERE
t_h = 2.0*mean2(abs(out(:,:,1))); %fix threshold for the horizontal derivative matrix
t_v = 2.0*mean2(abs(out(:,:,2))); %fix threshold for the vertical derivative matrix

out(:,:,1) = out(:,:,1) .* (abs(out(:,:,1)) > t_h );
out(:,:,2) = out(:,:,2) .* (abs(out(:,:,2)) > t_v );

% Pseudo-inverse (using the trick from Weiss, ICCV 2001; equations 5-7)
log_ref = deconvFn(out,fn);

% INSERT YOUR CODE HERE
ref = 10.^(log_ref);

%Pick a column and plot it
col = 150;
figure
plot(1:size(img,2),log_img(:,col), 'b');
hold on;
plot(1:size(img,2),log_ref(:,col), 'r');
hold off;


% Visualization
figure
subplot(221)
imshow(img)
title('input (I)')
subplot(222)
imagesc(ref)
title('reflectance')
axis('square'); axis('off')
colormap(gray(256))
subplot(223)
imagesc(out(:,:,1))
title('dI/dx')
axis('square'); axis('off')
colormap(gray(256))
subplot(224)
imagesc(out(:,:,2))
title('dI/dy')
axis('square'); axis('off')
colormap(gray(256))
