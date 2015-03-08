
#ifndef AtoZ_MacroDefines
#define AtoZ_MacroDefines

#define vFK valueForKey
#define vFKP valueForKeyPath
#define mC mutableCopy
#define mAVFK  mutableArrayValueForKey
#define bFK boolForKey

#define bV boolValue
#define dV doubleValue
#define fV floatValue
#define iV integerValue
#define pV pointValue
#define rngV rangeValue
#define rV rectValue
#define strV stringValue
#define uIV unsignedIntegerValue

#define    kOpacity  @"opacity"
#define    kPhase @"phase"
#define      kBGC @"backgroundColor"
#define    kBGNSC @"backgroundNSColor"
#define  zNL @"\n"
#define zTAB @"\t"
#define zSPC @" "
#define zNIL @""

#pragma mark - ACTIVE NSLOG

#define  NSLog(fmt...)  ((void)printf("%s %s\n",__PRETTY_FUNCTION__,[[NSString.alloc initWithFormat:fmt]UTF8String]))
#define NSLogC(fmt...)  NSLog(fmt)

#define APPLE_MAIN int main(int argc, char **argv, char **envp, char **apple)
#define MAIN(...) APPLE_MAIN { ({ __VA_ARGS__; }); }

// START NEEDHOMES

#define    WORD definition

// END NEEDHOMES

#pragma mark - Foundation

#define     IBA IBAction
#define     IBO IBOutlet
#define    INST instancetype
#define    IFCE interface
#define    IMPL implementation

#define      CP copy
#define      WK weak
#define     ASS assign
#define     GET getter
#define    SETR setter
#define    UNSF unsafe_unretained
#define   NATOM nonatomic
#define      RO readonly
#define      RW readwrite
#define     STR strong

#define   prop_ property
#define   prop__ property (STR)

#define   prop_NC  prop_ (NATOM,CP)
#define   prop_NA  prop_ (NATOM)
#define   prop_RO  prop_ (RO)
#define   prop_CP  prop_ (CP)
#define   prop_AS  prop_ (ASS)
#define   prop_WK  prop_ (WK)
#define   prop_RC  prop_ (RO,CP)

#define PROP(...) property (__VA_ARGS__)

#define AZPROPERTY(_kind_,_arc_,...)  @property (_arc_)  _kind_   __VA_ARGS__;
#define AZPROPERTYIBO(_kind_,...)     @property (assign) IBOutlet  _kind_   __VA_ARGS__;

#define  IDDRAG id<NSDraggingInfo>
#define  IDPBW id<NSPasteboardWriting>
#define    IDCP id<NSCopying>

#define 	CCHAR const char*

#define AZSTRSTR(A)    @property (nonatomic, strong) NSString* A
#define AZPROPSTR(z,x)  @property (nonatomic, strong) z *x
#define AZPROPRDO(z,x)   @property (readonly) z* x
#define AZPROP_HINTED(_type_,_hints_,_name_)    @property (_hints_) _type_ _name
#define AZPROPS(_type_,_directives_,...)        for(int i=2, i<VA_NUM_ARGS, i++) AZPROP

#define   prop_RW property (nonatomic,readwrite)
#define   NSIFACE(X)        @interface X : NSObject + (instancetype)
#define INTERFACE(X,...)    @interface X : __VA_ARGS__ + (instancetype)
#define    EXTEND(X)        @interface X ()
#define      VOID(X)      - (void) X
#define FACTORY + (instancetype)
#define TYPEDEF_V(X)        typedef void(^X)

#define     ACT  id<CAAction>
#define AZIDCAA (id<CAAction>)
#define   IDCAA (id<CAAction>)

#define    NSPB NSPasteboard
#define    NSPBGENERAL [NSPB generalPasteboard]

#define ISADICT isKindOfClass:NSDictionary.class
#define ISANARRAY isKindOfClass:NSArray.class

#pragma mark - Quartz

#define CAMASK enum CAAutoresizingMask
#define       CGP CGPoint
#define      CGCR CGColorRef
#define       CGF CGFloat
#define       CGS CGSize
#define       CIF CIFilter
#define    CGCREF CGContextRef
#define      CGSZ CGSize
#define     CGRGB CGColorCreateGenericRGB
#define CGPATH(A) CGPathCreateWithRect(R)
#define    JSCREF JSContextRef
#define      CGPR CGPathRef
#define       CGR CGRect
#define      CGWL CGWindowLevel
#define      CFTI CFTimeInterval

#define                                sblrs sublayers
#define                                  CAL CALayer
#define                               CACcWA CAConstraint constraintWithAttribute
#define                                  loM layoutManager
#define                            AZNOCACHE NSURLRequestReloadIgnoringLocalCacheData
#define                                NDOBC needsDisplayOnBoundsChange
#define                               arMASK autoresizingMask
#define                                 kCLR @"color"
#define                                 kPOS @"position"
#define                             CATRANNY CATransaction
#define                              CACONST CAConstraint
#define                                 CASL CAShapeLayer
#define                               aPoint anchorPoint
#define                                CALNH CALayerNoHit
#define                                  mTB masksToBounds
#define                                 CAT3 CATransform3D
#define                    AZSLayer @"superlayer"
#define                                 CAAG CAAnimationGroup
#define                                 kIMG @"image"
#define                                  CAA CAAnimation
#define                                  bgC backgroundColor
#define                                 CAGL CAGradientLayer
#define                               CATXTL CATextLayer
#define                                CALNA CALayerNonAnimating
#define                             CATRANST CATransition
#define                          CACONSTATTR CAConstraintAttribute
#define CARL CAReplicatorLayer
#define CGIREF CGImageRef
#define CGCLRREF CGColorRef
#define  AZSL @"superlayer"

#pragma mark - NS

#define NSW NSWindow
#define NSU NSURL
#define NSET NSSet
#define NSS   NSString
#define CSET  NSCountedSet
#define NSUI  NSUInteger
#define ASOCK GCDAsyncSocket
#define NSBST NSBackingStoreType

#define NSDCLASS NSDictionary.class
#define NSFH NSFileHandle
#define NSOQ NSOperationQueue
#define AZAPPBUNDLE NSBundle.mainBundle
#define AZAPPRESOURCES [NSBundle.mainBundle resourcePath]
#define AZCLSSTR NSStringFromClass ( [self class] )
#define AZNULL [NSNull null]
#define AZOQMAX NSOperationQueueDefaultMaxConcurrentOperationCount
#define AZPROP(A,B) @property (nonatomic, strong) A* B
#define DATA DTA
#define DATE NSDate
#define DTA NSData
#define IMG NSIMG
#define NSA NSArray
#define NSACLASS NSArray.class
#define NSAS NSAttributedString
#define NSB NSBundle
#define NSBIR NSBitmapImageRep
#define NSBLO NSBlockOperation
#define NSBP NSBezierPath
#define NSC NSColor
#define NSCOMPR NSComparisonResult
#define NSCS NSCountedSet
#define NSD NSDictionary
#define NSE NSEvent
#define NSED NSEntityDescription
#define NSF NSFont
#define NSI NSInteger
#define NSIMG NSImage
#define NSINV NSInvocation
#define NSIP NSIndexPath
#define NSIR NSImageRep
#define NSIS NSIndexSet
#define NSJS NSJSONSerialization
#define NSJSONS NSJSONSerialization
#define NSMA NSMutableArray
#define NSMAS NSMutableAttributedString
#define NSMD NSMutableDictionary
#define NSMDATA NSMutableData
#define NSMIS NSMutableIndexSet
#define NSMO NSManagedObject
#define NSMOC NSManagedObjectContext
#define NSMOM NSManagedObjectModel
#define NSMPS NSMutableParagraphStyle
#define NSMS NSMutableString
#define NSMSET NSMutableSet
#define NSMSet NSMutableSet
#define NSN NSNumber
#define NSNOT NSNotification
#define NSO NSObject
#define NSP NSPoint
#define NSPInRect NSPointInRect
#define NSPLS NSPropertyListSerialization
#define NSPSC NSPersistentStoreCoordinator
#define NSR NSRect
#define NSRNG NSRange
#define NSS NSString
#define NSSCLASS NSString.class
#define NSST NSSet
#define NST NSTimer
#define NSTI NSTimeInterval
#define NSTXTV NSTextView
#define NSUI NSUInteger
#define NSURLREQ NSURLRequest
#define NSVAL NSValue
#define NSVT NSValueTransformer
#define rV rectValue
#define TMR NSTimer
#define uiV unsignedIntegerValue
#define VAL NSVAL

#if __has_feature(objc_arc_weak)
#ifndef NATOMICWEAK
#define NATOMICWEAK nonatomic,weak
#else
#define NATOMICWEAK nonatomic,assign
#endif
#endif

#define RET_ASSOC                 return objc_getAssociatedObject(self ,_cmd)
#define SET_ASSOC_DELEGATE(X)     objc_setAssociatedObject(self, NSSelectorFromString([NSString stringWithUTF8String:#X]),\
X,OBJC_ASSOCIATION_COPY_NONATOMIC); self.delegate = self
#define SET_ASSOC(X)              objc_setAssociatedObject(self, NSSelectorFromString([NSString stringWithUTF8String:#X]),\
X,OBJC_ASSOCIATION_COPY_NONATOMIC);
/** INSTEAD OF NASTY BLOCK SETTERS AND GETTERS FOR DYNAMIC DELEGATES... */
/* SYNTHESIZE_DELEGATE( didOpenBlock, setDidOpenBlock,
 (void(^)(WebSocket*ws)),
 (void)webSocketDidOpen:(WebSocket*)ws,
 DO_IF_SELF(didOpenBlock))
 @param */

#define SYNTHESIZE_DELEGATE(BLOCK_NAME,SETTER_NAME,SIG,METHOD,BLOCK) \
- SIG BLOCK_NAME { RET_ASSOC; }\
- (void) SETTER_NAME:SIG BLOCK_NAME { SET_ASSOC_DELEGATE(BLOCK_NAME); }\
- METHOD { BLOCK; }

/*  INSTEAD OF NASTY ASSOCIATED OBJECTS.....  */

#define DO_IF_SELF(X)  if (self.X && self.delegate == self) self.X(self)
#define DO_IF_1ARG(X,Z) if (self.X && self.delegate == self) self.X(self,Z)

