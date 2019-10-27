
_hwuthread:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}


int 
main(int argc, char *argv[]) 
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    if (t->state == FREE) break;
  11:	8b 0d cc 4e 00 00    	mov    0x4ecc,%ecx
  current_thread = &all_thread[0];
  17:	c7 05 ec 8e 00 00 c0 	movl   $0xec0,0x8eec
  1e:	0e 00 00 
  current_thread->state = RUNNING;
  21:	c7 05 c4 2e 00 00 01 	movl   $0x1,0x2ec4
  28:	00 00 00 
    if (t->state == FREE) break;
  2b:	85 c9                	test   %ecx,%ecx
  2d:	0f 84 ff 00 00 00    	je     132 <main+0x132>
  33:	8b 15 d4 6e 00 00    	mov    0x6ed4,%edx
  39:	85 d2                	test   %edx,%edx
  3b:	0f 84 fb 00 00 00    	je     13c <main+0x13c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  41:	a1 dc 8e 00 00       	mov    0x8edc,%eax
  46:	ba d8 6e 00 00       	mov    $0x6ed8,%edx
  4b:	85 c0                	test   %eax,%eax
  4d:	b8 e0 8e 00 00       	mov    $0x8ee0,%eax
  52:	0f 44 c2             	cmove  %edx,%eax
  t->sp -= 4;                              // space for return address
  55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  * (int *) (t->sp) = (int)func;           // push return address on stack
  5b:	c7 80 00 20 00 00 30 	movl   $0x230,0x2000(%eax)
  62:	02 00 00 
  t->state = RUNNABLE;
  65:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
  6c:	00 00 00 
  t->sp -= 4;                              // space for return address
  6f:	89 10                	mov    %edx,(%eax)
  t->sp -= 32;                             // space for registers that thread_switch expects
  71:	83 28 20             	subl   $0x20,(%eax)
    if (t->state == FREE) break;
  74:	a1 c4 2e 00 00       	mov    0x2ec4,%eax
  79:	85 c0                	test   %eax,%eax
  7b:	0f 84 cc 00 00 00    	je     14d <main+0x14d>
  81:	a1 cc 4e 00 00       	mov    0x4ecc,%eax
  86:	85 c0                	test   %eax,%eax
  88:	0f 84 d0 00 00 00    	je     15e <main+0x15e>
  8e:	a1 d4 6e 00 00       	mov    0x6ed4,%eax
  93:	85 c0                	test   %eax,%eax
  95:	0f 84 cd 00 00 00    	je     168 <main+0x168>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  9b:	a1 dc 8e 00 00       	mov    0x8edc,%eax
  a0:	ba d8 6e 00 00       	mov    $0x6ed8,%edx
  a5:	85 c0                	test   %eax,%eax
  a7:	b8 e0 8e 00 00       	mov    $0x8ee0,%eax
  ac:	0f 44 c2             	cmove  %edx,%eax
  t->sp -= 4;                              // space for return address
  af:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  * (int *) (t->sp) = (int)func;           // push return address on stack
  b5:	c7 80 00 20 00 00 80 	movl   $0x180,0x2000(%eax)
  bc:	01 00 00 
  t->state = RUNNABLE;
  bf:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
  c6:	00 00 00 
  t->sp -= 4;                              // space for return address
  c9:	89 10                	mov    %edx,(%eax)
  t->sp -= 32;                             // space for registers that thread_switch expects
  cb:	83 28 20             	subl   $0x20,(%eax)
    if (t->state == FREE) break;
  ce:	a1 c4 2e 00 00       	mov    0x2ec4,%eax
  d3:	85 c0                	test   %eax,%eax
  d5:	74 6f                	je     146 <main+0x146>
  d7:	8b 0d cc 4e 00 00    	mov    0x4ecc,%ecx
  dd:	85 c9                	test   %ecx,%ecx
  df:	74 76                	je     157 <main+0x157>
  e1:	8b 15 d4 6e 00 00    	mov    0x6ed4,%edx
  e7:	85 d2                	test   %edx,%edx
  e9:	0f 84 83 00 00 00    	je     172 <main+0x172>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  ef:	a1 dc 8e 00 00       	mov    0x8edc,%eax
  f4:	ba d8 6e 00 00       	mov    $0x6ed8,%edx
  f9:	85 c0                	test   %eax,%eax
  fb:	b8 e0 8e 00 00       	mov    $0x8ee0,%eax
 100:	0f 44 c2             	cmove  %edx,%eax
  t->sp -= 4;                              // space for return address
 103:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  * (int *) (t->sp) = (int)func;           // push return address on stack
 109:	c7 80 00 20 00 00 30 	movl   $0x230,0x2000(%eax)
 110:	02 00 00 
  t->state = RUNNABLE;
 113:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 11a:	00 00 00 
  t->sp -= 4;                              // space for return address
 11d:	89 10                	mov    %edx,(%eax)
  t->sp -= 32;                             // space for registers that thread_switch expects
 11f:	83 28 20             	subl   $0x20,(%eax)
  thread_init1();
  thread_create1(mythread1);
  thread_create1(blockthread1);
  thread_create1(mythread1);
  thread_schedule1();
 122:	e8 79 00 00 00       	call   1a0 <thread_schedule1>
  return 0;
}
 127:	83 c4 04             	add    $0x4,%esp
 12a:	31 c0                	xor    %eax,%eax
 12c:	59                   	pop    %ecx
 12d:	5d                   	pop    %ebp
 12e:	8d 61 fc             	lea    -0x4(%ecx),%esp
 131:	c3                   	ret    
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 132:	b8 c8 2e 00 00       	mov    $0x2ec8,%eax
 137:	e9 19 ff ff ff       	jmp    55 <main+0x55>
 13c:	b8 d0 4e 00 00       	mov    $0x4ed0,%eax
 141:	e9 0f ff ff ff       	jmp    55 <main+0x55>
 146:	b8 c0 0e 00 00       	mov    $0xec0,%eax
 14b:	eb b6                	jmp    103 <main+0x103>
 14d:	b8 c0 0e 00 00       	mov    $0xec0,%eax
 152:	e9 58 ff ff ff       	jmp    af <main+0xaf>
 157:	b8 c8 2e 00 00       	mov    $0x2ec8,%eax
 15c:	eb a5                	jmp    103 <main+0x103>
 15e:	b8 c8 2e 00 00       	mov    $0x2ec8,%eax
 163:	e9 47 ff ff ff       	jmp    af <main+0xaf>
 168:	b8 d0 4e 00 00       	mov    $0x4ed0,%eax
 16d:	e9 3d ff ff ff       	jmp    af <main+0xaf>
 172:	b8 d0 4e 00 00       	mov    $0x4ed0,%eax
 177:	eb 8a                	jmp    103 <main+0x103>
 179:	66 90                	xchg   %ax,%ax
 17b:	66 90                	xchg   %ax,%ax
 17d:	66 90                	xchg   %ax,%ax
 17f:	90                   	nop

