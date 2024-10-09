%{
#include<stdio.h>
#include<string.h>
int cnt_keyword=0;
int cnt_variables=0;
int cnt_stmnts=0;
int f=0;
char str[10000];
char str2[10000];
char str3[10000];
char str4[10000];
char str5[10000];

%}

fdir		"#"("include")("<<")("flang"|"flang+")(".")("h")(">>")[ \n][ \n\t]*
fdigit		[0-9]+
fletter		[a-zA-Z]+
stmnt		("|")
fint		([\+\-]?{fdigit})
ffloat		([\+\-]?{fdigit}"."{fdigit})
fbool		("true"|"false")
fstring		[\"].*[\"]

fvariable		("_"{fletter})
ffmain		("fmain"[ ]"["[ ]"]"[ \n\t]*"$"[ \n\t]*)
freturn		([ \n\t]*"fret"[ ]{fdigit}[ ]?"|"[ \n\t]*"$")
fdt		("fint"|"ffloat"|"fstring"|"fbool")
fkw		("fint"|"ffloat"|"fstring"|"fbool"|"fif"|"felsif"|"felse"|"ffor"|"fwhile"|"fret"|"fmain")
frel_op		(">"|"<"|">="|"<="|"=="|"!=")
farith_op		("+"|"-"|"*"|"/")
finc_dec		("++"|"--")
fassign_op		[=]
f1line_cmnt		("##")[^\n]*
fmultiline_cmnt		"/*"[^*/]*"*/"


valid_declaration		{fdt}[ ]+{fvariable}[ ]*([=][ ]*({fint}|{ffloat}|{fstring}|{fbool})[ ]*)?"|"[ \n\t]*
valid_operation		({fvariable}[=]{fvariable}{farith_op}{fvariable}"|"[ \n\t]*)


ffor		("ffor"[ ]"@"[ ]{fdt}[ ]{fvariable}[=]{fdigit}";"{fvariable}{frel_op}({fdigit}|{fvariable})";"{fvariable}{finc_dec}[ ]"@"[ \n\t]*[(][ \n\t]*{valid_operation}*[ \n\t]*[)][ \n\t]*) 

fwhile		("fwhile"[ ]"@"[ ]{fvariable}{frel_op}({fvariable}|{fdigit})[ ]"@"[ \n\t]*[(][ \n\t]*{fvariable}{finc_dec}"|"[ \n\t]*[)][ \n\t]*)
fif		("fif"[ ]"@"[ ]{fvariable}{frel_op}{fvariable}[ ]"@"[ \n\t]*[(][ \n\t]*{valid_operation}*[ \n\t]*[)][ \n\t]*)
felsif		("felsif"[ ]"@"[ ]{fvariable}{frel_op}{fvariable}[ ]"@"[ \n\t]*[(][ \n\t]*{valid_operation}*[ \n\t]*[)][ \n\t]*)
felse		("felse"[ \n\t]*[(][ \n\t]*{valid_operation}*[ \n\t]*[)][ \n\t]*)
%%
{fdir}		{printf("\nDirective is declared correctly \n");}

{f1line_cmnt}		{printf("Single line comment detected \n");}
{fmultiline_cmnt}		{printf("Multi line comment detected \n");}
{fkw}		{
		++cnt_keyword;
		}
{fvariable}		{
			++cnt_variables;
			}

{ffmain}		{printf("In the main function \n");
			++cnt_keyword;}

{valid_operation}		{
				printf("This is a valid operation \n");	
				++cnt_stmnts;	
				}
{valid_declaration}		{
				printf("This is a valid declaration \n");
				++cnt_stmnts;
				}

{ffor}		{printf("for loop detected \n");
		++cnt_keyword;
		++cnt_keyword;
		strcpy(str2,yytext);
		int i;
		for(i=0;i<strlen(str2);i++)
		{if(str2[i]=='|')
		{++cnt_stmnts;}
		if(str2[i]=='_')
		{++cnt_variables;}}}
{fwhile}		{printf("fwhile loop detected \n");
			++cnt_keyword;
			strcpy(str3,yytext);
			int i;
			for(i=0;i<strlen(str3);i++)
			{if(str3[i]=='|')
			{++cnt_stmnts;}
			if(str3[i]=='_')
			{++cnt_variables;}}	
			}
{fif}({felsif}?){felse}		{printf("fif-felsif-felse detected\n");
				cnt_keyword+=3;
				strcpy(str4,yytext);
				int i;
				for(i=0;i<strlen(str4);i++)
				{if(str4[i]=='|')
				{++cnt_stmnts;}
				if(str4[i]=='_')
				{++cnt_variables;}}	
				}
{freturn}		{printf("Program ended \n");
			++cnt_keyword;
			++cnt_stmnts;}
%%



int yywrap()
{
	return 1;
}

int main()
{
	yyin=fopen("input.txt", "r");
	yylex();
	printf("Total variables: %d\n", cnt_variables);
	printf("Total statements: %d\n", cnt_stmnts);
	printf("Total keywords: %d\n", cnt_keyword);
	return 0;
}