#define RET_ASSOC      return objc_getAssociatedObject(self ,_cmd)
#define SET_ASSOC_DELEGATE(X)   objc_setAssociatedObject(self, NSSelectorFromString([NSString stringWithUTF8String:#X]),\
X,OBJC_ASSOCIATION_COPY_NONATOMIC); self.delegate = self
#define SET_ASSOC(X)   objc_setAssociatedObject(self, NSSelectorFromString([NSString stringWithUTF8String:#X]),\
X,OBJC_ASSOCIATION_COPY_NONATOMIC);

/*
 Example Setter
 - (void) setSomething:(BOOL)something { if (self.something == something) return;  SAVE(@selector(something), @(something)); }
 Example Getter
 - (BOOL) something { id x = FETCH; return x ? [x boolValue] : NO; }
 */

//FOUNDATION_STATIC_INLINE BOOL SameSEL(SEL a, SEL b) {
// return (BOOL)sel_isEqual(a, b);
//}

#define ASSIGN_WEAK(__self,sel,WK) ({ objc_setAssociatedObject(__self,@selector(sel),WK,OBJC_ASSOCIATION_ASSIGN); })
#define ASSIGNBOOL(sel,VAL) objc_setAssociatedObject(self,sel, @(VAL),OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define REFERENCE(sel,obj) objc_setAssociatedObject(self,sel, obj, 0)
#define _REFERENCE(sel,obj) objc_setAssociatedObject(_self,sel, obj, OBJC_ASSOCIATION_ASSIGN)
#define COPY(sel,obj)   objc_setAssociatedObject(self,sel, obj, OBJC_ASSOCIATION_COPY)
#define _COPY(sel,obj)   objc_setAssociatedObject(_self,sel, obj, OBJC_ASSOCIATION_COPY)
#define SAVE(sel,obj)   objc_setAssociatedObject(self,sel, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define GETTER (SEL)NSSelectorFromString([[AZSELSTR substringAfter:@"set"].decapitalized substringBefore:@":"])
#define _SAVE(sel,obj)   objc_setAssociatedObject(_self,sel, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define SAVEREFERENCE(obj)   ({ objc_setAssociatedObject(self,GETTER,obj,OBJC_ASSOCIATION_ASSIGN); })
#define OPEN(sel)    objc_getAssociatedObject(self, sel)
#define _OPEN(sel)    objc_getAssociatedObject(_self, sel)
#define FETCH          objc_getAssociatedObject(self, _cmd)
#define _FETCH          objc_getAssociatedObject(_self, _cmd)
#define FETCH_OR(X)        FETCH ?: X
#define CALLSUPER [super _cmd]
#define CALLSUPERWITH(X) [super performString:AZSELSTR     withObject:X]

//#define MAX(a, b) ((a) > (b) ? (a) : (b))
//#define MIN(a, b) ((a) < (b) ? (a) : (b))
//#define YESNO ( b )    ( (b) ? @"YES" : @"NO" )
//#define YESNO ( b ) b ? @"YES" : @"NO"

#ifndef      FIFTEEN_DEGREES // some useful angular constants
#define      FIFTEEN_DEGREES  .261799387799
#define       NINETY_DEGREES  (pi * .5 )
#define    FORTYFIVE_DEGREES  (pi * .25)
#define         HALF_PI       (pi * .5 )
#define            TWOPI (2 * 3.1415926535)
#define    RAND_UINT_MAX 0xFFFFFFFF
#define     RAND_INT_MAX 0x7FFFFFFF
#endif

#define NEG(a) -a
#define HALF(a) (a / 2.0)

#define StringFromBOOL(b) (b?@"YES":@"NO")

#define       P(x,y)  CGPointMake(x, y)
#define       R(x,y)  CGRectMake(0,0,x, y)
#define       S(w,h)  NSMakeSize(w,h)
#define       RAND01()  ((random() / (float)0x7fffffff ))     // returns float in range 0 - 1.0f
          //usage RAND01()*3, or (int)RAND01()*3 , so there is no risk of dividing by zero
#pragma mark - arc4random()

#define      RAND_UINT() arc4random()           // positive unsigned integer from 0 to RAND_UINT_MAX
#define     RAND_INT() ((int)(arc4random() & 0x7FFFFFFF))    // positive unsigned integer from 0 to RAND_UINT_MAX
#define    RAND_INT_VAL(a,b) ((arc4random() % ((b)-(a)+1)) + (a))   // integer on the interval [a,b] (includes a and b)

#define     RAND_FLOAT() (((float)arc4random()) / RAND_UINT_MAX)  // float between 0 and 1 (including 0 and 1)
#define  RAND_FLOAT_VAL(a,b) (((((float)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))
// float between a and b (including a and b)

// note: Random doubles will contain more precision than floats, but will NOT utilize the full precision of the double. They are still limited to the 32-bit precision of arc4random
#define    RAND_DOUBLE() (((double)arc4random()) / RAND_UINT_MAX)  // double betw. 0 & 1 (incl. 0 and 1)
#define RAND_DOUBLE_VAL(a,b) (((((double)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))// dbl btw. a and b (incl a and b)

#define RAND_BOOL()    (arc4random() & 1)         // a random boolean (0 or 1)
#define RAND_DIRECTION()  (RAND_BOOL() ? 1 : -1)        // -1 or +1 (usage: int steps = 10*RAND_DIRECTION();  will get you -10 or 10)

//#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))
#define LIMIT( value, min, max )  (((value) < (min))? (min) : (((value) > (max))? (max) : (value))) // pinning a value between a lower and upper limit
//#define DEGREES_TO_RADIANS( d )  ((d) * 0.0174532925199432958)    // converting from radians to degrees
//#define  RADIANS_TO_DEGREES( r )  ((r) * 57.29577951308232)

#ifndef DEG2RAD // degree to radians

#define         ARAD  .017453f
#define DEG2RAD(deg)  (deg * ARAD)
#define RAD2DEG(rad)  (rad * 180.0f / M_PI)
#endif

#define CLAMP(value, lowerBound, upperbound) MAX( lowerBound, MIN( upperbound, value ))

#define AZDistance(A,B) sqrtf(powf(fabs(A.x - B.x), 2.0f) + powf(fabs(A.y - B.y), 2.0f))
#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))

#define NEWLAYER(_x_) CAL* _x_ = CAL.new
//#define NEW(_class_,_name_) _class_ *_name_ = [_class_.alloc init]

#define NEWATTR(_class_,_name_...)

#define $NSMD(_NAME_) NSMutableDictionary *_NAME_ = NSMutableDictionary.new
#define $NSMA(_NAME_) NSMutableArray *_NAME_ = NSMutableArray.new

#define ptmake(A,B)   CGPointMake(A,B)stringByAppendingPathComponent

#define SUPERINIT        if (!(self = [super init])) return nil
#define SUPERINITWITHFRAME(f)     if (!(self = [super initWithFrame:f])) return nil

#define SUPERWINDOWINIT  if(!(self=[super initWithContentRect:r styleMask:m backing:b defer:f])) return nil

// StringConsts.h
#ifdef SYNTHESIZE_CONSTS
# define STR_CONST(name, value) NSString* const name = @ value
#else
# define STR_CONST(name, value) extern NSString* const name
#endif

#define __VA_ARG_CT__(...) __VA_ARG_CT__IMPL(0, ## __VA_ARGS__, 5,4,3,2,1,0)
#define __VA_ARG_CT__IMPL(_0,_1,_2,_3,_4,_5,N,...) N

//#define __VA_ARG_CT__(...) (sizeof(#__VA_ARGS__) == sizeof("") ? 0 : VA_NUM_ARGS_IMPL(__VA_ARGS__, 5,4,3,2,1))

#define VA_NUM_ARGS(...) VA_NUM_ARGS_IMPL(__VA_ARGS__, 9,8,7,6,5,4,3,2,1) 	 	// USAGE int i = VA_NUM_ARGS("sssss",5,3);  -> i = 3
#define VA_NUM_ARGS_IMPL(_1,_2,_3,_4,_5,_6,_7,_8,_9,N,...) N

//@interface NSIMG (SizeLike) <SizeLike> @end

//#define    FORBIDDEN_CLASSES( ([NSA arrayWithObjects:__VA_ARGS__]contains           [NSException raise:@"We should never get here!" format:@"%@ should have implemented this:%@", self.className, AZSELSTR]
#define  ASSERTSAME(A,B)      NSAssert(A == B, @"These values should be same, but they are %@ and %@", @(A), @(B))
#define    CONFORMS(PROTO)    [self conformsToProtocol:@protocol(PROTO)]
#define IF_CONFORMS(PROTO,X)  if(CONFORMS(PROTO)){ ({ X; }) }

#define    GETALIASF(X)        return [self floatForKey:@#X]  // [self vFK:NSStringify(X)];    [value getValue: ptr];    (const char * typeCode, void * value); [self  X]
#define    SETALIAS(X,V)      [self sV:V fK:@#X]

//#define REFUSE_CLASSES(SPLIT)
//	[NSException raise:@"NonConformantProtocolMethodFallThrough" format:@"This concrete protocol NEEDS YOU (%@) to

#define YOU_DONT_BELONG return [NSException raise:@"ProtocolIsOverridingYourMethod" format:@"You already implement %@. why are you (%@) here?", AZSELSTR, self]

#define DEMAND_CONFORMANCE	[NSException raise:@"NonConformantProtocolMethodFallThrough" format:@"This concrete protocol NEEDS YOU (%@) to implement this method,.. %@ elsewhere... for internal peace and traquility.",NSStringFromClass([self class]), AZSELSTR]

