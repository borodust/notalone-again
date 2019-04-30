(cl:in-package :notalone-again)


(defclass loading-screen () ())


(defmethod draw ((this loading-screen))
  (with-slots (player space-font avara-font) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (let* ((time (* (ge.util:real-time-seconds) 10))
           (origin (vec2 (+ (* (cos time) 8) 25) (+ (* (sin time) 8) 25))))
      (draw-circle origin 5 :fill-paint *foreground-color*)
      (with-pushed-canvas ()
        (scale-canvas 5 5)
        (draw-text "LOADING" (vec2 10 10) :fill-color *foreground-color*)))))
