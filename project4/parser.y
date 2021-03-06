%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <iostream>
    #define YYINITDEPTH 10000
    #include "ast.hpp"
    #define YYDEBUG 1
    int yylex(void);
    void yyerror(const char *);
    
    extern ASTNode* astRoot;
%}

%error-verbose
/* WRITEME: List all your tokens here */
%token T_OPENPAREN
%token T_PLUS
%token T_MINUS
%token T_UNARYMINUS
%token T_MULTIPLY
%token T_DIVIDE
%token T_GREATER
%token T_GREATEROREQUAL
%token T_EQUAL
%token T_DOT
%token T_SEMICOLON
%token T_CLOSEPAREN
%token T_OPENBRACE
%token T_CLOSEBRACE
%token T_COMMA
%token T_ARROW
%token T_EXTENDS
%token T_RETURN
%token T_IF
%token T_ELSE
%token T_DO
%token T_WHILE
%token T_PRINT
%token T_EQUALS
%token T_AND
%token T_OR
%token T_NOT
%token T_NEW
%token T_INTEGER
%token T_BOOLEAN
%token T_NONE
%token T_TRUE
%token T_FALSE
%token T_NUMBER
%token T_IDENTIFIER

/* WRITEME: Specify precedence here */
%left T_OR
%left T_AND
%left T_GREATER T_GREATEROREQUAL T_EQUALS
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE
%precedence T_NOT T_UNARYMINUS

%type <program_ptr> Start
%type <class_list_ptr> Classes
%type <class_ptr> Class
%type <declaration_list_ptr> Members
%type <declaration_ptr> Member 
%type <method_list_ptr> Methods
%type <method_ptr> Method
%type <methodbody_ptr> Mbody

%type <parameter_list_ptr> Parameters
%type <parameter_list_ptr> Parameter
%type <parameter_ptr> Parameter2

%type <declaration_list_ptr> Declarations
%type <declaration_ptr> Declaration
%type <identifier_list_ptr> Declaration2

%type <statement_list_ptr> Statements
%type <statement_ptr> Statement
%type <assignment_ptr> Assignment
%type <methodcall_ptr> MethodCall
%type <expression_list_ptr> Arguments
%type <expression_list_ptr> Arguments2
%type <ifelse_ptr> Ifelse
%type <while_ptr> Whileloop
%type <dowhile_ptr> Dowhile
%type <print_ptr> Print
%type <expression_ptr> Expression
%type <returnstatement_ptr> Return
%type <type_ptr> Ident
%type <type_ptr> RIdent


%type <integertype_ptr> T_INTEGER
%type <booleantype_ptr> T_BOOLEAN
%type <base_char_ptr> T_IDENTIFIER
%type <base_int> T_NUMBER T_FALSE T_TRUE
%%

/* WRITEME: This rule is a placeholder, since Bison requires
            at least one rule to run successfully. Replace
            this with your appropriate start rules. */
Start   : Classes {$$=new ProgramNode($1); astRoot=$$;}

Classes : Classes Class {$$ = $1; $$->push_back($2);}
	| Class {$$ = new std::list<ClassNode*>(); $$->push_back($1);}
	;

Class   : T_IDENTIFIER T_EXTENDS T_IDENTIFIER T_OPENBRACE Members Methods T_CLOSEBRACE {$$=new ClassNode(new IdentifierNode($1), new IdentifierNode($3), $5, $6);}
        | T_IDENTIFIER T_EXTENDS T_IDENTIFIER T_OPENBRACE Members T_CLOSEBRACE {$$=new ClassNode(new IdentifierNode($1), new IdentifierNode($3), $5, NULL);}
        | T_IDENTIFIER T_EXTENDS T_IDENTIFIER T_OPENBRACE Methods T_CLOSEBRACE {$$=new ClassNode(new IdentifierNode($1), new IdentifierNode($3), NULL, $5);}
        | T_IDENTIFIER T_EXTENDS T_IDENTIFIER T_OPENBRACE T_CLOSEBRACE  {$$=new ClassNode(new IdentifierNode($1), new IdentifierNode($3), NULL, NULL);}
        | T_IDENTIFIER T_OPENBRACE Members Methods T_CLOSEBRACE {$$=new ClassNode(new IdentifierNode($1), NULL, $3, $4);}
        | T_IDENTIFIER T_OPENBRACE Members T_CLOSEBRACE {$$=new ClassNode(new IdentifierNode($1), NULL, $3, NULL);} 
        | T_IDENTIFIER T_OPENBRACE Methods T_CLOSEBRACE {$$=new ClassNode(new IdentifierNode($1), NULL, NULL, $3);}
        | T_IDENTIFIER T_OPENBRACE T_CLOSEBRACE  {$$=new ClassNode(new IdentifierNode($1), NULL, NULL, NULL);}
	;

