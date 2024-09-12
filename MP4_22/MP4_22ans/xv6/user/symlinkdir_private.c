#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/riscv.h"
#include "kernel/fcntl.h"
#include "kernel/spinlock.h"
#include "kernel/sleeplock.h"
#include "kernel/fs.h"
#include "kernel/file.h"
#include "user/user.h"

#define fail(msg) do {printf("FAILURE: " msg "\n"); failed = 1; goto done;} while (0);
static int failed = 0;

static void private1(void);
static void private2(void);
static void private3(void);
static void cleanup(void);

int
main(int argc, char *argv[])
{
  cleanup();
  private1();
  cleanup();
  private2();
  cleanup();
  private3();
  exit(failed);
}

static void
cleanup(void)
{
  unlink("/testsymlink2/p");
  unlink("/testsymlink3/q");
  unlink("/testsymlink3/a");
  unlink("/testsymlink3/b");
  unlink("/testsymlink3/c");
  unlink("/testsymlink3/d");
  unlink("/testsymlink3/e");
  unlink("/testsymlink2/x");


  unlink("/testsymlink2");
  unlink("/testsymlink3");
}


static void
private1()
{
  int r, fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;
    
  printf("Start: test symlinks to directory\n");

  mkdir("/testsymlink2");
  mkdir("/testsymlink3");

  fd1 = open("/testsymlink2/p", O_CREATE | O_RDWR);
  if(fd1 < 0) fail("failed to open p");

  r = symlink("/testsymlink2", "/testsymlink3/q");
  if(r < 0)
    fail("symlink q -> p failed");

  fd2 = open("/testsymlink3/q/p", O_RDWR);
  if(fd2<0) fail("Failed to open /testsymlink3/q/p\n");

  c = '#';
  r = write(fd1, &c, 1);
  if(r!=1) fail("Failed to write to /testsymlink2/p\n");
  r = read(fd2, &c2, 1);
  if(r!=1) fail("Failed to read from /testsymlink3/q/p\n");
  if(c!=c2)
    fail("Value read from /testsymlink2/p differs from value written to /testsymlink3/q/p\n");

  close(fd1);

  chdir("/testsymlink3/q");
  fd1 = open("p", O_RDWR);
  r = read(fd1, &c2, 1);
  if(r!=1) fail("Failed to read from p in /testsymlink3/q\n");
  if(c!=c2)
    fail("Value read from p in /testsymlink3/q differed from value written to /testsymlink3/q/p\n");

  close(fd1);

  printf("private testcase 1: ok\n");
done:
  close(fd1);
  close(fd2);
}

static void
private2()
{
  int r;

  printf("Start: test symlinks to directory\n");

  mkdir("/testsymlink2");
  mkdir("/testsymlink3");

  r = symlink("/testsymlink2/p", "/testsymlink3/q");
  if(r < 0)
    fail("symlink q -> p failed");

  r = symlink("/testsymlink2/q", "/testsymlink3/p");
  if(r < 0)
    fail("symlink q -> p failed");

  if(chdir("/testsymlink3/q") >= 0){
    fail("Can not cd to infinite loop.");
  }

  printf("private testcase 2: ok\n");
done:
  return;
}

static void
private3()
{
  int fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;
    
  printf("Start: test symlinks to directory\n");

  mkdir("/testsymlink2");
  mkdir("/testsymlink3");


  // 2
  //  x -> /3
  // 3
  //  a -> /2/
  //  b -> /3/a

  // /3/b/x/c == /3/a/x/c == /2/x/c == /3/c
  if(symlink("/testsymlink3", "/testsymlink2/x")){
    fail("symlink failed 0");
  }
  if(symlink("/testsymlink2", "/testsymlink3/a")){
    fail("symlink failed 1");
  }

  if(symlink("/testsymlink3/a", "/testsymlink3/b")){
    fail("symlink failed 2");
  }

  // /testsymlink3/b/x/c == /testsymlink3/c
  fd1 = open("/testsymlink3/b/x/c", O_CREATE | O_RDWR);
  if(fd1<0) fail("Failed to open /testsymlink3/b/x/c");

  fd2 = open("/testsymlink3/c", O_RDWR);
  if(fd2<0) fail("Failed to open /testsymlink3/c\n");

  c = '#';
  if(write(fd1, &c, 1) != 1) fail("Failed to write /testsymlink3/d/x/c\n");
  if (read(fd2, &c2, 1) != 1) fail("Failed to read /testsymlink3/c\n");
  if (c != c2) fail("Read unequal to write.\n");

  printf("private testcase 3: ok\n");
done:
  close(fd1);
  close(fd2);
  return;
}