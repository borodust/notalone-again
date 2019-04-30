(cl:in-package :notalone-again)


(defclass main-menu (state-input-handler)
  ((universe :initform nil)
   (player :initform nil)
   (space-font :initform nil)
   (avara-font :initform nil)))


(defmethod initialize-state ((this main-menu) &key)
  (call-next-method)
  (with-slots (player universe space-font avara-font) this
    (setf universe (make-universe :2d)
          player (make-player universe)
          space-font (make-font :space-meatball 60)
          avara-font (make-font :avara 24))
    (play-sound :the-anomaly :looped-p t)))


(defmethod discard-state ((this main-menu))
  (with-slots (universe player) this
    (stop-sound :the-anomaly)
    (destroy-player player)
    (dispose universe))
  (call-next-method))


(defmethod button-pressed ((this main-menu) (button (eql :enter)))
  (transition-to 'level))


(defmethod draw ((this main-menu))
  (with-slots (player space-font avara-font) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (let ((time (bodge-util:real-time-seconds)))
      (update-player-position player
                              (+ (* (cos time) 500) 400)
                              (+ (* (sin time) 100) 300))
      (update-player-rotation player (* time 2)))
    (render player)
    (with-pushed-canvas ()
      (let ((v (* (cos (* (ge.util:real-time-seconds) 0.5)) 0.01)))
        (scale-canvas (+ 0.55 v) 1))
      (draw-text "NOTALONE AGAIN"
                 (vec2 (- (/ *viewport-width* 2) 50)
                       (/ *viewport-height* 2))
                 :fill-color *foreground-color*
                 :font space-font))
    (draw-text "PRESS ENTER TO START"
                 (vec2 (- (/ *viewport-width* 2) 120)
                       (- (/ *viewport-height* 2) 200))
                 :fill-color *foreground-color*
                 :font avara-font)))
