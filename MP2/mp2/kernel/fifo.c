#include "fifo.h"

#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

void q_init(queue_t *q){
	for(int i = 0; i < PG_BUF_SIZE; ++i){
		q->bucket[i] = 0;
	}
	q->size = 0;
}

int q_push(queue_t *q, uint64 e){
	if(*((pte_t*)e) & PTE_S || *((pte_t*)e) & PTE_V == 0) return 0;
	int idx = q_find(q,e);
	if(idx != -1){
		// e is already in q
		return 0;
	}
	else if(!q_full(q)){
		// e is not in q && q not full
		q->bucket[q->size++] = e;
	}
	else{
		// e is not in q && q full
		int replace_idx = -1;
		for(int i = 0; i < q->size; ++i){
			pte_t *pte = (pte_t*)q->bucket[i];
			if(*pte & PTE_P && *pte & PTE_V && *pte != 0x0101010101010101) {
				// printf("pte flag: %p, ", PTE_FLAGS((uint64)*pte));
				// printf("PTE_V: %p, ", *pte & PTE_V ); 
				// printf("pte: %p is pinned\n", q->bucket[i]);
				continue;
			}
			replace_idx = i; 
			break;
		}
		if(replace_idx == -1) return -1;
		q_pop_idx(q, replace_idx);
		q->bucket[q->size++] = e;
	}
	return 0;
}

uint64 q_pop_idx(queue_t *q, int idx){
	if(q_empty(q) || idx >= q->size) return -1;
	uint64 remove = q->bucket[idx];
	for(int i = idx; i < q->size - 1; ++i){
		q->bucket[i] = q->bucket[i + 1];
	}
	q->size -= 1;
	return remove;
}

int q_empty(queue_t *q){
	return (q->size == 0);
}

int q_full(queue_t *q){
	return (q->size == PG_BUF_SIZE);
}

int q_clear(queue_t *q){
	for(int i = 0; i < PG_BUF_SIZE; ++i){
		q->bucket[i] = 0;
	}
	q->size = 0;
	return 0;
}

int q_find(queue_t *q, uint64 e){
	for(int i = 0; i < q->size; ++i){
		if(q->bucket[i] == e) return i;
	}
	return -1;
}
