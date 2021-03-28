;; load robot and scene model
(require "package://fetcheus/fetch-utils.l")
(require "package://fetcheus/fetch-interface.l")
(require "package://jsk_maps/src/eng2-scene.l")
(require "~/semi_ws/src/jsk_robot/jsk_fetch_robot/jsk_fetch_startup/euslisp/navigation-utils.l")

(unless (boundp '*scene*)
  (setq *scene* (make-eng2-7f-scene)))
(unless (boundp '*ri*)
  (fetch-init))
;; fetch-init instantiate *fetch* and *ri*

(setq *difpos* (list 0 0 0))

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

(defun stop-grasp ()
  (send *fetch* :stop-grasp :effort 60)
  (send *ri* :stop-grasp :effort 60)
  (unix:sleep 1)
)

(defun start-grasp ()
  (send *fetch* :start-grasp :effort 60)
  (send *ri* :start-grasp :effort 60)
  (unix:sleep 1)
)

(defun look-down ()
  (send *fetch* :head_tilt_joint :joint-angle 20)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)
)
  

;; use (mapcar #'(lambda (x) (send x :name)) (send *scene* :spots)) to get list of spots
(defun move-to-73B2-inside-door-front() 
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
			       :transform (make-coords :pos #f(-200 100 0) :rpy (float-vector 0 0 0))) :world) ;; moved in irtviewer
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to  (send *door-spot*
			     :transform (make-coords :pos #f(-200 100 0) :rpy (float-vector 0 0 0))))
  )

(defun move-to-73B1-outside-door-front() 

  (setq *room73B1-front* (send (send (send *scene* :spot "/eng2/7f/room73A2-front") :copy-worldcoords) :rotate pi :z  ))
  (send *fetch* :move-to (send *room73B1-front*
			       :transform (make-coords :pos #f(200 -1500 0) :rpy (float-vector 0 0 0))) :world) ;; moved in irtviewer
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to  (send *room73B1-front*
			     :transform (make-coords :pos #f(200 -1500 0) :rpy (float-vector 0 0 0))))
  )


(defun move-to-73B2-outside-door-front() 

  (setq *room73A3-front1* (send (send (send *scene* :spot "/eng2/7f/room73A3-front1") :copy-worldcoords) :rotate 0 :z  ))
  (send *fetch* :move-to (send *room73A3-front1*
			       :transform (make-coords :pos #f(-200 100 0) :rpy (float-vector 0 0 0))) :world) ;; moved in irtviewer
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to  (send *room73A3-front1*
			     :transform (make-coords :pos #f(-200 100 0) :rpy (float-vector 0 0 0))))
  )


(defun move-to-73A2-outside-door-front() 

  (setq *room73A2-front* (send (send (send *scene* :spot "/eng2/7f/room73A2-front") :copy-worldcoords) :rotate 0 :z  ))
  (send *fetch* :move-to (send *room73A2-front*
			       :transform (make-coords :pos #f(-290 0 0) :rpy (float-vector 0 0 0))) :world) ;; moved in irtviewer(x y z)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to  (send *room73A2-front*
			     :transform (make-coords :pos #f(-290 0 0) :rpy (float-vector 0 0 0))))
  )

(defun move-to-73A3-outside-door-front()
  (setq *room73A3-front* (send (send (send *scene* :spot "/eng2/7f/room73A3-front") :copy-worldcoords) :rotate 0 :z  ))
  (send *fetch* :move-to (send *room73A3-front*
			       :transform (make-coords :pos #f(-100 0 0) :rpy (float-vector 0 0 0))) :world) ;; moved in irtviewer (x y z)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to  (send *room73A3-front*
			     :transform (make-coords :pos #f(-100 0 0) :rpy (float-vector 0 0 0))))
  )

(defun set-pos-outside ()
  (search-mark)
  (setq *door-front-outside* (send (send (send (send *ri* :state :worldcoords) :transform bed) :transform  (make-coords :pos #f(800 500 1000) :rpy (float-vector 0 pi/2 pi))) :copy-worldcoords))
  (send *fetch* :move-to *door-front-outside* :world)
  (send *irtviewer* :draw-objects)
  (send *ri* :move-to *door-front-outside* )
  #|(setq *door-front-outside* (send  (send (send *fetch* :copy-worldcoords) :transform (send (send (send (send bed :copy-coords) :translate #f(-600 -1000 -500) :world) :rotate  pi :z) :rotate  pi/2 :y)) #|x y z|# #|1075(-420 -160 115) 15(-415 -150 110)|# :copy-worldcoords) )
  (send *fetch* :move-to (send *door-front-outside*
			       :transform (make-coords :pos #f(0 0 0) :rpy (float-vector 0 -0 0))) :world) ;; moved in irtviewer(x y z)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :move-to  (send *door-front-outside*
			     :transform (make-coords :pos #f(0 0 0) :rpy (float-vector 0 0 0)))) |#
)

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
	      (make-coords :pos #f(850 200 1000) :rpy (float-vector 0 0 (/ pi -2)) )) :debug-view t)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
  (send *ri* :wait-interpolation t)

  (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(900 250 1000) :rpy (float-vector 0 0 (/ pi -2)) )) :debug-view t)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
  (send *ri* :wait-interpolation t)

  (send *fetch* :stop-grasp)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :stop-grasp)
  (send *ri* :wait-interpolation t)

#|  (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(1100 250 1000) :rpy (float-vector 0 0 (/ pi -2)) )) :debug-view t)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
  (send *ri* :wait-interpolation t)
  |#
#|  (send *fetch* :start-grasp)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :start-grasp)
  (send *ri* :wait-interpolation t)
|#

#|
  (send *fetch* :rarm :wrist-r :joint-angle -90)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)
|#
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
	      (make-coords :pos #f(700 450 965) :rpy (float-vector 0 0 (/ pi -2)) )) :debug-view t)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
  (send *ri* :wait-interpolation t)

 ;; (setq pos (list 0 0 0))
#|
  (send *fetch* :rarm :wrist-r :joint-angle -90)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)
  |#
  
  
  )



#|(defun hold-hand-pre()
 (send *fetch* :rarm :shoulder-r :joint-angle -60.0)
 (send *irtviewer* :draw-objects)
 (send *ri* :angle-vector (send *fetch* :angle-vector))
 (send *ri* :wait-interpolation)

 (send *fetch* :rarm :elbow-r :joint-angle 90.0)
 (send *irtviewer* :draw-objects)
 (send *ri* :angle-vector (send *fetch* :angle-vector))
 (send *ri* :wait-interpolation)

 (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(-20 -210 520) :rpy (float-vector 0 pi (/ pi 2)) )) :debug-view t)
 (send *irtviewer* :draw-objects) ;; update viewer
 (send *ri* :angle-vector (send *fetch* :angle-vector) 5000 :use-torso nil)
 (send *ri* :wait-interpolation t)

 (stop-grasp)
 

 )|#
  
  

(defun move-hand (x y z)
 ;; (send *fetch* :rarm :end-coords :parent)
  (send *fetch* :rarm :move-end-pos (float-vector x y z) :local :debug-view t)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)
  ;;(print (send (send *fetch* :copy-worldcoords) :transform (send *fetch* :rarm-end-coords) ))
  (setf (elt *difpos* 0) (+ (elt *difpos* 0) x))
  (setf (elt *difpos* 1) (+ (elt *difpos* 1) y))
  (setf (elt *difpos* 2) (+ (elt *difpos* 2) z))
   ;; ()
   ;; )
  )

(defun hold-hand ()
 (stop-grasp)
 
 (send *fetch* :rarm :shoulder-r :joint-angle -60.0)
 (send *irtviewer* :draw-objects)
 (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation)

 (send *fetch* :rarm :elbow-r :joint-angle 90.0)
 (send *irtviewer* :draw-objects)
 (send *ri* :angle-vector (send *fetch* :angle-vector) 2000)
 (send *ri* :wait-interpolation)
 
 (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(-10 -210 520) :rpy (float-vector 0 pi (/ pi 2)) )) :debug-view t);;1075(-20 -210 520), 15(-20 -215 520) (x? y Z?)
 (send *irtviewer* :draw-objects) ;; update viewer
 (send *ri* :angle-vector (send *fetch* :angle-vector) 5000 :use-torso nil)
 (send *ri* :wait-interpolation)
 
 (send *fetch* :rarm :move-end-pos #f(70 0 0))
 (send *irtviewer* :draw-objects) ;; update viewer
 (send *ri* :angle-vector (send *fetch* :angle-vector) 2000)
 (send *ri* :wait-interpolation)

 (start-grasp)

 (send *fetch* :rarm :wrist-p :joint-angle -90.0)
 (send *irtviewer* :draw-objects)
 (send *ri* :angle-vector (send *fetch* :angle-vector))
 (send *ri* :wait-interpolation) 
 )

(defun set-hand-outside ()

 (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform (send (send (send (send bed :copy-worldcoords) :translate #f(-420 -210 125) :world) :rotate  -pi/2 :z) :rotate  pi/2 :y)) #|x y z|# #|1075(-420 -210 125) 15(-415 -150 110)|#
	#|(send (send *fetch* :copy-worldcoords) :transform (send bed :translate #f(-300 0 190) :world))|# 
        :debug-view t )
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation )
  ()
  )

(defun set-hand-inside ()
 (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform (send (send (send (send bed :copy-world-coords) :translate #f(-350 -50 120) :world) :rotate  -pi/2 :z) :rotate  pi/2 :y))
	#|(send (send *fetch* :copy-worldcoords) :transform (send bed :translate #f(-300 0 190) :world))|# 
        :debug-view t )
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation )
  ()
 #| (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(700 450 965) :rpy (float-vector 0 0 (/ pi -2)) )) :debug-view t)
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
 (send *ri* :wait-interpolation )|#
  #|(send *fetch* :rarm :wrist-r :joint-angle -pi/2)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation t)

  (move-hand 100 100 0)

  (send *fetch* :rarm :wrist-r :joint-angle pi/2)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation )
  
  (move-hand -100 -100 0)|#
 )

(defun clean-handle ()
  (move-hand 180 0 0)
  (move-hand 0 0 50)
  (move-hand 0 0 -50)
  (move-hand -200 0 0)
 )

(defun return-hand ()
 (send *fetch* :angle-vector (float-vector 22.4306 74.3831 80.2347 -97.0705 99.1346 75.9194 76.8505 0.010871 -0.640125 0.392456))
 (send *irtviewer* :draw-objects)
 (send *ri* :angle-vector (send *fetch* :angle-vector))
 (send *ri* :wait-interpolation)

 (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform
	      (make-coords :pos #f(-20 -210 520) :rpy (float-vector 0 pi (/ pi 2)) )) :debug-view t);;1075(-20 -210 520) 15(-20 -215 520) (x? y Z?)
 (send *irtviewer* :draw-objects) ;; update viewer
 (send *ri* :angle-vector (send *fetch* :angle-vector) 5000 :use-torso nil)
 (send *ri* :wait-interpolation)

 (send *fetch* :rarm :move-end-pos #f(60 0 0))
 (send *ri* :angle-vector (send *fetch* :angle-vector) 2000)
 (send *ri* :wait-interpolation)

 (stop-grasp)

 (send *fetch* :rarm :move-end-pos #f(-150 0 0))
 (send *ri* :angle-vector (send *fetch* :angle-vector) 2000)
 (send *ri* :wait-interpolation)

 (reset-pose)
 
)

(defun move-hand-to-recpos ()
  (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform (send (send (send bed :translate #f(-350 -50 120) :world) :rotate -pi/2 :z) :rotate pi/2 :y))
	#|(send (send *fetch* :copy-worldcoords) :transform (send bed :translate #f(-300 0 190) :world))|# 
        :debug-view t )
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector) 5000)
  (send *ri* :wait-interpolation )  
)

(defun see-fetch ()
   (send *irtviewer* :look-all
(geo::make-bounding-box
 (flatten (send-all (send *fetch* :bodies) :vertices))))
)
#|(defun hand-forward ()
  (setq current-trans (send (send *fetch* :copy-worldcoords) :transform))
  (print current-trans)
  )|#



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

(defun search-mark ()
  (look-down)
  (unix::sleep 3)
  (setq bed nil)
  (ros::rate 10)
  (while (null bed)
    (unless (boundp '*tfl*) (setq *tfl* (instance transform-listener :init)))
    (setq bed (send *tfl* :lookup-transform "/base_link" "/sample1" (ros::time 0)))
    (ros::sleep)
    )
  (ros::ros-info "msg [~A]" bed)
  ;;(send bed :draw-on :flush t :size 10000000 :color #f(1 0 0))
  (setq c1 (make-cube 100 100 1000))
  (send c1 :move-to  (send (send *fetch* :copy-worldcoords) :transform bed) :world)
  (objects (list *fetch* *scene* c1))
  )

(defun receive-hand-message ()
  (setq hand-message (send (one-shot-subscribe "/chatter" std_msgs::Int16) :data)) 
  (ros::ros-info "msg [~A]" hand-message)

)

(defun set-hand-spray ()
 (send *fetch* :rarm :inverse-kinematics
	(send (send *fetch* :copy-worldcoords) :transform (send (send (send (send bed :copy-worldcoords) :translate #f(-420 90 115) :world) :rotate  0 :z) :rotate  pi/2 :y)) #|x y z|# #|1075(-420 -160 115) 15(-415 -150 110)|#
	#|(send (send *fetch* :copy-worldcoords) :transform (send bed :translate #f(-300 0 190) :world))|# 
        :debug-view t )
  (send *irtviewer* :draw-objects) ;; update viewer
  (send *ri* :angle-vector (send *fetch* :angle-vector))
  (send *ri* :wait-interpolation )
  ()
  )

(defun spraing-hand ()
  (move-hand 100 0 0)
  (move-hand -100 0 0)
  
  (send *fetch* :rarm :wrist-r :joint-angle pi)
  (send *irtviewer* :draw-objects)
  (send *ri* :angle-vector (send *fetch* :angle-vector) 2000)
  (send *ri* :wait-interpolation)

  (move-hand 100 0 0)
  (move-hand -100 0 0)
  )

(defun clean-outside-loop-from-search-to-reset ()
  (setq hand-message 0)
  (while (eql hand-message 0)
     (search-mark)
     (set-hand-outside)
     (move-hand 180 0 0)
     (receive-hand-message)
     (if (eql hand-message 0)
	 (progn (print "clean-failed") (move-hand -180 0 0))
       )
     )
  (print "clean-successs")
  (move-hand 0 0 50)
  (move-hand 0 0 -50)
  (move-hand -200 0 0)
  (return-hand)
  (reset-pose)
  )

(defun clean-outside-from-search-to-reset ()
  (search-mark)
  (set-hand-outside)
  (clean-handle)
  (return-hand)
  (reset-pose)
  )

(defun whole-cleaning-process-73A3 ()
  (reset-pose)
  (search-mark)
  (hold-hand)
  (search-mark)
  (set-hand-spray)
  (spraing-hand)
  (clean-outside-loop-from-search-to-reset)
  )

(defun whole-cleaning-process-inside()
  (reset-pose)
  (search-mark)
  (hold-hand)
  (search-mark)
  (set-hand-inside)
  (clean-handle)
  (return-hand)
  (reset-pose)
  )

(defun whole-cleaning-process-outside()
  (reset-pose)
  (search-mark)
  (hold-hand)
  (clean-outside-loop-from-search-to-reset)
)

(defun whole-process()
  (reset-pose)
  (move-to-73A3-outside-door-front)
  (set-pos-outside)
  (whole-cleaning-process-73A3)
  (move-to-73A2-outside-door-front)
  (set-pos-outside)
  (whole-cleaning-process-outside)
  (move-to-73B1-outside-door-front)
  (set-pos-outside)
  (whole-cleaning-process-outside)
)
