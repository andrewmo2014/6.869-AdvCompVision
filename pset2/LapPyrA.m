% 6.869 Advances in Computer Vision
% Andrew Moran
% PSET 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LapPyrA(img)
r = im2double(img(:,:,1));
g = im2double(img(:,:,2));
b = im2double(img(:,:,3));

[Rpyr, Rpind] = buildLpyr(r);
[Gpyr, Gpind] = buildLpyr(g);
[Bpyr, Bpind] = buildLpyr(b);

reconImg = cat(3, reconLpyr(Rpyr, Rpind), ... 
                  reconLpyr(Gpyr, Gpind), ...
                  reconLpyr(Bpyr, Bpind) );  

figure
imshow(img)
axis('off'); axis('equal')
title('Input image')
figure
showLpyr(Rpyr, Rpind);
axis('off'); axis('equal')
title('LPYR - Red Channel')
figure
showLpyr(Gpyr, Gpind);
axis('off'); axis('equal')
title('LPYR - Green Channel')
figure
showLpyr(Bpyr, Bpind);
axis('off'); axis('equal')
title('LPYR - Blue Channel')
figure
imshow( reconImg );
axis('off'); axis('equal')
title('LPYR - Reconstructed')
end
