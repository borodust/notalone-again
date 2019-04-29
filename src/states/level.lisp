(cl:in-package :notalone-again)


(defclass level (state-input-handler)
  ((universe :initform nil)
   (player :initform nil)
   (projectiles :initform nil)
   (enemies :initform nil)))


(defun on-pre-solve (this that)
  (collide-p (shape-substance this) (shape-substance that)))


(defun on-post-solve (this that)
  (collide (shape-substance this) (shape-substance that)))


(defun spawn-enemy (level x y)
  (with-slots (enemies universe) level
    (let ((enemy (make-enemy universe x y)))
      (push enemy enemies))))


(defun kill-enemy (enemy projectile)
  (with-slots (enemies projectiles universe) (current-state)
    (when (member enemy enemies)
      (destroy-enemy enemy)
      (alexandria:deletef enemies enemy))
    (when (member projectile projectiles)
      (destroy-projectile projectile)
      (alexandria:deletef projectiles projectile))))


(defmethod initialize-state ((this level) &key)
  (call-next-method)
  (with-slots (universe player) this
    (setf universe (make-universe :2d
                                  :on-pre-solve #'on-pre-solve
                                  :on-post-solve #'on-post-solve)
          player (make-player universe))
    (update-player-position player 100 100)
    (update-player-rotation player 0)
    (spawn-enemy this 600 400)
    (spawn-enemy this 200 400)
    (spawn-enemy this 600 200)))


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


(defmethod act ((this level))
  (with-slots (player universe enemies) this
    (update-player player)
    (observe-universe universe 0.10)
    (loop for enemy in enemies
          do (seek-player enemy player))))


(defmethod draw ((this level))
  (with-slots (player projectiles enemies) this
    (draw-rect *zero-origin* *viewport-width* *viewport-height*
               :fill-paint *background-color*)
    (render player)
    (loop for projectile in projectiles
          do (render projectile))
    (loop for enemy in enemies
          do (render enemy))))


(defmethod collide-p ((this player) (that enemy))
  nil)

(defmethod collide-p ((that enemy) (this player))
  (collide-p this that))

(defmethod collide-p ((this enemy) (that projectile))
  t)

(defmethod collide-p ((that projectile) (this enemy))
  (collide-p this that))


(defmethod collide ((this enemy) (that projectile))
  (push-action (lambda () (kill-enemy this that))))


(defmethod collide ((that projectile) (this enemy))
  (collide this that))
