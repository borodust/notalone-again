(cl:pushnew :bodge-gl2 cl:*features*)
(asdf:defsystem :notalone-again
  :description "Lisp Game Jam 2019 entry"
  :author "Pavel Korolev"
  :mailto "mail@borodust.org"
  :depends-on (alexandria trivial-gamekit
                          trivial-gamekit-fistmachine
                          trivial-gamekit-input-handler
                          cl-bodge/physics
                          cl-bodge/physics/2d)
  :serial t
  :pathname "src/"
  :components ((:file "packages")
               (:file "util")
               (:module "models"
                :serial t
                :components ((:file "projectile")
                             (:file "player")
                             (:file "enemy")))
               (:module "states"
                :serial t
                :components ((:file "main-menu")
                             (:file "loading-screen")
                             (:file "level")))
               (:file "main")))
