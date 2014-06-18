
//  SSGeometryKVC
//  Created by Colin Barrett on 1/13/10.

/*! @abstract

    [window mutableRectValueForKey:@"frame"].x = 20.0;
    
    [window mRVfK:@"frame"].x = 100000;
    [layer mGeo:@"bounds"].width = 30;
    
    
    id x = CAL.new; [x setGeos:@"bounds", @"x",@100, @"width", @5000, nil];
    
    f:{{ 0    x  0},{ 0   x 0 }}  b:{{ 0  x  0},{ 0   x 0 }} ->

    f:{{-2500 x  0},{5000 x 0  }} b:{{100 x  0},{5000 x 0  }}

*/


#import "AtoZUmbrella.h"

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#   define NSCGRect CGRect
#   define NSCGRectMake CGRectMake
#   define NSCGSize CGSize
#   define NSCGPoint CGPoint
#   define NSCGPointMake CGPointMake
#   define NSCGSizeMake CGSizeMake
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
#   define NSCGRect NSRect
#   define NSCGRectMake NSMakeRect
#   define NSCGSize NSSize
#   define NSCGSizeMake NSMakeSize
#   define NSCGPoint NSPoint
#   define NSCGPointMake NSMakePoint
#endif

@protocol SSGeo <NSObject>
@optional
- (void) notifyReceiver;
@property (nonatomic) CGFloat x, y, width, height;
@property (nonatomic) NSCGPoint origin;
@property (nonatomic) NSCGSize size;
@concrete
@property BOOL grouping;
- (void)beginGroup; // nesting groups has no effect
- (void)commitGroup;
@end

@class SSPoint,SSSize;

@interface SSRect : NSObject <SSGeo> {
@private
    id receiver;
    NSString *key;
    const char *objCType;
    BOOL grouping;
    CGFloat x,y,width, height;
}

@property (nonatomic) CGFloat x, y, width, height;
@property (nonatomic) NSCGPoint origin;
@property (nonatomic) NSCGSize size;
@property (readonly) SSPoint *mutableOrigin;
@property (readonly) SSSize *mutableSize;
@end

@interface SSPoint : NSObject <SSGeo>
{
@private
    id receiver;
    NSString *key;
    const char *objCType;
    BOOL grouping;
    SSRect *rect;
    CGFloat x, y;
}
@property (nonatomic) CGFloat x,y;
@end

@interface SSSize : NSObject <SSGeo>
{
@private
    id receiver;
    NSString *key;
    const char *objCType;
    BOOL grouping;
    SSRect *rect;
    CGFloat width, height;
}
@property (nonatomic) CGFloat width, height;
@end


#define mRVfK mutableRectValueForKey
#define mPVfK mutablePointValueForKey
#define mSVfK mutableSizeValueForKey
#define mGeo mutableGeoValueForKey
#define setGeos  setGeoValuesForKey

@interface NSObject (SSGeometry)

- (void) setGeoValuesForKey:(NSString*)key, ... NS_REQUIRES_NIL_TERMINATION;
- (NSObject<SSGeo>*) mutableGeoValueForKey:(NSString*)key;

- (SSRect*) mutableRectValueForKey:(NSString*)key;
- (SSPoint*)mutablePointValueForKey:(NSString *)key;
- (SSSize*)mutableSizeValueForKey:(NSString *)key;
@end

@interface NSValue (SSGeometryCompatibility)
+ (id)valueWithNSCGRect:(NSCGRect)inRect;
+ (id)valueWithNSCGSize:(NSCGSize)inSize;
+ (id)valueWithNSCGPoint:(NSCGPoint)inPoint;
@end

