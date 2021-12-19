(ns day18)

(use 'clojure.java.io)
(require '[clojure.string :as str])
(require '[clojure.core.reducers :as r])
(use '[clojure.test :only [is]])

(defrecord Pair [left right])
(defrecord Element [elem depth uid])

(defn element
  "Creates a new element from a value and assigns a uuid"
  [val depth]
      (->Element val depth (java.util.UUID/randomUUID)))

(defn pair
  "Creates a new pair"
  [a deptha b depthb]
  (->Pair (element a deptha) (element b depthb)))

(defn is-pair? [a]
  (instance? day18.Pair a))

(defn is-element? [a]
  (instance? day18.Element a))

;; (defn snailfish-reduce [reduction-list num-list]
;;   (r/reduce 
;;    (fn [acc elem] (if (vector? elem)
;;                     (conj acc (snailfish-reduce reduction-list elem))
;;                     (conj acc elem))) 
;;    [] 
;;    num-list))

;; (defn reduction-check [depth num-list]
;;   (r/reduce
;;    (fn [acc elem] (if (vector? elem)
;;                     (conj acc (reduction-check (+ depth 1) elem))
;;                     (conj acc (->Pair (int elem) depth))))
;;    []
;;    num-list))

;; (defn create-reduction-check-map [combined-input]
;;   (flatten (reduction-check 0 combined-input)))

;; (defn safe-pop [vec]
;;   (if (empty? vec)
;;     []
;;     (pop vec)))

;; (defn explode [prev-elem first-elem second-elem next-elem]
;;   (flatten (conj (if (empty? prev-elem) [] (->Pair (+ (:elem prev-elem) (:elem first-elem)) (:depth prev-elem)))
;;         (if (empty? next-elem) [] (->Pair (+ (:elem next-elem) (:elem second-elem)) (:depth next-elem))))
;; ))

;; (defn first-and-rest [vec]
;;   (let [[first-vec rest-vec] (split-at 1 vec)]
;;     (if (empty? first-vec) nil (list (first first-vec) rest-vec))))

;; (defn update-reduction-map [reduction-map updated-map]
;;   (let [[first-elem rest-elems-inter] (first-and-rest reduction-map)
;;         [second-elem rest-elems-iter2] (first-and-rest rest-elems-inter)
;;         [thrid-elem rest-elems] (first-and-rest rest-elems-iter2)
;;         last-elem (peek updated-map)
;;         without-last (safe-pop updated-map)]
;;     (println reduction-map)
;;     (cond
;;       (empty? reduction-map) updated-map
;;       (= (:depth first-elem) 4) (update-reduction-map rest-elems (conj without-last (explode last-elem first-elem second-elem thrid-elem)))
;;       :else (update-reduction-map rest-elems-inter (conj updated-map first-elem)))))

(defn explode [binary-tree]
  0)
  ;; (println "Explode")
  ;; (println binary-tree))

(defn snailfish-reduce [binary-tree val-list depth]
  ;; (println "snailfish-reduce")
  ;; (println binary-tree)
  ;; (println depth)
  (if (= depth 2)
    (cond 
      (not (number? (:left binary-tree))) (explode (:left binary-tree))
      (not (number? (:right binary-tree))) (explode (:right binary-tree))
      )
    (->Pair (snailfish-reduce (:left binary-tree) val-list (+ depth 1)) (snailfish-reduce (:right binary-tree) val-list (+ depth 1)))))

(defn create-list-of-numbers [elem]
  (cond
    (and (is-pair? (:left elem)) (is-pair? (:right elem))) (list (create-list-of-numbers (:left elem)) (create-list-of-numbers (:right elem)))
    (is-pair? (:left elem)) (list (create-list-of-numbers (:left elem)) (:right elem))
    (is-pair? (:right elem)) (list (:left elem) (create-list-of-numbers (:right elem)))
    :else (list (:left elem) (:right elem))))

(defn convert-to-binary-tree [depth elem]
  (cond
    (and (vector? (get elem 0)) (vector? (get elem 1))) (->Pair (convert-to-binary-tree (+ depth 1) (get elem 0)) (convert-to-binary-tree (+ depth 1)(get elem 1)))
    (vector? (get elem 0)) (->Pair (convert-to-binary-tree (+ depth 1) (get elem 0)) (element (get elem 1) depth))
    (vector? (get elem 1)) (->Pair (element (get elem 0) depth) (convert-to-binary-tree (+ depth 1) (get elem 1)))
    :else (pair (get elem 0) depth (get elem 1) depth)))

(defn first-and-rest [vec]
  (let [[first-vec rest-vec] (split-at 1 vec)]
    (if (empty? first-vec) nil (list (first first-vec) rest-vec))))

(defn safe-pop [vec]
  (if (empty? vec)
    []
    (pop vec)))

(defn update-entry [elem reduction-list]
  (let [[first-elem rest-elems-inter] (first-and-rest reduction-list)]
    (if (= (:uid elem) (:uid first-elem))
      (conj (->Element (+ (:val elem) (:val first-elem)) (:depth first-elem) (:uid first-elem)) rest-elems-inter)
      (conj first-elem (update-entry elem rest-elems-inter)))))

(defn update-val-list [reduction-map]
  (let [[first-elem rest-elems-inter] (first-and-rest reduction-map)
        [second-elem rest-elems-iter2] (first-and-rest rest-elems-inter)
        [thrid-elem rest-elems] (first-and-rest rest-elems-iter2)]
    (println reduction-map)
    (cond
      (empty? reduction-map) []
      (= (:depth first-elem) 3) (update-val-list rest-elems (conj without-last (explode last-elem first-elem second-elem thrid-elem)))
      :else (update-val-list rest-elems-inter (conj updated-map first-elem)))))

(defn read-and-reduce [acc s]
  (let [new-list (read-string s)
        binary-tree (convert-to-binary-tree 0 new-list)
        updated-binary-tree (->Pair acc binary-tree)
        val-list (flatten (create-list-of-numbers updated-binary-tree))
        updated-val-list (update-val-list val-list)]
    (println "FINAL")
    (println val-list)
    (if (empty? acc)
        binary-tree
        (snailfish-reduce updated-binary-tree val-list 0))))

(defn read-file [file_name]
  (with-open [rdr (reader file_name)]
    (doall (r/reduce read-and-reduce [] (line-seq rdr))) ;; the doall is so we can return the object before the stream is closed as everything else is lazy
    ))

(defn -main
  [& args]
  (read-file "testInputSimple.txt"))
