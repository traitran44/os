
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
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
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
80100046:	68 c0 6e 10 80       	push   $0x80106ec0
8010004b:	68 e0 b5 10 80       	push   $0x8010b5e0
80100050:	e8 2b 42 00 00       	call   80104280 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100055:	83 c4 10             	add    $0x10,%esp
80100058:	b9 e4 f4 10 80       	mov    $0x8010f4e4,%ecx
  bcache.head.prev = &bcache.head;
8010005d:	c7 05 f0 f4 10 80 e4 	movl   $0x8010f4e4,0x8010f4f0
80100064:	f4 10 80 
  bcache.head.next = &bcache.head;
80100067:	c7 05 f4 f4 10 80 e4 	movl   $0x8010f4e4,0x8010f4f4
8010006e:	f4 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100071:	b8 14 b6 10 80       	mov    $0x8010b614,%eax
80100076:	eb 0a                	jmp    80100082 <binit+0x42>
80100078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010007f:	90                   	nop
80100080:	89 d0                	mov    %edx,%eax
    b->next = bcache.head.next;
80100082:	89 48 10             	mov    %ecx,0x10(%eax)
    b->prev = &bcache.head;
80100085:	89 c1                	mov    %eax,%ecx
80100087:	c7 40 0c e4 f4 10 80 	movl   $0x8010f4e4,0xc(%eax)
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
801000af:	75 cf                	jne    80100080 <binit+0x40>
  }
}
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    
801000b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801000c9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000cf:	68 e0 b5 10 80       	push   $0x8010b5e0
801000d4:	e8 c7 41 00 00       	call   801042a0 <acquire>
801000d9:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000dc:	8b 1d f4 f4 10 80    	mov    0x8010f4f4,%ebx
801000e2:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
801000e8:	75 11                	jne    801000fb <bread+0x3b>
801000ea:	eb 3c                	jmp    80100128 <bread+0x68>
801000ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000f0:	8b 5b 10             	mov    0x10(%ebx),%ebx
801000f3:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
801000f9:	74 2d                	je     80100128 <bread+0x68>
    if(b->dev == dev && b->blockno == blockno){
801000fb:	3b 7b 04             	cmp    0x4(%ebx),%edi
801000fe:	75 f0                	jne    801000f0 <bread+0x30>
80100100:	3b 73 08             	cmp    0x8(%ebx),%esi
80100103:	75 eb                	jne    801000f0 <bread+0x30>
      if(!(b->flags & B_BUSY)){
80100105:	8b 03                	mov    (%ebx),%eax
80100107:	a8 01                	test   $0x1,%al
80100109:	0f 84 91 00 00 00    	je     801001a0 <bread+0xe0>
      sleep(b, &bcache.lock);
8010010f:	83 ec 08             	sub    $0x8,%esp
80100112:	68 e0 b5 10 80       	push   $0x8010b5e0
80100117:	53                   	push   %ebx
80100118:	e8 23 3e 00 00       	call   80103f40 <sleep>
8010011d:	83 c4 10             	add    $0x10,%esp
80100120:	eb ba                	jmp    801000dc <bread+0x1c>
80100122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100128:	8b 1d f0 f4 10 80    	mov    0x8010f4f0,%ebx
8010012e:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
80100134:	75 15                	jne    8010014b <bread+0x8b>
80100136:	eb 7f                	jmp    801001b7 <bread+0xf7>
80100138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010013f:	90                   	nop
80100140:	8b 5b 0c             	mov    0xc(%ebx),%ebx
80100143:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
80100149:	74 6c                	je     801001b7 <bread+0xf7>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014b:	f6 03 05             	testb  $0x5,(%ebx)
8010014e:	75 f0                	jne    80100140 <bread+0x80>
      release(&bcache.lock);
80100150:	83 ec 0c             	sub    $0xc,%esp
      b->dev = dev;
80100153:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
80100156:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = B_BUSY;
80100159:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      release(&bcache.lock);
8010015f:	68 e0 b5 10 80       	push   $0x8010b5e0
80100164:	e8 07 43 00 00       	call   80104470 <release>
80100169:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
8010016c:	f6 03 02             	testb  $0x2,(%ebx)
8010016f:	74 0f                	je     80100180 <bread+0xc0>
    iderw(b);
  }
  return b;
}
80100171:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100174:	89 d8                	mov    %ebx,%eax
80100176:	5b                   	pop    %ebx
80100177:	5e                   	pop    %esi
80100178:	5f                   	pop    %edi
80100179:	5d                   	pop    %ebp
8010017a:	c3                   	ret    
8010017b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010017f:	90                   	nop
    iderw(b);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	53                   	push   %ebx
80100184:	e8 87 20 00 00       	call   80102210 <iderw>
80100189:	83 c4 10             	add    $0x10,%esp
}
8010018c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010018f:	89 d8                	mov    %ebx,%eax
80100191:	5b                   	pop    %ebx
80100192:	5e                   	pop    %esi
80100193:	5f                   	pop    %edi
80100194:	5d                   	pop    %ebp
80100195:	c3                   	ret    
80100196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010019d:	8d 76 00             	lea    0x0(%esi),%esi
        release(&bcache.lock);
801001a0:	83 ec 0c             	sub    $0xc,%esp
        b->flags |= B_BUSY;
801001a3:	83 c8 01             	or     $0x1,%eax
801001a6:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
801001a8:	68 e0 b5 10 80       	push   $0x8010b5e0
801001ad:	e8 be 42 00 00       	call   80104470 <release>
801001b2:	83 c4 10             	add    $0x10,%esp
801001b5:	eb b5                	jmp    8010016c <bread+0xac>
  panic("bget: no buffers");
801001b7:	83 ec 0c             	sub    $0xc,%esp
801001ba:	68 c7 6e 10 80       	push   $0x80106ec7
801001bf:	e8 cc 01 00 00       	call   80100390 <panic>
801001c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001cf:	90                   	nop

801001d0 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	83 ec 08             	sub    $0x8,%esp
801001d6:	8b 55 08             	mov    0x8(%ebp),%edx
  if((b->flags & B_BUSY) == 0)
801001d9:	8b 02                	mov    (%edx),%eax
801001db:	a8 01                	test   $0x1,%al
801001dd:	74 0b                	je     801001ea <bwrite+0x1a>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001df:	83 c8 04             	or     $0x4,%eax
801001e2:	89 02                	mov    %eax,(%edx)
  iderw(b);
}
801001e4:	c9                   	leave  
  iderw(b);
801001e5:	e9 26 20 00 00       	jmp    80102210 <iderw>
    panic("bwrite");
801001ea:	83 ec 0c             	sub    $0xc,%esp
801001ed:	68 d8 6e 10 80       	push   $0x80106ed8
801001f2:	e8 99 01 00 00       	call   80100390 <panic>
801001f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001fe:	66 90                	xchg   %ax,%ax

80100200 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100200:	55                   	push   %ebp
80100201:	89 e5                	mov    %esp,%ebp
80100203:	53                   	push   %ebx
80100204:	83 ec 04             	sub    $0x4,%esp
80100207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
8010020a:	f6 03 01             	testb  $0x1,(%ebx)
8010020d:	74 57                	je     80100266 <brelse+0x66>
    panic("brelse");

  acquire(&bcache.lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	68 e0 b5 10 80       	push   $0x8010b5e0
80100217:	e8 84 40 00 00       	call   801042a0 <acquire>

  b->next->prev = b->prev;
8010021c:	8b 53 10             	mov    0x10(%ebx),%edx
8010021f:	8b 43 0c             	mov    0xc(%ebx),%eax
80100222:	89 42 0c             	mov    %eax,0xc(%edx)
  b->prev->next = b->next;
80100225:	8b 53 10             	mov    0x10(%ebx),%edx
80100228:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010022b:	a1 f4 f4 10 80       	mov    0x8010f4f4,%eax
  b->prev = &bcache.head;
80100230:	c7 43 0c e4 f4 10 80 	movl   $0x8010f4e4,0xc(%ebx)
  b->next = bcache.head.next;
80100237:	89 43 10             	mov    %eax,0x10(%ebx)
  bcache.head.next->prev = b;
8010023a:	a1 f4 f4 10 80       	mov    0x8010f4f4,%eax
8010023f:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
80100242:	89 1d f4 f4 10 80    	mov    %ebx,0x8010f4f4

  b->flags &= ~B_BUSY;
80100248:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
8010024b:	89 1c 24             	mov    %ebx,(%esp)
8010024e:	e8 8d 3e 00 00       	call   801040e0 <wakeup>

  release(&bcache.lock);
80100253:	83 c4 10             	add    $0x10,%esp
80100256:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010025d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100260:	c9                   	leave  
  release(&bcache.lock);
80100261:	e9 0a 42 00 00       	jmp    80104470 <release>
    panic("brelse");
80100266:	83 ec 0c             	sub    $0xc,%esp
80100269:	68 df 6e 10 80       	push   $0x80106edf
8010026e:	e8 1d 01 00 00       	call   80100390 <panic>
80100273:	66 90                	xchg   %ax,%ax
80100275:	66 90                	xchg   %ax,%ax
80100277:	66 90                	xchg   %ax,%ax
80100279:	66 90                	xchg   %ax,%ax
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 4c 15 00 00       	call   801017e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029b:	e8 00 40 00 00       	call   801042a0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 80 f7 10 80    	mov    0x8010f780,%edx
801002ba:	39 15 84 f7 10 80    	cmp    %edx,0x8010f784
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 80 f7 10 80       	push   $0x8010f780
801002d5:	e8 66 3c 00 00       	call   80103f40 <sleep>
    while(input.r == input.w){
801002da:	8b 15 80 f7 10 80    	mov    0x8010f780,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 84 f7 10 80    	cmp    0x8010f784,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(proc->killed){
801002eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002f1:	8b 48 24             	mov    0x24(%eax),%ecx
801002f4:	85 c9                	test   %ecx,%ecx
801002f6:	74 d0                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f8:	83 ec 0c             	sub    $0xc,%esp
801002fb:	68 20 a5 10 80       	push   $0x8010a520
80100300:	e8 6b 41 00 00       	call   80104470 <release>
        ilock(ip);
80100305:	5a                   	pop    %edx
80100306:	ff 75 08             	pushl  0x8(%ebp)
80100309:	e8 c2 13 00 00       	call   801016d0 <ilock>
        return -1;
8010030e:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100311:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100319:	5b                   	pop    %ebx
8010031a:	5e                   	pop    %esi
8010031b:	5f                   	pop    %edi
8010031c:	5d                   	pop    %ebp
8010031d:	c3                   	ret    
8010031e:	66 90                	xchg   %ax,%ax
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 80 f7 10 80       	mov    %eax,0x8010f780
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 00 f7 10 80 	movsbl -0x7fef0900(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 20 a5 10 80       	push   $0x8010a520
8010035d:	e8 0e 41 00 00       	call   80104470 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 65 13 00 00       	call   801016d0 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 80 f7 10 80    	mov    %edx,0x8010f780
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100399:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  getcallerpcs(&s, pcs);
8010039f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a2:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cons.locking = 0;
801003a5:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003ac:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
801003af:	0f b6 00             	movzbl (%eax),%eax
801003b2:	50                   	push   %eax
801003b3:	68 e6 6e 10 80       	push   $0x80106ee6
801003b8:	e8 f3 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bd:	58                   	pop    %eax
801003be:	ff 75 08             	pushl  0x8(%ebp)
801003c1:	e8 ea 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c6:	c7 04 24 06 74 10 80 	movl   $0x80107406,(%esp)
801003cd:	e8 de 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	5a                   	pop    %edx
801003d6:	59                   	pop    %ecx
801003d7:	53                   	push   %ebx
801003d8:	50                   	push   %eax
801003d9:	e8 92 3f 00 00       	call   80104370 <getcallerpcs>
  for(i=0; i<10; i++)
801003de:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e1:	83 ec 08             	sub    $0x8,%esp
801003e4:	ff 33                	pushl  (%ebx)
801003e6:	83 c3 04             	add    $0x4,%ebx
801003e9:	68 02 6f 10 80       	push   $0x80106f02
801003ee:	e8 bd 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f3:	83 c4 10             	add    $0x10,%esp
801003f6:	39 f3                	cmp    %esi,%ebx
801003f8:	75 e7                	jne    801003e1 <panic+0x51>
  panicked = 1; // freeze other CPU
801003fa:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100401:	00 00 00 
    ;
80100404:	eb fe                	jmp    80100404 <panic+0x74>
80100406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010040d:	8d 76 00             	lea    0x0(%esi),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 01 57 00 00       	call   80105b30 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004ec:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 16 56 00 00       	call   80105b30 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 0a 56 00 00       	call   80105b30 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 fe 55 00 00       	call   80105b30 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100550:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 fa 3f 00 00       	call   80104560 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 45 3f 00 00       	call   801044c0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 06 6f 10 80       	push   $0x80106f06
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 68                	js     8010061c <printint+0x7c>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	31 db                	xor    %ebx,%ebx
801005ba:	eb 04                	jmp    801005c0 <printint+0x20>
  }while((x /= base) != 0);
801005bc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005be:	89 fb                	mov    %edi,%ebx
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005c7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ca:	0f b6 92 34 6f 10 80 	movzbl -0x7fef90cc(%edx),%edx
801005d1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005d8:	76 e2                	jbe    801005bc <printint+0x1c>
  if(sign)
801005da:	85 f6                	test   %esi,%esi
801005dc:	75 32                	jne    80100610 <printint+0x70>
801005de:	0f be c2             	movsbl %dl,%eax
801005e1:	89 df                	mov    %ebx,%edi
  if(panicked){
801005e3:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801005e9:	85 c9                	test   %ecx,%ecx
801005eb:	75 20                	jne    8010060d <printint+0x6d>
801005ed:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f1:	e8 1a fe ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
801005f6:	8d 45 d7             	lea    -0x29(%ebp),%eax
801005f9:	39 d8                	cmp    %ebx,%eax
801005fb:	74 27                	je     80100624 <printint+0x84>
  if(panicked){
801005fd:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100603:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100606:	83 eb 01             	sub    $0x1,%ebx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 e4                	je     801005f1 <printint+0x51>
  asm volatile("cli");
8010060d:	fa                   	cli    
      ;
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
    buf[i++] = '-';
80100610:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100615:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010061a:	eb c7                	jmp    801005e3 <printint+0x43>
    x = -xx;
8010061c:	f7 d8                	neg    %eax
8010061e:	89 ce                	mov    %ecx,%esi
80100620:	89 c1                	mov    %eax,%ecx
80100622:	eb 94                	jmp    801005b8 <printint+0x18>
}
80100624:	83 c4 2c             	add    $0x2c,%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
80100639:	8b 7d 10             	mov    0x10(%ebp),%edi
8010063c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010063f:	ff 75 08             	pushl  0x8(%ebp)
80100642:	e8 99 11 00 00       	call   801017e0 <iunlock>
  acquire(&cons.lock);
80100647:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064e:	e8 4d 3c 00 00       	call   801042a0 <acquire>
  for(i = 0; i < n; i++)
80100653:	83 c4 10             	add    $0x10,%esp
80100656:	85 ff                	test   %edi,%edi
80100658:	7e 36                	jle    80100690 <consolewrite+0x60>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	75 21                	jne    80100685 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100664:	0f b6 03             	movzbl (%ebx),%eax
80100667:	8d 73 01             	lea    0x1(%ebx),%esi
8010066a:	01 fb                	add    %edi,%ebx
8010066c:	e8 9f fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
80100671:	39 de                	cmp    %ebx,%esi
80100673:	74 1b                	je     80100690 <consolewrite+0x60>
  if(panicked){
80100675:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010067b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010067e:	83 c6 01             	add    $0x1,%esi
80100681:	85 d2                	test   %edx,%edx
80100683:	74 e7                	je     8010066c <consolewrite+0x3c>
80100685:	fa                   	cli    
      ;
80100686:	eb fe                	jmp    80100686 <consolewrite+0x56>
80100688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010068f:	90                   	nop
  release(&cons.lock);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 20 a5 10 80       	push   $0x8010a520
80100698:	e8 d3 3d 00 00       	call   80104470 <release>
  ilock(ip);
8010069d:	58                   	pop    %eax
8010069e:	ff 75 08             	pushl  0x8(%ebp)
801006a1:	e8 2a 10 00 00       	call   801016d0 <ilock>

  return n;
}
801006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a9:	89 f8                	mov    %edi,%eax
801006ab:	5b                   	pop    %ebx
801006ac:	5e                   	pop    %esi
801006ad:	5f                   	pop    %edi
801006ae:	5d                   	pop    %ebp
801006af:	c3                   	ret    

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c1:	85 c0                	test   %eax,%eax
801006c3:	0f 85 df 00 00 00    	jne    801007a8 <cprintf+0xf8>
  if (fmt == 0)
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cf:	85 c0                	test   %eax,%eax
801006d1:	0f 84 5e 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 00             	movzbl (%eax),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 32                	je     80100710 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006de:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	74 40                	je     80100728 <cprintf+0x78>
  if(panicked){
801006e8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006ee:	85 c9                	test   %ecx,%ecx
801006f0:	74 0b                	je     801006fd <cprintf+0x4d>
801006f2:	fa                   	cli    
      ;
801006f3:	eb fe                	jmp    801006f3 <cprintf+0x43>
801006f5:	8d 76 00             	lea    0x0(%esi),%esi
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	e8 0e fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100705:	83 c6 01             	add    $0x1,%esi
80100708:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	75 d3                	jne    801006e3 <cprintf+0x33>
  if(locking)
80100710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100713:	85 db                	test   %ebx,%ebx
80100715:	0f 85 05 01 00 00    	jne    80100820 <cprintf+0x170>
}
8010071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100727:	90                   	nop
    c = fmt[++i] & 0xff;
80100728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072b:	83 c6 01             	add    $0x1,%esi
8010072e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100732:	85 ff                	test   %edi,%edi
80100734:	74 da                	je     80100710 <cprintf+0x60>
    switch(c){
80100736:	83 ff 70             	cmp    $0x70,%edi
80100739:	0f 84 7e 00 00 00    	je     801007bd <cprintf+0x10d>
8010073f:	7f 26                	jg     80100767 <cprintf+0xb7>
80100741:	83 ff 25             	cmp    $0x25,%edi
80100744:	0f 84 be 00 00 00    	je     80100808 <cprintf+0x158>
8010074a:	83 ff 64             	cmp    $0x64,%edi
8010074d:	75 46                	jne    80100795 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010074f:	8b 03                	mov    (%ebx),%eax
80100751:	8d 7b 04             	lea    0x4(%ebx),%edi
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 fb                	mov    %edi,%ebx
80100760:	e8 3b fe ff ff       	call   801005a0 <printint>
      break;
80100765:	eb 9b                	jmp    80100702 <cprintf+0x52>
    switch(c){
80100767:	83 ff 73             	cmp    $0x73,%edi
8010076a:	75 24                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010076c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010076f:	8b 1b                	mov    (%ebx),%ebx
80100771:	85 db                	test   %ebx,%ebx
80100773:	75 68                	jne    801007dd <cprintf+0x12d>
80100775:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010077a:	bb 19 6f 10 80       	mov    $0x80106f19,%ebx
  if(panicked){
8010077f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 4c                	je     801007d5 <cprintf+0x125>
80100789:	fa                   	cli    
      ;
8010078a:	eb fe                	jmp    8010078a <cprintf+0xda>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 ff 78             	cmp    $0x78,%edi
80100793:	74 28                	je     801007bd <cprintf+0x10d>
  if(panicked){
80100795:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010079b:	85 d2                	test   %edx,%edx
8010079d:	74 4c                	je     801007eb <cprintf+0x13b>
8010079f:	fa                   	cli    
      ;
801007a0:	eb fe                	jmp    801007a0 <cprintf+0xf0>
801007a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	68 20 a5 10 80       	push   $0x8010a520
801007b0:	e8 eb 3a 00 00       	call   801042a0 <acquire>
801007b5:	83 c4 10             	add    $0x10,%esp
801007b8:	e9 0c ff ff ff       	jmp    801006c9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007bd:	8b 03                	mov    (%ebx),%eax
801007bf:	8d 7b 04             	lea    0x4(%ebx),%edi
801007c2:	31 c9                	xor    %ecx,%ecx
801007c4:	ba 10 00 00 00       	mov    $0x10,%edx
801007c9:	89 fb                	mov    %edi,%ebx
801007cb:	e8 d0 fd ff ff       	call   801005a0 <printint>
      break;
801007d0:	e9 2d ff ff ff       	jmp    80100702 <cprintf+0x52>
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007da:	83 c3 01             	add    $0x1,%ebx
801007dd:	0f be 03             	movsbl (%ebx),%eax
801007e0:	84 c0                	test   %al,%al
801007e2:	75 9b                	jne    8010077f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007e4:	89 fb                	mov    %edi,%ebx
801007e6:	e9 17 ff ff ff       	jmp    80100702 <cprintf+0x52>
801007eb:	b8 25 00 00 00       	mov    $0x25,%eax
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
801007f5:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801007fa:	85 c0                	test   %eax,%eax
801007fc:	74 4a                	je     80100848 <cprintf+0x198>
801007fe:	fa                   	cli    
      ;
801007ff:	eb fe                	jmp    801007ff <cprintf+0x14f>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100808:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	0f 84 e2 fe ff ff    	je     801006f8 <cprintf+0x48>
80100816:	fa                   	cli    
      ;
80100817:	eb fe                	jmp    80100817 <cprintf+0x167>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 43 3c 00 00       	call   80104470 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 20 6f 10 80       	push   $0x80106f20
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 ae fe ff ff       	jmp    80100702 <cprintf+0x52>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
  int c, doprocdump = 0;
80100865:	31 f6                	xor    %esi,%esi
{
80100867:	53                   	push   %ebx
80100868:	83 ec 18             	sub    $0x18,%esp
8010086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 28 3a 00 00       	call   801042a0 <acquire>
  while((c = getc()) >= 0){
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	ff d7                	call   *%edi
8010087d:	89 c3                	mov    %eax,%ebx
8010087f:	85 c0                	test   %eax,%eax
80100881:	0f 88 38 01 00 00    	js     801009bf <consoleintr+0x15f>
    switch(c){
80100887:	83 fb 10             	cmp    $0x10,%ebx
8010088a:	0f 84 f0 00 00 00    	je     80100980 <consoleintr+0x120>
80100890:	0f 8e ba 00 00 00    	jle    80100950 <consoleintr+0xf0>
80100896:	83 fb 15             	cmp    $0x15,%ebx
80100899:	75 35                	jne    801008d0 <consoleintr+0x70>
      while(input.e != input.w &&
8010089b:	a1 88 f7 10 80       	mov    0x8010f788,%eax
801008a0:	39 05 84 f7 10 80    	cmp    %eax,0x8010f784
801008a6:	74 d3                	je     8010087b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008a8:	83 e8 01             	sub    $0x1,%eax
801008ab:	89 c2                	mov    %eax,%edx
801008ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b0:	80 ba 00 f7 10 80 0a 	cmpb   $0xa,-0x7fef0900(%edx)
801008b7:	74 c2                	je     8010087b <consoleintr+0x1b>
  if(panicked){
801008b9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008bf:	a3 88 f7 10 80       	mov    %eax,0x8010f788
  if(panicked){
801008c4:	85 d2                	test   %edx,%edx
801008c6:	0f 84 be 00 00 00    	je     8010098a <consoleintr+0x12a>
801008cc:	fa                   	cli    
      ;
801008cd:	eb fe                	jmp    801008cd <consoleintr+0x6d>
801008cf:	90                   	nop
    switch(c){
801008d0:	83 fb 7f             	cmp    $0x7f,%ebx
801008d3:	0f 84 7c 00 00 00    	je     80100955 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d9:	85 db                	test   %ebx,%ebx
801008db:	74 9e                	je     8010087b <consoleintr+0x1b>
801008dd:	a1 88 f7 10 80       	mov    0x8010f788,%eax
801008e2:	89 c2                	mov    %eax,%edx
801008e4:	2b 15 80 f7 10 80    	sub    0x8010f780,%edx
801008ea:	83 fa 7f             	cmp    $0x7f,%edx
801008ed:	77 8c                	ja     8010087b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
801008ef:	8d 48 01             	lea    0x1(%eax),%ecx
801008f2:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008f8:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008fb:	89 0d 88 f7 10 80    	mov    %ecx,0x8010f788
        c = (c == '\r') ? '\n' : c;
80100901:	83 fb 0d             	cmp    $0xd,%ebx
80100904:	0f 84 d1 00 00 00    	je     801009db <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090a:	88 98 00 f7 10 80    	mov    %bl,-0x7fef0900(%eax)
  if(panicked){
80100910:	85 d2                	test   %edx,%edx
80100912:	0f 85 ce 00 00 00    	jne    801009e6 <consoleintr+0x186>
80100918:	89 d8                	mov    %ebx,%eax
8010091a:	e8 f1 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091f:	83 fb 0a             	cmp    $0xa,%ebx
80100922:	0f 84 d2 00 00 00    	je     801009fa <consoleintr+0x19a>
80100928:	83 fb 04             	cmp    $0x4,%ebx
8010092b:	0f 84 c9 00 00 00    	je     801009fa <consoleintr+0x19a>
80100931:	a1 80 f7 10 80       	mov    0x8010f780,%eax
80100936:	83 e8 80             	sub    $0xffffff80,%eax
80100939:	39 05 88 f7 10 80    	cmp    %eax,0x8010f788
8010093f:	0f 85 36 ff ff ff    	jne    8010087b <consoleintr+0x1b>
80100945:	e9 b5 00 00 00       	jmp    801009ff <consoleintr+0x19f>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100950:	83 fb 08             	cmp    $0x8,%ebx
80100953:	75 84                	jne    801008d9 <consoleintr+0x79>
      if(input.e != input.w){
80100955:	a1 88 f7 10 80       	mov    0x8010f788,%eax
8010095a:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
80100960:	0f 84 15 ff ff ff    	je     8010087b <consoleintr+0x1b>
        input.e--;
80100966:	83 e8 01             	sub    $0x1,%eax
80100969:	a3 88 f7 10 80       	mov    %eax,0x8010f788
  if(panicked){
8010096e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100973:	85 c0                	test   %eax,%eax
80100975:	74 39                	je     801009b0 <consoleintr+0x150>
80100977:	fa                   	cli    
      ;
80100978:	eb fe                	jmp    80100978 <consoleintr+0x118>
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
80100980:	be 01 00 00 00       	mov    $0x1,%esi
80100985:	e9 f1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
8010098a:	b8 00 01 00 00       	mov    $0x100,%eax
8010098f:	e8 7c fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100994:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100999:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
8010099f:	0f 85 03 ff ff ff    	jne    801008a8 <consoleintr+0x48>
801009a5:	e9 d1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 56 fa ff ff       	call   80100410 <consputc.part.0>
801009ba:	e9 bc fe ff ff       	jmp    8010087b <consoleintr+0x1b>
  release(&cons.lock);
801009bf:	83 ec 0c             	sub    $0xc,%esp
801009c2:	68 20 a5 10 80       	push   $0x8010a520
801009c7:	e8 a4 3a 00 00       	call   80104470 <release>
  if(doprocdump) {
801009cc:	83 c4 10             	add    $0x10,%esp
801009cf:	85 f6                	test   %esi,%esi
801009d1:	75 46                	jne    80100a19 <consoleintr+0x1b9>
}
801009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009d6:	5b                   	pop    %ebx
801009d7:	5e                   	pop    %esi
801009d8:	5f                   	pop    %edi
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009db:	c6 80 00 f7 10 80 0a 	movb   $0xa,-0x7fef0900(%eax)
  if(panicked){
801009e2:	85 d2                	test   %edx,%edx
801009e4:	74 0a                	je     801009f0 <consoleintr+0x190>
801009e6:	fa                   	cli    
      ;
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x187>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f5:	e8 16 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fa:	a1 88 f7 10 80       	mov    0x8010f788,%eax
          wakeup(&input.r);
801009ff:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a02:	a3 84 f7 10 80       	mov    %eax,0x8010f784
          wakeup(&input.r);
80100a07:	68 80 f7 10 80       	push   $0x8010f780
80100a0c:	e8 cf 36 00 00       	call   801040e0 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 9b 37 00 00       	jmp    801041c0 <procdump>
80100a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 29 6f 10 80       	push   $0x80106f29
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 3b 38 00 00       	call   80104280 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
80100a45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100a4c:	c7 05 4c 01 11 80 30 	movl   $0x80100630,0x8011014c
80100a53:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a56:	c7 05 48 01 11 80 80 	movl   $0x80100280,0x80110148
80100a5d:	02 10 80 
  cons.locking = 1;
80100a60:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a67:	00 00 00 
  picenable(IRQ_KBD);
80100a6a:	e8 b1 29 00 00       	call   80103420 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100a6f:	58                   	pop    %eax
80100a70:	5a                   	pop    %edx
80100a71:	6a 00                	push   $0x0
80100a73:	6a 01                	push   $0x1
80100a75:	e8 56 19 00 00       	call   801023d0 <ioapicenable>
}
80100a7a:	83 c4 10             	add    $0x10,%esp
80100a7d:	c9                   	leave  
80100a7e:	c3                   	ret    
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100a8c:	e8 af 22 00 00       	call   80102d40 <begin_op>
  if((ip = namei(path)) == 0){
80100a91:	83 ec 0c             	sub    $0xc,%esp
80100a94:	ff 75 08             	pushl  0x8(%ebp)
80100a97:	e8 24 15 00 00       	call   80101fc0 <namei>
80100a9c:	83 c4 10             	add    $0x10,%esp
80100a9f:	85 c0                	test   %eax,%eax
80100aa1:	0f 84 03 03 00 00    	je     80100daa <exec+0x32a>
    end_op();
    return -1;
  }
  ilock(ip);
80100aa7:	83 ec 0c             	sub    $0xc,%esp
80100aaa:	89 c3                	mov    %eax,%ebx
80100aac:	50                   	push   %eax
80100aad:	e8 1e 0c 00 00       	call   801016d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100ab2:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ab8:	6a 34                	push   $0x34
80100aba:	6a 00                	push   $0x0
80100abc:	50                   	push   %eax
80100abd:	53                   	push   %ebx
80100abe:	e8 3d 0f 00 00       	call   80101a00 <readi>
80100ac3:	83 c4 20             	add    $0x20,%esp
80100ac6:	83 f8 33             	cmp    $0x33,%eax
80100ac9:	76 0c                	jbe    80100ad7 <exec+0x57>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100acb:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100ad2:	45 4c 46 
80100ad5:	74 21                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad7:	83 ec 0c             	sub    $0xc,%esp
80100ada:	53                   	push   %ebx
80100adb:	e8 d0 0e 00 00       	call   801019b0 <iunlockput>
    end_op();
80100ae0:	e8 cb 22 00 00       	call   80102db0 <end_op>
80100ae5:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af0:	5b                   	pop    %ebx
80100af1:	5e                   	pop    %esi
80100af2:	5f                   	pop    %edi
80100af3:	5d                   	pop    %ebp
80100af4:	c3                   	ret    
80100af5:	8d 76 00             	lea    0x0(%esi),%esi
  if((pgdir = setupkvm()) == 0)
80100af8:	e8 83 5d 00 00       	call   80106880 <setupkvm>
80100afd:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b03:	85 c0                	test   %eax,%eax
80100b05:	74 d0                	je     80100ad7 <exec+0x57>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b07:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b0e:	00 
80100b0f:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b15:	0f 84 9e 02 00 00    	je     80100db9 <exec+0x339>
  sz = 0;
80100b1b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b22:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b25:	31 ff                	xor    %edi,%edi
80100b27:	e9 8a 00 00 00       	jmp    80100bb6 <exec+0x136>
80100b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100b30:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b37:	75 6c                	jne    80100ba5 <exec+0x125>
    if(ph.memsz < ph.filesz)
80100b39:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b3f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b45:	0f 82 87 00 00 00    	jb     80100bd2 <exec+0x152>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b4b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b51:	72 7f                	jb     80100bd2 <exec+0x152>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b53:	83 ec 04             	sub    $0x4,%esp
80100b56:	50                   	push   %eax
80100b57:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b5d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b63:	e8 98 5f 00 00       	call   80106b00 <allocuvm>
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b71:	85 c0                	test   %eax,%eax
80100b73:	74 5d                	je     80100bd2 <exec+0x152>
    if(ph.vaddr % PGSIZE != 0)
80100b75:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b7b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b80:	75 50                	jne    80100bd2 <exec+0x152>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b82:	83 ec 0c             	sub    $0xc,%esp
80100b85:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b8b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b91:	53                   	push   %ebx
80100b92:	50                   	push   %eax
80100b93:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b99:	e8 a2 5e 00 00       	call   80106a40 <loaduvm>
80100b9e:	83 c4 20             	add    $0x20,%esp
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	78 2d                	js     80100bd2 <exec+0x152>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bac:	83 c7 01             	add    $0x1,%edi
80100baf:	83 c6 20             	add    $0x20,%esi
80100bb2:	39 f8                	cmp    %edi,%eax
80100bb4:	7e 3a                	jle    80100bf0 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bb6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bbc:	6a 20                	push   $0x20
80100bbe:	56                   	push   %esi
80100bbf:	50                   	push   %eax
80100bc0:	53                   	push   %ebx
80100bc1:	e8 3a 0e 00 00       	call   80101a00 <readi>
80100bc6:	83 c4 10             	add    $0x10,%esp
80100bc9:	83 f8 20             	cmp    $0x20,%eax
80100bcc:	0f 84 5e ff ff ff    	je     80100b30 <exec+0xb0>
    freevm(pgdir);
80100bd2:	83 ec 0c             	sub    $0xc,%esp
80100bd5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bdb:	e8 80 60 00 00       	call   80106c60 <freevm>
  if(ip){
80100be0:	83 c4 10             	add    $0x10,%esp
80100be3:	e9 ef fe ff ff       	jmp    80100ad7 <exec+0x57>
80100be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bef:	90                   	nop
80100bf0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100bf6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100bfc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c02:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c08:	83 ec 0c             	sub    $0xc,%esp
80100c0b:	53                   	push   %ebx
80100c0c:	e8 9f 0d 00 00       	call   801019b0 <iunlockput>
  end_op();
80100c11:	e8 9a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c16:	83 c4 0c             	add    $0xc,%esp
80100c19:	56                   	push   %esi
80100c1a:	57                   	push   %edi
80100c1b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c21:	57                   	push   %edi
80100c22:	e8 d9 5e 00 00       	call   80106b00 <allocuvm>
80100c27:	83 c4 10             	add    $0x10,%esp
80100c2a:	89 c6                	mov    %eax,%esi
80100c2c:	85 c0                	test   %eax,%eax
80100c2e:	0f 84 94 00 00 00    	je     80100cc8 <exec+0x248>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c34:	83 ec 08             	sub    $0x8,%esp
80100c37:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c3f:	50                   	push   %eax
80100c40:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c41:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c43:	e8 98 60 00 00       	call   80106ce0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c48:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4b:	83 c4 10             	add    $0x10,%esp
80100c4e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c54:	8b 00                	mov    (%eax),%eax
80100c56:	85 c0                	test   %eax,%eax
80100c58:	0f 84 8b 00 00 00    	je     80100ce9 <exec+0x269>
80100c5e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c64:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c6a:	eb 23                	jmp    80100c8f <exec+0x20f>
80100c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c70:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c73:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c7a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c83:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c86:	85 c0                	test   %eax,%eax
80100c88:	74 59                	je     80100ce3 <exec+0x263>
    if(argc >= MAXARG)
80100c8a:	83 ff 20             	cmp    $0x20,%edi
80100c8d:	74 39                	je     80100cc8 <exec+0x248>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c8f:	83 ec 0c             	sub    $0xc,%esp
80100c92:	50                   	push   %eax
80100c93:	e8 38 3a 00 00       	call   801046d0 <strlen>
80100c98:	f7 d0                	not    %eax
80100c9a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c9c:	58                   	pop    %eax
80100c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ca6:	e8 25 3a 00 00       	call   801046d0 <strlen>
80100cab:	83 c0 01             	add    $0x1,%eax
80100cae:	50                   	push   %eax
80100caf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb5:	53                   	push   %ebx
80100cb6:	56                   	push   %esi
80100cb7:	e8 74 61 00 00       	call   80106e30 <copyout>
80100cbc:	83 c4 20             	add    $0x20,%esp
80100cbf:	85 c0                	test   %eax,%eax
80100cc1:	79 ad                	jns    80100c70 <exec+0x1f0>
80100cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cc7:	90                   	nop
    freevm(pgdir);
80100cc8:	83 ec 0c             	sub    $0xc,%esp
80100ccb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cd1:	e8 8a 5f 00 00       	call   80106c60 <freevm>
80100cd6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cde:	e9 0a fe ff ff       	jmp    80100aed <exec+0x6d>
80100ce3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ce9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cf0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cf2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cf9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cfd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cff:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d02:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d08:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d0a:	50                   	push   %eax
80100d0b:	52                   	push   %edx
80100d0c:	53                   	push   %ebx
80100d0d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d13:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d1a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d1d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d23:	e8 08 61 00 00       	call   80106e30 <copyout>
80100d28:	83 c4 10             	add    $0x10,%esp
80100d2b:	85 c0                	test   %eax,%eax
80100d2d:	78 99                	js     80100cc8 <exec+0x248>
  for(last=s=path; *s; s++)
80100d2f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d32:	8b 55 08             	mov    0x8(%ebp),%edx
80100d35:	0f b6 00             	movzbl (%eax),%eax
80100d38:	84 c0                	test   %al,%al
80100d3a:	74 13                	je     80100d4f <exec+0x2cf>
80100d3c:	89 d1                	mov    %edx,%ecx
80100d3e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d40:	83 c1 01             	add    $0x1,%ecx
80100d43:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d45:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d48:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d4b:	84 c0                	test   %al,%al
80100d4d:	75 f1                	jne    80100d40 <exec+0x2c0>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100d4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d55:	83 ec 04             	sub    $0x4,%esp
80100d58:	6a 10                	push   $0x10
80100d5a:	83 c0 6c             	add    $0x6c,%eax
80100d5d:	52                   	push   %edx
80100d5e:	50                   	push   %eax
80100d5f:	e8 2c 39 00 00       	call   80104690 <safestrcpy>
  oldpgdir = proc->pgdir;
80100d64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100d6a:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = proc->pgdir;
80100d70:	8b 78 04             	mov    0x4(%eax),%edi
  proc->sz = sz;
80100d73:	89 30                	mov    %esi,(%eax)
  proc->pgdir = pgdir;
80100d75:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->tf->eip = elf.entry;  // main
80100d78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d7e:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d84:	8b 50 18             	mov    0x18(%eax),%edx
80100d87:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d8a:	8b 50 18             	mov    0x18(%eax),%edx
80100d8d:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d90:	89 04 24             	mov    %eax,(%esp)
80100d93:	e8 88 5b 00 00       	call   80106920 <switchuvm>
  freevm(oldpgdir);
80100d98:	89 3c 24             	mov    %edi,(%esp)
80100d9b:	e8 c0 5e 00 00       	call   80106c60 <freevm>
  return 0;
80100da0:	83 c4 10             	add    $0x10,%esp
80100da3:	31 c0                	xor    %eax,%eax
80100da5:	e9 43 fd ff ff       	jmp    80100aed <exec+0x6d>
    end_op();
80100daa:	e8 01 20 00 00       	call   80102db0 <end_op>
    return -1;
80100daf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100db4:	e9 34 fd ff ff       	jmp    80100aed <exec+0x6d>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100db9:	31 ff                	xor    %edi,%edi
80100dbb:	be 00 20 00 00       	mov    $0x2000,%esi
80100dc0:	e9 43 fe ff ff       	jmp    80100c08 <exec+0x188>
80100dc5:	66 90                	xchg   %ax,%ax
80100dc7:	66 90                	xchg   %ax,%ax
80100dc9:	66 90                	xchg   %ax,%ax
80100dcb:	66 90                	xchg   %ax,%ax
80100dcd:	66 90                	xchg   %ax,%ax
80100dcf:	90                   	nop

80100dd0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dd6:	68 45 6f 10 80       	push   $0x80106f45
80100ddb:	68 a0 f7 10 80       	push   $0x8010f7a0
80100de0:	e8 9b 34 00 00       	call   80104280 <initlock>
}
80100de5:	83 c4 10             	add    $0x10,%esp
80100de8:	c9                   	leave  
80100de9:	c3                   	ret    
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100df0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100df4:	bb d4 f7 10 80       	mov    $0x8010f7d4,%ebx
{
80100df9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dfc:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e01:	e8 9a 34 00 00       	call   801042a0 <acquire>
80100e06:	83 c4 10             	add    $0x10,%esp
80100e09:	eb 10                	jmp    80100e1b <filealloc+0x2b>
80100e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e0f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e10:	83 c3 18             	add    $0x18,%ebx
80100e13:	81 fb 34 01 11 80    	cmp    $0x80110134,%ebx
80100e19:	74 25                	je     80100e40 <filealloc+0x50>
    if(f->ref == 0){
80100e1b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e1e:	85 c0                	test   %eax,%eax
80100e20:	75 ee                	jne    80100e10 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e22:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e25:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e2c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e31:	e8 3a 36 00 00       	call   80104470 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e36:	89 d8                	mov    %ebx,%eax
      return f;
80100e38:	83 c4 10             	add    $0x10,%esp
}
80100e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e3e:	c9                   	leave  
80100e3f:	c3                   	ret    
  release(&ftable.lock);
80100e40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e43:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e45:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e4a:	e8 21 36 00 00       	call   80104470 <release>
}
80100e4f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e51:	83 c4 10             	add    $0x10,%esp
}
80100e54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e57:	c9                   	leave  
80100e58:	c3                   	ret    
80100e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	53                   	push   %ebx
80100e64:	83 ec 10             	sub    $0x10,%esp
80100e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e6a:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e6f:	e8 2c 34 00 00       	call   801042a0 <acquire>
  if(f->ref < 1)
80100e74:	8b 43 04             	mov    0x4(%ebx),%eax
80100e77:	83 c4 10             	add    $0x10,%esp
80100e7a:	85 c0                	test   %eax,%eax
80100e7c:	7e 1a                	jle    80100e98 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e7e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e81:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e84:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e87:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e8c:	e8 df 35 00 00       	call   80104470 <release>
  return f;
}
80100e91:	89 d8                	mov    %ebx,%eax
80100e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e96:	c9                   	leave  
80100e97:	c3                   	ret    
    panic("filedup");
80100e98:	83 ec 0c             	sub    $0xc,%esp
80100e9b:	68 4c 6f 10 80       	push   $0x80106f4c
80100ea0:	e8 eb f4 ff ff       	call   80100390 <panic>
80100ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	57                   	push   %edi
80100eb4:	56                   	push   %esi
80100eb5:	53                   	push   %ebx
80100eb6:	83 ec 28             	sub    $0x28,%esp
80100eb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ebc:	68 a0 f7 10 80       	push   $0x8010f7a0
80100ec1:	e8 da 33 00 00       	call   801042a0 <acquire>
  if(f->ref < 1)
80100ec6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec9:	83 c4 10             	add    $0x10,%esp
80100ecc:	85 c0                	test   %eax,%eax
80100ece:	0f 8e a3 00 00 00    	jle    80100f77 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100ed4:	83 e8 01             	sub    $0x1,%eax
80100ed7:	89 43 04             	mov    %eax,0x4(%ebx)
80100eda:	75 44                	jne    80100f20 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100edc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ee0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ee3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ee5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eeb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100eee:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ef1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ef4:	68 a0 f7 10 80       	push   $0x8010f7a0
  ff = *f;
80100ef9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100efc:	e8 6f 35 00 00       	call   80104470 <release>

  if(ff.type == FD_PIPE)
80100f01:	83 c4 10             	add    $0x10,%esp
80100f04:	83 ff 01             	cmp    $0x1,%edi
80100f07:	74 2f                	je     80100f38 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f09:	83 ff 02             	cmp    $0x2,%edi
80100f0c:	74 4a                	je     80100f58 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f11:	5b                   	pop    %ebx
80100f12:	5e                   	pop    %esi
80100f13:	5f                   	pop    %edi
80100f14:	5d                   	pop    %ebp
80100f15:	c3                   	ret    
80100f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f1d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f20:	c7 45 08 a0 f7 10 80 	movl   $0x8010f7a0,0x8(%ebp)
}
80100f27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f2a:	5b                   	pop    %ebx
80100f2b:	5e                   	pop    %esi
80100f2c:	5f                   	pop    %edi
80100f2d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f2e:	e9 3d 35 00 00       	jmp    80104470 <release>
80100f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f37:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100f38:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f3c:	83 ec 08             	sub    $0x8,%esp
80100f3f:	53                   	push   %ebx
80100f40:	56                   	push   %esi
80100f41:	e8 aa 26 00 00       	call   801035f0 <pipeclose>
80100f46:	83 c4 10             	add    $0x10,%esp
}
80100f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4c:	5b                   	pop    %ebx
80100f4d:	5e                   	pop    %esi
80100f4e:	5f                   	pop    %edi
80100f4f:	5d                   	pop    %ebp
80100f50:	c3                   	ret    
80100f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f58:	e8 e3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 d8 08 00 00       	call   80101840 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 39 1e 00 00       	jmp    80102db0 <end_op>
    panic("fileclose");
80100f77:	83 ec 0c             	sub    $0xc,%esp
80100f7a:	68 54 6f 10 80       	push   $0x80106f54
80100f7f:	e8 0c f4 ff ff       	call   80100390 <panic>
80100f84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f8f:	90                   	nop

80100f90 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	53                   	push   %ebx
80100f94:	83 ec 04             	sub    $0x4,%esp
80100f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f9a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f9d:	75 31                	jne    80100fd0 <filestat+0x40>
    ilock(f->ip);
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	ff 73 10             	pushl  0x10(%ebx)
80100fa5:	e8 26 07 00 00       	call   801016d0 <ilock>
    stati(f->ip, st);
80100faa:	58                   	pop    %eax
80100fab:	5a                   	pop    %edx
80100fac:	ff 75 0c             	pushl  0xc(%ebp)
80100faf:	ff 73 10             	pushl  0x10(%ebx)
80100fb2:	e8 19 0a 00 00       	call   801019d0 <stati>
    iunlock(f->ip);
80100fb7:	59                   	pop    %ecx
80100fb8:	ff 73 10             	pushl  0x10(%ebx)
80100fbb:	e8 20 08 00 00       	call   801017e0 <iunlock>
    return 0;
80100fc0:	83 c4 10             	add    $0x10,%esp
80100fc3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc8:	c9                   	leave  
80100fc9:	c3                   	ret    
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100fe0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 0c             	sub    $0xc,%esp
80100fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fec:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fef:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100ff2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100ff6:	74 60                	je     80101058 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100ff8:	8b 03                	mov    (%ebx),%eax
80100ffa:	83 f8 01             	cmp    $0x1,%eax
80100ffd:	74 41                	je     80101040 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fff:	83 f8 02             	cmp    $0x2,%eax
80101002:	75 5b                	jne    8010105f <fileread+0x7f>
    ilock(f->ip);
80101004:	83 ec 0c             	sub    $0xc,%esp
80101007:	ff 73 10             	pushl  0x10(%ebx)
8010100a:	e8 c1 06 00 00       	call   801016d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010100f:	57                   	push   %edi
80101010:	ff 73 14             	pushl  0x14(%ebx)
80101013:	56                   	push   %esi
80101014:	ff 73 10             	pushl  0x10(%ebx)
80101017:	e8 e4 09 00 00       	call   80101a00 <readi>
8010101c:	83 c4 20             	add    $0x20,%esp
8010101f:	89 c6                	mov    %eax,%esi
80101021:	85 c0                	test   %eax,%eax
80101023:	7e 03                	jle    80101028 <fileread+0x48>
      f->off += r;
80101025:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 ad 07 00 00       	call   801017e0 <iunlock>
    return r;
80101033:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101039:	89 f0                	mov    %esi,%eax
8010103b:	5b                   	pop    %ebx
8010103c:	5e                   	pop    %esi
8010103d:	5f                   	pop    %edi
8010103e:	5d                   	pop    %ebp
8010103f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101040:	8b 43 0c             	mov    0xc(%ebx),%eax
80101043:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	5b                   	pop    %ebx
8010104a:	5e                   	pop    %esi
8010104b:	5f                   	pop    %edi
8010104c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010104d:	e9 6e 27 00 00       	jmp    801037c0 <piperead>
80101052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101058:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010105d:	eb d7                	jmp    80101036 <fileread+0x56>
  panic("fileread");
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	68 5e 6f 10 80       	push   $0x80106f5e
80101067:	e8 24 f3 ff ff       	call   80100390 <panic>
8010106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101070 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 1c             	sub    $0x1c,%esp
80101079:	8b 45 0c             	mov    0xc(%ebp),%eax
8010107c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101082:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101085:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101089:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010108c:	0f 84 bb 00 00 00    	je     8010114d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101092:	8b 03                	mov    (%ebx),%eax
80101094:	83 f8 01             	cmp    $0x1,%eax
80101097:	0f 84 bf 00 00 00    	je     8010115c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010109d:	83 f8 02             	cmp    $0x2,%eax
801010a0:	0f 85 c8 00 00 00    	jne    8010116e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010a9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010ab:	85 c0                	test   %eax,%eax
801010ad:	7f 30                	jg     801010df <filewrite+0x6f>
801010af:	e9 94 00 00 00       	jmp    80101148 <filewrite+0xd8>
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010b8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	ff 73 10             	pushl  0x10(%ebx)
        f->off += r;
801010c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010c4:	e8 17 07 00 00       	call   801017e0 <iunlock>
      end_op();
801010c9:	e8 e2 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d1:	83 c4 10             	add    $0x10,%esp
801010d4:	39 f0                	cmp    %esi,%eax
801010d6:	75 60                	jne    80101138 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010d8:	01 c7                	add    %eax,%edi
    while(i < n){
801010da:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010dd:	7e 69                	jle    80101148 <filewrite+0xd8>
      int n1 = n - i;
801010df:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801010e2:	b8 00 1a 00 00       	mov    $0x1a00,%eax
801010e7:	29 fe                	sub    %edi,%esi
      if(n1 > max)
801010e9:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
801010ef:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
801010f2:	e8 49 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
801010f7:	83 ec 0c             	sub    $0xc,%esp
801010fa:	ff 73 10             	pushl  0x10(%ebx)
801010fd:	e8 ce 05 00 00       	call   801016d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101102:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101105:	56                   	push   %esi
80101106:	ff 73 14             	pushl  0x14(%ebx)
80101109:	01 f8                	add    %edi,%eax
8010110b:	50                   	push   %eax
8010110c:	ff 73 10             	pushl  0x10(%ebx)
8010110f:	e8 ec 09 00 00       	call   80101b00 <writei>
80101114:	83 c4 20             	add    $0x20,%esp
80101117:	85 c0                	test   %eax,%eax
80101119:	7f 9d                	jg     801010b8 <filewrite+0x48>
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	ff 73 10             	pushl  0x10(%ebx)
80101121:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101124:	e8 b7 06 00 00       	call   801017e0 <iunlock>
      end_op();
80101129:	e8 82 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
8010112e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	85 c0                	test   %eax,%eax
80101136:	75 15                	jne    8010114d <filewrite+0xdd>
        panic("short filewrite");
80101138:	83 ec 0c             	sub    $0xc,%esp
8010113b:	68 67 6f 10 80       	push   $0x80106f67
80101140:	e8 4b f2 ff ff       	call   80100390 <panic>
80101145:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101148:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010114b:	74 05                	je     80101152 <filewrite+0xe2>
8010114d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101152:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101155:	89 f8                	mov    %edi,%eax
80101157:	5b                   	pop    %ebx
80101158:	5e                   	pop    %esi
80101159:	5f                   	pop    %edi
8010115a:	5d                   	pop    %ebp
8010115b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010115c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010115f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101162:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101165:	5b                   	pop    %ebx
80101166:	5e                   	pop    %esi
80101167:	5f                   	pop    %edi
80101168:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101169:	e9 22 25 00 00       	jmp    80103690 <pipewrite>
  panic("filewrite");
8010116e:	83 ec 0c             	sub    $0xc,%esp
80101171:	68 6d 6f 10 80       	push   $0x80106f6d
80101176:	e8 15 f2 ff ff       	call   80100390 <panic>
8010117b:	66 90                	xchg   %ax,%ax
8010117d:	66 90                	xchg   %ax,%ax
8010117f:	90                   	nop

80101180 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d a0 01 11 80    	mov    0x801101a0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 b8 01 11 80    	add    0x801101b8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 05 ef ff ff       	call   801000c0 <bread>
801011bb:	83 c4 10             	add    $0x10,%esp
801011be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011c1:	a1 a0 01 11 80       	mov    0x801101a0,%eax
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
801011d2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 18       	movzbl 0x18(%edx,%ecx,1),%edi
801011e9:	89 fa                	mov    %edi,%edx
801011eb:	85 df                	test   %ebx,%edi
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 f4 ef ff ff       	call   80100200 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 a0 01 11 80    	cmp    %eax,0x801101a0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 77 6f 10 80       	push   $0x80106f77
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 18          	mov    %dl,0x18(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 de 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 b6 ef ff ff       	call   80100200 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 6b ee ff ff       	call   801000c0 <bread>
  memset(bp->data, 0, BSIZE);
80101255:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101258:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010125a:	8d 40 18             	lea    0x18(%eax),%eax
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 56 32 00 00       	call   801044c0 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 ae 1c 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 86 ef ff ff       	call   80100200 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010128f:	90                   	nop

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	89 c7                	mov    %eax,%edi
80101296:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101297:	31 f6                	xor    %esi,%esi
{
80101299:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb f4 01 11 80       	mov    $0x801101f4,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 c0 01 11 80       	push   $0x801101c0
801012aa:	e8 f1 2f 00 00       	call   801042a0 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 18                	jmp    801012cf <iget+0x3f>
801012b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012be:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c0:	39 3b                	cmp    %edi,(%ebx)
801012c2:	74 64                	je     80101328 <iget+0x98>
801012c4:	83 c3 50             	add    $0x50,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c7:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
801012cd:	73 21                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012cf:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d2:	85 c9                	test   %ecx,%ecx
801012d4:	7f ea                	jg     801012c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d6:	85 f6                	test   %esi,%esi
801012d8:	75 ea                	jne    801012c4 <iget+0x34>
801012da:	8d 43 50             	lea    0x50(%ebx),%eax
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	75 6e                	jne    8010134f <iget+0xbf>
801012e1:	89 de                	mov    %ebx,%esi
801012e3:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e5:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
801012eb:	72 e2                	jb     801012cf <iget+0x3f>
801012ed:	8d 76 00             	lea    0x0(%esi),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 74                	je     80101368 <iget+0xd8>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101303:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
8010130a:	68 c0 01 11 80       	push   $0x801101c0
8010130f:	e8 5c 31 00 00       	call   80104470 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 97                	jne    801012c4 <iget+0x34>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      ip->ref++;
80101335:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101338:	68 c0 01 11 80       	push   $0x801101c0
8010133d:	e8 2e 31 00 00       	call   80104470 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134f:	3d 94 11 11 80       	cmp    $0x80111194,%eax
80101354:	73 12                	jae    80101368 <iget+0xd8>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101356:	8b 48 08             	mov    0x8(%eax),%ecx
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	85 c9                	test   %ecx,%ecx
8010135d:	0f 8f 5d ff ff ff    	jg     801012c0 <iget+0x30>
80101363:	e9 72 ff ff ff       	jmp    801012da <iget+0x4a>
    panic("iget: no inodes");
80101368:	83 ec 0c             	sub    $0xc,%esp
8010136b:	68 8d 6f 10 80       	push   $0x80106f8d
80101370:	e8 1b f0 ff ff       	call   80100390 <panic>
80101375:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101380 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	89 c6                	mov    %eax,%esi
80101387:	53                   	push   %ebx
80101388:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010138b:	83 fa 0b             	cmp    $0xb,%edx
8010138e:	0f 86 7c 00 00 00    	jbe    80101410 <bmap+0x90>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101394:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101397:	83 fb 7f             	cmp    $0x7f,%ebx
8010139a:	0f 87 90 00 00 00    	ja     80101430 <bmap+0xb0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013a0:	8b 50 4c             	mov    0x4c(%eax),%edx
801013a3:	8b 00                	mov    (%eax),%eax
801013a5:	85 d2                	test   %edx,%edx
801013a7:	74 57                	je     80101400 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013a9:	83 ec 08             	sub    $0x8,%esp
801013ac:	52                   	push   %edx
801013ad:	50                   	push   %eax
801013ae:	e8 0d ed ff ff       	call   801000c0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013b3:	83 c4 10             	add    $0x10,%esp
801013b6:	8d 54 98 18          	lea    0x18(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013ba:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013bc:	8b 1a                	mov    (%edx),%ebx
801013be:	85 db                	test   %ebx,%ebx
801013c0:	74 1e                	je     801013e0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013c2:	83 ec 0c             	sub    $0xc,%esp
801013c5:	57                   	push   %edi
801013c6:	e8 35 ee ff ff       	call   80100200 <brelse>
    return addr;
801013cb:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801013ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d1:	89 d8                	mov    %ebx,%eax
801013d3:	5b                   	pop    %ebx
801013d4:	5e                   	pop    %esi
801013d5:	5f                   	pop    %edi
801013d6:	5d                   	pop    %ebp
801013d7:	c3                   	ret    
801013d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013df:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801013e0:	8b 06                	mov    (%esi),%eax
801013e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013e5:	e8 96 fd ff ff       	call   80101180 <balloc>
801013ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013ed:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013f0:	89 c3                	mov    %eax,%ebx
801013f2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013f4:	57                   	push   %edi
801013f5:	e8 26 1b 00 00       	call   80102f20 <log_write>
801013fa:	83 c4 10             	add    $0x10,%esp
801013fd:	eb c3                	jmp    801013c2 <bmap+0x42>
801013ff:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101400:	e8 7b fd ff ff       	call   80101180 <balloc>
80101405:	89 c2                	mov    %eax,%edx
80101407:	89 46 4c             	mov    %eax,0x4c(%esi)
8010140a:	8b 06                	mov    (%esi),%eax
8010140c:	eb 9b                	jmp    801013a9 <bmap+0x29>
8010140e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101410:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101413:	8b 5f 1c             	mov    0x1c(%edi),%ebx
80101416:	85 db                	test   %ebx,%ebx
80101418:	75 b4                	jne    801013ce <bmap+0x4e>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010141a:	8b 00                	mov    (%eax),%eax
8010141c:	e8 5f fd ff ff       	call   80101180 <balloc>
80101421:	89 47 1c             	mov    %eax,0x1c(%edi)
80101424:	89 c3                	mov    %eax,%ebx
}
80101426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101429:	89 d8                	mov    %ebx,%eax
8010142b:	5b                   	pop    %ebx
8010142c:	5e                   	pop    %esi
8010142d:	5f                   	pop    %edi
8010142e:	5d                   	pop    %ebp
8010142f:	c3                   	ret    
  panic("bmap: out of range");
80101430:	83 ec 0c             	sub    $0xc,%esp
80101433:	68 9d 6f 10 80       	push   $0x80106f9d
80101438:	e8 53 ef ff ff       	call   80100390 <panic>
8010143d:	8d 76 00             	lea    0x0(%esi),%esi

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 6b ec ff ff       	call   801000c0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101455:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101458:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010145a:	8d 40 18             	lea    0x18(%eax),%eax
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 fa 30 00 00       	call   80104560 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 89 ed ff ff       	jmp    80100200 <brelse>
80101477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010147e:	66 90                	xchg   %ax,%ax

80101480 <bfree>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	89 c6                	mov    %eax,%esi
80101486:	53                   	push   %ebx
80101487:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
80101489:	83 ec 08             	sub    $0x8,%esp
8010148c:	68 a0 01 11 80       	push   $0x801101a0
80101491:	50                   	push   %eax
80101492:	e8 a9 ff ff ff       	call   80101440 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101497:	58                   	pop    %eax
80101498:	5a                   	pop    %edx
80101499:	89 da                	mov    %ebx,%edx
8010149b:	c1 ea 0c             	shr    $0xc,%edx
8010149e:	03 15 b8 01 11 80    	add    0x801101b8,%edx
801014a4:	52                   	push   %edx
801014a5:	56                   	push   %esi
801014a6:	e8 15 ec ff ff       	call   801000c0 <bread>
  m = 1 << (bi % 8);
801014ab:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ad:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014b0:	ba 01 00 00 00       	mov    $0x1,%edx
801014b5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014b8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014be:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014c1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014c3:	0f b6 4c 18 18       	movzbl 0x18(%eax,%ebx,1),%ecx
801014c8:	85 d1                	test   %edx,%ecx
801014ca:	74 25                	je     801014f1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014cc:	f7 d2                	not    %edx
801014ce:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014d0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014d3:	21 ca                	and    %ecx,%edx
801014d5:	88 54 1e 18          	mov    %dl,0x18(%esi,%ebx,1)
  log_write(bp);
801014d9:	56                   	push   %esi
801014da:	e8 41 1a 00 00       	call   80102f20 <log_write>
  brelse(bp);
801014df:	89 34 24             	mov    %esi,(%esp)
801014e2:	e8 19 ed ff ff       	call   80100200 <brelse>
}
801014e7:	83 c4 10             	add    $0x10,%esp
801014ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ed:	5b                   	pop    %ebx
801014ee:	5e                   	pop    %esi
801014ef:	5d                   	pop    %ebp
801014f0:	c3                   	ret    
    panic("freeing free block");
801014f1:	83 ec 0c             	sub    $0xc,%esp
801014f4:	68 b0 6f 10 80       	push   $0x80106fb0
801014f9:	e8 92 ee ff ff       	call   80100390 <panic>
801014fe:	66 90                	xchg   %ax,%ax

80101500 <iinit>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	83 ec 10             	sub    $0x10,%esp
  initlock(&icache.lock, "icache");
80101506:	68 c3 6f 10 80       	push   $0x80106fc3
8010150b:	68 c0 01 11 80       	push   $0x801101c0
80101510:	e8 6b 2d 00 00       	call   80104280 <initlock>
  readsb(dev, &sb);
80101515:	58                   	pop    %eax
80101516:	5a                   	pop    %edx
80101517:	68 a0 01 11 80       	push   $0x801101a0
8010151c:	ff 75 08             	pushl  0x8(%ebp)
8010151f:	e8 1c ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101524:	ff 35 b8 01 11 80    	pushl  0x801101b8
8010152a:	ff 35 b4 01 11 80    	pushl  0x801101b4
80101530:	ff 35 b0 01 11 80    	pushl  0x801101b0
80101536:	ff 35 ac 01 11 80    	pushl  0x801101ac
8010153c:	ff 35 a8 01 11 80    	pushl  0x801101a8
80101542:	ff 35 a4 01 11 80    	pushl  0x801101a4
80101548:	ff 35 a0 01 11 80    	pushl  0x801101a0
8010154e:	68 24 70 10 80       	push   $0x80107024
80101553:	e8 58 f1 ff ff       	call   801006b0 <cprintf>
}
80101558:	83 c4 30             	add    $0x30,%esp
8010155b:	c9                   	leave  
8010155c:	c3                   	ret    
8010155d:	8d 76 00             	lea    0x0(%esi),%esi

80101560 <ialloc>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	56                   	push   %esi
80101565:	53                   	push   %ebx
80101566:	83 ec 1c             	sub    $0x1c,%esp
80101569:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010156c:	83 3d a8 01 11 80 01 	cmpl   $0x1,0x801101a8
{
80101573:	8b 75 08             	mov    0x8(%ebp),%esi
80101576:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101579:	0f 86 91 00 00 00    	jbe    80101610 <ialloc+0xb0>
8010157f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101584:	eb 21                	jmp    801015a7 <ialloc+0x47>
80101586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010158d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101590:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101593:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101596:	57                   	push   %edi
80101597:	e8 64 ec ff ff       	call   80100200 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010159c:	83 c4 10             	add    $0x10,%esp
8010159f:	3b 1d a8 01 11 80    	cmp    0x801101a8,%ebx
801015a5:	73 69                	jae    80101610 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015a7:	89 d8                	mov    %ebx,%eax
801015a9:	83 ec 08             	sub    $0x8,%esp
801015ac:	c1 e8 03             	shr    $0x3,%eax
801015af:	03 05 b4 01 11 80    	add    0x801101b4,%eax
801015b5:	50                   	push   %eax
801015b6:	56                   	push   %esi
801015b7:	e8 04 eb ff ff       	call   801000c0 <bread>
    if(dip->type == 0){  // a free inode
801015bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801015bf:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015c1:	89 d8                	mov    %ebx,%eax
801015c3:	83 e0 07             	and    $0x7,%eax
801015c6:	c1 e0 06             	shl    $0x6,%eax
801015c9:	8d 4c 07 18          	lea    0x18(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015d1:	75 bd                	jne    80101590 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015d3:	83 ec 04             	sub    $0x4,%esp
801015d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015d9:	6a 40                	push   $0x40
801015db:	6a 00                	push   $0x0
801015dd:	51                   	push   %ecx
801015de:	e8 dd 2e 00 00       	call   801044c0 <memset>
      dip->type = type;
801015e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ed:	89 3c 24             	mov    %edi,(%esp)
801015f0:	e8 2b 19 00 00       	call   80102f20 <log_write>
      brelse(bp);
801015f5:	89 3c 24             	mov    %edi,(%esp)
801015f8:	e8 03 ec ff ff       	call   80100200 <brelse>
      return iget(dev, inum);
801015fd:	83 c4 10             	add    $0x10,%esp
}
80101600:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101603:	89 da                	mov    %ebx,%edx
80101605:	89 f0                	mov    %esi,%eax
}
80101607:	5b                   	pop    %ebx
80101608:	5e                   	pop    %esi
80101609:	5f                   	pop    %edi
8010160a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010160b:	e9 80 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
80101610:	83 ec 0c             	sub    $0xc,%esp
80101613:	68 ca 6f 10 80       	push   $0x80106fca
80101618:	e8 73 ed ff ff       	call   80100390 <panic>
8010161d:	8d 76 00             	lea    0x0(%esi),%esi

80101620 <iupdate>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101628:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162b:	83 c3 1c             	add    $0x1c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010162e:	83 ec 08             	sub    $0x8,%esp
80101631:	c1 e8 03             	shr    $0x3,%eax
80101634:	03 05 b4 01 11 80    	add    0x801101b4,%eax
8010163a:	50                   	push   %eax
8010163b:	ff 73 e4             	pushl  -0x1c(%ebx)
8010163e:	e8 7d ea ff ff       	call   801000c0 <bread>
  dip->type = ip->type;
80101643:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101647:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010164a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010164c:	8b 43 e8             	mov    -0x18(%ebx),%eax
8010164f:	83 e0 07             	and    $0x7,%eax
80101652:	c1 e0 06             	shl    $0x6,%eax
80101655:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
80101659:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010165c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101660:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101663:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101667:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010166b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010166f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101673:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101677:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010167a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167d:	6a 34                	push   $0x34
8010167f:	53                   	push   %ebx
80101680:	50                   	push   %eax
80101681:	e8 da 2e 00 00       	call   80104560 <memmove>
  log_write(bp);
80101686:	89 34 24             	mov    %esi,(%esp)
80101689:	e8 92 18 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010168e:	89 75 08             	mov    %esi,0x8(%ebp)
80101691:	83 c4 10             	add    $0x10,%esp
}
80101694:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101697:	5b                   	pop    %ebx
80101698:	5e                   	pop    %esi
80101699:	5d                   	pop    %ebp
  brelse(bp);
8010169a:	e9 61 eb ff ff       	jmp    80100200 <brelse>
8010169f:	90                   	nop

801016a0 <idup>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	53                   	push   %ebx
801016a4:	83 ec 10             	sub    $0x10,%esp
801016a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016aa:	68 c0 01 11 80       	push   $0x801101c0
801016af:	e8 ec 2b 00 00       	call   801042a0 <acquire>
  ip->ref++;
801016b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016b8:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
801016bf:	e8 ac 2d 00 00       	call   80104470 <release>
}
801016c4:	89 d8                	mov    %ebx,%eax
801016c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016c9:	c9                   	leave  
801016ca:	c3                   	ret    
801016cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016cf:	90                   	nop

801016d0 <ilock>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016d8:	85 db                	test   %ebx,%ebx
801016da:	0f 84 e8 00 00 00    	je     801017c8 <ilock+0xf8>
801016e0:	8b 43 08             	mov    0x8(%ebx),%eax
801016e3:	85 c0                	test   %eax,%eax
801016e5:	0f 8e dd 00 00 00    	jle    801017c8 <ilock+0xf8>
  acquire(&icache.lock);
801016eb:	83 ec 0c             	sub    $0xc,%esp
801016ee:	68 c0 01 11 80       	push   $0x801101c0
801016f3:	e8 a8 2b 00 00       	call   801042a0 <acquire>
  while(ip->flags & I_BUSY)
801016f8:	8b 43 0c             	mov    0xc(%ebx),%eax
801016fb:	83 c4 10             	add    $0x10,%esp
801016fe:	a8 01                	test   $0x1,%al
80101700:	74 1e                	je     80101720 <ilock+0x50>
80101702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(ip, &icache.lock);
80101708:	83 ec 08             	sub    $0x8,%esp
8010170b:	68 c0 01 11 80       	push   $0x801101c0
80101710:	53                   	push   %ebx
80101711:	e8 2a 28 00 00       	call   80103f40 <sleep>
  while(ip->flags & I_BUSY)
80101716:	8b 43 0c             	mov    0xc(%ebx),%eax
80101719:	83 c4 10             	add    $0x10,%esp
8010171c:	a8 01                	test   $0x1,%al
8010171e:	75 e8                	jne    80101708 <ilock+0x38>
  release(&icache.lock);
80101720:	83 ec 0c             	sub    $0xc,%esp
  ip->flags |= I_BUSY;
80101723:	83 c8 01             	or     $0x1,%eax
80101726:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
80101729:	68 c0 01 11 80       	push   $0x801101c0
8010172e:	e8 3d 2d 00 00       	call   80104470 <release>
  if(!(ip->flags & I_VALID)){
80101733:	83 c4 10             	add    $0x10,%esp
80101736:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
8010173a:	74 0c                	je     80101748 <ilock+0x78>
}
8010173c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010173f:	5b                   	pop    %ebx
80101740:	5e                   	pop    %esi
80101741:	5d                   	pop    %ebp
80101742:	c3                   	ret    
80101743:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101747:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
8010174b:	83 ec 08             	sub    $0x8,%esp
8010174e:	c1 e8 03             	shr    $0x3,%eax
80101751:	03 05 b4 01 11 80    	add    0x801101b4,%eax
80101757:	50                   	push   %eax
80101758:	ff 33                	pushl  (%ebx)
8010175a:	e8 61 e9 ff ff       	call   801000c0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010175f:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101762:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101764:	8b 43 04             	mov    0x4(%ebx),%eax
80101767:	83 e0 07             	and    $0x7,%eax
8010176a:	c1 e0 06             	shl    $0x6,%eax
8010176d:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
80101771:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101774:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101777:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
8010177b:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
8010177f:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
80101783:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101787:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
8010178b:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
8010178f:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
80101793:	8b 50 fc             	mov    -0x4(%eax),%edx
80101796:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101799:	6a 34                	push   $0x34
8010179b:	50                   	push   %eax
8010179c:	8d 43 1c             	lea    0x1c(%ebx),%eax
8010179f:	50                   	push   %eax
801017a0:	e8 bb 2d 00 00       	call   80104560 <memmove>
    brelse(bp);
801017a5:	89 34 24             	mov    %esi,(%esp)
801017a8:	e8 53 ea ff ff       	call   80100200 <brelse>
    ip->flags |= I_VALID;
801017ad:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
801017b1:	83 c4 10             	add    $0x10,%esp
801017b4:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
801017b9:	75 81                	jne    8010173c <ilock+0x6c>
      panic("ilock: no type");
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	68 e2 6f 10 80       	push   $0x80106fe2
801017c3:	e8 c8 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017c8:	83 ec 0c             	sub    $0xc,%esp
801017cb:	68 dc 6f 10 80       	push   $0x80106fdc
801017d0:	e8 bb eb ff ff       	call   80100390 <panic>
801017d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017e0 <iunlock>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	53                   	push   %ebx
801017e4:	83 ec 04             	sub    $0x4,%esp
801017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801017ea:	85 db                	test   %ebx,%ebx
801017ec:	74 39                	je     80101827 <iunlock+0x47>
801017ee:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
801017f2:	74 33                	je     80101827 <iunlock+0x47>
801017f4:	8b 43 08             	mov    0x8(%ebx),%eax
801017f7:	85 c0                	test   %eax,%eax
801017f9:	7e 2c                	jle    80101827 <iunlock+0x47>
  acquire(&icache.lock);
801017fb:	83 ec 0c             	sub    $0xc,%esp
801017fe:	68 c0 01 11 80       	push   $0x801101c0
80101803:	e8 98 2a 00 00       	call   801042a0 <acquire>
  ip->flags &= ~I_BUSY;
80101808:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
8010180c:	89 1c 24             	mov    %ebx,(%esp)
8010180f:	e8 cc 28 00 00       	call   801040e0 <wakeup>
  release(&icache.lock);
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010181e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101821:	c9                   	leave  
  release(&icache.lock);
80101822:	e9 49 2c 00 00       	jmp    80104470 <release>
    panic("iunlock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 f1 6f 10 80       	push   $0x80106ff1
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iput>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 28             	sub    $0x28,%esp
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010184c:	68 c0 01 11 80       	push   $0x801101c0
80101851:	e8 4a 2a 00 00       	call   801042a0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101856:	8b 43 08             	mov    0x8(%ebx),%eax
80101859:	83 c4 10             	add    $0x10,%esp
8010185c:	83 f8 01             	cmp    $0x1,%eax
8010185f:	0f 85 ab 00 00 00    	jne    80101910 <iput+0xd0>
80101865:	8b 53 0c             	mov    0xc(%ebx),%edx
80101868:	f6 c2 02             	test   $0x2,%dl
8010186b:	0f 84 9f 00 00 00    	je     80101910 <iput+0xd0>
80101871:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
80101876:	0f 85 94 00 00 00    	jne    80101910 <iput+0xd0>
    if(ip->flags & I_BUSY)
8010187c:	f6 c2 01             	test   $0x1,%dl
8010187f:	0f 85 0f 01 00 00    	jne    80101994 <iput+0x154>
    release(&icache.lock);
80101885:	83 ec 0c             	sub    $0xc,%esp
80101888:	8d 73 1c             	lea    0x1c(%ebx),%esi
8010188b:	8d 7b 4c             	lea    0x4c(%ebx),%edi
    ip->flags |= I_BUSY;
8010188e:	83 ca 01             	or     $0x1,%edx
80101891:	89 53 0c             	mov    %edx,0xc(%ebx)
    release(&icache.lock);
80101894:	68 c0 01 11 80       	push   $0x801101c0
80101899:	e8 d2 2b 00 00       	call   80104470 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010189e:	83 c4 10             	add    $0x10,%esp
801018a1:	eb 0c                	jmp    801018af <iput+0x6f>
801018a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018a7:	90                   	nop
801018a8:	83 c6 04             	add    $0x4,%esi
801018ab:	39 fe                	cmp    %edi,%esi
801018ad:	74 1b                	je     801018ca <iput+0x8a>
    if(ip->addrs[i]){
801018af:	8b 16                	mov    (%esi),%edx
801018b1:	85 d2                	test   %edx,%edx
801018b3:	74 f3                	je     801018a8 <iput+0x68>
      bfree(ip->dev, ip->addrs[i]);
801018b5:	8b 03                	mov    (%ebx),%eax
801018b7:	83 c6 04             	add    $0x4,%esi
801018ba:	e8 c1 fb ff ff       	call   80101480 <bfree>
      ip->addrs[i] = 0;
801018bf:	c7 46 fc 00 00 00 00 	movl   $0x0,-0x4(%esi)
  for(i = 0; i < NDIRECT; i++){
801018c6:	39 fe                	cmp    %edi,%esi
801018c8:	75 e5                	jne    801018af <iput+0x6f>
    }
  }

  if(ip->addrs[NDIRECT]){
801018ca:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018cd:	85 c0                	test   %eax,%eax
801018cf:	75 5f                	jne    80101930 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018d1:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018d4:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
  iupdate(ip);
801018db:	53                   	push   %ebx
801018dc:	e8 3f fd ff ff       	call   80101620 <iupdate>
    ip->type = 0;
801018e1:	31 c0                	xor    %eax,%eax
801018e3:	66 89 43 10          	mov    %ax,0x10(%ebx)
    iupdate(ip);
801018e7:	89 1c 24             	mov    %ebx,(%esp)
801018ea:	e8 31 fd ff ff       	call   80101620 <iupdate>
    acquire(&icache.lock);
801018ef:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
801018f6:	e8 a5 29 00 00       	call   801042a0 <acquire>
    ip->flags = 0;
801018fb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    wakeup(ip);
80101902:	89 1c 24             	mov    %ebx,(%esp)
80101905:	e8 d6 27 00 00       	call   801040e0 <wakeup>
8010190a:	8b 43 08             	mov    0x8(%ebx),%eax
8010190d:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101910:	83 e8 01             	sub    $0x1,%eax
80101913:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101916:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010191d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101920:	5b                   	pop    %ebx
80101921:	5e                   	pop    %esi
80101922:	5f                   	pop    %edi
80101923:	5d                   	pop    %ebp
  release(&icache.lock);
80101924:	e9 47 2b 00 00       	jmp    80104470 <release>
80101929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101930:	83 ec 08             	sub    $0x8,%esp
80101933:	50                   	push   %eax
80101934:	ff 33                	pushl  (%ebx)
80101936:	e8 85 e7 ff ff       	call   801000c0 <bread>
8010193b:	83 c4 10             	add    $0x10,%esp
8010193e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101941:	8d 78 18             	lea    0x18(%eax),%edi
80101944:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
8010194a:	eb 0b                	jmp    80101957 <iput+0x117>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101950:	83 c7 04             	add    $0x4,%edi
80101953:	39 f7                	cmp    %esi,%edi
80101955:	74 19                	je     80101970 <iput+0x130>
      if(a[j])
80101957:	8b 17                	mov    (%edi),%edx
80101959:	85 d2                	test   %edx,%edx
8010195b:	74 f3                	je     80101950 <iput+0x110>
        bfree(ip->dev, a[j]);
8010195d:	8b 03                	mov    (%ebx),%eax
8010195f:	e8 1c fb ff ff       	call   80101480 <bfree>
80101964:	eb ea                	jmp    80101950 <iput+0x110>
80101966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010196d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101970:	83 ec 0c             	sub    $0xc,%esp
80101973:	ff 75 e4             	pushl  -0x1c(%ebp)
80101976:	e8 85 e8 ff ff       	call   80100200 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010197b:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010197e:	8b 03                	mov    (%ebx),%eax
80101980:	e8 fb fa ff ff       	call   80101480 <bfree>
    ip->addrs[NDIRECT] = 0;
80101985:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198c:	83 c4 10             	add    $0x10,%esp
8010198f:	e9 3d ff ff ff       	jmp    801018d1 <iput+0x91>
      panic("iput busy");
80101994:	83 ec 0c             	sub    $0xc,%esp
80101997:	68 f9 6f 10 80       	push   $0x80106ff9
8010199c:	e8 ef e9 ff ff       	call   80100390 <panic>
801019a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop

801019b0 <iunlockput>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	53                   	push   %ebx
801019b4:	83 ec 10             	sub    $0x10,%esp
801019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ba:	53                   	push   %ebx
801019bb:	e8 20 fe ff ff       	call   801017e0 <iunlock>
  iput(ip);
801019c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019c3:	83 c4 10             	add    $0x10,%esp
}
801019c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019c9:	c9                   	leave  
  iput(ip);
801019ca:	e9 71 fe ff ff       	jmp    80101840 <iput>
801019cf:	90                   	nop

801019d0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	8b 55 08             	mov    0x8(%ebp),%edx
801019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019d9:	8b 0a                	mov    (%edx),%ecx
801019db:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019de:	8b 4a 04             	mov    0x4(%edx),%ecx
801019e1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019e4:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
801019e8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019eb:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
801019ef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019f3:	8b 52 18             	mov    0x18(%edx),%edx
801019f6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ff:	90                   	nop

80101a00 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 1c             	sub    $0x1c,%esp
80101a09:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0f:	8b 75 10             	mov    0x10(%ebp),%esi
80101a12:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a15:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a18:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
{
80101a1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a23:	0f 84 a7 00 00 00    	je     80101ad0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a2c:	8b 40 18             	mov    0x18(%eax),%eax
80101a2f:	39 c6                	cmp    %eax,%esi
80101a31:	0f 87 ba 00 00 00    	ja     80101af1 <readi+0xf1>
80101a37:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a3a:	31 c9                	xor    %ecx,%ecx
80101a3c:	89 da                	mov    %ebx,%edx
80101a3e:	01 f2                	add    %esi,%edx
80101a40:	0f 92 c1             	setb   %cl
80101a43:	89 cf                	mov    %ecx,%edi
80101a45:	0f 82 a6 00 00 00    	jb     80101af1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a4b:	89 c1                	mov    %eax,%ecx
80101a4d:	29 f1                	sub    %esi,%ecx
80101a4f:	39 d0                	cmp    %edx,%eax
80101a51:	0f 43 cb             	cmovae %ebx,%ecx
80101a54:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	85 c9                	test   %ecx,%ecx
80101a59:	74 67                	je     80101ac2 <readi+0xc2>
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a63:	89 f2                	mov    %esi,%edx
80101a65:	c1 ea 09             	shr    $0x9,%edx
80101a68:	89 d8                	mov    %ebx,%eax
80101a6a:	e8 11 f9 ff ff       	call   80101380 <bmap>
80101a6f:	83 ec 08             	sub    $0x8,%esp
80101a72:	50                   	push   %eax
80101a73:	ff 33                	pushl  (%ebx)
80101a75:	e8 46 e6 ff ff       	call   801000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a7d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a82:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a85:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a87:	89 f0                	mov    %esi,%eax
80101a89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a8e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a93:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a95:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a99:	39 d9                	cmp    %ebx,%ecx
80101a9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a9f:	01 df                	add    %ebx,%edi
80101aa1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa3:	50                   	push   %eax
80101aa4:	ff 75 e0             	pushl  -0x20(%ebp)
80101aa7:	e8 b4 2a 00 00       	call   80104560 <memmove>
    brelse(bp);
80101aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aaf:	89 14 24             	mov    %edx,(%esp)
80101ab2:	e8 49 e7 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ac0:	77 9e                	ja     80101a60 <readi+0x60>
  }
  return n;
80101ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac8:	5b                   	pop    %ebx
80101ac9:	5e                   	pop    %esi
80101aca:	5f                   	pop    %edi
80101acb:	5d                   	pop    %ebp
80101acc:	c3                   	ret    
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 17                	ja     80101af1 <readi+0xf1>
80101ada:	8b 04 c5 40 01 11 80 	mov    -0x7feefec0(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aef:	ff e0                	jmp    *%eax
      return -1;
80101af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af6:	eb cd                	jmp    80101ac5 <readi+0xc5>
80101af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
{
80101b17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b23:	0f 84 b7 00 00 00    	je     80101be0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	39 70 18             	cmp    %esi,0x18(%eax)
80101b2f:	0f 82 e7 00 00 00    	jb     80101c1c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b38:	89 f8                	mov    %edi,%eax
80101b3a:	01 f0                	add    %esi,%eax
80101b3c:	0f 82 da 00 00 00    	jb     80101c1c <writei+0x11c>
80101b42:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b47:	0f 87 cf 00 00 00    	ja     80101c1c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b54:	85 ff                	test   %edi,%edi
80101b56:	74 79                	je     80101bd1 <writei+0xd1>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 f8                	mov    %edi,%eax
80101b6a:	e8 11 f8 ff ff       	call   80101380 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 37                	pushl  (%edi)
80101b75:	e8 46 e5 ff ff       	call   801000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b7f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b82:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b85:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	89 f0                	mov    %esi,%eax
80101b89:	83 c4 0c             	add    $0xc,%esp
80101b8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b93:	8d 44 07 18          	lea    0x18(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	39 d9                	cmp    %ebx,%ecx
80101b99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b9c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b9d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b9f:	ff 75 dc             	pushl  -0x24(%ebp)
80101ba2:	50                   	push   %eax
80101ba3:	e8 b8 29 00 00       	call   80104560 <memmove>
    log_write(bp);
80101ba8:	89 3c 24             	mov    %edi,(%esp)
80101bab:	e8 70 13 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101bb0:	89 3c 24             	mov    %edi,(%esp)
80101bb3:	e8 48 e6 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bbb:	83 c4 10             	add    $0x10,%esp
80101bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bc7:	77 97                	ja     80101b60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 18             	cmp    0x18(%eax),%esi
80101bcf:	77 37                	ja     80101c08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd7:	5b                   	pop    %ebx
80101bd8:	5e                   	pop    %esi
80101bd9:	5f                   	pop    %edi
80101bda:	5d                   	pop    %ebp
80101bdb:	c3                   	ret    
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be0:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 32                	ja     80101c1c <writei+0x11c>
80101bea:	8b 04 c5 44 01 11 80 	mov    -0x7feefebc(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 27                	je     80101c1c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bff:	ff e0                	jmp    *%eax
80101c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c0e:	89 70 18             	mov    %esi,0x18(%eax)
    iupdate(ip);
80101c11:	50                   	push   %eax
80101c12:	e8 09 fa ff ff       	call   80101620 <iupdate>
80101c17:	83 c4 10             	add    $0x10,%esp
80101c1a:	eb b5                	jmp    80101bd1 <writei+0xd1>
      return -1;
80101c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c21:	eb b1                	jmp    80101bd4 <writei+0xd4>
80101c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c36:	6a 0e                	push   $0xe
80101c38:	ff 75 0c             	pushl  0xc(%ebp)
80101c3b:	ff 75 08             	pushl  0x8(%ebp)
80101c3e:	e8 8d 29 00 00       	call   801045d0 <strncmp>
}
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    
80101c45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c5c:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80101c61:	0f 85 85 00 00 00    	jne    80101cec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c67:	8b 53 18             	mov    0x18(%ebx),%edx
80101c6a:	31 ff                	xor    %edi,%edi
80101c6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c6f:	85 d2                	test   %edx,%edx
80101c71:	74 3e                	je     80101cb1 <dirlookup+0x61>
80101c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c77:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c78:	6a 10                	push   $0x10
80101c7a:	57                   	push   %edi
80101c7b:	56                   	push   %esi
80101c7c:	53                   	push   %ebx
80101c7d:	e8 7e fd ff ff       	call   80101a00 <readi>
80101c82:	83 c4 10             	add    $0x10,%esp
80101c85:	83 f8 10             	cmp    $0x10,%eax
80101c88:	75 55                	jne    80101cdf <dirlookup+0x8f>
      panic("dirlink read");
    if(de.inum == 0)
80101c8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c8f:	74 18                	je     80101ca9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c91:	83 ec 04             	sub    $0x4,%esp
80101c94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c97:	6a 0e                	push   $0xe
80101c99:	50                   	push   %eax
80101c9a:	ff 75 0c             	pushl  0xc(%ebp)
80101c9d:	e8 2e 29 00 00       	call   801045d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	85 c0                	test   %eax,%eax
80101ca7:	74 17                	je     80101cc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca9:	83 c7 10             	add    $0x10,%edi
80101cac:	3b 7b 18             	cmp    0x18(%ebx),%edi
80101caf:	72 c7                	jb     80101c78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cb4:	31 c0                	xor    %eax,%eax
}
80101cb6:	5b                   	pop    %ebx
80101cb7:	5e                   	pop    %esi
80101cb8:	5f                   	pop    %edi
80101cb9:	5d                   	pop    %ebp
80101cba:	c3                   	ret    
80101cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cbf:	90                   	nop
      if(poff)
80101cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc3:	85 c0                	test   %eax,%eax
80101cc5:	74 05                	je     80101ccc <dirlookup+0x7c>
        *poff = off;
80101cc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ccc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cd0:	8b 03                	mov    (%ebx),%eax
80101cd2:	e8 b9 f5 ff ff       	call   80101290 <iget>
}
80101cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cda:	5b                   	pop    %ebx
80101cdb:	5e                   	pop    %esi
80101cdc:	5f                   	pop    %edi
80101cdd:	5d                   	pop    %ebp
80101cde:	c3                   	ret    
      panic("dirlink read");
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 15 70 10 80       	push   $0x80107015
80101ce7:	e8 a4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 03 70 10 80       	push   $0x80107003
80101cf4:	e8 97 e6 ff ff       	call   80100390 <panic>
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	89 c3                	mov    %eax,%ebx
80101d08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d0e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d14:	0f 84 86 01 00 00    	je     80101ea0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101d1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  acquire(&icache.lock);
80101d20:	83 ec 0c             	sub    $0xc,%esp
80101d23:	89 df                	mov    %ebx,%edi
    ip = idup(proc->cwd);
80101d25:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d28:	68 c0 01 11 80       	push   $0x801101c0
80101d2d:	e8 6e 25 00 00       	call   801042a0 <acquire>
  ip->ref++;
80101d32:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d36:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101d3d:	e8 2e 27 00 00       	call   80104470 <release>
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	eb 0c                	jmp    80101d53 <namex+0x53>
80101d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4e:	66 90                	xchg   %ax,%ax
    path++;
80101d50:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d53:	0f b6 07             	movzbl (%edi),%eax
80101d56:	3c 2f                	cmp    $0x2f,%al
80101d58:	74 f6                	je     80101d50 <namex+0x50>
  if(*path == 0)
80101d5a:	84 c0                	test   %al,%al
80101d5c:	0f 84 ee 00 00 00    	je     80101e50 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d62:	0f b6 07             	movzbl (%edi),%eax
80101d65:	84 c0                	test   %al,%al
80101d67:	0f 84 fb 00 00 00    	je     80101e68 <namex+0x168>
80101d6d:	89 fb                	mov    %edi,%ebx
80101d6f:	3c 2f                	cmp    $0x2f,%al
80101d71:	0f 84 f1 00 00 00    	je     80101e68 <namex+0x168>
80101d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7e:	66 90                	xchg   %ax,%ax
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d83:	0f b6 03             	movzbl (%ebx),%eax
80101d86:	3c 2f                	cmp    $0x2f,%al
80101d88:	74 04                	je     80101d8e <namex+0x8e>
80101d8a:	84 c0                	test   %al,%al
80101d8c:	75 f2                	jne    80101d80 <namex+0x80>
  len = path - s;
80101d8e:	89 d8                	mov    %ebx,%eax
80101d90:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101d92:	83 f8 0d             	cmp    $0xd,%eax
80101d95:	0f 8e 85 00 00 00    	jle    80101e20 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101d9b:	83 ec 04             	sub    $0x4,%esp
80101d9e:	6a 0e                	push   $0xe
80101da0:	57                   	push   %edi
    path++;
80101da1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101da3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101da6:	e8 b5 27 00 00       	call   80104560 <memmove>
80101dab:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101dae:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101db1:	75 0d                	jne    80101dc0 <namex+0xc0>
80101db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101db7:	90                   	nop
    path++;
80101db8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dbb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dbe:	74 f8                	je     80101db8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 07 f9 ff ff       	call   801016d0 <ilock>
    if(ip->type != T_DIR){
80101dc9:	83 c4 10             	add    $0x10,%esp
80101dcc:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80101dd1:	0f 85 a1 00 00 00    	jne    80101e78 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dda:	85 d2                	test   %edx,%edx
80101ddc:	74 09                	je     80101de7 <namex+0xe7>
80101dde:	80 3f 00             	cmpb   $0x0,(%edi)
80101de1:	0f 84 d9 00 00 00    	je     80101ec0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101de7:	83 ec 04             	sub    $0x4,%esp
80101dea:	6a 00                	push   $0x0
80101dec:	ff 75 e4             	pushl  -0x1c(%ebp)
80101def:	56                   	push   %esi
80101df0:	e8 5b fe ff ff       	call   80101c50 <dirlookup>
80101df5:	83 c4 10             	add    $0x10,%esp
80101df8:	89 c3                	mov    %eax,%ebx
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	74 7a                	je     80101e78 <namex+0x178>
  iunlock(ip);
80101dfe:	83 ec 0c             	sub    $0xc,%esp
80101e01:	56                   	push   %esi
80101e02:	e8 d9 f9 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101e07:	89 34 24             	mov    %esi,(%esp)
80101e0a:	89 de                	mov    %ebx,%esi
80101e0c:	e8 2f fa ff ff       	call   80101840 <iput>
  while(*path == '/')
80101e11:	83 c4 10             	add    $0x10,%esp
80101e14:	e9 3a ff ff ff       	jmp    80101d53 <namex+0x53>
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e26:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e29:	83 ec 04             	sub    $0x4,%esp
80101e2c:	50                   	push   %eax
80101e2d:	57                   	push   %edi
    name[len] = 0;
80101e2e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e30:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e33:	e8 28 27 00 00       	call   80104560 <memmove>
    name[len] = 0;
80101e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e3b:	83 c4 10             	add    $0x10,%esp
80101e3e:	c6 00 00             	movb   $0x0,(%eax)
80101e41:	e9 68 ff ff ff       	jmp    80101dae <namex+0xae>
80101e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 85 00 00 00    	jne    80101ee0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5e:	89 f0                	mov    %esi,%eax
80101e60:	5b                   	pop    %ebx
80101e61:	5e                   	pop    %esi
80101e62:	5f                   	pop    %edi
80101e63:	5d                   	pop    %ebp
80101e64:	c3                   	ret    
80101e65:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e6b:	89 fb                	mov    %edi,%ebx
80101e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e70:	31 c0                	xor    %eax,%eax
80101e72:	eb b5                	jmp    80101e29 <namex+0x129>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e78:	83 ec 0c             	sub    $0xc,%esp
80101e7b:	56                   	push   %esi
80101e7c:	e8 5f f9 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101e81:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e84:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e86:	e8 b5 f9 ff ff       	call   80101840 <iput>
      return 0;
80101e8b:	83 c4 10             	add    $0x10,%esp
}
80101e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e91:	89 f0                	mov    %esi,%eax
80101e93:	5b                   	pop    %ebx
80101e94:	5e                   	pop    %esi
80101e95:	5f                   	pop    %edi
80101e96:	5d                   	pop    %ebp
80101e97:	c3                   	ret    
80101e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101ea0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eaa:	89 df                	mov    %ebx,%edi
80101eac:	e8 df f3 ff ff       	call   80101290 <iget>
80101eb1:	89 c6                	mov    %eax,%esi
80101eb3:	e9 9b fe ff ff       	jmp    80101d53 <namex+0x53>
80101eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebf:	90                   	nop
      iunlock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 17 f9 ff ff       	call   801017e0 <iunlock>
      return ip;
80101ec9:	83 c4 10             	add    $0x10,%esp
}
80101ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecf:	89 f0                	mov    %esi,%eax
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
80101ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	56                   	push   %esi
    return 0;
80101ee4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ee6:	e8 55 f9 ff ff       	call   80101840 <iput>
    return 0;
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	e9 68 ff ff ff       	jmp    80101e5b <namex+0x15b>
80101ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f00 <dirlink>:
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	83 ec 20             	sub    $0x20,%esp
80101f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f0c:	6a 00                	push   $0x0
80101f0e:	ff 75 0c             	pushl  0xc(%ebp)
80101f11:	53                   	push   %ebx
80101f12:	e8 39 fd ff ff       	call   80101c50 <dirlookup>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	75 67                	jne    80101f85 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f1e:	8b 7b 18             	mov    0x18(%ebx),%edi
80101f21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f24:	85 ff                	test   %edi,%edi
80101f26:	74 29                	je     80101f51 <dirlink+0x51>
80101f28:	31 ff                	xor    %edi,%edi
80101f2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f2d:	eb 09                	jmp    80101f38 <dirlink+0x38>
80101f2f:	90                   	nop
80101f30:	83 c7 10             	add    $0x10,%edi
80101f33:	3b 7b 18             	cmp    0x18(%ebx),%edi
80101f36:	73 19                	jae    80101f51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f38:	6a 10                	push   $0x10
80101f3a:	57                   	push   %edi
80101f3b:	56                   	push   %esi
80101f3c:	53                   	push   %ebx
80101f3d:	e8 be fa ff ff       	call   80101a00 <readi>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	83 f8 10             	cmp    $0x10,%eax
80101f48:	75 4e                	jne    80101f98 <dirlink+0x98>
    if(de.inum == 0)
80101f4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4f:	75 df                	jne    80101f30 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f51:	83 ec 04             	sub    $0x4,%esp
80101f54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f57:	6a 0e                	push   $0xe
80101f59:	ff 75 0c             	pushl  0xc(%ebp)
80101f5c:	50                   	push   %eax
80101f5d:	e8 ce 26 00 00       	call   80104630 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f62:	6a 10                	push   $0x10
  de.inum = inum;
80101f64:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f67:	57                   	push   %edi
80101f68:	56                   	push   %esi
80101f69:	53                   	push   %ebx
  de.inum = inum;
80101f6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6e:	e8 8d fb ff ff       	call   80101b00 <writei>
80101f73:	83 c4 20             	add    $0x20,%esp
80101f76:	83 f8 10             	cmp    $0x10,%eax
80101f79:	75 2a                	jne    80101fa5 <dirlink+0xa5>
  return 0;
80101f7b:	31 c0                	xor    %eax,%eax
}
80101f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
    iput(ip);
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	50                   	push   %eax
80101f89:	e8 b2 f8 ff ff       	call   80101840 <iput>
    return -1;
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	eb e5                	jmp    80101f7d <dirlink+0x7d>
      panic("dirlink read");
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	68 15 70 10 80       	push   $0x80107015
80101fa0:	e8 eb e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101fa5:	83 ec 0c             	sub    $0xc,%esp
80101fa8:	68 fe 75 10 80       	push   $0x801075fe
80101fad:	e8 de e3 ff ff       	call   80100390 <panic>
80101fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fc0 <namei>:

struct inode*
namei(char *path)
{
80101fc0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc1:	31 d2                	xor    %edx,%edx
{
80101fc3:	89 e5                	mov    %esp,%ebp
80101fc5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fce:	e8 2d fd ff ff       	call   80101d00 <namex>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fe0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fe1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fe6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fef:	e9 0c fd ff ff       	jmp    80101d00 <namex>
80101ff4:	66 90                	xchg   %ax,%ax
80101ff6:	66 90                	xchg   %ax,%ax
80101ff8:	66 90                	xchg   %ax,%ax
80101ffa:	66 90                	xchg   %ax,%ax
80101ffc:	66 90                	xchg   %ax,%ax
80101ffe:	66 90                	xchg   %ax,%ax

80102000 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102009:	85 c0                	test   %eax,%eax
8010200b:	0f 84 b4 00 00 00    	je     801020c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102011:	8b 70 08             	mov    0x8(%eax),%esi
80102014:	89 c3                	mov    %eax,%ebx
80102016:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010201c:	0f 87 96 00 00 00    	ja     801020b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202e:	66 90                	xchg   %ax,%ax
80102030:	89 ca                	mov    %ecx,%edx
80102032:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102033:	83 e0 c0             	and    $0xffffffc0,%eax
80102036:	3c 40                	cmp    $0x40,%al
80102038:	75 f6                	jne    80102030 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010203a:	31 ff                	xor    %edi,%edi
8010203c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102041:	89 f8                	mov    %edi,%eax
80102043:	ee                   	out    %al,(%dx)
80102044:	b8 01 00 00 00       	mov    $0x1,%eax
80102049:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010204e:	ee                   	out    %al,(%dx)
8010204f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102054:	89 f0                	mov    %esi,%eax
80102056:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102057:	89 f0                	mov    %esi,%eax
80102059:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010205e:	c1 f8 08             	sar    $0x8,%eax
80102061:	ee                   	out    %al,(%dx)
80102062:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102067:	89 f8                	mov    %edi,%eax
80102069:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010206a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010206e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102073:	c1 e0 04             	shl    $0x4,%eax
80102076:	83 e0 10             	and    $0x10,%eax
80102079:	83 c8 e0             	or     $0xffffffe0,%eax
8010207c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010207d:	f6 03 04             	testb  $0x4,(%ebx)
80102080:	75 16                	jne    80102098 <idestart+0x98>
80102082:	b8 20 00 00 00       	mov    $0x20,%eax
80102087:	89 ca                	mov    %ecx,%edx
80102089:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010208a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208d:	5b                   	pop    %ebx
8010208e:	5e                   	pop    %esi
8010208f:	5f                   	pop    %edi
80102090:	5d                   	pop    %ebp
80102091:	c3                   	ret    
80102092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102098:	b8 30 00 00 00       	mov    $0x30,%eax
8010209d:	89 ca                	mov    %ecx,%edx
8010209f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020a5:	8d 73 18             	lea    0x18(%ebx),%esi
801020a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ad:	fc                   	cld    
801020ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b3:	5b                   	pop    %ebx
801020b4:	5e                   	pop    %esi
801020b5:	5f                   	pop    %edi
801020b6:	5d                   	pop    %ebp
801020b7:	c3                   	ret    
    panic("incorrect blockno");
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 89 70 10 80       	push   $0x80107089
801020c0:	e8 cb e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	68 80 70 10 80       	push   $0x80107080
801020cd:	e8 be e2 ff ff       	call   80100390 <panic>
801020d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <ideinit>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020e6:	68 9b 70 10 80       	push   $0x8010709b
801020eb:	68 80 a5 10 80       	push   $0x8010a580
801020f0:	e8 8b 21 00 00       	call   80104280 <initlock>
  picenable(IRQ_IDE);
801020f5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801020fc:	e8 1f 13 00 00       	call   80103420 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102101:	58                   	pop    %eax
80102102:	a1 c0 18 11 80       	mov    0x801118c0,%eax
80102107:	5a                   	pop    %edx
80102108:	83 e8 01             	sub    $0x1,%eax
8010210b:	50                   	push   %eax
8010210c:	6a 0e                	push   $0xe
8010210e:	e8 bd 02 00 00       	call   801023d0 <ioapicenable>
80102113:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102116:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010211f:	90                   	nop
80102120:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102121:	83 e0 c0             	and    $0xffffffc0,%eax
80102124:	3c 40                	cmp    $0x40,%al
80102126:	75 f8                	jne    80102120 <ideinit+0x40>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102128:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010212d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102132:	ee                   	out    %al,(%dx)
80102133:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102138:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010213d:	eb 06                	jmp    80102145 <ideinit+0x65>
8010213f:	90                   	nop
  for(i=0; i<1000; i++){
80102140:	83 e9 01             	sub    $0x1,%ecx
80102143:	74 0f                	je     80102154 <ideinit+0x74>
80102145:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102146:	84 c0                	test   %al,%al
80102148:	74 f6                	je     80102140 <ideinit+0x60>
      havedisk1 = 1;
8010214a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102151:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102154:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102159:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010215e:	ee                   	out    %al,(%dx)
}
8010215f:	c9                   	leave  
80102160:	c3                   	ret    
80102161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216f:	90                   	nop

80102170 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	57                   	push   %edi
80102174:	56                   	push   %esi
80102175:	53                   	push   %ebx
80102176:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102179:	68 80 a5 10 80       	push   $0x8010a580
8010217e:	e8 1d 21 00 00       	call   801042a0 <acquire>
  if((b = idequeue) == 0){
80102183:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102189:	83 c4 10             	add    $0x10,%esp
8010218c:	85 db                	test   %ebx,%ebx
8010218e:	74 63                	je     801021f3 <ideintr+0x83>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102190:	8b 43 14             	mov    0x14(%ebx),%eax
80102193:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102198:	8b 33                	mov    (%ebx),%esi
8010219a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801021a0:	75 2f                	jne    801021d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
801021b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021b1:	89 c1                	mov    %eax,%ecx
801021b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021b6:	80 f9 40             	cmp    $0x40,%cl
801021b9:	75 f5                	jne    801021b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021bb:	a8 21                	test   $0x21,%al
801021bd:	75 12                	jne    801021d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801021bf:	8d 7b 18             	lea    0x18(%ebx),%edi
  asm volatile("cld; rep insl" :
801021c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021cc:	fc                   	cld    
801021cd:	f3 6d                	rep insl (%dx),%es:(%edi)
801021cf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021d7:	83 ce 02             	or     $0x2,%esi
801021da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021dc:	53                   	push   %ebx
801021dd:	e8 fe 1e 00 00       	call   801040e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021e2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021e7:	83 c4 10             	add    $0x10,%esp
801021ea:	85 c0                	test   %eax,%eax
801021ec:	74 05                	je     801021f3 <ideintr+0x83>
    idestart(idequeue);
801021ee:	e8 0d fe ff ff       	call   80102000 <idestart>
    release(&idelock);
801021f3:	83 ec 0c             	sub    $0xc,%esp
801021f6:	68 80 a5 10 80       	push   $0x8010a580
801021fb:	e8 70 22 00 00       	call   80104470 <release>

  release(&idelock);
}
80102200:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102203:	5b                   	pop    %ebx
80102204:	5e                   	pop    %esi
80102205:	5f                   	pop    %edi
80102206:	5d                   	pop    %ebp
80102207:	c3                   	ret    
80102208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010220f:	90                   	nop

80102210 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	53                   	push   %ebx
80102214:	83 ec 04             	sub    $0x4,%esp
80102217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010221a:	8b 03                	mov    (%ebx),%eax
8010221c:	a8 01                	test   $0x1,%al
8010221e:	0f 84 cd 00 00 00    	je     801022f1 <iderw+0xe1>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102224:	83 e0 06             	and    $0x6,%eax
80102227:	83 f8 02             	cmp    $0x2,%eax
8010222a:	0f 84 b4 00 00 00    	je     801022e4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102230:	8b 53 04             	mov    0x4(%ebx),%edx
80102233:	85 d2                	test   %edx,%edx
80102235:	74 0d                	je     80102244 <iderw+0x34>
80102237:	a1 60 a5 10 80       	mov    0x8010a560,%eax
8010223c:	85 c0                	test   %eax,%eax
8010223e:	0f 84 93 00 00 00    	je     801022d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 80 a5 10 80       	push   $0x8010a580
8010224c:	e8 4f 20 00 00       	call   801042a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102251:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102257:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010225e:	83 c4 10             	add    $0x10,%esp
80102261:	85 d2                	test   %edx,%edx
80102263:	75 0d                	jne    80102272 <iderw+0x62>
80102265:	eb 69                	jmp    801022d0 <iderw+0xc0>
80102267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010226e:	66 90                	xchg   %ax,%ax
80102270:	89 c2                	mov    %eax,%edx
80102272:	8b 42 14             	mov    0x14(%edx),%eax
80102275:	85 c0                	test   %eax,%eax
80102277:	75 f7                	jne    80102270 <iderw+0x60>
80102279:	83 c2 14             	add    $0x14,%edx
    ;
  *pp = b;
8010227c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010227e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102284:	74 3a                	je     801022c0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102286:	8b 03                	mov    (%ebx),%eax
80102288:	83 e0 06             	and    $0x6,%eax
8010228b:	83 f8 02             	cmp    $0x2,%eax
8010228e:	74 1b                	je     801022ab <iderw+0x9b>
    sleep(b, &idelock);
80102290:	83 ec 08             	sub    $0x8,%esp
80102293:	68 80 a5 10 80       	push   $0x8010a580
80102298:	53                   	push   %ebx
80102299:	e8 a2 1c 00 00       	call   80103f40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010229e:	8b 03                	mov    (%ebx),%eax
801022a0:	83 c4 10             	add    $0x10,%esp
801022a3:	83 e0 06             	and    $0x6,%eax
801022a6:	83 f8 02             	cmp    $0x2,%eax
801022a9:	75 e5                	jne    80102290 <iderw+0x80>
  }

  release(&idelock);
801022ab:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022b5:	c9                   	leave  
  release(&idelock);
801022b6:	e9 b5 21 00 00       	jmp    80104470 <release>
801022bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop
    idestart(b);
801022c0:	89 d8                	mov    %ebx,%eax
801022c2:	e8 39 fd ff ff       	call   80102000 <idestart>
801022c7:	eb bd                	jmp    80102286 <iderw+0x76>
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022d5:	eb a5                	jmp    8010227c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801022d7:	83 ec 0c             	sub    $0xc,%esp
801022da:	68 c8 70 10 80       	push   $0x801070c8
801022df:	e8 ac e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 b3 70 10 80       	push   $0x801070b3
801022ec:	e8 9f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not busy");
801022f1:	83 ec 0c             	sub    $0xc,%esp
801022f4:	68 9f 70 10 80       	push   $0x8010709f
801022f9:	e8 92 e0 ff ff       	call   80100390 <panic>
801022fe:	66 90                	xchg   %ax,%ax

80102300 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102300:	a1 c4 12 11 80       	mov    0x801112c4,%eax
80102305:	85 c0                	test   %eax,%eax
80102307:	0f 84 b3 00 00 00    	je     801023c0 <ioapicinit+0xc0>
{
8010230d:	55                   	push   %ebp
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010230e:	c7 05 94 11 11 80 00 	movl   $0xfec00000,0x80111194
80102315:	00 c0 fe 
{
80102318:	89 e5                	mov    %esp,%ebp
8010231a:	56                   	push   %esi
8010231b:	53                   	push   %ebx
  ioapic->reg = reg;
8010231c:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102323:	00 00 00 
  return ioapic->data;
80102326:	8b 15 94 11 11 80    	mov    0x80111194,%edx
8010232c:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
8010232f:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102335:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010233b:	0f b6 15 c0 12 11 80 	movzbl 0x801112c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102342:	c1 ee 10             	shr    $0x10,%esi
80102345:	89 f0                	mov    %esi,%eax
80102347:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010234a:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
8010234d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102350:	39 c2                	cmp    %eax,%edx
80102352:	75 4c                	jne    801023a0 <ioapicinit+0xa0>
80102354:	83 c6 21             	add    $0x21,%esi
{
80102357:	ba 10 00 00 00       	mov    $0x10,%edx
8010235c:	b8 20 00 00 00       	mov    $0x20,%eax
80102361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102368:	89 11                	mov    %edx,(%ecx)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010236a:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
8010236c:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
80102372:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102375:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
8010237b:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
8010237e:	8d 5a 01             	lea    0x1(%edx),%ebx
80102381:	83 c2 02             	add    $0x2,%edx
80102384:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102386:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
8010238c:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102393:	39 f0                	cmp    %esi,%eax
80102395:	75 d1                	jne    80102368 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102397:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010239a:	5b                   	pop    %ebx
8010239b:	5e                   	pop    %esi
8010239c:	5d                   	pop    %ebp
8010239d:	c3                   	ret    
8010239e:	66 90                	xchg   %ax,%ax
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 e8 70 10 80       	push   $0x801070e8
801023a8:	e8 03 e3 ff ff       	call   801006b0 <cprintf>
801023ad:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
801023b3:	83 c4 10             	add    $0x10,%esp
801023b6:	eb 9c                	jmp    80102354 <ioapicinit+0x54>
801023b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023bf:	90                   	nop
801023c0:	c3                   	ret    
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023cf:	90                   	nop

801023d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023d0:	55                   	push   %ebp
  if(!ismp)
801023d1:	8b 15 c4 12 11 80    	mov    0x801112c4,%edx
{
801023d7:	89 e5                	mov    %esp,%ebp
801023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801023dc:	85 d2                	test   %edx,%edx
801023de:	74 2b                	je     8010240b <ioapicenable+0x3b>
  ioapic->reg = reg;
801023e0:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023e6:	8d 50 20             	lea    0x20(%eax),%edx
801023e9:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023ed:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023ef:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023f5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023f8:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023fe:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102400:	a1 94 11 11 80       	mov    0x80111194,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102405:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102408:	89 50 10             	mov    %edx,0x10(%eax)
}
8010240b:	5d                   	pop    %ebp
8010240c:	c3                   	ret    
8010240d:	66 90                	xchg   %ax,%ax
8010240f:	90                   	nop

80102410 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	53                   	push   %ebx
80102414:	83 ec 04             	sub    $0x4,%esp
80102417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010241a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102420:	75 76                	jne    80102498 <kfree+0x88>
80102422:	81 fb 68 40 11 80    	cmp    $0x80114068,%ebx
80102428:	72 6e                	jb     80102498 <kfree+0x88>
8010242a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102430:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102435:	77 61                	ja     80102498 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102437:	83 ec 04             	sub    $0x4,%esp
8010243a:	68 00 10 00 00       	push   $0x1000
8010243f:	6a 01                	push   $0x1
80102441:	53                   	push   %ebx
80102442:	e8 79 20 00 00       	call   801044c0 <memset>

  if(kmem.use_lock)
80102447:	8b 15 d4 11 11 80    	mov    0x801111d4,%edx
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	85 d2                	test   %edx,%edx
80102452:	75 1c                	jne    80102470 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102454:	a1 d8 11 11 80       	mov    0x801111d8,%eax
80102459:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010245b:	a1 d4 11 11 80       	mov    0x801111d4,%eax
  kmem.freelist = r;
80102460:	89 1d d8 11 11 80    	mov    %ebx,0x801111d8
  if(kmem.use_lock)
80102466:	85 c0                	test   %eax,%eax
80102468:	75 1e                	jne    80102488 <kfree+0x78>
    release(&kmem.lock);
}
8010246a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010246d:	c9                   	leave  
8010246e:	c3                   	ret    
8010246f:	90                   	nop
    acquire(&kmem.lock);
80102470:	83 ec 0c             	sub    $0xc,%esp
80102473:	68 a0 11 11 80       	push   $0x801111a0
80102478:	e8 23 1e 00 00       	call   801042a0 <acquire>
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	eb d2                	jmp    80102454 <kfree+0x44>
80102482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102488:	c7 45 08 a0 11 11 80 	movl   $0x801111a0,0x8(%ebp)
}
8010248f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102492:	c9                   	leave  
    release(&kmem.lock);
80102493:	e9 d8 1f 00 00       	jmp    80104470 <release>
    panic("kfree");
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	68 1a 71 10 80       	push   $0x8010711a
801024a0:	e8 eb de ff ff       	call   80100390 <panic>
801024a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024b0 <freerange>:
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801024b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801024ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024cd:	39 de                	cmp    %ebx,%esi
801024cf:	72 23                	jb     801024f4 <freerange+0x44>
801024d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024e7:	50                   	push   %eax
801024e8:	e8 23 ff ff ff       	call   80102410 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ed:	83 c4 10             	add    $0x10,%esp
801024f0:	39 f3                	cmp    %esi,%ebx
801024f2:	76 e4                	jbe    801024d8 <freerange+0x28>
}
801024f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f7:	5b                   	pop    %ebx
801024f8:	5e                   	pop    %esi
801024f9:	5d                   	pop    %ebp
801024fa:	c3                   	ret    
801024fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024ff:	90                   	nop

80102500 <kinit1>:
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	56                   	push   %esi
80102504:	53                   	push   %ebx
80102505:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102508:	83 ec 08             	sub    $0x8,%esp
8010250b:	68 20 71 10 80       	push   $0x80107120
80102510:	68 a0 11 11 80       	push   $0x801111a0
80102515:	e8 66 1d 00 00       	call   80104280 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010251a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010251d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102520:	c7 05 d4 11 11 80 00 	movl   $0x0,0x801111d4
80102527:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010252a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102530:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102536:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010253c:	39 de                	cmp    %ebx,%esi
8010253e:	72 1c                	jb     8010255c <kinit1+0x5c>
    kfree(p);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102549:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010254f:	50                   	push   %eax
80102550:	e8 bb fe ff ff       	call   80102410 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102555:	83 c4 10             	add    $0x10,%esp
80102558:	39 de                	cmp    %ebx,%esi
8010255a:	73 e4                	jae    80102540 <kinit1+0x40>
}
8010255c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010255f:	5b                   	pop    %ebx
80102560:	5e                   	pop    %esi
80102561:	5d                   	pop    %ebp
80102562:	c3                   	ret    
80102563:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102570 <kinit2>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102574:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102577:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <kinit2+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 63 fe ff ff       	call   80102410 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	73 e4                	jae    80102598 <kinit2+0x28>
  kmem.use_lock = 1;
801025b4:	c7 05 d4 11 11 80 01 	movl   $0x1,0x801111d4
801025bb:	00 00 00 
}
801025be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c1:	5b                   	pop    %ebx
801025c2:	5e                   	pop    %esi
801025c3:	5d                   	pop    %ebp
801025c4:	c3                   	ret    
801025c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	53                   	push   %ebx
801025d4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801025d7:	a1 d4 11 11 80       	mov    0x801111d4,%eax
801025dc:	85 c0                	test   %eax,%eax
801025de:	75 20                	jne    80102600 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025e0:	8b 1d d8 11 11 80    	mov    0x801111d8,%ebx
  if(r)
801025e6:	85 db                	test   %ebx,%ebx
801025e8:	74 07                	je     801025f1 <kalloc+0x21>
    kmem.freelist = r->next;
801025ea:	8b 03                	mov    (%ebx),%eax
801025ec:	a3 d8 11 11 80       	mov    %eax,0x801111d8
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801025f1:	89 d8                	mov    %ebx,%eax
801025f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025f6:	c9                   	leave  
801025f7:	c3                   	ret    
801025f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ff:	90                   	nop
    acquire(&kmem.lock);
80102600:	83 ec 0c             	sub    $0xc,%esp
80102603:	68 a0 11 11 80       	push   $0x801111a0
80102608:	e8 93 1c 00 00       	call   801042a0 <acquire>
  r = kmem.freelist;
8010260d:	8b 1d d8 11 11 80    	mov    0x801111d8,%ebx
  if(r)
80102613:	83 c4 10             	add    $0x10,%esp
80102616:	a1 d4 11 11 80       	mov    0x801111d4,%eax
8010261b:	85 db                	test   %ebx,%ebx
8010261d:	74 08                	je     80102627 <kalloc+0x57>
    kmem.freelist = r->next;
8010261f:	8b 13                	mov    (%ebx),%edx
80102621:	89 15 d8 11 11 80    	mov    %edx,0x801111d8
  if(kmem.use_lock)
80102627:	85 c0                	test   %eax,%eax
80102629:	74 c6                	je     801025f1 <kalloc+0x21>
    release(&kmem.lock);
8010262b:	83 ec 0c             	sub    $0xc,%esp
8010262e:	68 a0 11 11 80       	push   $0x801111a0
80102633:	e8 38 1e 00 00       	call   80104470 <release>
}
80102638:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010263a:	83 c4 10             	add    $0x10,%esp
}
8010263d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102640:	c9                   	leave  
80102641:	c3                   	ret    
80102642:	66 90                	xchg   %ax,%ax
80102644:	66 90                	xchg   %ax,%ax
80102646:	66 90                	xchg   %ax,%ax
80102648:	66 90                	xchg   %ax,%ax
8010264a:	66 90                	xchg   %ax,%ax
8010264c:	66 90                	xchg   %ax,%ax
8010264e:	66 90                	xchg   %ax,%ax

80102650 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102650:	ba 64 00 00 00       	mov    $0x64,%edx
80102655:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102656:	a8 01                	test   $0x1,%al
80102658:	0f 84 c2 00 00 00    	je     80102720 <kbdgetc+0xd0>
{
8010265e:	55                   	push   %ebp
8010265f:	ba 60 00 00 00       	mov    $0x60,%edx
80102664:	89 e5                	mov    %esp,%ebp
80102666:	53                   	push   %ebx
80102667:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102668:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010266b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102671:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102677:	74 57                	je     801026d0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102679:	89 d9                	mov    %ebx,%ecx
8010267b:	83 e1 40             	and    $0x40,%ecx
8010267e:	84 c0                	test   %al,%al
80102680:	78 5e                	js     801026e0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102682:	85 c9                	test   %ecx,%ecx
80102684:	74 09                	je     8010268f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102686:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102689:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010268c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010268f:	0f b6 8a 60 72 10 80 	movzbl -0x7fef8da0(%edx),%ecx
  shift ^= togglecode[data];
80102696:	0f b6 82 60 71 10 80 	movzbl -0x7fef8ea0(%edx),%eax
  shift |= shiftcode[data];
8010269d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010269f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026a1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026a3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026a9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026ac:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026af:	8b 04 85 40 71 10 80 	mov    -0x7fef8ec0(,%eax,4),%eax
801026b6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801026ba:	74 0b                	je     801026c7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801026bc:	8d 50 9f             	lea    -0x61(%eax),%edx
801026bf:	83 fa 19             	cmp    $0x19,%edx
801026c2:	77 44                	ja     80102708 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026c4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026c7:	5b                   	pop    %ebx
801026c8:	5d                   	pop    %ebp
801026c9:	c3                   	ret    
801026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801026d0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801026d3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026d5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801026db:	5b                   	pop    %ebx
801026dc:	5d                   	pop    %ebp
801026dd:	c3                   	ret    
801026de:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026e0:	83 e0 7f             	and    $0x7f,%eax
801026e3:	85 c9                	test   %ecx,%ecx
801026e5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026e8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026ea:	0f b6 8a 60 72 10 80 	movzbl -0x7fef8da0(%edx),%ecx
801026f1:	83 c9 40             	or     $0x40,%ecx
801026f4:	0f b6 c9             	movzbl %cl,%ecx
801026f7:	f7 d1                	not    %ecx
801026f9:	21 d9                	and    %ebx,%ecx
}
801026fb:	5b                   	pop    %ebx
801026fc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801026fd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102703:	c3                   	ret    
80102704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102708:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010270b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010270e:	5b                   	pop    %ebx
8010270f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102710:	83 f9 1a             	cmp    $0x1a,%ecx
80102713:	0f 42 c2             	cmovb  %edx,%eax
}
80102716:	c3                   	ret    
80102717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271e:	66 90                	xchg   %ax,%ax
    return -1;
80102720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102725:	c3                   	ret    
80102726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272d:	8d 76 00             	lea    0x0(%esi),%esi

80102730 <kbdintr>:

void
kbdintr(void)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102736:	68 50 26 10 80       	push   $0x80102650
8010273b:	e8 20 e1 ff ff       	call   80100860 <consoleintr>
}
80102740:	83 c4 10             	add    $0x10,%esp
80102743:	c9                   	leave  
80102744:	c3                   	ret    
80102745:	66 90                	xchg   %ax,%ax
80102747:	66 90                	xchg   %ax,%ax
80102749:	66 90                	xchg   %ax,%ax
8010274b:	66 90                	xchg   %ax,%ax
8010274d:	66 90                	xchg   %ax,%ax
8010274f:	90                   	nop

80102750 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102750:	a1 dc 11 11 80       	mov    0x801111dc,%eax
80102755:	85 c0                	test   %eax,%eax
80102757:	0f 84 cb 00 00 00    	je     80102828 <lapicinit+0xd8>
  lapic[index] = value;
8010275d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102764:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102767:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010276a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102771:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102774:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102777:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010277e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102781:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102784:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010278b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010278e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102791:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102798:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010279b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010279e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027a5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ab:	8b 50 30             	mov    0x30(%eax),%edx
801027ae:	c1 ea 10             	shr    $0x10,%edx
801027b1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801027b7:	75 77                	jne    80102830 <lapicinit+0xe0>
  lapic[index] = value;
801027b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102801:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
80102807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010280e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102810:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102816:	80 e6 10             	and    $0x10,%dh
80102819:	75 f5                	jne    80102810 <lapicinit+0xc0>
  lapic[index] = value;
8010281b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102822:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102828:	c3                   	ret    
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102830:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102837:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283a:	8b 50 20             	mov    0x20(%eax),%edx
8010283d:	e9 77 ff ff ff       	jmp    801027b9 <lapicinit+0x69>
80102842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102850 <cpunum>:

int
cpunum(void)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	53                   	push   %ebx
80102854:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102857:	9c                   	pushf  
80102858:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102859:	f6 c4 02             	test   $0x2,%ah
8010285c:	74 12                	je     80102870 <cpunum+0x20>
    static int n;
    if(n++ == 0)
8010285e:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102863:	8d 50 01             	lea    0x1(%eax),%edx
80102866:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010286c:	85 c0                	test   %eax,%eax
8010286e:	74 50                	je     801028c0 <cpunum+0x70>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102870:	a1 dc 11 11 80       	mov    0x801111dc,%eax
80102875:	85 c0                	test   %eax,%eax
80102877:	74 63                	je     801028dc <cpunum+0x8c>
    return 0;

  apicid = lapic[ID] >> 24;
80102879:	8b 48 20             	mov    0x20(%eax),%ecx
  for (i = 0; i < ncpu; ++i) {
8010287c:	8b 1d c0 18 11 80    	mov    0x801118c0,%ebx
  apicid = lapic[ID] >> 24;
80102882:	c1 e9 18             	shr    $0x18,%ecx
  for (i = 0; i < ncpu; ++i) {
80102885:	85 db                	test   %ebx,%ebx
80102887:	7e 5a                	jle    801028e3 <cpunum+0x93>
    if (cpus[i].apicid == apicid)
80102889:	0f b6 05 e0 12 11 80 	movzbl 0x801112e0,%eax
80102890:	39 c1                	cmp    %eax,%ecx
    return 0;
80102892:	b8 00 00 00 00       	mov    $0x0,%eax
    if (cpus[i].apicid == apicid)
80102897:	74 1f                	je     801028b8 <cpunum+0x68>
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < ncpu; ++i) {
801028a0:	83 c0 01             	add    $0x1,%eax
801028a3:	39 c3                	cmp    %eax,%ebx
801028a5:	74 3c                	je     801028e3 <cpunum+0x93>
    if (cpus[i].apicid == apicid)
801028a7:	69 d0 bc 00 00 00    	imul   $0xbc,%eax,%edx
801028ad:	0f b6 92 e0 12 11 80 	movzbl -0x7feeed20(%edx),%edx
801028b4:	39 ca                	cmp    %ecx,%edx
801028b6:	75 e8                	jne    801028a0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801028b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028bb:	c9                   	leave  
801028bc:	c3                   	ret    
801028bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("cpu called from %x with interrupts enabled\n",
801028c0:	83 ec 08             	sub    $0x8,%esp
801028c3:	ff 75 04             	pushl  0x4(%ebp)
801028c6:	68 60 73 10 80       	push   $0x80107360
801028cb:	e8 e0 dd ff ff       	call   801006b0 <cprintf>
  if (!lapic)
801028d0:	a1 dc 11 11 80       	mov    0x801111dc,%eax
      cprintf("cpu called from %x with interrupts enabled\n",
801028d5:	83 c4 10             	add    $0x10,%esp
  if (!lapic)
801028d8:	85 c0                	test   %eax,%eax
801028da:	75 9d                	jne    80102879 <cpunum+0x29>
    return 0;
801028dc:	31 c0                	xor    %eax,%eax
}
801028de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028e1:	c9                   	leave  
801028e2:	c3                   	ret    
  panic("unknown apicid\n");
801028e3:	83 ec 0c             	sub    $0xc,%esp
801028e6:	68 8c 73 10 80       	push   $0x8010738c
801028eb:	e8 a0 da ff ff       	call   80100390 <panic>

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 dc 11 11 80       	mov    0x801111dc,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 0d                	je     80102906 <lapiceoi+0x16>
  lapic[index] = value;
801028f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102900:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102903:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102906:	c3                   	ret    
80102907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290e:	66 90                	xchg   %ax,%ax

80102910 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102910:	c3                   	ret    
80102911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102950:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102952:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 dc 11 11 80       	mov    0x801111dc,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801029a7:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029a8:	8b 40 20             	mov    0x20(%eax),%eax
}
801029ab:	5d                   	pop    %ebp
801029ac:	c3                   	ret    
801029ad:	8d 76 00             	lea    0x0(%esi),%esi

801029b0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bb 70 00 00 00       	mov    $0x70,%ebx
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 da                	mov    %ebx,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 da                	mov    %ebx,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 da                	mov    %ebx,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 da                	mov    %ebx,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 da                	mov    %ebx,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 da                	mov    %ebx,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2c:	89 da                	mov    %ebx,%edx
80102a2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	89 ca                	mov    %ecx,%edx
80102a36:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a37:	84 c0                	test   %al,%al
80102a39:	78 9d                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a3f:	89 fa                	mov    %edi,%edx
80102a41:	0f b6 fa             	movzbl %dl,%edi
80102a44:	89 f2                	mov    %esi,%edx
80102a46:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a49:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a4d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a50:	89 da                	mov    %ebx,%edx
80102a52:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a55:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a58:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a69:	31 c0                	xor    %eax,%eax
80102a6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6c:	89 ca                	mov    %ecx,%edx
80102a6e:	ec                   	in     (%dx),%al
80102a6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a72:	89 da                	mov    %ebx,%edx
80102a74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a77:	b8 02 00 00 00       	mov    $0x2,%eax
80102a7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7d:	89 ca                	mov    %ecx,%edx
80102a7f:	ec                   	in     (%dx),%al
80102a80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a83:	89 da                	mov    %ebx,%edx
80102a85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a88:	b8 04 00 00 00       	mov    $0x4,%eax
80102a8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8e:	89 ca                	mov    %ecx,%edx
80102a90:	ec                   	in     (%dx),%al
80102a91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 da                	mov    %ebx,%edx
80102a96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a99:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9f:	89 ca                	mov    %ecx,%edx
80102aa1:	ec                   	in     (%dx),%al
80102aa2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa5:	89 da                	mov    %ebx,%edx
80102aa7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aaa:	b8 08 00 00 00       	mov    $0x8,%eax
80102aaf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab0:	89 ca                	mov    %ecx,%edx
80102ab2:	ec                   	in     (%dx),%al
80102ab3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab6:	89 da                	mov    %ebx,%edx
80102ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102abb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ac0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac1:	89 ca                	mov    %ecx,%edx
80102ac3:	ec                   	in     (%dx),%al
80102ac4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102acd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ad0:	6a 18                	push   $0x18
80102ad2:	50                   	push   %eax
80102ad3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad6:	50                   	push   %eax
80102ad7:	e8 34 1a 00 00       	call   80104510 <memcmp>
80102adc:	83 c4 10             	add    $0x10,%esp
80102adf:	85 c0                	test   %eax,%eax
80102ae1:	0f 85 f1 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102aeb:	75 78                	jne    80102b65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102aed:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af0:	89 c2                	mov    %eax,%edx
80102af2:	83 e0 0f             	and    $0xf,%eax
80102af5:	c1 ea 04             	shr    $0x4,%edx
80102af8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b04:	89 c2                	mov    %eax,%edx
80102b06:	83 e0 0f             	and    $0xf,%eax
80102b09:	c1 ea 04             	shr    $0x4,%edx
80102b0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b18:	89 c2                	mov    %eax,%edx
80102b1a:	83 e0 0f             	and    $0xf,%eax
80102b1d:	c1 ea 04             	shr    $0x4,%edx
80102b20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2c:	89 c2                	mov    %eax,%edx
80102b2e:	83 e0 0f             	and    $0xf,%eax
80102b31:	c1 ea 04             	shr    $0x4,%edx
80102b34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b40:	89 c2                	mov    %eax,%edx
80102b42:	83 e0 0f             	and    $0xf,%eax
80102b45:	c1 ea 04             	shr    $0x4,%edx
80102b48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b54:	89 c2                	mov    %eax,%edx
80102b56:	83 e0 0f             	and    $0xf,%eax
80102b59:	c1 ea 04             	shr    $0x4,%edx
80102b5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b65:	8b 75 08             	mov    0x8(%ebp),%esi
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 06                	mov    %eax,(%esi)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 46 04             	mov    %eax,0x4(%esi)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 46 08             	mov    %eax,0x8(%esi)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 46 10             	mov    %eax,0x10(%esi)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret    
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
80102bb2:	56                   	push   %esi
80102bb3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb4:	31 db                	xor    %ebx,%ebx
{
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 14 12 11 80       	mov    0x80111214,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 d8                	add    %ebx,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 24 12 11 80    	pushl  0x80111224
80102bd4:	e8 e7 d4 ff ff       	call   801000c0 <bread>
80102bd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 9d 2c 12 11 80 	pushl  -0x7feeedd4(,%ebx,4)
80102be4:	ff 35 24 12 11 80    	pushl  0x80111224
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 ce d4 ff ff       	call   801000c0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 47 18             	lea    0x18(%edi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 46 18             	lea    0x18(%esi),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 57 19 00 00       	call   80104560 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 34 24             	mov    %esi,(%esp)
80102c0c:	e8 bf d5 ff ff       	call   801001d0 <bwrite>
    brelse(lbuf);
80102c11:	89 3c 24             	mov    %edi,(%esp)
80102c14:	e8 e7 d5 ff ff       	call   80100200 <brelse>
    brelse(dbuf);
80102c19:	89 34 24             	mov    %esi,(%esp)
80102c1c:	e8 df d5 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 1d 28 12 11 80    	cmp    %ebx,0x80111228
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 14 12 11 80    	pushl  0x80111214
80102c4d:	ff 35 24 12 11 80    	pushl  0x80111224
80102c53:	e8 68 d4 ff ff       	call   801000c0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 28 12 11 80       	mov    0x80111228,%eax
80102c62:	89 43 18             	mov    %eax,0x18(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	a1 28 12 11 80       	mov    0x80111228,%eax
80102c6a:	85 c0                	test   %eax,%eax
80102c6c:	7e 18                	jle    80102c86 <write_head+0x46>
80102c6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 2c 12 11 80 	mov    -0x7feeedd4(,%edx,4),%ecx
80102c77:	89 4c 93 1c          	mov    %ecx,0x1c(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 15 28 12 11 80    	cmp    %edx,0x80111228
80102c84:	7f ea                	jg     80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c86:	83 ec 0c             	sub    $0xc,%esp
80102c89:	53                   	push   %ebx
80102c8a:	e8 41 d5 ff ff       	call   801001d0 <bwrite>
  brelse(buf);
80102c8f:	89 1c 24             	mov    %ebx,(%esp)
80102c92:	e8 69 d5 ff ff       	call   80100200 <brelse>
}
80102c97:	83 c4 10             	add    $0x10,%esp
80102c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c9d:	c9                   	leave  
80102c9e:	c3                   	ret    
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 9c 73 10 80       	push   $0x8010739c
80102caf:	68 e0 11 11 80       	push   $0x801111e0
80102cb4:	e8 c7 15 00 00       	call   80104280 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 7b e7 ff ff       	call   80101440 <readsb>
  log.start = sb.logstart;
80102cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cc8:	59                   	pop    %ecx
  log.dev = dev;
80102cc9:	89 1d 24 12 11 80    	mov    %ebx,0x80111224
  log.size = sb.nlog;
80102ccf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd2:	a3 14 12 11 80       	mov    %eax,0x80111214
  log.size = sb.nlog;
80102cd7:	89 15 18 12 11 80    	mov    %edx,0x80111218
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 db d3 ff ff       	call   801000c0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ce8:	8b 48 18             	mov    0x18(%eax),%ecx
80102ceb:	89 0d 28 12 11 80    	mov    %ecx,0x80111228
  for (i = 0; i < log.lh.n; i++) {
80102cf1:	85 c9                	test   %ecx,%ecx
80102cf3:	7e 1d                	jle    80102d12 <initlog+0x72>
80102cf5:	31 d2                	xor    %edx,%edx
80102cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cfe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d00:	8b 5c 90 1c          	mov    0x1c(%eax,%edx,4),%ebx
80102d04:	89 1c 95 2c 12 11 80 	mov    %ebx,-0x7feeedd4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d1                	cmp    %edx,%ecx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 e5 d4 ff ff       	call   80100200 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	83 c4 10             	add    $0x10,%esp
80102d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 e0 11 11 80       	push   $0x801111e0
80102d4b:	e8 50 15 00 00       	call   801042a0 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 e0 11 11 80       	push   $0x801111e0
80102d60:	68 e0 11 11 80       	push   $0x801111e0
80102d65:	e8 d6 11 00 00       	call   80103f40 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 20 12 11 80       	mov    0x80111220,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102d7b:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 1c 12 11 80       	mov    %eax,0x8011121c
      release(&log.lock);
80102d97:	68 e0 11 11 80       	push   $0x801111e0
80102d9c:	e8 cf 16 00 00       	call   80104470 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave  
80102da5:	c3                   	ret    
80102da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dad:	8d 76 00             	lea    0x0(%esi),%esi

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 e0 11 11 80       	push   $0x801111e0
80102dbe:	e8 dd 14 00 00       	call   801042a0 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 1c 12 11 80       	mov    0x8011121c,%eax
  if(log.committing)
80102dc8:	8b 35 20 12 11 80    	mov    0x80111220,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd4:	89 1d 1c 12 11 80    	mov    %ebx,0x8011121c
  if(log.committing)
80102dda:	85 f6                	test   %esi,%esi
80102ddc:	0f 85 22 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 f6 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dea:	c7 05 20 12 11 80 01 	movl   $0x1,0x80111220
80102df1:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102df4:	83 ec 0c             	sub    $0xc,%esp
80102df7:	68 e0 11 11 80       	push   $0x801111e0
80102dfc:	e8 6f 16 00 00       	call   80104470 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	7f 42                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e0e:	83 ec 0c             	sub    $0xc,%esp
80102e11:	68 e0 11 11 80       	push   $0x801111e0
80102e16:	e8 85 14 00 00       	call   801042a0 <acquire>
    wakeup(&log);
80102e1b:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
    log.committing = 0;
80102e22:	c7 05 20 12 11 80 00 	movl   $0x0,0x80111220
80102e29:	00 00 00 
    wakeup(&log);
80102e2c:	e8 af 12 00 00       	call   801040e0 <wakeup>
    release(&log.lock);
80102e31:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102e38:	e8 33 16 00 00       	call   80104470 <release>
80102e3d:	83 c4 10             	add    $0x10,%esp
}
80102e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e43:	5b                   	pop    %ebx
80102e44:	5e                   	pop    %esi
80102e45:	5f                   	pop    %edi
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret    
80102e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 14 12 11 80       	mov    0x80111214,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 24 12 11 80    	pushl  0x80111224
80102e64:	e8 57 d2 ff ff       	call   801000c0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d 2c 12 11 80 	pushl  -0x7feeedd4(,%ebx,4)
80102e74:	ff 35 24 12 11 80    	pushl  0x80111224
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 3e d2 ff ff       	call   801000c0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 18             	lea    0x18(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 18             	lea    0x18(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 c7 16 00 00       	call   80104560 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 2f d3 ff ff       	call   801001d0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 57 d3 ff ff       	call   80100200 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 4f d3 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d 28 12 11 80    	cmp    0x80111228,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 34 ff ff ff       	jmp    80102e0e <end_op+0x5e>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 e0 11 11 80       	push   $0x801111e0
80102ee8:	e8 f3 11 00 00       	call   801040e0 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102ef4:	e8 77 15 00 00       	call   80104470 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 a0 73 10 80       	push   $0x801073a0
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f27:	8b 15 28 12 11 80    	mov    0x80111228,%edx
{
80102f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f30:	83 fa 1d             	cmp    $0x1d,%edx
80102f33:	0f 8f 94 00 00 00    	jg     80102fcd <log_write+0xad>
80102f39:	a1 18 12 11 80       	mov    0x80111218,%eax
80102f3e:	83 e8 01             	sub    $0x1,%eax
80102f41:	39 c2                	cmp    %eax,%edx
80102f43:	0f 8d 84 00 00 00    	jge    80102fcd <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f49:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102f4e:	85 c0                	test   %eax,%eax
80102f50:	0f 8e 84 00 00 00    	jle    80102fda <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f56:	83 ec 0c             	sub    $0xc,%esp
80102f59:	68 e0 11 11 80       	push   $0x801111e0
80102f5e:	e8 3d 13 00 00       	call   801042a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f63:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102f69:	83 c4 10             	add    $0x10,%esp
80102f6c:	85 d2                	test   %edx,%edx
80102f6e:	7e 51                	jle    80102fc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f70:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f73:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f75:	3b 0d 2c 12 11 80    	cmp    0x8011122c,%ecx
80102f7b:	75 0c                	jne    80102f89 <log_write+0x69>
80102f7d:	eb 39                	jmp    80102fb8 <log_write+0x98>
80102f7f:	90                   	nop
80102f80:	39 0c 85 2c 12 11 80 	cmp    %ecx,-0x7feeedd4(,%eax,4)
80102f87:	74 2f                	je     80102fb8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f89:	83 c0 01             	add    $0x1,%eax
80102f8c:	39 c2                	cmp    %eax,%edx
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 95 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f97:	83 c2 01             	add    $0x1,%edx
80102f9a:	89 15 28 12 11 80    	mov    %edx,0x80111228
  b->flags |= B_DIRTY; // prevent eviction
80102fa0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fa6:	c7 45 08 e0 11 11 80 	movl   $0x801111e0,0x8(%ebp)
}
80102fad:	c9                   	leave  
  release(&log.lock);
80102fae:	e9 bd 14 00 00       	jmp    80104470 <release>
80102fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fb7:	90                   	nop
  log.lh.block[i] = b->blockno;
80102fb8:	89 0c 85 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%eax,4)
  if (i == log.lh.n)
80102fbf:	eb df                	jmp    80102fa0 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102fc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102fc4:	a3 2c 12 11 80       	mov    %eax,0x8011122c
  if (i == log.lh.n)
80102fc9:	75 d5                	jne    80102fa0 <log_write+0x80>
80102fcb:	eb ca                	jmp    80102f97 <log_write+0x77>
    panic("too big a transaction");
80102fcd:	83 ec 0c             	sub    $0xc,%esp
80102fd0:	68 af 73 10 80       	push   $0x801073af
80102fd5:	e8 b6 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fda:	83 ec 0c             	sub    $0xc,%esp
80102fdd:	68 c5 73 10 80       	push   $0x801073c5
80102fe2:	e8 a9 d3 ff ff       	call   80100390 <panic>
80102fe7:	66 90                	xchg   %ax,%ax
80102fe9:	66 90                	xchg   %ax,%ax
80102feb:	66 90                	xchg   %ax,%ax
80102fed:	66 90                	xchg   %ax,%ax
80102fef:	90                   	nop

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102ff6:	e8 55 f8 ff ff       	call   80102850 <cpunum>
80102ffb:	83 ec 08             	sub    $0x8,%esp
80102ffe:	50                   	push   %eax
80102fff:	68 e0 73 10 80       	push   $0x801073e0
80103004:	e8 a7 d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103009:	e8 32 27 00 00       	call   80105740 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010300e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103015:	b8 01 00 00 00       	mov    $0x1,%eax
8010301a:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80103021:	e8 4a 0c 00 00       	call   80103c70 <scheduler>
80103026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302d:	8d 76 00             	lea    0x0(%esi),%esi

80103030 <mpenter>:
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103036:	e8 d5 38 00 00       	call   80106910 <switchkvm>
  seginit();
8010303b:	e8 60 37 00 00       	call   801067a0 <seginit>
  lapicinit();
80103040:	e8 0b f7 ff ff       	call   80102750 <lapicinit>
  mpmain();
80103045:	e8 a6 ff ff ff       	call   80102ff0 <mpmain>
8010304a:	66 90                	xchg   %ax,%ax
8010304c:	66 90                	xchg   %ax,%ax
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103054:	83 e4 f0             	and    $0xfffffff0,%esp
80103057:	ff 71 fc             	pushl  -0x4(%ecx)
8010305a:	55                   	push   %ebp
8010305b:	89 e5                	mov    %esp,%ebp
8010305d:	53                   	push   %ebx
8010305e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010305f:	83 ec 08             	sub    $0x8,%esp
80103062:	68 00 00 40 80       	push   $0x80400000
80103067:	68 68 40 11 80       	push   $0x80114068
8010306c:	e8 8f f4 ff ff       	call   80102500 <kinit1>
  kvmalloc();      // kernel page table
80103071:	e8 7a 38 00 00       	call   801068f0 <kvmalloc>
  mpinit();        // detect other processors
80103076:	e8 b5 01 00 00       	call   80103230 <mpinit>
  lapicinit();     // interrupt controller
8010307b:	e8 d0 f6 ff ff       	call   80102750 <lapicinit>
  seginit();       // segment descriptors
80103080:	e8 1b 37 00 00       	call   801067a0 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80103085:	e8 c6 f7 ff ff       	call   80102850 <cpunum>
8010308a:	5a                   	pop    %edx
8010308b:	59                   	pop    %ecx
8010308c:	50                   	push   %eax
8010308d:	68 f1 73 10 80       	push   $0x801073f1
80103092:	e8 19 d6 ff ff       	call   801006b0 <cprintf>
  picinit();       // another interrupt controller
80103097:	e8 b4 03 00 00       	call   80103450 <picinit>
  ioapicinit();    // another interrupt controller
8010309c:	e8 5f f2 ff ff       	call   80102300 <ioapicinit>
  consoleinit();   // console hardware
801030a1:	e8 8a d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030a6:	e8 c5 29 00 00       	call   80105a70 <uartinit>
  pinit();         // process table
801030ab:	e8 00 09 00 00       	call   801039b0 <pinit>
  tvinit();        // trap vectors
801030b0:	e8 0b 26 00 00       	call   801056c0 <tvinit>
  binit();         // buffer cache
801030b5:	e8 86 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ba:	e8 11 dd ff ff       	call   80100dd0 <fileinit>
  ideinit();       // disk
801030bf:	e8 1c f0 ff ff       	call   801020e0 <ideinit>
  if(!ismp)
801030c4:	8b 1d c4 12 11 80    	mov    0x801112c4,%ebx
801030ca:	83 c4 10             	add    $0x10,%esp
801030cd:	85 db                	test   %ebx,%ebx
801030cf:	0f 84 cf 00 00 00    	je     801031a4 <main+0x154>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d5:	83 ec 04             	sub    $0x4,%esp
801030d8:	68 8a 00 00 00       	push   $0x8a
801030dd:	68 8c a4 10 80       	push   $0x8010a48c
801030e2:	68 00 70 00 80       	push   $0x80007000
801030e7:	e8 74 14 00 00       	call   80104560 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030ec:	83 c4 10             	add    $0x10,%esp
801030ef:	69 05 c0 18 11 80 bc 	imul   $0xbc,0x801118c0,%eax
801030f6:	00 00 00 
801030f9:	05 e0 12 11 80       	add    $0x801112e0,%eax
801030fe:	3d e0 12 11 80       	cmp    $0x801112e0,%eax
80103103:	0f 86 7f 00 00 00    	jbe    80103188 <main+0x138>
80103109:	bb e0 12 11 80       	mov    $0x801112e0,%ebx
8010310e:	eb 19                	jmp    80103129 <main+0xd9>
80103110:	69 05 c0 18 11 80 bc 	imul   $0xbc,0x801118c0,%eax
80103117:	00 00 00 
8010311a:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80103120:	05 e0 12 11 80       	add    $0x801112e0,%eax
80103125:	39 c3                	cmp    %eax,%ebx
80103127:	73 5f                	jae    80103188 <main+0x138>
    if(c == cpus+cpunum())  // We've started already.
80103129:	e8 22 f7 ff ff       	call   80102850 <cpunum>
8010312e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103134:	05 e0 12 11 80       	add    $0x801112e0,%eax
80103139:	39 c3                	cmp    %eax,%ebx
8010313b:	74 d3                	je     80103110 <main+0xc0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010313d:	e8 8e f4 ff ff       	call   801025d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103142:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
80103145:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
8010314c:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010314f:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103156:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103159:	05 00 10 00 00       	add    $0x1000,%eax
8010315e:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103163:	68 00 70 00 00       	push   $0x7000
80103168:	0f b6 03             	movzbl (%ebx),%eax
8010316b:	50                   	push   %eax
8010316c:	e8 af f7 ff ff       	call   80102920 <lapicstartap>
80103171:	83 c4 10             	add    $0x10,%esp
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103178:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
8010317e:	85 c0                	test   %eax,%eax
80103180:	74 f6                	je     80103178 <main+0x128>
80103182:	eb 8c                	jmp    80103110 <main+0xc0>
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103188:	83 ec 08             	sub    $0x8,%esp
8010318b:	68 00 00 00 8e       	push   $0x8e000000
80103190:	68 00 00 40 80       	push   $0x80400000
80103195:	e8 d6 f3 ff ff       	call   80102570 <kinit2>
  userinit();      // first user process
8010319a:	e8 31 08 00 00       	call   801039d0 <userinit>
  mpmain();        // finish this processor's setup
8010319f:	e8 4c fe ff ff       	call   80102ff0 <mpmain>
    timerinit();   // uniprocessor timer
801031a4:	e8 b7 24 00 00       	call   80105660 <timerinit>
801031a9:	e9 27 ff ff ff       	jmp    801030d5 <main+0x85>
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031bb:	53                   	push   %ebx
  e = addr+len;
801031bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031c2:	39 de                	cmp    %ebx,%esi
801031c4:	72 10                	jb     801031d6 <mpsearch1+0x26>
801031c6:	eb 50                	jmp    80103218 <mpsearch1+0x68>
801031c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop
801031d0:	89 fe                	mov    %edi,%esi
801031d2:	39 fb                	cmp    %edi,%ebx
801031d4:	76 42                	jbe    80103218 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d6:	83 ec 04             	sub    $0x4,%esp
801031d9:	8d 7e 10             	lea    0x10(%esi),%edi
801031dc:	6a 04                	push   $0x4
801031de:	68 08 74 10 80       	push   $0x80107408
801031e3:	56                   	push   %esi
801031e4:	e8 27 13 00 00       	call   80104510 <memcmp>
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	85 c0                	test   %eax,%eax
801031ee:	75 e0                	jne    801031d0 <mpsearch1+0x20>
801031f0:	89 f1                	mov    %esi,%ecx
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031f8:	0f b6 11             	movzbl (%ecx),%edx
801031fb:	83 c1 01             	add    $0x1,%ecx
801031fe:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103200:	39 f9                	cmp    %edi,%ecx
80103202:	75 f4                	jne    801031f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103204:	84 c0                	test   %al,%al
80103206:	75 c8                	jne    801031d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320b:	89 f0                	mov    %esi,%eax
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5f                   	pop    %edi
80103210:	5d                   	pop    %ebp
80103211:	c3                   	ret    
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010321b:	31 f6                	xor    %esi,%esi
}
8010321d:	5b                   	pop    %ebx
8010321e:	89 f0                	mov    %esi,%eax
80103220:	5e                   	pop    %esi
80103221:	5f                   	pop    %edi
80103222:	5d                   	pop    %ebp
80103223:	c3                   	ret    
80103224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop

80103230 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103239:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103240:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103247:	c1 e0 08             	shl    $0x8,%eax
8010324a:	09 d0                	or     %edx,%eax
8010324c:	c1 e0 04             	shl    $0x4,%eax
8010324f:	75 1b                	jne    8010326c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103251:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103258:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010325f:	c1 e0 08             	shl    $0x8,%eax
80103262:	09 d0                	or     %edx,%eax
80103264:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103267:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010326c:	ba 00 04 00 00       	mov    $0x400,%edx
80103271:	e8 3a ff ff ff       	call   801031b0 <mpsearch1>
80103276:	89 c6                	mov    %eax,%esi
80103278:	85 c0                	test   %eax,%eax
8010327a:	0f 84 50 01 00 00    	je     801033d0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103280:	8b 5e 04             	mov    0x4(%esi),%ebx
80103283:	85 db                	test   %ebx,%ebx
80103285:	0f 84 ec 00 00 00    	je     80103377 <mpinit+0x147>
  if(memcmp(conf, "PCMP", 4) != 0)
8010328b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103294:	6a 04                	push   $0x4
80103296:	68 0d 74 10 80       	push   $0x8010740d
8010329b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010329c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010329f:	e8 6c 12 00 00       	call   80104510 <memcmp>
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	85 c0                	test   %eax,%eax
801032a9:	0f 85 c8 00 00 00    	jne    80103377 <mpinit+0x147>
  if(conf->version != 1 && conf->version != 4)
801032af:	0f b6 93 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%edx
801032b6:	80 fa 01             	cmp    $0x1,%dl
801032b9:	0f 95 c1             	setne  %cl
801032bc:	80 fa 04             	cmp    $0x4,%dl
801032bf:	0f 95 c2             	setne  %dl
801032c2:	20 d1                	and    %dl,%cl
801032c4:	0f 85 ad 00 00 00    	jne    80103377 <mpinit+0x147>
  if(sum((uchar*)conf, conf->length) != 0)
801032ca:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801032d1:	66 85 ff             	test   %di,%di
801032d4:	74 1f                	je     801032f5 <mpinit+0xc5>
801032d6:	89 da                	mov    %ebx,%edx
801032d8:	01 df                	add    %ebx,%edi
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032e0:	0f b6 8a 00 00 00 80 	movzbl -0x80000000(%edx),%ecx
801032e7:	83 c2 01             	add    $0x1,%edx
801032ea:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032ec:	39 fa                	cmp    %edi,%edx
801032ee:	75 f0                	jne    801032e0 <mpinit+0xb0>
801032f0:	84 c0                	test   %al,%al
801032f2:	0f 95 c1             	setne  %cl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801032f8:	85 ff                	test   %edi,%edi
801032fa:	74 7b                	je     80103377 <mpinit+0x147>
801032fc:	84 c9                	test   %cl,%cl
801032fe:	75 77                	jne    80103377 <mpinit+0x147>
    return;
  ismp = 1;
80103300:	c7 05 c4 12 11 80 01 	movl   $0x1,0x801112c4
80103307:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010330a:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103310:	a3 dc 11 11 80       	mov    %eax,0x801111dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103315:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
8010331c:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103322:	01 f9                	add    %edi,%ecx
80103324:	39 c8                	cmp    %ecx,%eax
80103326:	73 34                	jae    8010335c <mpinit+0x12c>
80103328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332f:	90                   	nop
    switch(*p){
80103330:	80 38 04             	cmpb   $0x4,(%eax)
80103333:	0f 87 87 00 00 00    	ja     801033c0 <mpinit+0x190>
80103339:	0f b6 10             	movzbl (%eax),%edx
8010333c:	ff 24 95 14 74 10 80 	jmp    *-0x7fef8bec(,%edx,4)
80103343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103347:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103348:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010334b:	39 c1                	cmp    %eax,%ecx
8010334d:	77 e1                	ja     80103330 <mpinit+0x100>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
8010334f:	a1 c4 12 11 80       	mov    0x801112c4,%eax
80103354:	85 c0                	test   %eax,%eax
80103356:	0f 84 94 00 00 00    	je     801033f0 <mpinit+0x1c0>
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
8010335c:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103360:	74 15                	je     80103377 <mpinit+0x147>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103362:	b8 70 00 00 00       	mov    $0x70,%eax
80103367:	ba 22 00 00 00       	mov    $0x22,%edx
8010336c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010336d:	ba 23 00 00 00       	mov    $0x23,%edx
80103372:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103373:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103376:	ee                   	out    %al,(%dx)
  }
}
80103377:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010337a:	5b                   	pop    %ebx
8010337b:	5e                   	pop    %esi
8010337c:	5f                   	pop    %edi
8010337d:	5d                   	pop    %ebp
8010337e:	c3                   	ret    
8010337f:	90                   	nop
      if(ncpu < NCPU) {
80103380:	8b 15 c0 18 11 80    	mov    0x801118c0,%edx
80103386:	83 fa 07             	cmp    $0x7,%edx
80103389:	7f 19                	jg     801033a4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338b:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
80103391:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103395:	83 c2 01             	add    $0x1,%edx
80103398:	89 15 c0 18 11 80    	mov    %edx,0x801118c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339e:	88 9f e0 12 11 80    	mov    %bl,-0x7feeed20(%edi)
      p += sizeof(struct mpproc);
801033a4:	83 c0 14             	add    $0x14,%eax
      continue;
801033a7:	eb a2                	jmp    8010334b <mpinit+0x11b>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033b7:	88 15 c0 12 11 80    	mov    %dl,0x801112c0
      continue;
801033bd:	eb 8c                	jmp    8010334b <mpinit+0x11b>
801033bf:	90                   	nop
      ismp = 0;
801033c0:	c7 05 c4 12 11 80 00 	movl   $0x0,0x801112c4
801033c7:	00 00 00 
      break;
801033ca:	e9 7c ff ff ff       	jmp    8010334b <mpinit+0x11b>
801033cf:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
801033d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033da:	e8 d1 fd ff ff       	call   801031b0 <mpsearch1>
801033df:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033e1:	85 c0                	test   %eax,%eax
801033e3:	0f 85 97 fe ff ff    	jne    80103280 <mpinit+0x50>
801033e9:	eb 8c                	jmp    80103377 <mpinit+0x147>
801033eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033ef:	90                   	nop
    ncpu = 1;
801033f0:	c7 05 c0 18 11 80 01 	movl   $0x1,0x801118c0
801033f7:	00 00 00 
    lapic = 0;
801033fa:	c7 05 dc 11 11 80 00 	movl   $0x0,0x801111dc
80103401:	00 00 00 
    ioapicid = 0;
80103404:	c6 05 c0 12 11 80 00 	movb   $0x0,0x801112c0
}
8010340b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010340e:	5b                   	pop    %ebx
8010340f:	5e                   	pop    %esi
80103410:	5f                   	pop    %edi
80103411:	5d                   	pop    %ebp
80103412:	c3                   	ret    
80103413:	66 90                	xchg   %ax,%ax
80103415:	66 90                	xchg   %ax,%ax
80103417:	66 90                	xchg   %ax,%ax
80103419:	66 90                	xchg   %ax,%ax
8010341b:	66 90                	xchg   %ax,%ax
8010341d:	66 90                	xchg   %ax,%ax
8010341f:	90                   	nop

80103420 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103420:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103421:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103426:	ba 21 00 00 00       	mov    $0x21,%edx
{
8010342b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010342d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103430:	d3 c0                	rol    %cl,%eax
80103432:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
  irqmask = mask;
80103439:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010343f:	ee                   	out    %al,(%dx)
80103440:	ba a1 00 00 00       	mov    $0xa1,%edx
  outb(IO_PIC2+1, mask >> 8);
80103445:	66 c1 e8 08          	shr    $0x8,%ax
80103449:	ee                   	out    %al,(%dx)
}
8010344a:	5d                   	pop    %ebp
8010344b:	c3                   	ret    
8010344c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103450 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103450:	55                   	push   %ebp
80103451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103456:	89 e5                	mov    %esp,%ebp
80103458:	57                   	push   %edi
80103459:	56                   	push   %esi
8010345a:	53                   	push   %ebx
8010345b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103460:	89 da                	mov    %ebx,%edx
80103462:	ee                   	out    %al,(%dx)
80103463:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103468:	89 ca                	mov    %ecx,%edx
8010346a:	ee                   	out    %al,(%dx)
8010346b:	be 11 00 00 00       	mov    $0x11,%esi
80103470:	ba 20 00 00 00       	mov    $0x20,%edx
80103475:	89 f0                	mov    %esi,%eax
80103477:	ee                   	out    %al,(%dx)
80103478:	b8 20 00 00 00       	mov    $0x20,%eax
8010347d:	89 da                	mov    %ebx,%edx
8010347f:	ee                   	out    %al,(%dx)
80103480:	b8 04 00 00 00       	mov    $0x4,%eax
80103485:	ee                   	out    %al,(%dx)
80103486:	bf 03 00 00 00       	mov    $0x3,%edi
8010348b:	89 f8                	mov    %edi,%eax
8010348d:	ee                   	out    %al,(%dx)
8010348e:	ba a0 00 00 00       	mov    $0xa0,%edx
80103493:	89 f0                	mov    %esi,%eax
80103495:	ee                   	out    %al,(%dx)
80103496:	b8 28 00 00 00       	mov    $0x28,%eax
8010349b:	89 ca                	mov    %ecx,%edx
8010349d:	ee                   	out    %al,(%dx)
8010349e:	b8 02 00 00 00       	mov    $0x2,%eax
801034a3:	ee                   	out    %al,(%dx)
801034a4:	89 f8                	mov    %edi,%eax
801034a6:	ee                   	out    %al,(%dx)
801034a7:	bf 68 00 00 00       	mov    $0x68,%edi
801034ac:	ba 20 00 00 00       	mov    $0x20,%edx
801034b1:	89 f8                	mov    %edi,%eax
801034b3:	ee                   	out    %al,(%dx)
801034b4:	be 0a 00 00 00       	mov    $0xa,%esi
801034b9:	89 f0                	mov    %esi,%eax
801034bb:	ee                   	out    %al,(%dx)
801034bc:	ba a0 00 00 00       	mov    $0xa0,%edx
801034c1:	89 f8                	mov    %edi,%eax
801034c3:	ee                   	out    %al,(%dx)
801034c4:	89 f0                	mov    %esi,%eax
801034c6:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801034c7:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
801034ce:	66 83 f8 ff          	cmp    $0xffff,%ax
801034d2:	74 0a                	je     801034de <picinit+0x8e>
801034d4:	89 da                	mov    %ebx,%edx
801034d6:	ee                   	out    %al,(%dx)
  outb(IO_PIC2+1, mask >> 8);
801034d7:	66 c1 e8 08          	shr    $0x8,%ax
801034db:	89 ca                	mov    %ecx,%edx
801034dd:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
801034de:	5b                   	pop    %ebx
801034df:	5e                   	pop    %esi
801034e0:	5f                   	pop    %edi
801034e1:	5d                   	pop    %ebp
801034e2:	c3                   	ret    
801034e3:	66 90                	xchg   %ax,%ax
801034e5:	66 90                	xchg   %ax,%ax
801034e7:	66 90                	xchg   %ax,%ax
801034e9:	66 90                	xchg   %ax,%ax
801034eb:	66 90                	xchg   %ax,%ax
801034ed:	66 90                	xchg   %ax,%ax
801034ef:	90                   	nop

801034f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103505:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010350b:	e8 e0 d8 ff ff       	call   80100df0 <filealloc>
80103510:	89 03                	mov    %eax,(%ebx)
80103512:	85 c0                	test   %eax,%eax
80103514:	0f 84 a8 00 00 00    	je     801035c2 <pipealloc+0xd2>
8010351a:	e8 d1 d8 ff ff       	call   80100df0 <filealloc>
8010351f:	89 06                	mov    %eax,(%esi)
80103521:	85 c0                	test   %eax,%eax
80103523:	0f 84 87 00 00 00    	je     801035b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103529:	e8 a2 f0 ff ff       	call   801025d0 <kalloc>
8010352e:	89 c7                	mov    %eax,%edi
80103530:	85 c0                	test   %eax,%eax
80103532:	0f 84 b0 00 00 00    	je     801035e8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103538:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010353f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103542:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103545:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010354c:	00 00 00 
  p->nwrite = 0;
8010354f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103556:	00 00 00 
  p->nread = 0;
80103559:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103560:	00 00 00 
  initlock(&p->lock, "pipe");
80103563:	68 28 74 10 80       	push   $0x80107428
80103568:	50                   	push   %eax
80103569:	e8 12 0d 00 00       	call   80104280 <initlock>
  (*f0)->type = FD_PIPE;
8010356e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103570:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103573:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103579:	8b 03                	mov    (%ebx),%eax
8010357b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010357f:	8b 03                	mov    (%ebx),%eax
80103581:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103585:	8b 03                	mov    (%ebx),%eax
80103587:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010358a:	8b 06                	mov    (%esi),%eax
8010358c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103592:	8b 06                	mov    (%esi),%eax
80103594:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103598:	8b 06                	mov    (%esi),%eax
8010359a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010359e:	8b 06                	mov    (%esi),%eax
801035a0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035a6:	31 c0                	xor    %eax,%eax
}
801035a8:	5b                   	pop    %ebx
801035a9:	5e                   	pop    %esi
801035aa:	5f                   	pop    %edi
801035ab:	5d                   	pop    %ebp
801035ac:	c3                   	ret    
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801035b0:	8b 03                	mov    (%ebx),%eax
801035b2:	85 c0                	test   %eax,%eax
801035b4:	74 1e                	je     801035d4 <pipealloc+0xe4>
    fileclose(*f0);
801035b6:	83 ec 0c             	sub    $0xc,%esp
801035b9:	50                   	push   %eax
801035ba:	e8 f1 d8 ff ff       	call   80100eb0 <fileclose>
801035bf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035c2:	8b 06                	mov    (%esi),%eax
801035c4:	85 c0                	test   %eax,%eax
801035c6:	74 0c                	je     801035d4 <pipealloc+0xe4>
    fileclose(*f1);
801035c8:	83 ec 0c             	sub    $0xc,%esp
801035cb:	50                   	push   %eax
801035cc:	e8 df d8 ff ff       	call   80100eb0 <fileclose>
801035d1:	83 c4 10             	add    $0x10,%esp
}
801035d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801035d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801035dc:	5b                   	pop    %ebx
801035dd:	5e                   	pop    %esi
801035de:	5f                   	pop    %edi
801035df:	5d                   	pop    %ebp
801035e0:	c3                   	ret    
801035e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801035e8:	8b 03                	mov    (%ebx),%eax
801035ea:	85 c0                	test   %eax,%eax
801035ec:	75 c8                	jne    801035b6 <pipealloc+0xc6>
801035ee:	eb d2                	jmp    801035c2 <pipealloc+0xd2>

801035f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035fb:	83 ec 0c             	sub    $0xc,%esp
801035fe:	53                   	push   %ebx
801035ff:	e8 9c 0c 00 00       	call   801042a0 <acquire>
  if(writable){
80103604:	83 c4 10             	add    $0x10,%esp
80103607:	85 f6                	test   %esi,%esi
80103609:	74 65                	je     80103670 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010360b:	83 ec 0c             	sub    $0xc,%esp
8010360e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103614:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010361b:	00 00 00 
    wakeup(&p->nread);
8010361e:	50                   	push   %eax
8010361f:	e8 bc 0a 00 00       	call   801040e0 <wakeup>
80103624:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103627:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010362d:	85 d2                	test   %edx,%edx
8010362f:	75 0a                	jne    8010363b <pipeclose+0x4b>
80103631:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103637:	85 c0                	test   %eax,%eax
80103639:	74 15                	je     80103650 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010363b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010363e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103641:	5b                   	pop    %ebx
80103642:	5e                   	pop    %esi
80103643:	5d                   	pop    %ebp
    release(&p->lock);
80103644:	e9 27 0e 00 00       	jmp    80104470 <release>
80103649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	53                   	push   %ebx
80103654:	e8 17 0e 00 00       	call   80104470 <release>
    kfree((char*)p);
80103659:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010365c:	83 c4 10             	add    $0x10,%esp
}
8010365f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103662:	5b                   	pop    %ebx
80103663:	5e                   	pop    %esi
80103664:	5d                   	pop    %ebp
    kfree((char*)p);
80103665:	e9 a6 ed ff ff       	jmp    80102410 <kfree>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103679:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103680:	00 00 00 
    wakeup(&p->nwrite);
80103683:	50                   	push   %eax
80103684:	e8 57 0a 00 00       	call   801040e0 <wakeup>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	eb 99                	jmp    80103627 <pipeclose+0x37>
8010368e:	66 90                	xchg   %ax,%ax

80103690 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 28             	sub    $0x28,%esp
80103699:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010369c:	57                   	push   %edi
8010369d:	e8 fe 0b 00 00       	call   801042a0 <acquire>
  for(i = 0; i < n; i++){
801036a2:	8b 45 10             	mov    0x10(%ebp),%eax
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	85 c0                	test   %eax,%eax
801036aa:	0f 8e c6 00 00 00    	jle    80103776 <pipewrite+0xe6>
801036b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801036b3:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
801036b9:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
801036bf:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
801036c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036c8:	03 45 10             	add    0x10(%ebp),%eax
801036cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ce:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801036d4:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801036da:	39 d1                	cmp    %edx,%ecx
801036dc:	0f 85 cf 00 00 00    	jne    801037b1 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
801036e2:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801036e8:	85 d2                	test   %edx,%edx
801036ea:	0f 84 a8 00 00 00    	je     80103798 <pipewrite+0x108>
801036f0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801036f7:	8b 42 24             	mov    0x24(%edx),%eax
801036fa:	85 c0                	test   %eax,%eax
801036fc:	74 25                	je     80103723 <pipewrite+0x93>
801036fe:	e9 95 00 00 00       	jmp    80103798 <pipewrite+0x108>
80103703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103707:	90                   	nop
80103708:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010370e:	85 c0                	test   %eax,%eax
80103710:	0f 84 82 00 00 00    	je     80103798 <pipewrite+0x108>
80103716:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010371c:	8b 40 24             	mov    0x24(%eax),%eax
8010371f:	85 c0                	test   %eax,%eax
80103721:	75 75                	jne    80103798 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103723:	83 ec 0c             	sub    $0xc,%esp
80103726:	56                   	push   %esi
80103727:	e8 b4 09 00 00       	call   801040e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010372c:	59                   	pop    %ecx
8010372d:	58                   	pop    %eax
8010372e:	57                   	push   %edi
8010372f:	53                   	push   %ebx
80103730:	e8 0b 08 00 00       	call   80103f40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103735:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
8010373b:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
80103741:	83 c4 10             	add    $0x10,%esp
80103744:	05 00 02 00 00       	add    $0x200,%eax
80103749:	39 c2                	cmp    %eax,%edx
8010374b:	74 bb                	je     80103708 <pipewrite+0x78>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010374d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103750:	8d 4a 01             	lea    0x1(%edx),%ecx
80103753:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103759:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010375d:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
80103763:	0f b6 00             	movzbl (%eax),%eax
80103766:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
8010376a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(i = 0; i < n; i++){
8010376d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80103770:	0f 85 58 ff ff ff    	jne    801036ce <pipewrite+0x3e>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103776:	83 ec 0c             	sub    $0xc,%esp
80103779:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
8010377f:	52                   	push   %edx
80103780:	e8 5b 09 00 00       	call   801040e0 <wakeup>
  release(&p->lock);
80103785:	89 3c 24             	mov    %edi,(%esp)
80103788:	e8 e3 0c 00 00       	call   80104470 <release>
  return n;
8010378d:	83 c4 10             	add    $0x10,%esp
80103790:	8b 45 10             	mov    0x10(%ebp),%eax
80103793:	eb 14                	jmp    801037a9 <pipewrite+0x119>
80103795:	8d 76 00             	lea    0x0(%esi),%esi
        release(&p->lock);
80103798:	83 ec 0c             	sub    $0xc,%esp
8010379b:	57                   	push   %edi
8010379c:	e8 cf 0c 00 00       	call   80104470 <release>
        return -1;
801037a1:	83 c4 10             	add    $0x10,%esp
801037a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801037a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ac:	5b                   	pop    %ebx
801037ad:	5e                   	pop    %esi
801037ae:	5f                   	pop    %edi
801037af:	5d                   	pop    %ebp
801037b0:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037b1:	89 ca                	mov    %ecx,%edx
801037b3:	eb 98                	jmp    8010374d <pipewrite+0xbd>
801037b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	57                   	push   %edi
801037c4:	56                   	push   %esi
801037c5:	53                   	push   %ebx
801037c6:	83 ec 18             	sub    $0x18,%esp
801037c9:	8b 75 08             	mov    0x8(%ebp),%esi
801037cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037cf:	56                   	push   %esi
801037d0:	e8 cb 0a 00 00       	call   801042a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037de:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037e4:	75 72                	jne    80103858 <piperead+0x98>
801037e6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801037ec:	85 db                	test   %ebx,%ebx
801037ee:	0f 84 cc 00 00 00    	je     801038c0 <piperead+0x100>
    if(proc->killed){
801037f4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037fa:	eb 2d                	jmp    80103829 <piperead+0x69>
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103800:	83 ec 08             	sub    $0x8,%esp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	e8 36 07 00 00       	call   80103f40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010380a:	83 c4 10             	add    $0x10,%esp
8010380d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103813:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103819:	75 3d                	jne    80103858 <piperead+0x98>
8010381b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103821:	85 d2                	test   %edx,%edx
80103823:	0f 84 97 00 00 00    	je     801038c0 <piperead+0x100>
    if(proc->killed){
80103829:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010382f:	8b 48 24             	mov    0x24(%eax),%ecx
80103832:	85 c9                	test   %ecx,%ecx
80103834:	74 ca                	je     80103800 <piperead+0x40>
      release(&p->lock);
80103836:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103839:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010383e:	56                   	push   %esi
8010383f:	e8 2c 0c 00 00       	call   80104470 <release>
      return -1;
80103844:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103847:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010384a:	89 d8                	mov    %ebx,%eax
8010384c:	5b                   	pop    %ebx
8010384d:	5e                   	pop    %esi
8010384e:	5f                   	pop    %edi
8010384f:	5d                   	pop    %ebp
80103850:	c3                   	ret    
80103851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103858:	8b 45 10             	mov    0x10(%ebp),%eax
8010385b:	85 c0                	test   %eax,%eax
8010385d:	7e 61                	jle    801038c0 <piperead+0x100>
    if(p->nread == p->nwrite)
8010385f:	31 db                	xor    %ebx,%ebx
80103861:	eb 13                	jmp    80103876 <piperead+0xb6>
80103863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103867:	90                   	nop
80103868:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010386e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103874:	74 1f                	je     80103895 <piperead+0xd5>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103876:	8d 41 01             	lea    0x1(%ecx),%eax
80103879:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
8010387f:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103885:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
8010388a:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010388d:	83 c3 01             	add    $0x1,%ebx
80103890:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103893:	75 d3                	jne    80103868 <piperead+0xa8>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103895:	83 ec 0c             	sub    $0xc,%esp
80103898:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
8010389e:	50                   	push   %eax
8010389f:	e8 3c 08 00 00       	call   801040e0 <wakeup>
  release(&p->lock);
801038a4:	89 34 24             	mov    %esi,(%esp)
801038a7:	e8 c4 0b 00 00       	call   80104470 <release>
  return i;
801038ac:	83 c4 10             	add    $0x10,%esp
}
801038af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b2:	89 d8                	mov    %ebx,%eax
801038b4:	5b                   	pop    %ebx
801038b5:	5e                   	pop    %esi
801038b6:	5f                   	pop    %edi
801038b7:	5d                   	pop    %ebp
801038b8:	c3                   	ret    
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801038c0:	31 db                	xor    %ebx,%ebx
801038c2:	eb d1                	jmp    80103895 <piperead+0xd5>
801038c4:	66 90                	xchg   %ax,%ax
801038c6:	66 90                	xchg   %ax,%ax
801038c8:	66 90                	xchg   %ax,%ax
801038ca:	66 90                	xchg   %ax,%ax
801038cc:	66 90                	xchg   %ax,%ax
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <allocproc>:
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038d4:	bb 14 19 11 80       	mov    $0x80111914,%ebx
{
801038d9:	83 ec 04             	sub    $0x4,%esp
801038dc:	eb 0d                	jmp    801038eb <allocproc+0x1b>
801038de:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	83 c3 7c             	add    $0x7c,%ebx
801038e3:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
801038e9:	74 6b                	je     80103956 <allocproc+0x86>
    if(p->state == UNUSED)
801038eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801038ee:	85 c0                	test   %eax,%eax
801038f0:	75 ee                	jne    801038e0 <allocproc+0x10>
      goto found;
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038f2:	a1 08 a0 10 80       	mov    0x8010a008,%eax
  p->state = EMBRYO;
801038f7:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038fe:	89 43 10             	mov    %eax,0x10(%ebx)
80103901:	8d 50 01             	lea    0x1(%eax),%edx
80103904:	89 15 08 a0 10 80    	mov    %edx,0x8010a008

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010390a:	e8 c1 ec ff ff       	call   801025d0 <kalloc>
8010390f:	89 43 08             	mov    %eax,0x8(%ebx)
80103912:	85 c0                	test   %eax,%eax
80103914:	74 39                	je     8010394f <allocproc+0x7f>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103916:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010391c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010391f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103924:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103927:	c7 40 14 ae 56 10 80 	movl   $0x801056ae,0x14(%eax)
  p->context = (struct context*)sp;
8010392e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103931:	6a 14                	push   $0x14
80103933:	6a 00                	push   $0x0
80103935:	50                   	push   %eax
80103936:	e8 85 0b 00 00       	call   801044c0 <memset>
  p->context->eip = (uint)forkret;
8010393b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010393e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103941:	c7 40 10 60 39 10 80 	movl   $0x80103960,0x10(%eax)
}
80103948:	89 d8                	mov    %ebx,%eax
8010394a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010394d:	c9                   	leave  
8010394e:	c3                   	ret    
    p->state = UNUSED;
8010394f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103956:	31 db                	xor    %ebx,%ebx
}
80103958:	89 d8                	mov    %ebx,%eax
8010395a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010395d:	c9                   	leave  
8010395e:	c3                   	ret    
8010395f:	90                   	nop

80103960 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103966:	68 e0 18 11 80       	push   $0x801118e0
8010396b:	e8 00 0b 00 00       	call   80104470 <release>

  if (first) {
80103970:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103975:	83 c4 10             	add    $0x10,%esp
80103978:	85 c0                	test   %eax,%eax
8010397a:	75 04                	jne    80103980 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010397c:	c9                   	leave  
8010397d:	c3                   	ret    
8010397e:	66 90                	xchg   %ax,%ax
    first = 0;
80103980:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
80103987:	00 00 00 
    iinit(ROOTDEV);
8010398a:	83 ec 0c             	sub    $0xc,%esp
8010398d:	6a 01                	push   $0x1
8010398f:	e8 6c db ff ff       	call   80101500 <iinit>
    initlog(ROOTDEV);
80103994:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010399b:	e8 00 f3 ff ff       	call   80102ca0 <initlog>
801039a0:	83 c4 10             	add    $0x10,%esp
}
801039a3:	c9                   	leave  
801039a4:	c3                   	ret    
801039a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039b0 <pinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039b6:	68 2d 74 10 80       	push   $0x8010742d
801039bb:	68 e0 18 11 80       	push   $0x801118e0
801039c0:	e8 bb 08 00 00       	call   80104280 <initlock>
}
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	c9                   	leave  
801039c9:	c3                   	ret    
801039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039d0 <userinit>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039d7:	68 e0 18 11 80       	push   $0x801118e0
801039dc:	e8 bf 08 00 00       	call   801042a0 <acquire>
  p = allocproc();
801039e1:	e8 ea fe ff ff       	call   801038d0 <allocproc>
801039e6:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039e8:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801039ed:	e8 8e 2e 00 00       	call   80106880 <setupkvm>
801039f2:	83 c4 10             	add    $0x10,%esp
801039f5:	89 43 04             	mov    %eax,0x4(%ebx)
801039f8:	85 c0                	test   %eax,%eax
801039fa:	0f 84 b1 00 00 00    	je     80103ab1 <userinit+0xe1>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a00:	83 ec 04             	sub    $0x4,%esp
80103a03:	68 2c 00 00 00       	push   $0x2c
80103a08:	68 60 a4 10 80       	push   $0x8010a460
80103a0d:	50                   	push   %eax
80103a0e:	e8 ad 2f 00 00       	call   801069c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a13:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a16:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a1c:	6a 4c                	push   $0x4c
80103a1e:	6a 00                	push   $0x0
80103a20:	ff 73 18             	pushl  0x18(%ebx)
80103a23:	e8 98 0a 00 00       	call   801044c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a28:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2b:	ba 23 00 00 00       	mov    $0x23,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a30:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a33:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a38:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a43:	8b 43 18             	mov    0x18(%ebx),%eax
80103a46:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a4a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a4e:	8b 43 18             	mov    0x18(%ebx),%eax
80103a51:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a55:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a59:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a63:	8b 43 18             	mov    0x18(%ebx),%eax
80103a66:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a6d:	8b 43 18             	mov    0x18(%ebx),%eax
80103a70:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a77:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a7a:	6a 10                	push   $0x10
80103a7c:	68 4d 74 10 80       	push   $0x8010744d
80103a81:	50                   	push   %eax
80103a82:	e8 09 0c 00 00       	call   80104690 <safestrcpy>
  p->cwd = namei("/");
80103a87:	c7 04 24 56 74 10 80 	movl   $0x80107456,(%esp)
80103a8e:	e8 2d e5 ff ff       	call   80101fc0 <namei>
  p->state = RUNNABLE;
80103a93:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->cwd = namei("/");
80103a9a:	89 43 68             	mov    %eax,0x68(%ebx)
  release(&ptable.lock);
80103a9d:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103aa4:	e8 c7 09 00 00       	call   80104470 <release>
}
80103aa9:	83 c4 10             	add    $0x10,%esp
80103aac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aaf:	c9                   	leave  
80103ab0:	c3                   	ret    
    panic("userinit: out of memory?");
80103ab1:	83 ec 0c             	sub    $0xc,%esp
80103ab4:	68 34 74 10 80       	push   $0x80107434
80103ab9:	e8 d2 c8 ff ff       	call   80100390 <panic>
80103abe:	66 90                	xchg   %ax,%ax

80103ac0 <growproc>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 08             	sub    $0x8,%esp
  sz = proc->sz;
80103ac6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80103acd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  sz = proc->sz;
80103ad0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103ad2:	85 c9                	test   %ecx,%ecx
80103ad4:	7f 1a                	jg     80103af0 <growproc+0x30>
  } else if(n < 0){
80103ad6:	75 38                	jne    80103b10 <growproc+0x50>
  proc->sz = sz;
80103ad8:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
80103ae4:	e8 37 2e 00 00       	call   80106920 <switchuvm>
  return 0;
80103ae9:	83 c4 10             	add    $0x10,%esp
80103aec:	31 c0                	xor    %eax,%eax
}
80103aee:	c9                   	leave  
80103aef:	c3                   	ret    
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c1                	add    %eax,%ecx
80103af5:	51                   	push   %ecx
80103af6:	50                   	push   %eax
80103af7:	ff 72 04             	pushl  0x4(%edx)
80103afa:	e8 01 30 00 00       	call   80106b00 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	74 20                	je     80103b26 <growproc+0x66>
80103b06:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b0d:	eb c9                	jmp    80103ad8 <growproc+0x18>
80103b0f:	90                   	nop
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c1                	add    %eax,%ecx
80103b15:	51                   	push   %ecx
80103b16:	50                   	push   %eax
80103b17:	ff 72 04             	pushl  0x4(%edx)
80103b1a:	e8 11 31 00 00       	call   80106c30 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 e0                	jne    80103b06 <growproc+0x46>
}
80103b26:	c9                   	leave  
      return -1;
80103b27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b2c:	c3                   	ret    
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi

80103b30 <fork>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103b39:	68 e0 18 11 80       	push   $0x801118e0
80103b3e:	e8 5d 07 00 00       	call   801042a0 <acquire>
  if((np = allocproc()) == 0){
80103b43:	e8 88 fd ff ff       	call   801038d0 <allocproc>
80103b48:	83 c4 10             	add    $0x10,%esp
80103b4b:	85 c0                	test   %eax,%eax
80103b4d:	0f 84 cd 00 00 00    	je     80103c20 <fork+0xf0>
80103b53:	89 c3                	mov    %eax,%ebx
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b5b:	83 ec 08             	sub    $0x8,%esp
80103b5e:	ff 30                	pushl  (%eax)
80103b60:	ff 70 04             	pushl  0x4(%eax)
80103b63:	e8 a8 31 00 00       	call   80106d10 <copyuvm>
80103b68:	83 c4 10             	add    $0x10,%esp
80103b6b:	89 43 04             	mov    %eax,0x4(%ebx)
80103b6e:	85 c0                	test   %eax,%eax
80103b70:	0f 84 c1 00 00 00    	je     80103c37 <fork+0x107>
  np->sz = proc->sz;
80103b76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  *np->tf = *proc->tf;
80103b7c:	8b 7b 18             	mov    0x18(%ebx),%edi
80103b7f:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = proc->sz;
80103b84:	8b 00                	mov    (%eax),%eax
80103b86:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103b88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b8e:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103b91:	8b 70 18             	mov    0x18(%eax),%esi
80103b94:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b96:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b98:	8b 43 18             	mov    0x18(%ebx),%eax
80103b9b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103ba2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->ofile[i])
80103bb0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103bb4:	85 c0                	test   %eax,%eax
80103bb6:	74 17                	je     80103bcf <fork+0x9f>
      np->ofile[i] = filedup(proc->ofile[i]);
80103bb8:	83 ec 0c             	sub    $0xc,%esp
80103bbb:	50                   	push   %eax
80103bbc:	e8 9f d2 ff ff       	call   80100e60 <filedup>
80103bc1:	83 c4 10             	add    $0x10,%esp
80103bc4:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103bc8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  for(i = 0; i < NOFILE; i++)
80103bcf:	83 c6 01             	add    $0x1,%esi
80103bd2:	83 fe 10             	cmp    $0x10,%esi
80103bd5:	75 d9                	jne    80103bb0 <fork+0x80>
  np->cwd = idup(proc->cwd);
80103bd7:	83 ec 0c             	sub    $0xc,%esp
80103bda:	ff 72 68             	pushl  0x68(%edx)
80103bdd:	e8 be da ff ff       	call   801016a0 <idup>
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103be2:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(proc->cwd);
80103be5:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103be8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bee:	6a 10                	push   $0x10
80103bf0:	83 c0 6c             	add    $0x6c,%eax
80103bf3:	50                   	push   %eax
80103bf4:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bf7:	50                   	push   %eax
80103bf8:	e8 93 0a 00 00       	call   80104690 <safestrcpy>
  np->state = RUNNABLE;
80103bfd:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pid = np->pid;
80103c04:	8b 73 10             	mov    0x10(%ebx),%esi
  release(&ptable.lock);
80103c07:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103c0e:	e8 5d 08 00 00       	call   80104470 <release>
  return pid;
80103c13:	83 c4 10             	add    $0x10,%esp
}
80103c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c19:	89 f0                	mov    %esi,%eax
80103c1b:	5b                   	pop    %ebx
80103c1c:	5e                   	pop    %esi
80103c1d:	5f                   	pop    %edi
80103c1e:	5d                   	pop    %ebp
80103c1f:	c3                   	ret    
    release(&ptable.lock);
80103c20:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103c23:	be ff ff ff ff       	mov    $0xffffffff,%esi
    release(&ptable.lock);
80103c28:	68 e0 18 11 80       	push   $0x801118e0
80103c2d:	e8 3e 08 00 00       	call   80104470 <release>
    return -1;
80103c32:	83 c4 10             	add    $0x10,%esp
80103c35:	eb df                	jmp    80103c16 <fork+0xe6>
    kfree(np->kstack);
80103c37:	83 ec 0c             	sub    $0xc,%esp
80103c3a:	ff 73 08             	pushl  0x8(%ebx)
    return -1;
80103c3d:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103c42:	e8 c9 e7 ff ff       	call   80102410 <kfree>
    np->kstack = 0;
80103c47:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c4e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    release(&ptable.lock);
80103c55:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103c5c:	e8 0f 08 00 00       	call   80104470 <release>
    return -1;
80103c61:	83 c4 10             	add    $0x10,%esp
80103c64:	eb b0                	jmp    80103c16 <fork+0xe6>
80103c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi

80103c70 <scheduler>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	53                   	push   %ebx
80103c74:	83 ec 04             	sub    $0x4,%esp
80103c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7e:	66 90                	xchg   %ax,%ax
  asm volatile("sti");
80103c80:	fb                   	sti    
    acquire(&ptable.lock);
80103c81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c84:	bb 14 19 11 80       	mov    $0x80111914,%ebx
    acquire(&ptable.lock);
80103c89:	68 e0 18 11 80       	push   $0x801118e0
80103c8e:	e8 0d 06 00 00       	call   801042a0 <acquire>
80103c93:	83 c4 10             	add    $0x10,%esp
80103c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ca0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ca4:	75 3e                	jne    80103ce4 <scheduler+0x74>
      switchuvm(p);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
      proc = p;
80103ca9:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103cb0:	53                   	push   %ebx
80103cb1:	e8 6a 2c 00 00       	call   80106920 <switchuvm>
      swtch(&cpu->scheduler, p->context);
80103cb6:	58                   	pop    %eax
80103cb7:	5a                   	pop    %edx
80103cb8:	ff 73 1c             	pushl  0x1c(%ebx)
80103cbb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      p->state = RUNNING;
80103cc1:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&cpu->scheduler, p->context);
80103cc8:	83 c0 04             	add    $0x4,%eax
80103ccb:	50                   	push   %eax
80103ccc:	e8 1a 0a 00 00       	call   801046eb <swtch>
      switchkvm();
80103cd1:	e8 3a 2c 00 00       	call   80106910 <switchkvm>
      proc = 0;
80103cd6:	83 c4 10             	add    $0x10,%esp
80103cd9:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103ce0:	00 00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce4:	83 c3 7c             	add    $0x7c,%ebx
80103ce7:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
80103ced:	75 b1                	jne    80103ca0 <scheduler+0x30>
    release(&ptable.lock);
80103cef:	83 ec 0c             	sub    $0xc,%esp
80103cf2:	68 e0 18 11 80       	push   $0x801118e0
80103cf7:	e8 74 07 00 00       	call   80104470 <release>
    sti();
80103cfc:	83 c4 10             	add    $0x10,%esp
80103cff:	e9 7c ff ff ff       	jmp    80103c80 <scheduler+0x10>
80103d04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d0f:	90                   	nop

80103d10 <sched>:
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	53                   	push   %ebx
80103d14:	83 ec 10             	sub    $0x10,%esp
  if(!holding(&ptable.lock))
80103d17:	68 e0 18 11 80       	push   $0x801118e0
80103d1c:	e8 9f 06 00 00       	call   801043c0 <holding>
80103d21:	83 c4 10             	add    $0x10,%esp
80103d24:	85 c0                	test   %eax,%eax
80103d26:	74 4c                	je     80103d74 <sched+0x64>
  if(cpu->ncli != 1)
80103d28:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103d2f:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103d36:	75 63                	jne    80103d9b <sched+0x8b>
  if(proc->state == RUNNING)
80103d38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d3e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103d42:	74 4a                	je     80103d8e <sched+0x7e>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d44:	9c                   	pushf  
80103d45:	59                   	pop    %ecx
  if(readeflags()&FL_IF)
80103d46:	80 e5 02             	and    $0x2,%ch
80103d49:	75 36                	jne    80103d81 <sched+0x71>
  swtch(&proc->context, cpu->scheduler);
80103d4b:	83 ec 08             	sub    $0x8,%esp
80103d4e:	83 c0 1c             	add    $0x1c,%eax
  intena = cpu->intena;
80103d51:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80103d57:	ff 72 04             	pushl  0x4(%edx)
80103d5a:	50                   	push   %eax
80103d5b:	e8 8b 09 00 00       	call   801046eb <swtch>
  cpu->intena = intena;
80103d60:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103d66:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80103d69:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d72:	c9                   	leave  
80103d73:	c3                   	ret    
    panic("sched ptable.lock");
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	68 58 74 10 80       	push   $0x80107458
80103d7c:	e8 0f c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d81:	83 ec 0c             	sub    $0xc,%esp
80103d84:	68 84 74 10 80       	push   $0x80107484
80103d89:	e8 02 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d8e:	83 ec 0c             	sub    $0xc,%esp
80103d91:	68 76 74 10 80       	push   $0x80107476
80103d96:	e8 f5 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d9b:	83 ec 0c             	sub    $0xc,%esp
80103d9e:	68 6a 74 10 80       	push   $0x8010746a
80103da3:	e8 e8 c5 ff ff       	call   80100390 <panic>
80103da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop

80103db0 <exit>:
{
80103db0:	55                   	push   %ebp
  if(proc == initproc)
80103db1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
{
80103db8:	89 e5                	mov    %esp,%ebp
80103dba:	56                   	push   %esi
80103dbb:	53                   	push   %ebx
80103dbc:	31 db                	xor    %ebx,%ebx
  if(proc == initproc)
80103dbe:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
80103dc4:	0f 84 1d 01 00 00    	je     80103ee7 <exit+0x137>
80103dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(proc->ofile[fd]){
80103dd0:	8d 73 08             	lea    0x8(%ebx),%esi
80103dd3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103dd7:	85 c0                	test   %eax,%eax
80103dd9:	74 1b                	je     80103df6 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103ddb:	83 ec 0c             	sub    $0xc,%esp
80103dde:	50                   	push   %eax
80103ddf:	e8 cc d0 ff ff       	call   80100eb0 <fileclose>
      proc->ofile[fd] = 0;
80103de4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103deb:	83 c4 10             	add    $0x10,%esp
80103dee:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103df5:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103df6:	83 c3 01             	add    $0x1,%ebx
80103df9:	83 fb 10             	cmp    $0x10,%ebx
80103dfc:	75 d2                	jne    80103dd0 <exit+0x20>
  begin_op();
80103dfe:	e8 3d ef ff ff       	call   80102d40 <begin_op>
  iput(proc->cwd);
80103e03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e09:	83 ec 0c             	sub    $0xc,%esp
80103e0c:	ff 70 68             	pushl  0x68(%eax)
80103e0f:	e8 2c da ff ff       	call   80101840 <iput>
  end_op();
80103e14:	e8 97 ef ff ff       	call   80102db0 <end_op>
  proc->cwd = 0;
80103e19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e1f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  acquire(&ptable.lock);
80103e26:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103e2d:	e8 6e 04 00 00       	call   801042a0 <acquire>
  wakeup1(proc->parent);
80103e32:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
80103e39:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e3c:	b8 14 19 11 80       	mov    $0x80111914,%eax
  wakeup1(proc->parent);
80103e41:	8b 53 14             	mov    0x14(%ebx),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e44:	eb 14                	jmp    80103e5a <exit+0xaa>
80103e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi
80103e50:	83 c0 7c             	add    $0x7c,%eax
80103e53:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80103e58:	74 1c                	je     80103e76 <exit+0xc6>
    if(p->state == SLEEPING && p->chan == chan)
80103e5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e5e:	75 f0                	jne    80103e50 <exit+0xa0>
80103e60:	3b 50 20             	cmp    0x20(%eax),%edx
80103e63:	75 eb                	jne    80103e50 <exit+0xa0>
      p->state = RUNNABLE;
80103e65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e6c:	83 c0 7c             	add    $0x7c,%eax
80103e6f:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80103e74:	75 e4                	jne    80103e5a <exit+0xaa>
      p->parent = initproc;
80103e76:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7c:	ba 14 19 11 80       	mov    $0x80111914,%edx
80103e81:	eb 10                	jmp    80103e93 <exit+0xe3>
80103e83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e87:	90                   	nop
80103e88:	83 c2 7c             	add    $0x7c,%edx
80103e8b:	81 fa 14 38 11 80    	cmp    $0x80113814,%edx
80103e91:	74 3b                	je     80103ece <exit+0x11e>
    if(p->parent == proc){
80103e93:	3b 5a 14             	cmp    0x14(%edx),%ebx
80103e96:	75 f0                	jne    80103e88 <exit+0xd8>
      if(p->state == ZOMBIE)
80103e98:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e9c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e9f:	75 e7                	jne    80103e88 <exit+0xd8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea1:	b8 14 19 11 80       	mov    $0x80111914,%eax
80103ea6:	eb 12                	jmp    80103eba <exit+0x10a>
80103ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop
80103eb0:	83 c0 7c             	add    $0x7c,%eax
80103eb3:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80103eb8:	74 ce                	je     80103e88 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
80103eba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ebe:	75 f0                	jne    80103eb0 <exit+0x100>
80103ec0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ec3:	75 eb                	jne    80103eb0 <exit+0x100>
      p->state = RUNNABLE;
80103ec5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ecc:	eb e2                	jmp    80103eb0 <exit+0x100>
  proc->state = ZOMBIE;
80103ece:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ed5:	e8 36 fe ff ff       	call   80103d10 <sched>
  panic("zombie exit");
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 a5 74 10 80       	push   $0x801074a5
80103ee2:	e8 a9 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103ee7:	83 ec 0c             	sub    $0xc,%esp
80103eea:	68 98 74 10 80       	push   $0x80107498
80103eef:	e8 9c c4 ff ff       	call   80100390 <panic>
80103ef4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eff:	90                   	nop

80103f00 <yield>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f06:	68 e0 18 11 80       	push   $0x801118e0
80103f0b:	e8 90 03 00 00       	call   801042a0 <acquire>
  proc->state = RUNNABLE;
80103f10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f16:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103f1d:	e8 ee fd ff ff       	call   80103d10 <sched>
  release(&ptable.lock);
80103f22:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103f29:	e8 42 05 00 00       	call   80104470 <release>
}
80103f2e:	83 c4 10             	add    $0x10,%esp
80103f31:	c9                   	leave  
80103f32:	c3                   	ret    
80103f33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f40 <sleep>:
{
80103f40:	55                   	push   %ebp
  if(proc == 0)
80103f41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80103f47:	89 e5                	mov    %esp,%ebp
80103f49:	56                   	push   %esi
80103f4a:	8b 75 08             	mov    0x8(%ebp),%esi
80103f4d:	53                   	push   %ebx
80103f4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103f51:	85 c0                	test   %eax,%eax
80103f53:	0f 84 97 00 00 00    	je     80103ff0 <sleep+0xb0>
  if(lk == 0)
80103f59:	85 db                	test   %ebx,%ebx
80103f5b:	0f 84 82 00 00 00    	je     80103fe3 <sleep+0xa3>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f61:	81 fb e0 18 11 80    	cmp    $0x801118e0,%ebx
80103f67:	74 57                	je     80103fc0 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f69:	83 ec 0c             	sub    $0xc,%esp
80103f6c:	68 e0 18 11 80       	push   $0x801118e0
80103f71:	e8 2a 03 00 00       	call   801042a0 <acquire>
    release(lk);
80103f76:	89 1c 24             	mov    %ebx,(%esp)
80103f79:	e8 f2 04 00 00       	call   80104470 <release>
  proc->chan = chan;
80103f7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f84:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103f87:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103f8e:	e8 7d fd ff ff       	call   80103d10 <sched>
  proc->chan = 0;
80103f93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f99:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    release(&ptable.lock);
80103fa0:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103fa7:	e8 c4 04 00 00       	call   80104470 <release>
    acquire(lk);
80103fac:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103faf:	83 c4 10             	add    $0x10,%esp
}
80103fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb5:	5b                   	pop    %ebx
80103fb6:	5e                   	pop    %esi
80103fb7:	5d                   	pop    %ebp
    acquire(lk);
80103fb8:	e9 e3 02 00 00       	jmp    801042a0 <acquire>
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
  proc->chan = chan;
80103fc0:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103fc3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103fca:	e8 41 fd ff ff       	call   80103d10 <sched>
  proc->chan = 0;
80103fcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103fd5:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
}
80103fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fdf:	5b                   	pop    %ebx
80103fe0:	5e                   	pop    %esi
80103fe1:	5d                   	pop    %ebp
80103fe2:	c3                   	ret    
    panic("sleep without lk");
80103fe3:	83 ec 0c             	sub    $0xc,%esp
80103fe6:	68 b7 74 10 80       	push   $0x801074b7
80103feb:	e8 a0 c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ff0:	83 ec 0c             	sub    $0xc,%esp
80103ff3:	68 b1 74 10 80       	push   $0x801074b1
80103ff8:	e8 93 c3 ff ff       	call   80100390 <panic>
80103ffd:	8d 76 00             	lea    0x0(%esi),%esi

80104000 <wait>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
  acquire(&ptable.lock);
80104005:	83 ec 0c             	sub    $0xc,%esp
80104008:	68 e0 18 11 80       	push   $0x801118e0
8010400d:	e8 8e 02 00 00       	call   801042a0 <acquire>
80104012:	83 c4 10             	add    $0x10,%esp
      if(p->parent != proc)
80104015:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    havekids = 0;
8010401b:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401d:	bb 14 19 11 80       	mov    $0x80111914,%ebx
80104022:	eb 0f                	jmp    80104033 <wait+0x33>
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104028:	83 c3 7c             	add    $0x7c,%ebx
8010402b:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
80104031:	74 1b                	je     8010404e <wait+0x4e>
      if(p->parent != proc)
80104033:	39 43 14             	cmp    %eax,0x14(%ebx)
80104036:	75 f0                	jne    80104028 <wait+0x28>
      if(p->state == ZOMBIE){
80104038:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010403c:	74 32                	je     80104070 <wait+0x70>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104041:	ba 01 00 00 00       	mov    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104046:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
8010404c:	75 e5                	jne    80104033 <wait+0x33>
    if(!havekids || proc->killed){
8010404e:	85 d2                	test   %edx,%edx
80104050:	74 74                	je     801040c6 <wait+0xc6>
80104052:	8b 50 24             	mov    0x24(%eax),%edx
80104055:	85 d2                	test   %edx,%edx
80104057:	75 6d                	jne    801040c6 <wait+0xc6>
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104059:	83 ec 08             	sub    $0x8,%esp
8010405c:	68 e0 18 11 80       	push   $0x801118e0
80104061:	50                   	push   %eax
80104062:	e8 d9 fe ff ff       	call   80103f40 <sleep>
    havekids = 0;
80104067:	83 c4 10             	add    $0x10,%esp
8010406a:	eb a9                	jmp    80104015 <wait+0x15>
8010406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104070:	83 ec 0c             	sub    $0xc,%esp
80104073:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104076:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104079:	e8 92 e3 ff ff       	call   80102410 <kfree>
        freevm(p->pgdir);
8010407e:	59                   	pop    %ecx
8010407f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104082:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104089:	e8 d2 2b 00 00       	call   80106c60 <freevm>
        release(&ptable.lock);
8010408e:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
        p->pid = 0;
80104095:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010409c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040a3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040a7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040ae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040b5:	e8 b6 03 00 00       	call   80104470 <release>
        return pid;
801040ba:	83 c4 10             	add    $0x10,%esp
}
801040bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040c0:	89 f0                	mov    %esi,%eax
801040c2:	5b                   	pop    %ebx
801040c3:	5e                   	pop    %esi
801040c4:	5d                   	pop    %ebp
801040c5:	c3                   	ret    
      release(&ptable.lock);
801040c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040ce:	68 e0 18 11 80       	push   $0x801118e0
801040d3:	e8 98 03 00 00       	call   80104470 <release>
      return -1;
801040d8:	83 c4 10             	add    $0x10,%esp
801040db:	eb e0                	jmp    801040bd <wait+0xbd>
801040dd:	8d 76 00             	lea    0x0(%esi),%esi

801040e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 10             	sub    $0x10,%esp
801040e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040ea:	68 e0 18 11 80       	push   $0x801118e0
801040ef:	e8 ac 01 00 00       	call   801042a0 <acquire>
801040f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040f7:	b8 14 19 11 80       	mov    $0x80111914,%eax
801040fc:	eb 0c                	jmp    8010410a <wakeup+0x2a>
801040fe:	66 90                	xchg   %ax,%ax
80104100:	83 c0 7c             	add    $0x7c,%eax
80104103:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80104108:	74 1c                	je     80104126 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010410a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010410e:	75 f0                	jne    80104100 <wakeup+0x20>
80104110:	3b 58 20             	cmp    0x20(%eax),%ebx
80104113:	75 eb                	jne    80104100 <wakeup+0x20>
      p->state = RUNNABLE;
80104115:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411c:	83 c0 7c             	add    $0x7c,%eax
8010411f:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80104124:	75 e4                	jne    8010410a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104126:	c7 45 08 e0 18 11 80 	movl   $0x801118e0,0x8(%ebp)
}
8010412d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104130:	c9                   	leave  
  release(&ptable.lock);
80104131:	e9 3a 03 00 00       	jmp    80104470 <release>
80104136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413d:	8d 76 00             	lea    0x0(%esi),%esi

80104140 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 10             	sub    $0x10,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010414a:	68 e0 18 11 80       	push   $0x801118e0
8010414f:	e8 4c 01 00 00       	call   801042a0 <acquire>
80104154:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104157:	b8 14 19 11 80       	mov    $0x80111914,%eax
8010415c:	eb 0c                	jmp    8010416a <kill+0x2a>
8010415e:	66 90                	xchg   %ax,%ax
80104160:	83 c0 7c             	add    $0x7c,%eax
80104163:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80104168:	74 36                	je     801041a0 <kill+0x60>
    if(p->pid == pid){
8010416a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010416d:	75 f1                	jne    80104160 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010416f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104173:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010417a:	75 07                	jne    80104183 <kill+0x43>
        p->state = RUNNABLE;
8010417c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104183:	83 ec 0c             	sub    $0xc,%esp
80104186:	68 e0 18 11 80       	push   $0x801118e0
8010418b:	e8 e0 02 00 00       	call   80104470 <release>
      return 0;
80104190:	83 c4 10             	add    $0x10,%esp
80104193:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104198:	c9                   	leave  
80104199:	c3                   	ret    
8010419a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	68 e0 18 11 80       	push   $0x801118e0
801041a8:	e8 c3 02 00 00       	call   80104470 <release>
  return -1;
801041ad:	83 c4 10             	add    $0x10,%esp
801041b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b8:	c9                   	leave  
801041b9:	c3                   	ret    
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	57                   	push   %edi
801041c4:	56                   	push   %esi
801041c5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041c8:	53                   	push   %ebx
801041c9:	bb 80 19 11 80       	mov    $0x80111980,%ebx
801041ce:	83 ec 3c             	sub    $0x3c,%esp
801041d1:	eb 24                	jmp    801041f7 <procdump+0x37>
801041d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 06 74 10 80       	push   $0x80107406
801041e0:	e8 cb c4 ff ff       	call   801006b0 <cprintf>
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041eb:	81 fb 80 38 11 80    	cmp    $0x80113880,%ebx
801041f1:	0f 84 81 00 00 00    	je     80104278 <procdump+0xb8>
    if(p->state == UNUSED)
801041f7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801041fa:	85 c0                	test   %eax,%eax
801041fc:	74 ea                	je     801041e8 <procdump+0x28>
      state = "???";
801041fe:	ba c8 74 10 80       	mov    $0x801074c8,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104203:	83 f8 05             	cmp    $0x5,%eax
80104206:	77 11                	ja     80104219 <procdump+0x59>
80104208:	8b 14 85 00 75 10 80 	mov    -0x7fef8b00(,%eax,4),%edx
      state = "???";
8010420f:	b8 c8 74 10 80       	mov    $0x801074c8,%eax
80104214:	85 d2                	test   %edx,%edx
80104216:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104219:	53                   	push   %ebx
8010421a:	52                   	push   %edx
8010421b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010421e:	68 cc 74 10 80       	push   $0x801074cc
80104223:	e8 88 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104228:	83 c4 10             	add    $0x10,%esp
8010422b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010422f:	75 a7                	jne    801041d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104231:	83 ec 08             	sub    $0x8,%esp
80104234:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104237:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010423a:	50                   	push   %eax
8010423b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010423e:	8b 40 0c             	mov    0xc(%eax),%eax
80104241:	83 c0 08             	add    $0x8,%eax
80104244:	50                   	push   %eax
80104245:	e8 26 01 00 00       	call   80104370 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010424a:	83 c4 10             	add    $0x10,%esp
8010424d:	8d 76 00             	lea    0x0(%esi),%esi
80104250:	8b 17                	mov    (%edi),%edx
80104252:	85 d2                	test   %edx,%edx
80104254:	74 82                	je     801041d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104256:	83 ec 08             	sub    $0x8,%esp
80104259:	83 c7 04             	add    $0x4,%edi
8010425c:	52                   	push   %edx
8010425d:	68 02 6f 10 80       	push   $0x80106f02
80104262:	e8 49 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104267:	83 c4 10             	add    $0x10,%esp
8010426a:	39 fe                	cmp    %edi,%esi
8010426c:	75 e2                	jne    80104250 <procdump+0x90>
8010426e:	e9 65 ff ff ff       	jmp    801041d8 <procdump+0x18>
80104273:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104277:	90                   	nop
  }
}
80104278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010427b:	5b                   	pop    %ebx
8010427c:	5e                   	pop    %esi
8010427d:	5f                   	pop    %edi
8010427e:	5d                   	pop    %ebp
8010427f:	c3                   	ret    

80104280 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104286:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010428f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104292:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104299:	5d                   	pop    %ebp
8010429a:	c3                   	ret    
8010429b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010429f:	90                   	nop

801042a0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 04             	sub    $0x4,%esp
801042a7:	9c                   	pushf  
801042a8:	5a                   	pop    %edx
  asm volatile("cli");
801042a9:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801042aa:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801042b1:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
801042b7:	85 c0                	test   %eax,%eax
801042b9:	75 0c                	jne    801042c7 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
801042bb:	81 e2 00 02 00 00    	and    $0x200,%edx
801042c1:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
  if(holding(lk))
801042c7:	8b 55 08             	mov    0x8(%ebp),%edx
  cpu->ncli += 1;
801042ca:	83 c0 01             	add    $0x1,%eax
801042cd:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)
  return lock->locked && lock->cpu == cpu;
801042d3:	8b 02                	mov    (%edx),%eax
801042d5:	85 c0                	test   %eax,%eax
801042d7:	74 05                	je     801042de <acquire+0x3e>
801042d9:	39 4a 08             	cmp    %ecx,0x8(%edx)
801042dc:	74 7a                	je     80104358 <acquire+0xb8>
  asm volatile("lock; xchgl %0, %1" :
801042de:	b9 01 00 00 00       	mov    $0x1,%ecx
801042e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e7:	90                   	nop
801042e8:	89 c8                	mov    %ecx,%eax
801042ea:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
801042ed:	85 c0                	test   %eax,%eax
801042ef:	75 f7                	jne    801042e8 <acquire+0x48>
  __sync_synchronize();
801042f1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  ebp = (uint*)v - 2;
801042f6:	89 ea                	mov    %ebp,%edx
  lk->cpu = cpu;
801042f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801042fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104301:	89 41 08             	mov    %eax,0x8(%ecx)
  for(i = 0; i < 10; i++){
80104304:	31 c0                	xor    %eax,%eax
80104306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104310:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104316:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010431c:	77 1a                	ja     80104338 <acquire+0x98>
    pcs[i] = ebp[1];     // saved %eip
8010431e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104321:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104325:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104328:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010432a:	83 f8 0a             	cmp    $0xa,%eax
8010432d:	75 e1                	jne    80104310 <acquire+0x70>
}
8010432f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104332:	c9                   	leave  
80104333:	c3                   	ret    
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104338:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010433c:	83 c1 34             	add    $0x34,%ecx
8010433f:	90                   	nop
    pcs[i] = 0;
80104340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104346:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104349:	39 c1                	cmp    %eax,%ecx
8010434b:	75 f3                	jne    80104340 <acquire+0xa0>
}
8010434d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104350:	c9                   	leave  
80104351:	c3                   	ret    
80104352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("acquire");
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 18 75 10 80       	push   $0x80107518
80104360:	e8 2b c0 ff ff       	call   80100390 <panic>
80104365:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104370 <getcallerpcs>:
{
80104370:	55                   	push   %ebp
  for(i = 0; i < 10; i++){
80104371:	31 d2                	xor    %edx,%edx
{
80104373:	89 e5                	mov    %esp,%ebp
80104375:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104376:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104379:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010437c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010437f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104380:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104386:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010438c:	77 1a                	ja     801043a8 <getcallerpcs+0x38>
    pcs[i] = ebp[1];     // saved %eip
8010438e:	8b 58 04             	mov    0x4(%eax),%ebx
80104391:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104394:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104397:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104399:	83 fa 0a             	cmp    $0xa,%edx
8010439c:	75 e2                	jne    80104380 <getcallerpcs+0x10>
}
8010439e:	5b                   	pop    %ebx
8010439f:	5d                   	pop    %ebp
801043a0:	c3                   	ret    
801043a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043ab:	8d 51 28             	lea    0x28(%ecx),%edx
801043ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801043b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043b6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801043b9:	39 d0                	cmp    %edx,%eax
801043bb:	75 f3                	jne    801043b0 <getcallerpcs+0x40>
}
801043bd:	5b                   	pop    %ebx
801043be:	5d                   	pop    %ebp
801043bf:	c3                   	ret    

801043c0 <holding>:
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
801043c6:	8b 02                	mov    (%edx),%eax
801043c8:	85 c0                	test   %eax,%eax
801043ca:	74 14                	je     801043e0 <holding+0x20>
801043cc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801043d2:	39 42 08             	cmp    %eax,0x8(%edx)
801043d5:	0f 94 c0             	sete   %al
}
801043d8:	5d                   	pop    %ebp
  return lock->locked && lock->cpu == cpu;
801043d9:	0f b6 c0             	movzbl %al,%eax
}
801043dc:	c3                   	ret    
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
801043e0:	31 c0                	xor    %eax,%eax
801043e2:	5d                   	pop    %ebp
801043e3:	c3                   	ret    
801043e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043ef:	90                   	nop

801043f0 <pushcli>:
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043f0:	9c                   	pushf  
801043f1:	59                   	pop    %ecx
  asm volatile("cli");
801043f2:	fa                   	cli    
  if(cpu->ncli == 0)
801043f3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801043fa:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104400:	85 c0                	test   %eax,%eax
80104402:	75 0c                	jne    80104410 <pushcli+0x20>
    cpu->intena = eflags & FL_IF;
80104404:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010440a:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
80104410:	83 c0 01             	add    $0x1,%eax
80104413:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
80104419:	c3                   	ret    
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <popcli>:

void
popcli(void)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104426:	9c                   	pushf  
80104427:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104428:	f6 c4 02             	test   $0x2,%ah
8010442b:	75 2c                	jne    80104459 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010442d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104434:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
8010443b:	78 0f                	js     8010444c <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
8010443d:	75 0b                	jne    8010444a <popcli+0x2a>
8010443f:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104445:	85 c0                	test   %eax,%eax
80104447:	74 01                	je     8010444a <popcli+0x2a>
  asm volatile("sti");
80104449:	fb                   	sti    
    sti();
}
8010444a:	c9                   	leave  
8010444b:	c3                   	ret    
    panic("popcli");
8010444c:	83 ec 0c             	sub    $0xc,%esp
8010444f:	68 37 75 10 80       	push   $0x80107537
80104454:	e8 37 bf ff ff       	call   80100390 <panic>
    panic("popcli - interruptible");
80104459:	83 ec 0c             	sub    $0xc,%esp
8010445c:	68 20 75 10 80       	push   $0x80107520
80104461:	e8 2a bf ff ff       	call   80100390 <panic>
80104466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446d:	8d 76 00             	lea    0x0(%esi),%esi

80104470 <release>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	83 ec 08             	sub    $0x8,%esp
80104476:	8b 45 08             	mov    0x8(%ebp),%eax
  return lock->locked && lock->cpu == cpu;
80104479:	8b 10                	mov    (%eax),%edx
8010447b:	85 d2                	test   %edx,%edx
8010447d:	74 0c                	je     8010448b <release+0x1b>
8010447f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104486:	39 50 08             	cmp    %edx,0x8(%eax)
80104489:	74 15                	je     801044a0 <release+0x30>
    panic("release");
8010448b:	83 ec 0c             	sub    $0xc,%esp
8010448e:	68 3e 75 10 80       	push   $0x8010753e
80104493:	e8 f8 be ff ff       	call   80100390 <panic>
80104498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449f:	90                   	nop
  lk->pcs[0] = 0;
801044a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801044a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  __sync_synchronize();
801044ae:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->locked = 0;
801044b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
801044b9:	c9                   	leave  
  popcli();
801044ba:	e9 61 ff ff ff       	jmp    80104420 <popcli>
801044bf:	90                   	nop

801044c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	8b 55 08             	mov    0x8(%ebp),%edx
801044c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044ca:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801044cb:	89 d0                	mov    %edx,%eax
801044cd:	09 c8                	or     %ecx,%eax
801044cf:	a8 03                	test   $0x3,%al
801044d1:	75 2d                	jne    80104500 <memset+0x40>
    c &= 0xFF;
801044d3:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801044d7:	c1 e9 02             	shr    $0x2,%ecx
801044da:	89 f8                	mov    %edi,%eax
801044dc:	89 fb                	mov    %edi,%ebx
801044de:	c1 e0 18             	shl    $0x18,%eax
801044e1:	c1 e3 10             	shl    $0x10,%ebx
801044e4:	09 d8                	or     %ebx,%eax
801044e6:	09 f8                	or     %edi,%eax
801044e8:	c1 e7 08             	shl    $0x8,%edi
801044eb:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801044ed:	89 d7                	mov    %edx,%edi
801044ef:	fc                   	cld    
801044f0:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801044f2:	5b                   	pop    %ebx
801044f3:	89 d0                	mov    %edx,%eax
801044f5:	5f                   	pop    %edi
801044f6:	5d                   	pop    %ebp
801044f7:	c3                   	ret    
801044f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ff:	90                   	nop
  asm volatile("cld; rep stosb" :
80104500:	89 d7                	mov    %edx,%edi
80104502:	8b 45 0c             	mov    0xc(%ebp),%eax
80104505:	fc                   	cld    
80104506:	f3 aa                	rep stos %al,%es:(%edi)
80104508:	5b                   	pop    %ebx
80104509:	89 d0                	mov    %edx,%eax
8010450b:	5f                   	pop    %edi
8010450c:	5d                   	pop    %ebp
8010450d:	c3                   	ret    
8010450e:	66 90                	xchg   %ax,%ax

80104510 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	8b 75 10             	mov    0x10(%ebp),%esi
80104517:	8b 45 08             	mov    0x8(%ebp),%eax
8010451a:	53                   	push   %ebx
8010451b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010451e:	85 f6                	test   %esi,%esi
80104520:	74 22                	je     80104544 <memcmp+0x34>
    if(*s1 != *s2)
80104522:	0f b6 08             	movzbl (%eax),%ecx
80104525:	0f b6 1a             	movzbl (%edx),%ebx
80104528:	01 c6                	add    %eax,%esi
8010452a:	38 cb                	cmp    %cl,%bl
8010452c:	74 0c                	je     8010453a <memcmp+0x2a>
8010452e:	eb 20                	jmp    80104550 <memcmp+0x40>
80104530:	0f b6 08             	movzbl (%eax),%ecx
80104533:	0f b6 1a             	movzbl (%edx),%ebx
80104536:	38 d9                	cmp    %bl,%cl
80104538:	75 16                	jne    80104550 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
8010453a:	83 c0 01             	add    $0x1,%eax
8010453d:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104540:	39 c6                	cmp    %eax,%esi
80104542:	75 ec                	jne    80104530 <memcmp+0x20>
  }

  return 0;
}
80104544:	5b                   	pop    %ebx
  return 0;
80104545:	31 c0                	xor    %eax,%eax
}
80104547:	5e                   	pop    %esi
80104548:	5d                   	pop    %ebp
80104549:	c3                   	ret    
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
80104550:	0f b6 c1             	movzbl %cl,%eax
80104553:	29 d8                	sub    %ebx,%eax
}
80104555:	5b                   	pop    %ebx
80104556:	5e                   	pop    %esi
80104557:	5d                   	pop    %ebp
80104558:	c3                   	ret    
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104560 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	8b 45 08             	mov    0x8(%ebp),%eax
80104567:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010456a:	56                   	push   %esi
8010456b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010456e:	39 c6                	cmp    %eax,%esi
80104570:	73 26                	jae    80104598 <memmove+0x38>
80104572:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104575:	39 f8                	cmp    %edi,%eax
80104577:	73 1f                	jae    80104598 <memmove+0x38>
80104579:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
8010457c:	85 c9                	test   %ecx,%ecx
8010457e:	74 0f                	je     8010458f <memmove+0x2f>
      *--d = *--s;
80104580:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104584:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104587:	83 ea 01             	sub    $0x1,%edx
8010458a:	83 fa ff             	cmp    $0xffffffff,%edx
8010458d:	75 f1                	jne    80104580 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010458f:	5e                   	pop    %esi
80104590:	5f                   	pop    %edi
80104591:	5d                   	pop    %ebp
80104592:	c3                   	ret    
80104593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104597:	90                   	nop
80104598:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
8010459b:	89 c7                	mov    %eax,%edi
8010459d:	85 c9                	test   %ecx,%ecx
8010459f:	74 ee                	je     8010458f <memmove+0x2f>
801045a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801045a8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801045a9:	39 d6                	cmp    %edx,%esi
801045ab:	75 fb                	jne    801045a8 <memmove+0x48>
}
801045ad:	5e                   	pop    %esi
801045ae:	5f                   	pop    %edi
801045af:	5d                   	pop    %ebp
801045b0:	c3                   	ret    
801045b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop

801045c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801045c0:	eb 9e                	jmp    80104560 <memmove>
801045c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	8b 7d 10             	mov    0x10(%ebp),%edi
801045d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801045da:	56                   	push   %esi
801045db:	8b 75 0c             	mov    0xc(%ebp),%esi
801045de:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
801045df:	85 ff                	test   %edi,%edi
801045e1:	74 2f                	je     80104612 <strncmp+0x42>
801045e3:	0f b6 11             	movzbl (%ecx),%edx
801045e6:	0f b6 1e             	movzbl (%esi),%ebx
801045e9:	84 d2                	test   %dl,%dl
801045eb:	74 37                	je     80104624 <strncmp+0x54>
801045ed:	38 da                	cmp    %bl,%dl
801045ef:	75 33                	jne    80104624 <strncmp+0x54>
801045f1:	01 f7                	add    %esi,%edi
801045f3:	eb 13                	jmp    80104608 <strncmp+0x38>
801045f5:	8d 76 00             	lea    0x0(%esi),%esi
801045f8:	0f b6 11             	movzbl (%ecx),%edx
801045fb:	84 d2                	test   %dl,%dl
801045fd:	74 21                	je     80104620 <strncmp+0x50>
801045ff:	0f b6 18             	movzbl (%eax),%ebx
80104602:	89 c6                	mov    %eax,%esi
80104604:	38 da                	cmp    %bl,%dl
80104606:	75 1c                	jne    80104624 <strncmp+0x54>
    n--, p++, q++;
80104608:	8d 46 01             	lea    0x1(%esi),%eax
8010460b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010460e:	39 f8                	cmp    %edi,%eax
80104610:	75 e6                	jne    801045f8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104612:	5b                   	pop    %ebx
    return 0;
80104613:	31 c0                	xor    %eax,%eax
}
80104615:	5e                   	pop    %esi
80104616:	5f                   	pop    %edi
80104617:	5d                   	pop    %ebp
80104618:	c3                   	ret    
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104620:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104624:	0f b6 c2             	movzbl %dl,%eax
80104627:	29 d8                	sub    %ebx,%eax
}
80104629:	5b                   	pop    %ebx
8010462a:	5e                   	pop    %esi
8010462b:	5f                   	pop    %edi
8010462c:	5d                   	pop    %ebp
8010462d:	c3                   	ret    
8010462e:	66 90                	xchg   %ax,%ax

80104630 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	57                   	push   %edi
80104634:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104637:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
8010463a:	56                   	push   %esi
8010463b:	53                   	push   %ebx
8010463c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
8010463f:	eb 1a                	jmp    8010465b <strncpy+0x2b>
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104648:	83 c2 01             	add    $0x1,%edx
8010464b:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
8010464f:	83 c1 01             	add    $0x1,%ecx
80104652:	88 41 ff             	mov    %al,-0x1(%ecx)
80104655:	84 c0                	test   %al,%al
80104657:	74 09                	je     80104662 <strncpy+0x32>
80104659:	89 fb                	mov    %edi,%ebx
8010465b:	8d 7b ff             	lea    -0x1(%ebx),%edi
8010465e:	85 db                	test   %ebx,%ebx
80104660:	7f e6                	jg     80104648 <strncpy+0x18>
    ;
  while(n-- > 0)
80104662:	89 ce                	mov    %ecx,%esi
80104664:	85 ff                	test   %edi,%edi
80104666:	7e 1b                	jle    80104683 <strncpy+0x53>
80104668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466f:	90                   	nop
    *s++ = 0;
80104670:	83 c6 01             	add    $0x1,%esi
80104673:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
80104677:	89 f2                	mov    %esi,%edx
80104679:	f7 d2                	not    %edx
8010467b:	01 ca                	add    %ecx,%edx
8010467d:	01 da                	add    %ebx,%edx
  while(n-- > 0)
8010467f:	85 d2                	test   %edx,%edx
80104681:	7f ed                	jg     80104670 <strncpy+0x40>
  return os;
}
80104683:	5b                   	pop    %ebx
80104684:	8b 45 08             	mov    0x8(%ebp),%eax
80104687:	5e                   	pop    %esi
80104688:	5f                   	pop    %edi
80104689:	5d                   	pop    %ebp
8010468a:	c3                   	ret    
8010468b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop

80104690 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104697:	8b 45 08             	mov    0x8(%ebp),%eax
8010469a:	53                   	push   %ebx
8010469b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010469e:	85 c9                	test   %ecx,%ecx
801046a0:	7e 26                	jle    801046c8 <safestrcpy+0x38>
801046a2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046a6:	89 c1                	mov    %eax,%ecx
801046a8:	eb 17                	jmp    801046c1 <safestrcpy+0x31>
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046b0:	83 c2 01             	add    $0x1,%edx
801046b3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046b7:	83 c1 01             	add    $0x1,%ecx
801046ba:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046bd:	84 db                	test   %bl,%bl
801046bf:	74 04                	je     801046c5 <safestrcpy+0x35>
801046c1:	39 f2                	cmp    %esi,%edx
801046c3:	75 eb                	jne    801046b0 <safestrcpy+0x20>
    ;
  *s = 0;
801046c5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046c8:	5b                   	pop    %ebx
801046c9:	5e                   	pop    %esi
801046ca:	5d                   	pop    %ebp
801046cb:	c3                   	ret    
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <strlen>:

int
strlen(const char *s)
{
801046d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046d1:	31 c0                	xor    %eax,%eax
{
801046d3:	89 e5                	mov    %esp,%ebp
801046d5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801046d8:	80 3a 00             	cmpb   $0x0,(%edx)
801046db:	74 0c                	je     801046e9 <strlen+0x19>
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
801046e0:	83 c0 01             	add    $0x1,%eax
801046e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046e7:	75 f7                	jne    801046e0 <strlen+0x10>
    ;
  return n;
}
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    

801046eb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046ef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801046f3:	55                   	push   %ebp
  pushl %ebx
801046f4:	53                   	push   %ebx
  pushl %esi
801046f5:	56                   	push   %esi
  pushl %edi
801046f6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801046f7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801046f9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801046fb:	5f                   	pop    %edi
  popl %esi
801046fc:	5e                   	pop    %esi
  popl %ebx
801046fd:	5b                   	pop    %ebx
  popl %ebp
801046fe:	5d                   	pop    %ebp
  ret
801046ff:	c3                   	ret    

80104700 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104700:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104701:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104708:	8b 12                	mov    (%edx),%edx
{
8010470a:	89 e5                	mov    %esp,%ebp
8010470c:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010470f:	39 c2                	cmp    %eax,%edx
80104711:	76 15                	jbe    80104728 <fetchint+0x28>
80104713:	8d 48 04             	lea    0x4(%eax),%ecx
80104716:	39 ca                	cmp    %ecx,%edx
80104718:	72 0e                	jb     80104728 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010471a:	8b 10                	mov    (%eax),%edx
8010471c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010471f:	89 10                	mov    %edx,(%eax)
  return 0;
80104721:	31 c0                	xor    %eax,%eax
}
80104723:	5d                   	pop    %ebp
80104724:	c3                   	ret    
80104725:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010472d:	5d                   	pop    %ebp
8010472e:	c3                   	ret    
8010472f:	90                   	nop

80104730 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104730:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104731:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
{
80104737:	89 e5                	mov    %esp,%ebp
80104739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= proc->sz)
8010473c:	39 08                	cmp    %ecx,(%eax)
8010473e:	76 2c                	jbe    8010476c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104740:	8b 45 0c             	mov    0xc(%ebp),%eax
80104743:	89 08                	mov    %ecx,(%eax)
  ep = (char*)proc->sz;
80104745:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010474b:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++)
8010474d:	39 d1                	cmp    %edx,%ecx
8010474f:	73 1b                	jae    8010476c <fetchstr+0x3c>
    if(*s == 0)
80104751:	80 39 00             	cmpb   $0x0,(%ecx)
80104754:	74 26                	je     8010477c <fetchstr+0x4c>
80104756:	89 c8                	mov    %ecx,%eax
80104758:	eb 0b                	jmp    80104765 <fetchstr+0x35>
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104760:	80 38 00             	cmpb   $0x0,(%eax)
80104763:	74 13                	je     80104778 <fetchstr+0x48>
  for(s = *pp; s < ep; s++)
80104765:	83 c0 01             	add    $0x1,%eax
80104768:	39 c2                	cmp    %eax,%edx
8010476a:	77 f4                	ja     80104760 <fetchstr+0x30>
    return -1;
8010476c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  return -1;
}
80104771:	5d                   	pop    %ebp
80104772:	c3                   	ret    
80104773:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104777:	90                   	nop
80104778:	29 c8                	sub    %ecx,%eax
8010477a:	5d                   	pop    %ebp
8010477b:	c3                   	ret    
    if(*s == 0)
8010477c:	31 c0                	xor    %eax,%eax
}
8010477e:	5d                   	pop    %ebp
8010477f:	c3                   	ret    

80104780 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104780:	55                   	push   %ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104781:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104788:	8b 42 18             	mov    0x18(%edx),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010478b:	8b 12                	mov    (%edx),%edx
{
8010478d:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010478f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104792:	8b 40 44             	mov    0x44(%eax),%eax
80104795:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104798:	8d 48 04             	lea    0x4(%eax),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
8010479b:	39 d1                	cmp    %edx,%ecx
8010479d:	73 19                	jae    801047b8 <argint+0x38>
8010479f:	8d 48 08             	lea    0x8(%eax),%ecx
801047a2:	39 ca                	cmp    %ecx,%edx
801047a4:	72 12                	jb     801047b8 <argint+0x38>
  *ip = *(int*)(addr);
801047a6:	8b 50 04             	mov    0x4(%eax),%edx
801047a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ac:	89 10                	mov    %edx,(%eax)
  return 0;
801047ae:	31 c0                	xor    %eax,%eax
}
801047b0:	5d                   	pop    %ebp
801047b1:	c3                   	ret    
801047b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801047b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047bd:	5d                   	pop    %ebp
801047be:	c3                   	ret    
801047bf:	90                   	nop

801047c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047c0:	55                   	push   %ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c7:	8b 50 18             	mov    0x18(%eax),%edx
  if(addr >= proc->sz || addr+4 > proc->sz)
801047ca:	8b 00                	mov    (%eax),%eax
{
801047cc:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047d1:	8b 52 44             	mov    0x44(%edx),%edx
801047d4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
801047d7:	8d 4a 04             	lea    0x4(%edx),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
801047da:	39 c1                	cmp    %eax,%ecx
801047dc:	73 22                	jae    80104800 <argptr+0x40>
801047de:	8d 4a 08             	lea    0x8(%edx),%ecx
801047e1:	39 c8                	cmp    %ecx,%eax
801047e3:	72 1b                	jb     80104800 <argptr+0x40>
  *ip = *(int*)(addr);
801047e5:	8b 52 04             	mov    0x4(%edx),%edx
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801047e8:	39 c2                	cmp    %eax,%edx
801047ea:	73 14                	jae    80104800 <argptr+0x40>
801047ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047ef:	01 d1                	add    %edx,%ecx
801047f1:	39 c1                	cmp    %eax,%ecx
801047f3:	77 0b                	ja     80104800 <argptr+0x40>
    return -1;
  *pp = (char*)i;
801047f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801047f8:	89 10                	mov    %edx,(%eax)
  return 0;
801047fa:	31 c0                	xor    %eax,%eax
}
801047fc:	5d                   	pop    %ebp
801047fd:	c3                   	ret    
801047fe:	66 90                	xchg   %ax,%ax
    return -1;
80104800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104805:	5d                   	pop    %ebp
80104806:	c3                   	ret    
80104807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480e:	66 90                	xchg   %ax,%ax

80104810 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104810:	55                   	push   %ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104811:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104817:	8b 50 18             	mov    0x18(%eax),%edx
  if(addr >= proc->sz || addr+4 > proc->sz)
8010481a:	8b 00                	mov    (%eax),%eax
{
8010481c:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010481e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104821:	8b 52 44             	mov    0x44(%edx),%edx
80104824:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104827:	8d 4a 04             	lea    0x4(%edx),%ecx
  if(addr >= proc->sz || addr+4 > proc->sz)
8010482a:	39 c1                	cmp    %eax,%ecx
8010482c:	73 3e                	jae    8010486c <argstr+0x5c>
8010482e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104831:	39 c8                	cmp    %ecx,%eax
80104833:	72 37                	jb     8010486c <argstr+0x5c>
  *ip = *(int*)(addr);
80104835:	8b 4a 04             	mov    0x4(%edx),%ecx
  if(addr >= proc->sz)
80104838:	39 c1                	cmp    %eax,%ecx
8010483a:	73 30                	jae    8010486c <argstr+0x5c>
  *pp = (char*)addr;
8010483c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010483f:	89 08                	mov    %ecx,(%eax)
  ep = (char*)proc->sz;
80104841:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104847:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++)
80104849:	39 d1                	cmp    %edx,%ecx
8010484b:	73 1f                	jae    8010486c <argstr+0x5c>
    if(*s == 0)
8010484d:	80 39 00             	cmpb   $0x0,(%ecx)
80104850:	74 2a                	je     8010487c <argstr+0x6c>
80104852:	89 c8                	mov    %ecx,%eax
80104854:	eb 0f                	jmp    80104865 <argstr+0x55>
80104856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485d:	8d 76 00             	lea    0x0(%esi),%esi
80104860:	80 38 00             	cmpb   $0x0,(%eax)
80104863:	74 13                	je     80104878 <argstr+0x68>
  for(s = *pp; s < ep; s++)
80104865:	83 c0 01             	add    $0x1,%eax
80104868:	39 c2                	cmp    %eax,%edx
8010486a:	77 f4                	ja     80104860 <argstr+0x50>
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
8010486c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104871:	5d                   	pop    %ebp
80104872:	c3                   	ret    
80104873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104877:	90                   	nop
80104878:	29 c8                	sub    %ecx,%eax
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    
    if(*s == 0)
8010487c:	31 c0                	xor    %eax,%eax
}
8010487e:	5d                   	pop    %ebp
8010487f:	c3                   	ret    

80104880 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	83 ec 08             	sub    $0x8,%esp
  int num;

  num = proc->tf->eax;
80104886:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010488d:	8b 42 18             	mov    0x18(%edx),%eax
80104890:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104893:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104896:	83 f9 14             	cmp    $0x14,%ecx
80104899:	77 25                	ja     801048c0 <syscall+0x40>
8010489b:	8b 0c 85 80 75 10 80 	mov    -0x7fef8a80(,%eax,4),%ecx
801048a2:	85 c9                	test   %ecx,%ecx
801048a4:	74 1a                	je     801048c0 <syscall+0x40>
    proc->tf->eax = syscalls[num]();
801048a6:	ff d1                	call   *%ecx
801048a8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048af:	8b 52 18             	mov    0x18(%edx),%edx
801048b2:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
801048b5:	c9                   	leave  
801048b6:	c3                   	ret    
801048b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048be:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
801048c0:	50                   	push   %eax
            proc->pid, proc->name, num);
801048c1:	8d 42 6c             	lea    0x6c(%edx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801048c4:	50                   	push   %eax
801048c5:	ff 72 10             	pushl  0x10(%edx)
801048c8:	68 46 75 10 80       	push   $0x80107546
801048cd:	e8 de bd ff ff       	call   801006b0 <cprintf>
    proc->tf->eax = -1;
801048d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d8:	83 c4 10             	add    $0x10,%esp
801048db:	8b 40 18             	mov    0x18(%eax),%eax
801048de:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801048e5:	c9                   	leave  
801048e6:	c3                   	ret    
801048e7:	66 90                	xchg   %ax,%ax
801048e9:	66 90                	xchg   %ax,%ax
801048eb:	66 90                	xchg   %ax,%ax
801048ed:	66 90                	xchg   %ax,%ax
801048ef:	90                   	nop

801048f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048f6:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801048f9:	83 ec 44             	sub    $0x44,%esp
801048fc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801048ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104902:	53                   	push   %ebx
80104903:	50                   	push   %eax
{
80104904:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104907:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010490a:	e8 d1 d6 ff ff       	call   80101fe0 <nameiparent>
8010490f:	83 c4 10             	add    $0x10,%esp
80104912:	85 c0                	test   %eax,%eax
80104914:	0f 84 46 01 00 00    	je     80104a60 <create+0x170>
    return 0;
  ilock(dp);
8010491a:	83 ec 0c             	sub    $0xc,%esp
8010491d:	89 c6                	mov    %eax,%esi
8010491f:	50                   	push   %eax
80104920:	e8 ab cd ff ff       	call   801016d0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104925:	83 c4 0c             	add    $0xc,%esp
80104928:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010492b:	50                   	push   %eax
8010492c:	53                   	push   %ebx
8010492d:	56                   	push   %esi
8010492e:	e8 1d d3 ff ff       	call   80101c50 <dirlookup>
80104933:	83 c4 10             	add    $0x10,%esp
80104936:	89 c7                	mov    %eax,%edi
80104938:	85 c0                	test   %eax,%eax
8010493a:	74 54                	je     80104990 <create+0xa0>
    iunlockput(dp);
8010493c:	83 ec 0c             	sub    $0xc,%esp
8010493f:	56                   	push   %esi
80104940:	e8 6b d0 ff ff       	call   801019b0 <iunlockput>
    ilock(ip);
80104945:	89 3c 24             	mov    %edi,(%esp)
80104948:	e8 83 cd ff ff       	call   801016d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010494d:	83 c4 10             	add    $0x10,%esp
80104950:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104955:	75 19                	jne    80104970 <create+0x80>
80104957:	66 83 7f 10 02       	cmpw   $0x2,0x10(%edi)
8010495c:	75 12                	jne    80104970 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010495e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104961:	89 f8                	mov    %edi,%eax
80104963:	5b                   	pop    %ebx
80104964:	5e                   	pop    %esi
80104965:	5f                   	pop    %edi
80104966:	5d                   	pop    %ebp
80104967:	c3                   	ret    
80104968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496f:	90                   	nop
    iunlockput(ip);
80104970:	83 ec 0c             	sub    $0xc,%esp
80104973:	57                   	push   %edi
    return 0;
80104974:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104976:	e8 35 d0 ff ff       	call   801019b0 <iunlockput>
    return 0;
8010497b:	83 c4 10             	add    $0x10,%esp
}
8010497e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104981:	89 f8                	mov    %edi,%eax
80104983:	5b                   	pop    %ebx
80104984:	5e                   	pop    %esi
80104985:	5f                   	pop    %edi
80104986:	5d                   	pop    %ebp
80104987:	c3                   	ret    
80104988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104990:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104994:	83 ec 08             	sub    $0x8,%esp
80104997:	50                   	push   %eax
80104998:	ff 36                	pushl  (%esi)
8010499a:	e8 c1 cb ff ff       	call   80101560 <ialloc>
8010499f:	83 c4 10             	add    $0x10,%esp
801049a2:	89 c7                	mov    %eax,%edi
801049a4:	85 c0                	test   %eax,%eax
801049a6:	0f 84 cd 00 00 00    	je     80104a79 <create+0x189>
  ilock(ip);
801049ac:	83 ec 0c             	sub    $0xc,%esp
801049af:	50                   	push   %eax
801049b0:	e8 1b cd ff ff       	call   801016d0 <ilock>
  ip->major = major;
801049b5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049b9:	66 89 47 12          	mov    %ax,0x12(%edi)
  ip->minor = minor;
801049bd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049c1:	66 89 47 14          	mov    %ax,0x14(%edi)
  ip->nlink = 1;
801049c5:	b8 01 00 00 00       	mov    $0x1,%eax
801049ca:	66 89 47 16          	mov    %ax,0x16(%edi)
  iupdate(ip);
801049ce:	89 3c 24             	mov    %edi,(%esp)
801049d1:	e8 4a cc ff ff       	call   80101620 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801049d6:	83 c4 10             	add    $0x10,%esp
801049d9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049de:	74 30                	je     80104a10 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801049e0:	83 ec 04             	sub    $0x4,%esp
801049e3:	ff 77 04             	pushl  0x4(%edi)
801049e6:	53                   	push   %ebx
801049e7:	56                   	push   %esi
801049e8:	e8 13 d5 ff ff       	call   80101f00 <dirlink>
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	85 c0                	test   %eax,%eax
801049f2:	78 78                	js     80104a6c <create+0x17c>
  iunlockput(dp);
801049f4:	83 ec 0c             	sub    $0xc,%esp
801049f7:	56                   	push   %esi
801049f8:	e8 b3 cf ff ff       	call   801019b0 <iunlockput>
  return ip;
801049fd:	83 c4 10             	add    $0x10,%esp
}
80104a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a03:	89 f8                	mov    %edi,%eax
80104a05:	5b                   	pop    %ebx
80104a06:	5e                   	pop    %esi
80104a07:	5f                   	pop    %edi
80104a08:	5d                   	pop    %ebp
80104a09:	c3                   	ret    
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104a10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104a13:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
80104a18:	56                   	push   %esi
80104a19:	e8 02 cc ff ff       	call   80101620 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a1e:	83 c4 0c             	add    $0xc,%esp
80104a21:	ff 77 04             	pushl  0x4(%edi)
80104a24:	68 f4 75 10 80       	push   $0x801075f4
80104a29:	57                   	push   %edi
80104a2a:	e8 d1 d4 ff ff       	call   80101f00 <dirlink>
80104a2f:	83 c4 10             	add    $0x10,%esp
80104a32:	85 c0                	test   %eax,%eax
80104a34:	78 18                	js     80104a4e <create+0x15e>
80104a36:	83 ec 04             	sub    $0x4,%esp
80104a39:	ff 76 04             	pushl  0x4(%esi)
80104a3c:	68 f3 75 10 80       	push   $0x801075f3
80104a41:	57                   	push   %edi
80104a42:	e8 b9 d4 ff ff       	call   80101f00 <dirlink>
80104a47:	83 c4 10             	add    $0x10,%esp
80104a4a:	85 c0                	test   %eax,%eax
80104a4c:	79 92                	jns    801049e0 <create+0xf0>
      panic("create dots");
80104a4e:	83 ec 0c             	sub    $0xc,%esp
80104a51:	68 e7 75 10 80       	push   $0x801075e7
80104a56:	e8 35 b9 ff ff       	call   80100390 <panic>
80104a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a5f:	90                   	nop
}
80104a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104a63:	31 ff                	xor    %edi,%edi
}
80104a65:	5b                   	pop    %ebx
80104a66:	89 f8                	mov    %edi,%eax
80104a68:	5e                   	pop    %esi
80104a69:	5f                   	pop    %edi
80104a6a:	5d                   	pop    %ebp
80104a6b:	c3                   	ret    
    panic("create: dirlink");
80104a6c:	83 ec 0c             	sub    $0xc,%esp
80104a6f:	68 f6 75 10 80       	push   $0x801075f6
80104a74:	e8 17 b9 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104a79:	83 ec 0c             	sub    $0xc,%esp
80104a7c:	68 d8 75 10 80       	push   $0x801075d8
80104a81:	e8 0a b9 ff ff       	call   80100390 <panic>
80104a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	89 d6                	mov    %edx,%esi
80104a96:	53                   	push   %ebx
80104a97:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104a99:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104a9c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104a9f:	50                   	push   %eax
80104aa0:	6a 00                	push   $0x0
80104aa2:	e8 d9 fc ff ff       	call   80104780 <argint>
80104aa7:	83 c4 10             	add    $0x10,%esp
80104aaa:	85 c0                	test   %eax,%eax
80104aac:	78 32                	js     80104ae0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab1:	83 f8 0f             	cmp    $0xf,%eax
80104ab4:	77 2a                	ja     80104ae0 <argfd.constprop.0+0x50>
80104ab6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104abd:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80104ac1:	85 c9                	test   %ecx,%ecx
80104ac3:	74 1b                	je     80104ae0 <argfd.constprop.0+0x50>
  if(pfd)
80104ac5:	85 db                	test   %ebx,%ebx
80104ac7:	74 02                	je     80104acb <argfd.constprop.0+0x3b>
    *pfd = fd;
80104ac9:	89 03                	mov    %eax,(%ebx)
    *pf = f;
80104acb:	89 0e                	mov    %ecx,(%esi)
  return 0;
80104acd:	31 c0                	xor    %eax,%eax
}
80104acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ad2:	5b                   	pop    %ebx
80104ad3:	5e                   	pop    %esi
80104ad4:	5d                   	pop    %ebp
80104ad5:	c3                   	ret    
80104ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104add:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ae5:	eb e8                	jmp    80104acf <argfd.constprop.0+0x3f>
80104ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <sys_dup>:
{
80104af0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104af1:	31 c0                	xor    %eax,%eax
{
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104af6:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104af9:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
80104afc:	e8 8f ff ff ff       	call   80104a90 <argfd.constprop.0>
80104b01:	85 c0                	test   %eax,%eax
80104b03:	78 1b                	js     80104b20 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104b05:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if(proc->ofile[fd] == 0){
80104b08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(fd = 0; fd < NOFILE; fd++){
80104b0e:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104b10:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104b14:	85 c9                	test   %ecx,%ecx
80104b16:	74 18                	je     80104b30 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104b18:	83 c3 01             	add    $0x1,%ebx
80104b1b:	83 fb 10             	cmp    $0x10,%ebx
80104b1e:	75 f0                	jne    80104b10 <sys_dup+0x20>
    return -1;
80104b20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104b25:	89 d8                	mov    %ebx,%eax
80104b27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b2a:	c9                   	leave  
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  filedup(f);
80104b30:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
80104b33:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  filedup(f);
80104b37:	52                   	push   %edx
80104b38:	e8 23 c3 ff ff       	call   80100e60 <filedup>
}
80104b3d:	89 d8                	mov    %ebx,%eax
  return fd;
80104b3f:	83 c4 10             	add    $0x10,%esp
}
80104b42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b45:	c9                   	leave  
80104b46:	c3                   	ret    
80104b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <sys_read>:
{
80104b50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b51:	31 c0                	xor    %eax,%eax
{
80104b53:	89 e5                	mov    %esp,%ebp
80104b55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b5b:	e8 30 ff ff ff       	call   80104a90 <argfd.constprop.0>
80104b60:	85 c0                	test   %eax,%eax
80104b62:	78 4c                	js     80104bb0 <sys_read+0x60>
80104b64:	83 ec 08             	sub    $0x8,%esp
80104b67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b6a:	50                   	push   %eax
80104b6b:	6a 02                	push   $0x2
80104b6d:	e8 0e fc ff ff       	call   80104780 <argint>
80104b72:	83 c4 10             	add    $0x10,%esp
80104b75:	85 c0                	test   %eax,%eax
80104b77:	78 37                	js     80104bb0 <sys_read+0x60>
80104b79:	83 ec 04             	sub    $0x4,%esp
80104b7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b82:	50                   	push   %eax
80104b83:	6a 01                	push   $0x1
80104b85:	e8 36 fc ff ff       	call   801047c0 <argptr>
80104b8a:	83 c4 10             	add    $0x10,%esp
80104b8d:	85 c0                	test   %eax,%eax
80104b8f:	78 1f                	js     80104bb0 <sys_read+0x60>
  return fileread(f, p, n);
80104b91:	83 ec 04             	sub    $0x4,%esp
80104b94:	ff 75 f0             	pushl  -0x10(%ebp)
80104b97:	ff 75 f4             	pushl  -0xc(%ebp)
80104b9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b9d:	e8 3e c4 ff ff       	call   80100fe0 <fileread>
80104ba2:	83 c4 10             	add    $0x10,%esp
}
80104ba5:	c9                   	leave  
80104ba6:	c3                   	ret    
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax
80104bb0:	c9                   	leave  
    return -1;
80104bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bb6:	c3                   	ret    
80104bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <sys_write>:
{
80104bc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bc1:	31 c0                	xor    %eax,%eax
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bcb:	e8 c0 fe ff ff       	call   80104a90 <argfd.constprop.0>
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	78 4c                	js     80104c20 <sys_write+0x60>
80104bd4:	83 ec 08             	sub    $0x8,%esp
80104bd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bda:	50                   	push   %eax
80104bdb:	6a 02                	push   $0x2
80104bdd:	e8 9e fb ff ff       	call   80104780 <argint>
80104be2:	83 c4 10             	add    $0x10,%esp
80104be5:	85 c0                	test   %eax,%eax
80104be7:	78 37                	js     80104c20 <sys_write+0x60>
80104be9:	83 ec 04             	sub    $0x4,%esp
80104bec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bef:	ff 75 f0             	pushl  -0x10(%ebp)
80104bf2:	50                   	push   %eax
80104bf3:	6a 01                	push   $0x1
80104bf5:	e8 c6 fb ff ff       	call   801047c0 <argptr>
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	78 1f                	js     80104c20 <sys_write+0x60>
  return filewrite(f, p, n);
80104c01:	83 ec 04             	sub    $0x4,%esp
80104c04:	ff 75 f0             	pushl  -0x10(%ebp)
80104c07:	ff 75 f4             	pushl  -0xc(%ebp)
80104c0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c0d:	e8 5e c4 ff ff       	call   80101070 <filewrite>
80104c12:	83 c4 10             	add    $0x10,%esp
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax
80104c20:	c9                   	leave  
    return -1;
80104c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c26:	c3                   	ret    
80104c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <sys_close>:
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104c36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c3c:	e8 4f fe ff ff       	call   80104a90 <argfd.constprop.0>
80104c41:	85 c0                	test   %eax,%eax
80104c43:	78 2b                	js     80104c70 <sys_close+0x40>
  proc->ofile[fd] = 0;
80104c45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c4e:	83 ec 0c             	sub    $0xc,%esp
  proc->ofile[fd] = 0;
80104c51:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c58:	00 
  fileclose(f);
80104c59:	ff 75 f4             	pushl  -0xc(%ebp)
80104c5c:	e8 4f c2 ff ff       	call   80100eb0 <fileclose>
  return 0;
80104c61:	83 c4 10             	add    $0x10,%esp
80104c64:	31 c0                	xor    %eax,%eax
}
80104c66:	c9                   	leave  
80104c67:	c3                   	ret    
80104c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop
80104c70:	c9                   	leave  
    return -1;
80104c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c76:	c3                   	ret    
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <sys_fstat>:
{
80104c80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c81:	31 c0                	xor    %eax,%eax
{
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c8b:	e8 00 fe ff ff       	call   80104a90 <argfd.constprop.0>
80104c90:	85 c0                	test   %eax,%eax
80104c92:	78 2c                	js     80104cc0 <sys_fstat+0x40>
80104c94:	83 ec 04             	sub    $0x4,%esp
80104c97:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c9a:	6a 14                	push   $0x14
80104c9c:	50                   	push   %eax
80104c9d:	6a 01                	push   $0x1
80104c9f:	e8 1c fb ff ff       	call   801047c0 <argptr>
80104ca4:	83 c4 10             	add    $0x10,%esp
80104ca7:	85 c0                	test   %eax,%eax
80104ca9:	78 15                	js     80104cc0 <sys_fstat+0x40>
  return filestat(f, st);
80104cab:	83 ec 08             	sub    $0x8,%esp
80104cae:	ff 75 f4             	pushl  -0xc(%ebp)
80104cb1:	ff 75 f0             	pushl  -0x10(%ebp)
80104cb4:	e8 d7 c2 ff ff       	call   80100f90 <filestat>
80104cb9:	83 c4 10             	add    $0x10,%esp
}
80104cbc:	c9                   	leave  
80104cbd:	c3                   	ret    
80104cbe:	66 90                	xchg   %ax,%ax
80104cc0:	c9                   	leave  
    return -1;
80104cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cc6:	c3                   	ret    
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <sys_link>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cd5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104cd8:	53                   	push   %ebx
80104cd9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cdc:	50                   	push   %eax
80104cdd:	6a 00                	push   $0x0
80104cdf:	e8 2c fb ff ff       	call   80104810 <argstr>
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	0f 88 fb 00 00 00    	js     80104dea <sys_link+0x11a>
80104cef:	83 ec 08             	sub    $0x8,%esp
80104cf2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104cf5:	50                   	push   %eax
80104cf6:	6a 01                	push   $0x1
80104cf8:	e8 13 fb ff ff       	call   80104810 <argstr>
80104cfd:	83 c4 10             	add    $0x10,%esp
80104d00:	85 c0                	test   %eax,%eax
80104d02:	0f 88 e2 00 00 00    	js     80104dea <sys_link+0x11a>
  begin_op();
80104d08:	e8 33 e0 ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80104d0d:	83 ec 0c             	sub    $0xc,%esp
80104d10:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d13:	e8 a8 d2 ff ff       	call   80101fc0 <namei>
80104d18:	83 c4 10             	add    $0x10,%esp
80104d1b:	89 c3                	mov    %eax,%ebx
80104d1d:	85 c0                	test   %eax,%eax
80104d1f:	0f 84 e4 00 00 00    	je     80104e09 <sys_link+0x139>
  ilock(ip);
80104d25:	83 ec 0c             	sub    $0xc,%esp
80104d28:	50                   	push   %eax
80104d29:	e8 a2 c9 ff ff       	call   801016d0 <ilock>
  if(ip->type == T_DIR){
80104d2e:	83 c4 10             	add    $0x10,%esp
80104d31:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104d36:	0f 84 b5 00 00 00    	je     80104df1 <sys_link+0x121>
  iupdate(ip);
80104d3c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104d3f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104d44:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104d47:	53                   	push   %ebx
80104d48:	e8 d3 c8 ff ff       	call   80101620 <iupdate>
  iunlock(ip);
80104d4d:	89 1c 24             	mov    %ebx,(%esp)
80104d50:	e8 8b ca ff ff       	call   801017e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104d55:	58                   	pop    %eax
80104d56:	5a                   	pop    %edx
80104d57:	57                   	push   %edi
80104d58:	ff 75 d0             	pushl  -0x30(%ebp)
80104d5b:	e8 80 d2 ff ff       	call   80101fe0 <nameiparent>
80104d60:	83 c4 10             	add    $0x10,%esp
80104d63:	89 c6                	mov    %eax,%esi
80104d65:	85 c0                	test   %eax,%eax
80104d67:	74 5b                	je     80104dc4 <sys_link+0xf4>
  ilock(dp);
80104d69:	83 ec 0c             	sub    $0xc,%esp
80104d6c:	50                   	push   %eax
80104d6d:	e8 5e c9 ff ff       	call   801016d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d72:	83 c4 10             	add    $0x10,%esp
80104d75:	8b 03                	mov    (%ebx),%eax
80104d77:	39 06                	cmp    %eax,(%esi)
80104d79:	75 3d                	jne    80104db8 <sys_link+0xe8>
80104d7b:	83 ec 04             	sub    $0x4,%esp
80104d7e:	ff 73 04             	pushl  0x4(%ebx)
80104d81:	57                   	push   %edi
80104d82:	56                   	push   %esi
80104d83:	e8 78 d1 ff ff       	call   80101f00 <dirlink>
80104d88:	83 c4 10             	add    $0x10,%esp
80104d8b:	85 c0                	test   %eax,%eax
80104d8d:	78 29                	js     80104db8 <sys_link+0xe8>
  iunlockput(dp);
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	56                   	push   %esi
80104d93:	e8 18 cc ff ff       	call   801019b0 <iunlockput>
  iput(ip);
80104d98:	89 1c 24             	mov    %ebx,(%esp)
80104d9b:	e8 a0 ca ff ff       	call   80101840 <iput>
  end_op();
80104da0:	e8 0b e0 ff ff       	call   80102db0 <end_op>
  return 0;
80104da5:	83 c4 10             	add    $0x10,%esp
80104da8:	31 c0                	xor    %eax,%eax
}
80104daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dad:	5b                   	pop    %ebx
80104dae:	5e                   	pop    %esi
80104daf:	5f                   	pop    %edi
80104db0:	5d                   	pop    %ebp
80104db1:	c3                   	ret    
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104db8:	83 ec 0c             	sub    $0xc,%esp
80104dbb:	56                   	push   %esi
80104dbc:	e8 ef cb ff ff       	call   801019b0 <iunlockput>
    goto bad;
80104dc1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104dc4:	83 ec 0c             	sub    $0xc,%esp
80104dc7:	53                   	push   %ebx
80104dc8:	e8 03 c9 ff ff       	call   801016d0 <ilock>
  ip->nlink--;
80104dcd:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104dd2:	89 1c 24             	mov    %ebx,(%esp)
80104dd5:	e8 46 c8 ff ff       	call   80101620 <iupdate>
  iunlockput(ip);
80104dda:	89 1c 24             	mov    %ebx,(%esp)
80104ddd:	e8 ce cb ff ff       	call   801019b0 <iunlockput>
  end_op();
80104de2:	e8 c9 df ff ff       	call   80102db0 <end_op>
  return -1;
80104de7:	83 c4 10             	add    $0x10,%esp
80104dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104def:	eb b9                	jmp    80104daa <sys_link+0xda>
    iunlockput(ip);
80104df1:	83 ec 0c             	sub    $0xc,%esp
80104df4:	53                   	push   %ebx
80104df5:	e8 b6 cb ff ff       	call   801019b0 <iunlockput>
    end_op();
80104dfa:	e8 b1 df ff ff       	call   80102db0 <end_op>
    return -1;
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e07:	eb a1                	jmp    80104daa <sys_link+0xda>
    end_op();
80104e09:	e8 a2 df ff ff       	call   80102db0 <end_op>
    return -1;
80104e0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e13:	eb 95                	jmp    80104daa <sys_link+0xda>
80104e15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e20 <sys_unlink>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104e25:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104e28:	53                   	push   %ebx
80104e29:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104e2c:	50                   	push   %eax
80104e2d:	6a 00                	push   $0x0
80104e2f:	e8 dc f9 ff ff       	call   80104810 <argstr>
80104e34:	83 c4 10             	add    $0x10,%esp
80104e37:	85 c0                	test   %eax,%eax
80104e39:	0f 88 91 01 00 00    	js     80104fd0 <sys_unlink+0x1b0>
  begin_op();
80104e3f:	e8 fc de ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e44:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104e47:	83 ec 08             	sub    $0x8,%esp
80104e4a:	53                   	push   %ebx
80104e4b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e4e:	e8 8d d1 ff ff       	call   80101fe0 <nameiparent>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	89 c6                	mov    %eax,%esi
80104e58:	85 c0                	test   %eax,%eax
80104e5a:	0f 84 7a 01 00 00    	je     80104fda <sys_unlink+0x1ba>
  ilock(dp);
80104e60:	83 ec 0c             	sub    $0xc,%esp
80104e63:	50                   	push   %eax
80104e64:	e8 67 c8 ff ff       	call   801016d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e69:	58                   	pop    %eax
80104e6a:	5a                   	pop    %edx
80104e6b:	68 f4 75 10 80       	push   $0x801075f4
80104e70:	53                   	push   %ebx
80104e71:	e8 ba cd ff ff       	call   80101c30 <namecmp>
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	0f 84 0f 01 00 00    	je     80104f90 <sys_unlink+0x170>
80104e81:	83 ec 08             	sub    $0x8,%esp
80104e84:	68 f3 75 10 80       	push   $0x801075f3
80104e89:	53                   	push   %ebx
80104e8a:	e8 a1 cd ff ff       	call   80101c30 <namecmp>
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	85 c0                	test   %eax,%eax
80104e94:	0f 84 f6 00 00 00    	je     80104f90 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104e9a:	83 ec 04             	sub    $0x4,%esp
80104e9d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ea0:	50                   	push   %eax
80104ea1:	53                   	push   %ebx
80104ea2:	56                   	push   %esi
80104ea3:	e8 a8 cd ff ff       	call   80101c50 <dirlookup>
80104ea8:	83 c4 10             	add    $0x10,%esp
80104eab:	89 c3                	mov    %eax,%ebx
80104ead:	85 c0                	test   %eax,%eax
80104eaf:	0f 84 db 00 00 00    	je     80104f90 <sys_unlink+0x170>
  ilock(ip);
80104eb5:	83 ec 0c             	sub    $0xc,%esp
80104eb8:	50                   	push   %eax
80104eb9:	e8 12 c8 ff ff       	call   801016d0 <ilock>
  if(ip->nlink < 1)
80104ebe:	83 c4 10             	add    $0x10,%esp
80104ec1:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
80104ec6:	0f 8e 37 01 00 00    	jle    80105003 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ecc:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104ed1:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104ed4:	74 6a                	je     80104f40 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104ed6:	83 ec 04             	sub    $0x4,%esp
80104ed9:	6a 10                	push   $0x10
80104edb:	6a 00                	push   $0x0
80104edd:	57                   	push   %edi
80104ede:	e8 dd f5 ff ff       	call   801044c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ee3:	6a 10                	push   $0x10
80104ee5:	ff 75 c4             	pushl  -0x3c(%ebp)
80104ee8:	57                   	push   %edi
80104ee9:	56                   	push   %esi
80104eea:	e8 11 cc ff ff       	call   80101b00 <writei>
80104eef:	83 c4 20             	add    $0x20,%esp
80104ef2:	83 f8 10             	cmp    $0x10,%eax
80104ef5:	0f 85 fb 00 00 00    	jne    80104ff6 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
80104efb:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104f00:	0f 84 aa 00 00 00    	je     80104fb0 <sys_unlink+0x190>
  iunlockput(dp);
80104f06:	83 ec 0c             	sub    $0xc,%esp
80104f09:	56                   	push   %esi
80104f0a:	e8 a1 ca ff ff       	call   801019b0 <iunlockput>
  ip->nlink--;
80104f0f:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104f14:	89 1c 24             	mov    %ebx,(%esp)
80104f17:	e8 04 c7 ff ff       	call   80101620 <iupdate>
  iunlockput(ip);
80104f1c:	89 1c 24             	mov    %ebx,(%esp)
80104f1f:	e8 8c ca ff ff       	call   801019b0 <iunlockput>
  end_op();
80104f24:	e8 87 de ff ff       	call   80102db0 <end_op>
  return 0;
80104f29:	83 c4 10             	add    $0x10,%esp
80104f2c:	31 c0                	xor    %eax,%eax
}
80104f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f31:	5b                   	pop    %ebx
80104f32:	5e                   	pop    %esi
80104f33:	5f                   	pop    %edi
80104f34:	5d                   	pop    %ebp
80104f35:	c3                   	ret    
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f40:	83 7b 18 20          	cmpl   $0x20,0x18(%ebx)
80104f44:	76 90                	jbe    80104ed6 <sys_unlink+0xb6>
80104f46:	ba 20 00 00 00       	mov    $0x20,%edx
80104f4b:	eb 0f                	jmp    80104f5c <sys_unlink+0x13c>
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
80104f50:	83 c2 10             	add    $0x10,%edx
80104f53:	39 53 18             	cmp    %edx,0x18(%ebx)
80104f56:	0f 86 7a ff ff ff    	jbe    80104ed6 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f5c:	6a 10                	push   $0x10
80104f5e:	52                   	push   %edx
80104f5f:	57                   	push   %edi
80104f60:	53                   	push   %ebx
80104f61:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80104f64:	e8 97 ca ff ff       	call   80101a00 <readi>
80104f69:	83 c4 10             	add    $0x10,%esp
80104f6c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80104f6f:	83 f8 10             	cmp    $0x10,%eax
80104f72:	75 75                	jne    80104fe9 <sys_unlink+0x1c9>
    if(de.inum != 0)
80104f74:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f79:	74 d5                	je     80104f50 <sys_unlink+0x130>
    iunlockput(ip);
80104f7b:	83 ec 0c             	sub    $0xc,%esp
80104f7e:	53                   	push   %ebx
80104f7f:	e8 2c ca ff ff       	call   801019b0 <iunlockput>
    goto bad;
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
80104f90:	83 ec 0c             	sub    $0xc,%esp
80104f93:	56                   	push   %esi
80104f94:	e8 17 ca ff ff       	call   801019b0 <iunlockput>
  end_op();
80104f99:	e8 12 de ff ff       	call   80102db0 <end_op>
  return -1;
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa6:	eb 86                	jmp    80104f2e <sys_unlink+0x10e>
80104fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop
    iupdate(dp);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80104fb3:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
    iupdate(dp);
80104fb8:	56                   	push   %esi
80104fb9:	e8 62 c6 ff ff       	call   80101620 <iupdate>
80104fbe:	83 c4 10             	add    $0x10,%esp
80104fc1:	e9 40 ff ff ff       	jmp    80104f06 <sys_unlink+0xe6>
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd5:	e9 54 ff ff ff       	jmp    80104f2e <sys_unlink+0x10e>
    end_op();
80104fda:	e8 d1 dd ff ff       	call   80102db0 <end_op>
    return -1;
80104fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe4:	e9 45 ff ff ff       	jmp    80104f2e <sys_unlink+0x10e>
      panic("isdirempty: readi");
80104fe9:	83 ec 0c             	sub    $0xc,%esp
80104fec:	68 18 76 10 80       	push   $0x80107618
80104ff1:	e8 9a b3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80104ff6:	83 ec 0c             	sub    $0xc,%esp
80104ff9:	68 2a 76 10 80       	push   $0x8010762a
80104ffe:	e8 8d b3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105003:	83 ec 0c             	sub    $0xc,%esp
80105006:	68 06 76 10 80       	push   $0x80107606
8010500b:	e8 80 b3 ff ff       	call   80100390 <panic>

80105010 <sys_open>:

int
sys_open(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105015:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105018:	53                   	push   %ebx
80105019:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010501c:	50                   	push   %eax
8010501d:	6a 00                	push   $0x0
8010501f:	e8 ec f7 ff ff       	call   80104810 <argstr>
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 9e 00 00 00    	js     801050cd <sys_open+0xbd>
8010502f:	83 ec 08             	sub    $0x8,%esp
80105032:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105035:	50                   	push   %eax
80105036:	6a 01                	push   $0x1
80105038:	e8 43 f7 ff ff       	call   80104780 <argint>
8010503d:	83 c4 10             	add    $0x10,%esp
80105040:	85 c0                	test   %eax,%eax
80105042:	0f 88 85 00 00 00    	js     801050cd <sys_open+0xbd>
    return -1;

  begin_op();
80105048:	e8 f3 dc ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010504d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105051:	0f 85 81 00 00 00    	jne    801050d8 <sys_open+0xc8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105057:	83 ec 0c             	sub    $0xc,%esp
8010505a:	ff 75 e0             	pushl  -0x20(%ebp)
8010505d:	e8 5e cf ff ff       	call   80101fc0 <namei>
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	89 c6                	mov    %eax,%esi
80105067:	85 c0                	test   %eax,%eax
80105069:	0f 84 86 00 00 00    	je     801050f5 <sys_open+0xe5>
      end_op();
      return -1;
    }
    ilock(ip);
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	50                   	push   %eax
80105073:	e8 58 c6 ff ff       	call   801016d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105078:	83 c4 10             	add    $0x10,%esp
8010507b:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80105080:	0f 84 ca 00 00 00    	je     80105150 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105086:	e8 65 bd ff ff       	call   80100df0 <filealloc>
8010508b:	89 c7                	mov    %eax,%edi
8010508d:	85 c0                	test   %eax,%eax
8010508f:	74 2b                	je     801050bc <sys_open+0xac>
    if(proc->ofile[fd] == 0){
80105091:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  for(fd = 0; fd < NOFILE; fd++){
80105098:	31 db                	xor    %ebx,%ebx
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(proc->ofile[fd] == 0){
801050a0:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801050a4:	85 c0                	test   %eax,%eax
801050a6:	74 60                	je     80105108 <sys_open+0xf8>
  for(fd = 0; fd < NOFILE; fd++){
801050a8:	83 c3 01             	add    $0x1,%ebx
801050ab:	83 fb 10             	cmp    $0x10,%ebx
801050ae:	75 f0                	jne    801050a0 <sys_open+0x90>
    if(f)
      fileclose(f);
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	57                   	push   %edi
801050b4:	e8 f7 bd ff ff       	call   80100eb0 <fileclose>
801050b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801050bc:	83 ec 0c             	sub    $0xc,%esp
801050bf:	56                   	push   %esi
801050c0:	e8 eb c8 ff ff       	call   801019b0 <iunlockput>
    end_op();
801050c5:	e8 e6 dc ff ff       	call   80102db0 <end_op>
    return -1;
801050ca:	83 c4 10             	add    $0x10,%esp
801050cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801050d2:	eb 6d                	jmp    80105141 <sys_open+0x131>
801050d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050de:	31 c9                	xor    %ecx,%ecx
801050e0:	ba 02 00 00 00       	mov    $0x2,%edx
801050e5:	6a 00                	push   $0x0
801050e7:	e8 04 f8 ff ff       	call   801048f0 <create>
    if(ip == 0){
801050ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801050ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801050f1:	85 c0                	test   %eax,%eax
801050f3:	75 91                	jne    80105086 <sys_open+0x76>
      end_op();
801050f5:	e8 b6 dc ff ff       	call   80102db0 <end_op>
      return -1;
801050fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801050ff:	eb 40                	jmp    80105141 <sys_open+0x131>
80105101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105108:	83 ec 0c             	sub    $0xc,%esp
      proc->ofile[fd] = f;
8010510b:	89 7c 9a 28          	mov    %edi,0x28(%edx,%ebx,4)
  iunlock(ip);
8010510f:	56                   	push   %esi
80105110:	e8 cb c6 ff ff       	call   801017e0 <iunlock>
  end_op();
80105115:	e8 96 dc ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
8010511a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105120:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105123:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105126:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105129:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010512b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105132:	f7 d0                	not    %eax
80105134:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105137:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010513a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010513d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105141:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105144:	89 d8                	mov    %ebx,%eax
80105146:	5b                   	pop    %ebx
80105147:	5e                   	pop    %esi
80105148:	5f                   	pop    %edi
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105150:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105153:	85 d2                	test   %edx,%edx
80105155:	0f 84 2b ff ff ff    	je     80105086 <sys_open+0x76>
8010515b:	e9 5c ff ff ff       	jmp    801050bc <sys_open+0xac>

80105160 <sys_mkdir>:

int
sys_mkdir(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105166:	e8 d5 db ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010516b:	83 ec 08             	sub    $0x8,%esp
8010516e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105171:	50                   	push   %eax
80105172:	6a 00                	push   $0x0
80105174:	e8 97 f6 ff ff       	call   80104810 <argstr>
80105179:	83 c4 10             	add    $0x10,%esp
8010517c:	85 c0                	test   %eax,%eax
8010517e:	78 30                	js     801051b0 <sys_mkdir+0x50>
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105186:	31 c9                	xor    %ecx,%ecx
80105188:	ba 01 00 00 00       	mov    $0x1,%edx
8010518d:	6a 00                	push   $0x0
8010518f:	e8 5c f7 ff ff       	call   801048f0 <create>
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	85 c0                	test   %eax,%eax
80105199:	74 15                	je     801051b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010519b:	83 ec 0c             	sub    $0xc,%esp
8010519e:	50                   	push   %eax
8010519f:	e8 0c c8 ff ff       	call   801019b0 <iunlockput>
  end_op();
801051a4:	e8 07 dc ff ff       	call   80102db0 <end_op>
  return 0;
801051a9:	83 c4 10             	add    $0x10,%esp
801051ac:	31 c0                	xor    %eax,%eax
}
801051ae:	c9                   	leave  
801051af:	c3                   	ret    
    end_op();
801051b0:	e8 fb db ff ff       	call   80102db0 <end_op>
    return -1;
801051b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051ba:	c9                   	leave  
801051bb:	c3                   	ret    
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051c0 <sys_mknod>:

int
sys_mknod(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801051c6:	e8 75 db ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801051cb:	83 ec 08             	sub    $0x8,%esp
801051ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051d1:	50                   	push   %eax
801051d2:	6a 00                	push   $0x0
801051d4:	e8 37 f6 ff ff       	call   80104810 <argstr>
801051d9:	83 c4 10             	add    $0x10,%esp
801051dc:	85 c0                	test   %eax,%eax
801051de:	78 60                	js     80105240 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801051e0:	83 ec 08             	sub    $0x8,%esp
801051e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e6:	50                   	push   %eax
801051e7:	6a 01                	push   $0x1
801051e9:	e8 92 f5 ff ff       	call   80104780 <argint>
  if((argstr(0, &path)) < 0 ||
801051ee:	83 c4 10             	add    $0x10,%esp
801051f1:	85 c0                	test   %eax,%eax
801051f3:	78 4b                	js     80105240 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801051f5:	83 ec 08             	sub    $0x8,%esp
801051f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fb:	50                   	push   %eax
801051fc:	6a 02                	push   $0x2
801051fe:	e8 7d f5 ff ff       	call   80104780 <argint>
     argint(1, &major) < 0 ||
80105203:	83 c4 10             	add    $0x10,%esp
80105206:	85 c0                	test   %eax,%eax
80105208:	78 36                	js     80105240 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010520a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010520e:	83 ec 0c             	sub    $0xc,%esp
80105211:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105215:	ba 03 00 00 00       	mov    $0x3,%edx
8010521a:	50                   	push   %eax
8010521b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010521e:	e8 cd f6 ff ff       	call   801048f0 <create>
     argint(2, &minor) < 0 ||
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	74 16                	je     80105240 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010522a:	83 ec 0c             	sub    $0xc,%esp
8010522d:	50                   	push   %eax
8010522e:	e8 7d c7 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105233:	e8 78 db ff ff       	call   80102db0 <end_op>
  return 0;
80105238:	83 c4 10             	add    $0x10,%esp
8010523b:	31 c0                	xor    %eax,%eax
}
8010523d:	c9                   	leave  
8010523e:	c3                   	ret    
8010523f:	90                   	nop
    end_op();
80105240:	e8 6b db ff ff       	call   80102db0 <end_op>
    return -1;
80105245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010524a:	c9                   	leave  
8010524b:	c3                   	ret    
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_chdir>:

int
sys_chdir(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	53                   	push   %ebx
80105254:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105257:	e8 e4 da ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010525c:	83 ec 08             	sub    $0x8,%esp
8010525f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105262:	50                   	push   %eax
80105263:	6a 00                	push   $0x0
80105265:	e8 a6 f5 ff ff       	call   80104810 <argstr>
8010526a:	83 c4 10             	add    $0x10,%esp
8010526d:	85 c0                	test   %eax,%eax
8010526f:	78 7f                	js     801052f0 <sys_chdir+0xa0>
80105271:	83 ec 0c             	sub    $0xc,%esp
80105274:	ff 75 f4             	pushl  -0xc(%ebp)
80105277:	e8 44 cd ff ff       	call   80101fc0 <namei>
8010527c:	83 c4 10             	add    $0x10,%esp
8010527f:	89 c3                	mov    %eax,%ebx
80105281:	85 c0                	test   %eax,%eax
80105283:	74 6b                	je     801052f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105285:	83 ec 0c             	sub    $0xc,%esp
80105288:	50                   	push   %eax
80105289:	e8 42 c4 ff ff       	call   801016d0 <ilock>
  if(ip->type != T_DIR){
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80105296:	75 38                	jne    801052d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	53                   	push   %ebx
8010529c:	e8 3f c5 ff ff       	call   801017e0 <iunlock>
  iput(proc->cwd);
801052a1:	58                   	pop    %eax
801052a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a8:	ff 70 68             	pushl  0x68(%eax)
801052ab:	e8 90 c5 ff ff       	call   80101840 <iput>
  end_op();
801052b0:	e8 fb da ff ff       	call   80102db0 <end_op>
  proc->cwd = ip;
801052b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
801052bb:	83 c4 10             	add    $0x10,%esp
  proc->cwd = ip;
801052be:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
801052c1:	31 c0                	xor    %eax,%eax
}
801052c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052c6:	c9                   	leave  
801052c7:	c3                   	ret    
801052c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cf:	90                   	nop
    iunlockput(ip);
801052d0:	83 ec 0c             	sub    $0xc,%esp
801052d3:	53                   	push   %ebx
801052d4:	e8 d7 c6 ff ff       	call   801019b0 <iunlockput>
    end_op();
801052d9:	e8 d2 da ff ff       	call   80102db0 <end_op>
    return -1;
801052de:	83 c4 10             	add    $0x10,%esp
801052e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e6:	eb db                	jmp    801052c3 <sys_chdir+0x73>
801052e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ef:	90                   	nop
    end_op();
801052f0:	e8 bb da ff ff       	call   80102db0 <end_op>
    return -1;
801052f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fa:	eb c7                	jmp    801052c3 <sys_chdir+0x73>
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_exec>:

int
sys_exec(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105305:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010530b:	53                   	push   %ebx
8010530c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105312:	50                   	push   %eax
80105313:	6a 00                	push   $0x0
80105315:	e8 f6 f4 ff ff       	call   80104810 <argstr>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	0f 88 87 00 00 00    	js     801053ac <sys_exec+0xac>
80105325:	83 ec 08             	sub    $0x8,%esp
80105328:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010532e:	50                   	push   %eax
8010532f:	6a 01                	push   $0x1
80105331:	e8 4a f4 ff ff       	call   80104780 <argint>
80105336:	83 c4 10             	add    $0x10,%esp
80105339:	85 c0                	test   %eax,%eax
8010533b:	78 6f                	js     801053ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010533d:	83 ec 04             	sub    $0x4,%esp
80105340:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105346:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105348:	68 80 00 00 00       	push   $0x80
8010534d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105353:	6a 00                	push   $0x0
80105355:	50                   	push   %eax
80105356:	e8 65 f1 ff ff       	call   801044c0 <memset>
8010535b:	83 c4 10             	add    $0x10,%esp
8010535e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105360:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105366:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
8010536d:	83 ec 08             	sub    $0x8,%esp
80105370:	57                   	push   %edi
80105371:	01 f0                	add    %esi,%eax
80105373:	50                   	push   %eax
80105374:	e8 87 f3 ff ff       	call   80104700 <fetchint>
80105379:	83 c4 10             	add    $0x10,%esp
8010537c:	85 c0                	test   %eax,%eax
8010537e:	78 2c                	js     801053ac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105380:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105386:	85 c0                	test   %eax,%eax
80105388:	74 36                	je     801053c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010538a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105390:	83 ec 08             	sub    $0x8,%esp
80105393:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105396:	52                   	push   %edx
80105397:	50                   	push   %eax
80105398:	e8 93 f3 ff ff       	call   80104730 <fetchstr>
8010539d:	83 c4 10             	add    $0x10,%esp
801053a0:	85 c0                	test   %eax,%eax
801053a2:	78 08                	js     801053ac <sys_exec+0xac>
  for(i=0;; i++){
801053a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801053a7:	83 fb 20             	cmp    $0x20,%ebx
801053aa:	75 b4                	jne    80105360 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801053ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801053af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b4:	5b                   	pop    %ebx
801053b5:	5e                   	pop    %esi
801053b6:	5f                   	pop    %edi
801053b7:	5d                   	pop    %ebp
801053b8:	c3                   	ret    
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801053c0:	83 ec 08             	sub    $0x8,%esp
801053c3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801053c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801053d0:	00 00 00 00 
  return exec(path, argv);
801053d4:	50                   	push   %eax
801053d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801053db:	e8 a0 b6 ff ff       	call   80100a80 <exec>
801053e0:	83 c4 10             	add    $0x10,%esp
}
801053e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053e6:	5b                   	pop    %ebx
801053e7:	5e                   	pop    %esi
801053e8:	5f                   	pop    %edi
801053e9:	5d                   	pop    %ebp
801053ea:	c3                   	ret    
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop

801053f0 <sys_pipe>:

int
sys_pipe(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801053f8:	53                   	push   %ebx
801053f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053fc:	6a 08                	push   $0x8
801053fe:	50                   	push   %eax
801053ff:	6a 00                	push   $0x0
80105401:	e8 ba f3 ff ff       	call   801047c0 <argptr>
80105406:	83 c4 10             	add    $0x10,%esp
80105409:	85 c0                	test   %eax,%eax
8010540b:	78 48                	js     80105455 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010540d:	83 ec 08             	sub    $0x8,%esp
80105410:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105413:	50                   	push   %eax
80105414:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105417:	50                   	push   %eax
80105418:	e8 d3 e0 ff ff       	call   801034f0 <pipealloc>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	78 31                	js     80105455 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105424:	8b 5d e0             	mov    -0x20(%ebp),%ebx
    if(proc->ofile[fd] == 0){
80105427:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
  for(fd = 0; fd < NOFILE; fd++){
8010542e:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
80105430:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105434:	85 d2                	test   %edx,%edx
80105436:	74 28                	je     80105460 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105438:	83 c0 01             	add    $0x1,%eax
8010543b:	83 f8 10             	cmp    $0x10,%eax
8010543e:	75 f0                	jne    80105430 <sys_pipe+0x40>
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	53                   	push   %ebx
80105444:	e8 67 ba ff ff       	call   80100eb0 <fileclose>
    fileclose(wf);
80105449:	58                   	pop    %eax
8010544a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010544d:	e8 5e ba ff ff       	call   80100eb0 <fileclose>
    return -1;
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545a:	eb 45                	jmp    801054a1 <sys_pipe+0xb1>
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      proc->ofile[fd] = f;
80105460:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105466:	31 d2                	xor    %edx,%edx
      proc->ofile[fd] = f;
80105468:	89 5e 28             	mov    %ebx,0x28(%esi)
  for(fd = 0; fd < NOFILE; fd++){
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop
    if(proc->ofile[fd] == 0){
80105470:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80105475:	74 19                	je     80105490 <sys_pipe+0xa0>
  for(fd = 0; fd < NOFILE; fd++){
80105477:	83 c2 01             	add    $0x1,%edx
8010547a:	83 fa 10             	cmp    $0x10,%edx
8010547d:	75 f1                	jne    80105470 <sys_pipe+0x80>
      proc->ofile[fd0] = 0;
8010547f:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
80105486:	eb b8                	jmp    80105440 <sys_pipe+0x50>
80105488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548f:	90                   	nop
      proc->ofile[fd] = f;
80105490:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
  }
  fd[0] = fd0;
80105494:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105497:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105499:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010549c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010549f:	31 c0                	xor    %eax,%eax
}
801054a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054a4:	5b                   	pop    %ebx
801054a5:	5e                   	pop    %esi
801054a6:	5f                   	pop    %edi
801054a7:	5d                   	pop    %ebp
801054a8:	c3                   	ret    
801054a9:	66 90                	xchg   %ax,%ax
801054ab:	66 90                	xchg   %ax,%ax
801054ad:	66 90                	xchg   %ax,%ax
801054af:	90                   	nop

801054b0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801054b0:	e9 7b e6 ff ff       	jmp    80103b30 <fork>
801054b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054c0 <sys_exit>:
}

int
sys_exit(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801054c6:	e8 e5 e8 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
801054cb:	31 c0                	xor    %eax,%eax
801054cd:	c9                   	leave  
801054ce:	c3                   	ret    
801054cf:	90                   	nop

801054d0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801054d0:	e9 2b eb ff ff       	jmp    80104000 <wait>
801054d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_kill>:
}

int
sys_kill(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801054e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e9:	50                   	push   %eax
801054ea:	6a 00                	push   $0x0
801054ec:	e8 8f f2 ff ff       	call   80104780 <argint>
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	85 c0                	test   %eax,%eax
801054f6:	78 18                	js     80105510 <sys_kill+0x30>
    return -1;
  return kill(pid);
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	ff 75 f4             	pushl  -0xc(%ebp)
801054fe:	e8 3d ec ff ff       	call   80104140 <kill>
80105503:	83 c4 10             	add    $0x10,%esp
}
80105506:	c9                   	leave  
80105507:	c3                   	ret    
80105508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
80105510:	c9                   	leave  
    return -1;
80105511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105516:	c3                   	ret    
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax

80105520 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105520:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105526:	8b 40 10             	mov    0x10(%eax),%eax
}
80105529:	c3                   	ret    
8010552a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105530 <sys_sbrk>:

int
sys_sbrk(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105534:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105537:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010553a:	50                   	push   %eax
8010553b:	6a 00                	push   $0x0
8010553d:	e8 3e f2 ff ff       	call   80104780 <argint>
80105542:	83 c4 10             	add    $0x10,%esp
80105545:	85 c0                	test   %eax,%eax
80105547:	78 27                	js     80105570 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105549:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
8010554f:	83 ec 0c             	sub    $0xc,%esp
  addr = proc->sz;
80105552:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105554:	ff 75 f4             	pushl  -0xc(%ebp)
80105557:	e8 64 e5 ff ff       	call   80103ac0 <growproc>
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	85 c0                	test   %eax,%eax
80105561:	78 0d                	js     80105570 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105563:	89 d8                	mov    %ebx,%eax
80105565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105568:	c9                   	leave  
80105569:	c3                   	ret    
8010556a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105570:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105575:	eb ec                	jmp    80105563 <sys_sbrk+0x33>
80105577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557e:	66 90                	xchg   %ax,%ax

80105580 <sys_sleep>:

int
sys_sleep(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105584:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105587:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010558a:	50                   	push   %eax
8010558b:	6a 00                	push   $0x0
8010558d:	e8 ee f1 ff ff       	call   80104780 <argint>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	0f 88 8a 00 00 00    	js     80105627 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	68 20 38 11 80       	push   $0x80113820
801055a5:	e8 f6 ec ff ff       	call   801042a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801055ad:	8b 1d 60 40 11 80    	mov    0x80114060,%ebx
  while(ticks - ticks0 < n){
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 d2                	test   %edx,%edx
801055b8:	75 27                	jne    801055e1 <sys_sleep+0x61>
801055ba:	eb 54                	jmp    80105610 <sys_sleep+0x90>
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801055c0:	83 ec 08             	sub    $0x8,%esp
801055c3:	68 20 38 11 80       	push   $0x80113820
801055c8:	68 60 40 11 80       	push   $0x80114060
801055cd:	e8 6e e9 ff ff       	call   80103f40 <sleep>
  while(ticks - ticks0 < n){
801055d2:	a1 60 40 11 80       	mov    0x80114060,%eax
801055d7:	83 c4 10             	add    $0x10,%esp
801055da:	29 d8                	sub    %ebx,%eax
801055dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801055df:	73 2f                	jae    80105610 <sys_sleep+0x90>
    if(proc->killed){
801055e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e7:	8b 40 24             	mov    0x24(%eax),%eax
801055ea:	85 c0                	test   %eax,%eax
801055ec:	74 d2                	je     801055c0 <sys_sleep+0x40>
      release(&tickslock);
801055ee:	83 ec 0c             	sub    $0xc,%esp
801055f1:	68 20 38 11 80       	push   $0x80113820
801055f6:	e8 75 ee ff ff       	call   80104470 <release>
      return -1;
801055fb:	83 c4 10             	add    $0x10,%esp
801055fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105606:	c9                   	leave  
80105607:	c3                   	ret    
80105608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560f:	90                   	nop
  release(&tickslock);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	68 20 38 11 80       	push   $0x80113820
80105618:	e8 53 ee ff ff       	call   80104470 <release>
  return 0;
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	31 c0                	xor    %eax,%eax
}
80105622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105625:	c9                   	leave  
80105626:	c3                   	ret    
    return -1;
80105627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562c:	eb f4                	jmp    80105622 <sys_sleep+0xa2>
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	53                   	push   %ebx
80105634:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105637:	68 20 38 11 80       	push   $0x80113820
8010563c:	e8 5f ec ff ff       	call   801042a0 <acquire>
  xticks = ticks;
80105641:	8b 1d 60 40 11 80    	mov    0x80114060,%ebx
  release(&tickslock);
80105647:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
8010564e:	e8 1d ee ff ff       	call   80104470 <release>
  return xticks;
}
80105653:	89 d8                	mov    %ebx,%eax
80105655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105658:	c9                   	leave  
80105659:	c3                   	ret    
8010565a:	66 90                	xchg   %ax,%ax
8010565c:	66 90                	xchg   %ax,%ax
8010565e:	66 90                	xchg   %ax,%ax

80105660 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105660:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105661:	b8 34 00 00 00       	mov    $0x34,%eax
80105666:	ba 43 00 00 00       	mov    $0x43,%edx
8010566b:	89 e5                	mov    %esp,%ebp
8010566d:	83 ec 14             	sub    $0x14,%esp
80105670:	ee                   	out    %al,(%dx)
80105671:	ba 40 00 00 00       	mov    $0x40,%edx
80105676:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
8010567b:	ee                   	out    %al,(%dx)
8010567c:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105681:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105682:	6a 00                	push   $0x0
80105684:	e8 97 dd ff ff       	call   80103420 <picenable>
}
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	c9                   	leave  
8010568d:	c3                   	ret    

8010568e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010568e:	1e                   	push   %ds
  pushl %es
8010568f:	06                   	push   %es
  pushl %fs
80105690:	0f a0                	push   %fs
  pushl %gs
80105692:	0f a8                	push   %gs
  pushal
80105694:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105695:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105699:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010569b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010569d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801056a1:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801056a3:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801056a5:	54                   	push   %esp
  call trap
801056a6:	e8 c5 00 00 00       	call   80105770 <trap>
  addl $4, %esp
801056ab:	83 c4 04             	add    $0x4,%esp

801056ae <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801056ae:	61                   	popa   
  popl %gs
801056af:	0f a9                	pop    %gs
  popl %fs
801056b1:	0f a1                	pop    %fs
  popl %es
801056b3:	07                   	pop    %es
  popl %ds
801056b4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801056b5:	83 c4 08             	add    $0x8,%esp
  iret
801056b8:	cf                   	iret   
801056b9:	66 90                	xchg   %ax,%ax
801056bb:	66 90                	xchg   %ax,%ax
801056bd:	66 90                	xchg   %ax,%ax
801056bf:	90                   	nop

801056c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056c0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801056c1:	31 c0                	xor    %eax,%eax
{
801056c3:	89 e5                	mov    %esp,%ebp
801056c5:	83 ec 08             	sub    $0x8,%esp
801056c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801056d0:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
801056d7:	c7 04 c5 62 38 11 80 	movl   $0x8e000008,-0x7feec79e(,%eax,8)
801056de:	08 00 00 8e 
801056e2:	66 89 14 c5 60 38 11 	mov    %dx,-0x7feec7a0(,%eax,8)
801056e9:	80 
801056ea:	c1 ea 10             	shr    $0x10,%edx
801056ed:	66 89 14 c5 66 38 11 	mov    %dx,-0x7feec79a(,%eax,8)
801056f4:	80 
  for(i = 0; i < 256; i++)
801056f5:	83 c0 01             	add    $0x1,%eax
801056f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801056fd:	75 d1                	jne    801056d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801056ff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105702:	a1 0c a1 10 80       	mov    0x8010a10c,%eax
80105707:	c7 05 62 3a 11 80 08 	movl   $0xef000008,0x80113a62
8010570e:	00 00 ef 
  initlock(&tickslock, "time");
80105711:	68 39 76 10 80       	push   $0x80107639
80105716:	68 20 38 11 80       	push   $0x80113820
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010571b:	66 a3 60 3a 11 80    	mov    %ax,0x80113a60
80105721:	c1 e8 10             	shr    $0x10,%eax
80105724:	66 a3 66 3a 11 80    	mov    %ax,0x80113a66
  initlock(&tickslock, "time");
8010572a:	e8 51 eb ff ff       	call   80104280 <initlock>
}
8010572f:	83 c4 10             	add    $0x10,%esp
80105732:	c9                   	leave  
80105733:	c3                   	ret    
80105734:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010573f:	90                   	nop

80105740 <idtinit>:

void
idtinit(void)
{
80105740:	55                   	push   %ebp
  pd[0] = size-1;
80105741:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105746:	89 e5                	mov    %esp,%ebp
80105748:	83 ec 10             	sub    $0x10,%esp
8010574b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010574f:	b8 60 38 11 80       	mov    $0x80113860,%eax
80105754:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105758:	c1 e8 10             	shr    $0x10,%eax
8010575b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010575f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105762:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576e:	66 90                	xchg   %ax,%ax

80105770 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
80105775:	53                   	push   %ebx
80105776:	83 ec 0c             	sub    $0xc,%esp
80105779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010577c:	8b 43 30             	mov    0x30(%ebx),%eax
8010577f:	83 f8 40             	cmp    $0x40,%eax
80105782:	0f 84 f8 00 00 00    	je     80105880 <trap+0x110>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105788:	83 e8 20             	sub    $0x20,%eax
8010578b:	83 f8 1f             	cmp    $0x1f,%eax
8010578e:	77 68                	ja     801057f8 <trap+0x88>
80105790:	ff 24 85 e0 76 10 80 	jmp    *-0x7fef8920(,%eax,4)
80105797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579e:	66 90                	xchg   %ax,%ax
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
801057a0:	e8 ab d0 ff ff       	call   80102850 <cpunum>
801057a5:	85 c0                	test   %eax,%eax
801057a7:	0f 84 db 01 00 00    	je     80105988 <trap+0x218>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
801057ad:	e8 3e d1 ff ff       	call   801028f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801057b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057b8:	85 c0                	test   %eax,%eax
801057ba:	74 2d                	je     801057e9 <trap+0x79>
801057bc:	8b 50 24             	mov    0x24(%eax),%edx
801057bf:	85 d2                	test   %edx,%edx
801057c1:	0f 85 86 00 00 00    	jne    8010584d <trap+0xdd>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801057c7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801057cb:	0f 84 8f 01 00 00    	je     80105960 <trap+0x1f0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801057d1:	8b 40 24             	mov    0x24(%eax),%eax
801057d4:	85 c0                	test   %eax,%eax
801057d6:	74 11                	je     801057e9 <trap+0x79>
801057d8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057dc:	83 e0 03             	and    $0x3,%eax
801057df:	66 83 f8 03          	cmp    $0x3,%ax
801057e3:	0f 84 c1 00 00 00    	je     801058aa <trap+0x13a>
    exit();
}
801057e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057ec:	5b                   	pop    %ebx
801057ed:	5e                   	pop    %esi
801057ee:	5f                   	pop    %edi
801057ef:	5d                   	pop    %ebp
801057f0:	c3                   	ret    
801057f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc == 0 || (tf->cs&3) == 0){
801057f8:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801057ff:	8b 73 38             	mov    0x38(%ebx),%esi
80105802:	85 c9                	test   %ecx,%ecx
80105804:	0f 84 b2 01 00 00    	je     801059bc <trap+0x24c>
8010580a:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010580e:	0f 84 a8 01 00 00    	je     801059bc <trap+0x24c>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105814:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105817:	e8 34 d0 ff ff       	call   80102850 <cpunum>
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
8010581c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105823:	57                   	push   %edi
80105824:	56                   	push   %esi
80105825:	50                   	push   %eax
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105826:	8d 42 6c             	lea    0x6c(%edx),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105829:	ff 73 34             	pushl  0x34(%ebx)
8010582c:	ff 73 30             	pushl  0x30(%ebx)
8010582f:	50                   	push   %eax
80105830:	ff 72 10             	pushl  0x10(%edx)
80105833:	68 9c 76 10 80       	push   $0x8010769c
80105838:	e8 73 ae ff ff       	call   801006b0 <cprintf>
    proc->killed = 1;
8010583d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105843:	83 c4 20             	add    $0x20,%esp
80105846:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010584d:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105851:	83 e2 03             	and    $0x3,%edx
80105854:	66 83 fa 03          	cmp    $0x3,%dx
80105858:	0f 85 69 ff ff ff    	jne    801057c7 <trap+0x57>
    exit();
8010585e:	e8 4d e5 ff ff       	call   80103db0 <exit>
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105863:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105869:	85 c0                	test   %eax,%eax
8010586b:	0f 85 56 ff ff ff    	jne    801057c7 <trap+0x57>
80105871:	e9 73 ff ff ff       	jmp    801057e9 <trap+0x79>
80105876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587d:	8d 76 00             	lea    0x0(%esi),%esi
    if(proc->killed)
80105880:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105886:	8b 70 24             	mov    0x24(%eax),%esi
80105889:	85 f6                	test   %esi,%esi
8010588b:	0f 85 b7 00 00 00    	jne    80105948 <trap+0x1d8>
    proc->tf = tf;
80105891:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105894:	e8 e7 ef ff ff       	call   80104880 <syscall>
    if(proc->killed)
80105899:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010589f:	8b 58 24             	mov    0x24(%eax),%ebx
801058a2:	85 db                	test   %ebx,%ebx
801058a4:	0f 84 3f ff ff ff    	je     801057e9 <trap+0x79>
}
801058aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058ad:	5b                   	pop    %ebx
801058ae:	5e                   	pop    %esi
801058af:	5f                   	pop    %edi
801058b0:	5d                   	pop    %ebp
      exit();
801058b1:	e9 fa e4 ff ff       	jmp    80103db0 <exit>
801058b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
    ideintr();
801058c0:	e8 ab c8 ff ff       	call   80102170 <ideintr>
    lapiceoi();
801058c5:	e8 26 d0 ff ff       	call   801028f0 <lapiceoi>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801058ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d0:	85 c0                	test   %eax,%eax
801058d2:	0f 85 e4 fe ff ff    	jne    801057bc <trap+0x4c>
801058d8:	e9 0c ff ff ff       	jmp    801057e9 <trap+0x79>
801058dd:	8d 76 00             	lea    0x0(%esi),%esi
    kbdintr();
801058e0:	e8 4b ce ff ff       	call   80102730 <kbdintr>
    lapiceoi();
801058e5:	e8 06 d0 ff ff       	call   801028f0 <lapiceoi>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801058ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058f0:	85 c0                	test   %eax,%eax
801058f2:	0f 85 c4 fe ff ff    	jne    801057bc <trap+0x4c>
801058f8:	e9 ec fe ff ff       	jmp    801057e9 <trap+0x79>
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
    uartintr();
80105900:	e8 5b 02 00 00       	call   80105b60 <uartintr>
80105905:	e9 a3 fe ff ff       	jmp    801057ad <trap+0x3d>
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105910:	8b 7b 38             	mov    0x38(%ebx),%edi
80105913:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105917:	e8 34 cf ff ff       	call   80102850 <cpunum>
8010591c:	57                   	push   %edi
8010591d:	56                   	push   %esi
8010591e:	50                   	push   %eax
8010591f:	68 44 76 10 80       	push   $0x80107644
80105924:	e8 87 ad ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105929:	e8 c2 cf ff ff       	call   801028f0 <lapiceoi>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010592e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105934:	83 c4 10             	add    $0x10,%esp
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105937:	85 c0                	test   %eax,%eax
80105939:	0f 85 7d fe ff ff    	jne    801057bc <trap+0x4c>
8010593f:	e9 a5 fe ff ff       	jmp    801057e9 <trap+0x79>
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105948:	e8 63 e4 ff ff       	call   80103db0 <exit>
8010594d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105953:	e9 39 ff ff ff       	jmp    80105891 <trap+0x121>
80105958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105960:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105964:	0f 85 67 fe ff ff    	jne    801057d1 <trap+0x61>
    yield();
8010596a:	e8 91 e5 ff ff       	call   80103f00 <yield>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010596f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105975:	85 c0                	test   %eax,%eax
80105977:	0f 85 54 fe ff ff    	jne    801057d1 <trap+0x61>
8010597d:	e9 67 fe ff ff       	jmp    801057e9 <trap+0x79>
80105982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	68 20 38 11 80       	push   $0x80113820
80105990:	e8 0b e9 ff ff       	call   801042a0 <acquire>
      wakeup(&ticks);
80105995:	c7 04 24 60 40 11 80 	movl   $0x80114060,(%esp)
      ticks++;
8010599c:	83 05 60 40 11 80 01 	addl   $0x1,0x80114060
      wakeup(&ticks);
801059a3:	e8 38 e7 ff ff       	call   801040e0 <wakeup>
      release(&tickslock);
801059a8:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
801059af:	e8 bc ea ff ff       	call   80104470 <release>
801059b4:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801059b7:	e9 f1 fd ff ff       	jmp    801057ad <trap+0x3d>
801059bc:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059bf:	e8 8c ce ff ff       	call   80102850 <cpunum>
801059c4:	83 ec 0c             	sub    $0xc,%esp
801059c7:	57                   	push   %edi
801059c8:	56                   	push   %esi
801059c9:	50                   	push   %eax
801059ca:	ff 73 30             	pushl  0x30(%ebx)
801059cd:	68 68 76 10 80       	push   $0x80107668
801059d2:	e8 d9 ac ff ff       	call   801006b0 <cprintf>
      panic("trap");
801059d7:	83 c4 14             	add    $0x14,%esp
801059da:	68 3e 76 10 80       	push   $0x8010763e
801059df:	e8 ac a9 ff ff       	call   80100390 <panic>
801059e4:	66 90                	xchg   %ax,%ax
801059e6:	66 90                	xchg   %ax,%ax
801059e8:	66 90                	xchg   %ax,%ax
801059ea:	66 90                	xchg   %ax,%ax
801059ec:	66 90                	xchg   %ax,%ax
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059f0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
801059f5:	85 c0                	test   %eax,%eax
801059f7:	74 17                	je     80105a10 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059f9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059fe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801059ff:	a8 01                	test   $0x1,%al
80105a01:	74 0d                	je     80105a10 <uartgetc+0x20>
80105a03:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a08:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a09:	0f b6 c0             	movzbl %al,%eax
80105a0c:	c3                   	ret    
80105a0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a15:	c3                   	ret    
80105a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi

80105a20 <uartputc.part.0>:
uartputc(int c)
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	89 c7                	mov    %eax,%edi
80105a26:	56                   	push   %esi
80105a27:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a2c:	53                   	push   %ebx
80105a2d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a32:	83 ec 0c             	sub    $0xc,%esp
80105a35:	eb 1b                	jmp    80105a52 <uartputc.part.0+0x32>
80105a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	6a 0a                	push   $0xa
80105a45:	e8 c6 ce ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	83 eb 01             	sub    $0x1,%ebx
80105a50:	74 07                	je     80105a59 <uartputc.part.0+0x39>
80105a52:	89 f2                	mov    %esi,%edx
80105a54:	ec                   	in     (%dx),%al
80105a55:	a8 20                	test   $0x20,%al
80105a57:	74 e7                	je     80105a40 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a5e:	89 f8                	mov    %edi,%eax
80105a60:	ee                   	out    %al,(%dx)
}
80105a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a64:	5b                   	pop    %ebx
80105a65:	5e                   	pop    %esi
80105a66:	5f                   	pop    %edi
80105a67:	5d                   	pop    %ebp
80105a68:	c3                   	ret    
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a70 <uartinit>:
{
80105a70:	55                   	push   %ebp
80105a71:	31 c9                	xor    %ecx,%ecx
80105a73:	89 c8                	mov    %ecx,%eax
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	57                   	push   %edi
80105a78:	56                   	push   %esi
80105a79:	53                   	push   %ebx
80105a7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105a7f:	89 da                	mov    %ebx,%edx
80105a81:	83 ec 0c             	sub    $0xc,%esp
80105a84:	ee                   	out    %al,(%dx)
80105a85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105a8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a8f:	89 fa                	mov    %edi,%edx
80105a91:	ee                   	out    %al,(%dx)
80105a92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a9c:	ee                   	out    %al,(%dx)
80105a9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105aa2:	89 c8                	mov    %ecx,%eax
80105aa4:	89 f2                	mov    %esi,%edx
80105aa6:	ee                   	out    %al,(%dx)
80105aa7:	b8 03 00 00 00       	mov    $0x3,%eax
80105aac:	89 fa                	mov    %edi,%edx
80105aae:	ee                   	out    %al,(%dx)
80105aaf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ab4:	89 c8                	mov    %ecx,%eax
80105ab6:	ee                   	out    %al,(%dx)
80105ab7:	b8 01 00 00 00       	mov    $0x1,%eax
80105abc:	89 f2                	mov    %esi,%edx
80105abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105abf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ac4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ac5:	3c ff                	cmp    $0xff,%al
80105ac7:	74 5e                	je     80105b27 <uartinit+0xb7>
  uart = 1;
80105ac9:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105ad0:	00 00 00 
80105ad3:	89 da                	mov    %ebx,%edx
80105ad5:	ec                   	in     (%dx),%al
80105ad6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105adb:	ec                   	in     (%dx),%al
  picenable(IRQ_COM1);
80105adc:	83 ec 0c             	sub    $0xc,%esp
  ioapicenable(IRQ_COM1, 0);
80105adf:	be 76 00 00 00       	mov    $0x76,%esi
  picenable(IRQ_COM1);
80105ae4:	6a 04                	push   $0x4
80105ae6:	e8 35 d9 ff ff       	call   80103420 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105aeb:	59                   	pop    %ecx
80105aec:	5b                   	pop    %ebx
80105aed:	6a 00                	push   $0x0
80105aef:	6a 04                	push   $0x4
  for(p="xv6...\n"; *p; p++)
80105af1:	bb 60 77 10 80       	mov    $0x80107760,%ebx
  ioapicenable(IRQ_COM1, 0);
80105af6:	e8 d5 c8 ff ff       	call   801023d0 <ioapicenable>
80105afb:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105afe:	b8 78 00 00 00       	mov    $0x78,%eax
80105b03:	eb 07                	jmp    80105b0c <uartinit+0x9c>
80105b05:	8d 76 00             	lea    0x0(%esi),%esi
80105b08:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105b0c:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105b12:	85 d2                	test   %edx,%edx
80105b14:	74 08                	je     80105b1e <uartinit+0xae>
    uartputc(*p);
80105b16:	0f be c0             	movsbl %al,%eax
80105b19:	e8 02 ff ff ff       	call   80105a20 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105b1e:	89 f0                	mov    %esi,%eax
80105b20:	83 c3 01             	add    $0x1,%ebx
80105b23:	84 c0                	test   %al,%al
80105b25:	75 e1                	jne    80105b08 <uartinit+0x98>
}
80105b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b2a:	5b                   	pop    %ebx
80105b2b:	5e                   	pop    %esi
80105b2c:	5f                   	pop    %edi
80105b2d:	5d                   	pop    %ebp
80105b2e:	c3                   	ret    
80105b2f:	90                   	nop

80105b30 <uartputc>:
{
80105b30:	55                   	push   %ebp
  if(!uart)
80105b31:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80105b37:	89 e5                	mov    %esp,%ebp
80105b39:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105b3c:	85 d2                	test   %edx,%edx
80105b3e:	74 10                	je     80105b50 <uartputc+0x20>
}
80105b40:	5d                   	pop    %ebp
80105b41:	e9 da fe ff ff       	jmp    80105a20 <uartputc.part.0>
80105b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
80105b50:	5d                   	pop    %ebp
80105b51:	c3                   	ret    
80105b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b60 <uartintr>:

void
uartintr(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b66:	68 f0 59 10 80       	push   $0x801059f0
80105b6b:	e8 f0 ac ff ff       	call   80100860 <consoleintr>
}
80105b70:	83 c4 10             	add    $0x10,%esp
80105b73:	c9                   	leave  
80105b74:	c3                   	ret    

80105b75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $0
80105b77:	6a 00                	push   $0x0
  jmp alltraps
80105b79:	e9 10 fb ff ff       	jmp    8010568e <alltraps>

80105b7e <vector1>:
.globl vector1
vector1:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $1
80105b80:	6a 01                	push   $0x1
  jmp alltraps
80105b82:	e9 07 fb ff ff       	jmp    8010568e <alltraps>

80105b87 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $2
80105b89:	6a 02                	push   $0x2
  jmp alltraps
80105b8b:	e9 fe fa ff ff       	jmp    8010568e <alltraps>

80105b90 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $3
80105b92:	6a 03                	push   $0x3
  jmp alltraps
80105b94:	e9 f5 fa ff ff       	jmp    8010568e <alltraps>

80105b99 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $4
80105b9b:	6a 04                	push   $0x4
  jmp alltraps
80105b9d:	e9 ec fa ff ff       	jmp    8010568e <alltraps>

80105ba2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $5
80105ba4:	6a 05                	push   $0x5
  jmp alltraps
80105ba6:	e9 e3 fa ff ff       	jmp    8010568e <alltraps>

80105bab <vector6>:
.globl vector6
vector6:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $6
80105bad:	6a 06                	push   $0x6
  jmp alltraps
80105baf:	e9 da fa ff ff       	jmp    8010568e <alltraps>

80105bb4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $7
80105bb6:	6a 07                	push   $0x7
  jmp alltraps
80105bb8:	e9 d1 fa ff ff       	jmp    8010568e <alltraps>

80105bbd <vector8>:
.globl vector8
vector8:
  pushl $8
80105bbd:	6a 08                	push   $0x8
  jmp alltraps
80105bbf:	e9 ca fa ff ff       	jmp    8010568e <alltraps>

80105bc4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bc4:	6a 00                	push   $0x0
  pushl $9
80105bc6:	6a 09                	push   $0x9
  jmp alltraps
80105bc8:	e9 c1 fa ff ff       	jmp    8010568e <alltraps>

80105bcd <vector10>:
.globl vector10
vector10:
  pushl $10
80105bcd:	6a 0a                	push   $0xa
  jmp alltraps
80105bcf:	e9 ba fa ff ff       	jmp    8010568e <alltraps>

80105bd4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bd4:	6a 0b                	push   $0xb
  jmp alltraps
80105bd6:	e9 b3 fa ff ff       	jmp    8010568e <alltraps>

80105bdb <vector12>:
.globl vector12
vector12:
  pushl $12
80105bdb:	6a 0c                	push   $0xc
  jmp alltraps
80105bdd:	e9 ac fa ff ff       	jmp    8010568e <alltraps>

80105be2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105be2:	6a 0d                	push   $0xd
  jmp alltraps
80105be4:	e9 a5 fa ff ff       	jmp    8010568e <alltraps>

80105be9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105be9:	6a 0e                	push   $0xe
  jmp alltraps
80105beb:	e9 9e fa ff ff       	jmp    8010568e <alltraps>

80105bf0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105bf0:	6a 00                	push   $0x0
  pushl $15
80105bf2:	6a 0f                	push   $0xf
  jmp alltraps
80105bf4:	e9 95 fa ff ff       	jmp    8010568e <alltraps>

80105bf9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $16
80105bfb:	6a 10                	push   $0x10
  jmp alltraps
80105bfd:	e9 8c fa ff ff       	jmp    8010568e <alltraps>

80105c02 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c02:	6a 11                	push   $0x11
  jmp alltraps
80105c04:	e9 85 fa ff ff       	jmp    8010568e <alltraps>

80105c09 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c09:	6a 00                	push   $0x0
  pushl $18
80105c0b:	6a 12                	push   $0x12
  jmp alltraps
80105c0d:	e9 7c fa ff ff       	jmp    8010568e <alltraps>

80105c12 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $19
80105c14:	6a 13                	push   $0x13
  jmp alltraps
80105c16:	e9 73 fa ff ff       	jmp    8010568e <alltraps>

80105c1b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $20
80105c1d:	6a 14                	push   $0x14
  jmp alltraps
80105c1f:	e9 6a fa ff ff       	jmp    8010568e <alltraps>

80105c24 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c24:	6a 00                	push   $0x0
  pushl $21
80105c26:	6a 15                	push   $0x15
  jmp alltraps
80105c28:	e9 61 fa ff ff       	jmp    8010568e <alltraps>

80105c2d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c2d:	6a 00                	push   $0x0
  pushl $22
80105c2f:	6a 16                	push   $0x16
  jmp alltraps
80105c31:	e9 58 fa ff ff       	jmp    8010568e <alltraps>

80105c36 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $23
80105c38:	6a 17                	push   $0x17
  jmp alltraps
80105c3a:	e9 4f fa ff ff       	jmp    8010568e <alltraps>

80105c3f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $24
80105c41:	6a 18                	push   $0x18
  jmp alltraps
80105c43:	e9 46 fa ff ff       	jmp    8010568e <alltraps>

80105c48 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c48:	6a 00                	push   $0x0
  pushl $25
80105c4a:	6a 19                	push   $0x19
  jmp alltraps
80105c4c:	e9 3d fa ff ff       	jmp    8010568e <alltraps>

80105c51 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c51:	6a 00                	push   $0x0
  pushl $26
80105c53:	6a 1a                	push   $0x1a
  jmp alltraps
80105c55:	e9 34 fa ff ff       	jmp    8010568e <alltraps>

80105c5a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $27
80105c5c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c5e:	e9 2b fa ff ff       	jmp    8010568e <alltraps>

80105c63 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $28
80105c65:	6a 1c                	push   $0x1c
  jmp alltraps
80105c67:	e9 22 fa ff ff       	jmp    8010568e <alltraps>

80105c6c <vector29>:
.globl vector29
vector29:
  pushl $0
80105c6c:	6a 00                	push   $0x0
  pushl $29
80105c6e:	6a 1d                	push   $0x1d
  jmp alltraps
80105c70:	e9 19 fa ff ff       	jmp    8010568e <alltraps>

80105c75 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c75:	6a 00                	push   $0x0
  pushl $30
80105c77:	6a 1e                	push   $0x1e
  jmp alltraps
80105c79:	e9 10 fa ff ff       	jmp    8010568e <alltraps>

80105c7e <vector31>:
.globl vector31
vector31:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $31
80105c80:	6a 1f                	push   $0x1f
  jmp alltraps
80105c82:	e9 07 fa ff ff       	jmp    8010568e <alltraps>

80105c87 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $32
80105c89:	6a 20                	push   $0x20
  jmp alltraps
80105c8b:	e9 fe f9 ff ff       	jmp    8010568e <alltraps>

80105c90 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c90:	6a 00                	push   $0x0
  pushl $33
80105c92:	6a 21                	push   $0x21
  jmp alltraps
80105c94:	e9 f5 f9 ff ff       	jmp    8010568e <alltraps>

80105c99 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $34
80105c9b:	6a 22                	push   $0x22
  jmp alltraps
80105c9d:	e9 ec f9 ff ff       	jmp    8010568e <alltraps>

80105ca2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $35
80105ca4:	6a 23                	push   $0x23
  jmp alltraps
80105ca6:	e9 e3 f9 ff ff       	jmp    8010568e <alltraps>

80105cab <vector36>:
.globl vector36
vector36:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $36
80105cad:	6a 24                	push   $0x24
  jmp alltraps
80105caf:	e9 da f9 ff ff       	jmp    8010568e <alltraps>

80105cb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $37
80105cb6:	6a 25                	push   $0x25
  jmp alltraps
80105cb8:	e9 d1 f9 ff ff       	jmp    8010568e <alltraps>

80105cbd <vector38>:
.globl vector38
vector38:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $38
80105cbf:	6a 26                	push   $0x26
  jmp alltraps
80105cc1:	e9 c8 f9 ff ff       	jmp    8010568e <alltraps>

80105cc6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $39
80105cc8:	6a 27                	push   $0x27
  jmp alltraps
80105cca:	e9 bf f9 ff ff       	jmp    8010568e <alltraps>

80105ccf <vector40>:
.globl vector40
vector40:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $40
80105cd1:	6a 28                	push   $0x28
  jmp alltraps
80105cd3:	e9 b6 f9 ff ff       	jmp    8010568e <alltraps>

80105cd8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $41
80105cda:	6a 29                	push   $0x29
  jmp alltraps
80105cdc:	e9 ad f9 ff ff       	jmp    8010568e <alltraps>

80105ce1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $42
80105ce3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ce5:	e9 a4 f9 ff ff       	jmp    8010568e <alltraps>

80105cea <vector43>:
.globl vector43
vector43:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $43
80105cec:	6a 2b                	push   $0x2b
  jmp alltraps
80105cee:	e9 9b f9 ff ff       	jmp    8010568e <alltraps>

80105cf3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $44
80105cf5:	6a 2c                	push   $0x2c
  jmp alltraps
80105cf7:	e9 92 f9 ff ff       	jmp    8010568e <alltraps>

80105cfc <vector45>:
.globl vector45
vector45:
  pushl $0
80105cfc:	6a 00                	push   $0x0
  pushl $45
80105cfe:	6a 2d                	push   $0x2d
  jmp alltraps
80105d00:	e9 89 f9 ff ff       	jmp    8010568e <alltraps>

80105d05 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $46
80105d07:	6a 2e                	push   $0x2e
  jmp alltraps
80105d09:	e9 80 f9 ff ff       	jmp    8010568e <alltraps>

80105d0e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $47
80105d10:	6a 2f                	push   $0x2f
  jmp alltraps
80105d12:	e9 77 f9 ff ff       	jmp    8010568e <alltraps>

80105d17 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $48
80105d19:	6a 30                	push   $0x30
  jmp alltraps
80105d1b:	e9 6e f9 ff ff       	jmp    8010568e <alltraps>

80105d20 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d20:	6a 00                	push   $0x0
  pushl $49
80105d22:	6a 31                	push   $0x31
  jmp alltraps
80105d24:	e9 65 f9 ff ff       	jmp    8010568e <alltraps>

80105d29 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $50
80105d2b:	6a 32                	push   $0x32
  jmp alltraps
80105d2d:	e9 5c f9 ff ff       	jmp    8010568e <alltraps>

80105d32 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $51
80105d34:	6a 33                	push   $0x33
  jmp alltraps
80105d36:	e9 53 f9 ff ff       	jmp    8010568e <alltraps>

80105d3b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $52
80105d3d:	6a 34                	push   $0x34
  jmp alltraps
80105d3f:	e9 4a f9 ff ff       	jmp    8010568e <alltraps>

80105d44 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $53
80105d46:	6a 35                	push   $0x35
  jmp alltraps
80105d48:	e9 41 f9 ff ff       	jmp    8010568e <alltraps>

80105d4d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $54
80105d4f:	6a 36                	push   $0x36
  jmp alltraps
80105d51:	e9 38 f9 ff ff       	jmp    8010568e <alltraps>

80105d56 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $55
80105d58:	6a 37                	push   $0x37
  jmp alltraps
80105d5a:	e9 2f f9 ff ff       	jmp    8010568e <alltraps>

80105d5f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $56
80105d61:	6a 38                	push   $0x38
  jmp alltraps
80105d63:	e9 26 f9 ff ff       	jmp    8010568e <alltraps>

80105d68 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $57
80105d6a:	6a 39                	push   $0x39
  jmp alltraps
80105d6c:	e9 1d f9 ff ff       	jmp    8010568e <alltraps>

80105d71 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $58
80105d73:	6a 3a                	push   $0x3a
  jmp alltraps
80105d75:	e9 14 f9 ff ff       	jmp    8010568e <alltraps>

80105d7a <vector59>:
.globl vector59
vector59:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $59
80105d7c:	6a 3b                	push   $0x3b
  jmp alltraps
80105d7e:	e9 0b f9 ff ff       	jmp    8010568e <alltraps>

80105d83 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $60
80105d85:	6a 3c                	push   $0x3c
  jmp alltraps
80105d87:	e9 02 f9 ff ff       	jmp    8010568e <alltraps>

80105d8c <vector61>:
.globl vector61
vector61:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $61
80105d8e:	6a 3d                	push   $0x3d
  jmp alltraps
80105d90:	e9 f9 f8 ff ff       	jmp    8010568e <alltraps>

80105d95 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $62
80105d97:	6a 3e                	push   $0x3e
  jmp alltraps
80105d99:	e9 f0 f8 ff ff       	jmp    8010568e <alltraps>

80105d9e <vector63>:
.globl vector63
vector63:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $63
80105da0:	6a 3f                	push   $0x3f
  jmp alltraps
80105da2:	e9 e7 f8 ff ff       	jmp    8010568e <alltraps>

80105da7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $64
80105da9:	6a 40                	push   $0x40
  jmp alltraps
80105dab:	e9 de f8 ff ff       	jmp    8010568e <alltraps>

80105db0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $65
80105db2:	6a 41                	push   $0x41
  jmp alltraps
80105db4:	e9 d5 f8 ff ff       	jmp    8010568e <alltraps>

80105db9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $66
80105dbb:	6a 42                	push   $0x42
  jmp alltraps
80105dbd:	e9 cc f8 ff ff       	jmp    8010568e <alltraps>

80105dc2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $67
80105dc4:	6a 43                	push   $0x43
  jmp alltraps
80105dc6:	e9 c3 f8 ff ff       	jmp    8010568e <alltraps>

80105dcb <vector68>:
.globl vector68
vector68:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $68
80105dcd:	6a 44                	push   $0x44
  jmp alltraps
80105dcf:	e9 ba f8 ff ff       	jmp    8010568e <alltraps>

80105dd4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $69
80105dd6:	6a 45                	push   $0x45
  jmp alltraps
80105dd8:	e9 b1 f8 ff ff       	jmp    8010568e <alltraps>

80105ddd <vector70>:
.globl vector70
vector70:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $70
80105ddf:	6a 46                	push   $0x46
  jmp alltraps
80105de1:	e9 a8 f8 ff ff       	jmp    8010568e <alltraps>

80105de6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $71
80105de8:	6a 47                	push   $0x47
  jmp alltraps
80105dea:	e9 9f f8 ff ff       	jmp    8010568e <alltraps>

80105def <vector72>:
.globl vector72
vector72:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $72
80105df1:	6a 48                	push   $0x48
  jmp alltraps
80105df3:	e9 96 f8 ff ff       	jmp    8010568e <alltraps>

80105df8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $73
80105dfa:	6a 49                	push   $0x49
  jmp alltraps
80105dfc:	e9 8d f8 ff ff       	jmp    8010568e <alltraps>

80105e01 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $74
80105e03:	6a 4a                	push   $0x4a
  jmp alltraps
80105e05:	e9 84 f8 ff ff       	jmp    8010568e <alltraps>

80105e0a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $75
80105e0c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e0e:	e9 7b f8 ff ff       	jmp    8010568e <alltraps>

80105e13 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $76
80105e15:	6a 4c                	push   $0x4c
  jmp alltraps
80105e17:	e9 72 f8 ff ff       	jmp    8010568e <alltraps>

80105e1c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $77
80105e1e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e20:	e9 69 f8 ff ff       	jmp    8010568e <alltraps>

80105e25 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $78
80105e27:	6a 4e                	push   $0x4e
  jmp alltraps
80105e29:	e9 60 f8 ff ff       	jmp    8010568e <alltraps>

80105e2e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $79
80105e30:	6a 4f                	push   $0x4f
  jmp alltraps
80105e32:	e9 57 f8 ff ff       	jmp    8010568e <alltraps>

80105e37 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $80
80105e39:	6a 50                	push   $0x50
  jmp alltraps
80105e3b:	e9 4e f8 ff ff       	jmp    8010568e <alltraps>

80105e40 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $81
80105e42:	6a 51                	push   $0x51
  jmp alltraps
80105e44:	e9 45 f8 ff ff       	jmp    8010568e <alltraps>

80105e49 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $82
80105e4b:	6a 52                	push   $0x52
  jmp alltraps
80105e4d:	e9 3c f8 ff ff       	jmp    8010568e <alltraps>

80105e52 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $83
80105e54:	6a 53                	push   $0x53
  jmp alltraps
80105e56:	e9 33 f8 ff ff       	jmp    8010568e <alltraps>

80105e5b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $84
80105e5d:	6a 54                	push   $0x54
  jmp alltraps
80105e5f:	e9 2a f8 ff ff       	jmp    8010568e <alltraps>

80105e64 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $85
80105e66:	6a 55                	push   $0x55
  jmp alltraps
80105e68:	e9 21 f8 ff ff       	jmp    8010568e <alltraps>

80105e6d <vector86>:
.globl vector86
vector86:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $86
80105e6f:	6a 56                	push   $0x56
  jmp alltraps
80105e71:	e9 18 f8 ff ff       	jmp    8010568e <alltraps>

80105e76 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $87
80105e78:	6a 57                	push   $0x57
  jmp alltraps
80105e7a:	e9 0f f8 ff ff       	jmp    8010568e <alltraps>

80105e7f <vector88>:
.globl vector88
vector88:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $88
80105e81:	6a 58                	push   $0x58
  jmp alltraps
80105e83:	e9 06 f8 ff ff       	jmp    8010568e <alltraps>

80105e88 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $89
80105e8a:	6a 59                	push   $0x59
  jmp alltraps
80105e8c:	e9 fd f7 ff ff       	jmp    8010568e <alltraps>

80105e91 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $90
80105e93:	6a 5a                	push   $0x5a
  jmp alltraps
80105e95:	e9 f4 f7 ff ff       	jmp    8010568e <alltraps>

80105e9a <vector91>:
.globl vector91
vector91:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $91
80105e9c:	6a 5b                	push   $0x5b
  jmp alltraps
80105e9e:	e9 eb f7 ff ff       	jmp    8010568e <alltraps>

80105ea3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $92
80105ea5:	6a 5c                	push   $0x5c
  jmp alltraps
80105ea7:	e9 e2 f7 ff ff       	jmp    8010568e <alltraps>

80105eac <vector93>:
.globl vector93
vector93:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $93
80105eae:	6a 5d                	push   $0x5d
  jmp alltraps
80105eb0:	e9 d9 f7 ff ff       	jmp    8010568e <alltraps>

80105eb5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $94
80105eb7:	6a 5e                	push   $0x5e
  jmp alltraps
80105eb9:	e9 d0 f7 ff ff       	jmp    8010568e <alltraps>

80105ebe <vector95>:
.globl vector95
vector95:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $95
80105ec0:	6a 5f                	push   $0x5f
  jmp alltraps
80105ec2:	e9 c7 f7 ff ff       	jmp    8010568e <alltraps>

80105ec7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $96
80105ec9:	6a 60                	push   $0x60
  jmp alltraps
80105ecb:	e9 be f7 ff ff       	jmp    8010568e <alltraps>

80105ed0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $97
80105ed2:	6a 61                	push   $0x61
  jmp alltraps
80105ed4:	e9 b5 f7 ff ff       	jmp    8010568e <alltraps>

80105ed9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $98
80105edb:	6a 62                	push   $0x62
  jmp alltraps
80105edd:	e9 ac f7 ff ff       	jmp    8010568e <alltraps>

80105ee2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $99
80105ee4:	6a 63                	push   $0x63
  jmp alltraps
80105ee6:	e9 a3 f7 ff ff       	jmp    8010568e <alltraps>

80105eeb <vector100>:
.globl vector100
vector100:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $100
80105eed:	6a 64                	push   $0x64
  jmp alltraps
80105eef:	e9 9a f7 ff ff       	jmp    8010568e <alltraps>

80105ef4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $101
80105ef6:	6a 65                	push   $0x65
  jmp alltraps
80105ef8:	e9 91 f7 ff ff       	jmp    8010568e <alltraps>

80105efd <vector102>:
.globl vector102
vector102:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $102
80105eff:	6a 66                	push   $0x66
  jmp alltraps
80105f01:	e9 88 f7 ff ff       	jmp    8010568e <alltraps>

80105f06 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $103
80105f08:	6a 67                	push   $0x67
  jmp alltraps
80105f0a:	e9 7f f7 ff ff       	jmp    8010568e <alltraps>

80105f0f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $104
80105f11:	6a 68                	push   $0x68
  jmp alltraps
80105f13:	e9 76 f7 ff ff       	jmp    8010568e <alltraps>

80105f18 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $105
80105f1a:	6a 69                	push   $0x69
  jmp alltraps
80105f1c:	e9 6d f7 ff ff       	jmp    8010568e <alltraps>

80105f21 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $106
80105f23:	6a 6a                	push   $0x6a
  jmp alltraps
80105f25:	e9 64 f7 ff ff       	jmp    8010568e <alltraps>

80105f2a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $107
80105f2c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f2e:	e9 5b f7 ff ff       	jmp    8010568e <alltraps>

80105f33 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $108
80105f35:	6a 6c                	push   $0x6c
  jmp alltraps
80105f37:	e9 52 f7 ff ff       	jmp    8010568e <alltraps>

80105f3c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $109
80105f3e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f40:	e9 49 f7 ff ff       	jmp    8010568e <alltraps>

80105f45 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $110
80105f47:	6a 6e                	push   $0x6e
  jmp alltraps
80105f49:	e9 40 f7 ff ff       	jmp    8010568e <alltraps>

80105f4e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $111
80105f50:	6a 6f                	push   $0x6f
  jmp alltraps
80105f52:	e9 37 f7 ff ff       	jmp    8010568e <alltraps>

80105f57 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $112
80105f59:	6a 70                	push   $0x70
  jmp alltraps
80105f5b:	e9 2e f7 ff ff       	jmp    8010568e <alltraps>

80105f60 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $113
80105f62:	6a 71                	push   $0x71
  jmp alltraps
80105f64:	e9 25 f7 ff ff       	jmp    8010568e <alltraps>

80105f69 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $114
80105f6b:	6a 72                	push   $0x72
  jmp alltraps
80105f6d:	e9 1c f7 ff ff       	jmp    8010568e <alltraps>

80105f72 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $115
80105f74:	6a 73                	push   $0x73
  jmp alltraps
80105f76:	e9 13 f7 ff ff       	jmp    8010568e <alltraps>

80105f7b <vector116>:
.globl vector116
vector116:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $116
80105f7d:	6a 74                	push   $0x74
  jmp alltraps
80105f7f:	e9 0a f7 ff ff       	jmp    8010568e <alltraps>

80105f84 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $117
80105f86:	6a 75                	push   $0x75
  jmp alltraps
80105f88:	e9 01 f7 ff ff       	jmp    8010568e <alltraps>

80105f8d <vector118>:
.globl vector118
vector118:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $118
80105f8f:	6a 76                	push   $0x76
  jmp alltraps
80105f91:	e9 f8 f6 ff ff       	jmp    8010568e <alltraps>

80105f96 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $119
80105f98:	6a 77                	push   $0x77
  jmp alltraps
80105f9a:	e9 ef f6 ff ff       	jmp    8010568e <alltraps>

80105f9f <vector120>:
.globl vector120
vector120:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $120
80105fa1:	6a 78                	push   $0x78
  jmp alltraps
80105fa3:	e9 e6 f6 ff ff       	jmp    8010568e <alltraps>

80105fa8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $121
80105faa:	6a 79                	push   $0x79
  jmp alltraps
80105fac:	e9 dd f6 ff ff       	jmp    8010568e <alltraps>

80105fb1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $122
80105fb3:	6a 7a                	push   $0x7a
  jmp alltraps
80105fb5:	e9 d4 f6 ff ff       	jmp    8010568e <alltraps>

80105fba <vector123>:
.globl vector123
vector123:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $123
80105fbc:	6a 7b                	push   $0x7b
  jmp alltraps
80105fbe:	e9 cb f6 ff ff       	jmp    8010568e <alltraps>

80105fc3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $124
80105fc5:	6a 7c                	push   $0x7c
  jmp alltraps
80105fc7:	e9 c2 f6 ff ff       	jmp    8010568e <alltraps>

80105fcc <vector125>:
.globl vector125
vector125:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $125
80105fce:	6a 7d                	push   $0x7d
  jmp alltraps
80105fd0:	e9 b9 f6 ff ff       	jmp    8010568e <alltraps>

80105fd5 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $126
80105fd7:	6a 7e                	push   $0x7e
  jmp alltraps
80105fd9:	e9 b0 f6 ff ff       	jmp    8010568e <alltraps>

80105fde <vector127>:
.globl vector127
vector127:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $127
80105fe0:	6a 7f                	push   $0x7f
  jmp alltraps
80105fe2:	e9 a7 f6 ff ff       	jmp    8010568e <alltraps>

80105fe7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $128
80105fe9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105fee:	e9 9b f6 ff ff       	jmp    8010568e <alltraps>

80105ff3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $129
80105ff5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ffa:	e9 8f f6 ff ff       	jmp    8010568e <alltraps>

80105fff <vector130>:
.globl vector130
vector130:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $130
80106001:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106006:	e9 83 f6 ff ff       	jmp    8010568e <alltraps>

8010600b <vector131>:
.globl vector131
vector131:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $131
8010600d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106012:	e9 77 f6 ff ff       	jmp    8010568e <alltraps>

80106017 <vector132>:
.globl vector132
vector132:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $132
80106019:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010601e:	e9 6b f6 ff ff       	jmp    8010568e <alltraps>

80106023 <vector133>:
.globl vector133
vector133:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $133
80106025:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010602a:	e9 5f f6 ff ff       	jmp    8010568e <alltraps>

8010602f <vector134>:
.globl vector134
vector134:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $134
80106031:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106036:	e9 53 f6 ff ff       	jmp    8010568e <alltraps>

8010603b <vector135>:
.globl vector135
vector135:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $135
8010603d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106042:	e9 47 f6 ff ff       	jmp    8010568e <alltraps>

80106047 <vector136>:
.globl vector136
vector136:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $136
80106049:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010604e:	e9 3b f6 ff ff       	jmp    8010568e <alltraps>

80106053 <vector137>:
.globl vector137
vector137:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $137
80106055:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010605a:	e9 2f f6 ff ff       	jmp    8010568e <alltraps>

8010605f <vector138>:
.globl vector138
vector138:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $138
80106061:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106066:	e9 23 f6 ff ff       	jmp    8010568e <alltraps>

8010606b <vector139>:
.globl vector139
vector139:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $139
8010606d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106072:	e9 17 f6 ff ff       	jmp    8010568e <alltraps>

80106077 <vector140>:
.globl vector140
vector140:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $140
80106079:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010607e:	e9 0b f6 ff ff       	jmp    8010568e <alltraps>

80106083 <vector141>:
.globl vector141
vector141:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $141
80106085:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010608a:	e9 ff f5 ff ff       	jmp    8010568e <alltraps>

8010608f <vector142>:
.globl vector142
vector142:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $142
80106091:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106096:	e9 f3 f5 ff ff       	jmp    8010568e <alltraps>

8010609b <vector143>:
.globl vector143
vector143:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $143
8010609d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060a2:	e9 e7 f5 ff ff       	jmp    8010568e <alltraps>

801060a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $144
801060a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060ae:	e9 db f5 ff ff       	jmp    8010568e <alltraps>

801060b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $145
801060b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060ba:	e9 cf f5 ff ff       	jmp    8010568e <alltraps>

801060bf <vector146>:
.globl vector146
vector146:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $146
801060c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060c6:	e9 c3 f5 ff ff       	jmp    8010568e <alltraps>

801060cb <vector147>:
.globl vector147
vector147:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $147
801060cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060d2:	e9 b7 f5 ff ff       	jmp    8010568e <alltraps>

801060d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $148
801060d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060de:	e9 ab f5 ff ff       	jmp    8010568e <alltraps>

801060e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $149
801060e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060ea:	e9 9f f5 ff ff       	jmp    8010568e <alltraps>

801060ef <vector150>:
.globl vector150
vector150:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $150
801060f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060f6:	e9 93 f5 ff ff       	jmp    8010568e <alltraps>

801060fb <vector151>:
.globl vector151
vector151:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $151
801060fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106102:	e9 87 f5 ff ff       	jmp    8010568e <alltraps>

80106107 <vector152>:
.globl vector152
vector152:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $152
80106109:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010610e:	e9 7b f5 ff ff       	jmp    8010568e <alltraps>

80106113 <vector153>:
.globl vector153
vector153:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $153
80106115:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010611a:	e9 6f f5 ff ff       	jmp    8010568e <alltraps>

8010611f <vector154>:
.globl vector154
vector154:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $154
80106121:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106126:	e9 63 f5 ff ff       	jmp    8010568e <alltraps>

8010612b <vector155>:
.globl vector155
vector155:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $155
8010612d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106132:	e9 57 f5 ff ff       	jmp    8010568e <alltraps>

80106137 <vector156>:
.globl vector156
vector156:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $156
80106139:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010613e:	e9 4b f5 ff ff       	jmp    8010568e <alltraps>

80106143 <vector157>:
.globl vector157
vector157:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $157
80106145:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010614a:	e9 3f f5 ff ff       	jmp    8010568e <alltraps>

8010614f <vector158>:
.globl vector158
vector158:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $158
80106151:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106156:	e9 33 f5 ff ff       	jmp    8010568e <alltraps>

8010615b <vector159>:
.globl vector159
vector159:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $159
8010615d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106162:	e9 27 f5 ff ff       	jmp    8010568e <alltraps>

80106167 <vector160>:
.globl vector160
vector160:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $160
80106169:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010616e:	e9 1b f5 ff ff       	jmp    8010568e <alltraps>

80106173 <vector161>:
.globl vector161
vector161:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $161
80106175:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010617a:	e9 0f f5 ff ff       	jmp    8010568e <alltraps>

8010617f <vector162>:
.globl vector162
vector162:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $162
80106181:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106186:	e9 03 f5 ff ff       	jmp    8010568e <alltraps>

8010618b <vector163>:
.globl vector163
vector163:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $163
8010618d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106192:	e9 f7 f4 ff ff       	jmp    8010568e <alltraps>

80106197 <vector164>:
.globl vector164
vector164:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $164
80106199:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010619e:	e9 eb f4 ff ff       	jmp    8010568e <alltraps>

801061a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $165
801061a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061aa:	e9 df f4 ff ff       	jmp    8010568e <alltraps>

801061af <vector166>:
.globl vector166
vector166:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $166
801061b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061b6:	e9 d3 f4 ff ff       	jmp    8010568e <alltraps>

801061bb <vector167>:
.globl vector167
vector167:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $167
801061bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061c2:	e9 c7 f4 ff ff       	jmp    8010568e <alltraps>

801061c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $168
801061c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061ce:	e9 bb f4 ff ff       	jmp    8010568e <alltraps>

801061d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $169
801061d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061da:	e9 af f4 ff ff       	jmp    8010568e <alltraps>

801061df <vector170>:
.globl vector170
vector170:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $170
801061e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061e6:	e9 a3 f4 ff ff       	jmp    8010568e <alltraps>

801061eb <vector171>:
.globl vector171
vector171:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $171
801061ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061f2:	e9 97 f4 ff ff       	jmp    8010568e <alltraps>

801061f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $172
801061f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061fe:	e9 8b f4 ff ff       	jmp    8010568e <alltraps>

80106203 <vector173>:
.globl vector173
vector173:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $173
80106205:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010620a:	e9 7f f4 ff ff       	jmp    8010568e <alltraps>

8010620f <vector174>:
.globl vector174
vector174:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $174
80106211:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106216:	e9 73 f4 ff ff       	jmp    8010568e <alltraps>

8010621b <vector175>:
.globl vector175
vector175:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $175
8010621d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106222:	e9 67 f4 ff ff       	jmp    8010568e <alltraps>

80106227 <vector176>:
.globl vector176
vector176:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $176
80106229:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010622e:	e9 5b f4 ff ff       	jmp    8010568e <alltraps>

80106233 <vector177>:
.globl vector177
vector177:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $177
80106235:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010623a:	e9 4f f4 ff ff       	jmp    8010568e <alltraps>

8010623f <vector178>:
.globl vector178
vector178:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $178
80106241:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106246:	e9 43 f4 ff ff       	jmp    8010568e <alltraps>

8010624b <vector179>:
.globl vector179
vector179:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $179
8010624d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106252:	e9 37 f4 ff ff       	jmp    8010568e <alltraps>

80106257 <vector180>:
.globl vector180
vector180:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $180
80106259:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010625e:	e9 2b f4 ff ff       	jmp    8010568e <alltraps>

80106263 <vector181>:
.globl vector181
vector181:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $181
80106265:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010626a:	e9 1f f4 ff ff       	jmp    8010568e <alltraps>

8010626f <vector182>:
.globl vector182
vector182:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $182
80106271:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106276:	e9 13 f4 ff ff       	jmp    8010568e <alltraps>

8010627b <vector183>:
.globl vector183
vector183:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $183
8010627d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106282:	e9 07 f4 ff ff       	jmp    8010568e <alltraps>

80106287 <vector184>:
.globl vector184
vector184:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $184
80106289:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010628e:	e9 fb f3 ff ff       	jmp    8010568e <alltraps>

80106293 <vector185>:
.globl vector185
vector185:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $185
80106295:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010629a:	e9 ef f3 ff ff       	jmp    8010568e <alltraps>

8010629f <vector186>:
.globl vector186
vector186:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $186
801062a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062a6:	e9 e3 f3 ff ff       	jmp    8010568e <alltraps>

801062ab <vector187>:
.globl vector187
vector187:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $187
801062ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062b2:	e9 d7 f3 ff ff       	jmp    8010568e <alltraps>

801062b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $188
801062b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062be:	e9 cb f3 ff ff       	jmp    8010568e <alltraps>

801062c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $189
801062c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062ca:	e9 bf f3 ff ff       	jmp    8010568e <alltraps>

801062cf <vector190>:
.globl vector190
vector190:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $190
801062d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062d6:	e9 b3 f3 ff ff       	jmp    8010568e <alltraps>

801062db <vector191>:
.globl vector191
vector191:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $191
801062dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062e2:	e9 a7 f3 ff ff       	jmp    8010568e <alltraps>

801062e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $192
801062e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062ee:	e9 9b f3 ff ff       	jmp    8010568e <alltraps>

801062f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $193
801062f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062fa:	e9 8f f3 ff ff       	jmp    8010568e <alltraps>

801062ff <vector194>:
.globl vector194
vector194:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $194
80106301:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106306:	e9 83 f3 ff ff       	jmp    8010568e <alltraps>

8010630b <vector195>:
.globl vector195
vector195:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $195
8010630d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106312:	e9 77 f3 ff ff       	jmp    8010568e <alltraps>

80106317 <vector196>:
.globl vector196
vector196:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $196
80106319:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010631e:	e9 6b f3 ff ff       	jmp    8010568e <alltraps>

80106323 <vector197>:
.globl vector197
vector197:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $197
80106325:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010632a:	e9 5f f3 ff ff       	jmp    8010568e <alltraps>

8010632f <vector198>:
.globl vector198
vector198:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $198
80106331:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106336:	e9 53 f3 ff ff       	jmp    8010568e <alltraps>

8010633b <vector199>:
.globl vector199
vector199:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $199
8010633d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106342:	e9 47 f3 ff ff       	jmp    8010568e <alltraps>

80106347 <vector200>:
.globl vector200
vector200:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $200
80106349:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010634e:	e9 3b f3 ff ff       	jmp    8010568e <alltraps>

80106353 <vector201>:
.globl vector201
vector201:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $201
80106355:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010635a:	e9 2f f3 ff ff       	jmp    8010568e <alltraps>

8010635f <vector202>:
.globl vector202
vector202:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $202
80106361:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106366:	e9 23 f3 ff ff       	jmp    8010568e <alltraps>

8010636b <vector203>:
.globl vector203
vector203:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $203
8010636d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106372:	e9 17 f3 ff ff       	jmp    8010568e <alltraps>

80106377 <vector204>:
.globl vector204
vector204:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $204
80106379:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010637e:	e9 0b f3 ff ff       	jmp    8010568e <alltraps>

80106383 <vector205>:
.globl vector205
vector205:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $205
80106385:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010638a:	e9 ff f2 ff ff       	jmp    8010568e <alltraps>

8010638f <vector206>:
.globl vector206
vector206:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $206
80106391:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106396:	e9 f3 f2 ff ff       	jmp    8010568e <alltraps>

8010639b <vector207>:
.globl vector207
vector207:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $207
8010639d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063a2:	e9 e7 f2 ff ff       	jmp    8010568e <alltraps>

801063a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $208
801063a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063ae:	e9 db f2 ff ff       	jmp    8010568e <alltraps>

801063b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $209
801063b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063ba:	e9 cf f2 ff ff       	jmp    8010568e <alltraps>

801063bf <vector210>:
.globl vector210
vector210:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $210
801063c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063c6:	e9 c3 f2 ff ff       	jmp    8010568e <alltraps>

801063cb <vector211>:
.globl vector211
vector211:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $211
801063cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063d2:	e9 b7 f2 ff ff       	jmp    8010568e <alltraps>

801063d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $212
801063d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063de:	e9 ab f2 ff ff       	jmp    8010568e <alltraps>

801063e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $213
801063e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063ea:	e9 9f f2 ff ff       	jmp    8010568e <alltraps>

801063ef <vector214>:
.globl vector214
vector214:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $214
801063f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063f6:	e9 93 f2 ff ff       	jmp    8010568e <alltraps>

801063fb <vector215>:
.globl vector215
vector215:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $215
801063fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106402:	e9 87 f2 ff ff       	jmp    8010568e <alltraps>

80106407 <vector216>:
.globl vector216
vector216:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $216
80106409:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010640e:	e9 7b f2 ff ff       	jmp    8010568e <alltraps>

80106413 <vector217>:
.globl vector217
vector217:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $217
80106415:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010641a:	e9 6f f2 ff ff       	jmp    8010568e <alltraps>

8010641f <vector218>:
.globl vector218
vector218:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $218
80106421:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106426:	e9 63 f2 ff ff       	jmp    8010568e <alltraps>

8010642b <vector219>:
.globl vector219
vector219:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $219
8010642d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106432:	e9 57 f2 ff ff       	jmp    8010568e <alltraps>

80106437 <vector220>:
.globl vector220
vector220:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $220
80106439:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010643e:	e9 4b f2 ff ff       	jmp    8010568e <alltraps>

80106443 <vector221>:
.globl vector221
vector221:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $221
80106445:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010644a:	e9 3f f2 ff ff       	jmp    8010568e <alltraps>

8010644f <vector222>:
.globl vector222
vector222:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $222
80106451:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106456:	e9 33 f2 ff ff       	jmp    8010568e <alltraps>

8010645b <vector223>:
.globl vector223
vector223:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $223
8010645d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106462:	e9 27 f2 ff ff       	jmp    8010568e <alltraps>

80106467 <vector224>:
.globl vector224
vector224:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $224
80106469:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010646e:	e9 1b f2 ff ff       	jmp    8010568e <alltraps>

80106473 <vector225>:
.globl vector225
vector225:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $225
80106475:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010647a:	e9 0f f2 ff ff       	jmp    8010568e <alltraps>

8010647f <vector226>:
.globl vector226
vector226:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $226
80106481:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106486:	e9 03 f2 ff ff       	jmp    8010568e <alltraps>

8010648b <vector227>:
.globl vector227
vector227:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $227
8010648d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106492:	e9 f7 f1 ff ff       	jmp    8010568e <alltraps>

80106497 <vector228>:
.globl vector228
vector228:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $228
80106499:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010649e:	e9 eb f1 ff ff       	jmp    8010568e <alltraps>

801064a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $229
801064a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064aa:	e9 df f1 ff ff       	jmp    8010568e <alltraps>

801064af <vector230>:
.globl vector230
vector230:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $230
801064b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064b6:	e9 d3 f1 ff ff       	jmp    8010568e <alltraps>

801064bb <vector231>:
.globl vector231
vector231:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $231
801064bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064c2:	e9 c7 f1 ff ff       	jmp    8010568e <alltraps>

801064c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $232
801064c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064ce:	e9 bb f1 ff ff       	jmp    8010568e <alltraps>

801064d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $233
801064d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064da:	e9 af f1 ff ff       	jmp    8010568e <alltraps>

801064df <vector234>:
.globl vector234
vector234:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $234
801064e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064e6:	e9 a3 f1 ff ff       	jmp    8010568e <alltraps>

801064eb <vector235>:
.globl vector235
vector235:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $235
801064ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064f2:	e9 97 f1 ff ff       	jmp    8010568e <alltraps>

801064f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $236
801064f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064fe:	e9 8b f1 ff ff       	jmp    8010568e <alltraps>

80106503 <vector237>:
.globl vector237
vector237:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $237
80106505:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010650a:	e9 7f f1 ff ff       	jmp    8010568e <alltraps>

8010650f <vector238>:
.globl vector238
vector238:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $238
80106511:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106516:	e9 73 f1 ff ff       	jmp    8010568e <alltraps>

8010651b <vector239>:
.globl vector239
vector239:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $239
8010651d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106522:	e9 67 f1 ff ff       	jmp    8010568e <alltraps>

80106527 <vector240>:
.globl vector240
vector240:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $240
80106529:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010652e:	e9 5b f1 ff ff       	jmp    8010568e <alltraps>

80106533 <vector241>:
.globl vector241
vector241:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $241
80106535:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010653a:	e9 4f f1 ff ff       	jmp    8010568e <alltraps>

8010653f <vector242>:
.globl vector242
vector242:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $242
80106541:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106546:	e9 43 f1 ff ff       	jmp    8010568e <alltraps>

8010654b <vector243>:
.globl vector243
vector243:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $243
8010654d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106552:	e9 37 f1 ff ff       	jmp    8010568e <alltraps>

80106557 <vector244>:
.globl vector244
vector244:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $244
80106559:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010655e:	e9 2b f1 ff ff       	jmp    8010568e <alltraps>

80106563 <vector245>:
.globl vector245
vector245:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $245
80106565:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010656a:	e9 1f f1 ff ff       	jmp    8010568e <alltraps>

8010656f <vector246>:
.globl vector246
vector246:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $246
80106571:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106576:	e9 13 f1 ff ff       	jmp    8010568e <alltraps>

8010657b <vector247>:
.globl vector247
vector247:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $247
8010657d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106582:	e9 07 f1 ff ff       	jmp    8010568e <alltraps>

80106587 <vector248>:
.globl vector248
vector248:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $248
80106589:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010658e:	e9 fb f0 ff ff       	jmp    8010568e <alltraps>

80106593 <vector249>:
.globl vector249
vector249:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $249
80106595:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010659a:	e9 ef f0 ff ff       	jmp    8010568e <alltraps>

8010659f <vector250>:
.globl vector250
vector250:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $250
801065a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065a6:	e9 e3 f0 ff ff       	jmp    8010568e <alltraps>

801065ab <vector251>:
.globl vector251
vector251:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $251
801065ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065b2:	e9 d7 f0 ff ff       	jmp    8010568e <alltraps>

801065b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $252
801065b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065be:	e9 cb f0 ff ff       	jmp    8010568e <alltraps>

801065c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $253
801065c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065ca:	e9 bf f0 ff ff       	jmp    8010568e <alltraps>

801065cf <vector254>:
.globl vector254
vector254:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $254
801065d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065d6:	e9 b3 f0 ff ff       	jmp    8010568e <alltraps>

801065db <vector255>:
.globl vector255
vector255:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $255
801065dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065e2:	e9 a7 f0 ff ff       	jmp    8010568e <alltraps>
801065e7:	66 90                	xchg   %ax,%ax
801065e9:	66 90                	xchg   %ax,%ax
801065eb:	66 90                	xchg   %ax,%ax
801065ed:	66 90                	xchg   %ax,%ax
801065ef:	90                   	nop

801065f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	57                   	push   %edi
801065f4:	56                   	push   %esi
801065f5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065f7:	c1 ea 16             	shr    $0x16,%edx
{
801065fa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801065fb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801065fe:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106601:	8b 07                	mov    (%edi),%eax
80106603:	a8 01                	test   $0x1,%al
80106605:	74 29                	je     80106630 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106607:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010660c:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106612:	c1 ee 0a             	shr    $0xa,%esi
}
80106615:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106618:	89 f2                	mov    %esi,%edx
8010661a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106620:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106623:	5b                   	pop    %ebx
80106624:	5e                   	pop    %esi
80106625:	5f                   	pop    %edi
80106626:	5d                   	pop    %ebp
80106627:	c3                   	ret    
80106628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010662f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106630:	85 c9                	test   %ecx,%ecx
80106632:	74 2c                	je     80106660 <walkpgdir+0x70>
80106634:	e8 97 bf ff ff       	call   801025d0 <kalloc>
80106639:	89 c3                	mov    %eax,%ebx
8010663b:	85 c0                	test   %eax,%eax
8010663d:	74 21                	je     80106660 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010663f:	83 ec 04             	sub    $0x4,%esp
80106642:	68 00 10 00 00       	push   $0x1000
80106647:	6a 00                	push   $0x0
80106649:	50                   	push   %eax
8010664a:	e8 71 de ff ff       	call   801044c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010664f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106655:	83 c4 10             	add    $0x10,%esp
80106658:	83 c8 07             	or     $0x7,%eax
8010665b:	89 07                	mov    %eax,(%edi)
8010665d:	eb b3                	jmp    80106612 <walkpgdir+0x22>
8010665f:	90                   	nop
}
80106660:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106663:	31 c0                	xor    %eax,%eax
}
80106665:	5b                   	pop    %ebx
80106666:	5e                   	pop    %esi
80106667:	5f                   	pop    %edi
80106668:	5d                   	pop    %ebp
80106669:	c3                   	ret    
8010666a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106670 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106675:	89 d6                	mov    %edx,%esi
{
80106677:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106678:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010667e:	83 ec 1c             	sub    $0x1c,%esp
80106681:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106684:	8b 7d 08             	mov    0x8(%ebp),%edi
80106687:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010668b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106690:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106693:	29 f7                	sub    %esi,%edi
80106695:	eb 21                	jmp    801066b8 <mappages+0x48>
80106697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010669e:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801066a0:	f6 00 01             	testb  $0x1,(%eax)
801066a3:	75 45                	jne    801066ea <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801066a5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801066a8:	83 cb 01             	or     $0x1,%ebx
801066ab:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801066ad:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801066b0:	74 2e                	je     801066e0 <mappages+0x70>
      break;
    a += PGSIZE;
801066b2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801066b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066bb:	b9 01 00 00 00       	mov    $0x1,%ecx
801066c0:	89 f2                	mov    %esi,%edx
801066c2:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801066c5:	e8 26 ff ff ff       	call   801065f0 <walkpgdir>
801066ca:	85 c0                	test   %eax,%eax
801066cc:	75 d2                	jne    801066a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801066ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801066d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066d6:	5b                   	pop    %ebx
801066d7:	5e                   	pop    %esi
801066d8:	5f                   	pop    %edi
801066d9:	5d                   	pop    %ebp
801066da:	c3                   	ret    
801066db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066df:	90                   	nop
801066e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801066e3:	31 c0                	xor    %eax,%eax
}
801066e5:	5b                   	pop    %ebx
801066e6:	5e                   	pop    %esi
801066e7:	5f                   	pop    %edi
801066e8:	5d                   	pop    %ebp
801066e9:	c3                   	ret    
      panic("remap");
801066ea:	83 ec 0c             	sub    $0xc,%esp
801066ed:	68 68 77 10 80       	push   $0x80107768
801066f2:	e8 99 9c ff ff       	call   80100390 <panic>
801066f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066fe:	66 90                	xchg   %ax,%ax

80106700 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	57                   	push   %edi
80106704:	89 c7                	mov    %eax,%edi
80106706:	56                   	push   %esi
80106707:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106708:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010670e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106714:	83 ec 1c             	sub    $0x1c,%esp
80106717:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010671a:	39 d3                	cmp    %edx,%ebx
8010671c:	73 60                	jae    8010677e <deallocuvm.part.0+0x7e>
8010671e:	89 d6                	mov    %edx,%esi
80106720:	eb 3d                	jmp    8010675f <deallocuvm.part.0+0x5f>
80106722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106728:	8b 10                	mov    (%eax),%edx
8010672a:	f6 c2 01             	test   $0x1,%dl
8010672d:	74 26                	je     80106755 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010672f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106735:	74 52                	je     80106789 <deallocuvm.part.0+0x89>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106737:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010673a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106743:	52                   	push   %edx
80106744:	e8 c7 bc ff ff       	call   80102410 <kfree>
      *pte = 0;
80106749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010674c:	83 c4 10             	add    $0x10,%esp
8010674f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106755:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010675b:	39 f3                	cmp    %esi,%ebx
8010675d:	73 1f                	jae    8010677e <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010675f:	31 c9                	xor    %ecx,%ecx
80106761:	89 da                	mov    %ebx,%edx
80106763:	89 f8                	mov    %edi,%eax
80106765:	e8 86 fe ff ff       	call   801065f0 <walkpgdir>
    if(!pte)
8010676a:	85 c0                	test   %eax,%eax
8010676c:	75 ba                	jne    80106728 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
8010676e:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106774:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010677a:	39 f3                	cmp    %esi,%ebx
8010677c:	72 e1                	jb     8010675f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
8010677e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106784:	5b                   	pop    %ebx
80106785:	5e                   	pop    %esi
80106786:	5f                   	pop    %edi
80106787:	5d                   	pop    %ebp
80106788:	c3                   	ret    
        panic("kfree");
80106789:	83 ec 0c             	sub    $0xc,%esp
8010678c:	68 1a 71 10 80       	push   $0x8010711a
80106791:	e8 fa 9b ff ff       	call   80100390 <panic>
80106796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010679d:	8d 76 00             	lea    0x0(%esi),%esi

801067a0 <seginit>:
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	53                   	push   %ebx
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801067a4:	31 db                	xor    %ebx,%ebx
{
801067a6:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpunum()];
801067a9:	e8 a2 c0 ff ff       	call   80102850 <cpunum>
801067ae:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801067b4:	8d 90 e0 12 11 80    	lea    -0x7feeed20(%eax),%edx
801067ba:	8d 88 94 13 11 80    	lea    -0x7feeec6c(%eax),%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067c0:	c7 80 58 13 11 80 ff 	movl   $0xffff,-0x7feeeca8(%eax)
801067c7:	ff 00 00 
801067ca:	c7 80 5c 13 11 80 00 	movl   $0xcf9a00,-0x7feeeca4(%eax)
801067d1:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067d4:	c7 80 60 13 11 80 ff 	movl   $0xffff,-0x7feeeca0(%eax)
801067db:	ff 00 00 
801067de:	c7 80 64 13 11 80 00 	movl   $0xcf9200,-0x7feeec9c(%eax)
801067e5:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067e8:	c7 80 70 13 11 80 ff 	movl   $0xffff,-0x7feeec90(%eax)
801067ef:	ff 00 00 
801067f2:	c7 80 74 13 11 80 00 	movl   $0xcffa00,-0x7feeec8c(%eax)
801067f9:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067fc:	c7 80 78 13 11 80 ff 	movl   $0xffff,-0x7feeec88(%eax)
80106803:	ff 00 00 
80106806:	c7 80 7c 13 11 80 00 	movl   $0xcff200,-0x7feeec84(%eax)
8010680d:	f2 cf 00 
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106810:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
80106817:	89 cb                	mov    %ecx,%ebx
80106819:	c1 eb 10             	shr    $0x10,%ebx
8010681c:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
80106823:	c1 e9 18             	shr    $0x18,%ecx
80106826:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
8010682c:	bb 92 c0 ff ff       	mov    $0xffffc092,%ebx
80106831:	66 89 98 6d 13 11 80 	mov    %bx,-0x7feeec93(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106838:	05 50 13 11 80       	add    $0x80111350,%eax
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010683d:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
  pd[0] = size-1;
80106843:	b9 37 00 00 00       	mov    $0x37,%ecx
80106848:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
8010684c:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106850:	c1 e8 10             	shr    $0x10,%eax
80106853:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106857:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010685a:	0f 01 10             	lgdtl  (%eax)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010685d:	b8 18 00 00 00       	mov    $0x18,%eax
80106862:	8e e8                	mov    %eax,%gs
  proc = 0;
80106864:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010686b:	00 00 00 00 
  c = &cpus[cpunum()];
8010686f:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
}
80106876:	83 c4 14             	add    $0x14,%esp
80106879:	5b                   	pop    %ebx
8010687a:	5d                   	pop    %ebp
8010687b:	c3                   	ret    
8010687c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106880 <setupkvm>:
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	56                   	push   %esi
80106884:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106885:	e8 46 bd ff ff       	call   801025d0 <kalloc>
8010688a:	85 c0                	test   %eax,%eax
8010688c:	74 52                	je     801068e0 <setupkvm+0x60>
  memset(pgdir, 0, PGSIZE);
8010688e:	83 ec 04             	sub    $0x4,%esp
80106891:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106893:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106898:	68 00 10 00 00       	push   $0x1000
8010689d:	6a 00                	push   $0x0
8010689f:	50                   	push   %eax
801068a0:	e8 1b dc ff ff       	call   801044c0 <memset>
801068a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0)
801068a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801068ab:	83 ec 08             	sub    $0x8,%esp
801068ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801068b1:	ff 73 0c             	pushl  0xc(%ebx)
801068b4:	8b 13                	mov    (%ebx),%edx
801068b6:	50                   	push   %eax
801068b7:	29 c1                	sub    %eax,%ecx
801068b9:	89 f0                	mov    %esi,%eax
801068bb:	e8 b0 fd ff ff       	call   80106670 <mappages>
801068c0:	83 c4 10             	add    $0x10,%esp
801068c3:	85 c0                	test   %eax,%eax
801068c5:	78 19                	js     801068e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801068c7:	83 c3 10             	add    $0x10,%ebx
801068ca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801068d0:	75 d6                	jne    801068a8 <setupkvm+0x28>
}
801068d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801068d5:	89 f0                	mov    %esi,%eax
801068d7:	5b                   	pop    %ebx
801068d8:	5e                   	pop    %esi
801068d9:	5d                   	pop    %ebp
801068da:	c3                   	ret    
801068db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068df:	90                   	nop
801068e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801068e3:	31 f6                	xor    %esi,%esi
}
801068e5:	89 f0                	mov    %esi,%eax
801068e7:	5b                   	pop    %ebx
801068e8:	5e                   	pop    %esi
801068e9:	5d                   	pop    %ebp
801068ea:	c3                   	ret    
801068eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068ef:	90                   	nop

801068f0 <kvmalloc>:
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801068f6:	e8 85 ff ff ff       	call   80106880 <setupkvm>
801068fb:	a3 64 40 11 80       	mov    %eax,0x80114064
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106900:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106905:	0f 22 d8             	mov    %eax,%cr3
}
80106908:	c9                   	leave  
80106909:	c3                   	ret    
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106910 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106910:	a1 64 40 11 80       	mov    0x80114064,%eax
80106915:	05 00 00 00 80       	add    $0x80000000,%eax
8010691a:	0f 22 d8             	mov    %eax,%cr3
}
8010691d:	c3                   	ret    
8010691e:	66 90                	xchg   %ax,%ax

80106920 <switchuvm>:
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	53                   	push   %ebx
80106924:	83 ec 04             	sub    $0x4,%esp
80106927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010692a:	e8 c1 da ff ff       	call   801043f0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010692f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106935:	b9 67 00 00 00       	mov    $0x67,%ecx
8010693a:	8d 50 08             	lea    0x8(%eax),%edx
8010693d:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106944:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
8010694b:	89 d1                	mov    %edx,%ecx
8010694d:	c1 ea 18             	shr    $0x18,%edx
80106950:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106956:	ba 89 40 00 00       	mov    $0x4089,%edx
8010695b:	c1 e9 10             	shr    $0x10,%ecx
8010695e:	66 89 90 a5 00 00 00 	mov    %dx,0xa5(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106965:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010696c:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80106972:	b9 10 00 00 00       	mov    $0x10,%ecx
80106977:	66 89 48 10          	mov    %cx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010697b:	8b 52 08             	mov    0x8(%edx),%edx
8010697e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106984:	89 50 0c             	mov    %edx,0xc(%eax)
  cpu->ts.iomb = (ushort) 0xFFFF;
80106987:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010698c:	66 89 50 6e          	mov    %dx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106990:	b8 30 00 00 00       	mov    $0x30,%eax
80106995:	0f 00 d8             	ltr    %ax
  if(p->pgdir == 0)
80106998:	8b 43 04             	mov    0x4(%ebx),%eax
8010699b:	85 c0                	test   %eax,%eax
8010699d:	74 11                	je     801069b0 <switchuvm+0x90>
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010699f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069a4:	0f 22 d8             	mov    %eax,%cr3
}
801069a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069aa:	c9                   	leave  
  popcli();
801069ab:	e9 70 da ff ff       	jmp    80104420 <popcli>
    panic("switchuvm: no pgdir");
801069b0:	83 ec 0c             	sub    $0xc,%esp
801069b3:	68 6e 77 10 80       	push   $0x8010776e
801069b8:	e8 d3 99 ff ff       	call   80100390 <panic>
801069bd:	8d 76 00             	lea    0x0(%esi),%esi

801069c0 <inituvm>:
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 1c             	sub    $0x1c,%esp
801069c9:	8b 45 08             	mov    0x8(%ebp),%eax
801069cc:	8b 75 10             	mov    0x10(%ebp),%esi
801069cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
801069d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801069d5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801069db:	77 49                	ja     80106a26 <inituvm+0x66>
  mem = kalloc();
801069dd:	e8 ee bb ff ff       	call   801025d0 <kalloc>
  memset(mem, 0, PGSIZE);
801069e2:	83 ec 04             	sub    $0x4,%esp
801069e5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801069ea:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801069ec:	6a 00                	push   $0x0
801069ee:	50                   	push   %eax
801069ef:	e8 cc da ff ff       	call   801044c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801069f4:	58                   	pop    %eax
801069f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069fb:	5a                   	pop    %edx
801069fc:	6a 06                	push   $0x6
801069fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a03:	31 d2                	xor    %edx,%edx
80106a05:	50                   	push   %eax
80106a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a09:	e8 62 fc ff ff       	call   80106670 <mappages>
  memmove(mem, init, sz);
80106a0e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a11:	83 c4 10             	add    $0x10,%esp
80106a14:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a1d:	5b                   	pop    %ebx
80106a1e:	5e                   	pop    %esi
80106a1f:	5f                   	pop    %edi
80106a20:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a21:	e9 3a db ff ff       	jmp    80104560 <memmove>
    panic("inituvm: more than a page");
80106a26:	83 ec 0c             	sub    $0xc,%esp
80106a29:	68 82 77 10 80       	push   $0x80107782
80106a2e:	e8 5d 99 ff ff       	call   80100390 <panic>
80106a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a40 <loaduvm>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
80106a46:	83 ec 1c             	sub    $0x1c,%esp
80106a49:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a4c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106a4f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106a54:	0f 85 8d 00 00 00    	jne    80106ae7 <loaduvm+0xa7>
80106a5a:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106a5c:	89 f3                	mov    %esi,%ebx
80106a5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a61:	8b 45 14             	mov    0x14(%ebp),%eax
80106a64:	01 f0                	add    %esi,%eax
80106a66:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106a69:	85 f6                	test   %esi,%esi
80106a6b:	75 11                	jne    80106a7e <loaduvm+0x3e>
80106a6d:	eb 61                	jmp    80106ad0 <loaduvm+0x90>
80106a6f:	90                   	nop
80106a70:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106a76:	89 f0                	mov    %esi,%eax
80106a78:	29 d8                	sub    %ebx,%eax
80106a7a:	39 c6                	cmp    %eax,%esi
80106a7c:	76 52                	jbe    80106ad0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a81:	8b 45 08             	mov    0x8(%ebp),%eax
80106a84:	31 c9                	xor    %ecx,%ecx
80106a86:	29 da                	sub    %ebx,%edx
80106a88:	e8 63 fb ff ff       	call   801065f0 <walkpgdir>
80106a8d:	85 c0                	test   %eax,%eax
80106a8f:	74 49                	je     80106ada <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106a91:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a93:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106a96:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106a9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106aa0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106aa6:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106aa9:	29 d9                	sub    %ebx,%ecx
80106aab:	05 00 00 00 80       	add    $0x80000000,%eax
80106ab0:	57                   	push   %edi
80106ab1:	51                   	push   %ecx
80106ab2:	50                   	push   %eax
80106ab3:	ff 75 10             	pushl  0x10(%ebp)
80106ab6:	e8 45 af ff ff       	call   80101a00 <readi>
80106abb:	83 c4 10             	add    $0x10,%esp
80106abe:	39 f8                	cmp    %edi,%eax
80106ac0:	74 ae                	je     80106a70 <loaduvm+0x30>
}
80106ac2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106aca:	5b                   	pop    %ebx
80106acb:	5e                   	pop    %esi
80106acc:	5f                   	pop    %edi
80106acd:	5d                   	pop    %ebp
80106ace:	c3                   	ret    
80106acf:	90                   	nop
80106ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ad3:	31 c0                	xor    %eax,%eax
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106ada:	83 ec 0c             	sub    $0xc,%esp
80106add:	68 9c 77 10 80       	push   $0x8010779c
80106ae2:	e8 a9 98 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106ae7:	83 ec 0c             	sub    $0xc,%esp
80106aea:	68 40 78 10 80       	push   $0x80107840
80106aef:	e8 9c 98 ff ff       	call   80100390 <panic>
80106af4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106aff:	90                   	nop

80106b00 <allocuvm>:
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b09:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b0c:	85 ff                	test   %edi,%edi
80106b0e:	0f 88 bc 00 00 00    	js     80106bd0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106b14:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b17:	0f 82 a3 00 00 00    	jb     80106bc0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b20:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b26:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b2c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b2f:	0f 86 8e 00 00 00    	jbe    80106bc3 <allocuvm+0xc3>
80106b35:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b38:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b3b:	eb 42                	jmp    80106b7f <allocuvm+0x7f>
80106b3d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106b40:	83 ec 04             	sub    $0x4,%esp
80106b43:	68 00 10 00 00       	push   $0x1000
80106b48:	6a 00                	push   $0x0
80106b4a:	50                   	push   %eax
80106b4b:	e8 70 d9 ff ff       	call   801044c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b50:	58                   	pop    %eax
80106b51:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b57:	5a                   	pop    %edx
80106b58:	6a 06                	push   $0x6
80106b5a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b5f:	89 da                	mov    %ebx,%edx
80106b61:	50                   	push   %eax
80106b62:	89 f8                	mov    %edi,%eax
80106b64:	e8 07 fb ff ff       	call   80106670 <mappages>
80106b69:	83 c4 10             	add    $0x10,%esp
80106b6c:	85 c0                	test   %eax,%eax
80106b6e:	78 70                	js     80106be0 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106b70:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b76:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b79:	0f 86 a1 00 00 00    	jbe    80106c20 <allocuvm+0x120>
    mem = kalloc();
80106b7f:	e8 4c ba ff ff       	call   801025d0 <kalloc>
80106b84:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106b86:	85 c0                	test   %eax,%eax
80106b88:	75 b6                	jne    80106b40 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106b8a:	83 ec 0c             	sub    $0xc,%esp
80106b8d:	68 ba 77 10 80       	push   $0x801077ba
80106b92:	e8 19 9b ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106b97:	83 c4 10             	add    $0x10,%esp
80106b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b9d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106ba0:	74 2e                	je     80106bd0 <allocuvm+0xd0>
80106ba2:	89 c1                	mov    %eax,%ecx
80106ba4:	8b 55 10             	mov    0x10(%ebp),%edx
80106ba7:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106baa:	31 ff                	xor    %edi,%edi
80106bac:	e8 4f fb ff ff       	call   80106700 <deallocuvm.part.0>
}
80106bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bb4:	89 f8                	mov    %edi,%eax
80106bb6:	5b                   	pop    %ebx
80106bb7:	5e                   	pop    %esi
80106bb8:	5f                   	pop    %edi
80106bb9:	5d                   	pop    %ebp
80106bba:	c3                   	ret    
80106bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bbf:	90                   	nop
    return oldsz;
80106bc0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bc6:	89 f8                	mov    %edi,%eax
80106bc8:	5b                   	pop    %ebx
80106bc9:	5e                   	pop    %esi
80106bca:	5f                   	pop    %edi
80106bcb:	5d                   	pop    %ebp
80106bcc:	c3                   	ret    
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi
80106bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106bd3:	31 ff                	xor    %edi,%edi
}
80106bd5:	5b                   	pop    %ebx
80106bd6:	89 f8                	mov    %edi,%eax
80106bd8:	5e                   	pop    %esi
80106bd9:	5f                   	pop    %edi
80106bda:	5d                   	pop    %ebp
80106bdb:	c3                   	ret    
80106bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106be0:	83 ec 0c             	sub    $0xc,%esp
80106be3:	68 d2 77 10 80       	push   $0x801077d2
80106be8:	e8 c3 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106bed:	83 c4 10             	add    $0x10,%esp
80106bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bf3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106bf6:	74 0d                	je     80106c05 <allocuvm+0x105>
80106bf8:	89 c1                	mov    %eax,%ecx
80106bfa:	8b 55 10             	mov    0x10(%ebp),%edx
80106bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80106c00:	e8 fb fa ff ff       	call   80106700 <deallocuvm.part.0>
      kfree(mem);
80106c05:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c08:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c0a:	56                   	push   %esi
80106c0b:	e8 00 b8 ff ff       	call   80102410 <kfree>
      return 0;
80106c10:	83 c4 10             	add    $0x10,%esp
}
80106c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c16:	89 f8                	mov    %edi,%eax
80106c18:	5b                   	pop    %ebx
80106c19:	5e                   	pop    %esi
80106c1a:	5f                   	pop    %edi
80106c1b:	5d                   	pop    %ebp
80106c1c:	c3                   	ret    
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
80106c20:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c26:	5b                   	pop    %ebx
80106c27:	5e                   	pop    %esi
80106c28:	89 f8                	mov    %edi,%eax
80106c2a:	5f                   	pop    %edi
80106c2b:	5d                   	pop    %ebp
80106c2c:	c3                   	ret    
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi

80106c30 <deallocuvm>:
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c36:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c39:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106c3c:	39 d1                	cmp    %edx,%ecx
80106c3e:	73 10                	jae    80106c50 <deallocuvm+0x20>
}
80106c40:	5d                   	pop    %ebp
80106c41:	e9 ba fa ff ff       	jmp    80106700 <deallocuvm.part.0>
80106c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c4d:	8d 76 00             	lea    0x0(%esi),%esi
80106c50:	89 d0                	mov    %edx,%eax
80106c52:	5d                   	pop    %ebp
80106c53:	c3                   	ret    
80106c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c5f:	90                   	nop

80106c60 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	53                   	push   %ebx
80106c66:	83 ec 0c             	sub    $0xc,%esp
80106c69:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c6c:	85 f6                	test   %esi,%esi
80106c6e:	74 59                	je     80106cc9 <freevm+0x69>
  if(newsz >= oldsz)
80106c70:	31 c9                	xor    %ecx,%ecx
80106c72:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c77:	89 f0                	mov    %esi,%eax
80106c79:	89 f3                	mov    %esi,%ebx
80106c7b:	e8 80 fa ff ff       	call   80106700 <deallocuvm.part.0>
freevm(pde_t *pgdir)
80106c80:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106c86:	eb 0f                	jmp    80106c97 <freevm+0x37>
80106c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8f:	90                   	nop
80106c90:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c93:	39 df                	cmp    %ebx,%edi
80106c95:	74 23                	je     80106cba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106c97:	8b 03                	mov    (%ebx),%eax
80106c99:	a8 01                	test   $0x1,%al
80106c9b:	74 f3                	je     80106c90 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106c9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106ca2:	83 ec 0c             	sub    $0xc,%esp
80106ca5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ca8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106cad:	50                   	push   %eax
80106cae:	e8 5d b7 ff ff       	call   80102410 <kfree>
80106cb3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106cb6:	39 df                	cmp    %ebx,%edi
80106cb8:	75 dd                	jne    80106c97 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106cba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cc0:	5b                   	pop    %ebx
80106cc1:	5e                   	pop    %esi
80106cc2:	5f                   	pop    %edi
80106cc3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106cc4:	e9 47 b7 ff ff       	jmp    80102410 <kfree>
    panic("freevm: no pgdir");
80106cc9:	83 ec 0c             	sub    $0xc,%esp
80106ccc:	68 ee 77 10 80       	push   $0x801077ee
80106cd1:	e8 ba 96 ff ff       	call   80100390 <panic>
80106cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cdd:	8d 76 00             	lea    0x0(%esi),%esi

80106ce0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ce0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ce1:	31 c9                	xor    %ecx,%ecx
{
80106ce3:	89 e5                	mov    %esp,%ebp
80106ce5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cee:	e8 fd f8 ff ff       	call   801065f0 <walkpgdir>
  if(pte == 0)
80106cf3:	85 c0                	test   %eax,%eax
80106cf5:	74 05                	je     80106cfc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106cf7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106cfa:	c9                   	leave  
80106cfb:	c3                   	ret    
    panic("clearpteu");
80106cfc:	83 ec 0c             	sub    $0xc,%esp
80106cff:	68 ff 77 10 80       	push   $0x801077ff
80106d04:	e8 87 96 ff ff       	call   80100390 <panic>
80106d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106d19:	e8 62 fb ff ff       	call   80106880 <setupkvm>
80106d1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d21:	85 c0                	test   %eax,%eax
80106d23:	0f 84 a0 00 00 00    	je     80106dc9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d2c:	85 c9                	test   %ecx,%ecx
80106d2e:	0f 84 95 00 00 00    	je     80106dc9 <copyuvm+0xb9>
80106d34:	31 f6                	xor    %esi,%esi
80106d36:	eb 4e                	jmp    80106d86 <copyuvm+0x76>
80106d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106d40:	83 ec 04             	sub    $0x4,%esp
80106d43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106d49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d4c:	68 00 10 00 00       	push   $0x1000
80106d51:	57                   	push   %edi
80106d52:	50                   	push   %eax
80106d53:	e8 08 d8 ff ff       	call   80104560 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106d58:	58                   	pop    %eax
80106d59:	5a                   	pop    %edx
80106d5a:	53                   	push   %ebx
80106d5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d61:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d66:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d6c:	52                   	push   %edx
80106d6d:	89 f2                	mov    %esi,%edx
80106d6f:	e8 fc f8 ff ff       	call   80106670 <mappages>
80106d74:	83 c4 10             	add    $0x10,%esp
80106d77:	85 c0                	test   %eax,%eax
80106d79:	78 39                	js     80106db4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106d7b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d81:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106d84:	76 43                	jbe    80106dc9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106d86:	8b 45 08             	mov    0x8(%ebp),%eax
80106d89:	31 c9                	xor    %ecx,%ecx
80106d8b:	89 f2                	mov    %esi,%edx
80106d8d:	e8 5e f8 ff ff       	call   801065f0 <walkpgdir>
80106d92:	85 c0                	test   %eax,%eax
80106d94:	74 3e                	je     80106dd4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106d96:	8b 18                	mov    (%eax),%ebx
80106d98:	f6 c3 01             	test   $0x1,%bl
80106d9b:	74 44                	je     80106de1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106d9d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106d9f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106da5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106dab:	e8 20 b8 ff ff       	call   801025d0 <kalloc>
80106db0:	85 c0                	test   %eax,%eax
80106db2:	75 8c                	jne    80106d40 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106db4:	83 ec 0c             	sub    $0xc,%esp
80106db7:	ff 75 e0             	pushl  -0x20(%ebp)
80106dba:	e8 a1 fe ff ff       	call   80106c60 <freevm>
  return 0;
80106dbf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106dc6:	83 c4 10             	add    $0x10,%esp
}
80106dc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dcf:	5b                   	pop    %ebx
80106dd0:	5e                   	pop    %esi
80106dd1:	5f                   	pop    %edi
80106dd2:	5d                   	pop    %ebp
80106dd3:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106dd4:	83 ec 0c             	sub    $0xc,%esp
80106dd7:	68 09 78 10 80       	push   $0x80107809
80106ddc:	e8 af 95 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80106de1:	83 ec 0c             	sub    $0xc,%esp
80106de4:	68 23 78 10 80       	push   $0x80107823
80106de9:	e8 a2 95 ff ff       	call   80100390 <panic>
80106dee:	66 90                	xchg   %ax,%ax

80106df0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106df0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106df1:	31 c9                	xor    %ecx,%ecx
{
80106df3:	89 e5                	mov    %esp,%ebp
80106df5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106df8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dfe:	e8 ed f7 ff ff       	call   801065f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106e03:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106e05:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106e06:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106e08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106e0d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106e10:	05 00 00 00 80       	add    $0x80000000,%eax
80106e15:	83 fa 05             	cmp    $0x5,%edx
80106e18:	ba 00 00 00 00       	mov    $0x0,%edx
80106e1d:	0f 45 c2             	cmovne %edx,%eax
}
80106e20:	c3                   	ret    
80106e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2f:	90                   	nop

80106e30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	8b 75 14             	mov    0x14(%ebp),%esi
80106e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e3f:	85 f6                	test   %esi,%esi
80106e41:	75 38                	jne    80106e7b <copyout+0x4b>
80106e43:	eb 6b                	jmp    80106eb0 <copyout+0x80>
80106e45:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106e48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e4b:	89 fb                	mov    %edi,%ebx
80106e4d:	29 d3                	sub    %edx,%ebx
80106e4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106e55:	39 f3                	cmp    %esi,%ebx
80106e57:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106e5a:	29 fa                	sub    %edi,%edx
80106e5c:	83 ec 04             	sub    $0x4,%esp
80106e5f:	01 c2                	add    %eax,%edx
80106e61:	53                   	push   %ebx
80106e62:	ff 75 10             	pushl  0x10(%ebp)
80106e65:	52                   	push   %edx
80106e66:	e8 f5 d6 ff ff       	call   80104560 <memmove>
    len -= n;
    buf += n;
80106e6b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106e6e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106e74:	83 c4 10             	add    $0x10,%esp
80106e77:	29 de                	sub    %ebx,%esi
80106e79:	74 35                	je     80106eb0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106e7b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106e7d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106e80:	89 55 0c             	mov    %edx,0xc(%ebp)
80106e83:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106e89:	57                   	push   %edi
80106e8a:	ff 75 08             	pushl  0x8(%ebp)
80106e8d:	e8 5e ff ff ff       	call   80106df0 <uva2ka>
    if(pa0 == 0)
80106e92:	83 c4 10             	add    $0x10,%esp
80106e95:	85 c0                	test   %eax,%eax
80106e97:	75 af                	jne    80106e48 <copyout+0x18>
  }
  return 0;
}
80106e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ea1:	5b                   	pop    %ebx
80106ea2:	5e                   	pop    %esi
80106ea3:	5f                   	pop    %edi
80106ea4:	5d                   	pop    %ebp
80106ea5:	c3                   	ret    
80106ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ead:	8d 76 00             	lea    0x0(%esi),%esi
80106eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106eb3:	31 c0                	xor    %eax,%eax
}
80106eb5:	5b                   	pop    %ebx
80106eb6:	5e                   	pop    %esi
80106eb7:	5f                   	pop    %edi
80106eb8:	5d                   	pop    %ebp
80106eb9:	c3                   	ret    
