(local input-file :./inputs/day9.txt)
;; (local pprint vim.pretty_print)
(local fennel (require :fennel))
(fn pprint [...]
  (print (fennel.view [...])))

(fn tlen [tbl]
  (accumulate [count 0 _ _ (pairs tbl)]
    (+ count 1)))

(fn is-touching [H T]
  (let [x (math.abs (- H.x T.x))
        y (math.abs (- H.y T.y))]
    (and (<= x 1) (<= y 1))))

(fn step [H T dir]
  (let [Hlast {:x 0 :y 0}]
    (tset Hlast :x H.x)
    (tset Hlast :y H.y)
    (match dir
      :R (tset H :x (+ H.x 1))
      :L (tset H :x (- H.x 1))
      :D (tset H :y (- H.y 1))
      :U (tset H :y (+ H.y 1)))
    ;; (pprint {:is-touching (is-touching H T)})
    (if (not (is-touching H T))
        (do
          (tset T :x Hlast.x)
          (tset T :y Hlast.y)))))

(fn part1 []
  (let [H {:x 0 :y 0}
        T {:x 0 :y 0}
        visited {} ;; set to store our visited coordinates
        ]
    (each [line (io.lines input-file)]
      (let [(dir count) (string.match line "(%a) (%d+)")
            count (tonumber count)]
        (for [_ 1 count 1]
          (step H T dir)
          (tset visited (string.format "%d,%d" T.x T.y) true)
          )))
    (tlen visited)))

(print :part1 (part1))

;; if we're 1 away from H, then do nothin
;; if we're more than 1 away from H, move to the closest spot to H
