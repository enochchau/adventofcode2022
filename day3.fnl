(local input-file :./inputs/day3.txt)

(fn str-to-set [str]
  (let [s {}]
    (str:gsub "." #(tset s $1 true))
    s))

(fn get-priority [c]
  (let [b (c:byte)]
    (if (>= b 97) (- b 96) (-> b (- 65) (+ 27)))))

(fn part-1 []
  (fn split-sack [sack]
    (let [half (/ (length sack) 2)]
      (values (sack:sub 1 half) (sack:sub (+ half 1)))))

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

  (fn str-arr-to-set-arr [arr]
    "transform array of strings to array of sets"
    (each [i val (ipairs arr)]
      (tset arr i (str-to-set val)))
    arr)

  (fn get-total [total get-group]
    (let [group (get-group)]
      (if (= group nil) total
          (do
            ;; find commonality in sets
            (-> (let [group (str-arr-to-set-arr group)]
                  (accumulate [local-total 0 char _ (pairs (. group 1))]
                    (if (and (. group 2 char) (. group 3 char))
                        (get-priority char)
                        local-total)))
                (+ total)
                (get-total get-group))))))

  (with-open [f (io.open input-file :r)]
    (let [get-next-line #(f:read :*l)]
      (->> (get-total 0 #(read-n-lines get-next-line 1 3 []))
           (print "Part 2:")))))

(part-1)
(part-2)
