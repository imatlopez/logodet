%In = 'tom.png';

I = imread(['../IMG/' In]);
if size(I,3) > 1; I = rgb2gray(I); end
I = norm(double(I));
I = histeq(I);
I = clip(I);

J = norm(imgradient(I));
I = clip(I.*(1-J));

frag_dim = [150 200];
frag_num = ceil(size(I)./frag_dim);
frag_ext = (frag_dim .* frag_num - size(I)) ./ (frag_num - 1);

frag_rem = [0 0];
frag_srt = [0 0];

images = cell(frag_num(1) * frag_num(2));

for i = 1:frag_num(1)
    ik = frag_srt(1)  - floor(frag_rem(1)) + ( 1:frag_dim(1) );
    frag_srt(1) = ik(end) - floor(frag_ext(1));
    frag_rem(1) = mod(frag_ext(1), 1) + mod(frag_rem(1), 1);
    for j = 1:frag_num(2)
        jk = frag_srt(2) - floor(frag_rem(2)) + ( 1:frag_dim(2) );
        frag_srt(2) = jk(end) - floor(frag_ext(2));
        frag_rem(2) = mod(frag_ext(2), 1) + mod(frag_rem(2), 1);
        
        images{sub2ind(frag_num, i, j)} = sprintf('tmpIMG%02dR%02dC.png', i, j);
        imwrite(I(ik, jk), images{sub2ind(frag_num, i, j)}, 'png')
    end
    frag_rem(2) = 0;
    frag_srt(2) = 0;
end

results = cell(frag_num);

for i = 1:length(images)
    ASIFT(fullfile('..', 'MATLAB', images{i}), Ref)
    results{i} = size(matched());
    delete(images{i})
end

% cellfun(@(s) delete(s), images);

function A = norm(I)
A = I - min(I(:));
A = A / max(A(:));
end

function A = clip(I)
A = I;
A(I < 0) = 0;
A(I > 1) = 1;
end

function A = matched()
filename = '../matchings.txt';
formatSpec = '%7s%9s%9s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3,4]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
A = cell2mat(raw);
end