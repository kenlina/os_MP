#include "lru.h"

#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

void lru_init(lru_t *lru){
	for(int i = 0; i < PG_BUF_SIZE; ++i){
		lru->bucket[i] = 0;
	}
	lru->size = 0;
}

int lru_push(lru_t *lru, uint64 e){ 
	if(*((pte_t*)e) & PTE_S || *((pte_t*)e) & PTE_V == 0) return 0;
	int idx = lru_find(lru,e);
	if(idx != -1){
		// e is already in lru
		for(int i = idx; i < lru->size - 1; ++i){
			lru->bucket[i] = lru->bucket[i + 1];
		}
		lru->bucket[lru->size - 1] = e;
		
	}
	else if(!lru_full(lru)){
		// e is not in lru && lru not full
		lru->bucket[lru->size++] = e;
	}
	else{
		// e is not in lru && lru full
		int replace_idx = -1;
		for(int i = 0; i < lru->size; ++i){
			pte_t *pte = (pte_t*)lru->bucket[i];
			if(*pte & PTE_P && *pte & PTE_V && *pte != 0x0101010101010101){
			// if(*pte & PTE_P && *pte & PTE_V) {
				// printf("lru_push: PTE: %p, ", *pte); 
				// printf("PTE flags: %p, ", PTE_FLAGS((uint64)*pte));
				// printf("PTE_V: %p, ", *pte & PTE_V ); 
				// printf("pte: %p is pinned\n", lru->bucket[i]);
				continue;
			}
			replace_idx = i; 
			break;
		}
		if(replace_idx == -1) return -1;
		lru_pop(lru, replace_idx);
		lru->bucket[lru->size++] = e;
	}
	return 0;
}

uint64 lru_pop(lru_t *lru, int idx){
	if (lru_empty(lru) || idx >= lru->size) {
        return -1; 
    }
	uint64 remove = lru->bucket[idx];
	for(int i = idx; i < lru->size - 1; ++i){
		lru->bucket[i] = lru->bucket[i + 1];
	}
	lru->size -= 1;
	return remove;
}

int lru_empty(lru_t *lru){
	return (lru->size == 0);
}

int lru_full(lru_t *lru){
	return (lru->size == PG_BUF_SIZE);
}

int lru_clear(lru_t *lru){
	for(int i = 0; i < PG_BUF_SIZE; ++i){
		lru->bucket[i] = 0;
	}
	lru->size = 0;
	return 0;
}

int lru_find(lru_t *lru, uint64 e){
	for(int i = 0; i < lru->size; ++i){
		if(lru->bucket[i] == e) return i;
	}
	return -1;
}
