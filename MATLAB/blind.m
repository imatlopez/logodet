I = rgb2gray(imread('../IMG/zoomwalt.png'));
PSF = fspecial('gaussian',5,5);
J = histeq(deconvlucy(I,PSF,5));
imshow(J)
imsave