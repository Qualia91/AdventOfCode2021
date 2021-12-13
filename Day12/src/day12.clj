(ns day12)

(use 'clojure.java.io)
(require '[clojure.string :as str])
(require '[clojure.core.reducers :as r])
(use '[clojure.test :only [is]])

(defrecord Pair [start end])

(defn pair
  "Creates a new pair from input string"
  [input_string]
  {:pre [(is (string? input_string)) (is (str/includes? input_string "-"))]}
  (let [split_input_string (str/split input_string #"-")]
    (if (= "start" (split_input_string 1))
              (->Pair (get split_input_string 1) (get split_input_string 0))
              (->Pair (get split_input_string 0) (get split_input_string 1)))))

(defrecord Route [route_list])

(defn route
  "Creates a new Route from a list of route points"
  [route_list]
    (->Route route_list))

(declare find-path)

(defn read-file [file_name]
  (with-open [rdr (reader file_name)]
    (doall (mapv pair (line-seq rdr))) ;; the doall is so we can return the object before the stream is closed as everything else is lazy
  )
)

(defn group-into-start-and-rest [pairs-list start-value]
  (group-by (fn [pair] (or (= start-value (:start pair)) (= start-value (:end pair)))) pairs-list))

(defn all-uppercase? [s]
  (= s (str/upper-case s)))

(defn find-path-iter [current-point pairs-list path-so-far can-we-visit-function]
  (if (all-uppercase? current-point)
      (find-path current-point pairs-list (conj path-so-far current-point) can-we-visit-function)
      (let
       [groups (group-into-start-and-rest pairs-list current-point)]
        (println current-point)
        (find-path current-point (get groups false) (conj path-so-far current-point) can-we-visit-function))
  )
)

(defn does-link-contain-point? [link point]
  (or (= point (:end link)) (= point (:start link))))

(defn get-end-point [link first-point]
  (if (= (:start link) first-point) (:end link) (:start link)))

;; https://stackoverflow.com/questions/3249334/test-whether-a-list-contains-a-specific-value-in-clojure
(defn in? 
  "true if coll contains elm"
  [coll elm]  
  (some #(= elm %) coll))

(defn can-we-vist? [current-point path-so-far]
  (if (all-uppercase? current-point)
    true
    (not (in? path-so-far current-point))
  )
)

(defn have-we-double-checked-a-small-cave? [path-so-far] 
  (if (empty? (reduce (fn [acc-set next-cave] 
                (if (all-uppercase? next-cave) 
                  acc-set 
                  (if (contains? acc-set next-cave) (reduced #{}) (conj acc-set next-cave))
                )
              ) #{} path-so-far
      ))   
    true
    false)
)

(defn can-we-vist-part-two? [current-point path-so-far]
  (if (all-uppercase? current-point)
    true
    (if (have-we-double-checked-a-small-cave? path-so-far)
      (not (in? path-so-far current-point))
      true)
    ))

(defn find-path [current-point pairs-list path-so-far can-we-visit-function]
  (if (= "end" current-point)
    (route (conj path-so-far "end"))
    (reduce
     (fn [result next-pair] (concat result (find-path (get-end-point next-pair current-point) pairs-list (conj path-so-far current-point) can-we-visit-function)))
     []
     (filter #(and (does-link-contain-point? % current-point) (can-we-visit-function current-point path-so-far)) pairs-list))
  )
)

(defn is-end? [pair]
  (= (:end pair) "end"))

(defn -main
  [& args]
  (let [groups (group-into-start-and-rest (read-file "input.txt") "start")]
    (count (reduce
     (fn [result start-pair] (concat result (find-path (:end start-pair) (get groups false) ["start"] can-we-vist-part-two?)))
     []
     (get groups true))))
)