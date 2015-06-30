

#import "CAWindow.h"


@interface AZTabView   : AZSimpleView
_RO NSAS *string;
@end

@interface AZWindowTab : CAWindow

_RO AZTabView * handle;
_NA       AZR * inFrame, * outFrame, * grabRect, * outerRect;
_NA      NSSZ   inSize,
                     outSize;
_RO OSCornerType 	outsideCorners;

@property CGP offset;
- (id)initWithView:(NSV *)v orClass:(Class)k frame:(NSR)r;
@end


@interface AZWindowTabController : NSArrayController <NSWindowDelegate>
@end


//@prop_NA NSV * view;
//+ tabWithViewClass:(Class)k;

//@property (STR) 			AZWindowTabController	*vc;
//+   (id) tabWithViewClass:				  (Class)k;
//-   (id) initWithView:(NSV*)c	orClass:(Class)k	frame:(NSR)r;
//@property (CP)	void (^rezhzuhz)(void);
//+ (NSA*) tabRects;
//+ (NSA*) tabs;
