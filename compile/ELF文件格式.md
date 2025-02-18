

## C程序

```c
#include <stdio.h>

extern int a;

int main()
{
	printf("%d\n", a);

	return 0;
}
```



编译：

```bash
gcc -c main.c
```



## ELF headers

```bash

$ readelf -e main.o
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              REL (Relocatable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x0
  Start of program headers:          0 (bytes into file)
  Start of section headers:          768 (bytes into file)					# section 文件中的偏移量
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           0 (bytes)
  Number of program headers:         0
  Size of section headers:           64 (bytes)								# section 长度
  Number of section headers:         13										# section 数量
  Section header string table index: 12										# section string 在 section 表中的下标，
  																			# 这里是12，也就是最后一个

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  # 文件内偏移地址为 0x40，长度为0x24，需要申请内存，可执行
  [ 1] .text             PROGBITS         0000000000000000  00000040
       0000000000000024  0000000000000000  AX       0     0     1
  # 偏移地址为0x238，entry size 为 0x18，大小为 0x48，也就是总共有 3 条
  [ 2] .rela.text        RELA             0000000000000000  00000238
       0000000000000048  0000000000000018   I      10     1     8
  [ 3] .data             PROGBITS         0000000000000000  00000064
       0000000000000000  0000000000000000  WA       0     0     1
  [ 4] .bss              NOBITS           0000000000000000  00000064
       0000000000000000  0000000000000000  WA       0     0     1
  [ 5] .rodata           PROGBITS         0000000000000000  00000064
       0000000000000004  0000000000000000   A       0     0     1
  [ 6] .comment          PROGBITS         0000000000000000  00000068
       000000000000002a  0000000000000001  MS       0     0     1
  [ 7] .note.GNU-stack   PROGBITS         0000000000000000  00000092
       0000000000000000  0000000000000000           0     0     1
  [ 8] .eh_frame         PROGBITS         0000000000000000  00000098
       0000000000000038  0000000000000000   A       0     0     8
  [ 9] .rela.eh_frame    RELA             0000000000000000  00000280
       0000000000000018  0000000000000018   I      10     8     8
  [10] .symtab           SYMTAB           0000000000000000  000000d0
       0000000000000138  0000000000000018          11     9     8
  [11] .strtab           STRTAB           0000000000000000  00000208
       000000000000002c  0000000000000000           0     0     1
  [12] .shstrtab         STRTAB           0000000000000000  00000298
       0000000000000061  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  l (large), p (processor specific)

There are no program headers in this file.

```



## ELF sections

### sections 格式

### section 1 .text

```bash
$ objdump -d main.o

main.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <main>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   # 8b 05 表示指令，00 00 00 00 表示偏移量
   4:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # a <main+0xa>
   # esi 传递第二个参数，也就是 a
   a:	89 c6                	mov    %eax,%esi
   # rdi 传递第一个参数，也就是字符串"%d\n"
   # mov 是取所在地址的值村到寄存器中
   # lea 是将所在地址存到寄存器中
   c:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 13 <main+0x13>
  13:	b8 00 00 00 00       	mov    $0x0,%eax
  # TODO
  18:	e8 00 00 00 00       	callq  1d <main+0x1d>
  1d:	b8 00 00 00 00       	mov    $0x0,%eax
  22:	5d                   	pop    %rbp
  23:	c3                   	retq  

```

这里需要重定位的有 3 处，分别是：

1. `extern int a`
2. `"%d\n"` 字符串
3. `printf` 函数调用



#### 调试手段

* 可以将汇编指令写到文件中， 使用`as` 编译

  ```bash
  as hello.s
  ```

* `objdump -d` 查看反汇编内容，对比分析



### section 2 .rela.text

```c
/* 表项格式 */
typedef struct elf64_rela {
	Elf64_Addr r_offset;	/* Location at which to apply the action */
	/* (sym_index << 32) + (type) */ 
	Elf64_Xword r_info;		/* index and type of relocation */
	Elf64_Sxword r_addend;	/* Constant addend used to compute value */
} Elf64_Rela;

```



```bash
$ readelf -r main.o 

Relocation section '.rela.text' at offset 0x238 contains 3 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
# 应用位置在 .text 内的偏移量为 0x06，符号表内地址为 0x0a，类型为0x02，
# 这里的 -4 意思是，偏移量计算的是 rip 的偏移量，在执行指令的时候，rip 中保存的是下一条指令的地址，
# 所以这里要 -4，获取到实际的偏移量。
# 计算时候实际是遮掩的，.text+offset 获取到链接之后的offset，sym 填充重定向之后的符号地址，
# 真正填充到.text 中偏移量为 sym - offset - 4
000000000006  000a00000002 R_X86_64_PC32     0000000000000000 a - 4
00000000000f  000500000002 R_X86_64_PC32     0000000000000000 .rodata - 4

000000000019  000c00000004 R_X86_64_PLT32    0000000000000000 printf - 4

```



#### 调试手段

```bash
# -Xlinker 是将参数传递给 linker 
# --print-map 是将输出map表输出到标准输出
# -q 是保留重定向表到可执行文件

$ gcc -Xlinker --print-map -Xlinker -q main.o extern_a.o -o main > ld-print-map.txt

# 查看重定向符号表
$ readelf -r main

# 调试
$ gdb main
(gdb) b main
(gdb) run
```





### seciont 10 .symtab

```c
typedef struct elf64_sym {
	Elf64_Word st_name;			/* Symbol name, index in string tbl */
	unsigned char	st_info;	/* Type and binding attributes */
	unsigned char	st_other;	/* No defined meaning, 0 */
	Elf64_Half st_shndx;		/* Associated section index */
	Elf64_Addr st_value;		/* Value of the symbol */
	Elf64_Xword st_size;		/* Associated symbol size */
} Elf64_Sym;


```



```bash
$ readelf -s main.o

# 这里的Vis 表示可见性质，存储在st_other中
Symbol table '.symtab' contains 13 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS main.c
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    3 
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    4 
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    5 
     6: 0000000000000000     0 SECTION LOCAL  DEFAULT    7 
     7: 0000000000000000     0 SECTION LOCAL  DEFAULT    8 
     8: 0000000000000000     0 SECTION LOCAL  DEFAULT    6 
     9: 0000000000000000    36 FUNC    GLOBAL DEFAULT    1 main
    10: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND a
    11: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND _GLOBAL_OFFSET_TABLE_
    12: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND printf
```



### section 11 .strtab

```bash
$ readelf -x 11 main.o

Hex dump of section '.strtab':
  0x00000000 006d6169 6e2e6300 6d61696e 0061005f .main.c.main.a._
  0x00000010 474c4f42 414c5f4f 46465345 545f5441 GLOBAL_OFFSET_TA
  0x00000020 424c455f 00707269 6e746600          BLE_.printf.

```

