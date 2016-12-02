let rec myftoi x =
  let rec calc_floor x =
        if x<1. then (0,0.)
        else
          let (zi,zf) = calc_floor (x/.2.) in
          let zf2=zf+.zf in
          if (if x<zf2 then zf2-.x else x-.zf2) < 1. then ((zi+zi),zf2)
          else ((zi+zi+1),(zf2+.1.)) in
  if x<0. then
    if x<= -.2147483648. then 0
    else let (i,_)=calc_floor (-.x) in -i 
  else
    if x>=2147483648. then 0
    else
      let(i,_)=calc_floor x in i 
    in
    
let rec main min acc =
  if min>=20000 then ()
  else if int_of_float acc = myftoi acc then main (min+1) (acc+.0.01)
  else ()
in
main 0 (-100.)

