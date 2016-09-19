% function of coarse to fine scheme of lucas-kanade
function [u,v,warpI2]=coarse2fine_lk(im1,im2,nlevels,winsize,medfiltsize,nIterations)

if ~isfloat(im1)
    im1 = im2double(im1);
end
if ~isfloat(im2)
    im2 = im2double(im2);
end

% Construct Gaussain pyramids
G1(1).img = im1;        
G2(1).img = im2;

for l=1:nlevels
    if( l ~= 1 )
        G1(l).img = impyramid(G1(l-1).img, 'reduce');
        G2(l).img = impyramid(G2(l-1).img, 'reduce');
    end
end

% Iterate K levels
for k=nlevels:-1:1
    
    [mk,nk,ok] = size(G1(k).img);
    
    u_tmp = zeros( [mk nk] );
    v_tmp = zeros( [mk nk] );
    
    %Return upscaled warp, not currently calculated one
    [u_tmp,v_tmp,warpI2b] = lucaskanade(G1(k).img,G2(k).img,u_tmp,v_tmp,winsize,medfiltsize,nIterations);
    
    if( k ~= nlevels )  
        u_tmp = u_tmp + u_up;
        v_tmp = v_tmp + v_up;
    end
    if( k == 1 )
        u = u_tmp;
        v = v_tmp;
        % Uses previously calculated warp
        return;
    end
    
    [mk1, nk1, ok1] = size(G1(k-1).img);
    
    %Upsample flow
    u_up = 2*imresize(u_tmp, [mk1 nk1], 'bicubic');
    v_up = 2*imresize(v_tmp, [mk1 nk1], 'bicubic');
    
    %Warp G2(k-1) to G1(k-1)
    warpI2 = warpFL(G2(k-1).img, u_up, v_up); 
end

end


