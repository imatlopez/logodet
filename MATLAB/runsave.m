clc; %clear

In = 'canvert.png'; 
Ref = 'canvert.png';

fprintf('=== SPARSER.m ===\n')
Out = 'sparser.png'; sparser; %#ok<*NASGU>
fprintf('\n=== BLIND.m ===\n')
Out = 'blind.png'; blind; 
fprintf('\n=== CGRAD.m ===\n')
Out = 'cgrad.png'; cgrad; 
fprintf('\n=== BRUSH.m ===\n')
Out = 'brush.png'; brush; 
fprintf('\n=== CLEAN.m ===\n')
Out = 'clean.png'; clean; 
fprintf('\n=== DGRAD.m ===\n')
Out = 'dgrad.png'; dgrad; 
fprintf('\n=== DILATE.m ===\n')
Out = 'dilate.png'; dilate; 
fprintf('\n=== MEDIN.m ===\n')
Out = 'medin.png'; medin; 
fprintf('\n=== SGRAD.m ===\n')
Out = 'sgrad.png'; sgrad; 
