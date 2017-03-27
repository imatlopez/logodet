% clear

% mex sparseEncode.cpp

In = 'walt.png';
Ref = 'logo.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = norm(histeq(I));

D = initdict();

R = imread(['../IMG/' Ref]);
if size(R,3) > 1; R = rgb2gray(R); end
R = norm(double(R));
R = norm(histeq(R));
Rz = size(R);
Ri = composeTo(R);
Ra = sparseEncode(D, Ri);
Ro = composeFrom(Ri, Rz);
Rb = decode(D, Ra);
Rc = composeFrom(Rb, Rz);

%Da = adapt(D, Ra, Ri, 5);

% remove('sparseEncode.mex*')

function D = adapt(D, A, I, n)
    if nargin < 4 || isempty(n); n = 1; end
    while n > 0
        for i = 1:size(D,2)
            M = A(i, :) ~= 0; N = find(M);
            J = zeros(64, sum(M));
            E = J;
            F = J; % Proportion to total effect
            G = J; % Magnitude of effect
            for j = 1:sum(M)
                l.v = A(:,i);
                F(:,j) = l.v(N(j))./sum(l.v);
                G(:,j) = l.v(N(j));
                l.u = l.v; l.u(N(j)) = 0;
                E(:,j) = sum(abs(I - D * l.u));
                J(:,j) = I - D * l.v; % D[64.d] * [d.1]
            end
            J = sum(E.*F.*G.*J, 2)/sum(E.*F.*G, 2);
            D(:,i) = D(:,i) + J;
        end
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