#pragma mark - COLORS
#define $RGBA(R,G,B,A) ((NSC*)[NSC r:R g:G b:B a:A])
#define idCG(COLOR) (id)[COLOR CGColor]
#define          WHITE ((NSC*)[NSC     whiteColor])
#define         PURPLE ((NSC*)[NSC   r:0.617 g:0.125 b:0.628 a:1.])
#define           BLUE ((NSC*)[NSC   r:0.267 g:0.683 b:0.979 a:1.])
#define     RANDOMGRAY ((NSC*)[NSC  white:RAND_FLOAT_VAL(0,1) a:1])
#define          GRAY9 ((NSC*)[NSC  white:.9 a: 1])
#define     PERIWINKLE ((NSC*)[NSColor colorWithDeviceRed:.79 green:.78 blue:.9 alpha:1])
#define   cgRANDOMGRAY ((CGColorRef)RANDOMGRAY.CGColor) // CGColorCreateGenericGray( RAND_FLOAT_VAL(0,1), 1)
#define          GREEN ((NSC*)[NSC   r:0.367 g:0.583 b:0.179 a:1.])
#define          GRAY7 ((NSC*)[NSC  white:.7 a: 1])
#define    kWhiteColor ((CGColorRef)cgWHITE)
#define          BLACK ((NSC*)[NSC blackColor])
#define          GRAY5 ((NSC*)[NSC  white:.5 a: 1])
#define  cgRANDOMCOLOR ((CGColorRef)RANDOMCOLOR.CGColor)
#define        cgGREEN ((CGColorRef)GREEN.CGColor)
#define          cgRED ((CGColorRef)RED.CGColor)
#define      RANDOMPAL [NSC  randomPalette]
#define         cgGREY ((CGColorRef)GREY.CGColor)
#define          GRAY3 ((NSC*)[NSC  white:.3 a: 1])
#define         YELLOw ((NSC*)[NSC   r:0.830 g:0.801 b:0.277 a:1.])
#define        cgWHITE ((CGColorRef)WHITE.CGColor)
#define         cgBLUE ((CGColorRef)BLUE.CGColor)
#define          GRAY1 ((NSC*)[NSC  white:.1 a: 1])
#define           GREY ((NSC*)[NSC      grayColor])
#define           PINK ((NSC*)[NSC   r:1.000 g:0.228 b:0.623 a:1.])
#define       cgYELLOW ((CGColorRef)YELLOW.CGColor)
#define    kBlackColor ((CGColorRef)cgBLACK)
#define          GRAY8 ((NSC*)[NSC  white:.8 a: 1])
#define       cgPURPLE ((CGColorRef)PURPLE.CGColor)
#define          CLEAR ((NSC*)[NSC     clearColor])
#define          GRAY6 ((NSC*)[NSC  white:.6 a: 1])

#if !TARGET_OS_IPHONE
#define    RANDOMCOLOR ((NSC*)[NSC colorWithCalibratedRed:(rand() % 255)/255. green:(rand() % 255)/255. blue:(rand() % 255)/255. alpha:1.])
#else
#define    RANDOMCOLOR [UIColor colorWithRed:(rand() % 255)/255. green:(rand() % 255)/255. blue:(rand() % 255)/255. alpha:1.]
#endif

#define         ORANGE ((NSC*)[NSC   r:0.888 g:0.492 b:0.000 a:1.])
#define       cgORANGE ((CGColorRef)ORANGE.CGColor)
#define        cgBLACK ((CGColorRef)BLACK.CGColor)
#define          GRAY4 ((NSC*)[NSC  white:.4 a: 1])
#define   cgCLEARCOLOR ((CGColorRef)CLEAR.CGColor)
#define          GRAY2 ((NSC*)[NSC  white:.2 a: 1])
#define STANDARDCOLORS  = @[RED,ORANGE,YELLOW,GREEN,BLUE,PURPLE,GRAY]
#define            RED ((NSC*)[NSC   r:0.797 g:0.000 b:0.043 a:1.])
#define         YELLOW ((NSC*)[NSC   r:0.830 g:0.801 b:0.277 a:1.])
#define          LGRAY ((NSC*)[NSC  white:.5 a:.6])

#define AZSTATIC(_TYPE,_NAME,_VAL)              static _TYPE _NAME = (_VAL)

#define AZSTATIC_OBJ(_KLASS,_NAME,...)          static _KLASS *_NAME; _NAME = _NAME ?: ({ __VA_ARGS__; });

#define AZSTATIC_OBJBLK(_KLASS,_NAME,_VALBLK)   static _KLASS *_NAME; _NAME = _NAME ?: (id)(_VALBLK())

//#define AZSTATIC_CONST(_TYPE,_NAME,_CONST,_VAL) static _TYPE _NAME = _CONST; _NAME = _VAL

//#define BlockWeakObject(o) __typeof(o) __weak
//#define BlockWeakSelf(_x_) BlockWeakObject(self)

///// For when you need a weak reference to self, example: `BBlockWeakSelf wself = self;`
//#define AZWeakSelf(_x_)  __block __typeof__(self) _x_ = self

//maye this... https://gist.github.com/4707815
// or maybe mazeroingweak

/// For when you need a weak reference of an object, example: `BBlockWeakObject(obj) wobj = obj;`
#define BlockSafeObject(o) __typeof__(o) __weak

/// For when you need a weak reference to self, example: `BBlockWeakSelf wself = self;`
#define AZBlockSelf(_x_)  __block __typeof__(self) _x_ = self 
#define AZBlockObj(_x_, _name_)  __block __typeof__(_x_) _name_ = _x_

#define declareBlockSafe(__obj__) __weak __typeof__(__obj__) __obj__ = __obj__
#define __blockSafe(__obj__)                    __obj__
#define __blk(__obj__)                          __blockSafe(__obj__)
#define declareBlockSafeAs(__obj__, __name__)   __weak __typeof__(__obj__) __name__ = __obj__

//__tmpblk __tmpblk## __tmpblk##

#define SELFBLK void(^)(id _self)

#define ISKINDA           isKindOfClass                           /// @c  [@"d" ISKINDA:NSNumber.class]   -> NO
#define ISA(OBJ,KLS)      (BOOL)([((id)OBJ) ISKINDA:[KLS class]])	/// @c  ISA(@"apple",NSString)          -> YES
#define ISNOTA(OBJ,KLASS) (BOOL)(!ISA(((id)OBJ),KLASS))           /// @c  ISA(@"apple",NSString)          -> YES
#define AM_I_A(KLASS)     ISA(self,KLASS)                         /// @c  AM_I_A(NSString)                -> YES
#define IS_NULL(X)        (!X || [X isEqual:AZNULL])              /// @c  IS_NULL(x)                      -> ??

/*! @c forKeys:SPLIT(handleInset|cornerRadius)] -> forKeys:@[@"handleInset",@"cornerRadius"]] 
    should technically also work with an NSSTRIng...
*/
#define     SPLIT(STR)  [@#STR componentsSeparatedByString:@"|"]  // RAW CSTRING INPUT!!

/*! @c  BOOL x = SPLIT_HAS(screenEdge|mouseEdge,@"someShit") -> NO   
OR  @c  BOOL z = SPLIT_HAS(screenEdge|mouseEdge,mouseEdge) -> YES (any use case? dont we already know?)
*/
#define SPLIT_HAS(SPLITEE,NEEDLE)    [SPLIT(SPLITEE) containsObject:NEEDLE] // RAW CSTRING INPUT!!

/*! SPLIT_SET(screenEdge|mouseEdge) -> [NSSet setWithArray:@[@"handleInset",@"cornerRadius"]]
    RET_SPLIT_SET(screenEdge)       -> return ... (see above)
*/
#define SPLIT_SET(RAWSTR)     [NSSet setWithArray:SPLIT(RAWSTR)]
#define RET_SPLIT_SET(STR) return SPLIT_SET(STR)

//OBJC_EXPORT  BOOL AZISAAnyOfThese(Class x, ...); // under construction

//#define ISANYOF(OBJ,...) AZISAAnyOfThese([OBJ class],__VA_ARGS__,NULL) // under construction

OBJC_EXPORT BOOL AZEqualToAnyObject(id x, ...); 

#define EQUAL2ANYOF(OBJ,...) (BOOL)AZEqualToAnyObject(OBJ,__VA_ARGS__)

#define ISIN(X,ARRAY) [ARRAY containsObject:X]

#define IS_IN_STATIC_SPLIT(NEEDLE,...) ISIN(NEEDLE,SPLIT(__VA_ARGS__))

// ({ AZSTATIC_OBJ(NSA,HAYSTACK,SPLIT(HAYSTACK)); [HAYSTACK containsObject:NEEDLE]; })

#define ISACLASS(OBJ) class_isMetaClass(object_getClass(OBJ))

/*! ALLARE - check that all NSArray objects are a certain class.. @code  id x = @[RED, GREEN, @1]; ALLARE(x,NSC)) ? [x ...] : nil;  */

#define ALLARE(OBJS,KLS) ({ NSParameterAssert(ISA(OBJS,NSA)); [OBJS all:^BOOL(id obj) { return ISA(obj,KLS); }]; })

//object_getClass([a class]))					// USAGE  ISACLASS(NSString)					-> YES

// USAGE  IFKINDA( X, SomeClass, LOG_EXPR(((SomeClass*)X).someProperty) );
#define IFKINDA(_obj_,_meta_,_method_)				  ({ if([_obj_ ISKINDA:[_meta_ class]]) _method_; })
#define IFKINDAELSE(_obj_,_meta_,_method_,_else_) ({ if([_obj_ ISKINDA:[_meta_ class]]) _method_; else _else_; })
#define IFNOT(_condition_,_action_)					  ({ if(!(_condition_)) _action__; })

//  AZPROP_HINTED(NSUInteger,ASS,poop);   -> @property (assign) NSUInteger _name;

//#define IFACE_(CLASSNAME)           IFACE CLASSNAME
//#define IFACE_/ISA(CLASSNAME,BASE)   IFACE_(CLASSNAME) : BASE
//#define IFACE_ID(CLASSNAME)         IFACE_ISA(CLASSNAME,NSObject)  // IFACE_ID(Fart) -> @interface Fart : NSObject

#define      AZIFACEDECL(_name_,_super_)  @interface _name_ : _super_
#define    AZNSIFACEDECL(_name_)          AZIFACEDECL(_name_,NSObject)

/*!   AZIFACE(MixinObject,NSA) // create mixin.
      EXTMixin(MixinObject, NSColor) // mix
      @implementation MixinObject @end // voila!
*/
#define CLASS(X) interface X : NSO

#define ENUM(x) JREnumDeclare(x)

#define      AZIFACE(_name_,_super_)  AZIFACEDECL(_name_,_super_) @end
#define    AZNSIFACE(_name_)          AZIFACE(_name_,NSObject)

#define                       AZIMPDECL(_name_) @implementation _name_
#define                       AZFULLIMP(_name_,_super_,...) AZIFACE(_name_,_super_) AZIMPDECL(_name_) __VA_ARGS__ @end 
#define          AZINTERFACEIMPLEMENTED(_name_) AZNSIFACE(_name_) AZIMPDECL(_name_) @end
#define AZINTERFACEIMPLEMENTEDWITHBLOCK(_name_,_super_,_BLOCK__) AZIFACE(_name_,_super_) _BLOCK__(); @end @implementation _name_ @end

#define AZTESTCASE(_name_)  @interface _name_ : XCTestCase @end @implementation _name_

#define AZTEST(_methodname_, _actions_)   - (void) test##_methodname_ { ({ _actions_; }); }

//#define AZINTERFACE(_name_,...) @interface _name_ : __VA_ARGS__ ?: NSObject   // AZINTERFACE(NSMA,Alex) -> @interface Alex : NSMutableArray

