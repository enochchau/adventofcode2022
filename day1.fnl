(local inspect (require :inspect))

(with-open [f (io.open :./inputs/day1.txt :r)]
  (-> (accumulate [v {:max 0 :curr 0} line (f:lines)]
        (match line
          "" (if (> v.curr v.max) {:max v.curr :curr 0} {:max v.max :curr 0})
          _ {:max v.max
             :curr (-> line
                       (tonumber)
                       (+ v.curr))}))
      (inspect)
      (print)))
