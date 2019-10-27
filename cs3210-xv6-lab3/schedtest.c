#include "types.h"
#include "stat.h"
#include "user.h"
#include "sched.h"

//int sched_test1(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count);
//int sched_test2(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count);
//int sched_test3(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count);
//
int
sched_test1(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count) {
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
sched_test2(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count) {
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
sched_test3(int num_proc, int parent_po, int child_po, int parent_pri, int child_pri, int loop_count) {
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
sched_test4(int num_proc, int parent_po, int parent_pri, int loop_count) {
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
main(int argc, char *argv[]) {
    // args order (int num_proc, int parent_po, int child_po, int parent_pri, int child_pri);

    // child priority same throughout
//    printf(1, "DEFAULT\n");
//    sched_test1(5, SCHED_RR, SCHED_RR, 0, 0, 2000);
//    printf(1, "Create all child, and then execute child\n");
//    sched_test1(5, SCHED_RR, SCHED_RR, 99, 0, 2000);
    printf(1, "Create child, execute til DONE, then create next child\n");
    sched_test1(5, SCHED_RR, SCHED_FIFO, 0, 0, 2000);
//    printf(1, "Create all child, execute child in RR\n");
//    sched_test1(5, SCHED_FIFO, SCHED_RR, 0, 0, 4000000000);
//    printf(1, "Creaate all child, execute child in FIFO\n");
//    sched_test1(5, SCHED_FIFO, SCHED_FIFO, 99, 0, 2000);

    // child priority increase
//    sched_test2(5, SCHED_RR, SCHED_RR, 99, 0, 200); // create all child in RR, execute by priority
//    sched_test2(5, SCHED_RR, SCHED_RR, 0, 0, 200);  // create child, execute child, create next child....
//    sched_test2(5, SCHED_RR, SCHED_FIFO, 0, 0, 200);   // create child, execute child, create next child...
//    sched_test2(4, SCHED_FIFO, SCHED_FIFO, 99, 0, 200);  // create all children, execute children in reverse order

    // priority decrease
//    sched_test3(4, SCHED_FIFO, SCHED_FIFO, 99, 10);  // create all children, execute in increasing order
//    sched_test3(4, SCHED_FIFO, SCHED_RR, 99, 10);  // create all children, execute in increasing order
//    sched_test3(4, SCHED_RR, SCHED_FIFO, 99, 10);  // alternate between create child, child run to finish, and create next child
//    sched_test3(4, SCHED_RR, SCHED_RR, 99, 10);  // create all child processes, then execute in priority

//    sched_test4(10, SCHED_FIFO, 99, 2000);
//    sched_test4(10, SCHED_RR, 99, 2000);

    exit();
}