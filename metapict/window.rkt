#lang racket/base
;;; A Window is represented as:
;;;   (struct window (minx maxx miny maxy) #:transparent)
;;; Conceptually a window represents a rectangular shaped part of the coordinate plane.

(require racket/contract/base racket/format)
(provide
 with-window         ; (with-window win body ...) evaluate bodies with win as curve-pict-window
 with-scaled-window  ; (with-scaled-window k body ...) eval bodies with curve-pict-window scaled k
 window/aspect  ; (window/aspect xmin xmax [ymin #f] [aspect #f]) create window using optional aspect
 window-opposite-corners   ; return two values: lower left and upper right pts of the window
 (contract-out
  [window-overlap? (-> window? window?  boolean?)] ; do the windows overlap?
  [window-center   (-> window?          pt?)]      ; return pt in center
  [pt-in-window?   (-> pt? window?      boolean?)] ; is the pt inside or on the edge of the window?
  [scale-window    (-> real? window?    window?)]  ; scale both x- and y-range
  ))

(require "def.rkt" "structs.rkt" "pt-vec.rkt" "device.rkt"
         (for-syntax racket/base syntax/parse) racket/match)

(define (window-opposite-corners win)
  (defm (window x- x+ y- y+) win)
  (values (pt x- y-) (pt x+ y+)))
  

(define (scale-window k win)
  (defm (window a b c d) win)
  (window (* k a) (* k b) (* k c) (* k d)))

(define (window-overlap? w1 w2)
  (defm (window x- x+ y- y+) w1)
  (defm (window r- r+ s- s+) w2)
  (not (or (< x+ r-)    ; w1 left of w1 
           (< r+ x-)    ; w2 left of w1
           (< y+ s-)    ; w1 below w2
           (< s+ y-)))) ; w2 below w1

(define (window-center w)
  (defm (window x- x+ y- y+) w)
  (med 1/2 (pt x- y-) (pt x+ y+)))

(define (pt-in-window? p w)
  (defm (pt x y) p)
  (defm (window xmin xmax ymin ymax) w)
  (and (<= xmin x xmax)
       (<= ymin y ymax)))

(define (window/aspect xmin xmax [ymin #f] [aspect #f])
  (match (list ymin aspect)
    [(list #f   #f) (window/aspect xmin xmax xmin #f)]
    [(list ymin #f) (def w (curve-pict-width))
                    (def h (curve-pict-height))
                    (def aspect (/ w h))
                    (window/aspect xmin xmax ymin aspect)]
    [_ (def dx (- xmax ymin))
       (def dy (/ dx aspect))
       (def ymax (+ ymin dy))
       (window xmin xmax ymin ymax)]))

(module+ test (require rackunit)
  (def w (window 2 4 6 10))
  (check-equal? (window-center w) (pt 3 8))
  (check-true   (pt-in-window? (pt 2 6) w))
  (check-true   (pt-in-window? (pt 3 8) w))
  (check-true   (pt-in-window? (pt 4 10) w))
  (check-false  (pt-in-window? (pt 5 7) w))
  (check-equal? (scale-window 2 w) (window 4 8 12 20)))

(define-syntax (with-window stx)
  (syntax-parse stx 
    [(_ win e ...)
     #'(let ([w win])
         (defm (window xmin xmax ymin ymax) w)
         (when (= xmin xmax) 
           (raise-syntax-error 
            'with-syntax (~a "empty x-range for window, got: " xmin "," xmax) win))
         (when (= ymin ymax) 
           (raise-syntax-error 
            'with-syntax (~a "empty y-range for window, got: " ymin "," ymax) win))
         (parameterize ([curve-pict-window w]) e ...))]))

(define-syntax (with-scaled-window stx)
  (syntax-parse stx [(_ k e ...) #'(with-window (scale-window k (curve-pict-window)) e ...)]))
