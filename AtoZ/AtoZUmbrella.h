#import "AtoZMacroDefines.h"

#pragma mark 														- GLOBAL CONSTANTS
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
#define				 NSINV   NSInvocation
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
*/
/*
//#define CACcWA CAConstraint constraintWithAttribute
#define AZConstraint(attrb,rel)		[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb]
#define AZConst(attrb,rel)				[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb]
#define AZConstScaleOff(attrb,rel,scl,off)	[CAConstraint constraintWithAttribute:attrb relativeTo:rel attribute:attrb scale:scl offset:off]
#define AZConstRelSuper(attrb)		[CAConstraint constraintWithAttribute:attrb relativeTo:AZSuperLayerSuper attribute:attrb]
#define AZConstRelSuperScaleOff (att,scl,off) [CAConstraint constraintWithAttribute:att relativeTo:AZSuperLayerSuper attribute:att scale:scl offset:off]
#define AZConstAttrRelNameAttrScaleOff ( attr1, relName, attr2, scl, off) [CAConstraint constraintWithAttribute:attr1 relativeTo:relName attribute:attr2 scale:scl offset:off]
*/
#pragma mark - VIEWS

#define 		  NSSIZEABLE 	NSViewHeightSizable | NSViewWidthSizable
#define 				  pBCN 	postsBoundsChangedNotifications
#define 				  pFCN 	postsFrameChangedNotifications


#pragma mark - STRINGS

#define sepByCharsInSet componentsSeparatedByCharactersInSet
#define sepByString componentsSeparatedByString
#define sansLast arrayByRemovingLastObject


#define 				  vFKP 	valueForKeyPath
#define 					vFK 	valueForKey
#define 					 pV 	pointValue
#define 					 rV	rectValue
#define 					 fV	floatValue
#define 				  rngV	rangeValue

#define 		 NSZeroRange 	NSMakeRange(0,0)

#define 				setPBCN 	setPostsBoundsChangedNotifications:YES
#define 				setPFCN 	setPostsFrameChangedNotifications:YES
#define 					pBCN 	postsBoundsChangedNotifications
#define 					pFCN 	postsFrameChangedNotifications

#define  NSKVOBEFOREAFTER	NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
#define            KVONEW 	NSKeyValueObservingOptionNew
#define 				 KVOOLD 	NSKeyValueObservingOptionOld

#define  NSEVENTLOCALMASK 	NSEvent addLocalMonitorForEventsMatchingMask
#define NSEVENTGLOBALMASK 	NSEvent addGlobalMonitorForEventsMatchingMask

#define         MOUSEDRAG 	NSLeftMouseDraggedMask
#define 			   MOUSEUP 	NSLeftMouseUpMask
#define 			 MOUSEDOWN	NSLeftMouseDownMask
#define MOUSEDRAGGING MOUSEDOWN | MOUSEDRAG | MOUSEUP

#define FUTURE NSDate.distantFuture

#define  	AZFWORKBUNDLE	[NSBundle bundleForClass:AtoZ.class]
#define  	AZFWRESOURCES 	[AZFWORKBUNDLE resourcePath]
#define    	  AZAPPBUNDLE 	NSBundle.mainBundle
#define 	  AZAPPRESOURCES 	[NSBundle.mainBundle resourcePath]

#define 	  CAMEDIAEASEOUT 	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
#define  	CAMEDIAEASEIN 	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
#define    	  CAMEDIAEASY 	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
#define    	  AZWORKSPACE 	NSWorkspace.sharedWorkspace
#define 	    AZCOLORPANEL 	NSColorPanel.sharedColorPanel
#define     	AZUSERDEFS 	NSUserDefaults.standardUserDefaults
#define  	AZUSERDEFSCTR 	NSUserDefaultsController.sharedUserDefaultsController
#define    	  AZNOTCENTER 	(NSNotificationCenter*)NSNotificationCenter.defaultCenter
#define  	AZFILEMANAGER 	NSFileManager.defaultManager
#define  	AZGRAPHICSCTX 	NSGraphicsContext.currentContext
#define   	 AZCURRENTCTX 	AZGRAPHICSCTX
#define   	 AZQTZCONTEXT 	[NSGraphicsContext.currentContext graphicsPort]
#define    	  AZSHAREDAPP 	NSApplication.sharedApplication
#define     	AZWEBPREFS 	WebPreferences.standardPreferences
#define     	AZPROCINFO 	NSProcessInfo.processInfo
#define     	AZPROCNAME 	[NSProcessInfo.processInfo processName]
#define 		 	 AZNEWPIPE 	NSPipe.pipe
#define 			AZNEWMUTEA 	NSMutableArray.array
#define 			AZNEWMUTED 	NSMutableDictionary.new
#define 	 	  AZSHAREDLOG DDTTYLogger.sharedInstance

