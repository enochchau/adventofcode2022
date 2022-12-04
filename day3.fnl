(local input-file :./inputs/day3.txt)

(fn split-sack [sack]
  (let [half (/ (length sack) 2)]
    (values (sack:sub 1 half) (sack:sub (+ half 1)))))

(fn str-to-set [str]
  (let [s {}]
    (str:gsub "." #(tset s $1 true))
    s))

(fn get-priority [c]
  (let [b (c:byte)]
    (if (>= b 97) (- b 96) (-> b (- 65) (+ 27)))))

(fn read-n-lines [get-next-line i n groupped]
  "get the next n lines, return nil if no lines left"
  (if (> i n)
      groupped
      (let [line (get-next-line)]
        (if (not= nil line)
            (do
              (table.insert groupped line)
              (read-n-lines get-next-line (+ 1 i) n groupped))
            nil))))

(fn part-1 []
  (with-open [f (io.open input-file :r)]
    (->> (accumulate [total 0 sack (f:lines)]
           (let [(fstr bstr) (split-sack sack)
                 front (str-to-set fstr)
                 back (str-to-set bstr)]
             (var c "")
             (each [fc _ (pairs front)]
               (when (. back fc)
                 (set c fc)))
             (-> c
                 (get-priority)
                 (+ total))))
         (print "Part 1:"))))

(fn part-2 []
  (with-open [f (io.open input-file :r)]
    (var total 0)
    (var grouped (read-n-lines #(f:read :*l) 1 3 []))
    (while (not= grouped nil)
      ;; (vim.pretty_print grouped)
      ;; convert strings to sets
      (each [i val (ipairs grouped)]
        (tset grouped i (str-to-set val)))
      ;; find commonality in sets
      (each [char _ (pairs (. grouped 1))]
        (when (and (. grouped 2 char) (. grouped 3 char))
          (set total (+ total (get-priority char)))))
      (set grouped (read-n-lines #(f:read :*l) 1 3 [])))
    (print "Part 2:" total)))

;; (part-1)
(part-2)
