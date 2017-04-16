%In  = 'zoomwalt.png';
%Out = 'matcan.png';

I = rgb2gray(imread(['../IMG/' In]));
J = medfilt2(I);

%imshow(J)
imwrite(J,['../IMG/' Out],'PNG')