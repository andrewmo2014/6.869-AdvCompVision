function out=convFn(im,fn)
% convolution of the image 'im' with a bank of filters 'fn'
%
% out=convFn(im,fn)
% im=deconvFn(out,fn)
%

% Set to zero a few boundary pixels. Otherwise boundary artifacts kill the
% integration.

%im = zeroB((im),fix(size(fn,1)/2)+5);

Nfilters=size(fn,3);

out=zeros(size(im,1),size(im,2),Nfilters);
for i=1:Nfilters
    out(:,:,i)=conv2(im,fn(:,:,i),'same');
    out(:,:,i) = zeroB((out(:,:,i)),fix(size(fn,1)/2)+1);

end


