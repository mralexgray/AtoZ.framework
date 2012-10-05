//
//  AZGridView.m
//  AZLayerGrid
//
//  Created by Alex Gray on 7/20/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import "AZGridView.h"
#import <QuartzCore/QuartzCore.h>
#import <AtoZ/AtoZ.h>
#import <FunSize/FunSize.h>

@interface AZGridView ()

@end
@implementation AZGridView

//@synthesize content, contentLayer, root;

-(void) awakeFromNib {
	self.root 				= [CALayer layer];
	_root.autoresizingMask 	= kCALayerWidthSizable |  kCALayerHeightSizable;
	_root.needsDisplayOnBoundsChange = YES;
	_root.position 			= [self center];
	_root.bounds 			= [self bounds];
	_root.name 				= @"root";
	_root.layoutManager 	= [CAConstraintLayoutManager layoutManager];
	self.layer				= _root;
	self.wantsLayer			= YES;				// Setup core animation
	self.contentLayer 		= [CALayer layer];
	_contentLayer.delegate 	= self;
	_contentLayer.position 	= [self center];
	_contentLayer.bounds 	= [self bounds];
	[_contentLayer addConstraintsSuperSize];
	self.content 			= [AZFolder samplerWithCount:34];// arrayUsingBlock:^id(id obj) {
//		return [AZFile instanceWithImage:obj];}];
//	}][AtoZ appFolderSamplerWith: RAND_INT_VAL(12, 29)];
	_root.sublayers 		= @[_contentLayer];
	[_root setNeedsLayout];
}

-(void) viewDidEndLiveResize {
	[_contentLayer setNeedsLayout];
}
- (void) setContent:(NSArray *)content {

	_content = content;
	_ss = self.ss;
	NSUInteger rowindex,  columnindex;  rowindex = columnindex = 0;
	_contentLayer.sublayers = [_content arrayUsingBlock:^id(AZFile* obj) {

		//		if ([imageLayer valueForKey:@"locked"]) continue;
		CALayer *fileLayer 			= [CALayer layer];
		fileLayer.autoresizingMask = kCALayerWidthSizable |  kCALayerHeightSizable;
		fileLayer.backgroundColor 	= cgRANDOMCOLOR;
		fileLayer.contents 			= obj.image;
		fileLayer.frame 			= [[_ss.rects objectAtNormalizedIndex:index]rectValue];
		return fileLayer;
	}];

	[_contentLayer setNeedsLayout];
}

- (AZSizer*)ss {
	return _ss = [AZSizer forQuantity:_content.count inRect:[[[self window]contentView]frame]];
}

- (void) layoutSublayersOfLayer:(CALayer *)layer {

//	AZLOG(ss);
//	structForQuantity:content.count inRect:[self frame]];
//				   contentLayer.sublayers.count inRect:[self frame]];
//	NSLog(@"Sizer rect: %@", NSStringFromRect(r));
//	int columns =  10;//r.origin.y;
//	int rows 	= 10;  //r.origin.x;
//	NSSize s 	= NSMakeSize(40, 40);//r.size.width, r.size.height);
	_ss = self.ss;


	[_contentLayer.sublayers enumerateObjectsUsingBlock:^(CALayer* obj, NSUInteger idx, BOOL *stop) {
		[CATransaction immediately:^{
			obj.position = AZCenterOfRect([[_ss.rects objectAtNormalizedIndex:idx]rectValue]);
			obj.bounds = (CGRect){0,0,_ss.width, _ss.height};
		}];
	}]; //		AZMakeRect( (NSPoint) {	s.width * columnindex,
//												 				root.frame.size.height - ((rowindex + 1)* s.height) }, s);
//		columnindex++;
//		if ( ! ((columnindex + 1) <= columns) ) { columnindex = 0; rowindex++; }
//		return fileLayer;

//	}];
		//		CATransform3D rot = [self makeTransformForAngle:270];
		//      imageLayer.transform = rot;
		//		box.identifier = $(@"%ldx%ld", rowindex, columnindex);	    
}

//- (id)initWithFrame:(NSRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//	}
//    return self;
//}
//
//- (void)drawRect:(NSRect)dirtyRect
//{
//    // Drawing code here.
//}
@end
