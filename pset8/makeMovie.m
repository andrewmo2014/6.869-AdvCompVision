imageFiles = dir('bookshelf/*.bmp');
nFiles = length(imageFiles);

for i=1:nFiles
    images{i} = im2double(imread(imageFiles(i).name));
end

alpha = 10;
tau = 2;
imagesMag = SimpleMotionMagnification(images, alpha, tau);

video = VideoWriter( 'bookshelfMagMovie.avi' );
video.FrameRate = ( 30 );
open( video );
for i=1:nFiles
    writeVideo( video, [max(0, min(imagesMag{i},1)), images{i}] );
end
close( video );