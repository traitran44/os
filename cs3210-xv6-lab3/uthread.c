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
    int sp;                /* saved stack pointer */
    char stack[STACK_SIZE];       /* the thread's stack */
    int state;             /* FREE, RUNNING, RUNNABLE */
};
static thread_t all_thread[MAX_THREAD];
thread_p current_thread;
thread_p next_thread;

extern void thread_switch(void);

void
thread_init(void) {
    // main() is thread 0, which will make the first invocation to
    // thread_schedule().  it needs a stack so that the first thread_switch() can
    // save thread 0's state.  thread_schedule() won't run the main thread ever
    // again, because its state is set to RUNNING, and thread_schedule() selects
    // a RUNNABLE thread.
    current_thread = &all_thread[0];
    current_thread->state = RUNNING;
}

static void
thread_schedule(void) {
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
        printf(2, "thread_schedule: no runnable threads\n");
        exit();
    }

    if (current_thread != next_thread) {         /* switch threads?  */
        next_thread->state = RUNNING;
        thread_switch();
    } else
        next_thread = 0;
}

void
thread_create(void (*func)()) {
    char stack[STACK_SIZE];
    *((int *) stack) = (int) func;           // push return address on stack
    printf(1, "func address %x\n", func);
    clone((void *) stack, STACK_SIZE);
}

void
thread_yield(void) {
    current_thread->state = RUNNABLE;
    thread_schedule();
}

static void
thread1(void) {
    int i;
    printf(1, "CPU: %d. my thread running\n", cpu());
    for (i = 0; i < 25; i++) {
        printf(1, "my thread 0x%x\n", (int) current_thread);
    }
    printf(1, "my thread: exit\n");
    exit();
}

static void
blockthread(void) {
    while(1) {}
    exit();
}

static void
thread2(void) {
//    int i;
    printf(1, "CPU: %d. my thread running\n", cpu());
//    for (i = 0; i < 50; i++) {
//        printf(1, "After block, my thread 0x%x\n", (int) current_thread);
//    }
    printf(1, "my thread: exit\n");
    exit();
}


int
main(int argc, char *argv[]) {
    thread_create(thread1);
    thread_create(blockthread);
    thread_create(thread2);
    for (int i = 0; i < 3; i++) {
        printf(1, "%Finished: join(%d) \n", join());
    }
    exit();
}
