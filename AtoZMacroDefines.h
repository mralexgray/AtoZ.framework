////@import Foundation;
//#import <Foundation/Foundation.h>
////@import QuartzCore;
//#import <QuartzCore/QuartzCore.h>
////@import ObjectiveC;
////@import Darwin;
/////@import Cocoa;
//@import SystemConfiguration;
//@import Dispatch;
//#import <Darwin/Darwin.h>
@import ObjectiveC;
@import Cocoa;
@import Dispatch;
@import SystemConfiguration;

//#import "NSColor+AtoZ.h"

//#import <WebKit/WebView.h>
//#import <Zangetsu/Zangetsu.h>

#pragma mark - COLORS
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
#define    RANDOMCOLOR ((NSC*)[NSC    randomColor])
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

#pragma mark - Foundation

#define   ACT id<CAAction>

#define   IDCAA (id<CAAction>)
#define     IBA IBAction
#define     SET NSSet
#define      CP copy
#define    NSPB NSPasteboard
#define     IBO IBOutlet
#define   RONLY readonly
#define    WORD definition
#define      WK weak
#define     GET getter
#define AZIDCAA (id<CAAction>)
#define   NATOM nonatomic
#define   prop_ property

#define   prop_NC property (nonatomic,copy)
#define   prop_NA property (nonatomic)
#define   prop_RO property (readonly)
#define   prop_CP  property (CP)
#define   prop_AS  property (ASS)
#define   prop_WK  property (WK)
#define   ASSGN assign
#define   RDWRT readwrite
#define     ASS assign
#define  IDDRAG id<NSDraggingInfo>
#define   STRNG strong
#define    IDCP id<NSCopying>
#define    prop property
#define    UNSF unsafe_unretained
#define     CPY copy
#define     STR strong

#pragma mark - Quartz

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

#pragma mark - STRINGS

#define                                        AZBezPath(r) [NSBezierPath bezierPathWithRect: r]
#define                                          AZNEWMUTEA NSMutableArray.array
#define                                    kContentImageKey @"itemImage"
#define                                               AZPAL AZPalette
#define                                                 USF unsafe_unretained
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
#define                                            AZCLSSTR NSStringFromClass ( [self class] )
#define                                              KVOOLD NSKeyValueObservingOptionOld
#define                                               UNSFE unsafe_unretained
#define                                          AZTRACKALL (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved)
#define                                        AZQTZCONTEXT [NSGraphicsContext.currentContext  graphicsPort]
#define                                      AZTArea(frame) [NSTA.alloc initWithRect:frame options:AZTRACKALL owner:self userInfo:nil]
#define                                       CAMEDIAEASEIN [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
#define                                                  rV rectValue
#define                                                 vFK valueForKey
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
#define                                      AZAPPRESOURCES [NSBundle.mainBundle resourcePath]
#define                                             MOUSEUP NSLeftMouseUpMask
#define                                                rngV rangeValue
#define                                        AZQtzPath(r) [(AZBezPath(r)) quartzPath]
#define                                                  fV floatValue
#define                                          AZWEBPREFS WebPreferences.standardPreferences
#define                                       AZUSERDEFSCTR NSUserDefaultsController.sharedUserDefaultsController
#define                                              AZNULL [NSNull  null]
#define            AZBindSelector(observer,sel,keypath,obj) [AZNOTCENTER  addObserver:observer selector:sel name:keypath object:obj]
#define                                           AZVrng(c) [NSVAL  valueWithRange: c]
#define                                       AZGRAPHICSCTX NSGraphicsContext.currentContext
#define                                              AZSSOQ AZSharedSingleOperationQueue()
#define                                           AZVclr(c) [NSVAL valueWithColor: c]
#define                                          AZVrect(r) [NSVAL		 valueWithRect: r]
#define                                     sepByCharsInSet componentsSeparatedByCharactersInSet
#define                                         AZAPPBUNDLE NSBundle.mainBundle
#define                                            sansLast arrayByRemovingLastObject
#define                                             AZGView AtoZGridView
#define                                         AZTALK(log) [AZTalker.new say:log]
#define                                      AZPROPIBO(A) @property (ASS) IBOutlet A      //QUOTE(A)
#define                AZBind(binder,binding,toObj,keyPath) [binder bind:binding toObject:toObj withKeyPath:keyPath options:nil]
#define                                           AZNEWPIPE NSPipe.pipe
#define                                          AZVsize(s) [NSVAL valueWithSize: s]
#define                                        NSBezPath(r) AZBezPath(r)
#define                                          AZUSERDEFS NSUserDefaults.standardUserDefaults
#define                                         CAMEDIAEASY [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
#define                                CGSUPRESSINTERVAL(x) CGEventSourceSetLocalEventsSuppressionInterval(nil,x)
#define                                         AZWORKSPACE NSWorkspace.sharedWorkspace
#define                                                pFCN postsFrameChangedNotifications
#define                                           MOUSEDOWN NSLeftMouseDownMask
#define                        performDelegateSelector(sel) if ([delegate respondsToSelector:sel]) { [delegate performSelector:sel]; }
#define                                        AZCOLORPANEL NSColorPanel.sharedColorPanel
#define                                         AZNOTCENTER (NSNotificationCenter*)NSNotificationCenter.defaultCenter
#define                                                  pV pointValue
#define                                         sepByString componentsSeparatedByString
#define                                         AZLAYOUTMGR [CAConstraintLayoutManager layoutManager]
#define                                         AZPROP(A,B) @property  (nonatomic, strong) A* B
#define                                                vFKP valueForKeyPath
#define                                    kContentColorKey @"itemColor"
#define                                     AZContentBounds [[[self window ] contentView] bounds]
#define                                      CAMEDIAEASEOUT [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
#define                                             setPBCN setPostsBoundsChangedNotifications:YES
#define                                               AZPOS AZA
#define                                        AZCURRENTCTX AZGRAPHICSCTX
#define                                             setPFCN setPostsFrameChangedNotifications:YES
#define                                       AZFILEMANAGER NSFileManager.defaultManager
#define                                              FUTURE NSDate.distantFuture
#define                                         NSZeroRange NSMakeRange(0,0)
#define                                                pBCN postsBoundsChangedNotifications
#define                                         AZVpoint(p) [NSVAL valueWithPoint: p]

