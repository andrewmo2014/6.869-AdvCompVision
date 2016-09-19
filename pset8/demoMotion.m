
im1 = im2double(imread('car1.jpg'));
im2 = im2double(imread('car2.jpg'));

% set parameters
nlevels = 5;
winsize = 3;
medfiltsize = 11;
nIterations = 5;

% use coarse to fine lucas kanade to obtain optical flow field
[u,v,warpI2] = coarse2fine_lk(im1,im2,nlevels,winsize,medfiltsize,nIterations);
                          
clear flow
flow(:,:,1) = u;
flow(:,:,2) = v;
                
offset = 10;
colorarray = 'wkkk';
figure;imshow(im1);
for i = 1:-1:0
    for j = 1:-1:0
        text(offset+j*2,offset+i*2,'Frame 1','FontSize',14,'FontName','Courier New','FontWeight','bold','Color',colorarray(i*2+j+1));
    end
end
drawnow;
Frame(1) = getframe;
close;

figure;imshow(warpI2);
for i = 1:-1:0
    for j = 1:-1:0
        text(offset+j*2,offset+i*2,'Warped Frame 2','FontSize',14,'FontName','Courier New','FontWeight','bold','Color',colorarray(i*2+j+1));
    end
end
drawnow;
Frame(2) = getframe;
close;

figure;
imshow(flowToColor(flow));
for i = 1:-1:0
    for j = 1:-1:0
        text(offset+j*2,offset+i*2,'Flow field','FontSize',14,'FontName','Courier New','FontWeight','bold','Color',colorarray(i*2+j+1));
    end
end
drawnow;

fprintf('Press Ctrl+C to break the loop');
h = figure;imshow(Frame(1).cdata);
AxesH = get(h,'CurrentAxes');
for i = 1:100
    if mod(i,2) == 0
        %clf;
        cla(AxesH,'reset');
        imshow(Frame(1).cdata,'Parent',AxesH);
        drawnow;
    else
        %clf;
        cla(AxesH,'reset');
        imshow(Frame(2).cdata,'Parent',AxesH);
        drawnow;
    end
    pause(0.7);
end

