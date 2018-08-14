/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_HPP_INCLUDED
# define YY_YY_PARSER_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_OPENPAREN = 258,
    T_PLUS = 259,
    T_MINUS = 260,
    T_UNARYMINUS = 261,
    T_MULTIPLY = 262,
    T_DIVIDE = 263,
    T_GREATER = 264,
    T_GREATEROREQUAL = 265,
    T_EQUAL = 266,
    T_DOT = 267,
    T_COLON = 268,
    T_SEMICOLON = 269,
    T_CLOSEPAREN = 270,
    T_OPENBRACE = 271,
    T_CLOSEBRACE = 272,
    T_COMMA = 273,
    T_ARROW = 274,
    T_EXTENDS = 275,
    T_RETURN = 276,
    T_IF = 277,
    T_ELSE = 278,
    T_DO = 279,
    T_WHILE = 280,
    T_PRINT = 281,
    T_EQUALS = 282,
    T_AND = 283,
    T_OR = 284,
    T_NOT = 285,
    T_NEW = 286,
    T_INTEGER = 287,
    T_BOOLEAN = 288,
    T_NONE = 289,
    T_TRUE = 290,
    T_FALSE = 291,
    T_NUMBER = 292,
    T_IDENTIFIER = 293
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_HPP_INCLUDED  */
