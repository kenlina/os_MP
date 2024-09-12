#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0

static struct thread *t;
static int cnt = 0;

void f1(void *arg)
{
    printf("%s 1: %d\n", (cnt == 0)? "thread" : "task", cnt);
    cnt++;

    if (cnt < 10){
        thread_assign_task(t, f1, NULL);
    }

    thread_yield();
}

int main(int argc, char **argv)
{
    printf("mp1-part2-2\n");
    t = thread_create(f1, NULL);
    thread_add_runqueue(t);
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
