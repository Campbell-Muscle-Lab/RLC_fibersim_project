function two_way_jitter_plot_new  
% Function runs a two-linear mixed model on Hill fit parameters and plot
% the results. 

%Path
addpath(genpath('../../MATLAB_Utilities'))
addpath(genpath('../../MATLAB_SAS'))

%Variables 
data_file_string = '../output/Hill_curve_repeats_fixed.xlsx';
results_file_string = 'sas_results/sas_results';
y_axis_label = {'nH'}
sheet = "Sheet1"
output_image_file = '../output/pCa50_jitter_nH';
output_image_types = {'png', 'svg', 'eps'};
color_map = [0.8 0 1 ; 1 0.6 0 ; 0.8 0 1; 1 0.6 0; ...
             1 0.7 0.3 ; 0.8 0 1; 0 0.8 0.8; 0.8 0 1 ; 1 0.6 0 ; 0.8 0 1; 1 0.6 0; ...
             1 0.7 0.3 ; 0.8 0 1; 0 0.8 0.8]
 y_ticks = [2 8]




% Pull data
d = readtable(data_file_string)

% Define the variables to plot on the y axis 
test_variable = 'n_H'

% Define the variables on the X axis 
factor_1 = 'RLC_phosp'
factor_2 = 'hs_length'

% Get it into format for jitter plot 
[od, jd] = extract_two_way_data( ...
    'table', d, ...
    'parameter_string', test_variable, ...
    'factor_1', factor_1, ...
    'factor_2', factor_2)

stats = sas_two_way_anova_without_grouping( ...
    'excel_file_string', data_file_string, ...
    'test_variable', test_variable, ...
    'factor_1', factor_1, ...
    'factor_2', factor_2, ...
    'calling_path_string', cd, ...
    'results_file_string', results_file_string)

% Pull out the main effects, write to title_string
p_string = write_p_table_to_string(stats.p_table)
vi = regexp(p_string,'\n')
title_string = p_string(1:vi(3)-1);



% Make a figure
sp = initialise_publication_quality_figure( ...
    'no_of_panels_wide', 1, ...
    'no_of_panels_high', 1, ...
    'x_to_y_axes_ratio', 1.75, ...
    'top_margin', 2,...
    'bottom_margin', 0.4)

% Draw the jitter plot
subplot(sp(1))
jd_out = jitter_plot( ...
    'data', jd, ..., ...
    'group_names', unique(d.(factor_1)), ...
    'sub_names', unique(d.(factor_2)), ...
    'symbols', {'o'}, ...
    'marker_face_colors', color_map, ...
    'y_from_zero', 0, ...
    'y_label_offset',-0.15, ...
    'y_axis_label',y_axis_label, ...
    'y_ticks', y_ticks,...
    'y_main_label_offset', 0.5,...
    'title', title_string, ...
    'title_y_offset', 2)

% Now that you know the y ticks, calculate the stat lines
% Pull out the stat lines
stat_line_data = return_stat_lines( ...
    '2way_LMM_without_grouping', ...
    stats.p_table, ...
    factor_1, factor_2, jd(1).f1_strings, jd(1).f2_strings, ...
    jd_out.y_ticks)

% Draw them
stat_lines('line_data', stat_line_data)


% Output
for type_counter = 1 : numel(output_image_types)
    figure_export( ...
        'output_file_string', output_image_file, ...
        'output_type', output_image_types{type_counter});
end

