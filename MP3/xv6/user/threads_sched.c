#include "kernel/types.h"
#include "user/user.h"
#include "user/list.h"
#include "user/threads.h"
#include "user/threads_sched.h"

#define NULL 0

/* default scheduling algorithm */
struct threads_sched_result schedule_default(struct threads_sched_args args)
{
    struct thread *thread_with_smallest_id = NULL;
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (thread_with_smallest_id == NULL || th->ID < thread_with_smallest_id->ID)
            thread_with_smallest_id = th;
    }

    struct threads_sched_result r;
    if (thread_with_smallest_id != NULL) {
        r.scheduled_thread_list_member = &thread_with_smallest_id->thread_list;
        r.allocated_time = thread_with_smallest_id->remaining_time;
    } else {
        r.scheduled_thread_list_member = args.run_queue;
        r.allocated_time = 1;
    }

    return r;
}

/* MP3 Part 1 - Non-Real-Time Scheduling */
/* Weighted-Round-Robin Scheduling */
struct threads_sched_result schedule_wrr(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the weighted round-robin scheduling algorithm
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        // printf("debug: thread%d\n", th->ID);
        break;
    }
    if(th != NULL){
        r.scheduled_thread_list_member = &th->thread_list;
        int alloc = th->weight * args.time_quantum;
        int remain = th->remaining_time;
        r.allocated_time = (alloc > remain) ? remain : alloc;
    } 
    else {
        r.scheduled_thread_list_member = args.run_queue;
        struct release_queue_entry *cur;
        int near_release = 100;
        list_for_each_entry(cur, args.release_queue, thread_list){
            if(cur->release_time - args.current_time < near_release)
                near_release = cur->release_time - args.current_time;
        }
        r.allocated_time = near_release;
    }
    return r;
}

/* Shortest-Job-First Scheduling */
struct threads_sched_result schedule_sjf(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the shortest-job-first scheduling algorithm
    struct thread *th = NULL;
    struct thread *smallest_time = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        // printf("debug: thread%d\n", th->ID);
        if (smallest_time == NULL || th->remaining_time < smallest_time->remaining_time){
            smallest_time = th;
        }
        else if(th->remaining_time == smallest_time->remaining_time){
            if(th->ID < smallest_time->ID){
                // printf("debug: thread%d now is smallest with the same burst time\n", th->ID);
                smallest_time = th;
            }
        }
    }

    if (smallest_time != NULL) {
        r.scheduled_thread_list_member = &smallest_time->thread_list;
        struct release_queue_entry *cur;
        int near_alloc = smallest_time->remaining_time;
        list_for_each_entry(cur, args.release_queue, thread_list){
            int _time = cur->release_time - args.current_time + cur->thrd->processing_time;
            if(near_alloc > cur->release_time - args.current_time){
                if(_time == smallest_time->remaining_time){
                    if(cur->thrd->ID < smallest_time->ID)
                        near_alloc = cur->release_time - args.current_time;
                }
                else if(_time < smallest_time->remaining_time)
                    near_alloc = cur->release_time - args.current_time;
            }
        }
        r.allocated_time = near_alloc;
    } 
    else {
        r.scheduled_thread_list_member = args.run_queue;
        struct release_queue_entry *cur;
        int near_release = 100;
        list_for_each_entry(cur, args.release_queue, thread_list){
            if(cur->release_time - args.current_time < near_release)
                near_release = cur->release_time - args.current_time;
        }
        r.allocated_time = near_release;
    }

    return r;
}

