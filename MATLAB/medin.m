I = rgb2gray(imread('../IMG/zoomwalt.png'));
J = medfilt2(I);
imshow(J)
imsave