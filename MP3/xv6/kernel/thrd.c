#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

// for mp3
uint64
sys_thrdstop(void)
{
  int delay, context_id;
  uint64 context_id_ptr;
  uint64 handler, handler_arg;
  if (argint(0, &delay) < 0)
    return -1;
  if (argaddr(1, &context_id_ptr) < 0)
    return -1;
  if (argaddr(2, &handler) < 0)
    return -1;
  if (argaddr(3, &handler_arg) < 0)
    return -1;

  struct proc *proc = myproc();
  if (copyin(proc->pagetable, (char *)&context_id, context_id_ptr, sizeof(int)) == -1) {
    return -1;
  }

  if (context_id < 0) {
    for (int i = 0; i < MAX_THRD_NUM; i++) {
      if (proc->thrdstop_context_used[i] == 0) {
        proc->thrdstop_context_used[i] = 1;
        context_id = i;
        break;
      }
    }

    if (context_id < 0) {
      return -1;
    }
  }

  if (copyout(proc->pagetable, context_id_ptr, (char *)&context_id, sizeof(int)) == -1) {
    return -1;
  }

  proc->thrdstop_context_id = context_id;
  proc->thrdstop_delay = delay;
  proc->thrdstop_handler_pointer = handler;
  proc->thrdstop_ticks = 0;
  proc->thrdstop_handler_arg = handler_arg;

  return 0;
}

// for mp3
uint64
sys_cancelthrdstop(void)
{
  int context_id, is_exit;
  if (argint(0, &context_id) < 0)
    return -1;
  if (argint(1, &is_exit) < 0)
    return -1;

  if (context_id < 0 || context_id >= MAX_THRD_NUM) {
    return -1;
  }

  struct proc *proc = myproc();

  // cancel previous thrdstop
  int consume_tick = proc->thrdstop_ticks;
  proc->thrdstop_delay = -1;

  if (is_exit == 0) {
    proc->cancel_save_flag = context_id;
  } else if (context_id >= 0 && context_id < MAX_THRD_NUM) {
    proc->thrdstop_context_used[context_id] = 0;
  }

  return consume_tick;
}

// for mp3
uint64
sys_thrdresume(void)
{
  int context_id;
  if (argint(0, &context_id) < 0)
    return -1;

  struct proc *proc = myproc();

  if (context_id < 0 || context_id >= MAX_THRD_NUM)
    return -1;

  proc->resume_flag = context_id;

  return 0;
}
