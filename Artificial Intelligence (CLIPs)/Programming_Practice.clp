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