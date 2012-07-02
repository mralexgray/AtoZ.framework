//
//  BaseModel.m
//  Version 2.3.1
//
//  http://charcoaldesign.co.uk/source/cocoa#basemodel
//  https://github.com/nicklockwood/BaseModel
//
#import "AtoZ.h"
#import <objc/message.h>


NSString *const AtoZSharedInstanceUpdated = @"AtoZSharedInstanceUpdated";


@implementation AtoZ

#pragma mark -
#pragma mark Private utility methods

+ (NSString *)resourceFilePath:(NSString *)path
{
    //check if the path is a full path or not
    if (![path isAbsolutePath])
    {
        return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
    }
    return path;
}

+ (NSString *)resourceFilePath
{
    return [self resourceFilePath:[self resourceFile]];
}

+ (NSString *)saveFilePath:(NSString *)path
{
    //check if the path is a full path or not
    if (![path isAbsolutePath])
    {
        //get the path to the application support folder
        NSString *folder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
        
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED
        //append application name on Mac OS
        NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
        folder = [folder stringByAppendingPathComponent:identifier];        
#endif
        //create the folder if it doesn't exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:folder])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        return [folder stringByAppendingPathComponent:path];
    }
    return path;
}

+ (NSString *)saveFilePath
{
    return [self saveFilePath:[self saveFile]];
}

#pragma mark -
#pragma mark Singleton behaviour

static NSMutableDictionary *sharedInstances = nil;

+ (void)setSharedInstance:(AtoZ *)instance
{
    if (![instance isKindOfClass:self])
    {
        [NSException raise:NSGenericException format:@"setSharedInstance: instance class does not match"];
    }
    sharedInstances = sharedInstances ?: [[NSMutableDictionary alloc] init];
    id oldInstance = [sharedInstances objectForKey:NSStringFromClass(self)];
    [sharedInstances setObject:instance forKey:NSStringFromClass(self)];
    if (oldInstance)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:AtoZSharedInstanceUpdated object:oldInstance];
    }
}

+ (BOOL)hasSharedInstance
{
    return [sharedInstances objectForKey:NSStringFromClass(self)] != nil;
}

+ (instancetype)sharedInstance
{
    sharedInstances = sharedInstances ?: [[NSMutableDictionary alloc] init];
    id instance = [sharedInstances objectForKey:NSStringFromClass(self)];
    if (instance == nil)
    {
        //load or create instance
        [self reloadSharedInstance];
        
        //get loaded instance
        instance = [sharedInstances objectForKey:NSStringFromClass(self)];
    }
    return instance;
}

+ (void)reloadSharedInstance
{
    id instance = nil;
    
    //try loading previously saved version
    instance = [self instanceWithContentsOfFile:[self saveFilePath]];   
    if (instance == nil)
    {
        //construct a new instance
        instance = [self instance];
    }
    
    //set singleton
    [self setSharedInstance:instance];
}

+ (NSString *)resourceFile
{
    //used for every instance
    return [NSStringFromClass(self) stringByAppendingPathExtension:@"plist"];
}

+ (NSString *)saveFile
{
    //used to save shared (singleton) instance
    return [NSStringFromClass(self) stringByAppendingPathExtension:@"plist"];
}

- (void)save
{
    if ([sharedInstances objectForKey:NSStringFromClass([self class])] == self)
    {
        //shared (singleton) instance
        [self writeToFile:[[self class] saveFilePath] atomically:YES];
    }
    else
    {
        //no save implementation
        [NSException raise:NSGenericException format:@"Unable to save object, save method not implemented"];
    }
}

#pragma mark -
#pragma mark Default constructors

- (void)setUp
{
    //override this
}

+ (instancetype)instance
{
    return AH_AUTORELEASE([[self alloc] init]);
}

static BOOL loadingFromResourceFile = NO;

- (instancetype)init
{
    @synchronized ([AtoZ class])
    {
        if (!loadingFromResourceFile)
        {
            //attempt to load from resource file
            loadingFromResourceFile = YES;
            id object = [[[self class] alloc] initWithContentsOfFile:[[self class] resourceFilePath]];
            loadingFromResourceFile = NO;
            if (object)
            {
                AH_RELEASE(self);
                self = object;
                return self;
            }
        }
        if ((self = [super init]))
        {
            
#ifdef DEBUG
            if ([self class] == [AtoZ class])
            {
                [NSException raise:NSGenericException format:@"BaseModel class is abstract and should be subclassed rather than instantiated directly"];
            }
#endif
            [self setUp];
        }
        return self;
    }
}

+ (instancetype)instanceWithObject:(id)object
{
    //return nil if object is nil
    return object? AH_AUTORELEASE([[self alloc] initWithObject:object]): nil;
}

- (NSString *)setterNameForClass:(Class)class
{
    //get class name
    NSString *className = NSStringFromClass(class);
    
    //strip NS prefix
    if ([className hasPrefix:@"NS"])
    {
        className = [className substringFromIndex:2];
    }
    
    //return setter name
    return [NSString stringWithFormat:@"setWith%@:", className];
}

- (instancetype)initWithObject:(id)object
{
    if ((self = [self init]))
    {
        Class class = [object class];
        while (true)
        {
            SEL setter = NSSelectorFromString([self setterNameForClass:class]);
            if ([self respondsToSelector:setter])
            {
                objc_msgSend(self, setter, object);
                return self;
            }
            if ([class superclass] == [NSObject class]) break;
            class = [class superclass];
        }
        [NSException raise:NSGenericException
                    format:@"%@ not implemented", [self setterNameForClass:class]];
    }
    return self;
}

+ (NSArray *)instancesWithArray:(NSArray *)array
{
    NSMutableArray *result = [NSMutableArray array];
    for (id object in array)
    {
        [result addObject:[self instanceWithObject:object]];
    }
    return result;
}