#define AZSTRONGSTRING(A) @property (nonatomic, strong) NSString* A
#define AZPROP(A,B) @property (nonatomic, strong) A* B
#define AZPROPASS(A,B) @property (NATOM,ASS) A B
#define AZPROPIBO(A,B) @property (ASS) IBOutlet A *B

//#define PROPSTRONG (@property (nonatomic,strong) )
//#define PROPASSIGN (@property (nonatomic,assign) )

#define	 USF unsafe_unretained
#define UNSFE unsafe_unretained
//#define STRONG ((nonatomic,strong) )
//#define ASSIGN ((nonatomic,assign) )
#define AZWindowPositionToString AZAlignToString
#define CGSUPRESSINTERVAL(x) CGEventSourceSetLocalEventsSuppressionInterval(nil,x)
#define AZPOS AZA// AZWindowPosition
//
#define AZCLSSTR NSStringFromClass ( [self class] )
#define AZSSOQ AZSharedSingleOperationQueue()
#define AZSOQ AZSharedOperationQueue()
#define AZOS AZSharedOperationStack()

#define AZNULL [NSNull null]
#define ELSENULL ?: [NSNull null]
#define AZGView AtoZGridView
#define AZGVItem AtoZGridViewItem

#define AZPAL AZPalette
#define AZIS AZInstallationStatus


#define performDelegateSelector(sel) if ([delegate respondsToSelector:sel]) { [delegate performSelector:sel]; }
#define performBlockIfDelegateRespondsToSelector(block, sel) if ([delegate respondsToSelector:sel]) { block(); }

#define AZBindSelector(observer,sel,keypath,obj) [AZNOTCENTER addObserver:observer selector:sel name:keypath object:obj]
#define AZBind(binder,binding,toObj,keyPath) [binder bind:binding toObject:toObj withKeyPath:keyPath options:nil]

//#define 	AZLAYOUTMGR 		[CAConstraintLayoutManager layoutManager]
//#define  AZTALK	 (log) 	[AZTalker.new say:log]
//#define  AZBezPath (r) 		[NSBezierPath bezierPathWithRect: r]
//#define  NSBezPath (r) 		AZBezPath(r)
//#define  AZQtzPath (r) 		[(AZBezPath(r)) quartzPath]

//#define AZContentBounds [[[ self window ] contentView] bounds]

#define  AZVinstall(p) 	[NSVAL valueWithInstallStatus: p]
#define  	AZVposi(p) 	[NSVAL      valueWithPosition: p]
#define 	  AZVpoint(p) 	[NSVAL 			valueWithPoint: p]
#define  	AZVrect(r) 	[NSVAL 			 valueWithRect: r]
#define  	AZVsize(s) 	[NSVAL 			 valueWithSize: s]
#define   	  AZV3d(t) 	[NSVAL valueWithCATransform3D: t]
#define   	 AZVclr(c) 	[NSVAL         valueWithColor: c]
#define   	 AZVrng(c) 	[NSVAL         valueWithRange: c]


#define 						kContentTitleKey @"itemTitle"
#define 						kContentColorKey @"itemColor"
#define 						kContentImageKey @"itemImage"
#define 						kItemSizeSliderPositionKey @"ItemSizeSliderPosition"

#define		AZTRACKALL 	(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved)
#define AZTArea(frame) 	[NSTA.alloc initWithRect:frame options:AZTRACKALL owner:self userInfo:nil]
//
//#define AZTAreaInfo(frame,info) [NSTA.alloc initWithRect: frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved ) owner:self userInfo:info];

#pragma mark - COLORS

