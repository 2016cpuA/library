let pi = 3.14159265359 in
let half_pi =1.5707963265 in

let rec fiszero x = x = 0.0 in
let rec fispos x = x > 0.0 in
let rec fisneg x = (x<0.0) in
let rec fneg x = -. x in
let rec fless x y = x < y in
let rec fhalf x = x *. 0.5 in
let rec fsqr x  = x*.x in

let rec abs_float x = if x<0. then -.x else x in
let rec fabs x = abs_float x in

let rec floor x =
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
let arr_f = create_array 31 0. in


let rec int_of_float x =
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

let rec sqrt x =
  if x<0. then 0.
  else if x=0. then x
  else
    let rec calc_sqrt x acc =
      let acc_ = 0.5*.(acc+.x/.acc) in
      if acc_=acc then acc
      else calc_sqrt x acc_ in
    calc_sqrt x (x*.0.5)
in

let rec mycos_step1 x =
  if x > 1. then let c = mycos_step1 (x/.2.) in 2.*.c*.c-.1.
  else
    let rec calc_cos x acc n =
    if n=0 then acc
    else 
      let fn = float_of_int n in
      let acc1 = -.acc/.(fn*.(fn-.1.))*.x*.x in
      calc_cos x (acc1+.1.) (n-2)
  in
  calc_cos x 1.0 16 in

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

let rec cos x =
  if x<0. then mycos_step1 (-.x) else mycos_step1 x in

let rec sin x =
  if x<0. then -.mysin_step1 (-.x) else mysin_step1 x in


let rec atan x =
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

let space = 32 in
let vtab = 9 in
let lf = 10 in
let cr = 13 in
let eof = 255 in
let zero = 48 in
let one = 49 in
let two = 50 in
let three = 51 in
let four = 52 in
let five = 53 in
let six = 54 in
let seven = 55 in
let eight = 56 in
let nine = 57 in
let minus = 45 in
let dot = 46 in
let null = 0 in

let space = ' ' in
let vtab = '\t' in
let lf = '\n' in
let cr = '\r' in
let zero = '0' in
let one = '1' in
let two = '2' in
let three = '3' in
let four = '4' in
let five = '5' in
let six = '6' in
let seven = '7' in
let eight = '8' in
let nine = '9' in
let minus = '-' in
let dot = '.' in
let eof = '\255' in
let null = '\000' in
let read_byte () = input_char stdin in


let rec read_token () =
  let buffer = Array.make 16 null in
  let rec make_token buffer i flag =
    let tmp = read_byte () in
    if tmp = space then
      if flag then i else make_token buffer i false
    else if tmp = vtab then
      if flag then i else make_token buffer i false
    else if tmp = lf then
      if flag then i else make_token buffer i false
    else if tmp = cr then
      if flag then i else make_token buffer i false
    else if tmp = eof then i
    else
      (buffer.(i) <- tmp;
       make_token buffer (i+1) true) in
  let len = make_token buffer 0 false in
  (buffer,len+1) in

let rec ten_times x =
  let dbl = x+x in
  let quad = dbl+dbl in
  let oct = quad+quad in
  dbl+oct in

let rec read_int () =
  let (token,len) = read_token () in
  let rec interpret token i len acc =
    if i < len then
      let tmp = token.(i) in
      if tmp=zero then interpret token (i+1) len (ten_times acc)
      else if tmp=one then interpret token (i+1) len (1+ten_times acc)
      else if tmp=two then interpret token (i+1) len (2+ten_times acc)
      else if tmp=three then interpret token (i+1) len (3+ten_times acc)
      else if tmp=four then interpret token (i+1) len (4+ten_times acc)
      else if tmp=five then interpret token (i+1) len (5+ten_times acc)
      else if tmp=six then interpret token (i+1) len (6+ten_times acc)
      else if tmp=seven then interpret token (i+1) len (7+ten_times acc)
      else if tmp=eight then interpret token (i+1) len (8+ten_times acc)
      else if tmp=nine then interpret token (i+1) len (9+ten_times acc)
      else acc
    else
      acc in
  if token.(0)=minus then -interpret token 1 len 0
  else interpret token 0 len 0 in

let rec read_float () =
  let (token,len) = read_token () in
  let rec interpret token i len acc adjust flag =
    if i < len then
      let tmp = token.(i) in
      if tmp=zero then
        interpret token (i+1) len (10.*. acc) (if flag then adjust *. 10. else adjust) flag
      else if tmp=one then interpret token (i+1) len (1.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=two then interpret token (i+1) len (2.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=three then interpret token (i+1) len (3.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=four then interpret token (i+1) len (4.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=five then interpret token (i+1) len (5.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=six then interpret token (i+1) len (6.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=seven then interpret token (i+1) len (7.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=eight then interpret token (i+1) len (8.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=nine then interpret token (i+1) len (9.+.acc*.10.)  (if flag then adjust *. 10. else adjust) flag
      else if tmp=dot then interpret token (i+1) len acc adjust true
      else acc /. adjust
    else
      acc in
  if token.(0)=minus then -.interpret token 1 len 0. 1. false
  else interpret token 0 len 0. 1. false in
()
