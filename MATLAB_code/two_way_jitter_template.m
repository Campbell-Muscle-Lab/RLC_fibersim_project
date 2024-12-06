% Code runs a two-way linear mixed model. This should be used wheh you are
% trying to compare nest categorical variables (i.e. comparing RV/LV in OD and HF)

%Write out the file path of the excel document you are trying to analyze.
%Also define the Sheet you are wanting to analyze if this is different from
%the default of 'Sheet1'
data_file_string = 'E:\caterina\GitHub\RLC_fibersim_project\MATLAB_code\tool_comparison_supp.xlsx'
d = readtable(data_file_string);
sheet= 'Sheet1'
%Give the column name (header) of the experimental variable you want to plot on the y-axis 
%and run stats. This comes the excel doc you are trying to analyze. This
%might be %N2BA, pCa50, or something similar. Must have '' around the word
testing_variable = 'Result'

%Give the column name (header) of the categorical variable you want to be 
%on the x-axis and make comparisions between. This might be DiseaseStatus,
%Region, or something similar. Must have '' around the word
factor_2_variable = 'HF_status'
factor_1_variable = 'Tool'
%If the analysis has a paired design (i.e. samples from the same patient)
%then define the grouping variable. This might be a hashcode or linking
%tag. Must have '' around the word. If not, leave it as a blank ''
grouping_variable = 'Hashcode'

%Give the figure a title. Might take some tweaking to get the axes and 
%margins correct given the size of the labels or titles
figure_title = 'tool_comparison_supp'
y_label_offset = -0.1
title_offset = 2

%Checks if there is a folder exists and makes it if not. This folder is
%needed for the code to work
if ~exist('/sas_code', 'dir')
       mkdir('sas_code')
end

%Makes plot and runs the stats. You may need to define the file path within
%the 'run_sas_model' function to the SAS.exe program which is required for 
%to do the stats

if strcmp(figure_title,'')
    figure_title = strjoin({testing_variable factor_1_variable factor_2_variable},'_')
end


sp_out = two_way_jitter(...
    'excel_file_string', data_file_string, ...
    'excel_sheet', sheet,...
    'test_variable', testing_variable, ...
    'factor_1', factor_1_variable, ...
    'factor_2', factor_2_variable,...
    'grouping', grouping_variable, ...
    'y_label_offset', y_label_offset,...
    'title_y_offset', title_offset,...
    'results_file_string', 'sas_results/sas_results', ...
    'results_type', 'html', ...
    'marker_size', 5,...
    'calling_path_string', cd);

% export_fig(figure_title,'-pdf','-transparent','-nocrop')
% figure_export('output_file_string',figure_title, ...
%     'output_type','png')
 