#define AZSTRONGSTRING(A) @property (nonatomic, strong) NSString* A
//AZPROPASS(_kind_...) @property (NATOM,ASS) _kind_ __VA_ARGS__ //#QUALIFIER_FROM_BITMASK(_arc_)

/*	CLANG_IGNORE(-Wuninitialized);
	Shady Shit
	CLANG_POP;
*/ /// Also in AutoBox (redundancy needs fix)

#define CLANG_IGNORE_HELPER0(x) #x
#define CLANG_IGNORE_HELPER1(x) CLANG_IGNORE_HELPER0(clang diagnostic ignored x)
#define CLANG_IGNORE_HELPER2(y) CLANG_IGNORE_HELPER1(#y)
#define CLANG_POP _Pragma("clang diagnostic pop")
#define CLANG_IGNORE(x)\
	_Pragma("clang diagnostic push");\
	_Pragma(CLANG_IGNORE_HELPER2(x))

#define CLANG_IGNORE_DEPRECATED CLANG_IGNORE(-Wdeprecated-declarations)
#define CLANG_IGNORE_PROTOCOL CLANG_IGNORE(-Wprotocol)

#define $point(A)     [NSValue valueWithPoint:A]
#define $points(A,B)     [NSValue valueWithPoint:CGPointMake(A,B)]
#define $rect(A,B,C,D)  [NSValue valueWithRect:CGRectMake(A,B,C,D)]

#define NSU  NSURL
#define $URL(A)    !ISA(A,NSS) || !A || ![A length] ? nil : \
                      [AZFILEMANAGER fileExistsAtPath:A] ? [NSURL fileURLWithPath:A] : \
                      [NSURL URLWithString:A]
                      
#define $SEL(A)    NSSelectorFromString(A)
#define AZStringFromSet(A) [NSS stringFromArray:A.allObjects]

#define     $(...)    ((NSS*)[NSS stringWithFormat:__VA_ARGS__,nil])
#define    $$(...)    ((NSS*)[NSS stringWithFormat:@__VA_ARGS__,nil])
#define $JOIN(...)    ((NSS*)[@[__VA_ARGS__] componentsJoinedByString:@" "])
#define  $set(...)    ((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])
#define  $map(...)    ((NSD*)[NSD dictionaryWithObjectsAndKeys:__VA_ARGS__,nil])

#define    $ints(...) [NSA arrayWithInts:__VA_ARGS__,NSNotFound]
#define $doubles(...) [NSA arrayWithDoubles:__VA_ARGS__,MAXFLOAT]
#define   $words(...) [[@#__VA_ARGS__ splitByComma] trimmedStrings]

#define     $float(A) [NSN numberWithFloat:(A)]
#define      $UTF8(A) [NSS stringWithUTF8String:A]
#define $UTF8orNIL(A) A ? [NSS stringWithUTF8String:A] : nil
#define       $int(A) @(A) // [NSNumber numberWithInt:(A)]

#define $IDX(X) [NSIS indexSetWithIndex:X]
#define $idxsetrng(X) [NSIS indexSetWithIndexesInRange:X]
#define $IDXRNG(L,X) [NSIS indexSetWithIndexesInRange:$NSRNG(L,X)]

//#define $#(A)    ((NSString *)[NSString string
//#define $array(...)   ((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])

#define idxOf indexOfObject
#define capped capitalizedString
#define AZSELSTR NSStringFromSelector(_cmd)

#define $ARRAYSET(A) [NSSet setWithArray:(A)]
#define $CG2NSC(A) [NSC colorWithCGColor:(A)]

// We often want to introspect something.  We always need to know if we are working with an ObjC object, or a primitive.

#define IS_OBJECT(_x_) _Generic( (_x_), id: YES, default: NO)

/* Exaples  of IS_OBJECT(_x_)...

	 	NSRect    a = (NSRect){1,2,3,4};	 IS_OBJECT(a) ? @"YES" : @"NO" -" NO
		NSString* b = @"whatAmI?";	       IS_OBJECT(b) ? @"YES" : @"NO" -" YES
		NSInteger c = 9;						 IS_OBJECT(a) ? @"YES" : @"NO" -" NO   */

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) 		\
+ (classname *)accessorname {                                       \
	static classname *accessorname = nil;                             \
	static dispatch_once_t onceToken;                                 \
	dispatch_once(&onceToken, ^{ accessorname = classname.new; });		\
	return accessorname; 															\
}

#define SYNTHESIZE_CLASS_FACTORY(accessorname) 		\
+ (instancetype) accessorname { return [self.class new]; }

#ifndef metamacro_take
#define metamacro_take(N, ...) \
        metamacro_concat(metamacro_take, N)(__VA_ARGS__)
#endif

#define AZASTRING @"attributedString"
#define AZSTRING  @"string"
#define AZFRAME   @"frame"
#define AZBOUNDS  @"bounds"

#define AZDEFAULTFONT [AtoZ controlFont]

#define            AZFONTMANAGER NSFontManager.sharedFontManager
#define    NSZeroRange  NSMakeRange(0,0)

#undef wCVfK
#define       wCVfK  willChangeValueForKey
#define       dCVfK  didChangeValueForKey

/* USAGE   SetKPfVA( Siblings, @"siblingIndexMax")  where "siblings" is the dependent key */
#define kPfVA(X) keyPathsForValuesAffecting##X
#define SetKPfVA(X,...) + (NSST*) kPfVA(X) { return [NSST setWithObjects:__VA_ARGS__,nil]; }

/* + (SET*) kPfVAVfK:(NSS*)  -> return [super kPfVAVfK:k]  */

#define kPfVAVfK keyPathsForValuesAffectingValueForKey

#define  SELFTYPE(_x_)            typeof(self) _x_

#define  CLASS_ARRAY(...) [metamacro_stringify map:^id(id o){ return NSClassFromString(o); }]

#define  KINDA_ANY(...) ({ id split = SPLIT(metamacro_stringify(metamacro_tail(__VA_ARGS__)));\
\
 id comparators = [split map:^id(id z){ return NSClassFromString(z); }];\
\
id compareto = [metamacro_head(__VA_ARGS__) class];\
\
 BOOL hasa = [comparators containsObject:compareto];\
\
 if (!hasa) { printf("%s is not one of any of %s", [compareto cDesc], [comparators cDesc]); }\
\
 hasa; })

#define NSAssertFail(x) do { NSAssert(0, x); } while(0)  // ( do { NSAssert(0, x); } while(0) )   ///((nil)NSAssert(0, x)) //

#define                                         AZNOTCENTER (NSNotificationCenter*)NSNotificationCenter.defaultCenter
#define                                                  pV pointValue
#define                                         sepByString componentsSeparatedByString
    #define            NSV NSView

#define                                           AZVrng(c) [NSVAL  valueWithRange: c]
#define                                       AZGRAPHICSCTX NSGraphicsContext.currentContext
#define                                              AZSSOQ AZSharedSingleOperationQueue()
#define                                           AZVclr(c) [NSVAL valueWithColor: c]
#if TARGET_OS_IPHONE
#define                                          AZVrect(r) [NSVAL   valueWithCGRect: r]
#else
#define                                          AZVrect(r) [NSVAL   valueWithRect: r]
#endif

#define                                     sepByCharsInSet componentsSeparatedByCharactersInSet
#define                                            sansLast arrayByRemovingLastObject
#define                                           AZNEWPIPE NSPipe.pipe

#if !TARGET_OS_IPHONE
#define                                          AZVsize(s) [NSVAL valueWithSize: s]
#else
#define                                          AZVsize(s) [NSVAL valueWithCGSize: s]
#endif

#if !TARGET_OS_IPHONE
#define                                         AZVpoint(p) [NSVAL valueWithPoint: p]
#else
#define                                         AZVpoint(p) [NSVAL valueWithCGPoint: p]
#endif

#define IFNOT_RETURN(x)  ({ if (!(x)) return 0; })
#define NSBOOL(X) [NSNumber numberWithBool:X]
#define NSSET(...) [NSSet setWithObjects: __VA_ARGS__, nil]

//#define AZNewInfer(_name_, _val_) __typeof((_val_)) _name_ = __

#define AZNew(_class_,_name_) _class_ *_name_ = [_class_ new]
//#define AZNewObj(_class_,_name_) _class_ *_name_ = [_class_ new]
//#define AZNewObj(_name_,...) __typeof((__VA_ARGS__)) *_name_ = (__VA_ARGS__)
#define AZNewVal(_name_,...)  __typeof((__VA_ARGS__))   _name_ = (__VA_ARGS__)

#define AZNewStatic(_name_,...)  static __typeof((__VA_ARGS__))   _name_; _name_ = _name_ ?: (__VA_ARGS__)

#define                                       AZFILEMANAGER NSFileManager.defaultManager
#define                                              FUTURE NSDate.distantFuture
#define                                         NSZeroRange NSMakeRange(0,0)

#if TARGET_OS_IPHONE

#pragma mark -  REDEFINITIONS

#define NSFont UIFont
#define NSNib UINib
#define NSEvent UIEvent
#define NSView UIView
#define NSWindow UIWindow
#define NSImage UIImage
#define NSColor UIColor
#define NSPoint CGPoint
#define NSRect CGRect
#define NSSize CGSize

#define NSZeroPoint CGPointZero
#define NSZeroSize CGSizeZero
#define  NSZeroRect CGRectZero

#else

//#define NSCalibratedRGBColorSpace UICalibratedRGBColorSpace

#define           NSOV NSOutlineView
#define           NSOVD NSOutlineViewDelegate
#define           NSOVDS NSOutlineViewDataSource
#define           NSAC NSArrayController
#define           NSMI NSMenuItem
#define           NSRE NSRectEdge
#define        NSMenuI NSMenuItem
#define            NSG NSGradient
#define        NSRFill NSRectFill

//(((void)DDLogInfo(__VA_ARGS__)))
//#define NSLogC(...) (((void)DDLogCInfo(__VA_ARGS__)))

#pragma mark - STRINGS

