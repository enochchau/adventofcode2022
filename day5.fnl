(local input-file :./inputs/day5.txt)
(local fennel (require :bulb.fennel))
(fn pprint [...]
  (print (fennel.view [...])))

(fn get-row [line]
  (let [row []]
    (for [i 1 (length line) 4]
      (let [box (string.match (string.sub line (+ i 1) (+ i 1)) "%a")]
        (table.insert row (or box 0))))
    row))

(fn get-matrix [iter]
  (let [matrix []]
    (each [line iter &until (string.match line "%d")]
      (table.insert matrix (get-row line)))
    matrix))

(fn configure-matrix [matrix]
  "Get it to look like the puzzle input"
  (let [swapped []]
    (for [col 1 (length (. matrix 1)) 1]
      (let [curr []]
        (table.insert swapped curr)
        (for [row (length matrix) 1 -1]
          (let [box (. matrix row col)]
            (if (not= box 0)
                (table.insert curr (. matrix row col)))))))
    swapped))

(fn atoi-arr [arr]
  (icollect [_ c (ipairs arr)]
    (tonumber c)))

(fn take-last [matrix]
  (accumulate [out "" _ row (ipairs matrix)]
    (.. out (. row (length row)))))

(fn part1 []
  (let [iter (io.lines input-file)
        matrix (configure-matrix (get-matrix iter))]
    (fn process [move from to]
      (for [_ 1 move]
        (table.insert (. matrix to) (table.remove (. matrix from)))))

    (each [line iter]
      (let [vals (-> [(string.match line "(%d+).*(%d+).*(%d+)")] (atoi-arr))]
        (if (not= nil (. vals 1))
            (process (unpack vals)))))
    (print (take-last matrix))))

(part1)

;; reading the puzzel input
;; 1 2 3 4 
;; [ X ] 
;; read 4 chars at a time
;; check if the 2nd char is a letter
;; if its a letter then add to matrix
;; if its a number then we're done
;;
;; parse the rest of the instructions
