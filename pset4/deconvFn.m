function im=deconvFn(out,fn)
% Pseudo-Inverse solution:
%
% out=convFn(im,fn)
% im=deconvFn(out,fn)
%


Nfilters=size(fn,3);
[sx,sy,Nfilters]=size(out);
mxsize=max(sx,sy);

for i=1:Nfilters
    D2(:,:,i)=conv2(out(:,:,i),flipud(fliplr(fn(:,:,i))),'same');
end
D=sum(D2,3);

gi=0;
for i=1:Nfilters
    gi=gi+conv2(fn(:,:,i),flipud(fliplr(fn(:,:,i))));
end

gi=conv2(gi,[1 0 0; 0 0 0; 0 0 0],'same');

G=fft2(gi,mxsize*2,mxsize*2);
I=find(G==0);
G(I)=1;
H=1./G;
H(I)=0;


I=fftshift(real(ifft2(H.*(fft2(D,mxsize*2,mxsize*2)))));

%im=I(mxsize:mxsize+sx-1,mxsize:mxsize+sy-1);

N=(size(gi,1)-5)/2
im=I(mxsize-N:mxsize+sx-1-N,mxsize-N:mxsize+sy-1-N);




