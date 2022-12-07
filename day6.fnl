(local input-file :./inputs/day6ex.txt)
(local fennel (require :bulb.fennel))
(fn pprint [...]
  (print (fennel.view [...])))

(fn solver [framesize]
  (fn check [frame]
    (-> (accumulate [counts {} _ char (ipairs frame)]
          (do
            (tset counts char (+ 1 (or (. counts char) 0)))
            counts))
        (#(accumulate [found true _ c (pairs $1)]
            (and found (= c 1))))))

  (fn read-to-frame [frame get-char i]
    (let [char (get-char)]
      (if char
          (if (= (length frame) framesize)
              (if (check frame)
                  i
                  (do
                    (table.remove frame 1)
                    (table.insert frame char)
                    (read-to-frame frame get-char (+ 1 i))))
              (do
                (table.insert frame char)
                (read-to-frame frame get-char (+ i 1)))))))

  (with-open [f (io.open input-file :r)]
    (read-to-frame [] #(f:read 1) 0)))

(fn part1 []
  (print :Part1 (solver 4)))

(fn part2 []
  (print :Part2 (solver 14)))

(part1)
(part2)
