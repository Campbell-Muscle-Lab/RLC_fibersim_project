/* SAS template for a 2 way analysis without a grouping variable */

proc import out = work.all_data
	datafile = "E:\caterina\GitHub\RLC_fibersim_project\MATLAB_code\..\output\Hill_curve_repeats_fixed.xlsx"
	dbms = xlsx replace;
	sheet = "Sheet1";
	getnames=yes;
run;

ods html file="E:\caterina\GitHub\RLC_fibersim_project\MATLAB_code\sas_results\sas_results.html";
ods listing close;

proc print data=all_data;
	title1 'All data';
run;

proc glimmix data=all_data;
	class RLC_phosp hs_length;
	model n_H = RLC_phosp hs_length RLC_phosp*hs_length /ddfm=satterthwaite;
	lsmeans RLC_phosp hs_length RLC_phosp*hs_length /slice = RLC_phosp slice = hs_length slicediff=(RLC_phosp hs_length) pdiff adjust=tukey;
run;

ods listing;
ods html close;