+ (instancetype)instanceWithCoder:(NSCoder *)decoder
{
    //return nil if coder is nil
    return decoder? AH_AUTORELEASE([[self alloc] initWithCoder:decoder]): nil;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if ((self = [self init]))
    {
        if ([self respondsToSelector:@selector(setWithCoder:)])
        {
            [self setWithCoder:decoder];
        }
        else
        {
            [NSException raise:NSGenericException format:@"setWithCoder: not implemented"];
        }
    }
    return self;
}

+ (instancetype)instanceWithContentsOfFile:(NSString *)filePath
{
    //check if the path is a full path or not
    NSString *path = filePath;
    if (![path isAbsolutePath])
    {
        //try resources
        path = [self resourceFilePath:filePath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            //try application support
            path = [self saveFilePath:filePath];
        }
    }
	
    return AH_AUTORELEASE([[self alloc] initWithContentsOfFile:path]);
}

- (instancetype)initWithContentsOfFile:(NSString *)filePath
{
    static NSCache *cachedResourceFiles = nil;
    if (cachedResourceFiles == nil)
    {
        cachedResourceFiles = [[NSCache alloc] init];
    }
    
    //check cache for existing instance
    //only cache files inside the main bundle as they are immutable 
    BOOL isResourceFile = [filePath hasPrefix:[[NSBundle mainBundle] bundlePath]];
    if (isResourceFile)
    {
        id object = [cachedResourceFiles objectForKey:filePath];
        if (object)
        {
            AH_RELEASE(self);
            return ((self = (object == [NSNull null])? nil: AH_RETAIN(object)));
        }
    }
    
    //load the file
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    //attempt to deserialise data as a plist
    id object = nil;
    if (data)
    {
        NSPropertyListFormat format;
        NSPropertyListReadOptions options = NSPropertyListMutableContainersAndLeaves;
        object = [NSPropertyListSerialization propertyListWithData:data options:options format:&format error:NULL];
    }
	
    //success?
    if (object)
    {
        //check if object is an NSCoded archive
        if ([object respondsToSelector:@selector(objectForKey:)])
        {
            if ([object objectForKey:@"$archiver"])
            {
                object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            else
            {
                Class coderClass = NSClassFromString(@"HRCoder");
                NSString *classNameKey = [coderClass valueForKey:@"classNameKey"];
                if ([object objectForKey:classNameKey])
                {
                    object = objc_msgSend(coderClass, @selector(unarchiveObjectWithPlist:), object);
                }
            }
            
            if ([object isKindOfClass:[self class]])
            {
                //return object
                AH_RELEASE(self);
                return ((self = AH_RETAIN(object)));
            }
        }
		
        if (isResourceFile)
        {
            //cache for next time
            [cachedResourceFiles setObject:object forKey:filePath];
        }
        
        //load with object
        return ((self = [self initWithObject:object]));
    }
    else if (isResourceFile)
    {
        //store null for non-existent files to improve performance next time
        [cachedResourceFiles setObject:[NSNull null] forKey:filePath];
    }
    
    //failed to load
    AH_RELEASE(self);
    return ((self = nil));
}


- (BOOL)useHRCoderIfAvailable
{
    return YES;
}


- (void)writeToFile:(NSString *)path atomically:(BOOL)atomically
{
    NSData *data = nil;
    Class coderClass = NSClassFromString(@"HRCoder");
    if (coderClass && [self useHRCoderIfAvailable])
    {
        id plist = objc_msgSend(coderClass, @selector(archivedPlistWithRootObject:), self);
        NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
        data = [NSPropertyListSerialization dataWithPropertyList:plist format:format options:0 error:NULL];
    }
    else
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:self];
    }
    [data writeToFile:[[self class] saveFilePath:path] atomically:YES];
}

#pragma mark -
#pragma mark Unique identifier generation

+ (NSString *)newUniqueIdentifier
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return AH_RETAIN(CFBridgingRelease(identifier));
}


@synthesize uniqueID = _uniqueID;

- (NSString *)uniqueID
{
    if (_uniqueID == nil)
    {
        _uniqueID = [[self class] newUniqueIdentifier];
    }
    return _uniqueID;
}

- (void)dealloc
{
    AH_RELEASE(_uniqueID);
    AH_SUPER_DEALLOC;
}

@end

void NSLog (NSString *format, ...) {	va_list argList;	va_start (argList, format);
	NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
	fprintf (stderr, "%s \n", [message UTF8String]); 	va_end  (argList);
} // QuietLog 


@implementation  NSNumber (Incrementer)
- (NSNumber *)increment {
return [NSNumber numberWithInt:[self intValue]+1];
}
@end


@implementation CALayer (AGFlip)
- (void) flipOver {
	[CATransaction setValue:[NSNumber numberWithFloat:2.0f]
					 forKey:kCATransactionAnimationDuration];
	self.transform = CATransform3DMakeRotation(DEG2RAD(180), 0.0f, 1.0f, 0.0f);
}
@end


@implementation Box
@synthesize color, save, selected, shapeLayer;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		shapeLayer = [CAShapeLayer layer];
		[self setLayer:shapeLayer];
		[self setWantsLayer:YES];
	}
    return self;
}
-(void) drawRect:(NSRect)dirtyRect {	
	//	cotn ext
	[color set];	NSRectFill(dirtyRect); 
	selected = NO;
	//	if (selected) [self lasso];
}

- (void) mouseUp:(NSEvent *)theEvent { 
	
	//	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	//	NSLog(@"BOX HIT AT POINT: %@", NSStringFromPoint(location));
	selected = YES;
	save = color.copy;
	//	NSLog(@"Saved %@", self.save);
	color = [NSColor whiteColor];
	float f  = 0;
	while ( f < .6 ) {
		color = ( color == [NSColor blackColor] ? [NSColor whiteColor] : [NSColor blackColor]); 
		[self performSelector:@selector(flash:) withObject:color.copy afterDelay:f];
		f = f+.1;
	}
	[self performSelector:@selector(flash:) withObject:save afterDelay:.6];
}
//	selected = YES;
-(void) flash:(NSColor*)savedColor { 
	//	NSLog(@"FLASHING %@", savedColor);
	color = savedColor;
	[self setNeedsDisplay:YES];
	//	if (selected) {  [self drawLasso]; }
}
@end







