#ifndef THREADS_H_
#define THREADS_H_

#include "user/list.h"
#include "kernel/types.h"

struct thread {
    void (*fp)(void *arg);
    void *arg;
    void *stack;
    void *stack_p;
    int buf_set;
    struct list_head thread_list;

    // When yeild or interrupt are happening,
    // kernel stores the thread context,
    // this is index for that.
    int thrdstop_context_id;
    // a unique ID
    int ID;
    // 1 if real-time, 0 if non-real-time
    int is_real_time;
    // the processing time of the thread
    int processing_time;
    // weight for WRR
    int weight;
    // the deadline of the thread
    int deadline;
    // the period of the thread
    int period;
    // In real-time, the thread will be released n times
    int n;
    // number of ticks to be allocated in the current period
    int remaining_time;
    // the deadline of the current period
    int current_deadline;
};

struct release_queue_entry {
    struct thread *thrd;
    // for linked list
    struct list_head thread_list;
    // the time when `thrd` should be released to run queue, measured in ticks
    int release_time;
};

struct thread *thread_create(void (*f)(void *), void *arg, int is_real_time, int processing_time, int period, int n);
void thread_set_weight(struct thread *t, int weight);
void thread_add_at(struct thread *t, int arrival_time);
void thread_exit(void);
void thread_start_threading();

#endif // THREADS_H_
