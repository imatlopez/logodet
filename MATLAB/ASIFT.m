%*-------------------demo_ASIFT MATLAB interface   -------------------------*/
% 
% *************************************************************************
% NOTE: The ASIFT SOFTWARE ./demo_ASIFT IS STANDALONE AND CAN BE EXECUTED
%       WITHOUT MATLAB. 
% *************************************************************************
% 
% Detect corresponding points in two images with the ASIFT method. 
% Copyright, Jean-Michel Morel, Guoshen Yu, 2008. 
% Please report bugs and/or send comments to Guoshen Yu yu@cmap.polytechnique.fr
%
% Reference: J.M. Morel and G.Yu, ASIFT: A New Framework for Fully Affine Invariant Image 
%           Comparison, SIAM Journal on Imaging Sciences, vol. 2, issue 2, pp. 438-469, 2009. 
% Reference: ASIFT online demo (You can try ASIFT with your own images online.) 
% http://www.ipol.im/pub/algo/my_affine_sift/
%
% 2010.08.17
% ---------------------------------------------------------------------------*/

function ASIFT(img1, img2, imgOutVert, imgOutHori, matchings, keys1, keys2, flag)

if nargin < 3 || isempty(imgOutVert); imgOutVert = 'imgOutVert.png'; end
if nargin < 4 || isempty(imgOutHori); imgOutHori = 'imgOutHori.png'; end
if nargin < 5 || isempty(matchings); matchings = 'matchings.txt'; end
if nargin < 6 || isempty(keys1); keys1 = 'keys1.txt'; end
if nargin < 7 || isempty(keys2); keys2 = 'keys2.txt'; end
if nargin < 8 || isempty(flag); flag = 1; end

imgOutVert = fullfile('..', imgOutVert);
imgOutHori = fullfile('..', imgOutHori);
matchings = fullfile('..', matchings);
keys1 = fullfile('..', keys1);
keys2 = fullfile('..', keys2);

% convert the image to png format
img1_png = fullfile('..', 'IMG', img1);
if ~contains(img1, '.png')
    imgIn1 = imread(img1_png);
    img1_png = 'tmpASIFTinput1.png';
    imwrite(imgIn1, img1_png, 'png');
end

img2_png = fullfile('..', 'IMG', img2);
if ~contains(img2, '.png')
    imgIn2 = imread(img2_png);
    img2_png = 'tmpASIFTinput2.png';
    imwrite(imgIn2, img2_png, 'png');
end

% ASIFT command
command_ASIFT = fullfile('..', 'ASIFT', 'demo_ASIFT'); 
command_ASIFT = [command_ASIFT ' ' img1_png ' ' img2_png ' ' ...
  imgOutVert ' ' imgOutHori ' ' matchings ' ' keys1 ' ' keys2];
if (flag == 0)
    command_ASIFT = [command_ASIFT ' 0'];
end

% Mac
if (ismac == 1)
    [~, w] = unix('sysctl -n hw.ncpu');
    num_CPUs = str2double(w);
    
    % set the maximum OpenMP threads to the number of processors 
    set_threads = sprintf('export OMP_NUM_THREADS=%d;', num_CPUs);
    command = [set_threads ' ' command_ASIFT];

% Unix    
elseif (isunix == 1)
    [~, w] = unix('grep processor /proc/cpuinfo | wc -l');
     num_CPUs = str2double(w);
     
    % set the maximum OpenMP threads to the number of processors 
    set_threads = sprintf('export OMP_NUM_THREADS=%d;', num_CPUs);
    command = [set_threads ' ' command_ASIFT];
    
% Windows    
elseif (ispc == 1)
    [~, w] = dos('set NUMBER_OF_PROCESSORS');
    num_CPUs = sscanf(w, '%*21c%d', [1, Inf]);
    
    % set the maximum OpenMP threads to the number of processors 
    setenv('OMP_NUM_THREADS', num2str(num_CPUs));
    command = command_ASIFT;
    
else
    error('Unrecognized operating system. The operating system should be Windows, Linux/Unix, or Mac OS.');
end

status = system(command);

if contains('tmp', img1_png); delete(img1_png); end
if contains('tmp', img2_png); delete(img2_png); end

assert(status == 0);