00000180 <blockthread1>:
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 08             	sub    $0x8,%esp
  printf(1, "Blockthread running... CPU: %d\n", cpu());
 186:	e8 17 05 00 00       	call   6a2 <cpu>
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	50                   	push   %eax
 18f:	68 b8 0a 00 00       	push   $0xab8
 194:	6a 01                	push   $0x1
 196:	e8 c5 05 00 00       	call   760 <printf>
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	eb fe                	jmp    19e <blockthread1+0x1e>

000001a0 <thread_schedule1>:
    if (t->state == RUNNABLE && t != current_thread) {
 1a0:	8b 15 ec 8e 00 00    	mov    0x8eec,%edx
  next_thread = 0;
 1a6:	c7 05 f0 8e 00 00 00 	movl   $0x0,0x8ef0
 1ad:	00 00 00 
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 1b0:	b8 c0 0e 00 00       	mov    $0xec0,%eax
    if (t->state == RUNNABLE && t != current_thread) {
 1b5:	83 b8 04 20 00 00 02 	cmpl   $0x2,0x2004(%eax)
 1bc:	74 22                	je     1e0 <thread_schedule1+0x40>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 1be:	05 08 20 00 00       	add    $0x2008,%eax
 1c3:	3d e0 8e 00 00       	cmp    $0x8ee0,%eax
 1c8:	75 eb                	jne    1b5 <thread_schedule1+0x15>
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 1ca:	83 ba 04 20 00 00 02 	cmpl   $0x2,0x2004(%edx)
 1d1:	75 43                	jne    216 <thread_schedule1+0x76>
    next_thread = 0;
 1d3:	c7 05 f0 8e 00 00 00 	movl   $0x0,0x8ef0
 1da:	00 00 00 
 1dd:	c3                   	ret    
 1de:	66 90                	xchg   %ax,%ax
    if (t->state == RUNNABLE && t != current_thread) {
 1e0:	39 c2                	cmp    %eax,%edx
 1e2:	74 da                	je     1be <thread_schedule1+0x1e>
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 1e4:	3d e0 8e 00 00       	cmp    $0x8ee0,%eax
      next_thread = t;
 1e9:	a3 f0 8e 00 00       	mov    %eax,0x8ef0
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 1ee:	73 13                	jae    203 <thread_schedule1+0x63>
  if (next_thread == 0) {
 1f0:	85 c0                	test   %eax,%eax
 1f2:	74 22                	je     216 <thread_schedule1+0x76>
    next_thread->state = RUNNING;
 1f4:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
 1fb:	00 00 00 
    thread_switch();
 1fe:	e9 75 01 00 00       	jmp    378 <thread_switch>
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 203:	83 ba 04 20 00 00 02 	cmpl   $0x2,0x2004(%edx)
 20a:	75 e4                	jne    1f0 <thread_schedule1+0x50>
  if (next_thread == 0) {
 20c:	85 d2                	test   %edx,%edx
    next_thread = current_thread;
 20e:	89 15 f0 8e 00 00    	mov    %edx,0x8ef0
  if (next_thread == 0) {
 214:	75 bd                	jne    1d3 <thread_schedule1+0x33>
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
 219:	83 ec 10             	sub    $0x10,%esp
    printf(2, "thread_schedule1: no runnable threads\n");
 21c:	68 d8 0a 00 00       	push   $0xad8
 221:	6a 02                	push   $0x2
 223:	e8 38 05 00 00       	call   760 <printf>
    exit();
 228:	e8 c5 03 00 00       	call   5f2 <exit>
 22d:	8d 76 00             	lea    0x0(%esi),%esi

00000230 <mythread1>:
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
  printf(1, "my thread running. CPU: %d\n", cpu());
 234:	bb 64 00 00 00       	mov    $0x64,%ebx
{
 239:	83 ec 04             	sub    $0x4,%esp
  printf(1, "my thread running. CPU: %d\n", cpu());
 23c:	e8 61 04 00 00       	call   6a2 <cpu>
 241:	83 ec 04             	sub    $0x4,%esp
 244:	50                   	push   %eax
 245:	68 00 0b 00 00       	push   $0xb00
 24a:	6a 01                	push   $0x1
 24c:	e8 0f 05 00 00       	call   760 <printf>
 251:	83 c4 10             	add    $0x10,%esp
 254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "my thread 0x%x\n", (int) current_thread);
 258:	83 ec 04             	sub    $0x4,%esp
 25b:	ff 35 ec 8e 00 00    	pushl  0x8eec
 261:	68 1c 0b 00 00       	push   $0xb1c
 266:	6a 01                	push   $0x1
 268:	e8 f3 04 00 00       	call   760 <printf>
  current_thread->state = RUNNABLE;
 26d:	a1 ec 8e 00 00       	mov    0x8eec,%eax
 272:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 279:	00 00 00 
  thread_schedule1();
 27c:	e8 1f ff ff ff       	call   1a0 <thread_schedule1>
  for (i = 0; i < 100; i++) {
 281:	83 c4 10             	add    $0x10,%esp
 284:	83 eb 01             	sub    $0x1,%ebx
 287:	75 cf                	jne    258 <mythread1+0x28>
  printf(1, "my thread: exit\n");
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	68 2c 0b 00 00       	push   $0xb2c
 291:	6a 01                	push   $0x1
 293:	e8 c8 04 00 00       	call   760 <printf>
  current_thread->state = FREE;
 298:	a1 ec 8e 00 00       	mov    0x8eec,%eax
  thread_schedule1();
 29d:	83 c4 10             	add    $0x10,%esp
  current_thread->state = FREE;
 2a0:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 2a7:	00 00 00 
}
 2aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2ad:	c9                   	leave  
  thread_schedule1();
 2ae:	e9 ed fe ff ff       	jmp    1a0 <thread_schedule1>
 2b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <thread_init1>:
{
 2c0:	55                   	push   %ebp
  current_thread = &all_thread[0];
 2c1:	c7 05 ec 8e 00 00 c0 	movl   $0xec0,0x8eec
 2c8:	0e 00 00 
  current_thread->state = RUNNING;
 2cb:	c7 05 c4 2e 00 00 01 	movl   $0x1,0x2ec4
 2d2:	00 00 00 
{
 2d5:	89 e5                	mov    %esp,%ebp
}
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002e0 <thread_create1>:
    if (t->state == FREE) break;
 2e0:	a1 c4 2e 00 00       	mov    0x2ec4,%eax
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
    if (t->state == FREE) break;
 2e8:	85 c0                	test   %eax,%eax
 2ea:	74 4c                	je     338 <thread_create1+0x58>
 2ec:	8b 0d cc 4e 00 00    	mov    0x4ecc,%ecx
 2f2:	85 c9                	test   %ecx,%ecx
 2f4:	74 4a                	je     340 <thread_create1+0x60>
 2f6:	8b 15 d4 6e 00 00    	mov    0x6ed4,%edx
 2fc:	85 d2                	test   %edx,%edx
 2fe:	74 50                	je     350 <thread_create1+0x70>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 300:	a1 dc 8e 00 00       	mov    0x8edc,%eax
 305:	ba d8 6e 00 00       	mov    $0x6ed8,%edx
 30a:	85 c0                	test   %eax,%eax
 30c:	b8 e0 8e 00 00       	mov    $0x8ee0,%eax
 311:	0f 44 c2             	cmove  %edx,%eax
  t->sp -= 4;                              // space for return address
 314:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  t->state = RUNNABLE;
 31a:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 321:	00 00 00 
  t->sp -= 4;                              // space for return address
 324:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 326:	8b 55 08             	mov    0x8(%ebp),%edx
  t->sp -= 32;                             // space for registers that thread_switch expects
 329:	83 28 20             	subl   $0x20,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 32c:	89 90 00 20 00 00    	mov    %edx,0x2000(%eax)
}
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    
 334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 338:	b8 c0 0e 00 00       	mov    $0xec0,%eax
 33d:	eb d5                	jmp    314 <thread_create1+0x34>
 33f:	90                   	nop
 340:	b8 c8 2e 00 00       	mov    $0x2ec8,%eax
 345:	eb cd                	jmp    314 <thread_create1+0x34>
 347:	89 f6                	mov    %esi,%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 350:	b8 d0 4e 00 00       	mov    $0x4ed0,%eax
 355:	eb bd                	jmp    314 <thread_create1+0x34>
 357:	89 f6                	mov    %esi,%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <thread_yield1>:
  current_thread->state = RUNNABLE;
 360:	a1 ec 8e 00 00       	mov    0x8eec,%eax
{
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
  current_thread->state = RUNNABLE;
 368:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 36f:	00 00 00 
}
 372:	5d                   	pop    %ebp
  thread_schedule1();
 373:	e9 28 fe ff ff       	jmp    1a0 <thread_schedule1>

00000378 <thread_switch>:
 * Use eax as a temporary register; it is caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
  pushal                        /* push e{abcd}x, e{sb}p, e{sd}i */
 378:	60                   	pusha  
  movl current_thread, %eax
 379:	a1 ec 8e 00 00       	mov    0x8eec,%eax
  movl %esp, (%eax)               /* save sp in current_thread->sp */
 37e:	89 20                	mov    %esp,(%eax)
  movl next_thread, %eax
 380:	a1 f0 8e 00 00       	mov    0x8ef0,%eax
  movl %eax, current_thread
 385:	a3 ec 8e 00 00       	mov    %eax,0x8eec
  movl $0, next_thread
 38a:	c7 05 f0 8e 00 00 00 	movl   $0x0,0x8ef0
 391:	00 00 00 
  movl current_thread, %eax
 394:	a1 ec 8e 00 00       	mov    0x8eec,%eax
  movl (%eax), %esp
 399:	8b 20                	mov    (%eax),%esp
  popal
 39b:	61                   	popa   
	ret				/* pop return address from stack */
 39c:	c3                   	ret    
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3aa:	89 c2                	mov    %eax,%edx
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3b0:	83 c1 01             	add    $0x1,%ecx
 3b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 3b7:	83 c2 01             	add    $0x1,%edx
 3ba:	84 db                	test   %bl,%bl
 3bc:	88 5a ff             	mov    %bl,-0x1(%edx)
 3bf:	75 ef                	jne    3b0 <strcpy+0x10>
    ;
  return os;
}
 3c1:	5b                   	pop    %ebx
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    
 3c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	53                   	push   %ebx
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
 3d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3da:	0f b6 02             	movzbl (%edx),%eax
 3dd:	0f b6 19             	movzbl (%ecx),%ebx
 3e0:	84 c0                	test   %al,%al
 3e2:	75 1c                	jne    400 <strcmp+0x30>
 3e4:	eb 2a                	jmp    410 <strcmp+0x40>
 3e6:	8d 76 00             	lea    0x0(%esi),%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3f0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3f3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3f6:	83 c1 01             	add    $0x1,%ecx
 3f9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 3fc:	84 c0                	test   %al,%al
 3fe:	74 10                	je     410 <strcmp+0x40>
 400:	38 d8                	cmp    %bl,%al
 402:	74 ec                	je     3f0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 404:	29 d8                	sub    %ebx,%eax
}
 406:	5b                   	pop    %ebx
 407:	5d                   	pop    %ebp
 408:	c3                   	ret    
 409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 410:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 412:	29 d8                	sub    %ebx,%eax
}
 414:	5b                   	pop    %ebx
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
 417:	89 f6                	mov    %esi,%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <strlen>:

uint
strlen(char *s)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 426:	80 39 00             	cmpb   $0x0,(%ecx)
 429:	74 15                	je     440 <strlen+0x20>
 42b:	31 d2                	xor    %edx,%edx
 42d:	8d 76 00             	lea    0x0(%esi),%esi
 430:	83 c2 01             	add    $0x1,%edx
 433:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 437:	89 d0                	mov    %edx,%eax
 439:	75 f5                	jne    430 <strlen+0x10>
    ;
  return n;
}
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 440:	31 c0                	xor    %eax,%eax
}
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
 444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 44a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000450 <memset>:

void*
memset(void *dst, int c, uint n)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 457:	8b 4d 10             	mov    0x10(%ebp),%ecx
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 d7                	mov    %edx,%edi
 45f:	fc                   	cld    
 460:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 462:	89 d0                	mov    %edx,%eax
 464:	5f                   	pop    %edi
 465:	5d                   	pop    %ebp
 466:	c3                   	ret    
 467:	89 f6                	mov    %esi,%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000470 <strchr>:

char*
strchr(const char *s, char c)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 47a:	0f b6 10             	movzbl (%eax),%edx
 47d:	84 d2                	test   %dl,%dl
 47f:	74 1d                	je     49e <strchr+0x2e>
    if(*s == c)
 481:	38 d3                	cmp    %dl,%bl
 483:	89 d9                	mov    %ebx,%ecx
 485:	75 0d                	jne    494 <strchr+0x24>
 487:	eb 17                	jmp    4a0 <strchr+0x30>
 489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 490:	38 ca                	cmp    %cl,%dl
 492:	74 0c                	je     4a0 <strchr+0x30>
  for(; *s; s++)
 494:	83 c0 01             	add    $0x1,%eax
 497:	0f b6 10             	movzbl (%eax),%edx
 49a:	84 d2                	test   %dl,%dl
 49c:	75 f2                	jne    490 <strchr+0x20>
      return (char*)s;
  return 0;
 49e:	31 c0                	xor    %eax,%eax
}
 4a0:	5b                   	pop    %ebx
 4a1:	5d                   	pop    %ebp
 4a2:	c3                   	ret    
 4a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004b0 <gets>:

