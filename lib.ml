let rec fiszero x = x = 0.0 in
let rec fispos x = x > 0.0 in
let rec fisneg x = (x<0.0) in
let rec fneg x = -. x in
let rec fless x y = x < y in
let rec fhalf x = x *. 0.5 in
let rec fsqr x  = x*.x in

let rec abs_float x = if x<0. then -.x else x in
let rec fabs x = abs_float x in
