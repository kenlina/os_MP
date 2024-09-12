#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0
#define LEN 10

static struct thread *t;
static int cnt = 0;
static int cnt_task1 = 1, cnt_task2 = 1;

void task2(void *arg){
    printf("task2: %d\n", cnt_task2);
    cnt_task2++;
    if (cnt_task2 & 1){
        thread_yield();
    }
}

void task1(void *arg){
    printf("task1: %d\n", cnt_task1);

    int i = 0;
    while (i < cnt){
        thread_assign_task(t, task2, NULL);
        i++;
    }

    if (cnt_task1 % 3 == 0){
        thread_yield();
    }
    cnt_task1++;
}

void f1(void *arg)
{   
    while (cnt < LEN){
        printf("thread: %d\n", cnt);
        thread_assign_task(t, task1, NULL);
        cnt++;
        thread_yield();
    }
}

int main(int argc, char **argv)
{
    printf("mp1-part2-6\n");
    t = thread_create(f1, NULL);
    thread_add_runqueue(t);
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
