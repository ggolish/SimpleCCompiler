
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "phase4.tab.h"

int yywrap();
void yyerror(char *s);

%}


%%

int                     { yylval.str = strdup(yytext); return TOK_TYPE; } 
void                    { yylval.str = strdup(yytext); return TOK_TYPE; }
char                    { yylval.str = strdup(yytext); return TOK_TYPE; }
return                  { yylval.str = strdup(yytext); return TOK_RTRN; }
writeint                { yylval.str = strdup(yytext); return TOK_WRTE; }
writebin                { yylval.str = strdup(yytext); return TOK_WRTE; }
writehex                { yylval.str = strdup(yytext); return TOK_WRTE; }
readint                 { yylval.str = strdup(yytext); return TOK_READ; }
readbin                 { yylval.str = strdup(yytext); return TOK_READ; }
readhex                 { yylval.str = strdup(yytext); return TOK_READ; }
if                      { yylval.str = strdup(yytext); return TOK_IFCD; }
while                   { yylval.str = strdup(yytext); return TOK_WHLP; }
">="                    { yylval.str = strdup("jge"); return TOK_COND;  }
">"                     { yylval.str = strdup("jg"); return TOK_COND;   }
"<="                    { yylval.str = strdup("jle"); return TOK_COND;  }
"<"                     { yylval.str = strdup("jl"); return TOK_COND;   }
"=="                    { yylval.str = strdup("je"); return TOK_COND;   }
"!="                    { yylval.str = strdup("jne"); return TOK_COND;  }
\(                      { yylval.chr = *yytext; return TOK_OPPN;        }
\)                      { yylval.chr = *yytext; return TOK_CLPN;        }
\{                      { yylval.chr = *yytext; return TOK_OPBK;        }
\}                      { yylval.chr = *yytext; return TOK_CLBK;        }
\+                      { yylval.chr = *yytext; return TOK_XADD;        }
-                       { yylval.chr = *yytext; return TOK_XSUB;        }
\*                      { yylval.chr = *yytext; return TOK_XMUL;        }
\/                      { yylval.chr = *yytext; return TOK_XDIV;        }
=                       { yylval.chr = *yytext; return TOK_XEQU;        }
%                       { yylval.chr = *yytext; return TOK_XMOD;        }
;                       { yylval.chr = *yytext; return TOK_SMCO;        }
,                       { yylval.chr = *yytext; return TOK_CMMA;        }
'.'                     { yylval.chr = *(yytext + 1); return TOK_CHAR;  }
[_a-zA-Z][_a-zA-Z0-9]*  { yylval.str = strdup(yytext); return TOK_IDEN; }
[-]*[0-9]+              { yylval.num = atoi(yytext); return TOK_XNUM;   }
[ \t\n]                 ;
.                       { yyerror("illegal character");                 }

%%

int yywrap() 
{
    return 1;
}
