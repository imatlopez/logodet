%clear

In  = 'walt.png';
Out = 'waltmat.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = histeq(I);

J = medfilt2(I, [5 5], 'symmetric');
imwrite(clip(J),['../IMG/' Out],'PNG')

function A = norm(I)
A = I - min(I(:));
A = A / max(A(:));
end

function A = clip(I)
A = I;
A(I < 0) = 0;
A(I > 1) = 1;
end