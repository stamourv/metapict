#lang racket
(provide (all-defined-out))

; shorter names
(define-syntax defv (make-rename-transformer #'define-values))
(define-syntax defm (make-rename-transformer #'match-define))
(define-syntax def  (make-rename-transformer #'define))

; short names for multiples of pi
(defm (list -pi -3pi/4 -pi/2 -pi/4 _ pi/4 pi/2 3pi/4) (for/list ([n (in-range -1   1 1/4)]) (* pi n)))
(defm (list -π -3π/4 -π/2 -π/4 _ π/4 π/2 3π/4 π)      (for/list ([n (in-range -1 5/4 1/4)]) (* pi n)))
(defm (list 2pi -2pi) (list (* 2 pi) (* -2 pi)))
(defv (2π -2π) (values 2pi -2pi))