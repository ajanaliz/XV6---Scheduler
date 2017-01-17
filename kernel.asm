
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
8010002d:	b8 f0 2e 10 80       	mov    $0x80102ef0,%eax
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
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 20 72 10 80       	push   $0x80107220
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 e5 43 00 00       	call   80104440 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 72 10 80       	push   $0x80107227
80100097:	50                   	push   %eax
80100098:	e8 93 42 00 00       	call   80104330 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 77 43 00 00       	call   80104460 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 d9 44 00 00       	call   80104640 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 41 00 00       	call   80104370 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 1f 00 00       	call   801020f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 72 10 80       	push   $0x8010722e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 5d 42 00 00       	call   80104410 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 72 10 80       	push   $0x8010723f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 1c 42 00 00       	call   80104410 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 41 00 00       	call   801043d0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 50 42 00 00       	call   80104460 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 df 43 00 00       	jmp    80104640 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 72 10 80       	push   $0x80107246
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 cf 41 00 00       	call   80104460 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002a6:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 c0 ff 10 80       	push   $0x8010ffc0
801002bd:	e8 ee 3b 00 00       	call   80103eb0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(proc->killed){
801002d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002d8:	8b 40 40             	mov    0x40(%eax),%eax
801002db:	85 c0                	test   %eax,%eax
801002dd:	74 d1                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002df:	83 ec 0c             	sub    $0xc,%esp
801002e2:	68 20 a5 10 80       	push   $0x8010a520
801002e7:	e8 54 43 00 00       	call   80104640 <release>
        ilock(ip);
801002ec:	89 3c 24             	mov    %edi,(%esp)
801002ef:	e8 7c 13 00 00       	call   80101670 <ilock>
        return -1;
801002f4:	83 c4 10             	add    $0x10,%esp
801002f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002ff:	5b                   	pop    %ebx
80100300:	5e                   	pop    %esi
80100301:	5f                   	pop    %edi
80100302:	5d                   	pop    %ebp
80100303:	c3                   	ret    
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 ff 10 80 	movsbl -0x7fef00c0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 f5 42 00 00       	call   80104640 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a1                	jmp    801002fc <consoleread+0x8c>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
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
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100379:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
8010037f:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100386:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100389:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010038c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010038f:	0f b6 00             	movzbl (%eax),%eax
80100392:	50                   	push   %eax
80100393:	68 4d 72 10 80       	push   $0x8010724d
80100398:	e8 c3 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039d:	58                   	pop    %eax
8010039e:	ff 75 08             	pushl  0x8(%ebp)
801003a1:	e8 ba 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a6:	c7 04 24 46 77 10 80 	movl   $0x80107746,(%esp)
801003ad:	e8 ae 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b2:	5a                   	pop    %edx
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	59                   	pop    %ecx
801003b7:	53                   	push   %ebx
801003b8:	50                   	push   %eax
801003b9:	e8 72 41 00 00       	call   80104530 <getcallerpcs>
801003be:	83 c4 10             	add    $0x10,%esp
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	ff 33                	pushl  (%ebx)
801003cd:	83 c3 04             	add    $0x4,%ebx
801003d0:	68 69 72 10 80       	push   $0x80107269
801003d5:	e8 86 02 00 00       	call   80100660 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003da:	83 c4 10             	add    $0x10,%esp
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 f1 59 00 00       	call   80105e10 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 38 59 00 00       	call   80105e10 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 2c 59 00 00       	call   80105e10 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 20 59 00 00       	call   80105e10 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 27 42 00 00       	call   80104740 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 62 41 00 00       	call   80104690 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 6d 72 10 80       	push   $0x8010726d
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 98 72 10 80 	movzbl -0x7fef8d68(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 40 3e 00 00       	call   80104460 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 f4 3f 00 00       	call   80104640 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 2e 3f 00 00       	call   80104640 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 80 72 10 80       	mov    $0x80107280,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 93 3c 00 00       	call   80104460 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 87 72 10 80       	push   $0x80107287
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 58 3c 00 00       	call   80104460 <acquire>
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
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100836:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 d3 3d 00 00       	call   80104640 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008f1:	68 c0 ff 10 80       	push   $0x8010ffc0
801008f6:	e8 75 38 00 00       	call   80104170 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010090d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100934:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 f4 38 00 00       	jmp    80104270 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 90 72 10 80       	push   $0x80107290
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 8b 3a 00 00       	call   80104440 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bc:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009c3:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c6:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009cd:	02 10 80 
  cons.locking = 1;
801009d0:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d7:	00 00 00 

  picenable(IRQ_KBD);
801009da:	e8 d1 28 00 00       	call   801032b0 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009df:	58                   	pop    %eax
801009e0:	5a                   	pop    %edx
801009e1:	6a 00                	push   $0x0
801009e3:	6a 01                	push   $0x1
801009e5:	e8 c6 18 00 00       	call   801022b0 <ioapicenable>
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
801009fc:	e8 df 21 00 00       	call   80102be0 <begin_op>

  if((ip = namei(path)) == 0){
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	ff 75 08             	pushl  0x8(%ebp)
80100a07:	e8 a4 14 00 00       	call   80101eb0 <namei>
80100a0c:	83 c4 10             	add    $0x10,%esp
80100a0f:	85 c0                	test   %eax,%eax
80100a11:	0f 84 a3 01 00 00    	je     80100bba <exec+0x1ca>
    end_op();
    return -1;
  }
  ilock(ip);
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	89 c3                	mov    %eax,%ebx
80100a1c:	50                   	push   %eax
80100a1d:	e8 4e 0c 00 00       	call   80101670 <ilock>
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
80100a44:	e8 07 22 00 00       	call   80102c50 <end_op>
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
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 cf                	jne    80100a3b <exec+0x4b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 5f 61 00 00       	call   80106bd0 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a79:	74 c0                	je     80100a3b <exec+0x4b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a82:	00 
80100a83:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a89:	0f 84 ac 02 00 00    	je     80100d3b <exec+0x34b>
80100a8f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a96:	00 00 00 
80100a99:	31 ff                	xor    %edi,%edi
80100a9b:	eb 18                	jmp    80100ab5 <exec+0xc5>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
80100aa0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aa7:	83 c7 01             	add    $0x1,%edi
80100aaa:	83 c6 20             	add    $0x20,%esi
80100aad:	39 f8                	cmp    %edi,%eax
80100aaf:	0f 8e ab 00 00 00    	jle    80100b60 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ab5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100abb:	6a 20                	push   $0x20
80100abd:	56                   	push   %esi
80100abe:	50                   	push   %eax
80100abf:	53                   	push   %ebx
80100ac0:	e8 6b 0e 00 00       	call   80101930 <readi>
80100ac5:	83 c4 10             	add    $0x10,%esp
80100ac8:	83 f8 20             	cmp    $0x20,%eax
80100acb:	75 7b                	jne    80100b48 <exec+0x158>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100acd:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ad4:	75 ca                	jne    80100aa0 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ad6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100adc:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ae2:	72 64                	jb     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ae4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100aea:	72 5c                	jb     80100b48 <exec+0x158>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aec:	83 ec 04             	sub    $0x4,%esp
80100aef:	50                   	push   %eax
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100afc:	e8 5f 63 00 00       	call   80106e60 <allocuvm>
80100b01:	83 c4 10             	add    $0x10,%esp
80100b04:	85 c0                	test   %eax,%eax
80100b06:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b0c:	74 3a                	je     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b0e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b14:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b19:	75 2d                	jne    80100b48 <exec+0x158>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b1b:	83 ec 0c             	sub    $0xc,%esp
80100b1e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b24:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b2a:	53                   	push   %ebx
80100b2b:	50                   	push   %eax
80100b2c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b32:	e8 69 62 00 00       	call   80106da0 <loaduvm>
80100b37:	83 c4 20             	add    $0x20,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 89 5e ff ff ff    	jns    80100aa0 <exec+0xb0>
80100b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b48:	83 ec 0c             	sub    $0xc,%esp
80100b4b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b51:	e8 3a 64 00 00       	call   80106f90 <freevm>
80100b56:	83 c4 10             	add    $0x10,%esp
80100b59:	e9 dd fe ff ff       	jmp    80100a3b <exec+0x4b>
80100b5e:	66 90                	xchg   %ax,%ax
80100b60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100b6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100b72:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b78:	83 ec 0c             	sub    $0xc,%esp
80100b7b:	53                   	push   %ebx
80100b7c:	e8 5f 0d 00 00       	call   801018e0 <iunlockput>
  end_op();
80100b81:	e8 ca 20 00 00       	call   80102c50 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b86:	83 c4 0c             	add    $0xc,%esp
80100b89:	57                   	push   %edi
80100b8a:	56                   	push   %esi
80100b8b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b91:	e8 ca 62 00 00       	call   80106e60 <allocuvm>
80100b96:	83 c4 10             	add    $0x10,%esp
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	89 c6                	mov    %eax,%esi
80100b9d:	75 2a                	jne    80100bc9 <exec+0x1d9>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b9f:	83 ec 0c             	sub    $0xc,%esp
80100ba2:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba8:	e8 e3 63 00 00       	call   80106f90 <freevm>
80100bad:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb5:	e9 97 fe ff ff       	jmp    80100a51 <exec+0x61>
  pde_t *pgdir, *oldpgdir;

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bba:	e8 91 20 00 00       	call   80102c50 <end_op>
    return -1;
80100bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc4:	e9 88 fe ff ff       	jmp    80100a51 <exec+0x61>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bcf:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bd2:	31 ff                	xor    %edi,%edi
80100bd4:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd6:	50                   	push   %eax
80100bd7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bdd:	e8 2e 64 00 00       	call   80107010 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bee:	8b 00                	mov    (%eax),%eax
80100bf0:	85 c0                	test   %eax,%eax
80100bf2:	74 71                	je     80100c65 <exec+0x275>
80100bf4:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100bfa:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c00:	eb 0b                	jmp    80100c0d <exec+0x21d>
80100c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
80100c08:	83 ff 20             	cmp    $0x20,%edi
80100c0b:	74 92                	je     80100b9f <exec+0x1af>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0d:	83 ec 0c             	sub    $0xc,%esp
80100c10:	50                   	push   %eax
80100c11:	e8 ba 3c 00 00       	call   801048d0 <strlen>
80100c16:	f7 d0                	not    %eax
80100c18:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c1a:	58                   	pop    %eax
80100c1b:	8b 45 0c             	mov    0xc(%ebp),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c1e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c21:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c24:	e8 a7 3c 00 00       	call   801048d0 <strlen>
80100c29:	83 c0 01             	add    $0x1,%eax
80100c2c:	50                   	push   %eax
80100c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c30:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c33:	53                   	push   %ebx
80100c34:	56                   	push   %esi
80100c35:	e8 36 65 00 00       	call   80107170 <copyout>
80100c3a:	83 c4 20             	add    $0x20,%esp
80100c3d:	85 c0                	test   %eax,%eax
80100c3f:	0f 88 5a ff ff ff    	js     80100b9f <exec+0x1af>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c45:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c48:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c4f:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c52:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c5b:	85 c0                	test   %eax,%eax
80100c5d:	75 a9                	jne    80100c08 <exec+0x218>
80100c5f:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c65:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c6c:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c6e:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c75:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c79:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c80:	ff ff ff 
  ustack[1] = argc;
80100c83:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c89:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c8b:	83 c0 0c             	add    $0xc,%eax
80100c8e:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c90:	50                   	push   %eax
80100c91:	52                   	push   %edx
80100c92:	53                   	push   %ebx
80100c93:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c99:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9f:	e8 cc 64 00 00       	call   80107170 <copyout>
80100ca4:	83 c4 10             	add    $0x10,%esp
80100ca7:	85 c0                	test   %eax,%eax
80100ca9:	0f 88 f0 fe ff ff    	js     80100b9f <exec+0x1af>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100caf:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb2:	0f b6 10             	movzbl (%eax),%edx
80100cb5:	84 d2                	test   %dl,%dl
80100cb7:	74 1a                	je     80100cd3 <exec+0x2e3>
80100cb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbc:	83 c0 01             	add    $0x1,%eax
80100cbf:	90                   	nop
    if(*s == '/')
      last = s+1;
80100cc0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cc6:	0f 44 c8             	cmove  %eax,%ecx
80100cc9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccc:	84 d2                	test   %dl,%dl
80100cce:	75 f0                	jne    80100cc0 <exec+0x2d0>
80100cd0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd9:	83 ec 04             	sub    $0x4,%esp
80100cdc:	6a 10                	push   $0x10
80100cde:	ff 75 08             	pushl  0x8(%ebp)
80100ce1:	05 88 00 00 00       	add    $0x88,%eax
80100ce6:	50                   	push   %eax
80100ce7:	e8 a4 3b 00 00       	call   80104890 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100cf2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cf8:	8b 78 20             	mov    0x20(%eax),%edi
  proc->pgdir = pgdir;
  proc->sz = sz;
80100cfb:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
80100cfd:	89 48 20             	mov    %ecx,0x20(%eax)
  proc->sz = sz;

  proc->ctime = ticks;
80100d00:	8b 15 20 5c 11 80    	mov    0x80115c20,%edx
80100d06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d0c:	89 50 04             	mov    %edx,0x4(%eax)
  
  proc->tf->eip = elf.entry;  // main
80100d0f:	8b 50 34             	mov    0x34(%eax),%edx
80100d12:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d18:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d1b:	8b 50 34             	mov    0x34(%eax),%edx
80100d1e:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d21:	89 04 24             	mov    %eax,(%esp)
80100d24:	e8 57 5f 00 00       	call   80106c80 <switchuvm>
  freevm(oldpgdir);
80100d29:	89 3c 24             	mov    %edi,(%esp)
80100d2c:	e8 5f 62 00 00       	call   80106f90 <freevm>
  return 0;
80100d31:	83 c4 10             	add    $0x10,%esp
80100d34:	31 c0                	xor    %eax,%eax
80100d36:	e9 16 fd ff ff       	jmp    80100a51 <exec+0x61>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d3b:	bf 00 20 00 00       	mov    $0x2000,%edi
80100d40:	31 f6                	xor    %esi,%esi
80100d42:	e9 31 fe ff ff       	jmp    80100b78 <exec+0x188>
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 a9 72 10 80       	push   $0x801072a9
80100d5b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d60:	e8 db 36 00 00       	call   80104440 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d81:	e8 da 36 00 00       	call   80104460 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 e0 ff 10 80       	push   $0x8010ffe0
80100db1:	e8 8a 38 00 00       	call   80104640 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dc8:	e8 73 38 00 00       	call   80104640 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 e0 ff 10 80       	push   $0x8010ffe0
80100def:	e8 6c 36 00 00       	call   80104460 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e0c:	e8 2f 38 00 00       	call   80104640 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 b0 72 10 80       	push   $0x801072b0
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e41:	e8 1a 36 00 00       	call   80104460 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 cf 37 00 00       	jmp    80104640 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 e0 ff 10 80       	push   $0x8010ffe0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 a3 37 00 00       	call   80104640 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 ba 25 00 00       	call   80103480 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 0b 1d 00 00       	call   80102be0 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 c0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 61 1d 00 00       	jmp    80102c50 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 b8 72 10 80       	push   $0x801072b8
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 56 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 d9 09 00 00       	call   80101900 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 20 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 f1 06 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 a4 09 00 00       	call   80101930 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 ad 07 00 00       	call   80101750 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 8e 26 00 00       	jmp    80103650 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 c2 72 10 80       	push   $0x801072c2
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 17 07 00 00       	call   80101750 <iunlock>
      end_op();
80101039:	e8 12 1c 00 00       	call   80102c50 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 75 1b 00 00       	call   80102be0 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 fa 05 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 a8 09 00 00       	call   80101a30 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 b3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010109d:	e8 ae 1b 00 00       	call   80102c50 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 3f 24 00 00       	jmp    80103520 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 cb 72 10 80       	push   $0x801072cb
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 d1 72 10 80       	push   $0x801072d1
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 85 00 00 00    	je     8010119f <balloc+0x9f>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2d                	jmp    8010117a <balloc+0x7a>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
80101152:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101169:	85 d7                	test   %edx,%edi
8010116b:	74 43                	je     801011b0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116d:	83 c0 01             	add    $0x1,%eax
80101170:	83 c6 01             	add    $0x1,%esi
80101173:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101178:	74 05                	je     8010117f <balloc+0x7f>
8010117a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117d:	72 d1                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 75 e4             	pushl  -0x1c(%ebp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101197:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
8010119d:	77 82                	ja     80101121 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 db 72 10 80       	push   $0x801072db
801011a7:	e8 c4 f1 ff ff       	call   80100370 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	09 fa                	or     %edi,%edx
801011b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 fe 1b 00 00       	call   80102dc0 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 a6 34 00 00       	call   80104690 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 ce 1b 00 00       	call   80102dc0 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101225:	68 00 0a 11 80       	push   $0x80110a00
8010122a:	e8 31 32 00 00       	call   80104460 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101250:	74 4e                	je     801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101268:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126a:	68 00 0a 11 80       	push   $0x80110a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 c9 33 00 00       	call   80104640 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101299:	75 b7                	jne    80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 00 0a 11 80       	push   $0x80110a00
801012bf:	e8 7c 33 00 00       	call   80104640 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 f1 72 10 80       	push   $0x801072f1
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 83 00 00 00    	ja     80101397 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 6a                	je     80101388 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 6e 1a 00 00       	call   80102dc0 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101364:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 06                	mov    (%esi),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 71 fd ff ff       	call   80101100 <balloc>
8010138f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101395:	eb 87                	jmp    8010131e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101397:	83 ec 0c             	sub    $0xc,%esp
8010139a:	68 01 73 10 80       	push   $0x80107301
8010139f:	e8 cc ef ff ff       	call   80100370 <panic>
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 6a 33 00 00       	call   80104740 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 e0 09 11 80       	push   $0x801109e0
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101423:	ba 01 00 00 00       	mov    $0x1,%edx
80101428:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142b:	c1 fb 03             	sar    $0x3,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 27                	je     80101463 <bfree+0x73>
8010143c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143e:	f7 d2                	not    %edx
80101440:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101442:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101445:	21 d0                	and    %edx,%eax
80101447:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010144b:	56                   	push   %esi
8010144c:	e8 6f 19 00 00       	call   80102dc0 <log_write>
  brelse(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101463:	83 ec 0c             	sub    $0xc,%esp
80101466:	68 14 73 10 80       	push   $0x80107314
8010146b:	e8 00 ef ff ff       	call   80100370 <panic>

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	68 27 73 10 80       	push   $0x80107327
80101481:	68 00 0a 11 80       	push   $0x80110a00
80101486:	e8 b5 2f 00 00       	call   80104440 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 2e 73 10 80       	push   $0x8010732e
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 8c 2e 00 00       	call   80104330 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 e0 09 11 80       	push   $0x801109e0
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 f8 09 11 80    	pushl  0x801109f8
801014c5:	ff 35 f4 09 11 80    	pushl  0x801109f4
801014cb:	ff 35 f0 09 11 80    	pushl  0x801109f0
801014d1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801014d7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801014dd:	ff 35 e4 09 11 80    	pushl  0x801109e4
801014e3:	ff 35 e0 09 11 80    	pushl  0x801109e0
801014e9:	68 84 73 10 80       	push   $0x80107384
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 0d 31 00 00       	call   80104690 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 2b 18 00 00       	call   80102dc0 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 34 73 10 80       	push   $0x80107334
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 1a 31 00 00       	call   80104740 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 92 17 00 00       	call   80102dc0 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 00 0a 11 80       	push   $0x80110a00
8010164f:	e8 0c 2e 00 00       	call   80104460 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010165f:	e8 dc 2f 00 00       	call   80104640 <release>
  return ip;
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b4 00 00 00    	je     80101734 <ilock+0xc4>
80101680:	8b 43 08             	mov    0x8(%ebx),%eax
80101683:	85 c0                	test   %eax,%eax
80101685:	0f 8e a9 00 00 00    	jle    80101734 <ilock+0xc4>
    panic("ilock");

  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 d9 2c 00 00       	call   80104370 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101697:	83 c4 10             	add    $0x10,%esp
8010169a:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
8010169e:	74 10                	je     801016b0 <ilock+0x40>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a3:	5b                   	pop    %ebx
801016a4:	5e                   	pop    %esi
801016a5:	5d                   	pop    %ebp
801016a6:	c3                   	ret    
801016a7:	89 f6                	mov    %esi,%esi
801016a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 33 30 00 00       	call   80104740 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101715:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
80101719:	83 c4 10             	add    $0x10,%esp
8010171c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101721:	0f 85 79 ff ff ff    	jne    801016a0 <ilock+0x30>
      panic("ilock: no type");
80101727:	83 ec 0c             	sub    $0xc,%esp
8010172a:	68 4c 73 10 80       	push   $0x8010734c
8010172f:	e8 3c ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101734:	83 ec 0c             	sub    $0xc,%esp
80101737:	68 46 73 10 80       	push   $0x80107346
8010173c:	e8 2f ec ff ff       	call   80100370 <panic>
80101741:	eb 0d                	jmp    80101750 <iunlock>
80101743:	90                   	nop
80101744:	90                   	nop
80101745:	90                   	nop
80101746:	90                   	nop
80101747:	90                   	nop
80101748:	90                   	nop
80101749:	90                   	nop
8010174a:	90                   	nop
8010174b:	90                   	nop
8010174c:	90                   	nop
8010174d:	90                   	nop
8010174e:	90                   	nop
8010174f:	90                   	nop

80101750 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 a8 2c 00 00       	call   80104410 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010177f:	e9 4c 2c 00 00       	jmp    801043d0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 5b 73 10 80       	push   $0x8010735b
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
801017ac:	68 00 0a 11 80       	push   $0x80110a00
801017b1:	e8 aa 2c 00 00       	call   80104460 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017b6:	8b 46 08             	mov    0x8(%esi),%eax
801017b9:	83 c4 10             	add    $0x10,%esp
801017bc:	83 f8 01             	cmp    $0x1,%eax
801017bf:	74 1f                	je     801017e0 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801017c1:	83 e8 01             	sub    $0x1,%eax
801017c4:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801017c7:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
801017ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017d1:	5b                   	pop    %ebx
801017d2:	5e                   	pop    %esi
801017d3:	5f                   	pop    %edi
801017d4:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
801017d5:	e9 66 2e 00 00       	jmp    80104640 <release>
801017da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017e0:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
801017e4:	74 db                	je     801017c1 <iput+0x21>
801017e6:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017eb:	75 d4                	jne    801017c1 <iput+0x21>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
801017ed:	83 ec 0c             	sub    $0xc,%esp
801017f0:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801017f3:	8d be 8c 00 00 00    	lea    0x8c(%esi),%edi
801017f9:	68 00 0a 11 80       	push   $0x80110a00
801017fe:	e8 3d 2e 00 00       	call   80104640 <release>
80101803:	83 c4 10             	add    $0x10,%esp
80101806:	eb 0f                	jmp    80101817 <iput+0x77>
80101808:	90                   	nop
80101809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101810:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101813:	39 fb                	cmp    %edi,%ebx
80101815:	74 19                	je     80101830 <iput+0x90>
    if(ip->addrs[i]){
80101817:	8b 13                	mov    (%ebx),%edx
80101819:	85 d2                	test   %edx,%edx
8010181b:	74 f3                	je     80101810 <iput+0x70>
      bfree(ip->dev, ip->addrs[i]);
8010181d:	8b 06                	mov    (%esi),%eax
8010181f:	e8 cc fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101824:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010182a:	eb e4                	jmp    80101810 <iput+0x70>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101830:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101836:	85 c0                	test   %eax,%eax
80101838:	75 46                	jne    80101880 <iput+0xe0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010183a:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010183d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101844:	56                   	push   %esi
80101845:	e8 76 fd ff ff       	call   801015c0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
8010184a:	31 c0                	xor    %eax,%eax
8010184c:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
80101850:	89 34 24             	mov    %esi,(%esp)
80101853:	e8 68 fd ff ff       	call   801015c0 <iupdate>
    acquire(&icache.lock);
80101858:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010185f:	e8 fc 2b 00 00       	call   80104460 <acquire>
    ip->flags = 0;
80101864:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010186b:	8b 46 08             	mov    0x8(%esi),%eax
8010186e:	83 c4 10             	add    $0x10,%esp
80101871:	e9 4b ff ff ff       	jmp    801017c1 <iput+0x21>
80101876:	8d 76 00             	lea    0x0(%esi),%esi
80101879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101880:	83 ec 08             	sub    $0x8,%esp
80101883:	50                   	push   %eax
80101884:	ff 36                	pushl  (%esi)
80101886:	e8 45 e8 ff ff       	call   801000d0 <bread>
8010188b:	83 c4 10             	add    $0x10,%esp
8010188e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101891:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101894:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
8010189a:	eb 0b                	jmp    801018a7 <iput+0x107>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018a0:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018a3:	39 df                	cmp    %ebx,%edi
801018a5:	74 0f                	je     801018b6 <iput+0x116>
      if(a[j])
801018a7:	8b 13                	mov    (%ebx),%edx
801018a9:	85 d2                	test   %edx,%edx
801018ab:	74 f3                	je     801018a0 <iput+0x100>
        bfree(ip->dev, a[j]);
801018ad:	8b 06                	mov    (%esi),%eax
801018af:	e8 3c fb ff ff       	call   801013f0 <bfree>
801018b4:	eb ea                	jmp    801018a0 <iput+0x100>
    }
    brelse(bp);
801018b6:	83 ec 0c             	sub    $0xc,%esp
801018b9:	ff 75 e4             	pushl  -0x1c(%ebp)
801018bc:	e8 1f e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018c1:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018c7:	8b 06                	mov    (%esi),%eax
801018c9:	e8 22 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018ce:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018d5:	00 00 00 
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	e9 5a ff ff ff       	jmp    8010183a <iput+0x9a>

801018e0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	53                   	push   %ebx
801018e4:	83 ec 10             	sub    $0x10,%esp
801018e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018ea:	53                   	push   %ebx
801018eb:	e8 60 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
801018f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018f3:	83 c4 10             	add    $0x10,%esp
}
801018f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018f9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018fa:	e9 a1 fe ff ff       	jmp    801017a0 <iput>
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
80101914:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101918:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010191b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010191f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101923:	8b 52 58             	mov    0x58(%edx),%edx
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
8010193c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010193f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101942:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101947:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010194a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010194d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101950:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101953:	0f 84 a7 00 00 00    	je     80101a00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101959:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010195c:	8b 40 58             	mov    0x58(%eax),%eax
8010195f:	39 f0                	cmp    %esi,%eax
80101961:	0f 82 c1 00 00 00    	jb     80101a28 <readi+0xf8>
80101967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010196a:	89 fa                	mov    %edi,%edx
8010196c:	01 f2                	add    %esi,%edx
8010196e:	0f 82 b4 00 00 00    	jb     80101a28 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101974:	89 c1                	mov    %eax,%ecx
80101976:	29 f1                	sub    %esi,%ecx
80101978:	39 d0                	cmp    %edx,%eax
8010197a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010197d:	31 ff                	xor    %edi,%edi
8010197f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101981:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101984:	74 6d                	je     801019f3 <readi+0xc3>
80101986:	8d 76 00             	lea    0x0(%esi),%esi
80101989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101990:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101993:	89 f2                	mov    %esi,%edx
80101995:	c1 ea 09             	shr    $0x9,%edx
80101998:	89 d8                	mov    %ebx,%eax
8010199a:	e8 41 f9 ff ff       	call   801012e0 <bmap>
8010199f:	83 ec 08             	sub    $0x8,%esp
801019a2:	50                   	push   %eax
801019a3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019a5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019aa:	e8 21 e7 ff ff       	call   801000d0 <bread>
801019af:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019b4:	89 f1                	mov    %esi,%ecx
801019b6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019bc:	83 c4 0c             	add    $0xc,%esp
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019c2:	29 cb                	sub    %ecx,%ebx
801019c4:	29 f8                	sub    %edi,%eax
801019c6:	39 c3                	cmp    %eax,%ebx
801019c8:	0f 47 d8             	cmova  %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019cb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019cf:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d0:	01 df                	add    %ebx,%edi
801019d2:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019d4:	50                   	push   %eax
801019d5:	ff 75 e0             	pushl  -0x20(%ebp)
801019d8:	e8 63 2d 00 00       	call   80104740 <memmove>
    brelse(bp);
801019dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019e0:	89 14 24             	mov    %edx,(%esp)
801019e3:	e8 f8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019f1:	77 9d                	ja     80101990 <readi+0x60>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019f9:	5b                   	pop    %ebx
801019fa:	5e                   	pop    %esi
801019fb:	5f                   	pop    %edi
801019fc:	5d                   	pop    %ebp
801019fd:	c3                   	ret    
801019fe:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a04:	66 83 f8 09          	cmp    $0x9,%ax
80101a08:	77 1e                	ja     80101a28 <readi+0xf8>
80101a0a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a11:	85 c0                	test   %eax,%eax
80101a13:	74 13                	je     80101a28 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a15:	89 7d 10             	mov    %edi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a1b:	5b                   	pop    %ebx
80101a1c:	5e                   	pop    %esi
80101a1d:	5f                   	pop    %edi
80101a1e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a1f:	ff e0                	jmp    *%eax
80101a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a2d:	eb c7                	jmp    801019f6 <readi+0xc6>
80101a2f:	90                   	nop

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
80101a42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a50:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a53:	0f 84 b7 00 00 00    	je     80101b10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a5c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a5f:	0f 82 eb 00 00 00    	jb     80101b50 <writei+0x120>
80101a65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a68:	89 f8                	mov    %edi,%eax
80101a6a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a6c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a71:	0f 87 d9 00 00 00    	ja     80101b50 <writei+0x120>
80101a77:	39 c6                	cmp    %eax,%esi
80101a79:	0f 87 d1 00 00 00    	ja     80101b50 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a7f:	85 ff                	test   %edi,%edi
80101a81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a88:	74 78                	je     80101b02 <writei+0xd2>
80101a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a93:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a95:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a9a:	c1 ea 09             	shr    $0x9,%edx
80101a9d:	89 f8                	mov    %edi,%eax
80101a9f:	e8 3c f8 ff ff       	call   801012e0 <bmap>
80101aa4:	83 ec 08             	sub    $0x8,%esp
80101aa7:	50                   	push   %eax
80101aa8:	ff 37                	pushl  (%edi)
80101aaa:	e8 21 e6 ff ff       	call   801000d0 <bread>
80101aaf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ab4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ab7:	89 f1                	mov    %esi,%ecx
80101ab9:	83 c4 0c             	add    $0xc,%esp
80101abc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ac2:	29 cb                	sub    %ecx,%ebx
80101ac4:	39 c3                	cmp    %eax,%ebx
80101ac6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ac9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101acd:	53                   	push   %ebx
80101ace:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ad3:	50                   	push   %eax
80101ad4:	e8 67 2c 00 00       	call   80104740 <memmove>
    log_write(bp);
80101ad9:	89 3c 24             	mov    %edi,(%esp)
80101adc:	e8 df 12 00 00       	call   80102dc0 <log_write>
    brelse(bp);
80101ae1:	89 3c 24             	mov    %edi,(%esp)
80101ae4:	e8 f7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101aec:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aef:	83 c4 10             	add    $0x10,%esp
80101af2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101af5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101af8:	77 96                	ja     80101a90 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101afa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afd:	3b 70 58             	cmp    0x58(%eax),%esi
80101b00:	77 36                	ja     80101b38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b08:	5b                   	pop    %ebx
80101b09:	5e                   	pop    %esi
80101b0a:	5f                   	pop    %edi
80101b0b:	5d                   	pop    %ebp
80101b0c:	c3                   	ret    
80101b0d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b14:	66 83 f8 09          	cmp    $0x9,%ax
80101b18:	77 36                	ja     80101b50 <writei+0x120>
80101b1a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b21:	85 c0                	test   %eax,%eax
80101b23:	74 2b                	je     80101b50 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b25:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2b:	5b                   	pop    %ebx
80101b2c:	5e                   	pop    %esi
80101b2d:	5f                   	pop    %edi
80101b2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b2f:	ff e0                	jmp    *%eax
80101b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b38:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b3b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b3e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b41:	50                   	push   %eax
80101b42:	e8 79 fa ff ff       	call   801015c0 <iupdate>
80101b47:	83 c4 10             	add    $0x10,%esp
80101b4a:	eb b6                	jmp    80101b02 <writei+0xd2>
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b55:	eb ae                	jmp    80101b05 <writei+0xd5>
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
80101b6e:	e8 4d 2c 00 00       	call   801047c0 <strncmp>
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
80101b8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b91:	0f 85 80 00 00 00    	jne    80101c17 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b97:	8b 53 58             	mov    0x58(%ebx),%edx
80101b9a:	31 ff                	xor    %edi,%edi
80101b9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b9f:	85 d2                	test   %edx,%edx
80101ba1:	75 0d                	jne    80101bb0 <dirlookup+0x30>
80101ba3:	eb 5b                	jmp    80101c00 <dirlookup+0x80>
80101ba5:	8d 76 00             	lea    0x0(%esi),%esi
80101ba8:	83 c7 10             	add    $0x10,%edi
80101bab:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bae:	76 50                	jbe    80101c00 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bb0:	6a 10                	push   $0x10
80101bb2:	57                   	push   %edi
80101bb3:	56                   	push   %esi
80101bb4:	53                   	push   %ebx
80101bb5:	e8 76 fd ff ff       	call   80101930 <readi>
80101bba:	83 c4 10             	add    $0x10,%esp
80101bbd:	83 f8 10             	cmp    $0x10,%eax
80101bc0:	75 48                	jne    80101c0a <dirlookup+0x8a>
      panic("dirlink read");
    if(de.inum == 0)
80101bc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bc7:	74 df                	je     80101ba8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bc9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bcc:	83 ec 04             	sub    $0x4,%esp
80101bcf:	6a 0e                	push   $0xe
80101bd1:	50                   	push   %eax
80101bd2:	ff 75 0c             	pushl  0xc(%ebp)
80101bd5:	e8 e6 2b 00 00       	call   801047c0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	85 c0                	test   %eax,%eax
80101bdf:	75 c7                	jne    80101ba8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101be1:	8b 45 10             	mov    0x10(%ebp),%eax
80101be4:	85 c0                	test   %eax,%eax
80101be6:	74 05                	je     80101bed <dirlookup+0x6d>
        *poff = off;
80101be8:	8b 45 10             	mov    0x10(%ebp),%eax
80101beb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bed:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101bf1:	8b 03                	mov    (%ebx),%eax
80101bf3:	e8 18 f6 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
80101bff:	c3                   	ret    
80101c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c03:	31 c0                	xor    %eax,%eax
}
80101c05:	5b                   	pop    %ebx
80101c06:	5e                   	pop    %esi
80101c07:	5f                   	pop    %edi
80101c08:	5d                   	pop    %ebp
80101c09:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c0a:	83 ec 0c             	sub    $0xc,%esp
80101c0d:	68 75 73 10 80       	push   $0x80107375
80101c12:	e8 59 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c17:	83 ec 0c             	sub    $0xc,%esp
80101c1a:	68 63 73 10 80       	push   $0x80107363
80101c1f:	e8 4c e7 ff ff       	call   80100370 <panic>
80101c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c40:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c43:	0f 84 63 01 00 00    	je     80101dac <namex+0x17c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c4f:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c52:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c58:	68 00 0a 11 80       	push   $0x80110a00
80101c5d:	e8 fe 27 00 00       	call   80104460 <acquire>
  ip->ref++;
80101c62:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c66:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c6d:	e8 ce 29 00 00       	call   80104640 <release>
80101c72:	83 c4 10             	add    $0x10,%esp
80101c75:	eb 0c                	jmp    80101c83 <namex+0x53>
80101c77:	89 f6                	mov    %esi,%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c80:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c83:	0f b6 03             	movzbl (%ebx),%eax
80101c86:	3c 2f                	cmp    $0x2f,%al
80101c88:	74 f6                	je     80101c80 <namex+0x50>
    path++;
  if(*path == 0)
80101c8a:	84 c0                	test   %al,%al
80101c8c:	0f 84 eb 00 00 00    	je     80101d7d <namex+0x14d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c92:	0f b6 03             	movzbl (%ebx),%eax
80101c95:	89 da                	mov    %ebx,%edx
80101c97:	84 c0                	test   %al,%al
80101c99:	0f 84 b4 00 00 00    	je     80101d53 <namex+0x123>
80101c9f:	3c 2f                	cmp    $0x2f,%al
80101ca1:	75 11                	jne    80101cb4 <namex+0x84>
80101ca3:	e9 ab 00 00 00       	jmp    80101d53 <namex+0x123>
80101ca8:	90                   	nop
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cb0:	84 c0                	test   %al,%al
80101cb2:	74 0a                	je     80101cbe <namex+0x8e>
    path++;
80101cb4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb7:	0f b6 02             	movzbl (%edx),%eax
80101cba:	3c 2f                	cmp    $0x2f,%al
80101cbc:	75 f2                	jne    80101cb0 <namex+0x80>
80101cbe:	89 d1                	mov    %edx,%ecx
80101cc0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cc2:	83 f9 0d             	cmp    $0xd,%ecx
80101cc5:	0f 8e 8d 00 00 00    	jle    80101d58 <namex+0x128>
    memmove(name, s, DIRSIZ);
80101ccb:	83 ec 04             	sub    $0x4,%esp
80101cce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cd1:	6a 0e                	push   $0xe
80101cd3:	53                   	push   %ebx
80101cd4:	57                   	push   %edi
80101cd5:	e8 66 2a 00 00       	call   80104740 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cdd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101ce0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ce2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ce5:	75 11                	jne    80101cf8 <namex+0xc8>
80101ce7:	89 f6                	mov    %esi,%esi
80101ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cf6:	74 f8                	je     80101cf0 <namex+0xc0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
80101cfb:	56                   	push   %esi
80101cfc:	e8 6f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d01:	83 c4 10             	add    $0x10,%esp
80101d04:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d09:	0f 85 7f 00 00 00    	jne    80101d8e <namex+0x15e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d12:	85 d2                	test   %edx,%edx
80101d14:	74 09                	je     80101d1f <namex+0xef>
80101d16:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d19:	0f 84 a3 00 00 00    	je     80101dc2 <namex+0x192>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d1f:	83 ec 04             	sub    $0x4,%esp
80101d22:	6a 00                	push   $0x0
80101d24:	57                   	push   %edi
80101d25:	56                   	push   %esi
80101d26:	e8 55 fe ff ff       	call   80101b80 <dirlookup>
80101d2b:	83 c4 10             	add    $0x10,%esp
80101d2e:	85 c0                	test   %eax,%eax
80101d30:	74 5c                	je     80101d8e <namex+0x15e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d32:	83 ec 0c             	sub    $0xc,%esp
80101d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d38:	56                   	push   %esi
80101d39:	e8 12 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d3e:	89 34 24             	mov    %esi,(%esp)
80101d41:	e8 5a fa ff ff       	call   801017a0 <iput>
80101d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d49:	83 c4 10             	add    $0x10,%esp
80101d4c:	89 c6                	mov    %eax,%esi
80101d4e:	e9 30 ff ff ff       	jmp    80101c83 <namex+0x53>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d53:	31 c9                	xor    %ecx,%ecx
80101d55:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d58:	83 ec 04             	sub    $0x4,%esp
80101d5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d5e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d61:	51                   	push   %ecx
80101d62:	53                   	push   %ebx
80101d63:	57                   	push   %edi
80101d64:	e8 d7 29 00 00       	call   80104740 <memmove>
    name[len] = 0;
80101d69:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d76:	89 d3                	mov    %edx,%ebx
80101d78:	e9 65 ff ff ff       	jmp    80101ce2 <namex+0xb2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d80:	85 c0                	test   %eax,%eax
80101d82:	75 54                	jne    80101dd8 <namex+0x1a8>
80101d84:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d89:	5b                   	pop    %ebx
80101d8a:	5e                   	pop    %esi
80101d8b:	5f                   	pop    %edi
80101d8c:	5d                   	pop    %ebp
80101d8d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	56                   	push   %esi
80101d92:	e8 b9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 01 fa ff ff       	call   801017a0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d9f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101da5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da7:	5b                   	pop    %ebx
80101da8:	5e                   	pop    %esi
80101da9:	5f                   	pop    %edi
80101daa:	5d                   	pop    %ebp
80101dab:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dac:	ba 01 00 00 00       	mov    $0x1,%edx
80101db1:	b8 01 00 00 00       	mov    $0x1,%eax
80101db6:	e8 55 f4 ff ff       	call   80101210 <iget>
80101dbb:	89 c6                	mov    %eax,%esi
80101dbd:	e9 c1 fe ff ff       	jmp    80101c83 <namex+0x53>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	56                   	push   %esi
80101dc6:	e8 85 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101dcb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dd1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd3:	5b                   	pop    %ebx
80101dd4:	5e                   	pop    %esi
80101dd5:	5f                   	pop    %edi
80101dd6:	5d                   	pop    %ebp
80101dd7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	56                   	push   %esi
80101ddc:	e8 bf f9 ff ff       	call   801017a0 <iput>
    return 0;
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	31 c0                	xor    %eax,%eax
80101de6:	eb 9e                	jmp    80101d86 <namex+0x156>
80101de8:	90                   	nop
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 20             	sub    $0x20,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	6a 00                	push   $0x0
80101dfe:	ff 75 0c             	pushl  0xc(%ebp)
80101e01:	53                   	push   %ebx
80101e02:	e8 79 fd ff ff       	call   80101b80 <dirlookup>
80101e07:	83 c4 10             	add    $0x10,%esp
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	75 67                	jne    80101e75 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e14:	85 ff                	test   %edi,%edi
80101e16:	74 29                	je     80101e41 <dirlink+0x51>
80101e18:	31 ff                	xor    %edi,%edi
80101e1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e1d:	eb 09                	jmp    80101e28 <dirlink+0x38>
80101e1f:	90                   	nop
80101e20:	83 c7 10             	add    $0x10,%edi
80101e23:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e26:	76 19                	jbe    80101e41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e28:	6a 10                	push   $0x10
80101e2a:	57                   	push   %edi
80101e2b:	56                   	push   %esi
80101e2c:	53                   	push   %ebx
80101e2d:	e8 fe fa ff ff       	call   80101930 <readi>
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	83 f8 10             	cmp    $0x10,%eax
80101e38:	75 4e                	jne    80101e88 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e3f:	75 df                	jne    80101e20 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e44:	83 ec 04             	sub    $0x4,%esp
80101e47:	6a 0e                	push   $0xe
80101e49:	ff 75 0c             	pushl  0xc(%ebp)
80101e4c:	50                   	push   %eax
80101e4d:	e8 de 29 00 00       	call   80104830 <strncpy>
  de.inum = inum;
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e55:	6a 10                	push   $0x10
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5e:	e8 cd fb ff ff       	call   80101a30 <writei>
80101e63:	83 c4 20             	add    $0x20,%esp
80101e66:	83 f8 10             	cmp    $0x10,%eax
80101e69:	75 2a                	jne    80101e95 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e6b:	31 c0                	xor    %eax,%eax
}
80101e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	50                   	push   %eax
80101e79:	e8 22 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb e5                	jmp    80101e6d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	68 75 73 10 80       	push   $0x80107375
80101e90:	e8 db e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	68 4a 79 10 80       	push   $0x8010794a
80101e9d:	e8 ce e4 ff ff       	call   80100370 <panic>
80101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101eb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101eb3:	89 e5                	mov    %esp,%ebp
80101eb5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
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
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ed6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ede:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
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
  if(b == 0)
80101ef1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	56                   	push   %esi
80101ef6:	53                   	push   %ebx
  if(b == 0)
80101ef7:	0f 84 ad 00 00 00    	je     80101faa <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101efd:	8b 58 08             	mov    0x8(%eax),%ebx
80101f00:	89 c1                	mov    %eax,%ecx
80101f02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f08:	0f 87 8f 00 00 00    	ja     80101f9d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f0e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f13:	90                   	nop
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f18:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f19:	83 e0 c0             	and    $0xffffffc0,%eax
80101f1c:	3c 40                	cmp    $0x40,%al
80101f1e:	75 f8                	jne    80101f18 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f20:	31 f6                	xor    %esi,%esi
80101f22:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f27:	89 f0                	mov    %esi,%eax
80101f29:	ee                   	out    %al,(%dx)
80101f2a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f2f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f34:	ee                   	out    %al,(%dx)
80101f35:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f3a:	89 d8                	mov    %ebx,%eax
80101f3c:	ee                   	out    %al,(%dx)
80101f3d:	89 d8                	mov    %ebx,%eax
80101f3f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f44:	c1 f8 08             	sar    $0x8,%eax
80101f47:	ee                   	out    %al,(%dx)
80101f48:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f4d:	89 f0                	mov    %esi,%eax
80101f4f:	ee                   	out    %al,(%dx)
80101f50:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f59:	83 e0 01             	and    $0x1,%eax
80101f5c:	c1 e0 04             	shl    $0x4,%eax
80101f5f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f62:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f63:	f6 01 04             	testb  $0x4,(%ecx)
80101f66:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f6b:	75 13                	jne    80101f80 <idestart+0x90>
80101f6d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f72:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f76:	5b                   	pop    %ebx
80101f77:	5e                   	pop    %esi
80101f78:	5d                   	pop    %ebp
80101f79:	c3                   	ret    
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f80:	b8 30 00 00 00       	mov    $0x30,%eax
80101f85:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f86:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f8b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f8e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f93:	fc                   	cld    
80101f94:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5d                   	pop    %ebp
80101f9c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f9d:	83 ec 0c             	sub    $0xc,%esp
80101fa0:	68 e0 73 10 80       	push   $0x801073e0
80101fa5:	e8 c6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101faa:	83 ec 0c             	sub    $0xc,%esp
80101fad:	68 d7 73 10 80       	push   $0x801073d7
80101fb2:	e8 b9 e3 ff ff       	call   80100370 <panic>
80101fb7:	89 f6                	mov    %esi,%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fc6:	68 f2 73 10 80       	push   $0x801073f2
80101fcb:	68 80 a5 10 80       	push   $0x8010a580
80101fd0:	e8 6b 24 00 00       	call   80104440 <initlock>
  picenable(IRQ_IDE);
80101fd5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101fdc:	e8 cf 12 00 00       	call   801032b0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fe1:	58                   	pop    %eax
80101fe2:	a1 80 2d 11 80       	mov    0x80112d80,%eax
80101fe7:	5a                   	pop    %edx
80101fe8:	83 e8 01             	sub    $0x1,%eax
80101feb:	50                   	push   %eax
80101fec:	6a 0e                	push   $0xe
80101fee:	e8 bd 02 00 00       	call   801022b0 <ioapicenable>
80101ff3:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ff6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ffb:	90                   	nop
80101ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102000:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102001:	83 e0 c0             	and    $0xffffffc0,%eax
80102004:	3c 40                	cmp    $0x40,%al
80102006:	75 f8                	jne    80102000 <ideinit+0x40>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102008:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010200d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102018:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010201d:	eb 06                	jmp    80102025 <ideinit+0x65>
8010201f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102020:	83 e9 01             	sub    $0x1,%ecx
80102023:	74 0f                	je     80102034 <ideinit+0x74>
80102025:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102026:	84 c0                	test   %al,%al
80102028:	74 f6                	je     80102020 <ideinit+0x60>
      havedisk1 = 1;
8010202a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102031:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010203e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    
80102041:	eb 0d                	jmp    80102050 <ideintr>
80102043:	90                   	nop
80102044:	90                   	nop
80102045:	90                   	nop
80102046:	90                   	nop
80102047:	90                   	nop
80102048:	90                   	nop
80102049:	90                   	nop
8010204a:	90                   	nop
8010204b:	90                   	nop
8010204c:	90                   	nop
8010204d:	90                   	nop
8010204e:	90                   	nop
8010204f:	90                   	nop

80102050 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	68 80 a5 10 80       	push   $0x8010a580
8010205e:	e8 fd 23 00 00       	call   80104460 <acquire>
  if((b = idequeue) == 0){
80102063:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	85 db                	test   %ebx,%ebx
8010206e:	74 34                	je     801020a4 <ideintr+0x54>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102070:	8b 43 58             	mov    0x58(%ebx),%eax
80102073:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102078:	8b 33                	mov    (%ebx),%esi
8010207a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102080:	74 3e                	je     801020c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102082:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102085:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102088:	83 ce 02             	or     $0x2,%esi
8010208b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010208d:	53                   	push   %ebx
8010208e:	e8 dd 20 00 00       	call   80104170 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102093:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <ideintr+0x54>
    idestart(idequeue);
8010209f:	e8 4c fe ff ff       	call   80101ef0 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 80 a5 10 80       	push   $0x8010a580
801020ac:	e8 8f 25 00 00       	call   80104640 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
801020c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	89 c1                	mov    %eax,%ecx
801020cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ce:	80 f9 40             	cmp    $0x40,%cl
801020d1:	75 f5                	jne    801020c8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020d3:	a8 21                	test   $0x21,%al
801020d5:	75 ab                	jne    80102082 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020da:	b9 80 00 00 00       	mov    $0x80,%ecx
801020df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e4:	fc                   	cld    
801020e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	eb 97                	jmp    80102082 <ideintr+0x32>
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 10             	sub    $0x10,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	50                   	push   %eax
801020fe:	e8 0d 23 00 00       	call   80104410 <holdingsleep>
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	85 c0                	test   %eax,%eax
80102108:	0f 84 ad 00 00 00    	je     801021bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	0f 84 b9 00 00 00    	je     801021d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211c:	8b 53 04             	mov    0x4(%ebx),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 0d                	je     80102130 <iderw+0x40>
80102123:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102128:	85 c0                	test   %eax,%eax
8010212a:	0f 84 98 00 00 00    	je     801021c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 80 a5 10 80       	push   $0x8010a580
80102138:	e8 23 23 00 00       	call   80104460 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102143:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102146:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	85 d2                	test   %edx,%edx
8010214f:	75 09                	jne    8010215a <iderw+0x6a>
80102151:	eb 58                	jmp    801021ab <iderw+0xbb>
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102158:	89 c2                	mov    %eax,%edx
8010215a:	8b 42 58             	mov    0x58(%edx),%eax
8010215d:	85 c0                	test   %eax,%eax
8010215f:	75 f7                	jne    80102158 <iderw+0x68>
80102161:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102164:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102166:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010216c:	74 44                	je     801021b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	74 23                	je     8010219b <iderw+0xab>
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 a5 10 80       	push   $0x8010a580
80102188:	53                   	push   %ebx
80102189:	e8 22 1d 00 00       	call   80103eb0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x90>
    sleep(b, &idelock);
  }

  release(&idelock);
8010219b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801021a6:	e9 95 24 00 00       	jmp    80104640 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021b0:	eb b2                	jmp    80102164 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 37 fd ff ff       	call   80101ef0 <idestart>
801021b9:	eb b3                	jmp    8010216e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021bb:	83 ec 0c             	sub    $0xc,%esp
801021be:	68 f6 73 10 80       	push   $0x801073f6
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 21 74 10 80       	push   $0x80107421
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 0c 74 10 80       	push   $0x8010740c
801021dd:	e8 8e e1 ff ff       	call   80100370 <panic>
801021e2:	66 90                	xchg   %ax,%ax
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021f0:	a1 84 27 11 80       	mov    0x80112784,%eax
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 a8 00 00 00    	je     801022a5 <ioapicinit+0xb5>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fd:	55                   	push   %ebp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021fe:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
80102205:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102208:	89 e5                	mov    %esp,%ebp
8010220a:	56                   	push   %esi
8010220b:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010220c:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102213:	00 00 00 
  return ioapic->data;
80102216:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010221c:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010221f:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102225:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102232:	89 f0                	mov    %esi,%eax
80102234:	c1 e8 10             	shr    $0x10,%eax
80102237:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223a:	8b 41 10             	mov    0x10(%ecx),%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010223d:	c1 e8 18             	shr    $0x18,%eax
80102240:	39 d0                	cmp    %edx,%eax
80102242:	74 16                	je     8010225a <ioapicinit+0x6a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 40 74 10 80       	push   $0x80107440
8010224c:	e8 0f e4 ff ff       	call   80100660 <cprintf>
80102251:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010225d:	ba 10 00 00 00       	mov    $0x10,%edx
80102262:	b8 20 00 00 00       	mov    $0x20,%eax
80102267:	89 f6                	mov    %esi,%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102270:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102272:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102278:	89 c3                	mov    %eax,%ebx
8010227a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102280:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102283:	89 59 10             	mov    %ebx,0x10(%ecx)
80102286:	8d 5a 01             	lea    0x1(%edx),%ebx
80102289:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010228e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102290:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102296:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010229d:	75 d1                	jne    80102270 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010229f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022a2:	5b                   	pop    %ebx
801022a3:	5e                   	pop    %esi
801022a4:	5d                   	pop    %ebp
801022a5:	f3 c3                	repz ret 
801022a7:	89 f6                	mov    %esi,%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022b0:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022b6:	55                   	push   %ebp
801022b7:	89 e5                	mov    %esp,%ebp
  if(!ismp)
801022b9:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022be:	74 2b                	je     801022eb <ioapicenable+0x3b>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c0:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022c6:	8d 50 20             	lea    0x20(%eax),%edx
801022c9:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022cd:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022cf:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022d8:	89 51 10             	mov    %edx,0x10(%ecx)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022db:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022de:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e0:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e5:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022e8:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022eb:	5d                   	pop    %ebp
801022ec:	c3                   	ret    
801022ed:	66 90                	xchg   %ax,%ax
801022ef:	90                   	nop

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 04             	sub    $0x4,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 70                	jne    80102372 <kfree+0x82>
80102302:	81 fb 28 5c 11 80    	cmp    $0x80115c28,%ebx
80102308:	72 68                	jb     80102372 <kfree+0x82>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 5b                	ja     80102372 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	83 ec 04             	sub    $0x4,%esp
8010231a:	68 00 10 00 00       	push   $0x1000
8010231f:	6a 01                	push   $0x1
80102321:	53                   	push   %ebx
80102322:	e8 69 23 00 00       	call   80104690 <memset>

  if(kmem.use_lock)
80102327:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010232d:	83 c4 10             	add    $0x10,%esp
80102330:	85 d2                	test   %edx,%edx
80102332:	75 2c                	jne    80102360 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102334:	a1 98 26 11 80       	mov    0x80112698,%eax
80102339:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010233b:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102340:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102346:	85 c0                	test   %eax,%eax
80102348:	75 06                	jne    80102350 <kfree+0x60>
    release(&kmem.lock);
}
8010234a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234d:	c9                   	leave  
8010234e:	c3                   	ret    
8010234f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102350:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010235a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010235b:	e9 e0 22 00 00       	jmp    80104640 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 60 26 11 80       	push   $0x80112660
80102368:	e8 f3 20 00 00       	call   80104460 <acquire>
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	eb c2                	jmp    80102334 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102372:	83 ec 0c             	sub    $0xc,%esp
80102375:	68 72 74 10 80       	push   $0x80107472
8010237a:	e8 f1 df ff ff       	call   80100370 <panic>
8010237f:	90                   	nop

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102385:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102388:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102391:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102397:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010239d:	39 de                	cmp    %ebx,%esi
8010239f:	72 23                	jb     801023c4 <freerange+0x44>
801023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ae:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023b7:	50                   	push   %eax
801023b8:	e8 33 ff ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	39 f3                	cmp    %esi,%ebx
801023c2:	76 e4                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023c7:	5b                   	pop    %ebx
801023c8:	5e                   	pop    %esi
801023c9:	5d                   	pop    %ebp
801023ca:	c3                   	ret    
801023cb:	90                   	nop
801023cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023d8:	83 ec 08             	sub    $0x8,%esp
801023db:	68 78 74 10 80       	push   $0x80107478
801023e0:	68 60 26 11 80       	push   $0x80112660
801023e5:	e8 56 20 00 00       	call   80104440 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801023f7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102400:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102406:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010240c:	39 de                	cmp    %ebx,%esi
8010240e:	72 1c                	jb     8010242c <kinit1+0x5c>
    kfree(p);
80102410:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102416:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102419:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010241f:	50                   	push   %eax
80102420:	e8 cb fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102425:	83 c4 10             	add    $0x10,%esp
80102428:	39 de                	cmp    %ebx,%esi
8010242a:	73 e4                	jae    80102410 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010242f:	5b                   	pop    %ebx
80102430:	5e                   	pop    %esi
80102431:	5d                   	pop    %ebp
80102432:	c3                   	ret    
80102433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102445:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102448:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102451:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102457:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245d:	39 de                	cmp    %ebx,%esi
8010245f:	72 23                	jb     80102484 <kinit2+0x44>
80102461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102468:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010246e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102471:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102477:	50                   	push   %eax
80102478:	e8 73 fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 e4                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102484:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010248b:	00 00 00 
}
8010248e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102491:	5b                   	pop    %ebx
80102492:	5e                   	pop    %esi
80102493:	5d                   	pop    %ebp
80102494:	c3                   	ret    
80102495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 94 26 11 80       	mov    0x80112694,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 1c                	je     801024d6 <kalloc+0x36>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 10                	je     801024d6 <kalloc+0x36>
    release(&kmem.lock);
801024c6:	83 ec 0c             	sub    $0xc,%esp
801024c9:	68 60 26 11 80       	push   $0x80112660
801024ce:	e8 6d 21 00 00       	call   80104640 <release>
801024d3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024d6:	89 d8                	mov    %ebx,%eax
801024d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024db:	c9                   	leave  
801024dc:	c3                   	ret    
801024dd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	68 60 26 11 80       	push   $0x80112660
801024e8:	e8 73 1f 00 00       	call   80104460 <acquire>
  r = kmem.freelist;
801024ed:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024f3:	83 c4 10             	add    $0x10,%esp
801024f6:	a1 94 26 11 80       	mov    0x80112694,%eax
801024fb:	85 db                	test   %ebx,%ebx
801024fd:	75 bb                	jne    801024ba <kalloc+0x1a>
801024ff:	eb c1                	jmp    801024c2 <kalloc+0x22>
80102501:	66 90                	xchg   %ax,%ax
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102510:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102511:	ba 64 00 00 00       	mov    $0x64,%edx
80102516:	89 e5                	mov    %esp,%ebp
80102518:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102519:	a8 01                	test   $0x1,%al
8010251b:	0f 84 af 00 00 00    	je     801025d0 <kbdgetc+0xc0>
80102521:	ba 60 00 00 00       	mov    $0x60,%edx
80102526:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102527:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010252a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102530:	74 7e                	je     801025b0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102532:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010253a:	79 24                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010253c:	f6 c1 40             	test   $0x40,%cl
8010253f:	75 05                	jne    80102546 <kbdgetc+0x36>
80102541:	89 c2                	mov    %eax,%edx
80102543:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102546:	0f b6 82 a0 75 10 80 	movzbl -0x7fef8a60(%edx),%eax
8010254d:	83 c8 40             	or     $0x40,%eax
80102550:	0f b6 c0             	movzbl %al,%eax
80102553:	f7 d0                	not    %eax
80102555:	21 c8                	and    %ecx,%eax
80102557:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010255c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010255e:	5d                   	pop    %ebp
8010255f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102560:	f6 c1 40             	test   $0x40,%cl
80102563:	74 09                	je     8010256e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102565:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102568:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010256e:	0f b6 82 a0 75 10 80 	movzbl -0x7fef8a60(%edx),%eax
80102575:	09 c1                	or     %eax,%ecx
80102577:	0f b6 82 a0 74 10 80 	movzbl -0x7fef8b60(%edx),%eax
8010257e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102580:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102582:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102588:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010258b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010258e:	8b 04 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%eax
80102595:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102599:	74 c3                	je     8010255e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010259b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010259e:	83 fa 19             	cmp    $0x19,%edx
801025a1:	77 1d                	ja     801025c0 <kbdgetc+0xb0>
      c += 'A' - 'a';
801025a3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a6:	5d                   	pop    %ebp
801025a7:	c3                   	ret    
801025a8:	90                   	nop
801025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801025b0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025b2:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	90                   	nop
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025c0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025c3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025c6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025c7:	83 f9 19             	cmp    $0x19,%ecx
801025ca:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025d5:	5d                   	pop    %ebp
801025d6:	c3                   	ret    
801025d7:	89 f6                	mov    %esi,%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025e6:	68 10 25 10 80       	push   $0x80102510
801025eb:	e8 00 e2 ff ff       	call   801007f0 <consoleintr>
}
801025f0:	83 c4 10             	add    $0x10,%esp
801025f3:	c9                   	leave  
801025f4:	c3                   	ret    
801025f5:	66 90                	xchg   %ax,%ax
801025f7:	66 90                	xchg   %ax,%ax
801025f9:	66 90                	xchg   %ax,%ax
801025fb:	66 90                	xchg   %ax,%ax
801025fd:	66 90                	xchg   %ax,%ax
801025ff:	90                   	nop

80102600 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102600:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102608:	85 c0                	test   %eax,%eax
8010260a:	0f 84 c8 00 00 00    	je     801026d8 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102610:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102617:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010261a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010261d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102624:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102627:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010262a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102631:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102634:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102637:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010263e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102641:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102644:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010264b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102651:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102658:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010265b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010265e:	8b 50 30             	mov    0x30(%eax),%edx
80102661:	c1 ea 10             	shr    $0x10,%edx
80102664:	80 fa 03             	cmp    $0x3,%dl
80102667:	77 77                	ja     801026e0 <lapicinit+0xe0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102669:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102670:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102673:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102676:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102680:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102683:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010268a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102690:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102697:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
801026b7:	89 f6                	mov    %esi,%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026c6:	80 e6 10             	and    $0x10,%dh
801026c9:	75 f5                	jne    801026c0 <lapicinit+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026d8:	5d                   	pop    %ebp
801026d9:	c3                   	ret    
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
801026ed:	e9 77 ff ff ff       	jmp    80102669 <lapicinit+0x69>
801026f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	56                   	push   %esi
80102704:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102705:	9c                   	pushf  
80102706:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102707:	f6 c4 02             	test   $0x2,%ah
8010270a:	74 12                	je     8010271e <cpunum+0x1e>
    static int n;
    if(n++ == 0)
8010270c:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102711:	8d 50 01             	lea    0x1(%eax),%edx
80102714:	85 c0                	test   %eax,%eax
80102716:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010271c:	74 4d                	je     8010276b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
8010271e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102723:	85 c0                	test   %eax,%eax
80102725:	74 60                	je     80102787 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
80102727:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010272a:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102730:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102733:	85 f6                	test   %esi,%esi
80102735:	7e 59                	jle    80102790 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102737:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
8010273e:	39 c3                	cmp    %eax,%ebx
80102740:	74 45                	je     80102787 <cpunum+0x87>
80102742:	ba 5c 28 11 80       	mov    $0x8011285c,%edx
80102747:	31 c0                	xor    %eax,%eax
80102749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80102750:	83 c0 01             	add    $0x1,%eax
80102753:	39 f0                	cmp    %esi,%eax
80102755:	74 39                	je     80102790 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102757:	0f b6 0a             	movzbl (%edx),%ecx
8010275a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102760:	39 cb                	cmp    %ecx,%ebx
80102762:	75 ec                	jne    80102750 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102767:	5b                   	pop    %ebx
80102768:	5e                   	pop    %esi
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010276b:	83 ec 08             	sub    $0x8,%esp
8010276e:	ff 75 04             	pushl  0x4(%ebp)
80102771:	68 a0 76 10 80       	push   $0x801076a0
80102776:	e8 e5 de ff ff       	call   80100660 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010277b:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102780:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80102783:	85 c0                	test   %eax,%eax
80102785:	75 a0                	jne    80102727 <cpunum+0x27>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102787:	8d 65 f8             	lea    -0x8(%ebp),%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010278a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010278c:	5b                   	pop    %ebx
8010278d:	5e                   	pop    %esi
8010278e:	5d                   	pop    %ebp
8010278f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 cc 76 10 80       	push   $0x801076cc
80102798:	e8 d3 db ff ff       	call   80100370 <panic>
8010279d:	8d 76 00             	lea    0x0(%esi),%esi

801027a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027a0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027a5:	55                   	push   %ebp
801027a6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027a8:	85 c0                	test   %eax,%eax
801027aa:	74 0d                	je     801027b9 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027b3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
801027bb:	90                   	nop
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027c0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
}
801027c3:	5d                   	pop    %ebp
801027c4:	c3                   	ret    
801027c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027d0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	b8 0f 00 00 00       	mov    $0xf,%eax
801027db:	89 e5                	mov    %esp,%ebp
801027dd:	53                   	push   %ebx
801027de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027e4:	ee                   	out    %al,(%dx)
801027e5:	ba 71 00 00 00       	mov    $0x71,%edx
801027ea:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027f0:	31 c0                	xor    %eax,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027f5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027fb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027fd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102800:	c1 e8 04             	shr    $0x4,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102803:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102805:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102808:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102813:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102819:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102823:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102826:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102829:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102830:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102833:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102836:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283c:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102845:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102848:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102851:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102857:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010285a:	5b                   	pop    %ebx
8010285b:	5d                   	pop    %ebp
8010285c:	c3                   	ret    
8010285d:	8d 76 00             	lea    0x0(%esi),%esi

80102860 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102860:	55                   	push   %ebp
80102861:	ba 70 00 00 00       	mov    $0x70,%edx
80102866:	b8 0b 00 00 00       	mov    $0xb,%eax
8010286b:	89 e5                	mov    %esp,%ebp
8010286d:	57                   	push   %edi
8010286e:	56                   	push   %esi
8010286f:	53                   	push   %ebx
80102870:	83 ec 4c             	sub    $0x4c,%esp
80102873:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102874:	ba 71 00 00 00       	mov    $0x71,%edx
80102879:	ec                   	in     (%dx),%al
8010287a:	83 e0 04             	and    $0x4,%eax
8010287d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102880:	31 db                	xor    %ebx,%ebx
80102882:	88 45 b7             	mov    %al,-0x49(%ebp)
80102885:	bf 70 00 00 00       	mov    $0x70,%edi
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102890:	89 d8                	mov    %ebx,%eax
80102892:	89 fa                	mov    %edi,%edx
80102894:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102895:	b9 71 00 00 00       	mov    $0x71,%ecx
8010289a:	89 ca                	mov    %ecx,%edx
8010289c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010289d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a0:	89 fa                	mov    %edi,%edx
801028a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028a5:	b8 02 00 00 00       	mov    $0x2,%eax
801028aa:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ab:	89 ca                	mov    %ecx,%edx
801028ad:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028ae:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b1:	89 fa                	mov    %edi,%edx
801028b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028b6:	b8 04 00 00 00       	mov    $0x4,%eax
801028bb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bc:	89 ca                	mov    %ecx,%edx
801028be:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028bf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c2:	89 fa                	mov    %edi,%edx
801028c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c7:	b8 07 00 00 00       	mov    $0x7,%eax
801028cc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cd:	89 ca                	mov    %ecx,%edx
801028cf:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028d0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d3:	89 fa                	mov    %edi,%edx
801028d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028d8:	b8 08 00 00 00       	mov    $0x8,%eax
801028dd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028de:	89 ca                	mov    %ecx,%edx
801028e0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028e1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e4:	89 fa                	mov    %edi,%edx
801028e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028e9:	b8 09 00 00 00       	mov    $0x9,%eax
801028ee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ef:	89 ca                	mov    %ecx,%edx
801028f1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028f2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	89 fa                	mov    %edi,%edx
801028f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028fa:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ff:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102900:	89 ca                	mov    %ecx,%edx
80102902:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102903:	84 c0                	test   %al,%al
80102905:	78 89                	js     80102890 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102907:	89 d8                	mov    %ebx,%eax
80102909:	89 fa                	mov    %edi,%edx
8010290b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010290f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102912:	89 fa                	mov    %edi,%edx
80102914:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102917:	b8 02 00 00 00       	mov    $0x2,%eax
8010291c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291d:	89 ca                	mov    %ecx,%edx
8010291f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102920:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102923:	89 fa                	mov    %edi,%edx
80102925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102928:	b8 04 00 00 00       	mov    $0x4,%eax
8010292d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292e:	89 ca                	mov    %ecx,%edx
80102930:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102931:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102934:	89 fa                	mov    %edi,%edx
80102936:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102939:	b8 07 00 00 00       	mov    $0x7,%eax
8010293e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293f:	89 ca                	mov    %ecx,%edx
80102941:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102942:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102945:	89 fa                	mov    %edi,%edx
80102947:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010294a:	b8 08 00 00 00       	mov    $0x8,%eax
8010294f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102953:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102956:	89 fa                	mov    %edi,%edx
80102958:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010295b:	b8 09 00 00 00       	mov    $0x9,%eax
80102960:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102961:	89 ca                	mov    %ecx,%edx
80102963:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102964:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102967:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010296a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010296d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102970:	6a 18                	push   $0x18
80102972:	56                   	push   %esi
80102973:	50                   	push   %eax
80102974:	e8 67 1d 00 00       	call   801046e0 <memcmp>
80102979:	83 c4 10             	add    $0x10,%esp
8010297c:	85 c0                	test   %eax,%eax
8010297e:	0f 85 0c ff ff ff    	jne    80102890 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102984:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102988:	75 78                	jne    80102a02 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010298a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010298d:	89 c2                	mov    %eax,%edx
8010298f:	83 e0 0f             	and    $0xf,%eax
80102992:	c1 ea 04             	shr    $0x4,%edx
80102995:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102998:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010299e:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a1:	89 c2                	mov    %eax,%edx
801029a3:	83 e0 0f             	and    $0xf,%eax
801029a6:	c1 ea 04             	shr    $0x4,%edx
801029a9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ac:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029af:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029b2:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b5:	89 c2                	mov    %eax,%edx
801029b7:	83 e0 0f             	and    $0xf,%eax
801029ba:	c1 ea 04             	shr    $0x4,%edx
801029bd:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029c6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029c9:	89 c2                	mov    %eax,%edx
801029cb:	83 e0 0f             	and    $0xf,%eax
801029ce:	c1 ea 04             	shr    $0x4,%edx
801029d1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029da:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029dd:	89 c2                	mov    %eax,%edx
801029df:	83 e0 0f             	and    $0xf,%eax
801029e2:	c1 ea 04             	shr    $0x4,%edx
801029e5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029e8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f1:	89 c2                	mov    %eax,%edx
801029f3:	83 e0 0f             	and    $0xf,%eax
801029f6:	c1 ea 04             	shr    $0x4,%edx
801029f9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029fc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a02:	8b 75 08             	mov    0x8(%ebp),%esi
80102a05:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a08:	89 06                	mov    %eax,(%esi)
80102a0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a0d:	89 46 04             	mov    %eax,0x4(%esi)
80102a10:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a13:	89 46 08             	mov    %eax,0x8(%esi)
80102a16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a19:	89 46 0c             	mov    %eax,0xc(%esi)
80102a1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a1f:	89 46 10             	mov    %eax,0x10(%esi)
80102a22:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a25:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a28:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a32:	5b                   	pop    %ebx
80102a33:	5e                   	pop    %esi
80102a34:	5f                   	pop    %edi
80102a35:	5d                   	pop    %ebp
80102a36:	c3                   	ret    
80102a37:	66 90                	xchg   %ax,%ax
80102a39:	66 90                	xchg   %ax,%ax
80102a3b:	66 90                	xchg   %ax,%ax
80102a3d:	66 90                	xchg   %ax,%ax
80102a3f:	90                   	nop

80102a40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a40:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102a46:	85 c9                	test   %ecx,%ecx
80102a48:	0f 8e 85 00 00 00    	jle    80102ad3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	57                   	push   %edi
80102a52:	56                   	push   %esi
80102a53:	53                   	push   %ebx
80102a54:	31 db                	xor    %ebx,%ebx
80102a56:	83 ec 0c             	sub    $0xc,%esp
80102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a60:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	01 d8                	add    %ebx,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	50                   	push   %eax
80102a6e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102a74:	e8 57 d6 ff ff       	call   801000d0 <bread>
80102a79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7b:	58                   	pop    %eax
80102a7c:	5a                   	pop    %edx
80102a7d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102a84:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a8d:	e8 3e d6 ff ff       	call   801000d0 <bread>
80102a92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a97:	83 c4 0c             	add    $0xc,%esp
80102a9a:	68 00 02 00 00       	push   $0x200
80102a9f:	50                   	push   %eax
80102aa0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa3:	50                   	push   %eax
80102aa4:	e8 97 1c 00 00       	call   80104740 <memmove>
    bwrite(dbuf);  // write dst to disk
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 ef d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ab1:	89 3c 24             	mov    %edi,(%esp)
80102ab4:	e8 27 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ab9:	89 34 24             	mov    %esi,(%esp)
80102abc:	e8 1f d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ac1:	83 c4 10             	add    $0x10,%esp
80102ac4:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102aca:	7f 94                	jg     80102a60 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102acf:	5b                   	pop    %ebx
80102ad0:	5e                   	pop    %esi
80102ad1:	5f                   	pop    %edi
80102ad2:	5d                   	pop    %ebp
80102ad3:	f3 c3                	repz ret 
80102ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	53                   	push   %ebx
80102ae4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ae7:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102aed:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102af3:	e8 d8 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102af8:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102afe:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b01:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b03:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b05:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b08:	7e 1f                	jle    80102b29 <write_head+0x49>
80102b0a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102b11:	31 d2                	xor    %edx,%edx
80102b13:	90                   	nop
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102b18:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102b1e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102b22:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b25:	39 c2                	cmp    %eax,%edx
80102b27:	75 ef                	jne    80102b18 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102b29:	83 ec 0c             	sub    $0xc,%esp
80102b2c:	53                   	push   %ebx
80102b2d:	e8 6e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b32:	89 1c 24             	mov    %ebx,(%esp)
80102b35:	e8 a6 d6 ff ff       	call   801001e0 <brelse>
}
80102b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b3d:	c9                   	leave  
80102b3e:	c3                   	ret    
80102b3f:	90                   	nop

80102b40 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 2c             	sub    $0x2c,%esp
80102b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b4a:	68 dc 76 10 80       	push   $0x801076dc
80102b4f:	68 a0 26 11 80       	push   $0x801126a0
80102b54:	e8 e7 18 00 00       	call   80104440 <initlock>
  readsb(dev, &sb);
80102b59:	58                   	pop    %eax
80102b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 4b e8 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b68:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b6b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b6c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b72:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b78:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b7d:	5a                   	pop    %edx
80102b7e:	50                   	push   %eax
80102b7f:	53                   	push   %ebx
80102b80:	e8 4b d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b85:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b8d:	89 0d e8 26 11 80    	mov    %ecx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b93:	7e 1c                	jle    80102bb1 <initlog+0x71>
80102b95:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b9c:	31 d2                	xor    %edx,%edx
80102b9e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ba0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ba4:	83 c2 04             	add    $0x4,%edx
80102ba7:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102bad:	39 da                	cmp    %ebx,%edx
80102baf:	75 ef                	jne    80102ba0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102bb1:	83 ec 0c             	sub    $0xc,%esp
80102bb4:	50                   	push   %eax
80102bb5:	e8 26 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bba:	e8 81 fe ff ff       	call   80102a40 <install_trans>
  log.lh.n = 0;
80102bbf:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102bc6:	00 00 00 
  write_head(); // clear the log
80102bc9:	e8 12 ff ff ff       	call   80102ae0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bd1:	c9                   	leave  
80102bd2:	c3                   	ret    
80102bd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102be6:	68 a0 26 11 80       	push   $0x801126a0
80102beb:	e8 70 18 00 00       	call   80104460 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 a0 26 11 80       	push   $0x801126a0
80102c00:	68 a0 26 11 80       	push   $0x801126a0
80102c05:	e8 a6 12 00 00       	call   80103eb0 <sleep>
80102c0a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102c0d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 e2                	jne    80102bf8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c16:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102c1b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102c21:	83 c0 01             	add    $0x1,%eax
80102c24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c2a:	83 fa 1e             	cmp    $0x1e,%edx
80102c2d:	7f c9                	jg     80102bf8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c2f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c32:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102c37:	68 a0 26 11 80       	push   $0x801126a0
80102c3c:	e8 ff 19 00 00       	call   80104640 <release>
      break;
    }
  }
}
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	c9                   	leave  
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	57                   	push   %edi
80102c54:	56                   	push   %esi
80102c55:	53                   	push   %ebx
80102c56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c59:	68 a0 26 11 80       	push   $0x801126a0
80102c5e:	e8 fd 17 00 00       	call   80104460 <acquire>
  log.outstanding -= 1;
80102c63:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c68:	8b 1d e0 26 11 80    	mov    0x801126e0,%ebx
80102c6e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c71:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c74:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c76:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c7b:	0f 85 23 01 00 00    	jne    80102da4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c81:	85 c0                	test   %eax,%eax
80102c83:	0f 85 f7 00 00 00    	jne    80102d80 <end_op+0x130>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c89:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c8c:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c93:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c96:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c98:	68 a0 26 11 80       	push   $0x801126a0
80102c9d:	e8 9e 19 00 00       	call   80104640 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ca2:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102ca8:	83 c4 10             	add    $0x10,%esp
80102cab:	85 c9                	test   %ecx,%ecx
80102cad:	0f 8e 8a 00 00 00    	jle    80102d3d <end_op+0xed>
80102cb3:	90                   	nop
80102cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cb8:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102cbd:	83 ec 08             	sub    $0x8,%esp
80102cc0:	01 d8                	add    %ebx,%eax
80102cc2:	83 c0 01             	add    $0x1,%eax
80102cc5:	50                   	push   %eax
80102cc6:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102ccc:	e8 ff d3 ff ff       	call   801000d0 <bread>
80102cd1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cd3:	58                   	pop    %eax
80102cd4:	5a                   	pop    %edx
80102cd5:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102cdc:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ce2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ce5:	e8 e6 d3 ff ff       	call   801000d0 <bread>
80102cea:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cec:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cef:	83 c4 0c             	add    $0xc,%esp
80102cf2:	68 00 02 00 00       	push   $0x200
80102cf7:	50                   	push   %eax
80102cf8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cfb:	50                   	push   %eax
80102cfc:	e8 3f 1a 00 00       	call   80104740 <memmove>
    bwrite(to);  // write the log
80102d01:	89 34 24             	mov    %esi,(%esp)
80102d04:	e8 97 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d09:	89 3c 24             	mov    %edi,(%esp)
80102d0c:	e8 cf d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d11:	89 34 24             	mov    %esi,(%esp)
80102d14:	e8 c7 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d19:	83 c4 10             	add    $0x10,%esp
80102d1c:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102d22:	7c 94                	jl     80102cb8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d24:	e8 b7 fd ff ff       	call   80102ae0 <write_head>
    install_trans(); // Now install writes to home locations
80102d29:	e8 12 fd ff ff       	call   80102a40 <install_trans>
    log.lh.n = 0;
80102d2e:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d35:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d38:	e8 a3 fd ff ff       	call   80102ae0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d3d:	83 ec 0c             	sub    $0xc,%esp
80102d40:	68 a0 26 11 80       	push   $0x801126a0
80102d45:	e8 16 17 00 00       	call   80104460 <acquire>
    log.committing = 0;
    wakeup(&log);
80102d4a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102d51:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d58:	00 00 00 
    wakeup(&log);
80102d5b:	e8 10 14 00 00       	call   80104170 <wakeup>
    release(&log.lock);
80102d60:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d67:	e8 d4 18 00 00       	call   80104640 <release>
80102d6c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d72:	5b                   	pop    %ebx
80102d73:	5e                   	pop    %esi
80102d74:	5f                   	pop    %edi
80102d75:	5d                   	pop    %ebp
80102d76:	c3                   	ret    
80102d77:	89 f6                	mov    %esi,%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80102d80:	83 ec 0c             	sub    $0xc,%esp
80102d83:	68 a0 26 11 80       	push   $0x801126a0
80102d88:	e8 e3 13 00 00       	call   80104170 <wakeup>
  }
  release(&log.lock);
80102d8d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d94:	e8 a7 18 00 00       	call   80104640 <release>
80102d99:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9f:	5b                   	pop    %ebx
80102da0:	5e                   	pop    %esi
80102da1:	5f                   	pop    %edi
80102da2:	5d                   	pop    %ebp
80102da3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102da4:	83 ec 0c             	sub    $0xc,%esp
80102da7:	68 e0 76 10 80       	push   $0x801076e0
80102dac:	e8 bf d5 ff ff       	call   80100370 <panic>
80102db1:	eb 0d                	jmp    80102dc0 <log_write>
80102db3:	90                   	nop
80102db4:	90                   	nop
80102db5:	90                   	nop
80102db6:	90                   	nop
80102db7:	90                   	nop
80102db8:	90                   	nop
80102db9:	90                   	nop
80102dba:	90                   	nop
80102dbb:	90                   	nop
80102dbc:	90                   	nop
80102dbd:	90                   	nop
80102dbe:	90                   	nop
80102dbf:	90                   	nop

80102dc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dc7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102dcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dd0:	83 fa 1d             	cmp    $0x1d,%edx
80102dd3:	0f 8f 97 00 00 00    	jg     80102e70 <log_write+0xb0>
80102dd9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102dde:	83 e8 01             	sub    $0x1,%eax
80102de1:	39 c2                	cmp    %eax,%edx
80102de3:	0f 8d 87 00 00 00    	jge    80102e70 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102de9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dee:	85 c0                	test   %eax,%eax
80102df0:	0f 8e 87 00 00 00    	jle    80102e7d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102df6:	83 ec 0c             	sub    $0xc,%esp
80102df9:	68 a0 26 11 80       	push   $0x801126a0
80102dfe:	e8 5d 16 00 00       	call   80104460 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e03:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e09:	83 c4 10             	add    $0x10,%esp
80102e0c:	83 fa 00             	cmp    $0x0,%edx
80102e0f:	7e 50                	jle    80102e61 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e11:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e14:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e16:	3b 0d ec 26 11 80    	cmp    0x801126ec,%ecx
80102e1c:	75 0b                	jne    80102e29 <log_write+0x69>
80102e1e:	eb 38                	jmp    80102e58 <log_write+0x98>
80102e20:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102e27:	74 2f                	je     80102e58 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e29:	83 c0 01             	add    $0x1,%eax
80102e2c:	39 d0                	cmp    %edx,%eax
80102e2e:	75 f0                	jne    80102e20 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e30:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e37:	83 c2 01             	add    $0x1,%edx
80102e3a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102e40:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e43:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102e4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e4d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e4e:	e9 ed 17 00 00       	jmp    80104640 <release>
80102e53:	90                   	nop
80102e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e58:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102e5f:	eb df                	jmp    80102e40 <log_write+0x80>
80102e61:	8b 43 08             	mov    0x8(%ebx),%eax
80102e64:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e69:	75 d5                	jne    80102e40 <log_write+0x80>
80102e6b:	eb ca                	jmp    80102e37 <log_write+0x77>
80102e6d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e70:	83 ec 0c             	sub    $0xc,%esp
80102e73:	68 ef 76 10 80       	push   $0x801076ef
80102e78:	e8 f3 d4 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e7d:	83 ec 0c             	sub    $0xc,%esp
80102e80:	68 05 77 10 80       	push   $0x80107705
80102e85:	e8 e6 d4 ff ff       	call   80100370 <panic>
80102e8a:	66 90                	xchg   %ax,%ax
80102e8c:	66 90                	xchg   %ax,%ax
80102e8e:	66 90                	xchg   %ax,%ax

80102e90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e96:	e8 65 f8 ff ff       	call   80102700 <cpunum>
80102e9b:	83 ec 08             	sub    $0x8,%esp
80102e9e:	50                   	push   %eax
80102e9f:	68 20 77 10 80       	push   $0x80107720
80102ea4:	e8 b7 d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea9:	e8 52 2b 00 00       	call   80105a00 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102eae:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eb5:	b8 01 00 00 00       	mov    $0x1,%eax
80102eba:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102ec1:	e8 aa 0c 00 00       	call   80103b70 <scheduler>
80102ec6:	8d 76 00             	lea    0x0(%esi),%esi
80102ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ed0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ed6:	e8 85 3d 00 00       	call   80106c60 <switchkvm>
  seginit();
80102edb:	e8 a0 3b 00 00       	call   80106a80 <seginit>
  lapicinit();
80102ee0:	e8 1b f7 ff ff       	call   80102600 <lapicinit>
  mpmain();
80102ee5:	e8 a6 ff ff ff       	call   80102e90 <mpmain>
80102eea:	66 90                	xchg   %ax,%ax
80102eec:	66 90                	xchg   %ax,%ax
80102eee:	66 90                	xchg   %ax,%ax

80102ef0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ef0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ef4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ef7:	ff 71 fc             	pushl  -0x4(%ecx)
80102efa:	55                   	push   %ebp
80102efb:	89 e5                	mov    %esp,%ebp
80102efd:	53                   	push   %ebx
80102efe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eff:	83 ec 08             	sub    $0x8,%esp
80102f02:	68 00 00 40 80       	push   $0x80400000
80102f07:	68 28 5c 11 80       	push   $0x80115c28
80102f0c:	e8 bf f4 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102f11:	e8 2a 3d 00 00       	call   80106c40 <kvmalloc>
  mpinit();        // detect other processors
80102f16:	e8 b5 01 00 00       	call   801030d0 <mpinit>
  lapicinit();     // interrupt controller
80102f1b:	e8 e0 f6 ff ff       	call   80102600 <lapicinit>
  seginit();       // segment descriptors
80102f20:	e8 5b 3b 00 00       	call   80106a80 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102f25:	e8 d6 f7 ff ff       	call   80102700 <cpunum>
80102f2a:	5a                   	pop    %edx
80102f2b:	59                   	pop    %ecx
80102f2c:	50                   	push   %eax
80102f2d:	68 31 77 10 80       	push   $0x80107731
80102f32:	e8 29 d7 ff ff       	call   80100660 <cprintf>
  picinit();       // another interrupt controller
80102f37:	e8 a4 03 00 00       	call   801032e0 <picinit>
  ioapicinit();    // another interrupt controller
80102f3c:	e8 af f2 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102f41:	e8 5a da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102f46:	e8 05 2e 00 00       	call   80105d50 <uartinit>
  pinit();         // process table
80102f4b:	e8 60 09 00 00       	call   801038b0 <pinit>
  tvinit();        // trap vectors
80102f50:	e8 0b 2a 00 00       	call   80105960 <tvinit>
  binit();         // buffer cache
80102f55:	e8 e6 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f5a:	e8 f1 dd ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk
80102f5f:	e8 5c f0 ff ff       	call   80101fc0 <ideinit>
  if(!ismp)
80102f64:	8b 1d 84 27 11 80    	mov    0x80112784,%ebx
80102f6a:	83 c4 10             	add    $0x10,%esp
80102f6d:	85 db                	test   %ebx,%ebx
80102f6f:	0f 84 ca 00 00 00    	je     8010303f <main+0x14f>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f75:	83 ec 04             	sub    $0x4,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80102f78:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f7d:	68 8a 00 00 00       	push   $0x8a
80102f82:	68 8c a4 10 80       	push   $0x8010a48c
80102f87:	68 00 70 00 80       	push   $0x80007000
80102f8c:	e8 af 17 00 00       	call   80104740 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f91:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f98:	00 00 00 
80102f9b:	83 c4 10             	add    $0x10,%esp
80102f9e:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fa3:	39 d8                	cmp    %ebx,%eax
80102fa5:	76 7c                	jbe    80103023 <main+0x133>
80102fa7:	89 f6                	mov    %esi,%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == cpus+cpunum())  // We've started already.
80102fb0:	e8 4b f7 ff ff       	call   80102700 <cpunum>
80102fb5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102fbb:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102fc0:	39 c3                	cmp    %eax,%ebx
80102fc2:	74 46                	je     8010300a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fc4:	e8 d7 f4 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102fc9:	83 ec 08             	sub    $0x8,%esp

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fcc:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fd1:	c7 05 f8 6f 00 80 d0 	movl   $0x80102ed0,0x80006ff8
80102fd8:	2e 10 80 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fdb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fe0:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fe7:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102fea:	68 00 70 00 00       	push   $0x7000
80102fef:	0f b6 03             	movzbl (%ebx),%eax
80102ff2:	50                   	push   %eax
80102ff3:	e8 d8 f7 ff ff       	call   801027d0 <lapicstartap>
80102ff8:	83 c4 10             	add    $0x10,%esp
80102ffb:	90                   	nop
80102ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103000:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80103006:	85 c0                	test   %eax,%eax
80103008:	74 f6                	je     80103000 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010300a:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80103011:	00 00 00 
80103014:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
8010301a:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010301f:	39 c3                	cmp    %eax,%ebx
80103021:	72 8d                	jb     80102fb0 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103023:	83 ec 08             	sub    $0x8,%esp
80103026:	68 00 00 00 8e       	push   $0x8e000000
8010302b:	68 00 00 40 80       	push   $0x80400000
80103030:	e8 0b f4 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80103035:	e8 96 08 00 00       	call   801038d0 <userinit>
  mpmain();        // finish this processor's setup
8010303a:	e8 51 fe ff ff       	call   80102e90 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
8010303f:	e8 bc 28 00 00       	call   80105900 <timerinit>
80103044:	e9 2c ff ff ff       	jmp    80102f75 <main+0x85>
80103049:	66 90                	xchg   %ax,%ax
8010304b:	66 90                	xchg   %ax,%ax
8010304d:	66 90                	xchg   %ax,%ax
8010304f:	90                   	nop

80103050 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103055:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010305b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010305c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010305f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103062:	39 de                	cmp    %ebx,%esi
80103064:	73 48                	jae    801030ae <mpsearch1+0x5e>
80103066:	8d 76 00             	lea    0x0(%esi),%esi
80103069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103070:	83 ec 04             	sub    $0x4,%esp
80103073:	8d 7e 10             	lea    0x10(%esi),%edi
80103076:	6a 04                	push   $0x4
80103078:	68 48 77 10 80       	push   $0x80107748
8010307d:	56                   	push   %esi
8010307e:	e8 5d 16 00 00       	call   801046e0 <memcmp>
80103083:	83 c4 10             	add    $0x10,%esp
80103086:	85 c0                	test   %eax,%eax
80103088:	75 1e                	jne    801030a8 <mpsearch1+0x58>
8010308a:	8d 7e 10             	lea    0x10(%esi),%edi
8010308d:	89 f2                	mov    %esi,%edx
8010308f:	31 c9                	xor    %ecx,%ecx
80103091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103098:	0f b6 02             	movzbl (%edx),%eax
8010309b:	83 c2 01             	add    $0x1,%edx
8010309e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a0:	39 fa                	cmp    %edi,%edx
801030a2:	75 f4                	jne    80103098 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030a4:	84 c9                	test   %cl,%cl
801030a6:	74 10                	je     801030b8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801030a8:	39 fb                	cmp    %edi,%ebx
801030aa:	89 fe                	mov    %edi,%esi
801030ac:	77 c2                	ja     80103070 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801030ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801030b1:	31 c0                	xor    %eax,%eax
}
801030b3:	5b                   	pop    %ebx
801030b4:	5e                   	pop    %esi
801030b5:	5f                   	pop    %edi
801030b6:	5d                   	pop    %ebp
801030b7:	c3                   	ret    
801030b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bb:	89 f0                	mov    %esi,%eax
801030bd:	5b                   	pop    %ebx
801030be:	5e                   	pop    %esi
801030bf:	5f                   	pop    %edi
801030c0:	5d                   	pop    %ebp
801030c1:	c3                   	ret    
801030c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	57                   	push   %edi
801030d4:	56                   	push   %esi
801030d5:	53                   	push   %ebx
801030d6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030e7:	c1 e0 08             	shl    $0x8,%eax
801030ea:	09 d0                	or     %edx,%eax
801030ec:	c1 e0 04             	shl    $0x4,%eax
801030ef:	85 c0                	test   %eax,%eax
801030f1:	75 1b                	jne    8010310e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801030f3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030fa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103101:	c1 e0 08             	shl    $0x8,%eax
80103104:	09 d0                	or     %edx,%eax
80103106:	c1 e0 0a             	shl    $0xa,%eax
80103109:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010310e:	ba 00 04 00 00       	mov    $0x400,%edx
80103113:	e8 38 ff ff ff       	call   80103050 <mpsearch1>
80103118:	85 c0                	test   %eax,%eax
8010311a:	89 c6                	mov    %eax,%esi
8010311c:	0f 84 66 01 00 00    	je     80103288 <mpinit+0x1b8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103122:	8b 5e 04             	mov    0x4(%esi),%ebx
80103125:	85 db                	test   %ebx,%ebx
80103127:	0f 84 d6 00 00 00    	je     80103203 <mpinit+0x133>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010312d:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103133:	83 ec 04             	sub    $0x4,%esp
80103136:	6a 04                	push   $0x4
80103138:	68 4d 77 10 80       	push   $0x8010774d
8010313d:	50                   	push   %eax
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010313e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103141:	e8 9a 15 00 00       	call   801046e0 <memcmp>
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	85 c0                	test   %eax,%eax
8010314b:	0f 85 b2 00 00 00    	jne    80103203 <mpinit+0x133>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103151:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103158:	3c 01                	cmp    $0x1,%al
8010315a:	74 08                	je     80103164 <mpinit+0x94>
8010315c:	3c 04                	cmp    $0x4,%al
8010315e:	0f 85 9f 00 00 00    	jne    80103203 <mpinit+0x133>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103164:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010316b:	85 ff                	test   %edi,%edi
8010316d:	74 1e                	je     8010318d <mpinit+0xbd>
8010316f:	31 d2                	xor    %edx,%edx
80103171:	31 c0                	xor    %eax,%eax
80103173:	90                   	nop
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103178:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010317f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103180:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103183:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103185:	39 c7                	cmp    %eax,%edi
80103187:	75 ef                	jne    80103178 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103189:	84 d2                	test   %dl,%dl
8010318b:	75 76                	jne    80103203 <mpinit+0x133>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010318d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103190:	85 ff                	test   %edi,%edi
80103192:	74 6f                	je     80103203 <mpinit+0x133>
    return;
  ismp = 1;
80103194:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010319b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010319e:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031a4:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031a9:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
801031b0:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801031b6:	01 f9                	add    %edi,%ecx
801031b8:	39 c8                	cmp    %ecx,%eax
801031ba:	0f 83 a0 00 00 00    	jae    80103260 <mpinit+0x190>
    switch(*p){
801031c0:	80 38 04             	cmpb   $0x4,(%eax)
801031c3:	0f 87 87 00 00 00    	ja     80103250 <mpinit+0x180>
801031c9:	0f b6 10             	movzbl (%eax),%edx
801031cc:	ff 24 95 54 77 10 80 	jmp    *-0x7fef88ac(,%edx,4)
801031d3:	90                   	nop
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031d8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031db:	39 c1                	cmp    %eax,%ecx
801031dd:	77 e1                	ja     801031c0 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
801031df:	a1 84 27 11 80       	mov    0x80112784,%eax
801031e4:	85 c0                	test   %eax,%eax
801031e6:	75 78                	jne    80103260 <mpinit+0x190>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801031e8:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
801031ef:	00 00 00 
    lapic = 0;
801031f2:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
801031f9:	00 00 00 
    ioapicid = 0;
801031fc:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103206:	5b                   	pop    %ebx
80103207:	5e                   	pop    %esi
80103208:	5f                   	pop    %edi
80103209:	5d                   	pop    %ebp
8010320a:	c3                   	ret    
8010320b:	90                   	nop
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103210:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
80103216:	83 fa 07             	cmp    $0x7,%edx
80103219:	7f 19                	jg     80103234 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010321b:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
8010321f:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
        ncpu++;
80103225:	83 c2 01             	add    $0x1,%edx
80103228:	89 15 80 2d 11 80    	mov    %edx,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010322e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
80103234:	83 c0 14             	add    $0x14,%eax
      continue;
80103237:	eb a2                	jmp    801031db <mpinit+0x10b>
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103240:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103244:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103247:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
8010324d:	eb 8c                	jmp    801031db <mpinit+0x10b>
8010324f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103250:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
80103257:	00 00 00 
      break;
8010325a:	e9 7c ff ff ff       	jmp    801031db <mpinit+0x10b>
8010325f:	90                   	nop
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103260:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103264:	74 9d                	je     80103203 <mpinit+0x133>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103266:	ba 22 00 00 00       	mov    $0x22,%edx
8010326b:	b8 70 00 00 00       	mov    $0x70,%eax
80103270:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103271:	ba 23 00 00 00       	mov    $0x23,%edx
80103276:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103277:	83 c8 01             	or     $0x1,%eax
8010327a:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010327b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010327e:	5b                   	pop    %ebx
8010327f:	5e                   	pop    %esi
80103280:	5f                   	pop    %edi
80103281:	5d                   	pop    %ebp
80103282:	c3                   	ret    
80103283:	90                   	nop
80103284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103288:	ba 00 00 01 00       	mov    $0x10000,%edx
8010328d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103292:	e8 b9 fd ff ff       	call   80103050 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103297:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103299:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010329b:	0f 85 81 fe ff ff    	jne    80103122 <mpinit+0x52>
801032a1:	e9 5d ff ff ff       	jmp    80103203 <mpinit+0x133>
801032a6:	66 90                	xchg   %ax,%ax
801032a8:	66 90                	xchg   %ax,%ax
801032aa:	66 90                	xchg   %ax,%ax
801032ac:	66 90                	xchg   %ax,%ax
801032ae:	66 90                	xchg   %ax,%ax

801032b0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801032b0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
801032b1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801032b6:	ba 21 00 00 00       	mov    $0x21,%edx
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801032bb:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
801032bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
801032c0:	d3 c0                	rol    %cl,%eax
801032c2:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
801032c9:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
801032cf:	ee                   	out    %al,(%dx)
801032d0:	ba a1 00 00 00       	mov    $0xa1,%edx
801032d5:	66 c1 e8 08          	shr    $0x8,%ax
801032d9:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
801032da:	5d                   	pop    %ebp
801032db:	c3                   	ret    
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032e0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801032e0:	55                   	push   %ebp
801032e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032e6:	89 e5                	mov    %esp,%ebp
801032e8:	57                   	push   %edi
801032e9:	56                   	push   %esi
801032ea:	53                   	push   %ebx
801032eb:	bb 21 00 00 00       	mov    $0x21,%ebx
801032f0:	89 da                	mov    %ebx,%edx
801032f2:	ee                   	out    %al,(%dx)
801032f3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801032f8:	89 ca                	mov    %ecx,%edx
801032fa:	ee                   	out    %al,(%dx)
801032fb:	bf 11 00 00 00       	mov    $0x11,%edi
80103300:	be 20 00 00 00       	mov    $0x20,%esi
80103305:	89 f8                	mov    %edi,%eax
80103307:	89 f2                	mov    %esi,%edx
80103309:	ee                   	out    %al,(%dx)
8010330a:	b8 20 00 00 00       	mov    $0x20,%eax
8010330f:	89 da                	mov    %ebx,%edx
80103311:	ee                   	out    %al,(%dx)
80103312:	b8 04 00 00 00       	mov    $0x4,%eax
80103317:	ee                   	out    %al,(%dx)
80103318:	b8 03 00 00 00       	mov    $0x3,%eax
8010331d:	ee                   	out    %al,(%dx)
8010331e:	bb a0 00 00 00       	mov    $0xa0,%ebx
80103323:	89 f8                	mov    %edi,%eax
80103325:	89 da                	mov    %ebx,%edx
80103327:	ee                   	out    %al,(%dx)
80103328:	b8 28 00 00 00       	mov    $0x28,%eax
8010332d:	89 ca                	mov    %ecx,%edx
8010332f:	ee                   	out    %al,(%dx)
80103330:	b8 02 00 00 00       	mov    $0x2,%eax
80103335:	ee                   	out    %al,(%dx)
80103336:	b8 03 00 00 00       	mov    $0x3,%eax
8010333b:	ee                   	out    %al,(%dx)
8010333c:	bf 68 00 00 00       	mov    $0x68,%edi
80103341:	89 f2                	mov    %esi,%edx
80103343:	89 f8                	mov    %edi,%eax
80103345:	ee                   	out    %al,(%dx)
80103346:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010334b:	89 c8                	mov    %ecx,%eax
8010334d:	ee                   	out    %al,(%dx)
8010334e:	89 f8                	mov    %edi,%eax
80103350:	89 da                	mov    %ebx,%edx
80103352:	ee                   	out    %al,(%dx)
80103353:	89 c8                	mov    %ecx,%eax
80103355:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103356:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010335d:	66 83 f8 ff          	cmp    $0xffff,%ax
80103361:	74 10                	je     80103373 <picinit+0x93>
80103363:	ba 21 00 00 00       	mov    $0x21,%edx
80103368:	ee                   	out    %al,(%dx)
80103369:	ba a1 00 00 00       	mov    $0xa1,%edx
8010336e:	66 c1 e8 08          	shr    $0x8,%ax
80103372:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
80103373:	5b                   	pop    %ebx
80103374:	5e                   	pop    %esi
80103375:	5f                   	pop    %edi
80103376:	5d                   	pop    %ebp
80103377:	c3                   	ret    
80103378:	66 90                	xchg   %ax,%ax
8010337a:	66 90                	xchg   %ax,%ax
8010337c:	66 90                	xchg   %ax,%ax
8010337e:	66 90                	xchg   %ax,%ax

80103380 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 0c             	sub    $0xc,%esp
80103389:	8b 75 08             	mov    0x8(%ebp),%esi
8010338c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010338f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103395:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010339b:	e8 d0 d9 ff ff       	call   80100d70 <filealloc>
801033a0:	85 c0                	test   %eax,%eax
801033a2:	89 06                	mov    %eax,(%esi)
801033a4:	0f 84 a8 00 00 00    	je     80103452 <pipealloc+0xd2>
801033aa:	e8 c1 d9 ff ff       	call   80100d70 <filealloc>
801033af:	85 c0                	test   %eax,%eax
801033b1:	89 03                	mov    %eax,(%ebx)
801033b3:	0f 84 87 00 00 00    	je     80103440 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033b9:	e8 e2 f0 ff ff       	call   801024a0 <kalloc>
801033be:	85 c0                	test   %eax,%eax
801033c0:	89 c7                	mov    %eax,%edi
801033c2:	0f 84 b0 00 00 00    	je     80103478 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033c8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801033cb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033d2:	00 00 00 
  p->writeopen = 1;
801033d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033dc:	00 00 00 
  p->nwrite = 0;
801033df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033e6:	00 00 00 
  p->nread = 0;
801033e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033f0:	00 00 00 
  initlock(&p->lock, "pipe");
801033f3:	68 68 77 10 80       	push   $0x80107768
801033f8:	50                   	push   %eax
801033f9:	e8 42 10 00 00       	call   80104440 <initlock>
  (*f0)->type = FD_PIPE;
801033fe:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103400:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103403:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103409:	8b 06                	mov    (%esi),%eax
8010340b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010340f:	8b 06                	mov    (%esi),%eax
80103411:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103415:	8b 06                	mov    (%esi),%eax
80103417:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010341a:	8b 03                	mov    (%ebx),%eax
8010341c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103422:	8b 03                	mov    (%ebx),%eax
80103424:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103428:	8b 03                	mov    (%ebx),%eax
8010342a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010342e:	8b 03                	mov    (%ebx),%eax
80103430:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103433:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103436:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103438:	5b                   	pop    %ebx
80103439:	5e                   	pop    %esi
8010343a:	5f                   	pop    %edi
8010343b:	5d                   	pop    %ebp
8010343c:	c3                   	ret    
8010343d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103440:	8b 06                	mov    (%esi),%eax
80103442:	85 c0                	test   %eax,%eax
80103444:	74 1e                	je     80103464 <pipealloc+0xe4>
    fileclose(*f0);
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	50                   	push   %eax
8010344a:	e8 e1 d9 ff ff       	call   80100e30 <fileclose>
8010344f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103452:	8b 03                	mov    (%ebx),%eax
80103454:	85 c0                	test   %eax,%eax
80103456:	74 0c                	je     80103464 <pipealloc+0xe4>
    fileclose(*f1);
80103458:	83 ec 0c             	sub    $0xc,%esp
8010345b:	50                   	push   %eax
8010345c:	e8 cf d9 ff ff       	call   80100e30 <fileclose>
80103461:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103464:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010346c:	5b                   	pop    %ebx
8010346d:	5e                   	pop    %esi
8010346e:	5f                   	pop    %edi
8010346f:	5d                   	pop    %ebp
80103470:	c3                   	ret    
80103471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103478:	8b 06                	mov    (%esi),%eax
8010347a:	85 c0                	test   %eax,%eax
8010347c:	75 c8                	jne    80103446 <pipealloc+0xc6>
8010347e:	eb d2                	jmp    80103452 <pipealloc+0xd2>

80103480 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	56                   	push   %esi
80103484:	53                   	push   %ebx
80103485:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103488:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010348b:	83 ec 0c             	sub    $0xc,%esp
8010348e:	53                   	push   %ebx
8010348f:	e8 cc 0f 00 00       	call   80104460 <acquire>
  if(writable){
80103494:	83 c4 10             	add    $0x10,%esp
80103497:	85 f6                	test   %esi,%esi
80103499:	74 45                	je     801034e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010349b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034a1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801034a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034ab:	00 00 00 
    wakeup(&p->nread);
801034ae:	50                   	push   %eax
801034af:	e8 bc 0c 00 00       	call   80104170 <wakeup>
801034b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034bd:	85 d2                	test   %edx,%edx
801034bf:	75 0a                	jne    801034cb <pipeclose+0x4b>
801034c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034c7:	85 c0                	test   %eax,%eax
801034c9:	74 35                	je     80103500 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034d1:	5b                   	pop    %ebx
801034d2:	5e                   	pop    %esi
801034d3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034d4:	e9 67 11 00 00       	jmp    80104640 <release>
801034d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801034e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034e6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801034e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034f0:	00 00 00 
    wakeup(&p->nwrite);
801034f3:	50                   	push   %eax
801034f4:	e8 77 0c 00 00       	call   80104170 <wakeup>
801034f9:	83 c4 10             	add    $0x10,%esp
801034fc:	eb b9                	jmp    801034b7 <pipeclose+0x37>
801034fe:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	53                   	push   %ebx
80103504:	e8 37 11 00 00       	call   80104640 <release>
    kfree((char*)p);
80103509:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010350c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010350f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103512:	5b                   	pop    %ebx
80103513:	5e                   	pop    %esi
80103514:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103515:	e9 d6 ed ff ff       	jmp    801022f0 <kfree>
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103520 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 28             	sub    $0x28,%esp
80103529:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010352c:	57                   	push   %edi
8010352d:	e8 2e 0f 00 00       	call   80104460 <acquire>
  for(i = 0; i < n; i++){
80103532:	8b 45 10             	mov    0x10(%ebp),%eax
80103535:	83 c4 10             	add    $0x10,%esp
80103538:	85 c0                	test   %eax,%eax
8010353a:	0f 8e c6 00 00 00    	jle    80103606 <pipewrite+0xe6>
80103540:	8b 45 0c             	mov    0xc(%ebp),%eax
80103543:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
80103549:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
8010354f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103555:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103558:	03 45 10             	add    0x10(%ebp),%eax
8010355b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010355e:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103564:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010356a:	39 d1                	cmp    %edx,%ecx
8010356c:	0f 85 cf 00 00 00    	jne    80103641 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
80103572:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103578:	85 d2                	test   %edx,%edx
8010357a:	0f 84 a8 00 00 00    	je     80103628 <pipewrite+0x108>
80103580:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103587:	8b 42 40             	mov    0x40(%edx),%eax
8010358a:	85 c0                	test   %eax,%eax
8010358c:	74 25                	je     801035b3 <pipewrite+0x93>
8010358e:	e9 95 00 00 00       	jmp    80103628 <pipewrite+0x108>
80103593:	90                   	nop
80103594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103598:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010359e:	85 c0                	test   %eax,%eax
801035a0:	0f 84 82 00 00 00    	je     80103628 <pipewrite+0x108>
801035a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035ac:	8b 40 40             	mov    0x40(%eax),%eax
801035af:	85 c0                	test   %eax,%eax
801035b1:	75 75                	jne    80103628 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035b3:	83 ec 0c             	sub    $0xc,%esp
801035b6:	56                   	push   %esi
801035b7:	e8 b4 0b 00 00       	call   80104170 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035bc:	59                   	pop    %ecx
801035bd:	58                   	pop    %eax
801035be:	57                   	push   %edi
801035bf:	53                   	push   %ebx
801035c0:	e8 eb 08 00 00       	call   80103eb0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c5:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801035cb:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801035d1:	83 c4 10             	add    $0x10,%esp
801035d4:	05 00 02 00 00       	add    $0x200,%eax
801035d9:	39 c2                	cmp    %eax,%edx
801035db:	74 bb                	je     80103598 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035e0:	8d 4a 01             	lea    0x1(%edx),%ecx
801035e3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801035e7:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035ed:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801035f3:	0f b6 00             	movzbl (%eax),%eax
801035f6:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
801035fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801035fd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80103600:	0f 85 58 ff ff ff    	jne    8010355e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103606:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
8010360c:	83 ec 0c             	sub    $0xc,%esp
8010360f:	52                   	push   %edx
80103610:	e8 5b 0b 00 00       	call   80104170 <wakeup>
  release(&p->lock);
80103615:	89 3c 24             	mov    %edi,(%esp)
80103618:	e8 23 10 00 00       	call   80104640 <release>
  return n;
8010361d:	83 c4 10             	add    $0x10,%esp
80103620:	8b 45 10             	mov    0x10(%ebp),%eax
80103623:	eb 14                	jmp    80103639 <pipewrite+0x119>
80103625:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103628:	83 ec 0c             	sub    $0xc,%esp
8010362b:	57                   	push   %edi
8010362c:	e8 0f 10 00 00       	call   80104640 <release>
        return -1;
80103631:	83 c4 10             	add    $0x10,%esp
80103634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103639:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010363c:	5b                   	pop    %ebx
8010363d:	5e                   	pop    %esi
8010363e:	5f                   	pop    %edi
8010363f:	5d                   	pop    %ebp
80103640:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103641:	89 ca                	mov    %ecx,%edx
80103643:	eb 98                	jmp    801035dd <pipewrite+0xbd>
80103645:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103650 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 18             	sub    $0x18,%esp
80103659:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010365c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010365f:	53                   	push   %ebx
80103660:	e8 fb 0d 00 00       	call   80104460 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103665:	83 c4 10             	add    $0x10,%esp
80103668:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103674:	75 6a                	jne    801036e0 <piperead+0x90>
80103676:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010367c:	85 f6                	test   %esi,%esi
8010367e:	0f 84 cc 00 00 00    	je     80103750 <piperead+0x100>
80103684:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010368a:	eb 2d                	jmp    801036b9 <piperead+0x69>
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103690:	83 ec 08             	sub    $0x8,%esp
80103693:	53                   	push   %ebx
80103694:	56                   	push   %esi
80103695:	e8 16 08 00 00       	call   80103eb0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801036a3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801036a9:	75 35                	jne    801036e0 <piperead+0x90>
801036ab:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801036b1:	85 d2                	test   %edx,%edx
801036b3:	0f 84 97 00 00 00    	je     80103750 <piperead+0x100>
    if(proc->killed){
801036b9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801036c0:	8b 4a 40             	mov    0x40(%edx),%ecx
801036c3:	85 c9                	test   %ecx,%ecx
801036c5:	74 c9                	je     80103690 <piperead+0x40>
      release(&p->lock);
801036c7:	83 ec 0c             	sub    $0xc,%esp
801036ca:	53                   	push   %ebx
801036cb:	e8 70 0f 00 00       	call   80104640 <release>
      return -1;
801036d0:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036d3:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801036d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036db:	5b                   	pop    %ebx
801036dc:	5e                   	pop    %esi
801036dd:	5f                   	pop    %edi
801036de:	5d                   	pop    %ebp
801036df:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036e0:	8b 45 10             	mov    0x10(%ebp),%eax
801036e3:	85 c0                	test   %eax,%eax
801036e5:	7e 69                	jle    80103750 <piperead+0x100>
    if(p->nread == p->nwrite)
801036e7:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036ed:	31 c9                	xor    %ecx,%ecx
801036ef:	eb 15                	jmp    80103706 <piperead+0xb6>
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f8:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036fe:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
80103704:	74 5a                	je     80103760 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103706:	8d 72 01             	lea    0x1(%edx),%esi
80103709:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010370f:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103715:	0f b6 54 13 34       	movzbl 0x34(%ebx,%edx,1),%edx
8010371a:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	83 c1 01             	add    $0x1,%ecx
80103720:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103723:	75 d3                	jne    801036f8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103725:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	52                   	push   %edx
8010372f:	e8 3c 0a 00 00       	call   80104170 <wakeup>
  release(&p->lock);
80103734:	89 1c 24             	mov    %ebx,(%esp)
80103737:	e8 04 0f 00 00       	call   80104640 <release>
  return i;
8010373c:	8b 45 10             	mov    0x10(%ebp),%eax
8010373f:	83 c4 10             	add    $0x10,%esp
}
80103742:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103745:	5b                   	pop    %ebx
80103746:	5e                   	pop    %esi
80103747:	5f                   	pop    %edi
80103748:	5d                   	pop    %ebp
80103749:	c3                   	ret    
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103750:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103757:	eb cc                	jmp    80103725 <piperead+0xd5>
80103759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103760:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103763:	eb c0                	jmp    80103725 <piperead+0xd5>
80103765:	66 90                	xchg   %ax,%ax
80103767:	66 90                	xchg   %ax,%ax
80103769:	66 90                	xchg   %ax,%ax
8010376b:	66 90                	xchg   %ax,%ax
8010376d:	66 90                	xchg   %ax,%ax
8010376f:	90                   	nop

80103770 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103774:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103779:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010377c:	68 a0 2d 11 80       	push   $0x80112da0
80103781:	e8 da 0c 00 00       	call   80104460 <acquire>
80103786:	83 c4 10             	add    $0x10,%esp
80103789:	eb 17                	jmp    801037a2 <allocproc+0x32>
8010378b:	90                   	nop
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103790:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103796:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
8010379c:	0f 84 9e 00 00 00    	je     80103840 <allocproc+0xd0>
    if(p->state == UNUSED)
801037a2:	8b 43 28             	mov    0x28(%ebx),%eax
801037a5:	85 c0                	test   %eax,%eax
801037a7:	75 e7                	jne    80103790 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037a9:	a1 08 a0 10 80       	mov    0x8010a008,%eax
  p->rtime=0;
  p->GRT=0;
  p->myquantum = 0;
  p->queuelevel = 3;
  p->priority=ticks;
  release(&ptable.lock);
801037ae:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801037b1:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  p->rtime=0;
  p->GRT=0;
  p->myquantum = 0;
  p->queuelevel = 3;
  p->priority=ticks;
  release(&ptable.lock);
801037b8:	68 a0 2d 11 80       	push   $0x80112da0

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->ctime= ticks;
  p->rtime=0;
801037bd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  p->GRT=0;
801037c4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  p->myquantum = 0;
801037cb:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d2:	8d 50 01             	lea    0x1(%eax),%edx
801037d5:	89 43 2c             	mov    %eax,0x2c(%ebx)
  p->ctime= ticks;
801037d8:	a1 20 5c 11 80       	mov    0x80115c20,%eax
  p->rtime=0;
  p->GRT=0;
  p->myquantum = 0;
  p->queuelevel = 3;
801037dd:	c7 43 18 03 00 00 00 	movl   $0x3,0x18(%ebx)
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e4:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
  p->ctime= ticks;
801037ea:	89 43 04             	mov    %eax,0x4(%ebx)
  p->rtime=0;
  p->GRT=0;
  p->myquantum = 0;
  p->queuelevel = 3;
  p->priority=ticks;
801037ed:	89 43 14             	mov    %eax,0x14(%ebx)
  release(&ptable.lock);
801037f0:	e8 4b 0e 00 00       	call   80104640 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037f5:	e8 a6 ec ff ff       	call   801024a0 <kalloc>
801037fa:	83 c4 10             	add    $0x10,%esp
801037fd:	85 c0                	test   %eax,%eax
801037ff:	89 43 24             	mov    %eax,0x24(%ebx)
80103802:	74 53                	je     80103857 <allocproc+0xe7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103804:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010380a:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010380d:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103812:	89 53 34             	mov    %edx,0x34(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103815:	c7 40 14 4e 59 10 80 	movl   $0x8010594e,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381c:	6a 14                	push   $0x14
8010381e:	6a 00                	push   $0x0
80103820:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103821:	89 43 38             	mov    %eax,0x38(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103824:	e8 67 0e 00 00       	call   80104690 <memset>
  p->context->eip = (uint)forkret;
80103829:	8b 43 38             	mov    0x38(%ebx),%eax

  return p;
8010382c:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
8010382f:	c7 40 10 60 38 10 80 	movl   $0x80103860,0x10(%eax)

  return p;
80103836:	89 d8                	mov    %ebx,%eax
}
80103838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010383b:	c9                   	leave  
8010383c:	c3                   	ret    
8010383d:	8d 76 00             	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
80103843:	68 a0 2d 11 80       	push   $0x80112da0
80103848:	e8 f3 0d 00 00       	call   80104640 <release>
  return 0;
8010384d:	83 c4 10             	add    $0x10,%esp
80103850:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103855:	c9                   	leave  
80103856:	c3                   	ret    
  p->priority=ticks;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103857:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
    return 0;
8010385e:	eb d8                	jmp    80103838 <allocproc+0xc8>

80103860 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103866:	68 a0 2d 11 80       	push   $0x80112da0
8010386b:	e8 d0 0d 00 00       	call   80104640 <release>

  if (first) {
80103870:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103875:	83 c4 10             	add    $0x10,%esp
80103878:	85 c0                	test   %eax,%eax
8010387a:	75 04                	jne    80103880 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010387c:	c9                   	leave  
8010387d:	c3                   	ret    
8010387e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103880:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103883:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010388a:	00 00 00 
    iinit(ROOTDEV);
8010388d:	6a 01                	push   $0x1
8010388f:	e8 dc db ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103894:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010389b:	e8 a0 f2 ff ff       	call   80102b40 <initlog>
801038a0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038a3:	c9                   	leave  
801038a4:	c3                   	ret    
801038a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038b0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038b6:	68 6d 77 10 80       	push   $0x8010776d
801038bb:	68 a0 2d 11 80       	push   $0x80112da0
801038c0:	e8 7b 0b 00 00       	call   80104440 <initlock>
}
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	c9                   	leave  
801038c9:	c3                   	ret    
801038ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038d0 <userinit>:

  }
}
void
userinit(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801038d7:	e8 94 fe ff ff       	call   80103770 <allocproc>
801038dc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801038de:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801038e3:	e8 e8 32 00 00       	call   80106bd0 <setupkvm>
801038e8:	85 c0                	test   %eax,%eax
801038ea:	89 43 20             	mov    %eax,0x20(%ebx)
801038ed:	0f 84 cb 00 00 00    	je     801039be <userinit+0xee>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038f3:	83 ec 04             	sub    $0x4,%esp
801038f6:	68 2c 00 00 00       	push   $0x2c
801038fb:	68 60 a4 10 80       	push   $0x8010a460
80103900:	50                   	push   %eax
80103901:	e8 1a 34 00 00       	call   80106d20 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103906:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103909:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010390f:	6a 4c                	push   $0x4c
80103911:	6a 00                	push   $0x0
80103913:	ff 73 34             	pushl  0x34(%ebx)
80103916:	e8 75 0d 00 00       	call   80104690 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010391b:	8b 43 34             	mov    0x34(%ebx),%eax
8010391e:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103923:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103928:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010392b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010392f:	8b 43 34             	mov    0x34(%ebx),%eax
80103932:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103936:	8b 43 34             	mov    0x34(%ebx),%eax
80103939:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010393d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103941:	8b 43 34             	mov    0x34(%ebx),%eax
80103944:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103948:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010394c:	8b 43 34             	mov    0x34(%ebx),%eax
8010394f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103956:	8b 43 34             	mov    0x34(%ebx),%eax
80103959:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103960:	8b 43 34             	mov    0x34(%ebx),%eax
80103963:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010396a:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80103970:	6a 10                	push   $0x10
80103972:	68 8d 77 10 80       	push   $0x8010778d
80103977:	50                   	push   %eax
80103978:	e8 13 0f 00 00       	call   80104890 <safestrcpy>
  p->cwd = namei("/");
8010397d:	c7 04 24 96 77 10 80 	movl   $0x80107796,(%esp)
80103984:	e8 27 e5 ff ff       	call   80101eb0 <namei>
80103989:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010398f:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103996:	e8 c5 0a 00 00       	call   80104460 <acquire>

  p->state = RUNNABLE;
  p->priority = ticks;
8010399b:	a1 20 5c 11 80       	mov    0x80115c20,%eax
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;
801039a0:	c7 43 28 03 00 00 00 	movl   $0x3,0x28(%ebx)
  p->priority = ticks;
801039a7:	89 43 14             	mov    %eax,0x14(%ebx)
  
  release(&ptable.lock);
801039aa:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801039b1:	e8 8a 0c 00 00       	call   80104640 <release>
}
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039bc:	c9                   	leave  
801039bd:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801039be:	83 ec 0c             	sub    $0xc,%esp
801039c1:	68 74 77 10 80       	push   $0x80107774
801039c6:	e8 a5 c9 ff ff       	call   80100370 <panic>
801039cb:	90                   	nop
801039cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039d0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	83 ec 08             	sub    $0x8,%esp
  uint sz;

  sz = proc->sz;
801039d6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801039dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801039e0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801039e2:	83 f9 00             	cmp    $0x0,%ecx
801039e5:	7e 39                	jle    80103a20 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801039e7:	83 ec 04             	sub    $0x4,%esp
801039ea:	01 c1                	add    %eax,%ecx
801039ec:	51                   	push   %ecx
801039ed:	50                   	push   %eax
801039ee:	ff 72 20             	pushl  0x20(%edx)
801039f1:	e8 6a 34 00 00       	call   80106e60 <allocuvm>
801039f6:	83 c4 10             	add    $0x10,%esp
801039f9:	85 c0                	test   %eax,%eax
801039fb:	74 3b                	je     80103a38 <growproc+0x68>
801039fd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103a04:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103a06:	83 ec 0c             	sub    $0xc,%esp
80103a09:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
80103a10:	e8 6b 32 00 00       	call   80106c80 <switchuvm>
  return 0;
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	31 c0                	xor    %eax,%eax
}
80103a1a:	c9                   	leave  
80103a1b:	c3                   	ret    
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103a20:	74 e2                	je     80103a04 <growproc+0x34>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a22:	83 ec 04             	sub    $0x4,%esp
80103a25:	01 c1                	add    %eax,%ecx
80103a27:	51                   	push   %ecx
80103a28:	50                   	push   %eax
80103a29:	ff 72 20             	pushl  0x20(%edx)
80103a2c:	e8 2f 35 00 00       	call   80106f60 <deallocuvm>
80103a31:	83 c4 10             	add    $0x10,%esp
80103a34:	85 c0                	test   %eax,%eax
80103a36:	75 c5                	jne    801039fd <growproc+0x2d>
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103a3d:	c9                   	leave  
80103a3e:	c3                   	ret    
80103a3f:	90                   	nop

80103a40 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	57                   	push   %edi
80103a44:	56                   	push   %esi
80103a45:	53                   	push   %ebx
80103a46:	83 ec 0c             	sub    $0xc,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103a49:	e8 22 fd ff ff       	call   80103770 <allocproc>
80103a4e:	85 c0                	test   %eax,%eax
80103a50:	0f 84 e9 00 00 00    	je     80103b3f <fork+0xff>
80103a56:	89 c3                	mov    %eax,%ebx
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103a58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a5e:	83 ec 08             	sub    $0x8,%esp
80103a61:	ff 30                	pushl  (%eax)
80103a63:	ff 70 20             	pushl  0x20(%eax)
80103a66:	e8 d5 35 00 00       	call   80107040 <copyuvm>
80103a6b:	83 c4 10             	add    $0x10,%esp
80103a6e:	85 c0                	test   %eax,%eax
80103a70:	89 43 20             	mov    %eax,0x20(%ebx)
80103a73:	0f 84 cd 00 00 00    	je     80103b46 <fork+0x106>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103a7f:	8b 7b 34             	mov    0x34(%ebx),%edi
80103a82:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103a87:	8b 00                	mov    (%eax),%eax
80103a89:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103a8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a91:	89 43 30             	mov    %eax,0x30(%ebx)
  *np->tf = *proc->tf;
80103a94:	8b 70 34             	mov    0x34(%eax),%esi
80103a97:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a99:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a9b:	8b 43 34             	mov    0x34(%ebx),%eax
80103a9e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103aa5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103ab0:	8b 44 b2 44          	mov    0x44(%edx,%esi,4),%eax
80103ab4:	85 c0                	test   %eax,%eax
80103ab6:	74 17                	je     80103acf <fork+0x8f>
      np->ofile[i] = filedup(proc->ofile[i]);
80103ab8:	83 ec 0c             	sub    $0xc,%esp
80103abb:	50                   	push   %eax
80103abc:	e8 1f d3 ff ff       	call   80100de0 <filedup>
80103ac1:	89 44 b3 44          	mov    %eax,0x44(%ebx,%esi,4)
80103ac5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103acc:	83 c4 10             	add    $0x10,%esp
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103acf:	83 c6 01             	add    $0x1,%esi
80103ad2:	83 fe 10             	cmp    $0x10,%esi
80103ad5:	75 d9                	jne    80103ab0 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103ad7:	83 ec 0c             	sub    $0xc,%esp
80103ada:	ff b2 84 00 00 00    	pushl  0x84(%edx)
80103ae0:	e8 5b db ff ff       	call   80101640 <idup>
80103ae5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103aeb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103af1:	83 c4 0c             	add    $0xc,%esp
80103af4:	6a 10                	push   $0x10
80103af6:	05 88 00 00 00       	add    $0x88,%eax
80103afb:	50                   	push   %eax
80103afc:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80103b02:	50                   	push   %eax
80103b03:	e8 88 0d 00 00       	call   80104890 <safestrcpy>

  pid = np->pid;
80103b08:	8b 73 2c             	mov    0x2c(%ebx),%esi

  acquire(&ptable.lock);
80103b0b:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103b12:	e8 49 09 00 00       	call   80104460 <acquire>

  np->state = RUNNABLE;
  np->priority = ticks;
80103b17:	a1 20 5c 11 80       	mov    0x80115c20,%eax

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
80103b1c:	c7 43 28 03 00 00 00 	movl   $0x3,0x28(%ebx)
  np->priority = ticks;
80103b23:	89 43 14             	mov    %eax,0x14(%ebx)
  release(&ptable.lock);
80103b26:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103b2d:	e8 0e 0b 00 00       	call   80104640 <release>

  return pid;
80103b32:	83 c4 10             	add    $0x10,%esp
80103b35:	89 f0                	mov    %esi,%eax
}
80103b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b3a:	5b                   	pop    %ebx
80103b3b:	5e                   	pop    %esi
80103b3c:	5f                   	pop    %edi
80103b3d:	5d                   	pop    %ebp
80103b3e:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103b3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b44:	eb f1                	jmp    80103b37 <fork+0xf7>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103b46:	83 ec 0c             	sub    $0xc,%esp
80103b49:	ff 73 24             	pushl  0x24(%ebx)
80103b4c:	e8 9f e7 ff ff       	call   801022f0 <kfree>
    np->kstack = 0;
80103b51:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    np->state = UNUSED;
80103b58:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
    return -1;
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b67:	eb ce                	jmp    80103b37 <fork+0xf7>
80103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b70 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 0c             	sub    $0xc,%esp
80103b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b80:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b81:	83 ec 0c             	sub    $0xc,%esp
    }
	
else if (SCHEDFLAG == 2){	
	
	 // rr policy 
	uint tmp=ticks;
80103b84:	31 db                	xor    %ebx,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b86:	68 a0 2d 11 80       	push   $0x80112da0
80103b8b:	e8 d0 08 00 00       	call   80104460 <acquire>
    }
	
else if (SCHEDFLAG == 2){	
	
	 // rr policy 
	uint tmp=ticks;
80103b90:	8b 3d 20 5c 11 80    	mov    0x80115c20,%edi
80103b96:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
80103b9d:	83 c4 10             	add    $0x10,%esp
	uint tmp2=tmp;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ba0:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
    }
	
else if (SCHEDFLAG == 2){	
	
	 // rr policy 
	uint tmp=ticks;
80103ba5:	89 f9                	mov    %edi,%ecx
80103ba7:	eb 13                	jmp    80103bbc <scheduler+0x4c>
80103ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	uint tmp2=tmp;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bb0:	05 98 00 00 00       	add    $0x98,%eax
80103bb5:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80103bba:	74 24                	je     80103be0 <scheduler+0x70>
      if(p->state != RUNNABLE)
80103bbc:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
80103bc0:	75 ee                	jne    80103bb0 <scheduler+0x40>
        continue;
	//cprintf("pid : %d  , ", p->pid);
      if((p->priority) < tmp){
80103bc2:	8b 50 14             	mov    0x14(%eax),%edx
80103bc5:	39 ca                	cmp    %ecx,%edx
80103bc7:	73 e7                	jae    80103bb0 <scheduler+0x40>
80103bc9:	89 c6                	mov    %eax,%esi
	
	 // rr policy 
	uint tmp=ticks;
	uint tmp2=tmp;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bcb:	05 98 00 00 00       	add    $0x98,%eax
80103bd0:	89 d1                	mov    %edx,%ecx
80103bd2:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80103bd7:	bb 01 00 00 00       	mov    $0x1,%ebx
80103bdc:	75 de                	jne    80103bbc <scheduler+0x4c>
80103bde:	66 90                	xchg   %ax,%ax
80103be0:	84 db                	test   %bl,%bl
80103be2:	75 6c                	jne    80103c50 <scheduler+0xe0>
	tmp=proc->priority;
	}
      }
     

	if(tmp!=tmp2){
80103be4:	39 f9                	cmp    %edi,%ecx
80103be6:	74 53                	je     80103c3b <scheduler+0xcb>

	proc->myquantum = 0;
80103be8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
	switchuvm(proc);
80103bee:	83 ec 0c             	sub    $0xc,%esp
      }
     

	if(tmp!=tmp2){

	proc->myquantum = 0;
80103bf1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	switchuvm(proc);
80103bf8:	50                   	push   %eax
80103bf9:	e8 82 30 00 00       	call   80106c80 <switchuvm>
	proc->priority=ticks;
80103bfe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c04:	8b 15 20 5c 11 80    	mov    0x80115c20,%edx
	proc->state = RUNNING;
80103c0a:	c7 40 28 04 00 00 00 	movl   $0x4,0x28(%eax)

	if(tmp!=tmp2){

	proc->myquantum = 0;
	switchuvm(proc);
	proc->priority=ticks;
80103c11:	89 50 14             	mov    %edx,0x14(%eax)
	proc->state = RUNNING;
	swtch(&cpu->scheduler, proc->context);
80103c14:	5a                   	pop    %edx
80103c15:	59                   	pop    %ecx
80103c16:	ff 70 38             	pushl  0x38(%eax)
80103c19:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c1f:	83 c0 04             	add    $0x4,%eax
80103c22:	50                   	push   %eax
80103c23:	e8 c3 0c 00 00       	call   801048eb <swtch>
	switchkvm();
80103c28:	e8 33 30 00 00       	call   80106c60 <switchkvm>
	//cprintf("\n");
	
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103c2d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103c34:	00 00 00 00 
80103c38:	83 c4 10             	add    $0x10,%esp
		
			}
		}
	}
}
    release(&ptable.lock);
80103c3b:	83 ec 0c             	sub    $0xc,%esp
80103c3e:	68 a0 2d 11 80       	push   $0x80112da0
80103c43:	e8 f8 09 00 00       	call   80104640 <release>

  }
80103c48:	83 c4 10             	add    $0x10,%esp
80103c4b:	e9 30 ff ff ff       	jmp    80103b80 <scheduler+0x10>
80103c50:	65 89 35 04 00 00 00 	mov    %esi,%gs:0x4
80103c57:	eb 8b                	jmp    80103be4 <scheduler+0x74>
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 10             	sub    $0x10,%esp
  int intena;

  if(!holding(&ptable.lock))
80103c67:	68 a0 2d 11 80       	push   $0x80112da0
80103c6c:	e8 1f 09 00 00       	call   80104590 <holding>
80103c71:	83 c4 10             	add    $0x10,%esp
80103c74:	85 c0                	test   %eax,%eax
80103c76:	74 4c                	je     80103cc4 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103c78:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103c7f:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103c86:	75 63                	jne    80103ceb <sched+0x8b>
    panic("sched locks");
  if(proc->state == RUNNING)
80103c88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c8e:	83 78 28 04          	cmpl   $0x4,0x28(%eax)
80103c92:	74 4a                	je     80103cde <sched+0x7e>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c94:	9c                   	pushf  
80103c95:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103c96:	80 e5 02             	and    $0x2,%ch
80103c99:	75 36                	jne    80103cd1 <sched+0x71>
    }

	for(int i =0 ; i<size ; i++)
		cprintf("%d:%d , ", i, pid[i]);
*/
  swtch(&proc->context, cpu->scheduler);	
80103c9b:	83 ec 08             	sub    $0x8,%esp
80103c9e:	83 c0 38             	add    $0x38,%eax
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
80103ca1:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
    }

	for(int i =0 ; i<size ; i++)
		cprintf("%d:%d , ", i, pid[i]);
*/
  swtch(&proc->context, cpu->scheduler);	
80103ca7:	ff 72 04             	pushl  0x4(%edx)
80103caa:	50                   	push   %eax
80103cab:	e8 3b 0c 00 00       	call   801048eb <swtch>
  cpu->intena = intena;
80103cb0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax

	
     
}
80103cb6:	83 c4 10             	add    $0x10,%esp

	for(int i =0 ; i<size ; i++)
		cprintf("%d:%d , ", i, pid[i]);
*/
  swtch(&proc->context, cpu->scheduler);	
  cpu->intena = intena;
80103cb9:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)

	
     
}
80103cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cc2:	c9                   	leave  
80103cc3:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	68 98 77 10 80       	push   $0x80107798
80103ccc:	e8 9f c6 ff ff       	call   80100370 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103cd1:	83 ec 0c             	sub    $0xc,%esp
80103cd4:	68 c4 77 10 80       	push   $0x801077c4
80103cd9:	e8 92 c6 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103cde:	83 ec 0c             	sub    $0xc,%esp
80103ce1:	68 b6 77 10 80       	push   $0x801077b6
80103ce6:	e8 85 c6 ff ff       	call   80100370 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103ceb:	83 ec 0c             	sub    $0xc,%esp
80103cee:	68 aa 77 10 80       	push   $0x801077aa
80103cf3:	e8 78 c6 ff ff       	call   80100370 <panic>
80103cf8:	90                   	nop
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d00 <exit>:
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
80103d00:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103d07:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d0d:	55                   	push   %ebp
80103d0e:	89 e5                	mov    %esp,%ebp
80103d10:	56                   	push   %esi
80103d11:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103d12:	0f 84 44 01 00 00    	je     80103e5c <exit+0x15c>
80103d18:	31 db                	xor    %ebx,%ebx
80103d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103d20:	8d 73 10             	lea    0x10(%ebx),%esi
80103d23:	8b 44 b2 04          	mov    0x4(%edx,%esi,4),%eax
80103d27:	85 c0                	test   %eax,%eax
80103d29:	74 1b                	je     80103d46 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103d2b:	83 ec 0c             	sub    $0xc,%esp
80103d2e:	50                   	push   %eax
80103d2f:	e8 fc d0 ff ff       	call   80100e30 <fileclose>
      proc->ofile[fd] = 0;
80103d34:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103d3b:	83 c4 10             	add    $0x10,%esp
80103d3e:	c7 44 b2 04 00 00 00 	movl   $0x0,0x4(%edx,%esi,4)
80103d45:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103d46:	83 c3 01             	add    $0x1,%ebx
80103d49:	83 fb 10             	cmp    $0x10,%ebx
80103d4c:	75 d2                	jne    80103d20 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103d4e:	e8 8d ee ff ff       	call   80102be0 <begin_op>
  iput(proc->cwd);
80103d53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d59:	83 ec 0c             	sub    $0xc,%esp
80103d5c:	ff b0 84 00 00 00    	pushl  0x84(%eax)
80103d62:	e8 39 da ff ff       	call   801017a0 <iput>
  end_op();
80103d67:	e8 e4 ee ff ff       	call   80102c50 <end_op>
  proc->cwd = 0;
80103d6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d72:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80103d79:	00 00 00 

  acquire(&ptable.lock);
80103d7c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d83:	e8 d8 06 00 00       	call   80104460 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d88:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103d8f:	8b 35 20 5c 11 80    	mov    0x80115c20,%esi
80103d95:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d98:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d9d:	8b 51 30             	mov    0x30(%ecx),%edx
80103da0:	eb 12                	jmp    80103db4 <exit+0xb4>
80103da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103da8:	05 98 00 00 00       	add    $0x98,%eax
80103dad:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80103db2:	74 21                	je     80103dd5 <exit+0xd5>
    if(p->state == SLEEPING && p->chan == chan){
80103db4:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80103db8:	75 ee                	jne    80103da8 <exit+0xa8>
80103dba:	3b 50 3c             	cmp    0x3c(%eax),%edx
80103dbd:	75 e9                	jne    80103da8 <exit+0xa8>
      p->state = RUNNABLE;
80103dbf:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
      p->priority = ticks;
80103dc6:	89 70 14             	mov    %esi,0x14(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc9:	05 98 00 00 00       	add    $0x98,%eax
80103dce:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80103dd3:	75 df                	jne    80103db4 <exit+0xb4>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103dd5:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103ddb:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103de0:	eb 14                	jmp    80103df6 <exit+0xf6>
80103de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de8:	81 c2 98 00 00 00    	add    $0x98,%edx
80103dee:	81 fa d4 53 11 80    	cmp    $0x801153d4,%edx
80103df4:	74 3d                	je     80103e33 <exit+0x133>
    if(p->parent == proc){
80103df6:	3b 4a 30             	cmp    0x30(%edx),%ecx
80103df9:	75 ed                	jne    80103de8 <exit+0xe8>
      p->parent = initproc;
      if(p->state == ZOMBIE){
80103dfb:	83 7a 28 05          	cmpl   $0x5,0x28(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103dff:	89 5a 30             	mov    %ebx,0x30(%edx)
      if(p->state == ZOMBIE){
80103e02:	75 e4                	jne    80103de8 <exit+0xe8>
80103e04:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103e09:	eb 11                	jmp    80103e1c <exit+0x11c>
80103e0b:	90                   	nop
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e10:	05 98 00 00 00       	add    $0x98,%eax
80103e15:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
80103e1a:	74 cc                	je     80103de8 <exit+0xe8>
    if(p->state == SLEEPING && p->chan == chan){
80103e1c:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80103e20:	75 ee                	jne    80103e10 <exit+0x110>
80103e22:	3b 58 3c             	cmp    0x3c(%eax),%ebx
80103e25:	75 e9                	jne    80103e10 <exit+0x110>
      p->state = RUNNABLE;
80103e27:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
      p->priority = ticks;
80103e2e:	89 70 14             	mov    %esi,0x14(%eax)
80103e31:	eb dd                	jmp    80103e10 <exit+0x110>

  // Jump into the scheduler, never to return.
  
  proc->state = ZOMBIE;
  proc->etime= ticks;  
  cprintf("etime :D %d\n", proc->etime);
80103e33:	83 ec 08             	sub    $0x8,%esp
    }
  }

  // Jump into the scheduler, never to return.
  
  proc->state = ZOMBIE;
80103e36:	c7 41 28 05 00 00 00 	movl   $0x5,0x28(%ecx)
  proc->etime= ticks;  
80103e3d:	89 71 08             	mov    %esi,0x8(%ecx)
  cprintf("etime :D %d\n", proc->etime);
80103e40:	56                   	push   %esi
80103e41:	68 e5 77 10 80       	push   $0x801077e5
80103e46:	e8 15 c8 ff ff       	call   80100660 <cprintf>
  sched();
80103e4b:	e8 10 fe ff ff       	call   80103c60 <sched>
  panic("zombie exit");
80103e50:	c7 04 24 f2 77 10 80 	movl   $0x801077f2,(%esp)
80103e57:	e8 14 c5 ff ff       	call   80100370 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103e5c:	83 ec 0c             	sub    $0xc,%esp
80103e5f:	68 d8 77 10 80       	push   $0x801077d8
80103e64:	e8 07 c5 ff ff       	call   80100370 <panic>
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e70 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e76:	68 a0 2d 11 80       	push   $0x80112da0
80103e7b:	e8 e0 05 00 00       	call   80104460 <acquire>
  proc->priority = ticks;
80103e80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e86:	8b 15 20 5c 11 80    	mov    0x80115c20,%edx
  proc->state = RUNNABLE;
80103e8c:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->priority = ticks;
80103e93:	89 50 14             	mov    %edx,0x14(%eax)
  proc->state = RUNNABLE;
  sched();
80103e96:	e8 c5 fd ff ff       	call   80103c60 <sched>
  release(&ptable.lock);
80103e9b:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ea2:	e8 99 07 00 00       	call   80104640 <release>

}
80103ea7:	83 c4 10             	add    $0x10,%esp
80103eaa:	c9                   	leave  
80103eab:	c3                   	ret    
80103eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103eb0 <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
80103eb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103eb6:	55                   	push   %ebp
80103eb7:	89 e5                	mov    %esp,%ebp
80103eb9:	56                   	push   %esi
80103eba:	53                   	push   %ebx
  if(proc == 0)
80103ebb:	85 c0                	test   %eax,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103ebd:	8b 75 08             	mov    0x8(%ebp),%esi
80103ec0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103ec3:	0f 84 97 00 00 00    	je     80103f60 <sleep+0xb0>
    panic("sleep");

  if(lk == 0)
80103ec9:	85 db                	test   %ebx,%ebx
80103ecb:	0f 84 82 00 00 00    	je     80103f53 <sleep+0xa3>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ed1:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103ed7:	74 57                	je     80103f30 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ed9:	83 ec 0c             	sub    $0xc,%esp
80103edc:	68 a0 2d 11 80       	push   $0x80112da0
80103ee1:	e8 7a 05 00 00       	call   80104460 <acquire>
    release(lk);
80103ee6:	89 1c 24             	mov    %ebx,(%esp)
80103ee9:	e8 52 07 00 00       	call   80104640 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103eee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ef4:	89 70 3c             	mov    %esi,0x3c(%eax)
  proc->state = SLEEPING;
80103ef7:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
  sched();
80103efe:	e8 5d fd ff ff       	call   80103c60 <sched>

  // Tidy up.
  proc->chan = 0;
80103f03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f09:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103f10:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f17:	e8 24 07 00 00       	call   80104640 <release>
    acquire(lk);
80103f1c:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103f1f:	83 c4 10             	add    $0x10,%esp
  }
}
80103f22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f25:	5b                   	pop    %ebx
80103f26:	5e                   	pop    %esi
80103f27:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103f28:	e9 33 05 00 00       	jmp    80104460 <acquire>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103f30:	89 70 3c             	mov    %esi,0x3c(%eax)
  proc->state = SLEEPING;
80103f33:	c7 40 28 02 00 00 00 	movl   $0x2,0x28(%eax)
  sched();
80103f3a:	e8 21 fd ff ff       	call   80103c60 <sched>

  // Tidy up.
  proc->chan = 0;
80103f3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f45:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103f4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f4f:	5b                   	pop    %ebx
80103f50:	5e                   	pop    %esi
80103f51:	5d                   	pop    %ebp
80103f52:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103f53:	83 ec 0c             	sub    $0xc,%esp
80103f56:	68 04 78 10 80       	push   $0x80107804
80103f5b:	e8 10 c4 ff ff       	call   80100370 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103f60:	83 ec 0c             	sub    $0xc,%esp
80103f63:	68 fe 77 10 80       	push   $0x801077fe
80103f68:	e8 03 c4 ff ff       	call   80100370 <panic>
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi

80103f70 <wait22>:

  return p;
}

int wait22 (char *wtime, char *rtime )
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103f75:	83 ec 0c             	sub    $0xc,%esp
80103f78:	68 a0 2d 11 80       	push   $0x80112da0
80103f7d:	e8 de 04 00 00       	call   80104460 <acquire>
80103f82:	83 c4 10             	add    $0x10,%esp
80103f85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80103f8b:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f8d:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103f92:	eb 12                	jmp    80103fa6 <wait22+0x36>
80103f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f98:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103f9e:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
80103fa4:	74 22                	je     80103fc8 <wait22+0x58>
      if(p->parent != proc)
80103fa6:	39 43 30             	cmp    %eax,0x30(%ebx)
80103fa9:	75 ed                	jne    80103f98 <wait22+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103fab:	83 7b 28 05          	cmpl   $0x5,0x28(%ebx)
80103faf:	74 3d                	je     80103fee <wait22+0x7e>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb1:	81 c3 98 00 00 00    	add    $0x98,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103fb7:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbc:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
80103fc2:	75 e2                	jne    80103fa6 <wait22+0x36>
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103fc8:	85 d2                	test   %edx,%edx
80103fca:	0f 84 8d 00 00 00    	je     8010405d <wait22+0xed>
80103fd0:	8b 50 40             	mov    0x40(%eax),%edx
80103fd3:	85 d2                	test   %edx,%edx
80103fd5:	0f 85 82 00 00 00    	jne    8010405d <wait22+0xed>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103fdb:	83 ec 08             	sub    $0x8,%esp
80103fde:	68 a0 2d 11 80       	push   $0x80112da0
80103fe3:	50                   	push   %eax
80103fe4:	e8 c7 fe ff ff       	call   80103eb0 <sleep>

  }
80103fe9:	83 c4 10             	add    $0x10,%esp
80103fec:	eb 97                	jmp    80103f85 <wait22+0x15>
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.

        // Added time field update, else same from wait system call
        *wtime = p->etime - p->ctime - p->rtime ;
80103fee:	8b 43 08             	mov    0x8(%ebx),%eax
80103ff1:	2a 43 04             	sub    0x4(%ebx),%al
        *rtime = p->rtime;

	
        // same as wait 
        pid = p->pid;
        kfree(p->kstack);
80103ff4:	83 ec 0c             	sub    $0xc,%esp
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.

        // Added time field update, else same from wait system call
        *wtime = p->etime - p->ctime - p->rtime ;
80103ff7:	2a 43 0c             	sub    0xc(%ebx),%al
80103ffa:	8b 55 08             	mov    0x8(%ebp),%edx
80103ffd:	88 02                	mov    %al,(%edx)
        *rtime = p->rtime;
80103fff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104002:	8b 53 0c             	mov    0xc(%ebx),%edx
80104005:	88 10                	mov    %dl,(%eax)

	
        // same as wait 
        pid = p->pid;
        kfree(p->kstack);
80104007:	ff 73 24             	pushl  0x24(%ebx)
        *wtime = p->etime - p->ctime - p->rtime ;
        *rtime = p->rtime;

	
        // same as wait 
        pid = p->pid;
8010400a:	8b 73 2c             	mov    0x2c(%ebx),%esi
        kfree(p->kstack);
8010400d:	e8 de e2 ff ff       	call   801022f0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104012:	59                   	pop    %ecx
80104013:	ff 73 20             	pushl  0x20(%ebx)

	
        // same as wait 
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104016:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        freevm(p->pgdir);
8010401d:	e8 6e 2f 00 00       	call   80106f90 <freevm>
        p->state = UNUSED;
80104022:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->pid = 0;
80104029:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->parent = 0;
80104030:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->name[0] = 0;
80104037:	c6 83 88 00 00 00 00 	movb   $0x0,0x88(%ebx)
        p->killed = 0;
8010403e:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
        release(&ptable.lock);
80104045:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010404c:	e8 ef 05 00 00       	call   80104640 <release>
        return pid;
80104051:	83 c4 10             	add    $0x10,%esp

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep

  }
}
80104054:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
80104057:	89 f0                	mov    %esi,%eax

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep

  }
}
80104059:	5b                   	pop    %ebx
8010405a:	5e                   	pop    %esi
8010405b:	5d                   	pop    %ebp
8010405c:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
8010405d:	83 ec 0c             	sub    $0xc,%esp
80104060:	68 a0 2d 11 80       	push   $0x80112da0
80104065:	e8 d6 05 00 00       	call   80104640 <release>
      return -1;
8010406a:	83 c4 10             	add    $0x10,%esp

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep

  }
}
8010406d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80104070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep

  }
}
80104075:	5b                   	pop    %ebx
80104076:	5e                   	pop    %esi
80104077:	5d                   	pop    %ebp
80104078:	c3                   	ret    
80104079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104080 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	56                   	push   %esi
80104084:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104085:	83 ec 0c             	sub    $0xc,%esp
80104088:	68 a0 2d 11 80       	push   $0x80112da0
8010408d:	e8 ce 03 00 00       	call   80104460 <acquire>
80104092:	83 c4 10             	add    $0x10,%esp
80104095:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010409b:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409d:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
801040a2:	eb 12                	jmp    801040b6 <wait+0x36>
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040a8:	81 c3 98 00 00 00    	add    $0x98,%ebx
801040ae:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
801040b4:	74 22                	je     801040d8 <wait+0x58>
      if(p->parent != proc)
801040b6:	3b 43 30             	cmp    0x30(%ebx),%eax
801040b9:	75 ed                	jne    801040a8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801040bb:	83 7b 28 05          	cmpl   $0x5,0x28(%ebx)
801040bf:	74 35                	je     801040f6 <wait+0x76>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c1:	81 c3 98 00 00 00    	add    $0x98,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
801040c7:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040cc:	81 fb d4 53 11 80    	cmp    $0x801153d4,%ebx
801040d2:	75 e2                	jne    801040b6 <wait+0x36>
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801040d8:	85 d2                	test   %edx,%edx
801040da:	74 73                	je     8010414f <wait+0xcf>
801040dc:	8b 50 40             	mov    0x40(%eax),%edx
801040df:	85 d2                	test   %edx,%edx
801040e1:	75 6c                	jne    8010414f <wait+0xcf>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801040e3:	83 ec 08             	sub    $0x8,%esp
801040e6:	68 a0 2d 11 80       	push   $0x80112da0
801040eb:	50                   	push   %eax
801040ec:	e8 bf fd ff ff       	call   80103eb0 <sleep>
  }
801040f1:	83 c4 10             	add    $0x10,%esp
801040f4:	eb 9f                	jmp    80104095 <wait+0x15>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	ff 73 24             	pushl  0x24(%ebx)
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801040fc:	8b 73 2c             	mov    0x2c(%ebx),%esi
        kfree(p->kstack);
801040ff:	e8 ec e1 ff ff       	call   801022f0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104104:	59                   	pop    %ecx
80104105:	ff 73 20             	pushl  0x20(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104108:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        freevm(p->pgdir);
8010410f:	e8 7c 2e 00 00       	call   80106f90 <freevm>
        p->pid = 0;
80104114:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->parent = 0;
8010411b:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->name[0] = 0;
80104122:	c6 83 88 00 00 00 00 	movb   $0x0,0x88(%ebx)
        p->killed = 0;
80104129:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
        p->state = UNUSED;
80104130:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        release(&ptable.lock);
80104137:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010413e:	e8 fd 04 00 00       	call   80104640 <release>
        return pid;
80104143:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104146:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104149:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010414b:	5b                   	pop    %ebx
8010414c:	5e                   	pop    %esi
8010414d:	5d                   	pop    %ebp
8010414e:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
8010414f:	83 ec 0c             	sub    $0xc,%esp
80104152:	68 a0 2d 11 80       	push   $0x80112da0
80104157:	e8 e4 04 00 00       	call   80104640 <release>
      return -1;
8010415c:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010415f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80104162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104167:	5b                   	pop    %ebx
80104168:	5e                   	pop    %esi
80104169:	5d                   	pop    %ebp
8010416a:	c3                   	ret    
8010416b:	90                   	nop
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104170 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 10             	sub    $0x10,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010417a:	68 a0 2d 11 80       	push   $0x80112da0
8010417f:	e8 dc 02 00 00       	call   80104460 <acquire>
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan){
      p->state = RUNNABLE;
      p->priority = ticks;
80104184:	8b 15 20 5c 11 80    	mov    0x80115c20,%edx
8010418a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010418d:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80104192:	eb 10                	jmp    801041a4 <wakeup+0x34>
80104194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104198:	05 98 00 00 00       	add    $0x98,%eax
8010419d:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
801041a2:	74 21                	je     801041c5 <wakeup+0x55>
    if(p->state == SLEEPING && p->chan == chan){
801041a4:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
801041a8:	75 ee                	jne    80104198 <wakeup+0x28>
801041aa:	3b 58 3c             	cmp    0x3c(%eax),%ebx
801041ad:	75 e9                	jne    80104198 <wakeup+0x28>
      p->state = RUNNABLE;
801041af:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
      p->priority = ticks;
801041b6:	89 50 14             	mov    %edx,0x14(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b9:	05 98 00 00 00       	add    $0x98,%eax
801041be:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
801041c3:	75 df                	jne    801041a4 <wakeup+0x34>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801041c5:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
801041cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041cf:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801041d0:	e9 6b 04 00 00       	jmp    80104640 <release>
801041d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 10             	sub    $0x10,%esp
801041e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ea:	68 a0 2d 11 80       	push   $0x80112da0
801041ef:	e8 6c 02 00 00       	call   80104460 <acquire>
801041f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f7:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
801041fc:	eb 0e                	jmp    8010420c <kill+0x2c>
801041fe:	66 90                	xchg   %ax,%ax
80104200:	05 98 00 00 00       	add    $0x98,%eax
80104205:	3d d4 53 11 80       	cmp    $0x801153d4,%eax
8010420a:	74 44                	je     80104250 <kill+0x70>
    if(p->pid == pid){
8010420c:	39 58 2c             	cmp    %ebx,0x2c(%eax)
8010420f:	75 ef                	jne    80104200 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80104211:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104215:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
8010421c:	74 1a                	je     80104238 <kill+0x58>
        p->state = RUNNABLE;
	p->priority = ticks;
      }
      release(&ptable.lock);
8010421e:	83 ec 0c             	sub    $0xc,%esp
80104221:	68 a0 2d 11 80       	push   $0x80112da0
80104226:	e8 15 04 00 00       	call   80104640 <release>
      return 0;
8010422b:	83 c4 10             	add    $0x10,%esp
8010422e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104233:	c9                   	leave  
80104234:	c3                   	ret    
80104235:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
        p->state = RUNNABLE;
	p->priority = ticks;
80104238:	8b 15 20 5c 11 80    	mov    0x80115c20,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
        p->state = RUNNABLE;
8010423e:	c7 40 28 03 00 00 00 	movl   $0x3,0x28(%eax)
	p->priority = ticks;
80104245:	89 50 14             	mov    %edx,0x14(%eax)
80104248:	eb d4                	jmp    8010421e <kill+0x3e>
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	68 a0 2d 11 80       	push   $0x80112da0
80104258:	e8 e3 03 00 00       	call   80104640 <release>
  return -1;
8010425d:	83 c4 10             	add    $0x10,%esp
80104260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104265:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104268:	c9                   	leave  
80104269:	c3                   	ret    
8010426a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104270 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104279:	bb 5c 2e 11 80       	mov    $0x80112e5c,%ebx
8010427e:	83 ec 3c             	sub    $0x3c,%esp
80104281:	eb 27                	jmp    801042aa <procdump+0x3a>
80104283:	90                   	nop
80104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104288:	83 ec 0c             	sub    $0xc,%esp
8010428b:	68 46 77 10 80       	push   $0x80107746
80104290:	e8 cb c3 ff ff       	call   80100660 <cprintf>
80104295:	83 c4 10             	add    $0x10,%esp
80104298:	81 c3 98 00 00 00    	add    $0x98,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010429e:	81 fb 5c 54 11 80    	cmp    $0x8011545c,%ebx
801042a4:	0f 84 7e 00 00 00    	je     80104328 <procdump+0xb8>
    if(p->state == UNUSED)
801042aa:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042ad:	85 c0                	test   %eax,%eax
801042af:	74 e7                	je     80104298 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042b1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801042b4:	ba 15 78 10 80       	mov    $0x80107815,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042b9:	77 11                	ja     801042cc <procdump+0x5c>
801042bb:	8b 14 85 4c 78 10 80 	mov    -0x7fef87b4(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801042c2:	b8 15 78 10 80       	mov    $0x80107815,%eax
801042c7:	85 d2                	test   %edx,%edx
801042c9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042cc:	53                   	push   %ebx
801042cd:	52                   	push   %edx
801042ce:	ff 73 a4             	pushl  -0x5c(%ebx)
801042d1:	68 19 78 10 80       	push   $0x80107819
801042d6:	e8 85 c3 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801042db:	83 c4 10             	add    $0x10,%esp
801042de:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042e2:	75 a4                	jne    80104288 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042e4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042e7:	83 ec 08             	sub    $0x8,%esp
801042ea:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042ed:	50                   	push   %eax
801042ee:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042f1:	8b 40 0c             	mov    0xc(%eax),%eax
801042f4:	83 c0 08             	add    $0x8,%eax
801042f7:	50                   	push   %eax
801042f8:	e8 33 02 00 00       	call   80104530 <getcallerpcs>
801042fd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104300:	8b 17                	mov    (%edi),%edx
80104302:	85 d2                	test   %edx,%edx
80104304:	74 82                	je     80104288 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104306:	83 ec 08             	sub    $0x8,%esp
80104309:	83 c7 04             	add    $0x4,%edi
8010430c:	52                   	push   %edx
8010430d:	68 69 72 10 80       	push   $0x80107269
80104312:	e8 49 c3 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104317:	83 c4 10             	add    $0x10,%esp
8010431a:	39 f7                	cmp    %esi,%edi
8010431c:	75 e2                	jne    80104300 <procdump+0x90>
8010431e:	e9 65 ff ff ff       	jmp    80104288 <procdump+0x18>
80104323:	90                   	nop
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104328:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432b:	5b                   	pop    %ebx
8010432c:	5e                   	pop    %esi
8010432d:	5f                   	pop    %edi
8010432e:	5d                   	pop    %ebp
8010432f:	c3                   	ret    

80104330 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 0c             	sub    $0xc,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010433a:	68 64 78 10 80       	push   $0x80107864
8010433f:	8d 43 04             	lea    0x4(%ebx),%eax
80104342:	50                   	push   %eax
80104343:	e8 f8 00 00 00       	call   80104440 <initlock>
  lk->name = name;
80104348:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010434b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104351:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104354:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010435b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010435e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104361:	c9                   	leave  
80104362:	c3                   	ret    
80104363:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104370 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	8d 73 04             	lea    0x4(%ebx),%esi
8010437e:	56                   	push   %esi
8010437f:	e8 dc 00 00 00       	call   80104460 <acquire>
  while (lk->locked) {
80104384:	8b 13                	mov    (%ebx),%edx
80104386:	83 c4 10             	add    $0x10,%esp
80104389:	85 d2                	test   %edx,%edx
8010438b:	74 16                	je     801043a3 <acquiresleep+0x33>
8010438d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104390:	83 ec 08             	sub    $0x8,%esp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
80104395:	e8 16 fb ff ff       	call   80103eb0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010439a:	8b 03                	mov    (%ebx),%eax
8010439c:	83 c4 10             	add    $0x10,%esp
8010439f:	85 c0                	test   %eax,%eax
801043a1:	75 ed                	jne    80104390 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801043a3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801043a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043af:	8b 40 2c             	mov    0x2c(%eax),%eax
801043b2:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043b5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043bb:	5b                   	pop    %ebx
801043bc:	5e                   	pop    %esi
801043bd:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801043be:	e9 7d 02 00 00       	jmp    80104640 <release>
801043c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043d0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
801043d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	8d 73 04             	lea    0x4(%ebx),%esi
801043de:	56                   	push   %esi
801043df:	e8 7c 00 00 00       	call   80104460 <acquire>
  lk->locked = 0;
801043e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043ea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043f1:	89 1c 24             	mov    %ebx,(%esp)
801043f4:	e8 77 fd ff ff       	call   80104170 <wakeup>
  release(&lk->lk);
801043f9:	89 75 08             	mov    %esi,0x8(%ebp)
801043fc:	83 c4 10             	add    $0x10,%esp
}
801043ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104402:	5b                   	pop    %ebx
80104403:	5e                   	pop    %esi
80104404:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104405:	e9 36 02 00 00       	jmp    80104640 <release>
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010441e:	53                   	push   %ebx
8010441f:	e8 3c 00 00 00       	call   80104460 <acquire>
  r = lk->locked;
80104424:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104426:	89 1c 24             	mov    %ebx,(%esp)
80104429:	e8 12 02 00 00       	call   80104640 <release>
  return r;
}
8010442e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104431:	89 f0                	mov    %esi,%eax
80104433:	5b                   	pop    %ebx
80104434:	5e                   	pop    %esi
80104435:	5d                   	pop    %ebp
80104436:	c3                   	ret    
80104437:	66 90                	xchg   %ax,%ax
80104439:	66 90                	xchg   %ax,%ax
8010443b:	66 90                	xchg   %ax,%ax
8010443d:	66 90                	xchg   %ax,%ax
8010443f:	90                   	nop

80104440 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104446:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104449:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010444f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104452:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104459:	5d                   	pop    %ebp
8010445a:	c3                   	ret    
8010445b:	90                   	nop
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104460 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 04             	sub    $0x4,%esp
80104467:	9c                   	pushf  
80104468:	5a                   	pop    %edx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104469:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
8010446a:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80104471:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
80104477:	85 c0                	test   %eax,%eax
80104479:	75 0c                	jne    80104487 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
8010447b:	81 e2 00 02 00 00    	and    $0x200,%edx
80104481:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80104487:	8b 55 08             	mov    0x8(%ebp),%edx

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
    cpu->intena = eflags & FL_IF;
  cpu->ncli += 1;
8010448a:	83 c0 01             	add    $0x1,%eax
8010448d:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104493:	8b 02                	mov    (%edx),%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	74 05                	je     8010449e <acquire+0x3e>
80104499:	39 4a 08             	cmp    %ecx,0x8(%edx)
8010449c:	74 7a                	je     80104518 <acquire+0xb8>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010449e:	b9 01 00 00 00       	mov    $0x1,%ecx
801044a3:	90                   	nop
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a8:	89 c8                	mov    %ecx,%eax
801044aa:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801044ad:	85 c0                	test   %eax,%eax
801044af:	75 f7                	jne    801044a8 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801044b1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801044b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044b9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801044bf:	89 ea                	mov    %ebp,%edx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801044c1:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
801044c4:	83 c1 0c             	add    $0xc,%ecx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044c7:	31 c0                	xor    %eax,%eax
801044c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801044d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044dc:	77 1a                	ja     801044f8 <acquire+0x98>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044de:	8b 5a 04             	mov    0x4(%edx),%ebx
801044e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044e4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801044e7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044e9:	83 f8 0a             	cmp    $0xa,%eax
801044ec:	75 e2                	jne    801044d0 <acquire+0x70>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  getcallerpcs(&lk, lk->pcs);
}
801044ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f1:	c9                   	leave  
801044f2:	c3                   	ret    
801044f3:	90                   	nop
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801044f8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801044ff:	83 c0 01             	add    $0x1,%eax
80104502:	83 f8 0a             	cmp    $0xa,%eax
80104505:	74 e7                	je     801044ee <acquire+0x8e>
    pcs[i] = 0;
80104507:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010450e:	83 c0 01             	add    $0x1,%eax
80104511:	83 f8 0a             	cmp    $0xa,%eax
80104514:	75 e2                	jne    801044f8 <acquire+0x98>
80104516:	eb d6                	jmp    801044ee <acquire+0x8e>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104518:	83 ec 0c             	sub    $0xc,%esp
8010451b:	68 6f 78 10 80       	push   $0x8010786f
80104520:	e8 4b be ff ff       	call   80100370 <panic>
80104525:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104534:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010453a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010453d:	31 c0                	xor    %eax,%eax
8010453f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104540:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104546:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010454c:	77 1a                	ja     80104568 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010454e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104551:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104554:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104557:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104559:	83 f8 0a             	cmp    $0xa,%eax
8010455c:	75 e2                	jne    80104540 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010455e:	5b                   	pop    %ebx
8010455f:	5d                   	pop    %ebp
80104560:	c3                   	ret    
80104561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104568:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010456f:	83 c0 01             	add    $0x1,%eax
80104572:	83 f8 0a             	cmp    $0xa,%eax
80104575:	74 e7                	je     8010455e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104577:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010457e:	83 c0 01             	add    $0x1,%eax
80104581:	83 f8 0a             	cmp    $0xa,%eax
80104584:	75 e2                	jne    80104568 <getcallerpcs+0x38>
80104586:	eb d6                	jmp    8010455e <getcallerpcs+0x2e>
80104588:	90                   	nop
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104590 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104596:	8b 02                	mov    (%edx),%eax
80104598:	85 c0                	test   %eax,%eax
8010459a:	74 14                	je     801045b0 <holding+0x20>
8010459c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801045a2:	39 42 08             	cmp    %eax,0x8(%edx)
}
801045a5:	5d                   	pop    %ebp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801045a6:	0f 94 c0             	sete   %al
801045a9:	0f b6 c0             	movzbl %al,%eax
}
801045ac:	c3                   	ret    
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
801045b0:	31 c0                	xor    %eax,%eax
801045b2:	5d                   	pop    %ebp
801045b3:	c3                   	ret    
801045b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801045c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045c3:	9c                   	pushf  
801045c4:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801045c5:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801045c6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801045cd:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801045d3:	85 c0                	test   %eax,%eax
801045d5:	75 0c                	jne    801045e3 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
801045d7:	81 e1 00 02 00 00    	and    $0x200,%ecx
801045dd:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
801045e3:	83 c0 01             	add    $0x1,%eax
801045e6:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
801045ec:	5d                   	pop    %ebp
801045ed:	c3                   	ret    
801045ee:	66 90                	xchg   %ax,%ax

801045f0 <popcli>:

void
popcli(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045f6:	9c                   	pushf  
801045f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045f8:	f6 c4 02             	test   $0x2,%ah
801045fb:	75 2c                	jne    80104629 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801045fd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104604:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
8010460b:	78 0f                	js     8010461c <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
8010460d:	75 0b                	jne    8010461a <popcli+0x2a>
8010460f:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104615:	85 c0                	test   %eax,%eax
80104617:	74 01                	je     8010461a <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104619:	fb                   	sti    
    sti();
}
8010461a:	c9                   	leave  
8010461b:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
8010461c:	83 ec 0c             	sub    $0xc,%esp
8010461f:	68 8e 78 10 80       	push   $0x8010788e
80104624:	e8 47 bd ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104629:	83 ec 0c             	sub    $0xc,%esp
8010462c:	68 77 78 10 80       	push   $0x80107877
80104631:	e8 3a bd ff ff       	call   80100370 <panic>
80104636:	8d 76 00             	lea    0x0(%esi),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	83 ec 08             	sub    $0x8,%esp
80104646:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104649:	8b 10                	mov    (%eax),%edx
8010464b:	85 d2                	test   %edx,%edx
8010464d:	74 0c                	je     8010465b <release+0x1b>
8010464f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104656:	39 50 08             	cmp    %edx,0x8(%eax)
80104659:	74 15                	je     80104670 <release+0x30>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010465b:	83 ec 0c             	sub    $0xc,%esp
8010465e:	68 95 78 10 80       	push   $0x80107895
80104663:	e8 08 bd ff ff       	call   80100370 <panic>
80104668:	90                   	nop
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  lk->pcs[0] = 0;
80104670:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104677:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010467e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104689:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010468a:	e9 61 ff ff ff       	jmp    801045f0 <popcli>
8010468f:	90                   	nop

80104690 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	53                   	push   %ebx
80104695:	8b 55 08             	mov    0x8(%ebp),%edx
80104698:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010469b:	f6 c2 03             	test   $0x3,%dl
8010469e:	75 05                	jne    801046a5 <memset+0x15>
801046a0:	f6 c1 03             	test   $0x3,%cl
801046a3:	74 13                	je     801046b8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801046a5:	89 d7                	mov    %edx,%edi
801046a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801046aa:	fc                   	cld    
801046ab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801046ad:	5b                   	pop    %ebx
801046ae:	89 d0                	mov    %edx,%eax
801046b0:	5f                   	pop    %edi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801046b8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801046bc:	c1 e9 02             	shr    $0x2,%ecx
801046bf:	89 fb                	mov    %edi,%ebx
801046c1:	89 f8                	mov    %edi,%eax
801046c3:	c1 e3 18             	shl    $0x18,%ebx
801046c6:	c1 e0 10             	shl    $0x10,%eax
801046c9:	09 d8                	or     %ebx,%eax
801046cb:	09 f8                	or     %edi,%eax
801046cd:	c1 e7 08             	shl    $0x8,%edi
801046d0:	09 f8                	or     %edi,%eax
801046d2:	89 d7                	mov    %edx,%edi
801046d4:	fc                   	cld    
801046d5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801046d7:	5b                   	pop    %ebx
801046d8:	89 d0                	mov    %edx,%eax
801046da:	5f                   	pop    %edi
801046db:	5d                   	pop    %ebp
801046dc:	c3                   	ret    
801046dd:	8d 76 00             	lea    0x0(%esi),%esi

801046e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	56                   	push   %esi
801046e5:	8b 45 10             	mov    0x10(%ebp),%eax
801046e8:	53                   	push   %ebx
801046e9:	8b 75 0c             	mov    0xc(%ebp),%esi
801046ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046ef:	85 c0                	test   %eax,%eax
801046f1:	74 29                	je     8010471c <memcmp+0x3c>
    if(*s1 != *s2)
801046f3:	0f b6 13             	movzbl (%ebx),%edx
801046f6:	0f b6 0e             	movzbl (%esi),%ecx
801046f9:	38 d1                	cmp    %dl,%cl
801046fb:	75 2b                	jne    80104728 <memcmp+0x48>
801046fd:	8d 78 ff             	lea    -0x1(%eax),%edi
80104700:	31 c0                	xor    %eax,%eax
80104702:	eb 14                	jmp    80104718 <memcmp+0x38>
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104708:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010470d:	83 c0 01             	add    $0x1,%eax
80104710:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104714:	38 ca                	cmp    %cl,%dl
80104716:	75 10                	jne    80104728 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104718:	39 f8                	cmp    %edi,%eax
8010471a:	75 ec                	jne    80104708 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010471c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010471d:	31 c0                	xor    %eax,%eax
}
8010471f:	5e                   	pop    %esi
80104720:	5f                   	pop    %edi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	90                   	nop
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104728:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010472b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010472c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010472e:	5e                   	pop    %esi
8010472f:	5f                   	pop    %edi
80104730:	5d                   	pop    %ebp
80104731:	c3                   	ret    
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 45 08             	mov    0x8(%ebp),%eax
80104748:	8b 75 0c             	mov    0xc(%ebp),%esi
8010474b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010474e:	39 c6                	cmp    %eax,%esi
80104750:	73 2e                	jae    80104780 <memmove+0x40>
80104752:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104755:	39 c8                	cmp    %ecx,%eax
80104757:	73 27                	jae    80104780 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104759:	85 db                	test   %ebx,%ebx
8010475b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010475e:	74 17                	je     80104777 <memmove+0x37>
      *--d = *--s;
80104760:	29 d9                	sub    %ebx,%ecx
80104762:	89 cb                	mov    %ecx,%ebx
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104768:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010476c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010476f:	83 ea 01             	sub    $0x1,%edx
80104772:	83 fa ff             	cmp    $0xffffffff,%edx
80104775:	75 f1                	jne    80104768 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104777:	5b                   	pop    %ebx
80104778:	5e                   	pop    %esi
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    
8010477b:	90                   	nop
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104780:	31 d2                	xor    %edx,%edx
80104782:	85 db                	test   %ebx,%ebx
80104784:	74 f1                	je     80104777 <memmove+0x37>
80104786:	8d 76 00             	lea    0x0(%esi),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104790:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104794:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104797:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010479a:	39 d3                	cmp    %edx,%ebx
8010479c:	75 f2                	jne    80104790 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010479e:	5b                   	pop    %ebx
8010479f:	5e                   	pop    %esi
801047a0:	5d                   	pop    %ebp
801047a1:	c3                   	ret    
801047a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801047b3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047b4:	eb 8a                	jmp    80104740 <memmove>
801047b6:	8d 76 00             	lea    0x0(%esi),%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	56                   	push   %esi
801047c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047c8:	53                   	push   %ebx
801047c9:	8b 7d 08             	mov    0x8(%ebp),%edi
801047cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801047cf:	85 c9                	test   %ecx,%ecx
801047d1:	74 37                	je     8010480a <strncmp+0x4a>
801047d3:	0f b6 17             	movzbl (%edi),%edx
801047d6:	0f b6 1e             	movzbl (%esi),%ebx
801047d9:	84 d2                	test   %dl,%dl
801047db:	74 3f                	je     8010481c <strncmp+0x5c>
801047dd:	38 d3                	cmp    %dl,%bl
801047df:	75 3b                	jne    8010481c <strncmp+0x5c>
801047e1:	8d 47 01             	lea    0x1(%edi),%eax
801047e4:	01 cf                	add    %ecx,%edi
801047e6:	eb 1b                	jmp    80104803 <strncmp+0x43>
801047e8:	90                   	nop
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f0:	0f b6 10             	movzbl (%eax),%edx
801047f3:	84 d2                	test   %dl,%dl
801047f5:	74 21                	je     80104818 <strncmp+0x58>
801047f7:	0f b6 19             	movzbl (%ecx),%ebx
801047fa:	83 c0 01             	add    $0x1,%eax
801047fd:	89 ce                	mov    %ecx,%esi
801047ff:	38 da                	cmp    %bl,%dl
80104801:	75 19                	jne    8010481c <strncmp+0x5c>
80104803:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104805:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104808:	75 e6                	jne    801047f0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010480a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010480b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010480d:	5e                   	pop    %esi
8010480e:	5f                   	pop    %edi
8010480f:	5d                   	pop    %ebp
80104810:	c3                   	ret    
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104818:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010481c:	0f b6 c2             	movzbl %dl,%eax
8010481f:	29 d8                	sub    %ebx,%eax
}
80104821:	5b                   	pop    %ebx
80104822:	5e                   	pop    %esi
80104823:	5f                   	pop    %edi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
80104826:	8d 76 00             	lea    0x0(%esi),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 45 08             	mov    0x8(%ebp),%eax
80104838:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010483b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010483e:	89 c2                	mov    %eax,%edx
80104840:	eb 19                	jmp    8010485b <strncpy+0x2b>
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104848:	83 c3 01             	add    $0x1,%ebx
8010484b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010484f:	83 c2 01             	add    $0x1,%edx
80104852:	84 c9                	test   %cl,%cl
80104854:	88 4a ff             	mov    %cl,-0x1(%edx)
80104857:	74 09                	je     80104862 <strncpy+0x32>
80104859:	89 f1                	mov    %esi,%ecx
8010485b:	85 c9                	test   %ecx,%ecx
8010485d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104860:	7f e6                	jg     80104848 <strncpy+0x18>
    ;
  while(n-- > 0)
80104862:	31 c9                	xor    %ecx,%ecx
80104864:	85 f6                	test   %esi,%esi
80104866:	7e 17                	jle    8010487f <strncpy+0x4f>
80104868:	90                   	nop
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104870:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104874:	89 f3                	mov    %esi,%ebx
80104876:	83 c1 01             	add    $0x1,%ecx
80104879:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010487b:	85 db                	test   %ebx,%ebx
8010487d:	7f f1                	jg     80104870 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010487f:	5b                   	pop    %ebx
80104880:	5e                   	pop    %esi
80104881:	5d                   	pop    %ebp
80104882:	c3                   	ret    
80104883:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104898:	8b 45 08             	mov    0x8(%ebp),%eax
8010489b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010489e:	85 c9                	test   %ecx,%ecx
801048a0:	7e 26                	jle    801048c8 <safestrcpy+0x38>
801048a2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801048a6:	89 c1                	mov    %eax,%ecx
801048a8:	eb 17                	jmp    801048c1 <safestrcpy+0x31>
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048b0:	83 c2 01             	add    $0x1,%edx
801048b3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801048b7:	83 c1 01             	add    $0x1,%ecx
801048ba:	84 db                	test   %bl,%bl
801048bc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801048bf:	74 04                	je     801048c5 <safestrcpy+0x35>
801048c1:	39 f2                	cmp    %esi,%edx
801048c3:	75 eb                	jne    801048b0 <safestrcpy+0x20>
    ;
  *s = 0;
801048c5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801048c8:	5b                   	pop    %ebx
801048c9:	5e                   	pop    %esi
801048ca:	5d                   	pop    %ebp
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048d0 <strlen>:

int
strlen(const char *s)
{
801048d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048d1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801048d3:	89 e5                	mov    %esp,%ebp
801048d5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801048d8:	80 3a 00             	cmpb   $0x0,(%edx)
801048db:	74 0c                	je     801048e9 <strlen+0x19>
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	83 c0 01             	add    $0x1,%eax
801048e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048e7:	75 f7                	jne    801048e0 <strlen+0x10>
    ;
  return n;
}
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    

801048eb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048ef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801048f3:	55                   	push   %ebp
  pushl %ebx
801048f4:	53                   	push   %ebx
  pushl %esi
801048f5:	56                   	push   %esi
  pushl %edi
801048f6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048f7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048f9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801048fb:	5f                   	pop    %edi
  popl %esi
801048fc:	5e                   	pop    %esi
  popl %ebx
801048fd:	5b                   	pop    %ebx
  popl %ebp
801048fe:	5d                   	pop    %ebp
  ret
801048ff:	c3                   	ret    

80104900 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104900:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104901:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104908:	89 e5                	mov    %esp,%ebp
8010490a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010490d:	8b 12                	mov    (%edx),%edx
8010490f:	39 c2                	cmp    %eax,%edx
80104911:	76 15                	jbe    80104928 <fetchint+0x28>
80104913:	8d 48 04             	lea    0x4(%eax),%ecx
80104916:	39 ca                	cmp    %ecx,%edx
80104918:	72 0e                	jb     80104928 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010491a:	8b 10                	mov    (%eax),%edx
8010491c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010491f:	89 10                	mov    %edx,(%eax)
  return 0;
80104921:	31 c0                	xor    %eax,%eax
}
80104923:	5d                   	pop    %ebp
80104924:	c3                   	ret    
80104925:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010492d:	5d                   	pop    %ebp
8010492e:	c3                   	ret    
8010492f:	90                   	nop

80104930 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104930:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104931:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104937:	89 e5                	mov    %esp,%ebp
80104939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
8010493c:	39 08                	cmp    %ecx,(%eax)
8010493e:	76 2c                	jbe    8010496c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104940:	8b 55 0c             	mov    0xc(%ebp),%edx
80104943:	89 c8                	mov    %ecx,%eax
80104945:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104947:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010494e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104950:	39 d1                	cmp    %edx,%ecx
80104952:	73 18                	jae    8010496c <fetchstr+0x3c>
    if(*s == 0)
80104954:	80 39 00             	cmpb   $0x0,(%ecx)
80104957:	75 0c                	jne    80104965 <fetchstr+0x35>
80104959:	eb 1d                	jmp    80104978 <fetchstr+0x48>
8010495b:	90                   	nop
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104960:	80 38 00             	cmpb   $0x0,(%eax)
80104963:	74 13                	je     80104978 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104965:	83 c0 01             	add    $0x1,%eax
80104968:	39 c2                	cmp    %eax,%edx
8010496a:	77 f4                	ja     80104960 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
8010496c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104971:	5d                   	pop    %ebp
80104972:	c3                   	ret    
80104973:	90                   	nop
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104978:	29 c8                	sub    %ecx,%eax
  return -1;
}
8010497a:	5d                   	pop    %ebp
8010497b:	c3                   	ret    
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104980 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104980:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104987:	55                   	push   %ebp
80104988:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010498a:	8b 42 34             	mov    0x34(%edx),%eax
8010498d:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104990:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104992:	8b 40 44             	mov    0x44(%eax),%eax
80104995:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104998:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010499b:	39 d1                	cmp    %edx,%ecx
8010499d:	73 19                	jae    801049b8 <argint+0x38>
8010499f:	8d 48 08             	lea    0x8(%eax),%ecx
801049a2:	39 ca                	cmp    %ecx,%edx
801049a4:	72 12                	jb     801049b8 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
801049a6:	8b 50 04             	mov    0x4(%eax),%edx
801049a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ac:	89 10                	mov    %edx,(%eax)
  return 0;
801049ae:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801049b0:	5d                   	pop    %ebp
801049b1:	c3                   	ret    
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801049b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
801049bd:	5d                   	pop    %ebp
801049be:	c3                   	ret    
801049bf:	90                   	nop

801049c0 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801049c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049c6:	55                   	push   %ebp
801049c7:	89 e5                	mov    %esp,%ebp
801049c9:	56                   	push   %esi
801049ca:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801049cb:	8b 48 34             	mov    0x34(%eax),%ecx
801049ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049d1:	8b 55 10             	mov    0x10(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801049d4:	8b 49 44             	mov    0x44(%ecx),%ecx
801049d7:	8d 1c 99             	lea    (%ecx,%ebx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801049da:	8b 08                	mov    (%eax),%ecx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
801049dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801049e1:	8d 73 04             	lea    0x4(%ebx),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801049e4:	39 ce                	cmp    %ecx,%esi
801049e6:	73 1f                	jae    80104a07 <argptr+0x47>
801049e8:	8d 73 08             	lea    0x8(%ebx),%esi
801049eb:	39 f1                	cmp    %esi,%ecx
801049ed:	72 18                	jb     80104a07 <argptr+0x47>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
801049ef:	85 d2                	test   %edx,%edx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801049f1:	8b 5b 04             	mov    0x4(%ebx),%ebx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
801049f4:	78 11                	js     80104a07 <argptr+0x47>
801049f6:	39 cb                	cmp    %ecx,%ebx
801049f8:	73 0d                	jae    80104a07 <argptr+0x47>
801049fa:	01 da                	add    %ebx,%edx
801049fc:	39 ca                	cmp    %ecx,%edx
801049fe:	77 07                	ja     80104a07 <argptr+0x47>
    return -1;
  *pp = (char*)i;
80104a00:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a03:	89 18                	mov    %ebx,(%eax)
  return 0;
80104a05:	31 c0                	xor    %eax,%eax
}
80104a07:	5b                   	pop    %ebx
80104a08:	5e                   	pop    %esi
80104a09:	5d                   	pop    %ebp
80104a0a:	c3                   	ret    
80104a0b:	90                   	nop
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a16:	55                   	push   %ebp
80104a17:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a19:	8b 50 34             	mov    0x34(%eax),%edx
80104a1c:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104a1f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104a21:	8b 52 44             	mov    0x44(%edx),%edx
80104a24:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104a27:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104a2a:	39 c1                	cmp    %eax,%ecx
80104a2c:	73 07                	jae    80104a35 <argstr+0x25>
80104a2e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104a31:	39 c8                	cmp    %ecx,%eax
80104a33:	73 0b                	jae    80104a40 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104a3a:	5d                   	pop    %ebp
80104a3b:	c3                   	ret    
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104a40:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104a43:	39 c1                	cmp    %eax,%ecx
80104a45:	73 ee                	jae    80104a35 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104a47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a4a:	89 c8                	mov    %ecx,%eax
80104a4c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104a4e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a55:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104a57:	39 d1                	cmp    %edx,%ecx
80104a59:	73 da                	jae    80104a35 <argstr+0x25>
    if(*s == 0)
80104a5b:	80 39 00             	cmpb   $0x0,(%ecx)
80104a5e:	75 0d                	jne    80104a6d <argstr+0x5d>
80104a60:	eb 1e                	jmp    80104a80 <argstr+0x70>
80104a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a68:	80 38 00             	cmpb   $0x0,(%eax)
80104a6b:	74 13                	je     80104a80 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104a6d:	83 c0 01             	add    $0x1,%eax
80104a70:	39 c2                	cmp    %eax,%edx
80104a72:	77 f4                	ja     80104a68 <argstr+0x58>
80104a74:	eb bf                	jmp    80104a35 <argstr+0x25>
80104a76:	8d 76 00             	lea    0x0(%esi),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(*s == 0)
      return s - *pp;
80104a80:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a82:	5d                   	pop    %ebp
80104a83:	c3                   	ret    
80104a84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a90 <syscall>:
[SYS_wait2] sys_wait2,
};

void
syscall(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
  int num;

  num = proc->tf->eax;
80104a97:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a9e:	8b 5a 34             	mov    0x34(%edx),%ebx
80104aa1:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104aa4:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104aa7:	83 f9 17             	cmp    $0x17,%ecx
80104aaa:	77 1c                	ja     80104ac8 <syscall+0x38>
80104aac:	8b 0c 85 c0 78 10 80 	mov    -0x7fef8740(,%eax,4),%ecx
80104ab3:	85 c9                	test   %ecx,%ecx
80104ab5:	74 11                	je     80104ac8 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104ab7:	ff d1                	call   *%ecx
80104ab9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104abc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104abf:	c9                   	leave  
80104ac0:	c3                   	ret    
80104ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104ac8:	50                   	push   %eax
            proc->pid, proc->name, num);
80104ac9:	8d 82 88 00 00 00    	lea    0x88(%edx),%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104acf:	50                   	push   %eax
80104ad0:	ff 72 2c             	pushl  0x2c(%edx)
80104ad3:	68 9d 78 10 80       	push   $0x8010789d
80104ad8:	e8 83 bb ff ff       	call   80100660 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104add:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae3:	83 c4 10             	add    $0x10,%esp
80104ae6:	8b 40 34             	mov    0x34(%eax),%eax
80104ae9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104af0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af3:	c9                   	leave  
80104af4:	c3                   	ret    
80104af5:	66 90                	xchg   %ax,%ax
80104af7:	66 90                	xchg   %ax,%ax
80104af9:	66 90                	xchg   %ax,%ax
80104afb:	66 90                	xchg   %ax,%ax
80104afd:	66 90                	xchg   %ax,%ax
80104aff:	90                   	nop

80104b00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b06:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b09:	83 ec 44             	sub    $0x44,%esp
80104b0c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b12:	56                   	push   %esi
80104b13:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b14:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104b17:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b1a:	e8 b1 d3 ff ff       	call   80101ed0 <nameiparent>
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	85 c0                	test   %eax,%eax
80104b24:	0f 84 f6 00 00 00    	je     80104c20 <create+0x120>
    return 0;
  ilock(dp);
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	89 c7                	mov    %eax,%edi
80104b2f:	50                   	push   %eax
80104b30:	e8 3b cb ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104b35:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b38:	83 c4 0c             	add    $0xc,%esp
80104b3b:	50                   	push   %eax
80104b3c:	56                   	push   %esi
80104b3d:	57                   	push   %edi
80104b3e:	e8 3d d0 ff ff       	call   80101b80 <dirlookup>
80104b43:	83 c4 10             	add    $0x10,%esp
80104b46:	85 c0                	test   %eax,%eax
80104b48:	89 c3                	mov    %eax,%ebx
80104b4a:	74 54                	je     80104ba0 <create+0xa0>
    iunlockput(dp);
80104b4c:	83 ec 0c             	sub    $0xc,%esp
80104b4f:	57                   	push   %edi
80104b50:	e8 8b cd ff ff       	call   801018e0 <iunlockput>
    ilock(ip);
80104b55:	89 1c 24             	mov    %ebx,(%esp)
80104b58:	e8 13 cb ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b65:	75 19                	jne    80104b80 <create+0x80>
80104b67:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104b6c:	89 d8                	mov    %ebx,%eax
80104b6e:	75 10                	jne    80104b80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b73:	5b                   	pop    %ebx
80104b74:	5e                   	pop    %esi
80104b75:	5f                   	pop    %edi
80104b76:	5d                   	pop    %ebp
80104b77:	c3                   	ret    
80104b78:	90                   	nop
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104b80:	83 ec 0c             	sub    $0xc,%esp
80104b83:	53                   	push   %ebx
80104b84:	e8 57 cd ff ff       	call   801018e0 <iunlockput>
    return 0;
80104b89:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104b8f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b91:	5b                   	pop    %ebx
80104b92:	5e                   	pop    %esi
80104b93:	5f                   	pop    %edi
80104b94:	5d                   	pop    %ebp
80104b95:	c3                   	ret    
80104b96:	8d 76 00             	lea    0x0(%esi),%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104ba0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ba4:	83 ec 08             	sub    $0x8,%esp
80104ba7:	50                   	push   %eax
80104ba8:	ff 37                	pushl  (%edi)
80104baa:	e8 51 c9 ff ff       	call   80101500 <ialloc>
80104baf:	83 c4 10             	add    $0x10,%esp
80104bb2:	85 c0                	test   %eax,%eax
80104bb4:	89 c3                	mov    %eax,%ebx
80104bb6:	0f 84 cc 00 00 00    	je     80104c88 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	50                   	push   %eax
80104bc0:	e8 ab ca ff ff       	call   80101670 <ilock>
  ip->major = major;
80104bc5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104bc9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104bcd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104bd1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104bd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bda:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104bde:	89 1c 24             	mov    %ebx,(%esp)
80104be1:	e8 da c9 ff ff       	call   801015c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104be6:	83 c4 10             	add    $0x10,%esp
80104be9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104bee:	74 40                	je     80104c30 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104bf0:	83 ec 04             	sub    $0x4,%esp
80104bf3:	ff 73 04             	pushl  0x4(%ebx)
80104bf6:	56                   	push   %esi
80104bf7:	57                   	push   %edi
80104bf8:	e8 f3 d1 ff ff       	call   80101df0 <dirlink>
80104bfd:	83 c4 10             	add    $0x10,%esp
80104c00:	85 c0                	test   %eax,%eax
80104c02:	78 77                	js     80104c7b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	57                   	push   %edi
80104c08:	e8 d3 cc ff ff       	call   801018e0 <iunlockput>

  return ip;
80104c0d:	83 c4 10             	add    $0x10,%esp
}
80104c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104c13:	89 d8                	mov    %ebx,%eax
}
80104c15:	5b                   	pop    %ebx
80104c16:	5e                   	pop    %esi
80104c17:	5f                   	pop    %edi
80104c18:	5d                   	pop    %ebp
80104c19:	c3                   	ret    
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104c20:	31 c0                	xor    %eax,%eax
80104c22:	e9 49 ff ff ff       	jmp    80104b70 <create+0x70>
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104c30:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104c35:	83 ec 0c             	sub    $0xc,%esp
80104c38:	57                   	push   %edi
80104c39:	e8 82 c9 ff ff       	call   801015c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c3e:	83 c4 0c             	add    $0xc,%esp
80104c41:	ff 73 04             	pushl  0x4(%ebx)
80104c44:	68 40 79 10 80       	push   $0x80107940
80104c49:	53                   	push   %ebx
80104c4a:	e8 a1 d1 ff ff       	call   80101df0 <dirlink>
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 18                	js     80104c6e <create+0x16e>
80104c56:	83 ec 04             	sub    $0x4,%esp
80104c59:	ff 77 04             	pushl  0x4(%edi)
80104c5c:	68 3f 79 10 80       	push   $0x8010793f
80104c61:	53                   	push   %ebx
80104c62:	e8 89 d1 ff ff       	call   80101df0 <dirlink>
80104c67:	83 c4 10             	add    $0x10,%esp
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	79 82                	jns    80104bf0 <create+0xf0>
      panic("create dots");
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	68 33 79 10 80       	push   $0x80107933
80104c76:	e8 f5 b6 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104c7b:	83 ec 0c             	sub    $0xc,%esp
80104c7e:	68 42 79 10 80       	push   $0x80107942
80104c83:	e8 e8 b6 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104c88:	83 ec 0c             	sub    $0xc,%esp
80104c8b:	68 24 79 10 80       	push   $0x80107924
80104c90:	e8 db b6 ff ff       	call   80100370 <panic>
80104c95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
80104ca5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ca7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104caa:	89 d3                	mov    %edx,%ebx
80104cac:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104caf:	50                   	push   %eax
80104cb0:	6a 00                	push   $0x0
80104cb2:	e8 c9 fc ff ff       	call   80104980 <argint>
80104cb7:	83 c4 10             	add    $0x10,%esp
80104cba:	85 c0                	test   %eax,%eax
80104cbc:	78 3a                	js     80104cf8 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc1:	83 f8 0f             	cmp    $0xf,%eax
80104cc4:	77 32                	ja     80104cf8 <argfd.constprop.0+0x58>
80104cc6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ccd:	8b 54 82 44          	mov    0x44(%edx,%eax,4),%edx
80104cd1:	85 d2                	test   %edx,%edx
80104cd3:	74 23                	je     80104cf8 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104cd5:	85 f6                	test   %esi,%esi
80104cd7:	74 02                	je     80104cdb <argfd.constprop.0+0x3b>
    *pfd = fd;
80104cd9:	89 06                	mov    %eax,(%esi)
  if(pf)
80104cdb:	85 db                	test   %ebx,%ebx
80104cdd:	74 11                	je     80104cf0 <argfd.constprop.0+0x50>
    *pf = f;
80104cdf:	89 13                	mov    %edx,(%ebx)
  return 0;
80104ce1:	31 c0                	xor    %eax,%eax
}
80104ce3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce6:	5b                   	pop    %ebx
80104ce7:	5e                   	pop    %esi
80104ce8:	5d                   	pop    %ebp
80104ce9:	c3                   	ret    
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104cf0:	31 c0                	xor    %eax,%eax
80104cf2:	eb ef                	jmp    80104ce3 <argfd.constprop.0+0x43>
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cfd:	eb e4                	jmp    80104ce3 <argfd.constprop.0+0x43>
80104cff:	90                   	nop

80104d00 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104d00:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104d01:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104d03:	89 e5                	mov    %esp,%ebp
80104d05:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104d06:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104d09:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104d0c:	e8 8f ff ff ff       	call   80104ca0 <argfd.constprop.0>
80104d11:	85 c0                	test   %eax,%eax
80104d13:	78 1b                	js     80104d30 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104d1e:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104d20:	8b 4c 98 44          	mov    0x44(%eax,%ebx,4),%ecx
80104d24:	85 c9                	test   %ecx,%ecx
80104d26:	74 18                	je     80104d40 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104d28:	83 c3 01             	add    $0x1,%ebx
80104d2b:	83 fb 10             	cmp    $0x10,%ebx
80104d2e:	75 f0                	jne    80104d20 <sys_dup+0x20>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d38:	c9                   	leave  
80104d39:	c3                   	ret    
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104d40:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104d43:	89 54 98 44          	mov    %edx,0x44(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104d47:	52                   	push   %edx
80104d48:	e8 93 c0 ff ff       	call   80100de0 <filedup>
  return fd;
80104d4d:	89 d8                	mov    %ebx,%eax
80104d4f:	83 c4 10             	add    $0x10,%esp
}
80104d52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <sys_read>:

int
sys_read(void)
{
80104d60:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d61:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d6b:	e8 30 ff ff ff       	call   80104ca0 <argfd.constprop.0>
80104d70:	85 c0                	test   %eax,%eax
80104d72:	78 4c                	js     80104dc0 <sys_read+0x60>
80104d74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d77:	83 ec 08             	sub    $0x8,%esp
80104d7a:	50                   	push   %eax
80104d7b:	6a 02                	push   $0x2
80104d7d:	e8 fe fb ff ff       	call   80104980 <argint>
80104d82:	83 c4 10             	add    $0x10,%esp
80104d85:	85 c0                	test   %eax,%eax
80104d87:	78 37                	js     80104dc0 <sys_read+0x60>
80104d89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d8c:	83 ec 04             	sub    $0x4,%esp
80104d8f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d92:	50                   	push   %eax
80104d93:	6a 01                	push   $0x1
80104d95:	e8 26 fc ff ff       	call   801049c0 <argptr>
80104d9a:	83 c4 10             	add    $0x10,%esp
80104d9d:	85 c0                	test   %eax,%eax
80104d9f:	78 1f                	js     80104dc0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104da1:	83 ec 04             	sub    $0x4,%esp
80104da4:	ff 75 f0             	pushl  -0x10(%ebp)
80104da7:	ff 75 f4             	pushl  -0xc(%ebp)
80104daa:	ff 75 ec             	pushl  -0x14(%ebp)
80104dad:	e8 9e c1 ff ff       	call   80100f50 <fileread>
80104db2:	83 c4 10             	add    $0x10,%esp
}
80104db5:	c9                   	leave  
80104db6:	c3                   	ret    
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104dc5:	c9                   	leave  
80104dc6:	c3                   	ret    
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <sys_write>:

int
sys_write(void)
{
80104dd0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dd1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dd8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ddb:	e8 c0 fe ff ff       	call   80104ca0 <argfd.constprop.0>
80104de0:	85 c0                	test   %eax,%eax
80104de2:	78 4c                	js     80104e30 <sys_write+0x60>
80104de4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104de7:	83 ec 08             	sub    $0x8,%esp
80104dea:	50                   	push   %eax
80104deb:	6a 02                	push   $0x2
80104ded:	e8 8e fb ff ff       	call   80104980 <argint>
80104df2:	83 c4 10             	add    $0x10,%esp
80104df5:	85 c0                	test   %eax,%eax
80104df7:	78 37                	js     80104e30 <sys_write+0x60>
80104df9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dfc:	83 ec 04             	sub    $0x4,%esp
80104dff:	ff 75 f0             	pushl  -0x10(%ebp)
80104e02:	50                   	push   %eax
80104e03:	6a 01                	push   $0x1
80104e05:	e8 b6 fb ff ff       	call   801049c0 <argptr>
80104e0a:	83 c4 10             	add    $0x10,%esp
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	78 1f                	js     80104e30 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104e11:	83 ec 04             	sub    $0x4,%esp
80104e14:	ff 75 f0             	pushl  -0x10(%ebp)
80104e17:	ff 75 f4             	pushl  -0xc(%ebp)
80104e1a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e1d:	e8 be c1 ff ff       	call   80100fe0 <filewrite>
80104e22:	83 c4 10             	add    $0x10,%esp
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <sys_close>:

int
sys_close(void)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104e46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e4c:	e8 4f fe ff ff       	call   80104ca0 <argfd.constprop.0>
80104e51:	85 c0                	test   %eax,%eax
80104e53:	78 2b                	js     80104e80 <sys_close+0x40>
    return -1;
  proc->ofile[fd] = 0;
80104e55:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  fileclose(f);
80104e5e:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  proc->ofile[fd] = 0;
80104e61:	c7 44 90 44 00 00 00 	movl   $0x0,0x44(%eax,%edx,4)
80104e68:	00 
  fileclose(f);
80104e69:	ff 75 f4             	pushl  -0xc(%ebp)
80104e6c:	e8 bf bf ff ff       	call   80100e30 <fileclose>
  return 0;
80104e71:	83 c4 10             	add    $0x10,%esp
80104e74:	31 c0                	xor    %eax,%eax
}
80104e76:	c9                   	leave  
80104e77:	c3                   	ret    
80104e78:	90                   	nop
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <sys_fstat>:

int
sys_fstat(void)
{
80104e90:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e91:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104e93:	89 e5                	mov    %esp,%ebp
80104e95:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e98:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e9b:	e8 00 fe ff ff       	call   80104ca0 <argfd.constprop.0>
80104ea0:	85 c0                	test   %eax,%eax
80104ea2:	78 2c                	js     80104ed0 <sys_fstat+0x40>
80104ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ea7:	83 ec 04             	sub    $0x4,%esp
80104eaa:	6a 14                	push   $0x14
80104eac:	50                   	push   %eax
80104ead:	6a 01                	push   $0x1
80104eaf:	e8 0c fb ff ff       	call   801049c0 <argptr>
80104eb4:	83 c4 10             	add    $0x10,%esp
80104eb7:	85 c0                	test   %eax,%eax
80104eb9:	78 15                	js     80104ed0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104ebb:	83 ec 08             	sub    $0x8,%esp
80104ebe:	ff 75 f4             	pushl  -0xc(%ebp)
80104ec1:	ff 75 f0             	pushl  -0x10(%ebp)
80104ec4:	e8 37 c0 ff ff       	call   80100f00 <filestat>
80104ec9:	83 c4 10             	add    $0x10,%esp
}
80104ecc:	c9                   	leave  
80104ecd:	c3                   	ret    
80104ece:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104ed5:	c9                   	leave  
80104ed6:	c3                   	ret    
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ee6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ee9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104eec:	50                   	push   %eax
80104eed:	6a 00                	push   $0x0
80104eef:	e8 1c fb ff ff       	call   80104a10 <argstr>
80104ef4:	83 c4 10             	add    $0x10,%esp
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	0f 88 fb 00 00 00    	js     80104ffa <sys_link+0x11a>
80104eff:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f02:	83 ec 08             	sub    $0x8,%esp
80104f05:	50                   	push   %eax
80104f06:	6a 01                	push   $0x1
80104f08:	e8 03 fb ff ff       	call   80104a10 <argstr>
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	85 c0                	test   %eax,%eax
80104f12:	0f 88 e2 00 00 00    	js     80104ffa <sys_link+0x11a>
    return -1;

  begin_op();
80104f18:	e8 c3 dc ff ff       	call   80102be0 <begin_op>
  if((ip = namei(old)) == 0){
80104f1d:	83 ec 0c             	sub    $0xc,%esp
80104f20:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f23:	e8 88 cf ff ff       	call   80101eb0 <namei>
80104f28:	83 c4 10             	add    $0x10,%esp
80104f2b:	85 c0                	test   %eax,%eax
80104f2d:	89 c3                	mov    %eax,%ebx
80104f2f:	0f 84 f3 00 00 00    	je     80105028 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104f35:	83 ec 0c             	sub    $0xc,%esp
80104f38:	50                   	push   %eax
80104f39:	e8 32 c7 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
80104f3e:	83 c4 10             	add    $0x10,%esp
80104f41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f46:	0f 84 c4 00 00 00    	je     80105010 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104f4c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f51:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104f54:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104f57:	53                   	push   %ebx
80104f58:	e8 63 c6 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
80104f5d:	89 1c 24             	mov    %ebx,(%esp)
80104f60:	e8 eb c7 ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104f65:	58                   	pop    %eax
80104f66:	5a                   	pop    %edx
80104f67:	57                   	push   %edi
80104f68:	ff 75 d0             	pushl  -0x30(%ebp)
80104f6b:	e8 60 cf ff ff       	call   80101ed0 <nameiparent>
80104f70:	83 c4 10             	add    $0x10,%esp
80104f73:	85 c0                	test   %eax,%eax
80104f75:	89 c6                	mov    %eax,%esi
80104f77:	74 5b                	je     80104fd4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104f79:	83 ec 0c             	sub    $0xc,%esp
80104f7c:	50                   	push   %eax
80104f7d:	e8 ee c6 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f82:	83 c4 10             	add    $0x10,%esp
80104f85:	8b 03                	mov    (%ebx),%eax
80104f87:	39 06                	cmp    %eax,(%esi)
80104f89:	75 3d                	jne    80104fc8 <sys_link+0xe8>
80104f8b:	83 ec 04             	sub    $0x4,%esp
80104f8e:	ff 73 04             	pushl  0x4(%ebx)
80104f91:	57                   	push   %edi
80104f92:	56                   	push   %esi
80104f93:	e8 58 ce ff ff       	call   80101df0 <dirlink>
80104f98:	83 c4 10             	add    $0x10,%esp
80104f9b:	85 c0                	test   %eax,%eax
80104f9d:	78 29                	js     80104fc8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104f9f:	83 ec 0c             	sub    $0xc,%esp
80104fa2:	56                   	push   %esi
80104fa3:	e8 38 c9 ff ff       	call   801018e0 <iunlockput>
  iput(ip);
80104fa8:	89 1c 24             	mov    %ebx,(%esp)
80104fab:	e8 f0 c7 ff ff       	call   801017a0 <iput>

  end_op();
80104fb0:	e8 9b dc ff ff       	call   80102c50 <end_op>

  return 0;
80104fb5:	83 c4 10             	add    $0x10,%esp
80104fb8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fbd:	5b                   	pop    %ebx
80104fbe:	5e                   	pop    %esi
80104fbf:	5f                   	pop    %edi
80104fc0:	5d                   	pop    %ebp
80104fc1:	c3                   	ret    
80104fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104fc8:	83 ec 0c             	sub    $0xc,%esp
80104fcb:	56                   	push   %esi
80104fcc:	e8 0f c9 ff ff       	call   801018e0 <iunlockput>
    goto bad;
80104fd1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	53                   	push   %ebx
80104fd8:	e8 93 c6 ff ff       	call   80101670 <ilock>
  ip->nlink--;
80104fdd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fe2:	89 1c 24             	mov    %ebx,(%esp)
80104fe5:	e8 d6 c5 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104fea:	89 1c 24             	mov    %ebx,(%esp)
80104fed:	e8 ee c8 ff ff       	call   801018e0 <iunlockput>
  end_op();
80104ff2:	e8 59 dc ff ff       	call   80102c50 <end_op>
  return -1;
80104ff7:	83 c4 10             	add    $0x10,%esp
}
80104ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104ffd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105002:	5b                   	pop    %ebx
80105003:	5e                   	pop    %esi
80105004:	5f                   	pop    %edi
80105005:	5d                   	pop    %ebp
80105006:	c3                   	ret    
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105010:	83 ec 0c             	sub    $0xc,%esp
80105013:	53                   	push   %ebx
80105014:	e8 c7 c8 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105019:	e8 32 dc ff ff       	call   80102c50 <end_op>
    return -1;
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105026:	eb 92                	jmp    80104fba <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105028:	e8 23 dc ff ff       	call   80102c50 <end_op>
    return -1;
8010502d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105032:	eb 86                	jmp    80104fba <sys_link+0xda>
80105034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010503a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105040 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105046:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105049:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010504c:	50                   	push   %eax
8010504d:	6a 00                	push   $0x0
8010504f:	e8 bc f9 ff ff       	call   80104a10 <argstr>
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	85 c0                	test   %eax,%eax
80105059:	0f 88 82 01 00 00    	js     801051e1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010505f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105062:	e8 79 db ff ff       	call   80102be0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105067:	83 ec 08             	sub    $0x8,%esp
8010506a:	53                   	push   %ebx
8010506b:	ff 75 c0             	pushl  -0x40(%ebp)
8010506e:	e8 5d ce ff ff       	call   80101ed0 <nameiparent>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010507b:	0f 84 6a 01 00 00    	je     801051eb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105081:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	56                   	push   %esi
80105088:	e8 e3 c5 ff ff       	call   80101670 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010508d:	58                   	pop    %eax
8010508e:	5a                   	pop    %edx
8010508f:	68 40 79 10 80       	push   $0x80107940
80105094:	53                   	push   %ebx
80105095:	e8 c6 ca ff ff       	call   80101b60 <namecmp>
8010509a:	83 c4 10             	add    $0x10,%esp
8010509d:	85 c0                	test   %eax,%eax
8010509f:	0f 84 fc 00 00 00    	je     801051a1 <sys_unlink+0x161>
801050a5:	83 ec 08             	sub    $0x8,%esp
801050a8:	68 3f 79 10 80       	push   $0x8010793f
801050ad:	53                   	push   %ebx
801050ae:	e8 ad ca ff ff       	call   80101b60 <namecmp>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	0f 84 e3 00 00 00    	je     801051a1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801050be:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050c1:	83 ec 04             	sub    $0x4,%esp
801050c4:	50                   	push   %eax
801050c5:	53                   	push   %ebx
801050c6:	56                   	push   %esi
801050c7:	e8 b4 ca ff ff       	call   80101b80 <dirlookup>
801050cc:	83 c4 10             	add    $0x10,%esp
801050cf:	85 c0                	test   %eax,%eax
801050d1:	89 c3                	mov    %eax,%ebx
801050d3:	0f 84 c8 00 00 00    	je     801051a1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
801050d9:	83 ec 0c             	sub    $0xc,%esp
801050dc:	50                   	push   %eax
801050dd:	e8 8e c5 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050ea:	0f 8e 24 01 00 00    	jle    80105214 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801050f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050f5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801050f8:	74 66                	je     80105160 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801050fa:	83 ec 04             	sub    $0x4,%esp
801050fd:	6a 10                	push   $0x10
801050ff:	6a 00                	push   $0x0
80105101:	56                   	push   %esi
80105102:	e8 89 f5 ff ff       	call   80104690 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105107:	6a 10                	push   $0x10
80105109:	ff 75 c4             	pushl  -0x3c(%ebp)
8010510c:	56                   	push   %esi
8010510d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105110:	e8 1b c9 ff ff       	call   80101a30 <writei>
80105115:	83 c4 20             	add    $0x20,%esp
80105118:	83 f8 10             	cmp    $0x10,%eax
8010511b:	0f 85 e6 00 00 00    	jne    80105207 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105121:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105126:	0f 84 9c 00 00 00    	je     801051c8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010512c:	83 ec 0c             	sub    $0xc,%esp
8010512f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105132:	e8 a9 c7 ff ff       	call   801018e0 <iunlockput>

  ip->nlink--;
80105137:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010513c:	89 1c 24             	mov    %ebx,(%esp)
8010513f:	e8 7c c4 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80105144:	89 1c 24             	mov    %ebx,(%esp)
80105147:	e8 94 c7 ff ff       	call   801018e0 <iunlockput>

  end_op();
8010514c:	e8 ff da ff ff       	call   80102c50 <end_op>

  return 0;
80105151:	83 c4 10             	add    $0x10,%esp
80105154:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105156:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105159:	5b                   	pop    %ebx
8010515a:	5e                   	pop    %esi
8010515b:	5f                   	pop    %edi
8010515c:	5d                   	pop    %ebp
8010515d:	c3                   	ret    
8010515e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105160:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105164:	76 94                	jbe    801050fa <sys_unlink+0xba>
80105166:	bf 20 00 00 00       	mov    $0x20,%edi
8010516b:	eb 0f                	jmp    8010517c <sys_unlink+0x13c>
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
80105170:	83 c7 10             	add    $0x10,%edi
80105173:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105176:	0f 83 7e ff ff ff    	jae    801050fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010517c:	6a 10                	push   $0x10
8010517e:	57                   	push   %edi
8010517f:	56                   	push   %esi
80105180:	53                   	push   %ebx
80105181:	e8 aa c7 ff ff       	call   80101930 <readi>
80105186:	83 c4 10             	add    $0x10,%esp
80105189:	83 f8 10             	cmp    $0x10,%eax
8010518c:	75 6c                	jne    801051fa <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010518e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105193:	74 db                	je     80105170 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	53                   	push   %ebx
80105199:	e8 42 c7 ff ff       	call   801018e0 <iunlockput>
    goto bad;
8010519e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801051a1:	83 ec 0c             	sub    $0xc,%esp
801051a4:	ff 75 b4             	pushl  -0x4c(%ebp)
801051a7:	e8 34 c7 ff ff       	call   801018e0 <iunlockput>
  end_op();
801051ac:	e8 9f da ff ff       	call   80102c50 <end_op>
  return -1;
801051b1:	83 c4 10             	add    $0x10,%esp
}
801051b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801051b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051bc:	5b                   	pop    %ebx
801051bd:	5e                   	pop    %esi
801051be:	5f                   	pop    %edi
801051bf:	5d                   	pop    %ebp
801051c0:	c3                   	ret    
801051c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801051c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051cb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801051ce:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051d3:	50                   	push   %eax
801051d4:	e8 e7 c3 ff ff       	call   801015c0 <iupdate>
801051d9:	83 c4 10             	add    $0x10,%esp
801051dc:	e9 4b ff ff ff       	jmp    8010512c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801051e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e6:	e9 6b ff ff ff       	jmp    80105156 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801051eb:	e8 60 da ff ff       	call   80102c50 <end_op>
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f5:	e9 5c ff ff ff       	jmp    80105156 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801051fa:	83 ec 0c             	sub    $0xc,%esp
801051fd:	68 64 79 10 80       	push   $0x80107964
80105202:	e8 69 b1 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105207:	83 ec 0c             	sub    $0xc,%esp
8010520a:	68 76 79 10 80       	push   $0x80107976
8010520f:	e8 5c b1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105214:	83 ec 0c             	sub    $0xc,%esp
80105217:	68 52 79 10 80       	push   $0x80107952
8010521c:	e8 4f b1 ff ff       	call   80100370 <panic>
80105221:	eb 0d                	jmp    80105230 <sys_open>
80105223:	90                   	nop
80105224:	90                   	nop
80105225:	90                   	nop
80105226:	90                   	nop
80105227:	90                   	nop
80105228:	90                   	nop
80105229:	90                   	nop
8010522a:	90                   	nop
8010522b:	90                   	nop
8010522c:	90                   	nop
8010522d:	90                   	nop
8010522e:	90                   	nop
8010522f:	90                   	nop

80105230 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi
80105235:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105236:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105239:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010523c:	50                   	push   %eax
8010523d:	6a 00                	push   $0x0
8010523f:	e8 cc f7 ff ff       	call   80104a10 <argstr>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	0f 88 9e 00 00 00    	js     801052ed <sys_open+0xbd>
8010524f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105252:	83 ec 08             	sub    $0x8,%esp
80105255:	50                   	push   %eax
80105256:	6a 01                	push   $0x1
80105258:	e8 23 f7 ff ff       	call   80104980 <argint>
8010525d:	83 c4 10             	add    $0x10,%esp
80105260:	85 c0                	test   %eax,%eax
80105262:	0f 88 85 00 00 00    	js     801052ed <sys_open+0xbd>
    return -1;

  begin_op();
80105268:	e8 73 d9 ff ff       	call   80102be0 <begin_op>

  if(omode & O_CREATE){
8010526d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105271:	0f 85 89 00 00 00    	jne    80105300 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105277:	83 ec 0c             	sub    $0xc,%esp
8010527a:	ff 75 e0             	pushl  -0x20(%ebp)
8010527d:	e8 2e cc ff ff       	call   80101eb0 <namei>
80105282:	83 c4 10             	add    $0x10,%esp
80105285:	85 c0                	test   %eax,%eax
80105287:	89 c7                	mov    %eax,%edi
80105289:	0f 84 8e 00 00 00    	je     8010531d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	50                   	push   %eax
80105293:	e8 d8 c3 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105298:	83 c4 10             	add    $0x10,%esp
8010529b:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
801052a0:	0f 84 d2 00 00 00    	je     80105378 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052a6:	e8 c5 ba ff ff       	call   80100d70 <filealloc>
801052ab:	85 c0                	test   %eax,%eax
801052ad:	89 c6                	mov    %eax,%esi
801052af:	74 2b                	je     801052dc <sys_open+0xac>
801052b1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052b8:	31 db                	xor    %ebx,%ebx
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801052c0:	8b 44 9a 44          	mov    0x44(%edx,%ebx,4),%eax
801052c4:	85 c0                	test   %eax,%eax
801052c6:	74 68                	je     80105330 <sys_open+0x100>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052c8:	83 c3 01             	add    $0x1,%ebx
801052cb:	83 fb 10             	cmp    $0x10,%ebx
801052ce:	75 f0                	jne    801052c0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801052d0:	83 ec 0c             	sub    $0xc,%esp
801052d3:	56                   	push   %esi
801052d4:	e8 57 bb ff ff       	call   80100e30 <fileclose>
801052d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052dc:	83 ec 0c             	sub    $0xc,%esp
801052df:	57                   	push   %edi
801052e0:	e8 fb c5 ff ff       	call   801018e0 <iunlockput>
    end_op();
801052e5:	e8 66 d9 ff ff       	call   80102c50 <end_op>
    return -1;
801052ea:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801052ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801052f5:	5b                   	pop    %ebx
801052f6:	5e                   	pop    %esi
801052f7:	5f                   	pop    %edi
801052f8:	5d                   	pop    %ebp
801052f9:	c3                   	ret    
801052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105306:	31 c9                	xor    %ecx,%ecx
80105308:	6a 00                	push   $0x0
8010530a:	ba 02 00 00 00       	mov    $0x2,%edx
8010530f:	e8 ec f7 ff ff       	call   80104b00 <create>
    if(ip == 0){
80105314:	83 c4 10             	add    $0x10,%esp
80105317:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105319:	89 c7                	mov    %eax,%edi
    if(ip == 0){
8010531b:	75 89                	jne    801052a6 <sys_open+0x76>
      end_op();
8010531d:	e8 2e d9 ff ff       	call   80102c50 <end_op>
      return -1;
80105322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105327:	eb 43                	jmp    8010536c <sys_open+0x13c>
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105330:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105333:	89 74 9a 44          	mov    %esi,0x44(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105337:	57                   	push   %edi
80105338:	e8 13 c4 ff ff       	call   80101750 <iunlock>
  end_op();
8010533d:	e8 0e d9 ff ff       	call   80102c50 <end_op>

  f->type = FD_INODE;
80105342:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105348:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010534b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010534e:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105351:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80105358:	89 d0                	mov    %edx,%eax
8010535a:	83 e0 01             	and    $0x1,%eax
8010535d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105360:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105363:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105366:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
8010536a:	89 d8                	mov    %ebx,%eax
}
8010536c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010536f:	5b                   	pop    %ebx
80105370:	5e                   	pop    %esi
80105371:	5f                   	pop    %edi
80105372:	5d                   	pop    %ebp
80105373:	c3                   	ret    
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105378:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010537b:	85 d2                	test   %edx,%edx
8010537d:	0f 84 23 ff ff ff    	je     801052a6 <sys_open+0x76>
80105383:	e9 54 ff ff ff       	jmp    801052dc <sys_open+0xac>
80105388:	90                   	nop
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105396:	e8 45 d8 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010539b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539e:	83 ec 08             	sub    $0x8,%esp
801053a1:	50                   	push   %eax
801053a2:	6a 00                	push   $0x0
801053a4:	e8 67 f6 ff ff       	call   80104a10 <argstr>
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	85 c0                	test   %eax,%eax
801053ae:	78 30                	js     801053e0 <sys_mkdir+0x50>
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b6:	31 c9                	xor    %ecx,%ecx
801053b8:	6a 00                	push   $0x0
801053ba:	ba 01 00 00 00       	mov    $0x1,%edx
801053bf:	e8 3c f7 ff ff       	call   80104b00 <create>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
801053c9:	74 15                	je     801053e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053cb:	83 ec 0c             	sub    $0xc,%esp
801053ce:	50                   	push   %eax
801053cf:	e8 0c c5 ff ff       	call   801018e0 <iunlockput>
  end_op();
801053d4:	e8 77 d8 ff ff       	call   80102c50 <end_op>
  return 0;
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	31 c0                	xor    %eax,%eax
}
801053de:	c9                   	leave  
801053df:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801053e0:	e8 6b d8 ff ff       	call   80102c50 <end_op>
    return -1;
801053e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801053ea:	c9                   	leave  
801053eb:	c3                   	ret    
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_mknod>:

int
sys_mknod(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053f6:	e8 e5 d7 ff ff       	call   80102be0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053fe:	83 ec 08             	sub    $0x8,%esp
80105401:	50                   	push   %eax
80105402:	6a 00                	push   $0x0
80105404:	e8 07 f6 ff ff       	call   80104a10 <argstr>
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	85 c0                	test   %eax,%eax
8010540e:	78 60                	js     80105470 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105410:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105413:	83 ec 08             	sub    $0x8,%esp
80105416:	50                   	push   %eax
80105417:	6a 01                	push   $0x1
80105419:	e8 62 f5 ff ff       	call   80104980 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	85 c0                	test   %eax,%eax
80105423:	78 4b                	js     80105470 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105425:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105428:	83 ec 08             	sub    $0x8,%esp
8010542b:	50                   	push   %eax
8010542c:	6a 02                	push   $0x2
8010542e:	e8 4d f5 ff ff       	call   80104980 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 36                	js     80105470 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010543a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010543e:	83 ec 0c             	sub    $0xc,%esp
80105441:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105445:	ba 03 00 00 00       	mov    $0x3,%edx
8010544a:	50                   	push   %eax
8010544b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010544e:	e8 ad f6 ff ff       	call   80104b00 <create>
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	74 16                	je     80105470 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010545a:	83 ec 0c             	sub    $0xc,%esp
8010545d:	50                   	push   %eax
8010545e:	e8 7d c4 ff ff       	call   801018e0 <iunlockput>
  end_op();
80105463:	e8 e8 d7 ff ff       	call   80102c50 <end_op>
  return 0;
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	31 c0                	xor    %eax,%eax
}
8010546d:	c9                   	leave  
8010546e:	c3                   	ret    
8010546f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105470:	e8 db d7 ff ff       	call   80102c50 <end_op>
    return -1;
80105475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010547a:	c9                   	leave  
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_chdir>:

int
sys_chdir(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	53                   	push   %ebx
80105484:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105487:	e8 54 d7 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010548c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010548f:	83 ec 08             	sub    $0x8,%esp
80105492:	50                   	push   %eax
80105493:	6a 00                	push   $0x0
80105495:	e8 76 f5 ff ff       	call   80104a10 <argstr>
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	85 c0                	test   %eax,%eax
8010549f:	78 7f                	js     80105520 <sys_chdir+0xa0>
801054a1:	83 ec 0c             	sub    $0xc,%esp
801054a4:	ff 75 f4             	pushl  -0xc(%ebp)
801054a7:	e8 04 ca ff ff       	call   80101eb0 <namei>
801054ac:	83 c4 10             	add    $0x10,%esp
801054af:	85 c0                	test   %eax,%eax
801054b1:	89 c3                	mov    %eax,%ebx
801054b3:	74 6b                	je     80105520 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054b5:	83 ec 0c             	sub    $0xc,%esp
801054b8:	50                   	push   %eax
801054b9:	e8 b2 c1 ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054c6:	75 38                	jne    80105500 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	53                   	push   %ebx
801054cc:	e8 7f c2 ff ff       	call   80101750 <iunlock>
  iput(proc->cwd);
801054d1:	58                   	pop    %eax
801054d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d8:	ff b0 84 00 00 00    	pushl  0x84(%eax)
801054de:	e8 bd c2 ff ff       	call   801017a0 <iput>
  end_op();
801054e3:	e8 68 d7 ff ff       	call   80102c50 <end_op>
  proc->cwd = ip;
801054e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
801054ee:	83 c4 10             	add    $0x10,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
801054f1:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
  return 0;
801054f7:	31 c0                	xor    %eax,%eax
}
801054f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054fc:	c9                   	leave  
801054fd:	c3                   	ret    
801054fe:	66 90                	xchg   %ax,%ax
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	53                   	push   %ebx
80105504:	e8 d7 c3 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105509:	e8 42 d7 ff ff       	call   80102c50 <end_op>
    return -1;
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105516:	eb e1                	jmp    801054f9 <sys_chdir+0x79>
80105518:	90                   	nop
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105520:	e8 2b d7 ff ff       	call   80102c50 <end_op>
    return -1;
80105525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552a:	eb cd                	jmp    801054f9 <sys_chdir+0x79>
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105536:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010553c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105542:	50                   	push   %eax
80105543:	6a 00                	push   $0x0
80105545:	e8 c6 f4 ff ff       	call   80104a10 <argstr>
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	85 c0                	test   %eax,%eax
8010554f:	78 7f                	js     801055d0 <sys_exec+0xa0>
80105551:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105557:	83 ec 08             	sub    $0x8,%esp
8010555a:	50                   	push   %eax
8010555b:	6a 01                	push   $0x1
8010555d:	e8 1e f4 ff ff       	call   80104980 <argint>
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	85 c0                	test   %eax,%eax
80105567:	78 67                	js     801055d0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105569:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010556f:	83 ec 04             	sub    $0x4,%esp
80105572:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105578:	68 80 00 00 00       	push   $0x80
8010557d:	6a 00                	push   $0x0
8010557f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105585:	50                   	push   %eax
80105586:	31 db                	xor    %ebx,%ebx
80105588:	e8 03 f1 ff ff       	call   80104690 <memset>
8010558d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105590:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105596:	83 ec 08             	sub    $0x8,%esp
80105599:	57                   	push   %edi
8010559a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010559d:	50                   	push   %eax
8010559e:	e8 5d f3 ff ff       	call   80104900 <fetchint>
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 26                	js     801055d0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801055aa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055b0:	85 c0                	test   %eax,%eax
801055b2:	74 2c                	je     801055e0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055b4:	83 ec 08             	sub    $0x8,%esp
801055b7:	56                   	push   %esi
801055b8:	50                   	push   %eax
801055b9:	e8 72 f3 ff ff       	call   80104930 <fetchstr>
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	85 c0                	test   %eax,%eax
801055c3:	78 0b                	js     801055d0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801055c5:	83 c3 01             	add    $0x1,%ebx
801055c8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801055cb:	83 fb 20             	cmp    $0x20,%ebx
801055ce:	75 c0                	jne    80105590 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801055d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801055d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801055d8:	5b                   	pop    %ebx
801055d9:	5e                   	pop    %esi
801055da:	5f                   	pop    %edi
801055db:	5d                   	pop    %ebp
801055dc:	c3                   	ret    
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801055e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055e6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801055e9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055f0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801055f4:	50                   	push   %eax
801055f5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801055fb:	e8 f0 b3 ff ff       	call   801009f0 <exec>
80105600:	83 c4 10             	add    $0x10,%esp
}
80105603:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105606:	5b                   	pop    %ebx
80105607:	5e                   	pop    %esi
80105608:	5f                   	pop    %edi
80105609:	5d                   	pop    %ebp
8010560a:	c3                   	ret    
8010560b:	90                   	nop
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_pipe>:

int
sys_pipe(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105616:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105619:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010561c:	6a 08                	push   $0x8
8010561e:	50                   	push   %eax
8010561f:	6a 00                	push   $0x0
80105621:	e8 9a f3 ff ff       	call   801049c0 <argptr>
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 48                	js     80105675 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010562d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	50                   	push   %eax
80105634:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105637:	50                   	push   %eax
80105638:	e8 43 dd ff ff       	call   80103380 <pipealloc>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	78 31                	js     80105675 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105644:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80105647:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010564e:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
80105650:	8b 54 81 44          	mov    0x44(%ecx,%eax,4),%edx
80105654:	85 d2                	test   %edx,%edx
80105656:	74 28                	je     80105680 <sys_pipe+0x70>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105658:	83 c0 01             	add    $0x1,%eax
8010565b:	83 f8 10             	cmp    $0x10,%eax
8010565e:	75 f0                	jne    80105650 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	53                   	push   %ebx
80105664:	e8 c7 b7 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105669:	58                   	pop    %eax
8010566a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010566d:	e8 be b7 ff ff       	call   80100e30 <fileclose>
    return -1;
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567a:	eb 45                	jmp    801056c1 <sys_pipe+0xb1>
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105680:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105683:	8b 7d e4             	mov    -0x1c(%ebp),%edi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105686:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105688:	89 5e 44             	mov    %ebx,0x44(%esi)
8010568b:	90                   	nop
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105690:	83 7c 91 44 00       	cmpl   $0x0,0x44(%ecx,%edx,4)
80105695:	74 19                	je     801056b0 <sys_pipe+0xa0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105697:	83 c2 01             	add    $0x1,%edx
8010569a:	83 fa 10             	cmp    $0x10,%edx
8010569d:	75 f1                	jne    80105690 <sys_pipe+0x80>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
8010569f:	c7 46 44 00 00 00 00 	movl   $0x0,0x44(%esi)
801056a6:	eb b8                	jmp    80105660 <sys_pipe+0x50>
801056a8:	90                   	nop
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801056b0:	89 7c 91 44          	mov    %edi,0x44(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801056b7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801056b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056bf:	31 c0                	xor    %eax,%eax
}
801056c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c4:	5b                   	pop    %ebx
801056c5:	5e                   	pop    %esi
801056c6:	5f                   	pop    %edi
801056c7:	5d                   	pop    %ebp
801056c8:	c3                   	ret    
801056c9:	66 90                	xchg   %ax,%ax
801056cb:	66 90                	xchg   %ax,%ax
801056cd:	66 90                	xchg   %ax,%ax
801056cf:	90                   	nop

801056d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801056d3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801056d4:	e9 67 e3 ff ff       	jmp    80103a40 <fork>
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_exit>:
}

int
sys_exit(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056e6:	e8 15 e6 ff ff       	call   80103d00 <exit>
  return 0;  // not reached
}
801056eb:	31 c0                	xor    %eax,%eax
801056ed:	c9                   	leave  
801056ee:	c3                   	ret    
801056ef:	90                   	nop

801056f0 <sys_wait>:

int
sys_wait(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801056f3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801056f4:	e9 87 e9 ff ff       	jmp    80104080 <wait>
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_kill>:
}

int
sys_kill(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105706:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105709:	50                   	push   %eax
8010570a:	6a 00                	push   $0x0
8010570c:	e8 6f f2 ff ff       	call   80104980 <argint>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	85 c0                	test   %eax,%eax
80105716:	78 18                	js     80105730 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	ff 75 f4             	pushl  -0xc(%ebp)
8010571e:	e8 bd ea ff ff       	call   801041e0 <kill>
80105723:	83 c4 10             	add    $0x10,%esp
}
80105726:	c9                   	leave  
80105727:	c3                   	ret    
80105728:	90                   	nop
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105735:	c9                   	leave  
80105736:	c3                   	ret    
80105737:	89 f6                	mov    %esi,%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105740 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105740:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105746:	55                   	push   %ebp
80105747:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105749:	8b 40 2c             	mov    0x2c(%eax),%eax
}
8010574c:	5d                   	pop    %ebp
8010574d:	c3                   	ret    
8010574e:	66 90                	xchg   %ax,%ax

80105750 <sys_getppid>:
int 
sys_getppid (void){
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 1c             	sub    $0x1c,%esp

	char *wtime = 0 , *rtime = 0;
    argptr(0 , &wtime , sizeof(int));
80105756:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105759:	6a 04                	push   $0x4
  return proc->pid;
}
int 
sys_getppid (void){

	char *wtime = 0 , *rtime = 0;
8010575b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105762:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    argptr(0 , &wtime , sizeof(int));
80105769:	50                   	push   %eax
8010576a:	6a 00                	push   $0x0
8010576c:	e8 4f f2 ff ff       	call   801049c0 <argptr>
    argptr(1 , &rtime , sizeof(int));
80105771:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105774:	83 c4 0c             	add    $0xc,%esp
80105777:	6a 04                	push   $0x4
80105779:	50                   	push   %eax
8010577a:	6a 01                	push   $0x1
8010577c:	e8 3f f2 ff ff       	call   801049c0 <argptr>

   // *wtime = (proc->etime - proc->ctime) - proc->rtime;
   // *rtime = proc->rtime;

    return wait22(wtime,rtime);
80105781:	58                   	pop    %eax
80105782:	5a                   	pop    %edx
80105783:	ff 75 f4             	pushl  -0xc(%ebp)
80105786:	ff 75 f0             	pushl  -0x10(%ebp)
80105789:	e8 e2 e7 ff ff       	call   80103f70 <wait22>

}
8010578e:	c9                   	leave  
8010578f:	c3                   	ret    

80105790 <sys_nice>:

int 
sys_nice (void){

if(proc-> queuelevel >1){
80105790:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
    return wait22(wtime,rtime);

}

int 
sys_nice (void){
80105797:	55                   	push   %ebp
80105798:	89 e5                	mov    %esp,%ebp

if(proc-> queuelevel >1){
8010579a:	8b 42 18             	mov    0x18(%edx),%eax
8010579d:	83 f8 01             	cmp    $0x1,%eax
801057a0:	7e 0e                	jle    801057b0 <sys_nice+0x20>
	proc->queuelevel -- ;
801057a2:	83 e8 01             	sub    $0x1,%eax
801057a5:	89 42 18             	mov    %eax,0x18(%edx)
		return 1;
801057a8:	b8 01 00 00 00       	mov    $0x1,%eax
			}
	return 0;
}
801057ad:	5d                   	pop    %ebp
801057ae:	c3                   	ret    
801057af:	90                   	nop

if(proc-> queuelevel >1){
	proc->queuelevel -- ;
		return 1;
			}
	return 0;
801057b0:	31 c0                	xor    %eax,%eax
}
801057b2:	5d                   	pop    %ebp
801057b3:	c3                   	ret    
801057b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801057c0 <sys_wait2>:

int
sys_wait2(void){
801057c0:	55                   	push   %ebp
	
return 0;

}
801057c1:	31 c0                	xor    %eax,%eax
			}
	return 0;
}

int
sys_wait2(void){
801057c3:	89 e5                	mov    %esp,%ebp
	
return 0;

}
801057c5:	5d                   	pop    %ebp
801057c6:	c3                   	ret    
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057d0 <sys_sbrk>:


int
sys_sbrk(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
}


int
sys_sbrk(void)
{
801057d7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057da:	50                   	push   %eax
801057db:	6a 00                	push   $0x0
801057dd:	e8 9e f1 ff ff       	call   80104980 <argint>
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	85 c0                	test   %eax,%eax
801057e7:	78 27                	js     80105810 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
801057e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
801057ef:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801057f2:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057f4:	ff 75 f4             	pushl  -0xc(%ebp)
801057f7:	e8 d4 e1 ff ff       	call   801039d0 <growproc>
801057fc:	83 c4 10             	add    $0x10,%esp
801057ff:	85 c0                	test   %eax,%eax
80105801:	78 0d                	js     80105810 <sys_sbrk+0x40>
    return -1;
  return addr;
80105803:	89 d8                	mov    %ebx,%eax
}
80105805:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105808:	c9                   	leave  
80105809:	c3                   	ret    
8010580a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105815:	eb ee                	jmp    80105805 <sys_sbrk+0x35>
80105817:	89 f6                	mov    %esi,%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105824:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105827:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010582a:	50                   	push   %eax
8010582b:	6a 00                	push   $0x0
8010582d:	e8 4e f1 ff ff       	call   80104980 <argint>
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	85 c0                	test   %eax,%eax
80105837:	0f 88 8a 00 00 00    	js     801058c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010583d:	83 ec 0c             	sub    $0xc,%esp
80105840:	68 e0 53 11 80       	push   $0x801153e0
80105845:	e8 16 ec ff ff       	call   80104460 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010584a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010584d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105850:	8b 1d 20 5c 11 80    	mov    0x80115c20,%ebx
  while(ticks - ticks0 < n){
80105856:	85 d2                	test   %edx,%edx
80105858:	75 27                	jne    80105881 <sys_sleep+0x61>
8010585a:	eb 54                	jmp    801058b0 <sys_sleep+0x90>
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105860:	83 ec 08             	sub    $0x8,%esp
80105863:	68 e0 53 11 80       	push   $0x801153e0
80105868:	68 20 5c 11 80       	push   $0x80115c20
8010586d:	e8 3e e6 ff ff       	call   80103eb0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105872:	a1 20 5c 11 80       	mov    0x80115c20,%eax
80105877:	83 c4 10             	add    $0x10,%esp
8010587a:	29 d8                	sub    %ebx,%eax
8010587c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010587f:	73 2f                	jae    801058b0 <sys_sleep+0x90>
    if(proc->killed){
80105881:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105887:	8b 40 40             	mov    0x40(%eax),%eax
8010588a:	85 c0                	test   %eax,%eax
8010588c:	74 d2                	je     80105860 <sys_sleep+0x40>
      release(&tickslock);
8010588e:	83 ec 0c             	sub    $0xc,%esp
80105891:	68 e0 53 11 80       	push   $0x801153e0
80105896:	e8 a5 ed ff ff       	call   80104640 <release>
      return -1;
8010589b:	83 c4 10             	add    $0x10,%esp
8010589e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801058a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058a6:	c9                   	leave  
801058a7:	c3                   	ret    
801058a8:	90                   	nop
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	68 e0 53 11 80       	push   $0x801153e0
801058b8:	e8 83 ed ff ff       	call   80104640 <release>
  return 0;
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	31 c0                	xor    %eax,%eax
}
801058c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c5:	c9                   	leave  
801058c6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801058c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cc:	eb d5                	jmp    801058a3 <sys_sleep+0x83>
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
801058d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058d7:	68 e0 53 11 80       	push   $0x801153e0
801058dc:	e8 7f eb ff ff       	call   80104460 <acquire>
  xticks = ticks;
801058e1:	8b 1d 20 5c 11 80    	mov    0x80115c20,%ebx
  release(&tickslock);
801058e7:	c7 04 24 e0 53 11 80 	movl   $0x801153e0,(%esp)
801058ee:	e8 4d ed ff ff       	call   80104640 <release>
  return xticks;
}
801058f3:	89 d8                	mov    %ebx,%eax
801058f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058f8:	c9                   	leave  
801058f9:	c3                   	ret    
801058fa:	66 90                	xchg   %ax,%ax
801058fc:	66 90                	xchg   %ax,%ax
801058fe:	66 90                	xchg   %ax,%ax

80105900 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105900:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105901:	ba 43 00 00 00       	mov    $0x43,%edx
80105906:	b8 34 00 00 00       	mov    $0x34,%eax
8010590b:	89 e5                	mov    %esp,%ebp
8010590d:	83 ec 14             	sub    $0x14,%esp
80105910:	ee                   	out    %al,(%dx)
80105911:	ba 40 00 00 00       	mov    $0x40,%edx
80105916:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
8010591b:	ee                   	out    %al,(%dx)
8010591c:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105921:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105922:	6a 00                	push   $0x0
80105924:	e8 87 d9 ff ff       	call   801032b0 <picenable>
}
80105929:	83 c4 10             	add    $0x10,%esp
8010592c:	c9                   	leave  
8010592d:	c3                   	ret    

8010592e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010592e:	1e                   	push   %ds
  pushl %es
8010592f:	06                   	push   %es
  pushl %fs
80105930:	0f a0                	push   %fs
  pushl %gs
80105932:	0f a8                	push   %gs
  pushal
80105934:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105935:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105939:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010593b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010593d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105941:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105943:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105945:	54                   	push   %esp
  call trap
80105946:	e8 e5 00 00 00       	call   80105a30 <trap>
  addl $4, %esp
8010594b:	83 c4 04             	add    $0x4,%esp

8010594e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010594e:	61                   	popa   
  popl %gs
8010594f:	0f a9                	pop    %gs
  popl %fs
80105951:	0f a1                	pop    %fs
  popl %es
80105953:	07                   	pop    %es
  popl %ds
80105954:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105955:	83 c4 08             	add    $0x8,%esp
  iret
80105958:	cf                   	iret   
80105959:	66 90                	xchg   %ax,%ax
8010595b:	66 90                	xchg   %ax,%ax
8010595d:	66 90                	xchg   %ax,%ax
8010595f:	90                   	nop

80105960 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105960:	31 c0                	xor    %eax,%eax
80105962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105968:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010596f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105974:	c6 04 c5 24 54 11 80 	movb   $0x0,-0x7feeabdc(,%eax,8)
8010597b:	00 
8010597c:	66 89 0c c5 22 54 11 	mov    %cx,-0x7feeabde(,%eax,8)
80105983:	80 
80105984:	c6 04 c5 25 54 11 80 	movb   $0x8e,-0x7feeabdb(,%eax,8)
8010598b:	8e 
8010598c:	66 89 14 c5 20 54 11 	mov    %dx,-0x7feeabe0(,%eax,8)
80105993:	80 
80105994:	c1 ea 10             	shr    $0x10,%edx
80105997:	66 89 14 c5 26 54 11 	mov    %dx,-0x7feeabda(,%eax,8)
8010599e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010599f:	83 c0 01             	add    $0x1,%eax
801059a2:	3d 00 01 00 00       	cmp    $0x100,%eax
801059a7:	75 bf                	jne    80105968 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801059a9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059aa:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801059af:	89 e5                	mov    %esp,%ebp
801059b1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059b4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
801059b9:	68 85 79 10 80       	push   $0x80107985
801059be:	68 e0 53 11 80       	push   $0x801153e0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059c3:	66 89 15 22 56 11 80 	mov    %dx,0x80115622
801059ca:	c6 05 24 56 11 80 00 	movb   $0x0,0x80115624
801059d1:	66 a3 20 56 11 80    	mov    %ax,0x80115620
801059d7:	c1 e8 10             	shr    $0x10,%eax
801059da:	c6 05 25 56 11 80 ef 	movb   $0xef,0x80115625
801059e1:	66 a3 26 56 11 80    	mov    %ax,0x80115626

  initlock(&tickslock, "time");
801059e7:	e8 54 ea ff ff       	call   80104440 <initlock>
}
801059ec:	83 c4 10             	add    $0x10,%esp
801059ef:	c9                   	leave  
801059f0:	c3                   	ret    
801059f1:	eb 0d                	jmp    80105a00 <idtinit>
801059f3:	90                   	nop
801059f4:	90                   	nop
801059f5:	90                   	nop
801059f6:	90                   	nop
801059f7:	90                   	nop
801059f8:	90                   	nop
801059f9:	90                   	nop
801059fa:	90                   	nop
801059fb:	90                   	nop
801059fc:	90                   	nop
801059fd:	90                   	nop
801059fe:	90                   	nop
801059ff:	90                   	nop

80105a00 <idtinit>:

void
idtinit(void)
{
80105a00:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105a01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a06:	89 e5                	mov    %esp,%ebp
80105a08:	83 ec 10             	sub    $0x10,%esp
80105a0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a0f:	b8 20 54 11 80       	mov    $0x80115420,%eax
80105a14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a18:	c1 e8 10             	shr    $0x10,%eax
80105a1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105a1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
80105a35:	53                   	push   %ebx
80105a36:	83 ec 0c             	sub    $0xc,%esp
80105a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105a3c:	8b 43 30             	mov    0x30(%ebx),%eax
80105a3f:	83 f8 40             	cmp    $0x40,%eax
80105a42:	0f 84 f0 00 00 00    	je     80105b38 <trap+0x108>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a48:	83 e8 20             	sub    $0x20,%eax
80105a4b:	83 f8 1f             	cmp    $0x1f,%eax
80105a4e:	77 60                	ja     80105ab0 <trap+0x80>
80105a50:	ff 24 85 2c 7a 10 80 	jmp    *-0x7fef85d4(,%eax,4)
80105a57:	89 f6                	mov    %esi,%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105a60:	e8 7b cb ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
80105a65:	e8 36 cd ff ff       	call   801027a0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105a6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a70:	85 c0                	test   %eax,%eax
80105a72:	74 2d                	je     80105aa1 <trap+0x71>
80105a74:	8b 50 40             	mov    0x40(%eax),%edx
80105a77:	85 d2                	test   %edx,%edx
80105a79:	0f 85 89 00 00 00    	jne    80105b08 <trap+0xd8>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105a7f:	83 78 28 04          	cmpl   $0x4,0x28(%eax)
80105a83:	0f 84 e7 00 00 00    	je     80105b70 <trap+0x140>
	if (proc->myquantum == QUANTA)
    		yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105a89:	8b 40 40             	mov    0x40(%eax),%eax
80105a8c:	85 c0                	test   %eax,%eax
80105a8e:	74 11                	je     80105aa1 <trap+0x71>
80105a90:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a94:	83 e0 03             	and    $0x3,%eax
80105a97:	66 83 f8 03          	cmp    $0x3,%ax
80105a9b:	0f 84 c1 00 00 00    	je     80105b62 <trap+0x132>
    exit();
}
80105aa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aa4:	5b                   	pop    %ebx
80105aa5:	5e                   	pop    %esi
80105aa6:	5f                   	pop    %edi
80105aa7:	5d                   	pop    %ebp
80105aa8:	c3                   	ret    
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105ab0:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105ab7:	85 c9                	test   %ecx,%ecx
80105ab9:	0f 84 e5 01 00 00    	je     80105ca4 <trap+0x274>
80105abf:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ac3:	0f 84 db 01 00 00    	je     80105ca4 <trap+0x274>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ac9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105acc:	8b 73 38             	mov    0x38(%ebx),%esi
80105acf:	e8 2c cc ff ff       	call   80102700 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105ad4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105adb:	57                   	push   %edi
80105adc:	56                   	push   %esi
80105add:	50                   	push   %eax
80105ade:	ff 73 34             	pushl  0x34(%ebx)
80105ae1:	ff 73 30             	pushl  0x30(%ebx)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105ae4:	8d 82 88 00 00 00    	lea    0x88(%edx),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105aea:	50                   	push   %eax
80105aeb:	ff 72 2c             	pushl  0x2c(%edx)
80105aee:	68 e8 79 10 80       	push   $0x801079e8
80105af3:	e8 68 ab ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80105af8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105afe:	83 c4 20             	add    $0x20,%esp
80105b01:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105b08:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105b0c:	83 e2 03             	and    $0x3,%edx
80105b0f:	66 83 fa 03          	cmp    $0x3,%dx
80105b13:	0f 85 66 ff ff ff    	jne    80105a7f <trap+0x4f>
    exit();
80105b19:	e8 e2 e1 ff ff       	call   80103d00 <exit>
80105b1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105b24:	85 c0                	test   %eax,%eax
80105b26:	0f 85 53 ff ff ff    	jne    80105a7f <trap+0x4f>
80105b2c:	e9 70 ff ff ff       	jmp    80105aa1 <trap+0x71>
80105b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105b38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b3e:	8b 70 40             	mov    0x40(%eax),%esi
80105b41:	85 f6                	test   %esi,%esi
80105b43:	0f 85 0f 01 00 00    	jne    80105c58 <trap+0x228>
      exit();
    proc->tf = tf;
80105b49:	89 58 34             	mov    %ebx,0x34(%eax)
    syscall();
80105b4c:	e8 3f ef ff ff       	call   80104a90 <syscall>
    if(proc->killed)
80105b51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b57:	8b 58 40             	mov    0x40(%eax),%ebx
80105b5a:	85 db                	test   %ebx,%ebx
80105b5c:	0f 84 3f ff ff ff    	je     80105aa1 <trap+0x71>
    		yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105b62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b65:	5b                   	pop    %ebx
80105b66:	5e                   	pop    %esi
80105b67:	5f                   	pop    %edi
80105b68:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105b69:	e9 92 e1 ff ff       	jmp    80103d00 <exit>
80105b6e:	66 90                	xchg   %ax,%ax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105b70:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b74:	0f 85 0f ff ff ff    	jne    80105a89 <trap+0x59>
	if (proc->myquantum == QUANTA)
80105b7a:	83 78 1c 05          	cmpl   $0x5,0x1c(%eax)
80105b7e:	0f 85 05 ff ff ff    	jne    80105a89 <trap+0x59>
    		yield();
80105b84:	e8 e7 e2 ff ff       	call   80103e70 <yield>
80105b89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105b8f:	85 c0                	test   %eax,%eax
80105b91:	0f 85 f2 fe ff ff    	jne    80105a89 <trap+0x59>
80105b97:	e9 05 ff ff ff       	jmp    80105aa1 <trap+0x71>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105ba0:	e8 5b cb ff ff       	call   80102700 <cpunum>
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	0f 84 c3 00 00 00    	je     80105c70 <trap+0x240>
      acquire(&tickslock);     
      ticks++;
      wakeup(&ticks);     
      release(&tickslock);	
    }
    lapiceoi();
80105bad:	e8 ee cb ff ff       	call   801027a0 <lapiceoi>
    if(proc && proc->state == RUNNING){
80105bb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bb8:	85 c0                	test   %eax,%eax
80105bba:	0f 84 e1 fe ff ff    	je     80105aa1 <trap+0x71>
80105bc0:	83 78 28 04          	cmpl   $0x4,0x28(%eax)
80105bc4:	0f 85 aa fe ff ff    	jne    80105a74 <trap+0x44>
	proc->rtime++;
80105bca:	83 40 0c 01          	addl   $0x1,0xc(%eax)
	proc->myquantum++;
80105bce:	83 40 1c 01          	addl   $0x1,0x1c(%eax)
80105bd2:	e9 9d fe ff ff       	jmp    80105a74 <trap+0x44>
80105bd7:	89 f6                	mov    %esi,%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105be0:	e8 5b 02 00 00       	call   80105e40 <uartintr>
    lapiceoi();
80105be5:	e8 b6 cb ff ff       	call   801027a0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105bea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	0f 85 7c fe ff ff    	jne    80105a74 <trap+0x44>
80105bf8:	e9 a4 fe ff ff       	jmp    80105aa1 <trap+0x71>
80105bfd:	8d 76 00             	lea    0x0(%esi),%esi
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c00:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105c04:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c07:	e8 f4 ca ff ff       	call   80102700 <cpunum>
80105c0c:	57                   	push   %edi
80105c0d:	56                   	push   %esi
80105c0e:	50                   	push   %eax
80105c0f:	68 90 79 10 80       	push   $0x80107990
80105c14:	e8 47 aa ff ff       	call   80100660 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105c19:	e8 82 cb ff ff       	call   801027a0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105c1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
    break;
80105c24:	83 c4 10             	add    $0x10,%esp
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105c27:	85 c0                	test   %eax,%eax
80105c29:	0f 85 45 fe ff ff    	jne    80105a74 <trap+0x44>
80105c2f:	e9 6d fe ff ff       	jmp    80105aa1 <trap+0x71>
80105c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	proc->rtime++;
	proc->myquantum++;
    }
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c38:	e8 13 c4 ff ff       	call   80102050 <ideintr>
    lapiceoi();
80105c3d:	e8 5e cb ff ff       	call   801027a0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105c42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c48:	85 c0                	test   %eax,%eax
80105c4a:	0f 85 24 fe ff ff    	jne    80105a74 <trap+0x44>
80105c50:	e9 4c fe ff ff       	jmp    80105aa1 <trap+0x71>
80105c55:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105c58:	e8 a3 e0 ff ff       	call   80103d00 <exit>
80105c5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c63:	e9 e1 fe ff ff       	jmp    80105b49 <trap+0x119>
80105c68:	90                   	nop
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);     
80105c70:	83 ec 0c             	sub    $0xc,%esp
80105c73:	68 e0 53 11 80       	push   $0x801153e0
80105c78:	e8 e3 e7 ff ff       	call   80104460 <acquire>
      ticks++;
      wakeup(&ticks);     
80105c7d:	c7 04 24 20 5c 11 80 	movl   $0x80115c20,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);     
      ticks++;
80105c84:	83 05 20 5c 11 80 01 	addl   $0x1,0x80115c20
      wakeup(&ticks);     
80105c8b:	e8 e0 e4 ff ff       	call   80104170 <wakeup>
      release(&tickslock);	
80105c90:	c7 04 24 e0 53 11 80 	movl   $0x801153e0,(%esp)
80105c97:	e8 a4 e9 ff ff       	call   80104640 <release>
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	e9 09 ff ff ff       	jmp    80105bad <trap+0x17d>
80105ca4:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ca7:	8b 73 38             	mov    0x38(%ebx),%esi
80105caa:	e8 51 ca ff ff       	call   80102700 <cpunum>
80105caf:	83 ec 0c             	sub    $0xc,%esp
80105cb2:	57                   	push   %edi
80105cb3:	56                   	push   %esi
80105cb4:	50                   	push   %eax
80105cb5:	ff 73 30             	pushl  0x30(%ebx)
80105cb8:	68 b4 79 10 80       	push   $0x801079b4
80105cbd:	e8 9e a9 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105cc2:	83 c4 14             	add    $0x14,%esp
80105cc5:	68 8a 79 10 80       	push   $0x8010798a
80105cca:	e8 a1 a6 ff ff       	call   80100370 <panic>
80105ccf:	90                   	nop

80105cd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105cd0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105cd5:	55                   	push   %ebp
80105cd6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105cd8:	85 c0                	test   %eax,%eax
80105cda:	74 1c                	je     80105cf8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cdc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ce1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ce2:	a8 01                	test   $0x1,%al
80105ce4:	74 12                	je     80105cf8 <uartgetc+0x28>
80105ce6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ceb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105cec:	0f b6 c0             	movzbl %al,%eax
}
80105cef:	5d                   	pop    %ebp
80105cf0:	c3                   	ret    
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105cfd:	5d                   	pop    %ebp
80105cfe:	c3                   	ret    
80105cff:	90                   	nop

80105d00 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	57                   	push   %edi
80105d04:	56                   	push   %esi
80105d05:	53                   	push   %ebx
80105d06:	89 c7                	mov    %eax,%edi
80105d08:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d12:	83 ec 0c             	sub    $0xc,%esp
80105d15:	eb 1b                	jmp    80105d32 <uartputc.part.0+0x32>
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105d20:	83 ec 0c             	sub    $0xc,%esp
80105d23:	6a 0a                	push   $0xa
80105d25:	e8 96 ca ff ff       	call   801027c0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	83 eb 01             	sub    $0x1,%ebx
80105d30:	74 07                	je     80105d39 <uartputc.part.0+0x39>
80105d32:	89 f2                	mov    %esi,%edx
80105d34:	ec                   	in     (%dx),%al
80105d35:	a8 20                	test   $0x20,%al
80105d37:	74 e7                	je     80105d20 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d3e:	89 f8                	mov    %edi,%eax
80105d40:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d44:	5b                   	pop    %ebx
80105d45:	5e                   	pop    %esi
80105d46:	5f                   	pop    %edi
80105d47:	5d                   	pop    %ebp
80105d48:	c3                   	ret    
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d50 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105d50:	55                   	push   %ebp
80105d51:	31 c9                	xor    %ecx,%ecx
80105d53:	89 c8                	mov    %ecx,%eax
80105d55:	89 e5                	mov    %esp,%ebp
80105d57:	57                   	push   %edi
80105d58:	56                   	push   %esi
80105d59:	53                   	push   %ebx
80105d5a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d5f:	89 da                	mov    %ebx,%edx
80105d61:	83 ec 0c             	sub    $0xc,%esp
80105d64:	ee                   	out    %al,(%dx)
80105d65:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d6f:	89 fa                	mov    %edi,%edx
80105d71:	ee                   	out    %al,(%dx)
80105d72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d7c:	ee                   	out    %al,(%dx)
80105d7d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d82:	89 c8                	mov    %ecx,%eax
80105d84:	89 f2                	mov    %esi,%edx
80105d86:	ee                   	out    %al,(%dx)
80105d87:	b8 03 00 00 00       	mov    $0x3,%eax
80105d8c:	89 fa                	mov    %edi,%edx
80105d8e:	ee                   	out    %al,(%dx)
80105d8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d94:	89 c8                	mov    %ecx,%eax
80105d96:	ee                   	out    %al,(%dx)
80105d97:	b8 01 00 00 00       	mov    $0x1,%eax
80105d9c:	89 f2                	mov    %esi,%edx
80105d9e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105da4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105da5:	3c ff                	cmp    $0xff,%al
80105da7:	74 5a                	je     80105e03 <uartinit+0xb3>
    return;
  uart = 1;
80105da9:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105db0:	00 00 00 
80105db3:	89 da                	mov    %ebx,%edx
80105db5:	ec                   	in     (%dx),%al
80105db6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dbb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105dbc:	83 ec 0c             	sub    $0xc,%esp
80105dbf:	6a 04                	push   $0x4
80105dc1:	e8 ea d4 ff ff       	call   801032b0 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105dc6:	59                   	pop    %ecx
80105dc7:	5b                   	pop    %ebx
80105dc8:	6a 00                	push   $0x0
80105dca:	6a 04                	push   $0x4
80105dcc:	bb ac 7a 10 80       	mov    $0x80107aac,%ebx
80105dd1:	e8 da c4 ff ff       	call   801022b0 <ioapicenable>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	b8 78 00 00 00       	mov    $0x78,%eax
80105dde:	eb 0a                	jmp    80105dea <uartinit+0x9a>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105de0:	83 c3 01             	add    $0x1,%ebx
80105de3:	0f be 03             	movsbl (%ebx),%eax
80105de6:	84 c0                	test   %al,%al
80105de8:	74 19                	je     80105e03 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105dea:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105df0:	85 d2                	test   %edx,%edx
80105df2:	74 ec                	je     80105de0 <uartinit+0x90>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105df4:	83 c3 01             	add    $0x1,%ebx
80105df7:	e8 04 ff ff ff       	call   80105d00 <uartputc.part.0>
80105dfc:	0f be 03             	movsbl (%ebx),%eax
80105dff:	84 c0                	test   %al,%al
80105e01:	75 e7                	jne    80105dea <uartinit+0x9a>
    uartputc(*p);
}
80105e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e06:	5b                   	pop    %ebx
80105e07:	5e                   	pop    %esi
80105e08:	5f                   	pop    %edi
80105e09:	5d                   	pop    %ebp
80105e0a:	c3                   	ret    
80105e0b:	90                   	nop
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e10 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105e10:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105e16:	55                   	push   %ebp
80105e17:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105e19:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105e1e:	74 10                	je     80105e30 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105e20:	5d                   	pop    %ebp
80105e21:	e9 da fe ff ff       	jmp    80105d00 <uartputc.part.0>
80105e26:	8d 76 00             	lea    0x0(%esi),%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e30:	5d                   	pop    %ebp
80105e31:	c3                   	ret    
80105e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e40 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e46:	68 d0 5c 10 80       	push   $0x80105cd0
80105e4b:	e8 a0 a9 ff ff       	call   801007f0 <consoleintr>
}
80105e50:	83 c4 10             	add    $0x10,%esp
80105e53:	c9                   	leave  
80105e54:	c3                   	ret    

80105e55 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e55:	6a 00                	push   $0x0
  pushl $0
80105e57:	6a 00                	push   $0x0
  jmp alltraps
80105e59:	e9 d0 fa ff ff       	jmp    8010592e <alltraps>

80105e5e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $1
80105e60:	6a 01                	push   $0x1
  jmp alltraps
80105e62:	e9 c7 fa ff ff       	jmp    8010592e <alltraps>

80105e67 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $2
80105e69:	6a 02                	push   $0x2
  jmp alltraps
80105e6b:	e9 be fa ff ff       	jmp    8010592e <alltraps>

80105e70 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $3
80105e72:	6a 03                	push   $0x3
  jmp alltraps
80105e74:	e9 b5 fa ff ff       	jmp    8010592e <alltraps>

80105e79 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $4
80105e7b:	6a 04                	push   $0x4
  jmp alltraps
80105e7d:	e9 ac fa ff ff       	jmp    8010592e <alltraps>

80105e82 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $5
80105e84:	6a 05                	push   $0x5
  jmp alltraps
80105e86:	e9 a3 fa ff ff       	jmp    8010592e <alltraps>

80105e8b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $6
80105e8d:	6a 06                	push   $0x6
  jmp alltraps
80105e8f:	e9 9a fa ff ff       	jmp    8010592e <alltraps>

80105e94 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $7
80105e96:	6a 07                	push   $0x7
  jmp alltraps
80105e98:	e9 91 fa ff ff       	jmp    8010592e <alltraps>

80105e9d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e9d:	6a 08                	push   $0x8
  jmp alltraps
80105e9f:	e9 8a fa ff ff       	jmp    8010592e <alltraps>

80105ea4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $9
80105ea6:	6a 09                	push   $0x9
  jmp alltraps
80105ea8:	e9 81 fa ff ff       	jmp    8010592e <alltraps>

80105ead <vector10>:
.globl vector10
vector10:
  pushl $10
80105ead:	6a 0a                	push   $0xa
  jmp alltraps
80105eaf:	e9 7a fa ff ff       	jmp    8010592e <alltraps>

80105eb4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105eb4:	6a 0b                	push   $0xb
  jmp alltraps
80105eb6:	e9 73 fa ff ff       	jmp    8010592e <alltraps>

80105ebb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ebb:	6a 0c                	push   $0xc
  jmp alltraps
80105ebd:	e9 6c fa ff ff       	jmp    8010592e <alltraps>

80105ec2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ec2:	6a 0d                	push   $0xd
  jmp alltraps
80105ec4:	e9 65 fa ff ff       	jmp    8010592e <alltraps>

80105ec9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ec9:	6a 0e                	push   $0xe
  jmp alltraps
80105ecb:	e9 5e fa ff ff       	jmp    8010592e <alltraps>

80105ed0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $15
80105ed2:	6a 0f                	push   $0xf
  jmp alltraps
80105ed4:	e9 55 fa ff ff       	jmp    8010592e <alltraps>

80105ed9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $16
80105edb:	6a 10                	push   $0x10
  jmp alltraps
80105edd:	e9 4c fa ff ff       	jmp    8010592e <alltraps>

80105ee2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ee2:	6a 11                	push   $0x11
  jmp alltraps
80105ee4:	e9 45 fa ff ff       	jmp    8010592e <alltraps>

80105ee9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ee9:	6a 00                	push   $0x0
  pushl $18
80105eeb:	6a 12                	push   $0x12
  jmp alltraps
80105eed:	e9 3c fa ff ff       	jmp    8010592e <alltraps>

80105ef2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $19
80105ef4:	6a 13                	push   $0x13
  jmp alltraps
80105ef6:	e9 33 fa ff ff       	jmp    8010592e <alltraps>

80105efb <vector20>:
.globl vector20
vector20:
  pushl $0
80105efb:	6a 00                	push   $0x0
  pushl $20
80105efd:	6a 14                	push   $0x14
  jmp alltraps
80105eff:	e9 2a fa ff ff       	jmp    8010592e <alltraps>

80105f04 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $21
80105f06:	6a 15                	push   $0x15
  jmp alltraps
80105f08:	e9 21 fa ff ff       	jmp    8010592e <alltraps>

80105f0d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f0d:	6a 00                	push   $0x0
  pushl $22
80105f0f:	6a 16                	push   $0x16
  jmp alltraps
80105f11:	e9 18 fa ff ff       	jmp    8010592e <alltraps>

80105f16 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $23
80105f18:	6a 17                	push   $0x17
  jmp alltraps
80105f1a:	e9 0f fa ff ff       	jmp    8010592e <alltraps>

80105f1f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f1f:	6a 00                	push   $0x0
  pushl $24
80105f21:	6a 18                	push   $0x18
  jmp alltraps
80105f23:	e9 06 fa ff ff       	jmp    8010592e <alltraps>

80105f28 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f28:	6a 00                	push   $0x0
  pushl $25
80105f2a:	6a 19                	push   $0x19
  jmp alltraps
80105f2c:	e9 fd f9 ff ff       	jmp    8010592e <alltraps>

80105f31 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f31:	6a 00                	push   $0x0
  pushl $26
80105f33:	6a 1a                	push   $0x1a
  jmp alltraps
80105f35:	e9 f4 f9 ff ff       	jmp    8010592e <alltraps>

80105f3a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $27
80105f3c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f3e:	e9 eb f9 ff ff       	jmp    8010592e <alltraps>

80105f43 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f43:	6a 00                	push   $0x0
  pushl $28
80105f45:	6a 1c                	push   $0x1c
  jmp alltraps
80105f47:	e9 e2 f9 ff ff       	jmp    8010592e <alltraps>

80105f4c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f4c:	6a 00                	push   $0x0
  pushl $29
80105f4e:	6a 1d                	push   $0x1d
  jmp alltraps
80105f50:	e9 d9 f9 ff ff       	jmp    8010592e <alltraps>

80105f55 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f55:	6a 00                	push   $0x0
  pushl $30
80105f57:	6a 1e                	push   $0x1e
  jmp alltraps
80105f59:	e9 d0 f9 ff ff       	jmp    8010592e <alltraps>

80105f5e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $31
80105f60:	6a 1f                	push   $0x1f
  jmp alltraps
80105f62:	e9 c7 f9 ff ff       	jmp    8010592e <alltraps>

80105f67 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f67:	6a 00                	push   $0x0
  pushl $32
80105f69:	6a 20                	push   $0x20
  jmp alltraps
80105f6b:	e9 be f9 ff ff       	jmp    8010592e <alltraps>

80105f70 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f70:	6a 00                	push   $0x0
  pushl $33
80105f72:	6a 21                	push   $0x21
  jmp alltraps
80105f74:	e9 b5 f9 ff ff       	jmp    8010592e <alltraps>

80105f79 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f79:	6a 00                	push   $0x0
  pushl $34
80105f7b:	6a 22                	push   $0x22
  jmp alltraps
80105f7d:	e9 ac f9 ff ff       	jmp    8010592e <alltraps>

80105f82 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $35
80105f84:	6a 23                	push   $0x23
  jmp alltraps
80105f86:	e9 a3 f9 ff ff       	jmp    8010592e <alltraps>

80105f8b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f8b:	6a 00                	push   $0x0
  pushl $36
80105f8d:	6a 24                	push   $0x24
  jmp alltraps
80105f8f:	e9 9a f9 ff ff       	jmp    8010592e <alltraps>

80105f94 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f94:	6a 00                	push   $0x0
  pushl $37
80105f96:	6a 25                	push   $0x25
  jmp alltraps
80105f98:	e9 91 f9 ff ff       	jmp    8010592e <alltraps>

80105f9d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f9d:	6a 00                	push   $0x0
  pushl $38
80105f9f:	6a 26                	push   $0x26
  jmp alltraps
80105fa1:	e9 88 f9 ff ff       	jmp    8010592e <alltraps>

80105fa6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $39
80105fa8:	6a 27                	push   $0x27
  jmp alltraps
80105faa:	e9 7f f9 ff ff       	jmp    8010592e <alltraps>

80105faf <vector40>:
.globl vector40
vector40:
  pushl $0
80105faf:	6a 00                	push   $0x0
  pushl $40
80105fb1:	6a 28                	push   $0x28
  jmp alltraps
80105fb3:	e9 76 f9 ff ff       	jmp    8010592e <alltraps>

80105fb8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105fb8:	6a 00                	push   $0x0
  pushl $41
80105fba:	6a 29                	push   $0x29
  jmp alltraps
80105fbc:	e9 6d f9 ff ff       	jmp    8010592e <alltraps>

80105fc1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105fc1:	6a 00                	push   $0x0
  pushl $42
80105fc3:	6a 2a                	push   $0x2a
  jmp alltraps
80105fc5:	e9 64 f9 ff ff       	jmp    8010592e <alltraps>

80105fca <vector43>:
.globl vector43
vector43:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $43
80105fcc:	6a 2b                	push   $0x2b
  jmp alltraps
80105fce:	e9 5b f9 ff ff       	jmp    8010592e <alltraps>

80105fd3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105fd3:	6a 00                	push   $0x0
  pushl $44
80105fd5:	6a 2c                	push   $0x2c
  jmp alltraps
80105fd7:	e9 52 f9 ff ff       	jmp    8010592e <alltraps>

80105fdc <vector45>:
.globl vector45
vector45:
  pushl $0
80105fdc:	6a 00                	push   $0x0
  pushl $45
80105fde:	6a 2d                	push   $0x2d
  jmp alltraps
80105fe0:	e9 49 f9 ff ff       	jmp    8010592e <alltraps>

80105fe5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fe5:	6a 00                	push   $0x0
  pushl $46
80105fe7:	6a 2e                	push   $0x2e
  jmp alltraps
80105fe9:	e9 40 f9 ff ff       	jmp    8010592e <alltraps>

80105fee <vector47>:
.globl vector47
vector47:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $47
80105ff0:	6a 2f                	push   $0x2f
  jmp alltraps
80105ff2:	e9 37 f9 ff ff       	jmp    8010592e <alltraps>

80105ff7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $48
80105ff9:	6a 30                	push   $0x30
  jmp alltraps
80105ffb:	e9 2e f9 ff ff       	jmp    8010592e <alltraps>

80106000 <vector49>:
.globl vector49
vector49:
  pushl $0
80106000:	6a 00                	push   $0x0
  pushl $49
80106002:	6a 31                	push   $0x31
  jmp alltraps
80106004:	e9 25 f9 ff ff       	jmp    8010592e <alltraps>

80106009 <vector50>:
.globl vector50
vector50:
  pushl $0
80106009:	6a 00                	push   $0x0
  pushl $50
8010600b:	6a 32                	push   $0x32
  jmp alltraps
8010600d:	e9 1c f9 ff ff       	jmp    8010592e <alltraps>

80106012 <vector51>:
.globl vector51
vector51:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $51
80106014:	6a 33                	push   $0x33
  jmp alltraps
80106016:	e9 13 f9 ff ff       	jmp    8010592e <alltraps>

8010601b <vector52>:
.globl vector52
vector52:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $52
8010601d:	6a 34                	push   $0x34
  jmp alltraps
8010601f:	e9 0a f9 ff ff       	jmp    8010592e <alltraps>

80106024 <vector53>:
.globl vector53
vector53:
  pushl $0
80106024:	6a 00                	push   $0x0
  pushl $53
80106026:	6a 35                	push   $0x35
  jmp alltraps
80106028:	e9 01 f9 ff ff       	jmp    8010592e <alltraps>

8010602d <vector54>:
.globl vector54
vector54:
  pushl $0
8010602d:	6a 00                	push   $0x0
  pushl $54
8010602f:	6a 36                	push   $0x36
  jmp alltraps
80106031:	e9 f8 f8 ff ff       	jmp    8010592e <alltraps>

80106036 <vector55>:
.globl vector55
vector55:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $55
80106038:	6a 37                	push   $0x37
  jmp alltraps
8010603a:	e9 ef f8 ff ff       	jmp    8010592e <alltraps>

8010603f <vector56>:
.globl vector56
vector56:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $56
80106041:	6a 38                	push   $0x38
  jmp alltraps
80106043:	e9 e6 f8 ff ff       	jmp    8010592e <alltraps>

80106048 <vector57>:
.globl vector57
vector57:
  pushl $0
80106048:	6a 00                	push   $0x0
  pushl $57
8010604a:	6a 39                	push   $0x39
  jmp alltraps
8010604c:	e9 dd f8 ff ff       	jmp    8010592e <alltraps>

80106051 <vector58>:
.globl vector58
vector58:
  pushl $0
80106051:	6a 00                	push   $0x0
  pushl $58
80106053:	6a 3a                	push   $0x3a
  jmp alltraps
80106055:	e9 d4 f8 ff ff       	jmp    8010592e <alltraps>

8010605a <vector59>:
.globl vector59
vector59:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $59
8010605c:	6a 3b                	push   $0x3b
  jmp alltraps
8010605e:	e9 cb f8 ff ff       	jmp    8010592e <alltraps>

80106063 <vector60>:
.globl vector60
vector60:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $60
80106065:	6a 3c                	push   $0x3c
  jmp alltraps
80106067:	e9 c2 f8 ff ff       	jmp    8010592e <alltraps>

8010606c <vector61>:
.globl vector61
vector61:
  pushl $0
8010606c:	6a 00                	push   $0x0
  pushl $61
8010606e:	6a 3d                	push   $0x3d
  jmp alltraps
80106070:	e9 b9 f8 ff ff       	jmp    8010592e <alltraps>

80106075 <vector62>:
.globl vector62
vector62:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $62
80106077:	6a 3e                	push   $0x3e
  jmp alltraps
80106079:	e9 b0 f8 ff ff       	jmp    8010592e <alltraps>

8010607e <vector63>:
.globl vector63
vector63:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $63
80106080:	6a 3f                	push   $0x3f
  jmp alltraps
80106082:	e9 a7 f8 ff ff       	jmp    8010592e <alltraps>

80106087 <vector64>:
.globl vector64
vector64:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $64
80106089:	6a 40                	push   $0x40
  jmp alltraps
8010608b:	e9 9e f8 ff ff       	jmp    8010592e <alltraps>

80106090 <vector65>:
.globl vector65
vector65:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $65
80106092:	6a 41                	push   $0x41
  jmp alltraps
80106094:	e9 95 f8 ff ff       	jmp    8010592e <alltraps>

80106099 <vector66>:
.globl vector66
vector66:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $66
8010609b:	6a 42                	push   $0x42
  jmp alltraps
8010609d:	e9 8c f8 ff ff       	jmp    8010592e <alltraps>

801060a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $67
801060a4:	6a 43                	push   $0x43
  jmp alltraps
801060a6:	e9 83 f8 ff ff       	jmp    8010592e <alltraps>

801060ab <vector68>:
.globl vector68
vector68:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $68
801060ad:	6a 44                	push   $0x44
  jmp alltraps
801060af:	e9 7a f8 ff ff       	jmp    8010592e <alltraps>

801060b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $69
801060b6:	6a 45                	push   $0x45
  jmp alltraps
801060b8:	e9 71 f8 ff ff       	jmp    8010592e <alltraps>

801060bd <vector70>:
.globl vector70
vector70:
  pushl $0
801060bd:	6a 00                	push   $0x0
  pushl $70
801060bf:	6a 46                	push   $0x46
  jmp alltraps
801060c1:	e9 68 f8 ff ff       	jmp    8010592e <alltraps>

801060c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $71
801060c8:	6a 47                	push   $0x47
  jmp alltraps
801060ca:	e9 5f f8 ff ff       	jmp    8010592e <alltraps>

801060cf <vector72>:
.globl vector72
vector72:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $72
801060d1:	6a 48                	push   $0x48
  jmp alltraps
801060d3:	e9 56 f8 ff ff       	jmp    8010592e <alltraps>

801060d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801060d8:	6a 00                	push   $0x0
  pushl $73
801060da:	6a 49                	push   $0x49
  jmp alltraps
801060dc:	e9 4d f8 ff ff       	jmp    8010592e <alltraps>

801060e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801060e1:	6a 00                	push   $0x0
  pushl $74
801060e3:	6a 4a                	push   $0x4a
  jmp alltraps
801060e5:	e9 44 f8 ff ff       	jmp    8010592e <alltraps>

801060ea <vector75>:
.globl vector75
vector75:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $75
801060ec:	6a 4b                	push   $0x4b
  jmp alltraps
801060ee:	e9 3b f8 ff ff       	jmp    8010592e <alltraps>

801060f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $76
801060f5:	6a 4c                	push   $0x4c
  jmp alltraps
801060f7:	e9 32 f8 ff ff       	jmp    8010592e <alltraps>

801060fc <vector77>:
.globl vector77
vector77:
  pushl $0
801060fc:	6a 00                	push   $0x0
  pushl $77
801060fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106100:	e9 29 f8 ff ff       	jmp    8010592e <alltraps>

80106105 <vector78>:
.globl vector78
vector78:
  pushl $0
80106105:	6a 00                	push   $0x0
  pushl $78
80106107:	6a 4e                	push   $0x4e
  jmp alltraps
80106109:	e9 20 f8 ff ff       	jmp    8010592e <alltraps>

8010610e <vector79>:
.globl vector79
vector79:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $79
80106110:	6a 4f                	push   $0x4f
  jmp alltraps
80106112:	e9 17 f8 ff ff       	jmp    8010592e <alltraps>

80106117 <vector80>:
.globl vector80
vector80:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $80
80106119:	6a 50                	push   $0x50
  jmp alltraps
8010611b:	e9 0e f8 ff ff       	jmp    8010592e <alltraps>

80106120 <vector81>:
.globl vector81
vector81:
  pushl $0
80106120:	6a 00                	push   $0x0
  pushl $81
80106122:	6a 51                	push   $0x51
  jmp alltraps
80106124:	e9 05 f8 ff ff       	jmp    8010592e <alltraps>

80106129 <vector82>:
.globl vector82
vector82:
  pushl $0
80106129:	6a 00                	push   $0x0
  pushl $82
8010612b:	6a 52                	push   $0x52
  jmp alltraps
8010612d:	e9 fc f7 ff ff       	jmp    8010592e <alltraps>

80106132 <vector83>:
.globl vector83
vector83:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $83
80106134:	6a 53                	push   $0x53
  jmp alltraps
80106136:	e9 f3 f7 ff ff       	jmp    8010592e <alltraps>

8010613b <vector84>:
.globl vector84
vector84:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $84
8010613d:	6a 54                	push   $0x54
  jmp alltraps
8010613f:	e9 ea f7 ff ff       	jmp    8010592e <alltraps>

80106144 <vector85>:
.globl vector85
vector85:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $85
80106146:	6a 55                	push   $0x55
  jmp alltraps
80106148:	e9 e1 f7 ff ff       	jmp    8010592e <alltraps>

8010614d <vector86>:
.globl vector86
vector86:
  pushl $0
8010614d:	6a 00                	push   $0x0
  pushl $86
8010614f:	6a 56                	push   $0x56
  jmp alltraps
80106151:	e9 d8 f7 ff ff       	jmp    8010592e <alltraps>

80106156 <vector87>:
.globl vector87
vector87:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $87
80106158:	6a 57                	push   $0x57
  jmp alltraps
8010615a:	e9 cf f7 ff ff       	jmp    8010592e <alltraps>

8010615f <vector88>:
.globl vector88
vector88:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $88
80106161:	6a 58                	push   $0x58
  jmp alltraps
80106163:	e9 c6 f7 ff ff       	jmp    8010592e <alltraps>

80106168 <vector89>:
.globl vector89
vector89:
  pushl $0
80106168:	6a 00                	push   $0x0
  pushl $89
8010616a:	6a 59                	push   $0x59
  jmp alltraps
8010616c:	e9 bd f7 ff ff       	jmp    8010592e <alltraps>

80106171 <vector90>:
.globl vector90
vector90:
  pushl $0
80106171:	6a 00                	push   $0x0
  pushl $90
80106173:	6a 5a                	push   $0x5a
  jmp alltraps
80106175:	e9 b4 f7 ff ff       	jmp    8010592e <alltraps>

8010617a <vector91>:
.globl vector91
vector91:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $91
8010617c:	6a 5b                	push   $0x5b
  jmp alltraps
8010617e:	e9 ab f7 ff ff       	jmp    8010592e <alltraps>

80106183 <vector92>:
.globl vector92
vector92:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $92
80106185:	6a 5c                	push   $0x5c
  jmp alltraps
80106187:	e9 a2 f7 ff ff       	jmp    8010592e <alltraps>

8010618c <vector93>:
.globl vector93
vector93:
  pushl $0
8010618c:	6a 00                	push   $0x0
  pushl $93
8010618e:	6a 5d                	push   $0x5d
  jmp alltraps
80106190:	e9 99 f7 ff ff       	jmp    8010592e <alltraps>

80106195 <vector94>:
.globl vector94
vector94:
  pushl $0
80106195:	6a 00                	push   $0x0
  pushl $94
80106197:	6a 5e                	push   $0x5e
  jmp alltraps
80106199:	e9 90 f7 ff ff       	jmp    8010592e <alltraps>

8010619e <vector95>:
.globl vector95
vector95:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $95
801061a0:	6a 5f                	push   $0x5f
  jmp alltraps
801061a2:	e9 87 f7 ff ff       	jmp    8010592e <alltraps>

801061a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $96
801061a9:	6a 60                	push   $0x60
  jmp alltraps
801061ab:	e9 7e f7 ff ff       	jmp    8010592e <alltraps>

801061b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801061b0:	6a 00                	push   $0x0
  pushl $97
801061b2:	6a 61                	push   $0x61
  jmp alltraps
801061b4:	e9 75 f7 ff ff       	jmp    8010592e <alltraps>

801061b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801061b9:	6a 00                	push   $0x0
  pushl $98
801061bb:	6a 62                	push   $0x62
  jmp alltraps
801061bd:	e9 6c f7 ff ff       	jmp    8010592e <alltraps>

801061c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $99
801061c4:	6a 63                	push   $0x63
  jmp alltraps
801061c6:	e9 63 f7 ff ff       	jmp    8010592e <alltraps>

801061cb <vector100>:
.globl vector100
vector100:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $100
801061cd:	6a 64                	push   $0x64
  jmp alltraps
801061cf:	e9 5a f7 ff ff       	jmp    8010592e <alltraps>

801061d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801061d4:	6a 00                	push   $0x0
  pushl $101
801061d6:	6a 65                	push   $0x65
  jmp alltraps
801061d8:	e9 51 f7 ff ff       	jmp    8010592e <alltraps>

801061dd <vector102>:
.globl vector102
vector102:
  pushl $0
801061dd:	6a 00                	push   $0x0
  pushl $102
801061df:	6a 66                	push   $0x66
  jmp alltraps
801061e1:	e9 48 f7 ff ff       	jmp    8010592e <alltraps>

801061e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $103
801061e8:	6a 67                	push   $0x67
  jmp alltraps
801061ea:	e9 3f f7 ff ff       	jmp    8010592e <alltraps>

801061ef <vector104>:
.globl vector104
vector104:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $104
801061f1:	6a 68                	push   $0x68
  jmp alltraps
801061f3:	e9 36 f7 ff ff       	jmp    8010592e <alltraps>

801061f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801061f8:	6a 00                	push   $0x0
  pushl $105
801061fa:	6a 69                	push   $0x69
  jmp alltraps
801061fc:	e9 2d f7 ff ff       	jmp    8010592e <alltraps>

80106201 <vector106>:
.globl vector106
vector106:
  pushl $0
80106201:	6a 00                	push   $0x0
  pushl $106
80106203:	6a 6a                	push   $0x6a
  jmp alltraps
80106205:	e9 24 f7 ff ff       	jmp    8010592e <alltraps>

8010620a <vector107>:
.globl vector107
vector107:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $107
8010620c:	6a 6b                	push   $0x6b
  jmp alltraps
8010620e:	e9 1b f7 ff ff       	jmp    8010592e <alltraps>

80106213 <vector108>:
.globl vector108
vector108:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $108
80106215:	6a 6c                	push   $0x6c
  jmp alltraps
80106217:	e9 12 f7 ff ff       	jmp    8010592e <alltraps>

8010621c <vector109>:
.globl vector109
vector109:
  pushl $0
8010621c:	6a 00                	push   $0x0
  pushl $109
8010621e:	6a 6d                	push   $0x6d
  jmp alltraps
80106220:	e9 09 f7 ff ff       	jmp    8010592e <alltraps>

80106225 <vector110>:
.globl vector110
vector110:
  pushl $0
80106225:	6a 00                	push   $0x0
  pushl $110
80106227:	6a 6e                	push   $0x6e
  jmp alltraps
80106229:	e9 00 f7 ff ff       	jmp    8010592e <alltraps>

8010622e <vector111>:
.globl vector111
vector111:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $111
80106230:	6a 6f                	push   $0x6f
  jmp alltraps
80106232:	e9 f7 f6 ff ff       	jmp    8010592e <alltraps>

80106237 <vector112>:
.globl vector112
vector112:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $112
80106239:	6a 70                	push   $0x70
  jmp alltraps
8010623b:	e9 ee f6 ff ff       	jmp    8010592e <alltraps>

80106240 <vector113>:
.globl vector113
vector113:
  pushl $0
80106240:	6a 00                	push   $0x0
  pushl $113
80106242:	6a 71                	push   $0x71
  jmp alltraps
80106244:	e9 e5 f6 ff ff       	jmp    8010592e <alltraps>

80106249 <vector114>:
.globl vector114
vector114:
  pushl $0
80106249:	6a 00                	push   $0x0
  pushl $114
8010624b:	6a 72                	push   $0x72
  jmp alltraps
8010624d:	e9 dc f6 ff ff       	jmp    8010592e <alltraps>

80106252 <vector115>:
.globl vector115
vector115:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $115
80106254:	6a 73                	push   $0x73
  jmp alltraps
80106256:	e9 d3 f6 ff ff       	jmp    8010592e <alltraps>

8010625b <vector116>:
.globl vector116
vector116:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $116
8010625d:	6a 74                	push   $0x74
  jmp alltraps
8010625f:	e9 ca f6 ff ff       	jmp    8010592e <alltraps>

80106264 <vector117>:
.globl vector117
vector117:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $117
80106266:	6a 75                	push   $0x75
  jmp alltraps
80106268:	e9 c1 f6 ff ff       	jmp    8010592e <alltraps>

8010626d <vector118>:
.globl vector118
vector118:
  pushl $0
8010626d:	6a 00                	push   $0x0
  pushl $118
8010626f:	6a 76                	push   $0x76
  jmp alltraps
80106271:	e9 b8 f6 ff ff       	jmp    8010592e <alltraps>

80106276 <vector119>:
.globl vector119
vector119:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $119
80106278:	6a 77                	push   $0x77
  jmp alltraps
8010627a:	e9 af f6 ff ff       	jmp    8010592e <alltraps>

8010627f <vector120>:
.globl vector120
vector120:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $120
80106281:	6a 78                	push   $0x78
  jmp alltraps
80106283:	e9 a6 f6 ff ff       	jmp    8010592e <alltraps>

80106288 <vector121>:
.globl vector121
vector121:
  pushl $0
80106288:	6a 00                	push   $0x0
  pushl $121
8010628a:	6a 79                	push   $0x79
  jmp alltraps
8010628c:	e9 9d f6 ff ff       	jmp    8010592e <alltraps>

80106291 <vector122>:
.globl vector122
vector122:
  pushl $0
80106291:	6a 00                	push   $0x0
  pushl $122
80106293:	6a 7a                	push   $0x7a
  jmp alltraps
80106295:	e9 94 f6 ff ff       	jmp    8010592e <alltraps>

8010629a <vector123>:
.globl vector123
vector123:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $123
8010629c:	6a 7b                	push   $0x7b
  jmp alltraps
8010629e:	e9 8b f6 ff ff       	jmp    8010592e <alltraps>

801062a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $124
801062a5:	6a 7c                	push   $0x7c
  jmp alltraps
801062a7:	e9 82 f6 ff ff       	jmp    8010592e <alltraps>

801062ac <vector125>:
.globl vector125
vector125:
  pushl $0
801062ac:	6a 00                	push   $0x0
  pushl $125
801062ae:	6a 7d                	push   $0x7d
  jmp alltraps
801062b0:	e9 79 f6 ff ff       	jmp    8010592e <alltraps>

801062b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801062b5:	6a 00                	push   $0x0
  pushl $126
801062b7:	6a 7e                	push   $0x7e
  jmp alltraps
801062b9:	e9 70 f6 ff ff       	jmp    8010592e <alltraps>

801062be <vector127>:
.globl vector127
vector127:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $127
801062c0:	6a 7f                	push   $0x7f
  jmp alltraps
801062c2:	e9 67 f6 ff ff       	jmp    8010592e <alltraps>

801062c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $128
801062c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801062ce:	e9 5b f6 ff ff       	jmp    8010592e <alltraps>

801062d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $129
801062d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801062da:	e9 4f f6 ff ff       	jmp    8010592e <alltraps>

801062df <vector130>:
.globl vector130
vector130:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $130
801062e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062e6:	e9 43 f6 ff ff       	jmp    8010592e <alltraps>

801062eb <vector131>:
.globl vector131
vector131:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $131
801062ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062f2:	e9 37 f6 ff ff       	jmp    8010592e <alltraps>

801062f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $132
801062f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062fe:	e9 2b f6 ff ff       	jmp    8010592e <alltraps>

80106303 <vector133>:
.globl vector133
vector133:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $133
80106305:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010630a:	e9 1f f6 ff ff       	jmp    8010592e <alltraps>

8010630f <vector134>:
.globl vector134
vector134:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $134
80106311:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106316:	e9 13 f6 ff ff       	jmp    8010592e <alltraps>

8010631b <vector135>:
.globl vector135
vector135:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $135
8010631d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106322:	e9 07 f6 ff ff       	jmp    8010592e <alltraps>

80106327 <vector136>:
.globl vector136
vector136:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $136
80106329:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010632e:	e9 fb f5 ff ff       	jmp    8010592e <alltraps>

80106333 <vector137>:
.globl vector137
vector137:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $137
80106335:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010633a:	e9 ef f5 ff ff       	jmp    8010592e <alltraps>

8010633f <vector138>:
.globl vector138
vector138:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $138
80106341:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106346:	e9 e3 f5 ff ff       	jmp    8010592e <alltraps>

8010634b <vector139>:
.globl vector139
vector139:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $139
8010634d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106352:	e9 d7 f5 ff ff       	jmp    8010592e <alltraps>

80106357 <vector140>:
.globl vector140
vector140:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $140
80106359:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010635e:	e9 cb f5 ff ff       	jmp    8010592e <alltraps>

80106363 <vector141>:
.globl vector141
vector141:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $141
80106365:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010636a:	e9 bf f5 ff ff       	jmp    8010592e <alltraps>

8010636f <vector142>:
.globl vector142
vector142:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $142
80106371:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106376:	e9 b3 f5 ff ff       	jmp    8010592e <alltraps>

8010637b <vector143>:
.globl vector143
vector143:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $143
8010637d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106382:	e9 a7 f5 ff ff       	jmp    8010592e <alltraps>

80106387 <vector144>:
.globl vector144
vector144:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $144
80106389:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010638e:	e9 9b f5 ff ff       	jmp    8010592e <alltraps>

80106393 <vector145>:
.globl vector145
vector145:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $145
80106395:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010639a:	e9 8f f5 ff ff       	jmp    8010592e <alltraps>

8010639f <vector146>:
.globl vector146
vector146:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $146
801063a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801063a6:	e9 83 f5 ff ff       	jmp    8010592e <alltraps>

801063ab <vector147>:
.globl vector147
vector147:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $147
801063ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801063b2:	e9 77 f5 ff ff       	jmp    8010592e <alltraps>

801063b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $148
801063b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801063be:	e9 6b f5 ff ff       	jmp    8010592e <alltraps>

801063c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $149
801063c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801063ca:	e9 5f f5 ff ff       	jmp    8010592e <alltraps>

801063cf <vector150>:
.globl vector150
vector150:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $150
801063d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801063d6:	e9 53 f5 ff ff       	jmp    8010592e <alltraps>

801063db <vector151>:
.globl vector151
vector151:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $151
801063dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063e2:	e9 47 f5 ff ff       	jmp    8010592e <alltraps>

801063e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $152
801063e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063ee:	e9 3b f5 ff ff       	jmp    8010592e <alltraps>

801063f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $153
801063f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063fa:	e9 2f f5 ff ff       	jmp    8010592e <alltraps>

801063ff <vector154>:
.globl vector154
vector154:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $154
80106401:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106406:	e9 23 f5 ff ff       	jmp    8010592e <alltraps>

8010640b <vector155>:
.globl vector155
vector155:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $155
8010640d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106412:	e9 17 f5 ff ff       	jmp    8010592e <alltraps>

80106417 <vector156>:
.globl vector156
vector156:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $156
80106419:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010641e:	e9 0b f5 ff ff       	jmp    8010592e <alltraps>

80106423 <vector157>:
.globl vector157
vector157:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $157
80106425:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010642a:	e9 ff f4 ff ff       	jmp    8010592e <alltraps>

8010642f <vector158>:
.globl vector158
vector158:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $158
80106431:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106436:	e9 f3 f4 ff ff       	jmp    8010592e <alltraps>

8010643b <vector159>:
.globl vector159
vector159:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $159
8010643d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106442:	e9 e7 f4 ff ff       	jmp    8010592e <alltraps>

80106447 <vector160>:
.globl vector160
vector160:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $160
80106449:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010644e:	e9 db f4 ff ff       	jmp    8010592e <alltraps>

80106453 <vector161>:
.globl vector161
vector161:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $161
80106455:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010645a:	e9 cf f4 ff ff       	jmp    8010592e <alltraps>

8010645f <vector162>:
.globl vector162
vector162:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $162
80106461:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106466:	e9 c3 f4 ff ff       	jmp    8010592e <alltraps>

8010646b <vector163>:
.globl vector163
vector163:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $163
8010646d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106472:	e9 b7 f4 ff ff       	jmp    8010592e <alltraps>

80106477 <vector164>:
.globl vector164
vector164:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $164
80106479:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010647e:	e9 ab f4 ff ff       	jmp    8010592e <alltraps>

80106483 <vector165>:
.globl vector165
vector165:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $165
80106485:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010648a:	e9 9f f4 ff ff       	jmp    8010592e <alltraps>

8010648f <vector166>:
.globl vector166
vector166:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $166
80106491:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106496:	e9 93 f4 ff ff       	jmp    8010592e <alltraps>

8010649b <vector167>:
.globl vector167
vector167:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $167
8010649d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801064a2:	e9 87 f4 ff ff       	jmp    8010592e <alltraps>

801064a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $168
801064a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801064ae:	e9 7b f4 ff ff       	jmp    8010592e <alltraps>

801064b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $169
801064b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801064ba:	e9 6f f4 ff ff       	jmp    8010592e <alltraps>

801064bf <vector170>:
.globl vector170
vector170:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $170
801064c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801064c6:	e9 63 f4 ff ff       	jmp    8010592e <alltraps>

801064cb <vector171>:
.globl vector171
vector171:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $171
801064cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801064d2:	e9 57 f4 ff ff       	jmp    8010592e <alltraps>

801064d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $172
801064d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064de:	e9 4b f4 ff ff       	jmp    8010592e <alltraps>

801064e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $173
801064e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064ea:	e9 3f f4 ff ff       	jmp    8010592e <alltraps>

801064ef <vector174>:
.globl vector174
vector174:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $174
801064f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064f6:	e9 33 f4 ff ff       	jmp    8010592e <alltraps>

801064fb <vector175>:
.globl vector175
vector175:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $175
801064fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106502:	e9 27 f4 ff ff       	jmp    8010592e <alltraps>

80106507 <vector176>:
.globl vector176
vector176:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $176
80106509:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010650e:	e9 1b f4 ff ff       	jmp    8010592e <alltraps>

80106513 <vector177>:
.globl vector177
vector177:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $177
80106515:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010651a:	e9 0f f4 ff ff       	jmp    8010592e <alltraps>

8010651f <vector178>:
.globl vector178
vector178:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $178
80106521:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106526:	e9 03 f4 ff ff       	jmp    8010592e <alltraps>

8010652b <vector179>:
.globl vector179
vector179:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $179
8010652d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106532:	e9 f7 f3 ff ff       	jmp    8010592e <alltraps>

80106537 <vector180>:
.globl vector180
vector180:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $180
80106539:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010653e:	e9 eb f3 ff ff       	jmp    8010592e <alltraps>

80106543 <vector181>:
.globl vector181
vector181:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $181
80106545:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010654a:	e9 df f3 ff ff       	jmp    8010592e <alltraps>

8010654f <vector182>:
.globl vector182
vector182:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $182
80106551:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106556:	e9 d3 f3 ff ff       	jmp    8010592e <alltraps>

8010655b <vector183>:
.globl vector183
vector183:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $183
8010655d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106562:	e9 c7 f3 ff ff       	jmp    8010592e <alltraps>

80106567 <vector184>:
.globl vector184
vector184:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $184
80106569:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010656e:	e9 bb f3 ff ff       	jmp    8010592e <alltraps>

80106573 <vector185>:
.globl vector185
vector185:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $185
80106575:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010657a:	e9 af f3 ff ff       	jmp    8010592e <alltraps>

8010657f <vector186>:
.globl vector186
vector186:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $186
80106581:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106586:	e9 a3 f3 ff ff       	jmp    8010592e <alltraps>

8010658b <vector187>:
.globl vector187
vector187:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $187
8010658d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106592:	e9 97 f3 ff ff       	jmp    8010592e <alltraps>

80106597 <vector188>:
.globl vector188
vector188:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $188
80106599:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010659e:	e9 8b f3 ff ff       	jmp    8010592e <alltraps>

801065a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $189
801065a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801065aa:	e9 7f f3 ff ff       	jmp    8010592e <alltraps>

801065af <vector190>:
.globl vector190
vector190:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $190
801065b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801065b6:	e9 73 f3 ff ff       	jmp    8010592e <alltraps>

801065bb <vector191>:
.globl vector191
vector191:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $191
801065bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801065c2:	e9 67 f3 ff ff       	jmp    8010592e <alltraps>

801065c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $192
801065c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801065ce:	e9 5b f3 ff ff       	jmp    8010592e <alltraps>

801065d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $193
801065d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801065da:	e9 4f f3 ff ff       	jmp    8010592e <alltraps>

801065df <vector194>:
.globl vector194
vector194:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $194
801065e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065e6:	e9 43 f3 ff ff       	jmp    8010592e <alltraps>

801065eb <vector195>:
.globl vector195
vector195:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $195
801065ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065f2:	e9 37 f3 ff ff       	jmp    8010592e <alltraps>

801065f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $196
801065f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065fe:	e9 2b f3 ff ff       	jmp    8010592e <alltraps>

80106603 <vector197>:
.globl vector197
vector197:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $197
80106605:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010660a:	e9 1f f3 ff ff       	jmp    8010592e <alltraps>

8010660f <vector198>:
.globl vector198
vector198:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $198
80106611:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106616:	e9 13 f3 ff ff       	jmp    8010592e <alltraps>

8010661b <vector199>:
.globl vector199
vector199:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $199
8010661d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106622:	e9 07 f3 ff ff       	jmp    8010592e <alltraps>

80106627 <vector200>:
.globl vector200
vector200:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $200
80106629:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010662e:	e9 fb f2 ff ff       	jmp    8010592e <alltraps>

80106633 <vector201>:
.globl vector201
vector201:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $201
80106635:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010663a:	e9 ef f2 ff ff       	jmp    8010592e <alltraps>

8010663f <vector202>:
.globl vector202
vector202:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $202
80106641:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106646:	e9 e3 f2 ff ff       	jmp    8010592e <alltraps>

8010664b <vector203>:
.globl vector203
vector203:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $203
8010664d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106652:	e9 d7 f2 ff ff       	jmp    8010592e <alltraps>

80106657 <vector204>:
.globl vector204
vector204:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $204
80106659:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010665e:	e9 cb f2 ff ff       	jmp    8010592e <alltraps>

80106663 <vector205>:
.globl vector205
vector205:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $205
80106665:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010666a:	e9 bf f2 ff ff       	jmp    8010592e <alltraps>

8010666f <vector206>:
.globl vector206
vector206:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $206
80106671:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106676:	e9 b3 f2 ff ff       	jmp    8010592e <alltraps>

8010667b <vector207>:
.globl vector207
vector207:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $207
8010667d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106682:	e9 a7 f2 ff ff       	jmp    8010592e <alltraps>

80106687 <vector208>:
.globl vector208
vector208:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $208
80106689:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010668e:	e9 9b f2 ff ff       	jmp    8010592e <alltraps>

80106693 <vector209>:
.globl vector209
vector209:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $209
80106695:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010669a:	e9 8f f2 ff ff       	jmp    8010592e <alltraps>

8010669f <vector210>:
.globl vector210
vector210:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $210
801066a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801066a6:	e9 83 f2 ff ff       	jmp    8010592e <alltraps>

801066ab <vector211>:
.globl vector211
vector211:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $211
801066ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801066b2:	e9 77 f2 ff ff       	jmp    8010592e <alltraps>

801066b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $212
801066b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801066be:	e9 6b f2 ff ff       	jmp    8010592e <alltraps>

801066c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $213
801066c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801066ca:	e9 5f f2 ff ff       	jmp    8010592e <alltraps>

801066cf <vector214>:
.globl vector214
vector214:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $214
801066d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801066d6:	e9 53 f2 ff ff       	jmp    8010592e <alltraps>

801066db <vector215>:
.globl vector215
vector215:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $215
801066dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066e2:	e9 47 f2 ff ff       	jmp    8010592e <alltraps>

801066e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $216
801066e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066ee:	e9 3b f2 ff ff       	jmp    8010592e <alltraps>

801066f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $217
801066f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066fa:	e9 2f f2 ff ff       	jmp    8010592e <alltraps>

801066ff <vector218>:
.globl vector218
vector218:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $218
80106701:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106706:	e9 23 f2 ff ff       	jmp    8010592e <alltraps>

8010670b <vector219>:
.globl vector219
vector219:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $219
8010670d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106712:	e9 17 f2 ff ff       	jmp    8010592e <alltraps>

80106717 <vector220>:
.globl vector220
vector220:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $220
80106719:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010671e:	e9 0b f2 ff ff       	jmp    8010592e <alltraps>

80106723 <vector221>:
.globl vector221
vector221:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $221
80106725:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010672a:	e9 ff f1 ff ff       	jmp    8010592e <alltraps>

8010672f <vector222>:
.globl vector222
vector222:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $222
80106731:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106736:	e9 f3 f1 ff ff       	jmp    8010592e <alltraps>

8010673b <vector223>:
.globl vector223
vector223:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $223
8010673d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106742:	e9 e7 f1 ff ff       	jmp    8010592e <alltraps>

80106747 <vector224>:
.globl vector224
vector224:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $224
80106749:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010674e:	e9 db f1 ff ff       	jmp    8010592e <alltraps>

80106753 <vector225>:
.globl vector225
vector225:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $225
80106755:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010675a:	e9 cf f1 ff ff       	jmp    8010592e <alltraps>

8010675f <vector226>:
.globl vector226
vector226:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $226
80106761:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106766:	e9 c3 f1 ff ff       	jmp    8010592e <alltraps>

8010676b <vector227>:
.globl vector227
vector227:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $227
8010676d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106772:	e9 b7 f1 ff ff       	jmp    8010592e <alltraps>

80106777 <vector228>:
.globl vector228
vector228:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $228
80106779:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010677e:	e9 ab f1 ff ff       	jmp    8010592e <alltraps>

80106783 <vector229>:
.globl vector229
vector229:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $229
80106785:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010678a:	e9 9f f1 ff ff       	jmp    8010592e <alltraps>

8010678f <vector230>:
.globl vector230
vector230:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $230
80106791:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106796:	e9 93 f1 ff ff       	jmp    8010592e <alltraps>

8010679b <vector231>:
.globl vector231
vector231:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $231
8010679d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801067a2:	e9 87 f1 ff ff       	jmp    8010592e <alltraps>

801067a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $232
801067a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801067ae:	e9 7b f1 ff ff       	jmp    8010592e <alltraps>

801067b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $233
801067b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801067ba:	e9 6f f1 ff ff       	jmp    8010592e <alltraps>

801067bf <vector234>:
.globl vector234
vector234:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $234
801067c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801067c6:	e9 63 f1 ff ff       	jmp    8010592e <alltraps>

801067cb <vector235>:
.globl vector235
vector235:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $235
801067cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801067d2:	e9 57 f1 ff ff       	jmp    8010592e <alltraps>

801067d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $236
801067d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067de:	e9 4b f1 ff ff       	jmp    8010592e <alltraps>

801067e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $237
801067e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067ea:	e9 3f f1 ff ff       	jmp    8010592e <alltraps>

801067ef <vector238>:
.globl vector238
vector238:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $238
801067f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067f6:	e9 33 f1 ff ff       	jmp    8010592e <alltraps>

801067fb <vector239>:
.globl vector239
vector239:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $239
801067fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106802:	e9 27 f1 ff ff       	jmp    8010592e <alltraps>

80106807 <vector240>:
.globl vector240
vector240:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $240
80106809:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010680e:	e9 1b f1 ff ff       	jmp    8010592e <alltraps>

80106813 <vector241>:
.globl vector241
vector241:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $241
80106815:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010681a:	e9 0f f1 ff ff       	jmp    8010592e <alltraps>

8010681f <vector242>:
.globl vector242
vector242:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $242
80106821:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106826:	e9 03 f1 ff ff       	jmp    8010592e <alltraps>

8010682b <vector243>:
.globl vector243
vector243:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $243
8010682d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106832:	e9 f7 f0 ff ff       	jmp    8010592e <alltraps>

80106837 <vector244>:
.globl vector244
vector244:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $244
80106839:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010683e:	e9 eb f0 ff ff       	jmp    8010592e <alltraps>

80106843 <vector245>:
.globl vector245
vector245:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $245
80106845:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010684a:	e9 df f0 ff ff       	jmp    8010592e <alltraps>

8010684f <vector246>:
.globl vector246
vector246:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $246
80106851:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106856:	e9 d3 f0 ff ff       	jmp    8010592e <alltraps>

8010685b <vector247>:
.globl vector247
vector247:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $247
8010685d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106862:	e9 c7 f0 ff ff       	jmp    8010592e <alltraps>

80106867 <vector248>:
.globl vector248
vector248:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $248
80106869:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010686e:	e9 bb f0 ff ff       	jmp    8010592e <alltraps>

80106873 <vector249>:
.globl vector249
vector249:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $249
80106875:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010687a:	e9 af f0 ff ff       	jmp    8010592e <alltraps>

8010687f <vector250>:
.globl vector250
vector250:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $250
80106881:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106886:	e9 a3 f0 ff ff       	jmp    8010592e <alltraps>

8010688b <vector251>:
.globl vector251
vector251:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $251
8010688d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106892:	e9 97 f0 ff ff       	jmp    8010592e <alltraps>

80106897 <vector252>:
.globl vector252
vector252:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $252
80106899:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010689e:	e9 8b f0 ff ff       	jmp    8010592e <alltraps>

801068a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $253
801068a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801068aa:	e9 7f f0 ff ff       	jmp    8010592e <alltraps>

801068af <vector254>:
.globl vector254
vector254:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $254
801068b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801068b6:	e9 73 f0 ff ff       	jmp    8010592e <alltraps>

801068bb <vector255>:
.globl vector255
vector255:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $255
801068bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801068c2:	e9 67 f0 ff ff       	jmp    8010592e <alltraps>
801068c7:	66 90                	xchg   %ax,%ax
801068c9:	66 90                	xchg   %ax,%ax
801068cb:	66 90                	xchg   %ax,%ax
801068cd:	66 90                	xchg   %ax,%ax
801068cf:	90                   	nop

801068d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	53                   	push   %ebx
801068d6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801068d8:	c1 ea 16             	shr    $0x16,%edx
801068db:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801068de:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801068e1:	8b 07                	mov    (%edi),%eax
801068e3:	a8 01                	test   $0x1,%al
801068e5:	74 29                	je     80106910 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068ec:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801068f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801068f5:	c1 eb 0a             	shr    $0xa,%ebx
801068f8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801068fe:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106901:	5b                   	pop    %ebx
80106902:	5e                   	pop    %esi
80106903:	5f                   	pop    %edi
80106904:	5d                   	pop    %ebp
80106905:	c3                   	ret    
80106906:	8d 76 00             	lea    0x0(%esi),%esi
80106909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106910:	85 c9                	test   %ecx,%ecx
80106912:	74 2c                	je     80106940 <walkpgdir+0x70>
80106914:	e8 87 bb ff ff       	call   801024a0 <kalloc>
80106919:	85 c0                	test   %eax,%eax
8010691b:	89 c6                	mov    %eax,%esi
8010691d:	74 21                	je     80106940 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010691f:	83 ec 04             	sub    $0x4,%esp
80106922:	68 00 10 00 00       	push   $0x1000
80106927:	6a 00                	push   $0x0
80106929:	50                   	push   %eax
8010692a:	e8 61 dd ff ff       	call   80104690 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010692f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106935:	83 c4 10             	add    $0x10,%esp
80106938:	83 c8 07             	or     $0x7,%eax
8010693b:	89 07                	mov    %eax,(%edi)
8010693d:	eb b3                	jmp    801068f2 <walkpgdir+0x22>
8010693f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106940:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106943:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106945:	5b                   	pop    %ebx
80106946:	5e                   	pop    %esi
80106947:	5f                   	pop    %edi
80106948:	5d                   	pop    %ebp
80106949:	c3                   	ret    
8010694a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106950 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	57                   	push   %edi
80106954:	56                   	push   %esi
80106955:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106956:	89 d3                	mov    %edx,%ebx
80106958:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010695e:	83 ec 1c             	sub    $0x1c,%esp
80106961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106964:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106968:	8b 7d 08             	mov    0x8(%ebp),%edi
8010696b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106970:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106973:	8b 45 0c             	mov    0xc(%ebp),%eax
80106976:	29 df                	sub    %ebx,%edi
80106978:	83 c8 01             	or     $0x1,%eax
8010697b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010697e:	eb 15                	jmp    80106995 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106980:	f6 00 01             	testb  $0x1,(%eax)
80106983:	75 45                	jne    801069ca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106985:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106988:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010698b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010698d:	74 31                	je     801069c0 <mappages+0x70>
      break;
    a += PGSIZE;
8010698f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106998:	b9 01 00 00 00       	mov    $0x1,%ecx
8010699d:	89 da                	mov    %ebx,%edx
8010699f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801069a2:	e8 29 ff ff ff       	call   801068d0 <walkpgdir>
801069a7:	85 c0                	test   %eax,%eax
801069a9:	75 d5                	jne    80106980 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801069ab:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801069ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801069b3:	5b                   	pop    %ebx
801069b4:	5e                   	pop    %esi
801069b5:	5f                   	pop    %edi
801069b6:	5d                   	pop    %ebp
801069b7:	c3                   	ret    
801069b8:	90                   	nop
801069b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801069c3:	31 c0                	xor    %eax,%eax
}
801069c5:	5b                   	pop    %ebx
801069c6:	5e                   	pop    %esi
801069c7:	5f                   	pop    %edi
801069c8:	5d                   	pop    %ebp
801069c9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801069ca:	83 ec 0c             	sub    $0xc,%esp
801069cd:	68 b4 7a 10 80       	push   $0x80107ab4
801069d2:	e8 99 99 ff ff       	call   80100370 <panic>
801069d7:	89 f6                	mov    %esi,%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069e0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	57                   	push   %edi
801069e4:	56                   	push   %esi
801069e5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069e6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069ec:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069f4:	83 ec 1c             	sub    $0x1c,%esp
801069f7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801069fa:	39 d3                	cmp    %edx,%ebx
801069fc:	73 60                	jae    80106a5e <deallocuvm.part.0+0x7e>
801069fe:	89 d6                	mov    %edx,%esi
80106a00:	eb 3d                	jmp    80106a3f <deallocuvm.part.0+0x5f>
80106a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106a08:	8b 10                	mov    (%eax),%edx
80106a0a:	f6 c2 01             	test   $0x1,%dl
80106a0d:	74 26                	je     80106a35 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106a0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a15:	74 52                	je     80106a69 <deallocuvm.part.0+0x89>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106a17:	83 ec 0c             	sub    $0xc,%esp
80106a1a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a23:	52                   	push   %edx
80106a24:	e8 c7 b8 ff ff       	call   801022f0 <kfree>
      *pte = 0;
80106a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a2c:	83 c4 10             	add    $0x10,%esp
80106a2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a3b:	39 f3                	cmp    %esi,%ebx
80106a3d:	73 1f                	jae    80106a5e <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a3f:	31 c9                	xor    %ecx,%ecx
80106a41:	89 da                	mov    %ebx,%edx
80106a43:	89 f8                	mov    %edi,%eax
80106a45:	e8 86 fe ff ff       	call   801068d0 <walkpgdir>
    if(!pte)
80106a4a:	85 c0                	test   %eax,%eax
80106a4c:	75 ba                	jne    80106a08 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
80106a4e:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a54:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a5a:	39 f3                	cmp    %esi,%ebx
80106a5c:	72 e1                	jb     80106a3f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a64:	5b                   	pop    %ebx
80106a65:	5e                   	pop    %esi
80106a66:	5f                   	pop    %edi
80106a67:	5d                   	pop    %ebp
80106a68:	c3                   	ret    
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106a69:	83 ec 0c             	sub    $0xc,%esp
80106a6c:	68 72 74 10 80       	push   $0x80107472
80106a71:	e8 fa 98 ff ff       	call   80100370 <panic>
80106a76:	8d 76 00             	lea    0x0(%esi),%esi
80106a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a80 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	53                   	push   %ebx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a84:	31 db                	xor    %ebx,%ebx

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106a86:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106a89:	e8 72 bc ff ff       	call   80102700 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a8e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106a94:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106a99:	8d 90 a0 27 11 80    	lea    -0x7feed860(%eax),%edx
80106a9f:	c6 80 1d 28 11 80 9a 	movb   $0x9a,-0x7feed7e3(%eax)
80106aa6:	c6 80 1e 28 11 80 cf 	movb   $0xcf,-0x7feed7e2(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106aad:	c6 80 25 28 11 80 92 	movb   $0x92,-0x7feed7db(%eax)
80106ab4:	c6 80 26 28 11 80 cf 	movb   $0xcf,-0x7feed7da(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106abb:	66 89 4a 78          	mov    %cx,0x78(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106abf:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ac4:	66 89 5a 7a          	mov    %bx,0x7a(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ac8:	66 89 8a 80 00 00 00 	mov    %cx,0x80(%edx)
80106acf:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ad1:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ad6:	66 89 9a 82 00 00 00 	mov    %bx,0x82(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106add:	66 89 8a 90 00 00 00 	mov    %cx,0x90(%edx)
80106ae4:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ae6:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106aeb:	66 89 9a 92 00 00 00 	mov    %bx,0x92(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106af2:	31 db                	xor    %ebx,%ebx
80106af4:	66 89 8a 98 00 00 00 	mov    %cx,0x98(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106afb:	8d 88 54 28 11 80    	lea    -0x7feed7ac(%eax),%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b01:	66 89 9a 9a 00 00 00 	mov    %bx,0x9a(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106b08:	31 db                	xor    %ebx,%ebx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b0a:	c6 80 35 28 11 80 fa 	movb   $0xfa,-0x7feed7cb(%eax)
80106b11:	c6 80 36 28 11 80 cf 	movb   $0xcf,-0x7feed7ca(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106b18:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
80106b1f:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
80106b26:	89 cb                	mov    %ecx,%ebx
80106b28:	c1 e9 18             	shr    $0x18,%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b2b:	c6 80 3d 28 11 80 f2 	movb   $0xf2,-0x7feed7c3(%eax)
80106b32:	c6 80 3e 28 11 80 cf 	movb   $0xcf,-0x7feed7c2(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106b39:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
80106b3f:	c6 80 2d 28 11 80 92 	movb   $0x92,-0x7feed7d3(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106b46:	b9 37 00 00 00       	mov    $0x37,%ecx
80106b4b:	c6 80 2e 28 11 80 c0 	movb   $0xc0,-0x7feed7d2(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80106b52:	05 10 28 11 80       	add    $0x80112810,%eax
80106b57:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106b5b:	c1 eb 10             	shr    $0x10,%ebx
  pd[1] = (uint)p;
80106b5e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b62:	c1 e8 10             	shr    $0x10,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b65:	c6 42 7c 00          	movb   $0x0,0x7c(%edx)
80106b69:	c6 42 7f 00          	movb   $0x0,0x7f(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b6d:	c6 82 84 00 00 00 00 	movb   $0x0,0x84(%edx)
80106b74:	c6 82 87 00 00 00 00 	movb   $0x0,0x87(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b7b:	c6 82 94 00 00 00 00 	movb   $0x0,0x94(%edx)
80106b82:	c6 82 97 00 00 00 00 	movb   $0x0,0x97(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b89:	c6 82 9c 00 00 00 00 	movb   $0x0,0x9c(%edx)
80106b90:	c6 82 9f 00 00 00 00 	movb   $0x0,0x9f(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106b97:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
80106b9d:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106ba1:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ba4:	0f 01 10             	lgdtl  (%eax)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106ba7:	b8 18 00 00 00       	mov    $0x18,%eax
80106bac:	8e e8                	mov    %eax,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106bae:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106bb5:	00 00 00 00 

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106bb9:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}
80106bc0:	83 c4 14             	add    $0x14,%esp
80106bc3:	5b                   	pop    %ebx
80106bc4:	5d                   	pop    %ebp
80106bc5:	c3                   	ret    
80106bc6:	8d 76 00             	lea    0x0(%esi),%esi
80106bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bd0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	56                   	push   %esi
80106bd4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106bd5:	e8 c6 b8 ff ff       	call   801024a0 <kalloc>
80106bda:	85 c0                	test   %eax,%eax
80106bdc:	74 52                	je     80106c30 <setupkvm+0x60>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106bde:	83 ec 04             	sub    $0x4,%esp
80106be1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106be3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106be8:	68 00 10 00 00       	push   $0x1000
80106bed:	6a 00                	push   $0x0
80106bef:	50                   	push   %eax
80106bf0:	e8 9b da ff ff       	call   80104690 <memset>
80106bf5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106bf8:	8b 43 04             	mov    0x4(%ebx),%eax
80106bfb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106bfe:	83 ec 08             	sub    $0x8,%esp
80106c01:	8b 13                	mov    (%ebx),%edx
80106c03:	ff 73 0c             	pushl  0xc(%ebx)
80106c06:	50                   	push   %eax
80106c07:	29 c1                	sub    %eax,%ecx
80106c09:	89 f0                	mov    %esi,%eax
80106c0b:	e8 40 fd ff ff       	call   80106950 <mappages>
80106c10:	83 c4 10             	add    $0x10,%esp
80106c13:	85 c0                	test   %eax,%eax
80106c15:	78 19                	js     80106c30 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c17:	83 c3 10             	add    $0x10,%ebx
80106c1a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106c20:	75 d6                	jne    80106bf8 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c25:	89 f0                	mov    %esi,%eax
80106c27:	5b                   	pop    %ebx
80106c28:	5e                   	pop    %esi
80106c29:	5d                   	pop    %ebp
80106c2a:	c3                   	ret    
80106c2b:	90                   	nop
80106c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c30:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106c33:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106c35:	5b                   	pop    %ebx
80106c36:	5e                   	pop    %esi
80106c37:	5d                   	pop    %ebp
80106c38:	c3                   	ret    
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c40 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106c46:	e8 85 ff ff ff       	call   80106bd0 <setupkvm>
80106c4b:	a3 24 5c 11 80       	mov    %eax,0x80115c24
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c50:	05 00 00 00 80       	add    $0x80000000,%eax
80106c55:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106c58:	c9                   	leave  
80106c59:	c3                   	ret    
80106c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c60 <switchkvm>:
80106c60:	a1 24 5c 11 80       	mov    0x80115c24,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106c65:	55                   	push   %ebp
80106c66:	89 e5                	mov    %esp,%ebp
80106c68:	05 00 00 00 80       	add    $0x80000000,%eax
80106c6d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106c70:	5d                   	pop    %ebp
80106c71:	c3                   	ret    
80106c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c80 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	53                   	push   %ebx
80106c84:	83 ec 04             	sub    $0x4,%esp
80106c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106c8a:	e8 31 d9 ff ff       	call   801045c0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106c8f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c95:	b9 67 00 00 00       	mov    $0x67,%ecx
80106c9a:	8d 50 08             	lea    0x8(%eax),%edx
80106c9d:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106ca4:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106cab:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106cb2:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106cb9:	89 d1                	mov    %edx,%ecx
80106cbb:	c1 ea 18             	shr    $0x18,%edx
80106cbe:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106cc4:	ba 10 00 00 00       	mov    $0x10,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106cc9:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106ccc:	66 89 50 10          	mov    %dx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106cd0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106cd7:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106cdd:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106ce2:	8b 52 24             	mov    0x24(%edx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106ce5:	66 89 48 6e          	mov    %cx,0x6e(%eax)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106ce9:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106cef:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106cf2:	b8 30 00 00 00       	mov    $0x30,%eax
80106cf7:	0f 00 d8             	ltr    %ax
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
80106cfa:	8b 43 20             	mov    0x20(%ebx),%eax
80106cfd:	85 c0                	test   %eax,%eax
80106cff:	74 11                	je     80106d12 <switchuvm+0x92>
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d01:	05 00 00 00 80       	add    $0x80000000,%eax
80106d06:	0f 22 d8             	mov    %eax,%cr3
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106d09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d0c:	c9                   	leave  
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106d0d:	e9 de d8 ff ff       	jmp    801045f0 <popcli>
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106d12:	83 ec 0c             	sub    $0xc,%esp
80106d15:	68 ba 7a 10 80       	push   $0x80107aba
80106d1a:	e8 51 96 ff ff       	call   80100370 <panic>
80106d1f:	90                   	nop

80106d20 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 1c             	sub    $0x1c,%esp
80106d29:	8b 75 10             	mov    0x10(%ebp),%esi
80106d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106d32:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106d38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106d3b:	77 49                	ja     80106d86 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106d3d:	e8 5e b7 ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106d42:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106d45:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d47:	68 00 10 00 00       	push   $0x1000
80106d4c:	6a 00                	push   $0x0
80106d4e:	50                   	push   %eax
80106d4f:	e8 3c d9 ff ff       	call   80104690 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d54:	58                   	pop    %eax
80106d55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d5b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d60:	5a                   	pop    %edx
80106d61:	6a 06                	push   $0x6
80106d63:	50                   	push   %eax
80106d64:	31 d2                	xor    %edx,%edx
80106d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d69:	e8 e2 fb ff ff       	call   80106950 <mappages>
  memmove(mem, init, sz);
80106d6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106d71:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106d74:	83 c4 10             	add    $0x10,%esp
80106d77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d7d:	5b                   	pop    %ebx
80106d7e:	5e                   	pop    %esi
80106d7f:	5f                   	pop    %edi
80106d80:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106d81:	e9 ba d9 ff ff       	jmp    80104740 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106d86:	83 ec 0c             	sub    $0xc,%esp
80106d89:	68 ce 7a 10 80       	push   $0x80107ace
80106d8e:	e8 dd 95 ff ff       	call   80100370 <panic>
80106d93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106da0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106da9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106db0:	0f 85 91 00 00 00    	jne    80106e47 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106db6:	8b 75 18             	mov    0x18(%ebp),%esi
80106db9:	31 db                	xor    %ebx,%ebx
80106dbb:	85 f6                	test   %esi,%esi
80106dbd:	75 1a                	jne    80106dd9 <loaduvm+0x39>
80106dbf:	eb 6f                	jmp    80106e30 <loaduvm+0x90>
80106dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106dd4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106dd7:	76 57                	jbe    80106e30 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddf:	31 c9                	xor    %ecx,%ecx
80106de1:	01 da                	add    %ebx,%edx
80106de3:	e8 e8 fa ff ff       	call   801068d0 <walkpgdir>
80106de8:	85 c0                	test   %eax,%eax
80106dea:	74 4e                	je     80106e3a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106dec:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dee:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106df1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106df6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106dfb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e01:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e04:	01 d9                	add    %ebx,%ecx
80106e06:	05 00 00 00 80       	add    $0x80000000,%eax
80106e0b:	57                   	push   %edi
80106e0c:	51                   	push   %ecx
80106e0d:	50                   	push   %eax
80106e0e:	ff 75 10             	pushl  0x10(%ebp)
80106e11:	e8 1a ab ff ff       	call   80101930 <readi>
80106e16:	83 c4 10             	add    $0x10,%esp
80106e19:	39 c7                	cmp    %eax,%edi
80106e1b:	74 ab                	je     80106dc8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret    
80106e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106e33:	31 c0                	xor    %eax,%eax
}
80106e35:	5b                   	pop    %ebx
80106e36:	5e                   	pop    %esi
80106e37:	5f                   	pop    %edi
80106e38:	5d                   	pop    %ebp
80106e39:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106e3a:	83 ec 0c             	sub    $0xc,%esp
80106e3d:	68 e8 7a 10 80       	push   $0x80107ae8
80106e42:	e8 29 95 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106e47:	83 ec 0c             	sub    $0xc,%esp
80106e4a:	68 8c 7b 10 80       	push   $0x80107b8c
80106e4f:	e8 1c 95 ff ff       	call   80100370 <panic>
80106e54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e60 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	57                   	push   %edi
80106e64:	56                   	push   %esi
80106e65:	53                   	push   %ebx
80106e66:	83 ec 0c             	sub    $0xc,%esp
80106e69:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106e6c:	85 ff                	test   %edi,%edi
80106e6e:	0f 88 ca 00 00 00    	js     80106f3e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106e74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106e7a:	0f 82 82 00 00 00    	jb     80106f02 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106e80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106e8c:	39 df                	cmp    %ebx,%edi
80106e8e:	77 43                	ja     80106ed3 <allocuvm+0x73>
80106e90:	e9 bb 00 00 00       	jmp    80106f50 <allocuvm+0xf0>
80106e95:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106e98:	83 ec 04             	sub    $0x4,%esp
80106e9b:	68 00 10 00 00       	push   $0x1000
80106ea0:	6a 00                	push   $0x0
80106ea2:	50                   	push   %eax
80106ea3:	e8 e8 d7 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ea8:	58                   	pop    %eax
80106ea9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106eaf:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eb4:	5a                   	pop    %edx
80106eb5:	6a 06                	push   $0x6
80106eb7:	50                   	push   %eax
80106eb8:	89 da                	mov    %ebx,%edx
80106eba:	8b 45 08             	mov    0x8(%ebp),%eax
80106ebd:	e8 8e fa ff ff       	call   80106950 <mappages>
80106ec2:	83 c4 10             	add    $0x10,%esp
80106ec5:	85 c0                	test   %eax,%eax
80106ec7:	78 47                	js     80106f10 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106ec9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ecf:	39 df                	cmp    %ebx,%edi
80106ed1:	76 7d                	jbe    80106f50 <allocuvm+0xf0>
    mem = kalloc();
80106ed3:	e8 c8 b5 ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
80106ed8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106eda:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106edc:	75 ba                	jne    80106e98 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106ede:	83 ec 0c             	sub    $0xc,%esp
80106ee1:	68 06 7b 10 80       	push   $0x80107b06
80106ee6:	e8 75 97 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106eeb:	83 c4 10             	add    $0x10,%esp
80106eee:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ef1:	76 4b                	jbe    80106f3e <allocuvm+0xde>
80106ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef9:	89 fa                	mov    %edi,%edx
80106efb:	e8 e0 fa ff ff       	call   801069e0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106f00:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106f10:	83 ec 0c             	sub    $0xc,%esp
80106f13:	68 1e 7b 10 80       	push   $0x80107b1e
80106f18:	e8 43 97 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106f1d:	83 c4 10             	add    $0x10,%esp
80106f20:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f23:	76 0d                	jbe    80106f32 <allocuvm+0xd2>
80106f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f28:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2b:	89 fa                	mov    %edi,%edx
80106f2d:	e8 ae fa ff ff       	call   801069e0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106f32:	83 ec 0c             	sub    $0xc,%esp
80106f35:	56                   	push   %esi
80106f36:	e8 b5 b3 ff ff       	call   801022f0 <kfree>
      return 0;
80106f3b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106f41:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106f43:	5b                   	pop    %ebx
80106f44:	5e                   	pop    %esi
80106f45:	5f                   	pop    %edi
80106f46:	5d                   	pop    %ebp
80106f47:	c3                   	ret    
80106f48:	90                   	nop
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106f53:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5f                   	pop    %edi
80106f58:	5d                   	pop    %ebp
80106f59:	c3                   	ret    
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f60 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f66:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f69:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106f6c:	39 d1                	cmp    %edx,%ecx
80106f6e:	73 10                	jae    80106f80 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106f70:	5d                   	pop    %ebp
80106f71:	e9 6a fa ff ff       	jmp    801069e0 <deallocuvm.part.0>
80106f76:	8d 76 00             	lea    0x0(%esi),%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106f80:	89 d0                	mov    %edx,%eax
80106f82:	5d                   	pop    %ebp
80106f83:	c3                   	ret    
80106f84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 0c             	sub    $0xc,%esp
80106f99:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f9c:	85 f6                	test   %esi,%esi
80106f9e:	74 59                	je     80106ff9 <freevm+0x69>
80106fa0:	31 c9                	xor    %ecx,%ecx
80106fa2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106fa7:	89 f0                	mov    %esi,%eax
80106fa9:	e8 32 fa ff ff       	call   801069e0 <deallocuvm.part.0>
80106fae:	89 f3                	mov    %esi,%ebx
80106fb0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106fb6:	eb 0f                	jmp    80106fc7 <freevm+0x37>
80106fb8:	90                   	nop
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fc0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fc3:	39 fb                	cmp    %edi,%ebx
80106fc5:	74 23                	je     80106fea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106fc7:	8b 03                	mov    (%ebx),%eax
80106fc9:	a8 01                	test   $0x1,%al
80106fcb:	74 f3                	je     80106fc0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106fcd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fd2:	83 ec 0c             	sub    $0xc,%esp
80106fd5:	83 c3 04             	add    $0x4,%ebx
80106fd8:	05 00 00 00 80       	add    $0x80000000,%eax
80106fdd:	50                   	push   %eax
80106fde:	e8 0d b3 ff ff       	call   801022f0 <kfree>
80106fe3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fe6:	39 fb                	cmp    %edi,%ebx
80106fe8:	75 dd                	jne    80106fc7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106fea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ff0:	5b                   	pop    %ebx
80106ff1:	5e                   	pop    %esi
80106ff2:	5f                   	pop    %edi
80106ff3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106ff4:	e9 f7 b2 ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106ff9:	83 ec 0c             	sub    $0xc,%esp
80106ffc:	68 3a 7b 10 80       	push   $0x80107b3a
80107001:	e8 6a 93 ff ff       	call   80100370 <panic>
80107006:	8d 76 00             	lea    0x0(%esi),%esi
80107009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107010 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107010:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107011:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107013:	89 e5                	mov    %esp,%ebp
80107015:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107018:	8b 55 0c             	mov    0xc(%ebp),%edx
8010701b:	8b 45 08             	mov    0x8(%ebp),%eax
8010701e:	e8 ad f8 ff ff       	call   801068d0 <walkpgdir>
  if(pte == 0)
80107023:	85 c0                	test   %eax,%eax
80107025:	74 05                	je     8010702c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107027:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010702a:	c9                   	leave  
8010702b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010702c:	83 ec 0c             	sub    $0xc,%esp
8010702f:	68 4b 7b 10 80       	push   $0x80107b4b
80107034:	e8 37 93 ff ff       	call   80100370 <panic>
80107039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107040 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107049:	e8 82 fb ff ff       	call   80106bd0 <setupkvm>
8010704e:	85 c0                	test   %eax,%eax
80107050:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107053:	0f 84 b2 00 00 00    	je     8010710b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107059:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010705c:	85 c9                	test   %ecx,%ecx
8010705e:	0f 84 9c 00 00 00    	je     80107100 <copyuvm+0xc0>
80107064:	31 f6                	xor    %esi,%esi
80107066:	eb 4a                	jmp    801070b2 <copyuvm+0x72>
80107068:	90                   	nop
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107070:	83 ec 04             	sub    $0x4,%esp
80107073:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107079:	68 00 10 00 00       	push   $0x1000
8010707e:	57                   	push   %edi
8010707f:	50                   	push   %eax
80107080:	e8 bb d6 ff ff       	call   80104740 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107085:	58                   	pop    %eax
80107086:	5a                   	pop    %edx
80107087:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010708d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107090:	ff 75 e4             	pushl  -0x1c(%ebp)
80107093:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107098:	52                   	push   %edx
80107099:	89 f2                	mov    %esi,%edx
8010709b:	e8 b0 f8 ff ff       	call   80106950 <mappages>
801070a0:	83 c4 10             	add    $0x10,%esp
801070a3:	85 c0                	test   %eax,%eax
801070a5:	78 3e                	js     801070e5 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801070b0:	76 4e                	jbe    80107100 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070b2:	8b 45 08             	mov    0x8(%ebp),%eax
801070b5:	31 c9                	xor    %ecx,%ecx
801070b7:	89 f2                	mov    %esi,%edx
801070b9:	e8 12 f8 ff ff       	call   801068d0 <walkpgdir>
801070be:	85 c0                	test   %eax,%eax
801070c0:	74 5a                	je     8010711c <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801070c2:	8b 18                	mov    (%eax),%ebx
801070c4:	f6 c3 01             	test   $0x1,%bl
801070c7:	74 46                	je     8010710f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070c9:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801070cb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801070d1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070d4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801070da:	e8 c1 b3 ff ff       	call   801024a0 <kalloc>
801070df:	85 c0                	test   %eax,%eax
801070e1:	89 c3                	mov    %eax,%ebx
801070e3:	75 8b                	jne    80107070 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801070e5:	83 ec 0c             	sub    $0xc,%esp
801070e8:	ff 75 e0             	pushl  -0x20(%ebp)
801070eb:	e8 a0 fe ff ff       	call   80106f90 <freevm>
  return 0;
801070f0:	83 c4 10             	add    $0x10,%esp
801070f3:	31 c0                	xor    %eax,%eax
}
801070f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f8:	5b                   	pop    %ebx
801070f9:	5e                   	pop    %esi
801070fa:	5f                   	pop    %edi
801070fb:	5d                   	pop    %ebp
801070fc:	c3                   	ret    
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107103:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107106:	5b                   	pop    %ebx
80107107:	5e                   	pop    %esi
80107108:	5f                   	pop    %edi
80107109:	5d                   	pop    %ebp
8010710a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010710b:	31 c0                	xor    %eax,%eax
8010710d:	eb e6                	jmp    801070f5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010710f:	83 ec 0c             	sub    $0xc,%esp
80107112:	68 6f 7b 10 80       	push   $0x80107b6f
80107117:	e8 54 92 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010711c:	83 ec 0c             	sub    $0xc,%esp
8010711f:	68 55 7b 10 80       	push   $0x80107b55
80107124:	e8 47 92 ff ff       	call   80100370 <panic>
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107130 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107130:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107131:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107133:	89 e5                	mov    %esp,%ebp
80107135:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107138:	8b 55 0c             	mov    0xc(%ebp),%edx
8010713b:	8b 45 08             	mov    0x8(%ebp),%eax
8010713e:	e8 8d f7 ff ff       	call   801068d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107143:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107145:	89 c2                	mov    %eax,%edx
80107147:	83 e2 05             	and    $0x5,%edx
8010714a:	83 fa 05             	cmp    $0x5,%edx
8010714d:	75 11                	jne    80107160 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010714f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107154:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107155:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010715a:	c3                   	ret    
8010715b:	90                   	nop
8010715c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107160:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107162:	c9                   	leave  
80107163:	c3                   	ret    
80107164:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010716a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107170 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 1c             	sub    $0x1c,%esp
80107179:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010717c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010717f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107182:	85 db                	test   %ebx,%ebx
80107184:	75 40                	jne    801071c6 <copyout+0x56>
80107186:	eb 70                	jmp    801071f8 <copyout+0x88>
80107188:	90                   	nop
80107189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107190:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107193:	89 f1                	mov    %esi,%ecx
80107195:	29 d1                	sub    %edx,%ecx
80107197:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010719d:	39 d9                	cmp    %ebx,%ecx
8010719f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801071a2:	29 f2                	sub    %esi,%edx
801071a4:	83 ec 04             	sub    $0x4,%esp
801071a7:	01 d0                	add    %edx,%eax
801071a9:	51                   	push   %ecx
801071aa:	57                   	push   %edi
801071ab:	50                   	push   %eax
801071ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801071af:	e8 8c d5 ff ff       	call   80104740 <memmove>
    len -= n;
    buf += n;
801071b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071b7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801071ba:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801071c0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071c2:	29 cb                	sub    %ecx,%ebx
801071c4:	74 32                	je     801071f8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801071c6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801071c8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801071cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801071ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801071d4:	56                   	push   %esi
801071d5:	ff 75 08             	pushl  0x8(%ebp)
801071d8:	e8 53 ff ff ff       	call   80107130 <uva2ka>
    if(pa0 == 0)
801071dd:	83 c4 10             	add    $0x10,%esp
801071e0:	85 c0                	test   %eax,%eax
801071e2:	75 ac                	jne    80107190 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801071e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801071e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801071ec:	5b                   	pop    %ebx
801071ed:	5e                   	pop    %esi
801071ee:	5f                   	pop    %edi
801071ef:	5d                   	pop    %ebp
801071f0:	c3                   	ret    
801071f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801071fb:	31 c0                	xor    %eax,%eax
}
801071fd:	5b                   	pop    %ebx
801071fe:	5e                   	pop    %esi
801071ff:	5f                   	pop    %edi
80107200:	5d                   	pop    %ebp
80107201:	c3                   	ret    
