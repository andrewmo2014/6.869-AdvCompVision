%pset4main.m

%% Problem 4.2
% B

img_files = dir('pets/*.jpg');
n = length(img_files);

images = cell(20);
M = zeros(512,512);

for i = 1:n
    img_name = img_files(i).name;
    fullname = strcat('pets/', img_name); 
    img = mean(im2double(imread(fullname)), 3);
    
    %figure
    %imshow(img);
    
    
    imgNew = abs(fft2(img));
    M = M + imgNew;
    images{i} = imgNew;
end
M = M/n;

imagesc(log(abs(fftshift(M))));
colormap(gray);

%% C
selected_img = mean(im2double(imread('pets/im10.jpg')), 3);

sigma_n_vals = {10, 20};
sigma_s_vals = {1,2,3};

for i = 1:length(sigma_n_vals)
    
    sigma_n = sigma_n_vals{i};
    noiseimage = imnoise(selected_img,'gaussian',0,(sigma_n/255)^2);
    
    titleName = strcat('Input Noise sigma n = ', int2str(sigma_n));
    
    figure
    subplot(221)
    imshow(noiseimage);
    title(titleName)
    
    for j = 1:length(sigma_s_vals)
        
        sigma_s = sigma_s_vals{j};
        
        k = fspecial('gaussian', [4*sigma_n 4*sigma_n], sigma_s);
        imgNew = imfilter(noiseimage, k, 'same');
        
        titleName = strcat('Input Noise sigma s = ', int2str(sigma_s));
        plotNum = 221 + j;
        
        subplot(plotNum)
        imshow(imgNew);
        title(titleName);
        
    end
end

%% D

I_o = selected_img;
I_d = zeros(size(selected_img));

for i = 1:length(sigma_n_vals)
    
    sigma_n = sigma_n_vals{i};
    noiseimage = imnoise(selected_img,'gaussian',0,(sigma_n/255)^2);
        
    titleName = strcat('Input Noise sigma n = ', int2str(sigma_n));
    
    figure
    subplot(121)
    imshow(noiseimage);
    title(titleName)
    
    N2_sigma = ones(size(M)).*(512^2*(sigma_n/255)^2);
    
    %Wiener Filter
    W = 1./(1+(N2_sigma./(M.^2)));
    out = W.*(fft2(noiseimage));
    
    result = real(ifft2(out));
    I_d = result;

    subplot(122)
    imshow(result);
    title('Wiener Result');
end

%% E
%PNSR

%Convert pxel range from [0,1] to [0,255]
R = 255;

I_o = I_o .* R;
I_d = I_d .* R;

I_n10 = imnoise(selected_img,'gaussian',0,(10/255)^2) .* R;
I_n20 = imnoise(selected_img,'gaussian',0,(20/255)^2) .* R;

g_1 = fspecial('gaussian', [4*10 4*10], 1);
I_g10 = imfilter(noiseimage, g_1, 'same') .* R;

g_2 = fspecial('gaussian', [4*20 4*20], 2);
I_g20 = imfilter(noiseimage, g_1, 'same') .* R;

N = 512^2; %Total pixels
PNSR_Io_Id = 10 * log10( (R^2)*N/(norm(I_o - I_d).^2) )
PNSR_Io_In10 = 10 * log10( (R^2)*N/(norm(I_o - I_g10).^2) )
PNSR_Io_Ig10 = 10 * log10( (R^2)*N/(norm(I_o - I_n10).^2) )
PNSR_Io_In20 = 10 * log10( (R^2)*N/(norm(I_o - I_g20).^2) )
PNSR_Io_Ig20 = 10 * log10( (R^2)*N/(norm(I_o - I_n20).^2) )

%% Problem 4.3

noiseimage = imnoise(selected_img,'gaussian',0,(20/255)^2);

f = [1 -1];
out_uncorrupted = imfilter(selected_img, f, 'conv');
out_corrupted = imfilter(noiseimage, f, 'conv');

figure
subplot(121)
imagesc(out_uncorrupted)
title('dI/dx original')
axis('square'); axis('off')
colormap(gray(256));

subplot(122)
imagesc(out_corrupted)
title('dI/dx noisy')
axis('square'); axis('off')
colormap(gray(256));

%Uncorrupted Plots
[n1, xout] = hist(out_uncorrupted(:), 200);

figure
hold on;
histfit(out_uncorrupted(:));
hold on;

%Laplacian
% pramater estimation
b = norm(xout - 0)/length(xout);
display(b);
x = xout(:);
y1 = zeros(size(n1));

for i=1:length(x);
    y1(i) = (1/2*b)*exp(-(abs(x(i)-0)/b));
end
y1 = y1.*sum(n1); %scale it

plot(x,y1,'m');

%Corrupted Plots
[n2, xout] = hist(out_corrupted(:), 200);

figure
hold on;
histfit(out_corrupted(:));
hold on;

%Laplacian
% pramater estimation
b = norm(xout - 0)/length(xout);
display(b);
x = xout(:);
y2 = zeros(size(n2));

for i=1:length(x);
    y2(i) = (1/2*b)*exp(-(abs(x(i)-0)/b));
end
y2 = y2.*sum(n2); %scale it

plot(x,y2,'m');


%C
figure
norm = normpdf(x, 0, 15);

numerator = zeros(size(x));
for a=1:length(x);
    numerator(a) = n1(a)*norm(a)*y2(a);
end
denominator = zeros(size(x));
for b=1:length(x);
    denominator(b) = norm(b)*y2(b);
end

y_n = numerator./denominator;

plot(x, y_n, 'g');