Members : Members Member {$$=$1; $$->push_back($2);}
        | Member {$$=new std::list<DeclarationNode*>(); $$->push_back($1);}
        ;

Member  : Ident T_IDENTIFIER T_SEMICOLON {$$=new DeclarationNode($1,new std::list<IdentifierNode*>(1, new IdentifierNode($2)));}
        ;

Methods : Methods Method {$$=$1; $$->push_back($2);}
        | Method {$$=new std::list<MethodNode*>(); $$->push_back($1);}
        ;

Method  : T_IDENTIFIER T_OPENPAREN Parameters T_CLOSEPAREN T_ARROW RIdent T_OPENBRACE Mbody T_CLOSEBRACE {$$=new MethodNode(new IdentifierNode($1), $3, $6, $8); }
        ;


Parameters : Parameter {$$=$1;}
           | %empty {$$=NULL;}
           ;

Parameter : Parameter2 {$$=new std::list<ParameterNode*>(); $$->push_back($1);}
      | Parameter2 T_COMMA Parameter {$$=$3; $$->push_front($1);}
      ;

Parameter2 : Ident T_IDENTIFIER {$$=new ParameterNode($1,new IdentifierNode($2));}

Mbody : Declarations Statements Return {$$=new MethodBodyNode($1, $2, $3);}
      | Declarations Return {$$=new MethodBodyNode($1, NULL, $2);}
      | Declarations Statements {$$=new MethodBodyNode($1, $2, NULL);}
      | Statements Return {$$=new MethodBodyNode(NULL, $1, $2);}
      | Declarations {$$=new MethodBodyNode($1, NULL, NULL);}
      | Statements {$$=new MethodBodyNode(NULL, $1, NULL);}
      | Return {$$=new MethodBodyNode(NULL, NULL, $1);}
      | %empty {$$=new MethodBodyNode(NULL, NULL, NULL);}
      ;

Declarations : Declarations Declaration {$$=$1; $$->push_back($2);}
|  Declaration {$$=new std::list<DeclarationNode*>(); $$->push_back($1);}
             ;

Declaration : Ident Declaration2 {$$ = new DeclarationNode($1, $2);}
            ;

Declaration2 : T_IDENTIFIER T_COMMA Declaration2 {$$=$3; $$->push_front(new IdentifierNode($1));}
             | T_IDENTIFIER T_SEMICOLON {$$=new std::list<IdentifierNode*>(); $$->push_front(new IdentifierNode($1));}
             ;

Statements : Statements Statement {$$=$1; $$->push_back($2);} 
           | Statement {$$=new std::list<StatementNode*>(); $$->push_back($1);}
           ; 

Statement : Assignment {$$=$1;}
          | MethodCall T_SEMICOLON {$$=new CallNode($1);}
          | Ifelse {$$=$1;}
          | Whileloop {$$=$1;}
          | Dowhile {$$=$1;}
          | Print {$$=$1;}
          ;

Assignment : T_IDENTIFIER T_EQUAL Expression T_SEMICOLON {$$=new AssignmentNode(new IdentifierNode($1), NULL, $3);}
           | T_IDENTIFIER T_DOT T_IDENTIFIER T_EQUAL Expression T_SEMICOLON {$$=new AssignmentNode(new IdentifierNode($1), new IdentifierNode($3), $5);}
           ;

