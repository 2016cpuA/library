let rec mysqrt x =
  if x<0. then 0.
  else if x=0. then x
  else
    let rec calc_sqrt x acc =
      let acc_ = 0.5*.(acc+.x/.acc) in
      if acc_=acc then acc
      else calc_sqrt x acc_ in
    calc_sqrt x (x*.0.5)
in 

let rec main min max acc step =
  if min>=max then (print_char 47;print_newline())
  else
    let value = mysqrt acc in
    let truth = sqrt acc in
    if abs_float(value-. truth)<=1./.1048576.*.truth then
      main (min+1) max (acc+.step) step
    else
      print_float acc
in
main 0 100000 0. 1.
