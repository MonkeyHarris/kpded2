VPATH=game geoip linux qcommon server
BUILDPATH=obj

ALLSRC:=cmd.c cmodel.c common.c cvar.c files.c md4.c net_chan.c \
	     mersennetwister.c redblack.c sv_ccmds.c sv_ents.c sv_game.c \
	     sv_init.c sv_main.c sv_send.c sv_user.c sv_world.c q_shlinux.c \
	     sys_linux.c glob.c net_udp.c q_shared.c pmove.c \
	     maxminddb.c data-pool.c
ALLOBJ:=$(addprefix $(BUILDPATH)/, $(ALLSRC:.c=.o))

TARGETS:=kpded2

# need -fno-associative-math to avoid prediction misses, -fno-finite-math-only to avoid GLIBC_2.15 requirement
CFLAGS+=-DKINGPIN -DDEDICATED_ONLY -DNDEBUG -DLINUX -O2 -m32 -ffast-math -fno-associative-math -fno-finite-math-only -MF $(BUILDPATH)/$*.d -MMD -flto
LDFLAGS=-lm -lz -lpthread -ldl -lrt -m32 -Wl,--gc-sections -Wl,--no-undefined

$(BUILDPATH)/maxminddb.o $(BUILDPATH)/data-pool.o: CFLAGS+=-std=c99

.PHONY: clean

kpded2: $(ALLOBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

$(BUILDPATH)/%.o : %.c
	@mkdir -p $(BUILDPATH)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	-rm -f $(TARGETS) $(BUILDPATH)/*

-include $(BUILDPATH)/*.d
