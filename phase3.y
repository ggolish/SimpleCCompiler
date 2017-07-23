
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define K    1024
#define INDENT      "    "

#define TYPE_ERROR  -1
#define TYPE_INT     0
#define TYPE_CHAR    1

#define R9  0
#define R10 1
#define R11 2
#define R12 3
#define R13 4
#define R14 5
#define R15 6

char *types[] = {
    "int",
    "char",
    0
};

int stackptr = R9;

char *identifiers[K];
char *reservations[K];
char previous_cmd[K];

int add_identifier(char *iden);
int get_type(char *t);
int split_list(char *fields[], char *line, char fs);
int yylex();
void eval_if();
void fun_declare(char *fun);
void fun_return();
void fun_write(int n);
void print_exit();
void print_header();
void print_footer();
void push(char *r);
void pop(char *r);
void push_add();
void push_char(char c);
void push_cond(char *jmp);
void push_divide();
void push_mod();
void push_multiply();
void push_num(int n);
void push_subtract();
void push_var(char *var);
void var_assign(char *var);
void var_init(char *type, char *varlist);
void yyerror(char *s); 

%}

%union 
{
    char *str;
    char chr;
    int num;
}

%token <chr> TOK_CHAR
%token <chr> TOK_CLBK
%token <chr> TOK_CLPN
%token <chr> TOK_CMMA
%token <chr> TOK_OPBK
%token <chr> TOK_OPPN
%token <chr> TOK_SMCO
%token <chr> TOK_XADD
%token <chr> TOK_XDIV
%token <chr> TOK_XEQU
%token <chr> TOK_XMOD
%token <chr> TOK_XMUL
%token <chr> TOK_XSUB
%token <num> TOK_XNUM
%token <str> TOK_COND
%token <str> TOK_IDEN
%token <str> TOK_IFCD
%token <str> TOK_RTRN
%token <str> TOK_TYPE
%token <str> TOK_WRTE

%type <num> arglist
%type <str> formalparamlist
%type <str> param
%type <str> varlist

%%

program: program function
       |
       ;

function: functionname TOK_OPPN formalparamlist TOK_CLPN block                  
        ;

functionname: TOK_TYPE TOK_IDEN                                         { fun_declare($2);                                  }
            ;

block: TOK_OPBK statementlist TOK_CLBK
     | TOK_OPBK TOK_CLBK              
     ;

statementlist: statementlist statement
             | statement
             ;

statement: TOK_TYPE varlist TOK_SMCO                                    { var_init($1, $2);                                 }
         | TOK_RTRN expression TOK_SMCO                                 { fun_return();                                     }
         | TOK_IDEN TOK_XEQU expression TOK_SMCO                        { var_assign($1);                                   }
         | TOK_TYPE TOK_IDEN TOK_XEQU expression TOK_SMCO               { var_init($1, $2); var_assign($2);                 }
         | TOK_WRTE TOK_OPPN arglist TOK_CLPN TOK_SMCO                  { fun_write($3);                                    }
         | TOK_IFCD TOK_OPPN conditional TOK_CLPN if statement endif 
         | block
         ;

if:                                                                     { eval_if();                                        }
  ;

endif:                                                                  { printf(".skip:\n");                               }
     ;

arglist: arglist TOK_CMMA expression                                    { $$ = $1 + 1;                                      }   
       | expression                                                     { $$ = 1;                                           }
       |                                                                { $$ = 0;                                           }
       ;

varlist: varlist TOK_CMMA TOK_IDEN                                      { sprintf($$, "%s,%s", $1, $3);                     }
       | TOK_IDEN                                                       { $$ = $1;                                          }
       ;

conditional: expression TOK_COND expression                             { push_cond($2);                                    }
           ;

expression: term                                                            
          | expression TOK_XADD term                                    { push_add();                                       }
          | expression TOK_XSUB term                                    { push_subtract();                                  }
          ;

term: factor                                                             
    | term TOK_XMUL factor                                              { push_multiply();                                  }
    | term TOK_XDIV factor                                              { push_divide();                                    }
    | term TOK_XMOD factor                                              { push_mod();                                       }
    ;

factor: TOK_XNUM                                                        { push_num($1);                                     } 
      | TOK_CHAR                                                        { push_char($1);                                    }
      | TOK_OPPN expression TOK_CLPN                                            
      | TOK_IDEN                                                        { push_var($1);                                     }
      ;

formalparamlist: formalparamlist TOK_CMMA param                         { sprintf($$, "%s,%s", $1, $3);                     }
               | param                                                  { $$ = $1;                                          }
               |                                                        { $$ = "";                                          }
               ;

param: TOK_TYPE TOK_IDEN                                                { var_init($1, $2); sprintf($$, "%s %s", $1, $2);   }       
     ;

%%

int main(int argc, char *argv[])
{
    memset(identifiers, 0, K * sizeof(char *));
    memset(reservations, 0, K * sizeof(char *));
    print_header();
    print_exit();
    yyparse();
    print_footer();
}

void push(char *r)
{
    switch(stackptr++) {
        case R9:
            printf("%smov r9, %s\n", INDENT, r);
            break;
        case R10:
            printf("%smov r10, %s\n", INDENT, r);
            break;
        case R11:
            printf("%smov r11, %s\n", INDENT, r);
            break;
        case R12:
            printf("%smov r12, %s\n", INDENT, r);
            break;
        case R13:
            printf("%smov r13, %s\n", INDENT, r);
            break;
        case R14:
            printf("%smov r14, %s\n", INDENT, r);
            break;
        case R15:
            printf("%smov r15, %s\n", INDENT, r);
            break;
        default:
            printf("%spush %s\n", INDENT, r);
            break;
    }
}

