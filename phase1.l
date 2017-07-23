

%%

int                         { printf("%s : type\n", yytext);                        } 
void                        { printf("%s : type\n", yytext);                        }   
return                      { printf("%s : return statement\n", yytext);            }     
\(                          { printf("%c : open paren\n", *yytext);                 }
\)                          { printf("%c : close paren\n", *yytext);                }
\{                          { printf("%c : open brace\n", *yytext);                 }
\}                          { printf("%c : close brace\n", *yytext);                }
\+                          { printf("%c : addition\n", *yytext);                   }
-                           { printf("%c : subtraction\n", *yytext);                }
\*                          { printf("%c : multiplication\n", *yytext);             }
\/                          { printf("%c : division\n", *yytext);                   }
=                           { printf("%c : assignment\n", *yytext);                 }
;                           { printf("%c : semicolon\n", *yytext);                  }
%                           { printf("%c : modulus\n", *yytext);                    }
,                           { printf("%c : comma\n", *yytext);                      }
'.'                         { printf("%s : character\n", yytext);                   }
[_a-zA-Z][_a-zA-Z0-9]*      { printf("%s : identifier\n", yytext);                  }
[0-9]+.[0-9]+               { printf("%f : floating point number\n", atof(yytext)); }
[0-9]+                      { printf("%d : number\n", atoi(yytext));                }
[ \t\n]                     ;
.                           { fprintf(stderr, "%c : invalid character\n", *yytext); }

%%

int yywrap() 
{
    return 1;
}

int main()
{   
    yylex();
}
