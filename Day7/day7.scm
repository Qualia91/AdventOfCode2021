#lang sicp

;; http://community.schemewiki.org/?fold
(define (fold-right f init seq) 
  (if (null? seq) 
      init 
      (f (car seq) 
        (fold-right f init (cdr seq))))) 

(define (fold-left f init seq) 
  (if (null? seq) 
      init 
      (fold-left f 
                (f init (car seq)) 
                (cdr seq)))) 

; https://cs.gmu.edu/~white/CS363/Scheme/SchemeSamples.html
(define (binarysort L)
  (if (null? L) '()
     (traverse (btree L))
))

(define (btree L)
  (if (= (length L) 1) (leaf (car L))
        (binsert (btree (cdr L)) (car L))
  )
)

(define (binsert T A)     ; insert A into the tree
   (cond  ( (null? T) (leaf A) )        ; insert here
          ( (> (car T) A) (list (car T) 
                                (binsert (car (cdr T)) A)
                                (car (cdr (cdr T))))
           )  ; left subtree 
          ( else (list (car T)
                       (car (cdr T)) 
                       (binsert (car (cdr (cdr T))) A))     ; right subtree
          )
    )
)

(define (leaf A)          ; add a leaf to the tree (A ()())
   (list A '() '())
)

(define (traverse L)   ; output sorted list by traversing the tree 
  (cond ( (null? L) L)
        ( else
           (append (traverse (car (cdr L)))
                   (cons (car L)(traverse (car (cdr (cdr L))))))
        )
  )
)

(define (length L)
  (if (null? L) 0
     (+ 1 (length (cdr L)))
  )
)

;; Read a text file
(define (get-input-data file-name) (call-with-input-file file-name
  (lambda (input-port)
    (let loop ((x (read-char input-port)) (acc "") (tree '()))
      (cond 
        ((not (eof-object? x))
          (cond ((eq? x #\,) (loop (read-char input-port) "" (binsert tree (string->number acc))))
          (else  (loop (read-char input-port) (string-append acc (string x)) tree))))
        (else (binsert tree (string->number acc))))))))

(define data (get-input-data "input.txt"))

(define sorted-list (traverse data))

(define half-length (quotient (length sorted-list) 2))

(define (get-at-index in-list index)
  (if (null? in-list)
      -1
      (if (= index 0)
        (car in-list)
        (get-at-index (cdr in-list) (- index 1))
      )
  )
)

(define middle-value (get-at-index sorted-list half-length))


; calc fuel cost for this value
(define (find-fuel-cost center pos-list) 
  (fold-left (lambda (sum next-val) (+ sum (abs (- next-val center))))
    0
    pos-list))

(define middle-cost (find-fuel-cost middle-value sorted-list))

; find direction of travel
(define (find-direction in-middle in-cost) 
  (let ((lower (find-fuel-cost (- in-middle 1) sorted-list)) 
        (higher (find-fuel-cost (+ in-middle 1) sorted-list)))
    (cond 
      ((and (< in-cost higher) (< in-cost lower)) 0)
      ((< lower higher) -1)
      (else 1)
    )
  )
)

(define direction-of-travel (find-direction middle-value middle-cost))

; now find minumum
(define (find-min start-val pos-list direction start-cost)
  (let ((next-cost (find-fuel-cost (+ start-val direction) pos-list)))
    (if (and (< start-cost next-cost)) 
        start-cost
        (find-min (+ start-val direction) pos-list direction next-cost)
    )
  )
)

(if (eq? direction-of-travel 0)
  middle-cost
  (find-min (+ middle-value direction-of-travel) sorted-list direction-of-travel (find-fuel-cost (+ middle-value direction-of-travel) sorted-list))
)

;; work out all values for video
;(fold-left (lambda (sum next-val) (begin (display "\n") (display (find-fuel-cost next-val sorted-list))))
;    0
;    sorted-list)