#define                                        AZBezPath(r) [NSBezierPath bezierPathWithRect: r]
#define                                          AZNEWMUTEA NSMutableArray.array
#define                                    kContentImageKey @"itemImage"
#define                                               AZPAL AZPalette
#define                                              KVONEW NSKeyValueObservingOptionNew
#define                                          AZVposi(p) [NSVAL      valueWithPosition: p]
#define                                       AZVinstall(p) [NSVAL valueWithInstallStatus: p]
#define                                                AZIS AZInstallationStatus
#define                                          AZNEWMUTED NSMutableDictionary.new
#define performBlockIfDelegateRespondsToSelector(block,sel) if ([delegate respondsToSelector:sel]) { block(); }
#define                             AZTAreaInfo(frame,info) [NSTA.allocinitWithRect: frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved ) owner:self userInfo:info]
#define                                   NSEVENTGLOBALMASK NSEvent addGlobalMonitorForEventsMatchingMask
#define                                       MOUSEDRAGGING MOUSEDOWN | MOUSEDRAG | MOUSEUP
#define                                    NSKVOBEFOREAFTER NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
#define                                            AZV3d(t) [NSVAL valueWithCATransform3D: t]
#define                                              KVOOLD NSKeyValueObservingOptionOld
#define                                          AZTRACKALL (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved)
#define                                        AZQTZCONTEXT [NSGraphicsContext.currentContext  graphicsPort]
#define                                      AZTArea(frame) [NSTA.alloc initWithRect:frame options:AZTRACKALL owner:self userInfo:nil]
#define                                       CAMEDIAEASEIN [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
#define                                    kContentTitleKey @"itemTitle"
#define                                                AZOS AZSharedOperationStack()
#define                                    NSEVENTLOCALMASK NSEvent addLocalMonitorForEventsMatchingMask
#define                          kItemSizeSliderPositionKey @"ItemSizeSliderPosition"
#define                                          AZPROCINFO NSProcessInfo.processInfo
#define                                               AZSOQ AZSharedOperationQueue()
#define                                            AZGVItem AtoZGridViewItem
#define                                         AZSHAREDLOG DDTTYLogger.sharedInstance
#define                                          AZPROCNAME [NSProcessInfo.processInfo processName]
#define                                            ELSENULL ?:  [NSNull null]
#define                                       AZFWRESOURCES [AZFWORKBUNDLE resourcePath]
#define                                             MOUSEUP NSLeftMouseUpMask
#define                                        AZQtzPath(r) [(AZBezPath(r)) quartzPath]
#define                                          AZWEBPREFS WebPreferences.standardPreferences
#define                                       AZUSERDEFSCTR NSUserDefaultsController.sharedUserDefaultsController
#define            AZBindSelector(observer,sel,keypath,obj) [AZNOTCENTER  addObserver:observer selector:sel name:keypath object:obj]
#define                                             AZGView AtoZGridView
#define                                         AZTALK(log) [AZTalker.new say:log]
#define                                      AZPROPIBO(A) @property (ASS) IBOutlet A      //QUOTE(A)
#define                AZBind(binder,binding,toObj,keyPath) [binder bind:binding toObject:toObj withKeyPath:keyPath options:nil]

#define                                        NSBezPath(r) AZBezPath(r)
#define                                          AZUSERDEFS NSUserDefaults.standardUserDefaults
#define                                         CAMEDIAEASY [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
#define                                CGSUPRESSINTERVAL(x) CGEventSourceSetLocalEventsSuppressionInterval(nil,x)
#define                                         AZWORKSPACE NSWorkspace.sharedWorkspace
#define                                                pFCN postsFrameChangedNotifications
#define                                           MOUSEDOWN NSLeftMouseDownMask
#define                        performDelegateSelector(sel) if ([delegate respondsToSelector:sel]) { [delegate performSelector:sel]; }
#define                                        AZCOLORPANEL NSColorPanel.sharedColorPanel
#define                                         AZLAYOUTMGR [CAConstraintLayoutManager layoutManager]
#define                                    kContentColorKey @"itemColor"
#define                                     AZContentBounds [[[self window ] contentView] bounds]
#define                                      CAMEDIAEASEOUT [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
#define                                             setPBCN setPostsBoundsChangedNotifications:YES
#define                                               AZPOS AZA
#define                                        AZCURRENTCTX AZGRAPHICSCTX
#define                                             setPFCN setPostsFrameChangedNotifications:YES
#define                                                pBCN postsBoundsChangedNotifications

#define                                           MOUSEDRAG NSLeftMouseDraggedMask
//#define                                       AZFWORKBUNDLE [NSBundle bundleForClass:AtoZ.class]

#pragma mark - TUI

#define    BLKV BLKVIEW
#define  IDWPDL id<WebPolicyDecisionListener>
#define    AHLO AHLayoutObject
#define  TUINSV TUINSView
#define BLKVIEW BNRBlockView
#define  TUINSW TUINSWindow
#define    TUIV TUIView
#define   TUIVC TUIViewController
#define      WV WebView
#define    AHLT AHLayoutTransaction
#define    Blk VoidBlock
#define    Blk VoidBlock

#pragma mark - AZ

#define    AZCACWide AZConstRelSuper ( kCAConstraintWidth  )
#define        AZRUN while(0) [NSRunLoop.currentRunLoop run]
#define    AZCACMaxY AZConstRelSuper ( kCAConstraintMaxY   )
#define    AZCACHigh AZConstRelSuper ( kCAConstraintHeight )
#define    AZCACMinX AZConstRelSuper( kCAConstraintMinX   )
#define    AZCACMaxX AZConstRelSuper ( kCAConstraintMaxX   )
#define    AZRUNLOOP NSRunLoop.currentRunLoop
#define    AZCACMinY AZConstRelSuper ( kCAConstraintMinY   )
#define     AZLOGCMD LOGCOLORS($UTF8(__PRETTY_FUNCTION__), AZCLSSTR, RANDOMPAL, nil)
#define AZRUNFOREVER [AZRUNLOOP runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture]
#define AZRANDOMICON [NSIMG randomMonoIcon]

#pragma mark - VIEWS

#define       pBCN postsBoundsChangedNotifications
#define       pFCN postsFrameChangedNotifications
#define NSSIZEABLE NSViewHeightSizable | NSViewWidthSizable

#define NSCSRGB NSColorSpace.genericRGBColorSpace

#define NSURLREQFMT(CACHE,TO,...)\
[NSURLREQ requestWithURL:\
    [NSString stringWithFormat:__VA_ARGS__].urlified\
                 cachePolicy:CACHE\
             timeoutInterval:TO]

//((NSURLREQ*)({ int a = metamacro_argcount(__VA_ARGS__);\ /NSURLREQ *req =

#define        NSSCRLV NSScrollView
#define           NSPO NSPopover
#define          NSBSB NSBackingStoreBuffered
#define         NSTABV NSTabView
#define         NSURLC NSURLConnection
#define    NSAorDCLASS @[NSArray.class, NSDictionary.class]
#define           NSWC NSWindowController
#define          NSCSV NSCellStateValue
#define           NSGC NSGraphicsContext
#define           NSSI NSStatusItem
#define           NSTV NSTableView
#define           NSTRV NSTableRowView
#define         NSTVDO NSTableViewDropOperation
#define            SIG NSMethodSignature
#define      NSMURLREQ NSMutableURLRequest
#define         NSSHDW NSShadow
#define ISADICTorARRAY isKindOfAnyClass:NSAorDCLASS
#define          NSERR NSError
#define           NSVC NSViewController
#define           NSEM NSEventMask
#define           NSOP NSOperation
#define            NSM NSMenu
#define           NSTA NSTrackingArea
#define         NSTXTF NSTextField
#define        NSBRWSR NSBrowser
#define           NSOS NSOperationStack
#define           NSAT NSAffineTransform
#define           NSCL NSColorList
#define           NSTC NSTableColumn
#define       NSPUBUTT NSPopUpButton

    #define           NSPI NSProgressIndicator
    #define        NSSPLTV NSSplitView
    #define          NSTSK NSTask
    #define           NSIV NSImageView
    #define          NSBWM NSBorderlessWindowMask
    #define           NSDO NSDragOperation
    #define         NSSEGC NSSegmentedControl
    #define         NSACTX NSAnimationContext
    #define         NSTBAR NSToolbar
    #define           NSSZ NSSize
    #define          NSAPP NSApplication
    #define           NSDE NSDirectoryEnumerator

    #define         NSBUTT NSButton
    #define       NSURLRES NSURLResponse

    #define NSCSET NSCharacterSet
#pragma mark - CoreAnimation

#define                               CAT3DR CATransform3DRotate
#define                           removedOnC removedOnCompletion
#define                                nDoBC needsDisplayOnBoundsChange
#define                              constWa constraintWithAttribute
#define                                 CAKA CAKeyframeAnimation
#define                                 kLAY @"layer"
#define                             kPSTRING @"pString"
#define                                 kFRM @"frame"
#define                              CAT3DTR CATransform3DTranslate
#define                                 zPos zPosition
#define                                 ID3D CATransform3DIdentity
#define                              CASCRLL CAScrollLayer
#define                                 CATL CATransformLayer
#define CATransform3DMakePerspective (x, y )  (CATransform3DPerspective( CATransform3DIdentity, x, y ))
#define                                kHIDE @"hide"
#define                           CASIZEABLE kCALayerWidthSizable | kCALayerHeightSizable
#define                                 kSTR @"string"
#define                                  CAT CATransaction
#define                                CAMTF CAMediaTimingFunction
#define                              cRadius cornerRadius
#define                            CATIMENOW CACurrentMediaTime()
#define                                 lMGR layoutManager
#define                                CAT3D CATransform3D
#define                               CATLNH CATextLayerNoHit
#define                                  fgC foregroundColor
#define                                 CABA CABasicAnimation
#define                                 CAGA CAGroupAnimation
#define                                CASHL CAShapeLayer
#define                                 kIDX @"index"
#define                               CASLNH CAShapeLayerNoHit
#define  CATransform3DPerspective( t, x, y ) (CATransform3DConcat(t, CATransform3DMake(1,0,0,x,0,1,0,y,0,0,1,0,0,0,0,1)))

#define QUALIFIER_FROM_BITMASK(q) q&AZ_arc_NATOM      ? nonatomic    :\
q&AZ_arc_NATOM|AZ_arc_STRNG  ? nonatomic,strong  :\
q&AZ_arc_RO      ? readonly     :\
q&AZ_arc__COPY      ? copy      :\
q&AZ_arc_NATOM|AZ_arc__COPY  ? nonatomic,copy   :\
q&AZ_arc__WEAK      ? weak    : assign

#define INV NSInvocation
#define A2DD A2DynamicDelegate
#define A2DD4PROTOCOL(PROTO) [A2DD.alloc initWithProtocol:@protocol(PROTO)]
#define A2DDIMP(DD,SEL,BLK)  ({ [DD implementMethod:@selector(SEL) withBlock:({ BLK; })]; })  

