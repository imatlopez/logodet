%clear

%In  = 'zoomwalt.png';
%Out = 'matcan.png'; 

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = histeq(I);

J = I;
 
frag_dim = [5 5];
frag_ext = (frag_dim-1)/2;
order = 1/3;

for i = 1:size(I,1)
    ik = max(1, i-floor(frag_ext(1))):min(i+ceil(frag_ext(1)), size(I,1));
    for j = 1:size(I,2)
        jk = max(1, j-floor(frag_ext(2))):min(j+ceil(frag_ext(2)), size(I,2));
        nk = length(ik) * length(jk) - 1;
        gk = J(ik, jk) - J(i, j);
        dk = sum(sign(gk(:)).*abs(gk(:)).^order); % sum
        dk = sign(dk)*abs(dk/nk).^(1/order); % mean
        
        J(i, j) = J(i, j) + dk;
    end
end

%imshow(clip(J));
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