#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"
#include "kernel/fs.h"
#define fail(msg) do {printf("FAILURE: " msg "\n"); failed = 1; goto done;} while (0);
static int failed = 0;

static void
private1()
{
  char buf[BSIZE];
  int fd, i, blocks;
  int target = 6666;

  fd = open("big.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    fail("bigfile: cannot open big.file for writing\n");
  }

  blocks = 0;
  while(1){
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
      printf(".");
    if(blocks == target)
      break;
  }
  printf("\nwrote %d blocks\n", blocks);
  if(blocks != target) {
    fail("bigfile: file is too small\n");
  }

  close(fd);
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    fail("bigfile: cannot re-open big.file for reading\n");
  }
  for(i = 0; i < blocks; i++){
    int cc = read(fd, buf, sizeof(buf));
    if(cc <= 0){
      fail("bigfile: read error\n");
    }
    if(*(int*)buf != i){
      fail("bigfile: read the wrong data\n");
    }
  }

  printf("private testcase 1: ok\n");

done:
  close(fd);
  unlink("big.file");
}

static void
private23()
{
  char buf[BSIZE];
  int fd, i, blocks;
  int target = 66666;

  fd = open("big.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    fail("bigfile: cannot open big.file for writing\n");
  }

  blocks = 0;
  while(1){
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
      printf(".");
    if(blocks == target)
      break;
  }
  printf("\nwrote %d blocks\n", blocks);
  if(blocks != target) {
    fail("bigfile: file is too small\n");
  }
  printf("private testcase 2: ok\n");


  close(fd);
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    fail("bigfile: cannot re-open big.file for reading\n");
  }
  for(i = 0; i < blocks; i++){
    int cc = read(fd, buf, sizeof(buf));
    if(cc <= 0){
      fail("bigfile: read error\n");
    }
    if(*(int*)buf != i){
      fail("bigfile: read the wrong data\n");
    }
  }
  printf("private testcase 3: ok\n");

done:
  close(fd);
  unlink("big.file");
}

int
main()
{
  private1();
  private23();

  exit(failed);
}
