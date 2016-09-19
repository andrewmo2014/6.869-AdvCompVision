% function for lucas-kanade algorithm
function [u,v,warpI2]=lucaskanade(I1,I2,u,v,winsize,medfiltSize,nIterations)

% form gaussian filter
gfilter=fspecial('gaussian',winsize*2+1,winsize/2);

% INSERT YOUR CODE HERE
warpI2 = warpFL(I2,u,v);
    
for count=1:nIterations

    % compute derivatives  % INSERT YOUR CODE HERE
    [Ix, Iy] = gradient(I2);    
    It = warpI2 - I1;
        
    % Multiplication of Matrics (average color channels)
    Ixx = mean(Ix.*Ix,3);
    Ixy = mean(Ix.*Iy,3);
    Iyy = mean(Iy.*Iy,3);
    Ixt = mean(Ix.*It,3);
    Iyt = mean(Iy.*It,3);

    % solve the large linear system
    Ixx=imfilter(Ixx,gfilter,'same',0)+0.001;
    Ixy=imfilter(Ixy,gfilter,'same',0);
    Iyy=imfilter(Iyy,gfilter,'same',0)+0.001;
    Ixt=imfilter(Ixt,gfilter,'same',0);
    Iyt=imfilter(Iyt,gfilter,'same',0);
    
    % update the flow field and warp image
    det = Ixx.*Iyy - Ixy.*Ixy;
    u = (-Iyy.*Ixt + Ixy.*Iyt )./det;
    v = ( Ixt.*Ixy - Ixx.*Iyt )./det;
    
    % median filtering is needed
    if medfiltSize > 0
        u = medfilt2(u,[medfiltSize medfiltSize]);
        v = medfilt2(v,[medfiltSize,medfiltSize]);
    end

    % INSERT YOUR CODE HERE
    warpI2 = warpFL(I2,u,v);

end
