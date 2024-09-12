#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0
#define LEN 10

static struct thread* threads[LEN];
static long cnt = 0;

void task2(void *arg){
    thread_exit();
}

void task1(void *arg)
{
    printf("task %d: %d\n", threads[cnt % LEN]->ID, cnt);

    if (cnt < LEN * LEN){
        thread_assign_task(threads[(cnt++) % LEN], task1, NULL);
    }else{
        for (int i = 0; i < LEN; i++){
            thread_assign_task(threads[i], task2, NULL);
        }
        return;
    }
    thread_yield();
    printf("Error!\n");
}

void f1(void *arg)
{
    long arg_l = (long)arg;

    printf("thread %d: %d\n", arg_l, cnt);

    thread_assign_task(threads[(cnt++) % LEN], task1, NULL);

    thread_yield();
}

int main(int argc, char **argv)
{
    printf("mp1-part2-4\n");
    while(cnt < LEN){
        threads[cnt] = thread_create(f1, (void *)(cnt+1));
        thread_add_runqueue(threads[cnt++]);
    }
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
