
	mov r0,#0
Loop:
	ldr r3,[r0,#4092] @load from switches
	mov r6,#1
	str r6,[r0,#4093]	@store to led
	mov r4,#0
	mov r5,#0
	Thousands:
		cmp r3,#1000
		str r3,[r0,#4093]	@store to led
		subge r3,r3,#1000
		str r3,[r0,#4093]	@store to led
		addge r4,r4,#1
		bge Thousands
	mov r4,r4,lsl #12
	add r5,r5,r4

	mov r6,#2
	str r6,[r0,#4093]	@store to led

	mov r4,#0
	Hundreds:
		cmp r3,#100
		subge r3,r3,#100
		addge r4,r4,#1
		bge Hundreds
	mov r4,r4,lsl #8
	add r5,r5,r4

	mov r6,#3
	str r6,[r0,#4093]	@store to led

	mov r4,#0
	Tens:
		cmp r3,#10
		subge r3,r3,#10
		addge r4,r4,#1
		bge Tens
	mov r4,r4,lsl #4
	add r5,r5,r4

	mov r6,#4
	str r6,[r0,#4093]	@store to led

	add r5,r5,r3
	str r5,[r0,#4094]	@store to ssd
	b Loop
	
		

