%clear

In  = 'zoomwalt.png';
Out = 'matcan.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = histeq(I);

J = norm(imgradient(I));
imwrite(clip(I.*(1-J)),['../IMG/' Out],'PNG')

function A = norm(I)
A = I - min(I(:));
A = A / max(A(:));
end

function A = clip(I)
A = I;
A(I < 0) = 0;
A(I > 1) = 1;
end  