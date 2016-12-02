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
let rec mysin_step1 x =
    let quo = floor(x/.pi) in
    let comx = x-.(n_pi quo) in
    let sgn = if floor(quo /. 2.)*.2.=quo then 1. else -1. in
    let narrx = if half_pi < comx then pi -. comx else comx in
    let x = narrx in
    let x2 = x*.x in
    let x4 = x2*.x2 in
    let acc_init=(x*.(1.-.x2/.3.)) in
    let rec ev_error err acc n =
      if err < acc*.0.000000001 then
        n
      else
        let n1=n+4 in
        let fn = float_of_int n in
        let err1 = err/.((fn+.2.)*.(fn+.1.))*.x2 in
        let err2 = err1/.((fn+.4.)*.(fn+.3.))*.x2 in
        ev_error err2 (acc+.err-.err1) n1 in
    let max = if acc_init=0. then 3 else ev_error acc_init (x*.x4/.120.) 5 in 
    let rec calc_sin x acc n =
      if n=1 then acc
      else 
        let fn = float_of_int n in
        let acc1 = -.acc/.(fn*.(fn-.1.))*.x2 in
        calc_sin x (acc1+.x) (n-2)
    in
    let n = max in
    (sgn*.calc_sin x x n) in

 *)

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

    calc_sin x x 17 in

(*let rec mysin_step1 x =
  let z = x/.pi in
  let z2 = z*.z in
  let rec calc_sin acc n =
    let nf = float_of_int(n) in
    let nf2 = nf *. nf in
    if abs_float(z2/.nf2-.1.) < 0.1
    then
      let acc1 =acc*.(nf2-.z2)/.nf2 in
      if acc1 = acc then acc else calc_sin acc1 (n+1)

    else
      let acc1 =acc*.(1.-.z2/.nf2) in
      if acc1 = acc then acc else calc_sin acc1 (n+1)
  in
  calc_sin x 1 in
 *)


let rec mysin x =
  if x<0. then -.mysin_step1 (-.x) else mysin_step1 x in



let rec err_sin x = let s = sin x in (mysin x -. s)/.s in


let rec put_space x = print_char 9 in
let plus = 1.+.1./.8388608. in
let minus = 1.-.1./.8388608. in
let border = 1./.262144. in
(*
let rec main min max step =
  let s = sin min in
  let mys = mysin min in
  let es = err_sin min in
  let sp = sin (plus*.min) in
  let sm = sin (minus*.min) in 
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
    let s  = sin min in
    let mys = mysin min in
    if abs_float(s-.mys)<border then main (min+.step) max step
    else
      let sp = sin (plus*.min) in
      let sm = sin (minus*.min) in
      let (l,r) = if sp>sm then (sm,sp) else (sp,sm) in
      if (l-.border*.s)<mys then
        if (r+.border*.s)>mys then main (min+.step) max step
        else print_float min
      else print_float min
in
main 3.1 3.2 0.00001


