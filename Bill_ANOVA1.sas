libname Bill "C:\Users\goffm\OneDrive\Documents\My SAS Files";


*The proc import function converts from excel to SAS:
Note that the file must itself be identified in the path:
Note that the DBMS must specify the file-type:
Note that the range reference is preceded by "Replace" and that 
the Range="<sheetname>$<Matrix Top-Left/Bottom Right";

proc import file="C:\Users\####\OneDrive\Documents\My SAS Files\Data_Bill.xlsx"
			out=Bill_SAS
			DBMS=XLSX
			Replace; 
			Range="data$A1:C61";
run;

proc print data=Bill_SAS;
run; 


*It doesn't appear that tree number has any bearing on the research question;

data Bill_NoTreeno (drop=Treeno);
	set Bill_SAS;
		run;

proc print data=Bill_NoTreeno;
	run;

*Class specifies what the "group" is (e.g., trt=1,2,3);
*Means specifies the significance tests being used;


proc ANOVA data=Bill_NoTreeno;	
	class Trt;
	model caliper_mm = Trt; 
	means Trt/ tukey lines;
run; 
	

proc glm data=Bill_NoTreeno order=data;
	class Trt (ref="1");
		model caliper_mm = Trt/solution;
			run; 

proc plot;
plot Trt*caliper_mm;
	run;
