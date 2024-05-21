(deffacts letters-and-digits
(letter A)
(letter C)
(letter D)
(letter E)
(letter G)
(letter O)
(letter P)
(letter T)
(digit 0)
(digit 1)
(digit 2)
(digit 3)
(digit 4)
(digit 5)
(digit 6)
(digit 7)
(digit 8)
(digit 9))

(defrule all-replacements
(letter ?letter)
(digit ?digit)
=>
(assert (replace ?letter ?digit)))

(defrule forward-checking
;checking the 1’s place
(replace T ?t)
(replace G ?g&~?t)
(test (= (mod (+ ?t ?g) 10) ?t))

;checking up to 10’s place
(replace A ?a&~?t&~?g)
(replace O ?o&~?t&~?g&~?a)
(replace E ?e&~?o&~?t&~?g&~?a)
(test (= (mod (+ ?t ?g (* ?a 10) (* ?o 10)) 100) (+ (* ?e 10) ?t)))

;checking up to 100’s place
(replace C ?c&~?e&~?o&~?t&~?g&~?a)
(replace D ?d&~?c&~?e&~?o&~?t&~?g&~?a)
(replace P ?p&~?d&~?c&~?e&~?o&~?t&~?g&~?a)
(test (= (+ ?t ?g (* ?a 10) (* ?o 10) (* ?c 100) (* ?d 100)) (+ (* ?p 100) (* ?e 10) ?t)))
=>
;display all solutions
(printout t "A=" ?a ", C=" ?c ", D=" ?d ", E=" ?e ", G=" ?g ", O=" ?o ", P=" ?p  ", T=" ?t crlf)
(printout t "   " ?c ?a ?t crlf)
(printout t " + " ?d ?o ?g crlf)
(printout t " ------" crlf)
(printout t "   " ?p ?e ?t crlf crlf)) 