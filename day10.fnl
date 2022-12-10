(local input-file :./inputs/day10.txt)
(local fennel (require :bulb.fennel))
(fn pprint [...]
  (print (fennel.view [...])))

(fn part1 []
  (fn get-signal [cycle X]
    (* X cycle))

  (fn update-total [cycle X total]
    (if (= 0 (% (- cycle 20) 40)) (+ total (get-signal cycle X)) total))

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

(fn part2 []
  (local screen [""])

  (fn get-cycle-i [cycle]
    (- cycle (* (- (length screen) 1) 40)))

  (fn sprite? [X cycle]
    ;; subtract 1 b/c cycle drawing is zero indexed
    (let [cycle-i (- (get-cycle-i cycle) 1)]
      (and (>= cycle-i (- X 1)) (<= cycle-i (+ X 1)))))

  (fn push-screen [cycle]
    (when (= (% cycle 40) 0)
      (table.insert screen "")))

  (fn draw [X cycle]
    (print :sprite? (sprite? X cycle) X (get-cycle-i cycle))
    (tset screen (length screen)
          (.. (. screen (length screen)) (if (sprite? X cycle) "#" "."))))

  (var cycle 0)
  (var X 1)
  (each [line (io.lines input-file)]
    (print line)
    (match (line:sub 1 4)
      :noop (do
              (set cycle (+ 1 cycle))
              (draw X cycle)
              (push-screen cycle))
      :addx (for [i 1 2 1]
              (set cycle (+ 1 cycle))
              (draw X cycle)
              (push-screen cycle)
              (if (= i 2) (set X (+ X (tonumber (line:sub 5))))))))
  screen)

(print :part1 (part1))
(pprint :part2 (part2))
