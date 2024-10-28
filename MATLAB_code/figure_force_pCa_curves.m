function figure_force_pCa_curves
% Function creates a figure showing force_pCa fits


%Variables
addpath(genpath('../../MATLAB_Utilities'))
num_of_folders = 6; % you can always use functions to do this bit programmatically
output_image_file = '../output/pCa_curves';
output_image_types ={'png'};
% f_scaling_factor = 0.001;
y_label_offset = -0.1;
title_y_offset = 0.1;
x_label_offset = 0.1;
buffer = 15 ;

color_map = ['#1f77b4' ; '#ff7f0e' ; '#2ca02c' ; '#d62728' ; '#9467bd' ; ...
    '#8c564b'; '#e377c2';'#7f7f7f'; '#bcbd22'; '#17becf']

color_map = hex2rgb(color_map)


for folder_counter = 1 : num_of_folders

    sim_data_folder = sprintf('../Simulations/specific_molecules/sim_output/%i',folder_counter);

    % Find data file
    data_file = findfiles('txt', sim_data_folder);


    % Loop through the data files
    for file_counter = 1 : numel(data_file);
        d = readtable(data_file{file_counter});
        l = d.m_length(1);
        [~,k_tr_step] = min(diff(d.m_length))
        summary.pCa(file_counter) = d.hs_1_pCa(k_tr_step-1)
        summary.hsl(file_counter) = l;
        summary.force(file_counter) = d.m_force(k_tr_step-1);
    end


    summary
    %Find values for plot
    hsl_values(folder_counter) = unique(summary.hsl)

    vi = find(summary.hsl == hsl_values(folder_counter))

    pd(folder_counter).pCa = summary.pCa(vi)
    pd(folder_counter).y = summary.force(vi)/(max(summary.force(vi)))
    pd(folder_counter).y_error = 0 * pd(folder_counter).y;

    [pCa50(folder_counter),n(folder_counter),~,~,~, pd(folder_counter).x_fit, pd(folder_counter).y_fit] = ...
        fit_Hill_curve(pd(folder_counter).pCa, pd(folder_counter).y);


end
% Make a figure
pCa50
n
figure(1);
clf
pd
h = plot_pCa_data_with_y_errors(pd,...
    'y_axis_off', 0, ...
    'y_axis_label', {'Normalized','force'}, ...
    'x_label_offset',-0.13, ...
    'y_label_offset', y_label_offset, ...
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



