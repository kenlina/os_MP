#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/vm.h"


#define PG_SIZE 4096
#define NR_PG 16

/* vmprint + swapped + page fault + fifo + pin */

/*
 * Note that the tenth(count from index 3 from vmprint table) pte
 * will the on top of queue for FIFO page replacement algorithm
 */

int main(int argc, char *argv[]) {
  vmprint();
  char *ptr = malloc(NR_PG * PG_SIZE);
  // vmprint(); // add
  // pgprint(); // add

  madvise((uint64) ptr + 9*PG_SIZE, PG_SIZE - 1,  MADV_PIN); // pin the tenth pte
  printf("After madvise(MADV_PIN)\n");
  vmprint();
  // pgprint(); // add

  madvise((uint64) ptr + 2*PG_SIZE, PG_SIZE - 1,  MADV_DONTNEED); // 3rd pages are swapped out
  printf("After madvise(MADV_DONTNEED)\n");
  vmprint();
  // pgprint(); // add

  char *qtr = ptr + 2*PG_SIZE;
  *qtr = 'a'; // page fault and swap in, should skip tenth pte
  printf("Page fault and swap in\n");
  vmprint();

  pgprint();
  exit(0);
}
