;; load robot and scene model
(require "package://fetcheus/fetch-utils.l")
(require "package://fetcheus/fetch-interface.l")
(require "package://jsk_maps/src/eng2-scene.l")

(unless (boundp '*scene*)
  (setq *scene* (make-eng2-7f-scene)))
(unless (boundp '*ri*)
  (fetch-init)) ;; fetch-init instantiate *fetch* and *ri*

;; show in irtviewer
(objects (list *fetch* *scene*))
;; show in "fetch Kinematics Simulator"
(send *ri* :objects (send *scene* :objects))

(defun reset-pose()
  (send *fetch* :torso :waist-z :joint-angle 50.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)


  (send *fetch* :reset-pose)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :reset-pose))
  (send *ri* :wait-interpolation)
  )

;; use (mapcar #'(lambda (x) (send x :name)) (send *scene* :spots)) to get list of spots
(defun move-to-door-front() 
  (send *fetch* :move-to (send *scene* :spot "/eng2/7f/room73B2-fetch-dock-front") :world)

  ;; check 20201026-soft3-model, the code to focus on the robot model
  (send *irtviewer* :look-all
	(send (geo::make-bounding-box
	       (flatten (send-all (send *fetch* :bodies) :vertices)))
	      :grow 2.0))

  #|(setq *table-back* (send (send (send *scene* :spot "/eng2/7f/room73B2-table-back") :copy-worldcoords) :rotate 0 :z  ))
  (send *fetch* :move-to *table-back* :world) ;; moved in irtviewer
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to *table-back*) |#

  (setq *door-spot* (send (send (send *scene* :spot "door-spot") :copy-worldcoords) :rotate 0 :z  ))
  (send *fetch* :move-to (send *door-spot*
			       :transform (make-coords :pos #f(-300 100 0) :rpy (float-vector 0 0 0))) :world) ;; moved in irtviewer
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to  (send *door-spot*
			     :transform (make-coords :pos #f(0 100 0) :rpy (float-vector 0 0 0))))
  )

#|(send *fetch* :rarm :angle-vector #f(-55 80 -45 -110 0 30 15))
(send *irtviewer* :draw-objects) ;; update viewer
(send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
(send *ri* :wait-interpolation t)|#

(defun hold-door-horizontal()
  (send *fetch* :torso :waist-z :joint-angle 200.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

  (send *fetch* :rarm :shoulder-r :joint-angle -90.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

  (send *fetch* :rarm :shoulder-p :joint-angle 0.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

  (send *fetch* :rarm :wrist-p :joint-angle -10)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

  #|(send *fetch* :rarm :shoulder-p :joint-angle -90.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)|#

  (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(700 250 1000) :rpy (float-vector 0 0 (/ pi -2)) )) :debug-view t)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
  (send *ri* :wait-interpolation t)

  (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(900 250 1000) :rpy (float-vector 0 0 (/ pi -2)) )) :debug-view t)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
  (send *ri* :wait-interpolation t)
  
  (send *fetch* :start-grasp)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :start-grasp)
  (send *ri* :wait-interpolation t)
#|
  (send *fetch* :rarm :wrist-r :joint-angle -90)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)
|#
  )

(defun move-to-door-front() 
  (send *fetch* :move-to (send *scene* :spot "/eng2/7f/room73B2-fetch-dock-front") :world)

  ;; check 20201026-soft3-model, the code to focus on the robot model
  (send *irtviewer* :look-all
	(send (geo::make-bounding-box
	       (flatten (send-all (send *fetch* :bodies) :vertices)))
	      :grow 2.0))

  #|(setq *table-back* (send (send (send *scene* :spot "/eng2/7f/room73B2-table-back") :copy-worldcoords) :rotate 0 :z  ))
  (send *fetch* :move-to *table-back* :world) ;; moved in irtviewer
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to *table-back*) |#

  (setq *door-spot* (send (send (send *scene* :spot "door-spot") :copy-worldcoords) :rotate 0 :z  ))
  (send *fetch* :move-to (send *door-spot*
			       :transform (make-coords :pos #f(-300 100 0) :rpy (float-vector 0 0 0))) :world) ;; moved in irtviewer
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to  (send *door-spot*
			     :transform (make-coords :pos #f(0 100 0) :rpy (float-vector 0 0 0))))
  )

#|(send *fetch* :rarm :angle-vector #f(-55 80 -45 -110 0 30 15))
(send *irtviewer* :draw-objects) ;; update viewer
(send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
(send *ri* :wait-interpolation t)|#

(defun hold-door-vertical()
  (send *fetch* :torso :waist-z :joint-angle 200.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

  (send *fetch* :rarm :shoulder-r :joint-angle -180.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

  (send *fetch* :rarm :shoulder-y :joint-angle 0.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

  (send *fetch* :rarm :wrist-p :joint-angle -10)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

  #|(send *fetch* :rarm :shoulder-p :joint-angle -90.0)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)|#

  (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(700 250 1000) :rpy (float-vector 0 0 (/ pi -2)) )) :debug-view t)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
  (send *ri* :wait-interpolation t)
#|
  (send *fetch* :rarm :wrist-r :joint-angle -90)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)
  |#
  
  
  )





#|(send *fetch* :rarm :inverse-kinematics
      (send (send *fetch* :copy-worldcoords) :transform
	    (make-coords :pos #f(400 200 800))) :debug-view t)
(send *irtviewer* :draw-objects) ;; update viewer
(send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
(send *ri* :wait-interpolation t)|#
;;(setq c (copy-worldcoords :pos  (float-vector 0 0 0) :rpy (float-vector 0 0 0)))

#|(send *fetch* :larm :inverse-kinematics c
:link-list (send *fetch* :larm :link-list (send *fetch* :larm :end-coords :parent))
:move-target (send *fetch* :larm :end-coords)
:translation-axis t
:rotation-axis :z
:debug-view t)|#
