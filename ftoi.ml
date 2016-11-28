let rec myftoi x =
  if x<0. then
    -myftoi (-.x)
  else
    let large = 2147483648. in
    if x>=large then 0
    else
      let rec distance a b = if a<b then b-.a else a-.b in
      let rec calc_floor x k =
        if x<1. then k 0 0.
        else
          let rec k_ z zf = if distance x (2.*.zf) < 1. then k (z+z) (2.*.zf)
                         else k (z+z+1) (2.*.zf+.1.)in
          calc_floor (x/.2.) k_ in
      let rec id x y = x in
      calc_floor x id
    in
    
let rec main min max acc step =
  if min>=max then print_char 47
  else
    let x = myftoi acc in
    if int_of_float acc = x then main (min+1) max (acc+.step) step
    else (print_float acc;print_char 32 ;print_int x) 
in
main 0 20000 (-100.0) 0.01