#define AZGV   AtoZGridView
#define AZGVA   AtoZGridViewAuto
#define AZGVI   AtoZGridViewItem
#define AZGVDATA AtoZGridViewDataSouce
#define AZGVDEL  AtoZGridViewDelegate

#define NSKA    NSKeyedArchiver
#define NSKUA   NSKeyedUnarchiver

#define qP      quartzPath
#define AZSLDST AZSlideState
#define AZWT    AZWindowTab
//#define AZWTV   AZWindowTabViewPrivate

//#define NSOrderedDictionary M13OrderedDictionary

#define clr colorLogString

#pragma mark               - GLOBAL CONSTANTS

#pragma mark - VIEWS

#define     NSSIZEABLE  NSViewHeightSizable | NSViewWidthSizable
#define       pBCN  postsBoundsChangedNotifications
#define       pFCN  postsFrameChangedNotifications

#define INRANGE(x,MINVAL,MAXVAL) (BOOL)({ MINVAL <= x && x <= MAXVAL; })

#define CFAA        CFAAction
#define UDEFSCTL   [NSUserDefaultsController sharedUserDefaultsController]
#define CONTINUOUS  NSContinuouslyUpdatesValueBindingOption:@(YES)
#define AZN  AZNode

#define ClassConst(X) X == [NSS class] ? NSS : X == [NSN  class] ? NSN  : \
                      X == [NSA class] ? NSA : X == [NSMA class] ? NSMA : \
                      X == [NSD class] ? NSD : X == [NSMD class] ? NSMD : id

#define SAFE_CAST(OBJECT, TYPE) ({ \
  id obj=OBJECT;[obj isKindOfClass:[TYPE class]] ? (TYPE *) obj: nil; })

//IS_OBJECT((__VA_ARGS__)) ? __typeof((__VA_ARGS__)) * _name_ = (__VA_ARGS__) 

#define AZFWBNDL AZFWORKBUNDLE
#define NSENUM NSEnumerator
#define CABD  BlockDelegate
#define FM   NSFileManager.defaultManager
#define UDEFS  NSUserDefaults.standardUserDefaults
#define PINFO NSProcessInfo.processInfo
#define AZF AZFile

#define DISABLE_SUDDEN_TERMINATION(_SELFBLK_) [NSProcessInfo.processInfo disableSuddenTermination]; \
_SELFBLK_(self); [NSProcessInfo.processInfo enableSuddenTermination];

#pragma mark - STRINGS

#define sepByCharsInSet componentsSeparatedByCharactersInSet
#define sepByString componentsSeparatedByString
#define sansLast arrayByRemovingLastObject

#define NSVA NSViewAnimation

#define          AZFONT NSFontAttributeName

#define     setPBCN  setPostsBoundsChangedNotifications:YES
#define     setPFCN  setPostsFrameChangedNotifications:YES
#define      pBCN  postsBoundsChangedNotifications
#define      pFCN  postsFrameChangedNotifications

#define  NSKVOBEFOREAFTER NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
#define            KVONEW  NSKeyValueObservingOptionNew
#define      KVOOLD  NSKeyValueObservingOptionOld

#define  NSEVENTLOCALMASK  NSEvent addLocalMonitorForEventsMatchingMask
#define NSEVENTGLOBALMASK  NSEvent addGlobalMonitorForEventsMatchingMask

#define         MOUSEDRAG  NSLeftMouseDraggedMask
#define          MOUSEUP  NSLeftMouseUpMask
#define     MOUSEDOWN NSLeftMouseDownMask
#define MOUSEDRAGGING MOUSEDOWN | MOUSEDRAG | MOUSEUP

#define FUTURE NSDate.distantFuture

#define   AZFWORKBUNDLE [NSBundle bundleForClass:NSClassFromString(@"AtoZ")]
#define   AZFWBUNDLE AZFWORKBUNDLE
#define   AZFWRESOURCES  [AZFWORKBUNDLE resourcePath]
#define       AZAPPBUNDLE  NSBundle.mainBundle
#define     AZAPPINFO  [AZAPPBUNDLE infoDictionary]
#define     AZAPPNAME   [AZAPPBUNDLE objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define     AZAPP_ID   [AZAPPBUNDLE objectForInfoDictionaryKey:@"CFBundleIdentifier"]
#define    AZAPPRESOURCES  [NSBundle.mainBundle resourcePath]

#define    CAMEDIAEASEOUT  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
#define   CAMEDIAEASEIN  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
#define       CAMEDIAEASY  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
#define       AZWORKSPACE  NSWorkspace.sharedWorkspace
#define      AZCOLORPANEL  NSColorPanel.sharedColorPanel
#define      AZUSERDEFS  NSUserDefaults.standardUserDefaults
#define NSOPANEL  NSOpenPanel.openPanel

#define AZ_DEFS_DOMAIN     @"AtoZ"

#define    AZ_DEFAULTS    [AZUSERDEFS persistentDomainForName:AZ_DEFS_DOMAIN]
//     AZ_DEFAULTS is the same as $(defaults read AtoZ)

#define    AZ_DEFAULT(KEY)     AZ_DEFAULTS[KEY]
// [NSUserDefaults.standardUserDefaults persistentDomainForName:@"AtoZ"][@"pooop"] = Bejememe

#define  AZ_SET_DEFAULT(KEY,VAL)   [AZUSERDEFS setPersistentDomain:[AZ_DEFAULTS dictionaryWithValue:VAL forKey:KEY]  forName:AZ_DEFS_DOMAIN]

#define   AZUSERDEFSCTR  NSUserDefaultsController.sharedUserDefaultsController
#define       AZNOTCENTER  (NSNotificationCenter*)NSNotificationCenter.defaultCenter
#define     AZWORKSPACENC  NSWorkspace.sharedWorkspace.notificationCenter
#define     AZDISTNCENTER  NSDistributedNotificationCenter.defaultCenter
#define   AZFILEMANAGER  NSFileManager.defaultManager
#define   AZGRAPHICSCTX  NSGraphicsContext.currentContext
#define     AZCURRENTCTX  AZGRAPHICSCTX
#define     AZQTZCONTEXT  [NSGraphicsContext.currentContext graphicsPort]
#define       AZSHAREDAPP  ((NSApplication*)[NSApplication sharedApplication])
#define       AZAPPEVENT  AZSHAREDAPP.currentEvent
#define       AZMODIFIERFLAGS AZAPPEVENT.modifierFlags

#define       AZAPPACTIVATE [AZSHAREDAPP setActivationPolicy:NSApplicationActivationPolicyRegular], [NSApp activateIgnoringOtherApps:YES]
#define       AZAPPRUN AZAPPACTIVATE, [NSApp run]
#define       AZAPPWINDOW [AZSHAREDAPP mainWindow]
#define         AZAPPVIEW ((NSView*)[AZAPPWINDOW contentView])
#define     AZCONTENTVIEW(V) ((NSView*)[V contentView])
#define      AZWEBPREFS  WebPreferences.standardPreferences
//#define      AZPROCINFO  NSProcessInfo.processInfo
#define      AZPROCNAME  [NSProcessInfo.processInfo processName]
#define      AZPROCARGS NSProcessInfo.processInfo.arguments
#define      AZARGS      [AZPROCARGS after:0]
#define      AZNEWPIPE  NSPipe.pipe
#define    AZNEWMUTEA  NSMutableArray.array
#define    AZNEWMUTED  NSMutableDictionary.new
#define      AZSHAREDLOG DDTTYLogger.sharedInstance

#define AZCURRENTDOC [NSDocumentController.sharedDocumentController currentDocument]
#define AZCURRENTDOCWINDOW [AZCURRENTDOC windowForSheet]

#define NSTN NSTreeNode 
#define tNwRO treeNodeWithRepresentedObject
#define mcNodes mutableChildNodes

/*  
  NSLog(@"%s", QUOTE(NSR));     NSLog(@"%s", EXPQUOTE(NSR));
  NSLog(@"%@", $UTF8(EXPQUOTE(NSR)));  NSLog(NSQUOTE(NSC));
  NSLog(NSEXPQUOTE(NSC));
*/
#define QUOTE(str) #str         // printf("%s\n", QUOTE(NSR));  -> %s NSR
#define EXPQUOTE(str) QUOTE(str)     // printf("%s\n", EXPQUOTE(NSR)); -> %s NSRect
#define NSQUOTE(str) $UTF8(#str)     // -> %@ NSR
#define NSEXPQUOTE(str) $UTF8(QUOTE(str))  // -> %@ NSRect
// NSW* theWindowVar; ->
// NSLog(@"%@", NSEXPQUOTE(theWindowVar));   -> %@ theWindowVar

//#define ISKINDA(x,y) [y isKindOfClass:[y class]]

//#warning - todo

//NSA*maybeAnArray = objc_dynamic_cast(UISwitch,viewController.view); if (switch) NSLog(@"It jolly well is!);
//That's nice, isn't it? Here's how:

#define objc_dynamic_cast(TYPE, object) \
  ({ \
      TYPE *dyn_cast_object = (TYPE*)(object); \
      [dyn_cast_object isKindOfClass:[TYPE class]] ? dyn_cast_object : nil; \
  })

#define AZCLASSNIBNAMED(_CLS_,_INSTANCENAME_) do { \
 NSArray *objs     = nil;                      \
 static NSNib   *aNib  = [NSNib.alloc initWithNibNamed:AZCLSSTR bundle:nil] instantiateWithOwner:nil topLevelObjects:&objs]; \
 _CLS_ *_INSTANCENAME_  = [objs objectWithClass:[_CLS_ class]]; \
} while(0)

//#define AZPROPASS (A,B...)  @property (NATOM,ASS) A B
//#define AZPROPIBO (A,B...)  @property (ASS) IBOutlet A B
// static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS;  \

//#define PROPSTRONG (@property (nonatomic,strong) )
//#define PROPASSIGN (@property (nonatomic,assign) )

//#define STRONG ((nonatomic,strong) )
//#define ASSIGN ((nonatomic,assign) )
#define AZWindowPositionToString AZAlignToString
#define CGSUPRESSINTERVAL(x) CGEventSourceSetLocalEventsSuppressionInterval(nil,x)
#define AZPOS AZA// AZWindowPosition
//

#define AZOBJCLSSTR(X) NSStringFromClass ( [X class] )
#define AZCLSSTR NSStringFromClass ( [self class] )
#define AZSSOQ AZSharedSingleOperationQueue()
#define AZSOQ AZSharedOperationQueue()
#define AZOS AZSharedOperationStack()
#define NSOQMQ NSOperationQueue.mainQueue

