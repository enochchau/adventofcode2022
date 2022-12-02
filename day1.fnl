(fn sum-i [nums sum i imax]
  "Sum nums up to the index max"
  (if (> i imax) sum (sum-i nums (+ sum (. nums i)) (+ 1 i) imax)))

(with-open [f (io.open :./inputs/day1.txt :r)]
  (-> (let [res (accumulate [res {:totals [] :curr 0} line (f:lines)]
                  (match line
                    "" (do
                         (table.insert res.totals res.curr)
                         {:totals res.totals :curr 0})
                    _ {:totals res.totals
                       :curr (-> line
                                 (tonumber)
                                 (+ res.curr))}))]
        ;; push in the last value since the file doesn't end with a blank line
        (when (> res.curr 0)
          (table.insert res.totals res.curr))
        (table.sort res.totals #(> $1 $2))
        (-> res.totals
            (sum-i 0 1 3)
            (print)))))
