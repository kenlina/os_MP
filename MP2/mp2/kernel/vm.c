#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "elf.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"
#include "fifo.h"
#include "lru.h"

// NTU OS 2024
// you may want to declare page replacement buffer here
// or other files
#ifdef PG_REPLACEMENT_USE_LRU
// TODO
lru_t lru[1];
#elif defined(PG_REPLACEMENT_USE_FIFO)
// TODO
queue_t q[1];
#endif

/*
 * the kernel's page table.
 */
pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.

extern char trampoline[]; // trampoline.S

// Make a direct-map page table for the kernel.
pagetable_t
kvmmake(void)
{
  pagetable_t kpgtbl;

  kpgtbl = (pagetable_t) kalloc();
  memset(kpgtbl, 0, PGSIZE);

  // uart registers
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);

  // virtio mmio disk interface
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

  // PLIC
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);

  // map kernel text executable and read-only.
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

  // map kernel data and the physical RAM we'll make use of.
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);

  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

  // map kernel stacks
  proc_mapstacks(kpgtbl);

  return kpgtbl;
}

// Initialize the one kernel_pagetable
void
kvminit(void)
{
  kernel_pagetable = kvmmake();
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
  w_satp(MAKE_SATP(kernel_pagetable));
  sfence_vma();
}

// get pte but not push into replacement buffer
pte_t *query_pte(pagetable_t pagetable, uint64 va)
{
  if(va >= MAXVA)
    panic("query_pte");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
        return 0;
    }
  }
  pte_t *pte = &pagetable[PX(0, va)];
  return pte;
}

// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
//
// The risc-v Sv39 scheme has three levels of page-table
// pages. A page-table page contains 512 64-bit PTEs.
// A 64-bit virtual address is split into five fields:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
  if(va >= MAXVA)
    panic("walk");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }

  pte_t *pte = &pagetable[PX(0, va)];

// NTU OS 2024
// pte is accessed, so determine how
// it affects the page replacement buffer here
  struct proc *p = myproc();
  
#ifdef PG_REPLACEMENT_USE_LRU
  // TODO
  if( va == (uint64)0x0000000000000000 || \
      va == (uint64)0x0000000000001000 || \
      va == (uint64)0x0000000000002000){ }
  else{
      if(lru_push(lru, pte) == -1){
          // panic("walk: lru_push failed");
      }
  } 
#elif defined(PG_REPLACEMENT_USE_FIFO)
  // TODO
  if( va == (uint64)0x0000000000000000 || \
      va == (uint64)0x0000000000001000 || \
      va == (uint64)0x0000000000002000){ }
  else{
      if(q_push(q, pte) == -1){
          // panic("walk: q_push failed");
      }
  } 
#endif
  return pte;
}

// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64
walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    return 0;

  pte = walk(pagetable, va, 0);
  if(pte == 0)
    return 0;
  if((*pte & PTE_V) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}

// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    panic("kvmmap");
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    panic("mappages: size");
  a = PGROUNDDOWN(va);
  last = PGROUNDDOWN(va + size - 1);
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
      return -1;
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");

    if(*pte & PTE_S) {
      /* NTU OS 2024 */
      /* int blockno = PTE2BLOCKNO(*pte); */
      /* bfree_page(ROOTDEV, blockno); */
      /* HACK: Do nothing here.
         The wait() syscall holds holds the proc lock and calls into this method.
         It causes bfree_page() to panic. Here we leak the swapped pages anyway.
      */
      continue;
    }

    if((*pte & PTE_V) == 0)
      continue;

    if(PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
  if(pagetable == 0)
    return 0;
  memset(pagetable, 0, PGSIZE);
  return pagetable;
}

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
  memmove(mem, src, sz);
}

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  // #ifdef PG_REPLACEMENT_USE_LRU
  // // TODO
  //   lru_clear(lru);
  // #elif defined(PG_REPLACEMENT_USE_FIFO)
  // // TODO
  //   q_clear(q);
  // #endif
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  for(a = oldsz; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  
  if(newsz >= oldsz)
    return oldsz;

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    }
  }
  kfree((void*)pagetable);
}

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
  if(sz > 0)
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
}

// Given a parent process's page table, copy
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
      kfree(mem);
      goto err;
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  pte = walk(pagetable, va, 0);
  if(pte == 0)
    panic("uvmclear");
  *pte &= ~PTE_U;
}

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = PGROUNDDOWN(dstva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
  }
  return 0;
}

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);

    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}

// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
        got_null = 1;
        break;
      } else {
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    return 0;
  } else {
    return -1;
  }
}

/* NTU OS 2024 */
/* Map pages to physical memory or swap space. */
int madvise(uint64 base, uint64 len, int advice) {
  struct proc *p = myproc();
  pagetable_t pgtbl = p->pagetable;

  if (base > p->sz || (base + len) > p->sz) {
    return -1;
  }

  if (len == 0) {
    return 0;
  }

  uint64 begin = PGROUNDDOWN(base);
  uint64 last = PGROUNDDOWN(base + len - 1);

  if (advice == MADV_NORMAL) {
      return 0;
  } else if (advice == MADV_WILLNEED) {
      for (uint64 va = begin; va <= last; va += PGSIZE){
          pte_t *pte = walk(pgtbl, va, 1);
          if(*pte & PTE_S){
              uint64 blockno = PTE2BLOCKNO(*pte);
              char *pa = kalloc();
              memset(pa, 0, PGSIZE);
              begin_op();
              read_page_from_disk(ROOTDEV, pa, blockno);
              bfree_page(ROOTDEV, blockno);
              end_op();
              *pte = PA2PTE(pa) | PTE_FLAGS(*pte);
              *pte &= ~PTE_S;
              *pte |= PTE_V; 
          }
          else if((*pte & PTE_V) == 0){
              uint64 pa = (uint64)kalloc();
              memset((void *)pa, 0, PGSIZE);
              *pte = PA2PTE(pa) |PTE_V|PTE_W|PTE_R|PTE_X|PTE_U;
          }
      }
      return 0;
  } else if (advice == MADV_DONTNEED) {
    begin_op();

    pte_t *pte;
    for (uint64 va = begin; va <= last; va += PGSIZE) {
      pte = walk(pgtbl, va, 0);
      if (pte != 0 && (*pte & PTE_V)) {
        char *pa = (char*) swap_page_from_pte(pte);
        if (pa == 0) {
          end_op();
          return -1;
        }
        kfree(pa);
      }
      #ifdef PG_REPLACEMENT_USE_LRU
      // TODO 
      if( lru_find(lru,(uint64)pte) != -1 ){
          lru_pop(lru, lru_find(lru,(uint64)pte));
      }
      #elif defined(PG_REPLACEMENT_USE_FIFO)
      // TODO
      if( q_find(q,(uint64)pte) != -1 ){
          q_pop_idx(q, q_find(q,(uint64)pte));
      }
      #endif
    }

    // NTU OS 2024
    // Swapped out page should not appear in
    // page replacement buffer
    // #ifdef PG_REPLACEMENT_USE_LRU
    // // TODO 
    // for (uint64 va = begin; va <= last; va += PGSIZE){
    //     pte = walk(pgtbl, va, 0);
    //     if(*pte & PTE_S && (lru_find(lru,(uint64)pte) != -1)){
    //         lru_pop(lru, lru_find(lru,(uint64)pte));
    //     }
    // }
    // #elif defined(PG_REPLACEMENT_USE_FIFO)
    // // TODO
    // #endif

    end_op();
    return 0;

  } else if(advice == MADV_PIN) {
      for (uint64 va = begin; va <= last; va += PGSIZE){
          pte_t *pte = walk(pgtbl, va, 0);
          // pte_t *pte = query_pte(pgtbl, va);
          if(*pte & PTE_V && pte != 0){
              *pte |= PTE_P;
          }
      }
      return 0;
  } else if(advice == MADV_UNPIN) {
      for (uint64 va = begin; va <= last; va += PGSIZE){
          pte_t *pte = walk(pgtbl, va, 0);
          // pte_t *pte = query_pte(pgtbl, va);
          if(*pte & PTE_V){
              *pte &= ~PTE_P;
          }
      }
      return 0;
  }
  else {
    printf("I'm down to wrong place\n");
    return -1;
  }
}

/* NTU OS 2024 */
/* print pages from page replacement buffers */
#if defined(PG_REPLACEMENT_USE_LRU) || defined(PG_REPLACEMENT_USE_FIFO)
void pgprint() {
  #ifdef PG_REPLACEMENT_USE_LRU
  // TODO
  printf("Page replacement buffers\n------Start------------\n");
  for(int i = 0; i < lru->size; ++i){
      pte_t *pte = (pte_t*)lru->bucket[i];
      printf("pte: %p", lru->bucket[i]);
      // if(*pte & PTE_P){
      //     printf(" P");
      // }
      printf("\n");
  }
  printf("------End--------------\n");
  #elif defined(PG_REPLACEMENT_USE_FIFO)
  // TODO
  printf("Page replacement buffers\n------Start------------\n");
  for(int i = 0; i < q->size; ++i){
      pte_t *pte = (pte_t*)q->bucket[i];
      printf("pte: %p", q->bucket[i]);
      // if(*pte & PTE_P){
      //     printf(" P");
      // }
      printf("\n");
  }
  printf("------End--------------\n");
  #endif
}
#endif

