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


@implementation AZGridView
{
	CALayer *root;
	CALayer *contentLayer;

}

@synthesize content;

-(void) awakeFromNib {
	
	root = [CALayer layer];
	root.name = @"root";
	[self setLayer:root];
	[self setWantsLayer:YES];
	contentLayer = [CALayer layer];
	contentLayer.position = [self center];
	[self doLayout];
}

-(void) viewDidEndLiveResize {
	[self doLayout];
}


- (void) doLayout {

	NSRect r 	= [AZSizer structForQuantity:[AtoZ dockSorted		].count inRect:[self frame]];
//				   contentLayer.sublayers.count inRect:[self frame]];
	NSLog(@"Sizer rect: %@", NSStringFromRect(r));
	int columns = r.origin.y;
	int rows 	= r.origin.x;
	NSSize s 	= NSMakeSize(r.size.width, r.size.height);
	NSUInteger rowindex,  columnindex;
	rowindex = columnindex = 0;
	for (AZFile *file in [AtoZ dock]) {
		//		if ([imageLayer valueForKey:@"locked"]) continue;
		CALayer *fileLayer = [CALayer layer];
		fileLayer.backgroundColor = file.color.CGColor;
		fileLayer.contents = file.image;
		fileLayer.frame = AZMakeRect(NSMakePoint(
												 s.width * columnindex,
												 root.frame.size.height - ((rowindex + 1) * s.height)), s);
		[root addSublayer:fileLayer];
		columnindex++;
		if ( ! ((columnindex + 1) <= columns) ) { columnindex = 0; rowindex++; }
		
		//		CATransform3D rot = [self makeTransformForAngle:270];
		//      imageLayer.transform = rot;
		//		box.identifier = $(@"%ldx%ld", rowindex, columnindex);	    
	}
	

}
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	}
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}
@end
