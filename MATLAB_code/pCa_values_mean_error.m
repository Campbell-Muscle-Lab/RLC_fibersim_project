function pCa_values_mean_error 
%Function plot mean values from different pCa

%Path
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
xls_file = '../Simulations/specific_molecules/sim_data/sim_output/pCa_analysis.xlsx';
output_image_file = '../output/new_trial';
output_image_types = {'png', 'svg', 'eps'};

% Display 
 color_map = [0.8 0 1 ; 1 0.6 0 ; 0.8 0 1; 1 0.6 0; ...
             1 0.7 0.3 ; 0.8 0 1; 0 0.8 0.8]
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
% Loop through files 
num_of_trials = 5 
m = 1 
for i = 1:numel(curve_id)
    vi = find(d.curve == i)

    for k = 1 : num_of_trials

        d(vi(k:5:end),:).hs_force = d(vi(k:5:end),:).hs_force./d(vi(k),:).hs_force

    end

    for j = 1:numel(pCa)

        ix = find(d(vi,:).hs_pCa==pCa(j));
        o(m).curve = i;
        o(m).hs_pCa = pCa(j);
        o(m).hs_force = mean(d(vi(ix),:).hs_force);
        o(m).hs_length = mean(d(vi(ix),:).hs_length)
        o(m).error = std(d(vi(ix),:).hs_force)/sqrt(numel((d(vi(ix),:).hs_force)));
        m = m + 1;
    end
end


writetable(struct2table(o),'mean_summary_pCa.xlsx') 


mean_data = readtable('mean_summary_pCa.xlsx')

for i = 1 : numel(curve_id)

    vi = find(mean_data.curve == i);

    [pCa50(i),n(i),~,~,~, r(i).x_fit, r(i).y_fit] = ...
        fit_Hill_curve(mean_data(vi,:).hs_pCa, mean_data(vi,:).hs_force)
    r(i).y_error = mean_data(vi,:).error;
    r(i).y = mean_data(vi,:).hs_force;
    r(i).pCa = mean_data(vi,:).hs_pCa;
    r(i).hsl = mean_data(vi,:).hs_length;
    r(i).hsl(2:end) = []
end


figure(1);
clf
h = plot_pCa_data_with_y_errors(r,...
    'y_axis_off', 0, ...
    'y_axis_label', {'Norm.','force'}, ...
    'x_label_offset',-0.13, ...
    'y_ticks', [0 1.1],...
    'y_label_offset', -0.05, ...
    'marker_symbols',{'o','o','^','^'},...
    'marker_size', 7,...
    'marker_face_colors', color_map, ...
    'y_axis_offset', -0.03, ...
    'title_y_offset', 0, ...
    'title_font_weight', 'bold')

for i = 1:size(r,2)
    leg_labels{i} = sprintf('hsl = %.f, pCa_5_0 = %.2f, n_h = %.2f',r(i).hsl,pCa50(i),n(i))
end

legendflex(h, leg_labels, ...
    'xscale',0.85, ...
    'anchor',{'nw','nw'}, ...
    'buffer',[20 0], ...
    'padding',[1 1 2], ...
    'FontSize',8, ...
    'text_y_padding', -5);

% Output
for type_counter = 1 : numel(output_image_types)
    figure_export( ...
        'output_file_string', output_image_file, ...
        'output_type', output_image_types{type_counter});
end