#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
#include <Availability.h>
#endif //  TARGET_OS_IPHONE

// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
#define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
#define MAC_OS_X_VERSION_10_6 1060
#endif
#ifndef MAC_OS_X_VERSION_10_7
#define MAC_OS_X_VERSION_10_7 1070
#endif

// Not all __IPHONE_X macros defined in past SDKs
#ifndef __IPHONE_3_0
#define __IPHONE_3_0 30000
#endif
#ifndef __IPHONE_3_1
#define __IPHONE_3_1 30100
#endif
#ifndef __IPHONE_3_2
#define __IPHONE_3_2 30200
#endif
#ifndef __IPHONE_4_0
#define __IPHONE_4_0 40000
#endif
#ifndef __IPHONE_4_3
#define __IPHONE_4_3 40300
#endif
#ifndef __IPHONE_5_0
#define __IPHONE_5_0 50000
#endif

// ----------------------------------------------------------------------------
// CPP symbols that can be overridden in a prefix to control how the toolbox
// is compiled.
// ----------------------------------------------------------------------------


// By setting the _CONTAINERS_VALIDATION_FAILED_LOG and
// GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
// when a validation fails. If you implement your own validators, you may want
// to control their internals using the same macros for consistency.
#ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
#define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
#endif

// Give ourselves a consistent way to do inlines.  Apple's macros even use
// a few different actual definitions, so we're based off of the foundation
// one.
#if !defined(GTM_INLINE)
#if (defined (__GNUC__) && (__GNUC__ == 4)) || defined (__clang__)
#define GTM_INLINE static __inline__ __attribute__((always_inline))
#else
#define GTM_INLINE static __inline__
#endif
#endif

// Give ourselves a consistent way of doing externs that links up nicely
// when mixing objc and objc++
#if !defined (GTM_EXTERN)
#if defined __cplusplus
#define GTM_EXTERN extern "C"
#define GTM_EXTERN_C_BEGIN extern "C" {
#define GTM_EXTERN_C_END }
#else
#define GTM_EXTERN extern
#define GTM_EXTERN_C_BEGIN
#define GTM_EXTERN_C_END
#endif
#endif

// Give ourselves a consistent way of exporting things if we have visibility
// set to hidden.
#if !defined (GTM_EXPORT)
#define GTM_EXPORT __attribute__((visibility("default")))
#endif

// Give ourselves a consistent way of declaring something as unused. This
// doesn't use __unused because that is only supported in gcc 4.2 and greater.
#if !defined (GTM_UNUSED)
#define GTM_UNUSED(x) ((void)(x))
#endif

// _GTMDevLog & _GTMDevAssert
//
// _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
// developer level errors.  This implementation simply macros to NSLog/NSAssert.
// It is not intended to be a general logging/reporting system.
//
// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
// for a little more background on the usage of these macros.
//
//    _GTMDevLog           log some error/problem in debug builds
//    _GTMDevAssert        assert if conditon isn't met w/in a method/function
//                           in all builds.
//
// To replace this system, just provide different macro definitions in your
// prefix header.  Remember, any implementation you provide *must* be thread
// safe since this could be called by anything in what ever situtation it has
// been placed in.
//

// We only define the simple macros if nothing else has defined this.
#ifndef _GTMDevLog

#ifdef DEBUG
#define _GTMDevLog(...) NSLog(__VA_ARGS__)
#else
#define _GTMDevLog(...) do { } while (0)
#endif

#endif // _GTMDevLog

#ifndef _GTMDevAssert
// we directly invoke the NSAssert handler so we can pass on the varargs
// (NSAssert doesn't have a macro we can use that takes varargs)
#if !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _GTMDevAssert

// _GTMCompileAssert
// _GTMCompileAssert is an assert that is meant to fire at compile time if you
// want to check things at compile instead of runtime. For example if you
// want to check that a wchar is 4 bytes instead of 2 you would use
// _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
// Note that the second "arg" is not in quotes, and must be a valid processor
// symbol in it's own right (no spaces, punctuation etc).

// Wrapping this in an #ifndef allows external groups to define their own
// compile time assert scheme.
#ifndef _GTMCompileAssert
// We got this technique from here:
// http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

#define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
#define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
#define _GTMCompileAssert(test, msg) \
typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _GTMCompileAssert

// ----------------------------------------------------------------------------
// CPP symbols defined based on the project settings so the GTM code has
// simple things to test against w/o scattering the knowledge of project
// setting through all the code.
// ----------------------------------------------------------------------------

// Provide a single constant CPP symbol that all of GTM uses for ifdefing
// iPhone code.
#if TARGET_OS_IPHONE // iPhone SDK
// For iPhone specific stuff
#define GTM_IPHONE_SDK 1
#if TARGET_IPHONE_SIMULATOR
#define GTM_IPHONE_SIMULATOR 1
#else
#define GTM_IPHONE_DEVICE 1
#endif  // TARGET_IPHONE_SIMULATOR
// By default, GTM has provided it's own unittesting support, define this
// to use the support provided by Xcode, especially for the Xcode4 support
// for unittesting.
#ifndef GTM_IPHONE_USE_SENTEST
#define GTM_IPHONE_USE_SENTEST 0
#endif
#else
// For MacOS specific stuff
#define GTM_MACOS_SDK 1
#endif

// Some of our own availability macros
#if GTM_MACOS_SDK
#define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
#define GTM_AVAILABLE_ONLY_ON_MACOS
#else
#define GTM_AVAILABLE_ONLY_ON_IPHONE
#define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
#endif

// Provide a symbol to include/exclude extra code for GC support.  (This mainly
// just controls the inclusion of finalize methods).
#ifndef GTM_SUPPORT_GC
#if GTM_IPHONE_SDK
// iPhone never needs GC
#define GTM_SUPPORT_GC 0
#else
// We can't find a symbol to tell if GC is supported/required, so best we
// do on Mac targets is include it if we're on 10.5 or later.
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#define GTM_SUPPORT_GC 0
#else
#define GTM_SUPPORT_GC 1
#endif
#endif
#endif

