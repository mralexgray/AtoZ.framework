
//  #import <Security/Security.h>
//  #import <QuartzCore/QuartzCore.h>
//  #import <WebKit/WebKit.h>
//  #import <objc/runtime.h>
//  #import <objc/message.h>
//  #import <AppKit/AppKit.h>
//  #import <Foundation/NSObjCRuntime.h>

//  #import <AtoZAutoBox/AtoZAutoBox.h>

//  #import <AtoZAppKit/AtoZAppKit.h>
//  #import <AtoZBezierPath/AtoZBezierPath.h>
//  #import <BWTK/BWToolkitFramework.h>
//  #import <BlocksKit/A2DynamicDelegate.h>
//  #import <CFAAction/CFAAction.h>
//  #import <CocoatechCore/CocoatechCore.h>
//  #import <DrawKit/DKDrawKit.h>
//  #import <KSHTMLWriter/KSHTMLWriter.h>
//  #import <MenuApp/MenuApp.h>
//  #import <NMSSH/NMSSH.h>
//  #import <PhFacebook/PhFacebook.h>
//  #import <Rebel/Rebel.h>


//#import <RoutingHTTPServer/RoutingHTTPServer.h>


// 64-bit float macros
/*
#ifdef __LP64__
	#define _CGFloatFabs( n )	fabs( n )
	#define _CGFloatTrunc( n )	trunc( n )
	#define _CGFloatLround( n )	roundtol( n )
	#define _CGFloatFloor( n )	floor( n )
	#define _CGFloatCeil( n )	ceil( n )
	#define _CGFloatExp( n )	exp( n )
	#define _CGFloatSqrt( n )	sqrt( n )
	#define _CGFloatLog( n )	log( n )
#else
	#define _CGFloatFabs( n )	fabsf( n )
	#define _CGFloatTrunc( n )	truncf( n )
	#define _CGFloatLround( n )	roundtol((double) n )
	#define _CGFloatFloor( n )	floorf( n )
	#define _CGFloatCeil( n )	ceilf( n )
	#define _CGFloatExp( n )	expf( n )
	#define _CGFloatSqrt( n )	sqrtf( n )
	#define _CGFloatLog( n )	logf( n )
#endif
*/

/*!

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
/ / exception safe save/restore of the current graphics context
#define 			SAVE_GRAPHICS_CONTEXT	@try { [NSGraphicsContext saveGraphicsState];
#define 		RESTORE_GRAPHICS_CONTEXT	} @finally { [NSGraphicsContext restoreGraphicsState]; }


/ / #define CACcWA CAConstraint constraintWithAttribute
#define AZConst(attrb,rel)		[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb]
#define AZConst(attrb,rel)				[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb]
#define AZConstScaleOff(attrb,rel,scl,off)	[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb scale:scl offset:off]
#define AZConstRelSuper(attrb)		[CAConstraint constraintWithAttribute:attrb relativeTo:AZSuperLayerSuper attribute:attrb]
#define AZConstRelSuperScaleOff (att,scl,off) [CAConstraint constraintWithAttribute:att relativeTo:AZSuperLayerSuper attribute:att scale:scl offset:off]
#define AZConstAttrRelNameAttrScaleOff ( attr1, relName, attr2, scl, off) [CAConstraint constraintWithAttribute:attr1 relativeTo:relName attribute:attr2 scale:scl offset:off]

 */

 //@protocol AtoZNodeProtocol;
//#define AZNODEPRO (NSObject<AtoZNodeProtocol>*)


//#define 	AZLAYOUTMGR 		[CAConstraintLayoutManager layoutManager]
//#define  AZTALK	 (log) 	[AZTalker.new say:log]
//#define  AZBezPath (r) 		[NSBezierPath bezierPathWithRect: r]
//#define  NSBezPath (r) 		AZBezPath(r)
//#define  AZQtzPath (r) 		[(AZBezPath(r)) quartzPath]

//#define AZContentBounds [[[ self window ] contentView] bounds]

//#import "extobjc_OSX/extobjc.h"
//@import Cocoa; 
//@import QuartzCore;
//@import WebKit;
//#import <WebKit/WebKit.h>
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


// NSVALUE defined, see NSValue+AtoZ.h
//#define AZWindowPositionTypeArray @[@"Left",@"Bottom",@"Right",@"Top",@"TopLeft",@"BottomLeft",@"TopRight",@"BottomRight",@"Automatic"]
//#endif

//JREnumDeclare(AZQuad, AZQuadTopLeft, AZQuadTopRight, AZQuadBotRight, AZQuadBotLeft);
//#define QUAD AZQuad


//JREnum() is fine for when you have an enum that lives solely in an .m file. But if you're exposing an enum in a header file, you'll have to use the alternate macros. In your .h, use JREnumDeclare():
//	JREnumDeclare(StreamState,	   Stream_Disconnected,   	Stream_Connecting,                                                    										Stream_Connected, 		Stream_Disconnecting);
//And then use JREnumDefine() in your .m:
//	JREnumDefine(StreamState); for Free!!
// NSString* AZQuadrantToString(int value);

//JREnumDeclare( AZQuadrant, AZTopLeftQuad = 0, AZTopRightQuad, AZBotRightQuad, AZBotLeftQuad);

//typedef NS_ENUM(NSUInteger, AZQuadrant){
//	AZTopLeftQuad = 0,
//	AZTopRightQuad,
//	AZBotRightQuad,
//	AZBotLeftQuad
//};


/*
 //#ifndef ATOZTOUCH
 typedef NS_OPTIONS(NSUInteger, AZWindowPosition) {
 AZLft 			= NSMinXEdge, // 0  NSDrawer
 AZRgt			= NSMaxXEdge, // 2  preferredEdge
 AZTop		   	= NSMaxYEdge, // 3  compatibility
 AZBtm			= NSMinYEdge, // 1  numbering!
 AZPositionTopLeft	   	= 4,
 AZPositionBottomLeft		= 5,
 AZPositionTopRight	 	= 6,
 AZPositionBottomRight   = 7,
 AZPositionAutomatic	 	= 8
 };// AZWindowPosition;
 */
//JREnumDeclare(AZPosition,
//	AZLft 			= 0,// NSMinXEdge, // 0  NSDrawer
//	AZRgt			= 2, //NSMaxXEdge, // 2  preferredEdge
//	AZTop		   	= 3, //NSMaxYEdge, // 3  compatibility
//	AZBtm			= 1,  //NSMinYEdge, // 1  numbering!
//	AZPositionTopLeft	   	= 4,
//	AZPositionBottomLeft		= 5,
//	AZPositionTopRight	 	= 6,
//	AZPositionBottomRight   = 7,
//	AZPositionAutomatic	 	= 8 );// AZWindowPosition;



//NSS* stringForPosition(AZWindowPosition enumVal);

//NS_INLINE NSS* stringForPosition(AZPOS e) {	_pos = _pos ?: [NSA arrayWithObjects:AZWindowPositionTypeArray];
//	return _pos.count >= e ? _pos[e] : @"outside of range for Positions";
//}
//NS_INLINE AZPOS positionForString(NSS* s)	{	_pos = _pos ?: [NSA arrayWithObjects:AZWindowPositionTypeArray];
//															return (AZPOS) [_pos indexOfObject:s];
//}

//JROptionsDeclare(AZAlign, 	AZAlignLeft       = flagbit1, //0x00000001,
//									AZAlignRight      = flagbit2, //0x00000010,
//									AZAlignTop        = flagbit3, //0x00000100,
//									AZAlignBottom     = flagbit4, //0x00001000,
//									AZAlignTopLeft    = flagbit5, //0x00000101,
//									AZAlignBottomLeft = flagbit6, //0x00001001,
//									AZAlignTopRight   = flagbit7, //0x00000110,
//									AZAlignBottomRight = flagbit8 // 0x00001010
//);