/* MP3 Part 2 - Real-Time Scheduling*/
/* Least-Slack-Time Scheduling */
struct threads_sched_result schedule_lst(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the least-slack-time scheduling algorithm
    struct thread *out = NULL;
    struct thread *t = NULL;
    list_for_each_entry(t, args.run_queue, thread_list){
        if(t->current_deadline <= args.current_time){
            if(out){
                if(out->ID > t->ID)
                    out = t;
            }
            else{
                out = t;
            }
        }
    }
    if(out){
        r.scheduled_thread_list_member = &out->thread_list;
        r.allocated_time = 0;
        return r;
    }
    struct thread *th = NULL;
    struct thread *smallest_time = NULL;
    int slack_time;
    list_for_each_entry(th, args.run_queue, thread_list) {
        // printf("debug: thread%d\n", th->ID);
        int s = th->current_deadline - args.current_time - th->remaining_time;
        if (smallest_time == NULL || s < slack_time){
            smallest_time = th;
            slack_time = s;
        }
        else if(s == slack_time){
            if(th->ID < smallest_time->ID){
                // printf("debug: thread%d now is smallest with the same burst time\n", th->ID);
                smallest_time = th;
                slack_time = s;
            }
        }
    }
    if (smallest_time != NULL) {
        // printf("thread %d 's slack time: %d\n", smallest_time->ID, slack_time);
        r.scheduled_thread_list_member = &smallest_time->thread_list;
        int deadline = smallest_time->current_deadline - args.current_time;
        int near_alloc = (smallest_time->remaining_time > deadline) ? deadline : smallest_time->remaining_time;
        struct release_queue_entry *cur;
        list_for_each_entry(cur, args.release_queue, thread_list){
            int _time = cur->release_time - args.current_time;
            // printf("thread %d 's _time is %d, slack_then is %d\n", cur->thrd->ID, _time, slack_time + _time);
            if(near_alloc > _time){
                int s = cur->thrd->current_deadline - (args.current_time + _time) - cur->thrd->remaining_time;
                if(slack_time > s){
                    near_alloc = _time;
                }
                else if(slack_time == s){
                    if(cur->thrd->ID < smallest_time->ID){
                        near_alloc = _time;
                    }
                }
            }
        }
        r.allocated_time = near_alloc;
    } 
    else {
        r.scheduled_thread_list_member = args.run_queue;
        struct release_queue_entry *cur;
        int near_release = 100;
        list_for_each_entry(cur, args.release_queue, thread_list){
            if(cur->release_time - args.current_time < near_release)
                near_release = cur->release_time - args.current_time;
        }
        r.allocated_time = near_release;
    }

    return r;
}

/* Deadline-Monotonic Scheduling */
struct threads_sched_result schedule_dm(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the deadline-monotonic scheduling algorithm
    struct thread *out = NULL;
    struct thread *t = NULL;
    list_for_each_entry(t, args.run_queue, thread_list){
        if(t->current_deadline <= args.current_time){
            if(out){
                if(out->ID > t->ID)
                    out = t;
            }
            else{
                out = t;
            }
        }
    }
    if(out){
        r.scheduled_thread_list_member = &out->thread_list;
        r.allocated_time = 0;
        return r;
    }
    struct thread *th = NULL;
    struct thread *smallest_time = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        // printf("debug: thread%d\n", th->ID);
        if (smallest_time == NULL || th->deadline < smallest_time->deadline){
            smallest_time = th;
        }
        else if(th->deadline == smallest_time->deadline){
            if(th->ID < smallest_time->ID){
                // printf("debug: thread%d now is smallest with the same burst time\n", th->ID);
                smallest_time = th;
            }
        }
    }
    if (smallest_time != NULL) {
        r.scheduled_thread_list_member = &smallest_time->thread_list;
        int deadline = smallest_time->current_deadline - args.current_time;
        int near_alloc = (smallest_time->remaining_time > deadline) ? deadline : smallest_time->remaining_time;
        struct release_queue_entry *cur;
        list_for_each_entry(cur, args.release_queue, thread_list){
            int _time = cur->release_time - args.current_time;
            // printf("thread %d 's _time is %d, slack_then is %d\n", cur->thrd->ID, _time, slack_time + _time);
            if(near_alloc > _time){
                if(cur->thrd->deadline < smallest_time->deadline){
                    near_alloc = _time;
                }
                else if(cur->thrd->deadline == smallest_time->deadline){
                    if(cur->thrd->ID < smallest_time->ID){
                        near_alloc = _time;
                    }
                }
            }
        }
        r.allocated_time = near_alloc;
    } 
    else {
        r.scheduled_thread_list_member = args.run_queue;
        struct release_queue_entry *cur;
        int near_release = 100;
        list_for_each_entry(cur, args.release_queue, thread_list){
            if(cur->release_time - args.current_time < near_release)
                near_release = cur->release_time - args.current_time;
        }
        r.allocated_time = near_release;
    }

    return r;
}
