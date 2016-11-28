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

let rec mysin_step1 x =
(*  let dif = abs_float(half_pi+.x-.floor((half_pi+.x)/.pi)) in
  if dif<0.3 then  2.*.(mysin_step1 (x/.2.))*.(mycos_step1 (x/.2.))
  else *)
    let quo = floor(x/.pi) in
    let comx = x-.(n_pi quo) in
    let sgn = if int_of_float(quo /. 2.)*2=int_of_float(quo) then 1. else -1. in
    let x = if half_pi < comx then pi -. comx else comx in
    let x2 = x*.x in
    let x4 = x2*.x2 in
    let err_normal=(x*.(1.-.x2/.3.))*.0.000000001 in
    let rec ev_error x acc1 acc2 n =
      if acc1-.acc2 < err_normal then
        n
      else
        let n1=n+4 in
        let fn = float_of_int n in
        let acc1_ = acc1/.((fn+.4.)*.(fn+.3.)*.(fn+.2.)*.(fn+.1.))*.x4 in
        let acc2_ = acc2/.((fn+.6.)*.(fn+.5.)*.(fn+.4.)*.(fn+.3.))*.x4 in
        ev_error x acc1_ acc2_ n1 in
    let max = if err_normal=0. then 3 else ev_error x x (x*.x2/.3.) 3 in 
    let rec calc_sin x acc n =
      if n=1 then acc
      else 
        let fn = float_of_int n in
        let acc1 = -.acc/.(fn*.(fn-.1.))*.x2 in
        calc_sin x (acc1+.x) (n-2)
    in
    (sgn*.calc_sin x x max) in

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

let rec mysin_step1 x =
  if x > 0.5 then let s = mysin_step1 (x/.3.) in s*.(3.-.4.*.s*.s)
  else
    let rec calc_sin x acc n =
      if n=1 then acc
      else 
        let fn = float_of_int n in
        let acc1 = 1.-.acc/.(fn*.(fn-.1.))*.x in
        calc_sin x (acc1*.x) (n-2)
    in
    calc_sin x x 29 in

let rec mycos x =
  if x<0. then mycos_step1 (-.x) else mycos_step1 x in

let rec mysin x =
  if x<0. then -.mysin_step1 (-.x) else mysin_step1 x in


let rec myatan x =
  let sgn = x<0. in
  let x = if sgn then -.x else x in
  let flag = 1.<x in
  let x = if flag then 1./.x else x in
  let x2 = x*.x in
  let z = x2 /. (1.+.x2) in
  let a0 = x /. (1.+.x2) in
  let rec ev_error err n acc z=
    if err < 0.0000000001*.acc then
      n
    else
      let n1=n+1 in
      ev_error (err*.(float_of_int (n+n))/.(float_of_int (n+n+1))*.z) n1 (acc+.err) z in
  let max = ev_error a0 1 0. z in
  let rec calc_atan a0 z acc n=
    if n=0 then acc
    else 
      let acc1 = acc*.(float_of_int (n+n))/.(float_of_int (n+n+1))*.z in
      calc_atan a0 z (acc1+.a0) (n-1)
  in
  let mid =if flag then half_pi -. calc_atan a0 z a0 max else calc_atan a0 z a0 max in
  if sgn then -.mid else mid in
let rec err_sin x = let s = sin x in (mysin x -. s)/.s in
let rec err_cos x = let s = cos x in (mycos x -. s)/.s in
let rec err_atan x = let s = atan x in (myatan x -. s)/.s in

let rec put_space x = print_char 9 in
let rec main min max step =
  put_space ();
  print_float min;
  put_space ();
  print_float_e (atan min);
  put_space ();
  print_float_e (myatan min);
  put_space ();
  print_float_e (err_atan min);
  put_space();
  print_float_e (abs_float (err_atan min));
  print_newline();
  if (min+.step)<=max then main (min+.step) max step else () in
main (-7.) 7. 0.01


