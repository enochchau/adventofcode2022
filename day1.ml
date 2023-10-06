open Printf

let file = "./inputs/day1.txt"
let input_line_opt ic = try Some (input_line ic) with End_of_file -> None

let read_input filename =
  let ic = open_in filename in

  let rec build l =
    match l with None -> [] | Some l -> l :: build (input_line_opt ic)
  in

  build (input_line_opt ic)

let rec calc_calories input calories curr_elf =
  match input with
  | [] -> curr_elf :: calories
  | x :: xs -> (
      match x with
      | "" -> calc_calories xs (curr_elf :: calories) 0
      | _ -> calc_calories xs calories (int_of_string x + curr_elf))

let () =
  let input = read_input file in
  let calories = calc_calories input [] 0 in
  let most_calories = List.fold_left max 0 calories in
  printf "part1: %d" most_calories
