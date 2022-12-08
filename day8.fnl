(local input-file :./inputs/day8.txt)
(local pprint vim.pretty_print)

(fn out-of-bounds [row col matrix]
  (or (< row 1) (> row (length matrix)) (< col 1)
      (> col (length (. matrix row)))))

(fn dir [next-row next-col]
  (fn step [row col matrix height]
    (if (out-of-bounds row col matrix) true
        (if (< (. matrix row col) height)
            (step (next-row row) (next-col col) matrix height)
            false))))

(fn incr [val] (+ val 1))
(fn decr [val] (- val 1))
(fn same [val] val)

(local north (dir incr same))
(local south (dir decr same))
(local east (dir same incr))
(local west (dir same decr))

(pprint {: north : south : east : west})

(fn read-matrix []
  (-> (accumulate [v {:matrix [] :i 1} line (io.lines input-file)]
        (do
          (table.insert v.matrix [])
          (for [i 1 (length line) 1]
            (table.insert (. v :matrix v.i) (tonumber (line:sub i i))))
          {:matrix v.matrix :i (+ 1 v.i)}))
      (. :matrix)))

(fn check [row col matrix]
  (let [height (. matrix row col)]
    (or (north (+ row 1) col matrix height) (south (- row 1) col matrix height)
        (east row (+ col 1) matrix height) (west row (- col 1) matrix height))))

(fn part1 []
  (var count 0)
  (let [matrix (read-matrix)
        visiblity (read-matrix)]
    (for [row 1 (length matrix) 1]
      (for [col 1 (length (. matrix row)) 1]
        (if (check row col matrix)
            (do
              (tset (. visiblity row) col true)
              (set count (+ 1 count))))))
    (pprint matrix)
    (pprint visiblity))
  count)

(pprint :part1 (part1))

;; check that all the trees around a tree is visible