#define                                           MOUSEDRAG NSLeftMouseDraggedMask
#define                                       AZFWORKBUNDLE [NSBundle bundleForClass:AtoZ.class]
#define iV integerValue
#define uiV unsignedIntegerValue

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
#define    VBLK VoidBlock
#define    VBLK VoidBlock

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

#pragma mark - NS

#define          NSPSC NSPersistentStoreCoordinator
#define          NSINV NSInvocation
#define          NSIMG NSImage
#define            NSB NSBundle
#define         NSTXTV NSTextView
#define           NSVT NSValueTransformer
#define            NSW NSWindow
#define           NSMS NSMutableString
#define          NSBIR NSBitmapImageRep
#define            NSC NSColor
#define           NSOV NSOutlineView
#define          NSNOT NSNotification
#define       NSSCLASS NSString.class
#define       NSACLASS NSArray.class
#define      NSPInRect NSPointInRect
#define        AZOQMAX NSOperationQueueDefaultMaxConcurrentOperationCount
#define            NSD NSDictionary
#define           NSAC NSArrayController
#define           NSUI NSUInteger
#define            NSE NSEvent
#define           NSMI NSMenuItem
#define           NSBP NSBezierPath
#define           NSRE NSRectEdge
#define            NSF NSFont
#define        NSMenuI NSMenuItem
#define            NSG NSGradient
#define        NSRFill NSRectFill
#define       NSURLREQ NSURLRequest
#define        NSSCRLV NSScrollView
#define           NSTI NSTimeInterval
#define          NSMOM NSManagedObjectModel
#define           NSIP NSIndexPath
#define           NSCS NSCountedSet
#define        NSCOMPR NSComparisonResult
#define           NSPO NSPopover
#define          NSBSB NSBackingStoreBuffered
#define         NSTABV NSTabView
#define         NSMSet NSMutableSet
#define            NSI NSInteger
#define         NSURLC NSURLConnection
#define    NSAorDCLASS @[NSArray.class, NSDictionary.class]
#define           NSWC NSWindowController
#define          NSCSV NSCellStateValue
#define           NSGC NSGraphicsContext
#define           NSST NSSet
#define           NSSI NSStatusItem
#define           NSJS NSJSONSerialization
#define           NSTV NSTableView
#define         NSTVDO NSTableViewDropOperation
#define           TMR NSTimer
#define           NSMA NSMutableArray
#define            SIG NSMethodSignature
#define      NSMURLREQ NSMutableURLRequest
#define         NSSHDW NSShadow
#define ISADICTorARRAY isKindOfAnyClass:NSAorDCLASS
#define          NSERR NSError
#define           NSVC NSViewController
#define           NSEM NSEventMask
#define           NSOP NSOperation
#define            NSM NSMenu
#define        NSMDATA NSMutableData
#define           NSIS NSIndexSet
#define          NSMOC NSManagedObjectContext
#define           NSAS NSAttributedString
#define           NSTA NSTrackingArea
#define         NSTXTF NSTextField
#define            NSN NSNumber
#define        NSBRWSR NSBrowser
#define           NSOQ NSOperationQueue
#define            NSO NSObject
#define        ISADICT isKindOfClass:NSDictionary.class
#define           NSAT NSAffineTransform
#define          NSMAS NSMutableAttributedString
#define           NSCL NSColorList
#define            NSP NSPoint
#define           NSMO NSManagedObject
#define           NSMD NSMutableDictionary
#define      ISANARRAY isKindOfClass:NSArray.class
#define          NSMPS NSMutableParagraphStyle
#define           NSED NSEntityDescription
#define          NSBLO NSBlockOperation
#define           NSTC NSTableColumn
#define       NSPUBUTT NSPopUpButton
    #define            NSR NSRect
    #define           NSPI NSProgressIndicator
    #define        NSSPLTV NSSplitView
    #define          NSTSK NSTask
    #define            NSS NSString
    #define           NSIV NSImageView
    #define          NSBWM NSBorderlessWindowMask
    #define           NSDO NSDragOperation
    #define         NSSEGC NSSegmentedControl
    #define            NST NSTimer
    #define          NSRNG NSRange
    #define          NSMIS NSMutableIndexSet
    #define         NSACTX NSAnimationContext
    #define         NSTBAR NSToolbar
    #define           NSSZ NSSize
    #define          NSAPP NSApplication
    #define           NSDE NSDirectoryEnumerator
    #define          NSVAL NSValue
    #define       NSDCLASS NSDictionary.class
    #define           NSFH NSFileHandle
    #define         NSBUTT NSButton
    #define       NSURLRES NSURLResponse
    #define            NSV NSView
    #define            NSA NSArray

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


