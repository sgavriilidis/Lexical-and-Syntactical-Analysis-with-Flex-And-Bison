/* definitions */
%{
  #include <stdio.h>
  int lineNum = 1;
%}

/* definitions */
Identifiers [A-Za-z][A-Za-z0-9_]*
Integers [1-9][0-9]*
Digit [0-9]
Floats {Integers}("."{Digit}+)([eE][+-]?{Integers})?
Common_Characters ["."|","|" "|[a-z]|[A-Z]|[0-9]|"-"|"+"|"*"|"/"|":"|"_"|"$"|"%"|"!"|"#"|"@"|"&"|"~"|"^"|"("|")"]
Escape_Sequence  ("\\n"|"\\t"|"\\r"|"\\\\"|"\\\"")
Constant_strings ("\"")(({Escape_Sequence}|{Common_Characters})*)("\"")
Arithmetic_Operators    ("+"|"-"|"*"|"/"|"%"|"**")
Relational_Operators    ("=="|"!="|"<"|"<="|">"|">=")
Assign_operators		("="|"+="|"-="|"*="|"/="|"%=")

/* rules */
%%
"--"[^\n]*  /* eat line comments */
integer	{ yylval.str = strdup(yytext); return KW_INTEGER;}
False   {yylval.str = strdup(yytext); return KW_FALSE;}
for		{ yylval.str = strdup(yytext); return KW_FOR;}
break	{ yylval.str = strdup(yytext); return KW_BREAK;}
def   	{ yylval.str = strdup(yytext); return KW_DEF;}
endcomp	{ yylval.str = strdup(yytext); return KW_ENDCOMP;}
scalar	{ yylval.str = strdup(yytext); return KW_SCALAR;}
const	{ yylval.str = strdup(yytext); return KW_CONST;}
in	    { yylval.str = strdup(yytext); return KW_CIN;}
continue { yylval.str = strdup(yytext); return KW_CONT;}
enddef   { yylval.str = strdup(yytext); return KW_ENDDEF;}
str      { yylval.str = strdup(yytext); return KW_ENDDEF;}
if		{ yylval.str = strdup(yytext); return KW_IF;}
endfor	{ yylval.str = strdup(yytext); return KW_ENDFOR;}
not  	{ yylval.str = strdup(yytext); return KW_NOT;}
main  	{ yylval.str = strdup(yytext); return KW_MAIN;}
boolean	{ yylval.str = strdup(yytext); return KW_BOOLEAN;}
else	{ yylval.str = strdup(yytext); return KW_ELSE;}
while	{ yylval.str = strdup(yytext); return KW_WHILE;}
and		{ yylval.str = strdup(yytext); return KW_AND;}
return	{ yylval.str = strdup(yytext); return KW_RETURN;}
True    {yylval.str = strdup(yytext); return KW_TRUE;}
endif   {yylval.str = strdup(yytext); return KW_ENDIF;}
endwhile  {yylval.str = strdup(yytext); return KW_ENDWHILE;}
or		{ yylval.str = strdup(yytext); return KW_OR;}
comp    { yylval.str = strdup(yytext); return KW_COMP;}
";"		{ yylval.str = strdup(yytext); return KW_SEMICLN;}
"("		{ yylval.str = strdup(yytext); return KW_OPEN_PAR;}
")"		{ yylval.str = strdup(yytext); return KW_CLOSE_PAR;}
","       { yylval.str = strdup(yytext); return KW_COMMA;}
"["       { yylval.str = strdup(yytext); return KW_OPEN_HK;}
"]"       { yylval.str = strdup(yytext); return KW_CLOSE HK;}
":"	      { yylval.str = strdup(yytext);return KW_CLN;}
"."	      { yylval.str = strdup(yytext);return KW_DOT;}
"readString"       		{ yylval.str = strdup(yytext); return RD_STR;}
"readInteger"       	{ yylval.str = strdup(yytext); return RD_INT;}
"readReal"          	{ yylval.str = strdup(yytext); return RD_REAL;}
"writeString"       	{ yylval.str = strdup(yytext); return WR_STR;}
"writeInteger"     		{ yylval.str = strdup(yytext); return WR_INT;}
"writeReal"         	{ yylval.str = strdup(yytext); return WR_REAL;}
{Arithmetic_Operators} 	{ yylval.str = strdup(yytext); return AR_OP;}
{Relational_Operators}  { yylval.str = strdup(yytext); return REL_OP;}
{Constant_strings} 		{ yylval.str = strdup(yytext); return STRINGS;}
{Identifiers} 			{ yylval.str = strdup(yytext); return IDENTIFIERS;}
{Integers}    			{ yylval.str = strdup(yytext); return INTEGERS;}
{Floats}      			{ yylval.str = strdup(yytext); return FLOATS;}
[ \r\t]+			/* skip whitespace */
\n 					 lineNum++;
.           { printf("Line %d Lexical Error: Unrecognized literal %s\n", lineNum, yytext); }
%%


int main ()
{
   int token;
   
   while ( (token = yylex()) != 0 )
      printf("Line %d Token %d: %s\n", lineNum, token, yytext);
	
	  
}
