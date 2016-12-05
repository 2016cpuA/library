let arr_f = create_array 31 0. in


let rec myftoi x =
  let rec calc_floor x i=
        if x<1. then (arr_f.(i)<-0.;0)
        else
          let zi = calc_floor (x/.2.) (i+1) in
          let zf = arr_f.(i+1) in
          let zf2=zf+.zf in
          if (if x<zf2 then zf2-.x else x-.zf2) < 1. then (arr_f.(i)<-zf2;(zi+zi))
          else (arr_f.(i)<-zf2+.1.;(zi+zi+1)) in
  if x<0. then
    if x<= -.2147483648. then 0
    else -calc_floor (-.x) 0 
  else
    if x>=2147483648. then 0
    else
      calc_floor x 0
    in
    
let rec main min acc =
  if min>=100000 then ()
  else if int_of_float acc = myftoi acc then main (min+1) (acc+.0.01)
  else ()
in
main 0 (-100.)

