#
# Copyright (c) 2017 The Altra64 project contributors
# See LICENSE file in the project root for full license information.
#

ROOTDIR = $(CURDIR)
SRCDIR = $(ROOTDIR)/src
OBJDIR = $(ROOTDIR)/obj
BINDIR = $(ROOTDIR)/bin
LIBDIR = $(ROOTDIR)/lib

CHKSUM64 = $(ROOTDIR)/toolchain/libdragon/tools/chksum64.exe
MKDFS = $(ROOTDIR)/toolchain/libdragon/tools/mkfs.exe
N64TOOL = $(ROOTDIR)/toolchain/libdragon/tools/n64tool.exe

HEADERNAME = header.ed64
HEADERTITLE = "EverDrive OS"
HEADER = $(ROOTDIR)/toolchain/libdragon/lib/header
PROG_NAME = OS64

INCLUDE_DIRS = -I$(ROOTDIR)/inc -I$(ROOTDIR)/include -I$(ROOTDIR)/toolchain/gcc-toolchain-mips64/include -I$(ROOTDIR)/toolchain/gcc-toolchain-mips64/mips64-elf/include -I$(ROOTDIR)/toolchain/libdragon/include

COMMON_FLAGS = -std=gnu17 -march=vr4300 -mtune=vr4300 -Wall -Wrestrict -Wno-pointer-sign -D_REENTRANT -DUSE_TRUETYPE $(INCLUDE_DIRS) $(SET_DEBUG)
FLAGS_VT = -O2 $(COMMON_FLAGS)
FLAGS = -O2 $(COMMON_FLAGS)
ASFLAGS = -mtune=vr4300 -march=vr4300
LINK_FLAGS = -G0 -L$(ROOTDIR)/lib -L$(ROOTDIR)/toolchain/gcc-toolchain-mips64/mips64-elf/lib -L$(ROOTDIR)/toolchain/libdragon/lib -ldragon -lmikmod -lmad -lyaml -lm -lc -ldragonsys -Tn64ld.x

GCCN64PREFIX = $(ROOTDIR)/toolchain/gcc-toolchain-mips64/bin/mips64-elf-
CC = $(GCCN64PREFIX)gcc.exe
AS = $(GCCN64PREFIX)as.exe
LD = $(GCCN64PREFIX)ld.exe
OBJCOPY = $(GCCN64PREFIX)objcopy

SRC = $(wildcard $(SRCDIR)/*.c)
SRCS = $(wildcard $(SRCDIR)/*.s)

OBJ = $(SRC:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
OBJS = $(SRCS:$(SRCDIR)/%.s=$(OBJDIR)/%.o)

all: $(PROG_NAME).v64

release: $(PROG_NAME).v64

debug: SET_DEBUG=-DDEBUG
debug: $(PROG_NAME).v64

send: $(PROG_NAME).v64
	$(TOOLSDIR)/up.bat


$(PROG_NAME).v64: $(PROG_NAME).elf
	$(OBJCOPY) $(BINDIR)/$(PROG_NAME).elf $(BINDIR)/$(PROG_NAME).bin -O binary
	$(N64TOOL) -l 4M -t $(HEADERTITLE) -h $(RESDIR)/$(HEADERNAME) -o $(BINDIR)/$(PROG_NAME).v64 $(BINDIR)/$(PROG_NAME).bin -s 1M $(BINDIR)/$(PROG_NAME).dfs
	$(CHKSUM64) $(BINDIR)/$(PROG_NAME).v64

$(PROG_NAME).elf : $(OBJ) $(OBJS)
	$(LD) -o $(BINDIR)/$(PROG_NAME).elf $(OBJ) $(OBJS) $(LINK_FLAGS)

$(PROG_NAME).dfs:
	$(MKDFSPATH) $(BINDIR)/$(PROG_NAME).dfs $(RESDIR)/filesystem/

$(OBJDIR)/gscore.o: $(SRCDIR)/gscore.c
	$(CC) $(FLAGS_VT) -c $(SRCDIR)/gscore.c -o $(OBJDIR)/gscore.o

$(OBJDIR)/%.o : $(SRCDIR)/%.c
	$(CC) $(FLAGS) -c $< -o $@

$(OBJDIR)/%.o : $(SRCDIR)/%.s
	$(AS) $(ASFLAGS) $< -o $@
	

clean:
	DEL /Q /S $(OBJDIR)/*.o
	DEL /Q $(BINDIR)/*.v64 & DEL /Q $(BINDIR)/*.bin & DEL /Q $(BINDIR)/*.elf
