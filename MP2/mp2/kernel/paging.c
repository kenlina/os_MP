#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

/* NTU OS 2024 */
/* Allocate eight consecutive disk blocks. */
/* Save the content of the physical page in the pte */
/* to the disk blocks and save the block-id into the */
/* pte. */
char *swap_page_from_pte(pte_t *pte) {
  char *pa = (char*) PTE2PA(*pte);
  uint dp = balloc_page(ROOTDEV);

  write_page_to_disk(ROOTDEV, pa, dp); // write this page to disk
  *pte = (BLOCKNO2PTE(dp) | PTE_FLAGS(*pte) | PTE_S) & ~PTE_V;

  return pa;
}

/* NTU OS 2024 */
/* Page fault handler */
int handle_pgfault() {
  /* Find the address that caused the fault */
  /* uint64 va = r_stval(); */
  uint64 va = PGROUNDDOWN((uint64)r_stval());
  if(va >= MAXVA) {
      panic("handle_pgfault: invaild r_stval");
  }
  struct proc *p = myproc();
  pte_t *pte = walk(p->pagetable, va, 0);

  // process swapped page
  if(*pte & PTE_S){
    char *pa = kalloc();
    memset(pa, 0, PGSIZE);
    uint64 blockno = PTE2BLOCKNO(*pte);
    begin_op();
    read_page_from_disk(ROOTDEV, pa, blockno);
    bfree_page(ROOTDEV, blockno);
    end_op();
    *pte = PA2PTE((uint64)pa) | PTE_FLAGS(*pte);
    *pte = (*pte & ~PTE_S) | PTE_V;
    #if defined(PG_REPLACEMENT_USE_LRU) || defined(PG_REPLACEMENT_USE_FIFO)
    walk(p->pagetable, va, 0);
    #endif
  }
  else if(pte == 0 || (*pte & PTE_V) == 0){
    // process invalid page
    char *mem = kalloc();
    if(mem == 0){
        panic("handle_pgfault: kalloc failed");
    } 
    memset(mem, 0, PGSIZE);
    if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, PTE_R | PTE_U | PTE_W | PTE_X) != 0){
        kfree(mem);
        panic("handle_pgfault: mappages failed");
    }
  }

  return 0;
}
