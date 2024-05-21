(deffacts letters-and-digits
(letter E)
(letter H)
(letter N)
(letter O)
(letter W)
(digit 0)
(digit 1)
(digit 2)
(digit 3)
(digit 4)
(digit 5)
(digit 6))

(defrule all-replacements
(letter ?letter)
(digit ?digit)
=>
(assert (replace ?letter ?digit)))

(defrule forward-checking
;checking the 1’s place
(replace E ?e)
(replace O ?o&~?e)
(test (= (mod (+ ?e ?e) 10) ?o))

;checking up to 10’s place
(replace W ?w&~?e&~?o)
(replace H ?h&~?w&~?e&~?o)
(replace N ?n&~?h&~?w&~?e&~?o)
(test (= (mod (+ ?e ?e (* ?w 10) (* ?h 10)) 100) (+ (* ?n 10) ?o)))
=>
;display all solutions
(printout t "E=" ?e ", H=" ?h ", N=" ?n ", O=" ?o ", W=" ?w crlf)
(printout t "   WE           " ?w ?e crlf)
(printout t " + HE         + " ?h ?e crlf)
(printout t " ------  ==>  ------" crlf)
(printout t "   NO           " ?n ?o crlf crlf)) 