(deffacts network-topology
    (link start "Node 1" end "Node 2" cost 4)
    (link start "Node 1" end "Node 3" cost 2)
    (link start "Node 2" end "Node 3" cost 5)
	(link start "Node 2" end "Node 4" cost 10)
	(link start "Node 3" end "Node 4" cost 3)
)

(deftemplate path
    (slot start)
    (slot end)
    (multislot nodes)
    (slot total-cost)
)

(deffacts network-paths
	(path (start 1) (end 2) (total-cost 4))
	(path (start 1) (end 3) (total-cost 2))
	(path (start 2) (end 3) (total-cost 5))
	(path (start 2) (end 4) (total-cost 10))
	(path (start 3) (end 4) (total-cost 3))
)

(defrule indirect-paths
	(path (start ?start) (end ?temp) (total-cost ?c1))
	(path (start ?temp) (end ?end) (total-cost ?c2))
	=>
	(assert (path (start ?start) (end ?end) (nodes ?temp) (total-cost (+ ?c1 ?c2))))
)

(defrule print-effective
(path (start 1) (end 4) (nodes $?nodes) (total-cost ?cost1))
(not (path (start 1) (end 4) (nodes $?nodes2) (total-cost ?cost2&:(> ?cost1 ?cost2))))
=>
(printout t "The most cost-effective path from Node 1 to Node 4 is: 1 " $?nodes " 4, with a total cost of: " ?cost1 crlf)
)





(defrule print-paths
(path (start ?start) (end ?end) (nodes $?nodes) (total-cost ?cost))
=>
(printout t "Cost of path " ?start $?nodes ?end " is " ?cost crlf))


(defrule print-4
(path (start 1) (end 4) (nodes $?nodes) (total-cost ?cost))
=>
(printout t "A path from Node 1 to Node 4 is: 1" $?nodes "4 , with a total cost of: " ?cost crlf))


(defrule print-effective
(path (start 1) (end 4) (nodes ?nodes) (total-cost ?cost1))
(not (path (start 1) (end 4) (nodes ?nodes) (total-cost ?cost2&:(> ?cost1 ?cost2))))
(not (test (= ?cost1 12)))
=>
(printout t "The most cost-effective path from Node 1 to Node 4 is: 1 " $?nodes " 4, with a total cost of: " ?cost1 crlf)
)
