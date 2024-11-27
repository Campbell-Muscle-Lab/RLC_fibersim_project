function fit_Hill_curves_to_simulation_repeats
% Takes a standard FiberSim pCa_analysis file and calculates fits for each
% repeat

%Path
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
xlsx_file = '../test_data/pCa_analysis.xlsx';

% Read excel sheet 
d = readtable(xlsx_file)

dn = d.Properties.VariableNames'

return

% Define needed files 
curve_id = unique(d.curve)
pCa = unique(d.hs_pCa)
hsl_values = unique(d.hs_length)
m=1
for i = 1:numel(curve_id)
    vi = find(d.curve == i)
    summary.pCa(m) = d.hs_pCa(vi)
    summary.force(m) = d.hs_force(vi)
    summary.length(m) = d.hs_length(vi)
    [pCa50(i),n(i),~,~,~, r(i).x_fit, r(i).y_fit] = ...
        fit_Hill_curve(d.hs_pCa(vi), d.hs_force(vi))

end 

writetable(struct2table(r),'n_summary.xlsx')

