
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "phase2.tab.h"

int yywrap();
void yyerror(char *s);

%}


%%

int                     { yylval.string = strdup(yytext); return TOK_TYPE;      } 
void                    { yylval.string = strdup(yytext); return TOK_TYPE;      }
char                    { yylval.string = strdup(yytext); return TOK_TYPE;      }
return                  { yylval.string = strdup(yytext); return TOK_RTRN;      }
\(                      { yylval.character = *yytext; return TOK_OPPN;          }
\)                      { yylval.character = *yytext; return TOK_CLPN;          }
\{                      { yylval.character = *yytext; return TOK_OPBK;          }
\}                      { yylval.character = *yytext; return TOK_CLBK;          }
\+                      { yylval.character = *yytext; return TOK_XADD;          }
-                       { yylval.character = *yytext; return TOK_XSUB;          }
\*                      { yylval.character = *yytext; return TOK_XMUL;          }
\/                      { yylval.character = *yytext; return TOK_XDIV;          }
=                       { yylval.character = *yytext; return TOK_XEQU;          }
%                       { yylval.character = *yytext; return TOK_XMOD;          }
;                       { yylval.character = *yytext; return TOK_SMCO;          }
,                       { yylval.character = *yytext; return TOK_CMMA;          }
[_a-zA-Z][_a-zA-Z0-9]*  { yylval.string = strdup(yytext); return TOK_IDEN;      }
[0-9]+                  { yylval.number = atoi(yytext); return TOK_XNUM;        }
[ \t\n]                 ;
.                       { yyerror("illegal character");                         }

%%

int yywrap() 
{
    return 1;
}
