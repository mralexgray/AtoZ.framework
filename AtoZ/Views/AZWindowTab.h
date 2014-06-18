

#import "AtoZUmbrella.h"
#import "CAWindow.h"


@interface AZTabView   : AZSimpleView
@prop_RO NSAS *string;
@end

@interface AZWindowTab : CAWindow

@prop_RO AZTabView * handle;
@prop_NA       AZR * inFrame, * outFrame, * grabRect, * outerRect;
@prop_NA      NSSZ   inSize,
                     outSize;
@property (RONLY) OSCornerType 	outsideCorners;

@property CGP offset;
- (id)initWithView:(NSV *)v orClass:(Class)k frame:(NSR)r;
@end


@interface AZWindowTabController : NSArrayController <NSWindowDelegate>
@end


//@prop_NA NSV * view;
//+ (id) tabWithViewClass:(Class)k;

//@property (STR) 			AZWindowTabController	*vc;
//+   (id) tabWithViewClass:				  (Class)k;
//-   (id) initWithView:(NSV*)c	orClass:(Class)k	frame:(NSR)r;
//@property (CP)	void (^rezhzuhz)(void);
//+ (NSA*) tabRects;
//+ (NSA*) tabs;
