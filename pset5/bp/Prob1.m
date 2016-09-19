Il = imread('data/scene1.row3.col2.ppm');
Ir = imread('data/scene1.row3.col3.ppm');

Il = imresize(Il,0.5,'bilinear');
Ir = imresize(Ir,0.5,'bilinear');

Il = rgb2gray(Il);
Ir = rgb2gray(Ir);
Il = double(Il);
Ir = double(Ir);

dx = StereoBP(Il,Ir);