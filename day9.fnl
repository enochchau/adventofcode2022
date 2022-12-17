(local input-file :./inputs/day9ex.txt)
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

(fn move-head [H dir]
  (match dir
    :R (tset H :x (+ H.x 1))
    :L (tset H :x (- H.x 1))
    :D (tset H :y (- H.y 1))
    :U (tset H :y (+ H.y 1))))

(fn move-tail [H T dir]
  (match dir
    :R (do
         (tset T :x (- H.x 1))
         (tset T :y H.y))
    :L (do
         (tset T :x (+ H.x 1))
         (tset T :y H.y))
    :D (do
         (tset T :x H.x)
         (tset T :y (+ H.y 1)))
    :U (do
         (tset T :x H.x)
         (tset T :y (- H.y 1)))))

(fn hash [T]
  (string.format "%d,%d" T.x T.y))

(fn parse []
  (icollect [line (io.lines input-file)]
    (let [(dir count) (string.match line "(%a) (%d+)")]
      {: dir :count (tonumber count)})))

(fn part1 []
  (fn step [H T dir]
    (move-head H dir)
    (if (not (is-touching H T))
        (move-tail H T dir)))

  (let [H {:x 0 :y 0}
        T {:x 0 :y 0}
        visited {} ;; set to store our visited coordinates
        ]
    (each [_ {: dir : count} (ipairs (parse))]
      (for [_ 1 count 1]
        (step H T dir)
        (tset visited (hash T) true)))
    (tlen visited)))

(fn part2 []
  (let [rope []
        visited {}]
    (for [_ 1 9 1]
      (table.insert rope {:x 0 :y 0}))
    (each [_ {: dir : count} (ipairs (parse))]
      (for [_ 1 count 1]
        (let [Hlast {:x (. rope 1 :x) :y (. rope 1 :y)}]
          (move-head (. rope 1) dir)
          (for [i 2 9 1]
            (let [H (. rope (- i 1))
                  T (. rope i)
                  Tlast {:x T.x :y T.y}]
              (if (not (is-touching H T))
                  (do
                    (tset T :x Hlast.x)
                    (tset T :y Hlast.y)
                    (tset Hlast :x Tlast.x)
                    (tset Hlast :y Tlast.y)))
              (if (= i 9) (tset visited (hash T) true)))))
        ))
    (pprint visited)
    (tlen visited)))

;; (print :part1 (part1))
(print :part2 (part2))

;; if we're 1 away from H, then do nothin
;; if we're more than 1 away from H, move to the closest spot to H
