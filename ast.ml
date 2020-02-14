type id = string

type bop =
  | And
  | Lt
  | Add
  | Sub
  | Mul

type exp = 
  | Bop of exp * bop * exp
  | ArrSelect of exp * exp
  | ArrLen of exp
  | Call of exp * id * exp list
  | Num of int
  | Bool of bool
  | Id of id
  | This
  | NewArr of exp
  | NewObj of id
  | Not of exp

type stmt =
  | Stmts of stmt list
  | If of exp * stmt * stmt
  | While of exp * stmt
  | Print of exp
  | Assgn of id * exp
  | ArrAssgn of id * exp * exp

type ty = 
  | IntArr
  | BoolTy
  | IntTy
  | IdTy of id

type varDecl = ty * id

type methDecl = ty * id * (ty * id) list * varDecl list * stmt list * exp

type classDecl = id * varDecl list * methDecl list

type mainDecl = id * id * stmt

type prog = mainDecl * classDecl list