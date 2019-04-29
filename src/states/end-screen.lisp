(cl:in-package :notalone-again)


(defclass end-screen (state-input-handler)
  ((total-time :initarg :total-time)
   (reason :initarg :reason)
   (score :initarg :score)))


(defmethod initialize-state ((this end-screen) &key)
  (call-next-method))


(defmethod discard-state ((this end-screen))
  (call-next-method))


(defmethod button-pressed ((this end-screen) (button (eql :enter)))
  (transition-to 'level))


(defmethod draw ((this end-screen))
  (with-slots (reason total-time score) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (if (eq reason :projectile)
        (draw-text "YOU KILLED YOURSELF"
                   (vec2 (/ *viewport-width* 2)
                         (/ *viewport-height* 2))
                   :fill-color *foreground-color*)
        (draw-text "YOU DIED"
                   (vec2 (/ *viewport-width* 2)
                         (/ *viewport-height* 2))
                   :fill-color *foreground-color*))
    (draw-text (format nil "Total time: ~A" total-time)
               (vec2 (/ *viewport-width* 2)
                     (- (/ *viewport-height* 2) 100))
               :fill-color *foreground-color*)
    (draw-text (format nil "Enemies killed: ~A" score)
               (vec2 (/ *viewport-width* 2)
                     (- (/ *viewport-height* 2) 120))
               :fill-color *foreground-color*)))
