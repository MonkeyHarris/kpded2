VPATH=game linux qcommon server
BUILDPATH=obj

ALLSRC:=cmd.c cmodel.c common.c cvar.c files.c md4.c net_chan.c \
	     mersennetwister.c redblack.c sv_ccmds.c sv_ents.c sv_game.c \
	     sv_init.c sv_main.c sv_send.c sv_user.c sv_world.c q_shlinux.c \
	     sys_linux.c glob.c net_udp.c q_shared.c pmove.c
ALLOBJ:=$(addprefix $(BUILDPATH)/, $(ALLSRC:.c=.o))

TARGETS:=kpded2

# need -fno-associative-math to avoid prediction misses
CFLAGS+=-DKINGPIN -DDEDICATED_ONLY -DNDEBUG -DLINUX -O2 -m32 -ffast-math -fno-associative-math -ffunction-sections -fdata-sections -MF $(BUILDPATH)/$*.d -MMD
LDFLAGS=-lm -lz -lpthread -ldl -m32 -Wl,--gc-sections -Wl,--no-undefined

.PHONY: clean

kpded2: $(ALLOBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

$(BUILDPATH)/%.o : %.c
	@mkdir -p $(BUILDPATH)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	-rm -f $(TARGETS) $(BUILDPATH)/*

-include $(BUILDPATH)/*.d
