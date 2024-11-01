function figure_ktr_analysis 
% Function creates a figure shwing ktr traces and analysis 

% Path 
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
sim_data_folder = '../Simulations/specific_molecules/sim_data/uniform/sim_output';
output_image_file = '../output/pCa_curves_uniform_fastnorm';
output_image_types = {'png', 'svg', 'eps'};
conditions_to_draw =  [1, 2, 5, 6]

% Display 
color_map = [1 0 0.2 ; 0.5 0.6 1 ; 1 0 0.2 ; 0.5 0.6 1 ; ...
             1 0.7 0.3 ; 0.8 0 1; 0 0.8 0.8];

t_ticks = [0 1]

% Figure layout
no_of_cols = 2
no_of_rows = 4 

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

    % Loop through the files
    for sim_counter = 1: numel(sim_files)

        % Read the file
        d = readtable(sim_files{sim_counter});

        % Set the visible points
        ti = find((d.time>t_ticks(1))& (d.time < t_ticks(end)));

    end
       
end