/* SAS template for a 2 way analysis with a grouping variable */

proc import out = work.all_data
	datafile = "E:\caterina\GitHub\RLC_fibersim_project\MATLAB_code\temp.xlsx"
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
	class Tool HF_status Hashcode;
	model Result = Tool HF_status Tool*HF_status /ddfm=satterthwaite;
	random Hashcode;
	lsmeans Tool HF_status Tool*HF_status /slice = Tool slice = HF_status slicediff=(Tool HF_status) pdiff adjust=tukey;
run;

ods listing;
ods html close;

