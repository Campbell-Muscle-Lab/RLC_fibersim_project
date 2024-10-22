function figure_force_pCa_norm
% Function create a figure showing force-pCa curves 

% Path 
addpath(genpath('../../MATLAB_Utilities'))

% Variables 
sim_data_folder = '../Simulations/specific_molecules/sim_data/sim_output';
output_image_file = '../output/pCa_curves_norm';
output_image_types = {'png', 'svg', 'eps'};

% Display 



% Code 

% Find data file
data_file = findfiles ('txt', sim_data_folder);

% Loop through the conditions to draw 
m = 1
for file_counter = 1 : numel(data_file)
    d = readtable(data_file{file_counter})
    l = d.m_length(1);
    ix = [];
    for i = 1:2
        ix(i) = find (d.m_length == 1, 1,'last');
        summary.pCa(m) = d.hs_1_pCa(1);
        summary.hsl(m) = 1;
        summry.force(m) = d.m_force(ix(i));
        l = l + 100;
        m = m + 1;
    end
end 