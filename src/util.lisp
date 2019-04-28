(cl:in-package :notalone-again)

(defparameter *viewport-width* 800)
(defparameter *viewport-height* 600)

(defparameter *background-color* (vec4 0.2 0.2 0.2 1.0))
(defparameter *foreground-color* (vec4 0.8 0.8 0.8 1.0))
(defparameter *zero-origin* (vec2 0 0))


(defgeneric render (object))


(defclass state-input-handler (input-handler) ())


(defmethod initialize-state ((this state-input-handler) &key)
  (call-next-method)
  (activate-input-handler this))


(defmethod discard-state ((this state-input-handler))
  (call-next-method)
  (deactivate-input-handler this))
