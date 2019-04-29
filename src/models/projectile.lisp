(cl:in-package :notalone-again)


(defparameter *projectile-speed* 50)

(defparameter *projectile-radius* 1.5)

(defclass projectile ()
  ((body :initform nil)
   (shape :initform nil)))


(defmethod initialize-instance :after ((this projectile)
                                       &key universe initial-speed position rotation)
  (with-slots (body shape) this
    (setf body (make-rigid-body universe)
          shape (make-circle-shape universe
                                   *projectile-radius*
                                   :body body
                                   :substance this))
    (setf (body-position body) position
          (body-linear-velocity body) (mult rotation
                                            *ox-unit*
                                            (+ initial-speed *projectile-speed*)))))


(defun make-projectile (universe position rotation initial-speed)
  (make-instance 'projectile :universe universe
                             :position position
                             :rotation rotation
                             :initial-speed initial-speed))


(defun destroy-projectile (projectile)
  (with-slots (body shape) projectile
    (dispose shape)
    (dispose body)))


(defmethod render ((this projectile))
  (with-slots (body) this
    (let ((position (setf (body-position body) (warp-position (body-position body)))))
      (flet ((render-object (x-offset y-offset)
               (with-pushed-canvas ()
                 (translate-canvas (+ (x position) x-offset) (+ (y position) y-offset))
                 (draw-circle *zero-origin* *projectile-radius*
                              :fill-paint (vec4 0.8 0.8 0.8 1)))))
        (render-object 0 0)
        (render-object *viewport-width* 0)
        (render-object 0 *viewport-height*)
        (render-object (- *viewport-width*) 0)
        (render-object 0 (- *viewport-height*))))))
