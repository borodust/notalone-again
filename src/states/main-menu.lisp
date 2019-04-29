(cl:in-package :notalone-again)


(defclass main-menu (state-input-handler)
  ((universe :initform nil)
   (player :initform nil)))


(defmethod initialize-state ((this main-menu) &key)
  (call-next-method)
  (with-slots (player universe) this
    (setf universe (make-universe :2d)
          player (make-player universe))))


(defmethod discard-state ((this main-menu))
  (with-slots (universe player) this
    (destroy-player player)
    (dispose universe))
  (call-next-method))


(defmethod button-pressed ((this main-menu) (button (eql :enter)))
  (transition-to 'level))


(defmethod draw ((this main-menu))
  (with-slots (player) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (let ((time (bodge-util:real-time-seconds)))
      (update-player-position player
                              (+ (* (cos time) 120) 400)
                              (+ (* (sin time) 40) 300))
      (update-player-rotation player (* time 2)))
    (render player)
    (draw-text "NOTALONE: AGAIN"
               (vec2 (- (/ *viewport-width* 2) 50)
                     (/ *viewport-height* 2))
               :fill-color *foreground-color*)))
