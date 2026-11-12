#Samantha Salgado Garcia
#Erick Gael Gonzalez Aguilar
.text
main:
	addi 	s0, zero, 3	#s0 - numero de elementos

	addi	t0, zero, 36	#t0 - offset
	mul	t1, t0, s0	#multiplicamos por el numero de discos para obtener un rectangulo tipo canvas en memoria

	sub	sp, sp, t1	#restar el tamano a sp

	add	s1, zero, sp	#s1 - pointer Torre 1
	addi	s2, s1, 4	#s2 - pointer Torre 2
	addi	s3, s2, 4	#s3 - pointer Torre 3

	#se liberan t0 y t1
	add	t0, s0, zero		#t0 - copia de s0
	add	t1, s1, zero		#t1 - pointer a Torre 1
	jal	ra, init_torre_1	#inicializar valores en la Torre 1
	#se liberan t0 y t1
	
	
	ble	s0, zero, end
	sub 	sp, sp, t0
	jal	ra, hanoi
	jal	zero, end
	
	#s0 = n; s1 = from; s2 = aux; s3 = to
hanoi:
	addi	t0, zero, 1
	if_base_case:
		bne	s0, t0, endif_base_case	#if(n == 1):
		add	a2, s1, zero			#arg1 = from
		add	a3, s3, zero			#arg2 = to
	
		addi	sp, sp, -4			#se aparta memoria
		sw	ra, 0(sp)			#se carga ra a memoria
		jal	ra, move			#se mueven los discos
		lw	ra, 0(sp)			#se carga ra de memoria
		addi	sp, sp, 4			#se libera memoria
		jalr	zero, 0(ra)			#return
	endif_base_case:				#endif
	
		addi	sp, sp, -20			#se aparta memoria
		sw	s0, 0(sp)			#respaldo de n en memoria
		sw	s1, 4(sp)			#respaldo de from en memoria
		sw	s2, 8(sp)			#respaldo de aux en memoria
		sw	s3, 12(sp)			#respaldo de to en memoria
		sw	ra, 16(sp)			#respaldo de ra en memoria
		
		addi	s0, s0, -1			#n = n - 1
		lw	s2, 12(sp)			#swap de aux por to
		lw	s3, 8(sp)			#swap de to por aux
		
		jal	ra, hanoi			#llamada recursiva
		
		lw	s0, 0(sp)			#cargar respaldo de n de memoria
		lw	s1, 8(sp)			#swap de from por aux
		lw	s2, 4(sp)			#swap de aux por from
		lw	s3, 12(sp)			#cargar respaldo de to de memoria
		
		lw	a2, 4(sp)			#arg1 = from
		lw	a3, 12(sp)			#arg2 = to
		
		jal 	ra, move			#movemos los discos
		
		addi	s0, s0, -1			#n = n - 1
		
		jal	ra, hanoi			#llamada recursiva
					
		lw	ra, 16(sp)
		addi	sp, sp, 20			#liberamos memoria
		jalr	zero, 0(ra)			#regresamos a donde fue llamada la funcion
			
		
		

	#a2 = from; a3 = to
move:
	a2_start_loop:				#buscar el numero del tope en la torre from
		lw	t0, 0(a2)			#
		beq	t0, zero, a2_end_loop	#
		addi	a2, a2, 32		#
		jal	zero, a2_start_loop	#
	a2_end_loop:				#
		addi	a2, a2, -32		#
	
	s3_start_loop:				#buscar el espacio vacio mas proximo en la torre to
		lw	t0, 0(a3)			#
		beq	t0, zero, a3_end_loop	#
		addi	a3, a3, 32		#
		jal	zero, s3_start_loop	#
	a3_end_loop:				
	lw	t0, 0(a2)			#carga de memoria el valor del disco mas alto
	sw	zero, 0(a2)			#carga a memoria el valor 0
	sw	t0, 0(a3)			#carga a memoria el valor del disco
	jalr	zero, 0(ra)			#return

init_torre_1:	
	sw	t0, 0(t1)			#inicializar valores de la torre 1
	addi	t0, t0, -1			#
	addi	t1, t1, 32			#
	bgt	t0, zero, init_torre_1		#
	jalr	zero, 0(ra)			#

end: nop
 
