(cl:in-package :notalone-again)

(defparameter *base-batch-cooldown* 10)
(defparameter *spawn-points* (list (vec2 600 400)
                                   (vec2 200 400)
                                   (vec2 600 200)
                                   (vec2 200 200)))

(defclass level (state-input-handler)
  ((universe :initform nil)
   (player :initform nil)
   (projectiles :initform nil)
   (enemies :initform nil)
   (start-time :initform (ge.util:real-time-seconds))
   (last-spawn :initform nil)
   (next-state :initform nil)
   (score :initform 0 :reader level-score)))


(defun on-pre-solve (this that)
  (collide (shape-substance this) (shape-substance that))
  nil)


(defun level-next-state (state &rest args &key &allow-other-keys)
  (with-slots (next-state) (current-state)
    (unless next-state
      (setf next-state (append (list state) args)))))


(defun spawn-enemy (level x y)
  (with-slots (enemies universe) level
    (let ((enemy (make-enemy universe x y)))
      (push enemy enemies))))


(defun spawn-batch (this)
  (with-slots (last-spawn) this
    (loop for spawn-point in *spawn-points*
          do (spawn-enemy this (x spawn-point) (y spawn-point)))
    (setf last-spawn (ge.util:real-time-seconds))))


(defun kill-enemy (enemy projectile)
  (with-slots (enemies projectiles universe score) (current-state)
    (when (member enemy enemies)
      (destroy-enemy enemy)
      (alexandria:deletef enemies enemy)
      (incf score))
    (when (member projectile projectiles)
      (destroy-projectile projectile)
      (alexandria:deletef projectiles projectile))))


(defmethod initialize-state ((this level) &key)
  (call-next-method)
  (with-slots (universe player) this
    (setf universe (make-universe :2d :on-pre-solve #'on-pre-solve)
          player (make-player universe))
    (update-player-position player 100 100)
    (update-player-rotation player 0)
    (spawn-batch this)))


(defmethod discard-state ((this level))
  (with-slots (universe player projectiles enemies) this
    (destroy-player player)
    (loop for projectile in projectiles
          do (destroy-projectile projectile))
    (loop for enemy in enemies
          do (destroy-enemy enemy))
    (dispose universe))
  (call-next-method))


(defmethod button-pressed ((this level) (button (eql :f)))
  (with-slots (player) this
    (turn-left player)))

(defmethod button-released ((this level) (button (eql :f)))
  (with-slots (player) this
    (stop-left-turn player)))

(defmethod button-pressed ((this level) (button (eql :d)))
  (with-slots (player) this
    (turn-right player)))

(defmethod button-released ((this level) (button (eql :d)))
  (with-slots (player) this
    (stop-right-turn player)))

(defmethod button-pressed ((this level) (button (eql :j)))
  (with-slots (player) this
    (engage-thrust player)))

(defmethod button-released ((this level) (button (eql :j)))
  (with-slots (player) this
    (disengage-thrust player)))

(defmethod button-released ((this level) (button (eql :p)))
  (spawn-enemy this 400 300))

(defmethod button-pressed ((this level) (button (eql :space)))
  (with-slots (universe projectiles player) this
    (let ((projectile (make-projectile universe
                                       (player-bow-position player)
                                       (player-rotation player)
                                       (vector-length (player-velocity player)))))
      (push projectile projectiles ))))

(defmethod button-released ((this level) (button (eql :escape)))
  (transition-to 'loading-screen))

(defmethod button-released ((this level) (button (eql :r)))
  (transition-to 'level))


(defun next-batch-spawn-cooldown (level)
  (with-slots (start-time) level
    (max (* *base-batch-cooldown*
            (- 1 (/ (max (- (ge.util:real-time-seconds) start-time) 1) 60)))
         2)))


(defmethod act ((this level))
  (with-slots (player universe enemies next-state last-spawn) this
    (when next-state
      (apply #'transition-to next-state))
    (update-player player)
    (loop for enemy in enemies
          do (seek-player enemy player))
    (observe-universe universe 0.10)
    (when (> (- (ge.util:real-time-seconds) last-spawn)
             (next-batch-spawn-cooldown this))
      (spawn-batch this))))


(defun elapsed-time-text (level)
  (with-slots (start-time) level
    (let ((elapsed (- (ge.util:real-time-seconds) start-time)))
     (format nil "~2,'0d:~2,'0d"
             (floor (/ elapsed 60))
             (floor (mod elapsed 60))))))


(defmethod draw ((this level))
  (with-slots (player projectiles enemies start-time) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (render player)
    (loop for projectile in projectiles
          do (render projectile))
    (loop for enemy in enemies
          do (render enemy))
    (draw-text (elapsed-time-text this)
               (vec2 5 5)
               :fill-color *foreground-color*)))


(defmethod collide ((this player) (that projectile))
  (level-next-state 'end-screen :total-time (elapsed-time-text (current-state))
                                :reason :projectile
                                :score (level-score (current-state))))

(defmethod collide ((that projectile) (this player))
  (collide this that))

(defmethod collide ((this player) (that enemy))
  (level-next-state 'end-screen :total-time (elapsed-time-text (current-state))
                                :reason :enemy
                                :score (level-score (current-state))))

(defmethod collide ((that enemy) (this player))
  (collide this that))

(defmethod collide ((this enemy) (that projectile))
  (kill-enemy this that))

(defmethod collide ((that projectile) (this enemy))
  (collide this that))
