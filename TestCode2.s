
	mov r0,#0
Loop:
	ldr r3,[r0,#4092] @load from switches
	str r3,[r0,#4093]	@store to led
	mov r3,r3,lsl #4
	str r3,[r0,#4094]	@store to ssd
	b Loop
	
		

