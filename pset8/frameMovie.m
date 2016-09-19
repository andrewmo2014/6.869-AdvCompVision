vid = VideoReader('bookshelfMagMovie.avi');

mkdir('bookshelfMag');
frameno = vid.NumberOfFrames;

for i = 1:frameno
    frame = read(vid, i);
    imwrite(frame, strcat('bookshelfMag/image',num2str(i),'.jpg'));
end