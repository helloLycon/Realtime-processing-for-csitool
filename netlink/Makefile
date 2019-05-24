CC=mips-openwrt-linux-gcc
ELF=log_to_server

${ELF}: log_to_server.c
	${CC} $^ -o $@

clean:
	rm -f ${ELF}
