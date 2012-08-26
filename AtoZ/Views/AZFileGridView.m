//
//  AZFileGridView.m
//  AtoZ
//
//  Created by Alex Gray on 8/26/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZFileGridView.h"
#import <QuartzCore/QuartzCore.h>
#import "AtoZ.h"

@implementation AZFileGridView

-(void) awakeFromNib {

//	self.root = [CALayer layer];
//	_root.name = @"root";
//	_root.frame = [self bounds];
//	_root.backgroundColor = cgRED;
//	[self setLayer:_root];
	[self setWantsLayer:YES];
//	self.contentLayer = [CALayer layer];
//	_contentLayer.position = [self center];
//	if (_content)	[self doLayout];

}

-(void) viewDidEndLiveResize {
	[self doLayout];
}


- (void)setContent:(NSMutableArray *)content {

	_content  = content;
	[self doLayout];

}
- (void) doLayout {


//	NSRect sizer 	= [AZSizer structForQuantity:_content.count inRect:[self bounds]];
	//				   contentLayer.sublayers.count inRect:[self frame]];
//	NSLog(@"Sizer rect: %@", NSStringFromRect(r));
//	int columns =  r.origin.y;
//	int rows 	=  r.origin.x;

//	NSUInteger rowindex,  columnindex;
//	rowindex = columnindex = 0;
//	for (AZFile *file in _content) {
//	NSLog(@"Sizer: %@", i.propertiesPlease);
	if (!_layers) {
		self.layers = [NSMutableArray array];
		[_content enumerateObjectsUsingBlock:^(AZFile* file, NSUInteger idx, BOOL *stop) {
			//		if ([imageLayer valueForKey:@"locked"]) continue;
			CALayer *fileLayer = [CALayer layer];
			fileLayer.backgroundColor = file.color.CGColor;
			[_layers addObject:fileLayer];
			[[self layer] addSublayer:fileLayer];
		}];
	}
	self.sizer = [AZSizer forQuantity:_content.count inRect:[self frame]];

	//		fileLayer.contents = file.image;
	//		fileLayer.contentsGravity = kCAGravityResizeAspect;
	[_layers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

		obj.frame = [[_sizer.rects objectAtIndex:idx]rectValue];
//		NSRect *f = AZMakeRect(	(NSPoint) {	sizerSize.width * columnindex,
//											_root.frame.size.height - ( (rowindex + 1) * sizerSize.height) },
//												sizerSize);
//		fileLayer.frame =
//		columnindex++;
//		if ( ! ((columnindex + 1) <= columns) ) { columnindex = 0; rowindex++; }

			//		CATransform3D rot = [self makeTransformForAngle:270];
			//      imageLayer.transform = rot;
			//		box.identifier = $(@"%ldx%ld", rowindex, columnindex);
	}];
	NSLog(@"root sublayer: %ld", [[self layer]sublayers].count);
	[self setNeedsDisplay:YES];

}

//- (void) viewWillDraw {
//	[self doLayout];
//}

- (id)initWithFrame:(NSRect)frame andFiles:(NSArray*)files
{
    self = [super initWithFrame:frame];
    if (self) {
		self.content = files.mutableCopy;
		[self setWantsLayer: YES];
		[self doLayout];
	}
    
    return self;
}

//- (void)drawRect:(NSRect)dirtyRect
//{
//    // Drawing code here.
//}

@end
