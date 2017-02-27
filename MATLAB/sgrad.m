%clear
normalize = @(x) (x - min(x(:)))/(max(x(:)) - min(x(:)));

In  = 'zoomwalt.png';
Out = 'zoommat.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = double(I)/255;

vic = 5; mid = round(vic/2);
J = I;%histeq(I);
J = normalize(imsharpen(J, 'Radius',vic,'Amount',5));
J = medfilt2(J,[vic vic]);
[~,Ga] = imgradient(J);
[di, dj] = meshgrid((1:vic)-mid);

for i = 1:size(I, 1)
    for j = 1:size(I,2)
        dI  = di*0; dI(mid, mid) = J(i,j);
        dIa = di*0;
        for k = 1:vic^2
            if i+di(k) > 0 && j+dj(k) > 0 && i+di(k) <= size(I, 1) && j+dj(k) <= size(I, 2)
                dI(mid+di(k), mid+dj(k)) = J(i+di(k), j+dj(k));
                dIa(mid+di(k), mid+dj(k)) = 1/(1e-6+abs(J(i,j)-J(i+di(k), j+dj(k))))^2 * sqrt(1/sqrt(di(k)^2+dj(k)^2));
            end
        end
        dIa(mid, mid) = 0;
        dIa = (vic^2-1)/vic^2/sum(dIa(:))*dIa; dIa(mid, mid) = 1/vic^2;
        J(i,j) = sum(sum(dI.*dIa));
    end
end
J = histeq(J);
imshow(J)
imwrite(J,['../IMG/' Out],'PNG')