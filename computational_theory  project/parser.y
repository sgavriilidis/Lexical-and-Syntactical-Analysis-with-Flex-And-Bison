%{
#include <stdio.h>
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

%union
{
	char* str;
	int num;
}

%define parse.trace
%debug


%token KW_INTEGER
%token KW_FALSE
%token KW_FOR
%token KW_BREAK
%token KW_DEF
%token KW_ENDCOMP
%token KW_SCALAR
%token KW_CONST
%token KW_IN
%token KW_CONTINUE
%token KW_ENDDEF
%token KW_STR
%token KW_IF
%token KW_ENDFOR
%right KW_NOT
%token KW_MAIN
%token KW_BOOLEAN
%token KW_ELSE
%token KW_WHILE
%left KW_AND
%token KW_RETURN
%token KW_TRUE
%token KW_ENDIF
%token KW_ENDWHILE
%left KW_OR
%token KW_COMP
%token KW_SEMICOL
%token KW_LEFT_PAR
%token KW_RIGHT_PAR
%token KW_COMMA
%left KW_LEFT_BRACKET
%right KW_RIGHT_BRACKET
%token KW_COLON
%token KW_DOT
%token KW_HASHTAG
%token KW_READ_STRING
%token KW_READ_INTEGER
%token KW_READ_REAL
%token KW_WRITE_STRING
%token KW_WRITE_INTEGER
%token KW_WRITE_REAL
%token KW_EQUAL
%token KW_RIGHT_ARROW

%left KW_ADD
%left KW_SUB
%left KW_MUL
%left KW_DIV
%left KW_MOD
%right KW_POWER
%right MATHS
%left SIGN

%token <str> ARITHM_OPER
%right <str> RELATIONAL_OPER
%token <str> CONSTANT_STR
%token <str> ASSIGN_OPER
%token <str> IDENTIFIERS
%token <str> DIGITS
%token <str> INTEGERS
%token <str> FLOATS

%start initial_point
%type <str> initial_point
%type <str> header
%type <str> globl_declarations 
%type <str> global_variables
%type <str> common_variables
%type <str> variable_type
%type <str> expression
%type <str> comp_contents
%type <str> comp_variables
%type <str> declare_name_of_variables
%type <str> function_contents
%type <str> function_body_instructions 
%type <str> function_parameters
%type <str> parameter
%type <str> call_function_params
%type <str> call_function
%%
header:{
	{
$$ = template("/*Sofoklis Gavr */\n#include <stdio.h>\n #include <math.h> \n#include <stdlib.h>\n#include <string.h>\n#include \"thetalib.h\" \n");
}
};

initial_point:
header globl_declarations {printf("%s\n%s\n",$1,$2);}
;

globl_declarations:
global_variables globl_declarations {$$=template("%s\n%s", $1, $2);}
|global_variables {$$=template("%s", $1);}
;

global_variables:
 common_variables {$$=template("%s\n", $1);}
|KW_CONST IDENTIFIERS ASSIGN_OPER expression KW_COLON variable_type KW_SEMICOL {$$=template("const %s %s %s %s;", $6, $2, $3, $4);}
|KW_COMP  IDENTIFIERS KW_COLON comp_contents  KW_ENDCOMP KW_SEMICOL {$$=template("typedef struct %s {\n%s\n} %s;",  $2, $4, $2);}
|KW_DEF  IDENTIFIERS KW_LEFT_PAR function_parameters KW_RIGHT_PAR KW_RIGHT_ARROW variable_type KW_COLON function_contents KW_ENDDEF KW_SEMICOL
																				{$$=template("%s %s (%s){\n%s\n}",  $7, $2, $4, $9);}
|KW_DEF  IDENTIFIERS KW_LEFT_PAR  KW_RIGHT_PAR KW_RIGHT_ARROW variable_type KW_COLON function_contents KW_ENDDEF KW_SEMICOL
																				{$$=template("%s %s (){\n%s\n}",  $6, $2, $8);}
|KW_DEF  IDENTIFIERS KW_LEFT_PAR function_parameters KW_RIGHT_PAR  KW_COLON function_contents KW_ENDDEF KW_SEMICOL
																				{$$=template("void %s (%s){\n%s\n}",  $2, $4, $7);}
|KW_DEF  IDENTIFIERS KW_LEFT_PAR  KW_RIGHT_PAR  KW_COLON function_contents KW_ENDDEF KW_SEMICOL
																				{$$=template("void %s (){\n%s\n}",  $2, $6);}																				
;

function_parameters:
parameter {$$=template("%s", $1);}
| parameter KW_COMMA function_parameters {$$=template("%s,%s", $1, $3);}

parameter:
IDENTIFIERS KW_COLON variable_type {$$=template("%s %s", $3, $1);}
|IDENTIFIERS KW_LEFT_BRACKET KW_RIGHT_BRACKET KW_COLON variable_type  {$$=template("%s  %s []", $5, $1);}


function_contents:
function_body_instructions {$$=template("%s\n", $1);}
|function_body_instructions function_contents {$$=template("%s\n%s", $1, $2);}

function_body_instructions:
common_variables  {$$=template("%s", $1);}
|KW_RETURN expression  KW_SEMICOL  {$$=template("return %s ;", $2);}
| IDENTIFIERS  ASSIGN_OPER  expression  KW_SEMICOL{$$=template("%s %s %s ;", $1, $2, $3);}
| call_function  KW_SEMICOL  {$$=template("%s;", $1);}
|  IDENTIFIERS KW_LEFT_BRACKET expression KW_RIGHT_BRACKET {$$=template("%s[%s]", $1, $3);}
|  IDENTIFIERS KW_LEFT_BRACKET expression KW_RIGHT_BRACKET KW_DOT IDENTIFIERS {$$=template("%s[%s].%s", $1, $3, $6);}
|  IDENTIFIERS KW_LEFT_BRACKET expression KW_RIGHT_BRACKET KW_DOT call_function {$$=template("%s[%s].%s", $1, $3, $6);}
|  IDENTIFIERS KW_DOT IDENTIFIERS   {$$=template("%s.%s", $1, $3);}
|  IDENTIFIERS KW_DOT call_function  {$$=template("%s.%s", $1, $3);}

;



common_variables:
declare_name_of_variables KW_COLON variable_type KW_SEMICOL  {$$=template("%s %s;", $3, $1);}

comp_contents:
comp_variables  KW_COLON variable_type KW_SEMICOL comp_contents {$$=template("%s %s;\n%s", $3, $1, $5 );}
|comp_variables KW_COLON variable_type KW_SEMICOL {$$=template("%s %s;\n", $3, $1);}

;

comp_variables: 
KW_HASHTAG IDENTIFIERS {$$=template("%s", $2);}
|KW_HASHTAG IDENTIFIERS KW_LEFT_BRACKET INTEGERS  KW_RIGHT_BRACKET {$$=template("%s[%s]", $2, $4);}
|KW_HASHTAG IDENTIFIERS KW_COMMA comp_variables {$$=template("%s,%s", $2, $4);}
|KW_HASHTAG IDENTIFIERS KW_LEFT_BRACKET  INTEGERS  KW_RIGHT_BRACKET KW_COMMA comp_variables {$$=template("%s[%s],%s", $2, $4, $7);}
;



call_function_params:
expression   { $$ = template("%s", $1);}
|call_function_params KW_COMMA expression  { $$ = template("%s,%s", $1, $3);}

call_function:
IDENTIFIERS KW_LEFT_PAR  KW_RIGHT_PAR { $$ = template("%s ()", $1);}
|IDENTIFIERS KW_LEFT_PAR call_function_params KW_RIGHT_PAR { $$ = template("%s (%s)", $1, $3);}
;

expression:
CONSTANT_STR {$$=template("%s", $1);}
|INTEGERS {$$=template("%s", $1);}
|DIGITS {$$=template("%s", $1);}
|FLOATS {$$=template("%s", $1);}
|IDENTIFIERS  {$$=template("%s", $1);}
|KW_TRUE {$$=template("1");}
|KW_FALSE {$$=template("0");}
|KW_NOT expression  {$$=template("!%s", $2);}
| call_function {$$=template("%s", $1);}
|  expression KW_AND expression  {$$=template("%s && %s", $1, $3);}
|  expression  KW_OR expression  {$$=template("%s || %s", $1, $3);}
|  expression KW_ADD expression %prec MATHS {$$=template("%s +  %s", $1, $3);}
|  expression  KW_SUB expression %prec MATHS  {$$=template("%s -  %s", $1, $3);}
|  KW_ADD expression %prec SIGN  {$$=template("+(%s)", $2);}
|  KW_SUB expression  %prec SIGN {$$=template("-(%s)", $2);}
|  expression KW_MUL expression  {$$=template("%s *  %s", $1, $3);}
|  expression KW_DIV expression  {$$=template("%s /  %s", $1, $3);}
|  expression KW_MOD expression  {$$=template("%s %  %s", $1, $3);}
|  expression KW_POWER expression {$$=template("pow(%s, %s)", $1, $3);}
|  expression RELATIONAL_OPER expression {$$=template("%s %s %s", $1, $2, $3);}
|  KW_LEFT_PAR expression KW_RIGHT_PAR {$$=template("(%s)", $2);}
|  IDENTIFIERS KW_LEFT_BRACKET expression KW_RIGHT_BRACKET {$$=template("%s[%s]", $1, $3);}
|  IDENTIFIERS KW_LEFT_BRACKET expression KW_RIGHT_BRACKET KW_DOT IDENTIFIERS {$$=template("%s[%s].%s", $1, $3, $6);}
|  IDENTIFIERS KW_LEFT_BRACKET expression KW_RIGHT_BRACKET KW_DOT call_function {$$=template("%s[%s].%s", $1, $3, $6);}
|  IDENTIFIERS KW_DOT IDENTIFIERS   {$$=template("%s.%s", $1, $3);}
|  IDENTIFIERS KW_DOT call_function  {$$=template("%s.%s", $1, $3);}

;

declare_name_of_variables:
IDENTIFIERS {$$=template("%s", $1);}
|IDENTIFIERS KW_LEFT_BRACKET INTEGERS  KW_RIGHT_BRACKET {$$=template("%s[%s]", $1, $3);}
|IDENTIFIERS KW_COMMA declare_name_of_variables {$$=template("%s,%s", $1, $3);}
|IDENTIFIERS KW_LEFT_BRACKET  INTEGERS  KW_RIGHT_BRACKET KW_COMMA declare_name_of_variables {$$=template("%s[%s],%s", $1, $3, $6);}
;


variable_type:
KW_INTEGER    { $$ = template("int");}
| KW_BOOLEAN  { $$ = template("int");}
| KW_STR      { $$ = template("char*");}
| KW_COMP     { $$ = template("typedef struct");}
| KW_SCALAR   { $$ = template("double");}
| IDENTIFIERS { $$ = template("%s", $1);}
;

%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}

