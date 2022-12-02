(fn get-play [round]
  (round:match "(%a) (%a)"))

(fn get-outcome [elf me]
  (if (and (= :A elf) (= :X me)) 3 ;; elf plays rock
      (and (= :A elf) (= :Y me)) 6
      (and (= :A elf) (= :Z me)) 0
      (and (= :B elf) (= :X me)) 0 ;; elf plays paper
      (and (= :B elf) (= :Y me)) 3
      (and (= :B elf) (= :Z me)) 6
      (and (= :C elf) (= :X me)) 6 ;; elf plays scissors
      (and (= :C elf) (= :Y me)) 0
      (and (= :C elf) (= :Z me)) 3))

(fn get-hand [me]
  (match me
    :X 1
    :Y 2
    :Z 3))

(fn get-outcome-2 [me]
  (match me
    :X 0
    :Y 3
    :Z 6))

(fn get-hand-2 [elf me]
  (if (and (= :A elf) (= :X me)) 3 ;; I must lose
      (and (= :B elf) (= :X me)) 1 
      (and (= :C elf) (= :X me)) 2
      (and (= :A elf) (= :Y me)) 1 ;; I must draw
      (and (= :B elf) (= :Y me)) 2
      (and (= :C elf) (= :Y me)) 3
      (and (= :A elf) (= :Z me)) 2 ;; I must win
      (and (= :B elf) (= :Z me)) 3
      (and (= :C elf) (= :Z me)) 1))

(fn get-score [elf me]
  (+ (get-outcome-2 me) (get-hand-2 elf me)))

(with-open [f (io.open :./inputs/day2.txt :r)]
  (-> (accumulate [score 0 line (f:lines)]
        (let [(elf me) (get-play line)]
          (+ score (get-score elf me))))
      (print)))
