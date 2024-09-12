#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0
#define LEN 10

static struct thread* threads[LEN];
static long cnt = 0;

void f1(void *arg)
{
    long arg_l = (long)arg;

    printf("%s %d: %d\n", (arg_l > 0)? "thread" : "task", (arg_l > 0)? arg_l : threads[cnt % LEN]->ID, cnt);

    if (cnt == LEN * LEN){
        return;
    }else if (arg_l != LEN){
        thread_assign_task(threads[(++cnt) % LEN], f1, (void *)0);
    }

    thread_yield();
}

int main(int argc, char **argv)
{
    printf("mp1-part2-3\n");
    while(cnt < LEN){
        threads[cnt] = thread_create(f1, (void *)(cnt+1));
        thread_add_runqueue(threads[cnt++]);
    }
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}