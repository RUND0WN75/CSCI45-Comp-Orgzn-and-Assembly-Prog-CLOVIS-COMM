//YOU: Insert the first SIZE/2 elements from randos into hash_table using linear probing or whatever hash method you want
//Hash_table is of size SIZE
//void asm_hash_insert(int *hash_table, int *randos, int SIZE);
.global asm_hash_insert
asm_hash_insert:
/*
hash_table = r4
randos = r5
SIZE = r6
address = r7
*/
push {lr}
push {r4-r12}
mov r1, #0
loop:
	add r1, #1 //i++
	mov r8, r6, lsr #1 //  SIZE/2
	cmp r1, r8
	bgt return
	ldr r9, [r0, r5] //randos[i]
	mov r7, r8 //size_t address
	//add 
	bal loop

//YOU: Return true or false based on if the key is in the table
//Hash_table is of size SIZE
//bool asm_hash_search(int *hash_table, int key, int SIZE); 
.global asm_hash_search
asm_hash_search:
push {lr}
push {r4-r12}
mov r1, #0
top:
	add r1, #1 //i++
	cmp r1, r6
	bgt return
	bal top

return: 
	pop {r4-r12}
	pop {pc}
