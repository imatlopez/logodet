% clear

% mex sparseEncode.cpp
% mex sparseAdapt.cpp

In = 'walt.png';
Ref = 'canvert.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = norm(histeq(I));
Iz = size(I);
Ii = composeTo(I);

% R = imread(['../IMG/' Ref]);
% if size(R,3) > 1; R = rgb2gray(R); end
% R = norm(double(R));
% R = norm(histeq(R));
% Rz = size(R);
% Ri = composeTo(R);

D = initdict();
%D = adapt(D, Ri, 3);

% Ra = sparseEncode(D, Ri);
% Rb = decode(D, Ra);
% Rc = composeFrom(Rb, Rz);

figure(1)
imshowpair(R,Rc,'montage')

Ia = sparseEncode(D, Ii);
Ib = decode(D, Ia);
Ic = composeFrom(Ib, Iz);

figure(2)
imshowpair(I,Ic,'montage')

% remove('sparseEncode.mex*')

function D = adapt(D, I, n)
    if nargin < 3 || isempty(n); n = 1; end
    while n > 0
        fprintf('Encode #%d\n', n)
        A = sparseEncode(D, I);
        fprintf('Adapting #%d\n', n)
        D = sparseAdapt(D, I, A);
        n = n - 1;
    end
end

function I = decode(D, A)
    I = D * A; % D[64.d] * A[d.i] 
end

function A = composeTo(I)
    S = size(I)-7;
    A = zeros(64, S(1)*S(2));
    for i = 1:S(2)
        for j = 1:S(1)
            k = S(1)*(i-1)+j;
            z = I(j+(0:7), i+(0:7));
            A(:, k) = z(:);
        end
    end
end

function I = composeFrom(A, S)
    B = zeros(S); I = zeros(S);
    j = 0;
    for i = 1:size(A, 2)
        k = mod(i-1, S(1)-7)+1;
        if k == 1; j = j + 1; end
        z = reshape(A(:, i), 8, 8);
        I(k:k+7, j:j+7) = I(k:k+7, j:j+7) + z;
        B(k:k+7, j:j+7) = B(k:k+7, j:j+7) + 1;
    end
    I = I./B;
end

% function I = parseFrom(D, A, S)
%     B = zeros(S); I = zeros(S);
%     j = 0;
%     for i = 1:size(A, 2)
%         if ~mod(i-1, S(2)-7); j = j + 1; end
%         z = reshape(sum(D.*A(:, i), 2), 8, 8);
%         I(i:i+7, j:j+7) = I(i:i+7, j:j+7) + z;
%         B(i:i+7, j:j+7) = B(i:i+7, j:j+7) + 1;
%     end
%     I = I./B;
% end

function A = initdict()
    A = zeros(64, 64);
    [x, y] = meshgrid(1:8);
    fun = @(t,n) (1+cos(pi*(2*n+1)*(t-1)/16))/2;
    for i = 1:8
        for j = 1:8
            z = fun(x,i).*fun(y,j);
            A(:, 8*(i-1)+j) = z(:);
        end
    end
    A = repmat(A, [1, 4]); % loosen dictionary
end

function A = norm(I)
A = I - min(I(:));
A = A / max(A(:));
end