#define QUALIFIER_FROM_BITMASK(q) q&AZ_arc_NATOM 					? nonatomic 			:\
q&AZ_arc_NATOM|AZ_arc_STRNG 	? nonatomic,strong 	:\
q&AZ_arc_RONLY 					? readonly 				:\
q&AZ_arc__COPY 					? copy 					:\
q&AZ_arc_NATOM|AZ_arc__COPY 	? nonatomic,copy 		:\
q&AZ_arc__WEAK 					? weak    : assign

#ifndef INST
#define INST instancetype
#endif

#define mC mutableCopy
#define INV NSInvocation
#define A2DD A2DynamicDelegate

//  AZPROP_HINTED(NSUInteger,ASS,poop);   -> @property (assign) NSUInteger _name;
#define NATOM_STR                               NATOM, strong

#define AZPROP_HINTED(_type_,_hints_,_name_)    @property (_hints_) _type_ _name
#define AZPROPS(_type_,_directives_,...)        for(int i=2, i<VA_NUM_ARGS, i++) AZPROP

#define      AZIFACEDECL(_name_,_super_)  @interface _name_ : _super_
#define    AZNSIFACEDECL(_name_)          AZIFACEDECL(_name_,NSObject)
#define      AZIFACE(_name_,_super_)  AZIFACEDECL(_name_,_super_) @end
#define    AZNSIFACE(_name_)          AZIFACE(_name_,NSObject)

#define                       AZIMPDECL(_name_) @implementation _name_
#define                       AZFULLIMP(_name_,_super_,...) AZIFACE(_name_,_super_) AZIMPDECL(_name_) __VA_ARGS__ @end 
#define          AZINTERFACEIMPLEMENTED(_name_) AZNSIFACE(_name_) AZIMPDECL(_name_) @end
#define AZINTERFACEIMPLEMENTEDWITHBLOCK(_name_,_super_,_BLOCK__) AZIFACE(_name_,_super_)	_BLOCK__(); @end @implementation _name_ @end

#define AZTESTCASE(_name_)   \
  @interface _name_ : SenTestCase @end @implementation _name_ 


//#define AZINTERFACE(_name_,...) @interface _name_ : __VA_ARGS__ ?: NSObject   // AZINTERFACE(NSMA,Alex) -> @interface Alex : NSMutableArray

#define AZPROPERTY(_kind_,_arc_,...)  @property (_arc_)  _kind_   __VA_ARGS__;
#define AZPROPERTYIBO(_kind_,...)     @property (assign) IBOutlet  _kind_   __VA_ARGS__;


#define AZSTRONGSTRING(A) @property (nonatomic, strong) NSString* A
//AZPROPASS(_kind_...) @property (NATOM,ASS) _kind_ __VA_ARGS__ //#QUALIFIER_FROM_BITMASK(_arc_)


#define AZGV 	 AtoZGridView
#define AZGVA 	 AtoZGridViewAuto
#define AZGVI 	 AtoZGridViewItem
#define AZGVDATA AtoZGridViewDataSouce
#define AZGVDEL  AtoZGridViewDelegate

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
/*	SYNTHESIZE_DELEGATE(	didOpenBlock, setDidOpenBlock,
							(void(^)(WebSocket*ws)),
							(void)webSocketDidOpen:(WebSocket*)ws,
							DO_IF_SELF(didOpenBlock))	
	@param	*/

