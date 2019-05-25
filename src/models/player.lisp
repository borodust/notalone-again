(cl:in-package :notalone-again)


(defparameter *player-bow* (vec2 30 0))


(defparameter *player-shape-vertices* (list (vec2 0 -10)
                                            *player-bow*
                                            (vec2 0 10)))


(defparameter *turn-speed* 2.5)

(defparameter *thrust-force* 300)

(defclass player ()
  ((body :initform nil)
   (shape :initform nil)
   (thrust-engaged-at :initform nil)
   (left-turn-started-at :initform nil)
   (right-turn-started-at :initform nil)))


(defmethod initialize-instance :after ((this player) &key universe)
  (with-slots (body shape) this
    (setf body (make-rigid-body universe)
          shape (make-polygon-shape universe
                                    *player-shape-vertices*
                                    :body body
                                    :substance this))))


(defun make-player (universe)
  (make-instance 'player :universe universe))


(defun destroy-player (player)
  (with-slots (body shape) player
    (dispose shape)
    (dispose body)))


(defun update-player-position (player x y)
  (with-slots (body) player
    (setf (body-position body) (vec2 x y))))


(defun player-position (player)
  (with-slots (body) player
    (body-position body)))


(defun player-bow-position (player)
  (with-slots (body) player
    (add (body-position body)
         (mult (body-rotation body)
               *player-bow*))))


(defun player-velocity (player)
  (with-slots (body) player
    (body-linear-velocity body)))


(defun player-rotation (player)
  (with-slots (body) player
    (body-rotation body)))


(defun update-player-rotation (player angle)
  (with-slots (body) player
    (setf (body-rotation body) (euler-angle->mat2 angle))))


(defun engage-thrust (player)
  (setf (slot-value player 'thrust-engaged-at) (ge.util:real-time-seconds)))


(defun disengage-thrust (player)
  (setf (slot-value player 'thrust-engaged-at) nil))


(defun update-thrust (player)
  (with-slots (body thrust-engaged-at) player
    (when thrust-engaged-at
      (let* ((current-time (ge.util:real-time-seconds))
             (time-delta (- current-time thrust-engaged-at)))
        (apply-force body (mult (body-rotation body)
                                (vec2 1 0)
                                (* *thrust-force* time-delta)))
        (setf thrust-engaged-at current-time)))))


(defun turn-left (player)
  (setf (slot-value player 'left-turn-started-at) (ge.util:real-time-seconds)))


(defun turn-right (player)
  (setf (slot-value player 'right-turn-started-at) (ge.util:real-time-seconds)))


(defun stop-left-turn (player)
  (setf (slot-value player 'left-turn-started-at) nil))


(defun stop-right-turn (player)
  (setf (slot-value player 'right-turn-started-at) nil))


(defun update-turn (player)
  (with-slots (left-turn-started-at right-turn-started-at body) player
    (let ((current-time (ge.util:real-time-seconds))
          (current-angle (mat2->euler-angle (body-rotation body)))
          (angle-delta 0))
      (when left-turn-started-at
        (incf angle-delta (* (- current-time left-turn-started-at)
                             *turn-speed*))
        (setf left-turn-started-at current-time))
      (when right-turn-started-at
        (incf angle-delta (- (* (- current-time right-turn-started-at)
                                *turn-speed*)))
        (setf right-turn-started-at current-time))
      (update-player-rotation player (+ current-angle angle-delta)))))


(defun update-player (player)
  (with-slots (body) player
    (setf (body-position body) (warp-position (body-position body))))
  (update-thrust player)
  (update-turn player))


(defmethod render ((this player))
  (with-slots (body) this
    (let ((position (body-position body))
          (rotation (body-rotation body)))
      (flet ((render-object (x-offset y-offset)
               (with-pushed-canvas ()
                 (translate-canvas (+ (x position) x-offset) (+ (y position) y-offset))
                 (rotate-canvas (mat2->euler-angle rotation))
                 (draw-polygon *player-shape-vertices*
                               :fill-paint (vec4 0.8 0.8 0.8 1)))))
        (render-object 0 0)
        (render-object *viewport-width* 0)
        (render-object 0 *viewport-height*)
        (render-object (- *viewport-width*) 0)
        (render-object 0 (- *viewport-height*))))))
