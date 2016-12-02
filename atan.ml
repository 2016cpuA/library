(* 許容相対誤差 2^(-20): cleared. *)
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

    let rec err_atan x = let s = atan x in (myatan x -. s)/.s in

    let rec put_space x = print_char 9 in
let float_eps = 1./.8388608. in
let plus = 1.+.float_eps in
let minus = 1.-.float_eps in
let rec main min max step =
  let s = atan min in
  let mys = myatan min in
  let es = err_atan min in
  let sp = atan (plus*.min) in
  let sm = atan (minus*.min) in 
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
main (-7.) 7. 0.01

