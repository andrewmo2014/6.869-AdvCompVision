%Problem 1c

function [ H ] = FitHomography( x1, x2 )
% x1 are input points Mx2
% x2 are output points Mx2
% H is the homography matrix 3x3

if ~isequal(size(x1), size(x2))
    error('Points matrices different sizes');
end
if size(x1, 2) ~= 2
    error('Points matrices must have two columns');
end
n = size(x1, 1);
if n < 4
    error('Need at least 4 matching points');
end

%Contruct A matrix
A = zeros(n*2, 9);
for i = 0:n-1
    A = addConstraint(A,i*2,x1(i+1,:),x2(i+1,:));
end

% Solve equations using SVD
if n == 4
    [~, ~, V] = svd(A);
else
    [~, ~, V] = svd(A, 'econ');
end

%Normalize and convert 9x1 to 3x3;
H = (reshape(V(:,9)./V(9,9), 3, 3));
%display(H);

%MATLAB version
%T=maketform('projective',x1,x2);
%display(T.tdata.T);

end

function [A] = addConstraint(A, i, x1, x2)
   
    x_in = x1(:,1);    
    y_in = x1(:,2);
    x_out = x2(:,1);
    y_out = x2(:,2);

    row1 = [x_in, y_in, 1, 0, 0, 0, -x_in*x_out, -y_in*x_out, -x_out];
    row2 = [0, 0, 0, x_in, y_in, 1, -x_in*y_out, -y_in*y_out, -y_out];
        
    A(i+1,:) = row1;
    A(i+2,:) = row2;
end
