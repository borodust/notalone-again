(cl:in-package :notalone-again)


(defclass loading-screen (state-input-handler)
  ((player :initform (make-instance 'player))))


(defmethod button-pressed ((this loading-screen) (button (eql :enter)))
  (transition-to 'main-menu))


(defmethod draw ((this loading-screen))
  (with-slots (player) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (let ((time (bodge-util:real-time-seconds)))
      (update-player-position player
                              (+ (* (sin time) 80) 400)
                              (+ (* (cos time) 80) 300))
      (update-player-rotation player time))
    (render player)
    (draw-text "LOADING"
               (vec2 (/ *viewport-width* 2)
                     (/ *viewport-height* 2))
               :fill-color *foreground-color*)))
