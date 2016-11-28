let rec mysqrt x =
  if x<0. then 0./.0.
  else if x=0. then 0.
  else
    let rec calc_sqrt x acc =
      let acc_ = 0.5*.(acc+.x/.acc) in
      if acc_=acc then acc
      else calc_sqrt x acc_ in
    calc_sqrt x x
in

let rec main min max acc step =
  if min>=max then (print_char 31;print_newline())
  else
    let value = mysqrt acc in
    if value = sqrt acc then
      main (min+1) max (acc+.step) step
    else
      (print_float acc;
       print_char 9;
       print_float value;
       print_char 9;
       print_float (sqrt acc);
       print_char 9;
       print_float_e (value-.sqrt acc);
       print_newline ();
      main (min+1) max (acc+.step) step)
in
main 0 10000 0. 0.1
