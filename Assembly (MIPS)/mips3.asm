addi $s0, $s0, 5
addi $s1, $s1, 10 

add $a0, $s0, $zero 	# set x and y as arguments  
add $a1, $s1, $zero  
add $s2, $s0, $s1	# x + y 
jal sum			# jump to Sum function  
add $s2, $s2, $v0	# z = x + y + Sum(x, y);  
j end			# skip functions  
  
sum:  
addi $sp, $sp, -12 	# adjust stack for 3 items 
sw $ra, 8($sp) 		# save return address 
sw $a0, 4($sp) 		# save argument m 
sw $a1, 0($sp) 		# save argument n 
addi $t2, $a1, 1	# n + 1 
addi $t3, $a0, -1	# m – 1 
add $a0, $t2, $zero	# $a0 = n + 1 
add $a1, $t3, $zero	# $a1 = m - 1 
jal dif 
add $t0, $v0, $zero	# p = dif(n+1, m-1) 
lw $a0, 4($sp)		# restore arguments 
lw $a1, 0($sp) 
addi $t2, $a0, 1	# m + 1 
addi $t3, $a1, -1	# n – 1 
add $a0, $t2, $zero	# $a0 = m + 1 
add $a1, $t3, $zero	# $a1 = n - 1 
jal dif 
add $t1, $v0, $zero	# q = dif(m+1, n-1) 
lw $ra, 8($sp) 		# restore return address 
lw $a0, 4($sp) 		# restore argument m 
lw $a1, 0($sp) 		# restore argument n 
add $v0, $t0, $t1	# return p + q 
jr $ra  

dif:  
sub $v0, $a1, $a0  
jr $ra  

end: 
