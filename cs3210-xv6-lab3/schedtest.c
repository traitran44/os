#include "types.h"
#include "stat.h"
#include "user.h"
#include "sched.h"

int
same_priority(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count) {
    setscheduler(-1, parent_po, parent_pri);
    int pid;
    for (int i = 0; i < num_proc; i++) {
        pid = fork();
        setscheduler(pid, child_po, 0);
        if (pid > 0) {
            printf(1, "Created %d\n", pid);
        } else if (pid == 0) {
            int k = 0;
            for (int j = 0; j < loop_count; j++) {
                k += 1;
                k *= 0.9;
            }
            exit();
        }
    }
    for (int j = 0; j < num_proc; j++) {
        pid = wait();
    }

    return 0;
}

int
increasing_priority(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count) {
    setscheduler(-1, parent_po, parent_pri);
    int pid;
    for (int i = 0; i < num_proc; i++) {
        pid = fork();
        setscheduler(pid, child_po, i + child_pri);
        if (pid > 0) {
            printf(1, "Created %d\n", pid);
        } else if (pid == 0) {
            int k = 0;
            for (int j = 0; j < loop_count; j++) {
                k += 1;
                k *= 0.9;
            }
            exit();
        }
    }
    for (int j = 0; j < num_proc; j++) {
        pid = wait();
    }

    return 0;
}

int
decreasing_priority(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count) {
    setscheduler(-1, parent_po, parent_pri);
    int pid;
    for (int i = 0; i < num_proc; i++) {
        pid = fork();
        setscheduler(pid, child_po, child_pri - i);
        if (pid > 0) {
            printf(1, "Created %d\n", pid);
        } else if (pid == 0) {
            int k = 0;
            for (int j = 0; j < loop_count; j++) {
                k += 1;
                k *= 0.9;
            }
            exit();
        }
    }
    for (int j = 0; j < num_proc; j++) {
        pid = wait();
    }

    return 0;
}


int
diff_policy(int num_proc, int parent_po, int parent_pri, int loop_count) {
    setscheduler(-1, parent_po, parent_pri);
    int pid;
    for (int i = 0; i < num_proc; i++) {
        pid = fork();
        if (pid % 2 == 0) {
            setscheduler(pid, SCHED_RR, i);
        } else {
            setscheduler(pid, SCHED_FIFO, i);
        }
        if (pid > 0) {
            printf(1, "Created %d\n", pid);
        } else if (pid == 0) {
            int k = 0;
            for (int j = 0; j < loop_count; j++) {
                k += 1;
            }
            exit();
        }
    }

    for (int j = 0; j < num_proc; j++) {
        pid = wait();
    }

    return 0;
}

int
main(int argc, char *argv[]) {
    // args order (int num_proc, int parent_po, int child_po, int parent_pri, int child_pri);

    // child priority same throughout
//    printf(1, "DEFAULT\n");
//    same_priority(5, SCHED_RR, SCHED_RR, 0, 0, 2000);
//    printf(1, "Create all child, and then execute child\n");
//    same_priority(5, SCHED_RR, SCHED_RR, 99, 0, 2000);
////    printf(1, "Create child, execute til DONE, then create next child\n");
////    same_priority(5, SCHED_RR, SCHED_FIFO, 0, 0, 2000);
//    printf(1, "Create all child, execute child in RR\n");
//    same_priority(5, SCHED_FIFO, SCHED_RR, 0, 0, 4000000000);
//    printf(1, "Creaate all child, execute child in FIFO\n");
//    same_priority(5, SCHED_FIFO, SCHED_FIFO, 99, 0, 2000);
//
//    // child priority increase
//    increasing_priority(5, SCHED_RR, SCHED_RR, 99, 0, 200); // create all child in RR, execute by priority
//    increasing_priority(5, SCHED_RR, SCHED_RR, 0, 0, 200);  // create child, execute child, create next child....
//    increasing_priority(5, SCHED_RR, SCHED_FIFO, 0, 0, 200);   // create child, execute child, create next child...
//    increasing_priority(4, SCHED_FIFO, SCHED_FIFO, 99, 0, 200);  // create all children, execute children in reverse order
//
//    // priority decrease
//    decreasing_priority(4, SCHED_FIFO, SCHED_FIFO, 99, 10, 200);  // create all children, execute in increasing order
//    decreasing_priority(4, SCHED_FIFO, SCHED_RR, 99, 10, 200);  // create all children, execute in increasing order
//    decreasing_priority(4, SCHED_RR, SCHED_FIFO, 99, 10, 200);  // alternate between create child, child run to finish, and create next child
//    decreasing_priority(4, SCHED_RR, SCHED_RR, 99, 10, 200);  // create all child processes, then execute in priority

    diff_policy(10, SCHED_FIFO, 99, 2000);
//    diff_policy(10, SCHED_RR, 99, 100);

    exit();
}