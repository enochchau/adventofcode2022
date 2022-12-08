(local input-file :./inputs/day7.txt)
(local pprint vim.pretty_print)

(fn part1 []
  (var stack [])

  (fn currdir []
    (table.concat stack "/"))

  (local dirs {})

  (fn proc-cd [line]
    (let [loc (line:sub 5)]
      (if (loc:match "%.%.") (table.remove stack)
          (loc:match "/") (set stack ["/"])
          (table.insert stack (loc:sub 2)))))

  ;; idk why we need another sub here

  (fn proc-ls []
    (tset dirs (currdir) {:dirs [] :files {}}))

  (fn proc-dir [line]
    (table.insert (. dirs (currdir) :dirs) (.. (currdir) "/" (line:sub 5))))

  (fn proc-file [line]
    (let [size (line:match "%d+")
          name (line:sub (+ 2 (length size)))]
      (tset (. dirs (currdir) :files) name (tonumber size))))

  (fn get-total [dir]
    (-> (accumulate [total 0 _ subdir (ipairs dir.dirs)]
          (+ total (get-total (. dirs subdir))))
        (#(accumulate [total $1 _ filesize (pairs dir.files)]
            (+ total filesize)))))

  (each [line (io.lines input-file)]
    (if (line:match "^%$ cd") (proc-cd line)
        (line:match "^%$ ls") (proc-ls line)
        (line:match :^dir) (proc-dir line)
        (line:match "^%d") (proc-file line)))
  (each [_ dir (pairs dirs)]
    (tset dir :total (get-total dir)))
  (accumulate [largest 0 _ dir (pairs dirs)]
    (if (<= dir.total 100000)
        (+ largest dir.total)
        largest)))

(pprint :part1 (part1))
nil
