function pset5_2main

sample = im2double(imread('data/rings.jpg'));
out_im1 = SynthTexture(sample, 5, [100 100]);
out_im2 = SynthTexture(sample, 7, [100 100]);
out_im3 = SynthTexture(sample, 13, [100 100]);

out_im4 = SynthTexture(sample, 5, [100 100]);
out_im5 = SynthTexture(sample, 5, [100 100]);
out_im6 = SynthTexture(sample, 5, [100 100]);

out_im7 = SynthTexture(sample, 7, [100 100]);
out_im8 = SynthTexture(sample, 7, [100 100]);
out_im9 = SynthTexture(sample, 7, [100 100]);

out_im10 = SynthTexture(sample, 13, [100 100]);
out_im11 = SynthTexture(sample, 13, [100 100]);
out_im12 = SynthTexture(sample, 13, [100 100]);

figure;
subplot(131);
imshow(out_im1);
title('w = 5');
subplot(132);
imshow(out_im2);
title('w = 7');
subplot(133);
imshow(out_im3);
title('w = 13');

figure;
subplot(131);
imshow(out_im4);
title('w = 5, trial 1');
subplot(132);
imshow(out_im5);
title('w = 5, trial 2');
subplot(133);
imshow(out_im6);
title('w = 5, trial 3');

figure;
subplot(131);
imshow(out_im7);
title('w = 7, trial 1');
subplot(132);
imshow(out_im8);
title('w = 7, trial 2');
subplot(133);
imshow(out_im9);
title('w = 7, trial 3');

figure;
subplot(131);
imshow(out_im10);
title('w = 13, trial 1');
subplot(132);
imshow(out_im11);
title('w = 13, trial 2');
subplot(133);
imshow(out_im12);
title('w = 13, trial 3');
