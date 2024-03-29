/// \file
#include "types.h"
#include "stat.h"
#include "user.h"

/* Possible states of a thread; */
#define FREE        0x0
#define RUNNING     0x1
#define RUNNABLE    0x2

#define STACK_SIZE  8192
#define MAX_THREAD  4

typedef struct thread thread_t, *thread_p;
typedef struct mutex mutex_t, *mutex_p;

struct thread {
  int        sp;                /* saved stack pointer */
  char stack[STACK_SIZE];       /* the thread's stack */
  int        state;             /* FREE, RUNNING, RUNNABLE */
};
static thread_t all_thread[MAX_THREAD];
thread_p  current_thread;
thread_p  next_thread;
extern void thread_switch(void);

void 
thread_init1(void)
{
  // main() is thread 0, which will make the first invocation to
  // thread_schedule1().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule1() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule1() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
}

static void 
thread_schedule1(void)
{
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == RUNNABLE && t != current_thread) {
      next_thread = t;
      break;
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  }

  if (next_thread == 0) {
    printf(2, "thread_schedule1: no runnable threads\n");
    exit();
  }

  if (current_thread != next_thread) {         /* switch threads?  */
    next_thread->state = RUNNING;
    thread_switch();
  } else
    next_thread = 0;
}

void 
thread_create1(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
  t->sp -= 4;                              // space for return address
  * (int *) (t->sp) = (int)func;           // push return address on stack
  t->sp -= 32;                             // space for registers that thread_switch expects
  t->state = RUNNABLE;
}

void 
thread_yield1(void)
{
  current_thread->state = RUNNABLE;
  thread_schedule1();
}

static void 
mythread1(void)
{
  int i;
  printf(1, "my thread running. CPU: %d\n", cpu());
  for (i = 0; i < 100; i++) {
    printf(1, "my thread 0x%x\n", (int) current_thread);
    thread_yield1();
  }
  printf(1, "my thread: exit\n");
  current_thread->state = FREE;
  thread_schedule1();
}

/**
 * Blocking other running threads
 */
static void
blockthread1(void)
{
  printf(1, "Blockthread running... CPU: %d\n", cpu());
    while(1) {}
}


int 
main(int argc, char *argv[]) 
{
  thread_init1();
  thread_create1(mythread1);
  thread_create1(blockthread1);
  thread_create1(mythread1);
  thread_schedule1();
  return 0;
}
