
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return randstate;
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
       e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
      11:	68 f3 4c 00 00       	push   $0x4cf3
      16:	6a 01                	push   $0x1
      18:	e8 a3 39 00 00       	call   39c0 <printf>

  if(open("usertests.ran", 0) >= 0){
      1d:	59                   	pop    %ecx
      1e:	58                   	pop    %eax
      1f:	6a 00                	push   $0x0
      21:	68 07 4d 00 00       	push   $0x4d07
      26:	e8 66 38 00 00       	call   3891 <open>
      2b:	83 c4 10             	add    $0x10,%esp
      2e:	85 c0                	test   %eax,%eax
      30:	78 13                	js     45 <main+0x45>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      32:	52                   	push   %edx
      33:	52                   	push   %edx
      34:	68 70 54 00 00       	push   $0x5470
      39:	6a 01                	push   $0x1
      3b:	e8 80 39 00 00       	call   39c0 <printf>
    exit();
      40:	e8 0c 38 00 00       	call   3851 <exit>
  }
  close(open("usertests.ran", O_CREATE));
      45:	50                   	push   %eax
      46:	50                   	push   %eax
      47:	68 00 02 00 00       	push   $0x200
      4c:	68 07 4d 00 00       	push   $0x4d07
      51:	e8 3b 38 00 00       	call   3891 <open>
      56:	89 04 24             	mov    %eax,(%esp)
      59:	e8 1b 38 00 00       	call   3879 <close>

  createdelete();
      5e:	e8 ad 11 00 00       	call   1210 <createdelete>
  linkunlink();
      63:	e8 68 1a 00 00       	call   1ad0 <linkunlink>
  concreate();
      68:	e8 63 17 00 00       	call   17d0 <concreate>
  fourfiles();
      6d:	e8 9e 0f 00 00       	call   1010 <fourfiles>
  sharedfd();
      72:	e8 d9 0d 00 00       	call   e50 <sharedfd>

  bigargtest();
      77:	e8 14 32 00 00       	call   3290 <bigargtest>
  bigwrite();
      7c:	e8 6f 23 00 00       	call   23f0 <bigwrite>
  bigargtest();
      81:	e8 0a 32 00 00       	call   3290 <bigargtest>
  bsstest();
      86:	e8 85 31 00 00       	call   3210 <bsstest>
  sbrktest();
      8b:	e8 a0 2c 00 00       	call   2d30 <sbrktest>
  validatetest();
      90:	e8 cb 30 00 00       	call   3160 <validatetest>

  opentest();
      95:	e8 56 03 00 00       	call   3f0 <opentest>
  writetest();
      9a:	e8 e1 03 00 00       	call   480 <writetest>
  writetest1();
      9f:	e8 bc 05 00 00       	call   660 <writetest1>
  createtest();
      a4:	e8 87 07 00 00       	call   830 <createtest>

  openiputtest();
      a9:	e8 42 02 00 00       	call   2f0 <openiputtest>
  exitiputtest();
      ae:	e8 3d 01 00 00       	call   1f0 <exitiputtest>
  iputtest();
      b3:	e8 58 00 00 00       	call   110 <iputtest>

  mem();
      b8:	e8 c3 0c 00 00       	call   d80 <mem>
  pipe1();
      bd:	e8 4e 09 00 00       	call   a10 <pipe1>
  preempt();
      c2:	e8 d9 0a 00 00       	call   ba0 <preempt>
  exitwait();
      c7:	e8 34 0c 00 00       	call   d00 <exitwait>

  rmdot();
      cc:	e8 0f 27 00 00       	call   27e0 <rmdot>
  fourteen();
      d1:	e8 ca 25 00 00       	call   26a0 <fourteen>
  bigfile();
      d6:	e8 f5 23 00 00       	call   24d0 <bigfile>
  subdir();
      db:	e8 30 1c 00 00       	call   1d10 <subdir>
  linktest();
      e0:	e8 db 14 00 00       	call   15c0 <linktest>
  unlinkread();
      e5:	e8 46 13 00 00       	call   1430 <unlinkread>
  dirfile();
      ea:	e8 71 28 00 00       	call   2960 <dirfile>
  iref();
      ef:	e8 6c 2a 00 00       	call   2b60 <iref>
  forktest();
      f4:	e8 87 2b 00 00       	call   2c80 <forktest>
  bigdir(); // slow
      f9:	e8 e2 1a 00 00       	call   1be0 <bigdir>

  uio();
      fe:	e8 6d 34 00 00       	call   3570 <uio>

  exectest();
     103:	e8 b8 08 00 00       	call   9c0 <exectest>

  exit();
     108:	e8 44 37 00 00       	call   3851 <exit>
     10d:	66 90                	xchg   %ax,%ax
     10f:	90                   	nop