char*
gets(char *buf, int max)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b6:	31 f6                	xor    %esi,%esi
 4b8:	89 f3                	mov    %esi,%ebx
{
 4ba:	83 ec 1c             	sub    $0x1c,%esp
 4bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4c0:	eb 2f                	jmp    4f1 <gets+0x41>
 4c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4cb:	83 ec 04             	sub    $0x4,%esp
 4ce:	6a 01                	push   $0x1
 4d0:	50                   	push   %eax
 4d1:	6a 00                	push   $0x0
 4d3:	e8 32 01 00 00       	call   60a <read>
    if(cc < 1)
 4d8:	83 c4 10             	add    $0x10,%esp
 4db:	85 c0                	test   %eax,%eax
 4dd:	7e 1c                	jle    4fb <gets+0x4b>
      break;
    buf[i++] = c;
 4df:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4e3:	83 c7 01             	add    $0x1,%edi
 4e6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4e9:	3c 0a                	cmp    $0xa,%al
 4eb:	74 23                	je     510 <gets+0x60>
 4ed:	3c 0d                	cmp    $0xd,%al
 4ef:	74 1f                	je     510 <gets+0x60>
  for(i=0; i+1 < max; ){
 4f1:	83 c3 01             	add    $0x1,%ebx
 4f4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4f7:	89 fe                	mov    %edi,%esi
 4f9:	7c cd                	jl     4c8 <gets+0x18>
 4fb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 500:	c6 03 00             	movb   $0x0,(%ebx)
}
 503:	8d 65 f4             	lea    -0xc(%ebp),%esp
 506:	5b                   	pop    %ebx
 507:	5e                   	pop    %esi
 508:	5f                   	pop    %edi
 509:	5d                   	pop    %ebp
 50a:	c3                   	ret    
 50b:	90                   	nop
 50c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 510:	8b 75 08             	mov    0x8(%ebp),%esi
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	01 de                	add    %ebx,%esi
 518:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 51a:	c6 03 00             	movb   $0x0,(%ebx)
}
 51d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 520:	5b                   	pop    %ebx
 521:	5e                   	pop    %esi
 522:	5f                   	pop    %edi
 523:	5d                   	pop    %ebp
 524:	c3                   	ret    
 525:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000530 <stat>:

