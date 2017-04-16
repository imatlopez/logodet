I7 = imread('../IMG/sparser.png');
I2 = imread('../IMG/blind.png');
I5 = imread('../IMG/cgrad.png');
I8 = imread('../IMG/brush.png');
I6 = imread('../IMG/clean.png');
I3 = imread('../IMG/dgrad.png');
I1 = imread('../IMG/dilate.png');
I4 = imread('../IMG/medin.png');
I0 = imread('../IMG/sgrad.png');

x = 465; % vertical
y = 106; % horizontal
z = 150; % size
s = z*4+20*3;

v = 0:z-1;

I = nan(z*3+40, z*3+40, 3);

for i = 1:3
    x2 = 1+(z+20)*(i-1);
    for j = 1:3
        n = j+(i-1)*3-1;
        y2 = 1+(z+20)*(j-1);
        eval(sprintf('I(y2+v, x2+v,:) = repmat(I%d(x+v, y+v), [1 1 3]);', n));
    end
end

I = I/255; I(isnan(I)) = 1;

figure(1); imshow(I)
imwrite(I, '../sidebyside.png','PNG')

J0 = imread('../IMG/canvert.png');
J1 = imread('../IMG/zoomwalt.png');
J2 = imread('../IMG/walt.png');

J = nan(1550, 1280, 3);

J(147:810, 410:780,:) = J0;
J(1:810, 801:end,:) = J1;
J(831:end,:,:) = J2;

J = J/255; J(isnan(J)) = 1;

figure(2); imshow(J)
imwrite(J, '../source.png','PNG')