00000110 <iputtest>:
{
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
     116:	68 bc 3d 00 00       	push   $0x3dbc
     11b:	ff 35 74 5d 00 00    	pushl  0x5d74
     121:	e8 9a 38 00 00       	call   39c0 <printf>
  if(mkdir("iputdir") < 0){
     126:	c7 04 24 4f 3d 00 00 	movl   $0x3d4f,(%esp)
     12d:	e8 87 37 00 00       	call   38b9 <mkdir>
     132:	83 c4 10             	add    $0x10,%esp
     135:	85 c0                	test   %eax,%eax
     137:	78 58                	js     191 <iputtest+0x81>
  if(chdir("iputdir") < 0){
     139:	83 ec 0c             	sub    $0xc,%esp
     13c:	68 4f 3d 00 00       	push   $0x3d4f
     141:	e8 7b 37 00 00       	call   38c1 <chdir>
     146:	83 c4 10             	add    $0x10,%esp
     149:	85 c0                	test   %eax,%eax
     14b:	0f 88 85 00 00 00    	js     1d6 <iputtest+0xc6>
  if(unlink("../iputdir") < 0){
     151:	83 ec 0c             	sub    $0xc,%esp
     154:	68 4c 3d 00 00       	push   $0x3d4c
     159:	e8 43 37 00 00       	call   38a1 <unlink>
     15e:	83 c4 10             	add    $0x10,%esp
     161:	85 c0                	test   %eax,%eax
     163:	78 5a                	js     1bf <iputtest+0xaf>
  if(chdir("/") < 0){
     165:	83 ec 0c             	sub    $0xc,%esp
     168:	68 71 3d 00 00       	push   $0x3d71
     16d:	e8 4f 37 00 00       	call   38c1 <chdir>
     172:	83 c4 10             	add    $0x10,%esp
     175:	85 c0                	test   %eax,%eax
     177:	78 2f                	js     1a8 <iputtest+0x98>
  printf(stdout, "iput test ok\n");
     179:	83 ec 08             	sub    $0x8,%esp
     17c:	68 f4 3d 00 00       	push   $0x3df4
     181:	ff 35 74 5d 00 00    	pushl  0x5d74
     187:	e8 34 38 00 00       	call   39c0 <printf>
}
     18c:	83 c4 10             	add    $0x10,%esp
     18f:	c9                   	leave  
     190:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     191:	50                   	push   %eax
     192:	50                   	push   %eax
     193:	68 28 3d 00 00       	push   $0x3d28
     198:	ff 35 74 5d 00 00    	pushl  0x5d74
     19e:	e8 1d 38 00 00       	call   39c0 <printf>
    exit();
     1a3:	e8 a9 36 00 00       	call   3851 <exit>
    printf(stdout, "chdir / failed\n");
     1a8:	50                   	push   %eax
     1a9:	50                   	push   %eax
     1aa:	68 73 3d 00 00       	push   $0x3d73
     1af:	ff 35 74 5d 00 00    	pushl  0x5d74
     1b5:	e8 06 38 00 00       	call   39c0 <printf>
    exit();
     1ba:	e8 92 36 00 00       	call   3851 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     1bf:	52                   	push   %edx
     1c0:	52                   	push   %edx
     1c1:	68 57 3d 00 00       	push   $0x3d57
     1c6:	ff 35 74 5d 00 00    	pushl  0x5d74
     1cc:	e8 ef 37 00 00       	call   39c0 <printf>
    exit();
     1d1:	e8 7b 36 00 00       	call   3851 <exit>
    printf(stdout, "chdir iputdir failed\n");
     1d6:	51                   	push   %ecx
     1d7:	51                   	push   %ecx
     1d8:	68 36 3d 00 00       	push   $0x3d36
     1dd:	ff 35 74 5d 00 00    	pushl  0x5d74
     1e3:	e8 d8 37 00 00       	call   39c0 <printf>
    exit();
     1e8:	e8 64 36 00 00       	call   3851 <exit>
     1ed:	8d 76 00             	lea    0x0(%esi),%esi

000001f0 <exitiputtest>:
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     1f6:	68 83 3d 00 00       	push   $0x3d83
     1fb:	ff 35 74 5d 00 00    	pushl  0x5d74
     201:	e8 ba 37 00 00       	call   39c0 <printf>
  pid = fork();
     206:	e8 3e 36 00 00       	call   3849 <fork>
  if(pid < 0){
     20b:	83 c4 10             	add    $0x10,%esp
     20e:	85 c0                	test   %eax,%eax
     210:	0f 88 8a 00 00 00    	js     2a0 <exitiputtest+0xb0>
  if(pid == 0){
     216:	75 50                	jne    268 <exitiputtest+0x78>
    if(mkdir("iputdir") < 0){
     218:	83 ec 0c             	sub    $0xc,%esp
     21b:	68 4f 3d 00 00       	push   $0x3d4f
     220:	e8 94 36 00 00       	call   38b9 <mkdir>
     225:	83 c4 10             	add    $0x10,%esp
     228:	85 c0                	test   %eax,%eax
     22a:	0f 88 87 00 00 00    	js     2b7 <exitiputtest+0xc7>
    if(chdir("iputdir") < 0){
     230:	83 ec 0c             	sub    $0xc,%esp
     233:	68 4f 3d 00 00       	push   $0x3d4f
     238:	e8 84 36 00 00       	call   38c1 <chdir>
     23d:	83 c4 10             	add    $0x10,%esp
     240:	85 c0                	test   %eax,%eax
     242:	0f 88 86 00 00 00    	js     2ce <exitiputtest+0xde>
    if(unlink("../iputdir") < 0){
     248:	83 ec 0c             	sub    $0xc,%esp
     24b:	68 4c 3d 00 00       	push   $0x3d4c
     250:	e8 4c 36 00 00       	call   38a1 <unlink>
     255:	83 c4 10             	add    $0x10,%esp
     258:	85 c0                	test   %eax,%eax
     25a:	78 2c                	js     288 <exitiputtest+0x98>
    exit();
     25c:	e8 f0 35 00 00       	call   3851 <exit>
     261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  wait();
     268:	e8 ec 35 00 00       	call   3859 <wait>
  printf(stdout, "exitiput test ok\n");
     26d:	83 ec 08             	sub    $0x8,%esp
     270:	68 a6 3d 00 00       	push   $0x3da6
     275:	ff 35 74 5d 00 00    	pushl  0x5d74
     27b:	e8 40 37 00 00       	call   39c0 <printf>
}
     280:	83 c4 10             	add    $0x10,%esp
     283:	c9                   	leave  
     284:	c3                   	ret    
     285:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     288:	83 ec 08             	sub    $0x8,%esp
     28b:	68 57 3d 00 00       	push   $0x3d57
     290:	ff 35 74 5d 00 00    	pushl  0x5d74
     296:	e8 25 37 00 00       	call   39c0 <printf>
      exit();
     29b:	e8 b1 35 00 00       	call   3851 <exit>
    printf(stdout, "fork failed\n");
     2a0:	51                   	push   %ecx
     2a1:	51                   	push   %ecx
     2a2:	68 69 4c 00 00       	push   $0x4c69
     2a7:	ff 35 74 5d 00 00    	pushl  0x5d74
     2ad:	e8 0e 37 00 00       	call   39c0 <printf>
    exit();
     2b2:	e8 9a 35 00 00       	call   3851 <exit>
      printf(stdout, "mkdir failed\n");
     2b7:	52                   	push   %edx
     2b8:	52                   	push   %edx
     2b9:	68 28 3d 00 00       	push   $0x3d28
     2be:	ff 35 74 5d 00 00    	pushl  0x5d74
     2c4:	e8 f7 36 00 00       	call   39c0 <printf>
      exit();
     2c9:	e8 83 35 00 00       	call   3851 <exit>
      printf(stdout, "child chdir failed\n");
     2ce:	50                   	push   %eax
     2cf:	50                   	push   %eax
     2d0:	68 92 3d 00 00       	push   $0x3d92
     2d5:	ff 35 74 5d 00 00    	pushl  0x5d74
     2db:	e8 e0 36 00 00       	call   39c0 <printf>
      exit();
     2e0:	e8 6c 35 00 00       	call   3851 <exit>
     2e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <openiputtest>:
{
     2f0:	55                   	push   %ebp
     2f1:	89 e5                	mov    %esp,%ebp
     2f3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     2f6:	68 b8 3d 00 00       	push   $0x3db8
     2fb:	ff 35 74 5d 00 00    	pushl  0x5d74
     301:	e8 ba 36 00 00       	call   39c0 <printf>
  if(mkdir("oidir") < 0){
     306:	c7 04 24 c7 3d 00 00 	movl   $0x3dc7,(%esp)
     30d:	e8 a7 35 00 00       	call   38b9 <mkdir>
     312:	83 c4 10             	add    $0x10,%esp
     315:	85 c0                	test   %eax,%eax
     317:	0f 88 9f 00 00 00    	js     3bc <openiputtest+0xcc>
  pid = fork();
     31d:	e8 27 35 00 00       	call   3849 <fork>
  if(pid < 0){
     322:	85 c0                	test   %eax,%eax
     324:	78 7f                	js     3a5 <openiputtest+0xb5>
  if(pid == 0){
     326:	75 38                	jne    360 <openiputtest+0x70>
    int fd = open("oidir", O_RDWR);
     328:	83 ec 08             	sub    $0x8,%esp
     32b:	6a 02                	push   $0x2
     32d:	68 c7 3d 00 00       	push   $0x3dc7
     332:	e8 5a 35 00 00       	call   3891 <open>
    if(fd >= 0){
     337:	83 c4 10             	add    $0x10,%esp
     33a:	85 c0                	test   %eax,%eax
     33c:	78 62                	js     3a0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     33e:	83 ec 08             	sub    $0x8,%esp
     341:	68 28 4d 00 00       	push   $0x4d28
     346:	ff 35 74 5d 00 00    	pushl  0x5d74
     34c:	e8 6f 36 00 00       	call   39c0 <printf>
      exit();
     351:	e8 fb 34 00 00       	call   3851 <exit>
     356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     35d:	8d 76 00             	lea    0x0(%esi),%esi
  sleep(1);
     360:	83 ec 0c             	sub    $0xc,%esp
     363:	6a 01                	push   $0x1
     365:	e8 77 35 00 00       	call   38e1 <sleep>
  if(unlink("oidir") != 0){
     36a:	c7 04 24 c7 3d 00 00 	movl   $0x3dc7,(%esp)
     371:	e8 2b 35 00 00       	call   38a1 <unlink>
     376:	83 c4 10             	add    $0x10,%esp
     379:	85 c0                	test   %eax,%eax
     37b:	75 56                	jne    3d3 <openiputtest+0xe3>
  wait();
     37d:	e8 d7 34 00 00       	call   3859 <wait>
  printf(stdout, "openiput test ok\n");
     382:	83 ec 08             	sub    $0x8,%esp
     385:	68 f0 3d 00 00       	push   $0x3df0
     38a:	ff 35 74 5d 00 00    	pushl  0x5d74
     390:	e8 2b 36 00 00       	call   39c0 <printf>
     395:	83 c4 10             	add    $0x10,%esp
}
     398:	c9                   	leave  
     399:	c3                   	ret    
     39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
     3a0:	e8 ac 34 00 00       	call   3851 <exit>
    printf(stdout, "fork failed\n");
     3a5:	52                   	push   %edx
     3a6:	52                   	push   %edx
     3a7:	68 69 4c 00 00       	push   $0x4c69
     3ac:	ff 35 74 5d 00 00    	pushl  0x5d74
     3b2:	e8 09 36 00 00       	call   39c0 <printf>
    exit();
     3b7:	e8 95 34 00 00       	call   3851 <exit>
    printf(stdout, "mkdir oidir failed\n");
     3bc:	51                   	push   %ecx
     3bd:	51                   	push   %ecx
     3be:	68 cd 3d 00 00       	push   $0x3dcd
     3c3:	ff 35 74 5d 00 00    	pushl  0x5d74
     3c9:	e8 f2 35 00 00       	call   39c0 <printf>
    exit();
     3ce:	e8 7e 34 00 00       	call   3851 <exit>
    printf(stdout, "unlink failed\n");
     3d3:	50                   	push   %eax
     3d4:	50                   	push   %eax
     3d5:	68 e1 3d 00 00       	push   $0x3de1
     3da:	ff 35 74 5d 00 00    	pushl  0x5d74
     3e0:	e8 db 35 00 00       	call   39c0 <printf>
    exit();
     3e5:	e8 67 34 00 00       	call   3851 <exit>
     3ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003f0 <opentest>:
{
     3f0:	55                   	push   %ebp
     3f1:	89 e5                	mov    %esp,%ebp
     3f3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     3f6:	68 02 3e 00 00       	push   $0x3e02
     3fb:	ff 35 74 5d 00 00    	pushl  0x5d74
     401:	e8 ba 35 00 00       	call   39c0 <printf>
  fd = open("echo", 0);
     406:	58                   	pop    %eax
     407:	5a                   	pop    %edx
     408:	6a 00                	push   $0x0
     40a:	68 0d 3e 00 00       	push   $0x3e0d
     40f:	e8 7d 34 00 00       	call   3891 <open>
  if(fd < 0){
     414:	83 c4 10             	add    $0x10,%esp
     417:	85 c0                	test   %eax,%eax
     419:	78 36                	js     451 <opentest+0x61>
  close(fd);
     41b:	83 ec 0c             	sub    $0xc,%esp
     41e:	50                   	push   %eax
     41f:	e8 55 34 00 00       	call   3879 <close>
  fd = open("doesnotexist", 0);
     424:	5a                   	pop    %edx
     425:	59                   	pop    %ecx
     426:	6a 00                	push   $0x0
     428:	68 25 3e 00 00       	push   $0x3e25
     42d:	e8 5f 34 00 00       	call   3891 <open>
  if(fd >= 0){
     432:	83 c4 10             	add    $0x10,%esp
     435:	85 c0                	test   %eax,%eax
     437:	79 2f                	jns    468 <opentest+0x78>
  printf(stdout, "open test ok\n");
     439:	83 ec 08             	sub    $0x8,%esp
     43c:	68 50 3e 00 00       	push   $0x3e50
     441:	ff 35 74 5d 00 00    	pushl  0x5d74
     447:	e8 74 35 00 00       	call   39c0 <printf>
}
     44c:	83 c4 10             	add    $0x10,%esp
     44f:	c9                   	leave  
     450:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     451:	50                   	push   %eax
     452:	50                   	push   %eax
     453:	68 12 3e 00 00       	push   $0x3e12
     458:	ff 35 74 5d 00 00    	pushl  0x5d74
     45e:	e8 5d 35 00 00       	call   39c0 <printf>
    exit();
     463:	e8 e9 33 00 00       	call   3851 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     468:	50                   	push   %eax
     469:	50                   	push   %eax
     46a:	68 32 3e 00 00       	push   $0x3e32
     46f:	ff 35 74 5d 00 00    	pushl  0x5d74
     475:	e8 46 35 00 00       	call   39c0 <printf>
    exit();
     47a:	e8 d2 33 00 00       	call   3851 <exit>
     47f:	90                   	nop

00000480 <writetest>:
{
     480:	55                   	push   %ebp
     481:	89 e5                	mov    %esp,%ebp
     483:	56                   	push   %esi
     484:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     485:	83 ec 08             	sub    $0x8,%esp
     488:	68 5e 3e 00 00       	push   $0x3e5e
     48d:	ff 35 74 5d 00 00    	pushl  0x5d74
     493:	e8 28 35 00 00       	call   39c0 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     498:	58                   	pop    %eax
     499:	5a                   	pop    %edx
     49a:	68 02 02 00 00       	push   $0x202
     49f:	68 6f 3e 00 00       	push   $0x3e6f
     4a4:	e8 e8 33 00 00       	call   3891 <open>
  if(fd >= 0){
     4a9:	83 c4 10             	add    $0x10,%esp
     4ac:	85 c0                	test   %eax,%eax
     4ae:	0f 88 88 01 00 00    	js     63c <writetest+0x1bc>
    printf(stdout, "creat small succeeded; ok\n");
     4b4:	83 ec 08             	sub    $0x8,%esp
     4b7:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
     4b9:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
     4bb:	68 75 3e 00 00       	push   $0x3e75
     4c0:	ff 35 74 5d 00 00    	pushl  0x5d74
     4c6:	e8 f5 34 00 00       	call   39c0 <printf>
     4cb:	83 c4 10             	add    $0x10,%esp
     4ce:	66 90                	xchg   %ax,%ax
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     4d0:	83 ec 04             	sub    $0x4,%esp
     4d3:	6a 0a                	push   $0xa
     4d5:	68 ac 3e 00 00       	push   $0x3eac
     4da:	56                   	push   %esi
     4db:	e8 91 33 00 00       	call   3871 <write>
     4e0:	83 c4 10             	add    $0x10,%esp
     4e3:	83 f8 0a             	cmp    $0xa,%eax
     4e6:	0f 85 d9 00 00 00    	jne    5c5 <writetest+0x145>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     4ec:	83 ec 04             	sub    $0x4,%esp
     4ef:	6a 0a                	push   $0xa
     4f1:	68 b7 3e 00 00       	push   $0x3eb7
     4f6:	56                   	push   %esi
     4f7:	e8 75 33 00 00       	call   3871 <write>
     4fc:	83 c4 10             	add    $0x10,%esp
     4ff:	83 f8 0a             	cmp    $0xa,%eax
     502:	0f 85 d6 00 00 00    	jne    5de <writetest+0x15e>
  for(i = 0; i < 100; i++){
     508:	83 c3 01             	add    $0x1,%ebx
     50b:	83 fb 64             	cmp    $0x64,%ebx
     50e:	75 c0                	jne    4d0 <writetest+0x50>
  printf(stdout, "writes ok\n");
     510:	83 ec 08             	sub    $0x8,%esp
     513:	68 c2 3e 00 00       	push   $0x3ec2
     518:	ff 35 74 5d 00 00    	pushl  0x5d74
     51e:	e8 9d 34 00 00       	call   39c0 <printf>
  close(fd);
     523:	89 34 24             	mov    %esi,(%esp)
     526:	e8 4e 33 00 00       	call   3879 <close>
  fd = open("small", O_RDONLY);
     52b:	5b                   	pop    %ebx
     52c:	5e                   	pop    %esi
     52d:	6a 00                	push   $0x0
     52f:	68 6f 3e 00 00       	push   $0x3e6f
     534:	e8 58 33 00 00       	call   3891 <open>
  if(fd >= 0){
     539:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     53c:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     53e:	85 c0                	test   %eax,%eax
     540:	0f 88 b1 00 00 00    	js     5f7 <writetest+0x177>
    printf(stdout, "open small succeeded ok\n");
     546:	83 ec 08             	sub    $0x8,%esp
     549:	68 cd 3e 00 00       	push   $0x3ecd
     54e:	ff 35 74 5d 00 00    	pushl  0x5d74
     554:	e8 67 34 00 00       	call   39c0 <printf>
  i = read(fd, buf, 2000);
     559:	83 c4 0c             	add    $0xc,%esp
     55c:	68 d0 07 00 00       	push   $0x7d0
     561:	68 60 85 00 00       	push   $0x8560
     566:	53                   	push   %ebx
     567:	e8 fd 32 00 00       	call   3869 <read>
  if(i == 2000){
     56c:	83 c4 10             	add    $0x10,%esp
     56f:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     574:	0f 85 94 00 00 00    	jne    60e <writetest+0x18e>
    printf(stdout, "read succeeded ok\n");
     57a:	83 ec 08             	sub    $0x8,%esp
     57d:	68 01 3f 00 00       	push   $0x3f01
     582:	ff 35 74 5d 00 00    	pushl  0x5d74
     588:	e8 33 34 00 00       	call   39c0 <printf>
  close(fd);
     58d:	89 1c 24             	mov    %ebx,(%esp)
     590:	e8 e4 32 00 00       	call   3879 <close>
  if(unlink("small") < 0){
     595:	c7 04 24 6f 3e 00 00 	movl   $0x3e6f,(%esp)
     59c:	e8 00 33 00 00       	call   38a1 <unlink>
     5a1:	83 c4 10             	add    $0x10,%esp
     5a4:	85 c0                	test   %eax,%eax
     5a6:	78 7d                	js     625 <writetest+0x1a5>
  printf(stdout, "small file test ok\n");
     5a8:	83 ec 08             	sub    $0x8,%esp
     5ab:	68 29 3f 00 00       	push   $0x3f29
     5b0:	ff 35 74 5d 00 00    	pushl  0x5d74
     5b6:	e8 05 34 00 00       	call   39c0 <printf>
}
     5bb:	83 c4 10             	add    $0x10,%esp
     5be:	8d 65 f8             	lea    -0x8(%ebp),%esp
     5c1:	5b                   	pop    %ebx
     5c2:	5e                   	pop    %esi
     5c3:	5d                   	pop    %ebp
     5c4:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     5c5:	83 ec 04             	sub    $0x4,%esp
     5c8:	53                   	push   %ebx
     5c9:	68 4c 4d 00 00       	push   $0x4d4c
     5ce:	ff 35 74 5d 00 00    	pushl  0x5d74
     5d4:	e8 e7 33 00 00       	call   39c0 <printf>
      exit();
     5d9:	e8 73 32 00 00       	call   3851 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     5de:	83 ec 04             	sub    $0x4,%esp
     5e1:	53                   	push   %ebx
     5e2:	68 70 4d 00 00       	push   $0x4d70
     5e7:	ff 35 74 5d 00 00    	pushl  0x5d74
     5ed:	e8 ce 33 00 00       	call   39c0 <printf>
      exit();
     5f2:	e8 5a 32 00 00       	call   3851 <exit>
    printf(stdout, "error: open small failed!\n");
     5f7:	51                   	push   %ecx
     5f8:	51                   	push   %ecx
     5f9:	68 e6 3e 00 00       	push   $0x3ee6
     5fe:	ff 35 74 5d 00 00    	pushl  0x5d74
     604:	e8 b7 33 00 00       	call   39c0 <printf>
    exit();
     609:	e8 43 32 00 00       	call   3851 <exit>
    printf(stdout, "read failed\n");
     60e:	52                   	push   %edx
     60f:	52                   	push   %edx
     610:	68 2d 42 00 00       	push   $0x422d
     615:	ff 35 74 5d 00 00    	pushl  0x5d74
     61b:	e8 a0 33 00 00       	call   39c0 <printf>
    exit();
     620:	e8 2c 32 00 00       	call   3851 <exit>
    printf(stdout, "unlink small failed\n");
     625:	50                   	push   %eax
     626:	50                   	push   %eax
     627:	68 14 3f 00 00       	push   $0x3f14
     62c:	ff 35 74 5d 00 00    	pushl  0x5d74
     632:	e8 89 33 00 00       	call   39c0 <printf>
    exit();
     637:	e8 15 32 00 00       	call   3851 <exit>
    printf(stdout, "error: creat small failed!\n");
     63c:	50                   	push   %eax
     63d:	50                   	push   %eax
     63e:	68 90 3e 00 00       	push   $0x3e90
     643:	ff 35 74 5d 00 00    	pushl  0x5d74
     649:	e8 72 33 00 00       	call   39c0 <printf>
    exit();
     64e:	e8 fe 31 00 00       	call   3851 <exit>
     653:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     65a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000660 <writetest1>:
{
     660:	55                   	push   %ebp
     661:	89 e5                	mov    %esp,%ebp
     663:	56                   	push   %esi
     664:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     665:	83 ec 08             	sub    $0x8,%esp
     668:	68 3d 3f 00 00       	push   $0x3f3d
     66d:	ff 35 74 5d 00 00    	pushl  0x5d74
     673:	e8 48 33 00 00       	call   39c0 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     678:	58                   	pop    %eax
     679:	5a                   	pop    %edx
     67a:	68 02 02 00 00       	push   $0x202
     67f:	68 b7 3f 00 00       	push   $0x3fb7
     684:	e8 08 32 00 00       	call   3891 <open>
  if(fd < 0){
     689:	83 c4 10             	add    $0x10,%esp
     68c:	85 c0                	test   %eax,%eax
     68e:	0f 88 61 01 00 00    	js     7f5 <writetest1+0x195>
     694:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     696:	31 db                	xor    %ebx,%ebx
     698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     69f:	90                   	nop
    if(write(fd, buf, 512) != 512){
     6a0:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
     6a3:	89 1d 60 85 00 00    	mov    %ebx,0x8560
    if(write(fd, buf, 512) != 512){
     6a9:	68 00 02 00 00       	push   $0x200
     6ae:	68 60 85 00 00       	push   $0x8560
     6b3:	56                   	push   %esi
     6b4:	e8 b8 31 00 00       	call   3871 <write>
     6b9:	83 c4 10             	add    $0x10,%esp
     6bc:	3d 00 02 00 00       	cmp    $0x200,%eax
     6c1:	0f 85 b3 00 00 00    	jne    77a <writetest1+0x11a>
  for(i = 0; i < MAXFILE; i++){
     6c7:	83 c3 01             	add    $0x1,%ebx
     6ca:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     6d0:	75 ce                	jne    6a0 <writetest1+0x40>
  close(fd);
     6d2:	83 ec 0c             	sub    $0xc,%esp
     6d5:	56                   	push   %esi
     6d6:	e8 9e 31 00 00       	call   3879 <close>
  fd = open("big", O_RDONLY);
     6db:	5b                   	pop    %ebx
     6dc:	5e                   	pop    %esi
     6dd:	6a 00                	push   $0x0
     6df:	68 b7 3f 00 00       	push   $0x3fb7
     6e4:	e8 a8 31 00 00       	call   3891 <open>
  if(fd < 0){
     6e9:	83 c4 10             	add    $0x10,%esp
  fd = open("big", O_RDONLY);
     6ec:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     6ee:	85 c0                	test   %eax,%eax
     6f0:	0f 88 e8 00 00 00    	js     7de <writetest1+0x17e>
  n = 0;
     6f6:	31 db                	xor    %ebx,%ebx
     6f8:	eb 1d                	jmp    717 <writetest1+0xb7>
     6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
     700:	3d 00 02 00 00       	cmp    $0x200,%eax
     705:	0f 85 9f 00 00 00    	jne    7aa <writetest1+0x14a>
    if(((int*)buf)[0] != n){
     70b:	a1 60 85 00 00       	mov    0x8560,%eax
     710:	39 d8                	cmp    %ebx,%eax
     712:	75 7f                	jne    793 <writetest1+0x133>
    n++;
     714:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     717:	83 ec 04             	sub    $0x4,%esp
     71a:	68 00 02 00 00       	push   $0x200
     71f:	68 60 85 00 00       	push   $0x8560
     724:	56                   	push   %esi
     725:	e8 3f 31 00 00       	call   3869 <read>
    if(i == 0){
     72a:	83 c4 10             	add    $0x10,%esp
     72d:	85 c0                	test   %eax,%eax
     72f:	75 cf                	jne    700 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     731:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     737:	0f 84 86 00 00 00    	je     7c3 <writetest1+0x163>
  close(fd);
     73d:	83 ec 0c             	sub    $0xc,%esp
     740:	56                   	push   %esi
     741:	e8 33 31 00 00       	call   3879 <close>
  if(unlink("big") < 0){
     746:	c7 04 24 b7 3f 00 00 	movl   $0x3fb7,(%esp)
     74d:	e8 4f 31 00 00       	call   38a1 <unlink>
     752:	83 c4 10             	add    $0x10,%esp
     755:	85 c0                	test   %eax,%eax
     757:	0f 88 af 00 00 00    	js     80c <writetest1+0x1ac>
  printf(stdout, "big files ok\n");
     75d:	83 ec 08             	sub    $0x8,%esp
     760:	68 de 3f 00 00       	push   $0x3fde
     765:	ff 35 74 5d 00 00    	pushl  0x5d74
     76b:	e8 50 32 00 00       	call   39c0 <printf>
}
     770:	83 c4 10             	add    $0x10,%esp
     773:	8d 65 f8             	lea    -0x8(%ebp),%esp
     776:	5b                   	pop    %ebx
     777:	5e                   	pop    %esi
     778:	5d                   	pop    %ebp
     779:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     77a:	83 ec 04             	sub    $0x4,%esp
     77d:	53                   	push   %ebx
     77e:	68 67 3f 00 00       	push   $0x3f67
     783:	ff 35 74 5d 00 00    	pushl  0x5d74
     789:	e8 32 32 00 00       	call   39c0 <printf>
      exit();
     78e:	e8 be 30 00 00       	call   3851 <exit>
      printf(stdout, "read content of block %d is %d\n",
     793:	50                   	push   %eax
     794:	53                   	push   %ebx
     795:	68 94 4d 00 00       	push   $0x4d94
     79a:	ff 35 74 5d 00 00    	pushl  0x5d74
     7a0:	e8 1b 32 00 00       	call   39c0 <printf>
      exit();
     7a5:	e8 a7 30 00 00       	call   3851 <exit>
      printf(stdout, "read failed %d\n", i);
     7aa:	83 ec 04             	sub    $0x4,%esp
     7ad:	50                   	push   %eax
     7ae:	68 bb 3f 00 00       	push   $0x3fbb
     7b3:	ff 35 74 5d 00 00    	pushl  0x5d74
     7b9:	e8 02 32 00 00       	call   39c0 <printf>
      exit();
     7be:	e8 8e 30 00 00       	call   3851 <exit>
        printf(stdout, "read only %d blocks from big", n);
     7c3:	52                   	push   %edx
     7c4:	68 8b 00 00 00       	push   $0x8b
     7c9:	68 9e 3f 00 00       	push   $0x3f9e
     7ce:	ff 35 74 5d 00 00    	pushl  0x5d74
     7d4:	e8 e7 31 00 00       	call   39c0 <printf>
        exit();
     7d9:	e8 73 30 00 00       	call   3851 <exit>
    printf(stdout, "error: open big failed!\n");
     7de:	51                   	push   %ecx
     7df:	51                   	push   %ecx
     7e0:	68 85 3f 00 00       	push   $0x3f85
     7e5:	ff 35 74 5d 00 00    	pushl  0x5d74
     7eb:	e8 d0 31 00 00       	call   39c0 <printf>
    exit();
     7f0:	e8 5c 30 00 00       	call   3851 <exit>
    printf(stdout, "error: creat big failed!\n");
     7f5:	50                   	push   %eax
     7f6:	50                   	push   %eax
     7f7:	68 4d 3f 00 00       	push   $0x3f4d
     7fc:	ff 35 74 5d 00 00    	pushl  0x5d74
     802:	e8 b9 31 00 00       	call   39c0 <printf>
    exit();
     807:	e8 45 30 00 00       	call   3851 <exit>
    printf(stdout, "unlink big failed\n");
     80c:	50                   	push   %eax
     80d:	50                   	push   %eax
     80e:	68 cb 3f 00 00       	push   $0x3fcb
     813:	ff 35 74 5d 00 00    	pushl  0x5d74
     819:	e8 a2 31 00 00       	call   39c0 <printf>
    exit();
     81e:	e8 2e 30 00 00       	call   3851 <exit>
     823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000830 <createtest>:
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	53                   	push   %ebx
  name[2] = '\0';
     834:	bb 30 00 00 00       	mov    $0x30,%ebx
{
     839:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     83c:	68 b4 4d 00 00       	push   $0x4db4
     841:	ff 35 74 5d 00 00    	pushl  0x5d74
     847:	e8 74 31 00 00       	call   39c0 <printf>
  name[0] = 'a';
     84c:	c6 05 60 a5 00 00 61 	movb   $0x61,0xa560
  name[2] = '\0';
     853:	83 c4 10             	add    $0x10,%esp
     856:	c6 05 62 a5 00 00 00 	movb   $0x0,0xa562
  for(i = 0; i < 52; i++){
     85d:	8d 76 00             	lea    0x0(%esi),%esi
    fd = open(name, O_CREATE|O_RDWR);
     860:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
     863:	88 1d 61 a5 00 00    	mov    %bl,0xa561
    fd = open(name, O_CREATE|O_RDWR);
     869:	83 c3 01             	add    $0x1,%ebx
     86c:	68 02 02 00 00       	push   $0x202
     871:	68 60 a5 00 00       	push   $0xa560
     876:	e8 16 30 00 00       	call   3891 <open>
    close(fd);
     87b:	89 04 24             	mov    %eax,(%esp)
     87e:	e8 f6 2f 00 00       	call   3879 <close>
  for(i = 0; i < 52; i++){
     883:	83 c4 10             	add    $0x10,%esp
     886:	80 fb 64             	cmp    $0x64,%bl
     889:	75 d5                	jne    860 <createtest+0x30>
  name[0] = 'a';
     88b:	c6 05 60 a5 00 00 61 	movb   $0x61,0xa560
  name[2] = '\0';
     892:	bb 30 00 00 00       	mov    $0x30,%ebx
     897:	c6 05 62 a5 00 00 00 	movb   $0x0,0xa562
  for(i = 0; i < 52; i++){
     89e:	66 90                	xchg   %ax,%ax
    unlink(name);
     8a0:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
     8a3:	88 1d 61 a5 00 00    	mov    %bl,0xa561
    unlink(name);
     8a9:	83 c3 01             	add    $0x1,%ebx
     8ac:	68 60 a5 00 00       	push   $0xa560
     8b1:	e8 eb 2f 00 00       	call   38a1 <unlink>
  for(i = 0; i < 52; i++){
     8b6:	83 c4 10             	add    $0x10,%esp
     8b9:	80 fb 64             	cmp    $0x64,%bl
     8bc:	75 e2                	jne    8a0 <createtest+0x70>
  printf(stdout, "many creates, followed by unlink; ok\n");
     8be:	83 ec 08             	sub    $0x8,%esp
     8c1:	68 dc 4d 00 00       	push   $0x4ddc
     8c6:	ff 35 74 5d 00 00    	pushl  0x5d74
     8cc:	e8 ef 30 00 00       	call   39c0 <printf>
}
     8d1:	83 c4 10             	add    $0x10,%esp
     8d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8d7:	c9                   	leave  
     8d8:	c3                   	ret    
     8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008e0 <dirtest>:
{
     8e0:	55                   	push   %ebp
     8e1:	89 e5                	mov    %esp,%ebp
     8e3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     8e6:	68 ec 3f 00 00       	push   $0x3fec
     8eb:	ff 35 74 5d 00 00    	pushl  0x5d74
     8f1:	e8 ca 30 00 00       	call   39c0 <printf>
  if(mkdir("dir0") < 0){
     8f6:	c7 04 24 f8 3f 00 00 	movl   $0x3ff8,(%esp)
     8fd:	e8 b7 2f 00 00       	call   38b9 <mkdir>
     902:	83 c4 10             	add    $0x10,%esp
     905:	85 c0                	test   %eax,%eax
     907:	78 58                	js     961 <dirtest+0x81>
  if(chdir("dir0") < 0){
     909:	83 ec 0c             	sub    $0xc,%esp
     90c:	68 f8 3f 00 00       	push   $0x3ff8
     911:	e8 ab 2f 00 00       	call   38c1 <chdir>
     916:	83 c4 10             	add    $0x10,%esp
     919:	85 c0                	test   %eax,%eax
     91b:	0f 88 85 00 00 00    	js     9a6 <dirtest+0xc6>
  if(chdir("..") < 0){
     921:	83 ec 0c             	sub    $0xc,%esp
     924:	68 9d 45 00 00       	push   $0x459d
     929:	e8 93 2f 00 00       	call   38c1 <chdir>
     92e:	83 c4 10             	add    $0x10,%esp
     931:	85 c0                	test   %eax,%eax
     933:	78 5a                	js     98f <dirtest+0xaf>
  if(unlink("dir0") < 0){
     935:	83 ec 0c             	sub    $0xc,%esp
     938:	68 f8 3f 00 00       	push   $0x3ff8
     93d:	e8 5f 2f 00 00       	call   38a1 <unlink>
     942:	83 c4 10             	add    $0x10,%esp
     945:	85 c0                	test   %eax,%eax
     947:	78 2f                	js     978 <dirtest+0x98>
  printf(stdout, "mkdir test ok\n");
     949:	83 ec 08             	sub    $0x8,%esp
     94c:	68 35 40 00 00       	push   $0x4035
     951:	ff 35 74 5d 00 00    	pushl  0x5d74
     957:	e8 64 30 00 00       	call   39c0 <printf>
}
     95c:	83 c4 10             	add    $0x10,%esp
     95f:	c9                   	leave  
     960:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     961:	50                   	push   %eax
     962:	50                   	push   %eax
     963:	68 28 3d 00 00       	push   $0x3d28
     968:	ff 35 74 5d 00 00    	pushl  0x5d74
     96e:	e8 4d 30 00 00       	call   39c0 <printf>
    exit();
     973:	e8 d9 2e 00 00       	call   3851 <exit>
    printf(stdout, "unlink dir0 failed\n");
     978:	50                   	push   %eax
     979:	50                   	push   %eax
     97a:	68 21 40 00 00       	push   $0x4021
     97f:	ff 35 74 5d 00 00    	pushl  0x5d74
     985:	e8 36 30 00 00       	call   39c0 <printf>
    exit();
     98a:	e8 c2 2e 00 00       	call   3851 <exit>
    printf(stdout, "chdir .. failed\n");
     98f:	52                   	push   %edx
     990:	52                   	push   %edx
     991:	68 10 40 00 00       	push   $0x4010
     996:	ff 35 74 5d 00 00    	pushl  0x5d74
     99c:	e8 1f 30 00 00       	call   39c0 <printf>
    exit();
     9a1:	e8 ab 2e 00 00       	call   3851 <exit>
    printf(stdout, "chdir dir0 failed\n");
     9a6:	51                   	push   %ecx
     9a7:	51                   	push   %ecx
     9a8:	68 fd 3f 00 00       	push   $0x3ffd
     9ad:	ff 35 74 5d 00 00    	pushl  0x5d74
     9b3:	e8 08 30 00 00       	call   39c0 <printf>
    exit();
     9b8:	e8 94 2e 00 00       	call   3851 <exit>
     9bd:	8d 76 00             	lea    0x0(%esi),%esi

000009c0 <exectest>:
{
     9c0:	55                   	push   %ebp
     9c1:	89 e5                	mov    %esp,%ebp
     9c3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     9c6:	68 44 40 00 00       	push   $0x4044
     9cb:	ff 35 74 5d 00 00    	pushl  0x5d74
     9d1:	e8 ea 2f 00 00       	call   39c0 <printf>
  if(exec("echo", echoargv) < 0){
     9d6:	5a                   	pop    %edx
     9d7:	59                   	pop    %ecx
     9d8:	68 78 5d 00 00       	push   $0x5d78
     9dd:	68 0d 3e 00 00       	push   $0x3e0d
     9e2:	e8 a2 2e 00 00       	call   3889 <exec>
     9e7:	83 c4 10             	add    $0x10,%esp
     9ea:	85 c0                	test   %eax,%eax
     9ec:	78 02                	js     9f0 <exectest+0x30>
}
     9ee:	c9                   	leave  
     9ef:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     9f0:	50                   	push   %eax
     9f1:	50                   	push   %eax
     9f2:	68 4f 40 00 00       	push   $0x404f
     9f7:	ff 35 74 5d 00 00    	pushl  0x5d74
     9fd:	e8 be 2f 00 00       	call   39c0 <printf>
    exit();
     a02:	e8 4a 2e 00 00       	call   3851 <exit>
     a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a0e:	66 90                	xchg   %ax,%ax

00000a10 <pipe1>:
{
     a10:	55                   	push   %ebp
     a11:	89 e5                	mov    %esp,%ebp
     a13:	57                   	push   %edi
     a14:	56                   	push   %esi
  if(pipe(fds) != 0){
     a15:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
     a18:	53                   	push   %ebx
     a19:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     a1c:	50                   	push   %eax
     a1d:	e8 3f 2e 00 00       	call   3861 <pipe>
     a22:	83 c4 10             	add    $0x10,%esp
     a25:	85 c0                	test   %eax,%eax
     a27:	0f 85 34 01 00 00    	jne    b61 <pipe1+0x151>
  pid = fork();
     a2d:	e8 17 2e 00 00       	call   3849 <fork>
  if(pid == 0){
     a32:	85 c0                	test   %eax,%eax
     a34:	0f 84 89 00 00 00    	je     ac3 <pipe1+0xb3>
  } else if(pid > 0){
     a3a:	0f 8e 34 01 00 00    	jle    b74 <pipe1+0x164>
    close(fds[1]);
     a40:	83 ec 0c             	sub    $0xc,%esp
     a43:	ff 75 e4             	pushl  -0x1c(%ebp)
  seq = 0;
     a46:	31 db                	xor    %ebx,%ebx
    cc = 1;
     a48:	bf 01 00 00 00       	mov    $0x1,%edi
    close(fds[1]);
     a4d:	e8 27 2e 00 00       	call   3879 <close>
    total = 0;
     a52:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a59:	83 c4 10             	add    $0x10,%esp
     a5c:	83 ec 04             	sub    $0x4,%esp
     a5f:	57                   	push   %edi
     a60:	68 60 85 00 00       	push   $0x8560
     a65:	ff 75 e0             	pushl  -0x20(%ebp)
     a68:	e8 fc 2d 00 00       	call   3869 <read>
     a6d:	83 c4 10             	add    $0x10,%esp
     a70:	85 c0                	test   %eax,%eax
     a72:	0f 8e a5 00 00 00    	jle    b1d <pipe1+0x10d>
     a78:	8d 34 03             	lea    (%ebx,%eax,1),%esi
      for(i = 0; i < n; i++){
     a7b:	31 d2                	xor    %edx,%edx
     a7d:	8d 76 00             	lea    0x0(%esi),%esi
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a80:	8d 4b 01             	lea    0x1(%ebx),%ecx
     a83:	38 9a 60 85 00 00    	cmp    %bl,0x8560(%edx)
     a89:	75 1e                	jne    aa9 <pipe1+0x99>
      for(i = 0; i < n; i++){
     a8b:	83 c2 01             	add    $0x1,%edx
     a8e:	89 cb                	mov    %ecx,%ebx
     a90:	39 ce                	cmp    %ecx,%esi
     a92:	75 ec                	jne    a80 <pipe1+0x70>
      cc = cc * 2;
     a94:	01 ff                	add    %edi,%edi
      total += n;
     a96:	01 45 d4             	add    %eax,-0x2c(%ebp)
     a99:	b8 00 20 00 00       	mov    $0x2000,%eax
     a9e:	81 ff 00 20 00 00    	cmp    $0x2000,%edi
     aa4:	0f 4f f8             	cmovg  %eax,%edi
     aa7:	eb b3                	jmp    a5c <pipe1+0x4c>
          printf(1, "pipe1 oops 2\n");
     aa9:	83 ec 08             	sub    $0x8,%esp
     aac:	68 7e 40 00 00       	push   $0x407e
     ab1:	6a 01                	push   $0x1
     ab3:	e8 08 2f 00 00       	call   39c0 <printf>
          return;
     ab8:	83 c4 10             	add    $0x10,%esp
}
     abb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     abe:	5b                   	pop    %ebx
     abf:	5e                   	pop    %esi
     ac0:	5f                   	pop    %edi
     ac1:	5d                   	pop    %ebp
     ac2:	c3                   	ret    
    close(fds[0]);
     ac3:	83 ec 0c             	sub    $0xc,%esp
     ac6:	ff 75 e0             	pushl  -0x20(%ebp)
  seq = 0;
     ac9:	31 db                	xor    %ebx,%ebx
    close(fds[0]);
     acb:	e8 a9 2d 00 00       	call   3879 <close>
     ad0:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 1033; i++)
     ad3:	31 c0                	xor    %eax,%eax
     ad5:	8d 76 00             	lea    0x0(%esi),%esi
        buf[i] = seq++;
     ad8:	8d 14 18             	lea    (%eax,%ebx,1),%edx
      for(i = 0; i < 1033; i++)
     adb:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
     ade:	88 90 5f 85 00 00    	mov    %dl,0x855f(%eax)
      for(i = 0; i < 1033; i++)
     ae4:	3d 09 04 00 00       	cmp    $0x409,%eax
     ae9:	75 ed                	jne    ad8 <pipe1+0xc8>
      if(write(fds[1], buf, 1033) != 1033){
     aeb:	83 ec 04             	sub    $0x4,%esp
     aee:	81 c3 09 04 00 00    	add    $0x409,%ebx
     af4:	68 09 04 00 00       	push   $0x409
     af9:	68 60 85 00 00       	push   $0x8560
     afe:	ff 75 e4             	pushl  -0x1c(%ebp)
     b01:	e8 6b 2d 00 00       	call   3871 <write>
     b06:	83 c4 10             	add    $0x10,%esp
     b09:	3d 09 04 00 00       	cmp    $0x409,%eax
     b0e:	75 77                	jne    b87 <pipe1+0x177>
    for(n = 0; n < 5; n++){
     b10:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     b16:	75 bb                	jne    ad3 <pipe1+0xc3>
    exit();
     b18:	e8 34 2d 00 00       	call   3851 <exit>
    if(total != 5 * 1033){
     b1d:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     b24:	75 26                	jne    b4c <pipe1+0x13c>
    close(fds[0]);
     b26:	83 ec 0c             	sub    $0xc,%esp
     b29:	ff 75 e0             	pushl  -0x20(%ebp)
     b2c:	e8 48 2d 00 00       	call   3879 <close>
    wait();
     b31:	e8 23 2d 00 00       	call   3859 <wait>
  printf(1, "pipe1 ok\n");
     b36:	5a                   	pop    %edx
     b37:	59                   	pop    %ecx
     b38:	68 a3 40 00 00       	push   $0x40a3
     b3d:	6a 01                	push   $0x1
     b3f:	e8 7c 2e 00 00       	call   39c0 <printf>
     b44:	83 c4 10             	add    $0x10,%esp
     b47:	e9 6f ff ff ff       	jmp    abb <pipe1+0xab>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b4c:	53                   	push   %ebx
     b4d:	ff 75 d4             	pushl  -0x2c(%ebp)
     b50:	68 8c 40 00 00       	push   $0x408c
     b55:	6a 01                	push   $0x1
     b57:	e8 64 2e 00 00       	call   39c0 <printf>
      exit();
     b5c:	e8 f0 2c 00 00       	call   3851 <exit>
    printf(1, "pipe() failed\n");
     b61:	57                   	push   %edi
     b62:	57                   	push   %edi
     b63:	68 61 40 00 00       	push   $0x4061
     b68:	6a 01                	push   $0x1
     b6a:	e8 51 2e 00 00       	call   39c0 <printf>
    exit();
     b6f:	e8 dd 2c 00 00       	call   3851 <exit>
    printf(1, "fork() failed\n");
     b74:	50                   	push   %eax
     b75:	50                   	push   %eax
     b76:	68 ad 40 00 00       	push   $0x40ad
     b7b:	6a 01                	push   $0x1
     b7d:	e8 3e 2e 00 00       	call   39c0 <printf>
    exit();
     b82:	e8 ca 2c 00 00       	call   3851 <exit>
        printf(1, "pipe1 oops 1\n");
     b87:	56                   	push   %esi
     b88:	56                   	push   %esi
     b89:	68 70 40 00 00       	push   $0x4070
     b8e:	6a 01                	push   $0x1
     b90:	e8 2b 2e 00 00       	call   39c0 <printf>
        exit();
     b95:	e8 b7 2c 00 00       	call   3851 <exit>
     b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000ba0 <preempt>:
{
     ba0:	55                   	push   %ebp
     ba1:	89 e5                	mov    %esp,%ebp
     ba3:	57                   	push   %edi
     ba4:	56                   	push   %esi
     ba5:	53                   	push   %ebx
     ba6:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     ba9:	68 bc 40 00 00       	push   $0x40bc
     bae:	6a 01                	push   $0x1
     bb0:	e8 0b 2e 00 00       	call   39c0 <printf>
  pid1 = fork();
     bb5:	e8 8f 2c 00 00       	call   3849 <fork>
  if(pid1 == 0)
     bba:	83 c4 10             	add    $0x10,%esp
     bbd:	85 c0                	test   %eax,%eax
     bbf:	75 07                	jne    bc8 <preempt+0x28>
      ;
     bc1:	eb fe                	jmp    bc1 <preempt+0x21>
     bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     bc7:	90                   	nop
     bc8:	89 c7                	mov    %eax,%edi
  pid2 = fork();
     bca:	e8 7a 2c 00 00       	call   3849 <fork>
     bcf:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     bd1:	85 c0                	test   %eax,%eax
     bd3:	75 0b                	jne    be0 <preempt+0x40>
      ;
     bd5:	eb fe                	jmp    bd5 <preempt+0x35>
     bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bde:	66 90                	xchg   %ax,%ax
  pipe(pfds);
     be0:	83 ec 0c             	sub    $0xc,%esp
     be3:	8d 45 e0             	lea    -0x20(%ebp),%eax
     be6:	50                   	push   %eax
     be7:	e8 75 2c 00 00       	call   3861 <pipe>
  pid3 = fork();
     bec:	e8 58 2c 00 00       	call   3849 <fork>
  if(pid3 == 0){
     bf1:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bf4:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     bf6:	85 c0                	test   %eax,%eax
     bf8:	75 3e                	jne    c38 <preempt+0x98>
    close(pfds[0]);
     bfa:	83 ec 0c             	sub    $0xc,%esp
     bfd:	ff 75 e0             	pushl  -0x20(%ebp)
     c00:	e8 74 2c 00 00       	call   3879 <close>
    if(write(pfds[1], "x", 1) != 1)
     c05:	83 c4 0c             	add    $0xc,%esp
     c08:	6a 01                	push   $0x1
     c0a:	68 81 46 00 00       	push   $0x4681
     c0f:	ff 75 e4             	pushl  -0x1c(%ebp)
     c12:	e8 5a 2c 00 00       	call   3871 <write>
     c17:	83 c4 10             	add    $0x10,%esp
     c1a:	83 f8 01             	cmp    $0x1,%eax
     c1d:	0f 85 a4 00 00 00    	jne    cc7 <preempt+0x127>
    close(pfds[1]);
     c23:	83 ec 0c             	sub    $0xc,%esp
     c26:	ff 75 e4             	pushl  -0x1c(%ebp)
     c29:	e8 4b 2c 00 00       	call   3879 <close>
     c2e:	83 c4 10             	add    $0x10,%esp
      ;
     c31:	eb fe                	jmp    c31 <preempt+0x91>
     c33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c37:	90                   	nop
  close(pfds[1]);
     c38:	83 ec 0c             	sub    $0xc,%esp
     c3b:	ff 75 e4             	pushl  -0x1c(%ebp)
     c3e:	e8 36 2c 00 00       	call   3879 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c43:	83 c4 0c             	add    $0xc,%esp
     c46:	68 00 20 00 00       	push   $0x2000
     c4b:	68 60 85 00 00       	push   $0x8560
     c50:	ff 75 e0             	pushl  -0x20(%ebp)
     c53:	e8 11 2c 00 00       	call   3869 <read>
     c58:	83 c4 10             	add    $0x10,%esp
     c5b:	83 f8 01             	cmp    $0x1,%eax
     c5e:	75 7e                	jne    cde <preempt+0x13e>
  close(pfds[0]);
     c60:	83 ec 0c             	sub    $0xc,%esp
     c63:	ff 75 e0             	pushl  -0x20(%ebp)
     c66:	e8 0e 2c 00 00       	call   3879 <close>
  printf(1, "kill... ");
     c6b:	58                   	pop    %eax
     c6c:	5a                   	pop    %edx
     c6d:	68 ed 40 00 00       	push   $0x40ed
     c72:	6a 01                	push   $0x1
     c74:	e8 47 2d 00 00       	call   39c0 <printf>
  kill(pid1);
     c79:	89 3c 24             	mov    %edi,(%esp)
     c7c:	e8 00 2c 00 00       	call   3881 <kill>
  kill(pid2);
     c81:	89 34 24             	mov    %esi,(%esp)
     c84:	e8 f8 2b 00 00       	call   3881 <kill>
  kill(pid3);
     c89:	89 1c 24             	mov    %ebx,(%esp)
     c8c:	e8 f0 2b 00 00       	call   3881 <kill>
  printf(1, "wait... ");
     c91:	59                   	pop    %ecx
     c92:	5b                   	pop    %ebx
     c93:	68 f6 40 00 00       	push   $0x40f6
     c98:	6a 01                	push   $0x1
     c9a:	e8 21 2d 00 00       	call   39c0 <printf>
  wait();
     c9f:	e8 b5 2b 00 00       	call   3859 <wait>
  wait();
     ca4:	e8 b0 2b 00 00       	call   3859 <wait>
  wait();
     ca9:	e8 ab 2b 00 00       	call   3859 <wait>
  printf(1, "preempt ok\n");
     cae:	5e                   	pop    %esi
     caf:	5f                   	pop    %edi
     cb0:	68 ff 40 00 00       	push   $0x40ff
     cb5:	6a 01                	push   $0x1
     cb7:	e8 04 2d 00 00       	call   39c0 <printf>
     cbc:	83 c4 10             	add    $0x10,%esp
}
     cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cc2:	5b                   	pop    %ebx
     cc3:	5e                   	pop    %esi
     cc4:	5f                   	pop    %edi
     cc5:	5d                   	pop    %ebp
     cc6:	c3                   	ret    
      printf(1, "preempt write error");
     cc7:	83 ec 08             	sub    $0x8,%esp
     cca:	68 c6 40 00 00       	push   $0x40c6
     ccf:	6a 01                	push   $0x1
     cd1:	e8 ea 2c 00 00       	call   39c0 <printf>
     cd6:	83 c4 10             	add    $0x10,%esp
     cd9:	e9 45 ff ff ff       	jmp    c23 <preempt+0x83>
    printf(1, "preempt read error");
     cde:	83 ec 08             	sub    $0x8,%esp
     ce1:	68 da 40 00 00       	push   $0x40da
     ce6:	6a 01                	push   $0x1
     ce8:	e8 d3 2c 00 00       	call   39c0 <printf>
    return;
     ced:	83 c4 10             	add    $0x10,%esp
     cf0:	eb cd                	jmp    cbf <preempt+0x11f>
     cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d00 <exitwait>:
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	56                   	push   %esi
     d04:	be 64 00 00 00       	mov    $0x64,%esi
     d09:	53                   	push   %ebx
     d0a:	eb 14                	jmp    d20 <exitwait+0x20>
     d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid){
     d10:	74 68                	je     d7a <exitwait+0x7a>
      if(wait() != pid){
     d12:	e8 42 2b 00 00       	call   3859 <wait>
     d17:	39 d8                	cmp    %ebx,%eax
     d19:	75 2d                	jne    d48 <exitwait+0x48>
  for(i = 0; i < 100; i++){
     d1b:	83 ee 01             	sub    $0x1,%esi
     d1e:	74 41                	je     d61 <exitwait+0x61>
    pid = fork();
     d20:	e8 24 2b 00 00       	call   3849 <fork>
     d25:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     d27:	85 c0                	test   %eax,%eax
     d29:	79 e5                	jns    d10 <exitwait+0x10>
      printf(1, "fork failed\n");
     d2b:	83 ec 08             	sub    $0x8,%esp
     d2e:	68 69 4c 00 00       	push   $0x4c69
     d33:	6a 01                	push   $0x1
     d35:	e8 86 2c 00 00       	call   39c0 <printf>
      return;
     d3a:	83 c4 10             	add    $0x10,%esp
}
     d3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d40:	5b                   	pop    %ebx
     d41:	5e                   	pop    %esi
     d42:	5d                   	pop    %ebp
     d43:	c3                   	ret    
     d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
     d48:	83 ec 08             	sub    $0x8,%esp
     d4b:	68 0b 41 00 00       	push   $0x410b
     d50:	6a 01                	push   $0x1
     d52:	e8 69 2c 00 00       	call   39c0 <printf>
        return;
     d57:	83 c4 10             	add    $0x10,%esp
}
     d5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d5d:	5b                   	pop    %ebx
     d5e:	5e                   	pop    %esi
     d5f:	5d                   	pop    %ebp
     d60:	c3                   	ret    
  printf(1, "exitwait ok\n");
     d61:	83 ec 08             	sub    $0x8,%esp
     d64:	68 1b 41 00 00       	push   $0x411b
     d69:	6a 01                	push   $0x1
     d6b:	e8 50 2c 00 00       	call   39c0 <printf>
     d70:	83 c4 10             	add    $0x10,%esp
}
     d73:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d76:	5b                   	pop    %ebx
     d77:	5e                   	pop    %esi
     d78:	5d                   	pop    %ebp
     d79:	c3                   	ret    
      exit();
     d7a:	e8 d2 2a 00 00       	call   3851 <exit>
     d7f:	90                   	nop

00000d80 <mem>:
{
     d80:	55                   	push   %ebp
     d81:	89 e5                	mov    %esp,%ebp
     d83:	57                   	push   %edi
     d84:	56                   	push   %esi
     d85:	53                   	push   %ebx
     d86:	31 db                	xor    %ebx,%ebx
     d88:	83 ec 14             	sub    $0x14,%esp
  printf(1, "mem test\n");
     d8b:	68 28 41 00 00       	push   $0x4128
     d90:	6a 01                	push   $0x1
     d92:	e8 29 2c 00 00       	call   39c0 <printf>
  ppid = getpid();
     d97:	e8 35 2b 00 00       	call   38d1 <getpid>
     d9c:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     d9e:	e8 a6 2a 00 00       	call   3849 <fork>
     da3:	83 c4 10             	add    $0x10,%esp
     da6:	85 c0                	test   %eax,%eax
     da8:	74 0a                	je     db4 <mem+0x34>
     daa:	e9 89 00 00 00       	jmp    e38 <mem+0xb8>
     daf:	90                   	nop
      *(char**)m2 = m1;
     db0:	89 18                	mov    %ebx,(%eax)
     db2:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     db4:	83 ec 0c             	sub    $0xc,%esp
     db7:	68 11 27 00 00       	push   $0x2711
     dbc:	e8 5f 2e 00 00       	call   3c20 <malloc>
     dc1:	83 c4 10             	add    $0x10,%esp
     dc4:	85 c0                	test   %eax,%eax
     dc6:	75 e8                	jne    db0 <mem+0x30>
    while(m1){
     dc8:	85 db                	test   %ebx,%ebx
     dca:	74 18                	je     de4 <mem+0x64>
     dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      free(m1);
     dd0:	83 ec 0c             	sub    $0xc,%esp
      m2 = *(char**)m1;
     dd3:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     dd5:	53                   	push   %ebx
     dd6:	89 fb                	mov    %edi,%ebx
     dd8:	e8 b3 2d 00 00       	call   3b90 <free>
    while(m1){
     ddd:	83 c4 10             	add    $0x10,%esp
     de0:	85 db                	test   %ebx,%ebx
     de2:	75 ec                	jne    dd0 <mem+0x50>
    m1 = malloc(1024*20);
     de4:	83 ec 0c             	sub    $0xc,%esp
     de7:	68 00 50 00 00       	push   $0x5000
     dec:	e8 2f 2e 00 00       	call   3c20 <malloc>
    if(m1 == 0){
     df1:	83 c4 10             	add    $0x10,%esp
     df4:	85 c0                	test   %eax,%eax
     df6:	74 20                	je     e18 <mem+0x98>
    free(m1);
     df8:	83 ec 0c             	sub    $0xc,%esp
     dfb:	50                   	push   %eax
     dfc:	e8 8f 2d 00 00       	call   3b90 <free>
    printf(1, "mem ok\n");
     e01:	58                   	pop    %eax
     e02:	5a                   	pop    %edx
     e03:	68 4c 41 00 00       	push   $0x414c
     e08:	6a 01                	push   $0x1
     e0a:	e8 b1 2b 00 00       	call   39c0 <printf>
    exit();
     e0f:	e8 3d 2a 00 00       	call   3851 <exit>
     e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "couldn't allocate mem?!!\n");
     e18:	83 ec 08             	sub    $0x8,%esp
     e1b:	68 32 41 00 00       	push   $0x4132
     e20:	6a 01                	push   $0x1
     e22:	e8 99 2b 00 00       	call   39c0 <printf>
      kill(ppid);
     e27:	89 34 24             	mov    %esi,(%esp)
     e2a:	e8 52 2a 00 00       	call   3881 <kill>
      exit();
     e2f:	e8 1d 2a 00 00       	call   3851 <exit>
     e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
     e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e3b:	5b                   	pop    %ebx
     e3c:	5e                   	pop    %esi
     e3d:	5f                   	pop    %edi
     e3e:	5d                   	pop    %ebp
    wait();
     e3f:	e9 15 2a 00 00       	jmp    3859 <wait>
     e44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e4f:	90                   	nop

00000e50 <sharedfd>:
{
     e50:	55                   	push   %ebp
     e51:	89 e5                	mov    %esp,%ebp
     e53:	57                   	push   %edi
     e54:	56                   	push   %esi
     e55:	53                   	push   %ebx
     e56:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
     e59:	68 54 41 00 00       	push   $0x4154
     e5e:	6a 01                	push   $0x1
     e60:	e8 5b 2b 00 00       	call   39c0 <printf>
  unlink("sharedfd");
     e65:	c7 04 24 63 41 00 00 	movl   $0x4163,(%esp)
     e6c:	e8 30 2a 00 00       	call   38a1 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e71:	5b                   	pop    %ebx
     e72:	5e                   	pop    %esi
     e73:	68 02 02 00 00       	push   $0x202
     e78:	68 63 41 00 00       	push   $0x4163
     e7d:	e8 0f 2a 00 00       	call   3891 <open>
  if(fd < 0){
     e82:	83 c4 10             	add    $0x10,%esp
     e85:	85 c0                	test   %eax,%eax
     e87:	0f 88 2a 01 00 00    	js     fb7 <sharedfd+0x167>
     e8d:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e8f:	8d 75 de             	lea    -0x22(%ebp),%esi
     e92:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
     e97:	e8 ad 29 00 00       	call   3849 <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e9c:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
     e9f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ea2:	19 c0                	sbb    %eax,%eax
     ea4:	83 ec 04             	sub    $0x4,%esp
     ea7:	83 e0 f3             	and    $0xfffffff3,%eax
     eaa:	6a 0a                	push   $0xa
     eac:	83 c0 70             	add    $0x70,%eax
     eaf:	50                   	push   %eax
     eb0:	56                   	push   %esi
     eb1:	e8 fa 27 00 00       	call   36b0 <memset>
     eb6:	83 c4 10             	add    $0x10,%esp
     eb9:	eb 0a                	jmp    ec5 <sharedfd+0x75>
     ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ebf:	90                   	nop
  for(i = 0; i < 1000; i++){
     ec0:	83 eb 01             	sub    $0x1,%ebx
     ec3:	74 26                	je     eeb <sharedfd+0x9b>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     ec5:	83 ec 04             	sub    $0x4,%esp
     ec8:	6a 0a                	push   $0xa
     eca:	56                   	push   %esi
     ecb:	57                   	push   %edi
     ecc:	e8 a0 29 00 00       	call   3871 <write>
     ed1:	83 c4 10             	add    $0x10,%esp
     ed4:	83 f8 0a             	cmp    $0xa,%eax
     ed7:	74 e7                	je     ec0 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
     ed9:	83 ec 08             	sub    $0x8,%esp
     edc:	68 30 4e 00 00       	push   $0x4e30
     ee1:	6a 01                	push   $0x1
     ee3:	e8 d8 2a 00 00       	call   39c0 <printf>
      break;
     ee8:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
     eeb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     eee:	85 c9                	test   %ecx,%ecx
     ef0:	0f 84 f5 00 00 00    	je     feb <sharedfd+0x19b>
    wait();
     ef6:	e8 5e 29 00 00       	call   3859 <wait>
  close(fd);
     efb:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
     efe:	31 db                	xor    %ebx,%ebx
  close(fd);
     f00:	57                   	push   %edi
     f01:	8d 7d e8             	lea    -0x18(%ebp),%edi
     f04:	e8 70 29 00 00       	call   3879 <close>
  fd = open("sharedfd", 0);
     f09:	58                   	pop    %eax
     f0a:	5a                   	pop    %edx
     f0b:	6a 00                	push   $0x0
     f0d:	68 63 41 00 00       	push   $0x4163
     f12:	e8 7a 29 00 00       	call   3891 <open>
  if(fd < 0){
     f17:	83 c4 10             	add    $0x10,%esp
  nc = np = 0;
     f1a:	31 d2                	xor    %edx,%edx
  fd = open("sharedfd", 0);
     f1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(fd < 0){
     f1f:	85 c0                	test   %eax,%eax
     f21:	0f 88 aa 00 00 00    	js     fd1 <sharedfd+0x181>
     f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f2e:	66 90                	xchg   %ax,%ax
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f30:	83 ec 04             	sub    $0x4,%esp
     f33:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f36:	6a 0a                	push   $0xa
     f38:	56                   	push   %esi
     f39:	ff 75 d0             	pushl  -0x30(%ebp)
     f3c:	e8 28 29 00 00       	call   3869 <read>
     f41:	83 c4 10             	add    $0x10,%esp
     f44:	85 c0                	test   %eax,%eax
     f46:	7e 28                	jle    f70 <sharedfd+0x120>
     f48:	89 f0                	mov    %esi,%eax
     f4a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     f4d:	eb 13                	jmp    f62 <sharedfd+0x112>
     f4f:	90                   	nop
        np++;
     f50:	80 f9 70             	cmp    $0x70,%cl
     f53:	0f 94 c1             	sete   %cl
     f56:	0f b6 c9             	movzbl %cl,%ecx
     f59:	01 cb                	add    %ecx,%ebx
     f5b:	83 c0 01             	add    $0x1,%eax
    for(i = 0; i < sizeof(buf); i++){
     f5e:	39 c7                	cmp    %eax,%edi
     f60:	74 ce                	je     f30 <sharedfd+0xe0>
      if(buf[i] == 'c')
     f62:	0f b6 08             	movzbl (%eax),%ecx
     f65:	80 f9 63             	cmp    $0x63,%cl
     f68:	75 e6                	jne    f50 <sharedfd+0x100>
        nc++;
     f6a:	83 c2 01             	add    $0x1,%edx
      if(buf[i] == 'p')
     f6d:	eb ec                	jmp    f5b <sharedfd+0x10b>
     f6f:	90                   	nop
  close(fd);
     f70:	83 ec 0c             	sub    $0xc,%esp
     f73:	ff 75 d0             	pushl  -0x30(%ebp)
     f76:	e8 fe 28 00 00       	call   3879 <close>
  unlink("sharedfd");
     f7b:	c7 04 24 63 41 00 00 	movl   $0x4163,(%esp)
     f82:	e8 1a 29 00 00       	call   38a1 <unlink>
  if(nc == 10000 && np == 10000){
     f87:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     f8a:	83 c4 10             	add    $0x10,%esp
     f8d:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
     f93:	75 5b                	jne    ff0 <sharedfd+0x1a0>
     f95:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     f9b:	75 53                	jne    ff0 <sharedfd+0x1a0>
    printf(1, "sharedfd ok\n");
     f9d:	83 ec 08             	sub    $0x8,%esp
     fa0:	68 6c 41 00 00       	push   $0x416c
     fa5:	6a 01                	push   $0x1
     fa7:	e8 14 2a 00 00       	call   39c0 <printf>
     fac:	83 c4 10             	add    $0x10,%esp
}
     faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fb2:	5b                   	pop    %ebx
     fb3:	5e                   	pop    %esi
     fb4:	5f                   	pop    %edi
     fb5:	5d                   	pop    %ebp
     fb6:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for writing");
     fb7:	83 ec 08             	sub    $0x8,%esp
     fba:	68 04 4e 00 00       	push   $0x4e04
     fbf:	6a 01                	push   $0x1
     fc1:	e8 fa 29 00 00       	call   39c0 <printf>
    return;
     fc6:	83 c4 10             	add    $0x10,%esp
}
     fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fcc:	5b                   	pop    %ebx
     fcd:	5e                   	pop    %esi
     fce:	5f                   	pop    %edi
     fcf:	5d                   	pop    %ebp
     fd0:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
     fd1:	83 ec 08             	sub    $0x8,%esp
     fd4:	68 50 4e 00 00       	push   $0x4e50
     fd9:	6a 01                	push   $0x1
     fdb:	e8 e0 29 00 00       	call   39c0 <printf>
    return;
     fe0:	83 c4 10             	add    $0x10,%esp
}
     fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fe6:	5b                   	pop    %ebx
     fe7:	5e                   	pop    %esi
     fe8:	5f                   	pop    %edi
     fe9:	5d                   	pop    %ebp
     fea:	c3                   	ret    
    exit();
     feb:	e8 61 28 00 00       	call   3851 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
     ff0:	53                   	push   %ebx
     ff1:	52                   	push   %edx
     ff2:	68 79 41 00 00       	push   $0x4179
     ff7:	6a 01                	push   $0x1
     ff9:	e8 c2 29 00 00       	call   39c0 <printf>
    exit();
     ffe:	e8 4e 28 00 00       	call   3851 <exit>
    1003:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001010 <fourfiles>:
{
    1010:	55                   	push   %ebp
    1011:	89 e5                	mov    %esp,%ebp
    1013:	57                   	push   %edi
    1014:	56                   	push   %esi
  printf(1, "fourfiles test\n");
    1015:	be 8e 41 00 00       	mov    $0x418e,%esi
{
    101a:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    101b:	31 db                	xor    %ebx,%ebx
{
    101d:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
    1020:	c7 45 d8 8e 41 00 00 	movl   $0x418e,-0x28(%ebp)
  printf(1, "fourfiles test\n");
    1027:	68 94 41 00 00       	push   $0x4194
    102c:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
    102e:	c7 45 dc d7 42 00 00 	movl   $0x42d7,-0x24(%ebp)
    1035:	c7 45 e0 db 42 00 00 	movl   $0x42db,-0x20(%ebp)
    103c:	c7 45 e4 91 41 00 00 	movl   $0x4191,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
    1043:	e8 78 29 00 00       	call   39c0 <printf>
    1048:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
    104b:	83 ec 0c             	sub    $0xc,%esp
    104e:	56                   	push   %esi
    104f:	e8 4d 28 00 00       	call   38a1 <unlink>
    pid = fork();
    1054:	e8 f0 27 00 00       	call   3849 <fork>
    if(pid < 0){
    1059:	83 c4 10             	add    $0x10,%esp
    105c:	85 c0                	test   %eax,%eax
    105e:	0f 88 6c 01 00 00    	js     11d0 <fourfiles+0x1c0>
    if(pid == 0){
    1064:	0f 84 ef 00 00 00    	je     1159 <fourfiles+0x149>
  for(pi = 0; pi < 4; pi++){
    106a:	83 c3 01             	add    $0x1,%ebx
    106d:	83 fb 04             	cmp    $0x4,%ebx
    1070:	74 06                	je     1078 <fourfiles+0x68>
    1072:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    1076:	eb d3                	jmp    104b <fourfiles+0x3b>
    wait();
    1078:	e8 dc 27 00 00       	call   3859 <wait>
  for(i = 0; i < 2; i++){
    107d:	31 ff                	xor    %edi,%edi
    wait();
    107f:	e8 d5 27 00 00       	call   3859 <wait>
    1084:	e8 d0 27 00 00       	call   3859 <wait>
    1089:	e8 cb 27 00 00       	call   3859 <wait>
    108e:	c7 45 d0 8e 41 00 00 	movl   $0x418e,-0x30(%ebp)
    fd = open(fname, 0);
    1095:	83 ec 08             	sub    $0x8,%esp
    total = 0;
    1098:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
    109a:	6a 00                	push   $0x0
    109c:	ff 75 d0             	pushl  -0x30(%ebp)
    109f:	e8 ed 27 00 00       	call   3891 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10a4:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
    10a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10b0:	83 ec 04             	sub    $0x4,%esp
    10b3:	68 00 20 00 00       	push   $0x2000
    10b8:	68 60 85 00 00       	push   $0x8560
    10bd:	ff 75 d4             	pushl  -0x2c(%ebp)
    10c0:	e8 a4 27 00 00       	call   3869 <read>
    10c5:	83 c4 10             	add    $0x10,%esp
    10c8:	85 c0                	test   %eax,%eax
    10ca:	7e 22                	jle    10ee <fourfiles+0xde>
      for(j = 0; j < n; j++){
    10cc:	31 d2                	xor    %edx,%edx
    10ce:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
    10d0:	83 ff 01             	cmp    $0x1,%edi
    10d3:	0f be b2 60 85 00 00 	movsbl 0x8560(%edx),%esi
    10da:	19 c9                	sbb    %ecx,%ecx
    10dc:	83 c1 31             	add    $0x31,%ecx
    10df:	39 ce                	cmp    %ecx,%esi
    10e1:	75 62                	jne    1145 <fourfiles+0x135>
      for(j = 0; j < n; j++){
    10e3:	83 c2 01             	add    $0x1,%edx
    10e6:	39 d0                	cmp    %edx,%eax
    10e8:	75 e6                	jne    10d0 <fourfiles+0xc0>
      total += n;
    10ea:	01 c3                	add    %eax,%ebx
    10ec:	eb c2                	jmp    10b0 <fourfiles+0xa0>
    close(fd);
    10ee:	83 ec 0c             	sub    $0xc,%esp
    10f1:	ff 75 d4             	pushl  -0x2c(%ebp)
    10f4:	e8 80 27 00 00       	call   3879 <close>
    if(total != 12*500){
    10f9:	83 c4 10             	add    $0x10,%esp
    10fc:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    1102:	0f 85 dc 00 00 00    	jne    11e4 <fourfiles+0x1d4>
    unlink(fname);
    1108:	83 ec 0c             	sub    $0xc,%esp
    110b:	ff 75 d0             	pushl  -0x30(%ebp)
    110e:	e8 8e 27 00 00       	call   38a1 <unlink>
  for(i = 0; i < 2; i++){
    1113:	83 c4 10             	add    $0x10,%esp
    1116:	83 ff 01             	cmp    $0x1,%edi
    1119:	75 1a                	jne    1135 <fourfiles+0x125>
  printf(1, "fourfiles ok\n");
    111b:	83 ec 08             	sub    $0x8,%esp
    111e:	68 d2 41 00 00       	push   $0x41d2
    1123:	6a 01                	push   $0x1
    1125:	e8 96 28 00 00       	call   39c0 <printf>
}
    112a:	83 c4 10             	add    $0x10,%esp
    112d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1130:	5b                   	pop    %ebx
    1131:	5e                   	pop    %esi
    1132:	5f                   	pop    %edi
    1133:	5d                   	pop    %ebp
    1134:	c3                   	ret    
    1135:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1138:	bf 01 00 00 00       	mov    $0x1,%edi
    113d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1140:	e9 50 ff ff ff       	jmp    1095 <fourfiles+0x85>
          printf(1, "wrong char\n");
    1145:	83 ec 08             	sub    $0x8,%esp
    1148:	68 b5 41 00 00       	push   $0x41b5
    114d:	6a 01                	push   $0x1
    114f:	e8 6c 28 00 00       	call   39c0 <printf>
          exit();
    1154:	e8 f8 26 00 00       	call   3851 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1159:	83 ec 08             	sub    $0x8,%esp
    115c:	68 02 02 00 00       	push   $0x202
    1161:	56                   	push   %esi
    1162:	e8 2a 27 00 00       	call   3891 <open>
      if(fd < 0){
    1167:	83 c4 10             	add    $0x10,%esp
      fd = open(fname, O_CREATE | O_RDWR);
    116a:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    116c:	85 c0                	test   %eax,%eax
    116e:	78 45                	js     11b5 <fourfiles+0x1a5>
      memset(buf, '0'+pi, 512);
    1170:	83 ec 04             	sub    $0x4,%esp
    1173:	83 c3 30             	add    $0x30,%ebx
    1176:	68 00 02 00 00       	push   $0x200
    117b:	53                   	push   %ebx
    117c:	bb 0c 00 00 00       	mov    $0xc,%ebx
    1181:	68 60 85 00 00       	push   $0x8560
    1186:	e8 25 25 00 00       	call   36b0 <memset>
    118b:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    118e:	83 ec 04             	sub    $0x4,%esp
    1191:	68 f4 01 00 00       	push   $0x1f4
    1196:	68 60 85 00 00       	push   $0x8560
    119b:	56                   	push   %esi
    119c:	e8 d0 26 00 00       	call   3871 <write>
    11a1:	83 c4 10             	add    $0x10,%esp
    11a4:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    11a9:	75 4c                	jne    11f7 <fourfiles+0x1e7>
      for(i = 0; i < 12; i++){
    11ab:	83 eb 01             	sub    $0x1,%ebx
    11ae:	75 de                	jne    118e <fourfiles+0x17e>
      exit();
    11b0:	e8 9c 26 00 00       	call   3851 <exit>
        printf(1, "create failed\n");
    11b5:	51                   	push   %ecx
    11b6:	51                   	push   %ecx
    11b7:	68 2f 44 00 00       	push   $0x442f
    11bc:	6a 01                	push   $0x1
    11be:	e8 fd 27 00 00       	call   39c0 <printf>
        exit();
    11c3:	e8 89 26 00 00       	call   3851 <exit>
    11c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11cf:	90                   	nop
      printf(1, "fork failed\n");
    11d0:	83 ec 08             	sub    $0x8,%esp
    11d3:	68 69 4c 00 00       	push   $0x4c69
    11d8:	6a 01                	push   $0x1
    11da:	e8 e1 27 00 00       	call   39c0 <printf>
      exit();
    11df:	e8 6d 26 00 00       	call   3851 <exit>
      printf(1, "wrong length %d\n", total);
    11e4:	50                   	push   %eax
    11e5:	53                   	push   %ebx
    11e6:	68 c1 41 00 00       	push   $0x41c1
    11eb:	6a 01                	push   $0x1
    11ed:	e8 ce 27 00 00       	call   39c0 <printf>
      exit();
    11f2:	e8 5a 26 00 00       	call   3851 <exit>
          printf(1, "write failed %d\n", n);
    11f7:	52                   	push   %edx
    11f8:	50                   	push   %eax
    11f9:	68 a4 41 00 00       	push   $0x41a4
    11fe:	6a 01                	push   $0x1
    1200:	e8 bb 27 00 00       	call   39c0 <printf>
          exit();
    1205:	e8 47 26 00 00       	call   3851 <exit>
    120a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001210 <createdelete>:
{
    1210:	55                   	push   %ebp
    1211:	89 e5                	mov    %esp,%ebp
    1213:	57                   	push   %edi
    1214:	56                   	push   %esi
    1215:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    1216:	31 db                	xor    %ebx,%ebx
{
    1218:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    121b:	68 e0 41 00 00       	push   $0x41e0
    1220:	6a 01                	push   $0x1
    1222:	e8 99 27 00 00       	call   39c0 <printf>
    1227:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    122a:	e8 1a 26 00 00       	call   3849 <fork>
    if(pid < 0){
    122f:	85 c0                	test   %eax,%eax
    1231:	0f 88 bf 01 00 00    	js     13f6 <createdelete+0x1e6>
    if(pid == 0){
    1237:	0f 84 0b 01 00 00    	je     1348 <createdelete+0x138>
  for(pi = 0; pi < 4; pi++){
    123d:	83 c3 01             	add    $0x1,%ebx
    1240:	83 fb 04             	cmp    $0x4,%ebx
    1243:	75 e5                	jne    122a <createdelete+0x1a>
    wait();
    1245:	e8 0f 26 00 00       	call   3859 <wait>
  name[0] = name[1] = name[2] = 0;
    124a:	be ff ff ff ff       	mov    $0xffffffff,%esi
    124f:	8d 7d c8             	lea    -0x38(%ebp),%edi
    wait();
    1252:	e8 02 26 00 00       	call   3859 <wait>
    1257:	e8 fd 25 00 00       	call   3859 <wait>
    125c:	e8 f8 25 00 00       	call   3859 <wait>
  name[0] = name[1] = name[2] = 0;
    1261:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  for(i = 0; i < N; i++){
    1265:	8d 76 00             	lea    0x0(%esi),%esi
    1268:	8d 46 31             	lea    0x31(%esi),%eax
    126b:	88 45 c7             	mov    %al,-0x39(%ebp)
    126e:	8d 46 01             	lea    0x1(%esi),%eax
    1271:	83 f8 09             	cmp    $0x9,%eax
    1274:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1277:	0f 9f c3             	setg   %bl
    127a:	85 c0                	test   %eax,%eax
    127c:	0f 94 c0             	sete   %al
    127f:	09 c3                	or     %eax,%ebx
    1281:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    1284:	bb 70 00 00 00       	mov    $0x70,%ebx
      fd = open(name, 0);
    1289:	83 ec 08             	sub    $0x8,%esp
      name[1] = '0' + i;
    128c:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      name[0] = 'p' + pi;
    1290:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    1293:	6a 00                	push   $0x0
    1295:	57                   	push   %edi
      name[1] = '0' + i;
    1296:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1299:	e8 f3 25 00 00       	call   3891 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    129e:	83 c4 10             	add    $0x10,%esp
    12a1:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    12a5:	0f 84 85 00 00 00    	je     1330 <createdelete+0x120>
    12ab:	85 c0                	test   %eax,%eax
    12ad:	0f 88 1a 01 00 00    	js     13cd <createdelete+0x1bd>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12b3:	83 fe 08             	cmp    $0x8,%esi
    12b6:	0f 86 56 01 00 00    	jbe    1412 <createdelete+0x202>
        close(fd);
    12bc:	83 ec 0c             	sub    $0xc,%esp
    12bf:	50                   	push   %eax
    12c0:	e8 b4 25 00 00       	call   3879 <close>
    12c5:	83 c4 10             	add    $0x10,%esp
    12c8:	83 c3 01             	add    $0x1,%ebx
    for(pi = 0; pi < 4; pi++){
    12cb:	80 fb 74             	cmp    $0x74,%bl
    12ce:	75 b9                	jne    1289 <createdelete+0x79>
    12d0:	8b 75 c0             	mov    -0x40(%ebp),%esi
  for(i = 0; i < N; i++){
    12d3:	83 fe 13             	cmp    $0x13,%esi
    12d6:	75 90                	jne    1268 <createdelete+0x58>
    12d8:	be 70 00 00 00       	mov    $0x70,%esi
    12dd:	8d 76 00             	lea    0x0(%esi),%esi
    12e0:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    12e3:	bb 04 00 00 00       	mov    $0x4,%ebx
    12e8:	88 45 c7             	mov    %al,-0x39(%ebp)
      unlink(name);
    12eb:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    12ee:	89 f0                	mov    %esi,%eax
      unlink(name);
    12f0:	57                   	push   %edi
      name[0] = 'p' + i;
    12f1:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    12f4:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    12f8:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    12fb:	e8 a1 25 00 00       	call   38a1 <unlink>
    for(pi = 0; pi < 4; pi++){
    1300:	83 c4 10             	add    $0x10,%esp
    1303:	83 eb 01             	sub    $0x1,%ebx
    1306:	75 e3                	jne    12eb <createdelete+0xdb>
    1308:	83 c6 01             	add    $0x1,%esi
  for(i = 0; i < N; i++){
    130b:	89 f0                	mov    %esi,%eax
    130d:	3c 84                	cmp    $0x84,%al
    130f:	75 cf                	jne    12e0 <createdelete+0xd0>
  printf(1, "createdelete ok\n");
    1311:	83 ec 08             	sub    $0x8,%esp
    1314:	68 f3 41 00 00       	push   $0x41f3
    1319:	6a 01                	push   $0x1
    131b:	e8 a0 26 00 00       	call   39c0 <printf>
}
    1320:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1323:	5b                   	pop    %ebx
    1324:	5e                   	pop    %esi
    1325:	5f                   	pop    %edi
    1326:	5d                   	pop    %ebp
    1327:	c3                   	ret    
    1328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    132f:	90                   	nop
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1330:	83 fe 08             	cmp    $0x8,%esi
    1333:	0f 86 d1 00 00 00    	jbe    140a <createdelete+0x1fa>
      if(fd >= 0)
    1339:	85 c0                	test   %eax,%eax
    133b:	78 8b                	js     12c8 <createdelete+0xb8>
    133d:	e9 7a ff ff ff       	jmp    12bc <createdelete+0xac>
    1342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    1348:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    134b:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    134f:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    1352:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    1355:	31 db                	xor    %ebx,%ebx
    1357:	eb 0f                	jmp    1368 <createdelete+0x158>
    1359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    1360:	83 fb 13             	cmp    $0x13,%ebx
    1363:	74 63                	je     13c8 <createdelete+0x1b8>
    1365:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    1368:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    136b:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    136e:	68 02 02 00 00       	push   $0x202
    1373:	57                   	push   %edi
        name[1] = '0' + i;
    1374:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    1377:	e8 15 25 00 00       	call   3891 <open>
        if(fd < 0){
    137c:	83 c4 10             	add    $0x10,%esp
    137f:	85 c0                	test   %eax,%eax
    1381:	78 5f                	js     13e2 <createdelete+0x1d2>
        close(fd);
    1383:	83 ec 0c             	sub    $0xc,%esp
    1386:	50                   	push   %eax
    1387:	e8 ed 24 00 00       	call   3879 <close>
        if(i > 0 && (i % 2 ) == 0){
    138c:	83 c4 10             	add    $0x10,%esp
    138f:	85 db                	test   %ebx,%ebx
    1391:	74 d2                	je     1365 <createdelete+0x155>
    1393:	f6 c3 01             	test   $0x1,%bl
    1396:	75 c8                	jne    1360 <createdelete+0x150>
          if(unlink(name) < 0){
    1398:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    139b:	89 d8                	mov    %ebx,%eax
          if(unlink(name) < 0){
    139d:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    139e:	d1 f8                	sar    %eax
    13a0:	83 c0 30             	add    $0x30,%eax
    13a3:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    13a6:	e8 f6 24 00 00       	call   38a1 <unlink>
    13ab:	83 c4 10             	add    $0x10,%esp
    13ae:	85 c0                	test   %eax,%eax
    13b0:	79 ae                	jns    1360 <createdelete+0x150>
            printf(1, "unlink failed\n");
    13b2:	52                   	push   %edx
    13b3:	52                   	push   %edx
    13b4:	68 e1 3d 00 00       	push   $0x3de1
    13b9:	6a 01                	push   $0x1
    13bb:	e8 00 26 00 00       	call   39c0 <printf>
            exit();
    13c0:	e8 8c 24 00 00       	call   3851 <exit>
    13c5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    13c8:	e8 84 24 00 00       	call   3851 <exit>
        printf(1, "oops createdelete %s didn't exist\n", name);
    13cd:	83 ec 04             	sub    $0x4,%esp
    13d0:	57                   	push   %edi
    13d1:	68 7c 4e 00 00       	push   $0x4e7c
    13d6:	6a 01                	push   $0x1
    13d8:	e8 e3 25 00 00       	call   39c0 <printf>
        exit();
    13dd:	e8 6f 24 00 00       	call   3851 <exit>
          printf(1, "create failed\n");
    13e2:	83 ec 08             	sub    $0x8,%esp
    13e5:	68 2f 44 00 00       	push   $0x442f
    13ea:	6a 01                	push   $0x1
    13ec:	e8 cf 25 00 00       	call   39c0 <printf>
          exit();
    13f1:	e8 5b 24 00 00       	call   3851 <exit>
      printf(1, "fork failed\n");
    13f6:	83 ec 08             	sub    $0x8,%esp
    13f9:	68 69 4c 00 00       	push   $0x4c69
    13fe:	6a 01                	push   $0x1
    1400:	e8 bb 25 00 00       	call   39c0 <printf>
      exit();
    1405:	e8 47 24 00 00       	call   3851 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    140a:	85 c0                	test   %eax,%eax
    140c:	0f 88 b6 fe ff ff    	js     12c8 <createdelete+0xb8>
        printf(1, "oops createdelete %s did exist\n", name);
    1412:	50                   	push   %eax
    1413:	57                   	push   %edi
    1414:	68 a0 4e 00 00       	push   $0x4ea0
    1419:	6a 01                	push   $0x1
    141b:	e8 a0 25 00 00       	call   39c0 <printf>
        exit();
    1420:	e8 2c 24 00 00       	call   3851 <exit>
    1425:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001430 <unlinkread>:
{
    1430:	55                   	push   %ebp
    1431:	89 e5                	mov    %esp,%ebp
    1433:	56                   	push   %esi
    1434:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    1435:	83 ec 08             	sub    $0x8,%esp
    1438:	68 04 42 00 00       	push   $0x4204
    143d:	6a 01                	push   $0x1
    143f:	e8 7c 25 00 00       	call   39c0 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1444:	5b                   	pop    %ebx
    1445:	5e                   	pop    %esi
    1446:	68 02 02 00 00       	push   $0x202
    144b:	68 15 42 00 00       	push   $0x4215
    1450:	e8 3c 24 00 00       	call   3891 <open>
  if(fd < 0){
    1455:	83 c4 10             	add    $0x10,%esp
    1458:	85 c0                	test   %eax,%eax
    145a:	0f 88 e6 00 00 00    	js     1546 <unlinkread+0x116>
  write(fd, "hello", 5);
    1460:	83 ec 04             	sub    $0x4,%esp
    1463:	89 c3                	mov    %eax,%ebx
    1465:	6a 05                	push   $0x5
    1467:	68 3a 42 00 00       	push   $0x423a
    146c:	50                   	push   %eax
    146d:	e8 ff 23 00 00       	call   3871 <write>
  close(fd);
    1472:	89 1c 24             	mov    %ebx,(%esp)
    1475:	e8 ff 23 00 00       	call   3879 <close>
  fd = open("unlinkread", O_RDWR);
    147a:	58                   	pop    %eax
    147b:	5a                   	pop    %edx
    147c:	6a 02                	push   $0x2
    147e:	68 15 42 00 00       	push   $0x4215
    1483:	e8 09 24 00 00       	call   3891 <open>
  if(fd < 0){
    1488:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_RDWR);
    148b:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    148d:	85 c0                	test   %eax,%eax
    148f:	0f 88 10 01 00 00    	js     15a5 <unlinkread+0x175>
  if(unlink("unlinkread") != 0){
    1495:	83 ec 0c             	sub    $0xc,%esp
    1498:	68 15 42 00 00       	push   $0x4215
    149d:	e8 ff 23 00 00       	call   38a1 <unlink>
    14a2:	83 c4 10             	add    $0x10,%esp
    14a5:	85 c0                	test   %eax,%eax
    14a7:	0f 85 e5 00 00 00    	jne    1592 <unlinkread+0x162>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    14ad:	83 ec 08             	sub    $0x8,%esp
    14b0:	68 02 02 00 00       	push   $0x202
    14b5:	68 15 42 00 00       	push   $0x4215
    14ba:	e8 d2 23 00 00       	call   3891 <open>
  write(fd1, "yyy", 3);
    14bf:	83 c4 0c             	add    $0xc,%esp
    14c2:	6a 03                	push   $0x3
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    14c4:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    14c6:	68 72 42 00 00       	push   $0x4272
    14cb:	50                   	push   %eax
    14cc:	e8 a0 23 00 00       	call   3871 <write>
  close(fd1);
    14d1:	89 34 24             	mov    %esi,(%esp)
    14d4:	e8 a0 23 00 00       	call   3879 <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    14d9:	83 c4 0c             	add    $0xc,%esp
    14dc:	68 00 20 00 00       	push   $0x2000
    14e1:	68 60 85 00 00       	push   $0x8560
    14e6:	53                   	push   %ebx
    14e7:	e8 7d 23 00 00       	call   3869 <read>
    14ec:	83 c4 10             	add    $0x10,%esp
    14ef:	83 f8 05             	cmp    $0x5,%eax
    14f2:	0f 85 87 00 00 00    	jne    157f <unlinkread+0x14f>
  if(buf[0] != 'h'){
    14f8:	80 3d 60 85 00 00 68 	cmpb   $0x68,0x8560
    14ff:	75 6b                	jne    156c <unlinkread+0x13c>
  if(write(fd, buf, 10) != 10){
    1501:	83 ec 04             	sub    $0x4,%esp
    1504:	6a 0a                	push   $0xa
    1506:	68 60 85 00 00       	push   $0x8560
    150b:	53                   	push   %ebx
    150c:	e8 60 23 00 00       	call   3871 <write>
    1511:	83 c4 10             	add    $0x10,%esp
    1514:	83 f8 0a             	cmp    $0xa,%eax
    1517:	75 40                	jne    1559 <unlinkread+0x129>
  close(fd);
    1519:	83 ec 0c             	sub    $0xc,%esp
    151c:	53                   	push   %ebx
    151d:	e8 57 23 00 00       	call   3879 <close>
  unlink("unlinkread");
    1522:	c7 04 24 15 42 00 00 	movl   $0x4215,(%esp)
    1529:	e8 73 23 00 00       	call   38a1 <unlink>
  printf(1, "unlinkread ok\n");
    152e:	58                   	pop    %eax
    152f:	5a                   	pop    %edx
    1530:	68 bd 42 00 00       	push   $0x42bd
    1535:	6a 01                	push   $0x1
    1537:	e8 84 24 00 00       	call   39c0 <printf>
}
    153c:	83 c4 10             	add    $0x10,%esp
    153f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1542:	5b                   	pop    %ebx
    1543:	5e                   	pop    %esi
    1544:	5d                   	pop    %ebp
    1545:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    1546:	51                   	push   %ecx
    1547:	51                   	push   %ecx
    1548:	68 20 42 00 00       	push   $0x4220
    154d:	6a 01                	push   $0x1
    154f:	e8 6c 24 00 00       	call   39c0 <printf>
    exit();
    1554:	e8 f8 22 00 00       	call   3851 <exit>
    printf(1, "unlinkread write failed\n");
    1559:	51                   	push   %ecx
    155a:	51                   	push   %ecx
    155b:	68 a4 42 00 00       	push   $0x42a4
    1560:	6a 01                	push   $0x1
    1562:	e8 59 24 00 00       	call   39c0 <printf>
    exit();
    1567:	e8 e5 22 00 00       	call   3851 <exit>
    printf(1, "unlinkread wrong data\n");
    156c:	53                   	push   %ebx
    156d:	53                   	push   %ebx
    156e:	68 8d 42 00 00       	push   $0x428d
    1573:	6a 01                	push   $0x1
    1575:	e8 46 24 00 00       	call   39c0 <printf>
    exit();
    157a:	e8 d2 22 00 00       	call   3851 <exit>
    printf(1, "unlinkread read failed");
    157f:	56                   	push   %esi
    1580:	56                   	push   %esi
    1581:	68 76 42 00 00       	push   $0x4276
    1586:	6a 01                	push   $0x1
    1588:	e8 33 24 00 00       	call   39c0 <printf>
    exit();
    158d:	e8 bf 22 00 00       	call   3851 <exit>
    printf(1, "unlink unlinkread failed\n");
    1592:	50                   	push   %eax
    1593:	50                   	push   %eax
    1594:	68 58 42 00 00       	push   $0x4258
    1599:	6a 01                	push   $0x1
    159b:	e8 20 24 00 00       	call   39c0 <printf>
    exit();
    15a0:	e8 ac 22 00 00       	call   3851 <exit>
    printf(1, "open unlinkread failed\n");
    15a5:	50                   	push   %eax
    15a6:	50                   	push   %eax
    15a7:	68 40 42 00 00       	push   $0x4240
    15ac:	6a 01                	push   $0x1
    15ae:	e8 0d 24 00 00       	call   39c0 <printf>
    exit();
    15b3:	e8 99 22 00 00       	call   3851 <exit>
    15b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15bf:	90                   	nop

000015c0 <linktest>:
{
    15c0:	55                   	push   %ebp
    15c1:	89 e5                	mov    %esp,%ebp
    15c3:	53                   	push   %ebx
    15c4:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    15c7:	68 cc 42 00 00       	push   $0x42cc
    15cc:	6a 01                	push   $0x1
    15ce:	e8 ed 23 00 00       	call   39c0 <printf>
  unlink("lf1");
    15d3:	c7 04 24 d6 42 00 00 	movl   $0x42d6,(%esp)
    15da:	e8 c2 22 00 00       	call   38a1 <unlink>
  unlink("lf2");
    15df:	c7 04 24 da 42 00 00 	movl   $0x42da,(%esp)
    15e6:	e8 b6 22 00 00       	call   38a1 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    15eb:	58                   	pop    %eax
    15ec:	5a                   	pop    %edx
    15ed:	68 02 02 00 00       	push   $0x202
    15f2:	68 d6 42 00 00       	push   $0x42d6
    15f7:	e8 95 22 00 00       	call   3891 <open>
  if(fd < 0){
    15fc:	83 c4 10             	add    $0x10,%esp
    15ff:	85 c0                	test   %eax,%eax
    1601:	0f 88 1e 01 00 00    	js     1725 <linktest+0x165>
  if(write(fd, "hello", 5) != 5){
    1607:	83 ec 04             	sub    $0x4,%esp
    160a:	89 c3                	mov    %eax,%ebx
    160c:	6a 05                	push   $0x5
    160e:	68 3a 42 00 00       	push   $0x423a
    1613:	50                   	push   %eax
    1614:	e8 58 22 00 00       	call   3871 <write>
    1619:	83 c4 10             	add    $0x10,%esp
    161c:	83 f8 05             	cmp    $0x5,%eax
    161f:	0f 85 98 01 00 00    	jne    17bd <linktest+0x1fd>
  close(fd);
    1625:	83 ec 0c             	sub    $0xc,%esp
    1628:	53                   	push   %ebx
    1629:	e8 4b 22 00 00       	call   3879 <close>
  if(link("lf1", "lf2") < 0){
    162e:	5b                   	pop    %ebx
    162f:	58                   	pop    %eax
    1630:	68 da 42 00 00       	push   $0x42da
    1635:	68 d6 42 00 00       	push   $0x42d6
    163a:	e8 72 22 00 00       	call   38b1 <link>
    163f:	83 c4 10             	add    $0x10,%esp
    1642:	85 c0                	test   %eax,%eax
    1644:	0f 88 60 01 00 00    	js     17aa <linktest+0x1ea>
  unlink("lf1");
    164a:	83 ec 0c             	sub    $0xc,%esp
    164d:	68 d6 42 00 00       	push   $0x42d6
    1652:	e8 4a 22 00 00       	call   38a1 <unlink>
  if(open("lf1", 0) >= 0){
    1657:	58                   	pop    %eax
    1658:	5a                   	pop    %edx
    1659:	6a 00                	push   $0x0
    165b:	68 d6 42 00 00       	push   $0x42d6
    1660:	e8 2c 22 00 00       	call   3891 <open>
    1665:	83 c4 10             	add    $0x10,%esp
    1668:	85 c0                	test   %eax,%eax
    166a:	0f 89 27 01 00 00    	jns    1797 <linktest+0x1d7>
  fd = open("lf2", 0);
    1670:	83 ec 08             	sub    $0x8,%esp
    1673:	6a 00                	push   $0x0
    1675:	68 da 42 00 00       	push   $0x42da
    167a:	e8 12 22 00 00       	call   3891 <open>
  if(fd < 0){
    167f:	83 c4 10             	add    $0x10,%esp
  fd = open("lf2", 0);
    1682:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1684:	85 c0                	test   %eax,%eax
    1686:	0f 88 f8 00 00 00    	js     1784 <linktest+0x1c4>
  if(read(fd, buf, sizeof(buf)) != 5){
    168c:	83 ec 04             	sub    $0x4,%esp
    168f:	68 00 20 00 00       	push   $0x2000
    1694:	68 60 85 00 00       	push   $0x8560
    1699:	50                   	push   %eax
    169a:	e8 ca 21 00 00       	call   3869 <read>
    169f:	83 c4 10             	add    $0x10,%esp
    16a2:	83 f8 05             	cmp    $0x5,%eax
    16a5:	0f 85 c6 00 00 00    	jne    1771 <linktest+0x1b1>
  close(fd);
    16ab:	83 ec 0c             	sub    $0xc,%esp
    16ae:	53                   	push   %ebx
    16af:	e8 c5 21 00 00       	call   3879 <close>
  if(link("lf2", "lf2") >= 0){
    16b4:	58                   	pop    %eax
    16b5:	5a                   	pop    %edx
    16b6:	68 da 42 00 00       	push   $0x42da
    16bb:	68 da 42 00 00       	push   $0x42da
    16c0:	e8 ec 21 00 00       	call   38b1 <link>
    16c5:	83 c4 10             	add    $0x10,%esp
    16c8:	85 c0                	test   %eax,%eax
    16ca:	0f 89 8e 00 00 00    	jns    175e <linktest+0x19e>
  unlink("lf2");
    16d0:	83 ec 0c             	sub    $0xc,%esp
    16d3:	68 da 42 00 00       	push   $0x42da
    16d8:	e8 c4 21 00 00       	call   38a1 <unlink>
  if(link("lf2", "lf1") >= 0){
    16dd:	59                   	pop    %ecx
    16de:	5b                   	pop    %ebx
    16df:	68 d6 42 00 00       	push   $0x42d6
    16e4:	68 da 42 00 00       	push   $0x42da
    16e9:	e8 c3 21 00 00       	call   38b1 <link>
    16ee:	83 c4 10             	add    $0x10,%esp
    16f1:	85 c0                	test   %eax,%eax
    16f3:	79 56                	jns    174b <linktest+0x18b>
  if(link(".", "lf1") >= 0){
    16f5:	83 ec 08             	sub    $0x8,%esp
    16f8:	68 d6 42 00 00       	push   $0x42d6
    16fd:	68 9e 45 00 00       	push   $0x459e
    1702:	e8 aa 21 00 00       	call   38b1 <link>
    1707:	83 c4 10             	add    $0x10,%esp
    170a:	85 c0                	test   %eax,%eax
    170c:	79 2a                	jns    1738 <linktest+0x178>
  printf(1, "linktest ok\n");
    170e:	83 ec 08             	sub    $0x8,%esp
    1711:	68 74 43 00 00       	push   $0x4374
    1716:	6a 01                	push   $0x1
    1718:	e8 a3 22 00 00       	call   39c0 <printf>
}
    171d:	83 c4 10             	add    $0x10,%esp
    1720:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1723:	c9                   	leave  
    1724:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1725:	50                   	push   %eax
    1726:	50                   	push   %eax
    1727:	68 de 42 00 00       	push   $0x42de
    172c:	6a 01                	push   $0x1
    172e:	e8 8d 22 00 00       	call   39c0 <printf>
    exit();
    1733:	e8 19 21 00 00       	call   3851 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    1738:	50                   	push   %eax
    1739:	50                   	push   %eax
    173a:	68 58 43 00 00       	push   $0x4358
    173f:	6a 01                	push   $0x1
    1741:	e8 7a 22 00 00       	call   39c0 <printf>
    exit();
    1746:	e8 06 21 00 00       	call   3851 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    174b:	52                   	push   %edx
    174c:	52                   	push   %edx
    174d:	68 e8 4e 00 00       	push   $0x4ee8
    1752:	6a 01                	push   $0x1
    1754:	e8 67 22 00 00       	call   39c0 <printf>
    exit();
    1759:	e8 f3 20 00 00       	call   3851 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    175e:	50                   	push   %eax
    175f:	50                   	push   %eax
    1760:	68 3a 43 00 00       	push   $0x433a
    1765:	6a 01                	push   $0x1
    1767:	e8 54 22 00 00       	call   39c0 <printf>
    exit();
    176c:	e8 e0 20 00 00       	call   3851 <exit>
    printf(1, "read lf2 failed\n");
    1771:	51                   	push   %ecx
    1772:	51                   	push   %ecx
    1773:	68 29 43 00 00       	push   $0x4329
    1778:	6a 01                	push   $0x1
    177a:	e8 41 22 00 00       	call   39c0 <printf>
    exit();
    177f:	e8 cd 20 00 00       	call   3851 <exit>
    printf(1, "open lf2 failed\n");
    1784:	53                   	push   %ebx
    1785:	53                   	push   %ebx
    1786:	68 18 43 00 00       	push   $0x4318
    178b:	6a 01                	push   $0x1
    178d:	e8 2e 22 00 00       	call   39c0 <printf>
    exit();
    1792:	e8 ba 20 00 00       	call   3851 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1797:	50                   	push   %eax
    1798:	50                   	push   %eax
    1799:	68 c0 4e 00 00       	push   $0x4ec0
    179e:	6a 01                	push   $0x1
    17a0:	e8 1b 22 00 00       	call   39c0 <printf>
    exit();
    17a5:	e8 a7 20 00 00       	call   3851 <exit>
    printf(1, "link lf1 lf2 failed\n");
    17aa:	51                   	push   %ecx
    17ab:	51                   	push   %ecx
    17ac:	68 03 43 00 00       	push   $0x4303
    17b1:	6a 01                	push   $0x1
    17b3:	e8 08 22 00 00       	call   39c0 <printf>
    exit();
    17b8:	e8 94 20 00 00       	call   3851 <exit>
    printf(1, "write lf1 failed\n");
    17bd:	50                   	push   %eax
    17be:	50                   	push   %eax
    17bf:	68 f1 42 00 00       	push   $0x42f1
    17c4:	6a 01                	push   $0x1
    17c6:	e8 f5 21 00 00       	call   39c0 <printf>
    exit();
    17cb:	e8 81 20 00 00       	call   3851 <exit>

000017d0 <concreate>:
{
    17d0:	55                   	push   %ebp
    17d1:	89 e5                	mov    %esp,%ebp
    17d3:	57                   	push   %edi
    if(pid && (i % 3) == 1){
    17d4:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
{
    17d9:	56                   	push   %esi
  for(i = 0; i < 40; i++){
    17da:	31 f6                	xor    %esi,%esi
{
    17dc:	53                   	push   %ebx
    17dd:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    17e0:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    17e3:	68 81 43 00 00       	push   $0x4381
    17e8:	6a 01                	push   $0x1
    17ea:	e8 d1 21 00 00       	call   39c0 <printf>
  file[0] = 'C';
    17ef:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    17f3:	83 c4 10             	add    $0x10,%esp
    17f6:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
  for(i = 0; i < 40; i++){
    17fa:	eb 4c                	jmp    1848 <concreate+0x78>
    17fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid && (i % 3) == 1){
    1800:	89 f0                	mov    %esi,%eax
    1802:	89 f1                	mov    %esi,%ecx
    1804:	f7 e7                	mul    %edi
    1806:	d1 ea                	shr    %edx
    1808:	8d 04 52             	lea    (%edx,%edx,2),%eax
    180b:	29 c1                	sub    %eax,%ecx
    180d:	83 f9 01             	cmp    $0x1,%ecx
    1810:	0f 84 ba 00 00 00    	je     18d0 <concreate+0x100>
      fd = open(file, O_CREATE | O_RDWR);
    1816:	83 ec 08             	sub    $0x8,%esp
    1819:	68 02 02 00 00       	push   $0x202
    181e:	53                   	push   %ebx
    181f:	e8 6d 20 00 00       	call   3891 <open>
      if(fd < 0){
    1824:	83 c4 10             	add    $0x10,%esp
    1827:	85 c0                	test   %eax,%eax
    1829:	78 67                	js     1892 <concreate+0xc2>
      close(fd);
    182b:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    182e:	83 c6 01             	add    $0x1,%esi
      close(fd);
    1831:	50                   	push   %eax
    1832:	e8 42 20 00 00       	call   3879 <close>
    1837:	83 c4 10             	add    $0x10,%esp
      wait();
    183a:	e8 1a 20 00 00       	call   3859 <wait>
  for(i = 0; i < 40; i++){
    183f:	83 fe 28             	cmp    $0x28,%esi
    1842:	0f 84 aa 00 00 00    	je     18f2 <concreate+0x122>
    unlink(file);
    1848:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    184b:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    184e:	53                   	push   %ebx
    file[1] = '0' + i;
    184f:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    1852:	e8 4a 20 00 00       	call   38a1 <unlink>
    pid = fork();
    1857:	e8 ed 1f 00 00       	call   3849 <fork>
    if(pid && (i % 3) == 1){
    185c:	83 c4 10             	add    $0x10,%esp
    185f:	85 c0                	test   %eax,%eax
    1861:	75 9d                	jne    1800 <concreate+0x30>
    } else if(pid == 0 && (i % 5) == 1){
    1863:	89 f0                	mov    %esi,%eax
    1865:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    186a:	f7 e2                	mul    %edx
    186c:	c1 ea 02             	shr    $0x2,%edx
    186f:	8d 04 92             	lea    (%edx,%edx,4),%eax
    1872:	29 c6                	sub    %eax,%esi
    1874:	83 fe 01             	cmp    $0x1,%esi
    1877:	74 37                	je     18b0 <concreate+0xe0>
      fd = open(file, O_CREATE | O_RDWR);
    1879:	83 ec 08             	sub    $0x8,%esp
    187c:	68 02 02 00 00       	push   $0x202
    1881:	53                   	push   %ebx
    1882:	e8 0a 20 00 00       	call   3891 <open>
      if(fd < 0){
    1887:	83 c4 10             	add    $0x10,%esp
    188a:	85 c0                	test   %eax,%eax
    188c:	0f 89 2c 02 00 00    	jns    1abe <concreate+0x2ee>
        printf(1, "concreate create %s failed\n", file);
    1892:	83 ec 04             	sub    $0x4,%esp
    1895:	53                   	push   %ebx
    1896:	68 94 43 00 00       	push   $0x4394
    189b:	6a 01                	push   $0x1
    189d:	e8 1e 21 00 00       	call   39c0 <printf>
        exit();
    18a2:	e8 aa 1f 00 00       	call   3851 <exit>
    18a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    18ae:	66 90                	xchg   %ax,%ax
      link("C0", file);
    18b0:	83 ec 08             	sub    $0x8,%esp
    18b3:	53                   	push   %ebx
    18b4:	68 91 43 00 00       	push   $0x4391
    18b9:	e8 f3 1f 00 00       	call   38b1 <link>
    18be:	83 c4 10             	add    $0x10,%esp
      exit();
    18c1:	e8 8b 1f 00 00       	call   3851 <exit>
    18c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    18cd:	8d 76 00             	lea    0x0(%esi),%esi
      link("C0", file);
    18d0:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 40; i++){
    18d3:	83 c6 01             	add    $0x1,%esi
      link("C0", file);
    18d6:	53                   	push   %ebx
    18d7:	68 91 43 00 00       	push   $0x4391
    18dc:	e8 d0 1f 00 00       	call   38b1 <link>
    18e1:	83 c4 10             	add    $0x10,%esp
      wait();
    18e4:	e8 70 1f 00 00       	call   3859 <wait>
  for(i = 0; i < 40; i++){
    18e9:	83 fe 28             	cmp    $0x28,%esi
    18ec:	0f 85 56 ff ff ff    	jne    1848 <concreate+0x78>
  memset(fa, 0, sizeof(fa));
    18f2:	83 ec 04             	sub    $0x4,%esp
    18f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
    18f8:	6a 28                	push   $0x28
    18fa:	6a 00                	push   $0x0
    18fc:	50                   	push   %eax
    18fd:	e8 ae 1d 00 00       	call   36b0 <memset>
  fd = open(".", 0);
    1902:	5e                   	pop    %esi
    1903:	5f                   	pop    %edi
    1904:	6a 00                	push   $0x0
    1906:	68 9e 45 00 00       	push   $0x459e
    190b:	8d 7d b0             	lea    -0x50(%ebp),%edi
    190e:	e8 7e 1f 00 00       	call   3891 <open>
  n = 0;
    1913:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    191a:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    191d:	89 c6                	mov    %eax,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    191f:	90                   	nop
    1920:	83 ec 04             	sub    $0x4,%esp
    1923:	6a 10                	push   $0x10
    1925:	57                   	push   %edi
    1926:	56                   	push   %esi
    1927:	e8 3d 1f 00 00       	call   3869 <read>
    192c:	83 c4 10             	add    $0x10,%esp
    192f:	85 c0                	test   %eax,%eax
    1931:	7e 3d                	jle    1970 <concreate+0x1a0>
    if(de.inum == 0)
    1933:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    1938:	74 e6                	je     1920 <concreate+0x150>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    193a:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    193e:	75 e0                	jne    1920 <concreate+0x150>
    1940:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    1944:	75 da                	jne    1920 <concreate+0x150>
      i = de.name[1] - '0';
    1946:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    194a:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    194d:	83 f8 27             	cmp    $0x27,%eax
    1950:	0f 87 50 01 00 00    	ja     1aa6 <concreate+0x2d6>
      if(fa[i]){
    1956:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    195b:	0f 85 2d 01 00 00    	jne    1a8e <concreate+0x2be>
      fa[i] = 1;
    1961:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    1966:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
    196a:	eb b4                	jmp    1920 <concreate+0x150>
    196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    1970:	83 ec 0c             	sub    $0xc,%esp
    1973:	56                   	push   %esi
    1974:	e8 00 1f 00 00       	call   3879 <close>
  if(n != 40){
    1979:	83 c4 10             	add    $0x10,%esp
    197c:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    1980:	0f 85 f5 00 00 00    	jne    1a7b <concreate+0x2ab>
  for(i = 0; i < 40; i++){
    1986:	31 f6                	xor    %esi,%esi
    1988:	eb 48                	jmp    19d2 <concreate+0x202>
    198a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    1990:	85 ff                	test   %edi,%edi
    1992:	74 05                	je     1999 <concreate+0x1c9>
    1994:	83 fa 01             	cmp    $0x1,%edx
    1997:	74 64                	je     19fd <concreate+0x22d>
      unlink(file);
    1999:	83 ec 0c             	sub    $0xc,%esp
    199c:	53                   	push   %ebx
    199d:	e8 ff 1e 00 00       	call   38a1 <unlink>
      unlink(file);
    19a2:	89 1c 24             	mov    %ebx,(%esp)
    19a5:	e8 f7 1e 00 00       	call   38a1 <unlink>
      unlink(file);
    19aa:	89 1c 24             	mov    %ebx,(%esp)
    19ad:	e8 ef 1e 00 00       	call   38a1 <unlink>
      unlink(file);
    19b2:	89 1c 24             	mov    %ebx,(%esp)
    19b5:	e8 e7 1e 00 00       	call   38a1 <unlink>
    19ba:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    19bd:	85 ff                	test   %edi,%edi
    19bf:	0f 84 fc fe ff ff    	je     18c1 <concreate+0xf1>
      wait();
    19c5:	e8 8f 1e 00 00       	call   3859 <wait>
  for(i = 0; i < 40; i++){
    19ca:	83 c6 01             	add    $0x1,%esi
    19cd:	83 fe 28             	cmp    $0x28,%esi
    19d0:	74 7e                	je     1a50 <concreate+0x280>
    file[1] = '0' + i;
    19d2:	8d 46 30             	lea    0x30(%esi),%eax
    19d5:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    19d8:	e8 6c 1e 00 00       	call   3849 <fork>
    19dd:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    19df:	85 c0                	test   %eax,%eax
    19e1:	0f 88 80 00 00 00    	js     1a67 <concreate+0x297>
    if(((i % 3) == 0 && pid == 0) ||
    19e7:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    19ec:	f7 e6                	mul    %esi
    19ee:	d1 ea                	shr    %edx
    19f0:	8d 04 52             	lea    (%edx,%edx,2),%eax
    19f3:	89 f2                	mov    %esi,%edx
    19f5:	29 c2                	sub    %eax,%edx
    19f7:	89 d0                	mov    %edx,%eax
    19f9:	09 f8                	or     %edi,%eax
    19fb:	75 93                	jne    1990 <concreate+0x1c0>
      close(open(file, 0));
    19fd:	83 ec 08             	sub    $0x8,%esp
    1a00:	6a 00                	push   $0x0
    1a02:	53                   	push   %ebx
    1a03:	e8 89 1e 00 00       	call   3891 <open>
    1a08:	89 04 24             	mov    %eax,(%esp)
    1a0b:	e8 69 1e 00 00       	call   3879 <close>
      close(open(file, 0));
    1a10:	58                   	pop    %eax
    1a11:	5a                   	pop    %edx
    1a12:	6a 00                	push   $0x0
    1a14:	53                   	push   %ebx
    1a15:	e8 77 1e 00 00       	call   3891 <open>
    1a1a:	89 04 24             	mov    %eax,(%esp)
    1a1d:	e8 57 1e 00 00       	call   3879 <close>
      close(open(file, 0));
    1a22:	59                   	pop    %ecx
    1a23:	58                   	pop    %eax
    1a24:	6a 00                	push   $0x0
    1a26:	53                   	push   %ebx
    1a27:	e8 65 1e 00 00       	call   3891 <open>
    1a2c:	89 04 24             	mov    %eax,(%esp)
    1a2f:	e8 45 1e 00 00       	call   3879 <close>
      close(open(file, 0));
    1a34:	58                   	pop    %eax
    1a35:	5a                   	pop    %edx
    1a36:	6a 00                	push   $0x0
    1a38:	53                   	push   %ebx
    1a39:	e8 53 1e 00 00       	call   3891 <open>
    1a3e:	89 04 24             	mov    %eax,(%esp)
    1a41:	e8 33 1e 00 00       	call   3879 <close>
    1a46:	83 c4 10             	add    $0x10,%esp
    1a49:	e9 6f ff ff ff       	jmp    19bd <concreate+0x1ed>
    1a4e:	66 90                	xchg   %ax,%ax
  printf(1, "concreate ok\n");
    1a50:	83 ec 08             	sub    $0x8,%esp
    1a53:	68 e6 43 00 00       	push   $0x43e6
    1a58:	6a 01                	push   $0x1
    1a5a:	e8 61 1f 00 00       	call   39c0 <printf>
}
    1a5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1a62:	5b                   	pop    %ebx
    1a63:	5e                   	pop    %esi
    1a64:	5f                   	pop    %edi
    1a65:	5d                   	pop    %ebp
    1a66:	c3                   	ret    
      printf(1, "fork failed\n");
    1a67:	83 ec 08             	sub    $0x8,%esp
    1a6a:	68 69 4c 00 00       	push   $0x4c69
    1a6f:	6a 01                	push   $0x1
    1a71:	e8 4a 1f 00 00       	call   39c0 <printf>
      exit();
    1a76:	e8 d6 1d 00 00       	call   3851 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    1a7b:	51                   	push   %ecx
    1a7c:	51                   	push   %ecx
    1a7d:	68 0c 4f 00 00       	push   $0x4f0c
    1a82:	6a 01                	push   $0x1
    1a84:	e8 37 1f 00 00       	call   39c0 <printf>
    exit();
    1a89:	e8 c3 1d 00 00       	call   3851 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1a8e:	83 ec 04             	sub    $0x4,%esp
    1a91:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1a94:	50                   	push   %eax
    1a95:	68 c9 43 00 00       	push   $0x43c9
    1a9a:	6a 01                	push   $0x1
    1a9c:	e8 1f 1f 00 00       	call   39c0 <printf>
        exit();
    1aa1:	e8 ab 1d 00 00       	call   3851 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1aa6:	83 ec 04             	sub    $0x4,%esp
    1aa9:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1aac:	50                   	push   %eax
    1aad:	68 b0 43 00 00       	push   $0x43b0
    1ab2:	6a 01                	push   $0x1
    1ab4:	e8 07 1f 00 00       	call   39c0 <printf>
        exit();
    1ab9:	e8 93 1d 00 00       	call   3851 <exit>
      close(fd);
    1abe:	83 ec 0c             	sub    $0xc,%esp
    1ac1:	50                   	push   %eax
    1ac2:	e8 b2 1d 00 00       	call   3879 <close>
    1ac7:	83 c4 10             	add    $0x10,%esp
    1aca:	e9 f2 fd ff ff       	jmp    18c1 <concreate+0xf1>
    1acf:	90                   	nop

00001ad0 <linkunlink>:
{
    1ad0:	55                   	push   %ebp
    1ad1:	89 e5                	mov    %esp,%ebp
    1ad3:	57                   	push   %edi
    1ad4:	56                   	push   %esi
    1ad5:	53                   	push   %ebx
    1ad6:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    1ad9:	68 f4 43 00 00       	push   $0x43f4
    1ade:	6a 01                	push   $0x1
    1ae0:	e8 db 1e 00 00       	call   39c0 <printf>
  unlink("x");
    1ae5:	c7 04 24 81 46 00 00 	movl   $0x4681,(%esp)
    1aec:	e8 b0 1d 00 00       	call   38a1 <unlink>
  pid = fork();
    1af1:	e8 53 1d 00 00       	call   3849 <fork>
  if(pid < 0){
    1af6:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1af9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1afc:	85 c0                	test   %eax,%eax
    1afe:	0f 88 b6 00 00 00    	js     1bba <linkunlink+0xea>
  unsigned int x = (pid ? 1 : 97);
    1b04:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1b08:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1b0d:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    1b12:	19 ff                	sbb    %edi,%edi
    1b14:	83 e7 60             	and    $0x60,%edi
    1b17:	83 c7 01             	add    $0x1,%edi
    1b1a:	eb 1e                	jmp    1b3a <linkunlink+0x6a>
    1b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if((x % 3) == 1){
    1b20:	83 fa 01             	cmp    $0x1,%edx
    1b23:	74 7b                	je     1ba0 <linkunlink+0xd0>
      unlink("x");
    1b25:	83 ec 0c             	sub    $0xc,%esp
    1b28:	68 81 46 00 00       	push   $0x4681
    1b2d:	e8 6f 1d 00 00       	call   38a1 <unlink>
    1b32:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1b35:	83 eb 01             	sub    $0x1,%ebx
    1b38:	74 3d                	je     1b77 <linkunlink+0xa7>
    x = x * 1103515245 + 12345;
    1b3a:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    1b40:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    1b46:	89 f8                	mov    %edi,%eax
    1b48:	f7 e6                	mul    %esi
    1b4a:	d1 ea                	shr    %edx
    1b4c:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1b4f:	89 fa                	mov    %edi,%edx
    1b51:	29 c2                	sub    %eax,%edx
    1b53:	75 cb                	jne    1b20 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1b55:	83 ec 08             	sub    $0x8,%esp
    1b58:	68 02 02 00 00       	push   $0x202
    1b5d:	68 81 46 00 00       	push   $0x4681
    1b62:	e8 2a 1d 00 00       	call   3891 <open>
    1b67:	89 04 24             	mov    %eax,(%esp)
    1b6a:	e8 0a 1d 00 00       	call   3879 <close>
    1b6f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1b72:	83 eb 01             	sub    $0x1,%ebx
    1b75:	75 c3                	jne    1b3a <linkunlink+0x6a>
  if(pid)
    1b77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1b7a:	85 c0                	test   %eax,%eax
    1b7c:	74 4f                	je     1bcd <linkunlink+0xfd>
    wait();
    1b7e:	e8 d6 1c 00 00       	call   3859 <wait>
  printf(1, "linkunlink ok\n");
    1b83:	83 ec 08             	sub    $0x8,%esp
    1b86:	68 09 44 00 00       	push   $0x4409
    1b8b:	6a 01                	push   $0x1
    1b8d:	e8 2e 1e 00 00       	call   39c0 <printf>
}
    1b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1b95:	5b                   	pop    %ebx
    1b96:	5e                   	pop    %esi
    1b97:	5f                   	pop    %edi
    1b98:	5d                   	pop    %ebp
    1b99:	c3                   	ret    
    1b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      link("cat", "x");
    1ba0:	83 ec 08             	sub    $0x8,%esp
    1ba3:	68 81 46 00 00       	push   $0x4681
    1ba8:	68 05 44 00 00       	push   $0x4405
    1bad:	e8 ff 1c 00 00       	call   38b1 <link>
    1bb2:	83 c4 10             	add    $0x10,%esp
    1bb5:	e9 7b ff ff ff       	jmp    1b35 <linkunlink+0x65>
    printf(1, "fork failed\n");
    1bba:	52                   	push   %edx
    1bbb:	52                   	push   %edx
    1bbc:	68 69 4c 00 00       	push   $0x4c69
    1bc1:	6a 01                	push   $0x1
    1bc3:	e8 f8 1d 00 00       	call   39c0 <printf>
    exit();
    1bc8:	e8 84 1c 00 00       	call   3851 <exit>
    exit();
    1bcd:	e8 7f 1c 00 00       	call   3851 <exit>
    1bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001be0 <bigdir>:
{
    1be0:	55                   	push   %ebp
    1be1:	89 e5                	mov    %esp,%ebp
    1be3:	57                   	push   %edi
    1be4:	56                   	push   %esi
    1be5:	53                   	push   %ebx
    1be6:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1be9:	68 18 44 00 00       	push   $0x4418
    1bee:	6a 01                	push   $0x1
    1bf0:	e8 cb 1d 00 00       	call   39c0 <printf>
  unlink("bd");
    1bf5:	c7 04 24 25 44 00 00 	movl   $0x4425,(%esp)
    1bfc:	e8 a0 1c 00 00       	call   38a1 <unlink>
  fd = open("bd", O_CREATE);
    1c01:	5a                   	pop    %edx
    1c02:	59                   	pop    %ecx
    1c03:	68 00 02 00 00       	push   $0x200
    1c08:	68 25 44 00 00       	push   $0x4425
    1c0d:	e8 7f 1c 00 00       	call   3891 <open>
  if(fd < 0){
    1c12:	83 c4 10             	add    $0x10,%esp
    1c15:	85 c0                	test   %eax,%eax
    1c17:	0f 88 de 00 00 00    	js     1cfb <bigdir+0x11b>
  close(fd);
    1c1d:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 500; i++){
    1c20:	31 f6                	xor    %esi,%esi
    1c22:	8d 7d de             	lea    -0x22(%ebp),%edi
  close(fd);
    1c25:	50                   	push   %eax
    1c26:	e8 4e 1c 00 00       	call   3879 <close>
    1c2b:	83 c4 10             	add    $0x10,%esp
    1c2e:	66 90                	xchg   %ax,%ax
    name[1] = '0' + (i / 64);
    1c30:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    1c32:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    1c35:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1c39:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    1c3c:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1c3d:	83 c0 30             	add    $0x30,%eax
    if(link("bd", name) != 0){
    1c40:	68 25 44 00 00       	push   $0x4425
    name[1] = '0' + (i / 64);
    1c45:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1c48:	89 f0                	mov    %esi,%eax
    1c4a:	83 e0 3f             	and    $0x3f,%eax
    name[3] = '\0';
    1c4d:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[2] = '0' + (i % 64);
    1c51:	83 c0 30             	add    $0x30,%eax
    1c54:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    1c57:	e8 55 1c 00 00       	call   38b1 <link>
    1c5c:	83 c4 10             	add    $0x10,%esp
    1c5f:	89 c3                	mov    %eax,%ebx
    1c61:	85 c0                	test   %eax,%eax
    1c63:	75 6e                	jne    1cd3 <bigdir+0xf3>
  for(i = 0; i < 500; i++){
    1c65:	83 c6 01             	add    $0x1,%esi
    1c68:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1c6e:	75 c0                	jne    1c30 <bigdir+0x50>
  unlink("bd");
    1c70:	83 ec 0c             	sub    $0xc,%esp
    1c73:	68 25 44 00 00       	push   $0x4425
    1c78:	e8 24 1c 00 00       	call   38a1 <unlink>
    1c7d:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + (i / 64);
    1c80:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    1c82:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    1c85:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1c89:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    1c8c:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1c8d:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    1c90:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1c94:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1c97:	89 d8                	mov    %ebx,%eax
    1c99:	83 e0 3f             	and    $0x3f,%eax
    1c9c:	83 c0 30             	add    $0x30,%eax
    1c9f:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    1ca2:	e8 fa 1b 00 00       	call   38a1 <unlink>
    1ca7:	83 c4 10             	add    $0x10,%esp
    1caa:	85 c0                	test   %eax,%eax
    1cac:	75 39                	jne    1ce7 <bigdir+0x107>
  for(i = 0; i < 500; i++){
    1cae:	83 c3 01             	add    $0x1,%ebx
    1cb1:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1cb7:	75 c7                	jne    1c80 <bigdir+0xa0>
  printf(1, "bigdir ok\n");
    1cb9:	83 ec 08             	sub    $0x8,%esp
    1cbc:	68 67 44 00 00       	push   $0x4467
    1cc1:	6a 01                	push   $0x1
    1cc3:	e8 f8 1c 00 00       	call   39c0 <printf>
    1cc8:	83 c4 10             	add    $0x10,%esp
}
    1ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1cce:	5b                   	pop    %ebx
    1ccf:	5e                   	pop    %esi
    1cd0:	5f                   	pop    %edi
    1cd1:	5d                   	pop    %ebp
    1cd2:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    1cd3:	83 ec 08             	sub    $0x8,%esp
    1cd6:	68 3e 44 00 00       	push   $0x443e
    1cdb:	6a 01                	push   $0x1
    1cdd:	e8 de 1c 00 00       	call   39c0 <printf>
      exit();
    1ce2:	e8 6a 1b 00 00       	call   3851 <exit>
      printf(1, "bigdir unlink failed");
    1ce7:	83 ec 08             	sub    $0x8,%esp
    1cea:	68 52 44 00 00       	push   $0x4452
    1cef:	6a 01                	push   $0x1
    1cf1:	e8 ca 1c 00 00       	call   39c0 <printf>
      exit();
    1cf6:	e8 56 1b 00 00       	call   3851 <exit>
    printf(1, "bigdir create failed\n");
    1cfb:	50                   	push   %eax
    1cfc:	50                   	push   %eax
    1cfd:	68 28 44 00 00       	push   $0x4428
    1d02:	6a 01                	push   $0x1
    1d04:	e8 b7 1c 00 00       	call   39c0 <printf>
    exit();
    1d09:	e8 43 1b 00 00       	call   3851 <exit>
    1d0e:	66 90                	xchg   %ax,%ax

00001d10 <subdir>:
{
    1d10:	55                   	push   %ebp
    1d11:	89 e5                	mov    %esp,%ebp
    1d13:	53                   	push   %ebx
    1d14:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    1d17:	68 72 44 00 00       	push   $0x4472
    1d1c:	6a 01                	push   $0x1
    1d1e:	e8 9d 1c 00 00       	call   39c0 <printf>
  unlink("ff");
    1d23:	c7 04 24 fb 44 00 00 	movl   $0x44fb,(%esp)
    1d2a:	e8 72 1b 00 00       	call   38a1 <unlink>
  if(mkdir("dd") != 0){
    1d2f:	c7 04 24 98 45 00 00 	movl   $0x4598,(%esp)
    1d36:	e8 7e 1b 00 00       	call   38b9 <mkdir>
    1d3b:	83 c4 10             	add    $0x10,%esp
    1d3e:	85 c0                	test   %eax,%eax
    1d40:	0f 85 b3 05 00 00    	jne    22f9 <subdir+0x5e9>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d46:	83 ec 08             	sub    $0x8,%esp
    1d49:	68 02 02 00 00       	push   $0x202
    1d4e:	68 d1 44 00 00       	push   $0x44d1
    1d53:	e8 39 1b 00 00       	call   3891 <open>
  if(fd < 0){
    1d58:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d5b:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d5d:	85 c0                	test   %eax,%eax
    1d5f:	0f 88 81 05 00 00    	js     22e6 <subdir+0x5d6>
  write(fd, "ff", 2);
    1d65:	83 ec 04             	sub    $0x4,%esp
    1d68:	6a 02                	push   $0x2
    1d6a:	68 fb 44 00 00       	push   $0x44fb
    1d6f:	50                   	push   %eax
    1d70:	e8 fc 1a 00 00       	call   3871 <write>
  close(fd);
    1d75:	89 1c 24             	mov    %ebx,(%esp)
    1d78:	e8 fc 1a 00 00       	call   3879 <close>
  if(unlink("dd") >= 0){
    1d7d:	c7 04 24 98 45 00 00 	movl   $0x4598,(%esp)
    1d84:	e8 18 1b 00 00       	call   38a1 <unlink>
    1d89:	83 c4 10             	add    $0x10,%esp
    1d8c:	85 c0                	test   %eax,%eax
    1d8e:	0f 89 3f 05 00 00    	jns    22d3 <subdir+0x5c3>
  if(mkdir("/dd/dd") != 0){
    1d94:	83 ec 0c             	sub    $0xc,%esp
    1d97:	68 ac 44 00 00       	push   $0x44ac
    1d9c:	e8 18 1b 00 00       	call   38b9 <mkdir>
    1da1:	83 c4 10             	add    $0x10,%esp
    1da4:	85 c0                	test   %eax,%eax
    1da6:	0f 85 14 05 00 00    	jne    22c0 <subdir+0x5b0>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1dac:	83 ec 08             	sub    $0x8,%esp
    1daf:	68 02 02 00 00       	push   $0x202
    1db4:	68 ce 44 00 00       	push   $0x44ce
    1db9:	e8 d3 1a 00 00       	call   3891 <open>
  if(fd < 0){
    1dbe:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1dc1:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1dc3:	85 c0                	test   %eax,%eax
    1dc5:	0f 88 24 04 00 00    	js     21ef <subdir+0x4df>
  write(fd, "FF", 2);
    1dcb:	83 ec 04             	sub    $0x4,%esp
    1dce:	6a 02                	push   $0x2
    1dd0:	68 ef 44 00 00       	push   $0x44ef
    1dd5:	50                   	push   %eax
    1dd6:	e8 96 1a 00 00       	call   3871 <write>
  close(fd);
    1ddb:	89 1c 24             	mov    %ebx,(%esp)
    1dde:	e8 96 1a 00 00       	call   3879 <close>
  fd = open("dd/dd/../ff", 0);
    1de3:	58                   	pop    %eax
    1de4:	5a                   	pop    %edx
    1de5:	6a 00                	push   $0x0
    1de7:	68 f2 44 00 00       	push   $0x44f2
    1dec:	e8 a0 1a 00 00       	call   3891 <open>
  if(fd < 0){
    1df1:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/../ff", 0);
    1df4:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1df6:	85 c0                	test   %eax,%eax
    1df8:	0f 88 de 03 00 00    	js     21dc <subdir+0x4cc>
  cc = read(fd, buf, sizeof(buf));
    1dfe:	83 ec 04             	sub    $0x4,%esp
    1e01:	68 00 20 00 00       	push   $0x2000
    1e06:	68 60 85 00 00       	push   $0x8560
    1e0b:	50                   	push   %eax
    1e0c:	e8 58 1a 00 00       	call   3869 <read>
  if(cc != 2 || buf[0] != 'f'){
    1e11:	83 c4 10             	add    $0x10,%esp
    1e14:	83 f8 02             	cmp    $0x2,%eax
    1e17:	0f 85 3a 03 00 00    	jne    2157 <subdir+0x447>
    1e1d:	80 3d 60 85 00 00 66 	cmpb   $0x66,0x8560
    1e24:	0f 85 2d 03 00 00    	jne    2157 <subdir+0x447>
  close(fd);
    1e2a:	83 ec 0c             	sub    $0xc,%esp
    1e2d:	53                   	push   %ebx
    1e2e:	e8 46 1a 00 00       	call   3879 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1e33:	5b                   	pop    %ebx
    1e34:	58                   	pop    %eax
    1e35:	68 32 45 00 00       	push   $0x4532
    1e3a:	68 ce 44 00 00       	push   $0x44ce
    1e3f:	e8 6d 1a 00 00       	call   38b1 <link>
    1e44:	83 c4 10             	add    $0x10,%esp
    1e47:	85 c0                	test   %eax,%eax
    1e49:	0f 85 c6 03 00 00    	jne    2215 <subdir+0x505>
  if(unlink("dd/dd/ff") != 0){
    1e4f:	83 ec 0c             	sub    $0xc,%esp
    1e52:	68 ce 44 00 00       	push   $0x44ce
    1e57:	e8 45 1a 00 00       	call   38a1 <unlink>
    1e5c:	83 c4 10             	add    $0x10,%esp
    1e5f:	85 c0                	test   %eax,%eax
    1e61:	0f 85 16 03 00 00    	jne    217d <subdir+0x46d>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1e67:	83 ec 08             	sub    $0x8,%esp
    1e6a:	6a 00                	push   $0x0
    1e6c:	68 ce 44 00 00       	push   $0x44ce
    1e71:	e8 1b 1a 00 00       	call   3891 <open>
    1e76:	83 c4 10             	add    $0x10,%esp
    1e79:	85 c0                	test   %eax,%eax
    1e7b:	0f 89 2c 04 00 00    	jns    22ad <subdir+0x59d>
  if(chdir("dd") != 0){
    1e81:	83 ec 0c             	sub    $0xc,%esp
    1e84:	68 98 45 00 00       	push   $0x4598
    1e89:	e8 33 1a 00 00       	call   38c1 <chdir>
    1e8e:	83 c4 10             	add    $0x10,%esp
    1e91:	85 c0                	test   %eax,%eax
    1e93:	0f 85 01 04 00 00    	jne    229a <subdir+0x58a>
  if(chdir("dd/../../dd") != 0){
    1e99:	83 ec 0c             	sub    $0xc,%esp
    1e9c:	68 66 45 00 00       	push   $0x4566
    1ea1:	e8 1b 1a 00 00       	call   38c1 <chdir>
    1ea6:	83 c4 10             	add    $0x10,%esp
    1ea9:	85 c0                	test   %eax,%eax
    1eab:	0f 85 b9 02 00 00    	jne    216a <subdir+0x45a>
  if(chdir("dd/../../../dd") != 0){
    1eb1:	83 ec 0c             	sub    $0xc,%esp
    1eb4:	68 8c 45 00 00       	push   $0x458c
    1eb9:	e8 03 1a 00 00       	call   38c1 <chdir>
    1ebe:	83 c4 10             	add    $0x10,%esp
    1ec1:	85 c0                	test   %eax,%eax
    1ec3:	0f 85 a1 02 00 00    	jne    216a <subdir+0x45a>
  if(chdir("./..") != 0){
    1ec9:	83 ec 0c             	sub    $0xc,%esp
    1ecc:	68 9b 45 00 00       	push   $0x459b
    1ed1:	e8 eb 19 00 00       	call   38c1 <chdir>
    1ed6:	83 c4 10             	add    $0x10,%esp
    1ed9:	85 c0                	test   %eax,%eax
    1edb:	0f 85 21 03 00 00    	jne    2202 <subdir+0x4f2>
  fd = open("dd/dd/ffff", 0);
    1ee1:	83 ec 08             	sub    $0x8,%esp
    1ee4:	6a 00                	push   $0x0
    1ee6:	68 32 45 00 00       	push   $0x4532
    1eeb:	e8 a1 19 00 00       	call   3891 <open>
  if(fd < 0){
    1ef0:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ffff", 0);
    1ef3:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1ef5:	85 c0                	test   %eax,%eax
    1ef7:	0f 88 e0 04 00 00    	js     23dd <subdir+0x6cd>
  if(read(fd, buf, sizeof(buf)) != 2){
    1efd:	83 ec 04             	sub    $0x4,%esp
    1f00:	68 00 20 00 00       	push   $0x2000
    1f05:	68 60 85 00 00       	push   $0x8560
    1f0a:	50                   	push   %eax
    1f0b:	e8 59 19 00 00       	call   3869 <read>
    1f10:	83 c4 10             	add    $0x10,%esp
    1f13:	83 f8 02             	cmp    $0x2,%eax
    1f16:	0f 85 ae 04 00 00    	jne    23ca <subdir+0x6ba>
  close(fd);
    1f1c:	83 ec 0c             	sub    $0xc,%esp
    1f1f:	53                   	push   %ebx
    1f20:	e8 54 19 00 00       	call   3879 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f25:	59                   	pop    %ecx
    1f26:	5b                   	pop    %ebx
    1f27:	6a 00                	push   $0x0
    1f29:	68 ce 44 00 00       	push   $0x44ce
    1f2e:	e8 5e 19 00 00       	call   3891 <open>
    1f33:	83 c4 10             	add    $0x10,%esp
    1f36:	85 c0                	test   %eax,%eax
    1f38:	0f 89 65 02 00 00    	jns    21a3 <subdir+0x493>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1f3e:	83 ec 08             	sub    $0x8,%esp
    1f41:	68 02 02 00 00       	push   $0x202
    1f46:	68 e6 45 00 00       	push   $0x45e6
    1f4b:	e8 41 19 00 00       	call   3891 <open>
    1f50:	83 c4 10             	add    $0x10,%esp
    1f53:	85 c0                	test   %eax,%eax
    1f55:	0f 89 35 02 00 00    	jns    2190 <subdir+0x480>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1f5b:	83 ec 08             	sub    $0x8,%esp
    1f5e:	68 02 02 00 00       	push   $0x202
    1f63:	68 0b 46 00 00       	push   $0x460b
    1f68:	e8 24 19 00 00       	call   3891 <open>
    1f6d:	83 c4 10             	add    $0x10,%esp
    1f70:	85 c0                	test   %eax,%eax
    1f72:	0f 89 0f 03 00 00    	jns    2287 <subdir+0x577>
  if(open("dd", O_CREATE) >= 0){
    1f78:	83 ec 08             	sub    $0x8,%esp
    1f7b:	68 00 02 00 00       	push   $0x200
    1f80:	68 98 45 00 00       	push   $0x4598
    1f85:	e8 07 19 00 00       	call   3891 <open>
    1f8a:	83 c4 10             	add    $0x10,%esp
    1f8d:	85 c0                	test   %eax,%eax
    1f8f:	0f 89 df 02 00 00    	jns    2274 <subdir+0x564>
  if(open("dd", O_RDWR) >= 0){
    1f95:	83 ec 08             	sub    $0x8,%esp
    1f98:	6a 02                	push   $0x2
    1f9a:	68 98 45 00 00       	push   $0x4598
    1f9f:	e8 ed 18 00 00       	call   3891 <open>
    1fa4:	83 c4 10             	add    $0x10,%esp
    1fa7:	85 c0                	test   %eax,%eax
    1fa9:	0f 89 b2 02 00 00    	jns    2261 <subdir+0x551>
  if(open("dd", O_WRONLY) >= 0){
    1faf:	83 ec 08             	sub    $0x8,%esp
    1fb2:	6a 01                	push   $0x1
    1fb4:	68 98 45 00 00       	push   $0x4598
    1fb9:	e8 d3 18 00 00       	call   3891 <open>
    1fbe:	83 c4 10             	add    $0x10,%esp
    1fc1:	85 c0                	test   %eax,%eax
    1fc3:	0f 89 85 02 00 00    	jns    224e <subdir+0x53e>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1fc9:	83 ec 08             	sub    $0x8,%esp
    1fcc:	68 7a 46 00 00       	push   $0x467a
    1fd1:	68 e6 45 00 00       	push   $0x45e6
    1fd6:	e8 d6 18 00 00       	call   38b1 <link>
    1fdb:	83 c4 10             	add    $0x10,%esp
    1fde:	85 c0                	test   %eax,%eax
    1fe0:	0f 84 55 02 00 00    	je     223b <subdir+0x52b>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1fe6:	83 ec 08             	sub    $0x8,%esp
    1fe9:	68 7a 46 00 00       	push   $0x467a
    1fee:	68 0b 46 00 00       	push   $0x460b
    1ff3:	e8 b9 18 00 00       	call   38b1 <link>
    1ff8:	83 c4 10             	add    $0x10,%esp
    1ffb:	85 c0                	test   %eax,%eax
    1ffd:	0f 84 25 02 00 00    	je     2228 <subdir+0x518>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2003:	83 ec 08             	sub    $0x8,%esp
    2006:	68 32 45 00 00       	push   $0x4532
    200b:	68 d1 44 00 00       	push   $0x44d1
    2010:	e8 9c 18 00 00       	call   38b1 <link>
    2015:	83 c4 10             	add    $0x10,%esp
    2018:	85 c0                	test   %eax,%eax
    201a:	0f 84 a9 01 00 00    	je     21c9 <subdir+0x4b9>
  if(mkdir("dd/ff/ff") == 0){
    2020:	83 ec 0c             	sub    $0xc,%esp
    2023:	68 e6 45 00 00       	push   $0x45e6
    2028:	e8 8c 18 00 00       	call   38b9 <mkdir>
    202d:	83 c4 10             	add    $0x10,%esp
    2030:	85 c0                	test   %eax,%eax
    2032:	0f 84 7e 01 00 00    	je     21b6 <subdir+0x4a6>
  if(mkdir("dd/xx/ff") == 0){
    2038:	83 ec 0c             	sub    $0xc,%esp
    203b:	68 0b 46 00 00       	push   $0x460b
    2040:	e8 74 18 00 00       	call   38b9 <mkdir>
    2045:	83 c4 10             	add    $0x10,%esp
    2048:	85 c0                	test   %eax,%eax
    204a:	0f 84 67 03 00 00    	je     23b7 <subdir+0x6a7>
  if(mkdir("dd/dd/ffff") == 0){
    2050:	83 ec 0c             	sub    $0xc,%esp
    2053:	68 32 45 00 00       	push   $0x4532
    2058:	e8 5c 18 00 00       	call   38b9 <mkdir>
    205d:	83 c4 10             	add    $0x10,%esp
    2060:	85 c0                	test   %eax,%eax
    2062:	0f 84 3c 03 00 00    	je     23a4 <subdir+0x694>
  if(unlink("dd/xx/ff") == 0){
    2068:	83 ec 0c             	sub    $0xc,%esp
    206b:	68 0b 46 00 00       	push   $0x460b
    2070:	e8 2c 18 00 00       	call   38a1 <unlink>
    2075:	83 c4 10             	add    $0x10,%esp
    2078:	85 c0                	test   %eax,%eax
    207a:	0f 84 11 03 00 00    	je     2391 <subdir+0x681>
  if(unlink("dd/ff/ff") == 0){
    2080:	83 ec 0c             	sub    $0xc,%esp
    2083:	68 e6 45 00 00       	push   $0x45e6
    2088:	e8 14 18 00 00       	call   38a1 <unlink>
    208d:	83 c4 10             	add    $0x10,%esp
    2090:	85 c0                	test   %eax,%eax
    2092:	0f 84 e6 02 00 00    	je     237e <subdir+0x66e>
  if(chdir("dd/ff") == 0){
    2098:	83 ec 0c             	sub    $0xc,%esp
    209b:	68 d1 44 00 00       	push   $0x44d1
    20a0:	e8 1c 18 00 00       	call   38c1 <chdir>
    20a5:	83 c4 10             	add    $0x10,%esp
    20a8:	85 c0                	test   %eax,%eax
    20aa:	0f 84 bb 02 00 00    	je     236b <subdir+0x65b>
  if(chdir("dd/xx") == 0){
    20b0:	83 ec 0c             	sub    $0xc,%esp
    20b3:	68 7d 46 00 00       	push   $0x467d
    20b8:	e8 04 18 00 00       	call   38c1 <chdir>
    20bd:	83 c4 10             	add    $0x10,%esp
    20c0:	85 c0                	test   %eax,%eax
    20c2:	0f 84 90 02 00 00    	je     2358 <subdir+0x648>
  if(unlink("dd/dd/ffff") != 0){
    20c8:	83 ec 0c             	sub    $0xc,%esp
    20cb:	68 32 45 00 00       	push   $0x4532
    20d0:	e8 cc 17 00 00       	call   38a1 <unlink>
    20d5:	83 c4 10             	add    $0x10,%esp
    20d8:	85 c0                	test   %eax,%eax
    20da:	0f 85 9d 00 00 00    	jne    217d <subdir+0x46d>
  if(unlink("dd/ff") != 0){
    20e0:	83 ec 0c             	sub    $0xc,%esp
    20e3:	68 d1 44 00 00       	push   $0x44d1
    20e8:	e8 b4 17 00 00       	call   38a1 <unlink>
    20ed:	83 c4 10             	add    $0x10,%esp
    20f0:	85 c0                	test   %eax,%eax
    20f2:	0f 85 4d 02 00 00    	jne    2345 <subdir+0x635>
  if(unlink("dd") == 0){
    20f8:	83 ec 0c             	sub    $0xc,%esp
    20fb:	68 98 45 00 00       	push   $0x4598
    2100:	e8 9c 17 00 00       	call   38a1 <unlink>
    2105:	83 c4 10             	add    $0x10,%esp
    2108:	85 c0                	test   %eax,%eax
    210a:	0f 84 22 02 00 00    	je     2332 <subdir+0x622>
  if(unlink("dd/dd") < 0){
    2110:	83 ec 0c             	sub    $0xc,%esp
    2113:	68 ad 44 00 00       	push   $0x44ad
    2118:	e8 84 17 00 00       	call   38a1 <unlink>
    211d:	83 c4 10             	add    $0x10,%esp
    2120:	85 c0                	test   %eax,%eax
    2122:	0f 88 f7 01 00 00    	js     231f <subdir+0x60f>
  if(unlink("dd") < 0){
    2128:	83 ec 0c             	sub    $0xc,%esp
    212b:	68 98 45 00 00       	push   $0x4598
    2130:	e8 6c 17 00 00       	call   38a1 <unlink>
    2135:	83 c4 10             	add    $0x10,%esp
    2138:	85 c0                	test   %eax,%eax
    213a:	0f 88 cc 01 00 00    	js     230c <subdir+0x5fc>
  printf(1, "subdir ok\n");
    2140:	83 ec 08             	sub    $0x8,%esp
    2143:	68 7a 47 00 00       	push   $0x477a
    2148:	6a 01                	push   $0x1
    214a:	e8 71 18 00 00       	call   39c0 <printf>
}
    214f:	83 c4 10             	add    $0x10,%esp
    2152:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2155:	c9                   	leave  
    2156:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    2157:	50                   	push   %eax
    2158:	50                   	push   %eax
    2159:	68 17 45 00 00       	push   $0x4517
    215e:	6a 01                	push   $0x1
    2160:	e8 5b 18 00 00       	call   39c0 <printf>
    exit();
    2165:	e8 e7 16 00 00       	call   3851 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    216a:	50                   	push   %eax
    216b:	50                   	push   %eax
    216c:	68 72 45 00 00       	push   $0x4572
    2171:	6a 01                	push   $0x1
    2173:	e8 48 18 00 00       	call   39c0 <printf>
    exit();
    2178:	e8 d4 16 00 00       	call   3851 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    217d:	52                   	push   %edx
    217e:	52                   	push   %edx
    217f:	68 3d 45 00 00       	push   $0x453d
    2184:	6a 01                	push   $0x1
    2186:	e8 35 18 00 00       	call   39c0 <printf>
    exit();
    218b:	e8 c1 16 00 00       	call   3851 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2190:	50                   	push   %eax
    2191:	50                   	push   %eax
    2192:	68 ef 45 00 00       	push   $0x45ef
    2197:	6a 01                	push   $0x1
    2199:	e8 22 18 00 00       	call   39c0 <printf>
    exit();
    219e:	e8 ae 16 00 00       	call   3851 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    21a3:	52                   	push   %edx
    21a4:	52                   	push   %edx
    21a5:	68 b0 4f 00 00       	push   $0x4fb0
    21aa:	6a 01                	push   $0x1
    21ac:	e8 0f 18 00 00       	call   39c0 <printf>
    exit();
    21b1:	e8 9b 16 00 00       	call   3851 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    21b6:	52                   	push   %edx
    21b7:	52                   	push   %edx
    21b8:	68 83 46 00 00       	push   $0x4683
    21bd:	6a 01                	push   $0x1
    21bf:	e8 fc 17 00 00       	call   39c0 <printf>
    exit();
    21c4:	e8 88 16 00 00       	call   3851 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    21c9:	51                   	push   %ecx
    21ca:	51                   	push   %ecx
    21cb:	68 20 50 00 00       	push   $0x5020
    21d0:	6a 01                	push   $0x1
    21d2:	e8 e9 17 00 00       	call   39c0 <printf>
    exit();
    21d7:	e8 75 16 00 00       	call   3851 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    21dc:	50                   	push   %eax
    21dd:	50                   	push   %eax
    21de:	68 fe 44 00 00       	push   $0x44fe
    21e3:	6a 01                	push   $0x1
    21e5:	e8 d6 17 00 00       	call   39c0 <printf>
    exit();
    21ea:	e8 62 16 00 00       	call   3851 <exit>
    printf(1, "create dd/dd/ff failed\n");
    21ef:	51                   	push   %ecx
    21f0:	51                   	push   %ecx
    21f1:	68 d7 44 00 00       	push   $0x44d7
    21f6:	6a 01                	push   $0x1
    21f8:	e8 c3 17 00 00       	call   39c0 <printf>
    exit();
    21fd:	e8 4f 16 00 00       	call   3851 <exit>
    printf(1, "chdir ./.. failed\n");
    2202:	50                   	push   %eax
    2203:	50                   	push   %eax
    2204:	68 a0 45 00 00       	push   $0x45a0
    2209:	6a 01                	push   $0x1
    220b:	e8 b0 17 00 00       	call   39c0 <printf>
    exit();
    2210:	e8 3c 16 00 00       	call   3851 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2215:	51                   	push   %ecx
    2216:	51                   	push   %ecx
    2217:	68 68 4f 00 00       	push   $0x4f68
    221c:	6a 01                	push   $0x1
    221e:	e8 9d 17 00 00       	call   39c0 <printf>
    exit();
    2223:	e8 29 16 00 00       	call   3851 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2228:	53                   	push   %ebx
    2229:	53                   	push   %ebx
    222a:	68 fc 4f 00 00       	push   $0x4ffc
    222f:	6a 01                	push   $0x1
    2231:	e8 8a 17 00 00       	call   39c0 <printf>
    exit();
    2236:	e8 16 16 00 00       	call   3851 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    223b:	50                   	push   %eax
    223c:	50                   	push   %eax
    223d:	68 d8 4f 00 00       	push   $0x4fd8
    2242:	6a 01                	push   $0x1
    2244:	e8 77 17 00 00       	call   39c0 <printf>
    exit();
    2249:	e8 03 16 00 00       	call   3851 <exit>
    printf(1, "open dd wronly succeeded!\n");
    224e:	50                   	push   %eax
    224f:	50                   	push   %eax
    2250:	68 5f 46 00 00       	push   $0x465f
    2255:	6a 01                	push   $0x1
    2257:	e8 64 17 00 00       	call   39c0 <printf>
    exit();
    225c:	e8 f0 15 00 00       	call   3851 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    2261:	50                   	push   %eax
    2262:	50                   	push   %eax
    2263:	68 46 46 00 00       	push   $0x4646
    2268:	6a 01                	push   $0x1
    226a:	e8 51 17 00 00       	call   39c0 <printf>
    exit();
    226f:	e8 dd 15 00 00       	call   3851 <exit>
    printf(1, "create dd succeeded!\n");
    2274:	50                   	push   %eax
    2275:	50                   	push   %eax
    2276:	68 30 46 00 00       	push   $0x4630
    227b:	6a 01                	push   $0x1
    227d:	e8 3e 17 00 00       	call   39c0 <printf>
    exit();
    2282:	e8 ca 15 00 00       	call   3851 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    2287:	50                   	push   %eax
    2288:	50                   	push   %eax
    2289:	68 14 46 00 00       	push   $0x4614
    228e:	6a 01                	push   $0x1
    2290:	e8 2b 17 00 00       	call   39c0 <printf>
    exit();
    2295:	e8 b7 15 00 00       	call   3851 <exit>
    printf(1, "chdir dd failed\n");
    229a:	50                   	push   %eax
    229b:	50                   	push   %eax
    229c:	68 55 45 00 00       	push   $0x4555
    22a1:	6a 01                	push   $0x1
    22a3:	e8 18 17 00 00       	call   39c0 <printf>
    exit();
    22a8:	e8 a4 15 00 00       	call   3851 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    22ad:	50                   	push   %eax
    22ae:	50                   	push   %eax
    22af:	68 8c 4f 00 00       	push   $0x4f8c
    22b4:	6a 01                	push   $0x1
    22b6:	e8 05 17 00 00       	call   39c0 <printf>
    exit();
    22bb:	e8 91 15 00 00       	call   3851 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    22c0:	53                   	push   %ebx
    22c1:	53                   	push   %ebx
    22c2:	68 b3 44 00 00       	push   $0x44b3
    22c7:	6a 01                	push   $0x1
    22c9:	e8 f2 16 00 00       	call   39c0 <printf>
    exit();
    22ce:	e8 7e 15 00 00       	call   3851 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    22d3:	50                   	push   %eax
    22d4:	50                   	push   %eax
    22d5:	68 40 4f 00 00       	push   $0x4f40
    22da:	6a 01                	push   $0x1
    22dc:	e8 df 16 00 00       	call   39c0 <printf>
    exit();
    22e1:	e8 6b 15 00 00       	call   3851 <exit>
    printf(1, "create dd/ff failed\n");
    22e6:	50                   	push   %eax
    22e7:	50                   	push   %eax
    22e8:	68 97 44 00 00       	push   $0x4497
    22ed:	6a 01                	push   $0x1
    22ef:	e8 cc 16 00 00       	call   39c0 <printf>
    exit();
    22f4:	e8 58 15 00 00       	call   3851 <exit>
    printf(1, "subdir mkdir dd failed\n");
    22f9:	50                   	push   %eax
    22fa:	50                   	push   %eax
    22fb:	68 7f 44 00 00       	push   $0x447f
    2300:	6a 01                	push   $0x1
    2302:	e8 b9 16 00 00       	call   39c0 <printf>
    exit();
    2307:	e8 45 15 00 00       	call   3851 <exit>
    printf(1, "unlink dd failed\n");
    230c:	50                   	push   %eax
    230d:	50                   	push   %eax
    230e:	68 68 47 00 00       	push   $0x4768
    2313:	6a 01                	push   $0x1
    2315:	e8 a6 16 00 00       	call   39c0 <printf>
    exit();
    231a:	e8 32 15 00 00       	call   3851 <exit>
    printf(1, "unlink dd/dd failed\n");
    231f:	52                   	push   %edx
    2320:	52                   	push   %edx
    2321:	68 53 47 00 00       	push   $0x4753
    2326:	6a 01                	push   $0x1
    2328:	e8 93 16 00 00       	call   39c0 <printf>
    exit();
    232d:	e8 1f 15 00 00       	call   3851 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2332:	51                   	push   %ecx
    2333:	51                   	push   %ecx
    2334:	68 44 50 00 00       	push   $0x5044
    2339:	6a 01                	push   $0x1
    233b:	e8 80 16 00 00       	call   39c0 <printf>
    exit();
    2340:	e8 0c 15 00 00       	call   3851 <exit>
    printf(1, "unlink dd/ff failed\n");
    2345:	53                   	push   %ebx
    2346:	53                   	push   %ebx
    2347:	68 3e 47 00 00       	push   $0x473e
    234c:	6a 01                	push   $0x1
    234e:	e8 6d 16 00 00       	call   39c0 <printf>
    exit();
    2353:	e8 f9 14 00 00       	call   3851 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    2358:	50                   	push   %eax
    2359:	50                   	push   %eax
    235a:	68 26 47 00 00       	push   $0x4726
    235f:	6a 01                	push   $0x1
    2361:	e8 5a 16 00 00       	call   39c0 <printf>
    exit();
    2366:	e8 e6 14 00 00       	call   3851 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    236b:	50                   	push   %eax
    236c:	50                   	push   %eax
    236d:	68 0e 47 00 00       	push   $0x470e
    2372:	6a 01                	push   $0x1
    2374:	e8 47 16 00 00       	call   39c0 <printf>
    exit();
    2379:	e8 d3 14 00 00       	call   3851 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    237e:	50                   	push   %eax
    237f:	50                   	push   %eax
    2380:	68 f2 46 00 00       	push   $0x46f2
    2385:	6a 01                	push   $0x1
    2387:	e8 34 16 00 00       	call   39c0 <printf>
    exit();
    238c:	e8 c0 14 00 00       	call   3851 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2391:	50                   	push   %eax
    2392:	50                   	push   %eax
    2393:	68 d6 46 00 00       	push   $0x46d6
    2398:	6a 01                	push   $0x1
    239a:	e8 21 16 00 00       	call   39c0 <printf>
    exit();
    239f:	e8 ad 14 00 00       	call   3851 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    23a4:	50                   	push   %eax
    23a5:	50                   	push   %eax
    23a6:	68 b9 46 00 00       	push   $0x46b9
    23ab:	6a 01                	push   $0x1
    23ad:	e8 0e 16 00 00       	call   39c0 <printf>
    exit();
    23b2:	e8 9a 14 00 00       	call   3851 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    23b7:	50                   	push   %eax
    23b8:	50                   	push   %eax
    23b9:	68 9e 46 00 00       	push   $0x469e
    23be:	6a 01                	push   $0x1
    23c0:	e8 fb 15 00 00       	call   39c0 <printf>
    exit();
    23c5:	e8 87 14 00 00       	call   3851 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    23ca:	50                   	push   %eax
    23cb:	50                   	push   %eax
    23cc:	68 cb 45 00 00       	push   $0x45cb
    23d1:	6a 01                	push   $0x1
    23d3:	e8 e8 15 00 00       	call   39c0 <printf>
    exit();
    23d8:	e8 74 14 00 00       	call   3851 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    23dd:	50                   	push   %eax
    23de:	50                   	push   %eax
    23df:	68 b3 45 00 00       	push   $0x45b3
    23e4:	6a 01                	push   $0x1
    23e6:	e8 d5 15 00 00       	call   39c0 <printf>
    exit();
    23eb:	e8 61 14 00 00       	call   3851 <exit>

000023f0 <bigwrite>:
{
    23f0:	55                   	push   %ebp
    23f1:	89 e5                	mov    %esp,%ebp
    23f3:	56                   	push   %esi
    23f4:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    23f5:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    23fa:	83 ec 08             	sub    $0x8,%esp
    23fd:	68 85 47 00 00       	push   $0x4785
    2402:	6a 01                	push   $0x1
    2404:	e8 b7 15 00 00       	call   39c0 <printf>
  unlink("bigwrite");
    2409:	c7 04 24 94 47 00 00 	movl   $0x4794,(%esp)
    2410:	e8 8c 14 00 00       	call   38a1 <unlink>
    2415:	83 c4 10             	add    $0x10,%esp
    2418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    241f:	90                   	nop
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2420:	83 ec 08             	sub    $0x8,%esp
    2423:	68 02 02 00 00       	push   $0x202
    2428:	68 94 47 00 00       	push   $0x4794
    242d:	e8 5f 14 00 00       	call   3891 <open>
    if(fd < 0){
    2432:	83 c4 10             	add    $0x10,%esp
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2435:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    2437:	85 c0                	test   %eax,%eax
    2439:	78 7e                	js     24b9 <bigwrite+0xc9>
      int cc = write(fd, buf, sz);
    243b:	83 ec 04             	sub    $0x4,%esp
    243e:	53                   	push   %ebx
    243f:	68 60 85 00 00       	push   $0x8560
    2444:	50                   	push   %eax
    2445:	e8 27 14 00 00       	call   3871 <write>
      if(cc != sz){
    244a:	83 c4 10             	add    $0x10,%esp
    244d:	39 d8                	cmp    %ebx,%eax
    244f:	75 55                	jne    24a6 <bigwrite+0xb6>
      int cc = write(fd, buf, sz);
    2451:	83 ec 04             	sub    $0x4,%esp
    2454:	53                   	push   %ebx
    2455:	68 60 85 00 00       	push   $0x8560
    245a:	56                   	push   %esi
    245b:	e8 11 14 00 00       	call   3871 <write>
      if(cc != sz){
    2460:	83 c4 10             	add    $0x10,%esp
    2463:	39 d8                	cmp    %ebx,%eax
    2465:	75 3f                	jne    24a6 <bigwrite+0xb6>
    close(fd);
    2467:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    246a:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    2470:	56                   	push   %esi
    2471:	e8 03 14 00 00       	call   3879 <close>
    unlink("bigwrite");
    2476:	c7 04 24 94 47 00 00 	movl   $0x4794,(%esp)
    247d:	e8 1f 14 00 00       	call   38a1 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2482:	83 c4 10             	add    $0x10,%esp
    2485:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    248b:	75 93                	jne    2420 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    248d:	83 ec 08             	sub    $0x8,%esp
    2490:	68 c7 47 00 00       	push   $0x47c7
    2495:	6a 01                	push   $0x1
    2497:	e8 24 15 00 00       	call   39c0 <printf>
}
    249c:	83 c4 10             	add    $0x10,%esp
    249f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    24a2:	5b                   	pop    %ebx
    24a3:	5e                   	pop    %esi
    24a4:	5d                   	pop    %ebp
    24a5:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    24a6:	50                   	push   %eax
    24a7:	53                   	push   %ebx
    24a8:	68 b5 47 00 00       	push   $0x47b5
    24ad:	6a 01                	push   $0x1
    24af:	e8 0c 15 00 00       	call   39c0 <printf>
        exit();
    24b4:	e8 98 13 00 00       	call   3851 <exit>
      printf(1, "cannot create bigwrite\n");
    24b9:	83 ec 08             	sub    $0x8,%esp
    24bc:	68 9d 47 00 00       	push   $0x479d
    24c1:	6a 01                	push   $0x1
    24c3:	e8 f8 14 00 00       	call   39c0 <printf>
      exit();
    24c8:	e8 84 13 00 00       	call   3851 <exit>
    24cd:	8d 76 00             	lea    0x0(%esi),%esi

000024d0 <bigfile>:
{
    24d0:	55                   	push   %ebp
    24d1:	89 e5                	mov    %esp,%ebp
    24d3:	57                   	push   %edi
    24d4:	56                   	push   %esi
    24d5:	53                   	push   %ebx
    24d6:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    24d9:	68 d4 47 00 00       	push   $0x47d4
    24de:	6a 01                	push   $0x1
    24e0:	e8 db 14 00 00       	call   39c0 <printf>
  unlink("bigfile");
    24e5:	c7 04 24 f0 47 00 00 	movl   $0x47f0,(%esp)
    24ec:	e8 b0 13 00 00       	call   38a1 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    24f1:	58                   	pop    %eax
    24f2:	5a                   	pop    %edx
    24f3:	68 02 02 00 00       	push   $0x202
    24f8:	68 f0 47 00 00       	push   $0x47f0
    24fd:	e8 8f 13 00 00       	call   3891 <open>
  if(fd < 0){
    2502:	83 c4 10             	add    $0x10,%esp
    2505:	85 c0                	test   %eax,%eax
    2507:	0f 88 5e 01 00 00    	js     266b <bigfile+0x19b>
    250d:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    250f:	31 db                	xor    %ebx,%ebx
    2511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(buf, i, 600);
    2518:	83 ec 04             	sub    $0x4,%esp
    251b:	68 58 02 00 00       	push   $0x258
    2520:	53                   	push   %ebx
    2521:	68 60 85 00 00       	push   $0x8560
    2526:	e8 85 11 00 00       	call   36b0 <memset>
    if(write(fd, buf, 600) != 600){
    252b:	83 c4 0c             	add    $0xc,%esp
    252e:	68 58 02 00 00       	push   $0x258
    2533:	68 60 85 00 00       	push   $0x8560
    2538:	56                   	push   %esi
    2539:	e8 33 13 00 00       	call   3871 <write>
    253e:	83 c4 10             	add    $0x10,%esp
    2541:	3d 58 02 00 00       	cmp    $0x258,%eax
    2546:	0f 85 f8 00 00 00    	jne    2644 <bigfile+0x174>
  for(i = 0; i < 20; i++){
    254c:	83 c3 01             	add    $0x1,%ebx
    254f:	83 fb 14             	cmp    $0x14,%ebx
    2552:	75 c4                	jne    2518 <bigfile+0x48>
  close(fd);
    2554:	83 ec 0c             	sub    $0xc,%esp
    2557:	56                   	push   %esi
    2558:	e8 1c 13 00 00       	call   3879 <close>
  fd = open("bigfile", 0);
    255d:	5e                   	pop    %esi
    255e:	5f                   	pop    %edi
    255f:	6a 00                	push   $0x0
    2561:	68 f0 47 00 00       	push   $0x47f0
    2566:	e8 26 13 00 00       	call   3891 <open>
  if(fd < 0){
    256b:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", 0);
    256e:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2570:	85 c0                	test   %eax,%eax
    2572:	0f 88 e0 00 00 00    	js     2658 <bigfile+0x188>
  total = 0;
    2578:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    257a:	31 ff                	xor    %edi,%edi
    257c:	eb 30                	jmp    25ae <bigfile+0xde>
    257e:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    2580:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2585:	0f 85 91 00 00 00    	jne    261c <bigfile+0x14c>
    if(buf[0] != i/2 || buf[299] != i/2){
    258b:	89 fa                	mov    %edi,%edx
    258d:	0f be 05 60 85 00 00 	movsbl 0x8560,%eax
    2594:	d1 fa                	sar    %edx
    2596:	39 d0                	cmp    %edx,%eax
    2598:	75 6e                	jne    2608 <bigfile+0x138>
    259a:	0f be 15 8b 86 00 00 	movsbl 0x868b,%edx
    25a1:	39 d0                	cmp    %edx,%eax
    25a3:	75 63                	jne    2608 <bigfile+0x138>
    total += cc;
    25a5:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    25ab:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    25ae:	83 ec 04             	sub    $0x4,%esp
    25b1:	68 2c 01 00 00       	push   $0x12c
    25b6:	68 60 85 00 00       	push   $0x8560
    25bb:	56                   	push   %esi
    25bc:	e8 a8 12 00 00       	call   3869 <read>
    if(cc < 0){
    25c1:	83 c4 10             	add    $0x10,%esp
    25c4:	85 c0                	test   %eax,%eax
    25c6:	78 68                	js     2630 <bigfile+0x160>
    if(cc == 0)
    25c8:	75 b6                	jne    2580 <bigfile+0xb0>
  close(fd);
    25ca:	83 ec 0c             	sub    $0xc,%esp
    25cd:	56                   	push   %esi
    25ce:	e8 a6 12 00 00       	call   3879 <close>
  if(total != 20*600){
    25d3:	83 c4 10             	add    $0x10,%esp
    25d6:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    25dc:	0f 85 9c 00 00 00    	jne    267e <bigfile+0x1ae>
  unlink("bigfile");
    25e2:	83 ec 0c             	sub    $0xc,%esp
    25e5:	68 f0 47 00 00       	push   $0x47f0
    25ea:	e8 b2 12 00 00       	call   38a1 <unlink>
  printf(1, "bigfile test ok\n");
    25ef:	58                   	pop    %eax
    25f0:	5a                   	pop    %edx
    25f1:	68 7f 48 00 00       	push   $0x487f
    25f6:	6a 01                	push   $0x1
    25f8:	e8 c3 13 00 00       	call   39c0 <printf>
}
    25fd:	83 c4 10             	add    $0x10,%esp
    2600:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2603:	5b                   	pop    %ebx
    2604:	5e                   	pop    %esi
    2605:	5f                   	pop    %edi
    2606:	5d                   	pop    %ebp
    2607:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    2608:	83 ec 08             	sub    $0x8,%esp
    260b:	68 4c 48 00 00       	push   $0x484c
    2610:	6a 01                	push   $0x1
    2612:	e8 a9 13 00 00       	call   39c0 <printf>
      exit();
    2617:	e8 35 12 00 00       	call   3851 <exit>
      printf(1, "short read bigfile\n");
    261c:	83 ec 08             	sub    $0x8,%esp
    261f:	68 38 48 00 00       	push   $0x4838
    2624:	6a 01                	push   $0x1
    2626:	e8 95 13 00 00       	call   39c0 <printf>
      exit();
    262b:	e8 21 12 00 00       	call   3851 <exit>
      printf(1, "read bigfile failed\n");
    2630:	83 ec 08             	sub    $0x8,%esp
    2633:	68 23 48 00 00       	push   $0x4823
    2638:	6a 01                	push   $0x1
    263a:	e8 81 13 00 00       	call   39c0 <printf>
      exit();
    263f:	e8 0d 12 00 00       	call   3851 <exit>
      printf(1, "write bigfile failed\n");
    2644:	83 ec 08             	sub    $0x8,%esp
    2647:	68 f8 47 00 00       	push   $0x47f8
    264c:	6a 01                	push   $0x1
    264e:	e8 6d 13 00 00       	call   39c0 <printf>
      exit();
    2653:	e8 f9 11 00 00       	call   3851 <exit>
    printf(1, "cannot open bigfile\n");
    2658:	53                   	push   %ebx
    2659:	53                   	push   %ebx
    265a:	68 0e 48 00 00       	push   $0x480e
    265f:	6a 01                	push   $0x1
    2661:	e8 5a 13 00 00       	call   39c0 <printf>
    exit();
    2666:	e8 e6 11 00 00       	call   3851 <exit>
    printf(1, "cannot create bigfile");
    266b:	50                   	push   %eax
    266c:	50                   	push   %eax
    266d:	68 e2 47 00 00       	push   $0x47e2
    2672:	6a 01                	push   $0x1
    2674:	e8 47 13 00 00       	call   39c0 <printf>
    exit();
    2679:	e8 d3 11 00 00       	call   3851 <exit>
    printf(1, "read bigfile wrong total\n");
    267e:	51                   	push   %ecx
    267f:	51                   	push   %ecx
    2680:	68 65 48 00 00       	push   $0x4865
    2685:	6a 01                	push   $0x1
    2687:	e8 34 13 00 00       	call   39c0 <printf>
    exit();
    268c:	e8 c0 11 00 00       	call   3851 <exit>
    2691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    269f:	90                   	nop

000026a0 <fourteen>:
{
    26a0:	55                   	push   %ebp
    26a1:	89 e5                	mov    %esp,%ebp
    26a3:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    26a6:	68 90 48 00 00       	push   $0x4890
    26ab:	6a 01                	push   $0x1
    26ad:	e8 0e 13 00 00       	call   39c0 <printf>
  if(mkdir("12345678901234") != 0){
    26b2:	c7 04 24 cb 48 00 00 	movl   $0x48cb,(%esp)
    26b9:	e8 fb 11 00 00       	call   38b9 <mkdir>
    26be:	83 c4 10             	add    $0x10,%esp
    26c1:	85 c0                	test   %eax,%eax
    26c3:	0f 85 97 00 00 00    	jne    2760 <fourteen+0xc0>
  if(mkdir("12345678901234/123456789012345") != 0){
    26c9:	83 ec 0c             	sub    $0xc,%esp
    26cc:	68 64 50 00 00       	push   $0x5064
    26d1:	e8 e3 11 00 00       	call   38b9 <mkdir>
    26d6:	83 c4 10             	add    $0x10,%esp
    26d9:	85 c0                	test   %eax,%eax
    26db:	0f 85 de 00 00 00    	jne    27bf <fourteen+0x11f>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    26e1:	83 ec 08             	sub    $0x8,%esp
    26e4:	68 00 02 00 00       	push   $0x200
    26e9:	68 b4 50 00 00       	push   $0x50b4
    26ee:	e8 9e 11 00 00       	call   3891 <open>
  if(fd < 0){
    26f3:	83 c4 10             	add    $0x10,%esp
    26f6:	85 c0                	test   %eax,%eax
    26f8:	0f 88 ae 00 00 00    	js     27ac <fourteen+0x10c>
  close(fd);
    26fe:	83 ec 0c             	sub    $0xc,%esp
    2701:	50                   	push   %eax
    2702:	e8 72 11 00 00       	call   3879 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2707:	58                   	pop    %eax
    2708:	5a                   	pop    %edx
    2709:	6a 00                	push   $0x0
    270b:	68 24 51 00 00       	push   $0x5124
    2710:	e8 7c 11 00 00       	call   3891 <open>
  if(fd < 0){
    2715:	83 c4 10             	add    $0x10,%esp
    2718:	85 c0                	test   %eax,%eax
    271a:	78 7d                	js     2799 <fourteen+0xf9>
  close(fd);
    271c:	83 ec 0c             	sub    $0xc,%esp
    271f:	50                   	push   %eax
    2720:	e8 54 11 00 00       	call   3879 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2725:	c7 04 24 bc 48 00 00 	movl   $0x48bc,(%esp)
    272c:	e8 88 11 00 00       	call   38b9 <mkdir>
    2731:	83 c4 10             	add    $0x10,%esp
    2734:	85 c0                	test   %eax,%eax
    2736:	74 4e                	je     2786 <fourteen+0xe6>
  if(mkdir("123456789012345/12345678901234") == 0){
    2738:	83 ec 0c             	sub    $0xc,%esp
    273b:	68 c0 51 00 00       	push   $0x51c0
    2740:	e8 74 11 00 00       	call   38b9 <mkdir>
    2745:	83 c4 10             	add    $0x10,%esp
    2748:	85 c0                	test   %eax,%eax
    274a:	74 27                	je     2773 <fourteen+0xd3>
  printf(1, "fourteen ok\n");
    274c:	83 ec 08             	sub    $0x8,%esp
    274f:	68 da 48 00 00       	push   $0x48da
    2754:	6a 01                	push   $0x1
    2756:	e8 65 12 00 00       	call   39c0 <printf>
}
    275b:	83 c4 10             	add    $0x10,%esp
    275e:	c9                   	leave  
    275f:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    2760:	50                   	push   %eax
    2761:	50                   	push   %eax
    2762:	68 9f 48 00 00       	push   $0x489f
    2767:	6a 01                	push   $0x1
    2769:	e8 52 12 00 00       	call   39c0 <printf>
    exit();
    276e:	e8 de 10 00 00       	call   3851 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2773:	50                   	push   %eax
    2774:	50                   	push   %eax
    2775:	68 e0 51 00 00       	push   $0x51e0
    277a:	6a 01                	push   $0x1
    277c:	e8 3f 12 00 00       	call   39c0 <printf>
    exit();
    2781:	e8 cb 10 00 00       	call   3851 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2786:	52                   	push   %edx
    2787:	52                   	push   %edx
    2788:	68 90 51 00 00       	push   $0x5190
    278d:	6a 01                	push   $0x1
    278f:	e8 2c 12 00 00       	call   39c0 <printf>
    exit();
    2794:	e8 b8 10 00 00       	call   3851 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2799:	51                   	push   %ecx
    279a:	51                   	push   %ecx
    279b:	68 54 51 00 00       	push   $0x5154
    27a0:	6a 01                	push   $0x1
    27a2:	e8 19 12 00 00       	call   39c0 <printf>
    exit();
    27a7:	e8 a5 10 00 00       	call   3851 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    27ac:	51                   	push   %ecx
    27ad:	51                   	push   %ecx
    27ae:	68 e4 50 00 00       	push   $0x50e4
    27b3:	6a 01                	push   $0x1
    27b5:	e8 06 12 00 00       	call   39c0 <printf>
    exit();
    27ba:	e8 92 10 00 00       	call   3851 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    27bf:	50                   	push   %eax
    27c0:	50                   	push   %eax
    27c1:	68 84 50 00 00       	push   $0x5084
    27c6:	6a 01                	push   $0x1
    27c8:	e8 f3 11 00 00       	call   39c0 <printf>
    exit();
    27cd:	e8 7f 10 00 00       	call   3851 <exit>
    27d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    27d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000027e0 <rmdot>:
{
    27e0:	55                   	push   %ebp
    27e1:	89 e5                	mov    %esp,%ebp
    27e3:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    27e6:	68 e7 48 00 00       	push   $0x48e7
    27eb:	6a 01                	push   $0x1
    27ed:	e8 ce 11 00 00       	call   39c0 <printf>
  if(mkdir("dots") != 0){
    27f2:	c7 04 24 f3 48 00 00 	movl   $0x48f3,(%esp)
    27f9:	e8 bb 10 00 00       	call   38b9 <mkdir>
    27fe:	83 c4 10             	add    $0x10,%esp
    2801:	85 c0                	test   %eax,%eax
    2803:	0f 85 b0 00 00 00    	jne    28b9 <rmdot+0xd9>
  if(chdir("dots") != 0){
    2809:	83 ec 0c             	sub    $0xc,%esp
    280c:	68 f3 48 00 00       	push   $0x48f3
    2811:	e8 ab 10 00 00       	call   38c1 <chdir>
    2816:	83 c4 10             	add    $0x10,%esp
    2819:	85 c0                	test   %eax,%eax
    281b:	0f 85 1d 01 00 00    	jne    293e <rmdot+0x15e>
  if(unlink(".") == 0){
    2821:	83 ec 0c             	sub    $0xc,%esp
    2824:	68 9e 45 00 00       	push   $0x459e
    2829:	e8 73 10 00 00       	call   38a1 <unlink>
    282e:	83 c4 10             	add    $0x10,%esp
    2831:	85 c0                	test   %eax,%eax
    2833:	0f 84 f2 00 00 00    	je     292b <rmdot+0x14b>
  if(unlink("..") == 0){
    2839:	83 ec 0c             	sub    $0xc,%esp
    283c:	68 9d 45 00 00       	push   $0x459d
    2841:	e8 5b 10 00 00       	call   38a1 <unlink>
    2846:	83 c4 10             	add    $0x10,%esp
    2849:	85 c0                	test   %eax,%eax
    284b:	0f 84 c7 00 00 00    	je     2918 <rmdot+0x138>
  if(chdir("/") != 0){
    2851:	83 ec 0c             	sub    $0xc,%esp
    2854:	68 71 3d 00 00       	push   $0x3d71
    2859:	e8 63 10 00 00       	call   38c1 <chdir>
    285e:	83 c4 10             	add    $0x10,%esp
    2861:	85 c0                	test   %eax,%eax
    2863:	0f 85 9c 00 00 00    	jne    2905 <rmdot+0x125>
  if(unlink("dots/.") == 0){
    2869:	83 ec 0c             	sub    $0xc,%esp
    286c:	68 3b 49 00 00       	push   $0x493b
    2871:	e8 2b 10 00 00       	call   38a1 <unlink>
    2876:	83 c4 10             	add    $0x10,%esp
    2879:	85 c0                	test   %eax,%eax
    287b:	74 75                	je     28f2 <rmdot+0x112>
  if(unlink("dots/..") == 0){
    287d:	83 ec 0c             	sub    $0xc,%esp
    2880:	68 59 49 00 00       	push   $0x4959
    2885:	e8 17 10 00 00       	call   38a1 <unlink>
    288a:	83 c4 10             	add    $0x10,%esp
    288d:	85 c0                	test   %eax,%eax
    288f:	74 4e                	je     28df <rmdot+0xff>
  if(unlink("dots") != 0){
    2891:	83 ec 0c             	sub    $0xc,%esp
    2894:	68 f3 48 00 00       	push   $0x48f3
    2899:	e8 03 10 00 00       	call   38a1 <unlink>
    289e:	83 c4 10             	add    $0x10,%esp
    28a1:	85 c0                	test   %eax,%eax
    28a3:	75 27                	jne    28cc <rmdot+0xec>
  printf(1, "rmdot ok\n");
    28a5:	83 ec 08             	sub    $0x8,%esp
    28a8:	68 8e 49 00 00       	push   $0x498e
    28ad:	6a 01                	push   $0x1
    28af:	e8 0c 11 00 00       	call   39c0 <printf>
}
    28b4:	83 c4 10             	add    $0x10,%esp
    28b7:	c9                   	leave  
    28b8:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    28b9:	50                   	push   %eax
    28ba:	50                   	push   %eax
    28bb:	68 f8 48 00 00       	push   $0x48f8
    28c0:	6a 01                	push   $0x1
    28c2:	e8 f9 10 00 00       	call   39c0 <printf>
    exit();
    28c7:	e8 85 0f 00 00       	call   3851 <exit>
    printf(1, "unlink dots failed!\n");
    28cc:	50                   	push   %eax
    28cd:	50                   	push   %eax
    28ce:	68 79 49 00 00       	push   $0x4979
    28d3:	6a 01                	push   $0x1
    28d5:	e8 e6 10 00 00       	call   39c0 <printf>
    exit();
    28da:	e8 72 0f 00 00       	call   3851 <exit>
    printf(1, "unlink dots/.. worked!\n");
    28df:	52                   	push   %edx
    28e0:	52                   	push   %edx
    28e1:	68 61 49 00 00       	push   $0x4961
    28e6:	6a 01                	push   $0x1
    28e8:	e8 d3 10 00 00       	call   39c0 <printf>
    exit();
    28ed:	e8 5f 0f 00 00       	call   3851 <exit>
    printf(1, "unlink dots/. worked!\n");
    28f2:	51                   	push   %ecx
    28f3:	51                   	push   %ecx
    28f4:	68 42 49 00 00       	push   $0x4942
    28f9:	6a 01                	push   $0x1
    28fb:	e8 c0 10 00 00       	call   39c0 <printf>
    exit();
    2900:	e8 4c 0f 00 00       	call   3851 <exit>
    printf(1, "chdir / failed\n");
    2905:	50                   	push   %eax
    2906:	50                   	push   %eax
    2907:	68 73 3d 00 00       	push   $0x3d73
    290c:	6a 01                	push   $0x1
    290e:	e8 ad 10 00 00       	call   39c0 <printf>
    exit();
    2913:	e8 39 0f 00 00       	call   3851 <exit>
    printf(1, "rm .. worked!\n");
    2918:	50                   	push   %eax
    2919:	50                   	push   %eax
    291a:	68 2c 49 00 00       	push   $0x492c
    291f:	6a 01                	push   $0x1
    2921:	e8 9a 10 00 00       	call   39c0 <printf>
    exit();
    2926:	e8 26 0f 00 00       	call   3851 <exit>
    printf(1, "rm . worked!\n");
    292b:	50                   	push   %eax
    292c:	50                   	push   %eax
    292d:	68 1e 49 00 00       	push   $0x491e
    2932:	6a 01                	push   $0x1
    2934:	e8 87 10 00 00       	call   39c0 <printf>
    exit();
    2939:	e8 13 0f 00 00       	call   3851 <exit>
    printf(1, "chdir dots failed\n");
    293e:	50                   	push   %eax
    293f:	50                   	push   %eax
    2940:	68 0b 49 00 00       	push   $0x490b
    2945:	6a 01                	push   $0x1
    2947:	e8 74 10 00 00       	call   39c0 <printf>
    exit();
    294c:	e8 00 0f 00 00       	call   3851 <exit>
    2951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    295f:	90                   	nop

00002960 <dirfile>:
{
    2960:	55                   	push   %ebp
    2961:	89 e5                	mov    %esp,%ebp
    2963:	53                   	push   %ebx
    2964:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    2967:	68 98 49 00 00       	push   $0x4998
    296c:	6a 01                	push   $0x1
    296e:	e8 4d 10 00 00       	call   39c0 <printf>
  fd = open("dirfile", O_CREATE);
    2973:	59                   	pop    %ecx
    2974:	5b                   	pop    %ebx
    2975:	68 00 02 00 00       	push   $0x200
    297a:	68 a5 49 00 00       	push   $0x49a5
    297f:	e8 0d 0f 00 00       	call   3891 <open>
  if(fd < 0){
    2984:	83 c4 10             	add    $0x10,%esp
    2987:	85 c0                	test   %eax,%eax
    2989:	0f 88 43 01 00 00    	js     2ad2 <dirfile+0x172>
  close(fd);
    298f:	83 ec 0c             	sub    $0xc,%esp
    2992:	50                   	push   %eax
    2993:	e8 e1 0e 00 00       	call   3879 <close>
  if(chdir("dirfile") == 0){
    2998:	c7 04 24 a5 49 00 00 	movl   $0x49a5,(%esp)
    299f:	e8 1d 0f 00 00       	call   38c1 <chdir>
    29a4:	83 c4 10             	add    $0x10,%esp
    29a7:	85 c0                	test   %eax,%eax
    29a9:	0f 84 10 01 00 00    	je     2abf <dirfile+0x15f>
  fd = open("dirfile/xx", 0);
    29af:	83 ec 08             	sub    $0x8,%esp
    29b2:	6a 00                	push   $0x0
    29b4:	68 de 49 00 00       	push   $0x49de
    29b9:	e8 d3 0e 00 00       	call   3891 <open>
  if(fd >= 0){
    29be:	83 c4 10             	add    $0x10,%esp
    29c1:	85 c0                	test   %eax,%eax
    29c3:	0f 89 e3 00 00 00    	jns    2aac <dirfile+0x14c>
  fd = open("dirfile/xx", O_CREATE);
    29c9:	83 ec 08             	sub    $0x8,%esp
    29cc:	68 00 02 00 00       	push   $0x200
    29d1:	68 de 49 00 00       	push   $0x49de
    29d6:	e8 b6 0e 00 00       	call   3891 <open>
  if(fd >= 0){
    29db:	83 c4 10             	add    $0x10,%esp
    29de:	85 c0                	test   %eax,%eax
    29e0:	0f 89 c6 00 00 00    	jns    2aac <dirfile+0x14c>
  if(mkdir("dirfile/xx") == 0){
    29e6:	83 ec 0c             	sub    $0xc,%esp
    29e9:	68 de 49 00 00       	push   $0x49de
    29ee:	e8 c6 0e 00 00       	call   38b9 <mkdir>
    29f3:	83 c4 10             	add    $0x10,%esp
    29f6:	85 c0                	test   %eax,%eax
    29f8:	0f 84 46 01 00 00    	je     2b44 <dirfile+0x1e4>
  if(unlink("dirfile/xx") == 0){
    29fe:	83 ec 0c             	sub    $0xc,%esp
    2a01:	68 de 49 00 00       	push   $0x49de
    2a06:	e8 96 0e 00 00       	call   38a1 <unlink>
    2a0b:	83 c4 10             	add    $0x10,%esp
    2a0e:	85 c0                	test   %eax,%eax
    2a10:	0f 84 1b 01 00 00    	je     2b31 <dirfile+0x1d1>
  if(link("README", "dirfile/xx") == 0){
    2a16:	83 ec 08             	sub    $0x8,%esp
    2a19:	68 de 49 00 00       	push   $0x49de
    2a1e:	68 42 4a 00 00       	push   $0x4a42
    2a23:	e8 89 0e 00 00       	call   38b1 <link>
    2a28:	83 c4 10             	add    $0x10,%esp
    2a2b:	85 c0                	test   %eax,%eax
    2a2d:	0f 84 eb 00 00 00    	je     2b1e <dirfile+0x1be>
  if(unlink("dirfile") != 0){
    2a33:	83 ec 0c             	sub    $0xc,%esp
    2a36:	68 a5 49 00 00       	push   $0x49a5
    2a3b:	e8 61 0e 00 00       	call   38a1 <unlink>
    2a40:	83 c4 10             	add    $0x10,%esp
    2a43:	85 c0                	test   %eax,%eax
    2a45:	0f 85 c0 00 00 00    	jne    2b0b <dirfile+0x1ab>
  fd = open(".", O_RDWR);
    2a4b:	83 ec 08             	sub    $0x8,%esp
    2a4e:	6a 02                	push   $0x2
    2a50:	68 9e 45 00 00       	push   $0x459e
    2a55:	e8 37 0e 00 00       	call   3891 <open>
  if(fd >= 0){
    2a5a:	83 c4 10             	add    $0x10,%esp
    2a5d:	85 c0                	test   %eax,%eax
    2a5f:	0f 89 93 00 00 00    	jns    2af8 <dirfile+0x198>
  fd = open(".", 0);
    2a65:	83 ec 08             	sub    $0x8,%esp
    2a68:	6a 00                	push   $0x0
    2a6a:	68 9e 45 00 00       	push   $0x459e
    2a6f:	e8 1d 0e 00 00       	call   3891 <open>
  if(write(fd, "x", 1) > 0){
    2a74:	83 c4 0c             	add    $0xc,%esp
    2a77:	6a 01                	push   $0x1
  fd = open(".", 0);
    2a79:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2a7b:	68 81 46 00 00       	push   $0x4681
    2a80:	50                   	push   %eax
    2a81:	e8 eb 0d 00 00       	call   3871 <write>
    2a86:	83 c4 10             	add    $0x10,%esp
    2a89:	85 c0                	test   %eax,%eax
    2a8b:	7f 58                	jg     2ae5 <dirfile+0x185>
  close(fd);
    2a8d:	83 ec 0c             	sub    $0xc,%esp
    2a90:	53                   	push   %ebx
    2a91:	e8 e3 0d 00 00       	call   3879 <close>
  printf(1, "dir vs file OK\n");
    2a96:	58                   	pop    %eax
    2a97:	5a                   	pop    %edx
    2a98:	68 75 4a 00 00       	push   $0x4a75
    2a9d:	6a 01                	push   $0x1
    2a9f:	e8 1c 0f 00 00       	call   39c0 <printf>
}
    2aa4:	83 c4 10             	add    $0x10,%esp
    2aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2aaa:	c9                   	leave  
    2aab:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2aac:	50                   	push   %eax
    2aad:	50                   	push   %eax
    2aae:	68 e9 49 00 00       	push   $0x49e9
    2ab3:	6a 01                	push   $0x1
    2ab5:	e8 06 0f 00 00       	call   39c0 <printf>
    exit();
    2aba:	e8 92 0d 00 00       	call   3851 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2abf:	50                   	push   %eax
    2ac0:	50                   	push   %eax
    2ac1:	68 c4 49 00 00       	push   $0x49c4
    2ac6:	6a 01                	push   $0x1
    2ac8:	e8 f3 0e 00 00       	call   39c0 <printf>
    exit();
    2acd:	e8 7f 0d 00 00       	call   3851 <exit>
    printf(1, "create dirfile failed\n");
    2ad2:	52                   	push   %edx
    2ad3:	52                   	push   %edx
    2ad4:	68 ad 49 00 00       	push   $0x49ad
    2ad9:	6a 01                	push   $0x1
    2adb:	e8 e0 0e 00 00       	call   39c0 <printf>
    exit();
    2ae0:	e8 6c 0d 00 00       	call   3851 <exit>
    printf(1, "write . succeeded!\n");
    2ae5:	51                   	push   %ecx
    2ae6:	51                   	push   %ecx
    2ae7:	68 61 4a 00 00       	push   $0x4a61
    2aec:	6a 01                	push   $0x1
    2aee:	e8 cd 0e 00 00       	call   39c0 <printf>
    exit();
    2af3:	e8 59 0d 00 00       	call   3851 <exit>
    printf(1, "open . for writing succeeded!\n");
    2af8:	53                   	push   %ebx
    2af9:	53                   	push   %ebx
    2afa:	68 34 52 00 00       	push   $0x5234
    2aff:	6a 01                	push   $0x1
    2b01:	e8 ba 0e 00 00       	call   39c0 <printf>
    exit();
    2b06:	e8 46 0d 00 00       	call   3851 <exit>
    printf(1, "unlink dirfile failed!\n");
    2b0b:	50                   	push   %eax
    2b0c:	50                   	push   %eax
    2b0d:	68 49 4a 00 00       	push   $0x4a49
    2b12:	6a 01                	push   $0x1
    2b14:	e8 a7 0e 00 00       	call   39c0 <printf>
    exit();
    2b19:	e8 33 0d 00 00       	call   3851 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2b1e:	50                   	push   %eax
    2b1f:	50                   	push   %eax
    2b20:	68 14 52 00 00       	push   $0x5214
    2b25:	6a 01                	push   $0x1
    2b27:	e8 94 0e 00 00       	call   39c0 <printf>
    exit();
    2b2c:	e8 20 0d 00 00       	call   3851 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2b31:	50                   	push   %eax
    2b32:	50                   	push   %eax
    2b33:	68 24 4a 00 00       	push   $0x4a24
    2b38:	6a 01                	push   $0x1
    2b3a:	e8 81 0e 00 00       	call   39c0 <printf>
    exit();
    2b3f:	e8 0d 0d 00 00       	call   3851 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2b44:	50                   	push   %eax
    2b45:	50                   	push   %eax
    2b46:	68 07 4a 00 00       	push   $0x4a07
    2b4b:	6a 01                	push   $0x1
    2b4d:	e8 6e 0e 00 00       	call   39c0 <printf>
    exit();
    2b52:	e8 fa 0c 00 00       	call   3851 <exit>
    2b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2b5e:	66 90                	xchg   %ax,%ax

00002b60 <iref>:
{
    2b60:	55                   	push   %ebp
    2b61:	89 e5                	mov    %esp,%ebp
    2b63:	53                   	push   %ebx
  printf(1, "empty file name\n");
    2b64:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    2b69:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    2b6c:	68 85 4a 00 00       	push   $0x4a85
    2b71:	6a 01                	push   $0x1
    2b73:	e8 48 0e 00 00       	call   39c0 <printf>
    2b78:	83 c4 10             	add    $0x10,%esp
    2b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2b7f:	90                   	nop
    if(mkdir("irefd") != 0){
    2b80:	83 ec 0c             	sub    $0xc,%esp
    2b83:	68 96 4a 00 00       	push   $0x4a96
    2b88:	e8 2c 0d 00 00       	call   38b9 <mkdir>
    2b8d:	83 c4 10             	add    $0x10,%esp
    2b90:	85 c0                	test   %eax,%eax
    2b92:	0f 85 bb 00 00 00    	jne    2c53 <iref+0xf3>
    if(chdir("irefd") != 0){
    2b98:	83 ec 0c             	sub    $0xc,%esp
    2b9b:	68 96 4a 00 00       	push   $0x4a96
    2ba0:	e8 1c 0d 00 00       	call   38c1 <chdir>
    2ba5:	83 c4 10             	add    $0x10,%esp
    2ba8:	85 c0                	test   %eax,%eax
    2baa:	0f 85 b7 00 00 00    	jne    2c67 <iref+0x107>
    mkdir("");
    2bb0:	83 ec 0c             	sub    $0xc,%esp
    2bb3:	68 4b 41 00 00       	push   $0x414b
    2bb8:	e8 fc 0c 00 00       	call   38b9 <mkdir>
    link("README", "");
    2bbd:	59                   	pop    %ecx
    2bbe:	58                   	pop    %eax
    2bbf:	68 4b 41 00 00       	push   $0x414b
    2bc4:	68 42 4a 00 00       	push   $0x4a42
    2bc9:	e8 e3 0c 00 00       	call   38b1 <link>
    fd = open("", O_CREATE);
    2bce:	58                   	pop    %eax
    2bcf:	5a                   	pop    %edx
    2bd0:	68 00 02 00 00       	push   $0x200
    2bd5:	68 4b 41 00 00       	push   $0x414b
    2bda:	e8 b2 0c 00 00       	call   3891 <open>
    if(fd >= 0)
    2bdf:	83 c4 10             	add    $0x10,%esp
    2be2:	85 c0                	test   %eax,%eax
    2be4:	78 0c                	js     2bf2 <iref+0x92>
      close(fd);
    2be6:	83 ec 0c             	sub    $0xc,%esp
    2be9:	50                   	push   %eax
    2bea:	e8 8a 0c 00 00       	call   3879 <close>
    2bef:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2bf2:	83 ec 08             	sub    $0x8,%esp
    2bf5:	68 00 02 00 00       	push   $0x200
    2bfa:	68 80 46 00 00       	push   $0x4680
    2bff:	e8 8d 0c 00 00       	call   3891 <open>
    if(fd >= 0)
    2c04:	83 c4 10             	add    $0x10,%esp
    2c07:	85 c0                	test   %eax,%eax
    2c09:	78 0c                	js     2c17 <iref+0xb7>
      close(fd);
    2c0b:	83 ec 0c             	sub    $0xc,%esp
    2c0e:	50                   	push   %eax
    2c0f:	e8 65 0c 00 00       	call   3879 <close>
    2c14:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2c17:	83 ec 0c             	sub    $0xc,%esp
    2c1a:	68 80 46 00 00       	push   $0x4680
    2c1f:	e8 7d 0c 00 00       	call   38a1 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2c24:	83 c4 10             	add    $0x10,%esp
    2c27:	83 eb 01             	sub    $0x1,%ebx
    2c2a:	0f 85 50 ff ff ff    	jne    2b80 <iref+0x20>
  chdir("/");
    2c30:	83 ec 0c             	sub    $0xc,%esp
    2c33:	68 71 3d 00 00       	push   $0x3d71
    2c38:	e8 84 0c 00 00       	call   38c1 <chdir>
  printf(1, "empty file name OK\n");
    2c3d:	58                   	pop    %eax
    2c3e:	5a                   	pop    %edx
    2c3f:	68 c4 4a 00 00       	push   $0x4ac4
    2c44:	6a 01                	push   $0x1
    2c46:	e8 75 0d 00 00       	call   39c0 <printf>
}
    2c4b:	83 c4 10             	add    $0x10,%esp
    2c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2c51:	c9                   	leave  
    2c52:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    2c53:	83 ec 08             	sub    $0x8,%esp
    2c56:	68 9c 4a 00 00       	push   $0x4a9c
    2c5b:	6a 01                	push   $0x1
    2c5d:	e8 5e 0d 00 00       	call   39c0 <printf>
      exit();
    2c62:	e8 ea 0b 00 00       	call   3851 <exit>
      printf(1, "chdir irefd failed\n");
    2c67:	83 ec 08             	sub    $0x8,%esp
    2c6a:	68 b0 4a 00 00       	push   $0x4ab0
    2c6f:	6a 01                	push   $0x1
    2c71:	e8 4a 0d 00 00       	call   39c0 <printf>
      exit();
    2c76:	e8 d6 0b 00 00       	call   3851 <exit>
    2c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2c7f:	90                   	nop

00002c80 <forktest>:
{
    2c80:	55                   	push   %ebp
    2c81:	89 e5                	mov    %esp,%ebp
    2c83:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    2c84:	31 db                	xor    %ebx,%ebx
{
    2c86:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    2c89:	68 d8 4a 00 00       	push   $0x4ad8
    2c8e:	6a 01                	push   $0x1
    2c90:	e8 2b 0d 00 00       	call   39c0 <printf>
    2c95:	83 c4 10             	add    $0x10,%esp
    2c98:	eb 13                	jmp    2cad <forktest+0x2d>
    2c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pid == 0)
    2ca0:	74 4a                	je     2cec <forktest+0x6c>
  for(n=0; n<1000; n++){
    2ca2:	83 c3 01             	add    $0x1,%ebx
    2ca5:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2cab:	74 6b                	je     2d18 <forktest+0x98>
    pid = fork();
    2cad:	e8 97 0b 00 00       	call   3849 <fork>
    if(pid < 0)
    2cb2:	85 c0                	test   %eax,%eax
    2cb4:	79 ea                	jns    2ca0 <forktest+0x20>
  for(; n > 0; n--){
    2cb6:	85 db                	test   %ebx,%ebx
    2cb8:	74 14                	je     2cce <forktest+0x4e>
    2cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
    2cc0:	e8 94 0b 00 00       	call   3859 <wait>
    2cc5:	85 c0                	test   %eax,%eax
    2cc7:	78 28                	js     2cf1 <forktest+0x71>
  for(; n > 0; n--){
    2cc9:	83 eb 01             	sub    $0x1,%ebx
    2ccc:	75 f2                	jne    2cc0 <forktest+0x40>
  if(wait() != -1){
    2cce:	e8 86 0b 00 00       	call   3859 <wait>
    2cd3:	83 f8 ff             	cmp    $0xffffffff,%eax
    2cd6:	75 2d                	jne    2d05 <forktest+0x85>
  printf(1, "fork test OK\n");
    2cd8:	83 ec 08             	sub    $0x8,%esp
    2cdb:	68 0a 4b 00 00       	push   $0x4b0a
    2ce0:	6a 01                	push   $0x1
    2ce2:	e8 d9 0c 00 00       	call   39c0 <printf>
}
    2ce7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2cea:	c9                   	leave  
    2ceb:	c3                   	ret    
      exit();
    2cec:	e8 60 0b 00 00       	call   3851 <exit>
      printf(1, "wait stopped early\n");
    2cf1:	83 ec 08             	sub    $0x8,%esp
    2cf4:	68 e3 4a 00 00       	push   $0x4ae3
    2cf9:	6a 01                	push   $0x1
    2cfb:	e8 c0 0c 00 00       	call   39c0 <printf>
      exit();
    2d00:	e8 4c 0b 00 00       	call   3851 <exit>
    printf(1, "wait got too many\n");
    2d05:	52                   	push   %edx
    2d06:	52                   	push   %edx
    2d07:	68 f7 4a 00 00       	push   $0x4af7
    2d0c:	6a 01                	push   $0x1
    2d0e:	e8 ad 0c 00 00       	call   39c0 <printf>
    exit();
    2d13:	e8 39 0b 00 00       	call   3851 <exit>
    printf(1, "fork claimed to work 1000 times!\n");
    2d18:	50                   	push   %eax
    2d19:	50                   	push   %eax
    2d1a:	68 54 52 00 00       	push   $0x5254
    2d1f:	6a 01                	push   $0x1
    2d21:	e8 9a 0c 00 00       	call   39c0 <printf>
    exit();
    2d26:	e8 26 0b 00 00       	call   3851 <exit>
    2d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2d2f:	90                   	nop

00002d30 <sbrktest>:
{
    2d30:	55                   	push   %ebp
    2d31:	89 e5                	mov    %esp,%ebp
    2d33:	57                   	push   %edi
  for(i = 0; i < 5000; i++){
    2d34:	31 ff                	xor    %edi,%edi
{
    2d36:	56                   	push   %esi
    2d37:	53                   	push   %ebx
    2d38:	83 ec 54             	sub    $0x54,%esp
  printf(stdout, "sbrk test\n");
    2d3b:	68 18 4b 00 00       	push   $0x4b18
    2d40:	ff 35 74 5d 00 00    	pushl  0x5d74
    2d46:	e8 75 0c 00 00       	call   39c0 <printf>
  oldbrk = sbrk(0);
    2d4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d52:	e8 82 0b 00 00       	call   38d9 <sbrk>
  a = sbrk(0);
    2d57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    2d5e:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    2d60:	e8 74 0b 00 00       	call   38d9 <sbrk>
    2d65:	83 c4 10             	add    $0x10,%esp
    2d68:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 5000; i++){
    2d6a:	eb 06                	jmp    2d72 <sbrktest+0x42>
    2d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    a = b + 1;
    2d70:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    2d72:	83 ec 0c             	sub    $0xc,%esp
    2d75:	6a 01                	push   $0x1
    2d77:	e8 5d 0b 00 00       	call   38d9 <sbrk>
    if(b != a){
    2d7c:	83 c4 10             	add    $0x10,%esp
    2d7f:	39 f0                	cmp    %esi,%eax
    2d81:	0f 85 84 02 00 00    	jne    300b <sbrktest+0x2db>
  for(i = 0; i < 5000; i++){
    2d87:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    2d8a:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    2d8d:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    2d90:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    2d96:	75 d8                	jne    2d70 <sbrktest+0x40>
  pid = fork();
    2d98:	e8 ac 0a 00 00       	call   3849 <fork>
    2d9d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    2d9f:	85 c0                	test   %eax,%eax
    2da1:	0f 88 91 03 00 00    	js     3138 <sbrktest+0x408>
  c = sbrk(1);
    2da7:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    2daa:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    2dad:	6a 01                	push   $0x1
    2daf:	e8 25 0b 00 00       	call   38d9 <sbrk>
  c = sbrk(1);
    2db4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dbb:	e8 19 0b 00 00       	call   38d9 <sbrk>
  if(c != a + 1){
    2dc0:	83 c4 10             	add    $0x10,%esp
    2dc3:	39 f0                	cmp    %esi,%eax
    2dc5:	0f 85 56 03 00 00    	jne    3121 <sbrktest+0x3f1>
  if(pid == 0)
    2dcb:	85 ff                	test   %edi,%edi
    2dcd:	0f 84 49 03 00 00    	je     311c <sbrktest+0x3ec>
  wait();
    2dd3:	e8 81 0a 00 00       	call   3859 <wait>
  a = sbrk(0);
    2dd8:	83 ec 0c             	sub    $0xc,%esp
    2ddb:	6a 00                	push   $0x0
    2ddd:	e8 f7 0a 00 00       	call   38d9 <sbrk>
    2de2:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    2de4:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2de9:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    2deb:	89 04 24             	mov    %eax,(%esp)
    2dee:	e8 e6 0a 00 00       	call   38d9 <sbrk>
  if (p != a) {
    2df3:	83 c4 10             	add    $0x10,%esp
    2df6:	39 c6                	cmp    %eax,%esi
    2df8:	0f 85 07 03 00 00    	jne    3105 <sbrktest+0x3d5>
  a = sbrk(0);
    2dfe:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    2e01:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2e08:	6a 00                	push   $0x0
    2e0a:	e8 ca 0a 00 00       	call   38d9 <sbrk>
  c = sbrk(-4096);
    2e0f:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    2e16:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    2e18:	e8 bc 0a 00 00       	call   38d9 <sbrk>
  if(c == (char*)0xffffffff){
    2e1d:	83 c4 10             	add    $0x10,%esp
    2e20:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e23:	0f 84 c5 02 00 00    	je     30ee <sbrktest+0x3be>
  c = sbrk(0);
    2e29:	83 ec 0c             	sub    $0xc,%esp
    2e2c:	6a 00                	push   $0x0
    2e2e:	e8 a6 0a 00 00       	call   38d9 <sbrk>
  if(c != a - 4096){
    2e33:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    2e39:	83 c4 10             	add    $0x10,%esp
    2e3c:	39 d0                	cmp    %edx,%eax
    2e3e:	0f 85 93 02 00 00    	jne    30d7 <sbrktest+0x3a7>
  a = sbrk(0);
    2e44:	83 ec 0c             	sub    $0xc,%esp
    2e47:	6a 00                	push   $0x0
    2e49:	e8 8b 0a 00 00       	call   38d9 <sbrk>
  c = sbrk(4096);
    2e4e:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  a = sbrk(0);
    2e55:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2e57:	e8 7d 0a 00 00       	call   38d9 <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    2e5c:	83 c4 10             	add    $0x10,%esp
  c = sbrk(4096);
    2e5f:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    2e61:	39 c6                	cmp    %eax,%esi
    2e63:	0f 85 57 02 00 00    	jne    30c0 <sbrktest+0x390>
    2e69:	83 ec 0c             	sub    $0xc,%esp
    2e6c:	6a 00                	push   $0x0
    2e6e:	e8 66 0a 00 00       	call   38d9 <sbrk>
    2e73:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    2e79:	83 c4 10             	add    $0x10,%esp
    2e7c:	39 d0                	cmp    %edx,%eax
    2e7e:	0f 85 3c 02 00 00    	jne    30c0 <sbrktest+0x390>
  if(*lastaddr == 99){
    2e84:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2e8b:	0f 84 18 02 00 00    	je     30a9 <sbrktest+0x379>
  a = sbrk(0);
    2e91:	83 ec 0c             	sub    $0xc,%esp
    2e94:	6a 00                	push   $0x0
    2e96:	e8 3e 0a 00 00       	call   38d9 <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    2e9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    2ea2:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    2ea4:	e8 30 0a 00 00       	call   38d9 <sbrk>
    2ea9:	89 d9                	mov    %ebx,%ecx
    2eab:	29 c1                	sub    %eax,%ecx
    2ead:	89 0c 24             	mov    %ecx,(%esp)
    2eb0:	e8 24 0a 00 00       	call   38d9 <sbrk>
  if(c != a){
    2eb5:	83 c4 10             	add    $0x10,%esp
    2eb8:	39 c6                	cmp    %eax,%esi
    2eba:	0f 85 d2 01 00 00    	jne    3092 <sbrktest+0x362>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2ec0:	be 00 00 00 80       	mov    $0x80000000,%esi
    2ec5:	8d 76 00             	lea    0x0(%esi),%esi
    ppid = getpid();
    2ec8:	e8 04 0a 00 00       	call   38d1 <getpid>
    2ecd:	89 c7                	mov    %eax,%edi
    pid = fork();
    2ecf:	e8 75 09 00 00       	call   3849 <fork>
    if(pid < 0){
    2ed4:	85 c0                	test   %eax,%eax
    2ed6:	0f 88 9e 01 00 00    	js     307a <sbrktest+0x34a>
    if(pid == 0){
    2edc:	0f 84 76 01 00 00    	je     3058 <sbrktest+0x328>
    wait();
    2ee2:	e8 72 09 00 00       	call   3859 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2ee7:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    2eed:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    2ef3:	75 d3                	jne    2ec8 <sbrktest+0x198>
  if(pipe(fds) != 0){
    2ef5:	83 ec 0c             	sub    $0xc,%esp
    2ef8:	8d 45 b8             	lea    -0x48(%ebp),%eax
    2efb:	50                   	push   %eax
    2efc:	e8 60 09 00 00       	call   3861 <pipe>
    2f01:	83 c4 10             	add    $0x10,%esp
    2f04:	85 c0                	test   %eax,%eax
    2f06:	0f 85 34 01 00 00    	jne    3040 <sbrktest+0x310>
    2f0c:	8d 75 c0             	lea    -0x40(%ebp),%esi
    2f0f:	89 f7                	mov    %esi,%edi
    if((pids[i] = fork()) == 0){
    2f11:	e8 33 09 00 00       	call   3849 <fork>
    2f16:	89 07                	mov    %eax,(%edi)
    2f18:	85 c0                	test   %eax,%eax
    2f1a:	0f 84 8f 00 00 00    	je     2faf <sbrktest+0x27f>
    if(pids[i] != -1)
    2f20:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f23:	74 14                	je     2f39 <sbrktest+0x209>
      read(fds[0], &scratch, 1);
    2f25:	83 ec 04             	sub    $0x4,%esp
    2f28:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2f2b:	6a 01                	push   $0x1
    2f2d:	50                   	push   %eax
    2f2e:	ff 75 b8             	pushl  -0x48(%ebp)
    2f31:	e8 33 09 00 00       	call   3869 <read>
    2f36:	83 c4 10             	add    $0x10,%esp
    2f39:	83 c7 04             	add    $0x4,%edi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f3c:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2f3f:	39 c7                	cmp    %eax,%edi
    2f41:	75 ce                	jne    2f11 <sbrktest+0x1e1>
  c = sbrk(4096);
    2f43:	83 ec 0c             	sub    $0xc,%esp
    2f46:	68 00 10 00 00       	push   $0x1000
    2f4b:	e8 89 09 00 00       	call   38d9 <sbrk>
    2f50:	83 c4 10             	add    $0x10,%esp
    2f53:	89 c7                	mov    %eax,%edi
    if(pids[i] == -1)
    2f55:	8b 06                	mov    (%esi),%eax
    2f57:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f5a:	74 11                	je     2f6d <sbrktest+0x23d>
    kill(pids[i]);
    2f5c:	83 ec 0c             	sub    $0xc,%esp
    2f5f:	50                   	push   %eax
    2f60:	e8 1c 09 00 00       	call   3881 <kill>
    wait();
    2f65:	e8 ef 08 00 00       	call   3859 <wait>
    2f6a:	83 c4 10             	add    $0x10,%esp
    2f6d:	83 c6 04             	add    $0x4,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f70:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2f73:	39 f0                	cmp    %esi,%eax
    2f75:	75 de                	jne    2f55 <sbrktest+0x225>
  if(c == (char*)0xffffffff){
    2f77:	83 ff ff             	cmp    $0xffffffff,%edi
    2f7a:	0f 84 a9 00 00 00    	je     3029 <sbrktest+0x2f9>
  if(sbrk(0) > oldbrk)
    2f80:	83 ec 0c             	sub    $0xc,%esp
    2f83:	6a 00                	push   $0x0
    2f85:	e8 4f 09 00 00       	call   38d9 <sbrk>
    2f8a:	83 c4 10             	add    $0x10,%esp
    2f8d:	39 d8                	cmp    %ebx,%eax
    2f8f:	77 61                	ja     2ff2 <sbrktest+0x2c2>
  printf(stdout, "sbrk test OK\n");
    2f91:	83 ec 08             	sub    $0x8,%esp
    2f94:	68 c0 4b 00 00       	push   $0x4bc0
    2f99:	ff 35 74 5d 00 00    	pushl  0x5d74
    2f9f:	e8 1c 0a 00 00       	call   39c0 <printf>
}
    2fa4:	83 c4 10             	add    $0x10,%esp
    2fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2faa:	5b                   	pop    %ebx
    2fab:	5e                   	pop    %esi
    2fac:	5f                   	pop    %edi
    2fad:	5d                   	pop    %ebp
    2fae:	c3                   	ret    
      sbrk(BIG - (uint)sbrk(0));
    2faf:	83 ec 0c             	sub    $0xc,%esp
    2fb2:	6a 00                	push   $0x0
    2fb4:	e8 20 09 00 00       	call   38d9 <sbrk>
    2fb9:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2fbe:	29 c2                	sub    %eax,%edx
    2fc0:	89 14 24             	mov    %edx,(%esp)
    2fc3:	e8 11 09 00 00       	call   38d9 <sbrk>
      write(fds[1], "x", 1);
    2fc8:	83 c4 0c             	add    $0xc,%esp
    2fcb:	6a 01                	push   $0x1
    2fcd:	68 81 46 00 00       	push   $0x4681
    2fd2:	ff 75 bc             	pushl  -0x44(%ebp)
    2fd5:	e8 97 08 00 00       	call   3871 <write>
    2fda:	83 c4 10             	add    $0x10,%esp
    2fdd:	8d 76 00             	lea    0x0(%esi),%esi
      for(;;) sleep(1000);
    2fe0:	83 ec 0c             	sub    $0xc,%esp
    2fe3:	68 e8 03 00 00       	push   $0x3e8
    2fe8:	e8 f4 08 00 00       	call   38e1 <sleep>
    2fed:	83 c4 10             	add    $0x10,%esp
    2ff0:	eb ee                	jmp    2fe0 <sbrktest+0x2b0>
    sbrk(-(sbrk(0) - oldbrk));
    2ff2:	83 ec 0c             	sub    $0xc,%esp
    2ff5:	6a 00                	push   $0x0
    2ff7:	e8 dd 08 00 00       	call   38d9 <sbrk>
    2ffc:	29 c3                	sub    %eax,%ebx
    2ffe:	89 1c 24             	mov    %ebx,(%esp)
    3001:	e8 d3 08 00 00       	call   38d9 <sbrk>
    3006:	83 c4 10             	add    $0x10,%esp
    3009:	eb 86                	jmp    2f91 <sbrktest+0x261>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    300b:	83 ec 0c             	sub    $0xc,%esp
    300e:	50                   	push   %eax
    300f:	56                   	push   %esi
    3010:	57                   	push   %edi
    3011:	68 23 4b 00 00       	push   $0x4b23
    3016:	ff 35 74 5d 00 00    	pushl  0x5d74
    301c:	e8 9f 09 00 00       	call   39c0 <printf>
      exit();
    3021:	83 c4 20             	add    $0x20,%esp
    3024:	e8 28 08 00 00       	call   3851 <exit>
    printf(stdout, "failed sbrk leaked memory\n");
    3029:	50                   	push   %eax
    302a:	50                   	push   %eax
    302b:	68 a5 4b 00 00       	push   $0x4ba5
    3030:	ff 35 74 5d 00 00    	pushl  0x5d74
    3036:	e8 85 09 00 00       	call   39c0 <printf>
    exit();
    303b:	e8 11 08 00 00       	call   3851 <exit>
    printf(1, "pipe() failed\n");
    3040:	52                   	push   %edx
    3041:	52                   	push   %edx
    3042:	68 61 40 00 00       	push   $0x4061
    3047:	6a 01                	push   $0x1
    3049:	e8 72 09 00 00       	call   39c0 <printf>
    exit();
    304e:	e8 fe 07 00 00       	call   3851 <exit>
    3053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3057:	90                   	nop
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3058:	0f be 06             	movsbl (%esi),%eax
    305b:	50                   	push   %eax
    305c:	56                   	push   %esi
    305d:	68 8c 4b 00 00       	push   $0x4b8c
    3062:	ff 35 74 5d 00 00    	pushl  0x5d74
    3068:	e8 53 09 00 00       	call   39c0 <printf>
      kill(ppid);
    306d:	89 3c 24             	mov    %edi,(%esp)
    3070:	e8 0c 08 00 00       	call   3881 <kill>
      exit();
    3075:	e8 d7 07 00 00       	call   3851 <exit>
      printf(stdout, "fork failed\n");
    307a:	83 ec 08             	sub    $0x8,%esp
    307d:	68 69 4c 00 00       	push   $0x4c69
    3082:	ff 35 74 5d 00 00    	pushl  0x5d74
    3088:	e8 33 09 00 00       	call   39c0 <printf>
      exit();
    308d:	e8 bf 07 00 00       	call   3851 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3092:	50                   	push   %eax
    3093:	56                   	push   %esi
    3094:	68 48 53 00 00       	push   $0x5348
    3099:	ff 35 74 5d 00 00    	pushl  0x5d74
    309f:	e8 1c 09 00 00       	call   39c0 <printf>
    exit();
    30a4:	e8 a8 07 00 00       	call   3851 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    30a9:	51                   	push   %ecx
    30aa:	51                   	push   %ecx
    30ab:	68 18 53 00 00       	push   $0x5318
    30b0:	ff 35 74 5d 00 00    	pushl  0x5d74
    30b6:	e8 05 09 00 00       	call   39c0 <printf>
    exit();
    30bb:	e8 91 07 00 00       	call   3851 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    30c0:	57                   	push   %edi
    30c1:	56                   	push   %esi
    30c2:	68 f0 52 00 00       	push   $0x52f0
    30c7:	ff 35 74 5d 00 00    	pushl  0x5d74
    30cd:	e8 ee 08 00 00       	call   39c0 <printf>
    exit();
    30d2:	e8 7a 07 00 00       	call   3851 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    30d7:	50                   	push   %eax
    30d8:	56                   	push   %esi
    30d9:	68 b8 52 00 00       	push   $0x52b8
    30de:	ff 35 74 5d 00 00    	pushl  0x5d74
    30e4:	e8 d7 08 00 00       	call   39c0 <printf>
    exit();
    30e9:	e8 63 07 00 00       	call   3851 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    30ee:	53                   	push   %ebx
    30ef:	53                   	push   %ebx
    30f0:	68 71 4b 00 00       	push   $0x4b71
    30f5:	ff 35 74 5d 00 00    	pushl  0x5d74
    30fb:	e8 c0 08 00 00       	call   39c0 <printf>
    exit();
    3100:	e8 4c 07 00 00       	call   3851 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3105:	56                   	push   %esi
    3106:	56                   	push   %esi
    3107:	68 78 52 00 00       	push   $0x5278
    310c:	ff 35 74 5d 00 00    	pushl  0x5d74
    3112:	e8 a9 08 00 00       	call   39c0 <printf>
    exit();
    3117:	e8 35 07 00 00       	call   3851 <exit>
    exit();
    311c:	e8 30 07 00 00       	call   3851 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    3121:	57                   	push   %edi
    3122:	57                   	push   %edi
    3123:	68 55 4b 00 00       	push   $0x4b55
    3128:	ff 35 74 5d 00 00    	pushl  0x5d74
    312e:	e8 8d 08 00 00       	call   39c0 <printf>
    exit();
    3133:	e8 19 07 00 00       	call   3851 <exit>
    printf(stdout, "sbrk test fork failed\n");
    3138:	50                   	push   %eax
    3139:	50                   	push   %eax
    313a:	68 3e 4b 00 00       	push   $0x4b3e
    313f:	ff 35 74 5d 00 00    	pushl  0x5d74
    3145:	e8 76 08 00 00       	call   39c0 <printf>
    exit();
    314a:	e8 02 07 00 00       	call   3851 <exit>
    314f:	90                   	nop

00003150 <validateint>:
}
    3150:	c3                   	ret    
    3151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    315f:	90                   	nop

00003160 <validatetest>:
{
    3160:	55                   	push   %ebp
    3161:	89 e5                	mov    %esp,%ebp
    3163:	56                   	push   %esi
    3164:	53                   	push   %ebx
  for(p = 0; p <= (uint)hi; p += 4096){
    3165:	31 db                	xor    %ebx,%ebx
  printf(stdout, "validate test\n");
    3167:	83 ec 08             	sub    $0x8,%esp
    316a:	68 ce 4b 00 00       	push   $0x4bce
    316f:	ff 35 74 5d 00 00    	pushl  0x5d74
    3175:	e8 46 08 00 00       	call   39c0 <printf>
    317a:	83 c4 10             	add    $0x10,%esp
    317d:	8d 76 00             	lea    0x0(%esi),%esi
    if((pid = fork()) == 0){
    3180:	e8 c4 06 00 00       	call   3849 <fork>
    3185:	89 c6                	mov    %eax,%esi
    3187:	85 c0                	test   %eax,%eax
    3189:	74 63                	je     31ee <validatetest+0x8e>
    sleep(0);
    318b:	83 ec 0c             	sub    $0xc,%esp
    318e:	6a 00                	push   $0x0
    3190:	e8 4c 07 00 00       	call   38e1 <sleep>
    sleep(0);
    3195:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    319c:	e8 40 07 00 00       	call   38e1 <sleep>
    kill(pid);
    31a1:	89 34 24             	mov    %esi,(%esp)
    31a4:	e8 d8 06 00 00       	call   3881 <kill>
    wait();
    31a9:	e8 ab 06 00 00       	call   3859 <wait>
    if(link("nosuchfile", (char*)p) != -1){
    31ae:	58                   	pop    %eax
    31af:	5a                   	pop    %edx
    31b0:	53                   	push   %ebx
    31b1:	68 dd 4b 00 00       	push   $0x4bdd
    31b6:	e8 f6 06 00 00       	call   38b1 <link>
    31bb:	83 c4 10             	add    $0x10,%esp
    31be:	83 f8 ff             	cmp    $0xffffffff,%eax
    31c1:	75 30                	jne    31f3 <validatetest+0x93>
  for(p = 0; p <= (uint)hi; p += 4096){
    31c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    31c9:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    31cf:	75 af                	jne    3180 <validatetest+0x20>
  printf(stdout, "validate ok\n");
    31d1:	83 ec 08             	sub    $0x8,%esp
    31d4:	68 01 4c 00 00       	push   $0x4c01
    31d9:	ff 35 74 5d 00 00    	pushl  0x5d74
    31df:	e8 dc 07 00 00       	call   39c0 <printf>
}
    31e4:	83 c4 10             	add    $0x10,%esp
    31e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
    31ea:	5b                   	pop    %ebx
    31eb:	5e                   	pop    %esi
    31ec:	5d                   	pop    %ebp
    31ed:	c3                   	ret    
      exit();
    31ee:	e8 5e 06 00 00       	call   3851 <exit>
      printf(stdout, "link should not succeed\n");
    31f3:	83 ec 08             	sub    $0x8,%esp
    31f6:	68 e8 4b 00 00       	push   $0x4be8
    31fb:	ff 35 74 5d 00 00    	pushl  0x5d74
    3201:	e8 ba 07 00 00       	call   39c0 <printf>
      exit();
    3206:	e8 46 06 00 00       	call   3851 <exit>
    320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    320f:	90                   	nop

00003210 <bsstest>:
{
    3210:	55                   	push   %ebp
    3211:	89 e5                	mov    %esp,%ebp
    3213:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    3216:	68 0e 4c 00 00       	push   $0x4c0e
    321b:	ff 35 74 5d 00 00    	pushl  0x5d74
    3221:	e8 9a 07 00 00       	call   39c0 <printf>
    if(uninit[i] != '\0'){
    3226:	83 c4 10             	add    $0x10,%esp
    3229:	80 3d 40 5e 00 00 00 	cmpb   $0x0,0x5e40
    3230:	75 39                	jne    326b <bsstest+0x5b>
  for(i = 0; i < sizeof(uninit); i++){
    3232:	b8 01 00 00 00       	mov    $0x1,%eax
    3237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    323e:	66 90                	xchg   %ax,%ax
    if(uninit[i] != '\0'){
    3240:	80 b8 40 5e 00 00 00 	cmpb   $0x0,0x5e40(%eax)
    3247:	75 22                	jne    326b <bsstest+0x5b>
  for(i = 0; i < sizeof(uninit); i++){
    3249:	83 c0 01             	add    $0x1,%eax
    324c:	3d 10 27 00 00       	cmp    $0x2710,%eax
    3251:	75 ed                	jne    3240 <bsstest+0x30>
  printf(stdout, "bss test ok\n");
    3253:	83 ec 08             	sub    $0x8,%esp
    3256:	68 29 4c 00 00       	push   $0x4c29
    325b:	ff 35 74 5d 00 00    	pushl  0x5d74
    3261:	e8 5a 07 00 00       	call   39c0 <printf>
}
    3266:	83 c4 10             	add    $0x10,%esp
    3269:	c9                   	leave  
    326a:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    326b:	83 ec 08             	sub    $0x8,%esp
    326e:	68 18 4c 00 00       	push   $0x4c18
    3273:	ff 35 74 5d 00 00    	pushl  0x5d74
    3279:	e8 42 07 00 00       	call   39c0 <printf>
      exit();
    327e:	e8 ce 05 00 00       	call   3851 <exit>
    3283:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    328a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003290 <bigargtest>:
{
    3290:	55                   	push   %ebp
    3291:	89 e5                	mov    %esp,%ebp
    3293:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    3296:	68 36 4c 00 00       	push   $0x4c36
    329b:	e8 01 06 00 00       	call   38a1 <unlink>
  pid = fork();
    32a0:	e8 a4 05 00 00       	call   3849 <fork>
  if(pid == 0){
    32a5:	83 c4 10             	add    $0x10,%esp
    32a8:	85 c0                	test   %eax,%eax
    32aa:	74 44                	je     32f0 <bigargtest+0x60>
  } else if(pid < 0){
    32ac:	0f 88 c5 00 00 00    	js     3377 <bigargtest+0xe7>
  wait();
    32b2:	e8 a2 05 00 00       	call   3859 <wait>
  fd = open("bigarg-ok", 0);
    32b7:	83 ec 08             	sub    $0x8,%esp
    32ba:	6a 00                	push   $0x0
    32bc:	68 36 4c 00 00       	push   $0x4c36
    32c1:	e8 cb 05 00 00       	call   3891 <open>
  if(fd < 0){
    32c6:	83 c4 10             	add    $0x10,%esp
    32c9:	85 c0                	test   %eax,%eax
    32cb:	0f 88 8f 00 00 00    	js     3360 <bigargtest+0xd0>
  close(fd);
    32d1:	83 ec 0c             	sub    $0xc,%esp
    32d4:	50                   	push   %eax
    32d5:	e8 9f 05 00 00       	call   3879 <close>
  unlink("bigarg-ok");
    32da:	c7 04 24 36 4c 00 00 	movl   $0x4c36,(%esp)
    32e1:	e8 bb 05 00 00       	call   38a1 <unlink>
}
    32e6:	83 c4 10             	add    $0x10,%esp
    32e9:	c9                   	leave  
    32ea:	c3                   	ret    
    32eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    32ef:	90                   	nop
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    32f0:	c7 04 85 a0 5d 00 00 	movl   $0x536c,0x5da0(,%eax,4)
    32f7:	6c 53 00 00 
    for(i = 0; i < MAXARG-1; i++)
    32fb:	83 c0 01             	add    $0x1,%eax
    32fe:	83 f8 1f             	cmp    $0x1f,%eax
    3301:	75 ed                	jne    32f0 <bigargtest+0x60>
    printf(stdout, "bigarg test\n");
    3303:	51                   	push   %ecx
    3304:	51                   	push   %ecx
    3305:	68 40 4c 00 00       	push   $0x4c40
    330a:	ff 35 74 5d 00 00    	pushl  0x5d74
    args[MAXARG-1] = 0;
    3310:	c7 05 1c 5e 00 00 00 	movl   $0x0,0x5e1c
    3317:	00 00 00 
    printf(stdout, "bigarg test\n");
    331a:	e8 a1 06 00 00       	call   39c0 <printf>
    exec("echo", args);
    331f:	58                   	pop    %eax
    3320:	5a                   	pop    %edx
    3321:	68 a0 5d 00 00       	push   $0x5da0
    3326:	68 0d 3e 00 00       	push   $0x3e0d
    332b:	e8 59 05 00 00       	call   3889 <exec>
    printf(stdout, "bigarg test ok\n");
    3330:	59                   	pop    %ecx
    3331:	58                   	pop    %eax
    3332:	68 4d 4c 00 00       	push   $0x4c4d
    3337:	ff 35 74 5d 00 00    	pushl  0x5d74
    333d:	e8 7e 06 00 00       	call   39c0 <printf>
    fd = open("bigarg-ok", O_CREATE);
    3342:	58                   	pop    %eax
    3343:	5a                   	pop    %edx
    3344:	68 00 02 00 00       	push   $0x200
    3349:	68 36 4c 00 00       	push   $0x4c36
    334e:	e8 3e 05 00 00       	call   3891 <open>
    close(fd);
    3353:	89 04 24             	mov    %eax,(%esp)
    3356:	e8 1e 05 00 00       	call   3879 <close>
    exit();
    335b:	e8 f1 04 00 00       	call   3851 <exit>
    printf(stdout, "bigarg test failed!\n");
    3360:	50                   	push   %eax
    3361:	50                   	push   %eax
    3362:	68 76 4c 00 00       	push   $0x4c76
    3367:	ff 35 74 5d 00 00    	pushl  0x5d74
    336d:	e8 4e 06 00 00       	call   39c0 <printf>
    exit();
    3372:	e8 da 04 00 00       	call   3851 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    3377:	52                   	push   %edx
    3378:	52                   	push   %edx
    3379:	68 5d 4c 00 00       	push   $0x4c5d
    337e:	ff 35 74 5d 00 00    	pushl  0x5d74
    3384:	e8 37 06 00 00       	call   39c0 <printf>
    exit();
    3389:	e8 c3 04 00 00       	call   3851 <exit>
    338e:	66 90                	xchg   %ax,%ax

00003390 <fsfull>:
{
    3390:	55                   	push   %ebp
    3391:	89 e5                	mov    %esp,%ebp
    3393:	57                   	push   %edi
    3394:	56                   	push   %esi
  for(nfiles = 0; ; nfiles++){
    3395:	31 f6                	xor    %esi,%esi
{
    3397:	53                   	push   %ebx
    3398:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    339b:	68 8b 4c 00 00       	push   $0x4c8b
    33a0:	6a 01                	push   $0x1
    33a2:	e8 19 06 00 00       	call   39c0 <printf>
    33a7:	83 c4 10             	add    $0x10,%esp
    33aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    33b0:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    33b5:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    33ba:	83 ec 04             	sub    $0x4,%esp
    name[0] = 'f';
    33bd:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    33c1:	f7 e6                	mul    %esi
    name[5] = '\0';
    33c3:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    33c7:	c1 ea 06             	shr    $0x6,%edx
    33ca:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    33cd:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    33d3:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    33d6:	89 f0                	mov    %esi,%eax
    33d8:	29 d0                	sub    %edx,%eax
    33da:	89 c2                	mov    %eax,%edx
    33dc:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    33e1:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    33e3:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    33e8:	c1 ea 05             	shr    $0x5,%edx
    33eb:	83 c2 30             	add    $0x30,%edx
    33ee:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    33f1:	f7 e6                	mul    %esi
    33f3:	89 f0                	mov    %esi,%eax
    33f5:	c1 ea 05             	shr    $0x5,%edx
    33f8:	6b d2 64             	imul   $0x64,%edx,%edx
    33fb:	29 d0                	sub    %edx,%eax
    33fd:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    33ff:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3401:	c1 ea 03             	shr    $0x3,%edx
    3404:	83 c2 30             	add    $0x30,%edx
    3407:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    340a:	f7 e1                	mul    %ecx
    340c:	89 f1                	mov    %esi,%ecx
    340e:	c1 ea 03             	shr    $0x3,%edx
    3411:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3414:	01 c0                	add    %eax,%eax
    3416:	29 c1                	sub    %eax,%ecx
    3418:	89 c8                	mov    %ecx,%eax
    341a:	83 c0 30             	add    $0x30,%eax
    341d:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    3420:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3423:	50                   	push   %eax
    3424:	68 98 4c 00 00       	push   $0x4c98
    3429:	6a 01                	push   $0x1
    342b:	e8 90 05 00 00       	call   39c0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3430:	58                   	pop    %eax
    3431:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3434:	5a                   	pop    %edx
    3435:	68 02 02 00 00       	push   $0x202
    343a:	50                   	push   %eax
    343b:	e8 51 04 00 00       	call   3891 <open>
    if(fd < 0){
    3440:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    3443:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    3445:	85 c0                	test   %eax,%eax
    3447:	78 4d                	js     3496 <fsfull+0x106>
    int total = 0;
    3449:	31 db                	xor    %ebx,%ebx
    344b:	eb 05                	jmp    3452 <fsfull+0xc2>
    344d:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    3450:	01 c3                	add    %eax,%ebx
      int cc = write(fd, buf, 512);
    3452:	83 ec 04             	sub    $0x4,%esp
    3455:	68 00 02 00 00       	push   $0x200
    345a:	68 60 85 00 00       	push   $0x8560
    345f:	57                   	push   %edi
    3460:	e8 0c 04 00 00       	call   3871 <write>
      if(cc < 512)
    3465:	83 c4 10             	add    $0x10,%esp
    3468:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    346d:	7f e1                	jg     3450 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    346f:	83 ec 04             	sub    $0x4,%esp
    3472:	53                   	push   %ebx
    3473:	68 b4 4c 00 00       	push   $0x4cb4
    3478:	6a 01                	push   $0x1
    347a:	e8 41 05 00 00       	call   39c0 <printf>
    close(fd);
    347f:	89 3c 24             	mov    %edi,(%esp)
    3482:	e8 f2 03 00 00       	call   3879 <close>
    if(total == 0)
    3487:	83 c4 10             	add    $0x10,%esp
    348a:	85 db                	test   %ebx,%ebx
    348c:	74 1e                	je     34ac <fsfull+0x11c>
  for(nfiles = 0; ; nfiles++){
    348e:	83 c6 01             	add    $0x1,%esi
    3491:	e9 1a ff ff ff       	jmp    33b0 <fsfull+0x20>
      printf(1, "open %s failed\n", name);
    3496:	83 ec 04             	sub    $0x4,%esp
    3499:	8d 45 a8             	lea    -0x58(%ebp),%eax
    349c:	50                   	push   %eax
    349d:	68 a4 4c 00 00       	push   $0x4ca4
    34a2:	6a 01                	push   $0x1
    34a4:	e8 17 05 00 00       	call   39c0 <printf>
      break;
    34a9:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    34ac:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    34b1:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
    34b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    34bd:	8d 76 00             	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    34c0:	89 f0                	mov    %esi,%eax
    34c2:	89 f1                	mov    %esi,%ecx
    unlink(name);
    34c4:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'f';
    34c7:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    34cb:	f7 ef                	imul   %edi
    34cd:	c1 f9 1f             	sar    $0x1f,%ecx
    name[5] = '\0';
    34d0:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    34d4:	c1 fa 06             	sar    $0x6,%edx
    34d7:	29 ca                	sub    %ecx,%edx
    34d9:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    34dc:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    34e2:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    34e5:	89 f0                	mov    %esi,%eax
    34e7:	29 d0                	sub    %edx,%eax
    34e9:	f7 e3                	mul    %ebx
    name[3] = '0' + (nfiles % 100) / 10;
    34eb:	89 f0                	mov    %esi,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    34ed:	c1 ea 05             	shr    $0x5,%edx
    34f0:	83 c2 30             	add    $0x30,%edx
    34f3:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    34f6:	f7 eb                	imul   %ebx
    34f8:	89 f0                	mov    %esi,%eax
    34fa:	c1 fa 05             	sar    $0x5,%edx
    34fd:	29 ca                	sub    %ecx,%edx
    34ff:	6b d2 64             	imul   $0x64,%edx,%edx
    3502:	29 d0                	sub    %edx,%eax
    3504:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    3509:	f7 e2                	mul    %edx
    name[4] = '0' + (nfiles % 10);
    350b:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    350d:	c1 ea 03             	shr    $0x3,%edx
    3510:	83 c2 30             	add    $0x30,%edx
    3513:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3516:	ba 67 66 66 66       	mov    $0x66666667,%edx
    351b:	f7 ea                	imul   %edx
    351d:	c1 fa 02             	sar    $0x2,%edx
    3520:	29 ca                	sub    %ecx,%edx
    3522:	89 f1                	mov    %esi,%ecx
    nfiles--;
    3524:	83 ee 01             	sub    $0x1,%esi
    name[4] = '0' + (nfiles % 10);
    3527:	8d 04 92             	lea    (%edx,%edx,4),%eax
    352a:	01 c0                	add    %eax,%eax
    352c:	29 c1                	sub    %eax,%ecx
    352e:	89 c8                	mov    %ecx,%eax
    3530:	83 c0 30             	add    $0x30,%eax
    3533:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    3536:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3539:	50                   	push   %eax
    353a:	e8 62 03 00 00       	call   38a1 <unlink>
  while(nfiles >= 0){
    353f:	83 c4 10             	add    $0x10,%esp
    3542:	83 fe ff             	cmp    $0xffffffff,%esi
    3545:	0f 85 75 ff ff ff    	jne    34c0 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    354b:	83 ec 08             	sub    $0x8,%esp
    354e:	68 c4 4c 00 00       	push   $0x4cc4
    3553:	6a 01                	push   $0x1
    3555:	e8 66 04 00 00       	call   39c0 <printf>
}
    355a:	83 c4 10             	add    $0x10,%esp
    355d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3560:	5b                   	pop    %ebx
    3561:	5e                   	pop    %esi
    3562:	5f                   	pop    %edi
    3563:	5d                   	pop    %ebp
    3564:	c3                   	ret    
    3565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003570 <uio>:
{
    3570:	55                   	push   %ebp
    3571:	89 e5                	mov    %esp,%ebp
    3573:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    3576:	68 da 4c 00 00       	push   $0x4cda
    357b:	6a 01                	push   $0x1
    357d:	e8 3e 04 00 00       	call   39c0 <printf>
  pid = fork();
    3582:	e8 c2 02 00 00       	call   3849 <fork>
  if(pid == 0){
    3587:	83 c4 10             	add    $0x10,%esp
    358a:	85 c0                	test   %eax,%eax
    358c:	74 1b                	je     35a9 <uio+0x39>
  } else if(pid < 0){
    358e:	78 3d                	js     35cd <uio+0x5d>
  wait();
    3590:	e8 c4 02 00 00       	call   3859 <wait>
  printf(1, "uio test done\n");
    3595:	83 ec 08             	sub    $0x8,%esp
    3598:	68 e4 4c 00 00       	push   $0x4ce4
    359d:	6a 01                	push   $0x1
    359f:	e8 1c 04 00 00       	call   39c0 <printf>
}
    35a4:	83 c4 10             	add    $0x10,%esp
    35a7:	c9                   	leave  
    35a8:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    35a9:	b8 09 00 00 00       	mov    $0x9,%eax
    35ae:	ba 70 00 00 00       	mov    $0x70,%edx
    35b3:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    35b4:	ba 71 00 00 00       	mov    $0x71,%edx
    35b9:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    35ba:	52                   	push   %edx
    35bb:	52                   	push   %edx
    35bc:	68 4c 54 00 00       	push   $0x544c
    35c1:	6a 01                	push   $0x1
    35c3:	e8 f8 03 00 00       	call   39c0 <printf>
    exit();
    35c8:	e8 84 02 00 00       	call   3851 <exit>
    printf (1, "fork failed\n");
    35cd:	50                   	push   %eax
    35ce:	50                   	push   %eax
    35cf:	68 69 4c 00 00       	push   $0x4c69
    35d4:	6a 01                	push   $0x1
    35d6:	e8 e5 03 00 00       	call   39c0 <printf>
    exit();
    35db:	e8 71 02 00 00       	call   3851 <exit>

000035e0 <rand>:
  randstate = randstate * 1664525 + 1013904223;
    35e0:	69 05 70 5d 00 00 0d 	imul   $0x19660d,0x5d70,%eax
    35e7:	66 19 00 
    35ea:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    35ef:	a3 70 5d 00 00       	mov    %eax,0x5d70
}
    35f4:	c3                   	ret    
    35f5:	66 90                	xchg   %ax,%ax
    35f7:	66 90                	xchg   %ax,%ax
    35f9:	66 90                	xchg   %ax,%ax
    35fb:	66 90                	xchg   %ax,%ax
    35fd:	66 90                	xchg   %ax,%ax
    35ff:	90                   	nop

00003600 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3600:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3601:	31 d2                	xor    %edx,%edx
{
    3603:	89 e5                	mov    %esp,%ebp
    3605:	53                   	push   %ebx
    3606:	8b 45 08             	mov    0x8(%ebp),%eax
    3609:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
    3610:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
    3614:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    3617:	83 c2 01             	add    $0x1,%edx
    361a:	84 c9                	test   %cl,%cl
    361c:	75 f2                	jne    3610 <strcpy+0x10>
    ;
  return os;
}
    361e:	5b                   	pop    %ebx
    361f:	5d                   	pop    %ebp
    3620:	c3                   	ret    
    3621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    362f:	90                   	nop

00003630 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3630:	55                   	push   %ebp
    3631:	89 e5                	mov    %esp,%ebp
    3633:	56                   	push   %esi
    3634:	53                   	push   %ebx
    3635:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3638:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
    363b:	0f b6 13             	movzbl (%ebx),%edx
    363e:	0f b6 0e             	movzbl (%esi),%ecx
    3641:	84 d2                	test   %dl,%dl
    3643:	74 1e                	je     3663 <strcmp+0x33>
    3645:	b8 01 00 00 00       	mov    $0x1,%eax
    364a:	38 ca                	cmp    %cl,%dl
    364c:	74 09                	je     3657 <strcmp+0x27>
    364e:	eb 20                	jmp    3670 <strcmp+0x40>
    3650:	83 c0 01             	add    $0x1,%eax
    3653:	38 ca                	cmp    %cl,%dl
    3655:	75 19                	jne    3670 <strcmp+0x40>
    3657:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    365b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
    365f:	84 d2                	test   %dl,%dl
    3661:	75 ed                	jne    3650 <strcmp+0x20>
    3663:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    3665:	5b                   	pop    %ebx
    3666:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
    3667:	29 c8                	sub    %ecx,%eax
}
    3669:	5d                   	pop    %ebp
    366a:	c3                   	ret    
    366b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    366f:	90                   	nop
    3670:	0f b6 c2             	movzbl %dl,%eax
    3673:	5b                   	pop    %ebx
    3674:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
    3675:	29 c8                	sub    %ecx,%eax
}
    3677:	5d                   	pop    %ebp
    3678:	c3                   	ret    
    3679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00003680 <strlen>:

uint
strlen(char *s)
{
    3680:	55                   	push   %ebp
    3681:	89 e5                	mov    %esp,%ebp
    3683:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    3686:	80 39 00             	cmpb   $0x0,(%ecx)
    3689:	74 15                	je     36a0 <strlen+0x20>
    368b:	31 d2                	xor    %edx,%edx
    368d:	8d 76 00             	lea    0x0(%esi),%esi
    3690:	83 c2 01             	add    $0x1,%edx
    3693:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    3697:	89 d0                	mov    %edx,%eax
    3699:	75 f5                	jne    3690 <strlen+0x10>
    ;
  return n;
}
    369b:	5d                   	pop    %ebp
    369c:	c3                   	ret    
    369d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    36a0:	31 c0                	xor    %eax,%eax
}
    36a2:	5d                   	pop    %ebp
    36a3:	c3                   	ret    
    36a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    36ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    36af:	90                   	nop

000036b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    36b0:	55                   	push   %ebp
    36b1:	89 e5                	mov    %esp,%ebp
    36b3:	57                   	push   %edi
    36b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    36b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    36ba:	8b 45 0c             	mov    0xc(%ebp),%eax
    36bd:	89 d7                	mov    %edx,%edi
    36bf:	fc                   	cld    
    36c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    36c2:	89 d0                	mov    %edx,%eax
    36c4:	5f                   	pop    %edi
    36c5:	5d                   	pop    %ebp
    36c6:	c3                   	ret    
    36c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    36ce:	66 90                	xchg   %ax,%ax

000036d0 <strchr>:

char*
strchr(const char *s, char c)
{
    36d0:	55                   	push   %ebp
    36d1:	89 e5                	mov    %esp,%ebp
    36d3:	53                   	push   %ebx
    36d4:	8b 45 08             	mov    0x8(%ebp),%eax
    36d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    36da:	0f b6 18             	movzbl (%eax),%ebx
    36dd:	84 db                	test   %bl,%bl
    36df:	74 1d                	je     36fe <strchr+0x2e>
    36e1:	89 d1                	mov    %edx,%ecx
    if(*s == c)
    36e3:	38 d3                	cmp    %dl,%bl
    36e5:	75 0d                	jne    36f4 <strchr+0x24>
    36e7:	eb 17                	jmp    3700 <strchr+0x30>
    36e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    36f0:	38 ca                	cmp    %cl,%dl
    36f2:	74 0c                	je     3700 <strchr+0x30>
  for(; *s; s++)
    36f4:	83 c0 01             	add    $0x1,%eax
    36f7:	0f b6 10             	movzbl (%eax),%edx
    36fa:	84 d2                	test   %dl,%dl
    36fc:	75 f2                	jne    36f0 <strchr+0x20>
      return (char*)s;
  return 0;
    36fe:	31 c0                	xor    %eax,%eax
}
    3700:	5b                   	pop    %ebx
    3701:	5d                   	pop    %ebp
    3702:	c3                   	ret    
    3703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003710 <gets>:

char*
gets(char *buf, int max)
{
    3710:	55                   	push   %ebp
    3711:	89 e5                	mov    %esp,%ebp
    3713:	57                   	push   %edi
    3714:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3715:	31 f6                	xor    %esi,%esi
{
    3717:	53                   	push   %ebx
    3718:	89 f3                	mov    %esi,%ebx
    371a:	83 ec 1c             	sub    $0x1c,%esp
    371d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    3720:	eb 2f                	jmp    3751 <gets+0x41>
    3722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    3728:	83 ec 04             	sub    $0x4,%esp
    372b:	8d 45 e7             	lea    -0x19(%ebp),%eax
    372e:	6a 01                	push   $0x1
    3730:	50                   	push   %eax
    3731:	6a 00                	push   $0x0
    3733:	e8 31 01 00 00       	call   3869 <read>
    if(cc < 1)
    3738:	83 c4 10             	add    $0x10,%esp
    373b:	85 c0                	test   %eax,%eax
    373d:	7e 1c                	jle    375b <gets+0x4b>
      break;
    buf[i++] = c;
    373f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    3743:	83 c7 01             	add    $0x1,%edi
    3746:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    3749:	3c 0a                	cmp    $0xa,%al
    374b:	74 23                	je     3770 <gets+0x60>
    374d:	3c 0d                	cmp    $0xd,%al
    374f:	74 1f                	je     3770 <gets+0x60>
  for(i=0; i+1 < max; ){
    3751:	83 c3 01             	add    $0x1,%ebx
    3754:	89 fe                	mov    %edi,%esi
    3756:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3759:	7c cd                	jl     3728 <gets+0x18>
    375b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    375d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    3760:	c6 03 00             	movb   $0x0,(%ebx)
}
    3763:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3766:	5b                   	pop    %ebx
    3767:	5e                   	pop    %esi
    3768:	5f                   	pop    %edi
    3769:	5d                   	pop    %ebp
    376a:	c3                   	ret    
    376b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    376f:	90                   	nop
    3770:	8b 75 08             	mov    0x8(%ebp),%esi
    3773:	8b 45 08             	mov    0x8(%ebp),%eax
    3776:	01 de                	add    %ebx,%esi
    3778:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    377a:	c6 03 00             	movb   $0x0,(%ebx)
}
    377d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3780:	5b                   	pop    %ebx
    3781:	5e                   	pop    %esi
    3782:	5f                   	pop    %edi
    3783:	5d                   	pop    %ebp
    3784:	c3                   	ret    
    3785:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003790 <stat>:

int
stat(char *n, struct stat *st)
{
    3790:	55                   	push   %ebp
    3791:	89 e5                	mov    %esp,%ebp
    3793:	56                   	push   %esi
    3794:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3795:	83 ec 08             	sub    $0x8,%esp
    3798:	6a 00                	push   $0x0
    379a:	ff 75 08             	pushl  0x8(%ebp)
    379d:	e8 ef 00 00 00       	call   3891 <open>
  if(fd < 0)
    37a2:	83 c4 10             	add    $0x10,%esp
    37a5:	85 c0                	test   %eax,%eax
    37a7:	78 27                	js     37d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    37a9:	83 ec 08             	sub    $0x8,%esp
    37ac:	ff 75 0c             	pushl  0xc(%ebp)
    37af:	89 c3                	mov    %eax,%ebx
    37b1:	50                   	push   %eax
    37b2:	e8 f2 00 00 00       	call   38a9 <fstat>
  close(fd);
    37b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    37ba:	89 c6                	mov    %eax,%esi
  close(fd);
    37bc:	e8 b8 00 00 00       	call   3879 <close>
  return r;
    37c1:	83 c4 10             	add    $0x10,%esp
}
    37c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    37c7:	89 f0                	mov    %esi,%eax
    37c9:	5b                   	pop    %ebx
    37ca:	5e                   	pop    %esi
    37cb:	5d                   	pop    %ebp
    37cc:	c3                   	ret    
    37cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    37d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    37d5:	eb ed                	jmp    37c4 <stat+0x34>
    37d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37de:	66 90                	xchg   %ax,%ax

000037e0 <atoi>:

int
atoi(const char *s)
{
    37e0:	55                   	push   %ebp
    37e1:	89 e5                	mov    %esp,%ebp
    37e3:	53                   	push   %ebx
    37e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    37e7:	0f be 11             	movsbl (%ecx),%edx
    37ea:	8d 42 d0             	lea    -0x30(%edx),%eax
    37ed:	3c 09                	cmp    $0x9,%al
  n = 0;
    37ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    37f4:	77 1f                	ja     3815 <atoi+0x35>
    37f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37fd:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
    3800:	83 c1 01             	add    $0x1,%ecx
    3803:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3806:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    380a:	0f be 11             	movsbl (%ecx),%edx
    380d:	8d 5a d0             	lea    -0x30(%edx),%ebx
    3810:	80 fb 09             	cmp    $0x9,%bl
    3813:	76 eb                	jbe    3800 <atoi+0x20>
  return n;
}
    3815:	5b                   	pop    %ebx
    3816:	5d                   	pop    %ebp
    3817:	c3                   	ret    
    3818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    381f:	90                   	nop

00003820 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3820:	55                   	push   %ebp
    3821:	89 e5                	mov    %esp,%ebp
    3823:	57                   	push   %edi
    3824:	8b 55 10             	mov    0x10(%ebp),%edx
    3827:	8b 45 08             	mov    0x8(%ebp),%eax
    382a:	56                   	push   %esi
    382b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    382e:	85 d2                	test   %edx,%edx
    3830:	7e 13                	jle    3845 <memmove+0x25>
    3832:	01 c2                	add    %eax,%edx
  dst = vdst;
    3834:	89 c7                	mov    %eax,%edi
    3836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    383d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    3840:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    3841:	39 fa                	cmp    %edi,%edx
    3843:	75 fb                	jne    3840 <memmove+0x20>
  return vdst;
}
    3845:	5e                   	pop    %esi
    3846:	5f                   	pop    %edi
    3847:	5d                   	pop    %ebp
    3848:	c3                   	ret    

00003849 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3849:	b8 01 00 00 00       	mov    $0x1,%eax
    384e:	cd 40                	int    $0x40
    3850:	c3                   	ret    

00003851 <exit>:
SYSCALL(exit)
    3851:	b8 02 00 00 00       	mov    $0x2,%eax
    3856:	cd 40                	int    $0x40
    3858:	c3                   	ret    

00003859 <wait>:
SYSCALL(wait)
    3859:	b8 03 00 00 00       	mov    $0x3,%eax
    385e:	cd 40                	int    $0x40
    3860:	c3                   	ret    

00003861 <pipe>:
SYSCALL(pipe)
    3861:	b8 04 00 00 00       	mov    $0x4,%eax
    3866:	cd 40                	int    $0x40
    3868:	c3                   	ret    

00003869 <read>:
SYSCALL(read)
    3869:	b8 05 00 00 00       	mov    $0x5,%eax
    386e:	cd 40                	int    $0x40
    3870:	c3                   	ret    

00003871 <write>:
SYSCALL(write)
    3871:	b8 10 00 00 00       	mov    $0x10,%eax
    3876:	cd 40                	int    $0x40
    3878:	c3                   	ret    

00003879 <close>:
SYSCALL(close)
    3879:	b8 15 00 00 00       	mov    $0x15,%eax
    387e:	cd 40                	int    $0x40
    3880:	c3                   	ret    

00003881 <kill>:
SYSCALL(kill)
    3881:	b8 06 00 00 00       	mov    $0x6,%eax
    3886:	cd 40                	int    $0x40
    3888:	c3                   	ret    

00003889 <exec>:
SYSCALL(exec)
    3889:	b8 07 00 00 00       	mov    $0x7,%eax
    388e:	cd 40                	int    $0x40
    3890:	c3                   	ret    

00003891 <open>:
SYSCALL(open)
    3891:	b8 0f 00 00 00       	mov    $0xf,%eax
    3896:	cd 40                	int    $0x40
    3898:	c3                   	ret    

00003899 <mknod>:
SYSCALL(mknod)
    3899:	b8 11 00 00 00       	mov    $0x11,%eax
    389e:	cd 40                	int    $0x40
    38a0:	c3                   	ret    

000038a1 <unlink>:
SYSCALL(unlink)
    38a1:	b8 12 00 00 00       	mov    $0x12,%eax
    38a6:	cd 40                	int    $0x40
    38a8:	c3                   	ret    

000038a9 <fstat>:
SYSCALL(fstat)
    38a9:	b8 08 00 00 00       	mov    $0x8,%eax
    38ae:	cd 40                	int    $0x40
    38b0:	c3                   	ret    

000038b1 <link>:
SYSCALL(link)
    38b1:	b8 13 00 00 00       	mov    $0x13,%eax
    38b6:	cd 40                	int    $0x40
    38b8:	c3                   	ret    

000038b9 <mkdir>:
SYSCALL(mkdir)
    38b9:	b8 14 00 00 00       	mov    $0x14,%eax
    38be:	cd 40                	int    $0x40
    38c0:	c3                   	ret    

000038c1 <chdir>:
SYSCALL(chdir)
    38c1:	b8 09 00 00 00       	mov    $0x9,%eax
    38c6:	cd 40                	int    $0x40
    38c8:	c3                   	ret    

000038c9 <dup>:
SYSCALL(dup)
    38c9:	b8 0a 00 00 00       	mov    $0xa,%eax
    38ce:	cd 40                	int    $0x40
    38d0:	c3                   	ret    

000038d1 <getpid>:
SYSCALL(getpid)
    38d1:	b8 0b 00 00 00       	mov    $0xb,%eax
    38d6:	cd 40                	int    $0x40
    38d8:	c3                   	ret    

000038d9 <sbrk>:
SYSCALL(sbrk)
    38d9:	b8 0c 00 00 00       	mov    $0xc,%eax
    38de:	cd 40                	int    $0x40
    38e0:	c3                   	ret    

000038e1 <sleep>:
SYSCALL(sleep)
    38e1:	b8 0d 00 00 00       	mov    $0xd,%eax
    38e6:	cd 40                	int    $0x40
    38e8:	c3                   	ret    

000038e9 <uptime>:
SYSCALL(uptime)
    38e9:	b8 0e 00 00 00       	mov    $0xe,%eax
    38ee:	cd 40                	int    $0x40
    38f0:	c3                   	ret    
    38f1:	66 90                	xchg   %ax,%ax
    38f3:	66 90                	xchg   %ax,%ax
    38f5:	66 90                	xchg   %ax,%ax
    38f7:	66 90                	xchg   %ax,%ax
    38f9:	66 90                	xchg   %ax,%ax
    38fb:	66 90                	xchg   %ax,%ax
    38fd:	66 90                	xchg   %ax,%ax
    38ff:	90                   	nop

00003900 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    3900:	55                   	push   %ebp
    3901:	89 e5                	mov    %esp,%ebp
    3903:	57                   	push   %edi
    3904:	56                   	push   %esi
    3905:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    3906:	89 d3                	mov    %edx,%ebx
{
    3908:	83 ec 3c             	sub    $0x3c,%esp
    390b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
    390e:	85 d2                	test   %edx,%edx
    3910:	0f 89 92 00 00 00    	jns    39a8 <printint+0xa8>
    3916:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    391a:	0f 84 88 00 00 00    	je     39a8 <printint+0xa8>
    neg = 1;
    3920:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
    3927:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
    3929:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    3930:	8d 75 d7             	lea    -0x29(%ebp),%esi
    3933:	eb 08                	jmp    393d <printint+0x3d>
    3935:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    3938:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
    393b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
    393d:	89 d8                	mov    %ebx,%eax
    393f:	31 d2                	xor    %edx,%edx
    3941:	8b 7d c4             	mov    -0x3c(%ebp),%edi
    3944:	f7 f1                	div    %ecx
    3946:	83 c7 01             	add    $0x1,%edi
    3949:	0f b6 92 a4 54 00 00 	movzbl 0x54a4(%edx),%edx
    3950:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
    3953:	39 d9                	cmp    %ebx,%ecx
    3955:	76 e1                	jbe    3938 <printint+0x38>
  if(neg)
    3957:	8b 45 c0             	mov    -0x40(%ebp),%eax
    395a:	85 c0                	test   %eax,%eax
    395c:	74 0d                	je     396b <printint+0x6b>
    buf[i++] = '-';
    395e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    3963:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
    3968:	89 7d c4             	mov    %edi,-0x3c(%ebp)
    396b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    396e:	8b 7d bc             	mov    -0x44(%ebp),%edi
    3971:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    3975:	eb 0f                	jmp    3986 <printint+0x86>
    3977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    397e:	66 90                	xchg   %ax,%ax
    3980:	0f b6 13             	movzbl (%ebx),%edx
    3983:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    3986:	83 ec 04             	sub    $0x4,%esp
    3989:	88 55 d7             	mov    %dl,-0x29(%ebp)
    398c:	6a 01                	push   $0x1
    398e:	56                   	push   %esi
    398f:	57                   	push   %edi
    3990:	e8 dc fe ff ff       	call   3871 <write>

  while(--i >= 0)
    3995:	83 c4 10             	add    $0x10,%esp
    3998:	39 de                	cmp    %ebx,%esi
    399a:	75 e4                	jne    3980 <printint+0x80>
    putc(fd, buf[i]);
}
    399c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    399f:	5b                   	pop    %ebx
    39a0:	5e                   	pop    %esi
    39a1:	5f                   	pop    %edi
    39a2:	5d                   	pop    %ebp
    39a3:	c3                   	ret    
    39a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    39a8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
    39af:	e9 75 ff ff ff       	jmp    3929 <printint+0x29>
    39b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    39bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    39bf:	90                   	nop

000039c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    39c0:	55                   	push   %ebp
    39c1:	89 e5                	mov    %esp,%ebp
    39c3:	57                   	push   %edi
    39c4:	56                   	push   %esi
    39c5:	53                   	push   %ebx
    39c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    39c9:	8b 75 0c             	mov    0xc(%ebp),%esi
    39cc:	0f b6 1e             	movzbl (%esi),%ebx
    39cf:	84 db                	test   %bl,%bl
    39d1:	0f 84 b9 00 00 00    	je     3a90 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
    39d7:	8d 45 10             	lea    0x10(%ebp),%eax
    39da:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    39dd:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    39e0:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    39e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    39e5:	eb 38                	jmp    3a1f <printf+0x5f>
    39e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    39ee:	66 90                	xchg   %ax,%ax
    39f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    39f3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    39f8:	83 f8 25             	cmp    $0x25,%eax
    39fb:	74 17                	je     3a14 <printf+0x54>
  write(fd, &c, 1);
    39fd:	83 ec 04             	sub    $0x4,%esp
    3a00:	88 5d e7             	mov    %bl,-0x19(%ebp)
    3a03:	6a 01                	push   $0x1
    3a05:	57                   	push   %edi
    3a06:	ff 75 08             	pushl  0x8(%ebp)
    3a09:	e8 63 fe ff ff       	call   3871 <write>
    3a0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    3a11:	83 c4 10             	add    $0x10,%esp
    3a14:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    3a17:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    3a1b:	84 db                	test   %bl,%bl
    3a1d:	74 71                	je     3a90 <printf+0xd0>
    c = fmt[i] & 0xff;
    3a1f:	0f be cb             	movsbl %bl,%ecx
    3a22:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    3a25:	85 d2                	test   %edx,%edx
    3a27:	74 c7                	je     39f0 <printf+0x30>
      }
    } else if(state == '%'){
    3a29:	83 fa 25             	cmp    $0x25,%edx
    3a2c:	75 e6                	jne    3a14 <printf+0x54>
      if(c == 'd'){
    3a2e:	83 f8 64             	cmp    $0x64,%eax
    3a31:	0f 84 99 00 00 00    	je     3ad0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3a37:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    3a3d:	83 f9 70             	cmp    $0x70,%ecx
    3a40:	74 5e                	je     3aa0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3a42:	83 f8 73             	cmp    $0x73,%eax
    3a45:	0f 84 d5 00 00 00    	je     3b20 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3a4b:	83 f8 63             	cmp    $0x63,%eax
    3a4e:	0f 84 8c 00 00 00    	je     3ae0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3a54:	83 f8 25             	cmp    $0x25,%eax
    3a57:	0f 84 b3 00 00 00    	je     3b10 <printf+0x150>
  write(fd, &c, 1);
    3a5d:	83 ec 04             	sub    $0x4,%esp
    3a60:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3a64:	6a 01                	push   $0x1
    3a66:	57                   	push   %edi
    3a67:	ff 75 08             	pushl  0x8(%ebp)
    3a6a:	e8 02 fe ff ff       	call   3871 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    3a6f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3a72:	83 c4 0c             	add    $0xc,%esp
    3a75:	6a 01                	push   $0x1
    3a77:	83 c6 01             	add    $0x1,%esi
    3a7a:	57                   	push   %edi
    3a7b:	ff 75 08             	pushl  0x8(%ebp)
    3a7e:	e8 ee fd ff ff       	call   3871 <write>
  for(i = 0; fmt[i]; i++){
    3a83:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    3a87:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    3a8a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    3a8c:	84 db                	test   %bl,%bl
    3a8e:	75 8f                	jne    3a1f <printf+0x5f>
    }
  }
}
    3a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3a93:	5b                   	pop    %ebx
    3a94:	5e                   	pop    %esi
    3a95:	5f                   	pop    %edi
    3a96:	5d                   	pop    %ebp
    3a97:	c3                   	ret    
    3a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3a9f:	90                   	nop
        printint(fd, *ap, 16, 0);
    3aa0:	83 ec 0c             	sub    $0xc,%esp
    3aa3:	b9 10 00 00 00       	mov    $0x10,%ecx
    3aa8:	6a 00                	push   $0x0
    3aaa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    3aad:	8b 45 08             	mov    0x8(%ebp),%eax
    3ab0:	8b 13                	mov    (%ebx),%edx
    3ab2:	e8 49 fe ff ff       	call   3900 <printint>
        ap++;
    3ab7:	89 d8                	mov    %ebx,%eax
    3ab9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3abc:	31 d2                	xor    %edx,%edx
        ap++;
    3abe:	83 c0 04             	add    $0x4,%eax
    3ac1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3ac4:	e9 4b ff ff ff       	jmp    3a14 <printf+0x54>
    3ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    3ad0:	83 ec 0c             	sub    $0xc,%esp
    3ad3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3ad8:	6a 01                	push   $0x1
    3ada:	eb ce                	jmp    3aaa <printf+0xea>
    3adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    3ae0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    3ae3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    3ae6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    3ae8:	6a 01                	push   $0x1
        ap++;
    3aea:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    3aed:	57                   	push   %edi
    3aee:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    3af1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3af4:	e8 78 fd ff ff       	call   3871 <write>
        ap++;
    3af9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    3afc:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3aff:	31 d2                	xor    %edx,%edx
    3b01:	e9 0e ff ff ff       	jmp    3a14 <printf+0x54>
    3b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3b0d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    3b10:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3b13:	83 ec 04             	sub    $0x4,%esp
    3b16:	e9 5a ff ff ff       	jmp    3a75 <printf+0xb5>
    3b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3b1f:	90                   	nop
        s = (char*)*ap;
    3b20:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3b23:	8b 18                	mov    (%eax),%ebx
        ap++;
    3b25:	83 c0 04             	add    $0x4,%eax
    3b28:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    3b2b:	85 db                	test   %ebx,%ebx
    3b2d:	74 17                	je     3b46 <printf+0x186>
        while(*s != 0){
    3b2f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    3b32:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    3b34:	84 c0                	test   %al,%al
    3b36:	0f 84 d8 fe ff ff    	je     3a14 <printf+0x54>
    3b3c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    3b3f:	89 de                	mov    %ebx,%esi
    3b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3b44:	eb 1a                	jmp    3b60 <printf+0x1a0>
          s = "(null)";
    3b46:	bb 9c 54 00 00       	mov    $0x549c,%ebx
        while(*s != 0){
    3b4b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    3b4e:	b8 28 00 00 00       	mov    $0x28,%eax
    3b53:	89 de                	mov    %ebx,%esi
    3b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3b5f:	90                   	nop
  write(fd, &c, 1);
    3b60:	83 ec 04             	sub    $0x4,%esp
          s++;
    3b63:	83 c6 01             	add    $0x1,%esi
    3b66:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3b69:	6a 01                	push   $0x1
    3b6b:	57                   	push   %edi
    3b6c:	53                   	push   %ebx
    3b6d:	e8 ff fc ff ff       	call   3871 <write>
        while(*s != 0){
    3b72:	0f b6 06             	movzbl (%esi),%eax
    3b75:	83 c4 10             	add    $0x10,%esp
    3b78:	84 c0                	test   %al,%al
    3b7a:	75 e4                	jne    3b60 <printf+0x1a0>
    3b7c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    3b7f:	31 d2                	xor    %edx,%edx
    3b81:	e9 8e fe ff ff       	jmp    3a14 <printf+0x54>
    3b86:	66 90                	xchg   %ax,%ax
    3b88:	66 90                	xchg   %ax,%ax
    3b8a:	66 90                	xchg   %ax,%ax
    3b8c:	66 90                	xchg   %ax,%ax
    3b8e:	66 90                	xchg   %ax,%ax

00003b90 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3b90:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3b91:	a1 20 5e 00 00       	mov    0x5e20,%eax
{
    3b96:	89 e5                	mov    %esp,%ebp
    3b98:	57                   	push   %edi
    3b99:	56                   	push   %esi
    3b9a:	53                   	push   %ebx
    3b9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3b9e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    3ba0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3ba3:	39 c8                	cmp    %ecx,%eax
    3ba5:	73 19                	jae    3bc0 <free+0x30>
    3ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3bae:	66 90                	xchg   %ax,%ax
    3bb0:	39 d1                	cmp    %edx,%ecx
    3bb2:	72 14                	jb     3bc8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3bb4:	39 d0                	cmp    %edx,%eax
    3bb6:	73 10                	jae    3bc8 <free+0x38>
{
    3bb8:	89 d0                	mov    %edx,%eax
    3bba:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3bbc:	39 c8                	cmp    %ecx,%eax
    3bbe:	72 f0                	jb     3bb0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3bc0:	39 d0                	cmp    %edx,%eax
    3bc2:	72 f4                	jb     3bb8 <free+0x28>
    3bc4:	39 d1                	cmp    %edx,%ecx
    3bc6:	73 f0                	jae    3bb8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3bc8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3bcb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3bce:	39 fa                	cmp    %edi,%edx
    3bd0:	74 1e                	je     3bf0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3bd2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3bd5:	8b 50 04             	mov    0x4(%eax),%edx
    3bd8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3bdb:	39 f1                	cmp    %esi,%ecx
    3bdd:	74 28                	je     3c07 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3bdf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    3be1:	5b                   	pop    %ebx
  freep = p;
    3be2:	a3 20 5e 00 00       	mov    %eax,0x5e20
}
    3be7:	5e                   	pop    %esi
    3be8:	5f                   	pop    %edi
    3be9:	5d                   	pop    %ebp
    3bea:	c3                   	ret    
    3beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3bef:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    3bf0:	03 72 04             	add    0x4(%edx),%esi
    3bf3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3bf6:	8b 10                	mov    (%eax),%edx
    3bf8:	8b 12                	mov    (%edx),%edx
    3bfa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3bfd:	8b 50 04             	mov    0x4(%eax),%edx
    3c00:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3c03:	39 f1                	cmp    %esi,%ecx
    3c05:	75 d8                	jne    3bdf <free+0x4f>
    p->s.size += bp->s.size;
    3c07:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    3c0a:	a3 20 5e 00 00       	mov    %eax,0x5e20
    p->s.size += bp->s.size;
    3c0f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3c12:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3c15:	89 10                	mov    %edx,(%eax)
}
    3c17:	5b                   	pop    %ebx
    3c18:	5e                   	pop    %esi
    3c19:	5f                   	pop    %edi
    3c1a:	5d                   	pop    %ebp
    3c1b:	c3                   	ret    
    3c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003c20 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3c20:	55                   	push   %ebp
    3c21:	89 e5                	mov    %esp,%ebp
    3c23:	57                   	push   %edi
    3c24:	56                   	push   %esi
    3c25:	53                   	push   %ebx
    3c26:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3c29:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    3c2c:	8b 3d 20 5e 00 00    	mov    0x5e20,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3c32:	8d 70 07             	lea    0x7(%eax),%esi
    3c35:	c1 ee 03             	shr    $0x3,%esi
    3c38:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    3c3b:	85 ff                	test   %edi,%edi
    3c3d:	0f 84 ad 00 00 00    	je     3cf0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3c43:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    3c45:	8b 4a 04             	mov    0x4(%edx),%ecx
    3c48:	39 f1                	cmp    %esi,%ecx
    3c4a:	73 72                	jae    3cbe <malloc+0x9e>
    3c4c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    3c52:	bb 00 10 00 00       	mov    $0x1000,%ebx
    3c57:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    3c5a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    3c61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    3c64:	eb 1b                	jmp    3c81 <malloc+0x61>
    3c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3c6d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3c70:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3c72:	8b 48 04             	mov    0x4(%eax),%ecx
    3c75:	39 f1                	cmp    %esi,%ecx
    3c77:	73 4f                	jae    3cc8 <malloc+0xa8>
    3c79:	8b 3d 20 5e 00 00    	mov    0x5e20,%edi
    3c7f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3c81:	39 d7                	cmp    %edx,%edi
    3c83:	75 eb                	jne    3c70 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    3c85:	83 ec 0c             	sub    $0xc,%esp
    3c88:	ff 75 e4             	pushl  -0x1c(%ebp)
    3c8b:	e8 49 fc ff ff       	call   38d9 <sbrk>
  if(p == (char*)-1)
    3c90:	83 c4 10             	add    $0x10,%esp
    3c93:	83 f8 ff             	cmp    $0xffffffff,%eax
    3c96:	74 1c                	je     3cb4 <malloc+0x94>
  hp->s.size = nu;
    3c98:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3c9b:	83 ec 0c             	sub    $0xc,%esp
    3c9e:	83 c0 08             	add    $0x8,%eax
    3ca1:	50                   	push   %eax
    3ca2:	e8 e9 fe ff ff       	call   3b90 <free>
  return freep;
    3ca7:	8b 15 20 5e 00 00    	mov    0x5e20,%edx
      if((p = morecore(nunits)) == 0)
    3cad:	83 c4 10             	add    $0x10,%esp
    3cb0:	85 d2                	test   %edx,%edx
    3cb2:	75 bc                	jne    3c70 <malloc+0x50>
        return 0;
  }
}
    3cb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    3cb7:	31 c0                	xor    %eax,%eax
}
    3cb9:	5b                   	pop    %ebx
    3cba:	5e                   	pop    %esi
    3cbb:	5f                   	pop    %edi
    3cbc:	5d                   	pop    %ebp
    3cbd:	c3                   	ret    
    if(p->s.size >= nunits){
    3cbe:	89 d0                	mov    %edx,%eax
    3cc0:	89 fa                	mov    %edi,%edx
    3cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    3cc8:	39 ce                	cmp    %ecx,%esi
    3cca:	74 54                	je     3d20 <malloc+0x100>
        p->s.size -= nunits;
    3ccc:	29 f1                	sub    %esi,%ecx
    3cce:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3cd1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    3cd4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    3cd7:	89 15 20 5e 00 00    	mov    %edx,0x5e20
}
    3cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    3ce0:	83 c0 08             	add    $0x8,%eax
}
    3ce3:	5b                   	pop    %ebx
    3ce4:	5e                   	pop    %esi
    3ce5:	5f                   	pop    %edi
    3ce6:	5d                   	pop    %ebp
    3ce7:	c3                   	ret    
    3ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3cef:	90                   	nop
    base.s.ptr = freep = prevp = &base;
    3cf0:	c7 05 20 5e 00 00 24 	movl   $0x5e24,0x5e20
    3cf7:	5e 00 00 
    base.s.size = 0;
    3cfa:	bf 24 5e 00 00       	mov    $0x5e24,%edi
    base.s.ptr = freep = prevp = &base;
    3cff:	c7 05 24 5e 00 00 24 	movl   $0x5e24,0x5e24
    3d06:	5e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3d09:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    3d0b:	c7 05 28 5e 00 00 00 	movl   $0x0,0x5e28
    3d12:	00 00 00 
    if(p->s.size >= nunits){
    3d15:	e9 32 ff ff ff       	jmp    3c4c <malloc+0x2c>
    3d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    3d20:	8b 08                	mov    (%eax),%ecx
    3d22:	89 0a                	mov    %ecx,(%edx)
    3d24:	eb b1                	jmp    3cd7 <malloc+0xb7>
