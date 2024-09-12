#include "kernel/types.h"
#include "user/user.h"
#include "user/threads.h"

#define NULL 0
#define LEN 10

static struct thread *threads[LEN];
static int cnt = 1;

void task1(void *arg)
{
    int i = 0;
    struct thread *t = *(struct thread**)arg;

    while (i < 2){
        printf("task %d: %d\n", t->ID, i);
        i++;
        thread_yield();
    }
}

void f1(void *arg)
{
    int i = 0;
    struct thread *t = *(struct thread**)arg;

    if (cnt < LEN){
        threads[cnt] = thread_create(f1, &threads[cnt]);
        threads[cnt]->ID = cnt + 1;
        thread_add_runqueue(threads[cnt]);
        cnt++;
    }
    thread_assign_task(t, task1, arg);
    
    while(1) {
        printf("thread %d: %d\n", t->ID, i);
        i++;
        if (i == 3) {
            thread_exit();
        }else if (i == 2){
            thread_assign_task(t, task1, arg);
        }
        thread_yield();
    }
}

int main(int argc, char **argv)
{
    printf("mp1-part2-5\n");
    threads[0] = thread_create(f1, &threads[0]);
    threads[0]->ID = 1;
    thread_add_runqueue(threads[0]);
    thread_start_threading();
    printf("\nexited\n");
    exit(0);
}
