clc; %clear

Ref = 'canvert.png';
Out = 'tempmat.png';

diary off; diary('../results_self.txt'); diary on
fprintf('====== Self ======\n')
In = 'canvert.png'; %#ok<*NASGU>

fprintf('\n=== NONE ===\n')
ASIFT(In, Ref);
fprintf('\n=== SPARSER.m ===\n')
sparser; ASIFT(Out, Ref);
fprintf('\n=== BLIND.m ===\n')
blind; ASIFT(Out, Ref);
fprintf('\n=== CGRAD.m ===\n')
cgrad; ASIFT(Out, Ref);
fprintf('\n=== BRUSH.m ===\n')
brush; ASIFT(Out, Ref);
fprintf('\n=== CLEAN.m ===\n')
clean; ASIFT(Out, Ref);
fprintf('\n=== DGRAD.m ===\n')
dgrad; ASIFT(Out, Ref);
fprintf('\n=== DILATE.m ===\n')
dilate; ASIFT(Out, Ref);
fprintf('\n=== MEDIN.m ===\n')
medin; ASIFT(Out, Ref);
fprintf('\n=== SGRAD.m ===\n')
sgrad; ASIFT(Out, Ref);

clc
diary off; diary('../results_zoom.txt'); diary on
fprintf('====== Ref Zoom ======\n')
In = 'zoomwalt.png';

fprintf('\n=== NONE ===\n')
ASIFT(In, Ref);
fprintf('\n=== BLIND.m ===\n')
blind; ASIFT(Out, Ref);
fprintf('\n=== CGRAD.m ===\n')
cgrad; ASIFT(Out, Ref);
fprintf('\n=== BRUSH.m ===\n')
brush; ASIFT(Out, Ref);
fprintf('\n=== CLEAN.m ===\n')
clean; ASIFT(Out, Ref);
fprintf('\n=== DGRAD.m ===\n')
dgrad; ASIFT(Out, Ref);
fprintf('\n=== DILATE.m ===\n')
dilate; ASIFT(Out, Ref);
fprintf('\n=== MEDIN.m ===\n')
medin; ASIFT(Out, Ref);
fprintf('\n=== SGRAD.m ===\n')
sgrad; ASIFT(Out, Ref);
fprintf('\n=== SPARSER.m ===\n')
sparser; ASIFT(Out, Ref);

clc
diary off; diary('../results_ref.txt'); diary on
fprintf('====== Ref ======\n')
In = 'walt.png';

fprintf('\n=== NONE ===\n')
ASIFT(In, Ref);
fprintf('\n=== BLIND.m ===\n')
blind; ASIFT(Out, Ref);
fprintf('\n=== CGRAD.m ===\n')
cgrad; ASIFT(Out, Ref);
fprintf('\n=== BRUSH.m ===\n')
brush; ASIFT(Out, Ref);
fprintf('\n=== CLEAN.m ===\n')
clean; ASIFT(Out, Ref);
fprintf('\n=== DGRAD.m ===\n')
dgrad; ASIFT(Out, Ref);
fprintf('\n=== DILATE.m ===\n')
dilate; ASIFT(Out, Ref);
fprintf('\n=== MEDIN.m ===\n')
medin; ASIFT(Out, Ref);
fprintf('\n=== SGRAD.m ===\n')
sgrad; ASIFT(Out, Ref);
fprintf('\n=== SPARSER.m ===\n')
sparser; ASIFT(Out, Ref);

diary off