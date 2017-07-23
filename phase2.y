
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_IDEN 1024

char *identifiers[MAX_IDEN];

int yylex();
void yyerror(char *s); 
int add_identifier(char *iden);
void fun_declare(char *fun);
void var_init(char *var);

%}

%union 
{
    int number;
    char character;
    char *string;
}

%token <string>     TOK_TYPE
%token <character>  TOK_OPPN
%token <character>  TOK_CLPN
%token <character>  TOK_CMMA
%token <string>     TOK_IDEN
%token <string>     TOK_RTRN
%token <character>  TOK_OPBK
%token <character>  TOK_CLBK
%token <character>  TOK_XADD
%token <character>  TOK_XSUB
%token <character>  TOK_XMOD
%token <character>  TOK_XMUL
%token <character>  TOK_XDIV
%token <character>  TOK_XEQU
%token <character>  TOK_SMCO
%token <number>     TOK_XNUM

%%

program: program function
       |
       ;

function: TOK_TYPE TOK_IDEN TOK_OPPN formalparamlist TOK_CLPN block             { fun_declare($2); printf("function name: %s, return type: %s\n", $2, $1); }
        ;

block: TOK_OPBK statementlist TOK_CLBK
     | TOK_OPBK TOK_CLBK              
     ;

statementlist: statementlist statement
             | statement
             ;

statement: TOK_TYPE TOK_IDEN TOK_SMCO                                           { var_init($2); printf("variable declared: %s, type: %s\n", $2, $1); }
         | TOK_RTRN expression TOK_SMCO                                         { printf("return: some value\n"); }
         | TOK_IDEN TOK_XEQU expression TOK_SMCO                                { printf("variable assigned some value: %s\n", $1); }
         ;

expression: term                                                            
          | expression TOK_XADD term                                       
          | expression TOK_XSUB term                                      
          ;

term: factor                                                             
    | term TOK_XMUL factor                                              
    | term TOK_XDIV factor                                          
    | term TOK_XMOD factor
    ;

factor: TOK_XNUM                                                   
      | TOK_OPPN expression TOK_CLPN                              
      | TOK_IDEN
      ;

formalparamlist: formalparamlist TOK_CMMA param
               | param
               |
               ;

param: TOK_TYPE TOK_IDEN                                                        { printf("parameter: %s, type: %s\n", $2, $1); }
     ;

%%

int main(int argc, char *argv[])
{
    memset(identifiers, 0, MAX_IDEN * sizeof(char *));
    yyparse();
}

void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}

void fun_declare(char *fun)
{
    if(add_identifier(fun) == -1) {
        fprintf(stderr, "%s: function redeclared\n", fun);
        exit(1);
    }
}

void var_init(char *var)
{
    if(add_identifier(var) == -1) {
        fprintf(stderr, "%s: variable redefined\n", var);
        exit(1);
    }
}

int add_identifier(char *iden)
{
    int i;

    for(i = 0; identifiers[i] != 0; i++) {
        if(strcmp(identifiers[i], iden) == 0) {
            return -1;
        }
    }

    identifiers[i] = strdup(iden); 
    return i;
}
