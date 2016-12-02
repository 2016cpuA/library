(*
let rec myfloor x =
  if x<0. then
    let value= -.myfloor (-.x) in
    if x=value then x else value-.1.
  else
    let large = 16777216. in
    if x>=large then x
    else
      let rec distance a b = if a<b then b-.a else a-.b in
      let rec calc_floor x k =
        if x<1. then k 0.
        else
          let rec k_ z = if distance x (2.*.z) < 1. then k (2.*.z)
                         else k (2.*.z+.1.) in
          calc_floor (x/.2.) k_ in
      let rec id x = x in
      calc_floor x id
    in *)

let rec myfloor x =
  let rec calc_floor x =
        if x<1. then 0.
        else
          let result = calc_floor (x/.2.) in
          let dbl= result+.result in
          if (if x<dbl then dbl-.x else x-.dbl) < 1. then dbl
          else (dbl+.1.) in
  if x<0. then
    if x<= -.16777216. then x
    else let negx = -.x in
         let value = calc_floor negx in
         if negx=value then x else -.(value+.1.)
  else
    if x>=16777216. then x
    else
      calc_floor x 
    in  
let rec main min max acc step =
  if min>=max then print_char 47
  else
    let x = floor acc in
    if floor acc = x then main (min+1) max (acc+.step) step
    else (print_float acc;print_char 32 ;print_float x) 
in
main 0 20000 (-100.0) 0.01


