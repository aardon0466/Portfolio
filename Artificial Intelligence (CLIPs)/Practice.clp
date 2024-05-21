(deftemplate path
(multislot nodes)
(slot cost))

(deffacts direct-paths
(path (nodes f e) (cost 2))
(path (nodes e b) (cost 2))
(path (nodes b a) (cost 3))
(path (nodes a d) (cost 2))
(path (nodes d c) (cost 1))
(path (nodes c a) (cost 1))
(path (nodes b c) (cost 2))
(path (nodes f c) (cost 3)))

(defrule indirect-paths
(path (nodes $?begin ?temp) (cost ?first))
(path (nodes ?temp $?end) (cost ?second))
=>
(assert (path (nodes ?begin ?temp ?end) (cost (+ ?first ?second)))))

(defrule print-paths
(path (nodes $?nodes) (cost ?cost))
=>
(printout t "Cost of path " $?nodes " is " ?cost crlf))







(defrule indirect-paths
(path (nodes $?begin ?temp) (cost ?first))
(path (nodes ?temp $?end) (cost ?second))
(path (nodes ?begin ?temp&~?begin&~?end) (cost ?first))
(path (nodes ?temp&~?begin&~?end ?end) (cost ?second))
=>
(assert (path (nodes ?begin ?temp ?end) (cost (+ ?first ?second)))))



(defrule indirect-paths
(path (nodes ?begin ?temp) (cost ?first))
(path (nodes ?temp ?end) (cost ?second))
=>
(assert (path (nodes ?begin ?temp ?end) (cost (+ ?first ?second)))))




;The Water Jug Puzzle

;facts

(deffacts initialization
(state 0 0)
(path [ 0 0 ]))


;Operations

;Fill 4-gallon from tap
(defrule op1
(path $?begin [ ?x ?y ])
(test (< ?x 4))
(not (exists (state 4 ?y)))
=>
(assert (state 4 ?y))
(assert (path $?begin [ ?x ?y ] [ 4 ?y ])))

;Fill 3-gallon from tap
(defrule op2
(path $?begin [ ?x ?y ])
(test (< ?y 3))
(not (exists (state ?x 3)))
=>
(assert (state ?x 3))
(assert (path $?begin [ ?x ?y ] [ ?x 3 ])))

;Fill 4-gallon from 3-gallon
(defrule op3
(path $?begin [ ?x ?y ])
(test (< ?x 4))
(test (>= (+ ?x ?y) 4))
(not (exists (state 4 =(- (+ ?x ?y) 4))))
=>
(assert (state 4 =(- (+ ?x ?y) 4)))
(assert (path $?begin [ ?x ?y ] [ 4 =(- (+ ?x ?y) 4) ])))

;Fill 3-gallon from 4-gallon
(defrule op4
(path $?begin [ ?x ?y ])
(test (< ?y 3))
(test (>= (+ ?x ?y) 3))
(not (exists (state =(- (+ ?x ?y) 3) 3)))
=>
(assert (state =(- (+ ?x ?y) 3) 3))
(assert (path $?begin [ ?x ?y ] [ =(- (+ ?x ?y) 3) 3 ])))

;Empty 4-gallon into 3-gallon
(defrule op5
(path $?begin [ ?x ?y ])
(test (> ?x 0))
(test (<= (+ ?x ?y) 3))
(not (exists (state 0 =(+ ?x ?y))))
=>
(assert (state 0 =(+ ?x ?y)))
(assert (path $?begin [ ?x ?y ] [ 0 =(+ ?x ?y) ])))

;Empty 3-gallon into 4-gallon
(defrule op6
(path $?begin [ ?x ?y ])
(test (> ?y 0))
(test (<= (+ ?x ?y) 4))
(not (exists (state =(+ ?x ?y) 0)))
=>
(assert (state =(+ ?x ?y) 0))
(assert (path $?begin [ ?x ?y ] [ =(+ ?x ?y) 0 ])))

;Empty 4-gallon into sink
(defrule op7
(path $?begin [ ?x ?y ])
(test (> ?x 0))
(not (exists (state 0 ?y)))
=>
(assert (state 0 ?y))
(assert (path $?begin [ ?x ?y ] [ 0 ?y ])))

;Empty 3-gallon into sink
(defrule op8
(path $?begin [ ?x ?y ])
(test (> ?y 0))
(not (exists (state ?x 0)))
=>
(assert (state ?x 0))
(assert (path $?begin [ ?x ?y ] [ ?x 0 ])))

(defrule print-solutions
(path [ 0 0 ] $?middle [ 2 ?y ])
=>
(bind $?solution (create$ [ 0 0 ] $?middle [ 2 ?y ]))
(printout t "Solution: " $?solution crlf))
