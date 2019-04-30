(cl:in-package :notalone-again)


(defun asset-path (pathname)
  (asdf:system-relative-pathname :notalone-again (merge-pathnames pathname "assets/")))

(define-font :avara (asset-path "fonts/avara/Avara.ttf"))
(define-font :space-meatball (asset-path "fonts/space-meatball/space-meatball.ttf"))


(define-sound :unknown-energy (asset-path "music/dox-unknown-energy.flac"))
(define-sound :the-anomaly (asset-path "music/tristan-lohengrin-the-anomaly.flac"))

(define-sound :explosion (asset-path "sounds/sfx_exp_short_soft9.flac"))
(define-sound :weapon (asset-path "sounds/sfx_weapon_singleshot8.flac"))
(define-sound :portal (asset-path "sounds/sfx_movement_portal3.flac"))
