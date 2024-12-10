function two_way_jitter_plot 
% Function runs a two-linear mixed model on Hill fit parameters and plot
% the results. 

% Paths 
addpath(genpath('../../MATLAB_Utilities'))
addpath(genpath('../../MATLAB_SAS'))

data_file_string = '../output/Hill_curve_repeats_test.xlsx';

% Variables 
sheet= 'Sheet1'
output_image_file = '../output/jitter_stat';
output_image_types = {'png', 'svg', 'eps'};

% Read excel sheet 
d = readtable(data_file_string)

% Define the variables to plot on the y axis 
testing_variable = 'pCa_50'

% Define the variables to plot on the x axis 
factor_1_variable = 'hs_length'
factor_2_variable = 'RLC_phosp'

% Make comparison between the X axes variables 
grouping_variable = 'RLC_phosp'

% Determine figure deisgn  
  % Title 
  figure_title = 'C_zone'
  % Y labels 
  y_label_offset = -0.1
  % X labels 
  title_offset = 1.1 

% Make a folder for thet SAScode to work
if ~exist('/sas_code','dir')
    mkdir('sas_code')
end

% Run the stat
if strcmp(figure_title, '')
    figure_title = strjoin({testing_variable factor_1_variable...
        factor_2_variable}, '_')
end 
 
% Plot the data using the 2 way jitter plot function 
sp_out = two_way_jitter(...
    'excel_file_string', data_file_string, ...
    'excel_sheet', sheet,...
    'test_variable', testing_variable, ...
    'factor_1', factor_1_variable, ...
    'factor_2', factor_2_variable,...
    'grouping', grouping_variable, ...
    'y_label_offset', y_label_offset,...
    'y_from_zero', 0, ...
    'title_y_offset', title_offset,...
    'results_file_string', 'sas_results/sas_results', ...
    'results_type', 'html', ...
    'marker_size', 6,...
    'calling_path_string', cd);


% Export the figure 
% for type_counter = 1 : numel(output_image_types)
%     figure_export( ...
%         'output_file_string', output_image_file, ...
%         'output_type', output_image_types{type_counter});
% end