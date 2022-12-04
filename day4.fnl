(local input-file :./inputs/day4ex.txt)

(fn part-1 []
  (fn get-range [assignment]
    "parse input lines into ranges"
    (let [(fmin fmax smin smax) (assignment:match "^(%d+)-(%d+),(%d+)-(%d+)")]
      {:first {:max (tonumber fmax) :min (tonumber fmin)}
       :second {:max (tonumber smax) :min (tonumber smin)}}))

  (lambda check-elves [first second]
    (or (and (<= first.max second.max) (>= first.min second.min))
        (and (<= second.max first.max) (>= second.min first.min))))

  (with-open [f (io.open input-file :r)]
    (-> (accumulate [overlaps 0 line (f:lines)]
          (let [{: first : second} (get-range line)]
            (if (check-elves first second)
                (+ overlaps 1)
                overlaps)))
        (print))))

(part-1)
