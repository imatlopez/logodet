In  = 'canvert.png';
Out = 'matcan.png';

I = double(rgb2gray(imread(['../IMG/' In])))/255;
G = imgradient(I);
J = I;
for i = 1:size(I,1)
    for j = 1:size(I,2)
        k1 = max(1,i-1):min(size(I,1), i+1);
        k2 = max(1,j-1):min(size(I,2), j+1);
        g = G(k1,k2);
        v = I(k1,k2);
        F = v./(1+g);
        J(i,j) = median(F(:));
    end
end
J = uint8(round(J*255));

imshow(J)
imwrite(J,['../IMG/' Out],'PNG')