#define SYNTHESIZE_DELEGATE(BLOCK_NAME,SETTER_NAME,SIG,METHOD,BLOCK) \
- SIG BLOCK_NAME { RET_ASSOC; }\
- (void) SETTER_NAME:SIG BLOCK_NAME { SET_ASSOC_DELEGATE(BLOCK_NAME); }\
- METHOD { BLOCK; }

/*  INSTEAD OF NASTY ASSOCIATED OBJECTS.....  */

#define DO_IF_SELF(X) 	if (self.X && self.delegate == self) self.X(self)
#define DO_IF_1ARG(X,Z) if (self.X && self.delegate == self) self.X(self,Z)

#define RET_ASSOC 					return objc_getAssociatedObject(self ,_cmd)
#define SET_ASSOC_DELEGATE(X)  	objc_setAssociatedObject(self, NSSelectorFromString([NSString stringWithUTF8String:#X]),\
																		X,OBJC_ASSOCIATION_COPY_NONATOMIC); self.delegate = self
#define SET_ASSOC(X)  	objc_setAssociatedObject(self, NSSelectorFromString([NSString stringWithUTF8String:#X]),\
																		X,OBJC_ASSOCIATION_COPY_NONATOMIC);

/*
	Example Setter
		- (void) setSomething:(BOOL)something { if (self.something == something) return; 	SAVE(@selector(something), @(something)); }
	Example Getter	
		- (BOOL) something { id x = FETCH; return x ? [x boolValue] : NO; }
*/

FOUNDATION_STATIC_INLINE BOOL SameSEL(SEL a, SEL b) {
	return sel_isEqual(a, b);
}

#define ASSIGN_WEAK(__self,sel,WK) ({ objc_setAssociatedObject(__self,@selector(sel),WK,OBJC_ASSOCIATION_ASSIGN); })
#define ASSIGNBOOL(sel,VAL) objc_setAssociatedObject(self,sel, @(VAL),OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define REFERENCE(sel,obj) objc_setAssociatedObject(self,sel, obj, 0)
#define _REFERENCE(sel,obj) objc_setAssociatedObject(_self,sel, obj, OBJC_ASSOCIATION_ASSIGN)
#define COPY(sel,obj) 		objc_setAssociatedObject(self,sel, obj, OBJC_ASSOCIATION_COPY)
#define _COPY(sel,obj) 		objc_setAssociatedObject(_self,sel, obj, OBJC_ASSOCIATION_COPY)
#define SAVE(sel,obj) 		objc_setAssociatedObject(self,sel, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define GETTER (SEL)NSSelectorFromString([[AZSELSTR substringAfter:@"set"].decapitalized substringBefore:@":"])
#define _SAVE(sel,obj) 		objc_setAssociatedObject(_self,sel, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define SAVEREFERENCE(obj) 		({ objc_setAssociatedObject(self,GETTER,obj,OBJC_ASSOCIATION_ASSIGN); })
#define OPEN(sel) 			objc_getAssociatedObject(self, sel)
#define _OPEN(sel) 			objc_getAssociatedObject(_self, sel)
#define FETCH       			objc_getAssociatedObject(self, _cmd)
#define _FETCH       			objc_getAssociatedObject(_self, _cmd)
#define FETCH_OR(X)        FETCH ?: X


#define NSKA    NSKeyedArchiver
#define NSKUA   NSKeyedUnarchiver
#define CALLSUPER [super _cmd]
#define CALLSUPERWITH(X) [super performString:AZSELSTR 				withObject:X]

#define CAMASK enum CAAutoresizingMask
#define DTA     NSData
#define DATA     DTA
#define DATE NSDate


#define qP      quartzPath
#define AZSLDST AZSlideState
#define AZWT    AZWindowTab
//#define AZWTV   AZWindowTabViewPrivate

#define NSOrderedDictionary M13OrderedDictionary

#define NSU NSURL
#define SET NSSet
#define NSS   NSString
#define CSET  NSCountedSet
#define CP    copy
#define NSUI  NSUInteger
#define ASOCK GCDAsyncSocket


#define clr colorLogString

#pragma mark 														- GLOBAL CONSTANTS

#pragma mark - VIEWS

#define 		  NSSIZEABLE 	NSViewHeightSizable | NSViewWidthSizable
#define 				  pBCN 	postsBoundsChangedNotifications
#define 				  pFCN 	postsFrameChangedNotifications

#define INRANGE(x,MINVAL,MAXVAL) (BOOL)({ MINVAL <= x && x <= MAXVAL; })


#define CFAA        CFAAction
#define UDEFSCTL	 	[NSUserDefaultsController sharedUserDefaultsController]
#define CONTINUOUS 	NSContinuouslyUpdatesValueBindingOption:@(YES)
#define AZN 	AZNode

