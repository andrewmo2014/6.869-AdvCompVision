% Problem 1f

function [im] = PhotoMerge( im1, im2 )

    %I1=imreadbw('ims/seoul1.jpg') ; 
    %I2=imreadbw('ims/seoul2.jpg') ;

    %I1_color=im2single(imread('ims/seoul1.jpg')) ; 
    %I2_color=im2single(imread('ims/seoul2.jpg')) ;
    
    I1 = im2single(rgb2gray(im1));
    I2 = im2single(rgb2gray(im2));

    I1_color=im2single(im1) ; 
    I2_color=im2single(im2) ;
    
    I1=I1-min(I1(:)) ;
    I1=I1/max(I1(:)) ;
    I2=I2-min(I2(:)) ;
    I2=I2/max(I2(:)) ;

    fprintf('Computing frames and descriptors.\n') ;
    [frames1,descr1,gss1,dogss1] = sift( I1, 'Verbosity', 0 ) ;
    [frames2,descr2,gss2,dogss2] = sift( I2, 'Verbosity', 0 ) ;

    fprintf('Computing matches.\n') ;
    % By passing to integers we greatly enhance the matching speed (we use
    % the scale factor 512 as Lowe's, but it could be greater without
    % overflow)
    descr1=uint8(512*descr1) ;
    descr2=uint8(512*descr2) ;
    tic ; 
    matches=siftmatch( descr1, descr2 ) ;
    fprintf('Matched in %.3f s\n', toc) ;

    P1 = frames1(1:2,:);
    P2 = frames2(1:2,:);

    im1_points = [ P1(1,matches(1,:))'  P1(2,matches(1,:))'] ;
    im2_points = [ P2(1,matches(2,:))'  P2(2,matches(2,:))'] ;

    %We want to map im2 to im1
    % Problem 1d
    H = TransformRANSAC(im2_points, im1_points);

    %I1 is the reference image
    % Problem 1e
    im = MakePanorama(I1_color, I2_color, H);
    %imshow(im);
end