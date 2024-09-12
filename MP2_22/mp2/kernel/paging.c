#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"
#include "proc.h"

/* NTU OS 2022 */
/* Page fault handler */
int handle_pgfault() {
  struct proc *p = myproc();
  /* Find the address that caused the fault */
  uint64 va = PGROUNDDOWN((uint64)r_stval());
  if(va >= MAXVA) {
      panic("handle_pgfault: invaild r_stval");
  }
  pte_t *pte = walk(p->pagetable, va, 0);


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
  }
  else if(pte == 0 || (*pte & PTE_V) == 0){
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