#define ClassConst(X) X == [NSS class] ? NSS : X == [NSN  class] ? NSN  : \
                      X == [NSA class] ? NSA : X == [NSMA class] ? NSMA : \
                      X == [NSD class] ? NSD : X == [NSMD class] ? NSMD : id

#define SAFE_CAST(OBJECT, TYPE) ({ \
  id obj=OBJECT;[obj isKindOfClass:[TYPE class]] ? (TYPE *) obj: nil; })

//#define AZNewInfer(_name_, _val_) __typeof((_val_)) _name_ = __

#define AZNew(_class_,_name_) _class_ *_name_ = [_class_ new]
//#define AZNewObj(_class_,_name_) _class_ *_name_ = [_class_ new]
//#define AZNewObj(_name_,...) __typeof((__VA_ARGS__)) *_name_ = (__VA_ARGS__)
#define AZNewVal(_name_,...)  __typeof((__VA_ARGS__))   _name_ = (__VA_ARGS__)

//IS_OBJECT((__VA_ARGS__)) ? __typeof((__VA_ARGS__)) * _name_ = (__VA_ARGS__) 

#define AZFWBNDL AZFWORKBUNDLE
#define NSENUM NSEnumerator
#define CABD 	BlockDelegate
#define FM 		NSFileManager.defaultManager
#define UDEFS 	NSUserDefaults.standardUserDefaults
#define PINFO	NSProcessInfo.processInfo
#define AZF AZFile

#define DISABLE_SUDDEN_TERMINATION(_SELFBLK_) [NSProcessInfo.processInfo disableSuddenTermination]; \
_SELFBLK_(self); [NSProcessInfo.processInfo enableSuddenTermination];

#pragma mark - STRINGS

#define sepByCharsInSet componentsSeparatedByCharactersInSet
#define sepByString componentsSeparatedByString
#define sansLast arrayByRemovingLastObject

#define NSVA NSViewAnimation

#define			 kOpacity 	@"opacity"
#define				kPhase	@"phase"
#define				  kBGC	@"backgroundColor"
#define				kBGNSC	@"backgroundNSColor"
#define 				  vFKP 	valueForKeyPath
#define 				 mAVFK 	mutableArrayValueForKey

#define 				  bFK boolForKey

#define 					vFK 	valueForKey
#define 					 pV 	pointValue
#define 					 bV 	boolValue
#define 					 rV 	rectValue
#define 					 fV	  floatValue
#define 					 dV	  doubleValue
#define 					 sV	  stringValue
#define 				  rngV	rangeValue
#define            uIV unsignedIntegerValue
#define            iV integerValue

#define NSAssertFail(x) do { NSAssert(0, x); } while(0)  // ( do { NSAssert(0, x); } while(0) )   ///((nil)NSAssert(0, x)) //

#define          AZFONT NSFontAttributeName

#define AZASTRING @"attributedString"
#define AZSTRING  @"string"
#define AZFRAME   @"frame"
#define AZBOUNDS  @"bounds"

#define            AZFONTMANAGER NSFontManager.sharedFontManager
#define 		 NSZeroRange 	NSMakeRange(0,0)

#undef wCVfK
#define 				  wCVfK 	willChangeValueForKey
#define 				  dCVfK 	didChangeValueForKey

/* USAGE   SetKPfVA( Siblings, @"siblingIndexMax")  where "siblings" is the dependent key */
#define kPfVA(X) keyPathsForValuesAffecting##X
#define SetKPfVA(X,...) + (NSST*) kPfVA(X) { return NSSET(__VA_ARGS__); }

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
#define 			 AZAPPINFO  [AZAPPBUNDLE infoDictionary]
#define 			 AZAPPNAME   [AZAPPBUNDLE objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define 			 AZAPP_ID   [AZAPPBUNDLE objectForInfoDictionaryKey:@"CFBundleIdentifier"]
#define 	  AZAPPRESOURCES 	[NSBundle.mainBundle resourcePath]

#define 	  CAMEDIAEASEOUT 	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
#define  	CAMEDIAEASEIN 	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
#define    	  CAMEDIAEASY 	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
#define    	  AZWORKSPACE 	NSWorkspace.sharedWorkspace
#define 	    AZCOLORPANEL 	NSColorPanel.sharedColorPanel
#define     	AZUSERDEFS 	NSUserDefaults.standardUserDefaults


#define AZ_DEFS_DOMAIN	 			@"AtoZ"

#define  	 AZ_DEFAULTS 			[AZUSERDEFS persistentDomainForName:AZ_DEFS_DOMAIN]
// 			 AZ_DEFAULTS is the same as $(defaults read AtoZ)

#define 		 AZ_DEFAULT(KEY)    	AZ_DEFAULTS[KEY]
// [NSUserDefaults.standardUserDefaults persistentDomainForName:@"AtoZ"][@"pooop"] = Bejememe

