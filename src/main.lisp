(cl:in-package :notalone-again)


(defgame notalone-again (fistmachine)
  ()
  (:viewport-width *viewport-width*)
  (:viewport-height *viewport-height*)
  (:default-initargs :initial-state 'loading-screen))


(defmethod initialize-instance ((this notalone-again) &rest args &key depends-on)
  (apply #'call-next-method this
         :depends-on (cons 'physics-system depends-on)
         args))
