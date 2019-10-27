
_uthread:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    exit();
}


int
main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    thread_create(thread1);
    thread_create(blockthread);
    thread_create(thread2);
   f:	bb 03 00 00 00       	mov    $0x3,%ebx
    thread_create(thread1);
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 a0 00 00 00       	push   $0xa0
  1c:	e8 ff 00 00 00       	call   120 <thread_create>
    thread_create(blockthread);
  21:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
  28:	e8 f3 00 00 00       	call   120 <thread_create>
    thread_create(thread2);
  2d:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
  34:	e8 e7 00 00 00       	call   120 <thread_create>
  39:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < 3; i++) {
        printf(1, "%Finished: join(%d) \n", join());
  3c:	e8 b9 04 00 00       	call   4fa <join>
  41:	83 ec 04             	sub    $0x4,%esp
  44:	50                   	push   %eax
  45:	68 66 09 00 00       	push   $0x966
  4a:	6a 01                	push   $0x1
  4c:	e8 6f 05 00 00       	call   5c0 <printf>
    for (int i = 0; i < 3; i++) {
  51:	83 c4 10             	add    $0x10,%esp
  54:	83 eb 01             	sub    $0x1,%ebx
  57:	75 e3                	jne    3c <main+0x3c>
    }
    exit();
  59:	e8 f4 03 00 00       	call   452 <exit>
  5e:	66 90                	xchg   %ax,%ax

00000060 <blockthread>:
blockthread(void) {
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	eb fe                	jmp    63 <blockthread+0x3>
  65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000070 <thread2>:
thread2(void) {
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	83 ec 08             	sub    $0x8,%esp
    printf(1, "CPU: %d. my thread running\n", cpu());
  76:	e8 87 04 00 00       	call   502 <cpu>
  7b:	83 ec 04             	sub    $0x4,%esp
  7e:	50                   	push   %eax
  7f:	68 18 09 00 00       	push   $0x918
  84:	6a 01                	push   $0x1
  86:	e8 35 05 00 00       	call   5c0 <printf>
    printf(1, "my thread: exit\n");
  8b:	58                   	pop    %eax
  8c:	5a                   	pop    %edx
  8d:	68 34 09 00 00       	push   $0x934
  92:	6a 01                	push   $0x1
  94:	e8 27 05 00 00       	call   5c0 <printf>
    exit();
  99:	e8 b4 03 00 00       	call   452 <exit>
  9e:	66 90                	xchg   %ax,%ax

000000a0 <thread1>:
thread1(void) {
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
    printf(1, "CPU: %d. my thread running\n", cpu());
  a4:	bb 19 00 00 00       	mov    $0x19,%ebx
thread1(void) {
  a9:	83 ec 04             	sub    $0x4,%esp
    printf(1, "CPU: %d. my thread running\n", cpu());
  ac:	e8 51 04 00 00       	call   502 <cpu>
  b1:	83 ec 04             	sub    $0x4,%esp
  b4:	50                   	push   %eax
  b5:	68 18 09 00 00       	push   $0x918
  ba:	6a 01                	push   $0x1
  bc:	e8 ff 04 00 00       	call   5c0 <printf>
  c1:	83 c4 10             	add    $0x10,%esp
  c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "my thread 0x%x\n", (int) current_thread);
  c8:	83 ec 04             	sub    $0x4,%esp
  cb:	ff 35 4c 8d 00 00    	pushl  0x8d4c
  d1:	68 45 09 00 00       	push   $0x945
  d6:	6a 01                	push   $0x1
  d8:	e8 e3 04 00 00       	call   5c0 <printf>
    for (i = 0; i < 25; i++) {
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	83 eb 01             	sub    $0x1,%ebx
  e3:	75 e3                	jne    c8 <thread1+0x28>
    printf(1, "my thread: exit\n");
  e5:	83 ec 08             	sub    $0x8,%esp
  e8:	68 34 09 00 00       	push   $0x934
  ed:	6a 01                	push   $0x1
  ef:	e8 cc 04 00 00       	call   5c0 <printf>
    exit();
  f4:	e8 59 03 00 00       	call   452 <exit>
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000100 <thread_init>:
thread_init(void) {
 100:	55                   	push   %ebp
    current_thread = &all_thread[0];
 101:	c7 05 4c 8d 00 00 20 	movl   $0xd20,0x8d4c
 108:	0d 00 00 
    current_thread->state = RUNNING;
 10b:	c7 05 24 2d 00 00 01 	movl   $0x1,0x2d24
 112:	00 00 00 
thread_init(void) {
 115:	89 e5                	mov    %esp,%ebp
}
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000120 <thread_create>:
thread_create(void (*func)()) {
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	81 ec 0c 20 00 00    	sub    $0x200c,%esp
 129:	8b 45 08             	mov    0x8(%ebp),%eax
    printf(1, "func address %x\n", func);
 12c:	50                   	push   %eax
 12d:	68 55 09 00 00       	push   $0x955
 132:	6a 01                	push   $0x1
    *((int *) stack) = (int) func;           // push return address on stack
 134:	89 85 f8 df ff ff    	mov    %eax,-0x2008(%ebp)
    printf(1, "func address %x\n", func);
 13a:	e8 81 04 00 00       	call   5c0 <printf>
    clone((void *) stack, STACK_SIZE);
 13f:	58                   	pop    %eax
 140:	8d 85 f8 df ff ff    	lea    -0x2008(%ebp),%eax
 146:	5a                   	pop    %edx
 147:	68 00 20 00 00       	push   $0x2000
 14c:	50                   	push   %eax
 14d:	e8 a0 03 00 00       	call   4f2 <clone>
}
 152:	83 c4 10             	add    $0x10,%esp
 155:	c9                   	leave  
 156:	c3                   	ret    
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <thread_yield>:
    current_thread->state = RUNNABLE;
 160:	8b 15 4c 8d 00 00    	mov    0x8d4c,%edx
    for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 166:	b8 20 0d 00 00       	mov    $0xd20,%eax
    current_thread->state = RUNNABLE;
 16b:	c7 82 04 20 00 00 02 	movl   $0x2,0x2004(%edx)
 172:	00 00 00 
        if (t->state == RUNNABLE && t != current_thread) {
 175:	83 b8 04 20 00 00 02 	cmpl   $0x2,0x2004(%eax)
 17c:	75 04                	jne    182 <thread_yield+0x22>
 17e:	39 c2                	cmp    %eax,%edx
 180:	75 1e                	jne    1a0 <thread_yield+0x40>
    for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 182:	05 08 20 00 00       	add    $0x2008,%eax
 187:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
 18c:	75 e7                	jne    175 <thread_yield+0x15>
        next_thread = 0;
 18e:	c7 05 50 8d 00 00 00 	movl   $0x0,0x8d50
 195:	00 00 00 
 198:	c3                   	ret    
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 1a0:	3d 40 8d 00 00       	cmp    $0x8d40,%eax
            next_thread = t;
 1a5:	a3 50 8d 00 00       	mov    %eax,0x8d50
    if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
 1aa:	73 e2                	jae    18e <thread_yield+0x2e>
    if (next_thread == 0) {
 1ac:	85 c0                	test   %eax,%eax
 1ae:	74 0f                	je     1bf <thread_yield+0x5f>
        next_thread->state = RUNNING;
 1b0:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
 1b7:	00 00 00 
        thread_switch();
 1ba:	e9 17 00 00 00       	jmp    1d6 <thread_switch>
thread_yield(void) {
 1bf:	55                   	push   %ebp
 1c0:	89 e5                	mov    %esp,%ebp
 1c2:	83 ec 10             	sub    $0x10,%esp
        printf(2, "thread_schedule: no runnable threads\n");
 1c5:	68 7c 09 00 00       	push   $0x97c
 1ca:	6a 02                	push   $0x2
 1cc:	e8 ef 03 00 00       	call   5c0 <printf>
        exit();
 1d1:	e8 7c 02 00 00       	call   452 <exit>

000001d6 <thread_switch>:
 * Use eax as a temporary register; it is caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
  pushal                        /* push e{abcd}x, e{sb}p, e{sd}i */
 1d6:	60                   	pusha  
  movl current_thread, %eax
 1d7:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
  movl %esp, (%eax)               /* save sp in current_thread->sp */
 1dc:	89 20                	mov    %esp,(%eax)
  movl next_thread, %eax
 1de:	a1 50 8d 00 00       	mov    0x8d50,%eax
  movl %eax, current_thread
 1e3:	a3 4c 8d 00 00       	mov    %eax,0x8d4c
  movl $0, next_thread
 1e8:	c7 05 50 8d 00 00 00 	movl   $0x0,0x8d50
 1ef:	00 00 00 
  movl current_thread, %eax
 1f2:	a1 4c 8d 00 00       	mov    0x8d4c,%eax
  movl (%eax), %esp
 1f7:	8b 20                	mov    (%eax),%esp
  popal
 1f9:	61                   	popa   
	ret				/* pop return address from stack */
 1fa:	c3                   	ret    
 1fb:	66 90                	xchg   %ax,%ax
 1fd:	66 90                	xchg   %ax,%ax
 1ff:	90                   	nop

00000200 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20a:	89 c2                	mov    %eax,%edx
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 210:	83 c1 01             	add    $0x1,%ecx
 213:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 217:	83 c2 01             	add    $0x1,%edx
 21a:	84 db                	test   %bl,%bl
 21c:	88 5a ff             	mov    %bl,-0x1(%edx)
 21f:	75 ef                	jne    210 <strcpy+0x10>
    ;
  return os;
}
 221:	5b                   	pop    %ebx
 222:	5d                   	pop    %ebp
 223:	c3                   	ret    
 224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 22a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 55 08             	mov    0x8(%ebp),%edx
 237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 23a:	0f b6 02             	movzbl (%edx),%eax
 23d:	0f b6 19             	movzbl (%ecx),%ebx
 240:	84 c0                	test   %al,%al
 242:	75 1c                	jne    260 <strcmp+0x30>
 244:	eb 2a                	jmp    270 <strcmp+0x40>
 246:	8d 76 00             	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 250:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 253:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 256:	83 c1 01             	add    $0x1,%ecx
 259:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 25c:	84 c0                	test   %al,%al
 25e:	74 10                	je     270 <strcmp+0x40>
 260:	38 d8                	cmp    %bl,%al
 262:	74 ec                	je     250 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 264:	29 d8                	sub    %ebx,%eax
}
 266:	5b                   	pop    %ebx
 267:	5d                   	pop    %ebp
 268:	c3                   	ret    
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 270:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 272:	29 d8                	sub    %ebx,%eax
}
 274:	5b                   	pop    %ebx
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	89 f6                	mov    %esi,%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <strlen>:

uint
strlen(char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 286:	80 39 00             	cmpb   $0x0,(%ecx)
 289:	74 15                	je     2a0 <strlen+0x20>
 28b:	31 d2                	xor    %edx,%edx
 28d:	8d 76 00             	lea    0x0(%esi),%esi
 290:	83 c2 01             	add    $0x1,%edx
 293:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 297:	89 d0                	mov    %edx,%eax
 299:	75 f5                	jne    290 <strlen+0x10>
    ;
  return n;
}
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2a0:	31 c0                	xor    %eax,%eax
}
 2a2:	5d                   	pop    %ebp
 2a3:	c3                   	ret    
 2a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 d7                	mov    %edx,%edi
 2bf:	fc                   	cld    
 2c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2c2:	89 d0                	mov    %edx,%eax
 2c4:	5f                   	pop    %edi
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    
 2c7:	89 f6                	mov    %esi,%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <strchr>:

char*
strchr(const char *s, char c)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2da:	0f b6 10             	movzbl (%eax),%edx
 2dd:	84 d2                	test   %dl,%dl
 2df:	74 1d                	je     2fe <strchr+0x2e>
    if(*s == c)
 2e1:	38 d3                	cmp    %dl,%bl
 2e3:	89 d9                	mov    %ebx,%ecx
 2e5:	75 0d                	jne    2f4 <strchr+0x24>
 2e7:	eb 17                	jmp    300 <strchr+0x30>
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2f0:	38 ca                	cmp    %cl,%dl
 2f2:	74 0c                	je     300 <strchr+0x30>
  for(; *s; s++)
 2f4:	83 c0 01             	add    $0x1,%eax
 2f7:	0f b6 10             	movzbl (%eax),%edx
 2fa:	84 d2                	test   %dl,%dl
 2fc:	75 f2                	jne    2f0 <strchr+0x20>
      return (char*)s;
  return 0;
 2fe:	31 c0                	xor    %eax,%eax
}
 300:	5b                   	pop    %ebx
 301:	5d                   	pop    %ebp
 302:	c3                   	ret    
 303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <gets>:

char*
gets(char *buf, int max)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 316:	31 f6                	xor    %esi,%esi
 318:	89 f3                	mov    %esi,%ebx
{
 31a:	83 ec 1c             	sub    $0x1c,%esp
 31d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 320:	eb 2f                	jmp    351 <gets+0x41>
 322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 328:	8d 45 e7             	lea    -0x19(%ebp),%eax
 32b:	83 ec 04             	sub    $0x4,%esp
 32e:	6a 01                	push   $0x1
 330:	50                   	push   %eax
 331:	6a 00                	push   $0x0
 333:	e8 32 01 00 00       	call   46a <read>
    if(cc < 1)
 338:	83 c4 10             	add    $0x10,%esp
 33b:	85 c0                	test   %eax,%eax
 33d:	7e 1c                	jle    35b <gets+0x4b>
      break;
    buf[i++] = c;
 33f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 343:	83 c7 01             	add    $0x1,%edi
 346:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 349:	3c 0a                	cmp    $0xa,%al
 34b:	74 23                	je     370 <gets+0x60>
 34d:	3c 0d                	cmp    $0xd,%al
 34f:	74 1f                	je     370 <gets+0x60>
  for(i=0; i+1 < max; ){
 351:	83 c3 01             	add    $0x1,%ebx
 354:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 357:	89 fe                	mov    %edi,%esi
 359:	7c cd                	jl     328 <gets+0x18>
 35b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 360:	c6 03 00             	movb   $0x0,(%ebx)
}
 363:	8d 65 f4             	lea    -0xc(%ebp),%esp
 366:	5b                   	pop    %ebx
 367:	5e                   	pop    %esi
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    
 36b:	90                   	nop
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 370:	8b 75 08             	mov    0x8(%ebp),%esi
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	01 de                	add    %ebx,%esi
 378:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 37a:	c6 03 00             	movb   $0x0,(%ebx)
}
 37d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 380:	5b                   	pop    %ebx
 381:	5e                   	pop    %esi
 382:	5f                   	pop    %edi
 383:	5d                   	pop    %ebp
 384:	c3                   	ret    
 385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <stat>:

int
stat(char *n, struct stat *st)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 395:	83 ec 08             	sub    $0x8,%esp
 398:	6a 00                	push   $0x0
 39a:	ff 75 08             	pushl  0x8(%ebp)
 39d:	e8 f0 00 00 00       	call   492 <open>
  if(fd < 0)
 3a2:	83 c4 10             	add    $0x10,%esp
 3a5:	85 c0                	test   %eax,%eax
 3a7:	78 27                	js     3d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3a9:	83 ec 08             	sub    $0x8,%esp
 3ac:	ff 75 0c             	pushl  0xc(%ebp)
 3af:	89 c3                	mov    %eax,%ebx
 3b1:	50                   	push   %eax
 3b2:	e8 f3 00 00 00       	call   4aa <fstat>
  close(fd);
 3b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ba:	89 c6                	mov    %eax,%esi
  close(fd);
 3bc:	e8 b9 00 00 00       	call   47a <close>
  return r;
 3c1:	83 c4 10             	add    $0x10,%esp
}
 3c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3c7:	89 f0                	mov    %esi,%eax
 3c9:	5b                   	pop    %ebx
 3ca:	5e                   	pop    %esi
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3d5:	eb ed                	jmp    3c4 <stat+0x34>
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <atoi>:

int
atoi(const char *s)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e7:	0f be 11             	movsbl (%ecx),%edx
 3ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 3ed:	3c 09                	cmp    $0x9,%al
  n = 0;
 3ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 3f4:	77 1f                	ja     415 <atoi+0x35>
 3f6:	8d 76 00             	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 400:	8d 04 80             	lea    (%eax,%eax,4),%eax
 403:	83 c1 01             	add    $0x1,%ecx
 406:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 40a:	0f be 11             	movsbl (%ecx),%edx
 40d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 410:	80 fb 09             	cmp    $0x9,%bl
 413:	76 eb                	jbe    400 <atoi+0x20>
  return n;
}
 415:	5b                   	pop    %ebx
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    
 418:	90                   	nop
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
 425:	8b 5d 10             	mov    0x10(%ebp),%ebx
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 42e:	85 db                	test   %ebx,%ebx
 430:	7e 14                	jle    446 <memmove+0x26>
 432:	31 d2                	xor    %edx,%edx
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 438:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 43c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 43f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 442:	39 d3                	cmp    %edx,%ebx
 444:	75 f2                	jne    438 <memmove+0x18>
  return vdst;
}
 446:	5b                   	pop    %ebx
 447:	5e                   	pop    %esi
 448:	5d                   	pop    %ebp
 449:	c3                   	ret    

0000044a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44a:	b8 01 00 00 00       	mov    $0x1,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <exit>:
SYSCALL(exit)
 452:	b8 02 00 00 00       	mov    $0x2,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <wait>:
SYSCALL(wait)
 45a:	b8 03 00 00 00       	mov    $0x3,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <pipe>:
SYSCALL(pipe)
 462:	b8 04 00 00 00       	mov    $0x4,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <read>:
SYSCALL(read)
 46a:	b8 05 00 00 00       	mov    $0x5,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <write>:
SYSCALL(write)
 472:	b8 10 00 00 00       	mov    $0x10,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <close>:
SYSCALL(close)
 47a:	b8 15 00 00 00       	mov    $0x15,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <kill>:
SYSCALL(kill)
 482:	b8 06 00 00 00       	mov    $0x6,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <exec>:
SYSCALL(exec)
 48a:	b8 07 00 00 00       	mov    $0x7,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <open>:
SYSCALL(open)
 492:	b8 0f 00 00 00       	mov    $0xf,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mknod>:
SYSCALL(mknod)
 49a:	b8 11 00 00 00       	mov    $0x11,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <unlink>:
SYSCALL(unlink)
 4a2:	b8 12 00 00 00       	mov    $0x12,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <fstat>:
SYSCALL(fstat)
 4aa:	b8 08 00 00 00       	mov    $0x8,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <link>:
SYSCALL(link)
 4b2:	b8 13 00 00 00       	mov    $0x13,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <mkdir>:
SYSCALL(mkdir)
 4ba:	b8 14 00 00 00       	mov    $0x14,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <chdir>:
SYSCALL(chdir)
 4c2:	b8 09 00 00 00       	mov    $0x9,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <dup>:
SYSCALL(dup)
 4ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <getpid>:
SYSCALL(getpid)
 4d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <sbrk>:
SYSCALL(sbrk)
 4da:	b8 0c 00 00 00       	mov    $0xc,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <sleep>:
SYSCALL(sleep)
 4e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <uptime>:
SYSCALL(uptime)
 4ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <clone>:
SYSCALL(clone)
 4f2:	b8 16 00 00 00       	mov    $0x16,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <join>:
SYSCALL(join)
 4fa:	b8 17 00 00 00       	mov    $0x17,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <cpu>:
SYSCALL(cpu)
 502:	b8 18 00 00 00       	mov    $0x18,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <setscheduler>:
SYSCALL(setscheduler)
 50a:	b8 19 00 00 00       	mov    $0x19,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    
 512:	66 90                	xchg   %ax,%ax
 514:	66 90                	xchg   %ax,%ax
 516:	66 90                	xchg   %ax,%ax
 518:	66 90                	xchg   %ax,%ax
 51a:	66 90                	xchg   %ax,%ax
 51c:	66 90                	xchg   %ax,%ax
 51e:	66 90                	xchg   %ax,%ax

00000520 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 529:	85 d2                	test   %edx,%edx
{
 52b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 52e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 530:	79 76                	jns    5a8 <printint+0x88>
 532:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 536:	74 70                	je     5a8 <printint+0x88>
    x = -xx;
 538:	f7 d8                	neg    %eax
    neg = 1;
 53a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 541:	31 f6                	xor    %esi,%esi
 543:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 546:	eb 0a                	jmp    552 <printint+0x32>
 548:	90                   	nop
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 550:	89 fe                	mov    %edi,%esi
 552:	31 d2                	xor    %edx,%edx
 554:	8d 7e 01             	lea    0x1(%esi),%edi
 557:	f7 f1                	div    %ecx
 559:	0f b6 92 ac 09 00 00 	movzbl 0x9ac(%edx),%edx
  }while((x /= base) != 0);
 560:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 562:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 565:	75 e9                	jne    550 <printint+0x30>
  if(neg)
 567:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 56a:	85 c0                	test   %eax,%eax
 56c:	74 08                	je     576 <printint+0x56>
    buf[i++] = '-';
 56e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 573:	8d 7e 02             	lea    0x2(%esi),%edi
 576:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 57a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
 580:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 583:	83 ec 04             	sub    $0x4,%esp
 586:	83 ee 01             	sub    $0x1,%esi
 589:	6a 01                	push   $0x1
 58b:	53                   	push   %ebx
 58c:	57                   	push   %edi
 58d:	88 45 d7             	mov    %al,-0x29(%ebp)
 590:	e8 dd fe ff ff       	call   472 <write>

  while(--i >= 0)
 595:	83 c4 10             	add    $0x10,%esp
 598:	39 de                	cmp    %ebx,%esi
 59a:	75 e4                	jne    580 <printint+0x60>
    putc(fd, buf[i]);
}
 59c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59f:	5b                   	pop    %ebx
 5a0:	5e                   	pop    %esi
 5a1:	5f                   	pop    %edi
 5a2:	5d                   	pop    %ebp
 5a3:	c3                   	ret    
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5a8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5af:	eb 90                	jmp    541 <printint+0x21>
 5b1:	eb 0d                	jmp    5c0 <printf>
 5b3:	90                   	nop
 5b4:	90                   	nop
 5b5:	90                   	nop
 5b6:	90                   	nop
 5b7:	90                   	nop
 5b8:	90                   	nop
 5b9:	90                   	nop
 5ba:	90                   	nop
 5bb:	90                   	nop
 5bc:	90                   	nop
 5bd:	90                   	nop
 5be:	90                   	nop
 5bf:	90                   	nop

