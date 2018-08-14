%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cerrno>
    #include <climits>
    #include <limits>
    #include "parser.hpp"
    
	void yyerror(const char *);
%}

/* WRITEME: Write any definitions here. You can find information on
            definitions here:
http://flex.sourceforge.net/manual/Definitions-Section.html */

%x comment

/* WRITEME: If you are going to use start conditions, write them here.
            You can find more information on start conditions here:
            http://flex.sourceforge.net/manual/Start-Conditions.html
            You will probably want to use exclusive conditions rather
            than inclusive conditions (use the %x instead of the %s). */
%%
<INITIAL>{
"/*"                 BEGIN(comment);
}
<comment>{
 "*/"                BEGIN(INITIAL);
 "*"                 
 [^*]+               
 <<EOF>>             { yyerror("dangling comment"); }
}

"+"                  {return T_PLUS;}
"-"                  {return T_MINUS;}
"--"                 {return T_UNARYMINUS;}
"*"                  {return T_MULTIPLY;}
"/"                  {return T_DIVIDE;}
">"                  {return T_GREATER;}
">="                 {return T_GREATEROREQUAL;}
"="                  {return T_EQUAL;}
"."                  {return T_DOT;}
":"                  {return T_COLON;}
";"                  {return T_SEMICOLON;}
"("                  {return T_OPENPAREN;}
")"                  {return T_CLOSEPAREN;}
"{"                  {return T_OPENBRACE;}
"}"                  {return T_CLOSEBRACE;}
","                  {return T_COMMA;}
"->"                 {return T_ARROW;}
"extends"            {return T_EXTENDS;}
"return"             {return T_RETURN;}
"if"                 {return T_IF;}
"else"               {return T_ELSE;}
"do"                 {return T_DO;}
"while"              {return T_WHILE;}
"print"              {return T_PRINT;}
"equals"             {return T_EQUALS;}
"and"                {return T_AND;}
"or"                 {return T_OR;}
"not"                {return T_NOT;}
"new"                {return T_NEW;}
"integer"            {return T_INTEGER;}
"boolean"            {return T_BOOLEAN;}
"none"               {return T_NONE;}
"true"               {return T_TRUE;}
"false"              {return T_FALSE;}
[0]|[1-9][0-9]*      {return T_NUMBER;}
[a-zA-z][a-zA-Z0-9]* {return T_IDENTIFIER;}
[ \t]                ;
[\n]                 ;
.                    { yyerror("invalid character"); }

%%

int yywrap(void) {
  return 1;
}
 
