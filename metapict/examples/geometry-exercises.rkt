#lang racket
(require metapict)

(define (save-as-png filename pict)
  (send (pict->bitmap pict)
        save-file filename 'png))

(def fig-geometry-exercise1
  (let ()
    (set-curve-pict-size 400 400 )
    (curve-pict-window (window -0.1 1.1 -0.1 1.1))
    (def P0 (pt 0 0))
    (def P1 (pt 1 0))
    (def P2 (pt 1 1))
    (def P3 (pt 0 1))
    (def P3P0 (pt- P0 P3))
    (def P3P2 (pt- P2 P3))
    (def x  0.3)
    (def A (pt+ P3 (vec* x P3P0)))
    (def B (pt+ P3 (vec* x P3P2)))
    (def C P1)
    (def corner-size 0.05)
    (def cs corner-size)
    (def corner (curve (pt cs 0) -- (pt cs cs) -- (pt 0 cs)))
    (def fig
      (draw (color "white" (fill (curve P0 -- P1 -- P2 -- P3 -- cycle)))
            (curve P0 -- P1 -- P2 -- P3 -- cycle)
            (dot-label-lft "A" A)
            (dot-label-top "B" B)
            (dot-label-lrt "C" C)
            (label-lft "x" (med 1/2 A P3))
            (label-top "x" (med 1/2 B P3))
            (label-rt  "1" (med 1/2 P1 P2))
            (label-bot "1" (med 1/2 P0 P1))
            (curve A -- B -- C -- cycle)
            corner
            ; (shifted P1 (flipx corner))
            (shifted P2 (flipx (flipy corner)))
            (shifted P3 (flipy corner))))
    (inset fig 5)))

(def fig-geometry-exercise2
  (let ()
    (set-curve-pict-size 400 400 )
    (curve-pict-window (window -0.1 1.1 -0.1 1.1))
    (def P0 (pt 0 0))
    (def P1 (pt 1 0))
    (def P2 (pt 1 1))
    (def P3 (pt 0 1))
    (def P3P0 (pt- P0 P3))
    (def P3P2 (pt- P2 P3))
    (def x  0.3)
    (def 2x (* 2 x))
    (def A (pt+ P3 (vec* x P3P0)))
    (def B (pt+ P3 (vec* 2x P3P2)))
    (def C P1)
    (def corner-size 0.05)
    (def cs corner-size)
    (def corner (curve (pt cs 0) -- (pt cs cs) -- (pt 0 cs)))
    (def fig
      (draw (color "white" (fill (curve P0 -- P1 -- P2 -- P3 -- cycle)))
            (curve P0 -- P1 -- P2 -- P3 -- cycle)
            (dot-label-lft "A" A)
            (dot-label-top "B" B)
            (dot-label-lrt "C" C)
            (label-lft "x" (med 1/2 A P3))
            (label-top "2x" (med 1/2 B P3))
            (label-rt  "1" (med 1/2 P1 P2))
            (label-bot "1" (med 1/2 P0 P1))
            (curve A -- B -- C -- cycle)
            corner
            ; (shifted P1 (flipx corner))
            (shifted P2 (flipx (flipy corner)))
            (shifted P3 (flipy corner))))
    (inset fig 5)))

(def fig-geometry-exercise3
  (let ()
    (set-curve-pict-size 400 400 )
    (curve-pict-window (window -0.1 1.1 -0.1 1.1))
    (def P0 (pt 0 0))
    (def P1 (pt 1 0))
    (def P2 (pt 1 1))
    (def P3 (pt 0 1))
    (def P3P0 (pt- P0 P3))
    (def P3P2 (pt- P2 P3))
    (def x  0.3)
    (def k 3)
    (def kx (* k x))
    (def A (pt+ P3 (vec* x P3P0)))
    (def B (pt+ P3 (vec* kx P3P2)))
    (def C P1)
    (def corner-size 0.05)
    (def cs corner-size)
    (def corner (curve (pt cs 0) -- (pt cs cs) -- (pt 0 cs)))
    (def fig
      (draw (color "white" (fill (curve P0 -- P1 -- P2 -- P3 -- cycle)))
            (curve P0 -- P1 -- P2 -- P3 -- cycle)
            (dot-label-lft "A" A)
            (dot-label-top "B" B)
            (dot-label-lrt "C" C)
            (label-lft "x" (med 1/2 A P3))
            (label-top "kx" (med 1/2 B P3))
            (label-rt  "1" (med 1/2 P1 P2))
            (label-bot "1" (med 1/2 P0 P1))
            (curve A -- B -- C -- cycle)
            corner
            ; (shifted P1 (flipx corner))
            (shifted P2 (flipx (flipy corner)))
            (shifted P3 (flipy corner))))
    (inset fig 5)))

fig-geometry-exercise1
fig-geometry-exercise2
fig-geometry-exercise3

(send (pict->bitmap fig-geometry-exercise1) 
      save-file "/Users/soegaard/Downloads/fig1.png" 'png)
(send (pict->bitmap fig-geometry-exercise2) 
      save-file "/Users/soegaard/Downloads/fig2.png" 'png)
(send (pict->bitmap fig-geometry-exercise3) 
      save-file "/Users/soegaard/Downloads/fig3.png" 'png)