//JREnumDeclare (AZAlign,

//JROptionsDeclare(AZ_arc, 	AZ_arc_NATOM	       	= 0x00000001,
//					  AZ_arc_RONLY 	     		= 0x00000010,
//					  AZ_arc_STRNG	        	= 0x00000100,
//					  AZ_arc_ASSGN  		   	= 0x00001000,
//					  AZ_arc__COPY 		   	= 0x00010000,
//					  AZ_arc__WEAK				= 0x00100000);


//#import "AtoZMacroDefines.h"
//#import "JREnum.h"
//#import "AtoZUmbrella.h"
//#ifdef __OBJC__

*/



//#import "AtoZUmbrella.h"


//#import "AtoZAutoBox/AtoZAutoBox.h"
////#import "JREnum.h"


//typedef enum {
//	JSON = 0,		 // explicitly indicate starting index
//	XML,
//	Atom,
//	RSS,
//
//	FormatTypeCount,  // keep track of the enum size automatically
//} FormatType;
//extern NSString *const FormatTypeName[FormatTypeCount];
//NSLog(@"%@", FormatTypeName[XML]);
//	// In a source file
//NSString *const FormatTypeName[FormatTypeCount] = {
//	[JSON] = @"JSON",
//	[XML] = @"XML",
//	[Atom] = @"Atom",
//	[RSS] = @"RSS",
//};
//typedef enum {
//	IngredientType_text  = 0,
//	IngredientType_audio = 1,
//	IngredientType_video = 2,
//	IngredientType_image = 3
//} IngredientType;
//write a method like this in class:
//+ (NSString*)typeStringForType:(IngredientType)_type {
//	NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type];
//	return NSLocalizedString(key, nil);
//}
//have the strings inside Localizable.strings file:
///* IngredientType_text */
//"IngredientType_0" = "Text";
///* IngredientType_audio */
//"IngredientType_1" = "Audio";
///* IngredientType_video */
//"IngredientType_2" = "Video";
///* IngredientType_image */
//"IngredientType_3" = "Image";
//

//typedef struct _GlossParameters{
//	CGFloat color[4];
//	CGFloat caustic[4];
//	CGFloat expCoefficient;
//	CGFloat expScale;
//	CGFloat expOffset;
//	CGFloat initialWhite;
//	CGFloat finalWhite;
//} GlossParameters;

//#endif


BOOL flag = YES;
NSLog(flag ? @"Yes" : @"No");
?: is the ternary conditional operator of the form:
condition ? result_if_true : result_if_false

#pragma - Log Functions

#ifdef DEBUG
#	define CWPrintClassAndMethod() NSLog(@"%s%i:\n",__PRETTY_FUNCTION__,__LINE__)
#	define CWDebugLog(args...) NSLog(@"%s%i: %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:args])
#else
#	define CWPrintClassAndMethod() /**/
#	define CWDebugLog(args...) /**/
#endif

#define CWLog(args...) NSLog(@"%s%i: %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:args])
#define CWDebugLocationString() [NSString stringWithFormat:@"%s[%i]",__PRETTY_FUNCTION__,__LINE__]

#define nilease(A) [A release]; A = nil

