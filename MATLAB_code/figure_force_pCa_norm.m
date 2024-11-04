
function figure_force_pCa_norm
% Function creates a figure showing force_pCa normilezed fits

% Path
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
sim_data_folder = '../Simulations/specific_molecules/sim_data/sim_output';
output_image_file = '../output/pCa_curves_CZone_3state';
output_image_types = {'png', 'svg', 'eps'};
conditions_to_draw =  [1, 2, 3, 4]

f_scaling_factor = 0.001;
y_label_offset = -0.05;
title_y_offset = 0.1;
x_label_offset = 0.1;
buffer = 20 ;

% Display 
color_map = [1 0 0.2 ; 0.5 0.6 1 ; 1 0 0.2 ; 0.5 0.6 1 ; ...
             1 0.7 0.3 ; 0.8 0 1; 0 0.8 0.8];

% Code 

% Figure layout
no_of_cols = 1
no_of_rows = 1 

sp = initialise_publication_quality_figure(...
    'no_of_panels_wide', no_of_cols,...
    'no_of_panels_high', no_of_rows, ...
    'x_to_y_axes_ratio', 1.3, ...
    'right_margin', 1, ...
    'axes_padding_top', 0 , ...
    'axes_padding_bottom', 0.4, ...
    'panel_label_font_size', 0, ...
    'top_margin', 0.4, ...
    'bottom_margin', 0.2)

% Loop through the conditions to draw
for cond_counter = 1: numel(conditions_to_draw)

    % Generate the folder name
     cond_data_folder = fullfile(sim_data_folder, ...
                        sprintf('%i', conditions_to_draw(cond_counter)));

    % Pull off all the txt files in the cond_data_folder
    sim_files = findfiles('txt', cond_data_folder)';

    % Loop through and read the files
  
    for sim_counter = 1 : numel(sim_files);
        d = readtable(sim_files{sim_counter});
        l = d.m_length(1)
          [~,k_tr_step] = min(diff(d.m_length))
        summary.pCa(sim_counter) = d.hs_1_pCa(k_tr_step-1)
        summary.hsl(sim_counter) = l;
        summary.force(sim_counter) = d.m_force(k_tr_step-1);
    end 

     summary
    %Find values for plot
    hsl_values(cond_counter) = unique(summary.hsl)

    vi = find(summary.hsl == hsl_values(cond_counter))

    pd(cond_counter).pCa = summary.pCa(vi)
    pd(cond_counter).y = summary.force(vi)/(max(summary.force(vi)))
    pd(cond_counter).y_error = 0 * pd(cond_counter).y;

    [pCa50(cond_counter),n(cond_counter),~,~,~, pd(cond_counter).x_fit, pd(cond_counter).y_fit] = ...
        fit_Hill_curve(pd(cond_counter).pCa, pd(cond_counter).y);

end

% Make a figure 
pCa50
n
figure(1);
clf
pd
h = plot_pCa_data_with_y_errors(pd,...
    'y_axis_off', 0, ...
    'y_axis_label', {'Norm.','force'}, ...
    'x_label_offset',-0.13, ...
    'y_label_offset', y_label_offset, ...
    'marker_symbols',{'o','o','^','^'},...
    'marker_size', 9,...
    'marker_face_colors', color_map, ...
    'y_axis_offset', -0.03, ...
    'title_y_offset', title_y_offset, ...
    'title_font_weight', 'bold')

%Make a legend

for i = 1:size(pd,2)
    leg_labels{i} = sprintf('hsl = %.f, pCa_5_0 = %.2f, n_h = %.2f',hsl_values(i),pCa50(i),n(i))
end

legendflex(h, leg_labels, ...
    'xscale',0.85, ...
    'anchor',{'nw','nw'}, ...
    'buffer',[buffer 0], ...
    'padding',[1 1 2], ...
    'FontSize',8, ...
    'text_y_padding', -5);

% Output
for type_counter = 1 : numel(output_image_types)
    figure_export( ...
        'output_file_string', output_image_file, ...
        'output_type', output_image_types{type_counter});
end