// To simplify support for 64bit (and Leopard in general), we provide the type
// defines for non Leopard SDKs
#if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
// NSInteger/NSUInteger and Max/Mins
#ifndef NSINTEGER_DEFINED
#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif
#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX
#define NSINTEGER_DEFINED 1
#endif  // NSINTEGER_DEFINED
// CGFloat
#ifndef CGFLOAT_DEFINED
#if defined(__LP64__) && __LP64__
// This really is an untested path (64bit on Tiger?)
typedef double CGFloat;
#define CGFLOAT_MIN DBL_MIN
#define CGFLOAT_MAX DBL_MAX
#define CGFLOAT_IS_DOUBLE 1
#else /* !defined(__LP64__) || !__LP64__ */
typedef float CGFloat;
#define CGFLOAT_MIN FLT_MIN
#define CGFLOAT_MAX FLT_MAX
#define CGFLOAT_IS_DOUBLE 0
#endif /* !defined(__LP64__) || !__LP64__ */
#define CGFLOAT_DEFINED 1
#endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

// Some support for advanced clang static analysis functionality
// See http://clang-analyzer.llvm.org/annotations.html
#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

#ifndef CF_RETURNS_NOT_RETAINED
#if __has_feature(attribute_cf_returns_not_retained)
#define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
#else
#define CF_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef NS_CONSUMED
#if __has_feature(attribute_ns_consumed)
#define NS_CONSUMED __attribute__((ns_consumed))
#else
#define NS_CONSUMED
#endif
#endif

#ifndef CF_CONSUMED
#if __has_feature(attribute_cf_consumed)
#define CF_CONSUMED __attribute__((cf_consumed))
#else
#define CF_CONSUMED
#endif
#endif

#ifndef NS_CONSUMES_SELF
#if __has_feature(attribute_ns_consumes_self)
#define NS_CONSUMES_SELF __attribute__((ns_consumes_self))
#else
#define NS_CONSUMES_SELF
#endif
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_ARGUMENT
#define NS_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_FUNCTION
#define NS_FORMAT_FUNCTION(F,A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_ARGUMENT
#define CF_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_FUNCTION
#define CF_FORMAT_FUNCTION(F,A)
#endif

#ifndef GTM_NONNULL
#define GTM_NONNULL(x) __attribute__((nonnull(x)))
#endif

#ifdef __OBJC__

// Declared here so that it can easily be used for logging tracking if
// necessary. See GTMUnitTestDevLog.h for details.
@class NSString;
GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);

// Macro to allow you to create NSStrings out of other macros.
// #define FOO foo
// NSString *fooString = GTM_NSSTRINGIFY(FOO);
#if !defined (GTM_NSSTRINGIFY)
#define GTM_NSSTRINGIFY_INNER(x) @#x
#define GTM_NSSTRINGIFY(x) GTM_NSSTRINGIFY_INNER(x)
#endif

