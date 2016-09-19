x1 = [1 1; -1 1; -1 -1; 1 -1;];
x2 = [-1 1; -1 -1; 1 -1; 1 1;];

x1_T = x1';
x2_T = x2';

H = FitHomography(x1, x2);
display(H);