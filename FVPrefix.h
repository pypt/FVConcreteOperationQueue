// Uses private APIs
#ifndef MAC_APP_STORE_BUILD


#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef CF_RETURNS_NOT_RETAINED
#if __has_feature(attribute_cf_returns_not_retained)
#define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
#else
#define CF_RETURNS_NOT_RETAINED
#endif
#endif

#ifdef __OBJC__
#import <Cocoa/Cocoa.h>

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

// docs say not to send [super initialize]
#if !defined(FVINITIALIZE)
#define FVINITIALIZE(aClass) \
do { if ([aClass self] != self) return; } while(0)
#endif /* FVINITIALIZE */

// disable Cocoa assertions for Release builds
#if !defined(DEBUG)
#if !defined(NS_BLOCK_ASSERTIONS) || !NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS 1
#endif /* NS_BLOCK_ASSERTIONS */
#endif /* DEBUG */

#if !defined(_FVAPIAssertBody)
#define _FVAPIAssertBody(condition, desc, arg1, arg2, arg3) \
do { if(!(condition)) { [NSException raise:NSInvalidArgumentException format:(desc), (arg1), (arg2), (arg3)]; } } while(0)
#endif /* _FVAPIAssertBody */

// use NSAssert internally for debugging; these asserts are to enforce public API usage for framework clients
#define FVAPIAssert(condition, desc) \
_FVAPIAssertBody((condition), desc, 0, 0, 0)

#define FVAPIAssert1(condition, desc, arg1) \
_FVAPIAssertBody((condition), (desc), (arg1), 0, 0)

#define FVAPIAssert2(condition, desc, arg1, arg2) \
_FVAPIAssertBody((condition), (desc), (arg1), (arg2), 0)

#define FVAPIAssert3(condition, desc, arg1, arg2, arg3) \
_FVAPIAssertBody((condition), (desc), (arg1), (arg2), (arg3))

#define FVAPIParameterAssert(condition)                 \
_FVAPIAssertBody((condition), @"Invalid parameter not satisfying: %s", #condition, 0, 0)

/* workaround for gcc warning about CFSTR usage when using strict aliasing */
#define FVSTR(cStr) ((CFStringRef)@cStr)

#endif /* __OBJC__ */

#ifndef MAC_OS_X_VERSION_10_6
#define USE_DISPATCH_QUEUE 0
#elif MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_6
#define USE_DISPATCH_QUEUE 1
#warning Using dispatch queue
#else
#define USE_DISPATCH_QUEUE 0
#if USE_DISPATCH_QUEUE
#warning Using dispatch queue on 10.5
#endif
#endif

#if defined(__ppc__) || defined(__ppc64__)
#define HALT __asm__ __volatile__("trap")
#elif defined(__i386__) || defined(__x86_64__)
#if defined(__GNUC__)
#define HALT __asm__ __volatile__("int3")
#elif defined(_MSC_VER)
#define HALT __asm int 3;
#else
#error Compiler not supported
#endif
#endif

// copied from AppKit
#if defined(__MACH__)

#ifdef __cplusplus
#define FV_EXTERN               extern "C"
#define FV_PRIVATE_EXTERN       __private_extern__ "C"
#else
#define FV_EXTERN               extern
#define FV_PRIVATE_EXTERN       __private_extern__
#endif

#else
#error Unsupported kernel
#endif

#endif	// 'MAC_APP_STORE_BUILD'
