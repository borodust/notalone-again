(cl:in-package :notalone-again)


(defparameter *enemy-radius* 10)
(defparameter *enemy-teeth* 30)
(defparameter *enemy-shape-vertices* (loop for i from 0 below *enemy-teeth*
                                           for angle = (* (/ (* 2 pi) *enemy-teeth*) i)
                                           collect (mult (vec2 (cos angle) (sin angle))
                                                         (if (oddp i)
                                                             (* *enemy-radius* 0.7)
                                                             *enemy-radius*))))

(defparameter *enemy-acceleration* 1)
(defparameter *enemy-max-speed* 10)

(defclass enemy ()
  ((body :initform nil)
   (shape :initform nil)))


(defmethod initialize-instance :after ((this enemy) &key universe position)
  (with-slots (body shape) this
    (setf body (make-rigid-body universe)
          (body-position body) position
          shape (make-polygon-shape universe
                                    *enemy-shape-vertices*
                                    :body body))))


(defun make-enemy (universe x y)
  (make-instance 'enemy :universe universe
                        :position (vec2 x y)))


(defun destroy-enemy (enemy)
  (with-slots (body shape) enemy
    (dispose shape)
    (dispose body)))


(defun seek-player (enemy player)
  (with-slots (body) enemy
    (let* ((player-position (player-position player))
           (position (body-position body))
           (popo-vec (subt player-position position))
           (distance (vector-length popo-vec))
           (target-direction (div popo-vec distance))
           (velocity (body-linear-velocity body))
           (speed (vector-length velocity))
           (direction (div velocity speed)))
      (apply-force body (mult target-direction *enemy-acceleration*))
      (when (< distance 100)
        (let* ((target-speed (min speed (+ (* speed (/ distance 100)) 10)))
               (target-force (- target-speed speed)))
          (apply-force body (mult direction target-force)))))))


(defmethod render ((this enemy))
  (with-slots (body) this
    (let ((position (setf (body-position body) (warp-position (body-position body)))))
      (flet ((render-object (x-offset y-offset)
               (with-pushed-canvas ()
                 (translate-canvas (+ (x position) x-offset) (+ (y position) y-offset))
                 (let ((ratio (- 1 (* (abs (cos (* (ge.util:real-time-seconds) 4))) 0.1))))
                   (scale-canvas ratio ratio))
                 (draw-polygon *enemy-shape-vertices*
                               :fill-paint (vec4 0.8 0.8 0.8 1)))))
        (render-object 0 0)
        (render-object *viewport-width* 0)
        (render-object 0 *viewport-height*)
        (render-object (- *viewport-width*) 0)
        (render-object 0 (- *viewport-height*))))))
