function synthIm = SynthTexture(sample, w, s)
%Implementation of Efros & Leung's algorithm for Texture Synthesis
%Only works for grey images for now

% Initilaization
epsilon = 0.1;                      % SSD min threshold
[height, width] = size(sample);
non_w_size = [(height - w + 1) (width - w + 1)];

half_w = (w-1)/2;
ht = s(1);
wt = s(2);
num_pixels = ht * wt;

% 3 by 3 patch, seed index
seeded_row_index_start = 4;
seeded_col_index_start = 32;

patch_size = 3;
% center patch
patch_rows = ceil(ht/2) : ceil(ht/2) +patch_size-1;
patch_cols = ceil(wt/2) : ceil(wt/2) +patch_size-1;

%end seed index
seeded_row_index_end = seeded_row_index_start +patch_size-1;
seeded_col_index_end = seeded_col_index_start +patch_size-1;

synthIm = zeros( ht, wt );
synthIm( patch_rows, patch_cols ) = sample( seeded_row_index_start:seeded_row_index_end, ...
                                            seeded_col_index_start:seeded_col_index_end );

%valid Mask                                        
num_pixels_filled = patch_size * patch_size;
filled = repmat(false, [ht wt]);
filled( patch_rows, patch_cols ) = repmat(true, [patch_size patch_size]);

%G
variance = w/6.4;
G = fspecial('gaussian', w, variance);

num_skipped = 0;

% While synth image not filled
while num_pixels_filled < num_pixels
    progress = false;
    
    %Get unfilled neighbors
    [pixel_rows, pixel_cols] = GetUnfilledNeighbors(filled, w);    
        
    for i = 1:length(pixel_rows)
        
        pixel = [pixel_rows(i), pixel_cols(i)];
        
        [template, validMask] = GetNeighborhoodWindow( pixel, w, s, synthIm, filled );
        [bestMatches, errors] = FindMatches( template, sample, G, w, validMask );
        bestMatch_index = RandomPick(bestMatches);
        
        %Error calculation
        if errors(bestMatch_index) < epsilon
            [match_row, match_col] = ind2sub(non_w_size, bestMatch_index);
            
            match_row = match_row + half_w;
            match_col = match_col + half_w;
            
            synthIm( pixel(1), pixel(2) ) = sample( match_row, match_col );
            filled( pixel(1), pixel(2) ) = true;
            num_pixels_filled = num_pixels_filled + 1;
            
            progress = true;
        else
            num_skipped = num_skipped + 1;
        end
    end
    
    if ~progress
        epsilon = epsilon * 1.1;
    end
    
end
end

% GetUnfilledNeighbors
function [pixel_rows, pixel_cols] = GetUnfilledNeighbors(filled, w)

border = bwmorph(filled, 'dilate') - filled;
[pixel_rows, pixel_cols] = find(border);

rand_index = randperm(length(pixel_rows));
pixel_rows = pixel_rows(rand_index);
pixel_cols = pixel_cols(rand_index);

filled_im_sum = colfilt(filled, [w w], 'sliding', @sum);
num_filled_neighbors = filled_im_sum( sub2ind(size(filled), pixel_rows, pixel_cols) );
[sorted, sort_index] = sort(num_filled_neighbors, 1, 'descend');

pixel_rows = pixel_rows(sort_index);
pixel_cols = pixel_cols(sort_index);

end

% GetNeighborhoodWindow
function [template, validMask] = GetNeighborhoodWindow( pixel, w, s, synthIm, filled )

half_w = (w-1)/2;
ht = s(1);
wt = s(2);

pixel_row = pixel(1);
pixel_col = pixel(2);

row_range = pixel_row-half_w : pixel_row+half_w;
col_range = pixel_col-half_w : pixel_col+half_w;

rows_outside = row_range < 1 | row_range > ht;
cols_outside = col_range < 1 | col_range > wt;

if sum(rows_outside) + sum(cols_outside) > 0
    rows_inside = row_range(~rows_outside);
    cols_inside = col_range(~cols_outside);
    
    template = zeros(w,w);
    template(~rows_outside, ~cols_outside) = synthIm(rows_inside, cols_inside);
    
    validMask = repmat(false, [w w]); 
    validMask(~rows_outside, ~cols_outside) = filled(rows_inside, cols_inside);
    
else
    template = synthIm(row_range, col_range);
    validMask = filled(row_range, col_range);
end
end

% FindMatches
function [bestMatches, errors] = FindMatches(template, sample, G, w, validMask)

delta = 0.3;

patches_sample = im2col(sample(:, :), [w w], 'sliding'); 
[pixel_per_patch, num_patches] = size(patches_sample);

sum_weight = sum(sum(G(validMask)));

Mask = (G .* validMask) / sum_weight;

patches = reshape(template(:,:,1), [pixel_per_patch 1]);
patches_template = repmat(patches, [1 num_patches]);

errors = Mask(:)' * (patches_template - patches_sample).^2;

bestMatches = errors <= min(errors) * (1+delta);
end

% RandomPick
function bestMatch_index = RandomPick(bestMatches)

BM_indexes = find(bestMatches);
bestMatch_index = BM_indexes(ceil(rand() * length(BM_indexes)));

end



    



