(local input-file :./inputs/day2.txt)

;; [elf me score]

(macro check-turn [elf me permutations]
  (fn step [i]
    (let [p (. permutations i)]
      (if (<= i (length permutations))
          `(if (and (= elf ,(. p 1)) (= me ,(. p 2))) ,(. p 3) ,(step (+ i 1))))))

  (step 1))

(fn get-play [round]
  (round:match "(%a) (%a)"))

(fn solver [get-outcome get-hand]
  (fn get-score [elf me]
    (+ (get-outcome elf me) (get-hand elf me)))

  (with-open [f (io.open input-file :r)]
    (accumulate [score 0 line (f:lines)]
      (-> (get-play line)
          (get-score)
          (+ score)))))

(fn part-1 []
  (fn get-outcome [elf me]
    (check-turn elf me [;; elf plays rock
                        [:A :X 3]
                        [:A :Y 6]
                        [:A :Z 0]
                        ;; elf plays paper
                        [:B :X 0]
                        [:B :Y 3]
                        [:B :Z 6]
                        ;; elf plays scissors
                        [:C :X 6]
                        [:C :Y 0]
                        [:C :Z 3]]))

  (fn get-hand [elf me]
    (match me
      :X 1
      :Y 2
      :Z 3))

  (print "part 1:" (solver get-outcome get-hand)))

(fn part-2 []
  (fn get-outcome [elf me]
    (match me
      :X 0
      :Y 3
      :Z 6))

  (fn get-hand [elf me]
    (check-turn elf me [;; I lose
                        [:A :X 3]
                        [:B :X 1]
                        [:C :X 2]
                        ;; I draw
                        [:A :Y 1]
                        [:B :Y 2]
                        [:C :Y 3]
                        ;; I win
                        [:A :Z 2]
                        [:B :Z 3]
                        [:C :Z 1]]))

  (print "part 2:" (solver get-outcome get-hand)))

(part-1)
(part-2)
