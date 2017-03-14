%clear

In  = 'zoomwalt.png';
Out = 'matcan.png'; 

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = histeq(I);

J = I;
 
frag_dim = [5 5];
frag_ext = (frag_dim-1)/2;

for i = 1:size(I,1)
    ik = max(1, i-floor(frag_ext(1))):min(i+ceil(frag_ext(1)), size(I,1));
    for j = 1:size(I,2)
        jk = max(1, j-floor(frag_ext(2))):min(j+ceil(frag_ext(2)), size(I,2));
        nk = length(ik) * length(jk) - 1;
        gk = J(ik, jk) - J(i, j);
        dik = (repmat(ik', [1 length(jk)]) - i).*abs(gk)./sum(abs(gk(:)));
        djk = (repmat(jk,  [length(ik) 1]) - j).*abs(gk)./sum(abs(gk(:)));
        dv = [sum(djk(:)) sum(dik(:))]/(length(ik)-1);
        dv(isnan(dv)) = 0;
        di = i+[0 0 floor(dv(1)) floor(dv(1)) ceil(dv(1)) ceil(dv(1))];
        if any(di < 1 | di > size(I,1)); di = i+[0 0 floor(-dv(1)) floor(-dv(1)) ceil(-dv(1)) ceil(-dv(1))]; end
        dj = j+[0 0 floor(dv(2)) ceil(dv(2)) floor(dv(2)) ceil(dv(2))];
        if any(dj < 1 | dj > size(I,2)); dj = j+[0 0 floor(-dv(2)) ceil(-dv(2)) floor(-dv(2)) ceil(-dv(2))]; end
        J(i, j) = mean(mean(J(di, dj)));
    end
end

imshow(clip(J));
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