	.text

/* Switch from current_thread to next_thread. Make next_thread
 * the current_thread, and set next_thread to 0.
 * Use eax as a temporary register; it is caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
  pushal                        /* push e{abcd}x, e{sb}p, e{sd}i */
  movl current_thread, %eax
  movl %esp, (%eax)               /* save sp in current_thread->sp */
  movl next_thread, %eax
  movl %eax, current_thread
  movl $0, next_thread
  movl current_thread, %eax
  movl (%eax), %esp
  popal
	ret				/* pop return address from stack */
