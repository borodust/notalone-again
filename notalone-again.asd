(cl:pushnew :bodge-gl2 cl:*features*)
(asdf:defsystem :notalone-again
  :description "Lisp Game Jam 2019 entry"
  :author "Pavel Korolev"
  :mailto "mail@borodust.org"
  :depends-on (trivial-gamekit trivial-gamekit-fistmachine trivial-gamekit-input-handler)
  :serial t
  :pathname "src/"
  :components ((:file "packages")
               (:file "main")))
