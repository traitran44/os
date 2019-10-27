
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 2f 10 80       	mov    $0x80102f40,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80100046:	68 e0 74 10 80       	push   $0x801074e0
8010004b:	68 e0 b5 10 80       	push   $0x8010b5e0
80100050:	e8 1b 48 00 00       	call   80104870 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100055:	c7 05 f0 f4 10 80 e4 	movl   $0x8010f4e4,0x8010f4f0
8010005c:	f4 10 80 
  bcache.head.next = &bcache.head;
8010005f:	c7 05 f4 f4 10 80 e4 	movl   $0x8010f4e4,0x8010f4f4
80100066:	f4 10 80 
80100069:	83 c4 10             	add    $0x10,%esp
8010006c:	b9 e4 f4 10 80       	mov    $0x8010f4e4,%ecx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100071:	b8 14 b6 10 80       	mov    $0x8010b614,%eax
80100076:	eb 0a                	jmp    80100082 <binit+0x42>
80100078:	90                   	nop
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d0                	mov    %edx,%eax
    b->next = bcache.head.next;
80100082:	89 48 10             	mov    %ecx,0x10(%eax)
    b->prev = &bcache.head;
80100085:	c7 40 0c e4 f4 10 80 	movl   $0x8010f4e4,0xc(%eax)
8010008c:	89 c1                	mov    %eax,%ecx
    b->dev = -1;
8010008e:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
80100095:	8b 15 f4 f4 10 80    	mov    0x8010f4f4,%edx
8010009b:	89 42 0c             	mov    %eax,0xc(%edx)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	8d 90 18 02 00 00    	lea    0x218(%eax),%edx
    bcache.head.next = b;
801000a4:	a3 f4 f4 10 80       	mov    %eax,0x8010f4f4
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	81 fa e4 f4 10 80    	cmp    $0x8010f4e4,%edx
801000af:	72 cf                	jb     80100080 <binit+0x40>
  }
}
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    
801000b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801000b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000c0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	57                   	push   %edi
801000c4:	56                   	push   %esi
801000c5:	53                   	push   %ebx
801000c6:	83 ec 18             	sub    $0x18,%esp
801000c9:	8b 75 08             	mov    0x8(%ebp),%esi
801000cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000cf:	68 e0 b5 10 80       	push   $0x8010b5e0
801000d4:	e8 b7 47 00 00       	call   80104890 <acquire>
801000d9:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000dc:	8b 1d f4 f4 10 80    	mov    0x8010f4f4,%ebx
801000e2:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
801000e8:	75 11                	jne    801000fb <bread+0x3b>
801000ea:	eb 34                	jmp    80100120 <bread+0x60>
801000ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000f0:	8b 5b 10             	mov    0x10(%ebx),%ebx
801000f3:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
801000f9:	74 25                	je     80100120 <bread+0x60>
    if(b->dev == dev && b->blockno == blockno){
801000fb:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fe:	75 f0                	jne    801000f0 <bread+0x30>
80100100:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100103:	75 eb                	jne    801000f0 <bread+0x30>
      if(!(b->flags & B_BUSY)){
80100105:	8b 03                	mov    (%ebx),%eax
80100107:	a8 01                	test   $0x1,%al
80100109:	74 6c                	je     80100177 <bread+0xb7>
      sleep(b, &bcache.lock);
8010010b:	83 ec 08             	sub    $0x8,%esp
8010010e:	68 e0 b5 10 80       	push   $0x8010b5e0
80100113:	53                   	push   %ebx
80100114:	e8 77 3d 00 00       	call   80103e90 <sleep>
80100119:	83 c4 10             	add    $0x10,%esp
8010011c:	eb be                	jmp    801000dc <bread+0x1c>
8010011e:	66 90                	xchg   %ax,%ax
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d f0 f4 10 80    	mov    0x8010f4f0,%ebx
80100126:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x7b>
8010012e:	eb 5e                	jmp    8010018e <bread+0xce>
80100130:	8b 5b 0c             	mov    0xc(%ebx),%ebx
80100133:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
80100139:	74 53                	je     8010018e <bread+0xce>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010013b:	f6 03 05             	testb  $0x5,(%ebx)
8010013e:	75 f0                	jne    80100130 <bread+0x70>
      release(&bcache.lock);
80100140:	83 ec 0c             	sub    $0xc,%esp
      b->dev = dev;
80100143:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100146:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = B_BUSY;
80100149:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      release(&bcache.lock);
8010014f:	68 e0 b5 10 80       	push   $0x8010b5e0
80100154:	e8 17 49 00 00       	call   80104a70 <release>
80100159:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
8010015c:	f6 03 02             	testb  $0x2,(%ebx)
8010015f:	75 0c                	jne    8010016d <bread+0xad>
    iderw(b);
80100161:	83 ec 0c             	sub    $0xc,%esp
80100164:	53                   	push   %ebx
80100165:	e8 96 1f 00 00       	call   80102100 <iderw>
8010016a:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
8010016d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100170:	89 d8                	mov    %ebx,%eax
80100172:	5b                   	pop    %ebx
80100173:	5e                   	pop    %esi
80100174:	5f                   	pop    %edi
80100175:	5d                   	pop    %ebp
80100176:	c3                   	ret    
        release(&bcache.lock);
80100177:	83 ec 0c             	sub    $0xc,%esp
        b->flags |= B_BUSY;
8010017a:	83 c8 01             	or     $0x1,%eax
8010017d:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
8010017f:	68 e0 b5 10 80       	push   $0x8010b5e0
80100184:	e8 e7 48 00 00       	call   80104a70 <release>
80100189:	83 c4 10             	add    $0x10,%esp
8010018c:	eb ce                	jmp    8010015c <bread+0x9c>
  panic("bget: no buffers");
8010018e:	83 ec 0c             	sub    $0xc,%esp
80100191:	68 e7 74 10 80       	push   $0x801074e7
80100196:	e8 d5 01 00 00       	call   80100370 <panic>
8010019b:	90                   	nop
8010019c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	83 ec 08             	sub    $0x8,%esp
801001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  if((b->flags & B_BUSY) == 0)
801001a9:	8b 02                	mov    (%edx),%eax
801001ab:	a8 01                	test   $0x1,%al
801001ad:	74 0b                	je     801001ba <bwrite+0x1a>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001af:	83 c8 04             	or     $0x4,%eax
801001b2:	89 02                	mov    %eax,(%edx)
  iderw(b);
}
801001b4:	c9                   	leave  
  iderw(b);
801001b5:	e9 46 1f 00 00       	jmp    80102100 <iderw>
    panic("bwrite");
801001ba:	83 ec 0c             	sub    $0xc,%esp
801001bd:	68 f8 74 10 80       	push   $0x801074f8
801001c2:	e8 a9 01 00 00       	call   80100370 <panic>
801001c7:	89 f6                	mov    %esi,%esi
801001c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001d0 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	53                   	push   %ebx
801001d4:	83 ec 04             	sub    $0x4,%esp
801001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
801001da:	f6 03 01             	testb  $0x1,(%ebx)
801001dd:	74 5a                	je     80100239 <brelse+0x69>
    panic("brelse");

  acquire(&bcache.lock);
801001df:	83 ec 0c             	sub    $0xc,%esp
801001e2:	68 e0 b5 10 80       	push   $0x8010b5e0
801001e7:	e8 a4 46 00 00       	call   80104890 <acquire>

  b->next->prev = b->prev;
801001ec:	8b 43 10             	mov    0x10(%ebx),%eax
801001ef:	8b 53 0c             	mov    0xc(%ebx),%edx
801001f2:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
801001f5:	8b 43 0c             	mov    0xc(%ebx),%eax
801001f8:	8b 53 10             	mov    0x10(%ebx),%edx
801001fb:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
801001fe:	a1 f4 f4 10 80       	mov    0x8010f4f4,%eax
  b->prev = &bcache.head;
80100203:	c7 43 0c e4 f4 10 80 	movl   $0x8010f4e4,0xc(%ebx)
  b->next = bcache.head.next;
8010020a:	89 43 10             	mov    %eax,0x10(%ebx)
  bcache.head.next->prev = b;
8010020d:	a1 f4 f4 10 80       	mov    0x8010f4f4,%eax
80100212:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
80100215:	89 1d f4 f4 10 80    	mov    %ebx,0x8010f4f4

  b->flags &= ~B_BUSY;
8010021b:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
8010021e:	89 1c 24             	mov    %ebx,(%esp)
80100221:	e8 5a 3e 00 00       	call   80104080 <wakeup>

  release(&bcache.lock);
80100226:	83 c4 10             	add    $0x10,%esp
80100229:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100233:	c9                   	leave  
  release(&bcache.lock);
80100234:	e9 37 48 00 00       	jmp    80104a70 <release>
    panic("brelse");
80100239:	83 ec 0c             	sub    $0xc,%esp
8010023c:	68 ff 74 10 80       	push   $0x801074ff
80100241:	e8 2a 01 00 00       	call   80100370 <panic>
80100246:	66 90                	xchg   %ax,%ax
80100248:	66 90                	xchg   %ax,%ax
8010024a:	66 90                	xchg   %ax,%ax
8010024c:	66 90                	xchg   %ax,%ax
8010024e:	66 90                	xchg   %ax,%ax

80100250 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100250:	55                   	push   %ebp
80100251:	89 e5                	mov    %esp,%ebp
80100253:	57                   	push   %edi
80100254:	56                   	push   %esi
80100255:	53                   	push   %ebx
80100256:	83 ec 28             	sub    $0x28,%esp
80100259:	8b 7d 08             	mov    0x8(%ebp),%edi
8010025c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010025f:	57                   	push   %edi
80100260:	e8 bb 14 00 00       	call   80101720 <iunlock>
  target = n;
  acquire(&cons.lock);
80100265:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010026c:	e8 1f 46 00 00       	call   80104890 <acquire>
  while(n > 0){
80100271:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100274:	83 c4 10             	add    $0x10,%esp
80100277:	31 c0                	xor    %eax,%eax
80100279:	85 db                	test   %ebx,%ebx
8010027b:	0f 8e a1 00 00 00    	jle    80100322 <consoleread+0xd2>
    while(input.r == input.w){
80100281:	8b 15 80 f7 10 80    	mov    0x8010f780,%edx
80100287:	39 15 84 f7 10 80    	cmp    %edx,0x8010f784
8010028d:	74 2c                	je     801002bb <consoleread+0x6b>
8010028f:	eb 5f                	jmp    801002f0 <consoleread+0xa0>
80100291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100298:	83 ec 08             	sub    $0x8,%esp
8010029b:	68 20 a5 10 80       	push   $0x8010a520
801002a0:	68 80 f7 10 80       	push   $0x8010f780
801002a5:	e8 e6 3b 00 00       	call   80103e90 <sleep>
    while(input.r == input.w){
801002aa:	8b 15 80 f7 10 80    	mov    0x8010f780,%edx
801002b0:	83 c4 10             	add    $0x10,%esp
801002b3:	3b 15 84 f7 10 80    	cmp    0x8010f784,%edx
801002b9:	75 35                	jne    801002f0 <consoleread+0xa0>
      if(proc->killed){
801002bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002c1:	8b 40 24             	mov    0x24(%eax),%eax
801002c4:	85 c0                	test   %eax,%eax
801002c6:	74 d0                	je     80100298 <consoleread+0x48>
        release(&cons.lock);
801002c8:	83 ec 0c             	sub    $0xc,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	e8 9b 47 00 00       	call   80104a70 <release>
        ilock(ip);
801002d5:	89 3c 24             	mov    %edi,(%esp)
801002d8:	e8 33 13 00 00       	call   80101610 <ilock>
        return -1;
801002dd:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801002e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801002e8:	5b                   	pop    %ebx
801002e9:	5e                   	pop    %esi
801002ea:	5f                   	pop    %edi
801002eb:	5d                   	pop    %ebp
801002ec:	c3                   	ret    
801002ed:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
801002f0:	8d 42 01             	lea    0x1(%edx),%eax
801002f3:	a3 80 f7 10 80       	mov    %eax,0x8010f780
801002f8:	89 d0                	mov    %edx,%eax
801002fa:	83 e0 7f             	and    $0x7f,%eax
801002fd:	0f be 80 00 f7 10 80 	movsbl -0x7fef0900(%eax),%eax
    if(c == C('D')){  // EOF
80100304:	83 f8 04             	cmp    $0x4,%eax
80100307:	74 3f                	je     80100348 <consoleread+0xf8>
    *dst++ = c;
80100309:	83 c6 01             	add    $0x1,%esi
    --n;
8010030c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010030f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100312:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100315:	74 43                	je     8010035a <consoleread+0x10a>
  while(n > 0){
80100317:	85 db                	test   %ebx,%ebx
80100319:	0f 85 62 ff ff ff    	jne    80100281 <consoleread+0x31>
8010031f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100322:	83 ec 0c             	sub    $0xc,%esp
80100325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100328:	68 20 a5 10 80       	push   $0x8010a520
8010032d:	e8 3e 47 00 00       	call   80104a70 <release>
  ilock(ip);
80100332:	89 3c 24             	mov    %edi,(%esp)
80100335:	e8 d6 12 00 00       	call   80101610 <ilock>
  return target - n;
8010033a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010033d:	83 c4 10             	add    $0x10,%esp
}
80100340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100343:	5b                   	pop    %ebx
80100344:	5e                   	pop    %esi
80100345:	5f                   	pop    %edi
80100346:	5d                   	pop    %ebp
80100347:	c3                   	ret    
80100348:	8b 45 10             	mov    0x10(%ebp),%eax
8010034b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010034d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100350:	73 d0                	jae    80100322 <consoleread+0xd2>
        input.r--;
80100352:	89 15 80 f7 10 80    	mov    %edx,0x8010f780
80100358:	eb c8                	jmp    80100322 <consoleread+0xd2>
8010035a:	8b 45 10             	mov    0x10(%ebp),%eax
8010035d:	29 d8                	sub    %ebx,%eax
8010035f:	eb c1                	jmp    80100322 <consoleread+0xd2>
80100361:	eb 0d                	jmp    80100370 <panic>
80100363:	90                   	nop
80100364:	90                   	nop
80100365:	90                   	nop
80100366:	90                   	nop
80100367:	90                   	nop
80100368:	90                   	nop
80100369:	90                   	nop
8010036a:	90                   	nop
8010036b:	90                   	nop
8010036c:	90                   	nop
8010036d:	90                   	nop
8010036e:	90                   	nop
8010036f:	90                   	nop

80100370 <panic>:
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100379:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cons.locking = 0;
8010037f:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100386:	00 00 00 
  getcallerpcs(&s, pcs);
80100389:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010038c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010038f:	0f b6 00             	movzbl (%eax),%eax
80100392:	50                   	push   %eax
80100393:	68 06 75 10 80       	push   $0x80107506
80100398:	e8 a3 02 00 00       	call   80100640 <cprintf>
  cprintf(s);
8010039d:	58                   	pop    %eax
8010039e:	ff 75 08             	pushl  0x8(%ebp)
801003a1:	e8 9a 02 00 00       	call   80100640 <cprintf>
  cprintf("\n");
801003a6:	c7 04 24 26 7a 10 80 	movl   $0x80107a26,(%esp)
801003ad:	e8 8e 02 00 00       	call   80100640 <cprintf>
  getcallerpcs(&s, pcs);
801003b2:	5a                   	pop    %edx
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	59                   	pop    %ecx
801003b7:	53                   	push   %ebx
801003b8:	50                   	push   %eax
801003b9:	e8 b2 45 00 00       	call   80104970 <getcallerpcs>
801003be:	83 c4 10             	add    $0x10,%esp
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	ff 33                	pushl  (%ebx)
801003cd:	83 c3 04             	add    $0x4,%ebx
801003d0:	68 22 75 10 80       	push   $0x80107522
801003d5:	e8 66 02 00 00       	call   80100640 <cprintf>
  for(i=0; i<10; i++)
801003da:	83 c4 10             	add    $0x10,%esp
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
  if(panicked){
801003f0:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801003f6:	85 c9                	test   %ecx,%ecx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c6                	mov    %eax,%esi
80100408:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b1 00 00 00    	je     801004c7 <consputc+0xd7>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 5d 00 00       	call   80106130 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 da                	mov    %ebx,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100434:	89 ca                	mov    %ecx,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 da                	mov    %ebx,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c7                	mov    %eax,%edi
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 ca                	mov    %ecx,%edx
80100449:	ec                   	in     (%dx),%al
8010044a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010044d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010044f:	83 fe 0a             	cmp    $0xa,%esi
80100452:	0f 84 f3 00 00 00    	je     8010054b <consputc+0x15b>
  else if(c == BACKSPACE){
80100458:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010045e:	0f 84 d7 00 00 00    	je     8010053b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	89 f0                	mov    %esi,%eax
80100466:	0f b6 c0             	movzbl %al,%eax
80100469:	80 cc 07             	or     $0x7,%ah
8010046c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100473:	80 
80100474:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100477:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010047d:	0f 8f ab 00 00 00    	jg     8010052e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
80100483:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100489:	7f 66                	jg     801004f1 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100490:	b8 0e 00 00 00       	mov    $0xe,%eax
80100495:	89 f2                	mov    %esi,%edx
80100497:	ee                   	out    %al,(%dx)
80100498:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	c1 f8 08             	sar    $0x8,%eax
801004a2:	89 ca                	mov    %ecx,%edx
801004a4:	ee                   	out    %al,(%dx)
801004a5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004aa:	89 f2                	mov    %esi,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	89 d8                	mov    %ebx,%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004be:	80 
}
801004bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c2:	5b                   	pop    %ebx
801004c3:	5e                   	pop    %esi
801004c4:	5f                   	pop    %edi
801004c5:	5d                   	pop    %ebp
801004c6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004c7:	83 ec 0c             	sub    $0xc,%esp
801004ca:	6a 08                	push   $0x8
801004cc:	e8 5f 5c 00 00       	call   80106130 <uartputc>
801004d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004d8:	e8 53 5c 00 00       	call   80106130 <uartputc>
801004dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004e4:	e8 47 5c 00 00       	call   80106130 <uartputc>
801004e9:	83 c4 10             	add    $0x10,%esp
801004ec:	e9 31 ff ff ff       	jmp    80100422 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f1:	52                   	push   %edx
801004f2:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
801004f7:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fa:	68 a0 80 0b 80       	push   $0x800b80a0
801004ff:	68 00 80 0b 80       	push   $0x800b8000
80100504:	e8 67 46 00 00       	call   80104b70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100509:	b8 80 07 00 00       	mov    $0x780,%eax
8010050e:	83 c4 0c             	add    $0xc,%esp
80100511:	29 d8                	sub    %ebx,%eax
80100513:	01 c0                	add    %eax,%eax
80100515:	50                   	push   %eax
80100516:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100519:	6a 00                	push   $0x0
8010051b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100520:	50                   	push   %eax
80100521:	e8 9a 45 00 00       	call   80104ac0 <memset>
80100526:	83 c4 10             	add    $0x10,%esp
80100529:	e9 5d ff ff ff       	jmp    8010048b <consputc+0x9b>
    panic("pos under/overflow");
8010052e:	83 ec 0c             	sub    $0xc,%esp
80100531:	68 26 75 10 80       	push   $0x80107526
80100536:	e8 35 fe ff ff       	call   80100370 <panic>
    if(pos > 0) --pos;
8010053b:	85 db                	test   %ebx,%ebx
8010053d:	0f 84 48 ff ff ff    	je     8010048b <consputc+0x9b>
80100543:	83 eb 01             	sub    $0x1,%ebx
80100546:	e9 2c ff ff ff       	jmp    80100477 <consputc+0x87>
    pos += 80 - pos%80;
8010054b:	89 d8                	mov    %ebx,%eax
8010054d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100552:	99                   	cltd   
80100553:	f7 f9                	idiv   %ecx
80100555:	29 d1                	sub    %edx,%ecx
80100557:	01 cb                	add    %ecx,%ebx
80100559:	e9 19 ff ff ff       	jmp    80100477 <consputc+0x87>
8010055e:	66 90                	xchg   %ax,%ax

80100560 <printint>:
{
80100560:	55                   	push   %ebp
80100561:	89 e5                	mov    %esp,%ebp
80100563:	57                   	push   %edi
80100564:	56                   	push   %esi
80100565:	53                   	push   %ebx
80100566:	89 d3                	mov    %edx,%ebx
80100568:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010056b:	85 c9                	test   %ecx,%ecx
{
8010056d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100570:	74 04                	je     80100576 <printint+0x16>
80100572:	85 c0                	test   %eax,%eax
80100574:	78 5a                	js     801005d0 <printint+0x70>
    x = xx;
80100576:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010057d:	31 c9                	xor    %ecx,%ecx
8010057f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100582:	eb 06                	jmp    8010058a <printint+0x2a>
80100584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100588:	89 f9                	mov    %edi,%ecx
8010058a:	31 d2                	xor    %edx,%edx
8010058c:	8d 79 01             	lea    0x1(%ecx),%edi
8010058f:	f7 f3                	div    %ebx
80100591:	0f b6 92 54 75 10 80 	movzbl -0x7fef8aac(%edx),%edx
  }while((x /= base) != 0);
80100598:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
8010059a:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
8010059d:	75 e9                	jne    80100588 <printint+0x28>
  if(sign)
8010059f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005a2:	85 c0                	test   %eax,%eax
801005a4:	74 08                	je     801005ae <printint+0x4e>
    buf[i++] = '-';
801005a6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005ab:	8d 79 02             	lea    0x2(%ecx),%edi
801005ae:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005b8:	0f be 03             	movsbl (%ebx),%eax
801005bb:	83 eb 01             	sub    $0x1,%ebx
801005be:	e8 2d fe ff ff       	call   801003f0 <consputc>
  while(--i >= 0)
801005c3:	39 f3                	cmp    %esi,%ebx
801005c5:	75 f1                	jne    801005b8 <printint+0x58>
}
801005c7:	83 c4 2c             	add    $0x2c,%esp
801005ca:	5b                   	pop    %ebx
801005cb:	5e                   	pop    %esi
801005cc:	5f                   	pop    %edi
801005cd:	5d                   	pop    %ebp
801005ce:	c3                   	ret    
801005cf:	90                   	nop
    x = -xx;
801005d0:	f7 d8                	neg    %eax
801005d2:	eb a9                	jmp    8010057d <printint+0x1d>
801005d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005e0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	57                   	push   %edi
801005e4:	56                   	push   %esi
801005e5:	53                   	push   %ebx
801005e6:	83 ec 18             	sub    $0x18,%esp
801005e9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ec:	ff 75 08             	pushl  0x8(%ebp)
801005ef:	e8 2c 11 00 00       	call   80101720 <iunlock>
  acquire(&cons.lock);
801005f4:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005fb:	e8 90 42 00 00       	call   80104890 <acquire>
  for(i = 0; i < n; i++)
80100600:	83 c4 10             	add    $0x10,%esp
80100603:	85 f6                	test   %esi,%esi
80100605:	7e 18                	jle    8010061f <consolewrite+0x3f>
80100607:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010060a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010060d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100610:	0f b6 07             	movzbl (%edi),%eax
80100613:	83 c7 01             	add    $0x1,%edi
80100616:	e8 d5 fd ff ff       	call   801003f0 <consputc>
  for(i = 0; i < n; i++)
8010061b:	39 fb                	cmp    %edi,%ebx
8010061d:	75 f1                	jne    80100610 <consolewrite+0x30>
  release(&cons.lock);
8010061f:	83 ec 0c             	sub    $0xc,%esp
80100622:	68 20 a5 10 80       	push   $0x8010a520
80100627:	e8 44 44 00 00       	call   80104a70 <release>
  ilock(ip);
8010062c:	58                   	pop    %eax
8010062d:	ff 75 08             	pushl  0x8(%ebp)
80100630:	e8 db 0f 00 00       	call   80101610 <ilock>

  return n;
}
80100635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100638:	89 f0                	mov    %esi,%eax
8010063a:	5b                   	pop    %ebx
8010063b:	5e                   	pop    %esi
8010063c:	5f                   	pop    %edi
8010063d:	5d                   	pop    %ebp
8010063e:	c3                   	ret    
8010063f:	90                   	nop

80100640 <cprintf>:
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100649:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010064e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100650:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100653:	0f 85 6f 01 00 00    	jne    801007c8 <cprintf+0x188>
  if (fmt == 0)
80100659:	8b 45 08             	mov    0x8(%ebp),%eax
8010065c:	85 c0                	test   %eax,%eax
8010065e:	89 c7                	mov    %eax,%edi
80100660:	0f 84 77 01 00 00    	je     801007dd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100666:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100669:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010066c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010066e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100671:	85 c0                	test   %eax,%eax
80100673:	75 56                	jne    801006cb <cprintf+0x8b>
80100675:	eb 79                	jmp    801006f0 <cprintf+0xb0>
80100677:	89 f6                	mov    %esi,%esi
80100679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100680:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100683:	85 d2                	test   %edx,%edx
80100685:	74 69                	je     801006f0 <cprintf+0xb0>
80100687:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010068a:	83 fa 70             	cmp    $0x70,%edx
8010068d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80100690:	0f 84 84 00 00 00    	je     8010071a <cprintf+0xda>
80100696:	7f 78                	jg     80100710 <cprintf+0xd0>
80100698:	83 fa 25             	cmp    $0x25,%edx
8010069b:	0f 84 ff 00 00 00    	je     801007a0 <cprintf+0x160>
801006a1:	83 fa 64             	cmp    $0x64,%edx
801006a4:	0f 85 8e 00 00 00    	jne    80100738 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006ad:	ba 0a 00 00 00       	mov    $0xa,%edx
801006b2:	8d 48 04             	lea    0x4(%eax),%ecx
801006b5:	8b 00                	mov    (%eax),%eax
801006b7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006ba:	b9 01 00 00 00       	mov    $0x1,%ecx
801006bf:	e8 9c fe ff ff       	call   80100560 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
801006c7:	85 c0                	test   %eax,%eax
801006c9:	74 25                	je     801006f0 <cprintf+0xb0>
801006cb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ce:	83 f8 25             	cmp    $0x25,%eax
801006d1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006d4:	74 aa                	je     80100680 <cprintf+0x40>
801006d6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006d9:	e8 12 fd ff ff       	call   801003f0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	0f b6 06             	movzbl (%esi),%eax
      continue;
801006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801006e4:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e6:	85 c0                	test   %eax,%eax
801006e8:	75 e1                	jne    801006cb <cprintf+0x8b>
801006ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
801006f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801006f3:	85 c0                	test   %eax,%eax
801006f5:	74 10                	je     80100707 <cprintf+0xc7>
    release(&cons.lock);
801006f7:	83 ec 0c             	sub    $0xc,%esp
801006fa:	68 20 a5 10 80       	push   $0x8010a520
801006ff:	e8 6c 43 00 00       	call   80104a70 <release>
80100704:	83 c4 10             	add    $0x10,%esp
}
80100707:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010070a:	5b                   	pop    %ebx
8010070b:	5e                   	pop    %esi
8010070c:	5f                   	pop    %edi
8010070d:	5d                   	pop    %ebp
8010070e:	c3                   	ret    
8010070f:	90                   	nop
    switch(c){
80100710:	83 fa 73             	cmp    $0x73,%edx
80100713:	74 43                	je     80100758 <cprintf+0x118>
80100715:	83 fa 78             	cmp    $0x78,%edx
80100718:	75 1e                	jne    80100738 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010071a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010071d:	ba 10 00 00 00       	mov    $0x10,%edx
80100722:	8d 48 04             	lea    0x4(%eax),%ecx
80100725:	8b 00                	mov    (%eax),%eax
80100727:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010072a:	31 c9                	xor    %ecx,%ecx
8010072c:	e8 2f fe ff ff       	call   80100560 <printint>
      break;
80100731:	eb 91                	jmp    801006c4 <cprintf+0x84>
80100733:	90                   	nop
80100734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100738:	b8 25 00 00 00       	mov    $0x25,%eax
8010073d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100740:	e8 ab fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100745:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100748:	89 d0                	mov    %edx,%eax
8010074a:	e8 a1 fc ff ff       	call   801003f0 <consputc>
      break;
8010074f:	e9 70 ff ff ff       	jmp    801006c4 <cprintf+0x84>
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010075b:	8b 10                	mov    (%eax),%edx
8010075d:	8d 48 04             	lea    0x4(%eax),%ecx
80100760:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100763:	85 d2                	test   %edx,%edx
80100765:	74 49                	je     801007b0 <cprintf+0x170>
      for(; *s; s++)
80100767:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010076a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010076d:	84 c0                	test   %al,%al
8010076f:	0f 84 4f ff ff ff    	je     801006c4 <cprintf+0x84>
80100775:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100778:	89 d3                	mov    %edx,%ebx
8010077a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100780:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100783:	e8 68 fc ff ff       	call   801003f0 <consputc>
      for(; *s; s++)
80100788:	0f be 03             	movsbl (%ebx),%eax
8010078b:	84 c0                	test   %al,%al
8010078d:	75 f1                	jne    80100780 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
8010078f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100792:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100795:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100798:	e9 27 ff ff ff       	jmp    801006c4 <cprintf+0x84>
8010079d:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007a0:	b8 25 00 00 00       	mov    $0x25,%eax
801007a5:	e8 46 fc ff ff       	call   801003f0 <consputc>
      break;
801007aa:	e9 15 ff ff ff       	jmp    801006c4 <cprintf+0x84>
801007af:	90                   	nop
        s = "(null)";
801007b0:	ba 39 75 10 80       	mov    $0x80107539,%edx
      for(; *s; s++)
801007b5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007b8:	b8 28 00 00 00       	mov    $0x28,%eax
801007bd:	89 d3                	mov    %edx,%ebx
801007bf:	eb bf                	jmp    80100780 <cprintf+0x140>
801007c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007c8:	83 ec 0c             	sub    $0xc,%esp
801007cb:	68 20 a5 10 80       	push   $0x8010a520
801007d0:	e8 bb 40 00 00       	call   80104890 <acquire>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	e9 7c fe ff ff       	jmp    80100659 <cprintf+0x19>
    panic("null fmt");
801007dd:	83 ec 0c             	sub    $0xc,%esp
801007e0:	68 40 75 10 80       	push   $0x80107540
801007e5:	e8 86 fb ff ff       	call   80100370 <panic>
801007ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801007f0 <consoleintr>:
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 88 40 00 00       	call   80104890 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 e7 00 00 00    	je     80100908 <consoleintr+0x118>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 ec 00 00 00    	je     80100918 <consoleintr+0x128>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
      if(input.e != input.w){
80100831:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100836:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 88 f7 10 80       	mov    %eax,0x8010f788
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 03 42 00 00       	call   80104a70 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 88 f7 10 80       	mov    0x8010f788,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 80 f7 10 80    	sub    0x8010f780,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 88 f7 10 80    	mov    %edx,0x8010f788
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 00 f7 10 80    	mov    %cl,-0x7fef0900(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c5 00 00 00    	je     80100991 <consoleintr+0x1a1>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 bc 00 00 00    	je     80100991 <consoleintr+0x1a1>
801008d5:	a1 80 f7 10 80       	mov    0x8010f780,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 88 f7 10 80    	cmp    %eax,0x8010f788
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801008ec:	a3 84 f7 10 80       	mov    %eax,0x8010f784
          wakeup(&input.r);
801008f1:	68 80 f7 10 80       	push   $0x8010f780
801008f6:	e8 85 37 00 00       	call   80104080 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100908:	be 01 00 00 00       	mov    $0x1,%esi
8010090d:	e9 fe fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100918:	a1 88 f7 10 80       	mov    0x8010f788,%eax
8010091d:	39 05 84 f7 10 80    	cmp    %eax,0x8010f784
80100923:	75 2b                	jne    80100950 <consoleintr+0x160>
80100925:	e9 e6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010092a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100930:	a3 88 f7 10 80       	mov    %eax,0x8010f788
        consputc(BACKSPACE);
80100935:	b8 00 01 00 00       	mov    $0x100,%eax
8010093a:	e8 b1 fa ff ff       	call   801003f0 <consputc>
      while(input.e != input.w &&
8010093f:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100944:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
8010094a:	0f 84 c0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100950:	83 e8 01             	sub    $0x1,%eax
80100953:	89 c2                	mov    %eax,%edx
80100955:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100958:	80 ba 00 f7 10 80 0a 	cmpb   $0xa,-0x7fef0900(%edx)
8010095f:	75 cf                	jne    80100930 <consoleintr+0x140>
80100961:	e9 aa fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100966:	8d 76 00             	lea    0x0(%esi),%esi
80100969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 e4 37 00 00       	jmp    80104160 <procdump>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100980:	c6 80 00 f7 10 80 0a 	movb   $0xa,-0x7fef0900(%eax)
        consputc(c);
80100987:	b8 0a 00 00 00       	mov    $0xa,%eax
8010098c:	e8 5f fa ff ff       	call   801003f0 <consputc>
80100991:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100996:	e9 4e ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
8010099b:	90                   	nop
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009a0 <consoleinit>:

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 49 75 10 80       	push   $0x80107549
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 bb 3e 00 00       	call   80104870 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
801009bc:	c7 05 4c 01 11 80 e0 	movl   $0x801005e0,0x8011014c
801009c3:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801009c6:	c7 05 48 01 11 80 50 	movl   $0x80100250,0x80110148
801009cd:	02 10 80 
  cons.locking = 1;
801009d0:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d7:	00 00 00 
  picenable(IRQ_KBD);
801009da:	e8 31 29 00 00       	call   80103310 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009df:	58                   	pop    %eax
801009e0:	5a                   	pop    %edx
801009e1:	6a 00                	push   $0x0
801009e3:	6a 01                	push   $0x1
801009e5:	e8 d6 18 00 00       	call   801022c0 <ioapicenable>
}
801009ea:	83 c4 10             	add    $0x10,%esp
801009ed:	c9                   	leave  
801009ee:	c3                   	ret    
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009fc:	e8 3f 22 00 00       	call   80102c40 <begin_op>
  if((ip = namei(path)) == 0){
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	ff 75 08             	pushl  0x8(%ebp)
80100a07:	e8 a4 14 00 00       	call   80101eb0 <namei>
80100a0c:	83 c4 10             	add    $0x10,%esp
80100a0f:	85 c0                	test   %eax,%eax
80100a11:	0f 84 9d 01 00 00    	je     80100bb4 <exec+0x1c4>
    end_op();
    return -1;
  }
  ilock(ip);
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	89 c3                	mov    %eax,%ebx
80100a1c:	50                   	push   %eax
80100a1d:	e8 ee 0b 00 00       	call   80101610 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100a22:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a28:	6a 34                	push   $0x34
80100a2a:	6a 00                	push   $0x0
80100a2c:	50                   	push   %eax
80100a2d:	53                   	push   %ebx
80100a2e:	e8 fd 0e 00 00       	call   80101930 <readi>
80100a33:	83 c4 20             	add    $0x20,%esp
80100a36:	83 f8 33             	cmp    $0x33,%eax
80100a39:	77 25                	ja     80100a60 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a3b:	83 ec 0c             	sub    $0xc,%esp
80100a3e:	53                   	push   %ebx
80100a3f:	e8 9c 0e 00 00       	call   801018e0 <iunlockput>
    end_op();
80100a44:	e8 67 22 00 00       	call   80102cb0 <end_op>
80100a49:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a54:	5b                   	pop    %ebx
80100a55:	5e                   	pop    %esi
80100a56:	5f                   	pop    %edi
80100a57:	5d                   	pop    %ebp
80100a58:	c3                   	ret    
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 cf                	jne    80100a3b <exec+0x4b>
  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 0f 64 00 00       	call   80106e80 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a79:	74 c0                	je     80100a3b <exec+0x4b>
  sz = 0;
80100a7b:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a84:	00 
80100a85:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100a8b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a91:	0f 84 89 02 00 00    	je     80100d20 <exec+0x330>
80100a97:	31 f6                	xor    %esi,%esi
80100a99:	eb 7f                	jmp    80100b1a <exec+0x12a>
80100a9b:	90                   	nop
80100a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100aa0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa7:	75 63                	jne    80100b0c <exec+0x11c>
    if(ph.memsz < ph.filesz)
80100aa9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aaf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab5:	0f 82 86 00 00 00    	jb     80100b41 <exec+0x151>
80100abb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ac1:	72 7e                	jb     80100b41 <exec+0x151>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ac3:	83 ec 04             	sub    $0x4,%esp
80100ac6:	50                   	push   %eax
80100ac7:	57                   	push   %edi
80100ac8:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ace:	e8 3d 66 00 00       	call   80107110 <allocuvm>
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	85 c0                	test   %eax,%eax
80100ad8:	89 c7                	mov    %eax,%edi
80100ada:	74 65                	je     80100b41 <exec+0x151>
    if(ph.vaddr % PGSIZE != 0)
80100adc:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae2:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ae7:	75 58                	jne    80100b41 <exec+0x151>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ae9:	83 ec 0c             	sub    $0xc,%esp
80100aec:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100af2:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100af8:	53                   	push   %ebx
80100af9:	50                   	push   %eax
80100afa:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b00:	e8 4b 65 00 00       	call   80107050 <loaduvm>
80100b05:	83 c4 20             	add    $0x20,%esp
80100b08:	85 c0                	test   %eax,%eax
80100b0a:	78 35                	js     80100b41 <exec+0x151>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b0c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b13:	83 c6 01             	add    $0x1,%esi
80100b16:	39 f0                	cmp    %esi,%eax
80100b18:	7e 46                	jle    80100b60 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b1a:	89 f0                	mov    %esi,%eax
80100b1c:	6a 20                	push   $0x20
80100b1e:	c1 e0 05             	shl    $0x5,%eax
80100b21:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b27:	50                   	push   %eax
80100b28:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b2e:	50                   	push   %eax
80100b2f:	53                   	push   %ebx
80100b30:	e8 fb 0d 00 00       	call   80101930 <readi>
80100b35:	83 c4 10             	add    $0x10,%esp
80100b38:	83 f8 20             	cmp    $0x20,%eax
80100b3b:	0f 84 5f ff ff ff    	je     80100aa0 <exec+0xb0>
    freevm(pgdir);
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b4a:	e8 21 67 00 00       	call   80107270 <freevm>
80100b4f:	83 c4 10             	add    $0x10,%esp
80100b52:	e9 e4 fe ff ff       	jmp    80100a3b <exec+0x4b>
80100b57:	89 f6                	mov    %esi,%esi
80100b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100b60:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b66:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b6c:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b72:	83 ec 0c             	sub    $0xc,%esp
80100b75:	53                   	push   %ebx
80100b76:	e8 65 0d 00 00       	call   801018e0 <iunlockput>
  end_op();
80100b7b:	e8 30 21 00 00       	call   80102cb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b80:	83 c4 0c             	add    $0xc,%esp
80100b83:	56                   	push   %esi
80100b84:	57                   	push   %edi
80100b85:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b8b:	e8 80 65 00 00       	call   80107110 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	85 c0                	test   %eax,%eax
80100b95:	89 c6                	mov    %eax,%esi
80100b97:	75 2a                	jne    80100bc3 <exec+0x1d3>
    freevm(pgdir);
80100b99:	83 ec 0c             	sub    $0xc,%esp
80100b9c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba2:	e8 c9 66 00 00       	call   80107270 <freevm>
80100ba7:	83 c4 10             	add    $0x10,%esp
  return -1;
80100baa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100baf:	e9 9d fe ff ff       	jmp    80100a51 <exec+0x61>
    end_op();
80100bb4:	e8 f7 20 00 00       	call   80102cb0 <end_op>
    return -1;
80100bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bbe:	e9 8e fe ff ff       	jmp    80100a51 <exec+0x61>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc3:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bc9:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bcc:	31 ff                	xor    %edi,%edi
80100bce:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd0:	50                   	push   %eax
80100bd1:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bd7:	e8 14 67 00 00       	call   801072f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bdf:	83 c4 10             	add    $0x10,%esp
80100be2:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100be8:	8b 00                	mov    (%eax),%eax
80100bea:	85 c0                	test   %eax,%eax
80100bec:	74 6f                	je     80100c5d <exec+0x26d>
80100bee:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100bf4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bfa:	eb 09                	jmp    80100c05 <exec+0x215>
80100bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c00:	83 ff 20             	cmp    $0x20,%edi
80100c03:	74 94                	je     80100b99 <exec+0x1a9>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c05:	83 ec 0c             	sub    $0xc,%esp
80100c08:	50                   	push   %eax
80100c09:	e8 d2 40 00 00       	call   80104ce0 <strlen>
80100c0e:	f7 d0                	not    %eax
80100c10:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c12:	58                   	pop    %eax
80100c13:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c16:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c19:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c1c:	e8 bf 40 00 00       	call   80104ce0 <strlen>
80100c21:	83 c0 01             	add    $0x1,%eax
80100c24:	50                   	push   %eax
80100c25:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c28:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c2b:	53                   	push   %ebx
80100c2c:	56                   	push   %esi
80100c2d:	e8 0e 68 00 00       	call   80107440 <copyout>
80100c32:	83 c4 20             	add    $0x20,%esp
80100c35:	85 c0                	test   %eax,%eax
80100c37:	0f 88 5c ff ff ff    	js     80100b99 <exec+0x1a9>
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c40:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c47:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c4a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c50:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c53:	85 c0                	test   %eax,%eax
80100c55:	75 a9                	jne    80100c00 <exec+0x210>
80100c57:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c5d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c64:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c66:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c6d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c71:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c78:	ff ff ff 
  ustack[1] = argc;
80100c7b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100c83:	83 c0 0c             	add    $0xc,%eax
80100c86:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c88:	50                   	push   %eax
80100c89:	52                   	push   %edx
80100c8a:	53                   	push   %ebx
80100c8b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c91:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c97:	e8 a4 67 00 00       	call   80107440 <copyout>
80100c9c:	83 c4 10             	add    $0x10,%esp
80100c9f:	85 c0                	test   %eax,%eax
80100ca1:	0f 88 f2 fe ff ff    	js     80100b99 <exec+0x1a9>
  for(last=s=path; *s; s++)
80100ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80100caa:	8b 55 08             	mov    0x8(%ebp),%edx
80100cad:	0f b6 00             	movzbl (%eax),%eax
80100cb0:	84 c0                	test   %al,%al
80100cb2:	74 11                	je     80100cc5 <exec+0x2d5>
80100cb4:	89 d1                	mov    %edx,%ecx
80100cb6:	83 c1 01             	add    $0x1,%ecx
80100cb9:	3c 2f                	cmp    $0x2f,%al
80100cbb:	0f b6 01             	movzbl (%ecx),%eax
80100cbe:	0f 44 d1             	cmove  %ecx,%edx
80100cc1:	84 c0                	test   %al,%al
80100cc3:	75 f1                	jne    80100cb6 <exec+0x2c6>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cc5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ccb:	83 ec 04             	sub    $0x4,%esp
80100cce:	6a 10                	push   $0x10
80100cd0:	52                   	push   %edx
80100cd1:	83 c0 6c             	add    $0x6c,%eax
80100cd4:	50                   	push   %eax
80100cd5:	e8 c6 3f 00 00       	call   80104ca0 <safestrcpy>
  oldpgdir = proc->pgdir;
80100cda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce0:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  oldpgdir = proc->pgdir;
80100ce6:	8b 78 04             	mov    0x4(%eax),%edi
  proc->sz = sz;
80100ce9:	89 30                	mov    %esi,(%eax)
  proc->pgdir = pgdir;
80100ceb:	89 50 04             	mov    %edx,0x4(%eax)
  proc->tf->eip = elf.entry;  // main
80100cee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf4:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cfa:	8b 50 18             	mov    0x18(%eax),%edx
80100cfd:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d00:	8b 50 18             	mov    0x18(%eax),%edx
80100d03:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d06:	89 04 24             	mov    %eax,(%esp)
80100d09:	e8 22 62 00 00       	call   80106f30 <switchuvm>
  freevm(oldpgdir);
80100d0e:	89 3c 24             	mov    %edi,(%esp)
80100d11:	e8 5a 65 00 00       	call   80107270 <freevm>
  return 0;
80100d16:	83 c4 10             	add    $0x10,%esp
80100d19:	31 c0                	xor    %eax,%eax
80100d1b:	e9 31 fd ff ff       	jmp    80100a51 <exec+0x61>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d20:	be 00 20 00 00       	mov    $0x2000,%esi
80100d25:	e9 48 fe ff ff       	jmp    80100b72 <exec+0x182>
80100d2a:	66 90                	xchg   %ax,%ax
80100d2c:	66 90                	xchg   %ax,%ax
80100d2e:	66 90                	xchg   %ax,%ax

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	68 65 75 10 80       	push   $0x80107565
80100d3b:	68 a0 f7 10 80       	push   $0x8010f7a0
80100d40:	e8 2b 3b 00 00       	call   80104870 <initlock>
}
80100d45:	83 c4 10             	add    $0x10,%esp
80100d48:	c9                   	leave  
80100d49:	c3                   	ret    
80100d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb d4 f7 10 80       	mov    $0x8010f7d4,%ebx
{
80100d59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d5c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100d61:	e8 2a 3b 00 00       	call   80104890 <acquire>
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	eb 10                	jmp    80100d7b <filealloc+0x2b>
80100d6b:	90                   	nop
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 34 01 11 80    	cmp    $0x80110134,%ebx
80100d79:	73 25                	jae    80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100d85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d8c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100d91:	e8 da 3c 00 00       	call   80104a70 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d96:	89 d8                	mov    %ebx,%eax
      return f;
80100d98:	83 c4 10             	add    $0x10,%esp
}
80100d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d9e:	c9                   	leave  
80100d9f:	c3                   	ret    
  release(&ftable.lock);
80100da0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100da3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100da5:	68 a0 f7 10 80       	push   $0x8010f7a0
80100daa:	e8 c1 3c 00 00       	call   80104a70 <release>
}
80100daf:	89 d8                	mov    %ebx,%eax
  return 0;
80100db1:	83 c4 10             	add    $0x10,%esp
}
80100db4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100db7:	c9                   	leave  
80100db8:	c3                   	ret    
80100db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 10             	sub    $0x10,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	68 a0 f7 10 80       	push   $0x8010f7a0
80100dcf:	e8 bc 3a 00 00       	call   80104890 <acquire>
  if(f->ref < 1)
80100dd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	85 c0                	test   %eax,%eax
80100ddc:	7e 1a                	jle    80100df8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100de1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100de4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de7:	68 a0 f7 10 80       	push   $0x8010f7a0
80100dec:	e8 7f 3c 00 00       	call   80104a70 <release>
  return f;
}
80100df1:	89 d8                	mov    %ebx,%eax
80100df3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df6:	c9                   	leave  
80100df7:	c3                   	ret    
    panic("filedup");
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 6c 75 10 80       	push   $0x8010756c
80100e00:	e8 6b f5 ff ff       	call   80100370 <panic>
80100e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 28             	sub    $0x28,%esp
80100e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e21:	e8 6a 3a 00 00       	call   80104890 <acquire>
  if(f->ref < 1)
80100e26:	8b 43 04             	mov    0x4(%ebx),%eax
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	0f 8e 9b 00 00 00    	jle    80100ecf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e34:	83 e8 01             	sub    $0x1,%eax
80100e37:	85 c0                	test   %eax,%eax
80100e39:	89 43 04             	mov    %eax,0x4(%ebx)
80100e3c:	74 1a                	je     80100e58 <fileclose+0x48>
    release(&ftable.lock);
80100e3e:	c7 45 08 a0 f7 10 80 	movl   $0x8010f7a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e48:	5b                   	pop    %ebx
80100e49:	5e                   	pop    %esi
80100e4a:	5f                   	pop    %edi
80100e4b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e4c:	e9 1f 3c 00 00       	jmp    80104a70 <release>
80100e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e58:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e5c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e5e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e61:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e64:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e6d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100e70:	68 a0 f7 10 80       	push   $0x8010f7a0
  ff = *f;
80100e75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e78:	e8 f3 3b 00 00       	call   80104a70 <release>
  if(ff.type == FD_PIPE)
80100e7d:	83 c4 10             	add    $0x10,%esp
80100e80:	83 ff 01             	cmp    $0x1,%edi
80100e83:	74 13                	je     80100e98 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100e85:	83 ff 02             	cmp    $0x2,%edi
80100e88:	74 26                	je     80100eb0 <fileclose+0xa0>
}
80100e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e8d:	5b                   	pop    %ebx
80100e8e:	5e                   	pop    %esi
80100e8f:	5f                   	pop    %edi
80100e90:	5d                   	pop    %ebp
80100e91:	c3                   	ret    
80100e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e9c:	83 ec 08             	sub    $0x8,%esp
80100e9f:	53                   	push   %ebx
80100ea0:	56                   	push   %esi
80100ea1:	e8 4a 26 00 00       	call   801034f0 <pipeclose>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb df                	jmp    80100e8a <fileclose+0x7a>
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100eb0:	e8 8b 1d 00 00       	call   80102c40 <begin_op>
    iput(ff.ip);
80100eb5:	83 ec 0c             	sub    $0xc,%esp
80100eb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ebb:	e8 c0 08 00 00       	call   80101780 <iput>
    end_op();
80100ec0:	83 c4 10             	add    $0x10,%esp
}
80100ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ec6:	5b                   	pop    %ebx
80100ec7:	5e                   	pop    %esi
80100ec8:	5f                   	pop    %edi
80100ec9:	5d                   	pop    %ebp
    end_op();
80100eca:	e9 e1 1d 00 00       	jmp    80102cb0 <end_op>
    panic("fileclose");
80100ecf:	83 ec 0c             	sub    $0xc,%esp
80100ed2:	68 74 75 10 80       	push   $0x80107574
80100ed7:	e8 94 f4 ff ff       	call   80100370 <panic>
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 04             	sub    $0x4,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	ff 73 10             	pushl  0x10(%ebx)
80100ef5:	e8 16 07 00 00       	call   80101610 <ilock>
    stati(f->ip, st);
80100efa:	58                   	pop    %eax
80100efb:	5a                   	pop    %edx
80100efc:	ff 75 0c             	pushl  0xc(%ebp)
80100eff:	ff 73 10             	pushl  0x10(%ebx)
80100f02:	e8 f9 09 00 00       	call   80101900 <stati>
    iunlock(f->ip);
80100f07:	59                   	pop    %ecx
80100f08:	ff 73 10             	pushl  0x10(%ebx)
80100f0b:	e8 10 08 00 00       	call   80101720 <iunlock>
    return 0;
80100f10:	83 c4 10             	add    $0x10,%esp
80100f13:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f25:	eb ee                	jmp    80100f15 <filestat+0x35>
80100f27:	89 f6                	mov    %esi,%esi
80100f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 60                	je     80100fa8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 41                	je     80100f90 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 5b                	jne    80100faf <fileread+0x7f>
    ilock(f->ip);
80100f54:	83 ec 0c             	sub    $0xc,%esp
80100f57:	ff 73 10             	pushl  0x10(%ebx)
80100f5a:	e8 b1 06 00 00       	call   80101610 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	57                   	push   %edi
80100f60:	ff 73 14             	pushl  0x14(%ebx)
80100f63:	56                   	push   %esi
80100f64:	ff 73 10             	pushl  0x10(%ebx)
80100f67:	e8 c4 09 00 00       	call   80101930 <readi>
80100f6c:	83 c4 20             	add    $0x20,%esp
80100f6f:	85 c0                	test   %eax,%eax
80100f71:	89 c6                	mov    %eax,%esi
80100f73:	7e 03                	jle    80100f78 <fileread+0x48>
      f->off += r;
80100f75:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	ff 73 10             	pushl  0x10(%ebx)
80100f7e:	e8 9d 07 00 00       	call   80101720 <iunlock>
    return r;
80100f83:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f89:	89 f0                	mov    %esi,%eax
80100f8b:	5b                   	pop    %ebx
80100f8c:	5e                   	pop    %esi
80100f8d:	5f                   	pop    %edi
80100f8e:	5d                   	pop    %ebp
80100f8f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100f90:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f93:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	5b                   	pop    %ebx
80100f9a:	5e                   	pop    %esi
80100f9b:	5f                   	pop    %edi
80100f9c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f9d:	e9 1e 27 00 00       	jmp    801036c0 <piperead>
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fa8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fad:	eb d7                	jmp    80100f86 <fileread+0x56>
  panic("fileread");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 7e 75 10 80       	push   $0x8010757e
80100fb7:	e8 b4 f3 ff ff       	call   80100370 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 1c             	sub    $0x1c,%esp
80100fc9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fcf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80100fd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100fdc:	0f 84 aa 00 00 00    	je     8010108c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 06                	mov    (%esi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c3 00 00 00    	je     801010b0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d9 00 00 00    	jne    801010cf <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80100ff9:	31 ff                	xor    %edi,%edi
    while(i < n){
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 34                	jg     80101033 <filewrite+0x73>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101008:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010100b:	83 ec 0c             	sub    $0xc,%esp
8010100e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101011:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101014:	e8 07 07 00 00       	call   80101720 <iunlock>
      end_op();
80101019:	e8 92 1c 00 00       	call   80102cb0 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101021:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101024:	39 c3                	cmp    %eax,%ebx
80101026:	0f 85 96 00 00 00    	jne    801010c2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010102c:	01 df                	add    %ebx,%edi
    while(i < n){
8010102e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101031:	7e 6d                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101033:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101036:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010103b:	29 fb                	sub    %edi,%ebx
8010103d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101043:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101046:	e8 f5 1b 00 00       	call   80102c40 <begin_op>
      ilock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
80101051:	e8 ba 05 00 00       	call   80101610 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101056:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101059:	53                   	push   %ebx
8010105a:	ff 76 14             	pushl  0x14(%esi)
8010105d:	01 f8                	add    %edi,%eax
8010105f:	50                   	push   %eax
80101060:	ff 76 10             	pushl  0x10(%esi)
80101063:	e8 c8 09 00 00       	call   80101a30 <writei>
80101068:	83 c4 20             	add    $0x20,%esp
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 99                	jg     80101008 <filewrite+0x48>
      iunlock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 76 10             	pushl  0x10(%esi)
80101075:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101078:	e8 a3 06 00 00       	call   80101720 <iunlock>
      end_op();
8010107d:	e8 2e 1c 00 00       	call   80102cb0 <end_op>
      if(r < 0)
80101082:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101085:	83 c4 10             	add    $0x10,%esp
80101088:	85 c0                	test   %eax,%eax
8010108a:	74 98                	je     80101024 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010108f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101094:	89 f8                	mov    %edi,%eax
80101096:	5b                   	pop    %ebx
80101097:	5e                   	pop    %esi
80101098:	5f                   	pop    %edi
80101099:	5d                   	pop    %ebp
8010109a:	c3                   	ret    
8010109b:	90                   	nop
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010a0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010a3:	75 e7                	jne    8010108c <filewrite+0xcc>
}
801010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a8:	89 f8                	mov    %edi,%eax
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
801010af:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010b0:	8b 46 0c             	mov    0xc(%esi),%eax
801010b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b9:	5b                   	pop    %ebx
801010ba:	5e                   	pop    %esi
801010bb:	5f                   	pop    %edi
801010bc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010bd:	e9 ce 24 00 00       	jmp    80103590 <pipewrite>
        panic("short filewrite");
801010c2:	83 ec 0c             	sub    $0xc,%esp
801010c5:	68 87 75 10 80       	push   $0x80107587
801010ca:	e8 a1 f2 ff ff       	call   80100370 <panic>
  panic("filewrite");
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	68 8d 75 10 80       	push   $0x8010758d
801010d7:	e8 94 f2 ff ff       	call   80100370 <panic>
801010dc:	66 90                	xchg   %ax,%ax
801010de:	66 90                	xchg   %ax,%ax

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010e9:	8b 0d a0 01 11 80    	mov    0x801101a0,%ecx
{
801010ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010f2:	85 c9                	test   %ecx,%ecx
801010f4:	0f 84 87 00 00 00    	je     80101181 <balloc+0xa1>
801010fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101101:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101104:	83 ec 08             	sub    $0x8,%esp
80101107:	89 f0                	mov    %esi,%eax
80101109:	c1 f8 0c             	sar    $0xc,%eax
8010110c:	03 05 b8 01 11 80    	add    0x801101b8,%eax
80101112:	50                   	push   %eax
80101113:	ff 75 d8             	pushl  -0x28(%ebp)
80101116:	e8 a5 ef ff ff       	call   801000c0 <bread>
8010111b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010111e:	a1 a0 01 11 80       	mov    0x801101a0,%eax
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101129:	31 c0                	xor    %eax,%eax
8010112b:	eb 2f                	jmp    8010115c <balloc+0x7c>
8010112d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101130:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101132:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101135:	bb 01 00 00 00       	mov    $0x1,%ebx
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010113f:	89 c1                	mov    %eax,%ecx
80101141:	c1 f9 03             	sar    $0x3,%ecx
80101144:	0f b6 7c 0a 18       	movzbl 0x18(%edx,%ecx,1),%edi
80101149:	85 df                	test   %ebx,%edi
8010114b:	89 fa                	mov    %edi,%edx
8010114d:	74 41                	je     80101190 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114f:	83 c0 01             	add    $0x1,%eax
80101152:	83 c6 01             	add    $0x1,%esi
80101155:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010115a:	74 05                	je     80101161 <balloc+0x81>
8010115c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010115f:	77 cf                	ja     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101161:	83 ec 0c             	sub    $0xc,%esp
80101164:	ff 75 e4             	pushl  -0x1c(%ebp)
80101167:	e8 64 f0 ff ff       	call   801001d0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010116c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101173:	83 c4 10             	add    $0x10,%esp
80101176:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101179:	39 05 a0 01 11 80    	cmp    %eax,0x801101a0
8010117f:	77 80                	ja     80101101 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101181:	83 ec 0c             	sub    $0xc,%esp
80101184:	68 97 75 10 80       	push   $0x80107597
80101189:	e8 e2 f1 ff ff       	call   80100370 <panic>
8010118e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101190:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101193:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101196:	09 da                	or     %ebx,%edx
80101198:	88 54 0f 18          	mov    %dl,0x18(%edi,%ecx,1)
        log_write(bp);
8010119c:	57                   	push   %edi
8010119d:	e8 6e 1c 00 00       	call   80102e10 <log_write>
        brelse(bp);
801011a2:	89 3c 24             	mov    %edi,(%esp)
801011a5:	e8 26 f0 ff ff       	call   801001d0 <brelse>
  bp = bread(dev, bno);
801011aa:	58                   	pop    %eax
801011ab:	5a                   	pop    %edx
801011ac:	56                   	push   %esi
801011ad:	ff 75 d8             	pushl  -0x28(%ebp)
801011b0:	e8 0b ef ff ff       	call   801000c0 <bread>
801011b5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011b7:	8d 40 18             	lea    0x18(%eax),%eax
801011ba:	83 c4 0c             	add    $0xc,%esp
801011bd:	68 00 02 00 00       	push   $0x200
801011c2:	6a 00                	push   $0x0
801011c4:	50                   	push   %eax
801011c5:	e8 f6 38 00 00       	call   80104ac0 <memset>
  log_write(bp);
801011ca:	89 1c 24             	mov    %ebx,(%esp)
801011cd:	e8 3e 1c 00 00       	call   80102e10 <log_write>
  brelse(bp);
801011d2:	89 1c 24             	mov    %ebx,(%esp)
801011d5:	e8 f6 ef ff ff       	call   801001d0 <brelse>
}
801011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011dd:	89 f0                	mov    %esi,%eax
801011df:	5b                   	pop    %ebx
801011e0:	5e                   	pop    %esi
801011e1:	5f                   	pop    %edi
801011e2:	5d                   	pop    %ebp
801011e3:	c3                   	ret    
801011e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011f8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011fa:	bb f4 01 11 80       	mov    $0x801101f4,%ebx
{
801011ff:	83 ec 28             	sub    $0x28,%esp
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101205:	68 c0 01 11 80       	push   $0x801101c0
8010120a:	e8 81 36 00 00       	call   80104890 <acquire>
8010120f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101215:	eb 14                	jmp    8010122b <iget+0x3b>
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101220:	83 c3 50             	add    $0x50,%ebx
80101223:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
80101229:	73 1f                	jae    8010124a <iget+0x5a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010122b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010122e:	85 c9                	test   %ecx,%ecx
80101230:	7e 04                	jle    80101236 <iget+0x46>
80101232:	39 3b                	cmp    %edi,(%ebx)
80101234:	74 4a                	je     80101280 <iget+0x90>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101236:	85 f6                	test   %esi,%esi
80101238:	75 e6                	jne    80101220 <iget+0x30>
8010123a:	85 c9                	test   %ecx,%ecx
8010123c:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123f:	83 c3 50             	add    $0x50,%ebx
80101242:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
80101248:	72 e1                	jb     8010122b <iget+0x3b>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010124a:	85 f6                	test   %esi,%esi
8010124c:	74 59                	je     801012a7 <iget+0xb7>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
8010124e:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101251:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101253:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101256:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
8010125d:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
80101264:	68 c0 01 11 80       	push   $0x801101c0
80101269:	e8 02 38 00 00       	call   80104a70 <release>

  return ip;
8010126e:	83 c4 10             	add    $0x10,%esp
}
80101271:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101274:	89 f0                	mov    %esi,%eax
80101276:	5b                   	pop    %ebx
80101277:	5e                   	pop    %esi
80101278:	5f                   	pop    %edi
80101279:	5d                   	pop    %ebp
8010127a:	c3                   	ret    
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101280:	39 53 04             	cmp    %edx,0x4(%ebx)
80101283:	75 b1                	jne    80101236 <iget+0x46>
      release(&icache.lock);
80101285:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101288:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010128b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010128d:	68 c0 01 11 80       	push   $0x801101c0
      ip->ref++;
80101292:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101295:	e8 d6 37 00 00       	call   80104a70 <release>
      return ip;
8010129a:	83 c4 10             	add    $0x10,%esp
}
8010129d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a0:	89 f0                	mov    %esi,%eax
801012a2:	5b                   	pop    %ebx
801012a3:	5e                   	pop    %esi
801012a4:	5f                   	pop    %edi
801012a5:	5d                   	pop    %ebp
801012a6:	c3                   	ret    
    panic("iget: no inodes");
801012a7:	83 ec 0c             	sub    $0xc,%esp
801012aa:	68 ad 75 10 80       	push   $0x801075ad
801012af:	e8 bc f0 ff ff       	call   80100370 <panic>
801012b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c6                	mov    %eax,%esi
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 5f 1c             	mov    0x1c(%edi),%ebx
801012d6:	85 db                	test   %ebx,%ebx
801012d8:	74 6e                	je     80101348 <bmap+0x88>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	89 d8                	mov    %ebx,%eax
801012df:	5b                   	pop    %ebx
801012e0:	5e                   	pop    %esi
801012e1:	5f                   	pop    %edi
801012e2:	5d                   	pop    %ebp
801012e3:	c3                   	ret    
801012e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801012e8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801012eb:	83 fb 7f             	cmp    $0x7f,%ebx
801012ee:	77 7e                	ja     8010136e <bmap+0xae>
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f0:	8b 50 4c             	mov    0x4c(%eax),%edx
801012f3:	8b 00                	mov    (%eax),%eax
801012f5:	85 d2                	test   %edx,%edx
801012f7:	74 67                	je     80101360 <bmap+0xa0>
    bp = bread(ip->dev, addr);
801012f9:	83 ec 08             	sub    $0x8,%esp
801012fc:	52                   	push   %edx
801012fd:	50                   	push   %eax
801012fe:	e8 bd ed ff ff       	call   801000c0 <bread>
    if((addr = a[bn]) == 0){
80101303:	8d 54 98 18          	lea    0x18(%eax,%ebx,4),%edx
80101307:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
8010130a:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010130c:	8b 1a                	mov    (%edx),%ebx
8010130e:	85 db                	test   %ebx,%ebx
80101310:	75 1d                	jne    8010132f <bmap+0x6f>
      a[bn] = addr = balloc(ip->dev);
80101312:	8b 06                	mov    (%esi),%eax
80101314:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101317:	e8 c4 fd ff ff       	call   801010e0 <balloc>
8010131c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010131f:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101322:	89 c3                	mov    %eax,%ebx
80101324:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101326:	57                   	push   %edi
80101327:	e8 e4 1a 00 00       	call   80102e10 <log_write>
8010132c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010132f:	83 ec 0c             	sub    $0xc,%esp
80101332:	57                   	push   %edi
80101333:	e8 98 ee ff ff       	call   801001d0 <brelse>
80101338:	83 c4 10             	add    $0x10,%esp
}
8010133b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133e:	89 d8                	mov    %ebx,%eax
80101340:	5b                   	pop    %ebx
80101341:	5e                   	pop    %esi
80101342:	5f                   	pop    %edi
80101343:	5d                   	pop    %ebp
80101344:	c3                   	ret    
80101345:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101348:	8b 00                	mov    (%eax),%eax
8010134a:	e8 91 fd ff ff       	call   801010e0 <balloc>
8010134f:	89 47 1c             	mov    %eax,0x1c(%edi)
}
80101352:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
80101355:	89 c3                	mov    %eax,%ebx
}
80101357:	89 d8                	mov    %ebx,%eax
80101359:	5b                   	pop    %ebx
8010135a:	5e                   	pop    %esi
8010135b:	5f                   	pop    %edi
8010135c:	5d                   	pop    %ebp
8010135d:	c3                   	ret    
8010135e:	66 90                	xchg   %ax,%ax
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101360:	e8 7b fd ff ff       	call   801010e0 <balloc>
80101365:	89 c2                	mov    %eax,%edx
80101367:	89 46 4c             	mov    %eax,0x4c(%esi)
8010136a:	8b 06                	mov    (%esi),%eax
8010136c:	eb 8b                	jmp    801012f9 <bmap+0x39>
  panic("bmap: out of range");
8010136e:	83 ec 0c             	sub    $0xc,%esp
80101371:	68 bd 75 10 80       	push   $0x801075bd
80101376:	e8 f5 ef ff ff       	call   80100370 <panic>
8010137b:	90                   	nop
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101380 <readsb>:
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	56                   	push   %esi
80101384:	53                   	push   %ebx
80101385:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101388:	83 ec 08             	sub    $0x8,%esp
8010138b:	6a 01                	push   $0x1
8010138d:	ff 75 08             	pushl  0x8(%ebp)
80101390:	e8 2b ed ff ff       	call   801000c0 <bread>
80101395:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101397:	8d 40 18             	lea    0x18(%eax),%eax
8010139a:	83 c4 0c             	add    $0xc,%esp
8010139d:	6a 1c                	push   $0x1c
8010139f:	50                   	push   %eax
801013a0:	56                   	push   %esi
801013a1:	e8 ca 37 00 00       	call   80104b70 <memmove>
  brelse(bp);
801013a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013a9:	83 c4 10             	add    $0x10,%esp
}
801013ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5d                   	pop    %ebp
  brelse(bp);
801013b2:	e9 19 ee ff ff       	jmp    801001d0 <brelse>
801013b7:	89 f6                	mov    %esi,%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013c0 <bfree>:
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	89 d3                	mov    %edx,%ebx
801013c7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801013c9:	83 ec 08             	sub    $0x8,%esp
801013cc:	68 a0 01 11 80       	push   $0x801101a0
801013d1:	50                   	push   %eax
801013d2:	e8 a9 ff ff ff       	call   80101380 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013d7:	58                   	pop    %eax
801013d8:	5a                   	pop    %edx
801013d9:	89 da                	mov    %ebx,%edx
801013db:	c1 ea 0c             	shr    $0xc,%edx
801013de:	03 15 b8 01 11 80    	add    0x801101b8,%edx
801013e4:	52                   	push   %edx
801013e5:	56                   	push   %esi
801013e6:	e8 d5 ec ff ff       	call   801000c0 <bread>
  m = 1 << (bi % 8);
801013eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801013f0:	ba 01 00 00 00       	mov    $0x1,%edx
801013f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801013f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801013fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101401:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101403:	0f b6 4c 18 18       	movzbl 0x18(%eax,%ebx,1),%ecx
80101408:	85 d1                	test   %edx,%ecx
8010140a:	74 25                	je     80101431 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010140c:	f7 d2                	not    %edx
8010140e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101410:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101413:	21 ca                	and    %ecx,%edx
80101415:	88 54 1e 18          	mov    %dl,0x18(%esi,%ebx,1)
  log_write(bp);
80101419:	56                   	push   %esi
8010141a:	e8 f1 19 00 00       	call   80102e10 <log_write>
  brelse(bp);
8010141f:	89 34 24             	mov    %esi,(%esp)
80101422:	e8 a9 ed ff ff       	call   801001d0 <brelse>
}
80101427:	83 c4 10             	add    $0x10,%esp
8010142a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010142d:	5b                   	pop    %ebx
8010142e:	5e                   	pop    %esi
8010142f:	5d                   	pop    %ebp
80101430:	c3                   	ret    
    panic("freeing free block");
80101431:	83 ec 0c             	sub    $0xc,%esp
80101434:	68 d0 75 10 80       	push   $0x801075d0
80101439:	e8 32 ef ff ff       	call   80100370 <panic>
8010143e:	66 90                	xchg   %ax,%ax

80101440 <iinit>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	83 ec 10             	sub    $0x10,%esp
  initlock(&icache.lock, "icache");
80101446:	68 e3 75 10 80       	push   $0x801075e3
8010144b:	68 c0 01 11 80       	push   $0x801101c0
80101450:	e8 1b 34 00 00       	call   80104870 <initlock>
  readsb(dev, &sb);
80101455:	58                   	pop    %eax
80101456:	5a                   	pop    %edx
80101457:	68 a0 01 11 80       	push   $0x801101a0
8010145c:	ff 75 08             	pushl  0x8(%ebp)
8010145f:	e8 1c ff ff ff       	call   80101380 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101464:	ff 35 b8 01 11 80    	pushl  0x801101b8
8010146a:	ff 35 b4 01 11 80    	pushl  0x801101b4
80101470:	ff 35 b0 01 11 80    	pushl  0x801101b0
80101476:	ff 35 ac 01 11 80    	pushl  0x801101ac
8010147c:	ff 35 a8 01 11 80    	pushl  0x801101a8
80101482:	ff 35 a4 01 11 80    	pushl  0x801101a4
80101488:	ff 35 a0 01 11 80    	pushl  0x801101a0
8010148e:	68 44 76 10 80       	push   $0x80107644
80101493:	e8 a8 f1 ff ff       	call   80100640 <cprintf>
}
80101498:	83 c4 30             	add    $0x30,%esp
8010149b:	c9                   	leave  
8010149c:	c3                   	ret    
8010149d:	8d 76 00             	lea    0x0(%esi),%esi

801014a0 <ialloc>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	53                   	push   %ebx
801014a6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801014a9:	83 3d a8 01 11 80 01 	cmpl   $0x1,0x801101a8
{
801014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014b3:	8b 75 08             	mov    0x8(%ebp),%esi
801014b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801014b9:	0f 86 91 00 00 00    	jbe    80101550 <ialloc+0xb0>
801014bf:	bb 01 00 00 00       	mov    $0x1,%ebx
801014c4:	eb 21                	jmp    801014e7 <ialloc+0x47>
801014c6:	8d 76 00             	lea    0x0(%esi),%esi
801014c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801014d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801014d3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801014d6:	57                   	push   %edi
801014d7:	e8 f4 ec ff ff       	call   801001d0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801014dc:	83 c4 10             	add    $0x10,%esp
801014df:	39 1d a8 01 11 80    	cmp    %ebx,0x801101a8
801014e5:	76 69                	jbe    80101550 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801014e7:	89 d8                	mov    %ebx,%eax
801014e9:	83 ec 08             	sub    $0x8,%esp
801014ec:	c1 e8 03             	shr    $0x3,%eax
801014ef:	03 05 b4 01 11 80    	add    0x801101b4,%eax
801014f5:	50                   	push   %eax
801014f6:	56                   	push   %esi
801014f7:	e8 c4 eb ff ff       	call   801000c0 <bread>
801014fc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801014fe:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101500:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101503:	83 e0 07             	and    $0x7,%eax
80101506:	c1 e0 06             	shl    $0x6,%eax
80101509:	8d 4c 07 18          	lea    0x18(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010150d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101511:	75 bd                	jne    801014d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101513:	83 ec 04             	sub    $0x4,%esp
80101516:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101519:	6a 40                	push   $0x40
8010151b:	6a 00                	push   $0x0
8010151d:	51                   	push   %ecx
8010151e:	e8 9d 35 00 00       	call   80104ac0 <memset>
      dip->type = type;
80101523:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101527:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010152a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010152d:	89 3c 24             	mov    %edi,(%esp)
80101530:	e8 db 18 00 00       	call   80102e10 <log_write>
      brelse(bp);
80101535:	89 3c 24             	mov    %edi,(%esp)
80101538:	e8 93 ec ff ff       	call   801001d0 <brelse>
      return iget(dev, inum);
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101543:	89 da                	mov    %ebx,%edx
80101545:	89 f0                	mov    %esi,%eax
}
80101547:	5b                   	pop    %ebx
80101548:	5e                   	pop    %esi
80101549:	5f                   	pop    %edi
8010154a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010154b:	e9 a0 fc ff ff       	jmp    801011f0 <iget>
  panic("ialloc: no inodes");
80101550:	83 ec 0c             	sub    $0xc,%esp
80101553:	68 ea 75 10 80       	push   $0x801075ea
80101558:	e8 13 ee ff ff       	call   80100370 <panic>
8010155d:	8d 76 00             	lea    0x0(%esi),%esi

80101560 <iupdate>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	56                   	push   %esi
80101564:	53                   	push   %ebx
80101565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010156e:	83 c3 1c             	add    $0x1c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101571:	c1 e8 03             	shr    $0x3,%eax
80101574:	03 05 b4 01 11 80    	add    0x801101b4,%eax
8010157a:	50                   	push   %eax
8010157b:	ff 73 e4             	pushl  -0x1c(%ebx)
8010157e:	e8 3d eb ff ff       	call   801000c0 <bread>
80101583:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101585:	8b 43 e8             	mov    -0x18(%ebx),%eax
  dip->type = ip->type;
80101588:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010158c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010158f:	83 e0 07             	and    $0x7,%eax
80101592:	c1 e0 06             	shl    $0x6,%eax
80101595:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
80101599:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010159c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015a0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801015a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015bd:	6a 34                	push   $0x34
801015bf:	53                   	push   %ebx
801015c0:	50                   	push   %eax
801015c1:	e8 aa 35 00 00       	call   80104b70 <memmove>
  log_write(bp);
801015c6:	89 34 24             	mov    %esi,(%esp)
801015c9:	e8 42 18 00 00       	call   80102e10 <log_write>
  brelse(bp);
801015ce:	89 75 08             	mov    %esi,0x8(%ebp)
801015d1:	83 c4 10             	add    $0x10,%esp
}
801015d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015d7:	5b                   	pop    %ebx
801015d8:	5e                   	pop    %esi
801015d9:	5d                   	pop    %ebp
  brelse(bp);
801015da:	e9 f1 eb ff ff       	jmp    801001d0 <brelse>
801015df:	90                   	nop

801015e0 <idup>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	53                   	push   %ebx
801015e4:	83 ec 10             	sub    $0x10,%esp
801015e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015ea:	68 c0 01 11 80       	push   $0x801101c0
801015ef:	e8 9c 32 00 00       	call   80104890 <acquire>
  ip->ref++;
801015f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801015f8:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
801015ff:	e8 6c 34 00 00       	call   80104a70 <release>
}
80101604:	89 d8                	mov    %ebx,%eax
80101606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101609:	c9                   	leave  
8010160a:	c3                   	ret    
8010160b:	90                   	nop
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ilock>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101618:	85 db                	test   %ebx,%ebx
8010161a:	0f 84 e8 00 00 00    	je     80101708 <ilock+0xf8>
80101620:	8b 43 08             	mov    0x8(%ebx),%eax
80101623:	85 c0                	test   %eax,%eax
80101625:	0f 8e dd 00 00 00    	jle    80101708 <ilock+0xf8>
  acquire(&icache.lock);
8010162b:	83 ec 0c             	sub    $0xc,%esp
8010162e:	68 c0 01 11 80       	push   $0x801101c0
80101633:	e8 58 32 00 00       	call   80104890 <acquire>
  while(ip->flags & I_BUSY)
80101638:	8b 43 0c             	mov    0xc(%ebx),%eax
8010163b:	83 c4 10             	add    $0x10,%esp
8010163e:	a8 01                	test   $0x1,%al
80101640:	74 1e                	je     80101660 <ilock+0x50>
80101642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(ip, &icache.lock);
80101648:	83 ec 08             	sub    $0x8,%esp
8010164b:	68 c0 01 11 80       	push   $0x801101c0
80101650:	53                   	push   %ebx
80101651:	e8 3a 28 00 00       	call   80103e90 <sleep>
  while(ip->flags & I_BUSY)
80101656:	8b 43 0c             	mov    0xc(%ebx),%eax
80101659:	83 c4 10             	add    $0x10,%esp
8010165c:	a8 01                	test   $0x1,%al
8010165e:	75 e8                	jne    80101648 <ilock+0x38>
  release(&icache.lock);
80101660:	83 ec 0c             	sub    $0xc,%esp
  ip->flags |= I_BUSY;
80101663:	83 c8 01             	or     $0x1,%eax
80101666:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
80101669:	68 c0 01 11 80       	push   $0x801101c0
8010166e:	e8 fd 33 00 00       	call   80104a70 <release>
  if(!(ip->flags & I_VALID)){
80101673:	83 c4 10             	add    $0x10,%esp
80101676:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
8010167a:	74 0c                	je     80101688 <ilock+0x78>
}
8010167c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010167f:	5b                   	pop    %ebx
80101680:	5e                   	pop    %esi
80101681:	5d                   	pop    %ebp
80101682:	c3                   	ret    
80101683:	90                   	nop
80101684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101688:	8b 43 04             	mov    0x4(%ebx),%eax
8010168b:	83 ec 08             	sub    $0x8,%esp
8010168e:	c1 e8 03             	shr    $0x3,%eax
80101691:	03 05 b4 01 11 80    	add    0x801101b4,%eax
80101697:	50                   	push   %eax
80101698:	ff 33                	pushl  (%ebx)
8010169a:	e8 21 ea ff ff       	call   801000c0 <bread>
8010169f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016a1:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016a4:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016a7:	83 e0 07             	and    $0x7,%eax
801016aa:	c1 e0 06             	shl    $0x6,%eax
801016ad:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
801016b1:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016b4:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016b7:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
801016bb:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016bf:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
801016c3:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016c7:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
801016cb:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016cf:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
801016d3:	8b 50 fc             	mov    -0x4(%eax),%edx
801016d6:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016d9:	6a 34                	push   $0x34
801016db:	50                   	push   %eax
801016dc:	8d 43 1c             	lea    0x1c(%ebx),%eax
801016df:	50                   	push   %eax
801016e0:	e8 8b 34 00 00       	call   80104b70 <memmove>
    brelse(bp);
801016e5:	89 34 24             	mov    %esi,(%esp)
801016e8:	e8 e3 ea ff ff       	call   801001d0 <brelse>
    ip->flags |= I_VALID;
801016ed:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
801016f1:	83 c4 10             	add    $0x10,%esp
801016f4:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
801016f9:	75 81                	jne    8010167c <ilock+0x6c>
      panic("ilock: no type");
801016fb:	83 ec 0c             	sub    $0xc,%esp
801016fe:	68 02 76 10 80       	push   $0x80107602
80101703:	e8 68 ec ff ff       	call   80100370 <panic>
    panic("ilock");
80101708:	83 ec 0c             	sub    $0xc,%esp
8010170b:	68 fc 75 10 80       	push   $0x801075fc
80101710:	e8 5b ec ff ff       	call   80100370 <panic>
80101715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101720 <iunlock>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	53                   	push   %ebx
80101724:	83 ec 04             	sub    $0x4,%esp
80101727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
8010172a:	85 db                	test   %ebx,%ebx
8010172c:	74 39                	je     80101767 <iunlock+0x47>
8010172e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
80101732:	74 33                	je     80101767 <iunlock+0x47>
80101734:	8b 43 08             	mov    0x8(%ebx),%eax
80101737:	85 c0                	test   %eax,%eax
80101739:	7e 2c                	jle    80101767 <iunlock+0x47>
  acquire(&icache.lock);
8010173b:	83 ec 0c             	sub    $0xc,%esp
8010173e:	68 c0 01 11 80       	push   $0x801101c0
80101743:	e8 48 31 00 00       	call   80104890 <acquire>
  ip->flags &= ~I_BUSY;
80101748:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
8010174c:	89 1c 24             	mov    %ebx,(%esp)
8010174f:	e8 2c 29 00 00       	call   80104080 <wakeup>
  release(&icache.lock);
80101754:	83 c4 10             	add    $0x10,%esp
80101757:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010175e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101761:	c9                   	leave  
  release(&icache.lock);
80101762:	e9 09 33 00 00       	jmp    80104a70 <release>
    panic("iunlock");
80101767:	83 ec 0c             	sub    $0xc,%esp
8010176a:	68 11 76 10 80       	push   $0x80107611
8010176f:	e8 fc eb ff ff       	call   80100370 <panic>
80101774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010177a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101780 <iput>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	53                   	push   %ebx
80101786:	83 ec 28             	sub    $0x28,%esp
80101789:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010178c:	68 c0 01 11 80       	push   $0x801101c0
80101791:	e8 fa 30 00 00       	call   80104890 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101796:	8b 46 08             	mov    0x8(%esi),%eax
80101799:	83 c4 10             	add    $0x10,%esp
8010179c:	83 f8 01             	cmp    $0x1,%eax
8010179f:	0f 85 ab 00 00 00    	jne    80101850 <iput+0xd0>
801017a5:	8b 56 0c             	mov    0xc(%esi),%edx
801017a8:	f6 c2 02             	test   $0x2,%dl
801017ab:	0f 84 9f 00 00 00    	je     80101850 <iput+0xd0>
801017b1:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
801017b6:	0f 85 94 00 00 00    	jne    80101850 <iput+0xd0>
    if(ip->flags & I_BUSY)
801017bc:	f6 c2 01             	test   $0x1,%dl
801017bf:	0f 85 05 01 00 00    	jne    801018ca <iput+0x14a>
    release(&icache.lock);
801017c5:	83 ec 0c             	sub    $0xc,%esp
    ip->flags |= I_BUSY;
801017c8:	83 ca 01             	or     $0x1,%edx
801017cb:	8d 5e 1c             	lea    0x1c(%esi),%ebx
801017ce:	89 56 0c             	mov    %edx,0xc(%esi)
    release(&icache.lock);
801017d1:	68 c0 01 11 80       	push   $0x801101c0
801017d6:	8d 7e 4c             	lea    0x4c(%esi),%edi
801017d9:	e8 92 32 00 00       	call   80104a70 <release>
801017de:	83 c4 10             	add    $0x10,%esp
801017e1:	eb 0c                	jmp    801017ef <iput+0x6f>
801017e3:	90                   	nop
801017e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017e8:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017eb:	39 fb                	cmp    %edi,%ebx
801017ed:	74 1b                	je     8010180a <iput+0x8a>
    if(ip->addrs[i]){
801017ef:	8b 13                	mov    (%ebx),%edx
801017f1:	85 d2                	test   %edx,%edx
801017f3:	74 f3                	je     801017e8 <iput+0x68>
      bfree(ip->dev, ip->addrs[i]);
801017f5:	8b 06                	mov    (%esi),%eax
801017f7:	83 c3 04             	add    $0x4,%ebx
801017fa:	e8 c1 fb ff ff       	call   801013c0 <bfree>
      ip->addrs[i] = 0;
801017ff:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
  for(i = 0; i < NDIRECT; i++){
80101806:	39 fb                	cmp    %edi,%ebx
80101808:	75 e5                	jne    801017ef <iput+0x6f>
    }
  }

  if(ip->addrs[NDIRECT]){
8010180a:	8b 46 4c             	mov    0x4c(%esi),%eax
8010180d:	85 c0                	test   %eax,%eax
8010180f:	75 5f                	jne    80101870 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101811:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101814:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
8010181b:	56                   	push   %esi
8010181c:	e8 3f fd ff ff       	call   80101560 <iupdate>
    ip->type = 0;
80101821:	31 c0                	xor    %eax,%eax
80101823:	66 89 46 10          	mov    %ax,0x10(%esi)
    iupdate(ip);
80101827:	89 34 24             	mov    %esi,(%esp)
8010182a:	e8 31 fd ff ff       	call   80101560 <iupdate>
    acquire(&icache.lock);
8010182f:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101836:	e8 55 30 00 00       	call   80104890 <acquire>
    ip->flags = 0;
8010183b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
80101842:	89 34 24             	mov    %esi,(%esp)
80101845:	e8 36 28 00 00       	call   80104080 <wakeup>
8010184a:	8b 46 08             	mov    0x8(%esi),%eax
8010184d:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101850:	83 e8 01             	sub    $0x1,%eax
80101853:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101856:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010185d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101860:	5b                   	pop    %ebx
80101861:	5e                   	pop    %esi
80101862:	5f                   	pop    %edi
80101863:	5d                   	pop    %ebp
  release(&icache.lock);
80101864:	e9 07 32 00 00       	jmp    80104a70 <release>
80101869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101870:	83 ec 08             	sub    $0x8,%esp
80101873:	50                   	push   %eax
80101874:	ff 36                	pushl  (%esi)
80101876:	e8 45 e8 ff ff       	call   801000c0 <bread>
8010187b:	83 c4 10             	add    $0x10,%esp
8010187e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101881:	8d 58 18             	lea    0x18(%eax),%ebx
80101884:	8d b8 18 02 00 00    	lea    0x218(%eax),%edi
8010188a:	eb 0b                	jmp    80101897 <iput+0x117>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101890:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101893:	39 df                	cmp    %ebx,%edi
80101895:	74 0f                	je     801018a6 <iput+0x126>
      if(a[j])
80101897:	8b 13                	mov    (%ebx),%edx
80101899:	85 d2                	test   %edx,%edx
8010189b:	74 f3                	je     80101890 <iput+0x110>
        bfree(ip->dev, a[j]);
8010189d:	8b 06                	mov    (%esi),%eax
8010189f:	e8 1c fb ff ff       	call   801013c0 <bfree>
801018a4:	eb ea                	jmp    80101890 <iput+0x110>
    brelse(bp);
801018a6:	83 ec 0c             	sub    $0xc,%esp
801018a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801018ac:	e8 1f e9 ff ff       	call   801001d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018b1:	8b 56 4c             	mov    0x4c(%esi),%edx
801018b4:	8b 06                	mov    (%esi),%eax
801018b6:	e8 05 fb ff ff       	call   801013c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	e9 47 ff ff ff       	jmp    80101811 <iput+0x91>
      panic("iput busy");
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	68 19 76 10 80       	push   $0x80107619
801018d2:	e8 99 ea ff ff       	call   80100370 <panic>
801018d7:	89 f6                	mov    %esi,%esi
801018d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018e0 <iunlockput>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	53                   	push   %ebx
801018e4:	83 ec 10             	sub    $0x10,%esp
801018e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018ea:	53                   	push   %ebx
801018eb:	e8 30 fe ff ff       	call   80101720 <iunlock>
  iput(ip);
801018f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018f3:	83 c4 10             	add    $0x10,%esp
}
801018f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018f9:	c9                   	leave  
  iput(ip);
801018fa:	e9 81 fe ff ff       	jmp    80101780 <iput>
801018ff:	90                   	nop

80101900 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	8b 55 08             	mov    0x8(%ebp),%edx
80101906:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101909:	8b 0a                	mov    (%edx),%ecx
8010190b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010190e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101911:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101914:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
80101918:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010191b:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
8010191f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101923:	8b 52 18             	mov    0x18(%edx),%edx
80101926:	89 50 10             	mov    %edx,0x10(%eax)
}
80101929:	5d                   	pop    %ebp
8010192a:	c3                   	ret    
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 1c             	sub    $0x1c,%esp
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010193f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101942:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
{
80101947:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010194a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010194d:	8b 75 10             	mov    0x10(%ebp),%esi
80101950:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101953:	0f 84 a7 00 00 00    	je     80101a00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101959:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010195c:	8b 40 18             	mov    0x18(%eax),%eax
8010195f:	39 c6                	cmp    %eax,%esi
80101961:	0f 87 ba 00 00 00    	ja     80101a21 <readi+0xf1>
80101967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010196a:	89 f9                	mov    %edi,%ecx
8010196c:	01 f1                	add    %esi,%ecx
8010196e:	0f 82 ad 00 00 00    	jb     80101a21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101974:	89 c2                	mov    %eax,%edx
80101976:	29 f2                	sub    %esi,%edx
80101978:	39 c8                	cmp    %ecx,%eax
8010197a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010197d:	31 ff                	xor    %edi,%edi
8010197f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101981:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101984:	74 6c                	je     801019f2 <readi+0xc2>
80101986:	8d 76 00             	lea    0x0(%esi),%esi
80101989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101990:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101993:	89 f2                	mov    %esi,%edx
80101995:	c1 ea 09             	shr    $0x9,%edx
80101998:	89 d8                	mov    %ebx,%eax
8010199a:	e8 21 f9 ff ff       	call   801012c0 <bmap>
8010199f:	83 ec 08             	sub    $0x8,%esp
801019a2:	50                   	push   %eax
801019a3:	ff 33                	pushl  (%ebx)
801019a5:	e8 16 e7 ff ff       	call   801000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ad:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019af:	89 f0                	mov    %esi,%eax
801019b1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019b6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019bb:	83 c4 0c             	add    $0xc,%esp
801019be:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019c0:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
801019c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019c7:	29 fb                	sub    %edi,%ebx
801019c9:	39 d9                	cmp    %ebx,%ecx
801019cb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ce:	53                   	push   %ebx
801019cf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
801019d2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801019d7:	e8 94 31 00 00       	call   80104b70 <memmove>
    brelse(bp);
801019dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019df:	89 14 24             	mov    %edx,(%esp)
801019e2:	e8 e9 e7 ff ff       	call   801001d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019ea:	83 c4 10             	add    $0x10,%esp
801019ed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019f0:	77 9e                	ja     80101990 <readi+0x60>
  }
  return n;
801019f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019f8:	5b                   	pop    %ebx
801019f9:	5e                   	pop    %esi
801019fa:	5f                   	pop    %edi
801019fb:	5d                   	pop    %ebp
801019fc:	c3                   	ret    
801019fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a00:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101a04:	66 83 f8 09          	cmp    $0x9,%ax
80101a08:	77 17                	ja     80101a21 <readi+0xf1>
80101a0a:	8b 04 c5 40 01 11 80 	mov    -0x7feefec0(,%eax,8),%eax
80101a11:	85 c0                	test   %eax,%eax
80101a13:	74 0c                	je     80101a21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a1b:	5b                   	pop    %ebx
80101a1c:	5e                   	pop    %esi
80101a1d:	5f                   	pop    %edi
80101a1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a1f:	ff e0                	jmp    *%eax
      return -1;
80101a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a26:	eb cd                	jmp    801019f5 <readi+0xc5>
80101a28:	90                   	nop
80101a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a30 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 1c             	sub    $0x1c,%esp
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a42:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
{
80101a47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a50:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a53:	0f 84 b7 00 00 00    	je     80101b10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a5c:	39 70 18             	cmp    %esi,0x18(%eax)
80101a5f:	0f 82 eb 00 00 00    	jb     80101b50 <writei+0x120>
80101a65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a68:	31 d2                	xor    %edx,%edx
80101a6a:	89 f8                	mov    %edi,%eax
80101a6c:	01 f0                	add    %esi,%eax
80101a6e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a71:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a76:	0f 87 d4 00 00 00    	ja     80101b50 <writei+0x120>
80101a7c:	85 d2                	test   %edx,%edx
80101a7e:	0f 85 cc 00 00 00    	jne    80101b50 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a84:	85 ff                	test   %edi,%edi
80101a86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a8d:	74 72                	je     80101b01 <writei+0xd1>
80101a8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a93:	89 f2                	mov    %esi,%edx
80101a95:	c1 ea 09             	shr    $0x9,%edx
80101a98:	89 f8                	mov    %edi,%eax
80101a9a:	e8 21 f8 ff ff       	call   801012c0 <bmap>
80101a9f:	83 ec 08             	sub    $0x8,%esp
80101aa2:	50                   	push   %eax
80101aa3:	ff 37                	pushl  (%edi)
80101aa5:	e8 16 e6 ff ff       	call   801000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aaa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aad:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab2:	89 f0                	mov    %esi,%eax
80101ab4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ab9:	83 c4 0c             	add    $0xc,%esp
80101abc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ac1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ac3:	8d 44 07 18          	lea    0x18(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac7:	39 d9                	cmp    %ebx,%ecx
80101ac9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101acc:	53                   	push   %ebx
80101acd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ad2:	50                   	push   %eax
80101ad3:	e8 98 30 00 00       	call   80104b70 <memmove>
    log_write(bp);
80101ad8:	89 3c 24             	mov    %edi,(%esp)
80101adb:	e8 30 13 00 00       	call   80102e10 <log_write>
    brelse(bp);
80101ae0:	89 3c 24             	mov    %edi,(%esp)
80101ae3:	e8 e8 e6 ff ff       	call   801001d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101aeb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aee:	83 c4 10             	add    $0x10,%esp
80101af1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101af4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101af7:	77 97                	ja     80101a90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101af9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afc:	3b 70 18             	cmp    0x18(%eax),%esi
80101aff:	77 37                	ja     80101b38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b07:	5b                   	pop    %ebx
80101b08:	5e                   	pop    %esi
80101b09:	5f                   	pop    %edi
80101b0a:	5d                   	pop    %ebp
80101b0b:	c3                   	ret    
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b10:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101b14:	66 83 f8 09          	cmp    $0x9,%ax
80101b18:	77 36                	ja     80101b50 <writei+0x120>
80101b1a:	8b 04 c5 44 01 11 80 	mov    -0x7feefebc(,%eax,8),%eax
80101b21:	85 c0                	test   %eax,%eax
80101b23:	74 2b                	je     80101b50 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2b:	5b                   	pop    %ebx
80101b2c:	5e                   	pop    %esi
80101b2d:	5f                   	pop    %edi
80101b2e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b2f:	ff e0                	jmp    *%eax
80101b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b38:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b3b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b3e:	89 70 18             	mov    %esi,0x18(%eax)
    iupdate(ip);
80101b41:	50                   	push   %eax
80101b42:	e8 19 fa ff ff       	call   80101560 <iupdate>
80101b47:	83 c4 10             	add    $0x10,%esp
80101b4a:	eb b5                	jmp    80101b01 <writei+0xd1>
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b55:	eb ad                	jmp    80101b04 <writei+0xd4>
80101b57:	89 f6                	mov    %esi,%esi
80101b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b60 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b66:	6a 0e                	push   $0xe
80101b68:	ff 75 0c             	pushl  0xc(%ebp)
80101b6b:	ff 75 08             	pushl  0x8(%ebp)
80101b6e:	e8 6d 30 00 00       	call   80104be0 <strncmp>
}
80101b73:	c9                   	leave  
80101b74:	c3                   	ret    
80101b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	57                   	push   %edi
80101b84:	56                   	push   %esi
80101b85:	53                   	push   %ebx
80101b86:	83 ec 1c             	sub    $0x1c,%esp
80101b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b8c:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80101b91:	0f 85 85 00 00 00    	jne    80101c1c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b97:	8b 53 18             	mov    0x18(%ebx),%edx
80101b9a:	31 ff                	xor    %edi,%edi
80101b9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b9f:	85 d2                	test   %edx,%edx
80101ba1:	74 3e                	je     80101be1 <dirlookup+0x61>
80101ba3:	90                   	nop
80101ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ba8:	6a 10                	push   $0x10
80101baa:	57                   	push   %edi
80101bab:	56                   	push   %esi
80101bac:	53                   	push   %ebx
80101bad:	e8 7e fd ff ff       	call   80101930 <readi>
80101bb2:	83 c4 10             	add    $0x10,%esp
80101bb5:	83 f8 10             	cmp    $0x10,%eax
80101bb8:	75 55                	jne    80101c0f <dirlookup+0x8f>
      panic("dirlink read");
    if(de.inum == 0)
80101bba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bbf:	74 18                	je     80101bd9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bc1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bc4:	83 ec 04             	sub    $0x4,%esp
80101bc7:	6a 0e                	push   $0xe
80101bc9:	50                   	push   %eax
80101bca:	ff 75 0c             	pushl  0xc(%ebp)
80101bcd:	e8 0e 30 00 00       	call   80104be0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101bd2:	83 c4 10             	add    $0x10,%esp
80101bd5:	85 c0                	test   %eax,%eax
80101bd7:	74 17                	je     80101bf0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd9:	83 c7 10             	add    $0x10,%edi
80101bdc:	3b 7b 18             	cmp    0x18(%ebx),%edi
80101bdf:	72 c7                	jb     80101ba8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101be4:	31 c0                	xor    %eax,%eax
}
80101be6:	5b                   	pop    %ebx
80101be7:	5e                   	pop    %esi
80101be8:	5f                   	pop    %edi
80101be9:	5d                   	pop    %ebp
80101bea:	c3                   	ret    
80101beb:	90                   	nop
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101bf0:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf3:	85 c0                	test   %eax,%eax
80101bf5:	74 05                	je     80101bfc <dirlookup+0x7c>
        *poff = off;
80101bf7:	8b 45 10             	mov    0x10(%ebp),%eax
80101bfa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101bfc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c00:	8b 03                	mov    (%ebx),%eax
80101c02:	e8 e9 f5 ff ff       	call   801011f0 <iget>
}
80101c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0a:	5b                   	pop    %ebx
80101c0b:	5e                   	pop    %esi
80101c0c:	5f                   	pop    %edi
80101c0d:	5d                   	pop    %ebp
80101c0e:	c3                   	ret    
      panic("dirlink read");
80101c0f:	83 ec 0c             	sub    $0xc,%esp
80101c12:	68 35 76 10 80       	push   $0x80107635
80101c17:	e8 54 e7 ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
80101c1c:	83 ec 0c             	sub    $0xc,%esp
80101c1f:	68 23 76 10 80       	push   $0x80107623
80101c24:	e8 47 e7 ff ff       	call   80100370 <panic>
80101c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	89 cf                	mov    %ecx,%edi
80101c38:	89 c3                	mov    %eax,%ebx
80101c3a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c3d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c40:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c43:	0f 84 67 01 00 00    	je     80101db0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  acquire(&icache.lock);
80101c4f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(proc->cwd);
80101c52:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c55:	68 c0 01 11 80       	push   $0x801101c0
80101c5a:	e8 31 2c 00 00       	call   80104890 <acquire>
  ip->ref++;
80101c5f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c63:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101c6a:	e8 01 2e 00 00       	call   80104a70 <release>
80101c6f:	83 c4 10             	add    $0x10,%esp
80101c72:	eb 07                	jmp    80101c7b <namex+0x4b>
80101c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101c78:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101c7b:	0f b6 03             	movzbl (%ebx),%eax
80101c7e:	3c 2f                	cmp    $0x2f,%al
80101c80:	74 f6                	je     80101c78 <namex+0x48>
  if(*path == 0)
80101c82:	84 c0                	test   %al,%al
80101c84:	0f 84 ee 00 00 00    	je     80101d78 <namex+0x148>
  while(*path != '/' && *path != 0)
80101c8a:	0f b6 03             	movzbl (%ebx),%eax
80101c8d:	3c 2f                	cmp    $0x2f,%al
80101c8f:	0f 84 b3 00 00 00    	je     80101d48 <namex+0x118>
80101c95:	84 c0                	test   %al,%al
80101c97:	89 da                	mov    %ebx,%edx
80101c99:	75 09                	jne    80101ca4 <namex+0x74>
80101c9b:	e9 a8 00 00 00       	jmp    80101d48 <namex+0x118>
80101ca0:	84 c0                	test   %al,%al
80101ca2:	74 0a                	je     80101cae <namex+0x7e>
    path++;
80101ca4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ca7:	0f b6 02             	movzbl (%edx),%eax
80101caa:	3c 2f                	cmp    $0x2f,%al
80101cac:	75 f2                	jne    80101ca0 <namex+0x70>
80101cae:	89 d1                	mov    %edx,%ecx
80101cb0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cb2:	83 f9 0d             	cmp    $0xd,%ecx
80101cb5:	0f 8e 91 00 00 00    	jle    80101d4c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cbb:	83 ec 04             	sub    $0x4,%esp
80101cbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cc1:	6a 0e                	push   $0xe
80101cc3:	53                   	push   %ebx
80101cc4:	57                   	push   %edi
80101cc5:	e8 a6 2e 00 00       	call   80104b70 <memmove>
    path++;
80101cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ccd:	83 c4 10             	add    $0x10,%esp
    path++;
80101cd0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101cd2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cd5:	75 11                	jne    80101ce8 <namex+0xb8>
80101cd7:	89 f6                	mov    %esi,%esi
80101cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ce0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ce3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ce6:	74 f8                	je     80101ce0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ce8:	83 ec 0c             	sub    $0xc,%esp
80101ceb:	56                   	push   %esi
80101cec:	e8 1f f9 ff ff       	call   80101610 <ilock>
    if(ip->type != T_DIR){
80101cf1:	83 c4 10             	add    $0x10,%esp
80101cf4:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80101cf9:	0f 85 91 00 00 00    	jne    80101d90 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101cff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d02:	85 d2                	test   %edx,%edx
80101d04:	74 09                	je     80101d0f <namex+0xdf>
80101d06:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d09:	0f 84 b7 00 00 00    	je     80101dc6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d0f:	83 ec 04             	sub    $0x4,%esp
80101d12:	6a 00                	push   $0x0
80101d14:	57                   	push   %edi
80101d15:	56                   	push   %esi
80101d16:	e8 65 fe ff ff       	call   80101b80 <dirlookup>
80101d1b:	83 c4 10             	add    $0x10,%esp
80101d1e:	85 c0                	test   %eax,%eax
80101d20:	74 6e                	je     80101d90 <namex+0x160>
  iunlock(ip);
80101d22:	83 ec 0c             	sub    $0xc,%esp
80101d25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d28:	56                   	push   %esi
80101d29:	e8 f2 f9 ff ff       	call   80101720 <iunlock>
  iput(ip);
80101d2e:	89 34 24             	mov    %esi,(%esp)
80101d31:	e8 4a fa ff ff       	call   80101780 <iput>
80101d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d39:	83 c4 10             	add    $0x10,%esp
80101d3c:	89 c6                	mov    %eax,%esi
80101d3e:	e9 38 ff ff ff       	jmp    80101c7b <namex+0x4b>
80101d43:	90                   	nop
80101d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d48:	89 da                	mov    %ebx,%edx
80101d4a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d4c:	83 ec 04             	sub    $0x4,%esp
80101d4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d52:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d55:	51                   	push   %ecx
80101d56:	53                   	push   %ebx
80101d57:	57                   	push   %edi
80101d58:	e8 13 2e 00 00       	call   80104b70 <memmove>
    name[len] = 0;
80101d5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d60:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d63:	83 c4 10             	add    $0x10,%esp
80101d66:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d6a:	89 d3                	mov    %edx,%ebx
80101d6c:	e9 61 ff ff ff       	jmp    80101cd2 <namex+0xa2>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d7b:	85 c0                	test   %eax,%eax
80101d7d:	75 5d                	jne    80101ddc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d82:	89 f0                	mov    %esi,%eax
80101d84:	5b                   	pop    %ebx
80101d85:	5e                   	pop    %esi
80101d86:	5f                   	pop    %edi
80101d87:	5d                   	pop    %ebp
80101d88:	c3                   	ret    
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101d90:	83 ec 0c             	sub    $0xc,%esp
80101d93:	56                   	push   %esi
80101d94:	e8 87 f9 ff ff       	call   80101720 <iunlock>
  iput(ip);
80101d99:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101d9c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101d9e:	e8 dd f9 ff ff       	call   80101780 <iput>
      return 0;
80101da3:	83 c4 10             	add    $0x10,%esp
}
80101da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101da9:	89 f0                	mov    %esi,%eax
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
80101daf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101db0:	ba 01 00 00 00       	mov    $0x1,%edx
80101db5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dba:	e8 31 f4 ff ff       	call   801011f0 <iget>
80101dbf:	89 c6                	mov    %eax,%esi
80101dc1:	e9 b5 fe ff ff       	jmp    80101c7b <namex+0x4b>
      iunlock(ip);
80101dc6:	83 ec 0c             	sub    $0xc,%esp
80101dc9:	56                   	push   %esi
80101dca:	e8 51 f9 ff ff       	call   80101720 <iunlock>
      return ip;
80101dcf:	83 c4 10             	add    $0x10,%esp
}
80101dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd5:	89 f0                	mov    %esi,%eax
80101dd7:	5b                   	pop    %ebx
80101dd8:	5e                   	pop    %esi
80101dd9:	5f                   	pop    %edi
80101dda:	5d                   	pop    %ebp
80101ddb:	c3                   	ret    
    iput(ip);
80101ddc:	83 ec 0c             	sub    $0xc,%esp
80101ddf:	56                   	push   %esi
    return 0;
80101de0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101de2:	e8 99 f9 ff ff       	call   80101780 <iput>
    return 0;
80101de7:	83 c4 10             	add    $0x10,%esp
80101dea:	eb 93                	jmp    80101d7f <namex+0x14f>
80101dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlink>:
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 20             	sub    $0x20,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	6a 00                	push   $0x0
80101dfe:	ff 75 0c             	pushl  0xc(%ebp)
80101e01:	53                   	push   %ebx
80101e02:	e8 79 fd ff ff       	call   80101b80 <dirlookup>
80101e07:	83 c4 10             	add    $0x10,%esp
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	75 67                	jne    80101e75 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e0e:	8b 7b 18             	mov    0x18(%ebx),%edi
80101e11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e14:	85 ff                	test   %edi,%edi
80101e16:	74 29                	je     80101e41 <dirlink+0x51>
80101e18:	31 ff                	xor    %edi,%edi
80101e1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e1d:	eb 09                	jmp    80101e28 <dirlink+0x38>
80101e1f:	90                   	nop
80101e20:	83 c7 10             	add    $0x10,%edi
80101e23:	3b 7b 18             	cmp    0x18(%ebx),%edi
80101e26:	73 19                	jae    80101e41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e28:	6a 10                	push   $0x10
80101e2a:	57                   	push   %edi
80101e2b:	56                   	push   %esi
80101e2c:	53                   	push   %ebx
80101e2d:	e8 fe fa ff ff       	call   80101930 <readi>
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	83 f8 10             	cmp    $0x10,%eax
80101e38:	75 4e                	jne    80101e88 <dirlink+0x98>
    if(de.inum == 0)
80101e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e3f:	75 df                	jne    80101e20 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e44:	83 ec 04             	sub    $0x4,%esp
80101e47:	6a 0e                	push   $0xe
80101e49:	ff 75 0c             	pushl  0xc(%ebp)
80101e4c:	50                   	push   %eax
80101e4d:	e8 ee 2d 00 00       	call   80104c40 <strncpy>
  de.inum = inum;
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e55:	6a 10                	push   $0x10
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
  de.inum = inum;
80101e5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5e:	e8 cd fb ff ff       	call   80101a30 <writei>
80101e63:	83 c4 20             	add    $0x20,%esp
80101e66:	83 f8 10             	cmp    $0x10,%eax
80101e69:	75 2a                	jne    80101e95 <dirlink+0xa5>
  return 0;
80101e6b:	31 c0                	xor    %eax,%eax
}
80101e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
    iput(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	50                   	push   %eax
80101e79:	e8 02 f9 ff ff       	call   80101780 <iput>
    return -1;
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb e5                	jmp    80101e6d <dirlink+0x7d>
      panic("dirlink read");
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	68 35 76 10 80       	push   $0x80107635
80101e90:	e8 db e4 ff ff       	call   80100370 <panic>
    panic("dirlink");
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	68 8e 7c 10 80       	push   $0x80107c8e
80101e9d:	e8 ce e4 ff ff       	call   80100370 <panic>
80101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <namei>:

struct inode*
namei(char *path)
{
80101eb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb1:	31 d2                	xor    %edx,%edx
{
80101eb3:	89 e5                	mov    %esp,%ebp
80101eb5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ebe:	e8 6d fd ff ff       	call   80101c30 <namex>
}
80101ec3:	c9                   	leave  
80101ec4:	c3                   	ret    
80101ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ed0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ed0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ed1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101ed6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ede:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101edf:	e9 4c fd ff ff       	jmp    80101c30 <namex>
80101ee4:	66 90                	xchg   %ax,%ax
80101ee6:	66 90                	xchg   %ax,%ax
80101ee8:	66 90                	xchg   %ax,%ax
80101eea:	66 90                	xchg   %ax,%ax
80101eec:	66 90                	xchg   %ax,%ax
80101eee:	66 90                	xchg   %ax,%ax

80101ef0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	57                   	push   %edi
80101ef4:	56                   	push   %esi
80101ef5:	53                   	push   %ebx
80101ef6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101ef9:	85 c0                	test   %eax,%eax
80101efb:	0f 84 b4 00 00 00    	je     80101fb5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f01:	8b 58 08             	mov    0x8(%eax),%ebx
80101f04:	89 c6                	mov    %eax,%esi
80101f06:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f0c:	0f 87 96 00 00 00    	ja     80101fa8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f12:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f17:	89 f6                	mov    %esi,%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f20:	89 ca                	mov    %ecx,%edx
80101f22:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f23:	83 e0 c0             	and    $0xffffffc0,%eax
80101f26:	3c 40                	cmp    $0x40,%al
80101f28:	75 f6                	jne    80101f20 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f2a:	31 ff                	xor    %edi,%edi
80101f2c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f31:	89 f8                	mov    %edi,%eax
80101f33:	ee                   	out    %al,(%dx)
80101f34:	b8 01 00 00 00       	mov    $0x1,%eax
80101f39:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3e:	ee                   	out    %al,(%dx)
80101f3f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f44:	89 d8                	mov    %ebx,%eax
80101f46:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f47:	89 d8                	mov    %ebx,%eax
80101f49:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f4e:	c1 f8 08             	sar    $0x8,%eax
80101f51:	ee                   	out    %al,(%dx)
80101f52:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f57:	89 f8                	mov    %edi,%eax
80101f59:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f5a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f5e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f63:	c1 e0 04             	shl    $0x4,%eax
80101f66:	83 e0 10             	and    $0x10,%eax
80101f69:	83 c8 e0             	or     $0xffffffe0,%eax
80101f6c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f6d:	f6 06 04             	testb  $0x4,(%esi)
80101f70:	75 16                	jne    80101f88 <idestart+0x98>
80101f72:	b8 20 00 00 00       	mov    $0x20,%eax
80101f77:	89 ca                	mov    %ecx,%edx
80101f79:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7d:	5b                   	pop    %ebx
80101f7e:	5e                   	pop    %esi
80101f7f:	5f                   	pop    %edi
80101f80:	5d                   	pop    %ebp
80101f81:	c3                   	ret    
80101f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f88:	b8 30 00 00 00       	mov    $0x30,%eax
80101f8d:	89 ca                	mov    %ecx,%edx
80101f8f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101f90:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101f95:	83 c6 18             	add    $0x18,%esi
80101f98:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101f9d:	fc                   	cld    
80101f9e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa3:	5b                   	pop    %ebx
80101fa4:	5e                   	pop    %esi
80101fa5:	5f                   	pop    %edi
80101fa6:	5d                   	pop    %ebp
80101fa7:	c3                   	ret    
    panic("incorrect blockno");
80101fa8:	83 ec 0c             	sub    $0xc,%esp
80101fab:	68 a9 76 10 80       	push   $0x801076a9
80101fb0:	e8 bb e3 ff ff       	call   80100370 <panic>
    panic("idestart");
80101fb5:	83 ec 0c             	sub    $0xc,%esp
80101fb8:	68 a0 76 10 80       	push   $0x801076a0
80101fbd:	e8 ae e3 ff ff       	call   80100370 <panic>
80101fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101fd6:	68 bb 76 10 80       	push   $0x801076bb
80101fdb:	68 80 a5 10 80       	push   $0x8010a580
80101fe0:	e8 8b 28 00 00       	call   80104870 <initlock>
  picenable(IRQ_IDE);
80101fe5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101fec:	e8 1f 13 00 00       	call   80103310 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101ff1:	58                   	pop    %eax
80101ff2:	a1 c0 18 11 80       	mov    0x801118c0,%eax
80101ff7:	5a                   	pop    %edx
80101ff8:	83 e8 01             	sub    $0x1,%eax
80101ffb:	50                   	push   %eax
80101ffc:	6a 0e                	push   $0xe
80101ffe:	e8 bd 02 00 00       	call   801022c0 <ioapicenable>
80102003:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102006:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010200b:	90                   	nop
8010200c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102010:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102011:	83 e0 c0             	and    $0xffffffc0,%eax
80102014:	3c 40                	cmp    $0x40,%al
80102016:	75 f8                	jne    80102010 <ideinit+0x40>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102018:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010201d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102022:	ee                   	out    %al,(%dx)
80102023:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102028:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202d:	eb 06                	jmp    80102035 <ideinit+0x65>
8010202f:	90                   	nop
  for(i=0; i<1000; i++){
80102030:	83 e9 01             	sub    $0x1,%ecx
80102033:	74 0f                	je     80102044 <ideinit+0x74>
80102035:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102036:	84 c0                	test   %al,%al
80102038:	74 f6                	je     80102030 <ideinit+0x60>
      havedisk1 = 1;
8010203a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102041:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102044:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102049:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010204e:	ee                   	out    %al,(%dx)
}
8010204f:	c9                   	leave  
80102050:	c3                   	ret    
80102051:	eb 0d                	jmp    80102060 <ideintr>
80102053:	90                   	nop
80102054:	90                   	nop
80102055:	90                   	nop
80102056:	90                   	nop
80102057:	90                   	nop
80102058:	90                   	nop
80102059:	90                   	nop
8010205a:	90                   	nop
8010205b:	90                   	nop
8010205c:	90                   	nop
8010205d:	90                   	nop
8010205e:	90                   	nop
8010205f:	90                   	nop

80102060 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102069:	68 80 a5 10 80       	push   $0x8010a580
8010206e:	e8 1d 28 00 00       	call   80104890 <acquire>
  if((b = idequeue) == 0){
80102073:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	85 db                	test   %ebx,%ebx
8010207e:	74 67                	je     801020e7 <ideintr+0x87>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102080:	8b 43 14             	mov    0x14(%ebx),%eax
80102083:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102088:	8b 3b                	mov    (%ebx),%edi
8010208a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102090:	75 31                	jne    801020c3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102097:	89 f6                	mov    %esi,%esi
80102099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a1:	89 c6                	mov    %eax,%esi
801020a3:	83 e6 c0             	and    $0xffffffc0,%esi
801020a6:	89 f1                	mov    %esi,%ecx
801020a8:	80 f9 40             	cmp    $0x40,%cl
801020ab:	75 f3                	jne    801020a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020ad:	a8 21                	test   $0x21,%al
801020af:	75 12                	jne    801020c3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020b1:	8d 7b 18             	lea    0x18(%ebx),%edi
  asm volatile("cld; rep insl" :
801020b4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020b9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020be:	fc                   	cld    
801020bf:	f3 6d                	rep insl (%dx),%es:(%edi)
801020c1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020c3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020c6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020c9:	89 f9                	mov    %edi,%ecx
801020cb:	83 c9 02             	or     $0x2,%ecx
801020ce:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020d0:	53                   	push   %ebx
801020d1:	e8 aa 1f 00 00       	call   80104080 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020db:	83 c4 10             	add    $0x10,%esp
801020de:	85 c0                	test   %eax,%eax
801020e0:	74 05                	je     801020e7 <ideintr+0x87>
    idestart(idequeue);
801020e2:	e8 09 fe ff ff       	call   80101ef0 <idestart>
    release(&idelock);
801020e7:	83 ec 0c             	sub    $0xc,%esp
801020ea:	68 80 a5 10 80       	push   $0x8010a580
801020ef:	e8 7c 29 00 00       	call   80104a70 <release>

  release(&idelock);
}
801020f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f7:	5b                   	pop    %ebx
801020f8:	5e                   	pop    %esi
801020f9:	5f                   	pop    %edi
801020fa:	5d                   	pop    %ebp
801020fb:	c3                   	ret    
801020fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102100 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	53                   	push   %ebx
80102104:	83 ec 04             	sub    $0x4,%esp
80102107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010210a:	8b 03                	mov    (%ebx),%eax
8010210c:	a8 01                	test   $0x1,%al
8010210e:	0f 84 c0 00 00 00    	je     801021d4 <iderw+0xd4>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102114:	83 e0 06             	and    $0x6,%eax
80102117:	83 f8 02             	cmp    $0x2,%eax
8010211a:	0f 84 a7 00 00 00    	je     801021c7 <iderw+0xc7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102120:	8b 53 04             	mov    0x4(%ebx),%edx
80102123:	85 d2                	test   %edx,%edx
80102125:	74 0d                	je     80102134 <iderw+0x34>
80102127:	a1 60 a5 10 80       	mov    0x8010a560,%eax
8010212c:	85 c0                	test   %eax,%eax
8010212e:	0f 84 ad 00 00 00    	je     801021e1 <iderw+0xe1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102134:	83 ec 0c             	sub    $0xc,%esp
80102137:	68 80 a5 10 80       	push   $0x8010a580
8010213c:	e8 4f 27 00 00       	call   80104890 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102141:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102147:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
8010214a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102151:	85 d2                	test   %edx,%edx
80102153:	75 0d                	jne    80102162 <iderw+0x62>
80102155:	eb 69                	jmp    801021c0 <iderw+0xc0>
80102157:	89 f6                	mov    %esi,%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102160:	89 c2                	mov    %eax,%edx
80102162:	8b 42 14             	mov    0x14(%edx),%eax
80102165:	85 c0                	test   %eax,%eax
80102167:	75 f7                	jne    80102160 <iderw+0x60>
80102169:	83 c2 14             	add    $0x14,%edx
    ;
  *pp = b;
8010216c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010216e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102174:	74 3a                	je     801021b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102176:	8b 03                	mov    (%ebx),%eax
80102178:	83 e0 06             	and    $0x6,%eax
8010217b:	83 f8 02             	cmp    $0x2,%eax
8010217e:	74 1b                	je     8010219b <iderw+0x9b>
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 a5 10 80       	push   $0x8010a580
80102188:	53                   	push   %ebx
80102189:	e8 02 1d 00 00       	call   80103e90 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x80>
  }

  release(&idelock);
8010219b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  release(&idelock);
801021a6:	e9 c5 28 00 00       	jmp    80104a70 <release>
801021ab:	90                   	nop
801021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021b0:	89 d8                	mov    %ebx,%eax
801021b2:	e8 39 fd ff ff       	call   80101ef0 <idestart>
801021b7:	eb bd                	jmp    80102176 <iderw+0x76>
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021c0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021c5:	eb a5                	jmp    8010216c <iderw+0x6c>
    panic("iderw: nothing to do");
801021c7:	83 ec 0c             	sub    $0xc,%esp
801021ca:	68 d3 76 10 80       	push   $0x801076d3
801021cf:	e8 9c e1 ff ff       	call   80100370 <panic>
    panic("iderw: buf not busy");
801021d4:	83 ec 0c             	sub    $0xc,%esp
801021d7:	68 bf 76 10 80       	push   $0x801076bf
801021dc:	e8 8f e1 ff ff       	call   80100370 <panic>
    panic("iderw: ide disk 1 not present");
801021e1:	83 ec 0c             	sub    $0xc,%esp
801021e4:	68 e8 76 10 80       	push   $0x801076e8
801021e9:	e8 82 e1 ff ff       	call   80100370 <panic>
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021f0:	a1 c4 12 11 80       	mov    0x801112c4,%eax
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 b3 00 00 00    	je     801022b0 <ioapicinit+0xc0>
{
801021fd:	55                   	push   %ebp
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021fe:	c7 05 94 11 11 80 00 	movl   $0xfec00000,0x80111194
80102205:	00 c0 fe 
{
80102208:	89 e5                	mov    %esp,%ebp
8010220a:	56                   	push   %esi
8010220b:	53                   	push   %ebx
  ioapic->reg = reg;
8010220c:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102213:	00 00 00 
  return ioapic->data;
80102216:	a1 94 11 11 80       	mov    0x80111194,%eax
8010221b:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
8010221e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102224:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222a:	0f b6 15 c0 12 11 80 	movzbl 0x801112c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102231:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102234:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102237:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010223a:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
8010223d:	39 c2                	cmp    %eax,%edx
8010223f:	75 4f                	jne    80102290 <ioapicinit+0xa0>
80102241:	83 c3 21             	add    $0x21,%ebx
{
80102244:	ba 10 00 00 00       	mov    $0x10,%edx
80102249:	b8 20 00 00 00       	mov    $0x20,%eax
8010224e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102250:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102252:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102258:	89 c6                	mov    %eax,%esi
8010225a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102260:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102263:	89 71 10             	mov    %esi,0x10(%ecx)
80102266:	8d 72 01             	lea    0x1(%edx),%esi
80102269:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010226c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010226e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102270:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
80102276:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010227d:	75 d1                	jne    80102250 <ioapicinit+0x60>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010227f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102282:	5b                   	pop    %ebx
80102283:	5e                   	pop    %esi
80102284:	5d                   	pop    %ebp
80102285:	c3                   	ret    
80102286:	8d 76 00             	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102290:	83 ec 0c             	sub    $0xc,%esp
80102293:	68 08 77 10 80       	push   $0x80107708
80102298:	e8 a3 e3 ff ff       	call   80100640 <cprintf>
8010229d:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
801022a3:	83 c4 10             	add    $0x10,%esp
801022a6:	eb 99                	jmp    80102241 <ioapicinit+0x51>
801022a8:	90                   	nop
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022b0:	f3 c3                	repz ret 
801022b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022c0:	8b 15 c4 12 11 80    	mov    0x801112c4,%edx
{
801022c6:	55                   	push   %ebp
801022c7:	89 e5                	mov    %esp,%ebp
  if(!ismp)
801022c9:	85 d2                	test   %edx,%edx
{
801022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022ce:	74 2b                	je     801022fb <ioapicenable+0x3b>
  ioapic->reg = reg;
801022d0:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022d6:	8d 50 20             	lea    0x20(%eax),%edx
801022d9:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022dd:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022df:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022e8:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022ee:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f0:	a1 94 11 11 80       	mov    0x80111194,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f5:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022f8:	89 50 10             	mov    %edx,0x10(%eax)
}
801022fb:	5d                   	pop    %ebp
801022fc:	c3                   	ret    
801022fd:	66 90                	xchg   %ax,%ax
801022ff:	90                   	nop

80102300 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 04             	sub    $0x4,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010230a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102310:	75 70                	jne    80102382 <kfree+0x82>
80102312:	81 fb 68 45 11 80    	cmp    $0x80114568,%ebx
80102318:	72 68                	jb     80102382 <kfree+0x82>
8010231a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102320:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102325:	77 5b                	ja     80102382 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102327:	83 ec 04             	sub    $0x4,%esp
8010232a:	68 00 10 00 00       	push   $0x1000
8010232f:	6a 01                	push   $0x1
80102331:	53                   	push   %ebx
80102332:	e8 89 27 00 00       	call   80104ac0 <memset>

  if(kmem.use_lock)
80102337:	8b 15 d4 11 11 80    	mov    0x801111d4,%edx
8010233d:	83 c4 10             	add    $0x10,%esp
80102340:	85 d2                	test   %edx,%edx
80102342:	75 2c                	jne    80102370 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102344:	a1 d8 11 11 80       	mov    0x801111d8,%eax
80102349:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010234b:	a1 d4 11 11 80       	mov    0x801111d4,%eax
  kmem.freelist = r;
80102350:	89 1d d8 11 11 80    	mov    %ebx,0x801111d8
  if(kmem.use_lock)
80102356:	85 c0                	test   %eax,%eax
80102358:	75 06                	jne    80102360 <kfree+0x60>
    release(&kmem.lock);
}
8010235a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010235d:	c9                   	leave  
8010235e:	c3                   	ret    
8010235f:	90                   	nop
    release(&kmem.lock);
80102360:	c7 45 08 a0 11 11 80 	movl   $0x801111a0,0x8(%ebp)
}
80102367:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236a:	c9                   	leave  
    release(&kmem.lock);
8010236b:	e9 00 27 00 00       	jmp    80104a70 <release>
    acquire(&kmem.lock);
80102370:	83 ec 0c             	sub    $0xc,%esp
80102373:	68 a0 11 11 80       	push   $0x801111a0
80102378:	e8 13 25 00 00       	call   80104890 <acquire>
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	eb c2                	jmp    80102344 <kfree+0x44>
    panic("kfree");
80102382:	83 ec 0c             	sub    $0xc,%esp
80102385:	68 3a 77 10 80       	push   $0x8010773a
8010238a:	e8 e1 df ff ff       	call   80100370 <panic>
8010238f:	90                   	nop

80102390 <freerange>:
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102395:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102398:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010239b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ad:	39 de                	cmp    %ebx,%esi
801023af:	72 23                	jb     801023d4 <freerange+0x44>
801023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023be:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023c7:	50                   	push   %eax
801023c8:	e8 33 ff ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	39 f3                	cmp    %esi,%ebx
801023d2:	76 e4                	jbe    801023b8 <freerange+0x28>
}
801023d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023d7:	5b                   	pop    %ebx
801023d8:	5e                   	pop    %esi
801023d9:	5d                   	pop    %ebp
801023da:	c3                   	ret    
801023db:	90                   	nop
801023dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023e0 <kinit1>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023e8:	83 ec 08             	sub    $0x8,%esp
801023eb:	68 40 77 10 80       	push   $0x80107740
801023f0:	68 a0 11 11 80       	push   $0x801111a0
801023f5:	e8 76 24 00 00       	call   80104870 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102400:	c7 05 d4 11 11 80 00 	movl   $0x0,0x801111d4
80102407:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102410:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102416:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010241c:	39 de                	cmp    %ebx,%esi
8010241e:	72 1c                	jb     8010243c <kinit1+0x5c>
    kfree(p);
80102420:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102426:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102429:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010242f:	50                   	push   %eax
80102430:	e8 cb fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102435:	83 c4 10             	add    $0x10,%esp
80102438:	39 de                	cmp    %ebx,%esi
8010243a:	73 e4                	jae    80102420 <kinit1+0x40>
}
8010243c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010243f:	5b                   	pop    %ebx
80102440:	5e                   	pop    %esi
80102441:	5d                   	pop    %ebp
80102442:	c3                   	ret    
80102443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102455:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102458:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010245b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102461:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102467:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010246d:	39 de                	cmp    %ebx,%esi
8010246f:	72 23                	jb     80102494 <kinit2+0x44>
80102471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102478:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010247e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102481:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102487:	50                   	push   %eax
80102488:	e8 73 fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010248d:	83 c4 10             	add    $0x10,%esp
80102490:	39 de                	cmp    %ebx,%esi
80102492:	73 e4                	jae    80102478 <kinit2+0x28>
  kmem.use_lock = 1;
80102494:	c7 05 d4 11 11 80 01 	movl   $0x1,0x801111d4
8010249b:	00 00 00 
}
8010249e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024a1:	5b                   	pop    %ebx
801024a2:	5e                   	pop    %esi
801024a3:	5d                   	pop    %ebp
801024a4:	c3                   	ret    
801024a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024b0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024b0:	a1 d4 11 11 80       	mov    0x801111d4,%eax
801024b5:	85 c0                	test   %eax,%eax
801024b7:	75 1f                	jne    801024d8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b9:	a1 d8 11 11 80       	mov    0x801111d8,%eax
  if(r)
801024be:	85 c0                	test   %eax,%eax
801024c0:	74 0e                	je     801024d0 <kalloc+0x20>
    kmem.freelist = r->next;
801024c2:	8b 10                	mov    (%eax),%edx
801024c4:	89 15 d8 11 11 80    	mov    %edx,0x801111d8
801024ca:	c3                   	ret    
801024cb:	90                   	nop
801024cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024d0:	f3 c3                	repz ret 
801024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024d8:	55                   	push   %ebp
801024d9:	89 e5                	mov    %esp,%ebp
801024db:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024de:	68 a0 11 11 80       	push   $0x801111a0
801024e3:	e8 a8 23 00 00       	call   80104890 <acquire>
  r = kmem.freelist;
801024e8:	a1 d8 11 11 80       	mov    0x801111d8,%eax
  if(r)
801024ed:	83 c4 10             	add    $0x10,%esp
801024f0:	8b 15 d4 11 11 80    	mov    0x801111d4,%edx
801024f6:	85 c0                	test   %eax,%eax
801024f8:	74 08                	je     80102502 <kalloc+0x52>
    kmem.freelist = r->next;
801024fa:	8b 08                	mov    (%eax),%ecx
801024fc:	89 0d d8 11 11 80    	mov    %ecx,0x801111d8
  if(kmem.use_lock)
80102502:	85 d2                	test   %edx,%edx
80102504:	74 16                	je     8010251c <kalloc+0x6c>
    release(&kmem.lock);
80102506:	83 ec 0c             	sub    $0xc,%esp
80102509:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010250c:	68 a0 11 11 80       	push   $0x801111a0
80102511:	e8 5a 25 00 00       	call   80104a70 <release>
  return (char*)r;
80102516:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102519:	83 c4 10             	add    $0x10,%esp
}
8010251c:	c9                   	leave  
8010251d:	c3                   	ret    
8010251e:	66 90                	xchg   %ax,%ax

80102520 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102520:	ba 64 00 00 00       	mov    $0x64,%edx
80102525:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102526:	a8 01                	test   $0x1,%al
80102528:	0f 84 c2 00 00 00    	je     801025f0 <kbdgetc+0xd0>
8010252e:	ba 60 00 00 00       	mov    $0x60,%edx
80102533:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102534:	0f b6 d0             	movzbl %al,%edx
80102537:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010253d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102543:	0f 84 7f 00 00 00    	je     801025c8 <kbdgetc+0xa8>
{
80102549:	55                   	push   %ebp
8010254a:	89 e5                	mov    %esp,%ebp
8010254c:	53                   	push   %ebx
8010254d:	89 cb                	mov    %ecx,%ebx
8010254f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102552:	84 c0                	test   %al,%al
80102554:	78 4a                	js     801025a0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102556:	85 db                	test   %ebx,%ebx
80102558:	74 09                	je     80102563 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010255d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102560:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102563:	0f b6 82 80 78 10 80 	movzbl -0x7fef8780(%edx),%eax
8010256a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010256c:	0f b6 82 80 77 10 80 	movzbl -0x7fef8880(%edx),%eax
80102573:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102575:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102577:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010257d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102580:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102583:	8b 04 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%eax
8010258a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010258e:	74 31                	je     801025c1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102590:	8d 50 9f             	lea    -0x61(%eax),%edx
80102593:	83 fa 19             	cmp    $0x19,%edx
80102596:	77 40                	ja     801025d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102598:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010259b:	5b                   	pop    %ebx
8010259c:	5d                   	pop    %ebp
8010259d:	c3                   	ret    
8010259e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025a0:	83 e0 7f             	and    $0x7f,%eax
801025a3:	85 db                	test   %ebx,%ebx
801025a5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025a8:	0f b6 82 80 78 10 80 	movzbl -0x7fef8780(%edx),%eax
801025af:	83 c8 40             	or     $0x40,%eax
801025b2:	0f b6 c0             	movzbl %al,%eax
801025b5:	f7 d0                	not    %eax
801025b7:	21 c1                	and    %eax,%ecx
    return 0;
801025b9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025bb:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801025c1:	5b                   	pop    %ebx
801025c2:	5d                   	pop    %ebp
801025c3:	c3                   	ret    
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025c8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025cb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025cd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025db:	8d 50 20             	lea    0x20(%eax),%edx
}
801025de:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025df:	83 f9 1a             	cmp    $0x1a,%ecx
801025e2:	0f 42 c2             	cmovb  %edx,%eax
}
801025e5:	5d                   	pop    %ebp
801025e6:	c3                   	ret    
801025e7:	89 f6                	mov    %esi,%esi
801025e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801025f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801025f5:	c3                   	ret    
801025f6:	8d 76 00             	lea    0x0(%esi),%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102600 <kbdintr>:

void
kbdintr(void)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102606:	68 20 25 10 80       	push   $0x80102520
8010260b:	e8 e0 e1 ff ff       	call   801007f0 <consoleintr>
}
80102610:	83 c4 10             	add    $0x10,%esp
80102613:	c9                   	leave  
80102614:	c3                   	ret    
80102615:	66 90                	xchg   %ax,%ax
80102617:	66 90                	xchg   %ax,%ax
80102619:	66 90                	xchg   %ax,%ax
8010261b:	66 90                	xchg   %ax,%ax
8010261d:	66 90                	xchg   %ax,%ax
8010261f:	90                   	nop

80102620 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102620:	a1 dc 11 11 80       	mov    0x801111dc,%eax
{
80102625:	55                   	push   %ebp
80102626:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102628:	85 c0                	test   %eax,%eax
8010262a:	0f 84 c8 00 00 00    	je     801026f8 <lapicinit+0xd8>
  lapic[index] = value;
80102630:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102637:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010263a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010263d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102644:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102647:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102651:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102654:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102657:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010265e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102661:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102664:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010266b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010266e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102671:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102678:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010267e:	8b 50 30             	mov    0x30(%eax),%edx
80102681:	c1 ea 10             	shr    $0x10,%edx
80102684:	80 fa 03             	cmp    $0x3,%dl
80102687:	77 77                	ja     80102700 <lapicinit+0xe0>
  lapic[index] = value;
80102689:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102690:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102693:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102696:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010269d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026d4:	8b 50 20             	mov    0x20(%eax),%edx
801026d7:	89 f6                	mov    %esi,%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026e6:	80 e6 10             	and    $0x10,%dh
801026e9:	75 f5                	jne    801026e0 <lapicinit+0xc0>
  lapic[index] = value;
801026eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026f8:	5d                   	pop    %ebp
801026f9:	c3                   	ret    
801026fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102700:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102707:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
8010270d:	e9 77 ff ff ff       	jmp    80102689 <lapicinit+0x69>
80102712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102720 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102720:	8b 15 dc 11 11 80    	mov    0x801111dc,%edx
{
80102726:	55                   	push   %ebp
80102727:	31 c0                	xor    %eax,%eax
80102729:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010272b:	85 d2                	test   %edx,%edx
8010272d:	74 06                	je     80102735 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010272f:	8b 42 20             	mov    0x20(%edx),%eax
80102732:	c1 e8 18             	shr    $0x18,%eax
}
80102735:	5d                   	pop    %ebp
80102736:	c3                   	ret    
80102737:	89 f6                	mov    %esi,%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <cpunum>:

int
cpunum(void)
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102745:	9c                   	pushf  
80102746:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102747:	f6 c4 02             	test   $0x2,%ah
8010274a:	74 12                	je     8010275e <cpunum+0x1e>
    static int n;
    if(n++ == 0)
8010274c:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102751:	8d 50 01             	lea    0x1(%eax),%edx
80102754:	85 c0                	test   %eax,%eax
80102756:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010275c:	74 62                	je     801027c0 <cpunum+0x80>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
8010275e:	a1 dc 11 11 80       	mov    0x801111dc,%eax
80102763:	85 c0                	test   %eax,%eax
80102765:	74 49                	je     801027b0 <cpunum+0x70>
    return 0;

  apicid = lapic[ID] >> 24;
80102767:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010276a:	8b 35 c0 18 11 80    	mov    0x801118c0,%esi
  apicid = lapic[ID] >> 24;
80102770:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102773:	85 f6                	test   %esi,%esi
80102775:	7e 5e                	jle    801027d5 <cpunum+0x95>
    if (cpus[i].apicid == apicid)
80102777:	0f b6 05 e0 12 11 80 	movzbl 0x801112e0,%eax
8010277e:	39 c3                	cmp    %eax,%ebx
80102780:	74 2e                	je     801027b0 <cpunum+0x70>
80102782:	ba 9c 13 11 80       	mov    $0x8011139c,%edx
  for (i = 0; i < ncpu; ++i) {
80102787:	31 c0                	xor    %eax,%eax
80102789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102790:	83 c0 01             	add    $0x1,%eax
80102793:	39 f0                	cmp    %esi,%eax
80102795:	74 3e                	je     801027d5 <cpunum+0x95>
    if (cpus[i].apicid == apicid)
80102797:	0f b6 0a             	movzbl (%edx),%ecx
8010279a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801027a0:	39 d9                	cmp    %ebx,%ecx
801027a2:	75 ec                	jne    80102790 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801027a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027a7:	5b                   	pop    %ebx
801027a8:	5e                   	pop    %esi
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801027b3:	31 c0                	xor    %eax,%eax
}
801027b5:	5b                   	pop    %ebx
801027b6:	5e                   	pop    %esi
801027b7:	5d                   	pop    %ebp
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("cpu called from %x with interrupts enabled\n",
801027c0:	83 ec 08             	sub    $0x8,%esp
801027c3:	ff 75 04             	pushl  0x4(%ebp)
801027c6:	68 80 79 10 80       	push   $0x80107980
801027cb:	e8 70 de ff ff       	call   80100640 <cprintf>
801027d0:	83 c4 10             	add    $0x10,%esp
801027d3:	eb 89                	jmp    8010275e <cpunum+0x1e>
  panic("unknown apicid\n");
801027d5:	83 ec 0c             	sub    $0xc,%esp
801027d8:	68 ac 79 10 80       	push   $0x801079ac
801027dd:	e8 8e db ff ff       	call   80100370 <panic>
801027e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027f0:	a1 dc 11 11 80       	mov    0x801111dc,%eax
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027f8:	85 c0                	test   %eax,%eax
801027fa:	74 0d                	je     80102809 <lapiceoi+0x19>
  lapic[index] = value;
801027fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102803:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
}
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret    
80102815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102820:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	b8 0f 00 00 00       	mov    $0xf,%eax
80102826:	ba 70 00 00 00       	mov    $0x70,%edx
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	53                   	push   %ebx
8010282e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102831:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102834:	ee                   	out    %al,(%dx)
80102835:	b8 0a 00 00 00       	mov    $0xa,%eax
8010283a:	ba 71 00 00 00       	mov    $0x71,%edx
8010283f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102840:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102842:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102845:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010284b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010284d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102850:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102853:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102855:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102858:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010285e:	a1 dc 11 11 80       	mov    0x801111dc,%eax
80102863:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102869:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010286c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102873:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102876:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102879:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102880:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102883:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102886:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010288c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010288f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102895:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102898:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801028aa:	5b                   	pop    %ebx
801028ab:	5d                   	pop    %ebp
801028ac:	c3                   	ret    
801028ad:	8d 76 00             	lea    0x0(%esi),%esi

801028b0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028b0:	55                   	push   %ebp
801028b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801028b6:	ba 70 00 00 00       	mov    $0x70,%edx
801028bb:	89 e5                	mov    %esp,%ebp
801028bd:	57                   	push   %edi
801028be:	56                   	push   %esi
801028bf:	53                   	push   %ebx
801028c0:	83 ec 4c             	sub    $0x4c,%esp
801028c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	ba 71 00 00 00       	mov    $0x71,%edx
801028c9:	ec                   	in     (%dx),%al
801028ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cd:	bb 70 00 00 00       	mov    $0x70,%ebx
801028d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801028d5:	8d 76 00             	lea    0x0(%esi),%esi
801028d8:	31 c0                	xor    %eax,%eax
801028da:	89 da                	mov    %ebx,%edx
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801028e2:	89 ca                	mov    %ecx,%edx
801028e4:	ec                   	in     (%dx),%al
801028e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e8:	89 da                	mov    %ebx,%edx
801028ea:	b8 02 00 00 00       	mov    $0x2,%eax
801028ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f0:	89 ca                	mov    %ecx,%edx
801028f2:	ec                   	in     (%dx),%al
801028f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f6:	89 da                	mov    %ebx,%edx
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
80102901:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 da                	mov    %ebx,%edx
80102906:	b8 07 00 00 00       	mov    $0x7,%eax
8010290b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
8010290f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102912:	89 da                	mov    %ebx,%edx
80102914:	b8 08 00 00 00       	mov    $0x8,%eax
80102919:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291a:	89 ca                	mov    %ecx,%edx
8010291c:	ec                   	in     (%dx),%al
8010291d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010291f:	89 da                	mov    %ebx,%edx
80102921:	b8 09 00 00 00       	mov    $0x9,%eax
80102926:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102927:	89 ca                	mov    %ecx,%edx
80102929:	ec                   	in     (%dx),%al
8010292a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292c:	89 da                	mov    %ebx,%edx
8010292e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102933:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102934:	89 ca                	mov    %ecx,%edx
80102936:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102937:	84 c0                	test   %al,%al
80102939:	78 9d                	js     801028d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010293b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010293f:	89 fa                	mov    %edi,%edx
80102941:	0f b6 fa             	movzbl %dl,%edi
80102944:	89 f2                	mov    %esi,%edx
80102946:	0f b6 f2             	movzbl %dl,%esi
80102949:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010294c:	89 da                	mov    %ebx,%edx
8010294e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102951:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102954:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102958:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010295b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010295f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102962:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102966:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102969:	31 c0                	xor    %eax,%eax
8010296b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296c:	89 ca                	mov    %ecx,%edx
8010296e:	ec                   	in     (%dx),%al
8010296f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102972:	89 da                	mov    %ebx,%edx
80102974:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102977:	b8 02 00 00 00       	mov    $0x2,%eax
8010297c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297d:	89 ca                	mov    %ecx,%edx
8010297f:	ec                   	in     (%dx),%al
80102980:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102983:	89 da                	mov    %ebx,%edx
80102985:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102988:	b8 04 00 00 00       	mov    $0x4,%eax
8010298d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298e:	89 ca                	mov    %ecx,%edx
80102990:	ec                   	in     (%dx),%al
80102991:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102994:	89 da                	mov    %ebx,%edx
80102996:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102999:	b8 07 00 00 00       	mov    $0x7,%eax
8010299e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299f:	89 ca                	mov    %ecx,%edx
801029a1:	ec                   	in     (%dx),%al
801029a2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a5:	89 da                	mov    %ebx,%edx
801029a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029aa:	b8 08 00 00 00       	mov    $0x8,%eax
801029af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b0:	89 ca                	mov    %ecx,%edx
801029b2:	ec                   	in     (%dx),%al
801029b3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b6:	89 da                	mov    %ebx,%edx
801029b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801029bb:	b8 09 00 00 00       	mov    $0x9,%eax
801029c0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c1:	89 ca                	mov    %ecx,%edx
801029c3:	ec                   	in     (%dx),%al
801029c4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029c7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801029ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029cd:	8d 45 d0             	lea    -0x30(%ebp),%eax
801029d0:	6a 18                	push   $0x18
801029d2:	50                   	push   %eax
801029d3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029d6:	50                   	push   %eax
801029d7:	e8 34 21 00 00       	call   80104b10 <memcmp>
801029dc:	83 c4 10             	add    $0x10,%esp
801029df:	85 c0                	test   %eax,%eax
801029e1:	0f 85 f1 fe ff ff    	jne    801028d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801029e7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801029eb:	75 78                	jne    80102a65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029f0:	89 c2                	mov    %eax,%edx
801029f2:	83 e0 0f             	and    $0xf,%eax
801029f5:	c1 ea 04             	shr    $0x4,%edx
801029f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a04:	89 c2                	mov    %eax,%edx
80102a06:	83 e0 0f             	and    $0xf,%eax
80102a09:	c1 ea 04             	shr    $0x4,%edx
80102a0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a18:	89 c2                	mov    %eax,%edx
80102a1a:	83 e0 0f             	and    $0xf,%eax
80102a1d:	c1 ea 04             	shr    $0x4,%edx
80102a20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a2c:	89 c2                	mov    %eax,%edx
80102a2e:	83 e0 0f             	and    $0xf,%eax
80102a31:	c1 ea 04             	shr    $0x4,%edx
80102a34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a40:	89 c2                	mov    %eax,%edx
80102a42:	83 e0 0f             	and    $0xf,%eax
80102a45:	c1 ea 04             	shr    $0x4,%edx
80102a48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a54:	89 c2                	mov    %eax,%edx
80102a56:	83 e0 0f             	and    $0xf,%eax
80102a59:	c1 ea 04             	shr    $0x4,%edx
80102a5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a65:	8b 75 08             	mov    0x8(%ebp),%esi
80102a68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a6b:	89 06                	mov    %eax,(%esi)
80102a6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a70:	89 46 04             	mov    %eax,0x4(%esi)
80102a73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a76:	89 46 08             	mov    %eax,0x8(%esi)
80102a79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a82:	89 46 10             	mov    %eax,0x10(%esi)
80102a85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a95:	5b                   	pop    %ebx
80102a96:	5e                   	pop    %esi
80102a97:	5f                   	pop    %edi
80102a98:	5d                   	pop    %ebp
80102a99:	c3                   	ret    
80102a9a:	66 90                	xchg   %ax,%ax
80102a9c:	66 90                	xchg   %ax,%ax
80102a9e:	66 90                	xchg   %ax,%ax

80102aa0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102aa0:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102aa6:	85 c9                	test   %ecx,%ecx
80102aa8:	0f 8e 8a 00 00 00    	jle    80102b38 <install_trans+0x98>
{
80102aae:	55                   	push   %ebp
80102aaf:	89 e5                	mov    %esp,%ebp
80102ab1:	57                   	push   %edi
80102ab2:	56                   	push   %esi
80102ab3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102ab4:	31 db                	xor    %ebx,%ebx
{
80102ab6:	83 ec 0c             	sub    $0xc,%esp
80102ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ac0:	a1 14 12 11 80       	mov    0x80111214,%eax
80102ac5:	83 ec 08             	sub    $0x8,%esp
80102ac8:	01 d8                	add    %ebx,%eax
80102aca:	83 c0 01             	add    $0x1,%eax
80102acd:	50                   	push   %eax
80102ace:	ff 35 24 12 11 80    	pushl  0x80111224
80102ad4:	e8 e7 d5 ff ff       	call   801000c0 <bread>
80102ad9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102adb:	58                   	pop    %eax
80102adc:	5a                   	pop    %edx
80102add:	ff 34 9d 2c 12 11 80 	pushl  -0x7feeedd4(,%ebx,4)
80102ae4:	ff 35 24 12 11 80    	pushl  0x80111224
  for (tail = 0; tail < log.lh.n; tail++) {
80102aea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102aed:	e8 ce d5 ff ff       	call   801000c0 <bread>
80102af2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102af4:	8d 47 18             	lea    0x18(%edi),%eax
80102af7:	83 c4 0c             	add    $0xc,%esp
80102afa:	68 00 02 00 00       	push   $0x200
80102aff:	50                   	push   %eax
80102b00:	8d 46 18             	lea    0x18(%esi),%eax
80102b03:	50                   	push   %eax
80102b04:	e8 67 20 00 00       	call   80104b70 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b09:	89 34 24             	mov    %esi,(%esp)
80102b0c:	e8 8f d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102b11:	89 3c 24             	mov    %edi,(%esp)
80102b14:	e8 b7 d6 ff ff       	call   801001d0 <brelse>
    brelse(dbuf);
80102b19:	89 34 24             	mov    %esi,(%esp)
80102b1c:	e8 af d6 ff ff       	call   801001d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b21:	83 c4 10             	add    $0x10,%esp
80102b24:	39 1d 28 12 11 80    	cmp    %ebx,0x80111228
80102b2a:	7f 94                	jg     80102ac0 <install_trans+0x20>
  }
}
80102b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b2f:	5b                   	pop    %ebx
80102b30:	5e                   	pop    %esi
80102b31:	5f                   	pop    %edi
80102b32:	5d                   	pop    %ebp
80102b33:	c3                   	ret    
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b38:	f3 c3                	repz ret 
80102b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b47:	ff 35 14 12 11 80    	pushl  0x80111214
80102b4d:	ff 35 24 12 11 80    	pushl  0x80111224
80102b53:	e8 68 d5 ff ff       	call   801000c0 <bread>
80102b58:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b5a:	a1 28 12 11 80       	mov    0x80111228,%eax
  for (i = 0; i < log.lh.n; i++) {
80102b5f:	83 c4 10             	add    $0x10,%esp
  hb->n = log.lh.n;
80102b62:	89 43 18             	mov    %eax,0x18(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102b65:	a1 28 12 11 80       	mov    0x80111228,%eax
80102b6a:	85 c0                	test   %eax,%eax
80102b6c:	7e 18                	jle    80102b86 <write_head+0x46>
80102b6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b70:	8b 0c 95 2c 12 11 80 	mov    -0x7feeedd4(,%edx,4),%ecx
80102b77:	89 4c 93 1c          	mov    %ecx,0x1c(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b7b:	83 c2 01             	add    $0x1,%edx
80102b7e:	39 15 28 12 11 80    	cmp    %edx,0x80111228
80102b84:	7f ea                	jg     80102b70 <write_head+0x30>
  }
  bwrite(buf);
80102b86:	83 ec 0c             	sub    $0xc,%esp
80102b89:	53                   	push   %ebx
80102b8a:	e8 11 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b8f:	89 1c 24             	mov    %ebx,(%esp)
80102b92:	e8 39 d6 ff ff       	call   801001d0 <brelse>
}
80102b97:	83 c4 10             	add    $0x10,%esp
80102b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b9d:	c9                   	leave  
80102b9e:	c3                   	ret    
80102b9f:	90                   	nop

80102ba0 <initlog>:
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	53                   	push   %ebx
80102ba4:	83 ec 2c             	sub    $0x2c,%esp
80102ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102baa:	68 bc 79 10 80       	push   $0x801079bc
80102baf:	68 e0 11 11 80       	push   $0x801111e0
80102bb4:	e8 b7 1c 00 00       	call   80104870 <initlock>
  readsb(dev, &sb);
80102bb9:	58                   	pop    %eax
80102bba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102bbd:	5a                   	pop    %edx
80102bbe:	50                   	push   %eax
80102bbf:	53                   	push   %ebx
80102bc0:	e8 bb e7 ff ff       	call   80101380 <readsb>
  log.size = sb.nlog;
80102bc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102bcb:	59                   	pop    %ecx
  log.dev = dev;
80102bcc:	89 1d 24 12 11 80    	mov    %ebx,0x80111224
  log.size = sb.nlog;
80102bd2:	89 15 18 12 11 80    	mov    %edx,0x80111218
  log.start = sb.logstart;
80102bd8:	a3 14 12 11 80       	mov    %eax,0x80111214
  struct buf *buf = bread(log.dev, log.start);
80102bdd:	5a                   	pop    %edx
80102bde:	50                   	push   %eax
80102bdf:	53                   	push   %ebx
80102be0:	e8 db d4 ff ff       	call   801000c0 <bread>
  log.lh.n = lh->n;
80102be5:	8b 58 18             	mov    0x18(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102be8:	83 c4 10             	add    $0x10,%esp
80102beb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102bed:	89 1d 28 12 11 80    	mov    %ebx,0x80111228
  for (i = 0; i < log.lh.n; i++) {
80102bf3:	7e 1c                	jle    80102c11 <initlog+0x71>
80102bf5:	c1 e3 02             	shl    $0x2,%ebx
80102bf8:	31 d2                	xor    %edx,%edx
80102bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102c00:	8b 4c 10 1c          	mov    0x1c(%eax,%edx,1),%ecx
80102c04:	83 c2 04             	add    $0x4,%edx
80102c07:	89 8a 28 12 11 80    	mov    %ecx,-0x7feeedd8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102c0d:	39 d3                	cmp    %edx,%ebx
80102c0f:	75 ef                	jne    80102c00 <initlog+0x60>
  brelse(buf);
80102c11:	83 ec 0c             	sub    $0xc,%esp
80102c14:	50                   	push   %eax
80102c15:	e8 b6 d5 ff ff       	call   801001d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c1a:	e8 81 fe ff ff       	call   80102aa0 <install_trans>
  log.lh.n = 0;
80102c1f:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102c26:	00 00 00 
  write_head(); // clear the log
80102c29:	e8 12 ff ff ff       	call   80102b40 <write_head>
}
80102c2e:	83 c4 10             	add    $0x10,%esp
80102c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c46:	68 e0 11 11 80       	push   $0x801111e0
80102c4b:	e8 40 1c 00 00       	call   80104890 <acquire>
80102c50:	83 c4 10             	add    $0x10,%esp
80102c53:	eb 18                	jmp    80102c6d <begin_op+0x2d>
80102c55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c58:	83 ec 08             	sub    $0x8,%esp
80102c5b:	68 e0 11 11 80       	push   $0x801111e0
80102c60:	68 e0 11 11 80       	push   $0x801111e0
80102c65:	e8 26 12 00 00       	call   80103e90 <sleep>
80102c6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c6d:	a1 20 12 11 80       	mov    0x80111220,%eax
80102c72:	85 c0                	test   %eax,%eax
80102c74:	75 e2                	jne    80102c58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c76:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102c7b:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102c81:	83 c0 01             	add    $0x1,%eax
80102c84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c8a:	83 fa 1e             	cmp    $0x1e,%edx
80102c8d:	7f c9                	jg     80102c58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c92:	a3 1c 12 11 80       	mov    %eax,0x8011121c
      release(&log.lock);
80102c97:	68 e0 11 11 80       	push   $0x801111e0
80102c9c:	e8 cf 1d 00 00       	call   80104a70 <release>
      break;
    }
  }
}
80102ca1:	83 c4 10             	add    $0x10,%esp
80102ca4:	c9                   	leave  
80102ca5:	c3                   	ret    
80102ca6:	8d 76 00             	lea    0x0(%esi),%esi
80102ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	57                   	push   %edi
80102cb4:	56                   	push   %esi
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102cb9:	68 e0 11 11 80       	push   $0x801111e0
80102cbe:	e8 cd 1b 00 00       	call   80104890 <acquire>
  log.outstanding -= 1;
80102cc3:	a1 1c 12 11 80       	mov    0x8011121c,%eax
  if(log.committing)
80102cc8:	8b 35 20 12 11 80    	mov    0x80111220,%esi
80102cce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102cd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102cd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102cd6:	89 1d 1c 12 11 80    	mov    %ebx,0x8011121c
  if(log.committing)
80102cdc:	0f 85 1a 01 00 00    	jne    80102dfc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102ce2:	85 db                	test   %ebx,%ebx
80102ce4:	0f 85 ee 00 00 00    	jne    80102dd8 <end_op+0x128>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102cea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ced:	c7 05 20 12 11 80 01 	movl   $0x1,0x80111220
80102cf4:	00 00 00 
  release(&log.lock);
80102cf7:	68 e0 11 11 80       	push   $0x801111e0
80102cfc:	e8 6f 1d 00 00       	call   80104a70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d01:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102d07:	83 c4 10             	add    $0x10,%esp
80102d0a:	85 c9                	test   %ecx,%ecx
80102d0c:	0f 8e 85 00 00 00    	jle    80102d97 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d12:	a1 14 12 11 80       	mov    0x80111214,%eax
80102d17:	83 ec 08             	sub    $0x8,%esp
80102d1a:	01 d8                	add    %ebx,%eax
80102d1c:	83 c0 01             	add    $0x1,%eax
80102d1f:	50                   	push   %eax
80102d20:	ff 35 24 12 11 80    	pushl  0x80111224
80102d26:	e8 95 d3 ff ff       	call   801000c0 <bread>
80102d2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d2d:	58                   	pop    %eax
80102d2e:	5a                   	pop    %edx
80102d2f:	ff 34 9d 2c 12 11 80 	pushl  -0x7feeedd4(,%ebx,4)
80102d36:	ff 35 24 12 11 80    	pushl  0x80111224
  for (tail = 0; tail < log.lh.n; tail++) {
80102d3c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d3f:	e8 7c d3 ff ff       	call   801000c0 <bread>
80102d44:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d46:	8d 40 18             	lea    0x18(%eax),%eax
80102d49:	83 c4 0c             	add    $0xc,%esp
80102d4c:	68 00 02 00 00       	push   $0x200
80102d51:	50                   	push   %eax
80102d52:	8d 46 18             	lea    0x18(%esi),%eax
80102d55:	50                   	push   %eax
80102d56:	e8 15 1e 00 00       	call   80104b70 <memmove>
    bwrite(to);  // write the log
80102d5b:	89 34 24             	mov    %esi,(%esp)
80102d5e:	e8 3d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d63:	89 3c 24             	mov    %edi,(%esp)
80102d66:	e8 65 d4 ff ff       	call   801001d0 <brelse>
    brelse(to);
80102d6b:	89 34 24             	mov    %esi,(%esp)
80102d6e:	e8 5d d4 ff ff       	call   801001d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d73:	83 c4 10             	add    $0x10,%esp
80102d76:	3b 1d 28 12 11 80    	cmp    0x80111228,%ebx
80102d7c:	7c 94                	jl     80102d12 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d7e:	e8 bd fd ff ff       	call   80102b40 <write_head>
    install_trans(); // Now install writes to home locations
80102d83:	e8 18 fd ff ff       	call   80102aa0 <install_trans>
    log.lh.n = 0;
80102d88:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102d8f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d92:	e8 a9 fd ff ff       	call   80102b40 <write_head>
    acquire(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
80102d9a:	68 e0 11 11 80       	push   $0x801111e0
80102d9f:	e8 ec 1a 00 00       	call   80104890 <acquire>
    wakeup(&log);
80102da4:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
    log.committing = 0;
80102dab:	c7 05 20 12 11 80 00 	movl   $0x0,0x80111220
80102db2:	00 00 00 
    wakeup(&log);
80102db5:	e8 c6 12 00 00       	call   80104080 <wakeup>
    release(&log.lock);
80102dba:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102dc1:	e8 aa 1c 00 00       	call   80104a70 <release>
80102dc6:	83 c4 10             	add    $0x10,%esp
}
80102dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dcc:	5b                   	pop    %ebx
80102dcd:	5e                   	pop    %esi
80102dce:	5f                   	pop    %edi
80102dcf:	5d                   	pop    %ebp
80102dd0:	c3                   	ret    
80102dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102dd8:	83 ec 0c             	sub    $0xc,%esp
80102ddb:	68 e0 11 11 80       	push   $0x801111e0
80102de0:	e8 9b 12 00 00       	call   80104080 <wakeup>
  release(&log.lock);
80102de5:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102dec:	e8 7f 1c 00 00       	call   80104a70 <release>
80102df1:	83 c4 10             	add    $0x10,%esp
}
80102df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df7:	5b                   	pop    %ebx
80102df8:	5e                   	pop    %esi
80102df9:	5f                   	pop    %edi
80102dfa:	5d                   	pop    %ebp
80102dfb:	c3                   	ret    
    panic("log.committing");
80102dfc:	83 ec 0c             	sub    $0xc,%esp
80102dff:	68 c0 79 10 80       	push   $0x801079c0
80102e04:	e8 67 d5 ff ff       	call   80100370 <panic>
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e17:	8b 15 28 12 11 80    	mov    0x80111228,%edx
{
80102e1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e20:	83 fa 1d             	cmp    $0x1d,%edx
80102e23:	0f 8f 9d 00 00 00    	jg     80102ec6 <log_write+0xb6>
80102e29:	a1 18 12 11 80       	mov    0x80111218,%eax
80102e2e:	83 e8 01             	sub    $0x1,%eax
80102e31:	39 c2                	cmp    %eax,%edx
80102e33:	0f 8d 8d 00 00 00    	jge    80102ec6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e39:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102e3e:	85 c0                	test   %eax,%eax
80102e40:	0f 8e 8d 00 00 00    	jle    80102ed3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	68 e0 11 11 80       	push   $0x801111e0
80102e4e:	e8 3d 1a 00 00       	call   80104890 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e53:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102e59:	83 c4 10             	add    $0x10,%esp
80102e5c:	83 f9 00             	cmp    $0x0,%ecx
80102e5f:	7e 57                	jle    80102eb8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e61:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e64:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e66:	3b 15 2c 12 11 80    	cmp    0x8011122c,%edx
80102e6c:	75 0b                	jne    80102e79 <log_write+0x69>
80102e6e:	eb 38                	jmp    80102ea8 <log_write+0x98>
80102e70:	39 14 85 2c 12 11 80 	cmp    %edx,-0x7feeedd4(,%eax,4)
80102e77:	74 2f                	je     80102ea8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e79:	83 c0 01             	add    $0x1,%eax
80102e7c:	39 c1                	cmp    %eax,%ecx
80102e7e:	75 f0                	jne    80102e70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e80:	89 14 85 2c 12 11 80 	mov    %edx,-0x7feeedd4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e87:	83 c0 01             	add    $0x1,%eax
80102e8a:	a3 28 12 11 80       	mov    %eax,0x80111228
  b->flags |= B_DIRTY; // prevent eviction
80102e8f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e92:	c7 45 08 e0 11 11 80 	movl   $0x801111e0,0x8(%ebp)
}
80102e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e9c:	c9                   	leave  
  release(&log.lock);
80102e9d:	e9 ce 1b 00 00       	jmp    80104a70 <release>
80102ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ea8:	89 14 85 2c 12 11 80 	mov    %edx,-0x7feeedd4(,%eax,4)
80102eaf:	eb de                	jmp    80102e8f <log_write+0x7f>
80102eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eb8:	8b 43 08             	mov    0x8(%ebx),%eax
80102ebb:	a3 2c 12 11 80       	mov    %eax,0x8011122c
  if (i == log.lh.n)
80102ec0:	75 cd                	jne    80102e8f <log_write+0x7f>
80102ec2:	31 c0                	xor    %eax,%eax
80102ec4:	eb c1                	jmp    80102e87 <log_write+0x77>
    panic("too big a transaction");
80102ec6:	83 ec 0c             	sub    $0xc,%esp
80102ec9:	68 cf 79 10 80       	push   $0x801079cf
80102ece:	e8 9d d4 ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
80102ed3:	83 ec 0c             	sub    $0xc,%esp
80102ed6:	68 e5 79 10 80       	push   $0x801079e5
80102edb:	e8 90 d4 ff ff       	call   80100370 <panic>

80102ee0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102ee6:	e8 55 f8 ff ff       	call   80102740 <cpunum>
80102eeb:	83 ec 08             	sub    $0x8,%esp
80102eee:	50                   	push   %eax
80102eef:	68 00 7a 10 80       	push   $0x80107a00
80102ef4:	e8 47 d7 ff ff       	call   80100640 <cprintf>
  idtinit();       // load idt register
80102ef9:	e8 82 2e 00 00       	call   80105d80 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102efe:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f05:	b8 01 00 00 00       	mov    $0x1,%eax
80102f0a:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102f11:	e8 ea 15 00 00       	call   80104500 <scheduler>
80102f16:	8d 76 00             	lea    0x0(%esi),%esi
80102f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f20 <mpenter>:
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f26:	e8 e5 3f 00 00       	call   80106f10 <switchkvm>
  seginit();
80102f2b:	e8 70 3e 00 00       	call   80106da0 <seginit>
  lapicinit();
80102f30:	e8 eb f6 ff ff       	call   80102620 <lapicinit>
  mpmain();
80102f35:	e8 a6 ff ff ff       	call   80102ee0 <mpmain>
80102f3a:	66 90                	xchg   %ax,%ax
80102f3c:	66 90                	xchg   %ax,%ax
80102f3e:	66 90                	xchg   %ax,%ax

80102f40 <main>:
{
80102f40:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f44:	83 e4 f0             	and    $0xfffffff0,%esp
80102f47:	ff 71 fc             	pushl  -0x4(%ecx)
80102f4a:	55                   	push   %ebp
80102f4b:	89 e5                	mov    %esp,%ebp
80102f4d:	53                   	push   %ebx
80102f4e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f4f:	83 ec 08             	sub    $0x8,%esp
80102f52:	68 00 00 40 80       	push   $0x80400000
80102f57:	68 68 45 11 80       	push   $0x80114568
80102f5c:	e8 7f f4 ff ff       	call   801023e0 <kinit1>
  kvmalloc();      // kernel page table
80102f61:	e8 8a 3f 00 00       	call   80106ef0 <kvmalloc>
  mpinit();        // detect other processors
80102f66:	e8 b5 01 00 00       	call   80103120 <mpinit>
  lapicinit();     // interrupt controller
80102f6b:	e8 b0 f6 ff ff       	call   80102620 <lapicinit>
  seginit();       // segment descriptors
80102f70:	e8 2b 3e 00 00       	call   80106da0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102f75:	e8 c6 f7 ff ff       	call   80102740 <cpunum>
80102f7a:	5a                   	pop    %edx
80102f7b:	59                   	pop    %ecx
80102f7c:	50                   	push   %eax
80102f7d:	68 11 7a 10 80       	push   $0x80107a11
80102f82:	e8 b9 d6 ff ff       	call   80100640 <cprintf>
  picinit();       // another interrupt controller
80102f87:	e8 b4 03 00 00       	call   80103340 <picinit>
  ioapicinit();    // another interrupt controller
80102f8c:	e8 5f f2 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102f91:	e8 0a da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102f96:	e8 d5 30 00 00       	call   80106070 <uartinit>
  pinit();         // process table
80102f9b:	e8 30 09 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
80102fa0:	e8 5b 2d 00 00       	call   80105d00 <tvinit>
  binit();         // buffer cache
80102fa5:	e8 96 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102faa:	e8 81 dd ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk
80102faf:	e8 1c f0 ff ff       	call   80101fd0 <ideinit>
  if(!ismp)
80102fb4:	8b 1d c4 12 11 80    	mov    0x801112c4,%ebx
80102fba:	83 c4 10             	add    $0x10,%esp
80102fbd:	85 db                	test   %ebx,%ebx
80102fbf:	0f 84 ca 00 00 00    	je     8010308f <main+0x14f>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102fc5:	83 ec 04             	sub    $0x4,%esp
80102fc8:	68 8a 00 00 00       	push   $0x8a
80102fcd:	68 8c a4 10 80       	push   $0x8010a48c
80102fd2:	68 00 70 00 80       	push   $0x80007000
80102fd7:	e8 94 1b 00 00       	call   80104b70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102fdc:	69 05 c0 18 11 80 bc 	imul   $0xbc,0x801118c0,%eax
80102fe3:	00 00 00 
80102fe6:	83 c4 10             	add    $0x10,%esp
80102fe9:	05 e0 12 11 80       	add    $0x801112e0,%eax
80102fee:	3d e0 12 11 80       	cmp    $0x801112e0,%eax
80102ff3:	76 7e                	jbe    80103073 <main+0x133>
80102ff5:	bb e0 12 11 80       	mov    $0x801112e0,%ebx
80102ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(c == cpus+cpunum())  // We've started already.
80103000:	e8 3b f7 ff ff       	call   80102740 <cpunum>
80103005:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010300b:	05 e0 12 11 80       	add    $0x801112e0,%eax
80103010:	39 c3                	cmp    %eax,%ebx
80103012:	74 46                	je     8010305a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103014:	e8 97 f4 ff ff       	call   801024b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103019:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-4) = stack + KSTACKSIZE;
8010301c:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103021:	c7 05 f8 6f 00 80 20 	movl   $0x80102f20,0x80006ff8
80103028:	2f 10 80 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010302b:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103030:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103037:	90 10 00 
    lapicstartap(c->apicid, V2P(code));
8010303a:	68 00 70 00 00       	push   $0x7000
8010303f:	0f b6 03             	movzbl (%ebx),%eax
80103042:	50                   	push   %eax
80103043:	e8 d8 f7 ff ff       	call   80102820 <lapicstartap>
80103048:	83 c4 10             	add    $0x10,%esp
8010304b:	90                   	nop
8010304c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103050:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80103056:	85 c0                	test   %eax,%eax
80103058:	74 f6                	je     80103050 <main+0x110>
  for(c = cpus; c < cpus+ncpu; c++){
8010305a:	69 05 c0 18 11 80 bc 	imul   $0xbc,0x801118c0,%eax
80103061:	00 00 00 
80103064:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
8010306a:	05 e0 12 11 80       	add    $0x801112e0,%eax
8010306f:	39 c3                	cmp    %eax,%ebx
80103071:	72 8d                	jb     80103000 <main+0xc0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103073:	83 ec 08             	sub    $0x8,%esp
80103076:	68 00 00 00 8e       	push   $0x8e000000
8010307b:	68 00 00 40 80       	push   $0x80400000
80103080:	e8 cb f3 ff ff       	call   80102450 <kinit2>
  userinit();      // first user process
80103085:	e8 66 08 00 00       	call   801038f0 <userinit>
  mpmain();        // finish this processor's setup
8010308a:	e8 51 fe ff ff       	call   80102ee0 <mpmain>
    timerinit();   // uniprocessor timer
8010308f:	e8 0c 2c 00 00       	call   80105ca0 <timerinit>
80103094:	e9 2c ff ff ff       	jmp    80102fc5 <main+0x85>
80103099:	66 90                	xchg   %ax,%ax
8010309b:	66 90                	xchg   %ax,%ax
8010309d:	66 90                	xchg   %ax,%ax
8010309f:	90                   	nop

801030a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	57                   	push   %edi
801030a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030ab:	53                   	push   %ebx
  e = addr+len;
801030ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030b2:	39 de                	cmp    %ebx,%esi
801030b4:	72 10                	jb     801030c6 <mpsearch1+0x26>
801030b6:	eb 50                	jmp    80103108 <mpsearch1+0x68>
801030b8:	90                   	nop
801030b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c0:	39 fb                	cmp    %edi,%ebx
801030c2:	89 fe                	mov    %edi,%esi
801030c4:	76 42                	jbe    80103108 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030c6:	83 ec 04             	sub    $0x4,%esp
801030c9:	8d 7e 10             	lea    0x10(%esi),%edi
801030cc:	6a 04                	push   $0x4
801030ce:	68 28 7a 10 80       	push   $0x80107a28
801030d3:	56                   	push   %esi
801030d4:	e8 37 1a 00 00       	call   80104b10 <memcmp>
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	85 c0                	test   %eax,%eax
801030de:	75 e0                	jne    801030c0 <mpsearch1+0x20>
801030e0:	89 f1                	mov    %esi,%ecx
801030e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801030e8:	0f b6 11             	movzbl (%ecx),%edx
801030eb:	83 c1 01             	add    $0x1,%ecx
801030ee:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801030f0:	39 f9                	cmp    %edi,%ecx
801030f2:	75 f4                	jne    801030e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030f4:	84 c0                	test   %al,%al
801030f6:	75 c8                	jne    801030c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801030f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030fb:	89 f0                	mov    %esi,%eax
801030fd:	5b                   	pop    %ebx
801030fe:	5e                   	pop    %esi
801030ff:	5f                   	pop    %edi
80103100:	5d                   	pop    %ebp
80103101:	c3                   	ret    
80103102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010310b:	31 f6                	xor    %esi,%esi
}
8010310d:	89 f0                	mov    %esi,%eax
8010310f:	5b                   	pop    %ebx
80103110:	5e                   	pop    %esi
80103111:	5f                   	pop    %edi
80103112:	5d                   	pop    %ebp
80103113:	c3                   	ret    
80103114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010311a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103120 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
80103125:	53                   	push   %ebx
80103126:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103129:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103130:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103137:	c1 e0 08             	shl    $0x8,%eax
8010313a:	09 d0                	or     %edx,%eax
8010313c:	c1 e0 04             	shl    $0x4,%eax
8010313f:	85 c0                	test   %eax,%eax
80103141:	75 1b                	jne    8010315e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103143:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010314a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103151:	c1 e0 08             	shl    $0x8,%eax
80103154:	09 d0                	or     %edx,%eax
80103156:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103159:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010315e:	ba 00 04 00 00       	mov    $0x400,%edx
80103163:	e8 38 ff ff ff       	call   801030a0 <mpsearch1>
80103168:	85 c0                	test   %eax,%eax
8010316a:	89 c7                	mov    %eax,%edi
8010316c:	0f 84 76 01 00 00    	je     801032e8 <mpinit+0x1c8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103172:	8b 5f 04             	mov    0x4(%edi),%ebx
80103175:	85 db                	test   %ebx,%ebx
80103177:	0f 84 e6 00 00 00    	je     80103263 <mpinit+0x143>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010317d:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103183:	83 ec 04             	sub    $0x4,%esp
80103186:	6a 04                	push   $0x4
80103188:	68 2d 7a 10 80       	push   $0x80107a2d
8010318d:	56                   	push   %esi
8010318e:	e8 7d 19 00 00       	call   80104b10 <memcmp>
80103193:	83 c4 10             	add    $0x10,%esp
80103196:	85 c0                	test   %eax,%eax
80103198:	0f 85 c5 00 00 00    	jne    80103263 <mpinit+0x143>
  if(conf->version != 1 && conf->version != 4)
8010319e:	0f b6 93 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%edx
801031a5:	80 fa 01             	cmp    $0x1,%dl
801031a8:	0f 95 c1             	setne  %cl
801031ab:	80 fa 04             	cmp    $0x4,%dl
801031ae:	0f 95 c2             	setne  %dl
801031b1:	20 ca                	and    %cl,%dl
801031b3:	0f 85 aa 00 00 00    	jne    80103263 <mpinit+0x143>
  if(sum((uchar*)conf, conf->length) != 0)
801031b9:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
801031c0:	66 85 c9             	test   %cx,%cx
801031c3:	74 1f                	je     801031e4 <mpinit+0xc4>
801031c5:	01 f1                	add    %esi,%ecx
801031c7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801031ca:	89 f2                	mov    %esi,%edx
801031cc:	89 cb                	mov    %ecx,%ebx
801031ce:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801031d0:	0f b6 0a             	movzbl (%edx),%ecx
801031d3:	83 c2 01             	add    $0x1,%edx
801031d6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d8:	39 da                	cmp    %ebx,%edx
801031da:	75 f4                	jne    801031d0 <mpinit+0xb0>
801031dc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801031df:	84 c0                	test   %al,%al
801031e1:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801031e4:	85 f6                	test   %esi,%esi
801031e6:	74 7b                	je     80103263 <mpinit+0x143>
801031e8:	84 d2                	test   %dl,%dl
801031ea:	75 77                	jne    80103263 <mpinit+0x143>
    return;
  ismp = 1;
801031ec:	c7 05 c4 12 11 80 01 	movl   $0x1,0x801112c4
801031f3:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801031f6:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031fc:	a3 dc 11 11 80       	mov    %eax,0x801111dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103201:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103208:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
8010320e:	01 d6                	add    %edx,%esi
80103210:	39 f0                	cmp    %esi,%eax
80103212:	0f 83 a8 00 00 00    	jae    801032c0 <mpinit+0x1a0>
80103218:	90                   	nop
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103220:	80 38 04             	cmpb   $0x4,(%eax)
80103223:	0f 87 87 00 00 00    	ja     801032b0 <mpinit+0x190>
80103229:	0f b6 10             	movzbl (%eax),%edx
8010322c:	ff 24 95 34 7a 10 80 	jmp    *-0x7fef85cc(,%edx,4)
80103233:	90                   	nop
80103234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103238:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010323b:	39 c6                	cmp    %eax,%esi
8010323d:	77 e1                	ja     80103220 <mpinit+0x100>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
8010323f:	a1 c4 12 11 80       	mov    0x801112c4,%eax
80103244:	85 c0                	test   %eax,%eax
80103246:	75 78                	jne    801032c0 <mpinit+0x1a0>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103248:	c7 05 c0 18 11 80 01 	movl   $0x1,0x801118c0
8010324f:	00 00 00 
    lapic = 0;
80103252:	c7 05 dc 11 11 80 00 	movl   $0x0,0x801111dc
80103259:	00 00 00 
    ioapicid = 0;
8010325c:	c6 05 c0 12 11 80 00 	movb   $0x0,0x801112c0
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103266:	5b                   	pop    %ebx
80103267:	5e                   	pop    %esi
80103268:	5f                   	pop    %edi
80103269:	5d                   	pop    %ebp
8010326a:	c3                   	ret    
8010326b:	90                   	nop
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103270:	8b 15 c0 18 11 80    	mov    0x801118c0,%edx
80103276:	83 fa 07             	cmp    $0x7,%edx
80103279:	7f 19                	jg     80103294 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010327b:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
8010327f:	69 da bc 00 00 00    	imul   $0xbc,%edx,%ebx
        ncpu++;
80103285:	83 c2 01             	add    $0x1,%edx
80103288:	89 15 c0 18 11 80    	mov    %edx,0x801118c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010328e:	88 8b e0 12 11 80    	mov    %cl,-0x7feeed20(%ebx)
      p += sizeof(struct mpproc);
80103294:	83 c0 14             	add    $0x14,%eax
      continue;
80103297:	eb a2                	jmp    8010323b <mpinit+0x11b>
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801032a0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801032a4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801032a7:	88 15 c0 12 11 80    	mov    %dl,0x801112c0
      continue;
801032ad:	eb 8c                	jmp    8010323b <mpinit+0x11b>
801032af:	90                   	nop
      ismp = 0;
801032b0:	c7 05 c4 12 11 80 00 	movl   $0x0,0x801112c4
801032b7:	00 00 00 
      break;
801032ba:	e9 7c ff ff ff       	jmp    8010323b <mpinit+0x11b>
801032bf:	90                   	nop
  if(mp->imcrp){
801032c0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801032c4:	74 9d                	je     80103263 <mpinit+0x143>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c6:	b8 70 00 00 00       	mov    $0x70,%eax
801032cb:	ba 22 00 00 00       	mov    $0x22,%edx
801032d0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d1:	ba 23 00 00 00       	mov    $0x23,%edx
801032d6:	ec                   	in     (%dx),%al
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032d7:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032da:	ee                   	out    %al,(%dx)
}
801032db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032de:	5b                   	pop    %ebx
801032df:	5e                   	pop    %esi
801032e0:	5f                   	pop    %edi
801032e1:	5d                   	pop    %ebp
801032e2:	c3                   	ret    
801032e3:	90                   	nop
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801032e8:	ba 00 00 01 00       	mov    $0x10000,%edx
801032ed:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801032f2:	e8 a9 fd ff ff       	call   801030a0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032f7:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801032f9:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032fb:	0f 85 71 fe ff ff    	jne    80103172 <mpinit+0x52>
80103301:	e9 5d ff ff ff       	jmp    80103263 <mpinit+0x143>
80103306:	66 90                	xchg   %ax,%ax
80103308:	66 90                	xchg   %ax,%ax
8010330a:	66 90                	xchg   %ax,%ax
8010330c:	66 90                	xchg   %ax,%ax
8010330e:	66 90                	xchg   %ax,%ax

80103310 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103310:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103311:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103316:	ba 21 00 00 00       	mov    $0x21,%edx
{
8010331b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010331d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103320:	d3 c0                	rol    %cl,%eax
80103322:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
  irqmask = mask;
80103329:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010332f:	ee                   	out    %al,(%dx)
80103330:	ba a1 00 00 00       	mov    $0xa1,%edx
  outb(IO_PIC2+1, mask >> 8);
80103335:	66 c1 e8 08          	shr    $0x8,%ax
80103339:	ee                   	out    %al,(%dx)
}
8010333a:	5d                   	pop    %ebp
8010333b:	c3                   	ret    
8010333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103340 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103340:	55                   	push   %ebp
80103341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103346:	89 e5                	mov    %esp,%ebp
80103348:	57                   	push   %edi
80103349:	56                   	push   %esi
8010334a:	53                   	push   %ebx
8010334b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103350:	89 da                	mov    %ebx,%edx
80103352:	ee                   	out    %al,(%dx)
80103353:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103358:	89 ca                	mov    %ecx,%edx
8010335a:	ee                   	out    %al,(%dx)
8010335b:	be 11 00 00 00       	mov    $0x11,%esi
80103360:	ba 20 00 00 00       	mov    $0x20,%edx
80103365:	89 f0                	mov    %esi,%eax
80103367:	ee                   	out    %al,(%dx)
80103368:	b8 20 00 00 00       	mov    $0x20,%eax
8010336d:	89 da                	mov    %ebx,%edx
8010336f:	ee                   	out    %al,(%dx)
80103370:	b8 04 00 00 00       	mov    $0x4,%eax
80103375:	ee                   	out    %al,(%dx)
80103376:	bf 03 00 00 00       	mov    $0x3,%edi
8010337b:	89 f8                	mov    %edi,%eax
8010337d:	ee                   	out    %al,(%dx)
8010337e:	ba a0 00 00 00       	mov    $0xa0,%edx
80103383:	89 f0                	mov    %esi,%eax
80103385:	ee                   	out    %al,(%dx)
80103386:	b8 28 00 00 00       	mov    $0x28,%eax
8010338b:	89 ca                	mov    %ecx,%edx
8010338d:	ee                   	out    %al,(%dx)
8010338e:	b8 02 00 00 00       	mov    $0x2,%eax
80103393:	ee                   	out    %al,(%dx)
80103394:	89 f8                	mov    %edi,%eax
80103396:	ee                   	out    %al,(%dx)
80103397:	bf 68 00 00 00       	mov    $0x68,%edi
8010339c:	ba 20 00 00 00       	mov    $0x20,%edx
801033a1:	89 f8                	mov    %edi,%eax
801033a3:	ee                   	out    %al,(%dx)
801033a4:	be 0a 00 00 00       	mov    $0xa,%esi
801033a9:	89 f0                	mov    %esi,%eax
801033ab:	ee                   	out    %al,(%dx)
801033ac:	ba a0 00 00 00       	mov    $0xa0,%edx
801033b1:	89 f8                	mov    %edi,%eax
801033b3:	ee                   	out    %al,(%dx)
801033b4:	89 f0                	mov    %esi,%eax
801033b6:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801033b7:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
801033be:	66 83 f8 ff          	cmp    $0xffff,%ax
801033c2:	74 0a                	je     801033ce <picinit+0x8e>
801033c4:	89 da                	mov    %ebx,%edx
801033c6:	ee                   	out    %al,(%dx)
  outb(IO_PIC2+1, mask >> 8);
801033c7:	66 c1 e8 08          	shr    $0x8,%ax
801033cb:	89 ca                	mov    %ecx,%edx
801033cd:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
801033ce:	5b                   	pop    %ebx
801033cf:	5e                   	pop    %esi
801033d0:	5f                   	pop    %edi
801033d1:	5d                   	pop    %ebp
801033d2:	c3                   	ret    
801033d3:	66 90                	xchg   %ax,%ax
801033d5:	66 90                	xchg   %ax,%ax
801033d7:	66 90                	xchg   %ax,%ax
801033d9:	66 90                	xchg   %ax,%ax
801033db:	66 90                	xchg   %ax,%ax
801033dd:	66 90                	xchg   %ax,%ax
801033df:	90                   	nop

801033e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033fb:	e8 50 d9 ff ff       	call   80100d50 <filealloc>
80103400:	85 c0                	test   %eax,%eax
80103402:	89 03                	mov    %eax,(%ebx)
80103404:	74 22                	je     80103428 <pipealloc+0x48>
80103406:	e8 45 d9 ff ff       	call   80100d50 <filealloc>
8010340b:	85 c0                	test   %eax,%eax
8010340d:	89 06                	mov    %eax,(%esi)
8010340f:	74 3f                	je     80103450 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103411:	e8 9a f0 ff ff       	call   801024b0 <kalloc>
80103416:	85 c0                	test   %eax,%eax
80103418:	89 c7                	mov    %eax,%edi
8010341a:	75 54                	jne    80103470 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010341c:	8b 03                	mov    (%ebx),%eax
8010341e:	85 c0                	test   %eax,%eax
80103420:	75 34                	jne    80103456 <pipealloc+0x76>
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103428:	8b 06                	mov    (%esi),%eax
8010342a:	85 c0                	test   %eax,%eax
8010342c:	74 0c                	je     8010343a <pipealloc+0x5a>
    fileclose(*f1);
8010342e:	83 ec 0c             	sub    $0xc,%esp
80103431:	50                   	push   %eax
80103432:	e8 d9 d9 ff ff       	call   80100e10 <fileclose>
80103437:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010343a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010343d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103442:	5b                   	pop    %ebx
80103443:	5e                   	pop    %esi
80103444:	5f                   	pop    %edi
80103445:	5d                   	pop    %ebp
80103446:	c3                   	ret    
80103447:	89 f6                	mov    %esi,%esi
80103449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103450:	8b 03                	mov    (%ebx),%eax
80103452:	85 c0                	test   %eax,%eax
80103454:	74 e4                	je     8010343a <pipealloc+0x5a>
    fileclose(*f0);
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	50                   	push   %eax
8010345a:	e8 b1 d9 ff ff       	call   80100e10 <fileclose>
  if(*f1)
8010345f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103461:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103464:	85 c0                	test   %eax,%eax
80103466:	75 c6                	jne    8010342e <pipealloc+0x4e>
80103468:	eb d0                	jmp    8010343a <pipealloc+0x5a>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103470:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103473:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347a:	00 00 00 
  p->writeopen = 1;
8010347d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103484:	00 00 00 
  p->nwrite = 0;
80103487:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010348e:	00 00 00 
  p->nread = 0;
80103491:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103498:	00 00 00 
  initlock(&p->lock, "pipe");
8010349b:	68 48 7a 10 80       	push   $0x80107a48
801034a0:	50                   	push   %eax
801034a1:	e8 ca 13 00 00       	call   80104870 <initlock>
  (*f0)->type = FD_PIPE;
801034a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801034a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b1:	8b 03                	mov    (%ebx),%eax
801034b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034b7:	8b 03                	mov    (%ebx),%eax
801034b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034bd:	8b 03                	mov    (%ebx),%eax
801034bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034c2:	8b 06                	mov    (%esi),%eax
801034c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d0:	8b 06                	mov    (%esi),%eax
801034d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034d6:	8b 06                	mov    (%esi),%eax
801034d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801034db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034de:	31 c0                	xor    %eax,%eax
}
801034e0:	5b                   	pop    %ebx
801034e1:	5e                   	pop    %esi
801034e2:	5f                   	pop    %edi
801034e3:	5d                   	pop    %ebp
801034e4:	c3                   	ret    
801034e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801034f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	56                   	push   %esi
801034f4:	53                   	push   %ebx
801034f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034fb:	83 ec 0c             	sub    $0xc,%esp
801034fe:	53                   	push   %ebx
801034ff:	e8 8c 13 00 00       	call   80104890 <acquire>
  if(writable){
80103504:	83 c4 10             	add    $0x10,%esp
80103507:	85 f6                	test   %esi,%esi
80103509:	74 45                	je     80103550 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010350b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103511:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103514:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010351b:	00 00 00 
    wakeup(&p->nread);
8010351e:	50                   	push   %eax
8010351f:	e8 5c 0b 00 00       	call   80104080 <wakeup>
80103524:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103527:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010352d:	85 d2                	test   %edx,%edx
8010352f:	75 0a                	jne    8010353b <pipeclose+0x4b>
80103531:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103537:	85 c0                	test   %eax,%eax
80103539:	74 35                	je     80103570 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010353b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010353e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103541:	5b                   	pop    %ebx
80103542:	5e                   	pop    %esi
80103543:	5d                   	pop    %ebp
    release(&p->lock);
80103544:	e9 27 15 00 00       	jmp    80104a70 <release>
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103550:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103556:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103559:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103560:	00 00 00 
    wakeup(&p->nwrite);
80103563:	50                   	push   %eax
80103564:	e8 17 0b 00 00       	call   80104080 <wakeup>
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	eb b9                	jmp    80103527 <pipeclose+0x37>
8010356e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	53                   	push   %ebx
80103574:	e8 f7 14 00 00       	call   80104a70 <release>
    kfree((char*)p);
80103579:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010357c:	83 c4 10             	add    $0x10,%esp
}
8010357f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103582:	5b                   	pop    %ebx
80103583:	5e                   	pop    %esi
80103584:	5d                   	pop    %ebp
    kfree((char*)p);
80103585:	e9 76 ed ff ff       	jmp    80102300 <kfree>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103590 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 28             	sub    $0x28,%esp
80103599:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010359c:	57                   	push   %edi
8010359d:	e8 ee 12 00 00       	call   80104890 <acquire>
  for(i = 0; i < n; i++){
801035a2:	8b 45 10             	mov    0x10(%ebp),%eax
801035a5:	83 c4 10             	add    $0x10,%esp
801035a8:	85 c0                	test   %eax,%eax
801035aa:	0f 8e c6 00 00 00    	jle    80103676 <pipewrite+0xe6>
801035b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801035b3:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
801035b9:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
801035bf:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
801035c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035c8:	03 45 10             	add    0x10(%ebp),%eax
801035cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ce:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801035d4:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801035da:	39 d1                	cmp    %edx,%ecx
801035dc:	0f 85 cf 00 00 00    	jne    801036b1 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
801035e2:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801035e8:	85 d2                	test   %edx,%edx
801035ea:	0f 84 a8 00 00 00    	je     80103698 <pipewrite+0x108>
801035f0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801035f7:	8b 42 24             	mov    0x24(%edx),%eax
801035fa:	85 c0                	test   %eax,%eax
801035fc:	74 25                	je     80103623 <pipewrite+0x93>
801035fe:	e9 95 00 00 00       	jmp    80103698 <pipewrite+0x108>
80103603:	90                   	nop
80103604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103608:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010360e:	85 c0                	test   %eax,%eax
80103610:	0f 84 82 00 00 00    	je     80103698 <pipewrite+0x108>
80103616:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010361c:	8b 40 24             	mov    0x24(%eax),%eax
8010361f:	85 c0                	test   %eax,%eax
80103621:	75 75                	jne    80103698 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103623:	83 ec 0c             	sub    $0xc,%esp
80103626:	56                   	push   %esi
80103627:	e8 54 0a 00 00       	call   80104080 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010362c:	59                   	pop    %ecx
8010362d:	58                   	pop    %eax
8010362e:	57                   	push   %edi
8010362f:	53                   	push   %ebx
80103630:	e8 5b 08 00 00       	call   80103e90 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103635:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
8010363b:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	05 00 02 00 00       	add    $0x200,%eax
80103649:	39 c2                	cmp    %eax,%edx
8010364b:	74 bb                	je     80103608 <pipewrite+0x78>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010364d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103650:	8d 4a 01             	lea    0x1(%edx),%ecx
80103653:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103657:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010365d:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
80103663:	0f b6 00             	movzbl (%eax),%eax
80103666:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
8010366a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(i = 0; i < n; i++){
8010366d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80103670:	0f 85 58 ff ff ff    	jne    801035ce <pipewrite+0x3e>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103676:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
8010367c:	83 ec 0c             	sub    $0xc,%esp
8010367f:	52                   	push   %edx
80103680:	e8 fb 09 00 00       	call   80104080 <wakeup>
  release(&p->lock);
80103685:	89 3c 24             	mov    %edi,(%esp)
80103688:	e8 e3 13 00 00       	call   80104a70 <release>
  return n;
8010368d:	83 c4 10             	add    $0x10,%esp
80103690:	8b 45 10             	mov    0x10(%ebp),%eax
80103693:	eb 14                	jmp    801036a9 <pipewrite+0x119>
80103695:	8d 76 00             	lea    0x0(%esi),%esi
        release(&p->lock);
80103698:	83 ec 0c             	sub    $0xc,%esp
8010369b:	57                   	push   %edi
8010369c:	e8 cf 13 00 00       	call   80104a70 <release>
        return -1;
801036a1:	83 c4 10             	add    $0x10,%esp
801036a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ac:	5b                   	pop    %ebx
801036ad:	5e                   	pop    %esi
801036ae:	5f                   	pop    %edi
801036af:	5d                   	pop    %ebp
801036b0:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b1:	89 ca                	mov    %ecx,%edx
801036b3:	eb 98                	jmp    8010364d <pipewrite+0xbd>
801036b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 18             	sub    $0x18,%esp
801036c9:	8b 75 08             	mov    0x8(%ebp),%esi
801036cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036cf:	56                   	push   %esi
801036d0:	e8 bb 11 00 00       	call   80104890 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036de:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036e4:	75 64                	jne    8010374a <piperead+0x8a>
801036e6:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801036ec:	85 c0                	test   %eax,%eax
801036ee:	0f 84 bc 00 00 00    	je     801037b0 <piperead+0xf0>
    if(proc->killed){
801036f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801036fa:	8b 58 24             	mov    0x24(%eax),%ebx
801036fd:	85 db                	test   %ebx,%ebx
801036ff:	0f 85 b3 00 00 00    	jne    801037b8 <piperead+0xf8>
80103705:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010370b:	eb 22                	jmp    8010372f <piperead+0x6f>
8010370d:	8d 76 00             	lea    0x0(%esi),%esi
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103710:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103716:	85 d2                	test   %edx,%edx
80103718:	0f 84 92 00 00 00    	je     801037b0 <piperead+0xf0>
    if(proc->killed){
8010371e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103724:	8b 48 24             	mov    0x24(%eax),%ecx
80103727:	85 c9                	test   %ecx,%ecx
80103729:	0f 85 89 00 00 00    	jne    801037b8 <piperead+0xf8>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010372f:	83 ec 08             	sub    $0x8,%esp
80103732:	56                   	push   %esi
80103733:	53                   	push   %ebx
80103734:	e8 57 07 00 00       	call   80103e90 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103742:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103748:	74 c6                	je     80103710 <piperead+0x50>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010374a:	8b 45 10             	mov    0x10(%ebp),%eax
8010374d:	85 c0                	test   %eax,%eax
8010374f:	7e 5f                	jle    801037b0 <piperead+0xf0>
    if(p->nread == p->nwrite)
80103751:	31 db                	xor    %ebx,%ebx
80103753:	eb 11                	jmp    80103766 <piperead+0xa6>
80103755:	8d 76 00             	lea    0x0(%esi),%esi
80103758:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010375e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103764:	74 1f                	je     80103785 <piperead+0xc5>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103766:	8d 41 01             	lea    0x1(%ecx),%eax
80103769:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
8010376f:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103775:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
8010377a:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010377d:	83 c3 01             	add    $0x1,%ebx
80103780:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103783:	75 d3                	jne    80103758 <piperead+0x98>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103785:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
8010378b:	83 ec 0c             	sub    $0xc,%esp
8010378e:	50                   	push   %eax
8010378f:	e8 ec 08 00 00       	call   80104080 <wakeup>
  release(&p->lock);
80103794:	89 34 24             	mov    %esi,(%esp)
80103797:	e8 d4 12 00 00       	call   80104a70 <release>
  return i;
8010379c:	83 c4 10             	add    $0x10,%esp
}
8010379f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a2:	89 d8                	mov    %ebx,%eax
801037a4:	5b                   	pop    %ebx
801037a5:	5e                   	pop    %esi
801037a6:	5f                   	pop    %edi
801037a7:	5d                   	pop    %ebp
801037a8:	c3                   	ret    
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801037b0:	31 db                	xor    %ebx,%ebx
801037b2:	eb d1                	jmp    80103785 <piperead+0xc5>
801037b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
801037b8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037c0:	56                   	push   %esi
801037c1:	e8 aa 12 00 00       	call   80104a70 <release>
      return -1;
801037c6:	83 c4 10             	add    $0x10,%esp
}
801037c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037cc:	89 d8                	mov    %ebx,%eax
801037ce:	5b                   	pop    %ebx
801037cf:	5e                   	pop    %esi
801037d0:	5f                   	pop    %edi
801037d1:	5d                   	pop    %ebp
801037d2:	c3                   	ret    
801037d3:	66 90                	xchg   %ax,%ax
801037d5:	66 90                	xchg   %ax,%ax
801037d7:	66 90                	xchg   %ax,%ax
801037d9:	66 90                	xchg   %ax,%ax
801037db:	66 90                	xchg   %ax,%ax
801037dd:	66 90                	xchg   %ax,%ax
801037df:	90                   	nop

801037e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc *
allocproc(void) {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
    struct proc *p;
    char *sp;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e4:	bb 14 19 11 80       	mov    $0x80111914,%ebx
allocproc(void) {
801037e9:	83 ec 04             	sub    $0x4,%esp
801037ec:	eb 10                	jmp    801037fe <allocproc+0x1e>
801037ee:	66 90                	xchg   %ax,%ax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801037f6:	81 fb 14 3d 11 80    	cmp    $0x80113d14,%ebx
801037fc:	73 6b                	jae    80103869 <allocproc+0x89>
        if (p->state == UNUSED)
801037fe:	8b 43 0c             	mov    0xc(%ebx),%eax
80103801:	85 c0                	test   %eax,%eax
80103803:	75 eb                	jne    801037f0 <allocproc+0x10>
            goto found;
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103805:	a1 08 a0 10 80       	mov    0x8010a008,%eax
    p->state = EMBRYO;
8010380a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103811:	8d 50 01             	lea    0x1(%eax),%edx
80103814:	89 43 10             	mov    %eax,0x10(%ebx)
80103817:	89 15 08 a0 10 80    	mov    %edx,0x8010a008

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
8010381d:	e8 8e ec ff ff       	call   801024b0 <kalloc>
80103822:	85 c0                	test   %eax,%eax
80103824:	89 43 08             	mov    %eax,0x8(%ebx)
80103827:	74 39                	je     80103862 <allocproc+0x82>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103829:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
8010382f:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103832:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103837:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *) sp = (uint) trapret;
8010383a:	c7 40 14 ee 5c 10 80 	movl   $0x80105cee,0x14(%eax)
    p->context = (struct context *) sp;
80103841:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103844:	6a 14                	push   $0x14
80103846:	6a 00                	push   $0x0
80103848:	50                   	push   %eax
80103849:	e8 72 12 00 00       	call   80104ac0 <memset>
    p->context->eip = (uint) forkret;
8010384e:	8b 43 1c             	mov    0x1c(%ebx),%eax

    return p;
80103851:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint) forkret;
80103854:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
8010385b:	89 d8                	mov    %ebx,%eax
8010385d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103860:	c9                   	leave  
80103861:	c3                   	ret    
        p->state = UNUSED;
80103862:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103869:	31 db                	xor    %ebx,%ebx
}
8010386b:	89 d8                	mov    %ebx,%eax
8010386d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103870:	c9                   	leave  
80103871:	c3                   	ret    
80103872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103880 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103886:	68 e0 18 11 80       	push   $0x801118e0
8010388b:	e8 e0 11 00 00       	call   80104a70 <release>

    if (first) {
80103890:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	85 c0                	test   %eax,%eax
8010389a:	75 04                	jne    801038a0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
8010389c:	c9                   	leave  
8010389d:	c3                   	ret    
8010389e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
801038a0:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
801038a3:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
801038aa:	00 00 00 
        iinit(ROOTDEV);
801038ad:	6a 01                	push   $0x1
801038af:	e8 8c db ff ff       	call   80101440 <iinit>
        initlog(ROOTDEV);
801038b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038bb:	e8 e0 f2 ff ff       	call   80102ba0 <initlog>
801038c0:	83 c4 10             	add    $0x10,%esp
}
801038c3:	c9                   	leave  
801038c4:	c3                   	ret    
801038c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <pinit>:
pinit(void) {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
801038d6:	68 4d 7a 10 80       	push   $0x80107a4d
801038db:	68 e0 18 11 80       	push   $0x801118e0
801038e0:	e8 8b 0f 00 00       	call   80104870 <initlock>
}
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	c9                   	leave  
801038e9:	c3                   	ret    
801038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038f0 <userinit>:
userinit(void) {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
801038f7:	68 e0 18 11 80       	push   $0x801118e0
801038fc:	e8 8f 0f 00 00       	call   80104890 <acquire>
    p = allocproc();
80103901:	e8 da fe ff ff       	call   801037e0 <allocproc>
80103906:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103908:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
    if ((p->pgdir = setupkvm()) == 0)
8010390d:	e8 6e 35 00 00       	call   80106e80 <setupkvm>
80103912:	83 c4 10             	add    $0x10,%esp
80103915:	85 c0                	test   %eax,%eax
80103917:	89 43 04             	mov    %eax,0x4(%ebx)
8010391a:	0f 84 b1 00 00 00    	je     801039d1 <userinit+0xe1>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103920:	83 ec 04             	sub    $0x4,%esp
80103923:	68 2c 00 00 00       	push   $0x2c
80103928:	68 60 a4 10 80       	push   $0x8010a460
8010392d:	50                   	push   %eax
8010392e:	e8 9d 36 00 00       	call   80106fd0 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103933:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103936:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
8010393c:	6a 4c                	push   $0x4c
8010393e:	6a 00                	push   $0x0
80103940:	ff 73 18             	pushl  0x18(%ebx)
80103943:	e8 78 11 00 00       	call   80104ac0 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103948:	8b 43 18             	mov    0x18(%ebx),%eax
8010394b:	ba 23 00 00 00       	mov    $0x23,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103950:	b9 2b 00 00 00       	mov    $0x2b,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103955:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103958:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010395c:	8b 43 18             	mov    0x18(%ebx),%eax
8010395f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103963:	8b 43 18             	mov    0x18(%ebx),%eax
80103966:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010396a:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
8010396e:	8b 43 18             	mov    0x18(%ebx),%eax
80103971:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103975:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103979:	8b 43 18             	mov    0x18(%ebx),%eax
8010397c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103983:	8b 43 18             	mov    0x18(%ebx),%eax
80103986:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
8010398d:	8b 43 18             	mov    0x18(%ebx),%eax
80103990:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103997:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010399a:	6a 10                	push   $0x10
8010399c:	68 6d 7a 10 80       	push   $0x80107a6d
801039a1:	50                   	push   %eax
801039a2:	e8 f9 12 00 00       	call   80104ca0 <safestrcpy>
    p->cwd = namei("/");
801039a7:	c7 04 24 76 7a 10 80 	movl   $0x80107a76,(%esp)
801039ae:	e8 fd e4 ff ff       	call   80101eb0 <namei>
    p->state = RUNNABLE;
801039b3:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    p->cwd = namei("/");
801039ba:	89 43 68             	mov    %eax,0x68(%ebx)
    release(&ptable.lock);
801039bd:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801039c4:	e8 a7 10 00 00       	call   80104a70 <release>
}
801039c9:	83 c4 10             	add    $0x10,%esp
801039cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039cf:	c9                   	leave  
801039d0:	c3                   	ret    
        panic("userinit: out of memory?");
801039d1:	83 ec 0c             	sub    $0xc,%esp
801039d4:	68 54 7a 10 80       	push   $0x80107a54
801039d9:	e8 92 c9 ff ff       	call   80100370 <panic>
801039de:	66 90                	xchg   %ax,%ax

801039e0 <growproc>:
growproc(int n) {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 08             	sub    $0x8,%esp
    sz = proc->sz;
801039e6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
growproc(int n) {
801039ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
    sz = proc->sz;
801039f0:	8b 02                	mov    (%edx),%eax
    if (n > 0) {
801039f2:	83 f9 00             	cmp    $0x0,%ecx
801039f5:	7f 21                	jg     80103a18 <growproc+0x38>
    } else if (n < 0) {
801039f7:	75 47                	jne    80103a40 <growproc+0x60>
    proc->sz = sz;
801039f9:	89 02                	mov    %eax,(%edx)
    switchuvm(proc);
801039fb:	83 ec 0c             	sub    $0xc,%esp
801039fe:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
80103a05:	e8 26 35 00 00       	call   80106f30 <switchuvm>
    return 0;
80103a0a:	83 c4 10             	add    $0x10,%esp
80103a0d:	31 c0                	xor    %eax,%eax
}
80103a0f:	c9                   	leave  
80103a10:	c3                   	ret    
80103a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if ((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a18:	83 ec 04             	sub    $0x4,%esp
80103a1b:	01 c1                	add    %eax,%ecx
80103a1d:	51                   	push   %ecx
80103a1e:	50                   	push   %eax
80103a1f:	ff 72 04             	pushl  0x4(%edx)
80103a22:	e8 e9 36 00 00       	call   80107110 <allocuvm>
80103a27:	83 c4 10             	add    $0x10,%esp
80103a2a:	85 c0                	test   %eax,%eax
80103a2c:	74 28                	je     80103a56 <growproc+0x76>
80103a2e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a35:	eb c2                	jmp    801039f9 <growproc+0x19>
80103a37:	89 f6                	mov    %esi,%esi
80103a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if ((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a40:	83 ec 04             	sub    $0x4,%esp
80103a43:	01 c1                	add    %eax,%ecx
80103a45:	51                   	push   %ecx
80103a46:	50                   	push   %eax
80103a47:	ff 72 04             	pushl  0x4(%edx)
80103a4a:	e8 f1 37 00 00       	call   80107240 <deallocuvm>
80103a4f:	83 c4 10             	add    $0x10,%esp
80103a52:	85 c0                	test   %eax,%eax
80103a54:	75 d8                	jne    80103a2e <growproc+0x4e>
            return -1;
80103a56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a5b:	c9                   	leave  
80103a5c:	c3                   	ret    
80103a5d:	8d 76 00             	lea    0x0(%esi),%esi

80103a60 <fork>:
fork(void) {
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	57                   	push   %edi
80103a64:	56                   	push   %esi
80103a65:	53                   	push   %ebx
80103a66:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80103a69:	68 e0 18 11 80       	push   $0x801118e0
80103a6e:	e8 1d 0e 00 00       	call   80104890 <acquire>
    if ((np = allocproc()) == 0) {
80103a73:	e8 68 fd ff ff       	call   801037e0 <allocproc>
80103a78:	83 c4 10             	add    $0x10,%esp
80103a7b:	85 c0                	test   %eax,%eax
80103a7d:	0f 84 cd 00 00 00    	je     80103b50 <fork+0xf0>
80103a83:	89 c3                	mov    %eax,%ebx
    if ((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0) {
80103a85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a8b:	83 ec 08             	sub    $0x8,%esp
80103a8e:	ff 30                	pushl  (%eax)
80103a90:	ff 70 04             	pushl  0x4(%eax)
80103a93:	e8 88 38 00 00       	call   80107320 <copyuvm>
80103a98:	83 c4 10             	add    $0x10,%esp
80103a9b:	85 c0                	test   %eax,%eax
80103a9d:	89 43 04             	mov    %eax,0x4(%ebx)
80103aa0:	0f 84 c1 00 00 00    	je     80103b67 <fork+0x107>
    np->sz = proc->sz;
80103aa6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    *np->tf = *proc->tf;
80103aac:	8b 7b 18             	mov    0x18(%ebx),%edi
80103aaf:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = proc->sz;
80103ab4:	8b 00                	mov    (%eax),%eax
80103ab6:	89 03                	mov    %eax,(%ebx)
    np->parent = proc;
80103ab8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103abe:	89 43 14             	mov    %eax,0x14(%ebx)
    *np->tf = *proc->tf;
80103ac1:	8b 70 18             	mov    0x18(%eax),%esi
80103ac4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103ac6:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103ac8:	8b 43 18             	mov    0x18(%ebx),%eax
80103acb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103ad2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (proc->ofile[i])
80103ae0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103ae4:	85 c0                	test   %eax,%eax
80103ae6:	74 17                	je     80103aff <fork+0x9f>
            np->ofile[i] = filedup(proc->ofile[i]);
80103ae8:	83 ec 0c             	sub    $0xc,%esp
80103aeb:	50                   	push   %eax
80103aec:	e8 cf d2 ff ff       	call   80100dc0 <filedup>
80103af1:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103af5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103afc:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NOFILE; i++)
80103aff:	83 c6 01             	add    $0x1,%esi
80103b02:	83 fe 10             	cmp    $0x10,%esi
80103b05:	75 d9                	jne    80103ae0 <fork+0x80>
    np->cwd = idup(proc->cwd);
80103b07:	83 ec 0c             	sub    $0xc,%esp
80103b0a:	ff 72 68             	pushl  0x68(%edx)
80103b0d:	e8 ce da ff ff       	call   801015e0 <idup>
80103b12:	89 43 68             	mov    %eax,0x68(%ebx)
    safestrcpy(np->name, proc->name, sizeof(proc->name));
80103b15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b1b:	83 c4 0c             	add    $0xc,%esp
80103b1e:	6a 10                	push   $0x10
80103b20:	83 c0 6c             	add    $0x6c,%eax
80103b23:	50                   	push   %eax
80103b24:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b27:	50                   	push   %eax
80103b28:	e8 73 11 00 00       	call   80104ca0 <safestrcpy>
    np->state = RUNNABLE;
80103b2d:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    pid = np->pid;
80103b34:	8b 73 10             	mov    0x10(%ebx),%esi
    release(&ptable.lock);
80103b37:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103b3e:	e8 2d 0f 00 00       	call   80104a70 <release>
    return pid;
80103b43:	83 c4 10             	add    $0x10,%esp
}
80103b46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b49:	89 f0                	mov    %esi,%eax
80103b4b:	5b                   	pop    %ebx
80103b4c:	5e                   	pop    %esi
80103b4d:	5f                   	pop    %edi
80103b4e:	5d                   	pop    %ebp
80103b4f:	c3                   	ret    
        release(&ptable.lock);
80103b50:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103b53:	be ff ff ff ff       	mov    $0xffffffff,%esi
        release(&ptable.lock);
80103b58:	68 e0 18 11 80       	push   $0x801118e0
80103b5d:	e8 0e 0f 00 00       	call   80104a70 <release>
        return -1;
80103b62:	83 c4 10             	add    $0x10,%esp
80103b65:	eb df                	jmp    80103b46 <fork+0xe6>
        kfree(np->kstack);
80103b67:	83 ec 0c             	sub    $0xc,%esp
80103b6a:	ff 73 08             	pushl  0x8(%ebx)
        return -1;
80103b6d:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->kstack);
80103b72:	e8 89 e7 ff ff       	call   80102300 <kfree>
        np->kstack = 0;
80103b77:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80103b7e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103b85:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103b8c:	e8 df 0e 00 00       	call   80104a70 <release>
        return -1;
80103b91:	83 c4 10             	add    $0x10,%esp
80103b94:	eb b0                	jmp    80103b46 <fork+0xe6>
80103b96:	8d 76 00             	lea    0x0(%esi),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ba0 <fifoProc>:
fifoProc() {
80103ba0:	55                   	push   %ebp
}
80103ba1:	a1 14 3d 11 80       	mov    0x80113d14,%eax
fifoProc() {
80103ba6:	89 e5                	mov    %esp,%ebp
}
80103ba8:	5d                   	pop    %ebp
80103ba9:	c3                   	ret    
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bb0 <sched>:
sched(void) {
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	53                   	push   %ebx
80103bb4:	83 ec 10             	sub    $0x10,%esp
    if (!holding(&ptable.lock))
80103bb7:	68 e0 18 11 80       	push   $0x801118e0
80103bbc:	e8 ff 0d 00 00       	call   801049c0 <holding>
80103bc1:	83 c4 10             	add    $0x10,%esp
80103bc4:	85 c0                	test   %eax,%eax
80103bc6:	74 4c                	je     80103c14 <sched+0x64>
    if (cpu->ncli != 1)
80103bc8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103bcf:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103bd6:	75 63                	jne    80103c3b <sched+0x8b>
    if (proc->state == RUNNING)
80103bd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bde:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103be2:	74 4a                	je     80103c2e <sched+0x7e>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103be4:	9c                   	pushf  
80103be5:	59                   	pop    %ecx
    if (readeflags() & FL_IF)
80103be6:	80 e5 02             	and    $0x2,%ch
80103be9:	75 36                	jne    80103c21 <sched+0x71>
    swtch(&proc->context, cpu->scheduler);
80103beb:	83 ec 08             	sub    $0x8,%esp
80103bee:	83 c0 1c             	add    $0x1c,%eax
    intena = cpu->intena;
80103bf1:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
    swtch(&proc->context, cpu->scheduler);
80103bf7:	ff 72 04             	pushl  0x4(%edx)
80103bfa:	50                   	push   %eax
80103bfb:	e8 fb 10 00 00       	call   80104cfb <swtch>
    cpu->intena = intena;
80103c00:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103c06:	83 c4 10             	add    $0x10,%esp
    cpu->intena = intena;
80103c09:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c12:	c9                   	leave  
80103c13:	c3                   	ret    
        panic("sched ptable.lock");
80103c14:	83 ec 0c             	sub    $0xc,%esp
80103c17:	68 78 7a 10 80       	push   $0x80107a78
80103c1c:	e8 4f c7 ff ff       	call   80100370 <panic>
        panic("sched interruptible");
80103c21:	83 ec 0c             	sub    $0xc,%esp
80103c24:	68 a4 7a 10 80       	push   $0x80107aa4
80103c29:	e8 42 c7 ff ff       	call   80100370 <panic>
        panic("sched running");
80103c2e:	83 ec 0c             	sub    $0xc,%esp
80103c31:	68 96 7a 10 80       	push   $0x80107a96
80103c36:	e8 35 c7 ff ff       	call   80100370 <panic>
        panic("sched locks");
80103c3b:	83 ec 0c             	sub    $0xc,%esp
80103c3e:	68 8a 7a 10 80       	push   $0x80107a8a
80103c43:	e8 28 c7 ff ff       	call   80100370 <panic>
80103c48:	90                   	nop
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <exit>:
exit(void) {
80103c50:	55                   	push   %ebp
    if (proc == initproc)
80103c51:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
exit(void) {
80103c58:	89 e5                	mov    %esp,%ebp
80103c5a:	56                   	push   %esi
80103c5b:	53                   	push   %ebx
80103c5c:	31 db                	xor    %ebx,%ebx
    if (proc == initproc)
80103c5e:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
80103c64:	0f 84 27 01 00 00    	je     80103d91 <exit+0x141>
80103c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (proc->ofile[fd]) {
80103c70:	8d 73 08             	lea    0x8(%ebx),%esi
80103c73:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103c77:	85 c0                	test   %eax,%eax
80103c79:	74 1b                	je     80103c96 <exit+0x46>
            fileclose(proc->ofile[fd]);
80103c7b:	83 ec 0c             	sub    $0xc,%esp
80103c7e:	50                   	push   %eax
80103c7f:	e8 8c d1 ff ff       	call   80100e10 <fileclose>
            proc->ofile[fd] = 0;
80103c84:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c8b:	83 c4 10             	add    $0x10,%esp
80103c8e:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103c95:	00 
    for (fd = 0; fd < NOFILE; fd++) {
80103c96:	83 c3 01             	add    $0x1,%ebx
80103c99:	83 fb 10             	cmp    $0x10,%ebx
80103c9c:	75 d2                	jne    80103c70 <exit+0x20>
    begin_op();
80103c9e:	e8 9d ef ff ff       	call   80102c40 <begin_op>
    iput(proc->cwd);
80103ca3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ca9:	83 ec 0c             	sub    $0xc,%esp
80103cac:	ff 70 68             	pushl  0x68(%eax)
80103caf:	e8 cc da ff ff       	call   80101780 <iput>
    end_op();
80103cb4:	e8 f7 ef ff ff       	call   80102cb0 <end_op>
    proc->cwd = 0;
80103cb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cbf:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
    cprintf("Exitting PID: %d\n", proc->pid);
80103cc6:	5a                   	pop    %edx
80103cc7:	59                   	pop    %ecx
80103cc8:	ff 70 10             	pushl  0x10(%eax)
80103ccb:	68 c5 7a 10 80       	push   $0x80107ac5
80103cd0:	e8 6b c9 ff ff       	call   80100640 <cprintf>
    acquire(&ptable.lock);
80103cd5:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103cdc:	e8 af 0b 00 00       	call   80104890 <acquire>
    wakeup1(proc->parent);
80103ce1:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
80103ce8:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ceb:	b8 14 19 11 80       	mov    $0x80111914,%eax
    wakeup1(proc->parent);
80103cf0:	8b 53 14             	mov    0x14(%ebx),%edx
80103cf3:	eb 0f                	jmp    80103d04 <exit+0xb4>
80103cf5:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf8:	05 90 00 00 00       	add    $0x90,%eax
80103cfd:	3d 14 3d 11 80       	cmp    $0x80113d14,%eax
80103d02:	73 1e                	jae    80103d22 <exit+0xd2>
        if (p->state == SLEEPING && p->chan == chan)
80103d04:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d08:	75 ee                	jne    80103cf8 <exit+0xa8>
80103d0a:	3b 50 20             	cmp    0x20(%eax),%edx
80103d0d:	75 e9                	jne    80103cf8 <exit+0xa8>
            p->state = RUNNABLE;
80103d0f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d16:	05 90 00 00 00       	add    $0x90,%eax
80103d1b:	3d 14 3d 11 80       	cmp    $0x80113d14,%eax
80103d20:	72 e2                	jb     80103d04 <exit+0xb4>
            p->parent = initproc;
80103d22:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d28:	ba 14 19 11 80       	mov    $0x80111914,%edx
80103d2d:	eb 0f                	jmp    80103d3e <exit+0xee>
80103d2f:	90                   	nop
80103d30:	81 c2 90 00 00 00    	add    $0x90,%edx
80103d36:	81 fa 14 3d 11 80    	cmp    $0x80113d14,%edx
80103d3c:	73 3a                	jae    80103d78 <exit+0x128>
        if (p->parent == proc) {
80103d3e:	3b 5a 14             	cmp    0x14(%edx),%ebx
80103d41:	75 ed                	jne    80103d30 <exit+0xe0>
            if (p->state == ZOMBIE)
80103d43:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80103d47:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
80103d4a:	75 e4                	jne    80103d30 <exit+0xe0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d4c:	b8 14 19 11 80       	mov    $0x80111914,%eax
80103d51:	eb 11                	jmp    80103d64 <exit+0x114>
80103d53:	90                   	nop
80103d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d58:	05 90 00 00 00       	add    $0x90,%eax
80103d5d:	3d 14 3d 11 80       	cmp    $0x80113d14,%eax
80103d62:	73 cc                	jae    80103d30 <exit+0xe0>
        if (p->state == SLEEPING && p->chan == chan)
80103d64:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d68:	75 ee                	jne    80103d58 <exit+0x108>
80103d6a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d6d:	75 e9                	jne    80103d58 <exit+0x108>
            p->state = RUNNABLE;
80103d6f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d76:	eb e0                	jmp    80103d58 <exit+0x108>
    proc->state = ZOMBIE;
80103d78:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
80103d7f:	e8 2c fe ff ff       	call   80103bb0 <sched>
    panic("zombie exit");
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 d7 7a 10 80       	push   $0x80107ad7
80103d8c:	e8 df c5 ff ff       	call   80100370 <panic>
        panic("init exiting");
80103d91:	83 ec 0c             	sub    $0xc,%esp
80103d94:	68 b8 7a 10 80       	push   $0x80107ab8
80103d99:	e8 d2 c5 ff ff       	call   80100370 <panic>
80103d9e:	66 90                	xchg   %ax,%ax

80103da0 <yield>:
yield(void) {
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80103da6:	68 e0 18 11 80       	push   $0x801118e0
80103dab:	e8 e0 0a 00 00       	call   80104890 <acquire>
    proc->state = RUNNABLE;
80103db0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103db6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80103dbd:	e8 ee fd ff ff       	call   80103bb0 <sched>
    release(&ptable.lock);
80103dc2:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103dc9:	e8 a2 0c 00 00       	call   80104a70 <release>
}
80103dce:	83 c4 10             	add    $0x10,%esp
80103dd1:	c9                   	leave  
80103dd2:	c3                   	ret    
80103dd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103de0 <mycpu>:
mycpu(void) {
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	56                   	push   %esi
80103de4:	53                   	push   %ebx
80103de5:	9c                   	pushf  
80103de6:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103de7:	f6 c4 02             	test   $0x2,%ah
80103dea:	75 5e                	jne    80103e4a <mycpu+0x6a>
    apicid = lapicid();
80103dec:	e8 2f e9 ff ff       	call   80102720 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103df1:	8b 35 c0 18 11 80    	mov    0x801118c0,%esi
80103df7:	85 f6                	test   %esi,%esi
80103df9:	7e 42                	jle    80103e3d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103dfb:	0f b6 15 e0 12 11 80 	movzbl 0x801112e0,%edx
80103e02:	39 d0                	cmp    %edx,%eax
80103e04:	74 30                	je     80103e36 <mycpu+0x56>
80103e06:	b9 9c 13 11 80       	mov    $0x8011139c,%ecx
    for (i = 0; i < ncpu; ++i) {
80103e0b:	31 d2                	xor    %edx,%edx
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
80103e10:	83 c2 01             	add    $0x1,%edx
80103e13:	39 f2                	cmp    %esi,%edx
80103e15:	74 26                	je     80103e3d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103e17:	0f b6 19             	movzbl (%ecx),%ebx
80103e1a:	81 c1 bc 00 00 00    	add    $0xbc,%ecx
80103e20:	39 c3                	cmp    %eax,%ebx
80103e22:	75 ec                	jne    80103e10 <mycpu+0x30>
80103e24:	69 c2 bc 00 00 00    	imul   $0xbc,%edx,%eax
80103e2a:	05 e0 12 11 80       	add    $0x801112e0,%eax
}
80103e2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e32:	5b                   	pop    %ebx
80103e33:	5e                   	pop    %esi
80103e34:	5d                   	pop    %ebp
80103e35:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103e36:	b8 e0 12 11 80       	mov    $0x801112e0,%eax
            return &cpus[i];
80103e3b:	eb f2                	jmp    80103e2f <mycpu+0x4f>
    panic("unknown apicid\n");
80103e3d:	83 ec 0c             	sub    $0xc,%esp
80103e40:	68 ac 79 10 80       	push   $0x801079ac
80103e45:	e8 26 c5 ff ff       	call   80100370 <panic>
        panic("mycpu called with interrupts enabled\n");
80103e4a:	83 ec 0c             	sub    $0xc,%esp
80103e4d:	68 4c 7b 10 80       	push   $0x80107b4c
80103e52:	e8 19 c5 ff ff       	call   80100370 <panic>
80103e57:	89 f6                	mov    %esi,%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <myproc>:
myproc(void) {
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
80103e64:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103e67:	e8 84 0b 00 00       	call   801049f0 <pushcli>
    c = mycpu();
80103e6c:	e8 6f ff ff ff       	call   80103de0 <mycpu>
    p = c->proc;
80103e71:	8b 98 b8 00 00 00    	mov    0xb8(%eax),%ebx
    popcli();
80103e77:	e8 a4 0b 00 00       	call   80104a20 <popcli>
}
80103e7c:	83 c4 04             	add    $0x4,%esp
80103e7f:	89 d8                	mov    %ebx,%eax
80103e81:	5b                   	pop    %ebx
80103e82:	5d                   	pop    %ebp
80103e83:	c3                   	ret    
80103e84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e90 <sleep>:
sleep(void *chan, struct spinlock *lk) {
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e9c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
80103e9f:	e8 4c 0b 00 00       	call   801049f0 <pushcli>
    c = mycpu();
80103ea4:	e8 37 ff ff ff       	call   80103de0 <mycpu>
    p = c->proc;
80103ea9:	8b 98 b8 00 00 00    	mov    0xb8(%eax),%ebx
    popcli();
80103eaf:	e8 6c 0b 00 00       	call   80104a20 <popcli>
    if (p == 0)
80103eb4:	85 db                	test   %ebx,%ebx
80103eb6:	0f 84 ad 00 00 00    	je     80103f69 <sleep+0xd9>
    if (lk == 0)
80103ebc:	85 f6                	test   %esi,%esi
80103ebe:	0f 84 b2 00 00 00    	je     80103f76 <sleep+0xe6>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
80103ec4:	81 fe e0 18 11 80    	cmp    $0x801118e0,%esi
80103eca:	74 5c                	je     80103f28 <sleep+0x98>
        acquire(&ptable.lock);  //DOC: sleeplock1
80103ecc:	83 ec 0c             	sub    $0xc,%esp
80103ecf:	68 e0 18 11 80       	push   $0x801118e0
80103ed4:	e8 b7 09 00 00       	call   80104890 <acquire>
        release(lk);
80103ed9:	89 34 24             	mov    %esi,(%esp)
80103edc:	e8 8f 0b 00 00       	call   80104a70 <release>
    if (p->policy == SCHED_FIFO) {
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
    p->chan = chan;
80103eeb:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80103eee:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    if (p->policy == SCHED_FIFO) {
80103ef5:	74 69                	je     80103f60 <sleep+0xd0>
    sched();
80103ef7:	e8 b4 fc ff ff       	call   80103bb0 <sched>
        release(&ptable.lock);
80103efc:	83 ec 0c             	sub    $0xc,%esp
    p->chan = 0;
80103eff:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80103f06:	68 e0 18 11 80       	push   $0x801118e0
80103f0b:	e8 60 0b 00 00       	call   80104a70 <release>
        acquire(lk);
80103f10:	89 75 08             	mov    %esi,0x8(%ebp)
80103f13:	83 c4 10             	add    $0x10,%esp
}
80103f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f19:	5b                   	pop    %ebx
80103f1a:	5e                   	pop    %esi
80103f1b:	5f                   	pop    %edi
80103f1c:	5d                   	pop    %ebp
        acquire(lk);
80103f1d:	e9 6e 09 00 00       	jmp    80104890 <acquire>
80103f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->policy == SCHED_FIFO) {
80103f28:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
    p->chan = chan;
80103f2f:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80103f32:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    if (p->policy == SCHED_FIFO) {
80103f39:	75 07                	jne    80103f42 <sleep+0xb2>
        ptable.queue_size--;
80103f3b:	83 2d 14 3d 11 80 01 	subl   $0x1,0x80113d14
    sched();
80103f42:	e8 69 fc ff ff       	call   80103bb0 <sched>
    p->chan = 0;
80103f47:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f51:	5b                   	pop    %ebx
80103f52:	5e                   	pop    %esi
80103f53:	5f                   	pop    %edi
80103f54:	5d                   	pop    %ebp
80103f55:	c3                   	ret    
80103f56:	8d 76 00             	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        ptable.queue_size--;
80103f60:	83 2d 14 3d 11 80 01 	subl   $0x1,0x80113d14
80103f67:	eb 8e                	jmp    80103ef7 <sleep+0x67>
        panic("sleep");
80103f69:	83 ec 0c             	sub    $0xc,%esp
80103f6c:	68 e3 7a 10 80       	push   $0x80107ae3
80103f71:	e8 fa c3 ff ff       	call   80100370 <panic>
        panic("sleep without lk");
80103f76:	83 ec 0c             	sub    $0xc,%esp
80103f79:	68 e9 7a 10 80       	push   $0x80107ae9
80103f7e:	e8 ed c3 ff ff       	call   80100370 <panic>
80103f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <wait>:
wait(void) {
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
    acquire(&ptable.lock);
80103f95:	83 ec 0c             	sub    $0xc,%esp
80103f98:	68 e0 18 11 80       	push   $0x801118e0
80103f9d:	e8 ee 08 00 00       	call   80104890 <acquire>
80103fa2:	83 c4 10             	add    $0x10,%esp
            if (p->parent != proc)
80103fa5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
        havekids = 0;
80103fab:	31 d2                	xor    %edx,%edx
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103fad:	bb 14 19 11 80       	mov    $0x80111914,%ebx
80103fb2:	eb 12                	jmp    80103fc6 <wait+0x36>
80103fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fb8:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103fbe:	81 fb 14 3d 11 80    	cmp    $0x80113d14,%ebx
80103fc4:	73 1e                	jae    80103fe4 <wait+0x54>
            if (p->parent != proc)
80103fc6:	39 43 14             	cmp    %eax,0x14(%ebx)
80103fc9:	75 ed                	jne    80103fb8 <wait+0x28>
            if (p->state == ZOMBIE) {
80103fcb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fcf:	74 37                	je     80104008 <wait+0x78>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103fd1:	81 c3 90 00 00 00    	add    $0x90,%ebx
            havekids = 1;
80103fd7:	ba 01 00 00 00       	mov    $0x1,%edx
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103fdc:	81 fb 14 3d 11 80    	cmp    $0x80113d14,%ebx
80103fe2:	72 e2                	jb     80103fc6 <wait+0x36>
        if (!havekids || proc->killed) {
80103fe4:	85 d2                	test   %edx,%edx
80103fe6:	74 76                	je     8010405e <wait+0xce>
80103fe8:	8b 50 24             	mov    0x24(%eax),%edx
80103feb:	85 d2                	test   %edx,%edx
80103fed:	75 6f                	jne    8010405e <wait+0xce>
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103fef:	83 ec 08             	sub    $0x8,%esp
80103ff2:	68 e0 18 11 80       	push   $0x801118e0
80103ff7:	50                   	push   %eax
80103ff8:	e8 93 fe ff ff       	call   80103e90 <sleep>
        havekids = 0;
80103ffd:	83 c4 10             	add    $0x10,%esp
80104000:	eb a3                	jmp    80103fa5 <wait+0x15>
80104002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104008:	83 ec 0c             	sub    $0xc,%esp
8010400b:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
8010400e:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104011:	e8 ea e2 ff ff       	call   80102300 <kfree>
                freevm(p->pgdir);
80104016:	59                   	pop    %ecx
80104017:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
8010401a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104021:	e8 4a 32 00 00       	call   80107270 <freevm>
                release(&ptable.lock);
80104026:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
                p->pid = 0;
8010402d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104034:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
8010403b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
8010403f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104046:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
8010404d:	e8 1e 0a 00 00       	call   80104a70 <release>
                return pid;
80104052:	83 c4 10             	add    $0x10,%esp
}
80104055:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104058:	89 f0                	mov    %esi,%eax
8010405a:	5b                   	pop    %ebx
8010405b:	5e                   	pop    %esi
8010405c:	5d                   	pop    %ebp
8010405d:	c3                   	ret    
            release(&ptable.lock);
8010405e:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104061:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
80104066:	68 e0 18 11 80       	push   $0x801118e0
8010406b:	e8 00 0a 00 00       	call   80104a70 <release>
            return -1;
80104070:	83 c4 10             	add    $0x10,%esp
80104073:	eb e0                	jmp    80104055 <wait+0xc5>
80104075:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104080 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	53                   	push   %ebx
80104084:	83 ec 10             	sub    $0x10,%esp
80104087:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010408a:	68 e0 18 11 80       	push   $0x801118e0
8010408f:	e8 fc 07 00 00       	call   80104890 <acquire>
80104094:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104097:	b8 14 19 11 80       	mov    $0x80111914,%eax
8010409c:	eb 0e                	jmp    801040ac <wakeup+0x2c>
8010409e:	66 90                	xchg   %ax,%ax
801040a0:	05 90 00 00 00       	add    $0x90,%eax
801040a5:	3d 14 3d 11 80       	cmp    $0x80113d14,%eax
801040aa:	73 1e                	jae    801040ca <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
801040ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040b0:	75 ee                	jne    801040a0 <wakeup+0x20>
801040b2:	3b 58 20             	cmp    0x20(%eax),%ebx
801040b5:	75 e9                	jne    801040a0 <wakeup+0x20>
            p->state = RUNNABLE;
801040b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040be:	05 90 00 00 00       	add    $0x90,%eax
801040c3:	3d 14 3d 11 80       	cmp    $0x80113d14,%eax
801040c8:	72 e2                	jb     801040ac <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
801040ca:	c7 45 08 e0 18 11 80 	movl   $0x801118e0,0x8(%ebp)
}
801040d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d4:	c9                   	leave  
    release(&ptable.lock);
801040d5:	e9 96 09 00 00       	jmp    80104a70 <release>
801040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040e0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 10             	sub    $0x10,%esp
801040e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
801040ea:	68 e0 18 11 80       	push   $0x801118e0
801040ef:	e8 9c 07 00 00       	call   80104890 <acquire>
801040f4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040f7:	b8 14 19 11 80       	mov    $0x80111914,%eax
801040fc:	eb 0e                	jmp    8010410c <kill+0x2c>
801040fe:	66 90                	xchg   %ax,%ax
80104100:	05 90 00 00 00       	add    $0x90,%eax
80104105:	3d 14 3d 11 80       	cmp    $0x80113d14,%eax
8010410a:	73 34                	jae    80104140 <kill+0x60>
        if (p->pid == pid) {
8010410c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010410f:	75 ef                	jne    80104100 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104111:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104115:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
8010411c:	75 07                	jne    80104125 <kill+0x45>
                p->state = RUNNABLE;
8010411e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104125:	83 ec 0c             	sub    $0xc,%esp
80104128:	68 e0 18 11 80       	push   $0x801118e0
8010412d:	e8 3e 09 00 00       	call   80104a70 <release>
            return 0;
80104132:	83 c4 10             	add    $0x10,%esp
80104135:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104137:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010413a:	c9                   	leave  
8010413b:	c3                   	ret    
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80104140:	83 ec 0c             	sub    $0xc,%esp
80104143:	68 e0 18 11 80       	push   $0x801118e0
80104148:	e8 23 09 00 00       	call   80104a70 <release>
    return -1;
8010414d:	83 c4 10             	add    $0x10,%esp
80104150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104158:	c9                   	leave  
80104159:	c3                   	ret    
8010415a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104160 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	57                   	push   %edi
80104164:	56                   	push   %esi
80104165:	53                   	push   %ebx
80104166:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104169:	bb 14 19 11 80       	mov    $0x80111914,%ebx
procdump(void) {
8010416e:	83 ec 3c             	sub    $0x3c,%esp
80104171:	eb 27                	jmp    8010419a <procdump+0x3a>
80104173:	90                   	nop
80104174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104178:	83 ec 0c             	sub    $0xc,%esp
8010417b:	68 26 7a 10 80       	push   $0x80107a26
80104180:	e8 bb c4 ff ff       	call   80100640 <cprintf>
80104185:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104188:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010418e:	81 fb 14 3d 11 80    	cmp    $0x80113d14,%ebx
80104194:	0f 83 86 00 00 00    	jae    80104220 <procdump+0xc0>
        if (p->state == UNUSED)
8010419a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010419d:	85 c0                	test   %eax,%eax
8010419f:	74 e7                	je     80104188 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041a1:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
801041a4:	ba fa 7a 10 80       	mov    $0x80107afa,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041a9:	77 11                	ja     801041bc <procdump+0x5c>
801041ab:	8b 14 85 74 7b 10 80 	mov    -0x7fef848c(,%eax,4),%edx
            state = "???";
801041b2:	b8 fa 7a 10 80       	mov    $0x80107afa,%eax
801041b7:	85 d2                	test   %edx,%edx
801041b9:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
801041bc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041bf:	50                   	push   %eax
801041c0:	52                   	push   %edx
801041c1:	ff 73 10             	pushl  0x10(%ebx)
801041c4:	68 fe 7a 10 80       	push   $0x80107afe
801041c9:	e8 72 c4 ff ff       	call   80100640 <cprintf>
        if (p->state == SLEEPING) {
801041ce:	83 c4 10             	add    $0x10,%esp
801041d1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801041d5:	75 a1                	jne    80104178 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
801041d7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041da:	83 ec 08             	sub    $0x8,%esp
801041dd:	8d 7d c0             	lea    -0x40(%ebp),%edi
801041e0:	50                   	push   %eax
801041e1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801041e4:	8b 40 0c             	mov    0xc(%eax),%eax
801041e7:	83 c0 08             	add    $0x8,%eax
801041ea:	50                   	push   %eax
801041eb:	e8 80 07 00 00       	call   80104970 <getcallerpcs>
801041f0:	83 c4 10             	add    $0x10,%esp
801041f3:	90                   	nop
801041f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801041f8:	8b 17                	mov    (%edi),%edx
801041fa:	85 d2                	test   %edx,%edx
801041fc:	0f 84 76 ff ff ff    	je     80104178 <procdump+0x18>
                cprintf(" %p", pc[i]);
80104202:	83 ec 08             	sub    $0x8,%esp
80104205:	83 c7 04             	add    $0x4,%edi
80104208:	52                   	push   %edx
80104209:	68 22 75 10 80       	push   $0x80107522
8010420e:	e8 2d c4 ff ff       	call   80100640 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104213:	83 c4 10             	add    $0x10,%esp
80104216:	39 fe                	cmp    %edi,%esi
80104218:	75 de                	jne    801041f8 <procdump+0x98>
8010421a:	e9 59 ff ff ff       	jmp    80104178 <procdump+0x18>
8010421f:	90                   	nop
    }
}
80104220:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104223:	5b                   	pop    %ebx
80104224:	5e                   	pop    %esi
80104225:	5f                   	pop    %edi
80104226:	5d                   	pop    %ebp
80104227:	c3                   	ret    
80104228:	90                   	nop
80104229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104230 <clone_thread>:

int
clone_thread(void *stack, int size) {
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	53                   	push   %ebx
80104236:	83 ec 18             	sub    $0x18,%esp
    int i, pid;
    struct proc *np;
    acquire(&ptable.lock);
80104239:	68 e0 18 11 80       	push   $0x801118e0
8010423e:	e8 4d 06 00 00       	call   80104890 <acquire>
    if ((np = allocproc()) == 0)
80104243:	e8 98 f5 ff ff       	call   801037e0 <allocproc>
80104248:	83 c4 10             	add    $0x10,%esp
8010424b:	85 c0                	test   %eax,%eax
8010424d:	0f 84 e0 00 00 00    	je     80104333 <clone_thread+0x103>
        return -1;

    np->pgdir = proc->pgdir;
80104253:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010425a:	89 c3                	mov    %eax,%ebx
    uint sp = (uint) (stack + size);
    sp -= 8;

    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;
8010425c:	b9 13 00 00 00       	mov    $0x13,%ecx
80104261:	8b 7b 18             	mov    0x18(%ebx),%edi
    np->pgdir = proc->pgdir;
80104264:	8b 42 04             	mov    0x4(%edx),%eax
80104267:	89 43 04             	mov    %eax,0x4(%ebx)
    np->sz = proc->sz;
8010426a:	8b 12                	mov    (%edx),%edx
    uint sp = (uint) (stack + size);
8010426c:	8b 45 08             	mov    0x8(%ebp),%eax
8010426f:	03 45 0c             	add    0xc(%ebp),%eax
    np->sz = proc->sz;
80104272:	89 13                	mov    %edx,(%ebx)
    np->parent = proc;
80104274:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010427b:	89 53 14             	mov    %edx,0x14(%ebx)
    *np->tf = *proc->tf;
8010427e:	8b 72 18             	mov    0x18(%edx),%esi
80104281:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    np->tf->eax = 0;
    np->tf->esp = (uint) sp;
    np->tf->eip = (uint) (*(uint *) stack);
80104283:	8b 7d 08             	mov    0x8(%ebp),%edi
    sp -= 8;
80104286:	8d 48 f8             	lea    -0x8(%eax),%ecx
    np->tf->ebp = (uint) (stack + size);
    for (i = 0; i < NOFILE; i++)
80104289:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
8010428b:	8b 53 18             	mov    0x18(%ebx),%edx
8010428e:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
    np->tf->esp = (uint) sp;
80104295:	8b 53 18             	mov    0x18(%ebx),%edx
    sp -= 8;
80104298:	89 4a 44             	mov    %ecx,0x44(%edx)
    np->tf->eip = (uint) (*(uint *) stack);
8010429b:	8b 53 18             	mov    0x18(%ebx),%edx
8010429e:	8b 0f                	mov    (%edi),%ecx
801042a0:	89 4a 38             	mov    %ecx,0x38(%edx)
    np->tf->ebp = (uint) (stack + size);
801042a3:	8b 53 18             	mov    0x18(%ebx),%edx
801042a6:	89 42 08             	mov    %eax,0x8(%edx)
801042a9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
        if (proc->ofile[i])
801042b0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
801042b4:	85 c0                	test   %eax,%eax
801042b6:	74 17                	je     801042cf <clone_thread+0x9f>
            np->ofile[i] = filedup(proc->ofile[i]);
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	50                   	push   %eax
801042bc:	e8 ff ca ff ff       	call   80100dc0 <filedup>
801042c1:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801042c5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801042cc:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NOFILE; i++)
801042cf:	83 c6 01             	add    $0x1,%esi
801042d2:	83 fe 10             	cmp    $0x10,%esi
801042d5:	75 d9                	jne    801042b0 <clone_thread+0x80>
    np->cwd = idup(proc->cwd);
801042d7:	83 ec 0c             	sub    $0xc,%esp
801042da:	ff 72 68             	pushl  0x68(%edx)
801042dd:	e8 fe d2 ff ff       	call   801015e0 <idup>
801042e2:	89 43 68             	mov    %eax,0x68(%ebx)

    pid = np->pid;
    np->state = RUNNABLE;
    safestrcpy(np->name, proc->name, sizeof(proc->name));
801042e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042eb:	83 c4 0c             	add    $0xc,%esp
    pid = np->pid;
801042ee:	8b 73 10             	mov    0x10(%ebx),%esi
    np->state = RUNNABLE;
801042f1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    safestrcpy(np->name, proc->name, sizeof(proc->name));
801042f8:	6a 10                	push   $0x10
801042fa:	83 c0 6c             	add    $0x6c,%eax
801042fd:	50                   	push   %eax
801042fe:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104301:	50                   	push   %eax
80104302:	e8 99 09 00 00       	call   80104ca0 <safestrcpy>
    proc->thread_count++;
80104307:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010430e:	8b 42 7c             	mov    0x7c(%edx),%eax
80104311:	83 c0 01             	add    $0x1,%eax
80104314:	89 42 7c             	mov    %eax,0x7c(%edx)
    np->thread_count = proc->thread_count;
80104317:	89 43 7c             	mov    %eax,0x7c(%ebx)

    release(&ptable.lock);
8010431a:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80104321:	e8 4a 07 00 00       	call   80104a70 <release>
    return pid;
80104326:	83 c4 10             	add    $0x10,%esp
}
80104329:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432c:	89 f0                	mov    %esi,%eax
8010432e:	5b                   	pop    %ebx
8010432f:	5e                   	pop    %esi
80104330:	5f                   	pop    %edi
80104331:	5d                   	pop    %ebp
80104332:	c3                   	ret    
        return -1;
80104333:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104338:	eb ef                	jmp    80104329 <clone_thread+0xf9>
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <sys_cpu>:

int
sys_cpu(void) {
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
    return cpunum();
}
80104343:	5d                   	pop    %ebp
    return cpunum();
80104344:	e9 f7 e3 ff ff       	jmp    80102740 <cpunum>
80104349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104350 <sys_join>:

int
sys_join(void) {
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80104355:	83 ec 0c             	sub    $0xc,%esp
80104358:	68 e0 18 11 80       	push   $0x801118e0
8010435d:	e8 2e 05 00 00       	call   80104890 <acquire>
80104362:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for zombie children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != proc || p->pgdir != proc->pgdir)
80104365:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
        havekids = 0;
8010436b:	31 d2                	xor    %edx,%edx
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010436d:	bb 14 19 11 80       	mov    $0x80111914,%ebx
80104372:	eb 12                	jmp    80104386 <sys_join+0x36>
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104378:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010437e:	81 fb 14 3d 11 80    	cmp    $0x80113d14,%ebx
80104384:	73 2a                	jae    801043b0 <sys_join+0x60>
            if (p->parent != proc || p->pgdir != proc->pgdir)
80104386:	39 43 14             	cmp    %eax,0x14(%ebx)
80104389:	75 ed                	jne    80104378 <sys_join+0x28>
8010438b:	8b 48 04             	mov    0x4(%eax),%ecx
8010438e:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80104391:	75 e5                	jne    80104378 <sys_join+0x28>
                continue;
            havekids = 1;
            if (p->state != ZOMBIE)
80104393:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104397:	74 37                	je     801043d0 <sys_join+0x80>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104399:	81 c3 90 00 00 00    	add    $0x90,%ebx
            havekids = 1;
8010439f:	ba 01 00 00 00       	mov    $0x1,%edx
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043a4:	81 fb 14 3d 11 80    	cmp    $0x80113d14,%ebx
801043aa:	72 da                	jb     80104386 <sys_join+0x36>
801043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || proc->killed) {
801043b0:	85 d2                	test   %edx,%edx
801043b2:	74 6d                	je     80104421 <sys_join+0xd1>
801043b4:	8b 50 24             	mov    0x24(%eax),%edx
801043b7:	85 d2                	test   %edx,%edx
801043b9:	75 66                	jne    80104421 <sys_join+0xd1>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
801043bb:	83 ec 08             	sub    $0x8,%esp
801043be:	68 e0 18 11 80       	push   $0x801118e0
801043c3:	50                   	push   %eax
801043c4:	e8 c7 fa ff ff       	call   80103e90 <sleep>
        havekids = 0;
801043c9:	83 c4 10             	add    $0x10,%esp
801043cc:	eb 97                	jmp    80104365 <sys_join+0x15>
801043ce:	66 90                	xchg   %ax,%ax
                proc->thread_count--;
801043d0:	83 68 7c 01          	subl   $0x1,0x7c(%eax)
                kfree(p->kstack);
801043d4:	83 ec 0c             	sub    $0xc,%esp
801043d7:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
801043da:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
801043dd:	e8 1e df ff ff       	call   80102300 <kfree>
                release(&ptable.lock);
801043e2:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
                p->state = UNUSED;
801043e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->kstack = 0;
801043f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                p->parent = 0;
801043f7:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->pid = 0;
801043fe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->killed = 0;
80104405:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->name[0] = 0;
8010440c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                release(&ptable.lock);
80104410:	e8 5b 06 00 00       	call   80104a70 <release>
                return pid;
80104415:	83 c4 10             	add    $0x10,%esp
    }
}
80104418:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010441b:	89 f0                	mov    %esi,%eax
8010441d:	5b                   	pop    %ebx
8010441e:	5e                   	pop    %esi
8010441f:	5d                   	pop    %ebp
80104420:	c3                   	ret    
            release(&ptable.lock);
80104421:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104424:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
80104429:	68 e0 18 11 80       	push   $0x801118e0
8010442e:	e8 3d 06 00 00       	call   80104a70 <release>
            return -1;
80104433:	83 c4 10             	add    $0x10,%esp
80104436:	eb e0                	jmp    80104418 <sys_join+0xc8>
80104438:	90                   	nop
80104439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104440 <sys_clone>:


int
sys_clone(void) {
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	83 ec 20             	sub    $0x20,%esp
    char *stack;
    int size;

    if (argint(1, &size) < 0)
80104446:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104449:	50                   	push   %eax
8010444a:	6a 01                	push   $0x1
8010444c:	e8 4f 09 00 00       	call   80104da0 <argint>
80104451:	83 c4 10             	add    $0x10,%esp
80104454:	85 c0                	test   %eax,%eax
80104456:	78 30                	js     80104488 <sys_clone+0x48>
        return -1;
    if (argptr(0, &stack, size) < 0)
80104458:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010445b:	83 ec 04             	sub    $0x4,%esp
8010445e:	ff 75 f4             	pushl  -0xc(%ebp)
80104461:	50                   	push   %eax
80104462:	6a 00                	push   $0x0
80104464:	e8 77 09 00 00       	call   80104de0 <argptr>
80104469:	83 c4 10             	add    $0x10,%esp
8010446c:	85 c0                	test   %eax,%eax
8010446e:	78 18                	js     80104488 <sys_clone+0x48>
        return -1;

    return clone_thread((void *) stack, size);
80104470:	83 ec 08             	sub    $0x8,%esp
80104473:	ff 75 f4             	pushl  -0xc(%ebp)
80104476:	ff 75 f0             	pushl  -0x10(%ebp)
80104479:	e8 b2 fd ff ff       	call   80104230 <clone_thread>
8010447e:	83 c4 10             	add    $0x10,%esp
}
80104481:	c9                   	leave  
80104482:	c3                   	ret    
80104483:	90                   	nop
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010448d:	c9                   	leave  
8010448e:	c3                   	ret    
8010448f:	90                   	nop

80104490 <fifo_q>:

struct proc *
fifo_q(void) {
    struct proc *curr_node = ptable.head;
80104490:	8b 15 18 3d 11 80    	mov    0x80113d18,%edx
    struct proc *best_proc = ptable.head;

    while (curr_node) {
80104496:	85 d2                	test   %edx,%edx
80104498:	74 56                	je     801044f0 <fifo_q+0x60>
fifo_q(void) {
8010449a:	55                   	push   %ebp
    while (curr_node) {
8010449b:	89 d0                	mov    %edx,%eax
fifo_q(void) {
8010449d:	89 e5                	mov    %esp,%ebp
8010449f:	53                   	push   %ebx
        if (curr_node->state == SLEEPING || curr_node->state == ZOMBIE) {
801044a0:	8b 4a 0c             	mov    0xc(%edx),%ecx
801044a3:	8b 9a 88 00 00 00    	mov    0x88(%edx),%ebx
801044a9:	83 f9 02             	cmp    $0x2,%ecx
801044ac:	74 22                	je     801044d0 <fifo_q+0x40>
801044ae:	83 f9 05             	cmp    $0x5,%ecx
801044b1:	74 1d                	je     801044d0 <fifo_q+0x40>
            if (curr_node->next)
                best_proc = curr_node->next;
            curr_node = curr_node->next;
        } else {
            if (curr_node->priority > best_proc->priority) {
801044b3:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801044b9:	39 8a 84 00 00 00    	cmp    %ecx,0x84(%edx)
801044bf:	7e 02                	jle    801044c3 <fifo_q+0x33>
801044c1:	89 d0                	mov    %edx,%eax
801044c3:	89 da                	mov    %ebx,%edx
    while (curr_node) {
801044c5:	85 d2                	test   %edx,%edx
801044c7:	75 d7                	jne    801044a0 <fifo_q+0x10>
            }
        }
        curr_node = curr_node->next;
    }
    return best_proc;
}
801044c9:	5b                   	pop    %ebx
801044ca:	5d                   	pop    %ebp
801044cb:	c3                   	ret    
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if (curr_node->next)
801044d0:	85 db                	test   %ebx,%ebx
801044d2:	74 0c                	je     801044e0 <fifo_q+0x50>
801044d4:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
801044da:	89 d8                	mov    %ebx,%eax
801044dc:	eb e7                	jmp    801044c5 <fifo_q+0x35>
801044de:	66 90                	xchg   %ax,%ax
        curr_node = curr_node->next;
801044e0:	a1 88 00 00 00       	mov    0x88,%eax
801044e5:	0f 0b                	ud2    
801044e7:	89 f6                	mov    %esi,%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    struct proc *best_proc = ptable.head;
801044f0:	31 c0                	xor    %eax,%eax
}
801044f2:	c3                   	ret    
801044f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104500 <scheduler>:
scheduler(void) {
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	57                   	push   %edi
80104504:	56                   	push   %esi
80104505:	53                   	push   %ebx
80104506:	83 ec 1c             	sub    $0x1c,%esp
    struct cpu *c = mycpu();
80104509:	e8 d2 f8 ff ff       	call   80103de0 <mycpu>
    c->proc = 0;
8010450e:	c7 80 b8 00 00 00 00 	movl   $0x0,0xb8(%eax)
80104515:	00 00 00 
    struct cpu *c = mycpu();
80104518:	89 c3                	mov    %eax,%ebx
8010451a:	8d 40 04             	lea    0x4(%eax),%eax
8010451d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80104520:	fb                   	sti    
        acquire(&ptable.lock);
80104521:	83 ec 0c             	sub    $0xc,%esp
80104524:	68 e0 18 11 80       	push   $0x801118e0
80104529:	e8 62 03 00 00       	call   80104890 <acquire>
        if (fifoProc() > 0) {
8010452e:	a1 14 3d 11 80       	mov    0x80113d14,%eax
80104533:	83 c4 10             	add    $0x10,%esp
80104536:	85 c0                	test   %eax,%eax
80104538:	7e 5e                	jle    80104598 <scheduler+0x98>
            p = fifo_q();
8010453a:	e8 51 ff ff ff       	call   80104490 <fifo_q>
            if (p->state != RUNNABLE)
8010453f:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
            p = fifo_q();
80104543:	89 c7                	mov    %eax,%edi
            if (p->state != RUNNABLE)
80104545:	75 d9                	jne    80104520 <scheduler+0x20>
            switchuvm(p);
80104547:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
8010454a:	89 83 b8 00 00 00    	mov    %eax,0xb8(%ebx)
            switchuvm(p);
80104550:	50                   	push   %eax
80104551:	e8 da 29 00 00       	call   80106f30 <switchuvm>
            p->state = RUNNING;
80104556:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
            swtch(&(c->scheduler), p->context);
8010455d:	5e                   	pop    %esi
8010455e:	58                   	pop    %eax
8010455f:	ff 77 1c             	pushl  0x1c(%edi)
80104562:	ff 75 e4             	pushl  -0x1c(%ebp)
80104565:	e8 91 07 00 00       	call   80104cfb <swtch>
            switchkvm();
8010456a:	e8 a1 29 00 00       	call   80106f10 <switchkvm>
            if (p->state == ZOMBIE) {
8010456f:	83 c4 10             	add    $0x10,%esp
80104572:	83 7f 0c 05          	cmpl   $0x5,0xc(%edi)
80104576:	0f 84 bc 00 00 00    	je     80104638 <scheduler+0x138>
            c->proc = 0;
8010457c:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
80104583:	00 00 00 
        release(&ptable.lock);
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	68 e0 18 11 80       	push   $0x801118e0
8010458e:	e8 dd 04 00 00       	call   80104a70 <release>
80104593:	83 c4 10             	add    $0x10,%esp
80104596:	eb 88                	jmp    80104520 <scheduler+0x20>
80104598:	be 14 19 11 80       	mov    $0x80111914,%esi
8010459d:	eb 0f                	jmp    801045ae <scheduler+0xae>
8010459f:	90                   	nop
801045a0:	81 c6 90 00 00 00    	add    $0x90,%esi
            for (int i = 0; i < NPROC; i++) {
801045a6:	81 fe 14 3d 11 80    	cmp    $0x80113d14,%esi
801045ac:	74 d8                	je     80104586 <scheduler+0x86>
                if (p->state != RUNNABLE) {
801045ae:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
801045b2:	89 f7                	mov    %esi,%edi
801045b4:	75 ea                	jne    801045a0 <scheduler+0xa0>
801045b6:	b8 20 19 11 80       	mov    $0x80111920,%eax
801045bb:	eb 0f                	jmp    801045cc <scheduler+0xcc>
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
801045c0:	05 90 00 00 00       	add    $0x90,%eax
                for (int j = 0; j < NPROC; j++) {
801045c5:	3d 20 3d 11 80       	cmp    $0x80113d20,%eax
801045ca:	74 24                	je     801045f0 <scheduler+0xf0>
                    if (p->state == RUNNABLE && p->priority > best_proc->priority)
801045cc:	83 38 03             	cmpl   $0x3,(%eax)
801045cf:	75 ef                	jne    801045c0 <scheduler+0xc0>
801045d1:	8b 8f 84 00 00 00    	mov    0x84(%edi),%ecx
801045d7:	39 48 78             	cmp    %ecx,0x78(%eax)
801045da:	7e e4                	jle    801045c0 <scheduler+0xc0>
801045dc:	8d 78 f4             	lea    -0xc(%eax),%edi
801045df:	05 90 00 00 00       	add    $0x90,%eax
                for (int j = 0; j < NPROC; j++) {
801045e4:	3d 20 3d 11 80       	cmp    $0x80113d20,%eax
801045e9:	75 e1                	jne    801045cc <scheduler+0xcc>
801045eb:	90                   	nop
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                switchuvm(p);
801045f0:	83 ec 0c             	sub    $0xc,%esp
                c->proc = p;
801045f3:	89 bb b8 00 00 00    	mov    %edi,0xb8(%ebx)
                switchuvm(p);
801045f9:	57                   	push   %edi
801045fa:	e8 31 29 00 00       	call   80106f30 <switchuvm>
                p->state = RUNNING;
801045ff:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
                swtch(&(c->scheduler), p->context);
80104606:	58                   	pop    %eax
80104607:	5a                   	pop    %edx
80104608:	ff 77 1c             	pushl  0x1c(%edi)
8010460b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010460e:	e8 e8 06 00 00       	call   80104cfb <swtch>
                switchkvm();
80104613:	e8 f8 28 00 00       	call   80106f10 <switchkvm>
                c->proc = 0;
80104618:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
8010461f:	00 00 00 
                if (fifoProc()) {
80104622:	8b 0d 14 3d 11 80    	mov    0x80113d14,%ecx
80104628:	83 c4 10             	add    $0x10,%esp
8010462b:	85 c9                	test   %ecx,%ecx
8010462d:	0f 84 6d ff ff ff    	je     801045a0 <scheduler+0xa0>
80104633:	e9 4e ff ff ff       	jmp    80104586 <scheduler+0x86>

int
remove_proc_q(int pid) {
    if (ptable.queue_size > 0) {
80104638:	a1 14 3d 11 80       	mov    0x80113d14,%eax
8010463d:	85 c0                	test   %eax,%eax
8010463f:	7e 1a                	jle    8010465b <scheduler+0x15b>
        if (ptable.head->pid == pid) {
80104641:	8b 15 18 3d 11 80    	mov    0x80113d18,%edx
80104647:	8b 72 10             	mov    0x10(%edx),%esi
8010464a:	39 77 10             	cmp    %esi,0x10(%edi)
8010464d:	75 19                	jne    80104668 <scheduler+0x168>
            ptable.head = ptable.head->next;
8010464f:	8b 92 88 00 00 00    	mov    0x88(%edx),%edx
80104655:	89 15 18 3d 11 80    	mov    %edx,0x80113d18
            return -1;
        }
    }

    done:
    ptable.queue_size -= 1;
8010465b:	83 e8 01             	sub    $0x1,%eax
8010465e:	a3 14 3d 11 80       	mov    %eax,0x80113d14
80104663:	e9 14 ff ff ff       	jmp    8010457c <scheduler+0x7c>
80104668:	eb fe                	jmp    80104668 <scheduler+0x168>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <remove_proc_q>:
    if (ptable.queue_size > 0) {
80104670:	8b 15 14 3d 11 80    	mov    0x80113d14,%edx
remove_proc_q(int pid) {
80104676:	55                   	push   %ebp
80104677:	89 e5                	mov    %esp,%ebp
    if (ptable.queue_size > 0) {
80104679:	85 d2                	test   %edx,%edx
remove_proc_q(int pid) {
8010467b:	8b 45 08             	mov    0x8(%ebp),%eax
    if (ptable.queue_size > 0) {
8010467e:	7e 19                	jle    80104699 <remove_proc_q+0x29>
        if (ptable.head->pid == pid) {
80104680:	8b 0d 18 3d 11 80    	mov    0x80113d18,%ecx
80104686:	39 41 10             	cmp    %eax,0x10(%ecx)
80104689:	74 02                	je     8010468d <remove_proc_q+0x1d>
8010468b:	eb fe                	jmp    8010468b <remove_proc_q+0x1b>
            ptable.head = ptable.head->next;
8010468d:	8b 89 88 00 00 00    	mov    0x88(%ecx),%ecx
80104693:	89 0d 18 3d 11 80    	mov    %ecx,0x80113d18
    ptable.queue_size -= 1;
80104699:	83 ea 01             	sub    $0x1,%edx
8010469c:	89 15 14 3d 11 80    	mov    %edx,0x80113d14
    return pid;
}
801046a2:	5d                   	pop    %ebp
801046a3:	c3                   	ret    
801046a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801046b0 <insert_proc_q>:

int
insert_proc_q(int priority, int pid, int policy) {
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 10             	sub    $0x10,%esp
801046b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    int valid = -1;
    acquire(&ptable.lock);
801046ba:	68 e0 18 11 80       	push   $0x801118e0
801046bf:	e8 cc 01 00 00       	call   80104890 <acquire>
    if (ptable.queue_size < NPROC) {
801046c4:	8b 0d 14 3d 11 80    	mov    0x80113d14,%ecx
801046ca:	83 c4 10             	add    $0x10,%esp
801046cd:	83 f9 3f             	cmp    $0x3f,%ecx
801046d0:	0f 8f a2 00 00 00    	jg     80104778 <insert_proc_q+0xc8>
801046d6:	ba 24 19 11 80       	mov    $0x80111924,%edx
        for (int i = 0; i < 30; i++) {
801046db:	31 c0                	xor    %eax,%eax
801046dd:	eb 13                	jmp    801046f2 <insert_proc_q+0x42>
801046df:	90                   	nop
801046e0:	83 c0 01             	add    $0x1,%eax
801046e3:	81 c2 90 00 00 00    	add    $0x90,%edx
801046e9:	83 f8 1e             	cmp    $0x1e,%eax
801046ec:	0f 84 86 00 00 00    	je     80104778 <insert_proc_q+0xc8>
            if (ptable.proc[i].pid == pid) {
801046f2:	39 1a                	cmp    %ebx,(%edx)
801046f4:	75 ea                	jne    801046e0 <insert_proc_q+0x30>
                ptable.proc[i].priority = priority;
801046f6:	8d 04 c0             	lea    (%eax,%eax,8),%eax
801046f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046fc:	c1 e0 04             	shl    $0x4,%eax
801046ff:	8d 90 e0 18 11 80    	lea    -0x7feee720(%eax),%edx
80104705:	05 14 19 11 80       	add    $0x80111914,%eax
8010470a:	89 9a b8 00 00 00    	mov    %ebx,0xb8(%edx)
                ptable.proc[i].policy = policy;
80104710:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104713:	89 9a b4 00 00 00    	mov    %ebx,0xb4(%edx)

                if (!ptable.head) {
80104719:	8b 1d 18 3d 11 80    	mov    0x80113d18,%ebx
8010471f:	85 db                	test   %ebx,%ebx
80104721:	74 45                	je     80104768 <insert_proc_q+0xb8>
                    ptable.head = &ptable.proc[i];
                    ptable.tail = &ptable.proc[i];
                } else {
                    ptable.tail->next = &ptable.proc[i];
80104723:	8b 0d 1c 3d 11 80    	mov    0x80113d1c,%ecx
80104729:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
                    ptable.proc[i].prev = ptable.tail;
8010472f:	8b 0d 1c 3d 11 80    	mov    0x80113d1c,%ecx
                    ptable.tail = &ptable.proc[i];
80104735:	a3 1c 3d 11 80       	mov    %eax,0x80113d1c
                    ptable.proc[i].prev = ptable.tail;
8010473a:	89 8a c0 00 00 00    	mov    %ecx,0xc0(%edx)
80104740:	8b 0d 14 3d 11 80    	mov    0x80113d14,%ecx
                }

                ptable.queue_size++;
80104746:	83 c1 01             	add    $0x1,%ecx
                valid = 0;
80104749:	31 db                	xor    %ebx,%ebx
                ptable.queue_size++;
8010474b:	89 0d 14 3d 11 80    	mov    %ecx,0x80113d14
                break;
            }
        }
    }
    release(&ptable.lock);
80104751:	83 ec 0c             	sub    $0xc,%esp
80104754:	68 e0 18 11 80       	push   $0x801118e0
80104759:	e8 12 03 00 00       	call   80104a70 <release>
    return valid;
}
8010475e:	89 d8                	mov    %ebx,%eax
80104760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104763:	c9                   	leave  
80104764:	c3                   	ret    
80104765:	8d 76 00             	lea    0x0(%esi),%esi
                    ptable.head = &ptable.proc[i];
80104768:	a3 18 3d 11 80       	mov    %eax,0x80113d18
                    ptable.tail = &ptable.proc[i];
8010476d:	a3 1c 3d 11 80       	mov    %eax,0x80113d1c
80104772:	eb d2                	jmp    80104746 <insert_proc_q+0x96>
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int valid = -1;
80104778:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010477d:	eb d2                	jmp    80104751 <insert_proc_q+0xa1>
8010477f:	90                   	nop

80104780 <sys_setscheduler>:

int
sys_setscheduler(void) {
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
    int pid;
    int policy;
    int priority;
    if (argint(0, &pid) < 0 || argint(1, &policy) < 0 || argint(2, &priority) < 0)
80104784:	8d 45 ec             	lea    -0x14(%ebp),%eax
sys_setscheduler(void) {
80104787:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &pid) < 0 || argint(1, &policy) < 0 || argint(2, &priority) < 0)
8010478a:	50                   	push   %eax
8010478b:	6a 00                	push   $0x0
8010478d:	e8 0e 06 00 00       	call   80104da0 <argint>
80104792:	83 c4 10             	add    $0x10,%esp
80104795:	85 c0                	test   %eax,%eax
80104797:	0f 88 a3 00 00 00    	js     80104840 <sys_setscheduler+0xc0>
8010479d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801047a0:	83 ec 08             	sub    $0x8,%esp
801047a3:	50                   	push   %eax
801047a4:	6a 01                	push   $0x1
801047a6:	e8 f5 05 00 00       	call   80104da0 <argint>
801047ab:	83 c4 10             	add    $0x10,%esp
801047ae:	85 c0                	test   %eax,%eax
801047b0:	0f 88 8a 00 00 00    	js     80104840 <sys_setscheduler+0xc0>
801047b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047b9:	83 ec 08             	sub    $0x8,%esp
801047bc:	50                   	push   %eax
801047bd:	6a 02                	push   $0x2
801047bf:	e8 dc 05 00 00       	call   80104da0 <argint>
801047c4:	83 c4 10             	add    $0x10,%esp
801047c7:	85 c0                	test   %eax,%eax
801047c9:	78 75                	js     80104840 <sys_setscheduler+0xc0>
        return -1;

    if (pid == 0)
801047cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ce:	85 c0                	test   %eax,%eax
801047d0:	74 3e                	je     80104810 <sys_setscheduler+0x90>
        return 0;
    if (policy == SCHED_FIFO) {
801047d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047d5:	83 fa 01             	cmp    $0x1,%edx
801047d8:	74 3e                	je     80104818 <sys_setscheduler+0x98>
        if (pid < 0)
            pid = myproc()->pid;
        if (insert_proc_q(priority, pid, policy) != 0)
            panic("Couldn't add proc to queue");
    } else if (policy == SCHED_RR) {
801047da:	85 d2                	test   %edx,%edx
801047dc:	75 2b                	jne    80104809 <sys_setscheduler+0x89>
801047de:	b9 24 19 11 80       	mov    $0x80111924,%ecx
801047e3:	eb 11                	jmp    801047f6 <sys_setscheduler+0x76>
801047e5:	8d 76 00             	lea    0x0(%esi),%esi
        for (int i = 0; i < NPROC; i++) {
801047e8:	83 c2 01             	add    $0x1,%edx
801047eb:	81 c1 90 00 00 00    	add    $0x90,%ecx
801047f1:	83 fa 40             	cmp    $0x40,%edx
801047f4:	74 13                	je     80104809 <sys_setscheduler+0x89>
            if (ptable.proc[i].pid == pid) {
801047f6:	3b 01                	cmp    (%ecx),%eax
801047f8:	75 ee                	jne    801047e8 <sys_setscheduler+0x68>
                ptable.proc[i].priority = priority;
801047fa:	8d 04 d2             	lea    (%edx,%edx,8),%eax
801047fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104800:	c1 e0 04             	shl    $0x4,%eax
80104803:	89 90 98 19 11 80    	mov    %edx,-0x7feee668(%eax)
                break;
            }
        }
    }

    yield();
80104809:	e8 92 f5 ff ff       	call   80103da0 <yield>
    return 0;
8010480e:	31 c0                	xor    %eax,%eax
}
80104810:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104813:	c9                   	leave  
80104814:	c3                   	ret    
80104815:	8d 76 00             	lea    0x0(%esi),%esi
        if (pid < 0)
80104818:	85 c0                	test   %eax,%eax
8010481a:	78 34                	js     80104850 <sys_setscheduler+0xd0>
        if (insert_proc_q(priority, pid, policy) != 0)
8010481c:	83 ec 04             	sub    $0x4,%esp
8010481f:	52                   	push   %edx
80104820:	50                   	push   %eax
80104821:	ff 75 f4             	pushl  -0xc(%ebp)
80104824:	e8 87 fe ff ff       	call   801046b0 <insert_proc_q>
80104829:	83 c4 10             	add    $0x10,%esp
8010482c:	85 c0                	test   %eax,%eax
8010482e:	74 d9                	je     80104809 <sys_setscheduler+0x89>
            panic("Couldn't add proc to queue");
80104830:	83 ec 0c             	sub    $0xc,%esp
80104833:	68 07 7b 10 80       	push   $0x80107b07
80104838:	e8 33 bb ff ff       	call   80100370 <panic>
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80104840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104845:	eb c9                	jmp    80104810 <sys_setscheduler+0x90>
80104847:	89 f6                	mov    %esi,%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pushcli();
80104850:	e8 9b 01 00 00       	call   801049f0 <pushcli>
    c = mycpu();
80104855:	e8 86 f5 ff ff       	call   80103de0 <mycpu>
    p = c->proc;
8010485a:	8b 98 b8 00 00 00    	mov    0xb8(%eax),%ebx
    popcli();
80104860:	e8 bb 01 00 00       	call   80104a20 <popcli>
80104865:	8b 55 f0             	mov    -0x10(%ebp),%edx
            pid = myproc()->pid;
80104868:	8b 43 10             	mov    0x10(%ebx),%eax
8010486b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010486e:	eb ac                	jmp    8010481c <sys_setscheduler+0x9c>

80104870 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104876:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010487f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104882:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	90                   	nop
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104890 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104897:	9c                   	pushf  
80104898:	5a                   	pop    %edx
  asm volatile("cli");
80104899:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
8010489a:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801048a1:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
801048a7:	85 c0                	test   %eax,%eax
801048a9:	75 0c                	jne    801048b7 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
801048ab:	81 e2 00 02 00 00    	and    $0x200,%edx
801048b1:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
  if(holding(lk)) {
801048b7:	8b 55 08             	mov    0x8(%ebp),%edx
  cpu->ncli += 1;
801048ba:	83 c0 01             	add    $0x1,%eax
801048bd:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)
  return lock->locked && lock->cpu == cpu;
801048c3:	8b 1a                	mov    (%edx),%ebx
801048c5:	85 db                	test   %ebx,%ebx
801048c7:	74 05                	je     801048ce <acquire+0x3e>
801048c9:	39 4a 08             	cmp    %ecx,0x8(%edx)
801048cc:	74 74                	je     80104942 <acquire+0xb2>
  asm volatile("lock; xchgl %0, %1" :
801048ce:	b9 01 00 00 00       	mov    $0x1,%ecx
801048d3:	90                   	nop
801048d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048d8:	89 c8                	mov    %ecx,%eax
801048da:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
801048dd:	85 c0                	test   %eax,%eax
801048df:	75 f7                	jne    801048d8 <acquire+0x48>
  __sync_synchronize();
801048e1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = cpu;
801048e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048e9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  for(i = 0; i < 10; i++){
801048ef:	31 d2                	xor    %edx,%edx
  lk->cpu = cpu;
801048f1:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
801048f4:	83 c1 0c             	add    $0xc,%ecx
  ebp = (uint*)v - 2;
801048f7:	89 e8                	mov    %ebp,%eax
801048f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104900:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104906:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010490c:	77 1a                	ja     80104928 <acquire+0x98>
    pcs[i] = ebp[1];     // saved %eip
8010490e:	8b 58 04             	mov    0x4(%eax),%ebx
80104911:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104914:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104917:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104919:	83 fa 0a             	cmp    $0xa,%edx
8010491c:	75 e2                	jne    80104900 <acquire+0x70>
}
8010491e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104921:	c9                   	leave  
80104922:	c3                   	ret    
80104923:	90                   	nop
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104928:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010492b:	83 c1 28             	add    $0x28,%ecx
8010492e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104936:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104939:	39 c8                	cmp    %ecx,%eax
8010493b:	75 f3                	jne    80104930 <acquire+0xa0>
}
8010493d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104940:	c9                   	leave  
80104941:	c3                   	ret    
      cprintf("Panic acquire. PID: %d\n", proc->pid);
80104942:	50                   	push   %eax
80104943:	50                   	push   %eax
80104944:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010494a:	ff 70 10             	pushl  0x10(%eax)
8010494d:	68 8c 7b 10 80       	push   $0x80107b8c
80104952:	e8 e9 bc ff ff       	call   80100640 <cprintf>
      panic("acquire");
80104957:	c7 04 24 a4 7b 10 80 	movl   $0x80107ba4,(%esp)
8010495e:	e8 0d ba ff ff       	call   80100370 <panic>
80104963:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104970 <getcallerpcs>:
{
80104970:	55                   	push   %ebp
  for(i = 0; i < 10; i++){
80104971:	31 d2                	xor    %edx,%edx
{
80104973:	89 e5                	mov    %esp,%ebp
80104975:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104976:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010497c:	83 e8 08             	sub    $0x8,%eax
8010497f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104980:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104986:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010498c:	77 1a                	ja     801049a8 <getcallerpcs+0x38>
    pcs[i] = ebp[1];     // saved %eip
8010498e:	8b 58 04             	mov    0x4(%eax),%ebx
80104991:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104994:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104997:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104999:	83 fa 0a             	cmp    $0xa,%edx
8010499c:	75 e2                	jne    80104980 <getcallerpcs+0x10>
}
8010499e:	5b                   	pop    %ebx
8010499f:	5d                   	pop    %ebp
801049a0:	c3                   	ret    
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801049ab:	83 c1 28             	add    $0x28,%ecx
801049ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801049b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049b6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049b9:	39 c1                	cmp    %eax,%ecx
801049bb:	75 f3                	jne    801049b0 <getcallerpcs+0x40>
}
801049bd:	5b                   	pop    %ebx
801049be:	5d                   	pop    %ebp
801049bf:	c3                   	ret    

801049c0 <holding>:
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
801049c6:	8b 02                	mov    (%edx),%eax
801049c8:	85 c0                	test   %eax,%eax
801049ca:	74 14                	je     801049e0 <holding+0x20>
801049cc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801049d2:	39 42 08             	cmp    %eax,0x8(%edx)
}
801049d5:	5d                   	pop    %ebp
  return lock->locked && lock->cpu == cpu;
801049d6:	0f 94 c0             	sete   %al
801049d9:	0f b6 c0             	movzbl %al,%eax
}
801049dc:	c3                   	ret    
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
801049e0:	31 c0                	xor    %eax,%eax
801049e2:	5d                   	pop    %ebp
801049e3:	c3                   	ret    
801049e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049f0 <pushcli>:
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049f3:	9c                   	pushf  
801049f4:	59                   	pop    %ecx
  asm volatile("cli");
801049f5:	fa                   	cli    
  if(cpu->ncli == 0)
801049f6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801049fd:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104a03:	85 c0                	test   %eax,%eax
80104a05:	75 0c                	jne    80104a13 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
80104a07:	81 e1 00 02 00 00    	and    $0x200,%ecx
80104a0d:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
80104a13:	83 c0 01             	add    $0x1,%eax
80104a16:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
80104a1c:	5d                   	pop    %ebp
80104a1d:	c3                   	ret    
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <popcli>:

void
popcli(void)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a26:	9c                   	pushf  
80104a27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a28:	f6 c4 02             	test   $0x2,%ah
80104a2b:	75 2c                	jne    80104a59 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
80104a2d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104a34:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
80104a3b:	78 0f                	js     80104a4c <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80104a3d:	75 0b                	jne    80104a4a <popcli+0x2a>
80104a3f:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104a45:	85 c0                	test   %eax,%eax
80104a47:	74 01                	je     80104a4a <popcli+0x2a>
  asm volatile("sti");
80104a49:	fb                   	sti    
    sti();
}
80104a4a:	c9                   	leave  
80104a4b:	c3                   	ret    
    panic("popcli");
80104a4c:	83 ec 0c             	sub    $0xc,%esp
80104a4f:	68 c3 7b 10 80       	push   $0x80107bc3
80104a54:	e8 17 b9 ff ff       	call   80100370 <panic>
    panic("popcli - interruptible");
80104a59:	83 ec 0c             	sub    $0xc,%esp
80104a5c:	68 ac 7b 10 80       	push   $0x80107bac
80104a61:	e8 0a b9 ff ff       	call   80100370 <panic>
80104a66:	8d 76 00             	lea    0x0(%esi),%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <release>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	83 ec 08             	sub    $0x8,%esp
80104a76:	8b 45 08             	mov    0x8(%ebp),%eax
  return lock->locked && lock->cpu == cpu;
80104a79:	8b 10                	mov    (%eax),%edx
80104a7b:	85 d2                	test   %edx,%edx
80104a7d:	74 2b                	je     80104aaa <release+0x3a>
80104a7f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104a86:	39 50 08             	cmp    %edx,0x8(%eax)
80104a89:	75 1f                	jne    80104aaa <release+0x3a>
  lk->pcs[0] = 0;
80104a8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104a92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  __sync_synchronize();
80104a99:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->locked = 0;
80104a9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80104aa4:	c9                   	leave  
  popcli();
80104aa5:	e9 76 ff ff ff       	jmp    80104a20 <popcli>
    panic("release");
80104aaa:	83 ec 0c             	sub    $0xc,%esp
80104aad:	68 ca 7b 10 80       	push   $0x80107bca
80104ab2:	e8 b9 b8 ff ff       	call   80100370 <panic>
80104ab7:	66 90                	xchg   %ax,%ax
80104ab9:	66 90                	xchg   %ax,%ax
80104abb:	66 90                	xchg   %ax,%ax
80104abd:	66 90                	xchg   %ax,%ax
80104abf:	90                   	nop

80104ac0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	53                   	push   %ebx
80104ac5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ac8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104acb:	f6 c2 03             	test   $0x3,%dl
80104ace:	75 05                	jne    80104ad5 <memset+0x15>
80104ad0:	f6 c1 03             	test   $0x3,%cl
80104ad3:	74 13                	je     80104ae8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ad5:	89 d7                	mov    %edx,%edi
80104ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ada:	fc                   	cld    
80104adb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104add:	5b                   	pop    %ebx
80104ade:	89 d0                	mov    %edx,%eax
80104ae0:	5f                   	pop    %edi
80104ae1:	5d                   	pop    %ebp
80104ae2:	c3                   	ret    
80104ae3:	90                   	nop
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104ae8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104aec:	c1 e9 02             	shr    $0x2,%ecx
80104aef:	89 f8                	mov    %edi,%eax
80104af1:	89 fb                	mov    %edi,%ebx
80104af3:	c1 e0 18             	shl    $0x18,%eax
80104af6:	c1 e3 10             	shl    $0x10,%ebx
80104af9:	09 d8                	or     %ebx,%eax
80104afb:	09 f8                	or     %edi,%eax
80104afd:	c1 e7 08             	shl    $0x8,%edi
80104b00:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104b02:	89 d7                	mov    %edx,%edi
80104b04:	fc                   	cld    
80104b05:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104b07:	5b                   	pop    %ebx
80104b08:	89 d0                	mov    %edx,%eax
80104b0a:	5f                   	pop    %edi
80104b0b:	5d                   	pop    %ebp
80104b0c:	c3                   	ret    
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	53                   	push   %ebx
80104b16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b19:	8b 75 08             	mov    0x8(%ebp),%esi
80104b1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b1f:	85 db                	test   %ebx,%ebx
80104b21:	74 29                	je     80104b4c <memcmp+0x3c>
    if(*s1 != *s2)
80104b23:	0f b6 16             	movzbl (%esi),%edx
80104b26:	0f b6 0f             	movzbl (%edi),%ecx
80104b29:	38 d1                	cmp    %dl,%cl
80104b2b:	75 2b                	jne    80104b58 <memcmp+0x48>
80104b2d:	b8 01 00 00 00       	mov    $0x1,%eax
80104b32:	eb 14                	jmp    80104b48 <memcmp+0x38>
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b38:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104b3c:	83 c0 01             	add    $0x1,%eax
80104b3f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104b44:	38 ca                	cmp    %cl,%dl
80104b46:	75 10                	jne    80104b58 <memcmp+0x48>
  while(n-- > 0){
80104b48:	39 d8                	cmp    %ebx,%eax
80104b4a:	75 ec                	jne    80104b38 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104b4c:	5b                   	pop    %ebx
  return 0;
80104b4d:	31 c0                	xor    %eax,%eax
}
80104b4f:	5e                   	pop    %esi
80104b50:	5f                   	pop    %edi
80104b51:	5d                   	pop    %ebp
80104b52:	c3                   	ret    
80104b53:	90                   	nop
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b58:	0f b6 c2             	movzbl %dl,%eax
}
80104b5b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b5c:	29 c8                	sub    %ecx,%eax
}
80104b5e:	5e                   	pop    %esi
80104b5f:	5f                   	pop    %edi
80104b60:	5d                   	pop    %ebp
80104b61:	c3                   	ret    
80104b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
80104b75:	8b 45 08             	mov    0x8(%ebp),%eax
80104b78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b7b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b7e:	39 c3                	cmp    %eax,%ebx
80104b80:	73 26                	jae    80104ba8 <memmove+0x38>
80104b82:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b85:	39 c8                	cmp    %ecx,%eax
80104b87:	73 1f                	jae    80104ba8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b89:	85 f6                	test   %esi,%esi
80104b8b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b8e:	74 0f                	je     80104b9f <memmove+0x2f>
      *--d = *--s;
80104b90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b97:	83 ea 01             	sub    $0x1,%edx
80104b9a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b9d:	75 f1                	jne    80104b90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b9f:	5b                   	pop    %ebx
80104ba0:	5e                   	pop    %esi
80104ba1:	5d                   	pop    %ebp
80104ba2:	c3                   	ret    
80104ba3:	90                   	nop
80104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104ba8:	31 d2                	xor    %edx,%edx
80104baa:	85 f6                	test   %esi,%esi
80104bac:	74 f1                	je     80104b9f <memmove+0x2f>
80104bae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104bb0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104bb4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104bb7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104bba:	39 d6                	cmp    %edx,%esi
80104bbc:	75 f2                	jne    80104bb0 <memmove+0x40>
}
80104bbe:	5b                   	pop    %ebx
80104bbf:	5e                   	pop    %esi
80104bc0:	5d                   	pop    %ebp
80104bc1:	c3                   	ret    
80104bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104bd3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104bd4:	eb 9a                	jmp    80104b70 <memmove>
80104bd6:	8d 76 00             	lea    0x0(%esi),%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	56                   	push   %esi
80104be5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104be8:	53                   	push   %ebx
80104be9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104bef:	85 ff                	test   %edi,%edi
80104bf1:	74 2f                	je     80104c22 <strncmp+0x42>
80104bf3:	0f b6 01             	movzbl (%ecx),%eax
80104bf6:	0f b6 1e             	movzbl (%esi),%ebx
80104bf9:	84 c0                	test   %al,%al
80104bfb:	74 37                	je     80104c34 <strncmp+0x54>
80104bfd:	38 c3                	cmp    %al,%bl
80104bff:	75 33                	jne    80104c34 <strncmp+0x54>
80104c01:	01 f7                	add    %esi,%edi
80104c03:	eb 13                	jmp    80104c18 <strncmp+0x38>
80104c05:	8d 76 00             	lea    0x0(%esi),%esi
80104c08:	0f b6 01             	movzbl (%ecx),%eax
80104c0b:	84 c0                	test   %al,%al
80104c0d:	74 21                	je     80104c30 <strncmp+0x50>
80104c0f:	0f b6 1a             	movzbl (%edx),%ebx
80104c12:	89 d6                	mov    %edx,%esi
80104c14:	38 d8                	cmp    %bl,%al
80104c16:	75 1c                	jne    80104c34 <strncmp+0x54>
    n--, p++, q++;
80104c18:	8d 56 01             	lea    0x1(%esi),%edx
80104c1b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c1e:	39 fa                	cmp    %edi,%edx
80104c20:	75 e6                	jne    80104c08 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104c22:	5b                   	pop    %ebx
    return 0;
80104c23:	31 c0                	xor    %eax,%eax
}
80104c25:	5e                   	pop    %esi
80104c26:	5f                   	pop    %edi
80104c27:	5d                   	pop    %ebp
80104c28:	c3                   	ret    
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c30:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104c34:	29 d8                	sub    %ebx,%eax
}
80104c36:	5b                   	pop    %ebx
80104c37:	5e                   	pop    %esi
80104c38:	5f                   	pop    %edi
80104c39:	5d                   	pop    %ebp
80104c3a:	c3                   	ret    
80104c3b:	90                   	nop
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c40 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
80104c45:	8b 45 08             	mov    0x8(%ebp),%eax
80104c48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c4e:	89 c2                	mov    %eax,%edx
80104c50:	eb 19                	jmp    80104c6b <strncpy+0x2b>
80104c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c58:	83 c3 01             	add    $0x1,%ebx
80104c5b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c5f:	83 c2 01             	add    $0x1,%edx
80104c62:	84 c9                	test   %cl,%cl
80104c64:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c67:	74 09                	je     80104c72 <strncpy+0x32>
80104c69:	89 f1                	mov    %esi,%ecx
80104c6b:	85 c9                	test   %ecx,%ecx
80104c6d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c70:	7f e6                	jg     80104c58 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c72:	31 c9                	xor    %ecx,%ecx
80104c74:	85 f6                	test   %esi,%esi
80104c76:	7e 17                	jle    80104c8f <strncpy+0x4f>
80104c78:	90                   	nop
80104c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c80:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c84:	89 f3                	mov    %esi,%ebx
80104c86:	83 c1 01             	add    $0x1,%ecx
80104c89:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c8b:	85 db                	test   %ebx,%ebx
80104c8d:	7f f1                	jg     80104c80 <strncpy+0x40>
  return os;
}
80104c8f:	5b                   	pop    %ebx
80104c90:	5e                   	pop    %esi
80104c91:	5d                   	pop    %ebp
80104c92:	c3                   	ret    
80104c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
80104ca5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80104cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104cae:	85 c9                	test   %ecx,%ecx
80104cb0:	7e 26                	jle    80104cd8 <safestrcpy+0x38>
80104cb2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104cb6:	89 c1                	mov    %eax,%ecx
80104cb8:	eb 17                	jmp    80104cd1 <safestrcpy+0x31>
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104cc0:	83 c2 01             	add    $0x1,%edx
80104cc3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104cc7:	83 c1 01             	add    $0x1,%ecx
80104cca:	84 db                	test   %bl,%bl
80104ccc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104ccf:	74 04                	je     80104cd5 <safestrcpy+0x35>
80104cd1:	39 f2                	cmp    %esi,%edx
80104cd3:	75 eb                	jne    80104cc0 <safestrcpy+0x20>
    ;
  *s = 0;
80104cd5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104cd8:	5b                   	pop    %ebx
80104cd9:	5e                   	pop    %esi
80104cda:	5d                   	pop    %ebp
80104cdb:	c3                   	ret    
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <strlen>:

int
strlen(const char *s)
{
80104ce0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ce1:	31 c0                	xor    %eax,%eax
{
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ce8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ceb:	74 0c                	je     80104cf9 <strlen+0x19>
80104ced:	8d 76 00             	lea    0x0(%esi),%esi
80104cf0:	83 c0 01             	add    $0x1,%eax
80104cf3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104cf7:	75 f7                	jne    80104cf0 <strlen+0x10>
    ;
  return n;
}
80104cf9:	5d                   	pop    %ebp
80104cfa:	c3                   	ret    

80104cfb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104cfb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104cff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104d03:	55                   	push   %ebp
  pushl %ebx
80104d04:	53                   	push   %ebx
  pushl %esi
80104d05:	56                   	push   %esi
  pushl %edi
80104d06:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d07:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d09:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104d0b:	5f                   	pop    %edi
  popl %esi
80104d0c:	5e                   	pop    %esi
  popl %ebx
80104d0d:	5b                   	pop    %ebx
  popl %ebp
80104d0e:	5d                   	pop    %ebp
  ret
80104d0f:	c3                   	ret    

80104d10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d10:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d11:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80104d18:	89 e5                	mov    %esp,%ebp
80104d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d1d:	8b 12                	mov    (%edx),%edx
80104d1f:	39 c2                	cmp    %eax,%edx
80104d21:	76 15                	jbe    80104d38 <fetchint+0x28>
80104d23:	8d 48 04             	lea    0x4(%eax),%ecx
80104d26:	39 ca                	cmp    %ecx,%edx
80104d28:	72 0e                	jb     80104d38 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80104d2a:	8b 10                	mov    (%eax),%edx
80104d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d2f:	89 10                	mov    %edx,(%eax)
  return 0;
80104d31:	31 c0                	xor    %eax,%eax
}
80104d33:	5d                   	pop    %ebp
80104d34:	c3                   	ret    
80104d35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d3d:	5d                   	pop    %ebp
80104d3e:	c3                   	ret    
80104d3f:	90                   	nop

80104d40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d40:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104d41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80104d47:	89 e5                	mov    %esp,%ebp
80104d49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz)
80104d4c:	39 08                	cmp    %ecx,(%eax)
80104d4e:	76 2c                	jbe    80104d7c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d50:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d53:	89 c8                	mov    %ecx,%eax
80104d55:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104d57:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d5e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104d60:	39 d1                	cmp    %edx,%ecx
80104d62:	73 18                	jae    80104d7c <fetchstr+0x3c>
    if(*s == 0)
80104d64:	80 39 00             	cmpb   $0x0,(%ecx)
80104d67:	75 0c                	jne    80104d75 <fetchstr+0x35>
80104d69:	eb 25                	jmp    80104d90 <fetchstr+0x50>
80104d6b:	90                   	nop
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d70:	80 38 00             	cmpb   $0x0,(%eax)
80104d73:	74 13                	je     80104d88 <fetchstr+0x48>
  for(s = *pp; s < ep; s++)
80104d75:	83 c0 01             	add    $0x1,%eax
80104d78:	39 c2                	cmp    %eax,%edx
80104d7a:	77 f4                	ja     80104d70 <fetchstr+0x30>
    return -1;
80104d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  return -1;
}
80104d81:	5d                   	pop    %ebp
80104d82:	c3                   	ret    
80104d83:	90                   	nop
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d88:	29 c8                	sub    %ecx,%eax
80104d8a:	5d                   	pop    %ebp
80104d8b:	c3                   	ret    
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
80104d90:	31 c0                	xor    %eax,%eax
}
80104d92:	5d                   	pop    %ebp
80104d93:	c3                   	ret    
80104d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104da0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104da0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80104da7:	55                   	push   %ebp
80104da8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104daa:	8b 42 18             	mov    0x18(%edx),%eax
80104dad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104db0:	8b 12                	mov    (%edx),%edx
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104db2:	8b 40 44             	mov    0x44(%eax),%eax
80104db5:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104db8:	8d 48 04             	lea    0x4(%eax),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104dbb:	39 d1                	cmp    %edx,%ecx
80104dbd:	73 19                	jae    80104dd8 <argint+0x38>
80104dbf:	8d 48 08             	lea    0x8(%eax),%ecx
80104dc2:	39 ca                	cmp    %ecx,%edx
80104dc4:	72 12                	jb     80104dd8 <argint+0x38>
  *ip = *(int*)(addr);
80104dc6:	8b 50 04             	mov    0x4(%eax),%edx
80104dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dcc:	89 10                	mov    %edx,(%eax)
  return 0;
80104dce:	31 c0                	xor    %eax,%eax
}
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret    
80104dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ddd:	5d                   	pop    %ebp
80104dde:	c3                   	ret    
80104ddf:	90                   	nop

80104de0 <argptr>:
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104de0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104de6:	55                   	push   %ebp
80104de7:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104de9:	8b 50 18             	mov    0x18(%eax),%edx
80104dec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104def:	8b 00                	mov    (%eax),%eax
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104df1:	8b 52 44             	mov    0x44(%edx),%edx
80104df4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104df7:	8d 4a 04             	lea    0x4(%edx),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104dfa:	39 c1                	cmp    %eax,%ecx
80104dfc:	73 22                	jae    80104e20 <argptr+0x40>
80104dfe:	8d 4a 08             	lea    0x8(%edx),%ecx
80104e01:	39 c8                	cmp    %ecx,%eax
80104e03:	72 1b                	jb     80104e20 <argptr+0x40>
  *ip = *(int*)(addr);
80104e05:	8b 52 04             	mov    0x4(%edx),%edx
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80104e08:	39 c2                	cmp    %eax,%edx
80104e0a:	73 14                	jae    80104e20 <argptr+0x40>
80104e0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e0f:	01 d1                	add    %edx,%ecx
80104e11:	39 c1                	cmp    %eax,%ecx
80104e13:	77 0b                	ja     80104e20 <argptr+0x40>
    return -1;
  *pp = (char*)i;
80104e15:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e18:	89 10                	mov    %edx,(%eax)
  return 0;
80104e1a:	31 c0                	xor    %eax,%eax
}
80104e1c:	5d                   	pop    %ebp
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax
    return -1;
80104e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e25:	5d                   	pop    %ebp
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <argstr>:
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104e30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e36:	55                   	push   %ebp
80104e37:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104e39:	8b 50 18             	mov    0x18(%eax),%edx
80104e3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104e3f:	8b 00                	mov    (%eax),%eax
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104e41:	8b 52 44             	mov    0x44(%edx),%edx
80104e44:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104e47:	8d 4a 04             	lea    0x4(%edx),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
80104e4a:	39 c1                	cmp    %eax,%ecx
80104e4c:	73 3e                	jae    80104e8c <argstr+0x5c>
80104e4e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104e51:	39 c8                	cmp    %ecx,%eax
80104e53:	72 37                	jb     80104e8c <argstr+0x5c>
  *ip = *(int*)(addr);
80104e55:	8b 4a 04             	mov    0x4(%edx),%ecx
  if(addr >= proc->sz)
80104e58:	39 c1                	cmp    %eax,%ecx
80104e5a:	73 30                	jae    80104e8c <argstr+0x5c>
  *pp = (char*)addr;
80104e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e5f:	89 c8                	mov    %ecx,%eax
80104e61:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104e63:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e6a:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104e6c:	39 d1                	cmp    %edx,%ecx
80104e6e:	73 1c                	jae    80104e8c <argstr+0x5c>
    if(*s == 0)
80104e70:	80 39 00             	cmpb   $0x0,(%ecx)
80104e73:	75 10                	jne    80104e85 <argstr+0x55>
80104e75:	eb 29                	jmp    80104ea0 <argstr+0x70>
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e80:	80 38 00             	cmpb   $0x0,(%eax)
80104e83:	74 13                	je     80104e98 <argstr+0x68>
  for(s = *pp; s < ep; s++)
80104e85:	83 c0 01             	add    $0x1,%eax
80104e88:	39 c2                	cmp    %eax,%edx
80104e8a:	77 f4                	ja     80104e80 <argstr+0x50>
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104e91:	5d                   	pop    %ebp
80104e92:	c3                   	ret    
80104e93:	90                   	nop
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e98:	29 c8                	sub    %ecx,%eax
80104e9a:	5d                   	pop    %ebp
80104e9b:	c3                   	ret    
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
80104ea0:	31 c0                	xor    %eax,%eax
}
80104ea2:	5d                   	pop    %ebp
80104ea3:	c3                   	ret    
80104ea4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104eb0 <syscall>:
[SYS_setscheduler]   sys_setscheduler
};

void
syscall(void)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	83 ec 08             	sub    $0x8,%esp
  int num;

  num = proc->tf->eax;
80104eb6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ebd:	8b 42 18             	mov    0x18(%edx),%eax
80104ec0:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ec3:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104ec6:	83 f9 18             	cmp    $0x18,%ecx
80104ec9:	77 25                	ja     80104ef0 <syscall+0x40>
80104ecb:	8b 0c 85 00 7c 10 80 	mov    -0x7fef8400(,%eax,4),%ecx
80104ed2:	85 c9                	test   %ecx,%ecx
80104ed4:	74 1a                	je     80104ef0 <syscall+0x40>
    proc->tf->eax = syscalls[num]();
80104ed6:	ff d1                	call   *%ecx
80104ed8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104edf:	8b 52 18             	mov    0x18(%edx),%edx
80104ee2:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104ee5:	c9                   	leave  
80104ee6:	c3                   	ret    
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("%d %s: unknown sys call %d\n",
80104ef0:	50                   	push   %eax
            proc->pid, proc->name, num);
80104ef1:	8d 42 6c             	lea    0x6c(%edx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ef4:	50                   	push   %eax
80104ef5:	ff 72 10             	pushl  0x10(%edx)
80104ef8:	68 d2 7b 10 80       	push   $0x80107bd2
80104efd:	e8 3e b7 ff ff       	call   80100640 <cprintf>
    proc->tf->eax = -1;
80104f02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f08:	83 c4 10             	add    $0x10,%esp
80104f0b:	8b 40 18             	mov    0x18(%eax),%eax
80104f0e:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    
80104f17:	66 90                	xchg   %ax,%ax
80104f19:	66 90                	xchg   %ax,%ax
80104f1b:	66 90                	xchg   %ax,%ax
80104f1d:	66 90                	xchg   %ax,%ax
80104f1f:	90                   	nop

80104f20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f26:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104f29:	83 ec 44             	sub    $0x44,%esp
80104f2c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104f2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104f32:	56                   	push   %esi
80104f33:	50                   	push   %eax
{
80104f34:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104f37:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f3a:	e8 91 cf ff ff       	call   80101ed0 <nameiparent>
80104f3f:	83 c4 10             	add    $0x10,%esp
80104f42:	85 c0                	test   %eax,%eax
80104f44:	0f 84 46 01 00 00    	je     80105090 <create+0x170>
    return 0;
  ilock(dp);
80104f4a:	83 ec 0c             	sub    $0xc,%esp
80104f4d:	89 c3                	mov    %eax,%ebx
80104f4f:	50                   	push   %eax
80104f50:	e8 bb c6 ff ff       	call   80101610 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104f55:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104f58:	83 c4 0c             	add    $0xc,%esp
80104f5b:	50                   	push   %eax
80104f5c:	56                   	push   %esi
80104f5d:	53                   	push   %ebx
80104f5e:	e8 1d cc ff ff       	call   80101b80 <dirlookup>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	89 c7                	mov    %eax,%edi
80104f6a:	74 34                	je     80104fa0 <create+0x80>
    iunlockput(dp);
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	53                   	push   %ebx
80104f70:	e8 6b c9 ff ff       	call   801018e0 <iunlockput>
    ilock(ip);
80104f75:	89 3c 24             	mov    %edi,(%esp)
80104f78:	e8 93 c6 ff ff       	call   80101610 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104f85:	0f 85 95 00 00 00    	jne    80105020 <create+0x100>
80104f8b:	66 83 7f 10 02       	cmpw   $0x2,0x10(%edi)
80104f90:	0f 85 8a 00 00 00    	jne    80105020 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f99:	89 f8                	mov    %edi,%eax
80104f9b:	5b                   	pop    %ebx
80104f9c:	5e                   	pop    %esi
80104f9d:	5f                   	pop    %edi
80104f9e:	5d                   	pop    %ebp
80104f9f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104fa0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104fa4:	83 ec 08             	sub    $0x8,%esp
80104fa7:	50                   	push   %eax
80104fa8:	ff 33                	pushl  (%ebx)
80104faa:	e8 f1 c4 ff ff       	call   801014a0 <ialloc>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	89 c7                	mov    %eax,%edi
80104fb6:	0f 84 e8 00 00 00    	je     801050a4 <create+0x184>
  ilock(ip);
80104fbc:	83 ec 0c             	sub    $0xc,%esp
80104fbf:	50                   	push   %eax
80104fc0:	e8 4b c6 ff ff       	call   80101610 <ilock>
  ip->major = major;
80104fc5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104fc9:	66 89 47 12          	mov    %ax,0x12(%edi)
  ip->minor = minor;
80104fcd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104fd1:	66 89 47 14          	mov    %ax,0x14(%edi)
  ip->nlink = 1;
80104fd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104fda:	66 89 47 16          	mov    %ax,0x16(%edi)
  iupdate(ip);
80104fde:	89 3c 24             	mov    %edi,(%esp)
80104fe1:	e8 7a c5 ff ff       	call   80101560 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104fe6:	83 c4 10             	add    $0x10,%esp
80104fe9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104fee:	74 50                	je     80105040 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ff0:	83 ec 04             	sub    $0x4,%esp
80104ff3:	ff 77 04             	pushl  0x4(%edi)
80104ff6:	56                   	push   %esi
80104ff7:	53                   	push   %ebx
80104ff8:	e8 f3 cd ff ff       	call   80101df0 <dirlink>
80104ffd:	83 c4 10             	add    $0x10,%esp
80105000:	85 c0                	test   %eax,%eax
80105002:	0f 88 8f 00 00 00    	js     80105097 <create+0x177>
  iunlockput(dp);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	53                   	push   %ebx
8010500c:	e8 cf c8 ff ff       	call   801018e0 <iunlockput>
  return ip;
80105011:	83 c4 10             	add    $0x10,%esp
}
80105014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105017:	89 f8                	mov    %edi,%eax
80105019:	5b                   	pop    %ebx
8010501a:	5e                   	pop    %esi
8010501b:	5f                   	pop    %edi
8010501c:	5d                   	pop    %ebp
8010501d:	c3                   	ret    
8010501e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	57                   	push   %edi
    return 0;
80105024:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105026:	e8 b5 c8 ff ff       	call   801018e0 <iunlockput>
    return 0;
8010502b:	83 c4 10             	add    $0x10,%esp
}
8010502e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105031:	89 f8                	mov    %edi,%eax
80105033:	5b                   	pop    %ebx
80105034:	5e                   	pop    %esi
80105035:	5f                   	pop    %edi
80105036:	5d                   	pop    %ebp
80105037:	c3                   	ret    
80105038:	90                   	nop
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105040:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
    iupdate(dp);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	53                   	push   %ebx
80105049:	e8 12 c5 ff ff       	call   80101560 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010504e:	83 c4 0c             	add    $0xc,%esp
80105051:	ff 77 04             	pushl  0x4(%edi)
80105054:	68 84 7c 10 80       	push   $0x80107c84
80105059:	57                   	push   %edi
8010505a:	e8 91 cd ff ff       	call   80101df0 <dirlink>
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	85 c0                	test   %eax,%eax
80105064:	78 1c                	js     80105082 <create+0x162>
80105066:	83 ec 04             	sub    $0x4,%esp
80105069:	ff 73 04             	pushl  0x4(%ebx)
8010506c:	68 83 7c 10 80       	push   $0x80107c83
80105071:	57                   	push   %edi
80105072:	e8 79 cd ff ff       	call   80101df0 <dirlink>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	85 c0                	test   %eax,%eax
8010507c:	0f 89 6e ff ff ff    	jns    80104ff0 <create+0xd0>
      panic("create dots");
80105082:	83 ec 0c             	sub    $0xc,%esp
80105085:	68 77 7c 10 80       	push   $0x80107c77
8010508a:	e8 e1 b2 ff ff       	call   80100370 <panic>
8010508f:	90                   	nop
    return 0;
80105090:	31 ff                	xor    %edi,%edi
80105092:	e9 ff fe ff ff       	jmp    80104f96 <create+0x76>
    panic("create: dirlink");
80105097:	83 ec 0c             	sub    $0xc,%esp
8010509a:	68 86 7c 10 80       	push   $0x80107c86
8010509f:	e8 cc b2 ff ff       	call   80100370 <panic>
    panic("create: ialloc");
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	68 68 7c 10 80       	push   $0x80107c68
801050ac:	e8 bf b2 ff ff       	call   80100370 <panic>
801050b1:	eb 0d                	jmp    801050c0 <argfd.constprop.0>
801050b3:	90                   	nop
801050b4:	90                   	nop
801050b5:	90                   	nop
801050b6:	90                   	nop
801050b7:	90                   	nop
801050b8:	90                   	nop
801050b9:	90                   	nop
801050ba:	90                   	nop
801050bb:	90                   	nop
801050bc:	90                   	nop
801050bd:	90                   	nop
801050be:	90                   	nop
801050bf:	90                   	nop

801050c0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
801050c5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801050c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801050ca:	89 d6                	mov    %edx,%esi
801050cc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050cf:	50                   	push   %eax
801050d0:	6a 00                	push   $0x0
801050d2:	e8 c9 fc ff ff       	call   80104da0 <argint>
801050d7:	83 c4 10             	add    $0x10,%esp
801050da:	85 c0                	test   %eax,%eax
801050dc:	78 32                	js     80105110 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801050de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e1:	83 f8 0f             	cmp    $0xf,%eax
801050e4:	77 2a                	ja     80105110 <argfd.constprop.0+0x50>
801050e6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050ed:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
801050f1:	85 c9                	test   %ecx,%ecx
801050f3:	74 1b                	je     80105110 <argfd.constprop.0+0x50>
  if(pfd)
801050f5:	85 db                	test   %ebx,%ebx
801050f7:	74 02                	je     801050fb <argfd.constprop.0+0x3b>
    *pfd = fd;
801050f9:	89 03                	mov    %eax,(%ebx)
    *pf = f;
801050fb:	89 0e                	mov    %ecx,(%esi)
  return 0;
801050fd:	31 c0                	xor    %eax,%eax
}
801050ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105102:	5b                   	pop    %ebx
80105103:	5e                   	pop    %esi
80105104:	5d                   	pop    %ebp
80105105:	c3                   	ret    
80105106:	8d 76 00             	lea    0x0(%esi),%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb e8                	jmp    801050ff <argfd.constprop.0+0x3f>
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_dup>:
{
80105120:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105121:	31 c0                	xor    %eax,%eax
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105126:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105129:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010512c:	e8 8f ff ff ff       	call   801050c0 <argfd.constprop.0>
80105131:	85 c0                	test   %eax,%eax
80105133:	78 3b                	js     80105170 <sys_dup+0x50>
  if((fd=fdalloc(f)) < 0)
80105135:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if(proc->ofile[fd] == 0){
80105138:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(fd = 0; fd < NOFILE; fd++){
8010513e:	31 db                	xor    %ebx,%ebx
80105140:	eb 0e                	jmp    80105150 <sys_dup+0x30>
80105142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105148:	83 c3 01             	add    $0x1,%ebx
8010514b:	83 fb 10             	cmp    $0x10,%ebx
8010514e:	74 20                	je     80105170 <sys_dup+0x50>
    if(proc->ofile[fd] == 0){
80105150:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80105154:	85 c9                	test   %ecx,%ecx
80105156:	75 f0                	jne    80105148 <sys_dup+0x28>
  filedup(f);
80105158:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
8010515b:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  filedup(f);
8010515f:	52                   	push   %edx
80105160:	e8 5b bc ff ff       	call   80100dc0 <filedup>
}
80105165:	89 d8                	mov    %ebx,%eax
  return fd;
80105167:	83 c4 10             	add    $0x10,%esp
}
8010516a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010516d:	c9                   	leave  
8010516e:	c3                   	ret    
8010516f:	90                   	nop
    return -1;
80105170:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105175:	89 d8                	mov    %ebx,%eax
80105177:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010517a:	c9                   	leave  
8010517b:	c3                   	ret    
8010517c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105180 <sys_read>:
{
80105180:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105181:	31 c0                	xor    %eax,%eax
{
80105183:	89 e5                	mov    %esp,%ebp
80105185:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105188:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010518b:	e8 30 ff ff ff       	call   801050c0 <argfd.constprop.0>
80105190:	85 c0                	test   %eax,%eax
80105192:	78 4c                	js     801051e0 <sys_read+0x60>
80105194:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105197:	83 ec 08             	sub    $0x8,%esp
8010519a:	50                   	push   %eax
8010519b:	6a 02                	push   $0x2
8010519d:	e8 fe fb ff ff       	call   80104da0 <argint>
801051a2:	83 c4 10             	add    $0x10,%esp
801051a5:	85 c0                	test   %eax,%eax
801051a7:	78 37                	js     801051e0 <sys_read+0x60>
801051a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ac:	83 ec 04             	sub    $0x4,%esp
801051af:	ff 75 f0             	pushl  -0x10(%ebp)
801051b2:	50                   	push   %eax
801051b3:	6a 01                	push   $0x1
801051b5:	e8 26 fc ff ff       	call   80104de0 <argptr>
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	85 c0                	test   %eax,%eax
801051bf:	78 1f                	js     801051e0 <sys_read+0x60>
  return fileread(f, p, n);
801051c1:	83 ec 04             	sub    $0x4,%esp
801051c4:	ff 75 f0             	pushl  -0x10(%ebp)
801051c7:	ff 75 f4             	pushl  -0xc(%ebp)
801051ca:	ff 75 ec             	pushl  -0x14(%ebp)
801051cd:	e8 5e bd ff ff       	call   80100f30 <fileread>
801051d2:	83 c4 10             	add    $0x10,%esp
}
801051d5:	c9                   	leave  
801051d6:	c3                   	ret    
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051f0 <sys_write>:
{
801051f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051f1:	31 c0                	xor    %eax,%eax
{
801051f3:	89 e5                	mov    %esp,%ebp
801051f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051fb:	e8 c0 fe ff ff       	call   801050c0 <argfd.constprop.0>
80105200:	85 c0                	test   %eax,%eax
80105202:	78 4c                	js     80105250 <sys_write+0x60>
80105204:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105207:	83 ec 08             	sub    $0x8,%esp
8010520a:	50                   	push   %eax
8010520b:	6a 02                	push   $0x2
8010520d:	e8 8e fb ff ff       	call   80104da0 <argint>
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	85 c0                	test   %eax,%eax
80105217:	78 37                	js     80105250 <sys_write+0x60>
80105219:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521c:	83 ec 04             	sub    $0x4,%esp
8010521f:	ff 75 f0             	pushl  -0x10(%ebp)
80105222:	50                   	push   %eax
80105223:	6a 01                	push   $0x1
80105225:	e8 b6 fb ff ff       	call   80104de0 <argptr>
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	85 c0                	test   %eax,%eax
8010522f:	78 1f                	js     80105250 <sys_write+0x60>
  return filewrite(f, p, n);
80105231:	83 ec 04             	sub    $0x4,%esp
80105234:	ff 75 f0             	pushl  -0x10(%ebp)
80105237:	ff 75 f4             	pushl  -0xc(%ebp)
8010523a:	ff 75 ec             	pushl  -0x14(%ebp)
8010523d:	e8 7e bd ff ff       	call   80100fc0 <filewrite>
80105242:	83 c4 10             	add    $0x10,%esp
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <sys_close>:
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105266:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105269:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010526c:	e8 4f fe ff ff       	call   801050c0 <argfd.constprop.0>
80105271:	85 c0                	test   %eax,%eax
80105273:	78 2b                	js     801052a0 <sys_close+0x40>
  proc->ofile[fd] = 0;
80105275:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010527b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010527e:	83 ec 0c             	sub    $0xc,%esp
  proc->ofile[fd] = 0;
80105281:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105288:	00 
  fileclose(f);
80105289:	ff 75 f4             	pushl  -0xc(%ebp)
8010528c:	e8 7f bb ff ff       	call   80100e10 <fileclose>
  return 0;
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	31 c0                	xor    %eax,%eax
}
80105296:	c9                   	leave  
80105297:	c3                   	ret    
80105298:	90                   	nop
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_fstat>:
{
801052b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052b1:	31 c0                	xor    %eax,%eax
{
801052b3:	89 e5                	mov    %esp,%ebp
801052b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052b8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801052bb:	e8 00 fe ff ff       	call   801050c0 <argfd.constprop.0>
801052c0:	85 c0                	test   %eax,%eax
801052c2:	78 2c                	js     801052f0 <sys_fstat+0x40>
801052c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c7:	83 ec 04             	sub    $0x4,%esp
801052ca:	6a 14                	push   $0x14
801052cc:	50                   	push   %eax
801052cd:	6a 01                	push   $0x1
801052cf:	e8 0c fb ff ff       	call   80104de0 <argptr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	78 15                	js     801052f0 <sys_fstat+0x40>
  return filestat(f, st);
801052db:	83 ec 08             	sub    $0x8,%esp
801052de:	ff 75 f4             	pushl  -0xc(%ebp)
801052e1:	ff 75 f0             	pushl  -0x10(%ebp)
801052e4:	e8 f7 bb ff ff       	call   80100ee0 <filestat>
801052e9:	83 c4 10             	add    $0x10,%esp
}
801052ec:	c9                   	leave  
801052ed:	c3                   	ret    
801052ee:	66 90                	xchg   %ax,%ax
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <sys_link>:
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	56                   	push   %esi
80105305:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105306:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105309:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010530c:	50                   	push   %eax
8010530d:	6a 00                	push   $0x0
8010530f:	e8 1c fb ff ff       	call   80104e30 <argstr>
80105314:	83 c4 10             	add    $0x10,%esp
80105317:	85 c0                	test   %eax,%eax
80105319:	0f 88 fb 00 00 00    	js     8010541a <sys_link+0x11a>
8010531f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105322:	83 ec 08             	sub    $0x8,%esp
80105325:	50                   	push   %eax
80105326:	6a 01                	push   $0x1
80105328:	e8 03 fb ff ff       	call   80104e30 <argstr>
8010532d:	83 c4 10             	add    $0x10,%esp
80105330:	85 c0                	test   %eax,%eax
80105332:	0f 88 e2 00 00 00    	js     8010541a <sys_link+0x11a>
  begin_op();
80105338:	e8 03 d9 ff ff       	call   80102c40 <begin_op>
  if((ip = namei(old)) == 0){
8010533d:	83 ec 0c             	sub    $0xc,%esp
80105340:	ff 75 d4             	pushl  -0x2c(%ebp)
80105343:	e8 68 cb ff ff       	call   80101eb0 <namei>
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	85 c0                	test   %eax,%eax
8010534d:	89 c3                	mov    %eax,%ebx
8010534f:	0f 84 ea 00 00 00    	je     8010543f <sys_link+0x13f>
  ilock(ip);
80105355:	83 ec 0c             	sub    $0xc,%esp
80105358:	50                   	push   %eax
80105359:	e8 b2 c2 ff ff       	call   80101610 <ilock>
  if(ip->type == T_DIR){
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80105366:	0f 84 bb 00 00 00    	je     80105427 <sys_link+0x127>
  ip->nlink++;
8010536c:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
80105371:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105374:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105377:	53                   	push   %ebx
80105378:	e8 e3 c1 ff ff       	call   80101560 <iupdate>
  iunlock(ip);
8010537d:	89 1c 24             	mov    %ebx,(%esp)
80105380:	e8 9b c3 ff ff       	call   80101720 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105385:	58                   	pop    %eax
80105386:	5a                   	pop    %edx
80105387:	57                   	push   %edi
80105388:	ff 75 d0             	pushl  -0x30(%ebp)
8010538b:	e8 40 cb ff ff       	call   80101ed0 <nameiparent>
80105390:	83 c4 10             	add    $0x10,%esp
80105393:	85 c0                	test   %eax,%eax
80105395:	89 c6                	mov    %eax,%esi
80105397:	74 5b                	je     801053f4 <sys_link+0xf4>
  ilock(dp);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	50                   	push   %eax
8010539d:	e8 6e c2 ff ff       	call   80101610 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	8b 03                	mov    (%ebx),%eax
801053a7:	39 06                	cmp    %eax,(%esi)
801053a9:	75 3d                	jne    801053e8 <sys_link+0xe8>
801053ab:	83 ec 04             	sub    $0x4,%esp
801053ae:	ff 73 04             	pushl  0x4(%ebx)
801053b1:	57                   	push   %edi
801053b2:	56                   	push   %esi
801053b3:	e8 38 ca ff ff       	call   80101df0 <dirlink>
801053b8:	83 c4 10             	add    $0x10,%esp
801053bb:	85 c0                	test   %eax,%eax
801053bd:	78 29                	js     801053e8 <sys_link+0xe8>
  iunlockput(dp);
801053bf:	83 ec 0c             	sub    $0xc,%esp
801053c2:	56                   	push   %esi
801053c3:	e8 18 c5 ff ff       	call   801018e0 <iunlockput>
  iput(ip);
801053c8:	89 1c 24             	mov    %ebx,(%esp)
801053cb:	e8 b0 c3 ff ff       	call   80101780 <iput>
  end_op();
801053d0:	e8 db d8 ff ff       	call   80102cb0 <end_op>
  return 0;
801053d5:	83 c4 10             	add    $0x10,%esp
801053d8:	31 c0                	xor    %eax,%eax
}
801053da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053dd:	5b                   	pop    %ebx
801053de:	5e                   	pop    %esi
801053df:	5f                   	pop    %edi
801053e0:	5d                   	pop    %ebp
801053e1:	c3                   	ret    
801053e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801053e8:	83 ec 0c             	sub    $0xc,%esp
801053eb:	56                   	push   %esi
801053ec:	e8 ef c4 ff ff       	call   801018e0 <iunlockput>
    goto bad;
801053f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801053f4:	83 ec 0c             	sub    $0xc,%esp
801053f7:	53                   	push   %ebx
801053f8:	e8 13 c2 ff ff       	call   80101610 <ilock>
  ip->nlink--;
801053fd:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80105402:	89 1c 24             	mov    %ebx,(%esp)
80105405:	e8 56 c1 ff ff       	call   80101560 <iupdate>
  iunlockput(ip);
8010540a:	89 1c 24             	mov    %ebx,(%esp)
8010540d:	e8 ce c4 ff ff       	call   801018e0 <iunlockput>
  end_op();
80105412:	e8 99 d8 ff ff       	call   80102cb0 <end_op>
  return -1;
80105417:	83 c4 10             	add    $0x10,%esp
}
8010541a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010541d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105422:	5b                   	pop    %ebx
80105423:	5e                   	pop    %esi
80105424:	5f                   	pop    %edi
80105425:	5d                   	pop    %ebp
80105426:	c3                   	ret    
    iunlockput(ip);
80105427:	83 ec 0c             	sub    $0xc,%esp
8010542a:	53                   	push   %ebx
8010542b:	e8 b0 c4 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105430:	e8 7b d8 ff ff       	call   80102cb0 <end_op>
    return -1;
80105435:	83 c4 10             	add    $0x10,%esp
80105438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543d:	eb 9b                	jmp    801053da <sys_link+0xda>
    end_op();
8010543f:	e8 6c d8 ff ff       	call   80102cb0 <end_op>
    return -1;
80105444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105449:	eb 8f                	jmp    801053da <sys_link+0xda>
8010544b:	90                   	nop
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_unlink>:
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105456:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105459:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010545c:	50                   	push   %eax
8010545d:	6a 00                	push   $0x0
8010545f:	e8 cc f9 ff ff       	call   80104e30 <argstr>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	85 c0                	test   %eax,%eax
80105469:	0f 88 77 01 00 00    	js     801055e6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010546f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105472:	e8 c9 d7 ff ff       	call   80102c40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105477:	83 ec 08             	sub    $0x8,%esp
8010547a:	53                   	push   %ebx
8010547b:	ff 75 c0             	pushl  -0x40(%ebp)
8010547e:	e8 4d ca ff ff       	call   80101ed0 <nameiparent>
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	85 c0                	test   %eax,%eax
80105488:	89 c6                	mov    %eax,%esi
8010548a:	0f 84 60 01 00 00    	je     801055f0 <sys_unlink+0x1a0>
  ilock(dp);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	50                   	push   %eax
80105494:	e8 77 c1 ff ff       	call   80101610 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105499:	58                   	pop    %eax
8010549a:	5a                   	pop    %edx
8010549b:	68 84 7c 10 80       	push   $0x80107c84
801054a0:	53                   	push   %ebx
801054a1:	e8 ba c6 ff ff       	call   80101b60 <namecmp>
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	85 c0                	test   %eax,%eax
801054ab:	0f 84 03 01 00 00    	je     801055b4 <sys_unlink+0x164>
801054b1:	83 ec 08             	sub    $0x8,%esp
801054b4:	68 83 7c 10 80       	push   $0x80107c83
801054b9:	53                   	push   %ebx
801054ba:	e8 a1 c6 ff ff       	call   80101b60 <namecmp>
801054bf:	83 c4 10             	add    $0x10,%esp
801054c2:	85 c0                	test   %eax,%eax
801054c4:	0f 84 ea 00 00 00    	je     801055b4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801054ca:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054cd:	83 ec 04             	sub    $0x4,%esp
801054d0:	50                   	push   %eax
801054d1:	53                   	push   %ebx
801054d2:	56                   	push   %esi
801054d3:	e8 a8 c6 ff ff       	call   80101b80 <dirlookup>
801054d8:	83 c4 10             	add    $0x10,%esp
801054db:	85 c0                	test   %eax,%eax
801054dd:	89 c3                	mov    %eax,%ebx
801054df:	0f 84 cf 00 00 00    	je     801055b4 <sys_unlink+0x164>
  ilock(ip);
801054e5:	83 ec 0c             	sub    $0xc,%esp
801054e8:	50                   	push   %eax
801054e9:	e8 22 c1 ff ff       	call   80101610 <ilock>
  if(ip->nlink < 1)
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
801054f6:	0f 8e 10 01 00 00    	jle    8010560c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054fc:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80105501:	74 6d                	je     80105570 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105503:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105506:	83 ec 04             	sub    $0x4,%esp
80105509:	6a 10                	push   $0x10
8010550b:	6a 00                	push   $0x0
8010550d:	50                   	push   %eax
8010550e:	e8 ad f5 ff ff       	call   80104ac0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105513:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105516:	6a 10                	push   $0x10
80105518:	ff 75 c4             	pushl  -0x3c(%ebp)
8010551b:	50                   	push   %eax
8010551c:	56                   	push   %esi
8010551d:	e8 0e c5 ff ff       	call   80101a30 <writei>
80105522:	83 c4 20             	add    $0x20,%esp
80105525:	83 f8 10             	cmp    $0x10,%eax
80105528:	0f 85 eb 00 00 00    	jne    80105619 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010552e:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80105533:	0f 84 97 00 00 00    	je     801055d0 <sys_unlink+0x180>
  iunlockput(dp);
80105539:	83 ec 0c             	sub    $0xc,%esp
8010553c:	56                   	push   %esi
8010553d:	e8 9e c3 ff ff       	call   801018e0 <iunlockput>
  ip->nlink--;
80105542:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80105547:	89 1c 24             	mov    %ebx,(%esp)
8010554a:	e8 11 c0 ff ff       	call   80101560 <iupdate>
  iunlockput(ip);
8010554f:	89 1c 24             	mov    %ebx,(%esp)
80105552:	e8 89 c3 ff ff       	call   801018e0 <iunlockput>
  end_op();
80105557:	e8 54 d7 ff ff       	call   80102cb0 <end_op>
  return 0;
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	31 c0                	xor    %eax,%eax
}
80105561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105564:	5b                   	pop    %ebx
80105565:	5e                   	pop    %esi
80105566:	5f                   	pop    %edi
80105567:	5d                   	pop    %ebp
80105568:	c3                   	ret    
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105570:	83 7b 18 20          	cmpl   $0x20,0x18(%ebx)
80105574:	76 8d                	jbe    80105503 <sys_unlink+0xb3>
80105576:	bf 20 00 00 00       	mov    $0x20,%edi
8010557b:	eb 0f                	jmp    8010558c <sys_unlink+0x13c>
8010557d:	8d 76 00             	lea    0x0(%esi),%esi
80105580:	83 c7 10             	add    $0x10,%edi
80105583:	3b 7b 18             	cmp    0x18(%ebx),%edi
80105586:	0f 83 77 ff ff ff    	jae    80105503 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010558c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010558f:	6a 10                	push   $0x10
80105591:	57                   	push   %edi
80105592:	50                   	push   %eax
80105593:	53                   	push   %ebx
80105594:	e8 97 c3 ff ff       	call   80101930 <readi>
80105599:	83 c4 10             	add    $0x10,%esp
8010559c:	83 f8 10             	cmp    $0x10,%eax
8010559f:	75 5e                	jne    801055ff <sys_unlink+0x1af>
    if(de.inum != 0)
801055a1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055a6:	74 d8                	je     80105580 <sys_unlink+0x130>
    iunlockput(ip);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	53                   	push   %ebx
801055ac:	e8 2f c3 ff ff       	call   801018e0 <iunlockput>
    goto bad;
801055b1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801055b4:	83 ec 0c             	sub    $0xc,%esp
801055b7:	56                   	push   %esi
801055b8:	e8 23 c3 ff ff       	call   801018e0 <iunlockput>
  end_op();
801055bd:	e8 ee d6 ff ff       	call   80102cb0 <end_op>
  return -1;
801055c2:	83 c4 10             	add    $0x10,%esp
801055c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ca:	eb 95                	jmp    80105561 <sys_unlink+0x111>
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801055d0:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
    iupdate(dp);
801055d5:	83 ec 0c             	sub    $0xc,%esp
801055d8:	56                   	push   %esi
801055d9:	e8 82 bf ff ff       	call   80101560 <iupdate>
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	e9 53 ff ff ff       	jmp    80105539 <sys_unlink+0xe9>
    return -1;
801055e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055eb:	e9 71 ff ff ff       	jmp    80105561 <sys_unlink+0x111>
    end_op();
801055f0:	e8 bb d6 ff ff       	call   80102cb0 <end_op>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fa:	e9 62 ff ff ff       	jmp    80105561 <sys_unlink+0x111>
      panic("isdirempty: readi");
801055ff:	83 ec 0c             	sub    $0xc,%esp
80105602:	68 a8 7c 10 80       	push   $0x80107ca8
80105607:	e8 64 ad ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
8010560c:	83 ec 0c             	sub    $0xc,%esp
8010560f:	68 96 7c 10 80       	push   $0x80107c96
80105614:	e8 57 ad ff ff       	call   80100370 <panic>
    panic("unlink: writei");
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	68 ba 7c 10 80       	push   $0x80107cba
80105621:	e8 4a ad ff ff       	call   80100370 <panic>
80105626:	8d 76 00             	lea    0x0(%esi),%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_open>:

int
sys_open(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
80105635:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105636:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105639:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010563c:	50                   	push   %eax
8010563d:	6a 00                	push   $0x0
8010563f:	e8 ec f7 ff ff       	call   80104e30 <argstr>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	85 c0                	test   %eax,%eax
80105649:	0f 88 1d 01 00 00    	js     8010576c <sys_open+0x13c>
8010564f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105652:	83 ec 08             	sub    $0x8,%esp
80105655:	50                   	push   %eax
80105656:	6a 01                	push   $0x1
80105658:	e8 43 f7 ff ff       	call   80104da0 <argint>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	0f 88 04 01 00 00    	js     8010576c <sys_open+0x13c>
    return -1;

  begin_op();
80105668:	e8 d3 d5 ff ff       	call   80102c40 <begin_op>

  if(omode & O_CREATE){
8010566d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105671:	0f 85 a9 00 00 00    	jne    80105720 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105677:	83 ec 0c             	sub    $0xc,%esp
8010567a:	ff 75 e0             	pushl  -0x20(%ebp)
8010567d:	e8 2e c8 ff ff       	call   80101eb0 <namei>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	85 c0                	test   %eax,%eax
80105687:	89 c6                	mov    %eax,%esi
80105689:	0f 84 b2 00 00 00    	je     80105741 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	50                   	push   %eax
80105693:	e8 78 bf ff ff       	call   80101610 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
801056a0:	0f 84 aa 00 00 00    	je     80105750 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056a6:	e8 a5 b6 ff ff       	call   80100d50 <filealloc>
801056ab:	85 c0                	test   %eax,%eax
801056ad:	89 c7                	mov    %eax,%edi
801056af:	0f 84 a6 00 00 00    	je     8010575b <sys_open+0x12b>
    if(proc->ofile[fd] == 0){
801056b5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  for(fd = 0; fd < NOFILE; fd++){
801056bc:	31 db                	xor    %ebx,%ebx
801056be:	eb 0c                	jmp    801056cc <sys_open+0x9c>
801056c0:	83 c3 01             	add    $0x1,%ebx
801056c3:	83 fb 10             	cmp    $0x10,%ebx
801056c6:	0f 84 ac 00 00 00    	je     80105778 <sys_open+0x148>
    if(proc->ofile[fd] == 0){
801056cc:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801056d0:	85 c0                	test   %eax,%eax
801056d2:	75 ec                	jne    801056c0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056d4:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
801056d7:	89 7c 9a 28          	mov    %edi,0x28(%edx,%ebx,4)
  iunlock(ip);
801056db:	56                   	push   %esi
801056dc:	e8 3f c0 ff ff       	call   80101720 <iunlock>
  end_op();
801056e1:	e8 ca d5 ff ff       	call   80102cb0 <end_op>

  f->type = FD_INODE;
801056e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056ef:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056f2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801056f5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056fc:	89 d0                	mov    %edx,%eax
801056fe:	f7 d0                	not    %eax
80105700:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105703:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105706:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105709:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010570d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105710:	89 d8                	mov    %ebx,%eax
80105712:	5b                   	pop    %ebx
80105713:	5e                   	pop    %esi
80105714:	5f                   	pop    %edi
80105715:	5d                   	pop    %ebp
80105716:	c3                   	ret    
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105726:	31 c9                	xor    %ecx,%ecx
80105728:	6a 00                	push   $0x0
8010572a:	ba 02 00 00 00       	mov    $0x2,%edx
8010572f:	e8 ec f7 ff ff       	call   80104f20 <create>
    if(ip == 0){
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105739:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010573b:	0f 85 65 ff ff ff    	jne    801056a6 <sys_open+0x76>
      end_op();
80105741:	e8 6a d5 ff ff       	call   80102cb0 <end_op>
      return -1;
80105746:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010574b:	eb c0                	jmp    8010570d <sys_open+0xdd>
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105750:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105753:	85 d2                	test   %edx,%edx
80105755:	0f 84 4b ff ff ff    	je     801056a6 <sys_open+0x76>
    iunlockput(ip);
8010575b:	83 ec 0c             	sub    $0xc,%esp
8010575e:	56                   	push   %esi
8010575f:	e8 7c c1 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105764:	e8 47 d5 ff ff       	call   80102cb0 <end_op>
    return -1;
80105769:	83 c4 10             	add    $0x10,%esp
8010576c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105771:	eb 9a                	jmp    8010570d <sys_open+0xdd>
80105773:	90                   	nop
80105774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105778:	83 ec 0c             	sub    $0xc,%esp
8010577b:	57                   	push   %edi
8010577c:	e8 8f b6 ff ff       	call   80100e10 <fileclose>
80105781:	83 c4 10             	add    $0x10,%esp
80105784:	eb d5                	jmp    8010575b <sys_open+0x12b>
80105786:	8d 76 00             	lea    0x0(%esi),%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_mkdir>:

int
sys_mkdir(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105796:	e8 a5 d4 ff ff       	call   80102c40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010579b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010579e:	83 ec 08             	sub    $0x8,%esp
801057a1:	50                   	push   %eax
801057a2:	6a 00                	push   $0x0
801057a4:	e8 87 f6 ff ff       	call   80104e30 <argstr>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 30                	js     801057e0 <sys_mkdir+0x50>
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b6:	31 c9                	xor    %ecx,%ecx
801057b8:	6a 00                	push   $0x0
801057ba:	ba 01 00 00 00       	mov    $0x1,%edx
801057bf:	e8 5c f7 ff ff       	call   80104f20 <create>
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
801057c9:	74 15                	je     801057e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057cb:	83 ec 0c             	sub    $0xc,%esp
801057ce:	50                   	push   %eax
801057cf:	e8 0c c1 ff ff       	call   801018e0 <iunlockput>
  end_op();
801057d4:	e8 d7 d4 ff ff       	call   80102cb0 <end_op>
  return 0;
801057d9:	83 c4 10             	add    $0x10,%esp
801057dc:	31 c0                	xor    %eax,%eax
}
801057de:	c9                   	leave  
801057df:	c3                   	ret    
    end_op();
801057e0:	e8 cb d4 ff ff       	call   80102cb0 <end_op>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ea:	c9                   	leave  
801057eb:	c3                   	ret    
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_mknod>:

int
sys_mknod(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057f6:	e8 45 d4 ff ff       	call   80102c40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057fe:	83 ec 08             	sub    $0x8,%esp
80105801:	50                   	push   %eax
80105802:	6a 00                	push   $0x0
80105804:	e8 27 f6 ff ff       	call   80104e30 <argstr>
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	85 c0                	test   %eax,%eax
8010580e:	78 60                	js     80105870 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105810:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105813:	83 ec 08             	sub    $0x8,%esp
80105816:	50                   	push   %eax
80105817:	6a 01                	push   $0x1
80105819:	e8 82 f5 ff ff       	call   80104da0 <argint>
  if((argstr(0, &path)) < 0 ||
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	85 c0                	test   %eax,%eax
80105823:	78 4b                	js     80105870 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105825:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105828:	83 ec 08             	sub    $0x8,%esp
8010582b:	50                   	push   %eax
8010582c:	6a 02                	push   $0x2
8010582e:	e8 6d f5 ff ff       	call   80104da0 <argint>
     argint(1, &major) < 0 ||
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	78 36                	js     80105870 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010583a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010583e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105841:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105845:	ba 03 00 00 00       	mov    $0x3,%edx
8010584a:	50                   	push   %eax
8010584b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010584e:	e8 cd f6 ff ff       	call   80104f20 <create>
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	85 c0                	test   %eax,%eax
80105858:	74 16                	je     80105870 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	50                   	push   %eax
8010585e:	e8 7d c0 ff ff       	call   801018e0 <iunlockput>
  end_op();
80105863:	e8 48 d4 ff ff       	call   80102cb0 <end_op>
  return 0;
80105868:	83 c4 10             	add    $0x10,%esp
8010586b:	31 c0                	xor    %eax,%eax
}
8010586d:	c9                   	leave  
8010586e:	c3                   	ret    
8010586f:	90                   	nop
    end_op();
80105870:	e8 3b d4 ff ff       	call   80102cb0 <end_op>
    return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010587a:	c9                   	leave  
8010587b:	c3                   	ret    
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_chdir>:

int
sys_chdir(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	53                   	push   %ebx
80105884:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105887:	e8 b4 d3 ff ff       	call   80102c40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010588c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010588f:	83 ec 08             	sub    $0x8,%esp
80105892:	50                   	push   %eax
80105893:	6a 00                	push   $0x0
80105895:	e8 96 f5 ff ff       	call   80104e30 <argstr>
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	85 c0                	test   %eax,%eax
8010589f:	78 7f                	js     80105920 <sys_chdir+0xa0>
801058a1:	83 ec 0c             	sub    $0xc,%esp
801058a4:	ff 75 f4             	pushl  -0xc(%ebp)
801058a7:	e8 04 c6 ff ff       	call   80101eb0 <namei>
801058ac:	83 c4 10             	add    $0x10,%esp
801058af:	85 c0                	test   %eax,%eax
801058b1:	89 c3                	mov    %eax,%ebx
801058b3:	74 6b                	je     80105920 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058b5:	83 ec 0c             	sub    $0xc,%esp
801058b8:	50                   	push   %eax
801058b9:	e8 52 bd ff ff       	call   80101610 <ilock>
  if(ip->type != T_DIR){
801058be:	83 c4 10             	add    $0x10,%esp
801058c1:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
801058c6:	75 38                	jne    80105900 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	53                   	push   %ebx
801058cc:	e8 4f be ff ff       	call   80101720 <iunlock>
  iput(proc->cwd);
801058d1:	58                   	pop    %eax
801058d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d8:	ff 70 68             	pushl  0x68(%eax)
801058db:	e8 a0 be ff ff       	call   80101780 <iput>
  end_op();
801058e0:	e8 cb d3 ff ff       	call   80102cb0 <end_op>
  proc->cwd = ip;
801058e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
801058eb:	83 c4 10             	add    $0x10,%esp
  proc->cwd = ip;
801058ee:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
801058f1:	31 c0                	xor    %eax,%eax
}
801058f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058f6:	c9                   	leave  
801058f7:	c3                   	ret    
801058f8:	90                   	nop
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	53                   	push   %ebx
80105904:	e8 d7 bf ff ff       	call   801018e0 <iunlockput>
    end_op();
80105909:	e8 a2 d3 ff ff       	call   80102cb0 <end_op>
    return -1;
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105916:	eb db                	jmp    801058f3 <sys_chdir+0x73>
80105918:	90                   	nop
80105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105920:	e8 8b d3 ff ff       	call   80102cb0 <end_op>
    return -1;
80105925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592a:	eb c7                	jmp    801058f3 <sys_chdir+0x73>
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_exec>:

int
sys_exec(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	57                   	push   %edi
80105934:	56                   	push   %esi
80105935:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105936:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010593c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105942:	50                   	push   %eax
80105943:	6a 00                	push   $0x0
80105945:	e8 e6 f4 ff ff       	call   80104e30 <argstr>
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	85 c0                	test   %eax,%eax
8010594f:	0f 88 87 00 00 00    	js     801059dc <sys_exec+0xac>
80105955:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010595b:	83 ec 08             	sub    $0x8,%esp
8010595e:	50                   	push   %eax
8010595f:	6a 01                	push   $0x1
80105961:	e8 3a f4 ff ff       	call   80104da0 <argint>
80105966:	83 c4 10             	add    $0x10,%esp
80105969:	85 c0                	test   %eax,%eax
8010596b:	78 6f                	js     801059dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010596d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105973:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105976:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105978:	68 80 00 00 00       	push   $0x80
8010597d:	6a 00                	push   $0x0
8010597f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105985:	50                   	push   %eax
80105986:	e8 35 f1 ff ff       	call   80104ac0 <memset>
8010598b:	83 c4 10             	add    $0x10,%esp
8010598e:	eb 2c                	jmp    801059bc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105990:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105996:	85 c0                	test   %eax,%eax
80105998:	74 56                	je     801059f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010599a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801059a0:	83 ec 08             	sub    $0x8,%esp
801059a3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801059a6:	52                   	push   %edx
801059a7:	50                   	push   %eax
801059a8:	e8 93 f3 ff ff       	call   80104d40 <fetchstr>
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	85 c0                	test   %eax,%eax
801059b2:	78 28                	js     801059dc <sys_exec+0xac>
  for(i=0;; i++){
801059b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801059b7:	83 fb 20             	cmp    $0x20,%ebx
801059ba:	74 20                	je     801059dc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059bc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059c2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801059c9:	83 ec 08             	sub    $0x8,%esp
801059cc:	57                   	push   %edi
801059cd:	01 f0                	add    %esi,%eax
801059cf:	50                   	push   %eax
801059d0:	e8 3b f3 ff ff       	call   80104d10 <fetchint>
801059d5:	83 c4 10             	add    $0x10,%esp
801059d8:	85 c0                	test   %eax,%eax
801059da:	79 b4                	jns    80105990 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e4:	5b                   	pop    %ebx
801059e5:	5e                   	pop    %esi
801059e6:	5f                   	pop    %edi
801059e7:	5d                   	pop    %ebp
801059e8:	c3                   	ret    
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801059f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801059f6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801059f9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a00:	00 00 00 00 
  return exec(path, argv);
80105a04:	50                   	push   %eax
80105a05:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105a0b:	e8 e0 af ff ff       	call   801009f0 <exec>
80105a10:	83 c4 10             	add    $0x10,%esp
}
80105a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a16:	5b                   	pop    %ebx
80105a17:	5e                   	pop    %esi
80105a18:	5f                   	pop    %edi
80105a19:	5d                   	pop    %ebp
80105a1a:	c3                   	ret    
80105a1b:	90                   	nop
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_pipe>:

int
sys_pipe(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
80105a25:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a26:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a29:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a2c:	6a 08                	push   $0x8
80105a2e:	50                   	push   %eax
80105a2f:	6a 00                	push   $0x0
80105a31:	e8 aa f3 ff ff       	call   80104de0 <argptr>
80105a36:	83 c4 10             	add    $0x10,%esp
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	0f 88 a4 00 00 00    	js     80105ae5 <sys_pipe+0xc5>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a41:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a44:	83 ec 08             	sub    $0x8,%esp
80105a47:	50                   	push   %eax
80105a48:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a4b:	50                   	push   %eax
80105a4c:	e8 8f d9 ff ff       	call   801033e0 <pipealloc>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	85 c0                	test   %eax,%eax
80105a56:	0f 88 89 00 00 00    	js     80105ae5 <sys_pipe+0xc5>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a5c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
    if(proc->ofile[fd] == 0){
80105a5f:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
  for(fd = 0; fd < NOFILE; fd++){
80105a66:	31 c0                	xor    %eax,%eax
80105a68:	eb 0e                	jmp    80105a78 <sys_pipe+0x58>
80105a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a70:	83 c0 01             	add    $0x1,%eax
80105a73:	83 f8 10             	cmp    $0x10,%eax
80105a76:	74 58                	je     80105ad0 <sys_pipe+0xb0>
    if(proc->ofile[fd] == 0){
80105a78:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105a7c:	85 d2                	test   %edx,%edx
80105a7e:	75 f0                	jne    80105a70 <sys_pipe+0x50>
80105a80:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a83:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a86:	31 d2                	xor    %edx,%edx
      proc->ofile[fd] = f;
80105a88:	89 5e 28             	mov    %ebx,0x28(%esi)
80105a8b:	eb 0b                	jmp    80105a98 <sys_pipe+0x78>
80105a8d:	8d 76 00             	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a90:	83 c2 01             	add    $0x1,%edx
80105a93:	83 fa 10             	cmp    $0x10,%edx
80105a96:	74 28                	je     80105ac0 <sys_pipe+0xa0>
    if(proc->ofile[fd] == 0){
80105a98:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80105a9d:	75 f1                	jne    80105a90 <sys_pipe+0x70>
      proc->ofile[fd] = f;
80105a9f:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105aa3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105aa6:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105aa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105aab:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105aae:	31 c0                	xor    %eax,%eax
}
80105ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab3:	5b                   	pop    %ebx
80105ab4:	5e                   	pop    %esi
80105ab5:	5f                   	pop    %edi
80105ab6:	5d                   	pop    %ebp
80105ab7:	c3                   	ret    
80105ab8:	90                   	nop
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      proc->ofile[fd0] = 0;
80105ac0:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    fileclose(rf);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	53                   	push   %ebx
80105ad4:	e8 37 b3 ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
80105ad9:	58                   	pop    %eax
80105ada:	ff 75 e4             	pushl  -0x1c(%ebp)
80105add:	e8 2e b3 ff ff       	call   80100e10 <fileclose>
    return -1;
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aea:	eb c4                	jmp    80105ab0 <sys_pipe+0x90>
80105aec:	66 90                	xchg   %ax,%ax
80105aee:	66 90                	xchg   %ax,%ax

80105af0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105af3:	5d                   	pop    %ebp
  return fork();
80105af4:	e9 67 df ff ff       	jmp    80103a60 <fork>
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_exit>:

int
sys_exit(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b06:	e8 45 e1 ff ff       	call   80103c50 <exit>
  return 0;  // not reached
}
80105b0b:	31 c0                	xor    %eax,%eax
80105b0d:	c9                   	leave  
80105b0e:	c3                   	ret    
80105b0f:	90                   	nop

80105b10 <sys_wait>:

int
sys_wait(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b13:	5d                   	pop    %ebp
  return wait();
80105b14:	e9 77 e4 ff ff       	jmp    80103f90 <wait>
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b20 <sys_kill>:

int
sys_kill(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b29:	50                   	push   %eax
80105b2a:	6a 00                	push   $0x0
80105b2c:	e8 6f f2 ff ff       	call   80104da0 <argint>
80105b31:	83 c4 10             	add    $0x10,%esp
80105b34:	85 c0                	test   %eax,%eax
80105b36:	78 18                	js     80105b50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b3e:	e8 9d e5 ff ff       	call   801040e0 <kill>
80105b43:	83 c4 10             	add    $0x10,%esp
}
80105b46:	c9                   	leave  
80105b47:	c3                   	ret    
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b55:	c9                   	leave  
80105b56:	c3                   	ret    
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105b60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80105b66:	55                   	push   %ebp
80105b67:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105b69:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b6c:	5d                   	pop    %ebp
80105b6d:	c3                   	ret    
80105b6e:	66 90                	xchg   %ax,%ax

80105b70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b7a:	50                   	push   %eax
80105b7b:	6a 00                	push   $0x0
80105b7d:	e8 1e f2 ff ff       	call   80104da0 <argint>
80105b82:	83 c4 10             	add    $0x10,%esp
80105b85:	85 c0                	test   %eax,%eax
80105b87:	78 27                	js     80105bb0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105b89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105b8f:	83 ec 0c             	sub    $0xc,%esp
  addr = proc->sz;
80105b92:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b94:	ff 75 f4             	pushl  -0xc(%ebp)
80105b97:	e8 44 de ff ff       	call   801039e0 <growproc>
80105b9c:	83 c4 10             	add    $0x10,%esp
80105b9f:	85 c0                	test   %eax,%eax
80105ba1:	78 0d                	js     80105bb0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ba3:	89 d8                	mov    %ebx,%eax
80105ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ba8:	c9                   	leave  
80105ba9:	c3                   	ret    
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105bb0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bb5:	eb ec                	jmp    80105ba3 <sys_sbrk+0x33>
80105bb7:	89 f6                	mov    %esi,%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bc0 <sys_sleep>:

int
sys_sleep(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bca:	50                   	push   %eax
80105bcb:	6a 00                	push   $0x0
80105bcd:	e8 ce f1 ff ff       	call   80104da0 <argint>
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	0f 88 8a 00 00 00    	js     80105c67 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105bdd:	83 ec 0c             	sub    $0xc,%esp
80105be0:	68 20 3d 11 80       	push   $0x80113d20
80105be5:	e8 a6 ec ff ff       	call   80104890 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bed:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105bf0:	8b 1d 60 45 11 80    	mov    0x80114560,%ebx
  while(ticks - ticks0 < n){
80105bf6:	85 d2                	test   %edx,%edx
80105bf8:	75 27                	jne    80105c21 <sys_sleep+0x61>
80105bfa:	eb 54                	jmp    80105c50 <sys_sleep+0x90>
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c00:	83 ec 08             	sub    $0x8,%esp
80105c03:	68 20 3d 11 80       	push   $0x80113d20
80105c08:	68 60 45 11 80       	push   $0x80114560
80105c0d:	e8 7e e2 ff ff       	call   80103e90 <sleep>
  while(ticks - ticks0 < n){
80105c12:	a1 60 45 11 80       	mov    0x80114560,%eax
80105c17:	83 c4 10             	add    $0x10,%esp
80105c1a:	29 d8                	sub    %ebx,%eax
80105c1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c1f:	73 2f                	jae    80105c50 <sys_sleep+0x90>
    if(proc->killed){
80105c21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c27:	8b 40 24             	mov    0x24(%eax),%eax
80105c2a:	85 c0                	test   %eax,%eax
80105c2c:	74 d2                	je     80105c00 <sys_sleep+0x40>
      release(&tickslock);
80105c2e:	83 ec 0c             	sub    $0xc,%esp
80105c31:	68 20 3d 11 80       	push   $0x80113d20
80105c36:	e8 35 ee ff ff       	call   80104a70 <release>
      return -1;
80105c3b:	83 c4 10             	add    $0x10,%esp
80105c3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c46:	c9                   	leave  
80105c47:	c3                   	ret    
80105c48:	90                   	nop
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	68 20 3d 11 80       	push   $0x80113d20
80105c58:	e8 13 ee ff ff       	call   80104a70 <release>
  return 0;
80105c5d:	83 c4 10             	add    $0x10,%esp
80105c60:	31 c0                	xor    %eax,%eax
}
80105c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c65:	c9                   	leave  
80105c66:	c3                   	ret    
    return -1;
80105c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c6c:	eb f4                	jmp    80105c62 <sys_sleep+0xa2>
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	53                   	push   %ebx
80105c74:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c77:	68 20 3d 11 80       	push   $0x80113d20
80105c7c:	e8 0f ec ff ff       	call   80104890 <acquire>
  xticks = ticks;
80105c81:	8b 1d 60 45 11 80    	mov    0x80114560,%ebx
  release(&tickslock);
80105c87:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80105c8e:	e8 dd ed ff ff       	call   80104a70 <release>
  return xticks;
}
80105c93:	89 d8                	mov    %ebx,%eax
80105c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c98:	c9                   	leave  
80105c99:	c3                   	ret    
80105c9a:	66 90                	xchg   %ax,%ax
80105c9c:	66 90                	xchg   %ax,%ax
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105ca0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ca1:	b8 34 00 00 00       	mov    $0x34,%eax
80105ca6:	ba 43 00 00 00       	mov    $0x43,%edx
80105cab:	89 e5                	mov    %esp,%ebp
80105cad:	83 ec 14             	sub    $0x14,%esp
80105cb0:	ee                   	out    %al,(%dx)
80105cb1:	ba 40 00 00 00       	mov    $0x40,%edx
80105cb6:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105cbb:	ee                   	out    %al,(%dx)
80105cbc:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105cc1:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105cc2:	6a 00                	push   $0x0
80105cc4:	e8 47 d6 ff ff       	call   80103310 <picenable>
}
80105cc9:	83 c4 10             	add    $0x10,%esp
80105ccc:	c9                   	leave  
80105ccd:	c3                   	ret    

80105cce <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cce:	1e                   	push   %ds
  pushl %es
80105ccf:	06                   	push   %es
  pushl %fs
80105cd0:	0f a0                	push   %fs
  pushl %gs
80105cd2:	0f a8                	push   %gs
  pushal
80105cd4:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105cd5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cd9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105cdb:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80105cdd:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105ce1:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105ce3:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ce5:	54                   	push   %esp
  call trap
80105ce6:	e8 c5 00 00 00       	call   80105db0 <trap>
  addl $4, %esp
80105ceb:	83 c4 04             	add    $0x4,%esp

80105cee <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105cee:	61                   	popa   
  popl %gs
80105cef:	0f a9                	pop    %gs
  popl %fs
80105cf1:	0f a1                	pop    %fs
  popl %es
80105cf3:	07                   	pop    %es
  popl %ds
80105cf4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105cf5:	83 c4 08             	add    $0x8,%esp
  iret
80105cf8:	cf                   	iret   
80105cf9:	66 90                	xchg   %ax,%ax
80105cfb:	66 90                	xchg   %ax,%ax
80105cfd:	66 90                	xchg   %ax,%ax
80105cff:	90                   	nop

80105d00 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d00:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d01:	31 c0                	xor    %eax,%eax
{
80105d03:	89 e5                	mov    %esp,%ebp
80105d05:	83 ec 08             	sub    $0x8,%esp
80105d08:	90                   	nop
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d10:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
80105d17:	c7 04 c5 62 3d 11 80 	movl   $0x8e000008,-0x7feec29e(,%eax,8)
80105d1e:	08 00 00 8e 
80105d22:	66 89 14 c5 60 3d 11 	mov    %dx,-0x7feec2a0(,%eax,8)
80105d29:	80 
80105d2a:	c1 ea 10             	shr    $0x10,%edx
80105d2d:	66 89 14 c5 66 3d 11 	mov    %dx,-0x7feec29a(,%eax,8)
80105d34:	80 
  for(i = 0; i < 256; i++)
80105d35:	83 c0 01             	add    $0x1,%eax
80105d38:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d3d:	75 d1                	jne    80105d10 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d3f:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105d44:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d47:	c7 05 62 3f 11 80 08 	movl   $0xef000008,0x80113f62
80105d4e:	00 00 ef 
  initlock(&tickslock, "time");
80105d51:	68 c9 7c 10 80       	push   $0x80107cc9
80105d56:	68 20 3d 11 80       	push   $0x80113d20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d5b:	66 a3 60 3f 11 80    	mov    %ax,0x80113f60
80105d61:	c1 e8 10             	shr    $0x10,%eax
80105d64:	66 a3 66 3f 11 80    	mov    %ax,0x80113f66
  initlock(&tickslock, "time");
80105d6a:	e8 01 eb ff ff       	call   80104870 <initlock>
}
80105d6f:	83 c4 10             	add    $0x10,%esp
80105d72:	c9                   	leave  
80105d73:	c3                   	ret    
80105d74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105d80 <idtinit>:

void
idtinit(void)
{
80105d80:	55                   	push   %ebp
  pd[0] = size-1;
80105d81:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d86:	89 e5                	mov    %esp,%ebp
80105d88:	83 ec 10             	sub    $0x10,%esp
80105d8b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d8f:	b8 60 3d 11 80       	mov    $0x80113d60,%eax
80105d94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d98:	c1 e8 10             	shr    $0x10,%eax
80105d9b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d9f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105da2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	57                   	push   %edi
80105db4:	56                   	push   %esi
80105db5:	53                   	push   %ebx
80105db6:	83 ec 0c             	sub    $0xc,%esp
80105db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105dbc:	8b 43 30             	mov    0x30(%ebx),%eax
80105dbf:	83 f8 40             	cmp    $0x40,%eax
80105dc2:	74 6c                	je     80105e30 <trap+0x80>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105dc4:	83 e8 20             	sub    $0x20,%eax
80105dc7:	83 f8 1f             	cmp    $0x1f,%eax
80105dca:	0f 87 98 00 00 00    	ja     80105e68 <trap+0xb8>
80105dd0:	ff 24 85 70 7d 10 80 	jmp    *-0x7fef8290(,%eax,4)
80105dd7:	89 f6                	mov    %esi,%esi
80105dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105de0:	e8 5b c9 ff ff       	call   80102740 <cpunum>
80105de5:	85 c0                	test   %eax,%eax
80105de7:	0f 84 a3 01 00 00    	je     80105f90 <trap+0x1e0>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
80105ded:	e8 fe c9 ff ff       	call   801027f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105df2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105df8:	85 c0                	test   %eax,%eax
80105dfa:	74 29                	je     80105e25 <trap+0x75>
80105dfc:	8b 50 24             	mov    0x24(%eax),%edx
80105dff:	85 d2                	test   %edx,%edx
80105e01:	0f 85 b6 00 00 00    	jne    80105ebd <trap+0x10d>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105e07:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e0b:	0f 84 3f 01 00 00    	je     80105f50 <trap+0x1a0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105e11:	8b 40 24             	mov    0x24(%eax),%eax
80105e14:	85 c0                	test   %eax,%eax
80105e16:	74 0d                	je     80105e25 <trap+0x75>
80105e18:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e1c:	83 e0 03             	and    $0x3,%eax
80105e1f:	66 83 f8 03          	cmp    $0x3,%ax
80105e23:	74 31                	je     80105e56 <trap+0xa6>
    exit();
}
80105e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e28:	5b                   	pop    %ebx
80105e29:	5e                   	pop    %esi
80105e2a:	5f                   	pop    %edi
80105e2b:	5d                   	pop    %ebp
80105e2c:	c3                   	ret    
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(proc->killed)
80105e30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e36:	8b 70 24             	mov    0x24(%eax),%esi
80105e39:	85 f6                	test   %esi,%esi
80105e3b:	0f 85 37 01 00 00    	jne    80105f78 <trap+0x1c8>
    proc->tf = tf;
80105e41:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e44:	e8 67 f0 ff ff       	call   80104eb0 <syscall>
    if(proc->killed)
80105e49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e4f:	8b 58 24             	mov    0x24(%eax),%ebx
80105e52:	85 db                	test   %ebx,%ebx
80105e54:	74 cf                	je     80105e25 <trap+0x75>
}
80105e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e59:	5b                   	pop    %ebx
80105e5a:	5e                   	pop    %esi
80105e5b:	5f                   	pop    %edi
80105e5c:	5d                   	pop    %ebp
      exit();
80105e5d:	e9 ee dd ff ff       	jmp    80103c50 <exit>
80105e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(proc == 0 || (tf->cs&3) == 0){
80105e68:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105e6f:	8b 73 38             	mov    0x38(%ebx),%esi
80105e72:	85 c9                	test   %ecx,%ecx
80105e74:	0f 84 4a 01 00 00    	je     80105fc4 <trap+0x214>
80105e7a:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e7e:	0f 84 40 01 00 00    	je     80105fc4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e84:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e87:	e8 b4 c8 ff ff       	call   80102740 <cpunum>
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105e8c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
80105e95:	50                   	push   %eax
80105e96:	ff 73 34             	pushl  0x34(%ebx)
80105e99:	ff 73 30             	pushl  0x30(%ebx)
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105e9c:	8d 42 6c             	lea    0x6c(%edx),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e9f:	50                   	push   %eax
80105ea0:	ff 72 10             	pushl  0x10(%edx)
80105ea3:	68 2c 7d 10 80       	push   $0x80107d2c
80105ea8:	e8 93 a7 ff ff       	call   80100640 <cprintf>
    proc->killed = 1;
80105ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105eb3:	83 c4 20             	add    $0x20,%esp
80105eb6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105ebd:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105ec1:	83 e2 03             	and    $0x3,%edx
80105ec4:	66 83 fa 03          	cmp    $0x3,%dx
80105ec8:	0f 85 39 ff ff ff    	jne    80105e07 <trap+0x57>
    exit();
80105ece:	e8 7d dd ff ff       	call   80103c50 <exit>
80105ed3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	0f 85 26 ff ff ff    	jne    80105e07 <trap+0x57>
80105ee1:	e9 3f ff ff ff       	jmp    80105e25 <trap+0x75>
80105ee6:	8d 76 00             	lea    0x0(%esi),%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
80105ef0:	e8 0b c7 ff ff       	call   80102600 <kbdintr>
    lapiceoi();
80105ef5:	e8 f6 c8 ff ff       	call   801027f0 <lapiceoi>
    break;
80105efa:	e9 f3 fe ff ff       	jmp    80105df2 <trap+0x42>
80105eff:	90                   	nop
    uartintr();
80105f00:	e8 5b 02 00 00       	call   80106160 <uartintr>
80105f05:	e9 e3 fe ff ff       	jmp    80105ded <trap+0x3d>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f10:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f14:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f17:	e8 24 c8 ff ff       	call   80102740 <cpunum>
80105f1c:	57                   	push   %edi
80105f1d:	56                   	push   %esi
80105f1e:	50                   	push   %eax
80105f1f:	68 d4 7c 10 80       	push   $0x80107cd4
80105f24:	e8 17 a7 ff ff       	call   80100640 <cprintf>
    lapiceoi();
80105f29:	e8 c2 c8 ff ff       	call   801027f0 <lapiceoi>
    break;
80105f2e:	83 c4 10             	add    $0x10,%esp
80105f31:	e9 bc fe ff ff       	jmp    80105df2 <trap+0x42>
80105f36:	8d 76 00             	lea    0x0(%esi),%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105f40:	e8 1b c1 ff ff       	call   80102060 <ideintr>
    lapiceoi();
80105f45:	e8 a6 c8 ff ff       	call   801027f0 <lapiceoi>
    break;
80105f4a:	e9 a3 fe ff ff       	jmp    80105df2 <trap+0x42>
80105f4f:	90                   	nop
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105f50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f54:	0f 85 b7 fe ff ff    	jne    80105e11 <trap+0x61>
    yield();
80105f5a:	e8 41 de ff ff       	call   80103da0 <yield>
80105f5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105f65:	85 c0                	test   %eax,%eax
80105f67:	0f 85 a4 fe ff ff    	jne    80105e11 <trap+0x61>
80105f6d:	e9 b3 fe ff ff       	jmp    80105e25 <trap+0x75>
80105f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f78:	e8 d3 dc ff ff       	call   80103c50 <exit>
80105f7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f83:	e9 b9 fe ff ff       	jmp    80105e41 <trap+0x91>
80105f88:	90                   	nop
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      acquire(&tickslock);
80105f90:	83 ec 0c             	sub    $0xc,%esp
80105f93:	68 20 3d 11 80       	push   $0x80113d20
80105f98:	e8 f3 e8 ff ff       	call   80104890 <acquire>
      wakeup(&ticks);
80105f9d:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
      ticks++;
80105fa4:	83 05 60 45 11 80 01 	addl   $0x1,0x80114560
      wakeup(&ticks);
80105fab:	e8 d0 e0 ff ff       	call   80104080 <wakeup>
      release(&tickslock);
80105fb0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80105fb7:	e8 b4 ea ff ff       	call   80104a70 <release>
80105fbc:	83 c4 10             	add    $0x10,%esp
80105fbf:	e9 29 fe ff ff       	jmp    80105ded <trap+0x3d>
80105fc4:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fc7:	e8 74 c7 ff ff       	call   80102740 <cpunum>
80105fcc:	83 ec 0c             	sub    $0xc,%esp
80105fcf:	57                   	push   %edi
80105fd0:	56                   	push   %esi
80105fd1:	50                   	push   %eax
80105fd2:	ff 73 30             	pushl  0x30(%ebx)
80105fd5:	68 f8 7c 10 80       	push   $0x80107cf8
80105fda:	e8 61 a6 ff ff       	call   80100640 <cprintf>
      panic("trap");
80105fdf:	83 c4 14             	add    $0x14,%esp
80105fe2:	68 ce 7c 10 80       	push   $0x80107cce
80105fe7:	e8 84 a3 ff ff       	call   80100370 <panic>
80105fec:	66 90                	xchg   %ax,%ax
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ff0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
{
80105ff5:	55                   	push   %ebp
80105ff6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ff8:	85 c0                	test   %eax,%eax
80105ffa:	74 1c                	je     80106018 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ffc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106001:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106002:	a8 01                	test   $0x1,%al
80106004:	74 12                	je     80106018 <uartgetc+0x28>
80106006:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010600b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010600c:	0f b6 c0             	movzbl %al,%eax
}
8010600f:	5d                   	pop    %ebp
80106010:	c3                   	ret    
80106011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010601d:	5d                   	pop    %ebp
8010601e:	c3                   	ret    
8010601f:	90                   	nop

80106020 <uartputc.part.0>:
uartputc(int c)
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	57                   	push   %edi
80106024:	56                   	push   %esi
80106025:	53                   	push   %ebx
80106026:	89 c7                	mov    %eax,%edi
80106028:	bb 80 00 00 00       	mov    $0x80,%ebx
8010602d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106032:	83 ec 0c             	sub    $0xc,%esp
80106035:	eb 1b                	jmp    80106052 <uartputc.part.0+0x32>
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	6a 0a                	push   $0xa
80106045:	e8 c6 c7 ff ff       	call   80102810 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010604a:	83 c4 10             	add    $0x10,%esp
8010604d:	83 eb 01             	sub    $0x1,%ebx
80106050:	74 07                	je     80106059 <uartputc.part.0+0x39>
80106052:	89 f2                	mov    %esi,%edx
80106054:	ec                   	in     (%dx),%al
80106055:	a8 20                	test   $0x20,%al
80106057:	74 e7                	je     80106040 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106059:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010605e:	89 f8                	mov    %edi,%eax
80106060:	ee                   	out    %al,(%dx)
}
80106061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106064:	5b                   	pop    %ebx
80106065:	5e                   	pop    %esi
80106066:	5f                   	pop    %edi
80106067:	5d                   	pop    %ebp
80106068:	c3                   	ret    
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106070 <uartinit>:
{
80106070:	55                   	push   %ebp
80106071:	31 c9                	xor    %ecx,%ecx
80106073:	89 c8                	mov    %ecx,%eax
80106075:	89 e5                	mov    %esp,%ebp
80106077:	57                   	push   %edi
80106078:	56                   	push   %esi
80106079:	53                   	push   %ebx
8010607a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010607f:	89 da                	mov    %ebx,%edx
80106081:	83 ec 0c             	sub    $0xc,%esp
80106084:	ee                   	out    %al,(%dx)
80106085:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010608a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010608f:	89 fa                	mov    %edi,%edx
80106091:	ee                   	out    %al,(%dx)
80106092:	b8 0c 00 00 00       	mov    $0xc,%eax
80106097:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010609c:	ee                   	out    %al,(%dx)
8010609d:	be f9 03 00 00       	mov    $0x3f9,%esi
801060a2:	89 c8                	mov    %ecx,%eax
801060a4:	89 f2                	mov    %esi,%edx
801060a6:	ee                   	out    %al,(%dx)
801060a7:	b8 03 00 00 00       	mov    $0x3,%eax
801060ac:	89 fa                	mov    %edi,%edx
801060ae:	ee                   	out    %al,(%dx)
801060af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060b4:	89 c8                	mov    %ecx,%eax
801060b6:	ee                   	out    %al,(%dx)
801060b7:	b8 01 00 00 00       	mov    $0x1,%eax
801060bc:	89 f2                	mov    %esi,%edx
801060be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060c5:	3c ff                	cmp    $0xff,%al
801060c7:	74 5a                	je     80106123 <uartinit+0xb3>
  uart = 1;
801060c9:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
801060d0:	00 00 00 
801060d3:	89 da                	mov    %ebx,%edx
801060d5:	ec                   	in     (%dx),%al
801060d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060db:	ec                   	in     (%dx),%al
  picenable(IRQ_COM1);
801060dc:	83 ec 0c             	sub    $0xc,%esp
801060df:	6a 04                	push   $0x4
801060e1:	e8 2a d2 ff ff       	call   80103310 <picenable>
  ioapicenable(IRQ_COM1, 0);
801060e6:	59                   	pop    %ecx
801060e7:	5b                   	pop    %ebx
801060e8:	6a 00                	push   $0x0
801060ea:	6a 04                	push   $0x4
  for(p="xv6...\n"; *p; p++)
801060ec:	bb f0 7d 10 80       	mov    $0x80107df0,%ebx
  ioapicenable(IRQ_COM1, 0);
801060f1:	e8 ca c1 ff ff       	call   801022c0 <ioapicenable>
801060f6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801060f9:	b8 78 00 00 00       	mov    $0x78,%eax
801060fe:	eb 0a                	jmp    8010610a <uartinit+0x9a>
80106100:	83 c3 01             	add    $0x1,%ebx
80106103:	0f be 03             	movsbl (%ebx),%eax
80106106:	84 c0                	test   %al,%al
80106108:	74 19                	je     80106123 <uartinit+0xb3>
  if(!uart)
8010610a:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80106110:	85 d2                	test   %edx,%edx
80106112:	74 ec                	je     80106100 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106114:	83 c3 01             	add    $0x1,%ebx
80106117:	e8 04 ff ff ff       	call   80106020 <uartputc.part.0>
8010611c:	0f be 03             	movsbl (%ebx),%eax
8010611f:	84 c0                	test   %al,%al
80106121:	75 e7                	jne    8010610a <uartinit+0x9a>
}
80106123:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106126:	5b                   	pop    %ebx
80106127:	5e                   	pop    %esi
80106128:	5f                   	pop    %edi
80106129:	5d                   	pop    %ebp
8010612a:	c3                   	ret    
8010612b:	90                   	nop
8010612c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106130 <uartputc>:
  if(!uart)
80106130:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80106136:	55                   	push   %ebp
80106137:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106139:	85 d2                	test   %edx,%edx
{
8010613b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010613e:	74 10                	je     80106150 <uartputc+0x20>
}
80106140:	5d                   	pop    %ebp
80106141:	e9 da fe ff ff       	jmp    80106020 <uartputc.part.0>
80106146:	8d 76 00             	lea    0x0(%esi),%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106150:	5d                   	pop    %ebp
80106151:	c3                   	ret    
80106152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106160 <uartintr>:

void
uartintr(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106166:	68 f0 5f 10 80       	push   $0x80105ff0
8010616b:	e8 80 a6 ff ff       	call   801007f0 <consoleintr>
}
80106170:	83 c4 10             	add    $0x10,%esp
80106173:	c9                   	leave  
80106174:	c3                   	ret    

80106175 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $0
80106177:	6a 00                	push   $0x0
  jmp alltraps
80106179:	e9 50 fb ff ff       	jmp    80105cce <alltraps>

8010617e <vector1>:
.globl vector1
vector1:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $1
80106180:	6a 01                	push   $0x1
  jmp alltraps
80106182:	e9 47 fb ff ff       	jmp    80105cce <alltraps>

80106187 <vector2>:
.globl vector2
vector2:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $2
80106189:	6a 02                	push   $0x2
  jmp alltraps
8010618b:	e9 3e fb ff ff       	jmp    80105cce <alltraps>

80106190 <vector3>:
.globl vector3
vector3:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $3
80106192:	6a 03                	push   $0x3
  jmp alltraps
80106194:	e9 35 fb ff ff       	jmp    80105cce <alltraps>

80106199 <vector4>:
.globl vector4
vector4:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $4
8010619b:	6a 04                	push   $0x4
  jmp alltraps
8010619d:	e9 2c fb ff ff       	jmp    80105cce <alltraps>

801061a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $5
801061a4:	6a 05                	push   $0x5
  jmp alltraps
801061a6:	e9 23 fb ff ff       	jmp    80105cce <alltraps>

801061ab <vector6>:
.globl vector6
vector6:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $6
801061ad:	6a 06                	push   $0x6
  jmp alltraps
801061af:	e9 1a fb ff ff       	jmp    80105cce <alltraps>

801061b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $7
801061b6:	6a 07                	push   $0x7
  jmp alltraps
801061b8:	e9 11 fb ff ff       	jmp    80105cce <alltraps>

801061bd <vector8>:
.globl vector8
vector8:
  pushl $8
801061bd:	6a 08                	push   $0x8
  jmp alltraps
801061bf:	e9 0a fb ff ff       	jmp    80105cce <alltraps>

801061c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $9
801061c6:	6a 09                	push   $0x9
  jmp alltraps
801061c8:	e9 01 fb ff ff       	jmp    80105cce <alltraps>

801061cd <vector10>:
.globl vector10
vector10:
  pushl $10
801061cd:	6a 0a                	push   $0xa
  jmp alltraps
801061cf:	e9 fa fa ff ff       	jmp    80105cce <alltraps>

801061d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061d4:	6a 0b                	push   $0xb
  jmp alltraps
801061d6:	e9 f3 fa ff ff       	jmp    80105cce <alltraps>

801061db <vector12>:
.globl vector12
vector12:
  pushl $12
801061db:	6a 0c                	push   $0xc
  jmp alltraps
801061dd:	e9 ec fa ff ff       	jmp    80105cce <alltraps>

801061e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061e2:	6a 0d                	push   $0xd
  jmp alltraps
801061e4:	e9 e5 fa ff ff       	jmp    80105cce <alltraps>

801061e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061e9:	6a 0e                	push   $0xe
  jmp alltraps
801061eb:	e9 de fa ff ff       	jmp    80105cce <alltraps>

801061f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $15
801061f2:	6a 0f                	push   $0xf
  jmp alltraps
801061f4:	e9 d5 fa ff ff       	jmp    80105cce <alltraps>

801061f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $16
801061fb:	6a 10                	push   $0x10
  jmp alltraps
801061fd:	e9 cc fa ff ff       	jmp    80105cce <alltraps>

80106202 <vector17>:
.globl vector17
vector17:
  pushl $17
80106202:	6a 11                	push   $0x11
  jmp alltraps
80106204:	e9 c5 fa ff ff       	jmp    80105cce <alltraps>

80106209 <vector18>:
.globl vector18
vector18:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $18
8010620b:	6a 12                	push   $0x12
  jmp alltraps
8010620d:	e9 bc fa ff ff       	jmp    80105cce <alltraps>

80106212 <vector19>:
.globl vector19
vector19:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $19
80106214:	6a 13                	push   $0x13
  jmp alltraps
80106216:	e9 b3 fa ff ff       	jmp    80105cce <alltraps>

8010621b <vector20>:
.globl vector20
vector20:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $20
8010621d:	6a 14                	push   $0x14
  jmp alltraps
8010621f:	e9 aa fa ff ff       	jmp    80105cce <alltraps>

80106224 <vector21>:
.globl vector21
vector21:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $21
80106226:	6a 15                	push   $0x15
  jmp alltraps
80106228:	e9 a1 fa ff ff       	jmp    80105cce <alltraps>

8010622d <vector22>:
.globl vector22
vector22:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $22
8010622f:	6a 16                	push   $0x16
  jmp alltraps
80106231:	e9 98 fa ff ff       	jmp    80105cce <alltraps>

80106236 <vector23>:
.globl vector23
vector23:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $23
80106238:	6a 17                	push   $0x17
  jmp alltraps
8010623a:	e9 8f fa ff ff       	jmp    80105cce <alltraps>

8010623f <vector24>:
.globl vector24
vector24:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $24
80106241:	6a 18                	push   $0x18
  jmp alltraps
80106243:	e9 86 fa ff ff       	jmp    80105cce <alltraps>

80106248 <vector25>:
.globl vector25
vector25:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $25
8010624a:	6a 19                	push   $0x19
  jmp alltraps
8010624c:	e9 7d fa ff ff       	jmp    80105cce <alltraps>

80106251 <vector26>:
.globl vector26
vector26:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $26
80106253:	6a 1a                	push   $0x1a
  jmp alltraps
80106255:	e9 74 fa ff ff       	jmp    80105cce <alltraps>

8010625a <vector27>:
.globl vector27
vector27:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $27
8010625c:	6a 1b                	push   $0x1b
  jmp alltraps
8010625e:	e9 6b fa ff ff       	jmp    80105cce <alltraps>

80106263 <vector28>:
.globl vector28
vector28:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $28
80106265:	6a 1c                	push   $0x1c
  jmp alltraps
80106267:	e9 62 fa ff ff       	jmp    80105cce <alltraps>

8010626c <vector29>:
.globl vector29
vector29:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $29
8010626e:	6a 1d                	push   $0x1d
  jmp alltraps
80106270:	e9 59 fa ff ff       	jmp    80105cce <alltraps>

80106275 <vector30>:
.globl vector30
vector30:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $30
80106277:	6a 1e                	push   $0x1e
  jmp alltraps
80106279:	e9 50 fa ff ff       	jmp    80105cce <alltraps>

8010627e <vector31>:
.globl vector31
vector31:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $31
80106280:	6a 1f                	push   $0x1f
  jmp alltraps
80106282:	e9 47 fa ff ff       	jmp    80105cce <alltraps>

80106287 <vector32>:
.globl vector32
vector32:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $32
80106289:	6a 20                	push   $0x20
  jmp alltraps
8010628b:	e9 3e fa ff ff       	jmp    80105cce <alltraps>

80106290 <vector33>:
.globl vector33
vector33:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $33
80106292:	6a 21                	push   $0x21
  jmp alltraps
80106294:	e9 35 fa ff ff       	jmp    80105cce <alltraps>

80106299 <vector34>:
.globl vector34
vector34:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $34
8010629b:	6a 22                	push   $0x22
  jmp alltraps
8010629d:	e9 2c fa ff ff       	jmp    80105cce <alltraps>

801062a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $35
801062a4:	6a 23                	push   $0x23
  jmp alltraps
801062a6:	e9 23 fa ff ff       	jmp    80105cce <alltraps>

801062ab <vector36>:
.globl vector36
vector36:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $36
801062ad:	6a 24                	push   $0x24
  jmp alltraps
801062af:	e9 1a fa ff ff       	jmp    80105cce <alltraps>

801062b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $37
801062b6:	6a 25                	push   $0x25
  jmp alltraps
801062b8:	e9 11 fa ff ff       	jmp    80105cce <alltraps>

801062bd <vector38>:
.globl vector38
vector38:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $38
801062bf:	6a 26                	push   $0x26
  jmp alltraps
801062c1:	e9 08 fa ff ff       	jmp    80105cce <alltraps>

801062c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $39
801062c8:	6a 27                	push   $0x27
  jmp alltraps
801062ca:	e9 ff f9 ff ff       	jmp    80105cce <alltraps>

801062cf <vector40>:
.globl vector40
vector40:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $40
801062d1:	6a 28                	push   $0x28
  jmp alltraps
801062d3:	e9 f6 f9 ff ff       	jmp    80105cce <alltraps>

801062d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $41
801062da:	6a 29                	push   $0x29
  jmp alltraps
801062dc:	e9 ed f9 ff ff       	jmp    80105cce <alltraps>

801062e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $42
801062e3:	6a 2a                	push   $0x2a
  jmp alltraps
801062e5:	e9 e4 f9 ff ff       	jmp    80105cce <alltraps>

801062ea <vector43>:
.globl vector43
vector43:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $43
801062ec:	6a 2b                	push   $0x2b
  jmp alltraps
801062ee:	e9 db f9 ff ff       	jmp    80105cce <alltraps>

801062f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $44
801062f5:	6a 2c                	push   $0x2c
  jmp alltraps
801062f7:	e9 d2 f9 ff ff       	jmp    80105cce <alltraps>

801062fc <vector45>:
.globl vector45
vector45:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $45
801062fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106300:	e9 c9 f9 ff ff       	jmp    80105cce <alltraps>

80106305 <vector46>:
.globl vector46
vector46:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $46
80106307:	6a 2e                	push   $0x2e
  jmp alltraps
80106309:	e9 c0 f9 ff ff       	jmp    80105cce <alltraps>

8010630e <vector47>:
.globl vector47
vector47:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $47
80106310:	6a 2f                	push   $0x2f
  jmp alltraps
80106312:	e9 b7 f9 ff ff       	jmp    80105cce <alltraps>

80106317 <vector48>:
.globl vector48
vector48:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $48
80106319:	6a 30                	push   $0x30
  jmp alltraps
8010631b:	e9 ae f9 ff ff       	jmp    80105cce <alltraps>

80106320 <vector49>:
.globl vector49
vector49:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $49
80106322:	6a 31                	push   $0x31
  jmp alltraps
80106324:	e9 a5 f9 ff ff       	jmp    80105cce <alltraps>

80106329 <vector50>:
.globl vector50
vector50:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $50
8010632b:	6a 32                	push   $0x32
  jmp alltraps
8010632d:	e9 9c f9 ff ff       	jmp    80105cce <alltraps>

80106332 <vector51>:
.globl vector51
vector51:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $51
80106334:	6a 33                	push   $0x33
  jmp alltraps
80106336:	e9 93 f9 ff ff       	jmp    80105cce <alltraps>

8010633b <vector52>:
.globl vector52
vector52:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $52
8010633d:	6a 34                	push   $0x34
  jmp alltraps
8010633f:	e9 8a f9 ff ff       	jmp    80105cce <alltraps>

80106344 <vector53>:
.globl vector53
vector53:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $53
80106346:	6a 35                	push   $0x35
  jmp alltraps
80106348:	e9 81 f9 ff ff       	jmp    80105cce <alltraps>

8010634d <vector54>:
.globl vector54
vector54:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $54
8010634f:	6a 36                	push   $0x36
  jmp alltraps
80106351:	e9 78 f9 ff ff       	jmp    80105cce <alltraps>

80106356 <vector55>:
.globl vector55
vector55:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $55
80106358:	6a 37                	push   $0x37
  jmp alltraps
8010635a:	e9 6f f9 ff ff       	jmp    80105cce <alltraps>

8010635f <vector56>:
.globl vector56
vector56:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $56
80106361:	6a 38                	push   $0x38
  jmp alltraps
80106363:	e9 66 f9 ff ff       	jmp    80105cce <alltraps>

80106368 <vector57>:
.globl vector57
vector57:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $57
8010636a:	6a 39                	push   $0x39
  jmp alltraps
8010636c:	e9 5d f9 ff ff       	jmp    80105cce <alltraps>

80106371 <vector58>:
.globl vector58
vector58:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $58
80106373:	6a 3a                	push   $0x3a
  jmp alltraps
80106375:	e9 54 f9 ff ff       	jmp    80105cce <alltraps>

8010637a <vector59>:
.globl vector59
vector59:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $59
8010637c:	6a 3b                	push   $0x3b
  jmp alltraps
8010637e:	e9 4b f9 ff ff       	jmp    80105cce <alltraps>

80106383 <vector60>:
.globl vector60
vector60:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $60
80106385:	6a 3c                	push   $0x3c
  jmp alltraps
80106387:	e9 42 f9 ff ff       	jmp    80105cce <alltraps>

8010638c <vector61>:
.globl vector61
vector61:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $61
8010638e:	6a 3d                	push   $0x3d
  jmp alltraps
80106390:	e9 39 f9 ff ff       	jmp    80105cce <alltraps>

80106395 <vector62>:
.globl vector62
vector62:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $62
80106397:	6a 3e                	push   $0x3e
  jmp alltraps
80106399:	e9 30 f9 ff ff       	jmp    80105cce <alltraps>

8010639e <vector63>:
.globl vector63
vector63:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $63
801063a0:	6a 3f                	push   $0x3f
  jmp alltraps
801063a2:	e9 27 f9 ff ff       	jmp    80105cce <alltraps>

801063a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $64
801063a9:	6a 40                	push   $0x40
  jmp alltraps
801063ab:	e9 1e f9 ff ff       	jmp    80105cce <alltraps>

801063b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $65
801063b2:	6a 41                	push   $0x41
  jmp alltraps
801063b4:	e9 15 f9 ff ff       	jmp    80105cce <alltraps>

801063b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $66
801063bb:	6a 42                	push   $0x42
  jmp alltraps
801063bd:	e9 0c f9 ff ff       	jmp    80105cce <alltraps>

801063c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $67
801063c4:	6a 43                	push   $0x43
  jmp alltraps
801063c6:	e9 03 f9 ff ff       	jmp    80105cce <alltraps>

801063cb <vector68>:
.globl vector68
vector68:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $68
801063cd:	6a 44                	push   $0x44
  jmp alltraps
801063cf:	e9 fa f8 ff ff       	jmp    80105cce <alltraps>

801063d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $69
801063d6:	6a 45                	push   $0x45
  jmp alltraps
801063d8:	e9 f1 f8 ff ff       	jmp    80105cce <alltraps>

801063dd <vector70>:
.globl vector70
vector70:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $70
801063df:	6a 46                	push   $0x46
  jmp alltraps
801063e1:	e9 e8 f8 ff ff       	jmp    80105cce <alltraps>

801063e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $71
801063e8:	6a 47                	push   $0x47
  jmp alltraps
801063ea:	e9 df f8 ff ff       	jmp    80105cce <alltraps>

801063ef <vector72>:
.globl vector72
vector72:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $72
801063f1:	6a 48                	push   $0x48
  jmp alltraps
801063f3:	e9 d6 f8 ff ff       	jmp    80105cce <alltraps>

801063f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $73
801063fa:	6a 49                	push   $0x49
  jmp alltraps
801063fc:	e9 cd f8 ff ff       	jmp    80105cce <alltraps>

80106401 <vector74>:
.globl vector74
vector74:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $74
80106403:	6a 4a                	push   $0x4a
  jmp alltraps
80106405:	e9 c4 f8 ff ff       	jmp    80105cce <alltraps>

8010640a <vector75>:
.globl vector75
vector75:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $75
8010640c:	6a 4b                	push   $0x4b
  jmp alltraps
8010640e:	e9 bb f8 ff ff       	jmp    80105cce <alltraps>

80106413 <vector76>:
.globl vector76
vector76:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $76
80106415:	6a 4c                	push   $0x4c
  jmp alltraps
80106417:	e9 b2 f8 ff ff       	jmp    80105cce <alltraps>

8010641c <vector77>:
.globl vector77
vector77:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $77
8010641e:	6a 4d                	push   $0x4d
  jmp alltraps
80106420:	e9 a9 f8 ff ff       	jmp    80105cce <alltraps>

80106425 <vector78>:
.globl vector78
vector78:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $78
80106427:	6a 4e                	push   $0x4e
  jmp alltraps
80106429:	e9 a0 f8 ff ff       	jmp    80105cce <alltraps>

8010642e <vector79>:
.globl vector79
vector79:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $79
80106430:	6a 4f                	push   $0x4f
  jmp alltraps
80106432:	e9 97 f8 ff ff       	jmp    80105cce <alltraps>

80106437 <vector80>:
.globl vector80
vector80:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $80
80106439:	6a 50                	push   $0x50
  jmp alltraps
8010643b:	e9 8e f8 ff ff       	jmp    80105cce <alltraps>

80106440 <vector81>:
.globl vector81
vector81:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $81
80106442:	6a 51                	push   $0x51
  jmp alltraps
80106444:	e9 85 f8 ff ff       	jmp    80105cce <alltraps>

80106449 <vector82>:
.globl vector82
vector82:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $82
8010644b:	6a 52                	push   $0x52
  jmp alltraps
8010644d:	e9 7c f8 ff ff       	jmp    80105cce <alltraps>

80106452 <vector83>:
.globl vector83
vector83:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $83
80106454:	6a 53                	push   $0x53
  jmp alltraps
80106456:	e9 73 f8 ff ff       	jmp    80105cce <alltraps>

8010645b <vector84>:
.globl vector84
vector84:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $84
8010645d:	6a 54                	push   $0x54
  jmp alltraps
8010645f:	e9 6a f8 ff ff       	jmp    80105cce <alltraps>

80106464 <vector85>:
.globl vector85
vector85:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $85
80106466:	6a 55                	push   $0x55
  jmp alltraps
80106468:	e9 61 f8 ff ff       	jmp    80105cce <alltraps>

8010646d <vector86>:
.globl vector86
vector86:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $86
8010646f:	6a 56                	push   $0x56
  jmp alltraps
80106471:	e9 58 f8 ff ff       	jmp    80105cce <alltraps>

80106476 <vector87>:
.globl vector87
vector87:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $87
80106478:	6a 57                	push   $0x57
  jmp alltraps
8010647a:	e9 4f f8 ff ff       	jmp    80105cce <alltraps>

8010647f <vector88>:
.globl vector88
vector88:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $88
80106481:	6a 58                	push   $0x58
  jmp alltraps
80106483:	e9 46 f8 ff ff       	jmp    80105cce <alltraps>

80106488 <vector89>:
.globl vector89
vector89:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $89
8010648a:	6a 59                	push   $0x59
  jmp alltraps
8010648c:	e9 3d f8 ff ff       	jmp    80105cce <alltraps>

80106491 <vector90>:
.globl vector90
vector90:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $90
80106493:	6a 5a                	push   $0x5a
  jmp alltraps
80106495:	e9 34 f8 ff ff       	jmp    80105cce <alltraps>

8010649a <vector91>:
.globl vector91
vector91:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $91
8010649c:	6a 5b                	push   $0x5b
  jmp alltraps
8010649e:	e9 2b f8 ff ff       	jmp    80105cce <alltraps>

801064a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $92
801064a5:	6a 5c                	push   $0x5c
  jmp alltraps
801064a7:	e9 22 f8 ff ff       	jmp    80105cce <alltraps>

801064ac <vector93>:
.globl vector93
vector93:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $93
801064ae:	6a 5d                	push   $0x5d
  jmp alltraps
801064b0:	e9 19 f8 ff ff       	jmp    80105cce <alltraps>

801064b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $94
801064b7:	6a 5e                	push   $0x5e
  jmp alltraps
801064b9:	e9 10 f8 ff ff       	jmp    80105cce <alltraps>

801064be <vector95>:
.globl vector95
vector95:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $95
801064c0:	6a 5f                	push   $0x5f
  jmp alltraps
801064c2:	e9 07 f8 ff ff       	jmp    80105cce <alltraps>

801064c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $96
801064c9:	6a 60                	push   $0x60
  jmp alltraps
801064cb:	e9 fe f7 ff ff       	jmp    80105cce <alltraps>

801064d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $97
801064d2:	6a 61                	push   $0x61
  jmp alltraps
801064d4:	e9 f5 f7 ff ff       	jmp    80105cce <alltraps>

801064d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $98
801064db:	6a 62                	push   $0x62
  jmp alltraps
801064dd:	e9 ec f7 ff ff       	jmp    80105cce <alltraps>

801064e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $99
801064e4:	6a 63                	push   $0x63
  jmp alltraps
801064e6:	e9 e3 f7 ff ff       	jmp    80105cce <alltraps>

801064eb <vector100>:
.globl vector100
vector100:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $100
801064ed:	6a 64                	push   $0x64
  jmp alltraps
801064ef:	e9 da f7 ff ff       	jmp    80105cce <alltraps>

801064f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $101
801064f6:	6a 65                	push   $0x65
  jmp alltraps
801064f8:	e9 d1 f7 ff ff       	jmp    80105cce <alltraps>

801064fd <vector102>:
.globl vector102
vector102:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $102
801064ff:	6a 66                	push   $0x66
  jmp alltraps
80106501:	e9 c8 f7 ff ff       	jmp    80105cce <alltraps>

80106506 <vector103>:
.globl vector103
vector103:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $103
80106508:	6a 67                	push   $0x67
  jmp alltraps
8010650a:	e9 bf f7 ff ff       	jmp    80105cce <alltraps>

8010650f <vector104>:
.globl vector104
vector104:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $104
80106511:	6a 68                	push   $0x68
  jmp alltraps
80106513:	e9 b6 f7 ff ff       	jmp    80105cce <alltraps>

80106518 <vector105>:
.globl vector105
vector105:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $105
8010651a:	6a 69                	push   $0x69
  jmp alltraps
8010651c:	e9 ad f7 ff ff       	jmp    80105cce <alltraps>

80106521 <vector106>:
.globl vector106
vector106:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $106
80106523:	6a 6a                	push   $0x6a
  jmp alltraps
80106525:	e9 a4 f7 ff ff       	jmp    80105cce <alltraps>

8010652a <vector107>:
.globl vector107
vector107:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $107
8010652c:	6a 6b                	push   $0x6b
  jmp alltraps
8010652e:	e9 9b f7 ff ff       	jmp    80105cce <alltraps>

80106533 <vector108>:
.globl vector108
vector108:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $108
80106535:	6a 6c                	push   $0x6c
  jmp alltraps
80106537:	e9 92 f7 ff ff       	jmp    80105cce <alltraps>

8010653c <vector109>:
.globl vector109
vector109:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $109
8010653e:	6a 6d                	push   $0x6d
  jmp alltraps
80106540:	e9 89 f7 ff ff       	jmp    80105cce <alltraps>

80106545 <vector110>:
.globl vector110
vector110:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $110
80106547:	6a 6e                	push   $0x6e
  jmp alltraps
80106549:	e9 80 f7 ff ff       	jmp    80105cce <alltraps>

8010654e <vector111>:
.globl vector111
vector111:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $111
80106550:	6a 6f                	push   $0x6f
  jmp alltraps
80106552:	e9 77 f7 ff ff       	jmp    80105cce <alltraps>

80106557 <vector112>:
.globl vector112
vector112:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $112
80106559:	6a 70                	push   $0x70
  jmp alltraps
8010655b:	e9 6e f7 ff ff       	jmp    80105cce <alltraps>

80106560 <vector113>:
.globl vector113
vector113:
  pushl $0
80106560:	6a 00                	push   $0x0
  pushl $113
80106562:	6a 71                	push   $0x71
  jmp alltraps
80106564:	e9 65 f7 ff ff       	jmp    80105cce <alltraps>

80106569 <vector114>:
.globl vector114
vector114:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $114
8010656b:	6a 72                	push   $0x72
  jmp alltraps
8010656d:	e9 5c f7 ff ff       	jmp    80105cce <alltraps>

80106572 <vector115>:
.globl vector115
vector115:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $115
80106574:	6a 73                	push   $0x73
  jmp alltraps
80106576:	e9 53 f7 ff ff       	jmp    80105cce <alltraps>

8010657b <vector116>:
.globl vector116
vector116:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $116
8010657d:	6a 74                	push   $0x74
  jmp alltraps
8010657f:	e9 4a f7 ff ff       	jmp    80105cce <alltraps>

80106584 <vector117>:
.globl vector117
vector117:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $117
80106586:	6a 75                	push   $0x75
  jmp alltraps
80106588:	e9 41 f7 ff ff       	jmp    80105cce <alltraps>

8010658d <vector118>:
.globl vector118
vector118:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $118
8010658f:	6a 76                	push   $0x76
  jmp alltraps
80106591:	e9 38 f7 ff ff       	jmp    80105cce <alltraps>

80106596 <vector119>:
.globl vector119
vector119:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $119
80106598:	6a 77                	push   $0x77
  jmp alltraps
8010659a:	e9 2f f7 ff ff       	jmp    80105cce <alltraps>

8010659f <vector120>:
.globl vector120
vector120:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $120
801065a1:	6a 78                	push   $0x78
  jmp alltraps
801065a3:	e9 26 f7 ff ff       	jmp    80105cce <alltraps>

801065a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $121
801065aa:	6a 79                	push   $0x79
  jmp alltraps
801065ac:	e9 1d f7 ff ff       	jmp    80105cce <alltraps>

801065b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $122
801065b3:	6a 7a                	push   $0x7a
  jmp alltraps
801065b5:	e9 14 f7 ff ff       	jmp    80105cce <alltraps>

801065ba <vector123>:
.globl vector123
vector123:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $123
801065bc:	6a 7b                	push   $0x7b
  jmp alltraps
801065be:	e9 0b f7 ff ff       	jmp    80105cce <alltraps>

801065c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $124
801065c5:	6a 7c                	push   $0x7c
  jmp alltraps
801065c7:	e9 02 f7 ff ff       	jmp    80105cce <alltraps>

801065cc <vector125>:
.globl vector125
vector125:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $125
801065ce:	6a 7d                	push   $0x7d
  jmp alltraps
801065d0:	e9 f9 f6 ff ff       	jmp    80105cce <alltraps>

801065d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $126
801065d7:	6a 7e                	push   $0x7e
  jmp alltraps
801065d9:	e9 f0 f6 ff ff       	jmp    80105cce <alltraps>

801065de <vector127>:
.globl vector127
vector127:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $127
801065e0:	6a 7f                	push   $0x7f
  jmp alltraps
801065e2:	e9 e7 f6 ff ff       	jmp    80105cce <alltraps>

801065e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $128
801065e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065ee:	e9 db f6 ff ff       	jmp    80105cce <alltraps>

801065f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $129
801065f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065fa:	e9 cf f6 ff ff       	jmp    80105cce <alltraps>

801065ff <vector130>:
.globl vector130
vector130:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $130
80106601:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106606:	e9 c3 f6 ff ff       	jmp    80105cce <alltraps>

8010660b <vector131>:
.globl vector131
vector131:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $131
8010660d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106612:	e9 b7 f6 ff ff       	jmp    80105cce <alltraps>

80106617 <vector132>:
.globl vector132
vector132:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $132
80106619:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010661e:	e9 ab f6 ff ff       	jmp    80105cce <alltraps>

80106623 <vector133>:
.globl vector133
vector133:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $133
80106625:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010662a:	e9 9f f6 ff ff       	jmp    80105cce <alltraps>

8010662f <vector134>:
.globl vector134
vector134:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $134
80106631:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106636:	e9 93 f6 ff ff       	jmp    80105cce <alltraps>

8010663b <vector135>:
.globl vector135
vector135:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $135
8010663d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106642:	e9 87 f6 ff ff       	jmp    80105cce <alltraps>

80106647 <vector136>:
.globl vector136
vector136:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $136
80106649:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010664e:	e9 7b f6 ff ff       	jmp    80105cce <alltraps>

80106653 <vector137>:
.globl vector137
vector137:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $137
80106655:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010665a:	e9 6f f6 ff ff       	jmp    80105cce <alltraps>

8010665f <vector138>:
.globl vector138
vector138:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $138
80106661:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106666:	e9 63 f6 ff ff       	jmp    80105cce <alltraps>

8010666b <vector139>:
.globl vector139
vector139:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $139
8010666d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106672:	e9 57 f6 ff ff       	jmp    80105cce <alltraps>

80106677 <vector140>:
.globl vector140
vector140:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $140
80106679:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010667e:	e9 4b f6 ff ff       	jmp    80105cce <alltraps>

80106683 <vector141>:
.globl vector141
vector141:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $141
80106685:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010668a:	e9 3f f6 ff ff       	jmp    80105cce <alltraps>

8010668f <vector142>:
.globl vector142
vector142:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $142
80106691:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106696:	e9 33 f6 ff ff       	jmp    80105cce <alltraps>

8010669b <vector143>:
.globl vector143
vector143:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $143
8010669d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066a2:	e9 27 f6 ff ff       	jmp    80105cce <alltraps>

801066a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $144
801066a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066ae:	e9 1b f6 ff ff       	jmp    80105cce <alltraps>

801066b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $145
801066b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066ba:	e9 0f f6 ff ff       	jmp    80105cce <alltraps>

801066bf <vector146>:
.globl vector146
vector146:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $146
801066c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801066c6:	e9 03 f6 ff ff       	jmp    80105cce <alltraps>

801066cb <vector147>:
.globl vector147
vector147:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $147
801066cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066d2:	e9 f7 f5 ff ff       	jmp    80105cce <alltraps>

801066d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $148
801066d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066de:	e9 eb f5 ff ff       	jmp    80105cce <alltraps>

801066e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $149
801066e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066ea:	e9 df f5 ff ff       	jmp    80105cce <alltraps>

801066ef <vector150>:
.globl vector150
vector150:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $150
801066f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066f6:	e9 d3 f5 ff ff       	jmp    80105cce <alltraps>

801066fb <vector151>:
.globl vector151
vector151:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $151
801066fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106702:	e9 c7 f5 ff ff       	jmp    80105cce <alltraps>

80106707 <vector152>:
.globl vector152
vector152:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $152
80106709:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010670e:	e9 bb f5 ff ff       	jmp    80105cce <alltraps>

80106713 <vector153>:
.globl vector153
vector153:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $153
80106715:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010671a:	e9 af f5 ff ff       	jmp    80105cce <alltraps>

8010671f <vector154>:
.globl vector154
vector154:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $154
80106721:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106726:	e9 a3 f5 ff ff       	jmp    80105cce <alltraps>

8010672b <vector155>:
.globl vector155
vector155:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $155
8010672d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106732:	e9 97 f5 ff ff       	jmp    80105cce <alltraps>

80106737 <vector156>:
.globl vector156
vector156:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $156
80106739:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010673e:	e9 8b f5 ff ff       	jmp    80105cce <alltraps>

80106743 <vector157>:
.globl vector157
vector157:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $157
80106745:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010674a:	e9 7f f5 ff ff       	jmp    80105cce <alltraps>

8010674f <vector158>:
.globl vector158
vector158:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $158
80106751:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106756:	e9 73 f5 ff ff       	jmp    80105cce <alltraps>

8010675b <vector159>:
.globl vector159
vector159:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $159
8010675d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106762:	e9 67 f5 ff ff       	jmp    80105cce <alltraps>

80106767 <vector160>:
.globl vector160
vector160:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $160
80106769:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010676e:	e9 5b f5 ff ff       	jmp    80105cce <alltraps>

80106773 <vector161>:
.globl vector161
vector161:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $161
80106775:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010677a:	e9 4f f5 ff ff       	jmp    80105cce <alltraps>

8010677f <vector162>:
.globl vector162
vector162:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $162
80106781:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106786:	e9 43 f5 ff ff       	jmp    80105cce <alltraps>

8010678b <vector163>:
.globl vector163
vector163:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $163
8010678d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106792:	e9 37 f5 ff ff       	jmp    80105cce <alltraps>

80106797 <vector164>:
.globl vector164
vector164:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $164
80106799:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010679e:	e9 2b f5 ff ff       	jmp    80105cce <alltraps>

801067a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $165
801067a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067aa:	e9 1f f5 ff ff       	jmp    80105cce <alltraps>

801067af <vector166>:
.globl vector166
vector166:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $166
801067b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067b6:	e9 13 f5 ff ff       	jmp    80105cce <alltraps>

801067bb <vector167>:
.globl vector167
vector167:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $167
801067bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801067c2:	e9 07 f5 ff ff       	jmp    80105cce <alltraps>

801067c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $168
801067c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801067ce:	e9 fb f4 ff ff       	jmp    80105cce <alltraps>

801067d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $169
801067d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067da:	e9 ef f4 ff ff       	jmp    80105cce <alltraps>

801067df <vector170>:
.globl vector170
vector170:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $170
801067e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067e6:	e9 e3 f4 ff ff       	jmp    80105cce <alltraps>

801067eb <vector171>:
.globl vector171
vector171:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $171
801067ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067f2:	e9 d7 f4 ff ff       	jmp    80105cce <alltraps>

801067f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $172
801067f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067fe:	e9 cb f4 ff ff       	jmp    80105cce <alltraps>

80106803 <vector173>:
.globl vector173
vector173:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $173
80106805:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010680a:	e9 bf f4 ff ff       	jmp    80105cce <alltraps>

8010680f <vector174>:
.globl vector174
vector174:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $174
80106811:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106816:	e9 b3 f4 ff ff       	jmp    80105cce <alltraps>

8010681b <vector175>:
.globl vector175
vector175:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $175
8010681d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106822:	e9 a7 f4 ff ff       	jmp    80105cce <alltraps>

80106827 <vector176>:
.globl vector176
vector176:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $176
80106829:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010682e:	e9 9b f4 ff ff       	jmp    80105cce <alltraps>

80106833 <vector177>:
.globl vector177
vector177:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $177
80106835:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010683a:	e9 8f f4 ff ff       	jmp    80105cce <alltraps>

8010683f <vector178>:
.globl vector178
vector178:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $178
80106841:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106846:	e9 83 f4 ff ff       	jmp    80105cce <alltraps>

8010684b <vector179>:
.globl vector179
vector179:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $179
8010684d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106852:	e9 77 f4 ff ff       	jmp    80105cce <alltraps>

80106857 <vector180>:
.globl vector180
vector180:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $180
80106859:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010685e:	e9 6b f4 ff ff       	jmp    80105cce <alltraps>

80106863 <vector181>:
.globl vector181
vector181:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $181
80106865:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010686a:	e9 5f f4 ff ff       	jmp    80105cce <alltraps>

8010686f <vector182>:
.globl vector182
vector182:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $182
80106871:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106876:	e9 53 f4 ff ff       	jmp    80105cce <alltraps>

8010687b <vector183>:
.globl vector183
vector183:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $183
8010687d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106882:	e9 47 f4 ff ff       	jmp    80105cce <alltraps>

80106887 <vector184>:
.globl vector184
vector184:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $184
80106889:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010688e:	e9 3b f4 ff ff       	jmp    80105cce <alltraps>

80106893 <vector185>:
.globl vector185
vector185:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $185
80106895:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010689a:	e9 2f f4 ff ff       	jmp    80105cce <alltraps>

8010689f <vector186>:
.globl vector186
vector186:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $186
801068a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068a6:	e9 23 f4 ff ff       	jmp    80105cce <alltraps>

801068ab <vector187>:
.globl vector187
vector187:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $187
801068ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068b2:	e9 17 f4 ff ff       	jmp    80105cce <alltraps>

801068b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $188
801068b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068be:	e9 0b f4 ff ff       	jmp    80105cce <alltraps>

801068c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $189
801068c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801068ca:	e9 ff f3 ff ff       	jmp    80105cce <alltraps>

801068cf <vector190>:
.globl vector190
vector190:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $190
801068d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068d6:	e9 f3 f3 ff ff       	jmp    80105cce <alltraps>

801068db <vector191>:
.globl vector191
vector191:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $191
801068dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068e2:	e9 e7 f3 ff ff       	jmp    80105cce <alltraps>

801068e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $192
801068e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068ee:	e9 db f3 ff ff       	jmp    80105cce <alltraps>

801068f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $193
801068f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068fa:	e9 cf f3 ff ff       	jmp    80105cce <alltraps>

801068ff <vector194>:
.globl vector194
vector194:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $194
80106901:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106906:	e9 c3 f3 ff ff       	jmp    80105cce <alltraps>

8010690b <vector195>:
.globl vector195
vector195:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $195
8010690d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106912:	e9 b7 f3 ff ff       	jmp    80105cce <alltraps>

80106917 <vector196>:
.globl vector196
vector196:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $196
80106919:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010691e:	e9 ab f3 ff ff       	jmp    80105cce <alltraps>

80106923 <vector197>:
.globl vector197
vector197:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $197
80106925:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010692a:	e9 9f f3 ff ff       	jmp    80105cce <alltraps>

8010692f <vector198>:
.globl vector198
vector198:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $198
80106931:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106936:	e9 93 f3 ff ff       	jmp    80105cce <alltraps>

8010693b <vector199>:
.globl vector199
vector199:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $199
8010693d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106942:	e9 87 f3 ff ff       	jmp    80105cce <alltraps>

80106947 <vector200>:
.globl vector200
vector200:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $200
80106949:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010694e:	e9 7b f3 ff ff       	jmp    80105cce <alltraps>

80106953 <vector201>:
.globl vector201
vector201:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $201
80106955:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010695a:	e9 6f f3 ff ff       	jmp    80105cce <alltraps>

8010695f <vector202>:
.globl vector202
vector202:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $202
80106961:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106966:	e9 63 f3 ff ff       	jmp    80105cce <alltraps>

8010696b <vector203>:
.globl vector203
vector203:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $203
8010696d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106972:	e9 57 f3 ff ff       	jmp    80105cce <alltraps>

80106977 <vector204>:
.globl vector204
vector204:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $204
80106979:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010697e:	e9 4b f3 ff ff       	jmp    80105cce <alltraps>

80106983 <vector205>:
.globl vector205
vector205:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $205
80106985:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010698a:	e9 3f f3 ff ff       	jmp    80105cce <alltraps>

8010698f <vector206>:
.globl vector206
vector206:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $206
80106991:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106996:	e9 33 f3 ff ff       	jmp    80105cce <alltraps>

8010699b <vector207>:
.globl vector207
vector207:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $207
8010699d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069a2:	e9 27 f3 ff ff       	jmp    80105cce <alltraps>

801069a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $208
801069a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069ae:	e9 1b f3 ff ff       	jmp    80105cce <alltraps>

801069b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $209
801069b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069ba:	e9 0f f3 ff ff       	jmp    80105cce <alltraps>

801069bf <vector210>:
.globl vector210
vector210:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $210
801069c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801069c6:	e9 03 f3 ff ff       	jmp    80105cce <alltraps>

801069cb <vector211>:
.globl vector211
vector211:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $211
801069cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069d2:	e9 f7 f2 ff ff       	jmp    80105cce <alltraps>

801069d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $212
801069d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069de:	e9 eb f2 ff ff       	jmp    80105cce <alltraps>

801069e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $213
801069e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069ea:	e9 df f2 ff ff       	jmp    80105cce <alltraps>

801069ef <vector214>:
.globl vector214
vector214:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $214
801069f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069f6:	e9 d3 f2 ff ff       	jmp    80105cce <alltraps>

801069fb <vector215>:
.globl vector215
vector215:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $215
801069fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a02:	e9 c7 f2 ff ff       	jmp    80105cce <alltraps>

80106a07 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $216
80106a09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a0e:	e9 bb f2 ff ff       	jmp    80105cce <alltraps>

80106a13 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $217
80106a15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a1a:	e9 af f2 ff ff       	jmp    80105cce <alltraps>

80106a1f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $218
80106a21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a26:	e9 a3 f2 ff ff       	jmp    80105cce <alltraps>

80106a2b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $219
80106a2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a32:	e9 97 f2 ff ff       	jmp    80105cce <alltraps>

80106a37 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $220
80106a39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a3e:	e9 8b f2 ff ff       	jmp    80105cce <alltraps>

80106a43 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $221
80106a45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a4a:	e9 7f f2 ff ff       	jmp    80105cce <alltraps>

80106a4f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $222
80106a51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a56:	e9 73 f2 ff ff       	jmp    80105cce <alltraps>

80106a5b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $223
80106a5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a62:	e9 67 f2 ff ff       	jmp    80105cce <alltraps>

80106a67 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $224
80106a69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a6e:	e9 5b f2 ff ff       	jmp    80105cce <alltraps>

80106a73 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $225
80106a75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a7a:	e9 4f f2 ff ff       	jmp    80105cce <alltraps>

80106a7f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $226
80106a81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a86:	e9 43 f2 ff ff       	jmp    80105cce <alltraps>

80106a8b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $227
80106a8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a92:	e9 37 f2 ff ff       	jmp    80105cce <alltraps>

80106a97 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $228
80106a99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a9e:	e9 2b f2 ff ff       	jmp    80105cce <alltraps>

80106aa3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $229
80106aa5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106aaa:	e9 1f f2 ff ff       	jmp    80105cce <alltraps>

80106aaf <vector230>:
.globl vector230
vector230:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $230
80106ab1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ab6:	e9 13 f2 ff ff       	jmp    80105cce <alltraps>

80106abb <vector231>:
.globl vector231
vector231:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $231
80106abd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ac2:	e9 07 f2 ff ff       	jmp    80105cce <alltraps>

80106ac7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $232
80106ac9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ace:	e9 fb f1 ff ff       	jmp    80105cce <alltraps>

80106ad3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $233
80106ad5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106ada:	e9 ef f1 ff ff       	jmp    80105cce <alltraps>

80106adf <vector234>:
.globl vector234
vector234:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $234
80106ae1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ae6:	e9 e3 f1 ff ff       	jmp    80105cce <alltraps>

80106aeb <vector235>:
.globl vector235
vector235:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $235
80106aed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106af2:	e9 d7 f1 ff ff       	jmp    80105cce <alltraps>

80106af7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $236
80106af9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106afe:	e9 cb f1 ff ff       	jmp    80105cce <alltraps>

80106b03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $237
80106b05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b0a:	e9 bf f1 ff ff       	jmp    80105cce <alltraps>

80106b0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $238
80106b11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b16:	e9 b3 f1 ff ff       	jmp    80105cce <alltraps>

80106b1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $239
80106b1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b22:	e9 a7 f1 ff ff       	jmp    80105cce <alltraps>

80106b27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $240
80106b29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b2e:	e9 9b f1 ff ff       	jmp    80105cce <alltraps>

80106b33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $241
80106b35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b3a:	e9 8f f1 ff ff       	jmp    80105cce <alltraps>

80106b3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $242
80106b41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b46:	e9 83 f1 ff ff       	jmp    80105cce <alltraps>

80106b4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $243
80106b4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b52:	e9 77 f1 ff ff       	jmp    80105cce <alltraps>

80106b57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $244
80106b59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b5e:	e9 6b f1 ff ff       	jmp    80105cce <alltraps>

80106b63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $245
80106b65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b6a:	e9 5f f1 ff ff       	jmp    80105cce <alltraps>

80106b6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $246
80106b71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b76:	e9 53 f1 ff ff       	jmp    80105cce <alltraps>

80106b7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $247
80106b7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b82:	e9 47 f1 ff ff       	jmp    80105cce <alltraps>

80106b87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $248
80106b89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b8e:	e9 3b f1 ff ff       	jmp    80105cce <alltraps>

80106b93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $249
80106b95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b9a:	e9 2f f1 ff ff       	jmp    80105cce <alltraps>

80106b9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $250
80106ba1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ba6:	e9 23 f1 ff ff       	jmp    80105cce <alltraps>

80106bab <vector251>:
.globl vector251
vector251:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $251
80106bad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106bb2:	e9 17 f1 ff ff       	jmp    80105cce <alltraps>

80106bb7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $252
80106bb9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bbe:	e9 0b f1 ff ff       	jmp    80105cce <alltraps>

80106bc3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $253
80106bc5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106bca:	e9 ff f0 ff ff       	jmp    80105cce <alltraps>

80106bcf <vector254>:
.globl vector254
vector254:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $254
80106bd1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106bd6:	e9 f3 f0 ff ff       	jmp    80105cce <alltraps>

80106bdb <vector255>:
.globl vector255
vector255:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $255
80106bdd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106be2:	e9 e7 f0 ff ff       	jmp    80105cce <alltraps>
80106be7:	66 90                	xchg   %ax,%ax
80106be9:	66 90                	xchg   %ax,%ax
80106beb:	66 90                	xchg   %ax,%ax
80106bed:	66 90                	xchg   %ax,%ax
80106bef:	90                   	nop

80106bf0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106bf6:	89 d3                	mov    %edx,%ebx
{
80106bf8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106bfa:	c1 eb 16             	shr    $0x16,%ebx
80106bfd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106c00:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c03:	8b 06                	mov    (%esi),%eax
80106c05:	a8 01                	test   $0x1,%al
80106c07:	74 27                	je     80106c30 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c0e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c14:	c1 ef 0a             	shr    $0xa,%edi
}
80106c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c1a:	89 fa                	mov    %edi,%edx
80106c1c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c22:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c30:	85 c9                	test   %ecx,%ecx
80106c32:	74 2c                	je     80106c60 <walkpgdir+0x70>
80106c34:	e8 77 b8 ff ff       	call   801024b0 <kalloc>
80106c39:	85 c0                	test   %eax,%eax
80106c3b:	89 c3                	mov    %eax,%ebx
80106c3d:	74 21                	je     80106c60 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c3f:	83 ec 04             	sub    $0x4,%esp
80106c42:	68 00 10 00 00       	push   $0x1000
80106c47:	6a 00                	push   $0x0
80106c49:	50                   	push   %eax
80106c4a:	e8 71 de ff ff       	call   80104ac0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c4f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c55:	83 c4 10             	add    $0x10,%esp
80106c58:	83 c8 07             	or     $0x7,%eax
80106c5b:	89 06                	mov    %eax,(%esi)
80106c5d:	eb b5                	jmp    80106c14 <walkpgdir+0x24>
80106c5f:	90                   	nop
}
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c63:	31 c0                	xor    %eax,%eax
}
80106c65:	5b                   	pop    %ebx
80106c66:	5e                   	pop    %esi
80106c67:	5f                   	pop    %edi
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	57                   	push   %edi
80106c74:	56                   	push   %esi
80106c75:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c76:	89 d3                	mov    %edx,%ebx
80106c78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c7e:	83 ec 1c             	sub    $0x1c,%esp
80106c81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c96:	29 df                	sub    %ebx,%edi
80106c98:	83 c8 01             	or     $0x1,%eax
80106c9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c9e:	eb 15                	jmp    80106cb5 <mappages+0x45>
    if(*pte & PTE_P)
80106ca0:	f6 00 01             	testb  $0x1,(%eax)
80106ca3:	75 45                	jne    80106cea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ca5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ca8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106cab:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106cad:	74 31                	je     80106ce0 <mappages+0x70>
      break;
    a += PGSIZE;
80106caf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106cb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cb8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106cbd:	89 da                	mov    %ebx,%edx
80106cbf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106cc2:	e8 29 ff ff ff       	call   80106bf0 <walkpgdir>
80106cc7:	85 c0                	test   %eax,%eax
80106cc9:	75 d5                	jne    80106ca0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cd3:	5b                   	pop    %ebx
80106cd4:	5e                   	pop    %esi
80106cd5:	5f                   	pop    %edi
80106cd6:	5d                   	pop    %ebp
80106cd7:	c3                   	ret    
80106cd8:	90                   	nop
80106cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ce3:	31 c0                	xor    %eax,%eax
}
80106ce5:	5b                   	pop    %ebx
80106ce6:	5e                   	pop    %esi
80106ce7:	5f                   	pop    %edi
80106ce8:	5d                   	pop    %ebp
80106ce9:	c3                   	ret    
      panic("remap");
80106cea:	83 ec 0c             	sub    $0xc,%esp
80106ced:	68 f8 7d 10 80       	push   $0x80107df8
80106cf2:	e8 79 96 ff ff       	call   80100370 <panic>
80106cf7:	89 f6                	mov    %esi,%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d0c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106d0e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d14:	83 ec 1c             	sub    $0x1c,%esp
80106d17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d1a:	39 d3                	cmp    %edx,%ebx
80106d1c:	73 60                	jae    80106d7e <deallocuvm.part.0+0x7e>
80106d1e:	89 d6                	mov    %edx,%esi
80106d20:	eb 3d                	jmp    80106d5f <deallocuvm.part.0+0x5f>
80106d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106d28:	8b 10                	mov    (%eax),%edx
80106d2a:	f6 c2 01             	test   $0x1,%dl
80106d2d:	74 26                	je     80106d55 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106d2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d35:	74 52                	je     80106d89 <deallocuvm.part.0+0x89>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106d37:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d3a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106d43:	52                   	push   %edx
80106d44:	e8 b7 b5 ff ff       	call   80102300 <kfree>
      *pte = 0;
80106d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d4c:	83 c4 10             	add    $0x10,%esp
80106d4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106d55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d5b:	39 f3                	cmp    %esi,%ebx
80106d5d:	73 1f                	jae    80106d7e <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106d5f:	31 c9                	xor    %ecx,%ecx
80106d61:	89 da                	mov    %ebx,%edx
80106d63:	89 f8                	mov    %edi,%eax
80106d65:	e8 86 fe ff ff       	call   80106bf0 <walkpgdir>
    if(!pte)
80106d6a:	85 c0                	test   %eax,%eax
80106d6c:	75 ba                	jne    80106d28 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
80106d6e:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d74:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d7a:	39 f3                	cmp    %esi,%ebx
80106d7c:	72 e1                	jb     80106d5f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d84:	5b                   	pop    %ebx
80106d85:	5e                   	pop    %esi
80106d86:	5f                   	pop    %edi
80106d87:	5d                   	pop    %ebp
80106d88:	c3                   	ret    
        panic("kfree");
80106d89:	83 ec 0c             	sub    $0xc,%esp
80106d8c:	68 3a 77 10 80       	push   $0x8010773a
80106d91:	e8 da 95 ff ff       	call   80100370 <panic>
80106d96:	8d 76 00             	lea    0x0(%esi),%esi
80106d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106da0 <seginit>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	53                   	push   %ebx
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106da4:	31 db                	xor    %ebx,%ebx
{
80106da6:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpunum()];
80106da9:	e8 92 b9 ff ff       	call   80102740 <cpunum>
80106dae:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106db4:	8d 90 e0 12 11 80    	lea    -0x7feeed20(%eax),%edx
80106dba:	8d 88 94 13 11 80    	lea    -0x7feeec6c(%eax),%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106dc0:	c7 80 58 13 11 80 ff 	movl   $0xffff,-0x7feeeca8(%eax)
80106dc7:	ff 00 00 
80106dca:	c7 80 5c 13 11 80 00 	movl   $0xcf9a00,-0x7feeeca4(%eax)
80106dd1:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106dd4:	c7 80 60 13 11 80 ff 	movl   $0xffff,-0x7feeeca0(%eax)
80106ddb:	ff 00 00 
80106dde:	c7 80 64 13 11 80 00 	movl   $0xcf9200,-0x7feeec9c(%eax)
80106de5:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106de8:	c7 80 70 13 11 80 ff 	movl   $0xffff,-0x7feeec90(%eax)
80106def:	ff 00 00 
80106df2:	c7 80 74 13 11 80 00 	movl   $0xcffa00,-0x7feeec8c(%eax)
80106df9:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dfc:	c7 80 78 13 11 80 ff 	movl   $0xffff,-0x7feeec88(%eax)
80106e03:	ff 00 00 
80106e06:	c7 80 7c 13 11 80 00 	movl   $0xcff200,-0x7feeec84(%eax)
80106e0d:	f2 cf 00 
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106e10:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
80106e17:	89 cb                	mov    %ecx,%ebx
80106e19:	c1 eb 10             	shr    $0x10,%ebx
80106e1c:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
80106e23:	c1 e9 18             	shr    $0x18,%ecx
80106e26:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
80106e2c:	bb 92 c0 ff ff       	mov    $0xffffc092,%ebx
80106e31:	66 89 98 6d 13 11 80 	mov    %bx,-0x7feeec93(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106e38:	05 50 13 11 80       	add    $0x80111350,%eax
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106e3d:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
  pd[0] = size-1;
80106e43:	b9 37 00 00 00       	mov    $0x37,%ecx
80106e48:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
80106e4c:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e50:	c1 e8 10             	shr    $0x10,%eax
80106e53:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e57:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e5a:	0f 01 10             	lgdtl  (%eax)
  asm volatile("movw %0, %%gs" : : "r" (v));
80106e5d:	b8 18 00 00 00       	mov    $0x18,%eax
80106e62:	8e e8                	mov    %eax,%gs
  proc = 0;
80106e64:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106e6b:	00 00 00 00 
  c = &cpus[cpunum()];
80106e6f:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
}
80106e76:	83 c4 14             	add    $0x14,%esp
80106e79:	5b                   	pop    %ebx
80106e7a:	5d                   	pop    %ebp
80106e7b:	c3                   	ret    
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <setupkvm>:
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	56                   	push   %esi
80106e84:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106e85:	e8 26 b6 ff ff       	call   801024b0 <kalloc>
80106e8a:	85 c0                	test   %eax,%eax
80106e8c:	74 52                	je     80106ee0 <setupkvm+0x60>
  memset(pgdir, 0, PGSIZE);
80106e8e:	83 ec 04             	sub    $0x4,%esp
80106e91:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e93:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106e98:	68 00 10 00 00       	push   $0x1000
80106e9d:	6a 00                	push   $0x0
80106e9f:	50                   	push   %eax
80106ea0:	e8 1b dc ff ff       	call   80104ac0 <memset>
80106ea5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0)
80106ea8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106eab:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106eae:	83 ec 08             	sub    $0x8,%esp
80106eb1:	8b 13                	mov    (%ebx),%edx
80106eb3:	ff 73 0c             	pushl  0xc(%ebx)
80106eb6:	50                   	push   %eax
80106eb7:	29 c1                	sub    %eax,%ecx
80106eb9:	89 f0                	mov    %esi,%eax
80106ebb:	e8 b0 fd ff ff       	call   80106c70 <mappages>
80106ec0:	83 c4 10             	add    $0x10,%esp
80106ec3:	85 c0                	test   %eax,%eax
80106ec5:	78 19                	js     80106ee0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ec7:	83 c3 10             	add    $0x10,%ebx
80106eca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ed0:	75 d6                	jne    80106ea8 <setupkvm+0x28>
}
80106ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ed5:	89 f0                	mov    %esi,%eax
80106ed7:	5b                   	pop    %ebx
80106ed8:	5e                   	pop    %esi
80106ed9:	5d                   	pop    %ebp
80106eda:	c3                   	ret    
80106edb:	90                   	nop
80106edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106ee3:	31 f6                	xor    %esi,%esi
}
80106ee5:	89 f0                	mov    %esi,%eax
80106ee7:	5b                   	pop    %ebx
80106ee8:	5e                   	pop    %esi
80106ee9:	5d                   	pop    %ebp
80106eea:	c3                   	ret    
80106eeb:	90                   	nop
80106eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <kvmalloc>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ef6:	e8 85 ff ff ff       	call   80106e80 <setupkvm>
80106efb:	a3 64 45 11 80       	mov    %eax,0x80114564
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f00:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f05:	0f 22 d8             	mov    %eax,%cr3
}
80106f08:	c9                   	leave  
80106f09:	c3                   	ret    
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f10:	a1 64 45 11 80       	mov    0x80114564,%eax
{
80106f15:	55                   	push   %ebp
80106f16:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f18:	05 00 00 00 80       	add    $0x80000000,%eax
80106f1d:	0f 22 d8             	mov    %eax,%cr3
}
80106f20:	5d                   	pop    %ebp
80106f21:	c3                   	ret    
80106f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f30 <switchuvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	53                   	push   %ebx
80106f34:	83 ec 04             	sub    $0x4,%esp
80106f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106f3a:	e8 b1 da ff ff       	call   801049f0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106f3f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f45:	b9 67 00 00 00       	mov    $0x67,%ecx
80106f4a:	8d 50 08             	lea    0x8(%eax),%edx
80106f4d:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106f54:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106f5b:	89 d1                	mov    %edx,%ecx
80106f5d:	c1 ea 18             	shr    $0x18,%edx
80106f60:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106f66:	ba 89 40 00 00       	mov    $0x4089,%edx
80106f6b:	c1 e9 10             	shr    $0x10,%ecx
80106f6e:	66 89 90 a5 00 00 00 	mov    %dx,0xa5(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106f75:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106f7c:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80106f82:	b9 10 00 00 00       	mov    $0x10,%ecx
80106f87:	66 89 48 10          	mov    %cx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106f8b:	8b 52 08             	mov    0x8(%edx),%edx
80106f8e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106f94:	89 50 0c             	mov    %edx,0xc(%eax)
  cpu->ts.iomb = (ushort) 0xFFFF;
80106f97:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106f9c:	66 89 50 6e          	mov    %dx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fa0:	b8 30 00 00 00       	mov    $0x30,%eax
80106fa5:	0f 00 d8             	ltr    %ax
  if(p->pgdir == 0)
80106fa8:	8b 43 04             	mov    0x4(%ebx),%eax
80106fab:	85 c0                	test   %eax,%eax
80106fad:	74 11                	je     80106fc0 <switchuvm+0x90>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106faf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fb4:	0f 22 d8             	mov    %eax,%cr3
}
80106fb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106fba:	c9                   	leave  
  popcli();
80106fbb:	e9 60 da ff ff       	jmp    80104a20 <popcli>
    panic("switchuvm: no pgdir");
80106fc0:	83 ec 0c             	sub    $0xc,%esp
80106fc3:	68 fe 7d 10 80       	push   $0x80107dfe
80106fc8:	e8 a3 93 ff ff       	call   80100370 <panic>
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi

80106fd0 <inituvm>:
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	57                   	push   %edi
80106fd4:	56                   	push   %esi
80106fd5:	53                   	push   %ebx
80106fd6:	83 ec 1c             	sub    $0x1c,%esp
80106fd9:	8b 75 10             	mov    0x10(%ebp),%esi
80106fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fdf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106fe2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106fe8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106feb:	77 49                	ja     80107036 <inituvm+0x66>
  mem = kalloc();
80106fed:	e8 be b4 ff ff       	call   801024b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106ff2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106ff5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ff7:	68 00 10 00 00       	push   $0x1000
80106ffc:	6a 00                	push   $0x0
80106ffe:	50                   	push   %eax
80106fff:	e8 bc da ff ff       	call   80104ac0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107004:	58                   	pop    %eax
80107005:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010700b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107010:	5a                   	pop    %edx
80107011:	6a 06                	push   $0x6
80107013:	50                   	push   %eax
80107014:	31 d2                	xor    %edx,%edx
80107016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107019:	e8 52 fc ff ff       	call   80106c70 <mappages>
  memmove(mem, init, sz);
8010701e:	89 75 10             	mov    %esi,0x10(%ebp)
80107021:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107024:	83 c4 10             	add    $0x10,%esp
80107027:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010702a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010702d:	5b                   	pop    %ebx
8010702e:	5e                   	pop    %esi
8010702f:	5f                   	pop    %edi
80107030:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107031:	e9 3a db ff ff       	jmp    80104b70 <memmove>
    panic("inituvm: more than a page");
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	68 12 7e 10 80       	push   $0x80107e12
8010703e:	e8 2d 93 ff ff       	call   80100370 <panic>
80107043:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107050 <loaduvm>:
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
80107056:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107059:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107060:	0f 85 91 00 00 00    	jne    801070f7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107066:	8b 75 18             	mov    0x18(%ebp),%esi
80107069:	31 db                	xor    %ebx,%ebx
8010706b:	85 f6                	test   %esi,%esi
8010706d:	75 1a                	jne    80107089 <loaduvm+0x39>
8010706f:	eb 6f                	jmp    801070e0 <loaduvm+0x90>
80107071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107078:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010707e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107084:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107087:	76 57                	jbe    801070e0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107089:	8b 55 0c             	mov    0xc(%ebp),%edx
8010708c:	8b 45 08             	mov    0x8(%ebp),%eax
8010708f:	31 c9                	xor    %ecx,%ecx
80107091:	01 da                	add    %ebx,%edx
80107093:	e8 58 fb ff ff       	call   80106bf0 <walkpgdir>
80107098:	85 c0                	test   %eax,%eax
8010709a:	74 4e                	je     801070ea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010709c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010709e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801070a1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070ab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070b1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070b4:	01 d9                	add    %ebx,%ecx
801070b6:	05 00 00 00 80       	add    $0x80000000,%eax
801070bb:	57                   	push   %edi
801070bc:	51                   	push   %ecx
801070bd:	50                   	push   %eax
801070be:	ff 75 10             	pushl  0x10(%ebp)
801070c1:	e8 6a a8 ff ff       	call   80101930 <readi>
801070c6:	83 c4 10             	add    $0x10,%esp
801070c9:	39 f8                	cmp    %edi,%eax
801070cb:	74 ab                	je     80107078 <loaduvm+0x28>
}
801070cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070e3:	31 c0                	xor    %eax,%eax
}
801070e5:	5b                   	pop    %ebx
801070e6:	5e                   	pop    %esi
801070e7:	5f                   	pop    %edi
801070e8:	5d                   	pop    %ebp
801070e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801070ea:	83 ec 0c             	sub    $0xc,%esp
801070ed:	68 2c 7e 10 80       	push   $0x80107e2c
801070f2:	e8 79 92 ff ff       	call   80100370 <panic>
    panic("loaduvm: addr must be page aligned");
801070f7:	83 ec 0c             	sub    $0xc,%esp
801070fa:	68 d0 7e 10 80       	push   $0x80107ed0
801070ff:	e8 6c 92 ff ff       	call   80100370 <panic>
80107104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010710a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107110 <allocuvm>:
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107119:	8b 7d 10             	mov    0x10(%ebp),%edi
8010711c:	85 ff                	test   %edi,%edi
8010711e:	0f 88 8e 00 00 00    	js     801071b2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107124:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107127:	0f 82 93 00 00 00    	jb     801071c0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010712d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107130:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107136:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010713c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010713f:	0f 86 7e 00 00 00    	jbe    801071c3 <allocuvm+0xb3>
80107145:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107148:	8b 7d 08             	mov    0x8(%ebp),%edi
8010714b:	eb 42                	jmp    8010718f <allocuvm+0x7f>
8010714d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107150:	83 ec 04             	sub    $0x4,%esp
80107153:	68 00 10 00 00       	push   $0x1000
80107158:	6a 00                	push   $0x0
8010715a:	50                   	push   %eax
8010715b:	e8 60 d9 ff ff       	call   80104ac0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107160:	58                   	pop    %eax
80107161:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107167:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010716c:	5a                   	pop    %edx
8010716d:	6a 06                	push   $0x6
8010716f:	50                   	push   %eax
80107170:	89 da                	mov    %ebx,%edx
80107172:	89 f8                	mov    %edi,%eax
80107174:	e8 f7 fa ff ff       	call   80106c70 <mappages>
80107179:	83 c4 10             	add    $0x10,%esp
8010717c:	85 c0                	test   %eax,%eax
8010717e:	78 50                	js     801071d0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107180:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107186:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107189:	0f 86 81 00 00 00    	jbe    80107210 <allocuvm+0x100>
    mem = kalloc();
8010718f:	e8 1c b3 ff ff       	call   801024b0 <kalloc>
    if(mem == 0){
80107194:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107196:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107198:	75 b6                	jne    80107150 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010719a:	83 ec 0c             	sub    $0xc,%esp
8010719d:	68 4a 7e 10 80       	push   $0x80107e4a
801071a2:	e8 99 94 ff ff       	call   80100640 <cprintf>
  if(newsz >= oldsz)
801071a7:	83 c4 10             	add    $0x10,%esp
801071aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801071ad:	39 45 10             	cmp    %eax,0x10(%ebp)
801071b0:	77 6e                	ja     80107220 <allocuvm+0x110>
}
801071b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801071b5:	31 ff                	xor    %edi,%edi
}
801071b7:	89 f8                	mov    %edi,%eax
801071b9:	5b                   	pop    %ebx
801071ba:	5e                   	pop    %esi
801071bb:	5f                   	pop    %edi
801071bc:	5d                   	pop    %ebp
801071bd:	c3                   	ret    
801071be:	66 90                	xchg   %ax,%ax
    return oldsz;
801071c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801071c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071c6:	89 f8                	mov    %edi,%eax
801071c8:	5b                   	pop    %ebx
801071c9:	5e                   	pop    %esi
801071ca:	5f                   	pop    %edi
801071cb:	5d                   	pop    %ebp
801071cc:	c3                   	ret    
801071cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801071d0:	83 ec 0c             	sub    $0xc,%esp
801071d3:	68 62 7e 10 80       	push   $0x80107e62
801071d8:	e8 63 94 ff ff       	call   80100640 <cprintf>
  if(newsz >= oldsz)
801071dd:	83 c4 10             	add    $0x10,%esp
801071e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e3:	39 45 10             	cmp    %eax,0x10(%ebp)
801071e6:	76 0d                	jbe    801071f5 <allocuvm+0xe5>
801071e8:	89 c1                	mov    %eax,%ecx
801071ea:	8b 55 10             	mov    0x10(%ebp),%edx
801071ed:	8b 45 08             	mov    0x8(%ebp),%eax
801071f0:	e8 0b fb ff ff       	call   80106d00 <deallocuvm.part.0>
      kfree(mem);
801071f5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801071f8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801071fa:	56                   	push   %esi
801071fb:	e8 00 b1 ff ff       	call   80102300 <kfree>
      return 0;
80107200:	83 c4 10             	add    $0x10,%esp
}
80107203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107206:	89 f8                	mov    %edi,%eax
80107208:	5b                   	pop    %ebx
80107209:	5e                   	pop    %esi
8010720a:	5f                   	pop    %edi
8010720b:	5d                   	pop    %ebp
8010720c:	c3                   	ret    
8010720d:	8d 76 00             	lea    0x0(%esi),%esi
80107210:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107213:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107216:	5b                   	pop    %ebx
80107217:	89 f8                	mov    %edi,%eax
80107219:	5e                   	pop    %esi
8010721a:	5f                   	pop    %edi
8010721b:	5d                   	pop    %ebp
8010721c:	c3                   	ret    
8010721d:	8d 76 00             	lea    0x0(%esi),%esi
80107220:	89 c1                	mov    %eax,%ecx
80107222:	8b 55 10             	mov    0x10(%ebp),%edx
80107225:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107228:	31 ff                	xor    %edi,%edi
8010722a:	e8 d1 fa ff ff       	call   80106d00 <deallocuvm.part.0>
8010722f:	eb 92                	jmp    801071c3 <allocuvm+0xb3>
80107231:	eb 0d                	jmp    80107240 <deallocuvm>
80107233:	90                   	nop
80107234:	90                   	nop
80107235:	90                   	nop
80107236:	90                   	nop
80107237:	90                   	nop
80107238:	90                   	nop
80107239:	90                   	nop
8010723a:	90                   	nop
8010723b:	90                   	nop
8010723c:	90                   	nop
8010723d:	90                   	nop
8010723e:	90                   	nop
8010723f:	90                   	nop

80107240 <deallocuvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	8b 55 0c             	mov    0xc(%ebp),%edx
80107246:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107249:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010724c:	39 d1                	cmp    %edx,%ecx
8010724e:	73 10                	jae    80107260 <deallocuvm+0x20>
}
80107250:	5d                   	pop    %ebp
80107251:	e9 aa fa ff ff       	jmp    80106d00 <deallocuvm.part.0>
80107256:	8d 76 00             	lea    0x0(%esi),%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107260:	89 d0                	mov    %edx,%eax
80107262:	5d                   	pop    %ebp
80107263:	c3                   	ret    
80107264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010726a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107270 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 0c             	sub    $0xc,%esp
80107279:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010727c:	85 f6                	test   %esi,%esi
8010727e:	74 59                	je     801072d9 <freevm+0x69>
80107280:	31 c9                	xor    %ecx,%ecx
80107282:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107287:	89 f0                	mov    %esi,%eax
80107289:	e8 72 fa ff ff       	call   80106d00 <deallocuvm.part.0>
8010728e:	89 f3                	mov    %esi,%ebx
80107290:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107296:	eb 0f                	jmp    801072a7 <freevm+0x37>
80107298:	90                   	nop
80107299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072a0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072a3:	39 fb                	cmp    %edi,%ebx
801072a5:	74 23                	je     801072ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072a7:	8b 03                	mov    (%ebx),%eax
801072a9:	a8 01                	test   $0x1,%al
801072ab:	74 f3                	je     801072a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072b2:	83 ec 0c             	sub    $0xc,%esp
801072b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072bd:	50                   	push   %eax
801072be:	e8 3d b0 ff ff       	call   80102300 <kfree>
801072c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072c6:	39 fb                	cmp    %edi,%ebx
801072c8:	75 dd                	jne    801072a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d0:	5b                   	pop    %ebx
801072d1:	5e                   	pop    %esi
801072d2:	5f                   	pop    %edi
801072d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072d4:	e9 27 b0 ff ff       	jmp    80102300 <kfree>
    panic("freevm: no pgdir");
801072d9:	83 ec 0c             	sub    $0xc,%esp
801072dc:	68 7e 7e 10 80       	push   $0x80107e7e
801072e1:	e8 8a 90 ff ff       	call   80100370 <panic>
801072e6:	8d 76 00             	lea    0x0(%esi),%esi
801072e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072f1:	31 c9                	xor    %ecx,%ecx
{
801072f3:	89 e5                	mov    %esp,%ebp
801072f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072fb:	8b 45 08             	mov    0x8(%ebp),%eax
801072fe:	e8 ed f8 ff ff       	call   80106bf0 <walkpgdir>
  if(pte == 0)
80107303:	85 c0                	test   %eax,%eax
80107305:	74 05                	je     8010730c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107307:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010730a:	c9                   	leave  
8010730b:	c3                   	ret    
    panic("clearpteu");
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	68 8f 7e 10 80       	push   $0x80107e8f
80107314:	e8 57 90 ff ff       	call   80100370 <panic>
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107329:	e8 52 fb ff ff       	call   80106e80 <setupkvm>
8010732e:	85 c0                	test   %eax,%eax
80107330:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107333:	0f 84 a0 00 00 00    	je     801073d9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107339:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010733c:	85 c9                	test   %ecx,%ecx
8010733e:	0f 84 95 00 00 00    	je     801073d9 <copyuvm+0xb9>
80107344:	31 f6                	xor    %esi,%esi
80107346:	eb 4e                	jmp    80107396 <copyuvm+0x76>
80107348:	90                   	nop
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107350:	83 ec 04             	sub    $0x4,%esp
80107353:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010735c:	68 00 10 00 00       	push   $0x1000
80107361:	57                   	push   %edi
80107362:	50                   	push   %eax
80107363:	e8 08 d8 ff ff       	call   80104b70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107368:	58                   	pop    %eax
80107369:	5a                   	pop    %edx
8010736a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010736d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107370:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107375:	53                   	push   %ebx
80107376:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010737c:	52                   	push   %edx
8010737d:	89 f2                	mov    %esi,%edx
8010737f:	e8 ec f8 ff ff       	call   80106c70 <mappages>
80107384:	83 c4 10             	add    $0x10,%esp
80107387:	85 c0                	test   %eax,%eax
80107389:	78 39                	js     801073c4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010738b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107391:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107394:	76 43                	jbe    801073d9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107396:	8b 45 08             	mov    0x8(%ebp),%eax
80107399:	31 c9                	xor    %ecx,%ecx
8010739b:	89 f2                	mov    %esi,%edx
8010739d:	e8 4e f8 ff ff       	call   80106bf0 <walkpgdir>
801073a2:	85 c0                	test   %eax,%eax
801073a4:	74 3e                	je     801073e4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
801073a6:	8b 18                	mov    (%eax),%ebx
801073a8:	f6 c3 01             	test   $0x1,%bl
801073ab:	74 44                	je     801073f1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
801073ad:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801073af:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801073b5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801073bb:	e8 f0 b0 ff ff       	call   801024b0 <kalloc>
801073c0:	85 c0                	test   %eax,%eax
801073c2:	75 8c                	jne    80107350 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801073c4:	83 ec 0c             	sub    $0xc,%esp
801073c7:	ff 75 e0             	pushl  -0x20(%ebp)
801073ca:	e8 a1 fe ff ff       	call   80107270 <freevm>
  return 0;
801073cf:	83 c4 10             	add    $0x10,%esp
801073d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801073d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073df:	5b                   	pop    %ebx
801073e0:	5e                   	pop    %esi
801073e1:	5f                   	pop    %edi
801073e2:	5d                   	pop    %ebp
801073e3:	c3                   	ret    
      panic("copyuvm: pte should exist");
801073e4:	83 ec 0c             	sub    $0xc,%esp
801073e7:	68 99 7e 10 80       	push   $0x80107e99
801073ec:	e8 7f 8f ff ff       	call   80100370 <panic>
      panic("copyuvm: page not present");
801073f1:	83 ec 0c             	sub    $0xc,%esp
801073f4:	68 b3 7e 10 80       	push   $0x80107eb3
801073f9:	e8 72 8f ff ff       	call   80100370 <panic>
801073fe:	66 90                	xchg   %ax,%ax

80107400 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107400:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107401:	31 c9                	xor    %ecx,%ecx
{
80107403:	89 e5                	mov    %esp,%ebp
80107405:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107408:	8b 55 0c             	mov    0xc(%ebp),%edx
8010740b:	8b 45 08             	mov    0x8(%ebp),%eax
8010740e:	e8 dd f7 ff ff       	call   80106bf0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107413:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107415:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107416:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107418:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010741d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107420:	05 00 00 00 80       	add    $0x80000000,%eax
80107425:	83 fa 05             	cmp    $0x5,%edx
80107428:	ba 00 00 00 00       	mov    $0x0,%edx
8010742d:	0f 45 c2             	cmovne %edx,%eax
}
80107430:	c3                   	ret    
80107431:	eb 0d                	jmp    80107440 <copyout>
80107433:	90                   	nop
80107434:	90                   	nop
80107435:	90                   	nop
80107436:	90                   	nop
80107437:	90                   	nop
80107438:	90                   	nop
80107439:	90                   	nop
8010743a:	90                   	nop
8010743b:	90                   	nop
8010743c:	90                   	nop
8010743d:	90                   	nop
8010743e:	90                   	nop
8010743f:	90                   	nop

80107440 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
80107449:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010744c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010744f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107452:	85 db                	test   %ebx,%ebx
80107454:	75 40                	jne    80107496 <copyout+0x56>
80107456:	eb 70                	jmp    801074c8 <copyout+0x88>
80107458:	90                   	nop
80107459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107460:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107463:	89 f1                	mov    %esi,%ecx
80107465:	29 d1                	sub    %edx,%ecx
80107467:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010746d:	39 d9                	cmp    %ebx,%ecx
8010746f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107472:	29 f2                	sub    %esi,%edx
80107474:	83 ec 04             	sub    $0x4,%esp
80107477:	01 d0                	add    %edx,%eax
80107479:	51                   	push   %ecx
8010747a:	57                   	push   %edi
8010747b:	50                   	push   %eax
8010747c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010747f:	e8 ec d6 ff ff       	call   80104b70 <memmove>
    len -= n;
    buf += n;
80107484:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107487:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010748a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107490:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107492:	29 cb                	sub    %ecx,%ebx
80107494:	74 32                	je     801074c8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107496:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107498:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010749b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010749e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074a4:	56                   	push   %esi
801074a5:	ff 75 08             	pushl  0x8(%ebp)
801074a8:	e8 53 ff ff ff       	call   80107400 <uva2ka>
    if(pa0 == 0)
801074ad:	83 c4 10             	add    $0x10,%esp
801074b0:	85 c0                	test   %eax,%eax
801074b2:	75 ac                	jne    80107460 <copyout+0x20>
  }
  return 0;
}
801074b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074bc:	5b                   	pop    %ebx
801074bd:	5e                   	pop    %esi
801074be:	5f                   	pop    %edi
801074bf:	5d                   	pop    %ebp
801074c0:	c3                   	ret    
801074c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074cb:	31 c0                	xor    %eax,%eax
}
801074cd:	5b                   	pop    %ebx
801074ce:	5e                   	pop    %esi
801074cf:	5f                   	pop    %edi
801074d0:	5d                   	pop    %ebp
801074d1:	c3                   	ret    
