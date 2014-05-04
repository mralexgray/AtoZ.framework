
#import "AZBlockView.h"
#import "AtoZ.h"

@interface  BNRBlockView ()
@prop_CP RectBlock   rBlock;
@prop_CP BLKVIEWRBLK   drawBlock;
@prop_CP BlkViewLayerBlock   layerDelBlock;

@end

@implementation BNRBlockView

+ (INST) drawInView:(NSV*)v block:(RectBlock)blk {

  BLKV *x = [self viewWithFrame:v.bounds];  x.rBlock = blk; [v addSubview:x]; return x;
}

+ (INST) viewWithFrame:(NSR)f drawBlock:(BLKVIEWRBLK)blk { return [self.class viewWithFrame:f opaque:YES drawnUsingBlock:blk]; }

+ (INST) viewWithFrame:(NSR)f opaque:(BOOL)o drawnUsingBlock:(BLKVIEWRBLK)blk {

  BLKVIEW *v = [self viewWithFrame:f]; [v setDrawBlock:blk]; [v setOpaque:o]; return v;
}

//+ (INST) inView:(NSV*)n withBlock:(BlkViewLayerDelegate)blk { BLKV * v;
//
//  return v = [self.class :n.bounds opaque:YES drawnUsingBlock:bl:v.bounds] ? [n addSubview:v],
//	[view setAutoresizingMask:NSSIZEABLE];
//	CAL* l        = view.setupHostView;
//	[view setLayer:l];
//	l.delegate 		= view;
//	l.arMASK 			= CASIZEABLE;
//	l.bgC 				= [LINEN CGColor];
//	[l setNeedsDisplay];
//	[view setLBlock:ctxBlk];
//	return view;
//}

+ (BLKVIEW*) inView:(NSV*)v withFrame:(NSR)f inContext:(BlkViewLayerBlock)ctxBlk{
	
	BLKVIEW *blkV 	= [self.alloc initWithFrame:v.bounds];
	blkV.arMASK = NSSIZEABLE;
	BOOL hasLayer = (v.layer != nil);	
	[blkV setupHostView];	
//	if (!hasLayer)  [v setupHostView];
	blkV.layer.needsDisplayOnBoundsChange = YES;
	CAL*l = CAL.layer;
	l.arMASK = kCALayerNotSizable;
	l.frame = f;
	[blkV.layer addSublayer:l]; 
	l.arMASK 			= CASIZEABLE;
	BlockDelegate *d = [BlockDelegate delegateFor:l ofType:CABlockTypeDrawBlock withBlock: ^(CAL* layer,CGContextRef ref){
		[NSGraphicsContext drawInContext:ref flipped:NO actions:^{
			NSLog(@"drawing in blockview block delegate context: %@", AZString(layer.frame));
			ctxBlk(blkV, layer);
		}];
	}];
	[v addSubview:blkV];
	return blkV;
}


- (void) drawLayer:(CAL*)l inContext:(CGCREF)ctx  {

	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
    if (_layerDelBlock) _layerDelBlock(self,l);
    if(_drawBlock) _drawBlock(self,l.bounds);
  }];
}

- (void) drawRect:(NSR)dRect { IF_VOID(!_rBlock && !_drawBlock);  AZBlockSelf(_self);

  [AZGRAPHICSCTX state:^{ _self.rBlock    ? _self.rBlock    (_self.bounds) :
                          _self.drawBlock ? _self.drawBlock (_self, dRect) :  nil;
  }];
}
@end

//@implementation AZBlockWindow
//@synthesize drawBlock;
//
//+ (AZBlockWindow*) windowWithFrame: (NSRect)frame drawnUsingBlock:(ObjRectBlock)theDrawBlock
//{	//	__typeof__(self)
//	AZBlockWindow *view = [AZBlockWindow.alloc initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
//	view.drawBlock = theDrawBlock;
////	[view setMovable: YES];
//	[(NSView*)[view contentView]addSubview:view.drawBlock];
//	return view;
//}
//
//- (BOOL) acceptsFirstResponder { return YES; }
//- (BOOL) acceptsMouseMovedEvents { return YES; }
//@end

/*
@implementation AZBlockView
@synthesize drawBlock, opaque;
+ (AZBlockView*)  viewWithFrame:(NSRect)frame  opaque:(BOOL)opaque
				drawnUsingBlock:(AZBlockViewDrawer)theDrawBlock
{
//	__typeof__(self) view = [AZBlockView.alloc initWithFrame:frame];
//	[view setDrawBlock:theDrawBlock];
//	[view setOpaque:opaque];
//	return view;// autorelease];
}


- (void) drawRect:(NSRect)dirtyRect {	if (drawBlock)		drawBlock(self, dirtyRect); }

- (BOOL)isOpaque {	return opaque; }

@end

@implementation AZBlockView
@synthesize drawBlock, opaque;
+ (AZBlockView *)viewWithFrame:(NSRect)frame 
						 opaque:(BOOL)opaque
				drawnUsingBlock:(AZBlockViewDrawer)theDrawBlock
{
//	__block __typeof__(self)
	AZBlockView *view = [AZBlockView.alloc initWithFrame:frame];
	[view setDrawBlock:theDrawBlock];
	[view setOpaque:opaque];
	return view;// autorelease];
}
- (void) dealloc {
	[self setDrawBlock:nil];
	[super dealloc];
}
- (void) drawRect:(NSRect)dirtyRect {
	if (drawBlock)
		drawBlock(self, dirtyRect);
}
- (BOOL)isOpaque {
	return opaque;
}
@implementation BLKCELL

+ (instancetype) inView:(NSV*)v withBlock:(void(^)(BLKCELL*cell, NSR cF, NSV*cV))blk {

	BLKCELL *cell 	= [BLKCELL.alloc initWithCoder:<#(NSCoder *)#> .alloc initWithFrame:frame];
	[view setDBlock:theDrawBlock];
	[view setOpaque:opaque];
	return view;
}
@end
//@synthesize drawBlock, opaque, layerBlock;

*/

