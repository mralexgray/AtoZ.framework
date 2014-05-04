
//#import "extobjc_OSX/extobjc.h"
//@import Cocoa; 
//@import QuartzCore;
//@import WebKit;
#import <WebKit/WebKit.h>
#import <Zangetsu/Zangetsu.h>
//#import <RoutingHTTPServer/RoutingHTTPServer.h>
#import <KVOMap/KVOMap.h>
#import <AtoZAutoBox/AtoZAutoBox.h>
#import <AtoZ/F.h>
#import <AtoZ/BaseModel.h>
#import <AtoZ/JREnum.h>
#import "AtoZMacroDefines.h"
#import "AtoZTypes.h"
#import "BoundingObject.h"
#import "AtoZGeometry.h"
//#import "AtoZCategories.h"


#define CGRect NSRect 
#define CGPoint NSPoint 
#define CGSize NSSize

#define DEFAULTINIT(methodName) \
- (id) init                       { return self = super.init ? [self methodName], self : nil; }\
- (id) initWithFrame:(NSR)f       { return self = [super initWithFrame:f] ? [self methodName], self : nil; }\
- (id) initWithCoder:(NSCoder*)d  { return self = [super initWithCoder:d] ? [self methodName], self : nil; }


//@protocol AtoZNodeProtocol;
//#define AZNODEPRO (NSObject<AtoZNodeProtocol>*)


//#define 	AZLAYOUTMGR 		[CAConstraintLayoutManager layoutManager]
//#define  AZTALK	 (log) 	[AZTalker.new say:log]
//#define  AZBezPath (r) 		[NSBezierPath bezierPathWithRect: r]
//#define  NSBezPath (r) 		AZBezPath(r)
//#define  AZQtzPath (r) 		[(AZBezPath(r)) quartzPath]

//#define AZContentBounds [[[ self window ] contentView] bounds]


#pragma mark - General Functions

//#define SDDefaults [NSUserDefaults standardUserDefaults]
//
//#if defined(DEBUG)
//	#define SDLog(format, ...) NSLog(format, ##__VA_ARGS__)
//#else
//	#define SDLog(format, ...)
//#endif
//
//#define NSSTRINGF(x, args...) [NSString stringWithFormat:x , ## args]
//#define NSINT(x) [NSNumber numberWithInt:x]
//#define NSFLOAT(x) [NSNumber numberWithFloat:x]
//#define NSDOUBLE(x) [NSNumber numberWithDouble:x]
//#define NSBOOL(x) [NSNumber numberWithBool:x]
//
//#define SDInfoPlistValueForKey(key) [[NSBundle mainBundle] objectForInfoDictionaryKey:key]

//#define NSDICT (...) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
//#define NSARRAY(...) [NSArray arrayWithObjects: __VA_ARGS__, nil]
#define NSBOOL(X) [NSNumber numberWithBool:X]
//#define NSSET  (...) [NSSet setWithObjects: __VA_ARGS__, nil]

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

#define AZBONK @throw \
[NSException \
exceptionWithName:@"WriteThisMethod" \
reason:@"You did not write this method, yet!" \
userInfo:nil]

#define GENERATE_SINGLETON(SC) \
static SC * SC##_sharedInstance = nil; \
+(SC *)sharedInstance { \
if (! SC##_sharedInstance) { \
SC##_sharedInstance = SC.new; \
} \
return SC##_sharedInstance; \
}


//#define foreach(B,A) A.andExecuteEnumeratorBlock = \
//^(B, NSUInteger A##Index, BOOL *A##StopBlock)

//#define foreach(A,B,C) \
//A.andExecuteEnumeratorBlock = \
//  ^(B, NSUInteger C, BOOL *A##StopBlock)


/* 	KSVarArgs is a set of macros designed to make dealing with variable arguments	easier in Objective-C. All macros assume that the varargs list contains only objective-c objects or object-like structures (assignable to type id). The base macro ksva_iterate_list() iterates over the variable arguments, invoking a block for each argument, until it encounters a terminating nil. The other macros are for convenience when converting to common collections.
*/
/** 	Block type used by ksva_iterate_list.
 @param entry The current argument in the vararg list.	*/

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


static inline void _AZUnimplementedMethod(SEL selector,id object,const char *file,int line) {
   NSLog(@"-[%@ %s] unimplemented in %s at %d",[object class],sel_getName(selector),file,line);
}

