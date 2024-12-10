function fig_example

% Variables
data_file_string = '../output/two_way_data_test.xlsx';
test_variable = 'pCa50';
factor_1 = 'A';
factor_2 = 'B'
results_file_string = 'sas_results/sas_results';


% Pull data
d = readtable(data_file_string)


% Get it into format for jitter plot
[od, jd] = extract_two_way_data( ...
    'table', d, ...
    'parameter_string', test_variable, ...
    'factor_1', factor_1, ...
    'factor_2', factor_2)

stats = sas_two_way_anova_without_grouping( ...
    'excel_file_string', data_file_string, ...
    'test_variable', test_variable, ...
    'factor_1', factor_1, ...
    'factor_2', factor_2, ...
    'calling_path_string', cd, ...
    'results_file_string', results_file_string)

% Pull out the main effects, write to title_string
p_string = write_p_table_to_string(stats.p_table);
vi = regexp(p_string,'\n');
title_string = p_string(1:vi(3)-1);


% Make a figure
sp = initialise_publication_quality_figure( ...
    'no_of_panels_wide', 1, ...
    'no_of_panels_high', 1, ...
    'top_margin', 1.5)

% Draw the jitter plot

subplot(sp(1))

jd_out = jitter_plot( ...
    'data', jd, ..., ...
    'group_names', unique(d.(factor_1)), ...
    'sub_names', unique(d.(factor_2)), ...
    'y_from_zero', 0, ...
    'title', title_string, ...
    'title_y_offset', 1.5)

% Now that you know the y ticks, calculate the stat lines
% Pull out the stat lines
stat_line_data = return_stat_lines( ...
    '2way_LMM_without_grouping', ...
    stats.p_table, ...
    factor_1, factor_2, jd(1).f1_strings, jd(1).f2_strings, ...
    jd_out.y_ticks)

% Draw them
stat_lines('line_data', stat_line_data)

