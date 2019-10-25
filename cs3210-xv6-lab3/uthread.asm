
_uthread:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}


int 
main(int argc, char *argv[]) 
{
   0:	55                   	push   %ebp
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
   1:	b8 20 0d 00 00       	mov    $0xd20,%eax
  current_thread = &all_thread[0];
   6:	c7 05 4c 8d 00 00 20 	movl   $0xd20,0x8d4c
   d:	0d 00 00 
  current_thread->state = RUNNING;
  10:	c7 05 24 2d 00 00 01 	movl   $0x1,0x2d24
  17:	00 00 00 
{
  1a:	89 e5                	mov    %esp,%ebp
  1c:	83 e4 f0             	and    $0xfffffff0,%esp
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  1f:	05 08 20 00 00       	add    $0x2008,%eax
  24:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
  29:	74 0d                	je     38 <main+0x38>
    if (t->state == FREE) break;
  2b:	8b 88 04 20 00 00    	mov    0x2004(%eax),%ecx
  31:	85 c9                	test   %ecx,%ecx
  33:	75 ea                	jne    1f <main+0x1f>
  35:	8d 76 00             	lea    0x0(%esi),%esi
  * (int *) (t->sp) = (int)func;           // push return address on stack
  38:	c7 80 00 20 00 00 30 	movl   $0x130,0x2000(%eax)
  3f:	01 00 00 
  t->sp -= 4;                              // space for return address
  42:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  48:	89 10                	mov    %edx,(%eax)
  t->state = RUNNABLE;
  4a:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
  51:	00 00 00 
  t->sp -= 32;                             // space for registers that thread_switch expects
  54:	83 28 20             	subl   $0x20,(%eax)
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  57:	b8 20 0d 00 00       	mov    $0xd20,%eax
    if (t->state == FREE) break;
  5c:	8b 90 04 20 00 00    	mov    0x2004(%eax),%edx
  62:	85 d2                	test   %edx,%edx
  64:	74 0c                	je     72 <main+0x72>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  66:	05 08 20 00 00       	add    $0x2008,%eax
  6b:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
  70:	75 ea                	jne    5c <main+0x5c>
  * (int *) (t->sp) = (int)func;           // push return address on stack
  72:	c7 80 00 20 00 00 30 	movl   $0x130,0x2000(%eax)
  79:	01 00 00 
  t->sp -= 4;                              // space for return address
  7c:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  82:	89 10                	mov    %edx,(%eax)
  t->sp -= 32;                             // space for registers that thread_switch expects
  84:	83 28 20             	subl   $0x20,(%eax)
  t->state = RUNNABLE;
  87:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
  8e:	00 00 00 
  thread_init();
  thread_create(mythread);
  thread_create(mythread);
  thread_schedule();
  91:	e8 0a 00 00 00       	call   a0 <thread_schedule>
  return 0;
}
  96:	31 c0                	xor    %eax,%eax
  98:	c9                   	leave  
  99:	c3                   	ret    
  9a:	66 90                	xchg   %ax,%ax
  9c:	66 90                	xchg   %ax,%ax
  9e:	66 90                	xchg   %ax,%ax

000000a0 <thread_schedule>:
  next_thread = 0;
  a0:	c7 05 50 8d 00 00 00 	movl   $0x0,0x8d50
  a7:	00 00 00 
    if (t->state == RUNNABLE && t != current_thread) {
  aa:	8b 15 4c 8d 00 00    	mov    0x8d4c,%edx
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  b0:	b8 20 0d 00 00       	mov    $0xd20,%eax
    if (t->state == RUNNABLE && t != current_thread) {
  b5:	83 b8 04 20 00 00 02 	cmpl   $0x2,0x2004(%eax)
  bc:	74 22                	je     e0 <thread_schedule+0x40>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  be:	05 08 20 00 00       	add    $0x2008,%eax
  c3:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
  c8:	75 eb                	jne    b5 <thread_schedule+0x15>
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  ca:	83 ba 04 20 00 00 02 	cmpl   $0x2,0x2004(%edx)
  d1:	75 30                	jne    103 <thread_schedule+0x63>
    next_thread = 0;
  d3:	c7 05 50 8d 00 00 00 	movl   $0x0,0x8d50
  da:	00 00 00 
  dd:	c3                   	ret    
  de:	66 90                	xchg   %ax,%ax
    if (t->state == RUNNABLE && t != current_thread) {
  e0:	39 c2                	cmp    %eax,%edx
  e2:	74 da                	je     be <thread_schedule+0x1e>
      next_thread = t;
  e4:	a3 50 8d 00 00       	mov    %eax,0x8d50
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  e9:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
  ee:	73 2a                	jae    11a <thread_schedule+0x7a>
  if (next_thread == 0) {
  f0:	85 c0                	test   %eax,%eax
  f2:	74 0f                	je     103 <thread_schedule+0x63>
    next_thread->state = RUNNING;
  f4:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  fb:	00 00 00 
    thread_switch();
  fe:	e9 21 01 00 00       	jmp    224 <thread_switch>
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 ec 10             	sub    $0x10,%esp
    printf(2, "thread_schedule: no runnable threads\n");
 109:	68 78 09 00 00       	push   $0x978
 10e:	6a 02                	push   $0x2
 110:	e8 fb 04 00 00       	call   610 <printf>
    exit();
 115:	e8 87 03 00 00       	call   4a1 <exit>
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 11a:	83 ba 04 20 00 00 02 	cmpl   $0x2,0x2004(%edx)
 121:	75 cd                	jne    f0 <thread_schedule+0x50>
 123:	eb ae                	jmp    d3 <thread_schedule+0x33>
 125:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000130 <mythread>:
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
  printf(1, "my thread running\n");
 134:	bb 64 00 00 00       	mov    $0x64,%ebx
{
 139:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "my thread running\n");
 13c:	68 a0 09 00 00       	push   $0x9a0
 141:	6a 01                	push   $0x1
 143:	e8 c8 04 00 00       	call   610 <printf>
 148:	83 c4 10             	add    $0x10,%esp
 14b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop
    printf(1, "my thread 0x%x\n", (int) current_thread);
 150:	83 ec 04             	sub    $0x4,%esp
 153:	ff 35 4c 8d 00 00    	pushl  0x8d4c
 159:	68 b3 09 00 00       	push   $0x9b3
 15e:	6a 01                	push   $0x1
 160:	e8 ab 04 00 00       	call   610 <printf>
  current_thread->state = RUNNABLE;
 165:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
 16a:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 171:	00 00 00 
  thread_schedule();
 174:	e8 27 ff ff ff       	call   a0 <thread_schedule>
  for (i = 0; i < 100; i++) {
 179:	83 c4 10             	add    $0x10,%esp
 17c:	83 eb 01             	sub    $0x1,%ebx
 17f:	75 cf                	jne    150 <mythread+0x20>
  printf(1, "my thread: exit\n");
 181:	83 ec 08             	sub    $0x8,%esp
 184:	68 c3 09 00 00       	push   $0x9c3
 189:	6a 01                	push   $0x1
 18b:	e8 80 04 00 00       	call   610 <printf>
  current_thread->state = FREE;
 190:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
  thread_schedule();
 195:	83 c4 10             	add    $0x10,%esp
  current_thread->state = FREE;
 198:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 19f:	00 00 00 
}
 1a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a5:	c9                   	leave  
  thread_schedule();
 1a6:	e9 f5 fe ff ff       	jmp    a0 <thread_schedule>
 1ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1af:	90                   	nop

000001b0 <thread_init>:
  current_thread = &all_thread[0];
 1b0:	c7 05 4c 8d 00 00 20 	movl   $0xd20,0x8d4c
 1b7:	0d 00 00 
  current_thread->state = RUNNING;
 1ba:	c7 05 24 2d 00 00 01 	movl   $0x1,0x2d24
 1c1:	00 00 00 
}
 1c4:	c3                   	ret    
 1c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001d0 <thread_create>:
{
 1d0:	55                   	push   %ebp
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 1d1:	b8 20 0d 00 00       	mov    $0xd20,%eax
{
 1d6:	89 e5                	mov    %esp,%ebp
    if (t->state == FREE) break;
 1d8:	8b 90 04 20 00 00    	mov    0x2004(%eax),%edx
 1de:	85 d2                	test   %edx,%edx
 1e0:	74 0c                	je     1ee <thread_create+0x1e>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 1e2:	05 08 20 00 00       	add    $0x2008,%eax
 1e7:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
 1ec:	75 ea                	jne    1d8 <thread_create+0x8>
  t->state = RUNNABLE;
 1ee:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 1f5:	00 00 00 
  t->sp -= 4;                              // space for return address
 1f8:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
 1fe:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 200:	8b 55 08             	mov    0x8(%ebp),%edx
  t->sp -= 32;                             // space for registers that thread_switch expects
 203:	83 28 20             	subl   $0x20,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 206:	89 90 00 20 00 00    	mov    %edx,0x2000(%eax)
}
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    
 20e:	66 90                	xchg   %ax,%ax

00000210 <thread_yield>:
  current_thread->state = RUNNABLE;
 210:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
 215:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 21c:	00 00 00 
  thread_schedule();
 21f:	e9 7c fe ff ff       	jmp    a0 <thread_schedule>

00000224 <thread_switch>:
 * Use eax as a temporary register; it is caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
  pushal                        /* push e{abcd}x, e{sb}p, e{sd}i */
 224:	60                   	pusha  
  movl current_thread, %eax
 225:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
  movl %esp, (%eax)               /* save sp in current_thread->sp */
 22a:	89 20                	mov    %esp,(%eax)
  movl next_thread, %eax
 22c:	a1 50 8d 00 00       	mov    0x8d50,%eax
  movl %eax, current_thread
 231:	a3 4c 8d 00 00       	mov    %eax,0x8d4c
  movl $0, next_thread
 236:	c7 05 50 8d 00 00 00 	movl   $0x0,0x8d50
 23d:	00 00 00 
  movl current_thread, %eax
 240:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
  movl (%eax), %esp
 245:	8b 20                	mov    (%eax),%esp
  popal
 247:	61                   	popa   
	ret				/* pop return address from stack */
 248:	c3                   	ret    
 249:	66 90                	xchg   %ax,%ax
 24b:	66 90                	xchg   %ax,%ax
 24d:	66 90                	xchg   %ax,%ax
 24f:	90                   	nop

00000250 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 250:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 251:	31 d2                	xor    %edx,%edx
{
 253:	89 e5                	mov    %esp,%ebp
 255:	53                   	push   %ebx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 260:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 264:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 267:	83 c2 01             	add    $0x1,%edx
 26a:	84 c9                	test   %cl,%cl
 26c:	75 f2                	jne    260 <strcpy+0x10>
    ;
  return os;
}
 26e:	5b                   	pop    %ebx
 26f:	5d                   	pop    %ebp
 270:	c3                   	ret    
 271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27f:	90                   	nop

00000280 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	8b 5d 08             	mov    0x8(%ebp),%ebx
 288:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 28b:	0f b6 13             	movzbl (%ebx),%edx
 28e:	0f b6 0e             	movzbl (%esi),%ecx
 291:	84 d2                	test   %dl,%dl
 293:	74 1e                	je     2b3 <strcmp+0x33>
 295:	b8 01 00 00 00       	mov    $0x1,%eax
 29a:	38 ca                	cmp    %cl,%dl
 29c:	74 09                	je     2a7 <strcmp+0x27>
 29e:	eb 20                	jmp    2c0 <strcmp+0x40>
 2a0:	83 c0 01             	add    $0x1,%eax
 2a3:	38 ca                	cmp    %cl,%dl
 2a5:	75 19                	jne    2c0 <strcmp+0x40>
 2a7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2ab:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 2af:	84 d2                	test   %dl,%dl
 2b1:	75 ed                	jne    2a0 <strcmp+0x20>
 2b3:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 2b5:	5b                   	pop    %ebx
 2b6:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 2b7:	29 c8                	sub    %ecx,%eax
}
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret    
 2bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop
 2c0:	0f b6 c2             	movzbl %dl,%eax
 2c3:	5b                   	pop    %ebx
 2c4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 2c5:	29 c8                	sub    %ecx,%eax
}
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <strlen>:

uint
strlen(char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2d6:	80 39 00             	cmpb   $0x0,(%ecx)
 2d9:	74 15                	je     2f0 <strlen+0x20>
 2db:	31 d2                	xor    %edx,%edx
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	83 c2 01             	add    $0x1,%edx
 2e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2e7:	89 d0                	mov    %edx,%eax
 2e9:	75 f5                	jne    2e0 <strlen+0x10>
    ;
  return n;
}
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2f0:	31 c0                	xor    %eax,%eax
}
 2f2:	5d                   	pop    %ebp
 2f3:	c3                   	ret    
 2f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <memset>:

void*
memset(void *dst, int c, uint n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 307:	8b 4d 10             	mov    0x10(%ebp),%ecx
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 d7                	mov    %edx,%edi
 30f:	fc                   	cld    
 310:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 312:	89 d0                	mov    %edx,%eax
 314:	5f                   	pop    %edi
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
 317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31e:	66 90                	xchg   %ax,%ax

00000320 <strchr>:

char*
strchr(const char *s, char c)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 32a:	0f b6 18             	movzbl (%eax),%ebx
 32d:	84 db                	test   %bl,%bl
 32f:	74 1d                	je     34e <strchr+0x2e>
 331:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 333:	38 d3                	cmp    %dl,%bl
 335:	75 0d                	jne    344 <strchr+0x24>
 337:	eb 17                	jmp    350 <strchr+0x30>
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 340:	38 ca                	cmp    %cl,%dl
 342:	74 0c                	je     350 <strchr+0x30>
  for(; *s; s++)
 344:	83 c0 01             	add    $0x1,%eax
 347:	0f b6 10             	movzbl (%eax),%edx
 34a:	84 d2                	test   %dl,%dl
 34c:	75 f2                	jne    340 <strchr+0x20>
      return (char*)s;
  return 0;
 34e:	31 c0                	xor    %eax,%eax
}
 350:	5b                   	pop    %ebx
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000360 <gets>:

char*
gets(char *buf, int max)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 365:	31 f6                	xor    %esi,%esi
{
 367:	53                   	push   %ebx
 368:	89 f3                	mov    %esi,%ebx
 36a:	83 ec 1c             	sub    $0x1c,%esp
 36d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 370:	eb 2f                	jmp    3a1 <gets+0x41>
 372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 378:	83 ec 04             	sub    $0x4,%esp
 37b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 37e:	6a 01                	push   $0x1
 380:	50                   	push   %eax
 381:	6a 00                	push   $0x0
 383:	e8 31 01 00 00       	call   4b9 <read>
    if(cc < 1)
 388:	83 c4 10             	add    $0x10,%esp
 38b:	85 c0                	test   %eax,%eax
 38d:	7e 1c                	jle    3ab <gets+0x4b>
      break;
    buf[i++] = c;
 38f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 393:	83 c7 01             	add    $0x1,%edi
 396:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 399:	3c 0a                	cmp    $0xa,%al
 39b:	74 23                	je     3c0 <gets+0x60>
 39d:	3c 0d                	cmp    $0xd,%al
 39f:	74 1f                	je     3c0 <gets+0x60>
  for(i=0; i+1 < max; ){
 3a1:	83 c3 01             	add    $0x1,%ebx
 3a4:	89 fe                	mov    %edi,%esi
 3a6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3a9:	7c cd                	jl     378 <gets+0x18>
 3ab:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3b0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b6:	5b                   	pop    %ebx
 3b7:	5e                   	pop    %esi
 3b8:	5f                   	pop    %edi
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret    
 3bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop
 3c0:	8b 75 08             	mov    0x8(%ebp),%esi
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	01 de                	add    %ebx,%esi
 3c8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3ca:	c6 03 00             	movb   $0x0,(%ebx)
}
 3cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d0:	5b                   	pop    %ebx
 3d1:	5e                   	pop    %esi
 3d2:	5f                   	pop    %edi
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    
 3d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003e0 <stat>:

int
stat(char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e5:	83 ec 08             	sub    $0x8,%esp
 3e8:	6a 00                	push   $0x0
 3ea:	ff 75 08             	pushl  0x8(%ebp)
 3ed:	e8 ef 00 00 00       	call   4e1 <open>
  if(fd < 0)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	78 27                	js     420 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3f9:	83 ec 08             	sub    $0x8,%esp
 3fc:	ff 75 0c             	pushl  0xc(%ebp)
 3ff:	89 c3                	mov    %eax,%ebx
 401:	50                   	push   %eax
 402:	e8 f2 00 00 00       	call   4f9 <fstat>
  close(fd);
 407:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 40a:	89 c6                	mov    %eax,%esi
  close(fd);
 40c:	e8 b8 00 00 00       	call   4c9 <close>
  return r;
 411:	83 c4 10             	add    $0x10,%esp
}
 414:	8d 65 f8             	lea    -0x8(%ebp),%esp
 417:	89 f0                	mov    %esi,%eax
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 420:	be ff ff ff ff       	mov    $0xffffffff,%esi
 425:	eb ed                	jmp    414 <stat+0x34>
 427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42e:	66 90                	xchg   %ax,%ax

00000430 <atoi>:

int
atoi(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 437:	0f be 11             	movsbl (%ecx),%edx
 43a:	8d 42 d0             	lea    -0x30(%edx),%eax
 43d:	3c 09                	cmp    $0x9,%al
  n = 0;
 43f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 444:	77 1f                	ja     465 <atoi+0x35>
 446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 450:	83 c1 01             	add    $0x1,%ecx
 453:	8d 04 80             	lea    (%eax,%eax,4),%eax
 456:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 45a:	0f be 11             	movsbl (%ecx),%edx
 45d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 460:	80 fb 09             	cmp    $0x9,%bl
 463:	76 eb                	jbe    450 <atoi+0x20>
  return n;
}
 465:	5b                   	pop    %ebx
 466:	5d                   	pop    %ebp
 467:	c3                   	ret    
 468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46f:	90                   	nop

00000470 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	8b 55 10             	mov    0x10(%ebp),%edx
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	56                   	push   %esi
 47b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	85 d2                	test   %edx,%edx
 480:	7e 13                	jle    495 <memmove+0x25>
 482:	01 c2                	add    %eax,%edx
  dst = vdst;
 484:	89 c7                	mov    %eax,%edi
 486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 490:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 491:	39 fa                	cmp    %edi,%edx
 493:	75 fb                	jne    490 <memmove+0x20>
  return vdst;
}
 495:	5e                   	pop    %esi
 496:	5f                   	pop    %edi
 497:	5d                   	pop    %ebp
 498:	c3                   	ret    

00000499 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 499:	b8 01 00 00 00       	mov    $0x1,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <exit>:
SYSCALL(exit)
 4a1:	b8 02 00 00 00       	mov    $0x2,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <wait>:
SYSCALL(wait)
 4a9:	b8 03 00 00 00       	mov    $0x3,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <pipe>:
SYSCALL(pipe)
 4b1:	b8 04 00 00 00       	mov    $0x4,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <read>:
SYSCALL(read)
 4b9:	b8 05 00 00 00       	mov    $0x5,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <write>:
SYSCALL(write)
 4c1:	b8 10 00 00 00       	mov    $0x10,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <close>:
SYSCALL(close)
 4c9:	b8 15 00 00 00       	mov    $0x15,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <kill>:
SYSCALL(kill)
 4d1:	b8 06 00 00 00       	mov    $0x6,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <exec>:
SYSCALL(exec)
 4d9:	b8 07 00 00 00       	mov    $0x7,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <open>:
SYSCALL(open)
 4e1:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <mknod>:
SYSCALL(mknod)
 4e9:	b8 11 00 00 00       	mov    $0x11,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <unlink>:
SYSCALL(unlink)
 4f1:	b8 12 00 00 00       	mov    $0x12,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <fstat>:
SYSCALL(fstat)
 4f9:	b8 08 00 00 00       	mov    $0x8,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <link>:
SYSCALL(link)
 501:	b8 13 00 00 00       	mov    $0x13,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <mkdir>:
SYSCALL(mkdir)
 509:	b8 14 00 00 00       	mov    $0x14,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <chdir>:
SYSCALL(chdir)
 511:	b8 09 00 00 00       	mov    $0x9,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <dup>:
SYSCALL(dup)
 519:	b8 0a 00 00 00       	mov    $0xa,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <getpid>:
SYSCALL(getpid)
 521:	b8 0b 00 00 00       	mov    $0xb,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <sbrk>:
SYSCALL(sbrk)
 529:	b8 0c 00 00 00       	mov    $0xc,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <sleep>:
SYSCALL(sleep)
 531:	b8 0d 00 00 00       	mov    $0xd,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <uptime>:
SYSCALL(uptime)
 539:	b8 0e 00 00 00       	mov    $0xe,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    
 541:	66 90                	xchg   %ax,%ax
 543:	66 90                	xchg   %ax,%ax
 545:	66 90                	xchg   %ax,%ax
 547:	66 90                	xchg   %ax,%ax
 549:	66 90                	xchg   %ax,%ax
 54b:	66 90                	xchg   %ax,%ax
 54d:	66 90                	xchg   %ax,%ax
 54f:	90                   	nop

00000550 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 556:	89 d3                	mov    %edx,%ebx
{
 558:	83 ec 3c             	sub    $0x3c,%esp
 55b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 55e:	85 d2                	test   %edx,%edx
 560:	0f 89 92 00 00 00    	jns    5f8 <printint+0xa8>
 566:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 56a:	0f 84 88 00 00 00    	je     5f8 <printint+0xa8>
    neg = 1;
 570:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 577:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 579:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 580:	8d 75 d7             	lea    -0x29(%ebp),%esi
 583:	eb 08                	jmp    58d <printint+0x3d>
 585:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 588:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 58b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 58d:	89 d8                	mov    %ebx,%eax
 58f:	31 d2                	xor    %edx,%edx
 591:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 594:	f7 f1                	div    %ecx
 596:	83 c7 01             	add    $0x1,%edi
 599:	0f b6 92 dc 09 00 00 	movzbl 0x9dc(%edx),%edx
 5a0:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 5a3:	39 d9                	cmp    %ebx,%ecx
 5a5:	76 e1                	jbe    588 <printint+0x38>
  if(neg)
 5a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
 5aa:	85 c0                	test   %eax,%eax
 5ac:	74 0d                	je     5bb <printint+0x6b>
    buf[i++] = '-';
 5ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5b3:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 5b8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 5bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5be:	8b 7d bc             	mov    -0x44(%ebp),%edi
 5c1:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5c5:	eb 0f                	jmp    5d6 <printint+0x86>
 5c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ce:	66 90                	xchg   %ax,%ax
 5d0:	0f b6 13             	movzbl (%ebx),%edx
 5d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5d6:	83 ec 04             	sub    $0x4,%esp
 5d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5dc:	6a 01                	push   $0x1
 5de:	56                   	push   %esi
 5df:	57                   	push   %edi
 5e0:	e8 dc fe ff ff       	call   4c1 <write>

  while(--i >= 0)
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	39 de                	cmp    %ebx,%esi
 5ea:	75 e4                	jne    5d0 <printint+0x80>
    putc(fd, buf[i]);
}
 5ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5f                   	pop    %edi
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5f8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 5ff:	e9 75 ff ff ff       	jmp    579 <printint+0x29>
 604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop

00000610 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 619:	8b 75 0c             	mov    0xc(%ebp),%esi
 61c:	0f b6 1e             	movzbl (%esi),%ebx
 61f:	84 db                	test   %bl,%bl
 621:	0f 84 b9 00 00 00    	je     6e0 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 627:	8d 45 10             	lea    0x10(%ebp),%eax
 62a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 62d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 630:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 632:	89 45 d0             	mov    %eax,-0x30(%ebp)
 635:	eb 38                	jmp    66f <printf+0x5f>
 637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63e:	66 90                	xchg   %ax,%ax
 640:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 643:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 648:	83 f8 25             	cmp    $0x25,%eax
 64b:	74 17                	je     664 <printf+0x54>
  write(fd, &c, 1);
 64d:	83 ec 04             	sub    $0x4,%esp
 650:	88 5d e7             	mov    %bl,-0x19(%ebp)
 653:	6a 01                	push   $0x1
 655:	57                   	push   %edi
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 63 fe ff ff       	call   4c1 <write>
 65e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 661:	83 c4 10             	add    $0x10,%esp
 664:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 667:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 66b:	84 db                	test   %bl,%bl
 66d:	74 71                	je     6e0 <printf+0xd0>
    c = fmt[i] & 0xff;
 66f:	0f be cb             	movsbl %bl,%ecx
 672:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 675:	85 d2                	test   %edx,%edx
 677:	74 c7                	je     640 <printf+0x30>
      }
    } else if(state == '%'){
 679:	83 fa 25             	cmp    $0x25,%edx
 67c:	75 e6                	jne    664 <printf+0x54>
      if(c == 'd'){
 67e:	83 f8 64             	cmp    $0x64,%eax
 681:	0f 84 99 00 00 00    	je     720 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 687:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 68d:	83 f9 70             	cmp    $0x70,%ecx
 690:	74 5e                	je     6f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 692:	83 f8 73             	cmp    $0x73,%eax
 695:	0f 84 d5 00 00 00    	je     770 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69b:	83 f8 63             	cmp    $0x63,%eax
 69e:	0f 84 8c 00 00 00    	je     730 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6a4:	83 f8 25             	cmp    $0x25,%eax
 6a7:	0f 84 b3 00 00 00    	je     760 <printf+0x150>
  write(fd, &c, 1);
 6ad:	83 ec 04             	sub    $0x4,%esp
 6b0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6b4:	6a 01                	push   $0x1
 6b6:	57                   	push   %edi
 6b7:	ff 75 08             	pushl  0x8(%ebp)
 6ba:	e8 02 fe ff ff       	call   4c1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6bf:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6c2:	83 c4 0c             	add    $0xc,%esp
 6c5:	6a 01                	push   $0x1
 6c7:	83 c6 01             	add    $0x1,%esi
 6ca:	57                   	push   %edi
 6cb:	ff 75 08             	pushl  0x8(%ebp)
 6ce:	e8 ee fd ff ff       	call   4c1 <write>
  for(i = 0; fmt[i]; i++){
 6d3:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6d7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6da:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6dc:	84 db                	test   %bl,%bl
 6de:	75 8f                	jne    66f <printf+0x5f>
    }
  }
}
 6e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e3:	5b                   	pop    %ebx
 6e4:	5e                   	pop    %esi
 6e5:	5f                   	pop    %edi
 6e6:	5d                   	pop    %ebp
 6e7:	c3                   	ret    
 6e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ef:	90                   	nop
        printint(fd, *ap, 16, 0);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6f8:	6a 00                	push   $0x0
 6fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	8b 13                	mov    (%ebx),%edx
 702:	e8 49 fe ff ff       	call   550 <printint>
        ap++;
 707:	89 d8                	mov    %ebx,%eax
 709:	83 c4 10             	add    $0x10,%esp
      state = 0;
 70c:	31 d2                	xor    %edx,%edx
        ap++;
 70e:	83 c0 04             	add    $0x4,%eax
 711:	89 45 d0             	mov    %eax,-0x30(%ebp)
 714:	e9 4b ff ff ff       	jmp    664 <printf+0x54>
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
 728:	6a 01                	push   $0x1
 72a:	eb ce                	jmp    6fa <printf+0xea>
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 730:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 733:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 736:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 738:	6a 01                	push   $0x1
        ap++;
 73a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 73d:	57                   	push   %edi
 73e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 741:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 744:	e8 78 fd ff ff       	call   4c1 <write>
        ap++;
 749:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 74c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 74f:	31 d2                	xor    %edx,%edx
 751:	e9 0e ff ff ff       	jmp    664 <printf+0x54>
 756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 760:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 763:	83 ec 04             	sub    $0x4,%esp
 766:	e9 5a ff ff ff       	jmp    6c5 <printf+0xb5>
 76b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop
        s = (char*)*ap;
 770:	8b 45 d0             	mov    -0x30(%ebp),%eax
 773:	8b 18                	mov    (%eax),%ebx
        ap++;
 775:	83 c0 04             	add    $0x4,%eax
 778:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 77b:	85 db                	test   %ebx,%ebx
 77d:	74 17                	je     796 <printf+0x186>
        while(*s != 0){
 77f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 782:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 784:	84 c0                	test   %al,%al
 786:	0f 84 d8 fe ff ff    	je     664 <printf+0x54>
 78c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 78f:	89 de                	mov    %ebx,%esi
 791:	8b 5d 08             	mov    0x8(%ebp),%ebx
 794:	eb 1a                	jmp    7b0 <printf+0x1a0>
          s = "(null)";
 796:	bb d4 09 00 00       	mov    $0x9d4,%ebx
        while(*s != 0){
 79b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 79e:	b8 28 00 00 00       	mov    $0x28,%eax
 7a3:	89 de                	mov    %ebx,%esi
 7a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop
  write(fd, &c, 1);
 7b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7b3:	83 c6 01             	add    $0x1,%esi
 7b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7b9:	6a 01                	push   $0x1
 7bb:	57                   	push   %edi
 7bc:	53                   	push   %ebx
 7bd:	e8 ff fc ff ff       	call   4c1 <write>
        while(*s != 0){
 7c2:	0f b6 06             	movzbl (%esi),%eax
 7c5:	83 c4 10             	add    $0x10,%esp
 7c8:	84 c0                	test   %al,%al
 7ca:	75 e4                	jne    7b0 <printf+0x1a0>
 7cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7cf:	31 d2                	xor    %edx,%edx
 7d1:	e9 8e fe ff ff       	jmp    664 <printf+0x54>
 7d6:	66 90                	xchg   %ax,%ax
 7d8:	66 90                	xchg   %ax,%ax
 7da:	66 90                	xchg   %ax,%ax
 7dc:	66 90                	xchg   %ax,%ax
 7de:	66 90                	xchg   %ax,%ax

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 40 8d 00 00       	mov    0x8d40,%eax
{
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	57                   	push   %edi
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7ee:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7f0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f3:	39 c8                	cmp    %ecx,%eax
 7f5:	73 19                	jae    810 <free+0x30>
 7f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7fe:	66 90                	xchg   %ax,%ax
 800:	39 d1                	cmp    %edx,%ecx
 802:	72 14                	jb     818 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	39 d0                	cmp    %edx,%eax
 806:	73 10                	jae    818 <free+0x38>
{
 808:	89 d0                	mov    %edx,%eax
 80a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80c:	39 c8                	cmp    %ecx,%eax
 80e:	72 f0                	jb     800 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	39 d0                	cmp    %edx,%eax
 812:	72 f4                	jb     808 <free+0x28>
 814:	39 d1                	cmp    %edx,%ecx
 816:	73 f0                	jae    808 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 818:	8b 73 fc             	mov    -0x4(%ebx),%esi
 81b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 81e:	39 fa                	cmp    %edi,%edx
 820:	74 1e                	je     840 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 822:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 825:	8b 50 04             	mov    0x4(%eax),%edx
 828:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 82b:	39 f1                	cmp    %esi,%ecx
 82d:	74 28                	je     857 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 82f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 831:	5b                   	pop    %ebx
  freep = p;
 832:	a3 40 8d 00 00       	mov    %eax,0x8d40
}
 837:	5e                   	pop    %esi
 838:	5f                   	pop    %edi
 839:	5d                   	pop    %ebp
 83a:	c3                   	ret    
 83b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 83f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 840:	03 72 04             	add    0x4(%edx),%esi
 843:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 12                	mov    (%edx),%edx
 84a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 853:	39 f1                	cmp    %esi,%ecx
 855:	75 d8                	jne    82f <free+0x4f>
    p->s.size += bp->s.size;
 857:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 85a:	a3 40 8d 00 00       	mov    %eax,0x8d40
    p->s.size += bp->s.size;
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 53 f8             	mov    -0x8(%ebx),%edx
 865:	89 10                	mov    %edx,(%eax)
}
 867:	5b                   	pop    %ebx
 868:	5e                   	pop    %esi
 869:	5f                   	pop    %edi
 86a:	5d                   	pop    %ebp
 86b:	c3                   	ret    
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 87c:	8b 3d 40 8d 00 00    	mov    0x8d40,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	8d 70 07             	lea    0x7(%eax),%esi
 885:	c1 ee 03             	shr    $0x3,%esi
 888:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 88b:	85 ff                	test   %edi,%edi
 88d:	0f 84 ad 00 00 00    	je     940 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 895:	8b 4a 04             	mov    0x4(%edx),%ecx
 898:	39 f1                	cmp    %esi,%ecx
 89a:	73 72                	jae    90e <malloc+0x9e>
 89c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 8a2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8a7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8aa:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8b4:	eb 1b                	jmp    8d1 <malloc+0x61>
 8b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8c2:	8b 48 04             	mov    0x4(%eax),%ecx
 8c5:	39 f1                	cmp    %esi,%ecx
 8c7:	73 4f                	jae    918 <malloc+0xa8>
 8c9:	8b 3d 40 8d 00 00    	mov    0x8d40,%edi
 8cf:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d1:	39 d7                	cmp    %edx,%edi
 8d3:	75 eb                	jne    8c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8d5:	83 ec 0c             	sub    $0xc,%esp
 8d8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8db:	e8 49 fc ff ff       	call   529 <sbrk>
  if(p == (char*)-1)
 8e0:	83 c4 10             	add    $0x10,%esp
 8e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8e6:	74 1c                	je     904 <malloc+0x94>
  hp->s.size = nu;
 8e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8eb:	83 ec 0c             	sub    $0xc,%esp
 8ee:	83 c0 08             	add    $0x8,%eax
 8f1:	50                   	push   %eax
 8f2:	e8 e9 fe ff ff       	call   7e0 <free>
  return freep;
 8f7:	8b 15 40 8d 00 00    	mov    0x8d40,%edx
      if((p = morecore(nunits)) == 0)
 8fd:	83 c4 10             	add    $0x10,%esp
 900:	85 d2                	test   %edx,%edx
 902:	75 bc                	jne    8c0 <malloc+0x50>
        return 0;
  }
}
 904:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 907:	31 c0                	xor    %eax,%eax
}
 909:	5b                   	pop    %ebx
 90a:	5e                   	pop    %esi
 90b:	5f                   	pop    %edi
 90c:	5d                   	pop    %ebp
 90d:	c3                   	ret    
    if(p->s.size >= nunits){
 90e:	89 d0                	mov    %edx,%eax
 910:	89 fa                	mov    %edi,%edx
 912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 918:	39 ce                	cmp    %ecx,%esi
 91a:	74 54                	je     970 <malloc+0x100>
        p->s.size -= nunits;
 91c:	29 f1                	sub    %esi,%ecx
 91e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 921:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 924:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 927:	89 15 40 8d 00 00    	mov    %edx,0x8d40
}
 92d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 930:	83 c0 08             	add    $0x8,%eax
}
 933:	5b                   	pop    %ebx
 934:	5e                   	pop    %esi
 935:	5f                   	pop    %edi
 936:	5d                   	pop    %ebp
 937:	c3                   	ret    
 938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 940:	c7 05 40 8d 00 00 44 	movl   $0x8d44,0x8d40
 947:	8d 00 00 
    base.s.size = 0;
 94a:	bf 44 8d 00 00       	mov    $0x8d44,%edi
    base.s.ptr = freep = prevp = &base;
 94f:	c7 05 44 8d 00 00 44 	movl   $0x8d44,0x8d44
 956:	8d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 959:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 95b:	c7 05 48 8d 00 00 00 	movl   $0x0,0x8d48
 962:	00 00 00 
    if(p->s.size >= nunits){
 965:	e9 32 ff ff ff       	jmp    89c <malloc+0x2c>
 96a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 970:	8b 08                	mov    (%eax),%ecx
 972:	89 0a                	mov    %ecx,(%edx)
 974:	eb b1                	jmp    927 <malloc+0xb7>
