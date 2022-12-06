(local input-file :./inputs/day6.txt)
(local fennel (require :bulb.fennel))
(fn pprint [...]
  (print (fennel.view [...])))

(fn solver [framesize]
  (fn check [frame]
    (let [counts (accumulate [counts {} _ char (ipairs frame)]
                   (do
                     (tset counts char
                           (if (not= (. counts char) nil)
                               (+ (. counts char) 1)
                               1))
                     counts))]
      (not (accumulate [found false _ c (pairs counts)]
             (or found (> c 1))))))

  (let [frame []]
    (with-open [f (io.open input-file :r)]
      (do
        (var char (f:read 1))
        (var i 0)
        (while (not= char nil)
          (if (= (length frame) framesize)
              (do
                (if (check frame)
                    (do
                      (print i)
                      (lua :return)))
                (table.remove frame 1)
                (table.insert frame char))
              (table.insert frame char))
          (set char (f:read 1))
          (set i (+ i 1)))))))

(fn part1 []
  (print :Part1)
  (solver 4))

(fn part2 []
  (print :Part2)
  (solver 14))

(part1)
(part2)
