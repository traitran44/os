#include "types.h"
#include "stat.h"
#include "user.h"
#include "sched.h"

int sched_test(int num);

int
sched_test(int num) {
    if (num == 0) {
        return 0;
    }
    int pid = fork();
//    int num_proc = 2;
    if (pid > 0) {
        wait();
    } else if (pid == 0) {
        int k = 0;
        setscheduler(SCHED_FIFO, 0);
        for (int j = 0; j < 40; j++) {
            k += 1;
            k *= 0.9;
            printf(1, "K val is %d", k);
        }
        printf(1, "DONE!\n");
        return 0;
    } else {
        printf(1, "Fork error\n");
    }
//    for (int i = 0; i < num_proc; i++) {
//        pid = fork();
//        printf(1, "Proc %d\n", pid);
//        if (pid > 0) {
//            if (i == num_proc - 1) {
//                for (int j = 0; j < num_proc; ++j) {
//                    pid = wait();
//                }
//            }
//        } else if (pid == 0) {
//            int k = 0;
//            setscheduler(SCHED_FIFO, 0);
//            for (int j = 0; j < 40; j++) {
//                k += 1;
//                k *= 0.9;
//                printf(1, "K val is %d", k);
//            }
//            printf(1, "DONE!\n");
//            return 0;
//        } else {
//            printf(1, "Fork error\n");
//        }
//    }
    return 0;
}

int
main(int argc, char *argv[]) {
    setscheduler(SCHED_FIFO, 0);
    sched_test(2);
    exit();
}
