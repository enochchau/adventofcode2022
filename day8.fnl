(local input-file :./inputs/day8.txt)
;; (local pprint vim.pretty_print)
(local fennel (require :bulb.fennel))
(fn pprint [...]
  (print (fennel.view [...])))

(fn out-of-bounds [row col matrix]
  (or (< row 1) (> row (length matrix)) (< col 1)
      (> col (length (. matrix row)))))

(fn incr [val]
  (+ val 1))

(fn decr [val]
  (- val 1))

(fn same [val]
  val)

(fn read-matrix []
  (-> (accumulate [v {:matrix [] :i 1} line (io.lines input-file)]
        (do
          (table.insert v.matrix [])
          (for [i 1 (length line) 1]
            (table.insert (. v :matrix v.i) (tonumber (line:sub i i))))
          {:matrix v.matrix :i (+ 1 v.i)}))
      (. :matrix)))

(fn part1 []
  (fn dir [next-row next-col]
    (fn step [row col matrix height]
      (if (out-of-bounds row col matrix) true
          (if (< (. matrix row col) height)
              (step (next-row row) (next-col col) matrix height)
              false))))

  (local north (dir incr same))
  (local south (dir decr same))
  (local east (dir same incr))
  (local west (dir same decr))

  (fn check [row col matrix]
    (let [height (. matrix row col)]
      (or (north (+ row 1) col matrix height)
          (south (- row 1) col matrix height) (east row (+ col 1) matrix height)
          (west row (- col 1) matrix height))))

  (var count 0)
  (let [matrix (read-matrix)]
    (for [row 1 (length matrix) 1]
      (for [col 1 (length (. matrix row)) 1]
        (if (check row col matrix)
            (set count (+ 1 count))))))
  count)

(fn part2 []
  (fn dir [next-row next-col]
    (fn step [row col matrix height count]
      (if (out-of-bounds row col matrix)
          count
          (let [val (. matrix row col)]
            (if (< val height)
                (step (next-row row) (next-col col) matrix height (+ 1 count))
                (+ 1 count))))))

  (local north (dir incr same))
  (local south (dir decr same))
  (local east (dir same incr))
  (local west (dir same decr))

  (fn check [row col matrix]
    (let [height (. matrix row col)
          n (north (incr row) col matrix height 0)
          s (south (decr row) col matrix height 0)
          w (west row (decr col) matrix height 0)
          e (east row (incr col) matrix height 0)]
      (* n s w e)))

  (var best 0)
  (let [matrix (read-matrix)]
    (for [row 1 (length matrix) 1]
      (for [col 1 (length (. matrix row)) 1]
        (let [curr (check row col matrix)]
          (if (> curr best) (set best curr))))))
  best)

;; (pprint :part1 (part1))
(pprint :part2 (part2))
