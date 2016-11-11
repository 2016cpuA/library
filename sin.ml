(* calculate pi with Euler's formula of arctan *)
let rec n_pi n =
  let x = 2.*.n in
  let rec ev_err_pi acc n =
    if acc < 0.000000001 then n
    else
      let rn = (float_of_int n)/.(float_of_int (n+n+1)) in
      ev_err_pi (acc *. rn) (n+1) in
  let max = ev_err_pi (4./.15.) 2 in
  let rec calc_pi acc n =
    if n=0 then acc else
      let rn = (float_of_int n)/.(float_of_int (n+n+1)) in
      calc_pi (x+.rn*.acc) (n-1) in
  calc_pi x max in

let pi = 3.1415926536 in
let half_pi = 1.5707963265 in
let rec cos x =
  let x = if x<0. then -.x else x in
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

let rec sin x =
  let sgn = if x<0. then -1. else 1. in
  let x = if x<0. then -.x else x in
  let quo = floor(x/.pi) in
  let x = x-.(n_pi quo) in
  let sgn = if floor(quo /. 2.)*.2.=quo then sgn else -.sgn in
  let x = if half_pi < x then pi -. x else x in
  let x2 = x*.x in
  let rec ev_error x err n =
    if err < 0.000000001 then
      n+2
    else
      let n1=n+2 in
      let fn = float_of_int n in
      ev_error x (err /.((fn+.2.)*.(fn+.1.))*.x2) n1 in
  let max = ev_error x (1.0) 1 in 
  let rec calc_sin x acc n =
    if n=1 then acc
    else 
      let fn = float_of_int n in
      let acc1 = -.acc/.(fn*.(fn-.1.))*.x2 in
      calc_sin x (acc1+.x) (n-2)
  in
  sgn*.calc_sin x x max in

let rec atan x =
  let sgn = x<0. in
  let x = if sgn then -.x else x in
  let flag = 1.<x in
  let x = if flag then 1./.x else x in
  let x2 = x*.x in
  let z = x2 /. (1.+.x2) in
  let a0 = x /. (1.+.x2) in
  let rec ev_error err n =
    if err < 0.000000001 then
      n+1
    else
      let n1=n+1 in
      ev_error (err*.(float_of_int (n+n))/.(float_of_int (n+n+1))*.z) n1 in
  let max = ev_error a0 0 in
  let rec calc_atan a0 z acc n=
    if n=0 then acc
    else 
      let acc1 = acc*.(float_of_int (n+n))/.(float_of_int (n+n+1))*.z in
      calc_atan a0 z (acc1+.a0) (n-1)
  in
  let mid =if flag then half_pi -. calc_atan a0 z a0 max else calc_atan a0 z a0 max in
  if sgn then -.mid else mid in
print_float sin 1.0
