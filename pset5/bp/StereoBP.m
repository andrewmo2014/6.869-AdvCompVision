function dx = StereoBP(Il,Ir)
% Estimates horizontal disparities of image pair using belief propagation.
% The images are assumed to be grayscale.
% Output: dx - the horizontal offsets in direction Il --> Ir.

% Parameters
lambda = .2;
disp = 0:10;

L = length(disp); % number of disparities that we consider

[height,width] = size(Ir);

% Precompute data term
fprintf('Computing data term\n');
D = zeros(height,width,L); 
for y=1:height
  for x=1:width
    for l=1:L
      dx = disp(l);
      if x-dx<1
        D(y,x,l) = 0; % boundary effect
      else
        % FILL IN D(y, x, l)
        y_l = Il(y,x);
        y_r = Ir(y,x-dx);
        D(y,x,l) = exp(-lambda*abs(y_l - y_r)); 
      end
    end
  end
end

% Precompute smoothness term
fprintf('Computing smoothness term\n');
P = zeros(L,L);
for l1=1:L
  for l2=1:L
    dx1 = disp(l1);
    dx2 = disp(l2);
    % FILL IN P(l1, l2)
    P(l1,l2) = exp(-abs(dx1-dx2));
  end
end

% Messages for max product
msgs_maxprod = ones(height,width,2,L);

% Messages for sum product
msgs_sumprod = ones(height,width,2,L);

% Constants to indicate direction 
LEFT=1;
RIGHT=2; 

% We do belief propagation for each row in the images. We compute messages
% for both max-product and sum-product.
fprintf('Performing sum-product message passing: ');
for y=1:height
  fprintf('.');

  % Forward pass: pass messages from left to right
  for x=1:width-1
    % FILL IN msgs_sumprod(y,x+1,LEFT,:)
    % x   -> node j
    % x+1 -> node i
    % EQUATION: m_ji(x_i) = 
    %               SUM_{x_j} [ P(x_i, x_j) * PROD_{k=n(j)~i} m_kj(x_j) ] 
    
    k_T = ones(L,1);    %(y) Top neighbor message
    k_P = ones(L,1);    %(x) Input neighbor message
    
    k_T(:) = D(y,x,:);
    k_P(:) = msgs_sumprod(y,x,LEFT,:);
    m_prev = k_T .* k_P;
    
    result = P * (m_prev);
    result = result / sum(result);
    
    msgs_sumprod(y,x+1,LEFT,:) = result;
  end
  
  % Backward pass: pass messages from right to left
  for x=width:-1:2
    % FILL IN msgs_sumprod(y,x-1,RIGHT,:)
    
    k_T = ones(L,1);    %(y) Top neighbor message
    k_P = ones(L,1);    %(x) Input neighbor message
    
    k_T(:) = D(y,x,:);
    k_P(:) = msgs_sumprod(y,x,RIGHT,:);
    m_prev = k_T .* k_P;
    
    result = P * ( m_prev );
    result = result / sum(result);
    
    msgs_sumprod(y,x-1,RIGHT,:) = result;
  end
  
end
fprintf('\n');

fprintf('Performing max-product message passing: ');
for y=1:height
  fprintf('.');

  % Forward pass: pass messages from left to right
  for x=1:width-1
    % FILL IN msgs_maxprod(y,x+1,LEFT,:) 
    
    k_T = ones(L,1);    %(y) Top neighbor message
    k_P = ones(L,1);    %(x) Input neighbor message
    
    k_T(:) = D(y,x,:);
    k_P(:) = msgs_maxprod(y,x,LEFT,:);
     
    m_prev = k_T .* k_P;
    
    R = zeros(size(P));
    for l=1:L
        R(:,l) = (P(:,l) .* m_prev);
    end
    
    [arg_val, arg_max] = max(R, [], 1);
    result = arg_val / sum(arg_val);
    msgs_maxprod(y,x+1,LEFT,:) = result;
   
  end
  % Backward pass: pass messages from right to left
  for x=width:-1:2
    % FILL IN msgs_maxprod(y,x-1,RIGHT,:) 
    
    k_T = ones(L,1);    %(y) Top neighbor message
    k_P = ones(L,1);    %(x) Input neighbor message
    
    k_T(:) = D(y,x,:);
    k_P(:) = msgs_maxprod(y,x,RIGHT,:);
     
    m_prev = k_T .* k_P;
    
    R = zeros(size(P));
    for l=1:L
        R(:,l) = (P(:,l) .* m_prev);
    end
    
    [arg_val, arg_max] = max(R, [], 1);
    result = arg_val / sum(arg_val);
    msgs_maxprod(y,x-1,RIGHT,:) = result;
    
  end
end
fprintf('\n');

% Compute marginals
fprintf('Computing marginals\n');
marg = ComputeMarginals(D, msgs_sumprod, disp);

% Compute mean
fprintf('Computing mean\n');
mu = ComputeMean(D, msgs_sumprod, disp);

% Compute MAP
fprintf('Computing MAP\n');
map = ComputeMAP(D, msgs_maxprod, disp);

% Start visualizing everything...
fprintf('Visualizing...\n');
Visualize(Il, Ir, D, msgs_maxprod, msgs_sumprod, marg, mu, map, disp);



