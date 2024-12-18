function k_tr_superpose_plots
% Function create a figure with ktr traces superimposition for different
%models

% Path 
addpath(genpath('../../MATLAB_Utilities'))
addpath(genpath('../../MATLAB_SAS'))

% Variables
sim_data_folder = '../Simulations/caterinas_playground/d/sim_data/sim_output';
data_file_string = '../output/k_tr_analysis_fixed.xlsx';
results_file_string = 'sas_results/sas_results';
output_file_string= '../output/ktr_image';
output_types = {'png', 'eps'};
conditions_to_draw = [1, 2]

f_scaling_factor = 0.001

test_variable = 'k_tr'
factor_1 = 'hs_length'
factor_2 = 'RLC_phosp'
sheet = "Sheet1"

% Display 
color_map  = [1 0.6 0; 0.8 0 1; 1 0.6 0; 0.8 0 1; 1 0.6 0; 0.8 0 1; 1 0.6 0;...
    0.8 0 1;1 0.6 0; 0.8 0 1; 1 0.6 0; 0.8 0 1; 1 0.6 0; 0.8 0 1; 1 0.6 0; 0.8 0 1];

 trace_line_width = 2
 t_ticks = [0.9 1.2]
 x_label_offset = -0.15
 y_ticks = [ 1120 1150 ; ...
             0 150]
 y_ticks_jit = [15 35]
 y_tick_decimal_places = [1 0]
 y_label_offset = -0.2;

 y_labels = {'Length','(um)' ...
            {'Force', '(mN mm^{-2})'}};
 y_axis_label = {'k_tr'}

% Code 

% Figure layout
idx = [4]

height_adjustments = zeros(1, 4)
height_adjustments(idx) = [2.1]

bottom_adjustments = zeros(1, 4);
bottom_adjustments(idx) = [0];


sp = initialise_publication_quality_figure(...
    'no_of_panels_wide', 2,...
    'no_of_panels_high', 2, ...
    'x_to_y_axes_ratio', 1.5, ...
    'right_margin', 1, ...
    'axes_padding_top', 0 , ...
    'axes_padding_bottom', 0.4, ...
    'panel_label_font_size', 0, ...
    'top_margin', 0.4, ...
    'bottom_margin', 0.2,...
    'omit_panels', [2],...
    'height_subplot_adjustments', height_adjustments, ...
     'bottom_subplot_adjustments', bottom_adjustments);


% Traces plot
% Loop through the conditions to draw 
for cond_counter = 1 : numel(conditions_to_draw)
    
    % Generate the folder name 
    cond_data_folder = fullfile(sim_data_folder,...
                       sprintf('%i', conditions_to_draw(cond_counter)))

    % Pull off all the txt files in the cond_data folder
    sim_files = findfiles ('txt', cond_data_folder)'
    
    % Loop through the files
    for sim_counter = 1: numel(sim_files)

        % Read the files 
        d = readtable(sim_files{sim_counter})

        % Set the visible data point 
        ti = find((d.time> t_ticks(1)) &...
             (d.time<t_ticks(end)));
    
        %Length
        plot_index = 1
        subplot(sp(plot_index))
        hold on
        h(sim_counter) = plot(d.time(ti),  d.hs_1_length(ti), '-', ...
                        'LineWidth', trace_line_width, ...
                        'Color', color_map(cond_counter, :));
        
        % Force
        plot_index = 3 
        subplot(sp(plot_index))
        hold on;
        h(sim_counter) = plot(d.time(ti), f_scaling_factor * d.hs_1_force(ti), ...
                         '-', 'LineWidth', trace_line_width,'Color',...
                         color_map(sim_counter, :))

    end
end

% Plot data from excel
b = readtable(data_file_string)

% Get it into format for jitter plot 
[od, jd] = extract_two_way_data( ...
    'table', b, ...
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

% Draw the jitter plot
plot_index = 4
subplot(sp(plot_index))
hold on
h(sim_counter) = jitter_plot( ...
                'data', jd, ..., ...
                'group_names', unique(b.(factor_1)), ...
                'sub_names', unique(b.(factor_2)), ...
                'symbols', {'o'}, ...
                'marker_face_colors', color_map, ...
                'y_from_zero', 0, ...
                'y_label_offset',-0.15, ...
                'y_axis_label',y_axis_label, ...
                'y_ticks', y_ticks_jit,...
                'y_main_label_offset', 0.5,...
                'title', title_string, ...
                'title_y_offset', 2)

