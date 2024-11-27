function jitter_plot_hill_fit_parameters
%Function will plot parameters from Hill fit analysis 

%Path
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
repeats_analysis_file = '../output/Hill_curve_repeats.xlsx';
output_image_file = '../output/pCa_curves_all_fil';
output_image_types = {'png', 'svg', 'eps'};

group_names = {'1.9um' '2.3um'}
sub_names = {'pre' 'post'}
y_axis_label = {'pCa50'}
y_ticks =[5.3 5.9]

% Read excel sheet 
d = readtable(repeats_analysis_file)
dn = d.Properties.VariableNames'

% Find the number of condition
unique_conditions = unique(d.curve)
unique_hs_length = unique(d.hs_length)

% Loop through the hs_length
for hs_i = 1: numel(unique_hs_length)

     % Find all the indices for the condition
     vi_cond = find(d.hs_length == unique_hs_length(hs_i))

  str = d(vi_cond, :)
  data(hs_i).points{1} = str.pCa_50(1:5)
  data(hs_i).points{2} = str.pCa_50(6:10)

end 


figure(1)
clf
h = jitter_plot('data',data,...
    'group_names',group_names, ... 
    'sub_names',sub_names, ... 
    'y_axis_label',y_axis_label, ...
    'y_label_offset',-0.10, ...
    'y_ticks', y_ticks, ...
    'group_spacing',2, ...
    'y_main_label_offset',0.3);

