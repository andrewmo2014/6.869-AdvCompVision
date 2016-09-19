function [im] = PanoramaN( imageList )

    L = size(imageList,2);
    refStart = ceil(L/2);
    imRef = cell2mat(imageList(refStart));
        
    for i=1:L-1
        if mod(i,2)==1
            ref = refStart + ceil(i/2);
        else
            ref = refStart - ceil(i/2);
        end
        imRef = PhotoMerge(imRef, cell2mat(imageList(ref)));

    end
    
    im = imRef;

end