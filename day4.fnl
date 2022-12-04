(local input-file :./inputs/day4.txt)

(fn get-range [assignment]
  "parse input lines into ranges"
  (let [(fmin fmax smin smax) (assignment:match "^(%d+)-(%d+),(%d+)-(%d+)")]
    {:first {:max (tonumber fmax) :min (tonumber fmin)}
     :second {:max (tonumber smax) :min (tonumber smin)}}))

(fn full-contains [first second]
  (or (and (<= first.max second.max) (>= first.min second.min))
      (and (<= second.max first.max) (>= second.min first.min))))

(fn solver [check-elves]
  (with-open [f (io.open input-file :r)]
    (accumulate [overlaps 0 line (f:lines)]
      (let [{: first : second} (get-range line)]
        (if (check-elves first second)
            (+ overlaps 1)
            overlaps)))))

(fn part-1 []
  (lambda check-elves [first second]
    (full-contains first second))
  (->> (solver check-elves) (print "Part 1:")))

(fn part-2 []
  (fn check-elves [f s]
    "returns true if elves are overlapping"
    ;; check first is less than second
    (or (full-contains f s) (and (>= f.max s.min) (< f.min s.min)
                                 (< f.max s.max))
        (and (>= s.max f.min) (< s.max f.max) (< s.min f.min))))

  (->> (solver check-elves) (print "Part 2:")))

(part-2)
