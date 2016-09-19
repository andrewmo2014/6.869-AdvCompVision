%Problem 1b

I1=imreadbw('ims/seoul1.jpg') ; 
I2=imreadbw('ims/seoul2.jpg') ;

%display(size(I1));

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
display(size(matches));

fprintf('Matched in %.3f s\n', toc) ;

figure(3) ; clf ;

plotmatches(I1,I2,frames1(1:2,:),frames2(1:2,:),matches) ;
%plotmatches(I1,I2,frames1(1:2,:),frames2(1:2,:),matches(:,200:209)) ;

P1 = frames1(1:2,:);
P2 = frames2(1:2,:);

x = [ P1(1,matches(1,:))'  P1(2,matches(1,:))'] ;
y = [ P2(1,matches(2,:))'  P2(2,matches(2,:))'] ;


drawnow ;
