//
//  AZAppDelegate.h
//  AtoZTestBed
//

#import <AtoZ/AtoZ.h>
#import <QuartzCore/QuartzCore.h>


@interface NASpinSeque : NSObject

@property (retain, strong) NSView *v1, *v2, *sV;
@property (retain, strong) CAL *l1, *l2;
+ (id)animateTo:(id)v1 inSuperView:(id)sV;
@end

@interface TestBedDelegate : NSObject <NSApplicationDelegate>
@property (ASSGN) IBOutlet NSWindow 		  *window;
@property (ASSGN) IBOutlet NSSegmentedControl *segments;
@property (ASSGN) IBOutlet NSView 			  *targetView;


@property (STRNG, NATOM) AZMedallionView 	*medallion;
@property (STRNG, NATOM) BNRBlockView 	    *blockView;
@property (STRNG, NATOM) AZHostView			*hostView;
@property (STRNG, NATOM) NSView				*debugLayers;
@property (STRNG, NATOM) AZGrid				*azGrid;

@property (STRNG, NATOM) NASpinSeque 		*seque;



@end
