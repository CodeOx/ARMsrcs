@move instructions
mov r0,#31
mov r1,#20
mvn r2,r0
mov r3,r1,lsl #2

@arithmetic
add r2,r0,r1
sub r3,r0,r1
mul r4,r0,r1
rsb r5,r0,r1
add r2,r2,#1
sub r3,r2,#1
rsb r5,r5,#0
add r2,r0,r1,lsr #2

@branch testing
mov r0,#0
b L
add r0,r0,#1
L:
add r0,r0,#1

@load/store testing