int
stat(char *n, struct stat *st)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	56                   	push   %esi
 534:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 535:	83 ec 08             	sub    $0x8,%esp
 538:	6a 00                	push   $0x0
 53a:	ff 75 08             	pushl  0x8(%ebp)
 53d:	e8 f0 00 00 00       	call   632 <open>
  if(fd < 0)
 542:	83 c4 10             	add    $0x10,%esp
 545:	85 c0                	test   %eax,%eax
 547:	78 27                	js     570 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 549:	83 ec 08             	sub    $0x8,%esp
 54c:	ff 75 0c             	pushl  0xc(%ebp)
 54f:	89 c3                	mov    %eax,%ebx
 551:	50                   	push   %eax
 552:	e8 f3 00 00 00       	call   64a <fstat>
  close(fd);
 557:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 55a:	89 c6                	mov    %eax,%esi
  close(fd);
 55c:	e8 b9 00 00 00       	call   61a <close>
  return r;
 561:	83 c4 10             	add    $0x10,%esp
}
 564:	8d 65 f8             	lea    -0x8(%ebp),%esp
 567:	89 f0                	mov    %esi,%eax
 569:	5b                   	pop    %ebx
 56a:	5e                   	pop    %esi
 56b:	5d                   	pop    %ebp
 56c:	c3                   	ret    
 56d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 570:	be ff ff ff ff       	mov    $0xffffffff,%esi
 575:	eb ed                	jmp    564 <stat+0x34>
 577:	89 f6                	mov    %esi,%esi
 579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000580 <atoi>:

