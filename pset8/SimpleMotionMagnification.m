function [output] = SimpleMotionMagnification(I,alpha,tau)

output = I; %Magnified frames
L = length(I);

% set parameters
nlevels = 5;
winsize = 3;
medfiltsize = 11;
nIterations = 5;

%Estimate motion (u,v) between frame I1 and each frame It in I
for t=1:L
    % use coarse to fine lucas kanade to obtain optical flow field
    [u_t,v_t,warpI2] = coarse2fine_lk(I{t},I{1},nlevels,winsize,medfiltsize,nIterations);
    
    u_t1 = u_t;
    v_t1 = v_t;
    
    [m, n] = size(u_t);
    for x=1:m
        for y=1:n
            if norm([u_t(x,y) v_t(x,y)]) <= tau 
                u_t1(x,y) = alpha*u_t(x,y);
                v_t1(x,y) = alpha*v_t(x,y);
            end
        end
    end
    
    output{t} = warpFL(I{1}, u_t1, v_t1);
end
    
end