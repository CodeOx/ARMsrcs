
	mov r0,@address of switches
	mov r1,@address of led
	mov r2,@address of memory
	mov r6,@address of sevenseg

Loop:
	ldr r3,[r0]
	mov r5,#0
	mov r4,#0
	Thousands:
		cmp r3,#1000
		subge r3,#1000
		addge r4,#1
		bge Thousands
	mov r4,r4,lsl #12
	add r5,r5,r4

	mov r4,#0
	Hundreds:
		cmp r3,#100
		subge r3,#100
		addge r4,#1
		bge Hundreds
	mov r4,r4,lsl #8
	add r5,r5,r4

	mov r4,#0
	Tens:
		cmp r3,#10
		subge r3,#10
		addge r4,#1
		bge Tens
	mov r4,r4,lsl #4
	add r5,r5,r4

	mov r4,#0
	Ones:
		cmp r3,#1
		subge r3,#1
		addge r4,#1
		bge Hundreds
	add r5,r5,r4
	str r5,[r1]
	str r5,[r6]
	b Loop
		

