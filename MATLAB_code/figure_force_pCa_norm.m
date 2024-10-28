function figure_force_pCa_norm
% Function creates a figure showing force_pCa normilezed fits

% Path
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
sim_data_folder = '../Simulations/specific_molecules/sim_data/sim_output';
output_image_file = '../output/pCa_curves';
output_image_types = {'png', 'svg', 'eps'};
conditions_to_draw =  [1, 2, 5, 6]

f_scaling_factor = 0.001;
y_label_offset = -0.1;
title_y_offset = 0.1;
x_label_offset = 0.1;
buffer = 20 ;

% Display 
color_map = [1 0 0.2 ; 0.5 0.6 1 ; 0 0 1 ; 0.4 0.7 0.9 ; ...
             1 0.7 0.3 ; 0.8 0 1; 0 0.8 0.8];

% Code 

% Figure layout
no_of_cols = 1
no_of_rows = 1 

sp = initialise_publication_quality_figure(...
    'no_of_panels_wide', no_of_cols,...
    'no_of_panels_high', no_of_rows, ...
    'x_to_y_axes_ratio', 1, ...
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
        ix = []
        for i =  1:2
            ix(i) = find(d.m_length == l, 1,'last');
            summary.pCa(1) = d.hs_1_pCa(1);
            summary.hsl(1) = l
            summary.force(1) = d.m_force(ix(i))
           
        end
    end 
end

% Find values for plot
hsl_values = unique(summary.hsl)

for hsl_counter = 1 : numel(hsl_values)
    vi = find(summary.hsl == hsl_values(hsl_counter))

    pd(hsl_counter).pCa = summary.pCa(vi)
    pd(hsl_counter).y = f_scaling_factor*summary.force(vi)
    pd(hsl_counter).y_error = 0*pd(hsl_counter).y

   [pCa50(hsl_counter),n(hsl_counter),~,~,~, pd(hsl_counter).x_fit,...
       pd(hsl_counter).y_fit] = ...
        fit_Hill_curve(pd(hsl_counter).pCa, pd(hsl_counter).y);
  
end 

% Make a figure 
pCa50
n
figure(1);
clf;

h = plot_pCa_data_with_y_errors(pd,...
'y_axis_off', 0, ...
'y_axis_label', {'Force','(kN m^{-2})'}, ...
'x_label_offset',-0.13, ...
'y_label_offset', y_label_offset, ...
'marker_size', 12,...
'marker_face_colors', color_map, ...
'y_axis_offset', -0.03, ...
'title_y_offset', title_y_offset, ...
'title_font_weight', 'bold')
