MethodCall : T_IDENTIFIER T_OPENPAREN Arguments T_CLOSEPAREN  {$$=new MethodCallNode(new IdentifierNode($1), NULL, $3);}
           | T_IDENTIFIER T_DOT T_IDENTIFIER T_OPENPAREN Arguments T_CLOSEPAREN {$$=new MethodCallNode(new IdentifierNode($1), new IdentifierNode($3), $5);}
           ;


Arguments : Arguments2 {$$=$1;}
          | %empty {$$=new std::list<ExpressionNode*>();}
          ;

Arguments2 : Arguments2 T_COMMA Expression {$$=$1; $$->push_back($3);}
           | Expression {$$=new std::list<ExpressionNode*>(); $$->push_back($1);}
           ;

Ifelse : T_IF Expression T_OPENBRACE Statements T_CLOSEBRACE {$$=new IfElseNode($2, $4, NULL);}
         | T_IF Expression T_OPENBRACE Statements T_CLOSEBRACE T_ELSE T_OPENBRACE Statements T_CLOSEBRACE {$$=new IfElseNode($2, $4, $8);}
       ;

Whileloop : T_WHILE Expression T_OPENBRACE Statements T_CLOSEBRACE {$$=new WhileNode($2, $4);}
          ;

Dowhile : T_DO T_OPENBRACE Statements T_CLOSEBRACE T_WHILE T_OPENPAREN Expression T_CLOSEPAREN T_SEMICOLON {$$=new DoWhileNode($3, $7);}
        ;

Print : T_PRINT Expression T_SEMICOLON {$$=new PrintNode($2);}
      ;

Expression : Expression T_PLUS Expression {$$=new PlusNode($1, $3);}
           | Expression T_MINUS Expression {$$=new MinusNode($1, $3);}
           | Expression T_MULTIPLY Expression {$$=new TimesNode($1, $3);}
           | Expression T_DIVIDE Expression {$$=new DivideNode($1, $3);}
           | Expression T_GREATER Expression {$$=new GreaterNode($1, $3);}
           | Expression T_GREATEROREQUAL Expression {$$=new GreaterEqualNode($1, $3);}
           | Expression T_EQUALS Expression {$$=new EqualNode($1, $3);}
           | Expression T_AND Expression {$$=new AndNode($1, $3);}
           | Expression T_OR Expression {$$=new OrNode($1, $3);}
           | T_NOT Expression {$$=new NotNode($2);}
           | T_MINUS Expression %prec T_NOT {$$=new NegationNode($2);}
           | T_IDENTIFIER {$$=new VariableNode(new IdentifierNode($1));}
           | T_IDENTIFIER T_DOT T_IDENTIFIER {$$=new MemberAccessNode(new IdentifierNode($1), new IdentifierNode($3));}
           | MethodCall {$$=$1;}
           | T_OPENPAREN Expression T_CLOSEPAREN {$$=$2;}
	   | T_NUMBER {$$=new IntegerLiteralNode(new IntegerNode($1));}
           | T_TRUE {$$=new BooleanLiteralNode(new IntegerNode($1));}
           | T_FALSE {$$=new BooleanLiteralNode(new IntegerNode($1));}
           | T_NEW T_IDENTIFIER {$$=new NewNode(new IdentifierNode($2), NULL);}
           | T_NEW T_IDENTIFIER T_OPENPAREN Arguments T_CLOSEPAREN {$$=new NewNode(new IdentifierNode($2), $4);}
           ;

Return  : T_RETURN Expression T_SEMICOLON {$$=new ReturnStatementNode($2);}
        ;

Ident   : T_INTEGER {$$=new IntegerTypeNode();}
        | T_BOOLEAN {$$=new BooleanTypeNode();}
        | T_IDENTIFIER {$$=new ObjectTypeNode(new IdentifierNode($1));}
        ;

RIdent  : Ident {$$=$1;}
        | T_NONE {$$=new NoneNode;}
        ;

%%

extern int yylineno;

void yyerror(const char *s) {
  fprintf(stderr, "%s at line %d\n", s, yylineno);
  exit(0);
}
