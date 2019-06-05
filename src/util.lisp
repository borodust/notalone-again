(cl:in-package :notalone-again)

(defparameter *viewport-width* 800)
(defparameter *viewport-height* 600)

(defparameter *background-color* (vec4 0.2 0.2 0.2 1.0))
(defparameter *foreground-color* (vec4 0.8 0.8 0.8 1.0))
(defparameter *zero-origin* (vec2 0 0))
(defparameter *ox-unit* (vec2 1 0))

(defgeneric render (object))


(defgeneric collide (this that)
  (:method (this that) nil))


(defclass state-input-handler (input-handler) ())


(defmethod post-initialize :after ((this state-input-handler))
  (activate-input-handler this))


(defmethod pre-destroy :before ((this state-input-handler))
  (deactivate-input-handler this))


(defun warp-position (position)
  (let ((result (copy-vec2 position)))
    (when (> (x position) *viewport-width*)
      (setf result (vec2 (mod (x position) *viewport-width*) (y position))))
    (when (> (y position) *viewport-height*)
      (setf result (vec2 (x position) (mod (y position) *viewport-height*))))
    (when (< (x position) 0)
      (setf result (vec2 (+ (x position) *viewport-width*) (y position))))
    (when (< (y position) 0)
      (setf result (vec2 (x position) (+ (y position) *viewport-height*))))
    result))
