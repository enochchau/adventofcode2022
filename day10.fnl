(local input-file :./inputs/day10.txt)
(local fennel (require :bulb.fennel))
(fn pprint [...]
  (print (fennel.view [...])))

(fn get-signal [cycle X]
  (pprint :signal {: cycle : X})
  (* X cycle))

(fn update-total [cycle X total]
  (if (= 0 (% (- cycle 20) 40)) (+ total (get-signal cycle X)) total))

(fn part1 []
  (var total 0)
  (var cycle 0)
  (var X 1)
  (each [line (io.lines input-file)]
    (match (line:sub 1 4)
      :noop (do
              (set cycle (+ 1 cycle))
              (set total (update-total cycle X total)))
      :addx (for [i 1 2 1]
              (set cycle (+ 1 cycle))
              (set total (update-total cycle X total))
              (if (= i 2) (set X (+ X (tonumber (line:sub 5))))))))
  total)

(print :part1 (part1))