#define  AZ_SET_DEFAULT(KEY,VAL) 		[AZUSERDEFS setPersistentDomain:[AZ_DEFAULTS dictionaryWithValue:VAL forKey:KEY]  forName:AZ_DEFS_DOMAIN]

#define AZSTATIC_OBJ(_KLASS,_NAME,_VAL) \
\
  static _KLASS *_NAME; _NAME = _NAME ?: ({ _VAL; })

#define AZSTATIC_OBJBLK(_KLASS,_NAME,_VALBLK) \
\
  static _KLASS *_NAME; _NAME = _NAME ?: (id)(_VALBLK())


#define AZSTATIC(_TYPE,_NAME,_VAL) static _TYPE _NAME = (_VAL)

#define  AZSL @"superlayer"
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
//__tmpblk
#define __blockSafe(__obj__)                    __obj__
//__tmpblk##
#define __blk(__obj__)                          __blockSafe(__obj__)
#define declareBlockSafeAs(__obj__, __name__)   __weak __typeof__(__obj__) __name__ = __obj__
	//__tmpblk##

#define SELFBLK void(^)(id _self)


#define  	AZUSERDEFSCTR 	NSUserDefaultsController.sharedUserDefaultsController
#define    	  AZNOTCENTER 	(NSNotificationCenter*)NSNotificationCenter.defaultCenter
#define    	AZWORKSPACENC  NSWorkspace.sharedWorkspace.notificationCenter
#define    	AZDISTNCENTER  NSDistributedNotificationCenter.defaultCenter
#define  	AZFILEMANAGER 	NSFileManager.defaultManager
#define  	AZGRAPHICSCTX 	NSGraphicsContext.currentContext
#define   	 AZCURRENTCTX 	AZGRAPHICSCTX
#define   	 AZQTZCONTEXT 	[NSGraphicsContext.currentContext graphicsPort]
#define    	  AZSHAREDAPP 	((NSApplication*)[NSApplication sharedApplication])
#define    	  AZAPPEVENT 	AZSHAREDAPP.currentEvent
#define    	  AZMODIFIERFLAGS AZAPPEVENT.modifierFlags

#define    	  AZAPPACTIVATE [AZSHAREDAPP setActivationPolicy:NSApplicationActivationPolicyRegular], [NSApp activateIgnoringOtherApps:YES]
#define    	  AZAPPRUN AZAPPACTIVATE, [NSApp run]
#define    	  AZAPPWINDOW [AZSHAREDAPP mainWindow]
#define    	    AZAPPVIEW ((NSView*)[AZAPPWINDOW contentView])
#define     AZCONTENTVIEW(V) ((NSView*)[V contentView])
#define     	AZWEBPREFS 	WebPreferences.standardPreferences
//#define     	AZPROCINFO 	NSProcessInfo.processInfo
#define     	AZPROCNAME 	[NSProcessInfo.processInfo processName]
#define     	AZPROCARGS NSProcessInfo.processInfo.arguments
#define     	AZARGS      [AZPROCARGS after:0]
#define 		 	 AZNEWPIPE 	NSPipe.pipe
#define 			AZNEWMUTEA 	NSMutableArray.array
#define 			AZNEWMUTED 	NSMutableDictionary.new
#define 	 	  AZSHAREDLOG DDTTYLogger.sharedInstance

#define AZCURRENTDOC [NSDocumentController.sharedDocumentController currentDocument]
#define AZCURRENTDOCWINDOW [AZCURRENTDOC windowForSheet]

#define NSTN NSTreeNode 
#define tNwRO treeNodeWithRepresentedObject
#define mcNodes mutableChildNodes


/*		
		NSLog(@"%s", QUOTE(NSR));					NSLog(@"%s", EXPQUOTE(NSR));
		NSLog(@"%@", $UTF8(EXPQUOTE(NSR)));		NSLog(NSQUOTE(NSC));
		NSLog(NSEXPQUOTE(NSC));
*/
#define QUOTE(str) #str  							// printf("%s\n", QUOTE(NSR));		-> %s NSR
#define EXPQUOTE(str) QUOTE(str) 				// printf("%s\n", EXPQUOTE(NSR));	-> %s NSRect
#define NSQUOTE(str) $UTF8(#str)					// -> %@ NSR
#define NSEXPQUOTE(str) $UTF8(QUOTE(str))		// -> %@ NSRect
//	NSW* theWindowVar; ->
//	NSLog(@"%@", NSEXPQUOTE(theWindowVar)); 		-> %@ theWindowVar

//#define ISKINDA(x,y) [y isKindOfClass:[y class]]

//#warning - todo

//NSA*maybeAnArray = objc_dynamic_cast(UISwitch,viewController.view);	if (switch) NSLog(@"It jolly well is!);
//That's nice, isn't it? Here's how:

