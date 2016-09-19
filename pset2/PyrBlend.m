% 6.869 Advances in Computer Vision
% Andrew Moran
% PSET 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [reconImg] = PyrBlend( im1, im2, mask )

%Placeholder for final reconstruction, replicated per channel
[Rpyr, Rpind] = buildLpyr(im2double(mask*0.0));
RpyrFinal = repmat(Rpyr, [1,1,3]);

%for each channel
for channel = 1:3
    %Laplace pyramid from images
    [L1pyr, L1pind] = buildLpyr(im2double(im1(:,:,channel)));   %Image 1
    [L2pyr, L2pind] = buildLpyr(im2double(im2(:,:,channel)));   %Image 2
    %Gaussain pyramid from mask
    [Gpyr, Gpind] = buildGpyr(im2double(mask));
    
    for level = size(Gpind,1):-1:1
        %Need to scale Gaussain appropriately per level
        masked = pyrBand(Gpyr, Gpind, level)/2^(level-1);
        %Blend L(j) = G(j)*L1(j) + (1-G(j))*L2(j) for level j
        blended = (masked)     .* pyrBand(L1pyr, L1pind, level) + ...
                  (1.0-masked) .* pyrBand(L2pyr, L2pind, level);
        %Add to result pyramid
        Rpyr = setPyrBand(Rpyr, Rpind, blended, level);
    end
    %Add to corresponding pyramid channel
    RpyrFinal(:,:,channel) = Rpyr;
end

%Final reconstruction of all channels
reconImg = cat(3, reconLpyr(RpyrFinal(:,:,1), Rpind), ...
                  reconLpyr(RpyrFinal(:,:,2), Rpind), ...
                  reconLpyr(RpyrFinal(:,:,3), Rpind) );
figure
imshow(reconImg)
axis('off'); axis('equal')
title('LBlended image')
end
