/* PS5 sysroot <endian.h> shim.
 *
 * glibc has <endian.h> with __BYTE_ORDER/__LITTLE_ENDIAN/__BIG_ENDIAN and the
 * htobe16..le64toh family; FreeBSD has the functions in <sys/endian.h> and the
 * byte-order macros without the leading double underscore. Cores written
 * against glibc (mesen's CRC32.cpp) include <endian.h> and test __BYTE_ORDER,
 * so provide both spellings. Found first through -I shims/include.
 */
#ifndef PS5_ENDIAN_SHIM_H
#define PS5_ENDIAN_SHIM_H

#include <sys/endian.h>

#ifndef __LITTLE_ENDIAN
#define __LITTLE_ENDIAN _LITTLE_ENDIAN
#endif
#ifndef __BIG_ENDIAN
#define __BIG_ENDIAN _BIG_ENDIAN
#endif
#ifndef __PDP_ENDIAN
#define __PDP_ENDIAN _PDP_ENDIAN
#endif
#ifndef __BYTE_ORDER
#define __BYTE_ORDER _BYTE_ORDER
#endif

#endif /* PS5_ENDIAN_SHIM_H */