// Macro to allow fast enumeration when building for 10.5 or later, and
// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
// does keys, so pick the right thing, nothing is done on the FastEnumeration
// side to be sure you're getting what you wanted.
#ifndef GTM_FOREACH_OBJECT
#if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (element in enumeration)
#define GTM_FOREACH_OBJECT(element, collection) \
for (element in collection)
#define GTM_FOREACH_KEY(element, collection) \
for (element in collection)
#else
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (NSEnumerator *_ ## element ## _enum = enumeration; \
(element = [_ ## element ## _enum nextObject]) != nil; )
#define GTM_FOREACH_OBJECT(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
#define GTM_FOREACH_KEY(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
#endif
#endif

// ============================================================================

// To simplify support for both Leopard and Snow Leopard we declare
// the Snow Leopard protocols that we need here.
#if !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)
#define GTM_10_6_PROTOCOLS_DEFINED 1
@protocol NSConnectionDelegate
@end
@protocol NSAnimationDelegate
@end
@protocol NSImageDelegate
@end
@protocol NSTabViewDelegate
@end
#endif  // !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)

// GTM_SEL_STRING is for specifying selector (usually property) names to KVC
// or KVO methods.
// In debug it will generate warnings for undeclared selectors if
// -Wunknown-selector is turned on.
// In release it will have no runtime overhead.
#ifndef GTM_SEL_STRING
#ifdef DEBUG
#define GTM_SEL_STRING(selName) NSStringFromSelector(@selector(selName))
#else
#define GTM_SEL_STRING(selName) @#selName
#endif  // DEBUG
#endif  // GTM_SEL_STRING

#endif // __OBJC__
#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
#include <Availability.h>
#endif //  TARGET_OS_IPHONE

// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
#define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
#define MAC_OS_X_VERSION_10_6 1060
#endif
#ifndef MAC_OS_X_VERSION_10_7
#define MAC_OS_X_VERSION_10_7 1070
#endif

// Not all __IPHONE_X macros defined in past SDKs
#ifndef __IPHONE_3_0
#define __IPHONE_3_0 30000
#endif
#ifndef __IPHONE_3_1
#define __IPHONE_3_1 30100
#endif
#ifndef __IPHONE_3_2
#define __IPHONE_3_2 30200
#endif
#ifndef __IPHONE_4_0
#define __IPHONE_4_0 40000
#endif
#ifndef __IPHONE_4_3
#define __IPHONE_4_3 40300
#endif
#ifndef __IPHONE_5_0
#define __IPHONE_5_0 50000
#endif

// ----------------------------------------------------------------------------
// CPP symbols that can be overridden in a prefix to control how the toolbox
// is compiled.
// ----------------------------------------------------------------------------


// By setting the GTM_CONTAINERS_VALIDATION_FAILED_LOG and
// GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
// when a validation fails. If you implement your own validators, you may want
// to control their internals using the same macros for consistency.
#ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
#define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
#endif

// Give ourselves a consistent way to do inlines.  Apple's macros even use
// a few different actual definitions, so we're based off of the foundation
// one.
#if !defined(GTM_INLINE)
#if (defined (__GNUC__) && (__GNUC__ == 4)) || defined (__clang__)
#define GTM_INLINE static __inline__ __attribute__((always_inline))
#else
#define GTM_INLINE static __inline__
#endif
#endif

// Give ourselves a consistent way of doing externs that links up nicely
// when mixing objc and objc++
#if !defined (GTM_EXTERN)
#if defined __cplusplus
#define GTM_EXTERN extern "C"
#define GTM_EXTERN_C_BEGIN extern "C" {
#define GTM_EXTERN_C_END }
#else
#define GTM_EXTERN extern
#define GTM_EXTERN_C_BEGIN
#define GTM_EXTERN_C_END
#endif
#endif

// Give ourselves a consistent way of exporting things if we have visibility
// set to hidden.
#if !defined (GTM_EXPORT)
#define GTM_EXPORT __attribute__((visibility("default")))
#endif

// Give ourselves a consistent way of declaring something as unused. This
// doesn't use __unused because that is only supported in gcc 4.2 and greater.
#if !defined (GTM_UNUSED)
#define GTM_UNUSED(x) ((void)(x))
#endif

// _GTMDevLog & _GTMDevAssert
//
// _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
// developer level errors.  This implementation simply macros to NSLog/NSAssert.
// It is not intended to be a general logging/reporting system.
//
// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
// for a little more background on the usage of these macros.
//
//    _GTMDevLog           log some error/problem in debug builds
//    _GTMDevAssert        assert if conditon isn't met w/in a method/function
//                           in all builds.
//
// To replace this system, just provide different macro definitions in your
// prefix header.  Remember, any implementation you provide *must* be thread
// safe since this could be called by anything in what ever situtation it has
// been placed in.
//

// We only define the simple macros if nothing else has defined this.
#ifndef _GTMDevLog

#ifdef DEBUG
#define _GTMDevLog(...) NSLog(__VA_ARGS__)
#else
#define _GTMDevLog(...) do { } while (0)
#endif

#endif // _GTMDevLog

#ifndef _GTMDevAssert
// we directly invoke the NSAssert handler so we can pass on the varargs
// (NSAssert doesn't have a macro we can use that takes varargs)
#if !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _GTMDevAssert

// _GTMCompileAssert
// _GTMCompileAssert is an assert that is meant to fire at compile time if you
// want to check things at compile instead of runtime. For example if you
// want to check that a wchar is 4 bytes instead of 2 you would use
// _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
// Note that the second "arg" is not in quotes, and must be a valid processor
// symbol in it's own right (no spaces, punctuation etc).

// Wrapping this in an #ifndef allows external groups to define their own
// compile time assert scheme.
#ifndef _GTMCompileAssert
// We got this technique from here:
// http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

#define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
#define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
#define _GTMCompileAssert(test, msg) \
typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _GTMCompileAssert

// ----------------------------------------------------------------------------
// CPP symbols defined based on the project settings so the GTM code has
// simple things to test against w/o scattering the knowledge of project
// setting through all the code.
// ----------------------------------------------------------------------------

// Provide a single constant CPP symbol that all of GTM uses for ifdefing
// iPhone code.
#if TARGET_OS_IPHONE // iPhone SDK
// For iPhone specific stuff
#define GTM_IPHONE_SDK 1
#if TARGET_IPHONE_SIMULATOR
#define GTM_IPHONE_SIMULATOR 1
#else
#define GTM_IPHONE_DEVICE 1
#endif  // TARGET_IPHONE_SIMULATOR
// By default, GTM has provided it's own unittesting support, define this
// to use the support provided by Xcode, especially for the Xcode4 support
// for unittesting.
#ifndef GTM_IPHONE_USE_SENTEST
#define GTM_IPHONE_USE_SENTEST 0
#endif
#else
// For MacOS specific stuff
#define GTM_MACOS_SDK 1
#endif

// Some of our own availability macros
#if GTM_MACOS_SDK
#define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
#define GTM_AVAILABLE_ONLY_ON_MACOS
#else
#define GTM_AVAILABLE_ONLY_ON_IPHONE
#define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
#endif

// Provide a symbol to include/exclude extra code for GC support.  (This mainly
// just controls the inclusion of finalize methods).
#ifndef GTM_SUPPORT_GC
#if GTM_IPHONE_SDK
// iPhone never needs GC
#define GTM_SUPPORT_GC 0
#else
// We can't find a symbol to tell if GC is supported/required, so best we
// do on Mac targets is include it if we're on 10.5 or later.
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#define GTM_SUPPORT_GC 0
#else
#define GTM_SUPPORT_GC 1
#endif
#endif
#endif

// To simplify support for 64bit (and Leopard in general), we provide the type
// defines for non Leopard SDKs
#if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
// NSInteger/NSUInteger and Max/Mins
#ifndef NSINTEGER_DEFINED
#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif
#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX
#define NSINTEGER_DEFINED 1
#endif  // NSINTEGER_DEFINED
// CGFloat
#ifndef CGFLOAT_DEFINED
#if defined(__LP64__) && __LP64__
// This really is an untested path (64bit on Tiger?)
typedef double CGFloat;
#define CGFLOAT_MIN DBL_MIN
#define CGFLOAT_MAX DBL_MAX
#define CGFLOAT_IS_DOUBLE 1
#else /* !defined(__LP64__) || !__LP64__ */
typedef float CGFloat;
#define CGFLOAT_MIN FLT_MIN
#define CGFLOAT_MAX FLT_MAX
#define CGFLOAT_IS_DOUBLE 0
#endif /* !defined(__LP64__) || !__LP64__ */
#define CGFLOAT_DEFINED 1
#endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

// Some support for advanced clang static analysis functionality
// See http://clang-analyzer.llvm.org/annotations.html
#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

#ifndef CF_RETURNS_NOT_RETAINED
#if __has_feature(attribute_cf_returns_not_retained)
#define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
#else
#define CF_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef NS_CONSUMED
#if __has_feature(attribute_ns_consumed)
#define NS_CONSUMED __attribute__((ns_consumed))
#else
#define NS_CONSUMED
#endif
#endif

#ifndef CF_CONSUMED
#if __has_feature(attribute_cf_consumed)
#define CF_CONSUMED __attribute__((cf_consumed))
#else
#define CF_CONSUMED
#endif
#endif

#ifndef NS_CONSUMES_SELF
#if __has_feature(attribute_ns_consumes_self)
#define NS_CONSUMES_SELF __attribute__((ns_consumes_self))
#else
#define NS_CONSUMES_SELF
#endif
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_ARGUMENT
#define NS_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_FUNCTION
#define NS_FORMAT_FUNCTION(F,A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_ARGUMENT
#define CF_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_FUNCTION
#define CF_FORMAT_FUNCTION(F,A)
#endif

#ifndef GTM_NONNULL
#define GTM_NONNULL(x) __attribute__((nonnull(x)))
#endif

#ifdef __OBJC__

// Declared here so that it can easily be used for logging tracking if
// necessary. See GTMUnitTestDevLog.h for details.
@class NSString;
GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);



// Macro to allow you to create NSStrings out of other macros.
// #define FOO foo
// NSString *fooString = GTM_NSSTRINGIFY(FOO);
#if !defined (GTM_NSSTRINGIFY)
#define GTM_NSSTRINGIFY_INNER(x) @#x
#define GTM_NSSTRINGIFY(x) GTM_NSSTRINGIFY_INNER(x)
#endif

// Macro to allow fast enumeration when building for 10.5 or later, and
// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
// does keys, so pick the right thing, nothing is done on the FastEnumeration
// side to be sure you're getting what you wanted.
#ifndef GTM_FOREACH_OBJECT
#if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (element in enumeration)
#define GTM_FOREACH_OBJECT(element, collection) \
for (element in collection)
#define GTM_FOREACH_KEY(element, collection) \
for (element in collection)
#else
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (NSEnumerator *_ ## element ## _enum = enumeration; \
(element = [_ ## element ## _enum nextObject]) != nil; )
#define GTM_FOREACH_OBJECT(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
#define GTM_FOREACH_KEY(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
#endif
#endif

// ============================================================================

// To simplify support for both Leopard and Snow Leopard we declare
// the Snow Leopard protocols that we need here.
#if !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)
#define GTM_10_6_PROTOCOLS_DEFINED 1
@protocol NSConnectionDelegate
@end
@protocol NSAnimationDelegate
@end
@protocol NSImageDelegate
@end
@protocol NSTabViewDelegate
@end
#endif  // !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)

// GTM_SEL_STRING is for specifying selector (usually property) names to KVC
// or KVO methods.
// In debug it will generate warnings for undeclared selectors if
// -Wunknown-selector is turned on.
// In release it will have no runtime overhead.
#ifndef GTM_SEL_STRING
#ifdef DEBUG
#define GTM_SEL_STRING(selName) NSStringFromSelector(@selector(selName))
#else
#define GTM_SEL_STRING(selName) @#selName
#endif  // DEBUG
#endif  // GTM_SEL_STRING

#endif // __OBJC__


//GTMDefines

#import <objc/objc-api.h>
#import <objc/objc-auto.h>


// These functions exist for code that we want to compile on both the < 10.5
// sdks and on the >= 10.5 sdks without warnings. It basically reimplements
// certain parts of the objc2 runtime in terms of the objc1 runtime. It is not
// a complete implementation as I've only implemented the routines I know we
// use. Feel free to add more as necessary.
// These functions are not documented because they conform to the documentation
// for the ObjC2 Runtime.

#if OBJC_API_VERSION >= 2  // Only have optional and req'd keywords in ObjC2.
#define AT_OPTIONAL @optional
#define AT_REQUIRED @required
#else
#define AT_OPTIONAL
#define AT_REQUIRED
#endif

// The file objc-runtime.h was moved to runtime.h and in Leopard, objc-runtime.h
// was just a wrapper around runtime.h. For the iPhone SDK, this objc-runtime.h
// is removed in the iPhoneOS2.0 SDK.
//
// The |Object| class was removed in the iPhone2.0 SDK too.
#if GTM_IPHONE_SDK
#import <objc/message.h>
#import <objc/runtime.h>
#else
#import <objc/objc-runtime.h>
#import <objc/Object.h>
#endif

#import <libkern/OSAtomic.h>

#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#import "objc/Protocol.h"

OBJC_EXPORT Class object_getClass(id obj);
OBJC_EXPORT const char *class_getName(Class cls);
OBJC_EXPORT BOOL class_conformsToProtocol(Class cls, Protocol *protocol);
OBJC_EXPORT BOOL class_respondsToSelector(Class cls, SEL sel);
OBJC_EXPORT Class class_getSuperclass(Class cls);
OBJC_EXPORT Method *class_copyMethodList(Class cls, unsigned int *outCount);
OBJC_EXPORT SEL method_getName(Method m);
OBJC_EXPORT void method_exchangeImplementations(Method m1, Method m2);
OBJC_EXPORT IMP method_getImplementation(Method method);
OBJC_EXPORT IMP method_setImplementation(Method method, IMP imp);
OBJC_EXPORT struct objc_method_description protocol_getMethodDescription(Protocol *p,
                                                                         SEL aSel,
                                                                         BOOL isRequiredMethod,
                                                                         BOOL isInstanceMethod);
OBJC_EXPORT BOOL sel_isEqual(SEL lhs, SEL rhs);

// If building for 10.4 but using the 10.5 SDK, don't include these.
#if MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_5
// atomics
// On Leopard these are GC aware
// Intentionally did not include the non-barrier versions, because I couldn't
// come up with a case personally where you wouldn't want to use the
// barrier versions.
GTM_INLINE bool OSAtomicCompareAndSwapPtrBarrier(void *predicate,
                                                 void *replacement,
                                                 void * volatile *theValue) {
#if defined(__LP64__) && __LP64__
	return OSAtomicCompareAndSwap64Barrier((int64_t)predicate,
										   (int64_t)replacement,
										   (int64_t *)theValue);
#else  // defined(__LP64__) && __LP64__
	return OSAtomicCompareAndSwap32Barrier((int32_t)predicate,
										   (int32_t)replacement,
										   (int32_t *)theValue);
#endif  // defined(__LP64__) && __LP64__
}

#endif  // MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_5
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

#if MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_5

GTM_INLINE BOOL objc_atomicCompareAndSwapGlobalBarrier(id predicate,
                                                       id replacement,
                                                       volatile id *objectLocation) {
	return OSAtomicCompareAndSwapPtrBarrier(predicate,
											replacement,
											(void * volatile *)objectLocation);
}
GTM_INLINE BOOL objc_atomicCompareAndSwapInstanceVariableBarrier(id predicate,
                                                                 id replacement,
                                                                 volatile id *objectLocation) {
	return OSAtomicCompareAndSwapPtrBarrier(predicate,
											replacement,
											(void * volatile *)objectLocation);
}
#endif  // MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_5



//
//  AGFoundation.m
//  AGFoundation
//
//  Created by Alex Gray on 4/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//



//@implementation AGFoundation
//@synthesize speaker;
//
//+ (AGFoundation *)sharedInstance	{	return [super sharedInstance]; }
//
//- (void)setUp {	
//
//	//	appArray = [[NSMutableArray alloc] init];
//	//	NSArray *ws =	 [[[NSWorkspace sharedWorkspace] launchedApplications] valueForKeyPath:@"NSApplicationPath"];
//	//	int k = 0;
//	//	for (NSString *path in ws) 	{
//	//		DBXApp *app = [DBXApp instanceWithPath:path];
//	//		[app setIndex:k];  k++;
//	//		[appArray addObject:app];
//	//	}
//}
//
//
//-(void) say:(NSString *)thing {
// 	// for (NSString *voice in
// 	NSArray *voices = [NSSpeechSynthesizer availableVoices];
// 	NSUInteger randomIndex = arc4random() % [voices count];
// 	NSString *voice = [voices objectAtIndex:randomIndex];
// 	[speaker setVoice: voice ];
// 	[speaker startSpeakingString: thing];
// 	printf("Speaking as %s\n", [voice UTF8String]);
// 	while ([speaker isSpeaking]) { usleep(40); }
//}
//
//@end


//- (void)enumerateProtocolMethods:(Protocol*)p { 
//// Custom block, used only in this method 
//	void (^enumerate)(BOOL, BOOL) = ^(BOOL isRequired, BOOL isInstance) { 
//		unsigned int descriptionCount; 
//		struct objc_method_description* methodDescriptions =  protocol_copyMethodDescriptionList(p, isRequired, isInstance, &descriptionCount); 
//		for (int i=0; i<descriptionCount; i++) { 
//			struct objc_method_description d = methodDescriptions[i]; 
//			NSLog(@"Protocol method %@ isRequired=%d isInstance=%d",  NSStringFromSelector(d.name), isRequired, isInstance);
//		} 
//		if (methodDescriptions)	free(methodDescriptions); 
//	}; 
//	// Call our block multiple times with different arguments  
//	// to enumerate all class, instance, required and non-required methods 
//	enumerate(YES, YES);
//	enumerate(YES, NO);
//	enumerate(NO, YES);
//	enumerate(NO, NO);
//}aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa




@implementation CAAnimation (NSViewFlipper)

+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGFloat)scaleFactor {
    // Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CGFloat startValue = beginsOnTop ? 0.0f : M_PI;
    CGFloat endValue = beginsOnTop ? -M_PI : 0.0f;
    flipAnimation.fromValue = [NSNumber numberWithDouble:startValue];
    flipAnimation.toValue = [NSNumber numberWithDouble:endValue];
	
    // Shrinking the view makes it seem to move away from us, for a more natural effect
    // Can also grow the view to make it move out of the screen
    CABasicAnimation *shrinkAnimation = nil;
    if ( scaleFactor != 1.0f ) {
        shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];
		
        // We only have to animate the shrink in one direction, then use autoreverse to "grow"
        shrinkAnimation.duration = aDuration * 0.5;
        shrinkAnimation.autoreverses = YES;
    }
	
    // Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];
	
    // As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = aDuration;
	
    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
	
    return animationGroup;
}

@end
@implementation NSView (AGAdditions)

-(CALayer *)layerFromContents
{
    CALayer *newLayer = [CALayer layer];
    newLayer.bounds = NSRectToCGRect(self.bounds);
    NSBitmapImageRep *bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
    newLayer.contents = (id)bitmapRep.CGImage;
    return newLayer;
}

@end

@implementation NSViewFlipperController
@synthesize isFlipped;
@synthesize duration;

-(id)initWithHostView:(NSView *)newHostView frontView:(NSView *)newFrontView backView:(NSView *)newBackView
{
    if ( self = [super init] ) {
    	hostView = newHostView;
        frontView = newFrontView;
        backView = newBackView;
        duration = 0.75;
    }
    return self;
}

-(void)flip {
	if ( isFlipped ) { topView = backView; bottomView = frontView; }
    else {topView = frontView; bottomView = backView; }
	CAAnimation *topAnimation = [CAAnimation flipAnimationWithDuration:duration forLayerBeginningOnTop:YES scaleFactor:1.3f];
    CAAnimation *bottomAnimation = [CAAnimation flipAnimationWithDuration:duration forLayerBeginningOnTop:NO scaleFactor:1.3f];
	bottomView.frame = topView.frame; topLayer = [topView layerFromContents]; bottomLayer = [bottomView layerFromContents];
	CGFloat zDistance = 1500.0f; CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1. / zDistance; topLayer.transform = perspective; bottomLayer.transform = perspective;
	bottomLayer.frame = NSRectToCGRect(topView.frame); // topView.frame;
    bottomLayer.doubleSided = NO;
    [hostView.layer addSublayer:bottomLayer];
	
    topLayer.doubleSided = NO;
    topLayer.frame = NSRectToCGRect(topView.frame);//topView.frame;
    [hostView.layer addSublayer:topLayer];
	
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [topView removeFromSuperview];
    [CATransaction commit];
	
    topAnimation.delegate = self;
    [CATransaction begin];
    [topLayer addAnimation:topAnimation forKey:@"flip"];
    [bottomLayer addAnimation:bottomAnimation forKey:@"flip"];
    [CATransaction commit];
}

-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
{
	isFlipped = !isFlipped;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [hostView addSubview:bottomView];
    [topLayer removeFromSuperlayer];
    [bottomLayer removeFromSuperlayer];
    topLayer = nil; bottomLayer = nil;
    [CATransaction commit];
}

-(NSView *)visibleView
{
    return (isFlipped ? backView : frontView);
}
@end

// Released by Drew McCormack into the pubic domain (2010).


@implementation NSWindow (Borderless)

+ (NSWindow*) borderlessWindowWithContentRect: (NSRect)aRect  {
	NSWindow *new = [[NSWindow alloc] initWithContentRect:aRect styleMask: NSBorderlessWindowMask
												  backing: NSBackingStoreBuffered	 defer: NO];
	[new setBackgroundColor: [NSColor clearColor]];							[new setOpaque:NO];
    return new;
}
@end


#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#import <stdlib.h>
#import <string.h>

Class object_getClass(id obj) {
	if (!obj) return NULL;
	return obj->isa;
}

const char *class_getName(Class cls) {
	if (!cls) return "nil";
	return cls->name;
}

BOOL class_conformsToProtocol(Class cls, Protocol *protocol) {
	// We intentionally don't check cls as it crashes on Leopard so we want
	// to crash on Tiger as well.
	// I logged
	// Radar 5572978 class_conformsToProtocol crashes when arg1 is passed as nil
	// because it seems odd that this API won't accept nil for cls considering
	// all the other apis will accept nil args.
	// If this does get fixed, remember to enable the unit tests.
	if (!protocol) return NO;
	
	struct objc_protocol_list *protos;
	for (protos = cls->protocols; protos != NULL; protos = protos->next) {
		for (long i = 0; i < protos->count; i++) {
			if ([protos->list[i] conformsTo:protocol]) {
				return YES;
			}
		}
	}
	return NO;
}

Class class_getSuperclass(Class cls) {
	if (!cls) return NULL;
	return cls->super_class;
}

BOOL class_respondsToSelector(Class cls, SEL sel) {
	return class_getInstanceMethod(cls, sel) != nil;
}

Method *class_copyMethodList(Class cls, unsigned int *outCount) {
	if (!cls) return NULL;
	
	unsigned int count = 0;
	void *iterator = NULL;
	struct objc_method_list *mlist;
	Method *methods = NULL;
	if (outCount) *outCount = 0;
	
	while ( (mlist = class_nextMethodList(cls, &iterator)) ) {
		if (mlist->method_count == 0) continue;
		methods = (Method *)realloc(methods,
									sizeof(Method) * (count + mlist->method_count + 1));
		if (!methods) {
			//Memory alloc failed, so what can we do?
			return NULL;  // COV_NF_LINE
		}
		for (int i = 0; i < mlist->method_count; i++) {
			methods[i + count] = &mlist->method_list[i];
		}
		count += mlist->method_count;
	}
	
	// List must be NULL terminated
	if (methods) {
		methods[count] = NULL;
	}
	if (outCount) *outCount = count;
	return methods;
}

SEL method_getName(Method method) {
	if (!method) return NULL;
	return method->method_name;
}

IMP method_getImplementation(Method method) {
	if (!method) return NULL;
	return method->method_imp;
}

IMP method_setImplementation(Method method, IMP imp) {
	// We intentionally don't test method for nil.
	// Leopard fails here, so should we.
	// I logged this as Radar:
	// 5572981 method_setImplementation crashes if you pass nil for the
	// method arg (arg 1)
	// because it seems odd that this API won't accept nil for method considering
	// all the other apis will accept nil args.
	// If this does get fixed, remember to enable the unit tests.
	// This method works differently on SnowLeopard than
	// on Leopard. If you pass in a nil for IMP on SnowLeopard
	// it doesn't change anything. On Leopard it will. Since
	// attempting to change a sel to nil is probably an error
	// we follow the SnowLeopard way of doing things.
	IMP oldImp = NULL;
	if (imp) {
		oldImp = method->method_imp;
		method->method_imp = imp;
	}
	return oldImp;
}

void method_exchangeImplementations(Method m1, Method m2) {
	if (m1 == m2) return;
	if (!m1 || !m2) return;
	IMP imp2 = method_getImplementation(m2);
	IMP imp1 = method_setImplementation(m1, imp2);
	method_setImplementation(m2, imp1);
}

struct objc_method_description protocol_getMethodDescription(Protocol *p,
                                                             SEL aSel,
                                                             BOOL isRequiredMethod,
                                                             BOOL isInstanceMethod) {
	struct objc_method_description *descPtr = NULL;
	// No such thing as required in ObjC1.
	if (isInstanceMethod) {
		descPtr = [p descriptionForInstanceMethod:aSel];
	} else {
		descPtr = [p descriptionForClassMethod:aSel];
	}
	
	struct objc_method_description desc;
	if (descPtr) {
		desc = *descPtr;
	} else {
		bzero(&desc, sizeof(desc));
	}
	return desc;
}

BOOL sel_isEqual(SEL lhs, SEL rhs) {
	// Apple (informally) promises this will work in the future:
	// http://twitter.com/#!/gparker/status/2400099786
	return (lhs == rhs) ? YES : NO;
}

#endif


