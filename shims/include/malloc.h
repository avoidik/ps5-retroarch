/* PS5 sysroot <malloc.h> shim.
 *
 * The SDK's libc is FreeBSD's, whose <malloc.h> is only
 *     #error "<malloc.h> has been replaced by <stdlib.h>"
 * Cores written against glibc include it for malloc/free/memalign, so every one
 * of them fails to compile. _common.sh puts this directory first on the include
 * path (-I), so it is found instead; <stdlib.h> declares what those cores use.
 */
#ifndef PS5_MALLOC_SHIM_H
#define PS5_MALLOC_SHIM_H

#include <stdlib.h>

#endif /* PS5_MALLOC_SHIM_H */
