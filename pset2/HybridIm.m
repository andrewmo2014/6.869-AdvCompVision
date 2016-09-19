% 6.869 Advances in Computer Vision
% Andrew Moran
% PSET 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out] = HybridIm(im1, im2)
   %Params for gaussian filtering;
   high = 24;   %Close Image
   low = 16;    %Away Image
   %Take FFT of images, work in Fourier domain
   imA = fftshift(fft2(double(im1)));
   imB = fftshift(fft2(double(im2)));
   [m n z] = size(im1);
   %Low pass filter
   blurred_low = fspecial('gaussian', [m,n], low);
   blurred_high = fspecial('gaussian', [m,n], high);
   %Nomralize
   blurred_low = blurred_low./max(max(blurred_low));
   blurred_high = blurred_high./max(max(blurred_high));

   for channel = 1:3
      %H = I_1(G_1) + I_2(1 - G_2)
      out(:,:,channel) = imB(:,:,channel).*(blurred_low) + imA(:,:,channel).*(1-blurred_high);
   end
   out = uint8(real(ifft2(ifftshift(out))));
   
   figure
   imshow(out)
   axis('off'); axis('equal')
   title('Close Hybrid image')
end