void test_flag(pagetable_t pagetable, int out){
    if(pagetable[out] & PTE_R) printf(" R");
    if(pagetable[out] & PTE_W) printf(" W");
    if(pagetable[out] & PTE_X) printf(" X");
    if(pagetable[out] & PTE_U) printf(" U");
    if(pagetable[out] & PTE_D) printf(" D");
    if(pagetable[out] & PTE_P) printf(" P");
    if(pagetable[out] & PTE_S) printf(" S");
    printf("\n");
}

void test_flag_swapped(pagetable_t pagetable, int out){
    if(pagetable[out] & PTE_R) printf(" R");
    if(pagetable[out] & PTE_W) printf(" W");
    if(pagetable[out] & PTE_X) printf(" X");
    if(pagetable[out] & PTE_U) printf(" U");
    if(pagetable[out] & PTE_S) printf(" S");
    printf("\n");
}


/* NTU OS 2024 */
/* Print multi layer page table. */
void vmprint(pagetable_t pagetable) {
  /* TODO */
  printf("page table %p\n", pagetable);

  // find last entry in this level first
  int last_out_print = -1;
  for (int temp_out = 511; temp_out >= 0; --temp_out) {
      if (pagetable[temp_out] & PTE_V) {
          last_out_print = temp_out;
          break;
      }
  }
  // iteratively check the entry
  for(int out = 0; out < 512; ++out){
      if(pagetable[out] & PTE_V){
          pte_t *pte_o = &pagetable[out];
          uint64 va_o = (uint64)out << PXSHIFT(2); // out layer is level so we shift by 2
          pagetable_t pa_o = (pagetable_t)PTE2PA(pagetable[out]);
          printf("%s %d: pte=%p va=%p pa=%p V", "+--", out, pte_o, va_o, pa_o);
          test_flag(pagetable,out);
          // find last entry in this level 
          int last_mid_print = -1;
          for (int temp_mid = 511; temp_mid >= 0; --temp_mid) {
              if (pa_o[temp_mid] & PTE_V) {
                  last_mid_print = temp_mid;
                  break;
              }
          }
          // iteratively check the entry
          for(int mid = 0; mid < 512; ++mid){
              if(pa_o[mid] & PTE_V){
                  pte_t *pte_m = &pa_o[mid];
                  uint64 va_m = va_o | ((uint64)mid << PXSHIFT(1));
                  pagetable_t pa_m = (pagetable_t)PTE2PA(pa_o[mid]);
                  printf("%s", (out == last_out_print) ? "    " : "|   ");
                  printf("%s %d: pte=%p va=%p pa=%p V", "+--", mid, pte_m, va_m, pa_m);
                  test_flag(pa_o, mid);
                  // iteratively check the entry
                  for(int last = 0; last < 512; ++last){
                      if(pa_m[last] & PTE_V){
                          pte_t *pte_last = &pa_m[last];
                          uint64 va_last = va_m | ((uint64)last << PXSHIFT(0));
                          uint64 pa_last = PTE2PA(pa_m[last]);
                          printf("%s", (out == last_out_print) ? "    " : "|   ");
                          printf("%s", (mid == last_mid_print) ? "    " : "|   ");                    
                          printf("%s %d: pte=%p va=%p pa=%p V", "+--", last, pte_last, va_last, pa_last);
                          test_flag(pa_m, last);
                      }
                      if(pa_m[last] & PTE_S){
                          pte_t *pte_last = &pa_m[last];
                          uint64 va_last = va_m | ((uint64)last << PXSHIFT(0));
                          uint64 blockno = PTE2BLOCKNO(pa_m[last]);
                          printf("%s", (out == last_out_print) ? "    " : "|   ");
                          printf("%s", (mid == last_mid_print) ? "    " : "|   ");
                          printf("%s %d: pte=%p va=%p blockno=%p", "+--", last, pte_last, va_last, blockno);
                          test_flag_swapped(pa_m, last);
                      }
                  }
              }
          }
      }
  }
}