int
atoi(const char *s)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	53                   	push   %ebx
 584:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 587:	0f be 11             	movsbl (%ecx),%edx
 58a:	8d 42 d0             	lea    -0x30(%edx),%eax
 58d:	3c 09                	cmp    $0x9,%al
  n = 0;
 58f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 594:	77 1f                	ja     5b5 <atoi+0x35>
 596:	8d 76 00             	lea    0x0(%esi),%esi
 599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 5a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5a3:	83 c1 01             	add    $0x1,%ecx
 5a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 5aa:	0f be 11             	movsbl (%ecx),%edx
 5ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5b0:	80 fb 09             	cmp    $0x9,%bl
 5b3:	76 eb                	jbe    5a0 <atoi+0x20>
  return n;
}
 5b5:	5b                   	pop    %ebx
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    
 5b8:	90                   	nop
 5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005c0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	56                   	push   %esi
 5c4:	53                   	push   %ebx
 5c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5ce:	85 db                	test   %ebx,%ebx
 5d0:	7e 14                	jle    5e6 <memmove+0x26>
 5d2:	31 d2                	xor    %edx,%edx
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5df:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 5e2:	39 d3                	cmp    %edx,%ebx
 5e4:	75 f2                	jne    5d8 <memmove+0x18>
  return vdst;
}
 5e6:	5b                   	pop    %ebx
 5e7:	5e                   	pop    %esi
 5e8:	5d                   	pop    %ebp
 5e9:	c3                   	ret    

000005ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ea:	b8 01 00 00 00       	mov    $0x1,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <exit>:
SYSCALL(exit)
 5f2:	b8 02 00 00 00       	mov    $0x2,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <wait>:
SYSCALL(wait)
 5fa:	b8 03 00 00 00       	mov    $0x3,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <pipe>:
SYSCALL(pipe)
 602:	b8 04 00 00 00       	mov    $0x4,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <read>:
SYSCALL(read)
 60a:	b8 05 00 00 00       	mov    $0x5,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <write>:
SYSCALL(write)
 612:	b8 10 00 00 00       	mov    $0x10,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <close>:
SYSCALL(close)
 61a:	b8 15 00 00 00       	mov    $0x15,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <kill>:
SYSCALL(kill)
 622:	b8 06 00 00 00       	mov    $0x6,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <exec>:
SYSCALL(exec)
 62a:	b8 07 00 00 00       	mov    $0x7,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <open>:
SYSCALL(open)
 632:	b8 0f 00 00 00       	mov    $0xf,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <mknod>:
SYSCALL(mknod)
 63a:	b8 11 00 00 00       	mov    $0x11,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <unlink>:
SYSCALL(unlink)
 642:	b8 12 00 00 00       	mov    $0x12,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <fstat>:
SYSCALL(fstat)
 64a:	b8 08 00 00 00       	mov    $0x8,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <link>:
SYSCALL(link)
 652:	b8 13 00 00 00       	mov    $0x13,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <mkdir>:
SYSCALL(mkdir)
 65a:	b8 14 00 00 00       	mov    $0x14,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <chdir>:
SYSCALL(chdir)
 662:	b8 09 00 00 00       	mov    $0x9,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <dup>:
SYSCALL(dup)
 66a:	b8 0a 00 00 00       	mov    $0xa,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <getpid>:
SYSCALL(getpid)
 672:	b8 0b 00 00 00       	mov    $0xb,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <sbrk>:
SYSCALL(sbrk)
 67a:	b8 0c 00 00 00       	mov    $0xc,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <sleep>:
SYSCALL(sleep)
 682:	b8 0d 00 00 00       	mov    $0xd,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <uptime>:
SYSCALL(uptime)
 68a:	b8 0e 00 00 00       	mov    $0xe,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <clone>:
SYSCALL(clone)
 692:	b8 16 00 00 00       	mov    $0x16,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <join>:
