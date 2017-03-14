%clear

In  = 'zoomwalt.png';
Out = 'matcan.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = clip(histeq(I));

J = I;

depth = 10;
maxn = 100;

fixd = (J*0) == 1;
 
for i = 1:depth:maxn
    mask = I > max((i-depth+1)/2/maxn, 0) & I < min((i+depth-1)/2/maxn, 1);
    fill = imfill(mask, 'holes');
    fixd = fixd | imerode(~mask & fill, strel('disk', round(depth/4)));
    J(fill & ~fixd) = median(median(I(mask)));
end

for i = maxn:-depth:1
    mask = I > max((i-depth+1)/2/maxn, 0) & I < min((i+depth-1)/2/maxn, 1);
    fill = imfill(mask, 'holes');
    fixd = fixd | imerode(~mask & fill, strel('disk', round(depth/4)));
    J(fill & ~fixd) = median(median(I(mask)));
end

J = imsharpen(J);
J = clip(J);

imshow(J);
imwrite(J,['../IMG/' Out],'PNG')

function A = norm(I)
A = I - min(I(:));
A = A / max(A(:));
end

function A = clip(I)
A = I;
A(I < 0) = 0;
A(I > 1) = 1;
end  