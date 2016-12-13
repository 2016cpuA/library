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

read_float ()
        
