function plot_hill_coefficient 

%Path
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
xls_file = '../Simulations/specific_molecules/sim_data/sim_output/pCa_analysis.xlsx';
output_image_file = '../output/pCa_curves_all_fil';
output_image_types = {'png', 'svg', 'eps'};

% Display 
 color_map = [0.8 0 1 ; 1 0.6 0 ; 0.8 0 1; 1 0.6 0; ...
             1 0.7 0.3 ; 0.8 0 1; 0 0.8 0.8]
 f_scaling_factor = 0.001;
y_label_offset = -0.05;
title_y_offset = 0.1;
x_label_offset = 0.1;
buffer = 20 ;

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
    'bottom_margin', 0.2);

% Read excel sheet 
d = readtable(xls_file) 

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

