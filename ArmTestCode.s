@move instructions
mov r0,#100
str r0,[r0]
sub r0,r0,#10
ldr r1,[r0,#10]!
mov r1,#20
mov r0,#0
ldr r1,[r0,#4092] @load from swithces
str r1,[r0,#4093] @output to LED
str r1,[r0,#4094] @output to LED


@branch testing
mov r0,#0
b L
add r0,r0,#4
mov r0,#8
L:
add r0,r0,#1

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