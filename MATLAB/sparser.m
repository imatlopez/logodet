% clear

% mex sparseEncode.cpp
% mex sparseAdapt.cpp

In = 'walt.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = norm(histeq(I));
[I, Ip] = pad(I);
Iz = size(I);
% Ii = composeTo(I);

% D = initdict(Ii);
% D = adapt(D, Ii, 5);

% Ia = sparseEncode(D, Ii);
Ib = decode(D, Ia);
Ic = composeFrom(Ib, Iz);
Id = unpad(Ic, Ip);

imshowpair(I,norm(Ic),'montage')

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

function [A, P] = pad(I)
    x = 16;
    P(1) = x*ceil(size(I,1)/x) - size(I,1);
    P(2) = x*ceil(size(I,2)/x) - size(I,2);
    A = [repmat(I(1,:), [floor(P(1)/2) 1]); I; repmat(I(end,:), [ceil(P(1)/2) 1])];
    A = [repmat(A(:,1), [1 floor(P(2)/2)]), A, repmat(A(:,end), [1 ceil(P(2)/2)])];
end

function I = unpad(A, P)
    fi = [floor(P(1)/2) ceil(P(1)/2)];
    fj = [floor(P(2)/2) ceil(P(2)/2)];
    I = A((fi(1)+1):(end-fi(2)), (fj(1)+1):(end-fj(2)));
end

function I = decode(D, A)
    I = D * A; % D[64.d] * A[d.i] 
end

function A = composeTo(I)
    S = size(I);
    N = S/4-3;
    A = zeros(256, N(1)*N(2));
    v = 0:15;
    k = 0;
    for i = 1:4:S(2)-15
        for j = 1:4:S(1)-15
            k = k + 1;
            z = I(j+v, i+v);
            A(:, k) = z(:);
        end
    end
end

function I = composeFrom(A, S)
    I = zeros(S);
    B = zeros(S);
    S = S(1) - 15;
    v = 0:15;
    k = -3; j = 1;
    for i = 1:size(A, 2)
        if k == S
            k = 1;
            j = j + 4;
        else
            k = k + 4;
        end
        z = reshape(A(:, i), 16, 16);
        I(k+v, j+v) = I(k+v, j+v) + z;
        B(k+v, j+v) = B(k+v, j+v) + 1;
    end
    I = I./B;
end

function A = initdict(I)
    if nargin < 1 || isempty(I)
        A = zeros(256, 256);
        [x, y] = meshgrid(1:16);
        fun = @(t,n) (1+cos(pi*(2*n+1)*(t-1)/32))/2;
        for i = 1:16
            for j = 1:16
                z = fun(x,i).*fun(y,j);
                A(:, 16*(i-1)+j) = z(:);
            end
        end
    else
        A = I(:, randi([1 size(I,2)], [1 256]));
    end
    % A = repmat(A, [1, 4]); % loosen dictionary
end

function A = norm(I)
A = I - min(I(:));
A = A / max(A(:));
end