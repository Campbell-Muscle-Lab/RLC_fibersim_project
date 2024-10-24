function figure_force_pCa_curves
% Function creates a figure showing force_pCa fits


%Variables
addpath(genpath('../../MATLAB_Utilities'))
sim_data_folder = '../sim_data/sim_output/1'
output_image_file = '../output/pCa_curves';
output_image_types ={'png', 'svg', 'eps'};
f_scaling_factor = 0.001;
y_label_offset = -0.1;
title_y_offset = 0.1;
x_label_offset = 0.1;
buffer = 20 ;

color_map = ['#1f77b4' ; '#ff7f0e' ; '#2ca02c' ; '#d62728' ; '#9467bd' ; ...
    '#8c564b'; '#e377c2';'#7f7f7f'; '#bcbd22'; '#17becf']

color_map = hex2rgb(color_map)


% Find data file
data_file = findfiles('txt', sim_data_folder);


% Loop through the data files
m = 1;
for file_counter = 1 : numel(data_file);
    d = readtable(data_file{file_counter});
    l = d.m_length(1);
    ix = [];
    for i = 1 : 3
        ix(i) = find(d.m_length == l, 1,'last');
        summary.pCa(m) = d.hs_1_pCa(1);
        summary.hsl(m) = l;
        summary.force(m) = d.m_force(ix(i));
        l = l +100;
        m = m+1;
    end
end

%Find values for plot 

hsl_values = unique(summary.hsl)

for hsl_counter = 1 : numel(hsl_values)
    vi = find(summary.hsl == hsl_values(hsl_counter));

    pd(hsl_counter).pCa = summary.pCa(vi)
    pd(hsl_counter).y = f_scaling_factor*summary.force(vi)
    pd(hsl_counter).y_error = 0 * pd(hsl_counter).y;

    [pCa50(hsl_counter),n(hsl_counter),~,~,~, pd(hsl_counter).x_fit, pd(hsl_counter).y_fit] = ...
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

%Make a legend 

for i = 1:numel(hsl_values)
    leg_labels{i} = sprintf('hsl =%.f, pCa50 = %.3f, n_h = %.3f',hsl_values(i),pCa50(i),n(i))
end

legendflex(h, leg_labels, ...
        'xscale',1, ...
        'anchor',{'nw','nw'}, ...
        'buffer',[buffer 10], ...
        'padding',[1 1 2], ...
        'FontSize',11, ...
        'text_y_padding', -5);

% Output
for type_counter = 1 : numel(output_image_types)
    figure_export( ...
        'output_file_string', output_image_file, ...
        'output_type', output_image_types{type_counter});
end



