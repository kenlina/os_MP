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
#define MAXBUFSIZE 512

static int failed = 0;

static void public1(void);
static void public2(void);
static void public3(void);
static void cleanup(void);


int
main(int argc, char *argv[])
{
    cleanup();
    public1();
    cleanup();
    public2();
    cleanup();
    public3();
    cleanup();
    exit(failed);
}

static void
cleanup(void){
    unlink("/test1");
    unlink("/test2");
    unlink("/testa");
    unlink("/testb");
    unlink("/testc");
    unlink("/testd");
    unlink("/testw");
    unlink("/testdir1/testx");
    unlink("/testdir1/testy");
    unlink("/testdir1/testz");
    unlink("/testdir1");
}

static void
public1(void)
{
    int r, fd1 = -1;
    char buf[MAXBUFSIZE] = {0};

    printf("public testcase 1:\n");

    fd1 = open("/test1", O_CREATE | O_RDWR);
    if(fd1 < 0) fail("create /test1 failed\n");

    r = symlink("/test1", "/test2");
    if(r < 0) fail("symlink test2 -> test1 failed");

    r = revreadlink("/test1", buf, sizeof(buf));
    if (r < 0) fail("revreadlink call failed\n");

    buf[r] = '\0';
    printf("%s\n", buf);

done:
    close(fd1);
}

static void
public2(void)
{
    int r, fd1 = -1;
    char buf[MAXBUFSIZE] = {0};

    printf("public testcase 2:\n");

    fd1 = open("/testa", O_CREATE | O_RDWR);
    if(fd1 < 0) fail("create /testa failed\n");

    r = symlink("/testa", "/testb");
    if(r < 0) fail("symlink testb -> testa failed");
    r = symlink("/testa", "/testc");
    if(r < 0) fail("symlink testc -> testa failed");
    r = symlink("/testa", "/testd");
    if(r < 0) fail("symlink testd -> testa failed");

    r = revreadlink("/testa", buf, sizeof(buf));
    if (r < 0) fail("revreadlink call failed\n");

    buf[r] = '\0';
    printf("%s\n", buf);

done:
    close(fd1);
}

static void
public3(void)
{
    int r, fd1 = -1;
    char buf[MAXBUFSIZE] = {0};

    printf("public testcase 3:\n");

    mkdir("/testdir1");

    fd1 = open("/testw", O_CREATE | O_RDWR);
    if(fd1 < 0) fail("create /testw failed\n");

    r = symlink("/testw", "/testdir1/testx");
    if(r < 0) fail("symlink testdir1/testx -> testw failed");
    r = symlink("/testw", "/testdir1/testy");
    if(r < 0) fail("symlink testdir1/testy -> testw failed");
    r = symlink("/testw", "/testdir1/testz");
    if(r < 0) fail("symlink testdir1/testz -> testw failed");

    r = revreadlink("/testw", buf, sizeof(buf));
    if (r < 0) fail("revreadlink call failed\n");
    
    buf[r] = '\0';
    printf("%s\n", buf);

done:
    close(fd1);
}