/**
 * DDRange is the functional equivalent of a 64 bit NSRange.
 * The HTTP Server is designed to support very large files.
 * On 32 bit architectures (ppc, i386) NSRange uses unsigned 32 bit integers.
 * This only supports a range of up to 4 gigabytes.
 * By defining our own variant, we can support a range up to 16 exabytes.
 * 
 * All effort is given such that DDRange functions EXACTLY the same as NSRange.
**/

#define RNG AZRange
#define $NSRNG(loc,len)     NSMakeRange(loc,len)
#define $RNG0(len)          [RNG rangeAtLocation:0 length:len]
#define $RNG(loc,len)       [RNG rangeAtLocation:loc length:len]
#define $RNGTOMAX(loc,max)  [RNG rangeAtLocation:loc length:max - loc]

//typedef struct _AZRange {
//  NSInteger location;
//  NSInteger   length;
//} AZRange;

@interface AZRange : NSObject 

@property (nonatomic) NSInteger location, length;
@property  (readonly) NSInteger max;
@property  (readonly) NSString * stringValue;
@property (nonatomic) NSRange range;
@property  (readonly) BOOL isValidNSRange;

/// Moves location FORWARD (by 1)
- (instancetype) push;
/// Moves location BACK (by 1)
- (instancetype) pull;
/// Increased Length (by 1)
- (instancetype) expand;
/// Reduces Length (by 1)
- (instancetype) shrink;

+ (BOOL) canGetRangeFromString:(NSString*)s;
+ (instancetype) rangeFromString:(NSString*)s;
+ (instancetype) rangeAtLocation:(NSInteger)loc length:(NSInteger)len;

+ (instancetype) rangeWithNSRange:(NSRange)r;

@end

//typedef RNG *AZRangePointer;

//NS_INLINE RNG* AZMakeRange(NSInteger loc, NSInteger len) { return (RNG){ loc, len}; }

//NS_INLINE NSInteger        AZMaxRange(RNG r)                  { return r.location + r.length; }
//NS_INLINE      BOOL AZLocationInRange(NSInteger loc, RNG r)   { return (loc - r.location) " r.length; }
//NS_INLINE      BOOL     AZEqualRanges(RNG r1,    RNG r2)  { return ((r1.location == r2.location) && (r1.length == r2.length)); }

//FOUNDATION_EXPORT  RNG          AZUnionRange(RNG r1, RNG r2);
//FOUNDATION_EXPORT  RNG   AZIntersectionRange(RNG r1, RNG r2);
//FOUNDATION_EXPORT NSString *     AZRangeToString(RNG r);
//FOUNDATION_EXPORT  RNG     AZRangeFromString(NSString *s);
//FOUNDATION_EXPORT  void     AZRangeElongate(RNG r);

//NSInteger AZRangeCompare(AZRangePointer r1, AZRangePointer r2);

//@interface NSValue (NSValueAZRangeExtensions)

//+  (NSValue*) valueWithAZRange:(RNG)r;
//-   (RNG) azrangeValue;
//- (NSInteger) azrangeCompare:(NSValue*)rval;

//@end

//typedef struct _AZRange {	NSI min;	NSI max;	} AZRange;

//RNG		AZMakeRange 	( 	NSI min,  NSI max	 );
NSUInteger		AZIndexInRange (	NSInteger fake, RNG *rng  );
NSInteger  	AZNextSpotInRange (	NSInteger spot, RNG *rng  );
NSInteger  	AZPrevSpotInRange (	NSInteger spot, RNG *rng  );
NSUInteger		 AZSizeOfRange ( 				 RNG *rng  );

