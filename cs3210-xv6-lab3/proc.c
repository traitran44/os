/// \file
#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "sched.h"

struct {
    struct spinlock lock;
    struct proc proc[NPROC];
    int queue_size;
    struct proc *fifo_head;
    struct proc *tail;
} ptable;

static struct proc *initproc;

int remove_proc_q(struct proc * proc);

int nextpid = 1;

extern void forkret(void);

extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void) {
    initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc *
allocproc(void) {
    struct proc *p;
    char *sp;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
    p->priority = 0;
    p->policy = SCHED_RR;

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
        p->state = UNUSED;
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
    p->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint) forkret;

    return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    acquire(&ptable.lock);

    p = allocproc();
    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    p->tf->es = p->tf->ds;
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
    p->cwd = namei("/");

    p->state = RUNNABLE;

    release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;

    sz = proc->sz;
    if (n > 0) {
        if ((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
        if ((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    proc->sz = sz;
    switchuvm(proc);
    return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
    int i, pid;
    struct proc *np;

    acquire(&ptable.lock);

    // Allocate process.
    if ((np = allocproc()) == 0) {
        release(&ptable.lock);
        return -1;
    }

    // Copy process state from p.
    if ((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0) {
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        release(&ptable.lock);
        return -1;
    }
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);

    safestrcpy(np->name, proc->name, sizeof(proc->name));

    pid = np->pid;

    np->state = RUNNABLE;

    release(&ptable.lock);

    return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
    struct proc *p;
    int fd;

    if (proc == initproc)
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (proc->ofile[fd]) {
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
    iput(proc->cwd);
    end_op();
    proc->cwd = 0;

    acquire(&ptable.lock);
    cprintf("Exitting PID: %d\n", proc->pid);

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == proc) {
            p->parent = initproc;
            if (p->state == ZOMBIE)
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
    if (p->pid > 2)
        cprintf("exit proc %d\n", p->pid);

    sched();
    panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for zombie children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != proc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                freevm(p->pgdir);
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                release(&ptable.lock);
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || proc->killed) {
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
/**
 * The implementation of FIFO and RR with priority is here.
 * FIFO policy is always executed first and then RR.
 */
void
scheduler(void) {
    struct proc *p = 0;
    struct cpu *c = mycpu();
    c->proc = 0;

    for (;;) {
        // Enable interrupts on this processor.
        sti();
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        if (fifo_size() > 0) {
            p = fifo_q();
            if (p->state != RUNNABLE)
                continue;

            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;
            swtch(&(c->scheduler), p->context);
            switchkvm();

            if (p->state == ZOMBIE) {
                remove_proc_q(p);
            }
            c->proc = 0;
        } else {
            struct proc sorted_ptable[NPROC];
            int max_priority = -1;
            for (int i = 0; i < NPROC; i++) {
                if (ptable.proc[i].priority > max_priority && ptable.proc[i].state == RUNNABLE) {
                    max_priority = ptable.proc[i].priority;
                }
            }
            int sorted_size = 0;
            for (int i = 0; i < NPROC; i++) {
                if (ptable.proc[i].priority == max_priority && ptable.proc[i].state == RUNNABLE) {
                    sorted_ptable[sorted_size] = ptable.proc[i];
                    sorted_size++;
                }
            }
            for (int i = 0; i < sorted_size; i++) {
                for (int j = 0; j < NPROC; j++) {
                    if (ptable.proc[j].pid == sorted_ptable[i].pid && ptable.proc[j].state == RUNNABLE) {
                        p = &ptable.proc[j];
                    }
                }
                if (p->state != RUNNABLE) {
                    continue;
                }
//                cprintf("PID: %d\n", p->pid);
//                int priority = p->priority;
//                for (int j = 0; j < NPROC; j++) {
//                    if (sorted_ptable[j].priority > priority && sorted_ptable[j].state == RUNNABLE)
//                        p = &sorted_ptable[j];
//                }
//                cprintf("Running PID: %d\n", p->pid);

                // Switch to chosen process.  It is the process's job
                // to release ptable.lock and then reacquire it
                // before jumping back to us.
                c->proc = p;
                switchuvm(p);
                p->state = RUNNING;
                swtch(&(c->scheduler), p->context);
                switchkvm();
                // Process is done running for now.
                // It should have changed its p->state before coming back.
                c->proc = 0;

                if (fifo_size()) {
                    break;
                }
            }
        }
        release(&ptable.lock);
    }
}

int
fifo_size(void) {
    return ptable.queue_size;
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
    int intena;

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (cpu->ncli != 1)
        panic("sched locks");
    if (proc->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = cpu->intena;
    swtch(&proc->context, cpu->scheduler);
    cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
    acquire(&ptable.lock);  //DOC: yieldlock
    proc->state = RUNNABLE;
    sched();
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}


struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
}

struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
    c = mycpu();
    p = c->proc;
    popcli();
    return p;
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();
    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");

    // Must acquire ptable.lock in order to
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }

    // Go to sleep.
    p->chan = chan;
    p->state = SLEEPING;
    if (p->policy == SCHED_FIFO) {
        ptable.queue_size--;
    }
    sched();

    // Tidy up.
    p->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
            if (p->policy == SCHED_FIFO)
                ptable.queue_size++;
        }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
    static char *states[] = {
            [UNUSED]    "unused",
            [EMBRYO]    "embryo",
            [SLEEPING]  "sleep ",
            [RUNNABLE]  "runble",
            [RUNNING]   "run   ",
            [ZOMBIE]    "zombie"
    };
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}

/**
 * Cloning thread helper function
 * @param stack
 * @param size
 * @return
 */
int
clone_thread(void *stack, int size) {
    int i, pid;
    struct proc *np;
    acquire(&ptable.lock);
    if ((np = allocproc()) == 0)
        return -1;

    np->pgdir = proc->pgdir;
    uint sp = (uint) (stack + size);
    sp -= 8;

    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;

    np->tf->eax = 0;
    np->tf->esp = (uint) sp;
    np->tf->eip = (uint) (*(uint *) stack);
    np->tf->ebp = (uint) (stack + size);
    for (i = 0; i < NOFILE; i++)
        if (proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);

    pid = np->pid;
    np->state = RUNNABLE;
    safestrcpy(np->name, proc->name, sizeof(proc->name));
    proc->thread_count++;
    np->thread_count = proc->thread_count;

    release(&ptable.lock);
    return pid;
}

/**
 * Returning the cpu number, this is a system call.
 * @return
 */
int
sys_cpu(void) {
    return cpunum();
}

/**
 * Behave similar to wait() but for thread.
 * Being used in uthread.c for testing purposes
 * @return
 */
int
sys_join(void) {
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for zombie children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != proc || p->pgdir != proc->pgdir)
                continue;
            havekids = 1;
            if (p->state != ZOMBIE)
                continue;
            if (p->state == ZOMBIE) {
                // Found one.
                proc->thread_count--;
                pid = p->pid;
                kfree(p->kstack);
                p->state = UNUSED;
                p->kstack = 0;
                p->parent = 0;
                p->pid = 0;
                p->killed = 0;
                p->name[0] = 0;
                release(&ptable.lock);
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || proc->killed) {
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}


/**
 * Cloning a thread given the stack and size.
 * @return
 */
int
sys_clone(void) {
    char *stack;
    int size;

    if (argint(1, &size) < 0)
        return -1;
    if (argptr(0, &stack, size) < 0)
        return -1;

    return clone_thread((void *) stack, size);
}

/**
 * Return the highest priority element without removing
 * @return
 */
struct proc *
fifo_q(void) {
    struct proc *curr_node = ptable.fifo_head;
    struct proc *best_proc = ptable.fifo_head;

    while (curr_node) {
        if (curr_node->state != RUNNABLE) {
            if (curr_node->next)
                best_proc = curr_node->next;
            curr_node = curr_node->next;
        } else {
            if (curr_node->priority > best_proc->priority) {
                best_proc = curr_node;
            }
        }
        curr_node = curr_node->next;
    }
    return best_proc;
}

/**
 * Remove the process in queue with highest priority or most recent
 * @param proc
 * @return
 */
int
remove_proc_q(struct proc *proc) {
    if (ptable.queue_size > 0) {
        if (ptable.fifo_head->pid == proc->pid) {
            ptable.fifo_head = ptable.fifo_head->next;
        } else {
            if (proc->pid == ptable.tail->pid) {
                ptable.tail = proc->prev;
                ptable.tail->next = 0;
            } else {
                struct proc *prev = proc->prev;
                prev->next = proc->next;
                proc->next->prev = prev;
            }
        }
        ptable.queue_size -= 1;
    }
    return proc->pid;
}

/**
 * Insert the process into the process queue used for FIFO
 * @param priority
 * @param pid
 * @param policy
 * @return
 */
int
insert_proc_q(int priority, int pid, int policy) {
    int valid = -1;
    acquire(&ptable.lock);
    if (ptable.queue_size < NPROC) {
        for (int i = 0; i < 30; i++) {
            if (ptable.proc[i].pid == pid) {
                ptable.proc[i].priority = priority;
                ptable.proc[i].policy = policy;

                if (!ptable.fifo_head) {
                    ptable.fifo_head = &ptable.proc[i];
                    ptable.tail = &ptable.proc[i];
                } else {
                    ptable.tail->next = &ptable.proc[i];
                    ptable.proc[i].prev = ptable.tail;
                    ptable.tail = &ptable.proc[i];
                }

                ptable.queue_size++;
                valid = 0;
                break;
            }
        }
    }
    release(&ptable.lock);
    return valid;
}

/**
 * Set the scheduler for process pid with policy, priority: SCHED_FIFO, SCHED_RR
 * @return
 */
int
sys_setscheduler(void) {
    int pid;
    int policy;
    int priority;
    if (argint(0, &pid) < 0 || argint(1, &policy) < 0 || argint(2, &priority) < 0)
        return -1;

    if (pid == 0)
        return 0;

    if (pid < 0)
        pid = myproc()->pid;

    if (policy == SCHED_FIFO) {
        if (insert_proc_q(priority, pid, policy) != 0)
            panic("Couldn't add proc to queue");
    } else if (policy == SCHED_RR) {
        for (int i = 0; i < NPROC; i++) {
            if (ptable.proc[i].pid == pid) {
                ptable.proc[i].priority = priority;
                break;
            }
        }
    }

    yield();
    return 0;
}
