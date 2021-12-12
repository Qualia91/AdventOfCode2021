(ns day12)

(use 'clojure.java.io)
(require '[clojure.string :as str])

(defrecord Pair [start end])

(defn pair
  "Creates a new pair from input string"
  [input_string]
  {:pre [(string? input_string) (str/includes? input_string "-")]}
  (let [split_input_string (str/split input_string #"-")]
    (->Pair (get split_input_string 0) (get split_input_string 1))
  )
)

(defn read-file [file_name]
  (with-open [rdr (reader file_name)]
    (doall (mapv pair (line-seq rdr))) ;; the doall is so we can return the object before the stream is closed as everything else is lazy
  )
)

(defn find-path [start-pair pairs-list]
  (->>
   (println start-pair)
   (println pairs-list)
  )
)

(defn group-into-start-and-rest [pairs-list]
  (group-by (fn [pair] (= "start" (:start pair))) pairs-list))

(defn -main
  [& args]
  (let [groups (group-into-start-and-rest (read-file "testInput.txt"))]
    (map
     (fn [start-pair] (map (partial find-path start-pair) (get groups false)))
     (get groups true)
    )
  )
)