//#define REDGRAD  		[NSG.alloc initWithColorsAndLocations: [NSColor colorWithDeviceRed:241/255 green:152/255 blue:139/255 alpha:1.0], 0,\
//							 [NSColor colorWithDeviceRed:	 228/255 green:116/255 blue:102/255 alpha:1.0], 0,\
//							 [NSColor colorWithCalibratedRed:192/255 green:86/255 blue:73/255 alpha:1.0], 1, nil]
//#define ORANGEGRAD 	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithDeviceRed:248/255 green:201/255 blue:148/255 alpha:1.0], 0,\
//[NSColor colorWithDeviceRed:237/255 green:174/255 blue:107/255 alpha:1.0], .5,\
//[NSColor colorWithCalibratedRed:210/255 green:143/255 blue:77/255 alpha:1.0], 1, nil];
//#define YELLOWGRAD 	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithDeviceRed:240/255 green:229/255 blue:164/255 alpha:1.0], 0,\
//[NSColor colorWithDeviceRed:227/255 green:213/255 blue:119/255 alpha:1.0], .5,\
//[NSColor colorWithCalibratedRed:201/255 green:188/255 blue:92/255 alpha:1.0], 1.0, nil];
//#define GREENGRAD  	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithDeviceRed:209/255 green:236/255 blue:156/255 alpha:1.0], 0.0,\
//[NSColor colorWithDeviceRed:175/255 green:215/255 blue:119/255 alpha:1.0], 0.5,\
//[NSColor colorWithCalibratedRed:142/255 green:182/255 blue:102/255 alpha:1.0], 1.0, nil];
//#define BLUEGRAD  	[NSG.alloc initWithColorsAndLocations: [NSColor colorWithDeviceRed:165/255 green:216/255 blue:249/255 alpha:1], 0,\
//[NSColor colorWithDeviceRed:118/255 green:185/255 blue:232/255 alpha:1.0], 0.5,\
//[NSColor colorWithCalibratedRed:90/255 green:152/255 blue:201/255 alpha:1.0], 1.0, nil];
//#define PURPLEGRAD  	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithDeviceRed:232/255 green:191/255 blue:248/255 alpha:1.0], 0,\
//[NSColor colorWithDeviceRed:202/255 green:152/255 blue:224/255 alpha:1.0], 0.5,\
//[NSColor colorWithCalibratedRed:163/255 green:121/255 blue:186/255 alpha:1.0], 1.0, nil];
//#define GRAYGRAD  	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:212/255 alpha:1.0], 0.0,\
//[NSColor colorWithCalibratedWhite:182/255 alpha:1.0], 0.5,\
//[NSColor colorWithCalibratedWhite:151/255 alpha:1.0], 1.0, nil];

#define PERIWINKLE [NSColor colorWithDeviceRed:.79 green:.78 blue:.9 alpha:1]

//#define STANDARDCOLORS = @[REDORANGE,YELLOW,GREEN,BLUE,PURPLE,GRAY]

#define RED							  [NSC  r:0.797 g:0.000 b:0.043 a:1.]
#define ORANGE						  [NSC  r:0.888 g:0.492 b:0.000 a:1.]
#define YELLOw						  [NSC  r:0.830 g:0.801 b:0.277 a:1.]
#define YELLOW						  [NSC  r:0.830 g:0.801 b:0.277 a:1.]
#define GREEN						  [NSC  r:0.367 g:0.583 b:0.179 a:1.]
#define BLUE						  [NSC  r:0.267 g:0.683 b:0.979 a:1.]
#define PURPLE						  [NSC  r:0.617 g:0.125 b:0.628 a:1.]
#define PINK						  [NSC  r:1.000 g:0.228 b:0.623 a:1.]
#define RANDOMGRAY 				  [NSC white:RAND_FLOAT_VAL(0,1) a:1]
#define RANDOMCOLOR				  [NSC   randomColor]
#define RANDOMPAL				  	  [NSC randomPalette]
#define BLACK						  [NSC    blackColor]
#define GREY						  [NSC     grayColor]
#define WHITE						  [NSC    whiteColor]
#define CLEAR						  [NSC    clearColor]
#define LGRAY						  [NSC white:.5 a:.6]
#define GRAY1						  [NSC white:.1 a: 1]
#define GRAY2						  [NSC white:.2 a: 1]
#define GRAY3						  [NSC white:.3 a: 1]
#define GRAY4						  [NSC white:.4 a: 1]
#define GRAY5						  [NSC white:.5 a: 1]
#define GRAY6						  [NSC white:.6 a: 1]
#define GRAY7						  [NSC white:.7 a: 1]
#define GRAY8						  [NSC white:.8 a: 1]
#define GRAY9						  [NSC white:.9 a: 1]

