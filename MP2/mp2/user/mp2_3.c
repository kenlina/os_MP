#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/vm.h"

#define PG_SIZE 4096
#define NR_PG 16

int main(int argc, char *argv[]) {
  vmprint();
  char *ptr = malloc(NR_PG * PG_SIZE);
  vmprint();
  madvise((uint64) ptr + 10*PG_SIZE, 2*PG_SIZE , MADV_NORMAL);
  vmprint();
  madvise((uint64) ptr + 10*PG_SIZE, 2*PG_SIZE , MADV_DONTNEED);
  vmprint();
  madvise((uint64) ptr + 10*PG_SIZE, 2*PG_SIZE , MADV_WILLNEED);
  vmprint();
  exit(0);
}