static inline void _AZUnimplementedFunction(const char *function,const char *file,int line) {
   NSLog(@"%s() unimplemented in %s at %d",function,file,line);
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

//#define objc_dynamic_cast(obj,cls) \
//    ([obj isKindOfClass:(Class)objc_getClass(#cls)] ? (cls *)obj : NULL)

#define NEW(A,B) A *B = A.new

//#define NEWVALUE(_NAME_,_VAL_) \
//	objc_getClass([_VAL_ class])
//	whatever *s = @"aa;";
//	NSLog(@"%@", s.class);
//}


//NS_INLINE void AZNewItems (Class aClass,...) {
//
//		objc_getClass
//}

#define NEWS(A,...) AZNewItems(A,...)


// 64-bit float macros

//#ifdef __LP64__
//	#define _CGFloatFabs( n )	fabs( n )
//	#define _CGFloatTrunc( n )	trunc( n )
//	#define _CGFloatLround( n )	roundtol( n )
//	#define _CGFloatFloor( n )	floor( n )
//	#define _CGFloatCeil( n )	ceil( n )
//	#define _CGFloatExp( n )	exp( n )
//	#define _CGFloatSqrt( n )	sqrt( n )
//	#define _CGFloatLog( n )	log( n )
//#else
//	#define _CGFloatFabs( n )	fabsf( n )
//	#define _CGFloatTrunc( n )	truncf( n )
//	#define _CGFloatLround( n )	roundtol((double) n )
//	#define _CGFloatFloor( n )	floorf( n )
//	#define _CGFloatCeil( n )	ceilf( n )
//	#define _CGFloatExp( n )	expf( n )
//	#define _CGFloatSqrt( n )	sqrtf( n )
//	#define _CGFloatLog( n )	logf( n )
//#endif


/*
#define 				 IDDRAG 	id<NSDraggingInfo>
#define 					NSPB 	NSPasteboard

#define 				AZIDCAA 	(id<CAAction>)
#define 				  IDCAA		(id<CAAction>)
#define 					IDCP 	id<NSCopying>
#define 				  	 IBO 	IBOutlet
#define 					 IBA 	IBAction
#define 				  RONLY 	readonly
#define 				  RDWRT	readwrite
#define 				  ASSGN 	assign
#define 				  NATOM 	nonatomic
#define 				  STRNG 	strong
#define 				    STR 	strong

#define 					 ASS 	assign
#define 					  CP 	copy
#define 					 CPY 	copy

#define 					 SET 	setter
#define 					 GET 	getter
#define	 				  WK 	weak
#define 					UNSF 	unsafe_unretained

#define					prop 	property
#define 					 IBO 	IBOutlet
#pragma mark 														- CoreGraphics / CoreFoundation
#define 				  CFTI	CFTimeInterval
#define 				  CGCR	CGColorRef
#define 					CGF 	CGFloat
#define 				   CGP	CGPoint
#define 				  CGPR 	CGPathRef
#define	 				CGR 	CGRect
#define 					CGS 	CGSize
#define 				  CGSZ 	CGSize
#define 					CIF 	CIFilter
#define 				 CGRGB 	CGColorCreateGenericRGB
#define 				CGCREF 	CGContextRef
#define 				JSCREF 	JSContextRef
#define 				  CGWL 	CGWindowLevel

#define 			CGPATH(A)	CGPathCreateWithRect(R)

#define 			AZRUNLOOP	NSRunLoop.currentRunLoop
#define 	   AZRUNFOREVER 	[AZRUNLOOP runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture]
#define 	AZRUN while(0)	[NSRunLoop.currentRunLoop run]
#define 					NSA 	NSArray
#define 			 NSACLASS 	NSArray.class
#define 	    NSAorDCLASS 	@[NSArray.class, NSDictionary.class]
#define 			  ISADICT 	isKindOfClass:NSDictionary.class
#define 			ISANARRAY	isKindOfClass:NSArray.class
#define 	 ISADICTorARRAY	isKindOfAnyClass:NSAorDCLASS
#define 			 NSSCLASS 	NSString.class
#define				 NSAPP 	NSApplication
#define				  NSAC 	NSArrayController
#define				  NSAS 	NSAttributedString
#define				  NSAT 	NSAffineTransform
#define			    	NSB 	NSBundle
#define				NSBUTT 	NSButton
#define				  NSBP 	NSBezierPath
#define			  NSBRWSR 	NSBrowser
#define				 NSBIR 	NSBitmapImageRep
#define				 NSBLO 	NSBlockOperation
#define				 NSBSB	NSBackingStoreBuffered

#define				 NSBWM 	NSBorderlessWindowMask
#define			  NSCOMPR 	NSComparisonResult
#define				  NSDE 	NSDirectoryEnumerator
#define				  NSGC 	NSGraphicsContext
#define				   NSC 	NSColor
#define			     NSCL 	NSColorList
#define				  NSCS 	NSCountedSet
#define				   NSD 	NSDictionary
#define			 NSDCLASS 	NSDictionary.class
#define			   	NSE 	NSEvent
#define			     NSEM	NSEventMask
#define				 NSERR 	NSError
#define			    	NSF 	NSFont
#define 				  NSFH	NSFileHandle
#define			    	NSG	NSGradient
#define				  NSJS	NSJSONSerialization
#define				   NSI 	NSInteger
#define				  NSIP 	NSIndexPath
#define				 NSIMG 	NSImage
#define				  NSIS 	NSIndexSet
#define				  NSIV 	NSImageView

#define					SIG	NSMethodSignature
#define				  NSMA 	NSMutableArray
#define				 NSMAS 	NSMutableAttributedString
#define				  NSMD 	NSMutableDictionary
#define			  NSMDATA 	NSMutableData
#define				   NSM 	NSMenu
#define				  NSMI 	NSMenuItem
#define			  NSMenuI	NSMenuItem
#define				  NSMS 	NSMutableString
#define				NSMSet 	NSMutableSet
#define				 NSMIS 	NSMutableIndexSet
#define				 NSMPS 	NSMutableParagraphStyle
#define				   NSN 	NSNumber
#define				 NSNOT 	NSNotification
#define				   NSO 	NSObject
//#define ID \(NSObject*\)
#define				  NSOQ 	NSOperationQueue
#define				  NSOP 	NSOperation
#define 			 NSPUBUTT   NSPopUpButton
#define 			 	  NSPO   NSPopover

#define				 NSCSV 	NSCellStateValue
#define			  AZOQMAX 	NSOperationQueueDefaultMaxConcurrentOperationCount
#define			  	  NSOV 	NSOutlineView

#define					NSP 	NSPoint
#define			NSPInRect 	NSPointInRect
#define			     NSPI 	NSProgressIndicator
#define			 NSPUBUTT 	NSPopUpButton
#define					NSR 	NSRect
#define				  NSRE 	NSRectEdge
#define				 NSRNG 	NSRange
#define			  NSRFill 	NSRectFill
#define					NSS 	NSString
#define				  NSSI 	NSStatusItem
#define				NSSHDW 	NSShadow
#define				  NSSZ 	NSSize
#define				  NSST 	NSSet
#define					NST 	NSTimer
#define				 NSTSK 	NSTask
#define 			   NSSEGC	NSSegmentedControl
#define			  NSSCRLV 	NSScrollView
#define			  NSSPLTV	NSSplitView
#define			     NSTA 	NSTrackingArea
#define			 	  NSTI 	NSTimeInterval
#define				  NSTV 	NSTableView
#define				  NSTC 	NSTableColumn
#define				NSTXTF 	NSTextField
#define				NSTXTV 	NSTextView
#define				  NSUI 	NSUInteger
#define				NSURLC 	NSURLConnection
#define		   NSMURLREQ	NSMutableURLRequest
#define			 NSURLREQ 	NSURLRequest
#define			 NSURLRES 	NSURLResponse
#define			   	NSV 	NSView
#define				  NSVC 	NSViewController
#define				  NSWC 	NSWindowController
#define				 NSVAL 	NSValue
#define				  NSVT 	NSValueTransformer
#define				NSTABV 	NSTabView

#define 				 NSPSC 	NSPersistentStoreCoordinator
#define 				  NSED 	NSEntityDescription
#define 				  NSMO	NSManagedObject
#define 				 NSMOM	NSManagedObjectModel
#define 			    NSMOC	NSManagedObjectContext

#define				NSTVDO	NSTableViewDropOperation
#define 				  NSDO	NSDragOperation

#define				NSTBAR 	NSToolbar
#define				   NSW 	NSWindow

#define				TUINSV 	TUINSView
#define				TUINSW 	TUINSWindow
#define				  TUIV 	TUIView
#define				 TUIVC	TUIViewController
#define				  VBLK 	VoidBlock
#define					 WV	WebView
#define				IDWPDL	id<WebPolicyDecisionListener>
#define 				  AHLO 	AHLayoutObject
#define 				  AHLT 	AHLayoutTransaction
#define  		  BLKVIEW 	BNRBlockView
#define  		     BLKV 	BLKVIEW

#pragma mark -  CoreAnimation
#import <QuartzCore/QuartzCore.h>

typedef struct {	CAConstraintAttribute constraint;	CGFloat scale;	CGFloat offset;	}	AZCAConstraint;

#pragma mark - AZSHORTCUTS

#define 			AZCACMinX	AZConstRelSuper ( kCAConstraintMinX   )
#define 			AZCACMinY	AZConstRelSuper ( kCAConstraintMinY   )
#define 			AZCACMaxX	AZConstRelSuper ( kCAConstraintMaxX   )
#define 			AZCACMaxY	AZConstRelSuper ( kCAConstraintMaxY   )
#define 			AZCACWide 	AZConstRelSuper ( kCAConstraintWidth  )
#define 			AZCACHigh 	AZConstRelSuper ( kCAConstraintHeight )

#define 		 			CAA 	CAAnimation
#define     		  CAAG	CAAnimationGroup
#define 	   		  CABA	CABasicAnimation
#define 		 CACONSTATTR   CAConstraintAttribute
#define			  CACONST	CAConstraint
#define     		  CAGA	CAGroupAnimation
#define     		  CAGL	CAGradientLayer
#define     		  CAKA	CAKeyframeAnimation
#define      			CAL	CALayer
#define    			 CALNA 	CALayerNonAnimating
#define    			 CALNH 	CALayerNoHit
#define    			 CAMTF	CAMediaTimingFunction
#define   			CASLNH 	CAShapeLayerNoHit
#define    			 CASHL 	CAShapeLayer
#define  		  CASCRLL 	CAScrollLayer
#define 				 CASHL 	CAShapeLayer
#define     		  CASL 	CAShapeLayer
#define   			CATLNH 	CATextLayerNoHit
#define      			CAT 	CATransaction
#define     		  CAT3 	CATransform3D
#define            CAT3D 	CATransform3D
#define   		   CAT3DR 	CATransform3DRotate
#define  		  CAT3DTR 	CATransform3DTranslate
#define     		  CATL 	CATransformLayer
#define   			CATXTL 	CATextLayer

#define 			 CATRANNY	CATransaction
#define 			 CATRANST 	CATransition
#define 				  ID3D 	CATransform3DIdentity
#define 		   CATIMENOW 	CACurrentMediaTime()

#define AZNOCACHE NSURLRequestReloadIgnoringLocalCacheData

#define 				  lMGR 	layoutManager
#define				   bgC	backgroundColor
#define 					fgC 	foregroundColor
#define 				arMASK 	autoresizingMask
#define 					mTB 	masksToBounds
#define 			  cRadius 	cornerRadius
#define 				aPoint 	anchorPoint
#define 				 NDOBC 	needsDisplayOnBoundsChange
#define 				 nDoBC 	needsDisplayOnBoundsChange
#define 		  CASIZEABLE 	kCALayerWidthSizable | kCALayerHeightSizable
#define 					loM 	layoutManager
#define 				 sblrs 	sublayers
#define 				  zPos 	zPosition
#define			  constWa   constraintWithAttribute
#define 		  removedOnC 	removedOnCompletion

#define 				  kIMG 	@"image"
#define 				  kCLR 	@"color"
#define 				  kIDX 	@"index"
#define 				  kLAY 	@"layer"
#define 				  kPOS 	@"position"
#define 			 kPSTRING 	@"pString"
#define 			     kSTR 	@"string"
#define 				  kFRM 	@"frame"
#define 				 kHIDE	@"hide"
#define AZSuperLayerSuper (@"superlayer")

#define 		CATransform3DPerspective	( t, x, y ) (CATransform3DConcat(t, CATransform3DMake(1,0,0,x,0,1,0,y,0,0,1,0,0,0,0,1)))
#define CATransform3DMakePerspective  	(  x, y ) (CATransform3DPerspective( CATransform3DIdentity, x, y ))
// exception safe save/restore of the current graphics context
#define 			SAVE_GRAPHICS_CONTEXT	@try { [NSGraphicsContext saveGraphicsState];
#define 		RESTORE_GRAPHICS_CONTEXT	} @finally { [NSGraphicsContext restoreGraphicsState]; }


//#define CACcWA CAConstraint constraintWithAttribute
#define AZConst(attrb,rel)		[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb]
#define AZConst(attrb,rel)				[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb]
#define AZConstScaleOff(attrb,rel,scl,off)	[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb scale:scl offset:off]
#define AZConstRelSuper(attrb)		[CAConstraint constraintWithAttribute:attrb relativeTo:AZSuperLayerSuper attribute:attrb]
#define AZConstRelSuperScaleOff (att,scl,off) [CAConstraint constraintWithAttribute:att relativeTo:AZSuperLayerSuper attribute:att scale:scl offset:off]
#define AZConstAttrRelNameAttrScaleOff ( attr1, relName, attr2, scl, off) [CAConstraint constraintWithAttribute:attr1 relativeTo:relName attribute:attr2 scale:scl offset:off]
*/



#import "AtoZGeometry.h"
#import "BoundingObject.h"

