(cl:in-package :notalone-again)


(defclass end-screen (state-input-handler) ())


(defmethod initialize-state ((this end-screen) &key)
  (call-next-method))


(defmethod discard-state ((this end-screen))
  (call-next-method))


(defmethod button-pressed ((this end-screen) (button (eql :enter)))
  (transition-to 'level))


(defmethod draw ((this end-screen))
  (with-slots () this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (draw-text "YOU DIED"
               (vec2 (/ *viewport-width* 2)
                     (/ *viewport-height* 2))
               :fill-color *foreground-color*)))
