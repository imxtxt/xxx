
(* The type of tokens. *)

type token = 
  | TOKEN_WHILE
  | TOKEN_VOID
  | TOKEN_TRUE
  | TOKEN_TIMES
  | TOKEN_THIS
  | TOKEN_SYSTEM
  | TOKEN_SUB
  | TOKEN_STRING
  | TOKEN_STATIC
  | TOKEN_SEMI
  | TOKEN_RPAREN
  | TOKEN_RETURN
  | TOKEN_RBRACK
  | TOKEN_RBRACE
  | TOKEN_PUBLIC
  | TOKEN_PRINTLN
  | TOKEN_OUT
  | TOKEN_NUM of (int)
  | TOKEN_NOT
  | TOKEN_NEW
  | TOKEN_MAIN
  | TOKEN_LT
  | TOKEN_LPAREN
  | TOKEN_LENGTH
  | TOKEN_LBRACK
  | TOKEN_LBRACE
  | TOKEN_INT
  | TOKEN_IF
  | TOKEN_ID of (string)
  | TOKEN_FALSE
  | TOKEN_EXTENDS
  | TOKEN_EOF
  | TOKEN_ELSE
  | TOKEN_DOT
  | TOKEN_COMMER
  | TOKEN_CLASS
  | TOKEN_BOOLEAN
  | TOKEN_ASSIGN
  | TOKEN_AND
  | TOKEN_ADD

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.prog)
