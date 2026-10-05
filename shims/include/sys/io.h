/* PS5 sysroot <sys/io.h> shim.
 *
 * <sys/io.h> is glibc's x86 port-I/O header (inb/outb/ioperm). Some cores
 * include it on every x86 target without using it (emuscv's common.h); there is
 * no port I/O here, so this is deliberately empty. A core that really calls
 * those functions still fails to compile, with an undeclared-function error.
 */
#ifndef PS5_SYS_IO_SHIM_H
#define PS5_SYS_IO_SHIM_H
#endif /* PS5_SYS_IO_SHIM_H */
