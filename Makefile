# Makefile for the pingtunnel utility
# (c) 2004-2009 Daniel Stoedle, daniels@cs.uit.no
# ptunnel.exe target added by Mike Miller, mike@mikeage.net

CC			= gcc
CFLAGS		= -Wall -g -fstrict-aliasing
LDOPTS		= -lpthread -lpcap
PT_OBJS		= options.o pdesc.o ptunnel.o md5.o base64.o

WIN32_CC      = mingw32-gcc
WIN32_CFLAGS  = -g -Wall -DWIN32 -I"c:\Program Files\WpdPack\Include"
WIN32_LDOPTS  = -lwpcap -lwsock32 -L"c:\Program Files\WpdPack\Lib"
WIN32_PT_OBJS = options.obj pdesc.obj ptunnel.obj md5.obj base64.obj

prefix		= $(DESTDIR)/usr
bindir		= $(prefix)/sbin
mandir		= $(prefix)/share/man/man8

all: ptunnel

dist:
	rm -rf PingTunnel/
	mkdir PingTunnel
	cp ptunnel.c ptunnel.h Makefile.dist PingTunnel/
	mv PingTunnel/Makefile.dist PingTunnel/Makefile
	

install: ptunnel
	install -d $(bindir)/
	install -d $(mandir)/
	install ./ptunnel $(bindir)/ptunnel
	install ./ptunnel.8 $(mandir)/ptunnel.8

ptunnel: $(PT_OBJS)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LDOPTS) `[ -e /usr/include/selinux/selinux.h ] && echo -lselinux`

ptunnel.exe: $(WIN32_PT_OBJS)
	$(CC) -o $@ $^ $(WIN32_LDOPTS)

clean:
	-rm -f *.o ptunnel
	-rm -f *.obj ptunnel.exe
	-rm -f .depend

depend: .depend
.depend:
	$(CC) $(CFLAGS) $(CPPFLAGS) -MM *.c > $@

%.o:%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) `[ -e /usr/include/selinux/selinux.h ] && echo -DHAVE_SELINUX` -c -o $@ $<

%.obj:%.c
	$(WIN32_CC) $(WIN32_CFLAGS) -c -o $@ $<

-include .depend
