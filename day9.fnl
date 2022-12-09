(local input-file :./inputs/day9ex.txt)
;; (local pprint vim.pretty_print)
(local fennel (require :bulb.fennel))
(fn pprint [...]
  (print (fennel.view [...])))

(fn part1 []
  (fn is-touching [H T]

    )
  (let [H {:x 0 :y 0}
T {:x 0 :y 0}

          ]

(each [line (io.lines input-file)]
  (let [(dir count) (string.match line "(%a) (%d)")
        count (tonumber count)
        visited [] ;; array to store our visited coordinate pairs
        ]
    (pprint {: dir : count})
    (for [_ 1 count 1]

    (match dir
      :R (tset H :x (+ H.x 1))
      :L (tset H :x (- H.x 1))
      :D (tset H :y (- H.y 1))
      :U (tset H :y (+ H.y 1))
      )
      )

    )



    

  )))

;; if we're 1 away from H, then do nothin
;; if we're more than 1 away from H, move to the closest spot to H