#define cgRED			   		  RED.CGColor
#define cgORANGE				  ORANGE.CGColor
#define cgYELLOW				  YELLOW.CGColor
#define cgGREEN		 			GREEN.CGColor
#define cgPURPLE				  PURPLE.CGColor
#define cgRANDOMCOLOR	RANDOMCOLOR.CGColor
#define cgBLUE		 				 BLUE.CGColor
#define cgBLACK				   BLACK.CGColor
#define cgGREY						 GREY.CGColor
#define cgWHITE					WHITE.CGColor
#define cgCLEARCOLOR		      CLEAR.CGColor

#define cgRANDOMGRAY 			CGColorCreateGenericGray( RAND_FLOAT_VAL(0,1), 1)
#define 	kBlackColor 			cgBLACK
#define 	kWhiteColor 			cgWHITE

#define CGSHADOW(A) 				CGColorCreate( kCGColorSpaceGenericGray, {0.0, 0.0, A})

#define 	kTranslucentGrayColor CGColorCreate( kCGColorSpaceGenericGray, {0.0, 0.5, 1.0})
#define 	kTranslucentLightGrayColor cgGREY
#define	kAlmostInvisibleWhiteColor CGColorCreate( kCGColorSpaceGenericGray, {1, 0.05, 1.0})

#define NOISY(C)   				  [C colorWithNoiseWithOpacity:.2 andBlendMode:kCGBlendModeMultiply]
#define RANDOMNOISYCOLOR  		   NOISY(RANDOMCOLOR)

#define LINEN 					     [NSColor linen]
#define RANDOMLINEN 				  [NSC linenTintedWithColor:RANDOMCOLOR]
#define CHECKERS 					  [NSC checkerboardWithFirstColor: BLACK secondColor: WHITE squareWidth:25]

#define clr colorLogString


#define REDGRAD  		[NSG.alloc initWithColorsAndLocations: [NSColor colorWithDeviceRed:241./255. green:152./255. blue:139./255. alpha:1.0], 0.0,\
							[NSColor colorWithDeviceRed:	 228./255. green:116./255. blue:102./255. alpha:1.0], 0.5,\
							[NSColor colorWithCalibratedRed:192./255. green:86./255. blue:73./255. alpha:1.0], 1.0, nil]

#define ORANGEGRAD 	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithDeviceRed:248./255. green:201./255. blue:148./255. alpha:1.0], 0.0,\
							[NSColor colorWithDeviceRed:237./255. green:174./255. blue:107./255. alpha:1.0], 0.5,\
							[NSColor colorWithCalibratedRed:210./255. green:143./255. blue:77./255. alpha:1.0], 1.0, nil]

#define YELLOWGRAD 	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithDeviceRed:240./255. green:229./255. blue:164./255. alpha:1.0], 0.0,\
							[NSColor colorWithDeviceRed:227./255. green:213./255. blue:119./255. alpha:1.0], 0.5,\
							[NSColor colorWithCalibratedRed:201./255. green:188./255. blue:92./255. alpha:1.0], 1.0, nil]

#define GREENGRAD  	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithDeviceRed:209./255. green:236./255. blue:156./255. alpha:1.0], 0.0,\
							[NSColor colorWithDeviceRed:175./255. green:215./255. blue:119./255. alpha:1.0], 0.5,\
							[NSColor colorWithCalibratedRed:142./255. green:182./255. blue:102./255. alpha:1.0], 1.0, nil]

#define BLUEGRAD  	[NSG.alloc initWithColorsAndLocations: [NSColor colorWithDeviceRed:165./255. green:216./255. blue:249./255. alpha:1.], 0.0,\
							[NSColor colorWithDeviceRed:118./255. green:185./255. blue:232./255. alpha:1.0], 0.5,\
							[NSColor colorWithCalibratedRed:90./255. green:152./255. blue:201./255. alpha:1.0], 1.0, nil]

#define PURPLEGRAD  	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithDeviceRed:232./255. green:191./255. blue:248./255. alpha:1.0], 0.0,\
							[NSColor colorWithDeviceRed:202./255. green:152./255. blue:224/255. alpha:1.0], 0.5,\
							[NSColor colorWithCalibratedRed:163./255. green:121./255. blue:186./255. alpha:1.0], 1.0, nil]

#define GRAYGRAD  	[NSG.alloc initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:212./255. alpha:1.0], 0.0,\
							[NSColor colorWithCalibratedWhite:182./255. alpha:1.0], 0.5,\
							[NSColor colorWithCalibratedWhite:151./255. alpha:1.0], 1.0, nil]