#define objc_dynamic_cast(TYPE, object) \
  ({ \
      TYPE *dyn_cast_object = (TYPE*)(object); \
      [dyn_cast_object isKindOfClass:[TYPE class]] ? dyn_cast_object : nil; \
  })

#define AZCLASSNIBNAMED(_CLS_,_INSTANCENAME_) do { \
	NSArray *objs 				= nil;                      \
	static NSNib   *aNib 	= [NSNib.alloc initWithNibNamed:AZCLSSTR bundle:nil] instantiateWithOwner:nil topLevelObjects:&objs]; \
	_CLS_ *_INSTANCENAME_ 	= [objs objectWithClass:[_CLS_ class]]; \
} while(0)


#define AZSTRSTR(A) 			@property (nonatomic, strong) NSString* A
#define AZPROPSTR(z,x)		@property (nonatomic, strong) z *x
#define AZPROPRDO(z,x) 		@property (readonly) z* x

//#define AZPROPASS (A,B...) 	@property (NATOM,ASS) A B
//#define AZPROPIBO (A,B...) 	@property (ASS) IBOutlet A B
//	static NSString *_##ENUM_TYPENAME##_constants_string = @"" #ENUM_CONSTANTS; 	\

//#define PROPSTRONG (@property (nonatomic,strong) )
//#define PROPASSIGN (@property (nonatomic,assign) )

#define	 USF unsafe_unretained
#define UNSFE unsafe_unretained
#define __UNSFE __unsafe_unretained

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

#define AZNULL [NSNull null]
#define ELSENULL ?: [NSNull null]
#define AZGView AtoZGridView
#define AZGVItem AtoZGridViewItem

#define GPAL AtoZ.globalPalette
#define GPALNEXT GPAL.nextNormalObject

#define AZPAL AZPalette
#define AZIS AZInstallationStatus

#define VAL NSVAL

#define AZAPPDELEGATE (NSObject<NSApplicationDelegate>*)[NSApp delegate]

#define performDelegateSelector(sel) if ([delegate respondsToSelector:sel]) { [delegate performSelector:sel]; }
#define performBlockIfDelegateRespondsToSelector(block, sel) if ([delegate respondsToSelector:sel]) { block(); }

#define AZBindSelector(observer,sel,keypath,obj) [AZNOTCENTER addObserver:observer selector:sel name:keypath object:obj]
#define AZBind(binder,binding,toObj,keyPath) [binder bind:binding toObject:toObj withKeyPath:keyPath options:nil]

#define 						kContentTitleKey @"itemTitle"
#define 						kContentColorKey @"itemColor"
#define 						kContentImageKey @"itemImage"
#define 						kItemSizeSliderPositionKey @"ItemSizeSliderPosition"

#define		AZTRACKALL 	(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseMoved)
#define AZTArea(frame) 	[NSTA.alloc initWithRect:frame options:AZTRACKALL owner:self userInfo:nil]
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

// Usage 	NEW( aColor, NSColor.clearColor );   ->  aColor.alphaComponent -> 0.0
#define NEWTYPEOF(_name_,_value_)  		 			__typeof(_value_) _name_ = _value_
#define BLOCKIFY(_name_,_value_)  __block __typeof(_value_) _name_ = _value_