#define AZNULL [NSNull null]
#define ELSENULL ?: [NSNull null]
#define AZGView AtoZGridView
#define AZGVItem AtoZGridViewItem

#define GPAL AtoZ.globalPalette
#define GPALNEXT GPAL.nextNormalObject

#define AZPAL AZPalette
#define AZIS AZInstallationStatus

#define AZAPPDELEGATE (NSObject<NSApplicationDelegate>*)[NSApp delegate]

#define performDelegateSelector(sel) if ([delegate respondsToSelector:sel]) { [delegate performSelector:sel]; }
#define performBlockIfDelegateRespondsToSelector(block, sel) if ([delegate respondsToSelector:sel]) { block(); }

#define AZBindSelector(observer,sel,keypath,obj) [AZNOTCENTER addObserver:observer selector:sel name:keypath object:obj]
#define AZBind(binder,binding,toObj,keyPath) [binder bind:binding toObject:toObj withKeyPath:keyPath options:nil]

#define       kContentTitleKey @"itemTitle"
#define       kContentColorKey @"itemColor"
#define       kContentImageKey @"itemImage"
#define       kItemSizeSliderPositionKey @"ItemSizeSliderPosition"

#define  AZTRACKALL  (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved)
#define AZTArea(frame)  [NSTA.alloc initWithRect:frame options:AZTRACKALL owner:self userInfo:nil]
//
//#define AZTAreaInfo(frame,info) [NSTA.alloc initWithRect: frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved ) owner:self userInfo:info];

#define NSAssertBlock(condition, desc, ...) do {                                      \
  __PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS                                                 \
  if (!(condition)) { __strong typeof(self) strongSelf = _self;                       \
    [NSAssertionHandler.currentHandler handleFailureInMethod:_cmd                     \
                                                      object:strongSelf               \
                                                        file:$UTF8(__FILE__)          \
                                                  lineNumber:__LINE__                 \
                                                 description:(desc), ##__VA_ARGS__];  \
  }                                                                                   \
  __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
} while(0)
    
    
#pragma mark - FUNCTION defines

// Usage  NEW( aColor, NSColor.clearColor );   ->  aColor.alphaComponent -> 0.0
#define NEWTYPEOF(_name_,_value_)        __typeof(_value_) _name_ = _value_
#define BLOCKIFY(_name_,_value_)  __block __typeof(_value_) _name_ = _value_

