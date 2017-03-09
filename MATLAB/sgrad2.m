%clear

In  = 'zoomwalt.png';
Out = 'matcan.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = histeq(I);

J = medfilt2(I, [15 15], 'symmetric');
K = imsharpen(J, 'Radius', 1, 'Amount', 1.5, 'Threshold', 0);

figure(1)
imshowpair(clip(J), clip(K), 'diff')
figure(2)
imshowpair(I, clip(K), 'montage')

imwrite(K,['../IMG/' Out],'PNG')

function A = norm(I)
A = I - min(I(:));
A = A / max(A(:));
end

function A = clip(I)
A = I;
A(I < 0) = 0;
A(I > 1) = 1;
end