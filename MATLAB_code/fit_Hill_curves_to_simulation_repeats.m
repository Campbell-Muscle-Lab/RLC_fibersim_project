function fit_Hill_curves_to_simulation_repeats
% Takes a standard FiberSim pCa_analysis file and calculates fits for each
% repeat

%Path
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
pCa_analysis_file ='../Simulations/sim_data/sim_output/pCa_analysis';
output_file = '../output/Hill_curve_repeats_noiso.xlsx';

% Read excel sheet 
d = readtable(pCa_analysis_file)

dn = d.Properties.VariableNames'

% Find the number of conditions and pCa values to analyze
unique_conditions = unique(d.curve);
unique_pCa_values = unique(d.hs_pCa);

% Deduce number of repeats
no_of_repeats = size(d,1) / ...
    (numel(unique_conditions) * numel(unique_pCa_values))

% Create a variable to hold the output
out = [];

output_i = 1;

% Loop through the conditions
for cond_i = 1 : numel(unique_conditions)

    % Find all the indices for the condition
    vi_cond = find(d.curve == unique_conditions(cond_i));

    % Now pull off the values for the different repeats
    for repeat_i = 1 : no_of_repeats

        vi_repeat = vi_cond(repeat_i : no_of_repeats : numel(vi_cond))

        pCa = d.hs_pCa(vi_repeat);
        y = d.hs_force(vi_repeat);

        % Fit the curve
        [pCa_50, n_H, f_min, f_amp, r_sq] = ...
            fit_Hill_curve(pCa, y)
    
        % Store the data
        out.curve(output_i) = unique_conditions(cond_i);
        out.repeat(output_i) = repeat_i;
        out.hs_length(output_i) = d.hs_length(vi_repeat(1));
        out.pCa_50(output_i) = pCa_50;
        out.n_H(output_i) = n_H;
        out.f_min(output_i) = f_min;
        out.f_amp(output_i) = f_amp;
        out.f_max(output_i) = f_min + f_amp;
        out.r_sq(output_i) = r_sq;
    
        % Increment the counter
        output_i = output_i + 1;

    end
end

% out is a structure, with data in wrong row column format
out = columnize_structure(out);

% Convert to a table
out = struct2table(out)

% Clean any existing file
try
    delete(output_file);
end
writetable(out, output_file);