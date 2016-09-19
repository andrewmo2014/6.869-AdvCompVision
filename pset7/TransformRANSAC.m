% Problem 1d

function [ H ] = TransformRANSAC( x1, x2 )
%TRANSFORMRANSAC Summary of this function goes here
%   Detailed explanation goes here

Niter = 10000;      %Number of iterations
epsilon = 10;       %Distance threshold when determining if inlier 
P = 4;              %Number of samples to use when fitting H to best seen so far
acceptableProbFailure = 1e-9;   %Acceptable probability of failure

n = min(size(x1,1), size(x2,1));
maxInliers = 0;
H = zeros(3,3);

for i = 1:Niter
        
    sampleIndices = randsample(n, 4, false)';
    x1_sample = x1(sampleIndices, :);
    x2_sample = x2(sampleIndices, :);
    H_tmp = FitHomography( x1_sample, x2_sample );

    numInliers = 0;
    for j = 1:n
        numInliers = numInliers + mapH(H_tmp, x1(j,:), x2(j,:), epsilon);
    end
    
    if(maxInliers < numInliers)
      H = H_tmp;
      maxInliers = numInliers;
    end

    G = maxInliers/n;
    probFailure = (1-G^P)^i;
    if (probFailure<acceptableProbFailure)
      break;
    end
end

numInliers = 0;
for j = 1:n
    numInliers = numInliers + mapH(H, x1(j,:), x2(j,:), epsilon);
end
display(maxInliers);
display(numInliers);
display(H);

if (maxInliers == 0)
    error('Found no inliers, please run again');
end

end

function bool = mapH( H, p2, p1, epsilon)

    x_in = [p1(1); p1(2); 1];
    pos = H*x_in;
    posH = [pos(1) pos(2)];
    
    dist = norm(posH-p2); 
    %display(dist);
    
    if( dist < epsilon ); bool = 1;
    else                  bool = 0;
    end
end

