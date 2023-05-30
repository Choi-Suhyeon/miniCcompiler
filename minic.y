%{
#include <stdlib.h>
#include <stdio.h>
%}

%union {
	struct ast * a;
	double d;
	struct symbol * s;
	struct symlist * sl;
	int fn;
}

%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC
%token EOL

%token IF THEN ELSE WHILE DO LET

%nonassoc <fn> CMP
%right '=' PLUS_ASGN MINUS_ASGN MULTIPLICATION_ASGN DIVISION_ASGN REMAINDER_ASGN
%left LOR
%left LAND
%left EQ NE
%left LT LE GT GE
%left '+' '-'
%left '*' '/' '%'
%right UPLUS UMINUS '!'



%type <a> exp cond_stmt list explist
%type <sl> symlist

%start calclist

%%

stmt: exp ';'
| cond_stmt
| iter_stmt
;

cond_stmt: IF '(' exp ')' ';' 
| IF '(' exp ')' exp
| IF '(' exp ')' '{' list '}'
| IF '(' exp ')' exp ELSE exp
| IF '(' exp ')' '{' list '}' ELSE ';'
| IF '(' exp ')' '{' list '}' ELSE exp
| IF '(' exp ')' exp ELSE '{' list '}'
| IF '(' exp ')' '{' list '}' ELSE '{' list '}'
| IF '(' exp ')' exp ELSE '{' list '}'
| IF '(' exp ')' '{' list '}' ELSE cond_stmt
;

iter_stmt: WHILE '(' exp ')' ';'
| WHILE '(' exp ')' exp
| WHILE '(' exp ')' '{' list '}'
| DO exp WHILE '(' exp ')' ';'
| DO '{' list '}' WHILE '(' exp ')' ';'
| FOR '('exp ';' exp ';' exp')' ';'
| FOR '('exp ';' exp ';' exp')' exp
| FOR '('exp ';' exp ';' exp')' '{' list '}'
;

list: { $$ = NULL; }
| stmt list
;

exp: exp EQ exp
| exp NE exp
| exp LT exp
| exp LE exp
| exp GT exp
| exp GE exp
| exp '+' exp
| exp '-' exp
| exp '*' exp
| exp '/' exp
| exp '%' exp
| '(' exp ')'
| '-' exp %prec UMINUS 
| '+' exp %prec UPLUS
| exp LOR exp
| exp LAND exp
| '!' exp
| NUMBER
| TYPE NAME '=' exp
| FUNC '(' explist ')'
;

explist: exp
| exp ',' explist
;
 
%%