#pragma mark - FUNCTION defines


#define REQ RouteRequest
#define RES RouteResponse
#define $SHORT(A,B) [Shortcut.alloc initWithURI:A syntax:B]

#define LOCALIZED_STRING(key) [[NSBundle bundleForClass:[AtoZ class]]localizedStringForKey:(key) value:@"" table:nil]
/* You cannot take the address of a return value like that, only a variable. Thus, you’d have to put the result in a temporary variable:
 The way to get around this problem is use another GCC extension allowing statements in expressions. Thus, the macro creates a temporary variable, _Y_, with the same type of _X_ (again using typeof) and passes the address of this temporary to the function.
 http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
 */
#define zNL @"\n"
#define zTAB @"\t"
#define zSPC @" "

//1 #define LOG_EXPR(_X_) do{\
//2 	__typeof__(_X_) _Y_ = (_X_);\
//3 	const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
//4 	NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
//5 	if(_STR_)\
//6 		NSLog(@"%s = %@", #_X_, _STR_);\
//7 	else\
//8 		NSLog(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
//9 }while(0)

//NSString * AZToStringFromTypeAndValue(const char * typeCode, void * value);
#define AZString(_X_) (	{	typeof(_X_) _Y_ = (_X_);\
AZToStringFromTypeAndValue(@encode(typeof(_X_)), &_Y_);})

//	NSLog(@"%@", StringFromBOOL(ISATYPE	( ( @"Hello", NSString)));   // DOESNT WORK
//	NSLog(@"%@", StringFromBOOL(ISATYPE	( ( (NSR){0,1,1,2} ), NSRect)));   // YES
//	NSLog(@"%@", StringFromBOOL(ISATYPE	( ( (NSR){0,1,1,2} ), NSRange)));  // NO
#define 	ISATYPE(_a_,_b_)  SameChar( @encode(typeof(_a_)), @encode(_b_) )

//	NSRect rect = (NSR){0,0,1,1};				
//		NSRange rng = NSMakeRange(0, 11);	
//			CGR cgr = CGRectMake (0,1,2,4);			
//				NSS *str = @"d";
//	SAMETYPE(cgr, rect);  YES		SAMETYPE(cgr,  rng);	 NO		SAMETYPE(rect, str);  NO		SAMETYPE(str, str);   YES

#define 	SAMETYPE(_a_,_b_)  SameChar( @encode(typeof(_a_)), @encode(typeof(_b_)) )

#pragma mark - MACROS

//#define check(x)		if (!(x)) return 0;

//#define loMismo isEqualToString

#define AZTEMPD 					NSTemporaryDirectory()
#define CLSSBNDL					[NSBundle bundleForClass:[self class]]
#define AZBUNDLE					[NSBundle bundleForClass:[AtoZ class]]
#define APP_NAME 					[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"]
#define APP_VERSION 				[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"]
#define OPEN_URL(urlString) 	[NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:urlString]]



/* Retrieving preference values */

#define PREF_KEY_VALUE(x) 			[[NSUserDefaultsController.sharedUserDefaultsController values] valueForKey:(x)]
#define PREF_KEY_BOOL(x) 			[(PREF_KEY_VALUE(x)) boolValue]
#define PREF_SET_KEY_VALUE(x, y) [[NSUserDefaultsController.sharedUserDefaultsController values] setValue:(y) forKey:(x)]
#define PREF_OBSERVE_VALUE(x, y) [NSUserDefaultsController.sharedUserDefaultsController addObserver:y forKeyPath:x\ 																						options:NSKeyValueObservingOptionOld context:nil]

/* key, observer, object */
#define OB_OBSERVE_VALUE(x, y, z) 	[(z) addObserver:y forKeyPath:x options:NSKeyValueObservingOptionOld context:nil];

#define AZLocalizedString(key) NSLocalizedStringFromTableInBundle(key,nil,AZBUNDLE,nil)

//#define AZLocalizedString(key, comment) NSLocalizedStringFromTableInBundle((key)nil, [NSBundle bundleWithIdentifier:AZBUNDLE,(comment))

//Usage:
//AZLocalizedString(@"ZeebaGreeting", @"Huluu zeeba")
//+ (NSString*)typeStringForType:(IngredientType)_type {
//	NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type];
//	return NSLocalizedString(key, nil);
//}

