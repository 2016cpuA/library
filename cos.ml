(* calculate pi with Euler's formula of arctan *)
let rec fsqr x = x*.x in

let rec n_pi n =
  let x = 2.*.n in
  let rec ev_err_pi err acc n =
    if acc < 0.000000001*.err then n
    else
      let rn = (float_of_int n)/.(float_of_int (n+n+1)) in
      ev_err_pi (err+.acc) (acc *. rn) (n+1) in
  let max = ev_err_pi (4./.15.) (4./.15.) 2 in
  let rec calc_pi acc n =
    if n=0 then acc else
      let rn = (float_of_int n)/.(float_of_int (n+n+1)) in
      calc_pi (x+.rn*.acc) (n-1) in
  calc_pi x max in

let pi = n_pi 1. in
let half_pi = n_pi 0.5 in

(*
let rec mycos_step1 x = 
  let quo = floor(x/.pi) in
  let x = x-.(n_pi quo) in
  let sgn = if floor(quo /. 2.)*.2.=quo then 1. else (-1.) in
  let sgn = if half_pi < x then -.sgn else sgn in
  let x = if half_pi < x then pi -. x else x in
  let x2 = x*.x in
  let rec ev_error x err n =
    if err < 0.000000001 then
      n+2
    else 
      let n1 =n+2 in
      let fn=float_of_int n in
      ev_error x (err/.((fn+.2.)*.(fn+.1.))*.x2) n1 in
  let max = ev_error x 1.0 0 in
  let rec calc_cos x acc n =
    if n=0 then acc
    else 
      let fn = float_of_int n in
      let acc1 = -.acc/.(fn*.(fn-.1.))*.x2 in
      calc_cos x (acc1+.1.) (n-2)
  in
  sgn*.calc_cos x 1.0 max in
 *)

let rec mycos_step1 x =
  if x > 1. then let c = mycos_step1 (x/.2.) in 2.*.c*.c-.1.
  else
    let rec calc_cos x acc n =
    if n=0 then acc
    else 
      let fn = float_of_int n in
      let acc1 = -.acc/.(fn*.(fn-.1.))*.x*.x in
      calc_cos x (acc1+.1.) (n-2)
  in
  calc_cos x 1.0 16 in

let rec mycos x =
  if x<0. then mycos_step1 (-.x) else mycos_step1 x in

(* 許容相対誤差 2^(-18) *)

let rec err_cos x = let s = cos x in (mycos x -. s)/.s in
let rec put_space x = print_char 9 in
let plus = 1.+.1./.8388608. in
let minus = 1.-.1./.8388608. in
let border = 1./.262144. in
(*
let rec main min max step =
  let s = cos min in
  let mys = mycos min in
  let es = err_cos min in
  let sp = cos (plus*.min) in
  let sm = cos (minus*.min) in 
  put_space ();
  print_float min;
  put_space ();
  print_float_e s;
  put_space ();
  print_float_e mys;
  put_space();
  print_float_e (abs_float es);
  put_space();
  print_float_e sp;
  put_space();
  print_float_e sm;
  print_newline();
  if (min+.step)<=max then main (min+.step) max step else () in
 *)
let rec main min max step =
  if min >= max then print_char 33
  else
    let s  = cos min in
    let mys = mycos min in
    if abs_float(s-.mys)<border then main (min+.step) max step
    else
      let sp = cos (plus*.min) in
      let sm = cos (minus*.min) in
      let (l,r) = if sp>sm then (sm,sp) else (sp,sm) in
      if (l-.border*.s)<mys then
        if (r+.border*.s)>mys then main (min+.step) max step
        else print_float min
      else print_float min
in
main 3.1 3.2 0.000001