SYSCALL(join)
 69a:	b8 17 00 00 00       	mov    $0x17,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <cpu>:
SYSCALL(cpu)
 6a2:	b8 18 00 00 00       	mov    $0x18,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <setscheduler>:
SYSCALL(setscheduler)
 6aa:	b8 19 00 00 00       	mov    $0x19,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    
 6b2:	66 90                	xchg   %ax,%ax
 6b4:	66 90                	xchg   %ax,%ax
 6b6:	66 90                	xchg   %ax,%ax
 6b8:	66 90                	xchg   %ax,%ax
 6ba:	66 90                	xchg   %ax,%ax
 6bc:	66 90                	xchg   %ax,%ax
 6be:	66 90                	xchg   %ax,%ax

000006c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6c9:	85 d2                	test   %edx,%edx
{
 6cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 6ce:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 6d0:	79 76                	jns    748 <printint+0x88>
 6d2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6d6:	74 70                	je     748 <printint+0x88>
    x = -xx;
 6d8:	f7 d8                	neg    %eax
    neg = 1;
 6da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 6e1:	31 f6                	xor    %esi,%esi
 6e3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6e6:	eb 0a                	jmp    6f2 <printint+0x32>
 6e8:	90                   	nop
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 6f0:	89 fe                	mov    %edi,%esi
 6f2:	31 d2                	xor    %edx,%edx
 6f4:	8d 7e 01             	lea    0x1(%esi),%edi
 6f7:	f7 f1                	div    %ecx
 6f9:	0f b6 92 44 0b 00 00 	movzbl 0xb44(%edx),%edx
  }while((x /= base) != 0);
 700:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 702:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 705:	75 e9                	jne    6f0 <printint+0x30>
  if(neg)
 707:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 70a:	85 c0                	test   %eax,%eax
 70c:	74 08                	je     716 <printint+0x56>
    buf[i++] = '-';
 70e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 713:	8d 7e 02             	lea    0x2(%esi),%edi
 716:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 71a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 71d:	8d 76 00             	lea    0x0(%esi),%esi
 720:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 723:	83 ec 04             	sub    $0x4,%esp
 726:	83 ee 01             	sub    $0x1,%esi
 729:	6a 01                	push   $0x1
 72b:	53                   	push   %ebx
 72c:	57                   	push   %edi
 72d:	88 45 d7             	mov    %al,-0x29(%ebp)
 730:	e8 dd fe ff ff       	call   612 <write>

  while(--i >= 0)
 735:	83 c4 10             	add    $0x10,%esp
 738:	39 de                	cmp    %ebx,%esi
 73a:	75 e4                	jne    720 <printint+0x60>
    putc(fd, buf[i]);
}
 73c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73f:	5b                   	pop    %ebx
 740:	5e                   	pop    %esi
 741:	5f                   	pop    %edi
 742:	5d                   	pop    %ebp
 743:	c3                   	ret    
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 748:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 74f:	eb 90                	jmp    6e1 <printint+0x21>
 751:	eb 0d                	jmp    760 <printf>
 753:	90                   	nop
 754:	90                   	nop
 755:	90                   	nop
 756:	90                   	nop
 757:	90                   	nop
 758:	90                   	nop
 759:	90                   	nop
 75a:	90                   	nop
 75b:	90                   	nop
 75c:	90                   	nop
 75d:	90                   	nop
 75e:	90                   	nop
 75f:	90                   	nop

