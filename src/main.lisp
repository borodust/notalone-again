(cl:in-package :notalone-again)


(defgame notalone-again (fistmachine)
  ()
  (:viewport-width *viewport-width*)
  (:viewport-height *viewport-height*)
  (:viewport-title "NOTALONE: AGAIN")
  (:prepare-resources nil)
  (:default-initargs :initial-state 'loading-screen))


(defmethod initialize-instance ((this notalone-again) &rest args &key depends-on)
  (apply #'call-next-method this
         :depends-on (cons 'physics-system depends-on)
         args))


(defmethod post-initialize ((this notalone-again))
  (call-next-method)
  (prepare-resources :avara
                     :space-meatball
                     :unknown-energy
                     :the-anomaly
                     :explosion
                     :weapon
                     :portal))


(defmethod notice-resources ((this notalone-again) &rest resource-names)
  (declare (ignore resource-names))
  (transition-to 'main-menu))