void pop(char *r)
{
    switch(--stackptr) {
        case R9:
            printf("%smov %s, r9\n", INDENT, r);
            break;
        case R10:
            printf("%smov %s, r10\n", INDENT, r);
            break;
        case R11:
            printf("%smov %s, r11\n", INDENT, r);
            break;
        case R12:
            printf("%smov %s, r12\n", INDENT, r);
            break;
        case R13:
            printf("%smov %s, r13\n", INDENT, r);
            break;
        case R14:
            printf("%smov %s, r14\n", INDENT, r);
            break;
        case R15:
            printf("%smov %s, r15\n", INDENT, r);
            break;
        default:
            printf("%spop %s\n", INDENT, r);
            break;
    }
}

void print_exit()
{
    printf("%smov rax, 60\n", INDENT);
    printf("%smov rdi, 0\n", INDENT);
    printf("%ssyscall\n", INDENT);
}

void print_header()
{
    printf("\nsection .text\n\n");
    printf("%sglobal _start\n%sextern writeint\n\n", INDENT, INDENT);
    printf("_start:\n");
    printf("%scall main\n", INDENT);
}

void print_footer()
{
    int i;

    printf("\nsection .bss\n\n");
    for(i = 0; i < K; i++) {
        if(reservations[i] != 0) {
            printf("%s", reservations[i]);
        }
    }
    printf("\nsection .data\n\n");
}

void fun_write(int n)
{
    int i;

    for(i = 0; i < n; i++) {
        pop("rax");
        printf("%scall writeint\n", INDENT);
    }
}

void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}

void fun_declare(char *fun)
{
    if(add_identifier(fun) == -1) {
        fprintf(stderr, "%s: identifier already used\n", fun);
        exit(1);
    }

    // print function name as label
    printf("\n%s:\n\n", fun);
}

void var_init(char *type, char *varlist)
{
    char *vars[K];
    char tmp[K];
    char fs = ',';
    int i, j, len, t;

    len = split_list(vars, varlist, fs);
    t = get_type(type);

    for(i = 0; i < len; i++) {
        if((j = add_identifier(vars[i])) == -1) {
            fprintf(stderr, "variable name already used: %s\n", vars[i]);
            exit(1);
        }
        switch(t) {
            case TYPE_INT:
                sprintf(tmp, "%svar_%s resq 1\n", INDENT, vars[i]);
                reservations[j] = strdup(tmp);
                break;
            case TYPE_CHAR:
                sprintf(tmp, "%svar_%s resb 1\n", INDENT, vars[i]);
                reservations[j] = strdup(tmp);
                break;
            default:
                fprintf(stderr, "invalid type: %s\n", type);
                exit(1);
        }
    }


}

int get_type(char *t)
{
    int i;

    for(i = 0; types[i] != 0; i++) {
        if(strcmp(t, types[i]) == 0) {
            return i;
        }
    }

    return TYPE_ERROR;
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

void var_assign(char *var)
{
    if(add_identifier(var) != -1) {
        fprintf(stderr, "error: %s assigned but not declared\n", var);
        exit(1);
    }

    pop("rax");
    printf("%smov [var_%s], rax\n", INDENT, var);
}

int split_list(char *fields[], char *line, char fs)
{
    char *s, *t;
    int n;

    s = line;
    n = 0;
    while((t = strchr(s, fs)) != NULL) {
        *t = 0;
        fields[n++] = s;
        s = t + 1;
    }

    fields[n++] = s;
    return n;
}

void fun_return()
{
    pop("rax");
    printf("%sret\n", INDENT);
}

void push_add()
{
    pop("rbx");
    pop("rax");
    printf("%sadd rax, rbx\n", INDENT);
    push("rax");
}

void push_subtract()
{
    pop("rbx");
    pop("rax");
    printf("%ssub rax, rbx\n", INDENT);
    push("rax");
}

void push_multiply()
{ 
    pop("rbx");
    pop("rax");
    printf("%simul rbx\n", INDENT);
    push("rax");
}

void push_divide()
{
    pop("rbx");
    pop("rax");
    printf("%sidiv rbx\n", INDENT);
    push("rax");
}

void push_mod()
{
    pop("rbx");
    pop("rax");
    printf("%sidiv rbx\n", INDENT);
    push("rdx");
}

void push_var(char *var)
{
    printf("%smov rax, [var_%s]\n", INDENT, var);
    push("rax");
}

void push_char(char c)
{
    push_num((int)c);
}

void push_num(int n)
{
    char s[K];
    sprintf(s, "%d", n);
    push(s);
}

void push_cond(char *jmp)
{
    pop("rbx");
    pop("rax");
    printf("%scmp rax, rbx\n", INDENT);
    printf("%s%s .true\n", INDENT, jmp);
    push_num(0);
    printf("%sjmp .false\n", INDENT);
    printf(".true:\n");
    push_num(1);
    printf(".false:\n");

}

void eval_if()
{
    pop("rax");
    printf("%scmp rax, 0\n", INDENT);
    printf("%sje .skip\n", INDENT);
}
