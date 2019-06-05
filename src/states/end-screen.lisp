(cl:in-package :notalone-again)


(defclass end-screen (state-input-handler)
  ((total-time :initarg :total-time)
   (reason :initarg :reason)
   (score :initarg :score)
   (space-font :initform nil)
   (avara-font :initform nil)))


(defmethod post-initialize ((this end-screen))
  (play-sound :the-anomaly)
  (with-slots (space-font avara-font) this
    (setf space-font (make-font :space-meatball 60)
          avara-font (make-font :avara 24))))


(defmethod pre-destroy ((this end-screen))
  (stop-sound :the-anomaly))


(defmethod button-pressed ((this end-screen) (button (eql :enter)))
  (transition-to 'level))


(defmethod button-pressed ((this end-screen) (button (eql :gamepad-start)))
  (transition-to 'level))


(defmethod draw ((this end-screen))
  (with-slots (reason total-time score space-font avara-font) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (if (eq reason :projectile)
        (with-pushed-canvas ()
          (scale-canvas 0.6 1)
          (draw-text "YOU KILLED YOURSELF"
                     (vec2 (- (/ *viewport-width* 2) 250)
                           (+ (/ *viewport-height* 2) 100))
                     :fill-color *foreground-color*
                     :font space-font))
        (draw-text "YOU DIED"
                   (vec2 (- (/ *viewport-width* 2) 210)
                         (+ (/ *viewport-height* 2) 100))
                   :fill-color *foreground-color*
                   :font space-font))
    (draw-text (format nil "Total time: ~A" total-time)
               (vec2 (- (/ *viewport-width* 2) 100)
                     (- (/ *viewport-height* 2) 100))
               :fill-color *foreground-color*
               :font avara-font)
    (draw-text (format nil "Enemies killed: ~A" score)
               (vec2 (- (/ *viewport-width* 2) 100)
                     (- (/ *viewport-height* 2) 140))
               :fill-color *foreground-color*
               :font avara-font)
    (draw-text "PRESS ENTER TO TRY AGAIN"
               (vec2 (- (/ *viewport-width* 2) 170)
                     (- (/ *viewport-height* 2) 250))
               :fill-color *foreground-color*
               :font avara-font)))