000005c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5cc:	0f b6 1e             	movzbl (%esi),%ebx
 5cf:	84 db                	test   %bl,%bl
 5d1:	0f 84 b3 00 00 00    	je     68a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 5d7:	8d 45 10             	lea    0x10(%ebp),%eax
 5da:	83 c6 01             	add    $0x1,%esi
  state = 0;
 5dd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 5df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5e2:	eb 2f                	jmp    613 <printf+0x53>
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5e8:	83 f8 25             	cmp    $0x25,%eax
 5eb:	0f 84 a7 00 00 00    	je     698 <printf+0xd8>
  write(fd, &c, 1);
 5f1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5f4:	83 ec 04             	sub    $0x4,%esp
 5f7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5fa:	6a 01                	push   $0x1
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 6d fe ff ff       	call   472 <write>
 605:	83 c4 10             	add    $0x10,%esp
 608:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 60b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 60f:	84 db                	test   %bl,%bl
 611:	74 77                	je     68a <printf+0xca>
    if(state == 0){
 613:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 615:	0f be cb             	movsbl %bl,%ecx
 618:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 61b:	74 cb                	je     5e8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 61d:	83 ff 25             	cmp    $0x25,%edi
 620:	75 e6                	jne    608 <printf+0x48>
      if(c == 'd'){
 622:	83 f8 64             	cmp    $0x64,%eax
 625:	0f 84 05 01 00 00    	je     730 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 62b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 631:	83 f9 70             	cmp    $0x70,%ecx
 634:	74 72                	je     6a8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 636:	83 f8 73             	cmp    $0x73,%eax
 639:	0f 84 99 00 00 00    	je     6d8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63f:	83 f8 63             	cmp    $0x63,%eax
 642:	0f 84 08 01 00 00    	je     750 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 648:	83 f8 25             	cmp    $0x25,%eax
 64b:	0f 84 ef 00 00 00    	je     740 <printf+0x180>
  write(fd, &c, 1);
 651:	8d 45 e7             	lea    -0x19(%ebp),%eax
 654:	83 ec 04             	sub    $0x4,%esp
 657:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 65b:	6a 01                	push   $0x1
 65d:	50                   	push   %eax
 65e:	ff 75 08             	pushl  0x8(%ebp)
 661:	e8 0c fe ff ff       	call   472 <write>
 666:	83 c4 0c             	add    $0xc,%esp
 669:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 66c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 66f:	6a 01                	push   $0x1
 671:	50                   	push   %eax
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 678:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 67a:	e8 f3 fd ff ff       	call   472 <write>
  for(i = 0; fmt[i]; i++){
 67f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 683:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 686:	84 db                	test   %bl,%bl
 688:	75 89                	jne    613 <printf+0x53>
    }
  }
}
 68a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68d:	5b                   	pop    %ebx
 68e:	5e                   	pop    %esi
 68f:	5f                   	pop    %edi
 690:	5d                   	pop    %ebp
 691:	c3                   	ret    
 692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 698:	bf 25 00 00 00       	mov    $0x25,%edi
 69d:	e9 66 ff ff ff       	jmp    608 <printf+0x48>
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6a8:	83 ec 0c             	sub    $0xc,%esp
 6ab:	b9 10 00 00 00       	mov    $0x10,%ecx
 6b0:	6a 00                	push   $0x0
 6b2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6b5:	8b 45 08             	mov    0x8(%ebp),%eax
 6b8:	8b 17                	mov    (%edi),%edx
 6ba:	e8 61 fe ff ff       	call   520 <printint>
        ap++;
 6bf:	89 f8                	mov    %edi,%eax
 6c1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6c4:	31 ff                	xor    %edi,%edi
        ap++;
 6c6:	83 c0 04             	add    $0x4,%eax
 6c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6cc:	e9 37 ff ff ff       	jmp    608 <printf+0x48>
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6db:	8b 08                	mov    (%eax),%ecx
        ap++;
 6dd:	83 c0 04             	add    $0x4,%eax
 6e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 6e3:	85 c9                	test   %ecx,%ecx
 6e5:	0f 84 8e 00 00 00    	je     779 <printf+0x1b9>
        while(*s != 0){
 6eb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 6ee:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 6f0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 6f2:	84 c0                	test   %al,%al
 6f4:	0f 84 0e ff ff ff    	je     608 <printf+0x48>
 6fa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6fd:	89 de                	mov    %ebx,%esi
 6ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
 702:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 705:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 708:	83 ec 04             	sub    $0x4,%esp
          s++;
 70b:	83 c6 01             	add    $0x1,%esi
 70e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 711:	6a 01                	push   $0x1
 713:	57                   	push   %edi
 714:	53                   	push   %ebx
 715:	e8 58 fd ff ff       	call   472 <write>
        while(*s != 0){
 71a:	0f b6 06             	movzbl (%esi),%eax
 71d:	83 c4 10             	add    $0x10,%esp
 720:	84 c0                	test   %al,%al
 722:	75 e4                	jne    708 <printf+0x148>
 724:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 727:	31 ff                	xor    %edi,%edi
 729:	e9 da fe ff ff       	jmp    608 <printf+0x48>
 72e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 730:	83 ec 0c             	sub    $0xc,%esp
 733:	b9 0a 00 00 00       	mov    $0xa,%ecx
 738:	6a 01                	push   $0x1
 73a:	e9 73 ff ff ff       	jmp    6b2 <printf+0xf2>
 73f:	90                   	nop
  write(fd, &c, 1);
 740:	83 ec 04             	sub    $0x4,%esp
 743:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 746:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 749:	6a 01                	push   $0x1
 74b:	e9 21 ff ff ff       	jmp    671 <printf+0xb1>
        putc(fd, *ap);
 750:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 753:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 756:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 758:	6a 01                	push   $0x1
        ap++;
 75a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 75d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 760:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 763:	50                   	push   %eax
 764:	ff 75 08             	pushl  0x8(%ebp)
 767:	e8 06 fd ff ff       	call   472 <write>
        ap++;
 76c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 76f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 772:	31 ff                	xor    %edi,%edi
 774:	e9 8f fe ff ff       	jmp    608 <printf+0x48>
          s = "(null)";
 779:	bb a4 09 00 00       	mov    $0x9a4,%ebx
        while(*s != 0){
 77e:	b8 28 00 00 00       	mov    $0x28,%eax
 783:	e9 72 ff ff ff       	jmp    6fa <printf+0x13a>
 788:	66 90                	xchg   %ax,%ax
 78a:	66 90                	xchg   %ax,%ax
 78c:	66 90                	xchg   %ax,%ax
 78e:	66 90                	xchg   %ax,%ax

00000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 791:	a1 40 8d 00 00       	mov    0x8d40,%eax
{
 796:	89 e5                	mov    %esp,%ebp
 798:	57                   	push   %edi
 799:	56                   	push   %esi
 79a:	53                   	push   %ebx
 79b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 79e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	39 c8                	cmp    %ecx,%eax
 7aa:	8b 10                	mov    (%eax),%edx
 7ac:	73 32                	jae    7e0 <free+0x50>
 7ae:	39 d1                	cmp    %edx,%ecx
 7b0:	72 04                	jb     7b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	39 d0                	cmp    %edx,%eax
 7b4:	72 32                	jb     7e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7bc:	39 fa                	cmp    %edi,%edx
 7be:	74 30                	je     7f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7c3:	8b 50 04             	mov    0x4(%eax),%edx
 7c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c9:	39 f1                	cmp    %esi,%ecx
 7cb:	74 3a                	je     807 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7cd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7cf:	a3 40 8d 00 00       	mov    %eax,0x8d40
}
 7d4:	5b                   	pop    %ebx
 7d5:	5e                   	pop    %esi
 7d6:	5f                   	pop    %edi
 7d7:	5d                   	pop    %ebp
 7d8:	c3                   	ret    
 7d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	39 d0                	cmp    %edx,%eax
 7e2:	72 04                	jb     7e8 <free+0x58>
 7e4:	39 d1                	cmp    %edx,%ecx
 7e6:	72 ce                	jb     7b6 <free+0x26>
{
 7e8:	89 d0                	mov    %edx,%eax
 7ea:	eb bc                	jmp    7a8 <free+0x18>
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7f0:	03 72 04             	add    0x4(%edx),%esi
 7f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 12                	mov    (%edx),%edx
 7fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7fd:	8b 50 04             	mov    0x4(%eax),%edx
 800:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 803:	39 f1                	cmp    %esi,%ecx
 805:	75 c6                	jne    7cd <free+0x3d>
    p->s.size += bp->s.size;
 807:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 80a:	a3 40 8d 00 00       	mov    %eax,0x8d40
    p->s.size += bp->s.size;
 80f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 812:	8b 53 f8             	mov    -0x8(%ebx),%edx
 815:	89 10                	mov    %edx,(%eax)
}
 817:	5b                   	pop    %ebx
 818:	5e                   	pop    %esi
 819:	5f                   	pop    %edi
 81a:	5d                   	pop    %ebp
 81b:	c3                   	ret    
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
 826:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 829:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 82c:	8b 15 40 8d 00 00    	mov    0x8d40,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	8d 78 07             	lea    0x7(%eax),%edi
 835:	c1 ef 03             	shr    $0x3,%edi
 838:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 83b:	85 d2                	test   %edx,%edx
 83d:	0f 84 9d 00 00 00    	je     8e0 <malloc+0xc0>
 843:	8b 02                	mov    (%edx),%eax
 845:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 848:	39 cf                	cmp    %ecx,%edi
 84a:	76 6c                	jbe    8b8 <malloc+0x98>
 84c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 852:	bb 00 10 00 00       	mov    $0x1000,%ebx
 857:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 85a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 861:	eb 0e                	jmp    871 <malloc+0x51>
 863:	90                   	nop
 864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 86a:	8b 48 04             	mov    0x4(%eax),%ecx
 86d:	39 f9                	cmp    %edi,%ecx
 86f:	73 47                	jae    8b8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 871:	39 05 40 8d 00 00    	cmp    %eax,0x8d40
 877:	89 c2                	mov    %eax,%edx
 879:	75 ed                	jne    868 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 87b:	83 ec 0c             	sub    $0xc,%esp
 87e:	56                   	push   %esi
 87f:	e8 56 fc ff ff       	call   4da <sbrk>
  if(p == (char*)-1)
 884:	83 c4 10             	add    $0x10,%esp
 887:	83 f8 ff             	cmp    $0xffffffff,%eax
 88a:	74 1c                	je     8a8 <malloc+0x88>
  hp->s.size = nu;
 88c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 88f:	83 ec 0c             	sub    $0xc,%esp
 892:	83 c0 08             	add    $0x8,%eax
 895:	50                   	push   %eax
 896:	e8 f5 fe ff ff       	call   790 <free>
  return freep;
 89b:	8b 15 40 8d 00 00    	mov    0x8d40,%edx
      if((p = morecore(nunits)) == 0)
 8a1:	83 c4 10             	add    $0x10,%esp
 8a4:	85 d2                	test   %edx,%edx
 8a6:	75 c0                	jne    868 <malloc+0x48>
        return 0;
  }
}
 8a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8ab:	31 c0                	xor    %eax,%eax
}
 8ad:	5b                   	pop    %ebx
 8ae:	5e                   	pop    %esi
 8af:	5f                   	pop    %edi
 8b0:	5d                   	pop    %ebp
 8b1:	c3                   	ret    
 8b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8b8:	39 cf                	cmp    %ecx,%edi
 8ba:	74 54                	je     910 <malloc+0xf0>
        p->s.size -= nunits;
 8bc:	29 f9                	sub    %edi,%ecx
 8be:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8c1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8c4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8c7:	89 15 40 8d 00 00    	mov    %edx,0x8d40
}
 8cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8d0:	83 c0 08             	add    $0x8,%eax
}
 8d3:	5b                   	pop    %ebx
 8d4:	5e                   	pop    %esi
 8d5:	5f                   	pop    %edi
 8d6:	5d                   	pop    %ebp
 8d7:	c3                   	ret    
 8d8:	90                   	nop
 8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 8e0:	c7 05 40 8d 00 00 44 	movl   $0x8d44,0x8d40
 8e7:	8d 00 00 
 8ea:	c7 05 44 8d 00 00 44 	movl   $0x8d44,0x8d44
 8f1:	8d 00 00 
    base.s.size = 0;
 8f4:	b8 44 8d 00 00       	mov    $0x8d44,%eax
 8f9:	c7 05 48 8d 00 00 00 	movl   $0x0,0x8d48
 900:	00 00 00 
 903:	e9 44 ff ff ff       	jmp    84c <malloc+0x2c>
 908:	90                   	nop
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 910:	8b 08                	mov    (%eax),%ecx
 912:	89 0a                	mov    %ecx,(%edx)
 914:	eb b1                	jmp    8c7 <malloc+0xa7>
