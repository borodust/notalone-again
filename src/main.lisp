(cl:in-package :notalone-again)


(defgame notalone-again (fistmachine)
  ()
  (:viewport-width *viewport-width*)
  (:viewport-height *viewport-height*)
  (:viewport-title "NOTALONE: AGAIN")
  (:depends-on physics-system)
  (:prepare-resources nil)
  (:default-initargs :initial-state 'loading-screen))
