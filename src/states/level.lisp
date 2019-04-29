(cl:in-package :notalone-again)


(defclass level (state-input-handler)
  ((universe :initform nil)
   (player :initform nil)))


(defmethod initialize-state ((this level) &key)
  (call-next-method)
  (with-slots (universe player) this
    (setf universe (make-universe :2d)
          player (make-player universe))
    (update-player-position player 100 100)
    (update-player-rotation player 0)))


(defmethod discard-state ((this level))
  (with-slots (universe player) this
    (destroy-player player)
    (dispose universe))
  (call-next-method))


(defmethod button-pressed ((this level) (button (eql :f)))
  (with-slots (player) this
    (turn-left player)))

(defmethod button-released ((this level) (button (eql :f)))
  (with-slots (player) this
    (stop-left-turn player)))

(defmethod button-pressed ((this level) (button (eql :d)))
  (with-slots (player) this
    (turn-right player)))

(defmethod button-released ((this level) (button (eql :d)))
  (with-slots (player) this
    (stop-right-turn player)))

(defmethod button-pressed ((this level) (button (eql :j)))
  (with-slots (player) this
    (engage-thrust player)))

(defmethod button-released ((this level) (button (eql :j)))
  (with-slots (player) this
    (disengage-thrust player)))

(defmethod button-pressed ((this level) (button (eql :k)))
  )

(defmethod button-released ((this level) (button (eql :k)))
  )

(defmethod button-pressed ((this level) (button (eql :space)))
  )

(defmethod button-released ((this level) (button (eql :escape)))
  (transition-to 'loading-screen))

(defmethod button-released ((this level) (button (eql :r)))
  (transition-to 'level))


(defmethod act ((this level))
  (with-slots (player universe) this
    (update-player player)
    (observe-universe universe 0.10)))


(defmethod draw ((this level))
  (with-slots (player) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (render player)))