#define DYNAMIC(_class_,_type_,_name_...) \
@interface     _class_ (Dynamic##_name_) @property _type_ _name_; @end \
@implementation _class_ (Dynamic##_name_) @dynamic _name_; @end

#define DYDISPLAYforKEYorSUPER(_key_) 	[self.dynamicPropertyNames containsObject:_key_] ?: [super needsDisplayForKey:_key_]
#define SUBLAYERofCLASS(_class_) 		[self sublayerOfClass:[_class_ class]]
#define SUPERINIT 							if (!(self = [super init])) return nil
#define SUPERINITWITHFRAME(f) 				if (!(self = [super initWithFrame:f])) return nil
//#define SUPERINITWITH(X)  				if (!(self = (IS_OBJECT(X) ? [super performSelector:_cmd withObject:X] : [super performSelector:_cmd withRect:X]))) return nil

#define SELFDELEGATE  						[self setDelegate:self], [self setNeedsDisplay]
#define WINLOC(_event_) 					[_event_ locationInWindow]

#define IF_RETURNIT(_X_) if (_X_) return _X_
#define IF_RETURN(_X_) if (_X_) return (id)nil
#define IF_VOID(_X_) if (_X_) return

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
#define zNL @"\n"
#define zTAB @"\t"
#define zSPC @" "
#define zNIL @""

#define ASOCK GCDAsyncSocket

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
#define AZString(_X_) (	{	__typeof__(_X_) _Y_ = (_X_); AZToStringFromTypeAndValue(@encode(__typeof__(_X_)), &_Y_);})

#define dothisXtimes(_ct_,_action_)  for(int X = 0; X < _ct_; X++) ({ _action_ }) 


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
#define AZTEMPFILE(EXT) 	[AtoZ tempFilePathWithExtension:$(@"%s",#EXT)]

#define CLSSBNDL					[NSBundle bundleForClass:[self class]]
#define AZBUNDLE					[NSBundle bundleForClass:[AtoZ class]]
#define APP_NAME 					[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"]
#define APP_VERSION 				[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"]
#define OPEN_URL(urlString) 	[NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:urlString]]



#define kPfVAVfK keyPathsForValuesAffectingValueForKey
#define wCVfK willChangeValueForKey
#define dCVfK didChangeValueForKey

#define dVfK defaultValueForKey
#define NSET NSSet*


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
//#define	DEGREES_TO_RADIANS( d )		((d) * 0.0174532925199432958)				// converting from radians to degrees
//#define 	RADIANS_TO_DEGREES( r )		((r) * 57.29577951308232)
#define 			  FIFTEEN_DEGREES		(0.261799387799)								// some useful angular constants
#define 				NINETY_DEGREES		(pi * 0.5)
#define 			FORTYFIVE_DEGREES		(pi * 0.25)
#define 						 HALF_PI		(pi * 0.5)


#define CLAMP(value, lowerBound, upperbound) MAX( lowerBound, MIN( upperbound, value ))

#define AZDistance(A,B) sqrtf(powf(fabs(A.x - B.x), 2.0f) + powf(fabs(A.y - B.y), 2.0f))
#define rand() (arc4random() % ((unsigned)RAND_MAX + 1))

#define CARL CAReplicatorLayer
#define CGIREF CGImageRef
#define CGCLRREF CGColorRef
#define NEWLAYER(_x_) CAL* _x_ = CAL.new
//#define NEW(_class_,_name_) _class_ *_name_ = [_class_.alloc init]

#define NEWATTR(_class_,_name_...)

#define $NSMD(_NAME_) NSMutableDictionary *_NAME_ = NSMutableDictionary.new
#define $NSMA(_NAME_) NSMutableArray *_NAME_ = NSMutableArray.new

#define $point(A)	   	[NSValue valueWithPoint:A]
#define $points(A,B)	   	[NSValue valueWithPoint:CGPointMake(A,B)]
#define $rect(A,B,C,D)		[NSValue valueWithRect:CGRectMake(A,B,C,D)]

#define ptmake(A,B)			CGPointMake(A,B)stringByAppendingPathComponent

#define NSWIND NSWindowDelegate 
#define NSAPPD NSApplicationDelegate
#define NSU		NSURL
#define $URL(A)				!ISA(A,NSS) || !A || ![A length] ? nil : \
                      [AZFILEMANAGER fileExistsAtPath:A] ? [NSURL fileURLWithPath:A] : \
                      [NSURL URLWithString:A]
                      
#define $SEL(A)				NSSelectorFromString(A)
#define AZStringFromSet(A) [NSS stringFromArray:A.allObjects]

//#define $#(A)				((NSString *)[NSString string
#define $(...)				((NSString*)[NSString stringWithFormat:__VA_ARGS__,nil])
#define $$(...)				((NSString*)[NSString stringWithFormat:@__VA_ARGS__,nil])
#define $JOIN(...)				((NSString*)[@[__VA_ARGS__] componentsJoinedByString:@" "])
#define $UTF8(A)			[NSS stringWithUTF8String:A]
#define $UTF8orNIL(A)	A ? [NSS stringWithUTF8String:A] : nil
//#define $array(...)  	((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])
#define $set(...)		 	((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])
#define $map(...)	 		((NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil])
#define $int(A)	   	@(A) // [NSNumber numberWithInt:(A)]
#define $ints(...)			[NSArray arrayWithInts:__VA_ARGS__,NSNotFound]
#define $float(A)	 		[NSNumber numberWithFloat:(A)]
#define $doubles(...) 		[NSArray arrayWithDoubles:__VA_ARGS__,MAXFLOAT]
#define $words(...)   		[[@#__VA_ARGS__ splitByComma] trimmedStrings]

#define $IDX(X) [NSIS indexSetWithIndex:X]
#define $idxsetrng(X) [NSIS indexSetWithIndexesInRange:X]

#define AZSELSTR NSStringFromSelector(_cmd)

#define capped capitalizedString

#define $ARRAYSET(A) [NSSet setWithArray:(A)]
#define $CG2NSC(A) [NSC colorWithCGColor:(A)]
//#define $concat(A,...) { A = [A arrayByAddingObjectsFromArray:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])]; }
// s stringByReplacingOccurrencesOfString:@"fff	" withString:@"%%%%"] )
//#define AZLOG(log,...) NSLog(@"%@", [log s stringByReplacingOccurrencesOfString:@"fff	" withString:@"%%%%"] )


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

