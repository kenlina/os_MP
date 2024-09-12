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
  private1();
  cleanup();
  private2();
  cleanup();
  private3();
  cleanup();
  exit(failed);
}

static void
cleanup(void)
{
  unlink("/testsymlink/a");
  unlink("/testsymlink/b");
  unlink("/testsymlink/c");
  unlink("/testsymlink/1");
  unlink("/testsymlink/2");
  unlink("/testsymlink/3");
  unlink("/testsymlink/4");
  unlink("/testsymlink2/1");
  unlink("/testsymlink2/3");
  unlink("/testsymlink");
  unlink("/testsymlink2");
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);

  if(fd < 0)
    return -1;
  if(fstat(fd, st) != 0)
    return -1;
  return 0;
}

static void
private1(void)
{
  int r, fd1 = -1, fd2 = -1;
  struct stat st;
    
  printf("private testcase 1:\n");

  mkdir("/testsymlink");

  // 1. Create file a
  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
  if(fd1 < 0) fail("failed to open a");

  // 2. Create symlink b -> a
  r = symlink("/testsymlink/a", "/testsymlink/b");
  if(r < 0)
    fail("symlink b -> a failed");

  // 3. check b file type
  if (stat_slink("/testsymlink/b", &st) != 0)
    fail("failed to stat b");
  if(st.type != T_SYMLINK)
    fail("b isn't a symlink");

  // 4. Delete a
  unlink("/testsymlink/a");

  // 5. Can not open b
  if(open("/testsymlink/b", O_RDWR) >= 0)
    fail("Should not be able to open b after deleting a");

  // 6. Create symlink a -> b
  r = symlink("/testsymlink/b", "/testsymlink/a");
  if(r < 0)
    fail("symlink a -> b failed");

  // 7. Can not open infinite symlink loop.
  r = open("/testsymlink/b", O_RDWR);
  if(r >= 0)
    fail("Should not be able to open b (cycle b->a->b->..)\n");

  printf("private testcase 1: ok\n");

done:
  close(fd1);
  close(fd2);
}


static void
private2(void)
{
  int r, fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;
    
  printf("private testcase 2:\n");

  mkdir("/testsymlink");
  mkdir("/testsymlink2");

  // 1. Create a symlink chain 
  // testsymlink2/1 -> testsymlink/2 -> testsymlink2/3 -> testsymlink/4
  r = symlink("/testsymlink/2", "/testsymlink2/1");
  if(r) fail("Failed to link 1->2");
  r = symlink("/testsymlink2/3", "/testsymlink/2");
  if(r) fail("Failed to link 2->3");
  r = symlink("/testsymlink/4", "/testsymlink2/3");
  if(r) fail("Failed to link 3->4");

  // 2. Create testsymlink/4 and open testsymlink2/1.
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
  if(fd1<0) fail("Failed to create /testsymlink/4\n");
  fd2 = open("/testsymlink2/1", O_RDWR);
  if(fd2<0) fail("Failed to open /testsymlink2/1\n");

  // Write 1 and read 4 to check they are the same file.
  c = '#';
  r = write(fd2, &c, 1);
  if(r!=1) fail("Failed to write to 1\n");
  r = read(fd1, &c2, 1);
  if(r!=1) fail("Failed to read from 4\n");
  if(c!=c2)
    fail("Value read from /testsymlink/4 differed from value written to /testsymlink2/1\n");

  printf("private testcase 2: ok\n");

done:
  close(fd1);
  close(fd2);
}

static void
private3(void)
{
  int r, fd1 = -1, fd2 = -1;
  char c = 0, c2 = 0;
    
  printf("private testcase 2:\n");

  mkdir("/testsymlink");
  mkdir("/testsymlink2");

  // 1. Create a symlink chain 
  // testsymlink2/1 -> testsymlink/2 -> testsymlink2/3 -> testsymlink/4
  r = symlink("/testsymlink/2", "/testsymlink2/1");
  if(r) fail("Failed to link 1->2");
  r = symlink("/testsymlink2/3", "/testsymlink/2");
  if(r) fail("Failed to link 2->3");
  r = symlink("/testsymlink/4", "/testsymlink2/3");
  if(r) fail("Failed to link 3->4");

  // 2. Create testsymlink/4.
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
  if(fd1<0) fail("Failed to create /testsymlink/4\n");
  
  // Open 1 in testsymlink2
  chdir("/testsymlink2/");
  fd2 = open("1", O_RDWR);
  if(fd2<0) fail("Failed to open /testsymlink2/1\n");

  // Write 1 and read 4 to check they are the same file.
  c = '#';
  r = write(fd2, &c, 1);
  if(r!=1) fail("Failed to write to 1\n");
  r = read(fd1, &c2, 1);
  if(r!=1) fail("Failed to read from 4\n");
  if(c!=c2)
    fail("Value read from /testsymlink/4 differed from value written to /testsymlink2/1\n");

  printf("private testcase 3: ok\n");

done:
  close(fd1);
  close(fd2);
}
