/* PS5 sysroot pthread_np shim.
 *
 * The toolchain defines __FreeBSD__, so libretro-common's rthreads.c names its
 * threads with pthread_set_name_np() - but it never includes <pthread_np.h>,
 * where FreeBSD declares it, and fails with "call to undeclared function".
 * libkernel_web.sprx does export the function; only the prototype is missing.
 *
 * <pthread_np.h> itself is not force-included because it drags in
 * <sys/param.h>, whose MIN/MAX/isset/setbit macros collide with emulator code.
 * This declares just the one function, with the SDK header's own signature, so
 * a translation unit that does include <pthread_np.h> sees a compatible
 * redeclaration. A configure probe for pthread_set_name_np itself will now see
 * a conflict and report it missing, which only costs that program its thread
 * names.
 *
 * Force-include it (-include ps5-pthread-np.h); _common.sh does so for every
 * core it builds.
 */
#ifndef PS5_PTHREAD_NP_SHIM_H
#define PS5_PTHREAD_NP_SHIM_H

/* -include also reaches preprocessed assembly; keep C out of it. */
#ifndef __ASSEMBLER__

/* Only the type, not <pthread.h>: a force-included <pthread.h> drags in
 * <time.h> and friends, and then every configure-style probe that declares a
 * function with a dummy signature (CMake's check_function_exists declares
 * `char localtime_r(void);`) fails on conflicting types - mgba then defined
 * its own localtime_r and collided with libc's at link time. */
#include <sys/_pthreadtypes.h>

#ifdef __cplusplus
extern "C" {
#endif

void pthread_set_name_np(pthread_t, const char *);

#ifdef __cplusplus
}
#endif

#endif /* !__ASSEMBLER__ */

#endif /* PS5_PTHREAD_NP_SHIM_H */
