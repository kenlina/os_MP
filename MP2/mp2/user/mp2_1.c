#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/vm.h"

int main(int argc, char *argv[]) {
  vmprint();
  exit(0);
}