function dx = ComputeMAP(D,msgs,disp)

[height,width,L] = size(D);
marg = ComputeMarginals(D, msgs, disp);

b = zeros(L,1);
dx = zeros(height,width);
for y=1:height
  for x=1:width
    % FILL IN: Compute the MAP estimate
    
    P_l = reshape(marg(y,x,:), length(disp), 1);
    
    [val, d] = max( P_l, [], 1 );
    dx(y,x) = d;
    
  end
end



function marg = ComputeMarginals(D, msgs, disp)

[height,width,L] = size(D);

b = zeros(L,1);
marg = zeros(height,width,L);
for y=1:height
  for x=1:width
    % FILL IN: Compute marginals 
    
    m_top = ones(L,1);
    m_left = ones(L,1);
    m_right = ones(L,1);
    
    m_top(:) = D(y,x,:);
    m_left(:) = msgs(y,x,1,:);
    m_right(:) = msgs(y,x,2,:);
    
    result = m_top .* m_left .* m_right;
    result = result / sum(result);
    marg(y, x, :) = result;
  
  end
end



function mu = ComputeMean(D, msgs, disp)

mu = zeros(size(D,1), size(D, 2));
marg = ComputeMarginals(D, msgs, disp);

L = length(disp);

% FILL IN: Compute mean (hint: you can use ComputeMarginals)
for y=1:size(D,1)
  for x=1:size(D,2)
      
       P_l = reshape(marg(y,x,:), length(disp), 1);
       mu(y,x) = dot(disp, P_l);
  end
end



% This function visualizes different aspects of the algorithm. You can tweak
% the parameters if you like. Be sure to include important ones in your writeup.
function Visualize(Il, Ir, D, msgs_maxprod, msgs_sumprod, marg, mu, map, disp);

scanline = 61;
LEFT=1;
RIGHT=2;
L = size(D, 3);

colormap gray;

% Show the stereo pair
clf;
subplot(121); imagesc(Il); axis image; title('Stereo Left', 'FontSize', 20);
subplot(122); imagesc(Ir); axis image; title('Stereo Right', 'FontSize', 20);
pause;

% Plot a scanline
clf; 
subplot(221);
img1 = repmat(Il, [1 1 3]) / 255;
img1(scanline, :, 1:2) = 0;
img1(scanline, :, 3) = 1;
imagesc(img1); axis image; title('Left Image Scanline', 'FontSize', 20);
subplot(223);
img2 = repmat(Ir, [1 1 3]) / 255;
img2(scanline, :, 2:3) = 0;
img2(scanline, :, 1) = 1;
imagesc(img2); axis image; title('Right Image Scanline', 'FontSize', 20)
subplot(122); hold on;
h1 = plot(Il(scanline, :), 'b', 'LineWidth', 5);
h2 = plot(Ir(scanline, :), 'r', 'LineWidth', 5);
legend('Left Image', 'Right Image'); title('Plot of a Scanline', 'FontSize', 20);
pause;

% Plot the messages for a pixel on this scanline
clf; 
pixel = 140;
subplot(121); 
img = repmat(Il, [1 1 3]) / 255;
img(scanline, pixel, :) = [0 1 0];
imagesc(img); axis image;
subplot(122); hold on;
plot(squeeze(msgs_sumprod(scanline, pixel, LEFT, :)), 'b', 'LineWidth', 5);
plot(squeeze(msgs_sumprod(scanline, pixel, RIGHT, :)), 'r', 'LineWidth', 5);
legend('Forward Pass', 'Backward Pass');
xlabel('Disparity');
title('Messages at Green Pixel', 'FontSize', 20);
pause;

% Plot the marginals for a pixel on this scanline
img = repmat(Il, [1 1 3]) / 255;
colors = [1 0 0; 0 1 0];
pixels = [140 130];
clf; subplot(122); hold on;
for i=1:length(pixels),
  img(scanline, pixels(i), :) = colors(i, :);
  plot(squeeze(marg(scanline, pixels(i), :)), '.', 'MarkerSize', 40, 'MarkerEdgeColor', colors(i, :));
end
subplot(121); imagesc(img); axis image;
subplot(122);
ylim([0 1]); xlabel('Disparity'); ylabel('Marginal Probability'); title('Marginals at Green and Red Pixels', 'FontSize', 20);
pause;

% Visualize the mean and map at this scanline
clf; hold on;
plot(squeeze(mu(scanline, :)), 'b', 'LineWidth', 5);
plot(squeeze(map(scanline, :)), 'r', 'LineWidth', 5);
legend('Mean at Scanline', 'MAP at Scanline');
title('Plot of Mean and MAP Estimates on Scanline', 'FontSize', 20);
pause;

% Visualize marginals for all scanlines
clf;
for i=1:9,
  subplot(3,3,i); imagesc(marg(:, :, i)); axis image; title(sprintf('Marginals for Disparity=%i', disp(i)), 'FontSize', 20);
end
pause;

% Visualize mean and map for all scanlines
clf;
subplot(121); imagesc(mu); title('Mean', 'FontSize', 20); axis image;
subplot(122); imagesc(map); title('MAP', 'FontSize', 20); axis image;
drawnow;