//typedef ((NSTask*)(^launchMonitorReturnTask) NSTask* task);
//typedef (^TaskBlock);
//#define AZLAUNCHMONITORRETURNTASK(A) ((NSTask*)(^launchMonitorReturnTask)(A))
// ^{ [A launch]; monitorTask(A); return A; }()


#define NEG(a) -a
#define HALF(a) (a / 2.0)

//#define MAX(a, b) ((a) > (b) ? (a) : (b))
//#define MIN(a, b) ((a) < (b) ? (a) : (b))

#define StringFromBOOL(b) (b?@"YES":@"NO")

//#define YESNO ( b )		  ( (b) ? @"YES" : @"NO" )
//#define YESNO ( b )	b ? @"YES" : @"NO"

// degree to radians
#define 						ARAD	0.017453f
#define 			 	DEG2RAD(x) 	((x)*ARAD)
#define 					 P(x,y) 	CGPointMake(x, y)
#define 					 R(x,y) 	CGRectMake(0,0,x, y)
#define 					 S(w,h) 	NSMakeSize(w,h)
#define 					  TWOPI 	(2 * 3.1415926535)
#define 			 RAD2DEG(rad) 	(rad * 180.0f / M_PI)
#define 				  RAND01() 	((random() / (float)0x7fffffff ))					//	returns float in range 0 - 1.0f
										//usage RAND01()*3, or (int)RAND01()*3 , so there is no risk of dividing by zero
#pragma mark - arc4random()

#define 			RAND_UINT_MAX	0xFFFFFFFF
#define 			 RAND_INT_MAX	0x7FFFFFFF
#define 			  RAND_UINT()	arc4random()											// positive unsigned integer from 0 to RAND_UINT_MAX
#define 				RAND_INT()	((int)(arc4random() & 0x7FFFFFFF))				// positive unsigned integer from 0 to RAND_UINT_MAX
#define 	  RAND_INT_VAL(a,b)	((arc4random() % ((b)-(a)+1)) + (a))			// integer on the interval [a,b] (includes a and b)

#define 			 RAND_FLOAT()	(((float)arc4random()) / RAND_UINT_MAX)		// float between 0 and 1 (including 0 and 1)
#define 	RAND_FLOAT_VAL(a,b)	(((((float)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))
// float between a and b (including a and b)

// note: Random doubles will contain more precision than floats, but will NOT utilize the full precision of the double. They are still limited to the 32-bit precision of arc4random
#define 			RAND_DOUBLE()	(((double)arc4random()) / RAND_UINT_MAX)		// double betw. 0 & 1 (incl. 0 and 1)
#define RAND_DOUBLE_VAL(a,b)	(((((double)arc4random()) * ((b)-(a))) / RAND_UINT_MAX) + (a))// dbl btw. a and b (incl a and b)

#define RAND_BOOL()				(arc4random() & 1)									//	a random boolean (0 or 1)
#define RAND_DIRECTION()		(RAND_BOOL() ? 1 : -1)								// -1 or +1 (usage: int steps = 10*RAND_DIRECTION();  will get you -10 or 10)

//#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))
#define LIMIT( value, min, max )		(((value) < (min))? (min) : (((value) > (max))? (max) : (value))) // pinning a value between a lower and upper limit
#define	DEGREES_TO_RADIANS( d )		((d) * 0.0174532925199432958)				// converting from radians to degrees
#define 	RADIANS_TO_DEGREES( r )		((r) * 57.29577951308232)
#define 			  FIFTEEN_DEGREES		(0.261799387799)								// some useful angular constants
#define 				NINETY_DEGREES		(pi * 0.5)
#define 			FORTYFIVE_DEGREES		(pi * 0.25)
#define 						 HALF_PI		(pi * 0.5)


#define CLAMP(value, lowerBound, upperbound) MAX( lowerBound, MIN( upperbound, value ))

#define AZDistance(A,B) sqrtf(powf(fabs(A.x - B.x), 2.0f) + powf(fabs(A.y - B.y), 2.0f))
#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))



#define $point(A)	   	[NSValue valueWithPoint:A]
#define $points(A,B)	   	[NSValue valueWithPoint:CGPointMake(A,B)]
#define $rect(A,B,C,D)		[NSValue valueWithRect:CGRectMake(A,B,C,D)]

#define ptmake(A,B)			CGPointMake(A,B)stringByAppendingPathComponent