#define $affectors(A,...) +(NSSet *)keyPathsForValuesAffecting##A { static NSSet *re = nil; \
if (!re) { re = [[[@#__VA_ARGS__ splitByComma] trimmedStrings] set]; } return re; }


 static NSA* colors;  colors = colors ?: NSC.randomPalette;
 static NSUI idx = 0;
 va_list   argList;
 va_start (argList, format);
 NSS *path  	= [$UTF8(file) lastPathComponent];
 NSS *mess   = [NSString.alloc initWithFormat:format arguments:argList];
 //	NSS *justinfo = $(@"[%s]:%i",path.UTF8String, lineNumber);
 //	NSS *info   = [NSString stringWithFormat:@"word:%-11s rank:%u", [word UTF8String], rank];
 NSS *info 	= $( XCODE_COLORS_ESCAPE @"fg82,82,82;" @"  [%s]" XCODE_COLORS_RESET
 XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i" XCODE_COLORS_RESET	, path.UTF8String, lineNumber);
 int max 			= 130;
 int cutTo			= 22;
 BOOL longer 	= mess.length > max;
 NSC *c = [colors normal:idx];
 NSS *cs = $(@"%i%i%i",(int)c.redComponent, (int)c.greenComponent, (int)c.blueComponent); idx++;
 NSS* nextLine 	= longer ? $(XCODE_COLORS_ESCAPE @"fg%@;" XCODE_COLORS_RESET @"\n\t%@\n", cs, [mess substringFromIndex:max - cutTo]) : @"\n";
 mess 				= longer ? [mess substringToIndex:max - cutTo] : mess;
 int add = max - mess.length - cutTo;
 if (add > 0) {
 NSS *pad = [NSS.string stringByPaddingToLength:add withString:@" " startingAtIndex:0];
 info = [pad stringByAppendingString:info];
 }
 NSS *toLog 	= $(XCODE_COLORS_ESCAPE @"fg%@;" @"%@" XCODE_COLORS_RESET @"%@%@", cs, mess, info, nextLine);
 fprintf ( stderr, "%s", toLog.UTF8String);//[%s]:%i %s \n", [path UTF8String], lineNumber, [message UTF8String] );
 va_end  (argList);


	NSS *toLog 	= $( XCODE_COLORS_RESET	@"%s" XCODE_COLORS_ESCAPE @"fg82,82,82;" @"%-70s[%s]" XCODE_COLORS_RESET
									XCODE_COLORS_ESCAPE @"fg140,140,140;" @":%i\n" XCODE_COLORS_RESET	,
									mess.UTF8String, "", path.UTF8String, lineNumber);

	NSLog(XCODE_COLORS_ESCAPE @"bg89,96,105;" @"Grey background" XCODE_COLORS_RESET);
	NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;"
			XCODE_COLORS_ESCAPE @"bg220,0,0;"
			@"Blue text on red background"
//			XCODE_COLORS_RESET);

 if ( [[NSApplication sharedApplication] delegate] ) {
 id appD = [[NSApplication sharedApplication] delegate];
 //		fprintf ( stderr, "%s", [[appD description]UTF8String] );
 if ( [(NSObject*)appD respondsToSelector:NSSelectorFromString(@"stdOutView")]) {
 NSTextView *tv 	= ((NSTextView*)[appD valueForKey:@"stdOutView"]);
 if (tv) [tv autoScrollText:toLog];
 }
 }

 $(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: args])	]
	const char *threadName = [[[NSThread currentThread] name] UTF8String];
}


#define AZTransition(duration, type, subtype) CATransition *transition = [CATransition animation];
[transition setDuration:1.0];
[transition setType:kCATransitionPush];
[transition setSubtype:kCATransitionFromLeft];
extern NSArray* AZConstraintEdgeExcept(AZCOn attr, rel, scale, off) \
[NSArray arrayWithArray:@[
AZConstRelSuper( kCAConstraintMaxX ),
AZConstRelSuper( kCAConstraintMinX ),
AZConstRelSuper( kCAConstraintWidth),
AZConstRelSuper( kCAConstraintMinY ),
AZConstRelSuperScaleOff(kCAConstraintHeight, .2, 0),

#define AZConst(attr, rel) \
[CAConstraint constraintWithAttribute: attr relativeTo: rel attribute: attr]
@property (nonatomic, assign) <\#type\#> <\#name\#>;
 AZConst(<\#CAConstraintAttribute\#>, <#\NSString\#>);
 AZConst(<#CAConstraintAttribute#>, <#NSString*#>);
#import "AtoZiTunes.h"

// Sweetness vs. longwindedness
//  BaseModel.h
//  Version 2.3.1
//  ARC Helper
//  Version 1.3.1

//  Weak delegate support
#ifndef ah_weak
#import <Availability.h>
#if (__has_feature(objc_arc)) && \
((defined __IPHONE_OS_VERSION_MIN_REQUIRED && \
__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0) || \
(defined __MAC_OS_X_VERSION_MIN_REQUIRED && \
__MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_7))
#define ah_weak weak
#define __ah_weak __weak
#else
#define ah_weak unsafe_unretained
#define __ah_weak __unsafe_unretained
#endif
#endif
//  ARC Helper ends


#define AZRelease(value) \
if ( value ) { \
[value release]; \
value = nil; \
}

#define AZAssign(oldValue,newValue) \
[ newValue retain ]; \
AZRelease (oldValue); \
oldValue = newValue;


////#import <AppKit/AppKit.h>
//#import <Carbon/Carbon.h>
//#import <Quartz/Quartz.h>
////#import <Python/Python.h>
//#import <WebKit/WebView.h>
//#import <dispatch/dispatch.h>
//#import <Security/Security.h>
//#import <QuartzCore/QuartzCore.h>
//#import <AVFoundation/AVFoundation.h>
//#import <CoreServices/CoreServices.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import <CoreFoundation/CoreFoundation.h>
//#import <ApplicationServices/ApplicationServices.h>
//#import <SystemConfiguration/SystemConfiguration.h>
//#import <CoreServices/CoreServices.h>


//#import <CoreData/CoreData.h>
//@import ApplicationServices;
//@import AudioToolbox;
//#import <AudioToolbox/AudioToolbox.h>
//@import AVFoundation;
//@import Cocoa;
//@import CoreServices;
//#import <Dispatch/Dispatch.h>
//#import <objc/runtime.h>
//  #import "BaseModel.h"
//  #import "JREnum.h"
//
//  #import "AtoZMacroDefines.h"
//  #import "AtoZUmbrella.h"
//  #import "BoundingObject.h"
//  #import "AtoZGeometry.h"
//  #import "AtoZCategories.h"


//#define release self
//#import "AtoZTypes.h"
//#define JROptionsDeclare(ENUM_TYPENAME...) JREnumDeclare(ENUM_TYPENAME,__VA_ARGS__)
//#define JROptionsDefine(X) JREnumDefine(X)



/*! @abstract		Enforcement of compiler warning flags */

#ifndef __clang__
#error "Please consider using Clang as compiler!"
#endif

/*
#ifdef AZWARNINGS 

#pragma clang diagnostic fatal "-Wabi"
#pragma clang diagnostic fatal "-Waddress-of-temporary"
#pragma clang diagnostic fatal "-Waddress"
#pragma clang diagnostic fatal "-Waggregate-return"
#pragma clang diagnostic fatal "-Wall"
#pragma clang diagnostic fatal "-Wambiguous-member-template"
#pragma clang diagnostic fatal "-Warc-abi"
#pragma clang diagnostic fatal "-Warc-non-pod-memaccess"
#pragma clang diagnostic fatal "-Warc-retain-cycles"
#pragma clang diagnostic fatal "-Warc-unsafe-retained-assign"
#pragma clang diagnostic fatal "-Warc"
#pragma clang diagnostic fatal "-Watomic-properties"
#pragma clang diagnostic fatal "-Wattributes"
#pragma clang diagnostic fatal "-Wavailability"
#pragma clang diagnostic fatal "-Wbad-function-cast"
#pragma clang diagnostic fatal "-Wbind-to-temporary-copy"
#pragma clang diagnostic fatal "-Wbitwise-op-parentheses"
#pragma clang diagnostic fatal "-Wbool-conversions"
#pragma clang diagnostic fatal "-Wbuiltin-macro-redefined"
#pragma clang diagnostic fatal "-Wc++-compat"
#pragma clang diagnostic fatal "-Wc++0x-compat"
#pragma clang diagnostic fatal "-Wc++0x-extensions"
#pragma clang diagnostic fatal "-Wcast-align"
#pragma clang diagnostic fatal "-Wcast-qual"
#pragma clang diagnostic fatal "-Wchar-align"
#pragma clang diagnostic fatal "-Wchar-subscripts"
#pragma clang diagnostic fatal "-Wcomment"
#pragma clang diagnostic fatal "-Wcomments"
#pragma clang diagnostic fatal "-Wconditional-uninitialized"
#pragma clang diagnostic fatal "-Wconversion"
#pragma clang diagnostic fatal "-Wctor-dtor-privacy"
#pragma clang diagnostic fatal "-Wcustom-atomic-properties"
#pragma clang diagnostic fatal "-Wdeclaration-after-statement"
#pragma clang diagnostic fatal "-Wdelegating-ctor-cycles"
#pragma clang diagnostic fatal "-Wdelete-non-virtual-dtor"
#pragma clang diagnostic fatal "-Wdeprecated-declarations"
#pragma clang diagnostic fatal "-Wdeprecated-implementations"
#pragma clang diagnostic fatal "-Wdeprecated-writable-strings"
#pragma clang diagnostic fatal "-Wdeprecated"
#pragma clang diagnostic fatal "-Wdisabled-optimization"
#pragma clang diagnostic fatal "-Wdiscard-qual"
#pragma clang diagnostic fatal "-Wdiv-by-zero"
#pragma clang diagnostic fatal "-Wduplicate-method-arg"
#pragma clang diagnostic fatal "-Weffc++"
#pragma clang diagnostic fatal "-Wempty-body"
#pragma clang diagnostic fatal "-Wendif-labels"
#pragma clang diagnostic fatal "-Wexit-time-destructors"
#pragma clang diagnostic fatal "-Wextra-tokens"
#pragma clang diagnostic fatal "-Wextra"
#pragma clang diagnostic fatal "-Wformat-extra-args"
#pragma clang diagnostic fatal "-Wformat-nonliteral"
#pragma clang diagnostic fatal "-Wformat-zero-length"
#pragma clang diagnostic fatal "-Wformat"
#pragma clang diagnostic fatal "-Wformat=2"
#pragma clang diagnostic fatal "-Wfour-char-constants"
#pragma clang diagnostic fatal "-Wglobal-constructors"
#pragma clang diagnostic fatal "-Wgnu-designator"
#pragma clang diagnostic fatal "-Wgnu"
#pragma clang diagnostic fatal "-Wheader-hygiene"
#pragma clang diagnostic fatal "-Widiomatic-parentheses"
#pragma clang diagnostic fatal "-Wignored-qualifiers"
#pragma clang diagnostic fatal "-Wimplicit-atomic-properties"
#pragma clang diagnostic fatal "-Wimplicit-function-declaration"
#pragma clang diagnostic fatal "-Wimplicit-int"
#pragma clang diagnostic fatal "-Wimplicit"
#pragma clang diagnostic fatal "-Wimport"
#pragma clang diagnostic fatal "-Wincompatible-pointer-types"
#pragma clang diagnostic fatal "-Winit-self"
#pragma clang diagnostic fatal "-Winitializer-overrides"
#pragma clang diagnostic fatal "-Winline"
#pragma clang diagnostic fatal "-Wint-to-pointer-cast"
#pragma clang diagnostic fatal "-Winvalid-offsetof"
#pragma clang diagnostic fatal "-Winvalid-pch"
#pragma clang diagnostic fatal "-Wlarge-by-value-copy"
#pragma clang diagnostic fatal "-Wliteral-range"
#pragma clang diagnostic fatal "-Wlocal-type-template-args"
#pragma clang diagnostic fatal "-Wlogical-op-parentheses"
#pragma clang diagnostic fatal "-Wlong-long"
#pragma clang diagnostic fatal "-Wmain"
#pragma clang diagnostic fatal "-Wmicrosoft"
#pragma clang diagnostic fatal "-Wmismatched-tags"
#pragma clang diagnostic fatal "-Wmissing-braces"
#pragma clang diagnostic fatal "-Wmissing-declarations"
#pragma clang diagnostic fatal "-Wmissing-field-initializers"
#pragma clang diagnostic fatal "-Wmissing-format-attribute"
#pragma clang diagnostic fatal "-Wmissing-include-dirs"
#pragma clang diagnostic fatal "-Wmissing-noreturn"
#pragma clang diagnostic fatal "-Wmost"
#pragma clang diagnostic fatal "-Wmultichar"
#pragma clang diagnostic fatal "-Wnested-externs"
#pragma clang diagnostic fatal "-Wnewline-eof"
#pragma clang diagnostic fatal "-Wnon-gcc"
#pragma clang diagnostic fatal "-Wnon-virtual-dtor"
#pragma clang diagnostic fatal "-Wnonnull"
#pragma clang diagnostic fatal "-Wnonportable-cfstrings"
#pragma clang diagnostic fatal "-Wnull-dereference"
#pragma clang diagnostic fatal "-Wobjc-nonunified-exceptions"
#pragma clang diagnostic fatal "-Wold-style-cast"
#pragma clang diagnostic fatal "-Wold-style-definition"
#pragma clang diagnostic fatal "-Wout-of-line-declaration"
#pragma clang diagnostic fatal "-Woverflow"
#pragma clang diagnostic fatal "-Woverlength-strings"
#pragma clang diagnostic fatal "-Woverloaded-virtual"
#pragma clang diagnostic fatal "-Wpacked"
#pragma clang diagnostic fatal "-Wparentheses"
#pragma clang diagnostic fatal "-Wpointer-arith"
#pragma clang diagnostic fatal "-Wpointer-to-int-cast"
#pragma clang diagnostic fatal "-Wprotocol"
#pragma clang diagnostic fatal "-Wreadonly-setter-attrs"
#pragma clang diagnostic fatal "-Wredundant-decls"
#pragma clang diagnostic fatal "-Wreorder"
#pragma clang diagnostic fatal "-Wreturn-type"
#pragma clang diagnostic fatal "-Wself-assign"
#pragma clang diagnostic fatal "-Wsemicolon-before-method-body"
#pragma clang diagnostic fatal "-Wsequence-point"
#pragma clang diagnostic fatal "-Wshadow"
#pragma clang diagnostic fatal "-Wshorten-64-to-32"
#pragma clang diagnostic fatal "-Wsign-compare"
#pragma clang diagnostic fatal "-Wsign-promo"
#pragma clang diagnostic fatal "-Wsizeof-array-argument"
#pragma clang diagnostic fatal "-Wstack-protector"
#pragma clang diagnostic fatal "-Wstrict-aliasing"
#pragma clang diagnostic fatal "-Wstrict-overflow"
#pragma clang diagnostic fatal "-Wstrict-prototypes"
#pragma clang diagnostic fatal "-Wstrict-selector-match"
#pragma clang diagnostic fatal "-Wsuper-class-method-mismatch"
#pragma clang diagnostic fatal "-Wswitch-default"
#pragma clang diagnostic fatal "-Wswitch-enum"
#pragma clang diagnostic fatal "-Wswitch"
#pragma clang diagnostic fatal "-Wsynth"
#pragma clang diagnostic fatal "-Wtautological-compare"
#pragma clang diagnostic fatal "-Wtrigraphs"
#pragma clang diagnostic fatal "-Wtype-limits"
#pragma clang diagnostic fatal "-Wundeclared-selector"
#pragma clang diagnostic fatal "-Wuninitialized"
#pragma clang diagnostic fatal "-Wunknown-pragmas"
#pragma clang diagnostic fatal "-Wunnamed-type-template-args"
#pragma clang diagnostic fatal "-Wunneeded-internal-declaration"
#pragma clang diagnostic fatal "-Wunneeded-member-function"
#pragma clang diagnostic fatal "-Wunused-argument"
#pragma clang diagnostic fatal "-Wunused-exception-parameter"
#pragma clang diagnostic fatal "-Wunused-function"
#pragma clang diagnostic fatal "-Wunused-label"
#pragma clang diagnostic fatal "-Wunused-member-function"
#pragma clang diagnostic fatal "-Wunused-parameter"
#pragma clang diagnostic fatal "-Wunused-value"
#pragma clang diagnostic fatal "-Wunused-variable"
#pragma clang diagnostic fatal "-Wunused"
#pragma clang diagnostic fatal "-Wused-but-marked-unused"
#pragma clang diagnostic fatal "-Wvector-conversions"
#pragma clang diagnostic fatal "-Wvla"
#pragma clang diagnostic fatal "-Wvolatile-register-var"
#pragma clang diagnostic fatal "-Wwrite-strings"
*/

/* Not wanted:*/
/*
#pragma clang diagnostic ignored "-Wgnu"
#pragma clang diagnostic ignored "-Wpadded"
#pragma clang diagnostic ignored "-Wselector"
#pragma clang diagnostic ignored "-Wvariadic-macros"
*/

/*
* Not recognized by Apple implementation:
* 
* #pragma clang diagnostic fatal "-Wdefault-arg-special-member"
* #pragma clang diagnostic fatal "-Wauto-import"
* #pragma clang diagnostic fatal "-Wbuiltin-requires-header"
* #pragma clang diagnostic fatal "-Wc++0x-narrowing"
* #pragma clang diagnostic fatal "-Wc++11-compat"
* #pragma clang diagnostic fatal "-Wc++11-extensions"
* #pragma clang diagnostic fatal "-Wc++11-narrowing"
* #pragma clang diagnostic fatal "-Wc++98-compat-bind-to-temporary-copy"
* #pragma clang diagnostic fatal "-Wc++98-compat-local-type-template-args"
* #pragma clang diagnostic fatal "-Wc++98-compat-pedantic"
* #pragma clang diagnostic fatal "-Wc++98-compat-unnamed-type-template-args"
* #pragma clang diagnostic fatal "-Wc1x-extensions"
* #pragma clang diagnostic fatal "-Wc99-extensions"
* #pragma clang diagnostic fatal "-Wcatch-incomplete-type-extensions"
* #pragma clang diagnostic fatal "-Wduplicate-method-match"
* #pragma clang diagnostic fatal "-Wflexible-array-extensions"
* #pragma clang diagnostic fatal "-Wmalformed-warning-check"
* #pragma clang diagnostic fatal "-Wmissing-method-return-type"
* #pragma clang diagnostic fatal "-Wmodule-build"
* #pragma clang diagnostic fatal "-WNSObject-attribute"
* #pragma clang diagnostic fatal "-Wnull-character"
* #pragma clang diagnostic fatal "-Wobjc-missing-super-calls"
* #pragma clang diagnostic fatal "-Wobjc-noncopy-retain-block-property"
* #pragma clang diagnostic fatal "-Wobjc-property-implementation"
* #pragma clang diagnostic fatal "-Wobjc-protocol-method-implementation"
* #pragma clang diagnostic fatal "-Wobjc-readonly-with-setter-property"
* #pragma clang diagnostic fatal "-Woverriding-method-mismatch"
* #pragma clang diagnostic fatal "-Wsentinel"
* #pragma clang diagnostic fatal "-Wunicode"
* #pragma clang diagnostic fatal "-Wunused-comparison"
* #pragma clang diagnostic fatal "-Wunused-result"
* #pragma clang diagnostic fatal "-Wuser-defined-literals"

#endif

*/

/*
//	#import <objc/message.h>
//	#import <objc/runtime.h>
//	#import <libkern/OSAtomic.h>

	#import <Availability.h>
	#import <TargetConditionals.h>
	#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MIN_REQUIRED
	#import <SystemConfiguration/SystemConfiguration.h>
	#import <MobileCoreServices/MobileCoreServices.h>
	#import <sys/xattr.h>
	#else
	#import <objc/NSObjCRuntime.h>

	#import <pwd.h>
	#import <stdio.h>
	#import <netdb.h>
	#import <dirent.h>
	#import <unistd.h>
	#import <stdarg.h>
	#import <xpc/xpc.h>
	#import <sys/time.h>
	#import <sys/ioctl.h>
	#import <sys/sysctl.h>
	#import <sys/stat.h>
	#import <sys/types.h>
	#import <sys/xattr.h>
	#import <arpa/inet.h>
	#import <objc/objc.h>
	#import <netinet/in.h>

	#import <objc/message.h>
	#import <objc/runtime.h>
	#import <libkern/OSAtomic.h>


	#import <Foundation/NSObjCRuntime.h>
	#import "AZObserversAndBinders.h"
	#import <TwUI/TUIKit.h>



//	#import <extobjc_OSX/e.h>
//	#import "extobjc_OSX/extobjc.h"
//	#import <extobjc/metamacros.h>

	#import <FunSize/FunSize.h>
	#import <DrawKit/DKDrawKit.h>
//	#import "AtoZAutoBox/NSObject+DynamicProperties.h"
  #import <AtoZAppKit/AtoZAppKit.h>
	#import <BlocksKit/BlocksKit.h>
	#import <CocoaPuffs/CocoaPuffs.h>
	#import <AtoZBezierPath/AtoZBezierPath.h>
	#import "AtoZAutoBox/AtoZAutoBox.h"
	#import "KVOMap/KVOMap.h"

//	#import "GCDAsyncSocket.h"
//	#import "GCDAsyncSocket+AtoZ.h"
	#import "objswitch.h"
	#import "BaseModel.h"
	#import "AtoZMacroDefines.h"
	#import "JREnum.h"
	#import "AtoZTypes.h"
	#import "AtoZGeometry.h"
	#import "AtoZCategories.h"
	#import "AtoZUmbrella.h"
  #import "BlocksAdditions.h"
  #import "SynthesizeSingleton.h"

//	#import "GCDAsyncSocket.h"
//	#import "HTTPServer.h"

	#define EXCLUDE_STUB_PROTOTYPES 1
	#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>
	#import <MenuApp/MenuApp.h>
#import <Rebel/Rebel.h>
	#import <KSHTMLWriterKit/KSHTMLWriterKit.h>
	#import <NanoStore/NanoStore.h>

#import <ApplicationServices/ApplicationServices.h>
#import "BaseModel.h"
//	#import <AIUtilities/AIUtilities.h>
	#import "NSTerminal.h"

	#define release 			self										// Is this right?  Why's mine different?
  #define autorelease 		self										// But shit hits fan without.

	#import "AZLog.h"
	#import "NSUserDefaults+Subscript.h"
	#import "AZProcess.h"

//#endif  //  END AZFRAMEWORK PCH  #ifdef __OBJC__
#ifndef _OmniBase_assertions_h_
#define _OmniBase_assertions_h_
//#import <OmniBase/FrameworkDefines.h>
//#if defined(DEBUG) || defined(OMNI_FORCE_ASSERTIONS)
//#define OMNI_ASSERTIONS_ON
//#endif
//#if defined(OMNI_FORCE_ASSERTIONS_OFF)					// This allows you to turn off assertions when debugging
#undef OMNI_ASSERTIONS_ON
//#warning Forcing assertions off!
//#endif
// Make sure that we don't accidentally use the ASSERT macro instead of OBASSERT
#ifdef ASSERT
#undef ASSERT
#endif
typedef void (*OBAssertionFailureHandler)(const char *type, const char *expression, const char *file, unsigned int lineNumber);
#if defined(OMNI_ASSERTIONS_ON)
OmniBase_EXTERN void OBSetAssertionFailureHandler(OBAssertionFailureHandler handler);
OmniBase_EXTERN void OBAssertFailed(const char *type, const char *expression, const char *file, unsigned int lineNumber);
#define OBPRECONDITION(expression)	do{if(!(expression))OBAssertFailed("PRECONDITION", #expression,__FILE__,__LINE__);}while(NO)
#define OBPOSTCONDITION(expression)	do{if(!(expression))OBAssertFailed("POSTCONDITION",#expression,__FILE__,__LINE__);}while(NO)
#define OBINVARIANT(expression)		do{if(!(expression))OBAssertFailed("INVARIANT",    #expression,__FILE__,__LINE__);}while(NO)
#define OBASSERT(expression)			do{if(!(expression))OBAssertFailed("ASSERT", 		#expression,__FILE__,__LINE__);}while(NO)
#define OBASSERT_NOT_REACHED(reason)do{					  OBAssertFailed("NOTREACHED", 	     reason,__FILE__,__LINE__);}while(NO)
#else	// else insert blank lines into the code
#define OBPRECONDITION(expression)
#define OBPOSTCONDITION(expression)
#define OBINVARIANT(expression)
#define OBASSERT(expression)
#define OBASSERT_NOT_REACHED(reason)
#endif
#endif // _OmniBase_assertions_h_

#endif

#import <MapKit/MapKit.h>
#import <Nu/Nu.h>
#import <Lumberjack/Lumberjack.h>
#import <XPCKit/XPCKit.h>
#import <SNRHUDKit/SNRHUDKit.h>
#import <AtoZUI/AtoZUI.h>
#import <libatoz.h>

#import "AutoCoding.h"
#import "HRCoder.h"
*/
/*
 #import "GTMHTTPFetcher.h"
 
 #import "AddressBookImageLoader.h"
 #import "AFHTTPClient.h"
 #import "AFHTTPRequestOperation.h"
 #import "AFImageRequestOperation.h"
 #import "AFJSONRequestOperation.h"
 #import "AFNetworking.h"
 #import "AFPropertyListRequestOperation.h"
 #import "AFURLConnectionOperation.h"
 #import "AFXMLRequestOperation.h"
 #import "AGNSSplitView.h"
 #import "AGNSSplitViewDelegate.h"
 #import "AZProcess.h"
 #import "AHLayout.h"
 #import "ASICacheDelegate.h"
 #import "ASIDataCompressor.h"
 #import "ASIDataDecompressor.h"
 #import "ASIDownloadCache.h"
 #import "ASIFormDataRequest.h"
 #import "ASIHTTPRequest.h"
 #import "ASIHTTPRequestConfig.h"
 #import "ASIHTTPRequestDelegate.h"
 #import "ASIInputStream.h"
 #import "ASINetworkQueue.h"
 #import "ASIProgressDelegate.h"

#import "AssetCollection.h"
#import "AtoZ.h"
#import "AtoZColorWell.h"
#import "AtoZFunctions.h"
#import "AtoZGeometry.h"
#import "AtoZGridView.h"
#import "AtoZGridViewProtocols.h"
#import "AtoZInfinity.h"
#import "AtoZModels.h"
#import "AtoZStack.h"
#import "AtoZTypes.h"
#import "AtoZUmbrella.h"
#import "AtoZWebSnapper.h"
#import "AtoZWebSnapperGridViewController.h"
#import "AtoZWebSnapperWindowController.h"
#import "AutoCoding.h"
#import "AZApplePrivate.h"
#import "AZASIMGV.h"
#import "AZAttachedWindow.h"
#import "AZAXAuthorization.h"
#import "AZBackground.h"
#import "AZBackgroundProgressBar.h"
#import "AZBlockView.h"
#import "AZBorderlessResizeWindow.h"
#import "AZBox.h"
#import "AZBoxGrid.h"
#import "AZBoxMagic.h"
#import "AZButton.h"
#import "AZCalculatorController.h"
#import "AZCLI.h"
#import "AZCLICategories.h"
#import "AZCLITests.h"
#import "AZCoreScrollView.h"
#import "AZCSSColorExtraction.h"
#import "AZDarkButtonCell.h"
#import "AZDebugLayer.h"
#import "AZDockQuery.h"
#import "AZExpandableView.h"
#import "AZFacebookConnection.h"
#import "AZFavIconManager.h"
#import "AZFile.h"
#import "AZFoamView.h"
#import "AZGrid.h"
#import "AZHomeBrew.h"
#import "AZHostView.h"
#import "AZHoverButton.h"
#import "AZHTMLParser.h"
#import "AZHTTPRouter.h"
#import "AZHTTPURLProtocol.h"
#import "AZImageToDataTransformer.h"
#import "AZIndeterminateIndicator.h"
#import "AZInfiniteCell.h"
#import "AZInstantApp.h"
#import "AZLassoLayer.h"
#import "AZLassoView.h"
#import "AZLaunchServices.h"
#import "AZLayer.h"
#import "AZMatrix.h"
#import "AZMatteButton.h"
#import "AZMatteFocusedGradientBox.h"
#import "AZMattePopUpButton.h"
#import "AZMattePopUpButtonView.h"
#import "AZMatteSegmentedControl.h"
#import "AZMedallionView.h"
#import "AZMouser.h"
#import "AZNamedColors.h"
#import "AZPoint.h"
#import "AZPopupWindow.h"
#import "AZPrismView.h"
#import "AZProgressIndicator.h"
#import "AZPropellerView.h"
#import "AZProportionalSegmentController.h"
#import "AZQueue.h"
#import "AZRect.h"
#import "AZScrollerLayer.h"
#import "AZScrollerProtocols.h"
#import "AZScrollPaneLayer.h"
#import "AZSegmentedRect.h"
#import "AZSemiResponderWindow.h"
#import "AZSimpleView.h"
#import "AZSize.h"
#import "AZSizer.h"
#import "AZSnapShotLayer.h"
#import "AZSound.h"
#import "AZSourceList.h"
#import "AZSpeechRecognition.h"
#import "AZSpinnerLayer.h"
#import "AZStopwatch.h"
  #import "AZTalker.h"
#import "AZTimeLineLayout.h"
#import "AZToggleArrayView.h"
#import "AZTrackingWindow.h"
#import "AZURLSnapshot.h"
#import "AZVeil.h"
#import "AZWeakCollections.h"
#import "AZWikipedia.h"
#import "AZWindowExtend.h"
#import "AZXMLWriter.h"
 #import "BaseModel.h"
 #import "BaseModel+AtoZ.h"
 #import "BBMeshView.h"
 #import "BlocksAdditions.h"
 #import "Bootstrap.h"
 #import "CAAnimation+AtoZ.h"
 #import "CALayer+AtoZ.h"
 #import "CalcModel.h"
 #import "CAScrollView.h"
 #import "CAWindow.h"
 #import "CKAdditions.h"
 #import "CKMacros.h"
 #import "CKSingleton.h"
 #import "ConciseKit.h"
 #import "ConcurrentOperation.h"
 #import "CPAccelerationTimer.h"
 #import "CTBadge.h"
 #import "CTGradient.h"
 #import "DDData.h"
 #import "DDNumber.h"
 #import "DDRange.h"
 #import "EGOCache.h"
 #import "EGOImageLoadConnection.h"
 #import "EGOImageLoader.h"
 #import "EGOImageView.h"
 #import "F.h"
 #import "GCDAsyncSocket.h"
 //#import "GTMHTTPFetcher.h"
 //#import "GTMNSString+HTML.h"
 #import "HRCoder.h"
 #import "HTMLNode.h"
 #import "HTMLParserViewController.h"
 #import "HTTPAsyncFileResponse.h"
 #import "HTTPAuthenticationRequest.h"
 #import "HTTPConnection.h"
 #import "HTTPDataResponse.h"
 #import "HTTPDynamicFileResponse.h"
 #import "HTTPErrorResponse.h"
 #import "HTTPFileResponse.h"
 #import "HTTPLogging.h"
 #import "HTTPMessage.h"
 #import "HTTPRedirectResponse.h"
 #import "HTTPResponse.h"
 #import "HTTPResponseProxy.h"
 #import "HTTPServer.h"
 #import "iCarousel.h"
 #import "IGIsolatedCookieWebView.h"
 #import "INAppStoreWindow.h"
 #import "JREnum.h"
 #import "JsonElement.h"
 #import "JSONKit.h"
 #import "KGNoise.h"
 #import "LetterView.h"
 #import "LoremIpsum.h"
 #import "MAAttachedWindow.h"
 #import "MAKVONotificationCenter.h"
#import "MArray.h"
 #import "MediaServer.h"
 #import "MetalUI.h"
 #import "MultipartFormDataParser.h"
 #import "MultipartMessageHeader.h"
 #import "MultipartMessageHeaderField.h"
 #import "NotificationCenterSpy.h"
 #import "NSApplication+AtoZ.h"
 #import "NSArray+AtoZ.h"
 #import "NSArray+ConciseKit.h"
 #import "NSArray+F.h"
 #import "NSArray+UsefulStuff.h"
 #import "NSBag.h"
 #import "NSBezierPath+AtoZ.h"
 #import "NSBundle+AtoZ.h"
 #import "NSCell+AtoZ.h"
 #import "NSColor+AtoZ.h"
 #import "NSDate+AtoZ.h"
 #import "NSDictionary+AtoZ.h"
 #import "NSDictionary+ConciseKit.h"
 #import "NSDictionary+F.h"
 #import "NSError+AtoZ.h"
 #import "NSEvent+AtoZ.h"
 #import "NSFileManager+AtoZ.h"
 #import "NSFont+AtoZ.h"
 #import "NSHTTPCookie+Testing.h"
 #import "NSImage-Tint.h"
 #import "NSImage+AtoZ.h"
 #import "NSIndexSet+AtoZ.h"
 #import "AZLogConsole.h"
 #import "NSNotificationCenter+AtoZ.h"
 #import "NSNumber+AtoZ.h"
 #import "NSNumber+F.h"
 #import "NSObject-Utilities.h"
 #import "NSObject+AtoZ.h"
 #import "NSObject+Properties.h"

 #import "NSOrderedDictionary.h"
 #import "NSOutlineView+AtoZ.h"
 #import "NSScreen+AtoZ.h"
 #import "NSShadow+AtoZ.h"
 #import "NSSplitView+DMAdditions.h"
 #import "NSString+AtoZ.h"
 #import "NSString+AtoZEnums.h"
 #import "NSString+ConciseKit.h"
 #import "NSString+PathAdditions.h"
 #import "NSString+URLAdditions.h"
 #import "NSString+UUID.h"
 #import "NSTableView+AtoZ.h"
 #import "NSTask+OneLineTasksWithOutput.h"
 #import "NSTextView+AtoZ.h"
 #import "NSThread+AtoZ.h"
 #import "NSURL+AtoZ.h"
 #import "NSUserDefaults+Subscript.h"
 #import "NSValue+AtoZ.h"
 #import "NSView+AtoZ.h"
 #import "NSWindow_Flipr.h"
 #import "NSWindow+AtoZ.h"

 #import "OperationsRunner.h"
 #import "OperationsRunnerProtocol.h"
 #import "PreferencesController.h"
 #import "PXListDocumentView.h"
 #import "PXListView.h"
 #import "PXListViewCell.h"
 #import "PythonOperation.h"
 #import "RoundedView.h"
 #import "Route.h"
 #import "RouteRequest.h"
 #import "RouteResponse.h"
 #import "RoutingConnection.h"
 #import "RoutingHTTPServer.h"
 #import "RuntimeReporter.h"
 #import "SDCloseButtonCell.h"
 #import "SDCommonAppDelegate.h"
 #import "SDDefines.h"
 #import "SDFoundation.h"
 #import "SDInsetDividerView.h"
 #import "SDInsetTextField.h"
 #import "SDInstructionsWindow.h"
 #import "SDInstructionsWindowController.h"
 #import "SDIsNotEmptyValueTransformer.h"
 #import "SDNextRunloopProxy.h"
 #import "SDOpenAtLoginController.h"
 #import "SDPreferencesController.h"
 #import "SDRoundedInstructionsImageView.h"
 #import "SDSingleton.h"
 #import "SDToolkit.h"
 #import "SDWindowController.h"
 #import "SIAppCookieJar.h"
 #import "SIAuthController.h"
 #import "SIConstants.h"
 #import "SIInboxDownloader.h"
 #import "SIInboxModel.h"
 #import "SIViewControllers.h"
 #import "SIWindow.h"
 #import "SNRHUDButtonCell.h"
 #import "SNRHUDScrollView.h"
 #import "SNRHUDSegmentedCell.h"
 #import "SNRHUDTextFieldCell.h"
 #import "SNRHUDTextView.h"
 #import "SNRHUDWindow.h"
 #import "StandardPaths.h"
 #import "StarLayer.h"

 #import "StickyNoteView.h"
 #import "Transition.h"
 #import "TransparentWindow.h"
 #import "TUIView+Dimensions.h"
 #import "WebFetcher.h"
 #import "WebSocket.h"
 #import "WebView+AtoZ.h"
 #import "XLDragDropView.h"

#import "AtoZ.h"
*/ 
 

/*
#import "AtoZFunctions.h"
#import "BaseModel.h"
#import "BaseModel+AtoZ.h"
//#import "AtoZ.h"
#import "SNRHUDButtonCell.h"
#import "SNRHUDImageCell.h"
#import "SNRHUDScrollView.h"
#import "SNRHUDSegmentedCell.h"
#import "SNRHUDTextFieldCell.h"
#import "SNRHUDTextView.h"
#import "SNRHUDWindow.h"

#import "NSObject+AutoMagicCoding.h"
#import "AZSizer.h"
#import "AZObject.h"
#import "AZFile.h"
#import "AZGeometry.h"
#import "Nu.h"

#define NSLog(__VA_ARGS__) NSLog(@"[%s:%d]: %@", __FILE__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
	#define NSLog(args...) QuietLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args)
#define NSLog(...) qlog(format,...) {\
#else
# define NSLog(…) 
#endif

#define NSLog(...) NSLog(__VA_ARGS__) {\
va_list argList;\
va_start(argList, format);\
NSString *file = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
printf("%s:%d - ", [file UTF8String], __LINE__); \
QuietLog((format),##__VA_ARGS__); \
}

if (format == nil) {	printf("nil\n"); return; }\
va_list argList;\
va_start(argList, format);\
NSString *s = [NSString.alloc initWithFormat:format arguments:argList];\
printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);\
[s release];\
va_end(argList);\
}

{ \
NSString *file = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
printf("%s:%d - ", [file UTF8String], __LINE__); \
QuietLog((format),##__VA_ARGS__); \
}
	#define NSLog(format,...) { \
	NSString *file = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
	printf("%s:%d - ", [file UTF8String], __LINE__); \
	QuietLog((format),##__VA_ARGS__);	}
#endif
static inline BOOL isEmpty(id thing);
	return thing ?: [thing respondsToSelector:@selector(length)] && [ (NSD*)thing length]
				 ?: [thing respondsToSelector:@selector(count) ] && [ (NSA*)thing count ]
					NO;
}

 StringConsts.h
#ifdef SYNTHESIZE_CONSTS
# define STR_CONST(name, value) NSString* const name = @ value
#else
# define STR_CONST(name, value) extern NSString* const name
#endif

The in my .h/.m pair where I want to define the constant I do the following:
 myfile.h
#import <StringConsts.h>
STR_CONST(MyConst, "Lorem Ipsum");
STR_CONST(MyOtherConst, "Hello world");
 myfile.m
#define SYNTHESIZE_CONSTS
#import "myfile.h"
#undef SYNTHESIZE_CONSTS



*/


/*
@interface NSColor (AIColorAdditions_HLS) Linearly adjust a color
- (NSC*)adjustHue:(CGFloat)dHue saturation:(CGFloat)dSat brightness:(CGFloat)dBrit;
@end


@implementation NSColor (AIColorAdditions_RepresentingColors)
- (NSString*)hexString
{
	CGFloat 	red,green,blue;
	char	hexString[7];
	NSInteger		tempNum;
	NSColor	*convertedColor;
	convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	[convertedColor getRed:&red green:&green blue:&blue alpha:NULL];
	tempNum = (red * 255.0f);
	hexString[0] = intToHex(tempNum / 16);
	hexString[1] = intToHex(tempNum % 16);
	tempNum = (green * 255.0f);
	hexString[2] = intToHex(tempNum / 16);
	hexString[3] = intToHex(tempNum % 16);
	tempNum = (blue * 255.0f);
	hexString[4] = intToHex(tempNum / 16);
	hexString[5] = intToHex(tempNum % 16);
	hexString[6] = '\0';
	return [NSString stringWithUTF8String:hexString];
}
//String representation: R,G,B[,A].
- (NSString*)stringRepresentation
{
	NSColor	*tempColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat alphaComponent = [tempColor alphaComponent];
	if (alphaComponent == 1.0)	{
		return [NSString stringWithFormat:@"%d,%d,%d",
			(int)([tempColor redComponent] * 255.0),
			(int)([tempColor greenComponent] * 255.0),
			(int)([tempColor blueComponent] * 255.0)];
	} else {
		return [NSString stringWithFormat:@"%d,%d,%d,%d",
			(int)([tempColor redComponent] * 255.0),
			(int)([tempColor greenComponent] * 255.0),
			(int)([tempColor blueComponent] * 255.0),
			(int)(alphaComponent * 255.0)];
	}
}
//- (NSString*)CSSRepresentation
//{
//	CGFloat alpha = [self alphaComponent];
//	if ( (1.0 - alpha)	>= 0.000001)	{
//		NSColor *rgb = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
//		//CSS3 defines rgba()	to take 0..255 for the color components, but 0..1 for the alpha component. Thus, we must multiply by 255 for the color components, but not for the alpha component.
//		return [NSString stringWithFormat:@"rgba(%@,%@,%@,%@)",
//			[NSString stringWithCGFloat:[rgb redComponent]   * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:[rgb greenComponent] * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:[rgb blueComponent]  * 255.0f maxDigits:6],
//			[NSString stringWithCGFloat:alpha						 maxDigits:6]];
//	} else {
//		return [@"#" stringByAppendingString:[self hexString]];
//	}
//}
@end
@implementation NSString (AIColorAdditions_RepresentingColors)
- (NSC*)representedColor
{
	CGFloat	r = 255, g = 255, b = 255;
	CGFloat	a = 255;
	const char *selfUTF8 = [self UTF8String];
	//format: r,g,b[,a]
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8))	goto scanFailed;
	r = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if(*selfUTF8 == ',')	++selfUTF8;
	else				 goto scanFailed;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	g = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if(*selfUTF8 == ',')	++selfUTF8;
	else				 goto scanFailed;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	b = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 == ',')	{
		++selfUTF8;
		a = (CGFloat)strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
		if (*selfUTF8)	goto scanFailed;
	} else if (*selfUTF8 != '\0')	{
		goto scanFailed;
	}
	return [NSColor colorWithCalibratedRed:(r/255)	green:(g/255)	blue:(b/255)	alpha:(a/255)] ;
scanFailed:
	return nil;
}
- (NSC*)representedColorWithAlpha:(CGFloat)alpha
{
	//this is the same as above, but the alpha component is overridden.
  NSUInteger	r, g, b;
	const char *selfUTF8 = [self UTF8String];
	//format: r,g,b
	//all components are decimal numbers 0..255.
	if (!isdigit(*selfUTF8))	goto scanFailed;
	r = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 != ',')	goto scanFailed;
	++selfUTF8;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	g = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	if (*selfUTF8 != ',')	goto scanFailed;
	++selfUTF8;
	if (!isdigit(*selfUTF8))	goto scanFailed;
	b = strtoul(selfUTF8, (char **)&selfUTF8, / * base * / 10);
	return [NSColor colorWithCalibratedRed:(r/255)	green:(g/255)	blue:(b/255)	alpha:alpha];
scanFailed:
	return nil;
}
@end
@implementation NSColor (AIColorAdditions_RandomColor)
+ (NSC*)randomColor
{
	return [NSColor colorWithCalibratedRed:(arc4random()	% 65536)	/ 65536.0f
									 green:(arc4random()	% 65536)	/ 65536.0f
									  blue:(arc4random()	% 65536)	/ 65536.0f
									 alpha:1.0f];
}
+ (NSC*)randomColorWithAlpha
{
	return [NSColor colorWithCalibratedRed:(arc4random()	% 65536)	/ 65536.0f
									 green:(arc4random()	% 65536)	/ 65536.0f
									  blue:(arc4random()	% 65536)	/ 65536.0f
									 alpha:(arc4random()	% 65536)	/ 65536.0f];
}
@end
@implementation NSColor (AIColorAdditions_HTMLSVGCSSColors)
//+ (id)colorWithHTMLString:(NSString*)str
//{
//	return [self colorWithHTMLString:str defaultColor:nil];
//}
/ * !
 * @brief Convert one or two hex characters to a float
 *
 * @param firstChar The first hex character
 * @param secondChar The second hex character, or 0x0 if only one character is to be used
 * @result The float value. Returns 0 as a bailout value if firstChar or secondChar are not valid hexadecimal characters ([0-9]|[A-F]|[a-f]). Also returns 0 if firstChar and secondChar equal 0.
 * /
static CGFloat hexCharsToFloat(char firstChar, char secondChar)
{
	CGFloat				hexValue;
	NSUInteger		firstDigit;
	firstDigit = hexToInt(firstChar);
	if (firstDigit != -1)	{
		hexValue = firstDigit;
		if (secondChar != 0x0)	{
			int secondDigit = hexToInt(secondChar);
			if (secondDigit != -1)
				hexValue = (hexValue * 16.0f + secondDigit)	/ 255.0f;
			else
				hexValue = 0;
		} else {
			hexValue /= 15.0f;
		}
	} else {
		hexValue = 0;
	}
	return hexValue;
}

+ (id)colorWithHTMLString:(NSString*)str defaultColor:(NSC*)defaultColor
{
	if (!str)	return defaultColor;
	NSUInteger strLength = [str length];
	NSString *colorValue = str;
	if ([str hasPrefix:@"rgb"])	{
		NSUInteger leftParIndex = [colorValue rangeOfString:@"("].location;
		NSUInteger rightParIndex = [colorValue rangeOfString:@")"].location;
		if (leftParIndex == NSNotFound || rightParIndex == NSNotFound)
		{
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with unrecognised color function (str is %@); returning %@", str, defaultColor);
			return defaultColor;
		}
		leftParIndex++;
		NSRange substrRange = NSMakeRange(leftParIndex, rightParIndex - leftParIndex);
		colorValue = [colorValue substringWithRange:substrRange];
		NSArray *colorComponents = [colorValue componentsSeparatedByString:@","];
		if ([colorComponents count] < 3 || [colorComponents count] > 4)	{
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with a color function with the wrong number of arguments (str is %@); returning %@", str, defaultColor);
			return defaultColor;
		}
		float red, green, blue, alpha = 1.0f;
		red = [[colorComponents objectAtIndex:0] floatValue];
		green = [[colorComponents objectAtIndex:1] floatValue];
		blue = [[colorComponents objectAtIndex:2] floatValue];
		if ([colorComponents count] == 4)
			alpha = [[colorComponents objectAtIndex:3] floatValue];
		return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
	}
	if ((!strLength)	|| ([str characterAtIndex:0] != '#'))	{
		//look it up; it's a colour name
		NSDictionary *colorValues = [self colorNamesDictionary];
		colorValue = [colorValues objectForKey:str];
		if (!colorValue)	colorValue = [colorValues objectForKey:[str lowercaseString]];
		if (!colorValue)	{
#if COLOR_DEBUG
			NSLog(@"+[NSColor(AIColorAdditions)	colorWithHTMLString:] called with unrecognised color name (str is %@); returning %@", str, defaultColor);
#endif
			return defaultColor;
		}
	}
	//we need room for at least 9 characters (#00ff00ff)	plus the NUL terminator.
	//this array is 12 bytes long because I like multiples of four. ;)
	enum { hexStringArrayLength = 12 };
	size_t hexStringLength = 0;
	char hexStringArray[hexStringArrayLength] = { 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0, };
	{
		NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
		hexStringLength = [stringData length];
		//subtract 1 because we don't want to overwrite that last NUL.
		memcpy(hexStringArray, [stringData bytes], MIN(hexStringLength, hexStringArrayLength - 1));
	}
	const char *hexString = hexStringArray;
	CGFloat		red,green,blue;
	CGFloat		alpha = 1.0f;
	//skip # if present.
	if (*hexString == '#')	{
		++hexString;
		--hexStringLength;
	}
	if (hexStringLength < 3)	{
#if COLOR_DEBUG
		NSLog(@"+[%@ colorWithHTMLString:] called with a string that cannot possibly be a hexadecimal color specification (e.g. #ff0000, #00b, #cc08)	(string: %@ input: %@); returning %@", NSStringFromClass(self), colorValue, str, defaultColor);
#endif
		return defaultColor;
	}
	//long specification:  #rrggbb[aa]
	//short specification: #rgb[a]
	//e.g. these all specify pure opaque blue: #0000ff #00f #0000ffff #00ff
	BOOL isLong = hexStringLength > 4;
	//for a long component c = 'xy':
	//	c = (x * 0x10 + y)	/ 0xff
	//for a short component c = 'x':
	//	c = x / 0xf
	char firstChar, secondChar;
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	red = hexCharsToFloat(firstChar, secondChar);
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	green = hexCharsToFloat(firstChar, secondChar);
	firstChar = *(hexString++);
	secondChar = (isLong ? *(hexString++)	: 0x0);
	blue = hexCharsToFloat(firstChar, secondChar);
	if (*hexString)	{
		//we still have one more component to go: this is alpha.
		//without this component, alpha defaults to 1.0 (see initialiser above).
		firstChar = *(hexString++);
		secondChar = (isLong ? *hexString : 0x0);
		alpha = hexCharsToFloat(firstChar, secondChar);
	}
	return [self colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

@end
@implementation NSColor (AIColorAdditions_ObjectColor)
+ (NSString*)representedColorForObject: (id)anObject withValidColors: (NSA*)validColors;
@end

*/
