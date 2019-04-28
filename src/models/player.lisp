(cl:in-package :notalone-again)


(defclass player ()
  ((position :initform (vec2 0 0))
   (rotation :initform 0)))


(defun update-player-position (player x y)
  (with-slots (position) player
    (setf (x position) x
          (y position) y)))


(defun update-player-rotation (player angle)
  (with-slots (rotation) player
    (setf rotation angle)))


(defmethod render ((this player))
  (with-slots (position rotation) this
    (with-pushed-canvas ()
      (translate-canvas (x position) (y position))
      (rotate-canvas rotation)
      (draw-polygon (list (vec2 0 0)
                          (vec2 10 0)
                          (vec2 5 10))
                    :fill-paint (vec4 0.8 0.8 0.8 1)))))
