%In  = 'zoomwalt.png';
%Out = 'matcan.png';

I = rgb2gray(imread(['../IMG/' In]));
PSF = fspecial('gaussian',5,5);
J = histeq(deconvlucy(I,PSF,5));

%imshow(J)
imwrite(J,['../IMG/' Out],'PNG')