function pCa_curves_figure
% function create a figure for pCa curves analysis 

% Path 
addpath(genpath('../../MATLAB_Utilities'))
addpath(genpath('../../MATLAB_SAS'))

% Variables 
sim_data_string = '../data/d_100fil/pCa_analysis_fixed_1.xlsx';
data_file_string = '../data/d_100fil/Hill_curve_repeats_fixed.xlsx';
results_file_string = 'sas_results/sas_results';
output_image_file = '../output/pCa_Czone_12';
output_image_types = {'png', 'eps'};


% Display 
color_map = [1 0.6 0; 0.8 0 1];

% Code
 % Figure layout 
 sp = initialise_publication_quality_figure(...
    'no_of_panels_wide', 3,...
    'no_of_panels_high', 1,...
    'x_to_y_axes_ratio', 1.3, ...
    'right_margin', 1,...
    'axes_padding_top', 0.6 , ...
    'axes_padding_bottom', 0.4,...
    'left_pads', 1,...
    'individual_panel_labels', { 'A', 'B', ''});

 % pCa curves plot 
      % Read excel sheet
      d = readtable(sim_data_string)

      % Define needed parameters
      curve_id = unique(d.curve)
      pCa = unique(d.hs_pCa)
      hs_value = unique(d.hs_length)

      % Loop through conditions
      num_of_trials = 10
      m = 1 
      for i = 1 numel(curve_id)
          vi = find(d.curve ==i)
          % Mean of values 
          for k = 1: num_of_trials
              d(vi(k:10:end),:).hs_force = d(vi(k:10:end),:).hs_force./d(vi(k),:).hs_force
          end
          
          % Built a summary structure  with values for fit 
          for j = 1: numel(pCa)
              ix = find(d(vi,:).hs_pCa == pCa(j)); 
          end
      end

      % Fit the data 
      % Plot data with fit
      % Make a legend 
 % pCa50 stat (2)
      % Read excel sheet
      % Get it into format for jitter plot 
      % Run stat
      % Pull out main effect
      % Draw the jitter plot 
 % n_H stat (3)
      % Read excel sheet
      % Get it into format for jitter plot 
      % Run stat
      % Pull out main effect
      % Draw the jitter plot 
 % Export figure 

  