#define DYNAMIC(_class_,_type_,_name_...) \
@interface     _class_ (Dynamic##_name_) @property _type_ _name_; @end \
@implementation _class_ (Dynamic##_name_) @dynamic _name_; @end

#define DYDISPLAYforKEYorSUPER(_key_)  [self.dynamicPropertyNames containsObject:_key_] ?: [super needsDisplayForKey:_key_]
#define SUBLAYERofCLASS(_class_)   [self sublayerOfClass:[_class_ class]]

#define AZCACHEDIR NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

#define MAKEDIR(_X_) [AZFILEMANAGER createDirectoryAtPath:_X_ \
                              withIntermediateDirectories:YES \
                                               attributes:nil \
                                                    error:nil]
#define MAKEDIR_IFNEEDED(_X_) [AZFILEMANAGER fileExistsAtPath:_X_] ?: MAKEDIR(_X_)

//#define SUPERINITWITH(X)      if (!(self = (IS_OBJECT(X) ? [super performSelector:_cmd withObject:X] : [super performSelector:_cmd withRect:X]))) return nil

#define SELFDELEGATE        [self setDelegate:self], [self setNeedsDisplay]
#define WINLOC(_event_)      [_event_ locationInWindow]

#define IF_RETURNIT(_X_) if (_X_) return _X_
#define IF_RETURN(_X_) if (_X_) return (id)nil
#define IF_VOID(_X_) if (_X_) return
#define IF_RETURNV(_X_) IF_VOID(_X_)

#define IF_ICAN_THEN(_SEL_,THEN) if([self respondsToSelector:@selector(_SEL_)]) ({ THEN; });

#define IF_CAN_DO(_X_,_SEL_) \
  if(_X_ != nil && [_X_ respondsToSelector:@selector(_SEL_)]) @synchronized(_X_) { [_X_ performSelectorOnMainThread:@selector(_SEL_)]; }

#define REQ RouteRequest
#define RES RouteResponse
#define $SHORT(A,B) [Shortcut.alloc initWithURI:A syntax:B]

#define LOCALIZED_STRING(key) [[NSBundle bundleForClass:[AtoZ class]]localizedStringForKey:(key) value:@"" table:nil]
/* You cannot take the address of a return value like that, only a variable. Thus, you’d have to put the result in a temporary variable:
 The way to get around this problem is use another GCC extension allowing statements in expressions. Thus, the macro creates a temporary variable, _Y_, with the same type of _X_ (again using typeof) and passes the address of this temporary to the function.
 http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
 */

#define ASOCK GCDAsyncSocket

//1 #define LOG_EXPR(_X_) do{\
//2  __typeof__(_X_) _Y_ = (_X_);\
//3  const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
//4  NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
//5  if(_STR_)\
//6   NSLog(@"%s = %@", #_X_, _STR_);\
//7  else\
//8   NSLog(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
//9 }while(0)

//NSString * AZToStringFromTypeAndValue(const char * typeCode, void * value);
#define AZString(_X_) ( { __typeof__(_X_) _Y_ = (_X_); AZToStringFromTypeAndValue(@encode(__typeof__(_X_)), &_Y_);})

#define dothisXtimes(_ct_,_action_)  for(int X = 0; X < _ct_; X++) ({ _action_ }) 

// NSLog(@"%@", StringFromBOOL(ISATYPE ( ( @"Hello", NSString)));   // DOESNT WORK
// NSLog(@"%@", StringFromBOOL(ISATYPE ( ( (NSR){0,1,1,2} ), NSRect)));   // YES
// NSLog(@"%@", StringFromBOOL(ISATYPE ( ( (NSR){0,1,1,2} ), NSRange)));  // NO
#define  ISATYPE(_a_,_b_)  SameChar( @encode(typeof(_a_)), @encode(_b_) )

// NSRect rect = (NSR){0,0,1,1};    
//  NSRange rng = NSMakeRange(0, 11); 
//   CGR cgr = CGRectMake (0,1,2,4);   
//    NSS *str = @"d";
// SAMETYPE(cgr, rect);  YES  SAMETYPE(cgr,  rng);  NO  SAMETYPE(rect, str);  NO  SAMETYPE(str, str);   YES

#define  SAMETYPE(_a_,_b_)  SameChar( @encode(typeof(_a_)), @encode(typeof(_b_)) )

#pragma mark - MACROS

//#define loMismo isEqualToString

#define AZTEMPD      NSTemporaryDirectory()
#define AZTEMPFILE(EXT)  [AtoZ tempFilePathWithExtension:$(@"%s",#EXT)]

#define CLSSBNDL     [NSBundle bundleForClass:[self class]]
#define AZBUNDLE     [NSBundle bundleForClass:[AtoZ class]]
#define APP_NAME      [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"]
#define APP_VERSION     [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"]
#define OPEN_URL(urlString)  [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:urlString]]

#define AZUSERNOTC NSUserNotificationCenter
#define AZUNOTC [AZUSERNOTC defaultUserNotificationCenter]

#define kPfVAVfK keyPathsForValuesAffectingValueForKey
#define wCVfK willChangeValueForKey
#define dCVfK didChangeValueForKey

#define dVfK defaultValueForKey
//#define NSET NSSet*

/* Retrieving preference values */

#define PREF_KEY_VALUE(x)    [[NSUserDefaultsController.sharedUserDefaultsController values] valueForKey:(x)]
#define PREF_KEY_BOOL(x)    [(PREF_KEY_VALUE(x)) boolValue]
#define PREF_SET_KEY_VALUE(x, y) [[NSUserDefaultsController.sharedUserDefaultsController values] setValue:(y) forKey:(x)]
#define PREF_OBSERVE_VALUE(x, y) [NSUserDefaultsController.sharedUserDefaultsController addObserver:y forKeyPath:x\                       options:NSKeyValueObservingOptionOld context:nil]

/* key, observer, object */
#define OB_OBSERVE_VALUE(x, y, z)  [(z) addObserver:y forKeyPath:x options:NSKeyValueObservingOptionOld context:nil];

#define AZLocalizedString(key) NSLocalizedStringFromTableInBundle(key,nil,AZBUNDLE,nil)

//#define AZLocalizedString(key, comment) NSLocalizedStringFromTableInBundle((key)nil, [NSBundle bundleWithIdentifier:AZBUNDLE,(comment))

//Usage:
//AZLocalizedString(@"ZeebaGreeting", @"Huluu zeeba")
//+ (NSString*)typeStringForType:(IngredientType)_type {
// NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type];
// return NSLocalizedString(key, nil);
//}

//typedef ((NSTask*)(^launchMonitorReturnTask) NSTask* task);
//typedef (^TaskBlock);
//#define AZLAUNCHMONITORRETURNTASK(A) ((NSTask*)(^launchMonitorReturnTask)(A))
// ^{ [A launch]; monitorTask(A); return A; }()

#define NSWIND NSWindowDelegate 
#define NSAPPD NSApplicationDelegate

//#define $concat(A,...) { A = [A arrayByAddingObjectsFromArray:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])]; }
// s stringByReplacingOccurrencesOfString:@"fff " withString:@"%%%%"] )
//#define AZLOG(log,...) NSLog(@"%@", [log s stringByReplacingOccurrencesOfString:@"fff " withString:@"%%%%"] )

/** get a VARIABLE's name, NOT value. 
 NEW(NSMA,alex);
*/

#define VARNAME(x) $(@"%s",#x)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//#ifndef metamacro_take
#define RNG AZRange
//#endif

#pragma mark - PREVIOUSLY IN UMBRELLA

//#import <RoutingHTTPServer/RoutingHTTPServer.h>
//#import "AtoZCategories.h"

#define CGRect NSRect 
#define CGPoint NSPoint 
#define CGSize NSSize

#define DEFAULTINIT(methodName) \
- (id) init                       { return self = super.init ? [self methodName], self : nil; }\
- (id) initWithFrame:(NSR)f       { return self = [super initWithFrame:f] ? [self methodName], self : nil; }\
- (id) initWithCoder:(NSCoder*)d  { return self = [super initWithCoder:d] ? [self methodName], self : nil; }

#pragma mark - General Functions

//#define NSDICT (...) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
//#define NSARRAY(...) [NSArray arrayWithObjects: __VA_ARGS__, nil]

#define NSCRGBA(red,green,blue,alpha) [NSC r:red g:green b:blue a:alpha]
#define NSDEVICECOLOR(r,g,b,a) [NSColor colorWithDeviceRed:r green:g blue:b alpha:a]
#define NSCOLORHSB(h,s,b,a) [NSColor colorWithDeviceHue:h saturation:s brightness:b alpha:a]
#define NSCW(_grey_,_alpha_)  [NSColor colorWithCalibratedWhite:_grey_ alpha:_alpha_]

//^NSC*(grey,alpa){ return (NSC*)[NSColor colorWithCalibratedWhite:grey alpha:alpha]; }

#pragma mark - FUNCTION defines

//		\
//	BOOL YESORNO = strcmp(getenv(XCODE_COLORS), "YES") == 0;					\
//	va_list vl;																				\
//	va_start(vl, fmt);																	\
//	NSS* str = [NSString.alloc initWithFormat:(NSS*)fmt arguments:vl];	\
//	va_end(vl);																				\
//	YESORNO 	? 	NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" @"%@" XCODE_COLORS_RESET, __PRETTY_FUNCTION__, __LINE__, str) \
//				: 	NSLog(@"%@",str); \
//}()

//strcmp(getenv(XCODE_COLORS), "YES") == 0 \
//		? NSLog(	(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" fmt XCODE_COLORS_RESET)\
//		, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) \
//			: NSLog(fmt,__VA_ARGS__)

//_AZColorLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

/**	const

 extern NSString * const MyConstant;

 You'll see this in header files. It tells the compiler that the variable MyConstant exists and can be used in your implementation files.	More likely than not, the variable is set something like:

 NSString * const MyConstant = @"foo";
 The value can't be changed. If you want a global that can be changed, then drop the const from the declaration.
 The position of the const keyword relative to the type identifier doesn't matter
 const NSString *MyConstant = @"foo";  ===  NSString const *MyConstant = @"foo";
 You can also legally declare both the pointer and the referenced value const, for maximum constness:
 const NSString * const MyConstant = @"foo";
 extern

 Allows you to declare a variable in one compilation unit, and let the compiler know that you've defined that variable in a separate compilation unit. You would generally use this only for global values and constants.

 A compilation unit is a single .m file, as well as all the .h files it includes. At build time the compiler compiles each .m file into a separate .o file, and then the linker hooks them all together into a single binary. Usually the way one compilation unit knows about identifiers (such as a class name) declared in another compilation unit is by importing a header file. But, in the case of globals, they are often not part of a class's public interface, so they're frequently declared and defined in a .m file.

 If compilation unit A declares a global in a .m file:

 #import "A.h"
 NSString *someGlobalValue;

 and compilation unit B wants to use that global:

 #import "B.h"
 extern NSString *someGlobalValue;

 @implementation B
 - (void)someFunc {
 NSString *localValue = [self getSomeValue];
 [localValue isEqualToString:someGlobalValue] ? ^{ ... }() : ^{ ... }();
 }

 unit B has to somehow tell the compiler to use the variable declared by unit A. It can't import the .m file where the declaration occurs, so it uses extern to tell the compiler that the variable exists elsewhere.
 Note that if unit A and unit B both have this line at the top level of the file:

 NSString *someGlobalValue;

 then you have two compilation units declaring the same global variable, and the linker will fail with a duplicate symbol error. If you want to have a variable like this that exists only inside a compilation unit, and is invisible to any other compilation units (even if they use extern), you can use the static keyword:

 static NSString * const someFileLevelConstant = @"wibble";

 This can be useful for constants that you want to use within a single implementation file, but won't need elsewhere
 **/

#define nAZColorWellChanged @"AtoZColorWellChangedColors"

#define AZBONK @throw [NSException exceptionWithName:@"WriteThisMethod" reason:@"You did not write this method, yet!" userInfo:nil]

#define GENERATE_SINGLETON(SC) static SC * SC##_sharedInstance = nil;\
+(SC *)sharedInstance { if (! SC##_sharedInstance) { SC##_sharedInstance = SC.new; } \
return SC##_sharedInstance; }

//#define foreach(B,A) A.andExecuteEnumeratorBlock = \
//^(B, NSUInteger A##Index, BOOL *A##StopBlock)

//#define foreach(A,B,C) \
//A.andExecuteEnumeratorBlock =  ^(B, NSUInteger C, BOOL *A##StopBlock)

static inline void _AZUnimplementedMethod(SEL selector,id object,const char *file,int line) {
   NSLogC(@"-[%@ %s] unimplemented in %s at %d",[object class],sel_getName(selector),file,line);
}

static inline void _AZUnimplementedFunction(const char *function,const char *file,int line) {
   NSLogC(@"%s() unimplemented in %s at %d",function,file,line);
}

#define AZUnimplementedMethod() \
_AZUnimplementedMethod(_cmd,self,__FILE__,__LINE__)

#define AZUnimplementedFunction() \
_AZUnimplementedFunction(__PRETTY_FUNCTION__,__FILE__,__LINE__)

/* instance variable    NSMutableArray *thingies;  in @implementation  ARRAY_ACCESSORS(thingies,Thingies) */

#define ARRAY_ACCESSORS(lowername, capsname) \
	- (NSUInteger)countOf ## capsname { return [lowername count]; } \
	- (id)objectIn ## capsname ## AtIndex: (NSUInteger)index { return [lowername objectAtIndex: index]; } \
	- (void)insertObject: (id)obj in ## capsname ## AtIndex: (NSUInteger)index { [lowername insertObject: obj atIndex: index]; } \
	- (void)removeObjectFrom ## capsname ## AtIndex: (NSUInteger)index { [lowername removeObjectAtIndex: index]; }

#ifdef XCODECODEFORPASTING

- (NSUInteger) countOf<#Collection#> { return [<#collectuion#> count]; }
- objectIn<#Collection#>AtIndex:(NSUInteger)idx { return [<#collectuion#> objectAtIndex:idx]; }
- (void) insertObject:(id)o in<#Collection#>AtIndex:(NSUInteger)idx { [<#collectuion#> insertObject:o atIndex:idx]; }
- (void) removeObjectFrom<#Collection#>AtIndex:(NSUInteger)idx { [<#collectuion#> removeObjectAtIndex:idx]; }

#endif

//#define objc_dynamic_cast(obj,cls) ([obj isKindOfClass:(Class)objc_getClass(#cls)] ? (cls *)obj : NULL)

#define NEW(A,B) A *B = A.new

//#define NEWVALUE(_NAME_,_VAL_) \
//	objc_getClass([_VAL_ class])
//	whatever *s = @"aa;";
//	NSLog(@"%@", s.class);
//}
//NS_INLINE void AZNewItems (Class aClass,...) {		objc_getClass}

#define NEWS(A,...) AZNewItems(A,...)

#pragma mark - END PREVIOUSLY IN UMBRELLA

#endif /* END if !TARGET_OS_IPHONE */

// 	KSVarArgs is a set of macros designed to make dealing with variable arguments	easier in Objective-C.\
    All macros assume that the varargs list contains only objective-c objects or \
    object-like structures (assignable to type id). \
    The base macro ksva_iterate_list() iterates over the variable arguments, \
    invoking a block for each argument, until it encounters a terminating nil. \
    The other macros are for convenience when converting to common collections.

/*! Block type used by ksva_iterate_list.\
    @param entry The current argument in the vararg list. */

typedef void (^AZVA_Block)(id entry);
typedef void (^AZVA_ArrayBlock)(NSArray* values);

#define AZVA_ARRAYB void (^)(NSArray* values)
#define AZVA_IDB void (^AZVA_Block)(id entry)

/**	Iterate over a va_list, executing the specified code block for each entry.
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param BLOCK A code block of type KSVA_Block.	 */
#define azva_iterate_list(FIRST_ARG_NAME, BLOCK) { \
	AZVA_Block azva_block = BLOCK;	va_list azva_args	;	va_start(azva_args,FIRST_ARG_NAME );							 \
	for( id azva_arg = FIRST_ARG_NAME;	azva_arg != nil;  azva_arg = va_arg(azva_args, id ) )	azva_block(azva_arg); \
	va_end(azva_args); }

#define AZVA_ARRAY(FIRST_ARG_NAME,ARRAY_NAME) azva_list_to_nsarray(FIRST_ARG_NAME,ARRAY_NAME)

/***	Convert a variable argument list into array. An autorel. NSMA will be created in current scope w/ the specified name.
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param ARRAY_NAME The name of the array to create in the current scope.	 */
#define azva_list_to_nsarray(FIRST_ARG_NAME, ARRAY_NAME) \
	NSMA* ARRAY_NAME = NSMA.new;  azva_iterate_list(FIRST_ARG_NAME, ^(id entry) { [ARRAY_NAME addObject:entry]; })

#define azva_list_to_nsarrayBLOCKSAFE(FIRST_ARG_NAME, ARRAY_NAME) \
	NSMA* ARRAY_NAME = NSMA.new;  azva_iterate_list(FIRST_ARG_NAME, ^(id entry) { __block __typeof__(entry) _x_ = entry; [ARRAY_NAME addObject:_x_]; })

/*** 	Convert a variable argument list into a dictionary, interpreting the vararg list as object, key, object, key, ...
 An autoreleased NSMutableDictionary will be created in the current scope with the specified name.
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param DICT_NAME The name of the dictionary to create in the current scope.		*/
#define azva_list_to_nsdictionary(FIRST_ARG_NAME, DICT_NAME) \
	NSMD* DICT_NAME = NSMD.new; 	{						 														\
		__block id azva_object = nil; 					 														\
		azva_iterate_list(FIRST_ARG_NAME, ^(id entry) { 													\
			if(azva_object == nil)  azva_object = entry; 													\
			else {	[DICT_NAME setObject:azva_object forKey:entry]; azva_object = nil;  } 	}); }

/*** 	Same as above... but KEY is first!
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param DICT_NAME The name of the dictionary to create in the current scope.		*/
#define azva_list_to_nsdictionaryKeyFirst(FIRST_KEY, DICT_NAME) \
	NSMD* DICT_NAME = NSMD.new; 	{						 														\
		__block id azva_object = nil; 					 														\
		azva_iterate_list(FIRST_KEY, ^(id entry) { 															\
			if(azva_object == nil)  azva_object = entry; 													\
			else {	[DICT_NAME setObject:entry forKey:azva_object]; azva_object = nil;  } 	}); }

#endif /* END AtoZ_AtoZMacroDefines_h */

