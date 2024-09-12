#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc != 3){
    fprintf(2, "Usage: symln old new\n");
    exit(1);
  }
  if(symlink(argv[1], argv[2]) < 0)
    fprintf(2, "symlink %s %s: failed\n", argv[1], argv[2]);
  exit(0);
}
