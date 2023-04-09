%{
  #include <stdio.h>
  #include <string.h>
  #include "cgen.h"
  #include  "parser.tab.h"
  #include <math.h>
  int line_num = 1;
%}


/* definitions */
Identifiers [A-Za-z][A-Za-z0-9_]*
Integers [1-9][0-9]*
Digit [0-9]
Floats {Integers}("."{Digit}+)([eE][+-]?{Integers})?
Common_Characters ["."|","|" "|[a-z]|[A-Z]|[0-9]|"-"|"+"|"*"|"/"|":"|"_"|"$"|"%"|"!"|"#"|"@"|"&"|"~"|"^"|"("|")"]
Escape_Sequence  ("\\n"|"\\t"|"\\r"|"\\\\"|"\\\"")
Constant_strings ("\"")(({Escape_Sequence}|{Common_Characters})*)("\"")
Relational_Operators    ("=="|"!="|"<"|"<="|">"|">=")
Assign_operators		("="|"+="|"-="|"*="|"/="|"%=")

/* rules */
%%
"+" {yylval.str = strdup(yytext); return KW_ADD;}
"-" {yylval.str = strdup(yytext); return KW_SUB;}
"*" {yylval.str = strdup(yytext); return KW_MUL;}
"/" {yylval.str = strdup(yytext); return KW_DIV;}
"%" {yylval.str = strdup(yytext); return KW_MOD;}
"**" {yylval.str = strdup(yytext); return KW_POWER;}
"--"[^\n]*  /* eat line comments */

"->" {yylval.str = strdup(yytext); return KW_RIGHT_ARROW;}
integer	{yylval.str = strdup(yytext); return KW_INTEGER;}
False   {yylval.str = strdup(yytext); return KW_FALSE;}
for		{yylval.str = strdup(yytext); return KW_FOR;}
break	{ yylval.str = strdup(yytext); return KW_BREAK;}
def   	{yylval.str = strdup(yytext); return KW_DEF; }
endcomp	{ yylval.str = strdup(yytext); return KW_ENDCOMP;}
scalar	{yylval.str = strdup(yytext); return KW_SCALAR; }
const	{yylval.str = strdup(yytext); return KW_CONST; }
in	    { yylval.str = strdup(yytext); return KW_IN;}
continue {yylval.str = strdup(yytext); return KW_CONTINUE;}
enddef   {yylval.str = strdup(yytext); return KW_ENDDEF; }
str      {yylval.str = strdup(yytext); return KW_STR; }
if		{yylval.str = strdup(yytext); return KW_IF; }
endfor	{ yylval.str = strdup(yytext); return KW_ENDFOR;}
not  	{yylval.str = strdup(yytext); return KW_NOT;}
boolean	{yylval.str = strdup(yytext); return KW_BOOLEAN;}
else	{ yylval.str = strdup(yytext); return KW_ELSE;}
while	{yylval.str = strdup(yytext); return KW_WHILE; }
and		{yylval.str = strdup(yytext); return KW_AND; }
return	{yylval.str = strdup(yytext); return KW_RETURN; }
True    {yylval.str = strdup(yytext); return KW_TRUE;}
endif   {yylval.str = strdup(yytext); return KW_ENDIF;}
endwhile  {yylval.str = strdup(yytext); return KW_ENDWHILE;}
or		{ yylval.str = strdup(yytext); return KW_OR;}
comp    {yylval.str = strdup(yytext); return KW_COMP;}
";"		{yylval.str = strdup(yytext); return KW_SEMICOL; }
"("		{ yylval.str = strdup(yytext); return KW_LEFT_PAR;}
")"		{ yylval.str = strdup(yytext); return KW_RIGHT_PAR;}
","       {yylval.str = strdup(yytext); return KW_COMMA; }
"["       { yylval.str = strdup(yytext); return KW_LEFT_BRACKET;}
"]"       {yylval.str = strdup(yytext); return KW_RIGHT_BRACKET; }
":"	      {yylval.str = strdup(yytext); return KW_COLON; }
"."	      { yylval.str = strdup(yytext); return KW_DOT;}
"#"	      { yylval.str = strdup(yytext); return KW_HASHTAG;}
{Relational_Operators}  {yylval.str = strdup(yytext); return RELATIONAL_OPER; }
{Constant_strings} 		{yylval.str = strdup(yytext); return CONSTANT_STR; }
{Assign_operators}       {yylval.str = strdup(yytext); return ASSIGN_OPER;}
{Integers}    			{yylval.str = strdup(yytext); return INTEGERS;}
{Digit}    			{yylval.str = strdup(yytext); return DIGITS;}
{Floats}      			{yylval.str = strdup(yytext); return FLOATS;}
{Identifiers} 			{yylval.str = strdup(yytext); return IDENTIFIERS; }
[ \r\t]+			/* skip whitespace */
\n 					 line_num++;
.           { printf("Line %d Lexical Error: Unrecognized literal %s\n", line_num, yytext); }
