#import <QuartzCore/QuartzCore.h>
#import "AtoZUmbrella.h"

#pragma mark - COLORS

#define          WHITE [NSC     whiteColor]
#define         PURPLE [NSC   r:0.617 g:0.125 b:0.628 a:1.]
#define           BLUE [NSC   r:0.267 g:0.683 b:0.979 a:1.]
#define     RANDOMGRAY [NSC  white:RAND_FLOAT_VAL(0,1) a:1]
#define          GRAY9 [NSC  white:.9 a: 1]
#define     PERIWINKLE [NSColor colorWithDeviceRed:.79 green:.78 blue:.9 alpha:1]
#define   cgRANDOMGRAY RANDOMGRAY.CGColor // CGColorCreateGenericGray( RAND_FLOAT_VAL(0,1), 1)
#define          GREEN [NSC   r:0.367 g:0.583 b:0.179 a:1.]
#define          GRAY7 [NSC  white:.7 a: 1]
#define    kWhiteColor cgWHITE
#define          BLACK [NSC blackColor]
#define          GRAY5 [NSC  white:.5 a: 1]
#define  cgRANDOMCOLOR RANDOMCOLOR.CGColor
#define        cgGREEN GREEN.CGColor
#define          cgRED RED.CGColor
#define      RANDOMPAL [NSC  randomPalette]
#define         cgGREY GREY.CGColor
#define          GRAY3 [NSC  white:.3 a: 1]
#define         YELLOw [NSC   r:0.830 g:0.801 b:0.277 a:1.]
#define        cgWHITE WHITE.CGColor
#define         cgBLUE BLUE.CGColor
#define          GRAY1 [NSC  white:.1 a: 1]
#define           GREY [NSC      grayColor]
#define           PINK [NSC   r:1.000 g:0.228 b:0.623 a:1.]
#define       cgYELLOW YELLOW.CGColor
#define    kBlackColor cgBLACK
#define          GRAY8 [NSC  white:.8 a: 1]
#define       cgPURPLE PURPLE.CGColor
#define          CLEAR [NSC     clearColor]
#define          GRAY6 [NSC  white:.6 a: 1]
#define    RANDOMCOLOR [NSC    randomColor]
#define         ORANGE [NSC   r:0.888 g:0.492 b:0.000 a:1.]
#define       cgORANGE ORANGE.CGColor
#define        cgBLACK BLACK.CGColor
#define          GRAY4 [NSC  white:.4 a: 1]
#define   cgCLEARCOLOR CLEAR.CGColor
#define          GRAY2 [NSC  white:.2 a: 1]
#define STANDARDCOLORS  = @[RED,ORANGE,YELLOW,GREEN,BLUE,PURPLE,GRAY]
#define            RED [NSC   r:0.797 g:0.000 b:0.043 a:1.]
#define         YELLOW [NSC   r:0.830 g:0.801 b:0.277 a:1.]
#define          LGRAY [NSC  white:.5 a:.6]

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
#define                                         AZSHAREDAPP NSApplication.sharedApplication
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
#define                                      AZPROPIBO(A) @property (ASS) IBOutlet QUOTE(A)
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
#define                                   AZSTRONGSTRING(A) @property (nonatomic, strong) NSString* A
#define                                      AZPROPASS(A) @property (NATOM,ASS) A
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

#pragma mark - AZ

#define    AZCACWide AZConstRelSuper ( kCAConstraintWidth  )
#define        AZRUN while(0) [NSRunLoop.currentRunLoop run]
#define    AZCACMaxY AZConstRelSuper ( kCAConstraintMaxY   )
#define    AZCACHigh AZConstRelSuper ( kCAConstraintHeight )
#define    AZCACMinX AZConstRelSuper( kCAConstraintMinX   )
#define    AZCACMaxX AZConstRelSuper ( kCAConstraintMaxX   )
#define    AZRUNLOOP NSRunLoop.currentRunLoop
#define    AZCACMinY AZConstRelSuper ( kCAConstraintMinY   )
#define     AZLOGCMD [$UTF8(__PRETTY_FUNCTION__) log]
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
#define                    AZSuperLayerSuper (@"superlayer")
#define                                 CAAG CAAnimationGroup
#define                                 kIMG @"image"
#define                                  CAA CAAnimation
#define                                  bgC backgroundColor
#define                                 CAGL CAGradientLayer
#define                               CATXTL CATextLayer
#define                                CALNA CALayerNonAnimating
#define                             CATRANST CATransition
#define                          CACONSTATTR CAConstraintAttribute
