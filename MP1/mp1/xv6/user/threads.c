#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0

static struct thread* current_thread = NULL;
static struct task *current_task = NULL;
static int id = 1;
static jmp_buf env_st;
static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    t->ID  = id;
    t->buf_set = 0;
    t->exe = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;
    t->latest_sp = new_stack_p;
    t->task = NULL;
    id++;
    return t;
}
void thread_add_runqueue(struct thread *t){
    if(current_thread == NULL){
        // TODO
        t->previous = t;
        t->next = t;
        current_thread = t;
    }
    else{
        // TODO
        struct thread* tmp_previous = current_thread->previous;
        tmp_previous->next = t;
        t->previous = tmp_previous;
        t->next = current_thread;
        current_thread->previous = t; 
    }
}
void thread_yield(void){
    // TODO
    if(current_task){
        // called by task
        if(setjmp(current_task->env) == 0){
            current_thread->latest_sp = current_task->env->sp;
            current_task = NULL;
            schedule();
            dispatch();
        }
    }
    else{
        // called by thread
        if(setjmp(current_thread->env) == 0){
            current_thread->latest_sp = current_thread->env->sp;
            schedule();
            dispatch();
        }
    }
}
void dispatch(void){
    // TODO
    if(!current_thread->buf_set){
        if(setjmp(env_tmp) == 0){
            env_tmp->sp = (unsigned long)current_thread->stack_p;
            current_thread->buf_set = 1;
            longjmp(env_tmp, 1);
        }
    }
    
    if(current_thread->task){
        // has some tasks
        if(!current_thread->task->buf_set){
            // new task
            current_task = current_thread->task;
            if(setjmp(env_tmp) == 0){
                env_tmp->sp = current_thread->latest_sp;
                longjmp(env_tmp, 1);
            }            

            current_task->buf_set = 1;
            current_task->fp(current_task->arg);
            current_task = NULL;
            if(current_thread->task->previous){
                // still has another task
                struct task* tmp = current_thread->task;
                current_thread->task = current_thread->task->previous;
                free(tmp);
            }
            else{
                // last task
                free(current_thread->task);
                current_thread->task = NULL;
            }
            dispatch();
        }
        else{
            // task has been executed
            current_task = current_thread->task;
            longjmp(current_thread->task->env, 1);
        }
    }
    else{
        // only thread
        if(current_thread->exe){
            // this thread has been executed
            current_task = NULL;
            longjmp(current_thread->env, 1);
        }
        else{
            current_task = NULL;
            current_thread->exe = 1;
            current_thread->fp(current_thread->arg);
            thread_exit();
        }
    }
}
void schedule(void){
    // TODO
    current_thread = current_thread->next;
}
void thread_exit(void){
    // release all task resource 
    while(current_thread->task){
        if(current_thread->task->previous){
            struct task *tmp = current_thread->task;
            current_thread->task = current_thread->task->previous;
            free(tmp);
        }
        else{
            free(current_thread->task);
            current_thread->task = NULL;
        }
    }
    
    if(current_thread->next != current_thread){
        // TODO, there are some threads wating
        struct thread* t = current_thread;
        t->previous->next = t->next;
        t->next->previous = t->previous;
        current_thread = t->next;
        free(t->stack);
        free(t);
        dispatch();
    }
    else{
        // TODO
        // Hint: No more thread to execute
        free(current_thread->stack);
        free(current_thread);
        current_thread = NULL;
        longjmp(env_st, 1);
    }
}
void thread_start_threading(void){
    // TODO
    if(setjmp(env_st) == 0){
        dispatch();
    }
    return;
}

// part 2
void thread_assign_task(struct thread *t, void (*f)(void *), void *arg){
    // TODO
    // test whether the thread is existed
    struct thread *tmp = current_thread;
    int existed = 0;
    do{
        if(tmp == t) {
            existed = 1;
            break;
        }
        tmp = tmp->next;
    } while( tmp != current_thread);

    if(!existed) 
        return;


    struct task *T = (struct task*)malloc(sizeof(struct task));
    T->fp = f;
    T->arg = arg;
    T->buf_set = 0;
    T->previous = NULL;
    // T->next = NULL;

    if(t->task == NULL){
        // No task now
        t->task = T;
    }
    else{   
        T->previous = t->task;
        t->task = T;
    }
}
