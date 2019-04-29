(cl:in-package :notalone-again)

(defclass main-menu (state-input-handler)
  ((text :initform "HI")))


(defun update-bag-display (this)
  (with-slots (text) this
    (alexandria:if-let ((bag (pressed-buttons this)))
      (setf text (format nil "INDEED: ~A" (pressed-buttons this)))
      (setf text "HI"))))


(defmethod button-pressed ((this main-menu) (button (eql :enter)))
  (transition-to 'level))


(defmethod button-pressed ((this main-menu) button)
  (update-bag-display this))


(defmethod button-released ((this main-menu) button)
  (update-bag-display this))


(defmethod draw ((this main-menu))
  (with-slots (text) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (draw-text text (vec2 100 100) :fill-color *foreground-color*)))
