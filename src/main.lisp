(cl:in-package :notalone-again)


(defclass loading-screen (input-handler)
  ((text :initform "HI")))


(defmethod initialize-state ((this loading-screen) &key)
  (activate-input-handler this))


(defmethod button-pressed ((this loading-screen) (button (eql :enter)))
  (with-slots (text) this
    (setf text "INDEED")))


(defmethod button-released ((this loading-screen) (button (eql :enter)))
  (with-slots (text) this
    (setf text "HI")))


(defmethod discard-state ((this loading-screen))
  (deactivate-input-handler this))


(defmethod draw ((this loading-screen))
  (with-slots (text) this
    (draw-text text (vec2 100 100))))


(defgame notalone-again (fistmachine)
  ()
  (:default-initargs :initial-state 'loading-screen))