00000760 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	53                   	push   %ebx
 766:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 769:	8b 75 0c             	mov    0xc(%ebp),%esi
 76c:	0f b6 1e             	movzbl (%esi),%ebx
 76f:	84 db                	test   %bl,%bl
 771:	0f 84 b3 00 00 00    	je     82a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 777:	8d 45 10             	lea    0x10(%ebp),%eax
 77a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 77d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 77f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 782:	eb 2f                	jmp    7b3 <printf+0x53>
 784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 788:	83 f8 25             	cmp    $0x25,%eax
 78b:	0f 84 a7 00 00 00    	je     838 <printf+0xd8>
  write(fd, &c, 1);
 791:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 794:	83 ec 04             	sub    $0x4,%esp
 797:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 79a:	6a 01                	push   $0x1
 79c:	50                   	push   %eax
 79d:	ff 75 08             	pushl  0x8(%ebp)
 7a0:	e8 6d fe ff ff       	call   612 <write>
 7a5:	83 c4 10             	add    $0x10,%esp
 7a8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 7ab:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7af:	84 db                	test   %bl,%bl
 7b1:	74 77                	je     82a <printf+0xca>
    if(state == 0){
 7b3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 7b5:	0f be cb             	movsbl %bl,%ecx
 7b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7bb:	74 cb                	je     788 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7bd:	83 ff 25             	cmp    $0x25,%edi
 7c0:	75 e6                	jne    7a8 <printf+0x48>
      if(c == 'd'){
 7c2:	83 f8 64             	cmp    $0x64,%eax
 7c5:	0f 84 05 01 00 00    	je     8d0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7cb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7d1:	83 f9 70             	cmp    $0x70,%ecx
 7d4:	74 72                	je     848 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7d6:	83 f8 73             	cmp    $0x73,%eax
 7d9:	0f 84 99 00 00 00    	je     878 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7df:	83 f8 63             	cmp    $0x63,%eax
 7e2:	0f 84 08 01 00 00    	je     8f0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7e8:	83 f8 25             	cmp    $0x25,%eax
 7eb:	0f 84 ef 00 00 00    	je     8e0 <printf+0x180>
  write(fd, &c, 1);
 7f1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7f4:	83 ec 04             	sub    $0x4,%esp
 7f7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7fb:	6a 01                	push   $0x1
 7fd:	50                   	push   %eax
 7fe:	ff 75 08             	pushl  0x8(%ebp)
 801:	e8 0c fe ff ff       	call   612 <write>
 806:	83 c4 0c             	add    $0xc,%esp
 809:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 80c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 80f:	6a 01                	push   $0x1
 811:	50                   	push   %eax
 812:	ff 75 08             	pushl  0x8(%ebp)
 815:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 818:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 81a:	e8 f3 fd ff ff       	call   612 <write>
  for(i = 0; fmt[i]; i++){
 81f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 823:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 826:	84 db                	test   %bl,%bl
 828:	75 89                	jne    7b3 <printf+0x53>
    }
  }
}
 82a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 82d:	5b                   	pop    %ebx
 82e:	5e                   	pop    %esi
 82f:	5f                   	pop    %edi
 830:	5d                   	pop    %ebp
 831:	c3                   	ret    
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 838:	bf 25 00 00 00       	mov    $0x25,%edi
 83d:	e9 66 ff ff ff       	jmp    7a8 <printf+0x48>
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 848:	83 ec 0c             	sub    $0xc,%esp
 84b:	b9 10 00 00 00       	mov    $0x10,%ecx
 850:	6a 00                	push   $0x0
 852:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 855:	8b 45 08             	mov    0x8(%ebp),%eax
 858:	8b 17                	mov    (%edi),%edx
 85a:	e8 61 fe ff ff       	call   6c0 <printint>
        ap++;
 85f:	89 f8                	mov    %edi,%eax
 861:	83 c4 10             	add    $0x10,%esp
      state = 0;
 864:	31 ff                	xor    %edi,%edi
        ap++;
 866:	83 c0 04             	add    $0x4,%eax
 869:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 86c:	e9 37 ff ff ff       	jmp    7a8 <printf+0x48>
 871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 878:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 87b:	8b 08                	mov    (%eax),%ecx
        ap++;
 87d:	83 c0 04             	add    $0x4,%eax
 880:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 883:	85 c9                	test   %ecx,%ecx
 885:	0f 84 8e 00 00 00    	je     919 <printf+0x1b9>
        while(*s != 0){
 88b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 88e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 890:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 892:	84 c0                	test   %al,%al
 894:	0f 84 0e ff ff ff    	je     7a8 <printf+0x48>
 89a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 89d:	89 de                	mov    %ebx,%esi
 89f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8a2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 8a5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 8a8:	83 ec 04             	sub    $0x4,%esp
          s++;
 8ab:	83 c6 01             	add    $0x1,%esi
 8ae:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 8b1:	6a 01                	push   $0x1
 8b3:	57                   	push   %edi
 8b4:	53                   	push   %ebx
 8b5:	e8 58 fd ff ff       	call   612 <write>
        while(*s != 0){
 8ba:	0f b6 06             	movzbl (%esi),%eax
 8bd:	83 c4 10             	add    $0x10,%esp
 8c0:	84 c0                	test   %al,%al
 8c2:	75 e4                	jne    8a8 <printf+0x148>
 8c4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 8c7:	31 ff                	xor    %edi,%edi
 8c9:	e9 da fe ff ff       	jmp    7a8 <printf+0x48>
 8ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 8d0:	83 ec 0c             	sub    $0xc,%esp
 8d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8d8:	6a 01                	push   $0x1
 8da:	e9 73 ff ff ff       	jmp    852 <printf+0xf2>
 8df:	90                   	nop
  write(fd, &c, 1);
 8e0:	83 ec 04             	sub    $0x4,%esp
 8e3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 8e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 8e9:	6a 01                	push   $0x1
 8eb:	e9 21 ff ff ff       	jmp    811 <printf+0xb1>
        putc(fd, *ap);
 8f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 8f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8f6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 8f8:	6a 01                	push   $0x1
        ap++;
 8fa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 8fd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 900:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 903:	50                   	push   %eax
 904:	ff 75 08             	pushl  0x8(%ebp)
 907:	e8 06 fd ff ff       	call   612 <write>
        ap++;
 90c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 90f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 912:	31 ff                	xor    %edi,%edi
 914:	e9 8f fe ff ff       	jmp    7a8 <printf+0x48>
          s = "(null)";
 919:	bb 3d 0b 00 00       	mov    $0xb3d,%ebx
        while(*s != 0){
 91e:	b8 28 00 00 00       	mov    $0x28,%eax
 923:	e9 72 ff ff ff       	jmp    89a <printf+0x13a>
 928:	66 90                	xchg   %ax,%ax
 92a:	66 90                	xchg   %ax,%ax
 92c:	66 90                	xchg   %ax,%ax
 92e:	66 90                	xchg   %ax,%ax

00000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 931:	a1 e0 8e 00 00       	mov    0x8ee0,%eax
{
 936:	89 e5                	mov    %esp,%ebp
 938:	57                   	push   %edi
 939:	56                   	push   %esi
 93a:	53                   	push   %ebx
 93b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 93e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 948:	39 c8                	cmp    %ecx,%eax
 94a:	8b 10                	mov    (%eax),%edx
 94c:	73 32                	jae    980 <free+0x50>
 94e:	39 d1                	cmp    %edx,%ecx
 950:	72 04                	jb     956 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	39 d0                	cmp    %edx,%eax
 954:	72 32                	jb     988 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 956:	8b 73 fc             	mov    -0x4(%ebx),%esi
 959:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 95c:	39 fa                	cmp    %edi,%edx
 95e:	74 30                	je     990 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 960:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 963:	8b 50 04             	mov    0x4(%eax),%edx
 966:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 969:	39 f1                	cmp    %esi,%ecx
 96b:	74 3a                	je     9a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 96d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 96f:	a3 e0 8e 00 00       	mov    %eax,0x8ee0
}
 974:	5b                   	pop    %ebx
 975:	5e                   	pop    %esi
 976:	5f                   	pop    %edi
 977:	5d                   	pop    %ebp
 978:	c3                   	ret    
 979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	39 d0                	cmp    %edx,%eax
 982:	72 04                	jb     988 <free+0x58>
 984:	39 d1                	cmp    %edx,%ecx
 986:	72 ce                	jb     956 <free+0x26>
{
 988:	89 d0                	mov    %edx,%eax
 98a:	eb bc                	jmp    948 <free+0x18>
 98c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 990:	03 72 04             	add    0x4(%edx),%esi
 993:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 996:	8b 10                	mov    (%eax),%edx
 998:	8b 12                	mov    (%edx),%edx
 99a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 99d:	8b 50 04             	mov    0x4(%eax),%edx
 9a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9a3:	39 f1                	cmp    %esi,%ecx
 9a5:	75 c6                	jne    96d <free+0x3d>
    p->s.size += bp->s.size;
 9a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9aa:	a3 e0 8e 00 00       	mov    %eax,0x8ee0
    p->s.size += bp->s.size;
 9af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9b5:	89 10                	mov    %edx,(%eax)
}
 9b7:	5b                   	pop    %ebx
 9b8:	5e                   	pop    %esi
 9b9:	5f                   	pop    %edi
 9ba:	5d                   	pop    %ebp
 9bb:	c3                   	ret    
 9bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	57                   	push   %edi
 9c4:	56                   	push   %esi
 9c5:	53                   	push   %ebx
 9c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9cc:	8b 15 e0 8e 00 00    	mov    0x8ee0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	8d 78 07             	lea    0x7(%eax),%edi
 9d5:	c1 ef 03             	shr    $0x3,%edi
 9d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9db:	85 d2                	test   %edx,%edx
 9dd:	0f 84 9d 00 00 00    	je     a80 <malloc+0xc0>
 9e3:	8b 02                	mov    (%edx),%eax
 9e5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9e8:	39 cf                	cmp    %ecx,%edi
 9ea:	76 6c                	jbe    a58 <malloc+0x98>
 9ec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9f2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9f7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 9fa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 a01:	eb 0e                	jmp    a11 <malloc+0x51>
 a03:	90                   	nop
 a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a08:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a0a:	8b 48 04             	mov    0x4(%eax),%ecx
 a0d:	39 f9                	cmp    %edi,%ecx
 a0f:	73 47                	jae    a58 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a11:	39 05 e0 8e 00 00    	cmp    %eax,0x8ee0
 a17:	89 c2                	mov    %eax,%edx
 a19:	75 ed                	jne    a08 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a1b:	83 ec 0c             	sub    $0xc,%esp
 a1e:	56                   	push   %esi
 a1f:	e8 56 fc ff ff       	call   67a <sbrk>
  if(p == (char*)-1)
 a24:	83 c4 10             	add    $0x10,%esp
 a27:	83 f8 ff             	cmp    $0xffffffff,%eax
 a2a:	74 1c                	je     a48 <malloc+0x88>
  hp->s.size = nu;
 a2c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a2f:	83 ec 0c             	sub    $0xc,%esp
 a32:	83 c0 08             	add    $0x8,%eax
 a35:	50                   	push   %eax
 a36:	e8 f5 fe ff ff       	call   930 <free>
  return freep;
 a3b:	8b 15 e0 8e 00 00    	mov    0x8ee0,%edx
      if((p = morecore(nunits)) == 0)
 a41:	83 c4 10             	add    $0x10,%esp
 a44:	85 d2                	test   %edx,%edx
 a46:	75 c0                	jne    a08 <malloc+0x48>
        return 0;
  }
}
 a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a4b:	31 c0                	xor    %eax,%eax
}
 a4d:	5b                   	pop    %ebx
 a4e:	5e                   	pop    %esi
 a4f:	5f                   	pop    %edi
 a50:	5d                   	pop    %ebp
 a51:	c3                   	ret    
 a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a58:	39 cf                	cmp    %ecx,%edi
 a5a:	74 54                	je     ab0 <malloc+0xf0>
        p->s.size -= nunits;
 a5c:	29 f9                	sub    %edi,%ecx
 a5e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a61:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a64:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a67:	89 15 e0 8e 00 00    	mov    %edx,0x8ee0
}
 a6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a70:	83 c0 08             	add    $0x8,%eax
}
 a73:	5b                   	pop    %ebx
 a74:	5e                   	pop    %esi
 a75:	5f                   	pop    %edi
 a76:	5d                   	pop    %ebp
 a77:	c3                   	ret    
 a78:	90                   	nop
 a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 a80:	c7 05 e0 8e 00 00 e4 	movl   $0x8ee4,0x8ee0
 a87:	8e 00 00 
 a8a:	c7 05 e4 8e 00 00 e4 	movl   $0x8ee4,0x8ee4
 a91:	8e 00 00 
    base.s.size = 0;
 a94:	b8 e4 8e 00 00       	mov    $0x8ee4,%eax
 a99:	c7 05 e8 8e 00 00 00 	movl   $0x0,0x8ee8
 aa0:	00 00 00 
 aa3:	e9 44 ff ff ff       	jmp    9ec <malloc+0x2c>
 aa8:	90                   	nop
 aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 ab0:	8b 08                	mov    (%eax),%ecx
 ab2:	89 0a                	mov    %ecx,(%edx)
 ab4:	eb b1                	jmp    a67 <malloc+0xa7>