#define $URL(A)				((NSURL *)[NSURL URLWithString:A])
#define $SEL(A)				NSSelectorFromString(A)
#define AZStringFromSet(A) [NSS stringFromArray:A.allObjects]

//#define $#(A)				((NSString *)[NSString string
#define $(...)				((NSString*)[NSString stringWithFormat:__VA_ARGS__,nil])
#define $UTF8(A)			((NSString*)[NSS stringWithUTF8String:A])
#define $UTF8orNIL(A)	(A) ? ((NSString *)[NSS stringWithUTF8String:A]) : nil
#define $array(...)  	((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])
#define $set(...)		 	((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])
#define $map(...)	 		((NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil])
#define $int(A)	   	@(A) // [NSNumber numberWithInt:(A)]
#define $ints(...)			[NSArray arrayWithInts:__VA_ARGS__,NSNotFound]
#define $float(A)	 		[NSNumber numberWithFloat:(A)]
#define $doubles(...) 		[NSArray arrayWithDoubles:__VA_ARGS__,MAXFLOAT]
#define $words(...)   		[[@#__VA_ARGS__ splitByComma] trimmedStrings]


#define capped capitalizedString
#define INST instancetype

#define $ARRAYSET(A) [NSSet setWithArray:(A)]
#define $CG2NSC(A) [NSC colorWithCGColor:(A)]
//#define $concat(A,...) { A = [A arrayByAddingObjectsFromArray:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])]; }
// s stringByReplacingOccurrencesOfString:@"fff	" withString:@"%%%%"] )
//#define AZLOG(log,...) NSLog(@"%@", [log s stringByReplacingOccurrencesOfString:@"fff	" withString:@"%%%%"] )


#define VARNAME(x) $(@"%s",#x)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#pragma mark - General Functions

//#define NSDICT (...) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
//#define NSARRAY(...) [NSArray arrayWithObjects: __VA_ARGS__, nil]
//#define NSBOOL (_X_) [NSNumber numberWithBool:(_X_)]
//#define NSSET  (...) [NSSet setWithObjects: __VA_ARGS__, nil]

//#define NSCOLOR	   (r,g,b,a) [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a]
//#define NSDEVICECOLOR (r,g,b,a) [NSColor colorWithDeviceRed:r green:g blue:b alpha:a]
//#define NSCOLORHSB	(h,s,b,a) [NSColor colorWithDeviceHue:h saturation:s brightness:b alpha:a]


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
SC##_sharedInstance = [[SC alloc] init]; \
} \
return SC##_sharedInstance; \
}


#define foreach(B,A) A.andExecuteEnumeratorBlock = \
^(B, NSUInteger A##Index, BOOL *A##StopBlock)

//#define foreach(A,B,C) \
//A.andExecuteEnumeratorBlock = \
//  ^(B, NSUInteger C, BOOL *A##StopBlock)


/* 	KSVarArgs is a set of macros designed to make dealing with variable arguments	easier in Objective-C. All macros assume that the varargs list contains only objective-c objects or object-like structures (assignable to type id). The base macro ksva_iterate_list() iterates over the variable arguments, invoking a block for each argument, until it encounters a terminating nil. The other macros are for convenience when converting to common collections.
*/
/** 	Block type used by ksva_iterate_list.
 @param entry The current argument in the vararg list.	*/
typedef void (^AZVA_Block)(id entry);
typedef void (^AZVA_ArrayBlock)(NSArray* values);

/**	Iterate over a va_list, executing the specified code block for each entry.
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param BLOCK A code block of type KSVA_Block.	 */
#define azva_iterate_list(FIRST_ARG_NAME, BLOCK) { \
	AZVA_Block azva_block = BLOCK;	va_list azva_args	;	va_start(azva_args,FIRST_ARG_NAME );							 \
	for( id azva_arg = FIRST_ARG_NAME;	azva_arg != nil;  azva_arg = va_arg(azva_args, id ) )	azva_block(azva_arg); \
	va_end(azva_args); }

/***	Convert a variable argument list into array. An autorel. NSMA will be created in current scope w/ the specified name.
 @param FIRST_ARG_NAME The name of the first argument in the vararg list.
 @param ARRAY_NAME The name of the array to create in the current scope.	 */
#define azva_list_to_nsarray(FIRST_ARG_NAME, ARRAY_NAME) \
	NSMA* ARRAY_NAME = NSMA.new;  azva_iterate_list(FIRST_ARG_NAME, ^(id entry) { [ARRAY_NAME addObject:entry]; })

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


