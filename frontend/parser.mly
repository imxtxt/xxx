%{
 open Ast
%}

%token          TOKEN_ADD
%token          TOKEN_AND
%token          TOKEN_ASSIGN
%token          TOKEN_BOOLEAN
%token          TOKEN_CLASS
%token          TOKEN_COMMER
%token          TOKEN_DOT
%token          TOKEN_ELSE
%token          TOKEN_EOF
%token          TOKEN_EXTENDS 
%token          TOKEN_FALSE
%token <string> TOKEN_ID 
%token          TOKEN_IF
%token          TOKEN_INT
%token          TOKEN_LBRACE
%token          TOKEN_LBRACK
%token          TOKEN_LENGTH
%token          TOKEN_LPAREN
%token          TOKEN_LT
%token          TOKEN_MAIN
%token          TOKEN_NEW
%token          TOKEN_NOT
%token          TOKEN_OUT
%token    <int> TOKEN_NUM
%token          TOKEN_PRINTLN
%token          TOKEN_PUBLIC
%token          TOKEN_RBRACE
%token          TOKEN_RBRACK
%token          TOKEN_RETURN
%token          TOKEN_RPAREN
%token          TOKEN_SEMI
%token          TOKEN_STATIC
%token          TOKEN_STRING
%token          TOKEN_SUB
%token          TOKEN_SYSTEM
%token          TOKEN_THIS
%token          TOKEN_TIMES
%token          TOKEN_TRUE
%token          TOKEN_VOID
%token          TOKEN_WHILE

%start prog
%type <Ast.prog> prog

%%

%inline bop:
  | TOKEN_AND    { And }
  | TOKEN_LT     { Lt }
  | TOKEN_ADD    { Add }
  | TOKEN_SUB    { Sub }
  | TOKEN_TIMES  { Mul }

%inline bool:
  | TOKEN_TRUE  { ture }
  | TOKEN_FALSE { false}

exp: 
  | l=exp b=bop r=exp                         { Bop (l, b, r)}
  | arr=exp TOKEN_LBRACK idx=exp TOKEN_RBRACK { ArrSelect (arr, idx) }
  | arr=exp TOKEN_DOT TOKEN_LENGTH            { ArrLen arr }
  | obj=exp TOKEN_DOT id=TOKEN_ID TOKEN_LPAREN args=separated_list(TOKEN_COMMER, exp) TOKEN_RPAREN
    { Call (obj, id, args) }
  | i=TOKEN_NUM  { Num i }
  | b=bool       { Bool b}
  | i=TOKEN_ID   { Id i}
  | TOKEN_THIS   { This }
  | TOKEN_NEW TOKEN_INT TOKEN_LBRACK e=exp TOKEN_RBRACK  { NewArr e }
  | TOKEN_NEW id=TOKEN_ID TOKEN_LPAREN  TOKEN_RPAREN { NewObj id }
  | TOKEN_NOT e=exp                                  { Not e }
  | TOKEN_LPAREN e=exp TOKEN_RPAREN                  { e }

stmt: 
  | TOKEN_LBRACE stmts=list(stmt) TOKEN_RBRACE  { Stmts stmts }
  | TOKEN_IF TOKEN_LPAREN cnd=exp TOKEN_RPAREN t=stmt TOKEN_ELSE f=stmt { If (cnd, t, f) }
  | TOKEN_WHILE TOKEN_LPAREN cnd=exp TOKEN_RPAREN body=stmt  { While (cnd, body)}
  | TOKEN_SYSTEM TOKEN_DOT TOKEN_OUT TOKEN_DOT TOKEN_PRINTLN TOKEN_LPAREN e=exp TOKEN_RPAREN TOKEN_SEMI
     { Print e }
  | id=TOKEN_ID TOKEN_ASSIGN e=exp TOKEN_SEMI { Assgn (id, e) }
  | id=TOKEN_ID TOKEN_LBRACK idx=exp TOKEN_RBRACK TOKEN_ASSIGN e=exp TOKEN_SEMI { ArrAssgn (id, idx, e) }

ty:
  | TOKEN_INT TOKEN_LBRACK TOKEN_RBRACK { IntArr }
  | TOKEN_BOOLEAN                       { BoolTy }
  | TOKEN_INT                           { IntTy }
  | id=TOKEN_ID                         { IdTy id }

varDecl:
  | t=ty id=TOKEN_ID TOKEN_SEMI       { (t, id)}

func:
  | TOKEN_PUBLIC retTy=ty methName=TOKEN_ID  TOKEN_LPAREN args=separated_list(TOKEN_COMMER, pair(ty,TOKEN_ID)) TOKEN_RPAREN 
    TOKEN_LBRACE vars=list(varDecl) stmts=list(stmt) TOKEN_RETURN retExp=exp TOKEN_RBRACE
    { (retTy, methName, args, vars, stmts, retExp) }

clas:
  | TOKEN_CLASS id=TOKEN_ID TOKEN_LBRACE vars=list(varDecl) meths=list(func) TOKEN_RBRACE { (id, vars, meths) }

main:
  | TOKEN_CLASS id=TOKEN_ID TOKEN_LBRACE TOKEN_PUBLIC TOKEN_STATIC TOKEN_VOID TOKEN_MAIN TOKEN_LPAREN TOKEN_STRING TOKEN_LBRACK TOKEN_RBRACK id2=TOKEN_ID TOKEN_RPAREN TOKEN_RBRACE
    TOKEN_LBRACE s=stmt TOKEN_RBRACE { (id, id2, s) }

prog:
  | m=main classes=list(clas) TOKEN_EOF { (m, classes) } 