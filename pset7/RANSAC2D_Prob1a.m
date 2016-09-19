%x = linspace(0, 10, 30);
%y = (2*x + 1) + 4*rand(size(x,1), size(x,2));

%x = [x 2 5 10];
%y = [y 20 0 10];

function RANSAC2D_Prob1a(x1, x2)

Niter = 100;
epsilon = 2;
P = 2;
acceptableProbFailure = 1e-9;

n = size(x1,2);
maxInliers = 0;
m = 0;
b = 0;

for i = 1:Niter
        
    sampleIndices = randsample(n, P, false)';
    x_sample = x1(sampleIndices);
    y_sample = x2(sampleIndices);
    [m_tmp, b_tmp] = FitLine( x_sample, y_sample );

    numInliers = 0;
    for j = 1:n
        numInliers = numInliers + mapLine(m_tmp, b_tmp, x1(j), x2(j), epsilon);
    end
    
    if(maxInliers < numInliers)
      m = m_tmp;
      b = b_tmp;
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
    numInliers = numInliers + mapLine(m, b, x1(j), x2(j), epsilon);
end
display(numInliers);

figure,
hold on;
scatter(x1(1:30),x2(1:30));
hold on;
scatter(x1(31:33),x2(31:33), 'r');
hold on;
x_line = 0:10;
plot(x_line, m*x_line + b, 'g'); 
end

function bool = mapLine( m, b, p1, p2, epsilon)

    posT = [p1, m*p1 + b];    
    posA = [p1, p2];
    
    dist = norm(posT-posA); 
    if( dist < epsilon ); bool = 1;
    else                  bool = 0;
    end
end

function [m, b] = FitLine( x, y )
   
   m = (y(2)-y(1))/(x(2)-x(1));
   b = y(1) - m*x(1);
   
end
   



