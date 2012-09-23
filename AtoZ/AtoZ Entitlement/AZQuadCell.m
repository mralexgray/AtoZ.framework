
//  AZQuadCell.m
//  AtoZ

//  Created by Alex Gray on 8/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "AZQuadCell.h"
#import <AtoZ/AtoZ.h>

@implementation AZQuadCell

- (id)initInWindow:(AZTrackingWindow*)window withObject:(id)thing atIndex:(NSUInteger)index
{
    self = [super initWithFrame:NSZeroRect];
    if (self) {
		[self setupHostView];


		NSSize trkrSize		= [[window contentView] bounds].size;
		
		CGFloat trkLong 	= window.orientation == AZOrientVertical ? trkrSize.height : trkrSize.width;

		trkLong = ( trkLong / (float) window.capacity );

		NSSize dim 			= window.orientation == AZOrientVertical ? (NSSize) { window.intrusion,  trkLong  }
							: (NSSize) { trkLong, 	window.intrusion };
		self.superWindow 	= window;
		self.position 		= window.position;
		self.frame 		=	AZMakeRectFromSize(dim);
		if (thing) {
			self.objectRep 	= 	thing;
			self.color 		= [thing class] == [NSColor class] ? thing
							: [thing respondsToSelector:@selector(color)] ? [thing color]
							: RANDOMCOLOR;
			self.string		= [thing class] == [AZFile class] ? [thing valueForKey:@"name"]
							: [thing valueForKey:@"string"];
		}
		if (!_color) self.color 		= RANDOMCOLOR;
		if (!_string) self.string		= $(@"%ld",index);

		self.layer.backgroundColor = [_color cgColor];
	
		CATextLayer *l = [CATextLayer layer];
		l.string =$(@"%ld", index);
//		l.string =$(@"%@%ld", _string.firstLetter, index);
		l.frame = [self bounds];
		l.font = (__bridge CFTypeRef)((id)@"Ubuntu Mono Bold");
		l.foregroundColor = [_color.contrastingForegroundColor cgColor];
		l.fontSize = self.font.pointSize;
		NSImage *s = [_objectRep valueForKey:@"image"];
		if (s) 	self.layer.contents = s;		//[(AZFile*)_objectRep image];
		[self.layer addSublayer:l];
//, [(NSColor*)[view valueForKey:@"backgroundColor"] nameOfColor])];
//		view.frame = AZMakeRectFromSize(dim);

    }

    return self;
}

- (CGFloat) dynamicStroke {
	return _dynamicStroke = AZMaxDim(self.bounds.size)  * .07;
}

- (void) awakeFromNib {
}

- (NSFont*) font {
	CGFloat size =  [@"M" pointSizeForFrame:[self bounds] withFont:@"Ubuntu Mono Bold"];
	return	_font  = [NSFont fontWithName:@"Ubuntu Mono Bold" size:size];
}


//[swatch lockFocus];
//[ico drawInRect:AZMakeRectFromSize(ico.size) fromRect:NSZeroRect operation:NSCompositeDestinationIn fraction:1];
//	operation:NSCompositeDestinationIn fraction:1];
//[NSShadow setShadowWithOffset:AZSizeFromDimension(3) blurRadius:10 color:c.contrastingForegroundColor];
//[string drawAtPoint:NSMakePoint(10,8)];
//[NSShadow clearShadow];
//[swatch unlockFocus];
//swatch = [swatch addReflection:.5];
//view = [[NSImageView alloc] initWithFrame:AZMakeRectFromSize(swatch.size)];
//[(NSImageView *)view setImage:swatch];


- (void)drawRect:(NSRect)dirtyRect
{

//	NSLog(@"%@", [(AZFile*)_objectRep colors]);
//	NSColor *tt = [[[(AZFile*)_objectRep colors]objectAtIndex:2] valueForKey:@"color"];
//	[self.color set];
//	NSRectFill([self bounds]);

// NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: desc.firstLetter attributes:@{ NSFontAttributeName: [NSFont fontWithName:@"Ubuntu Mono Bold" size:190],
		//													  NSForegroundColorAttributeName :WHITE} ];


//	NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
//	[self.color.contrastingForegroundColor set];
//	[style setAlignment:NSCenterTextAlignment];
//	NSDictionary *attr = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];

//	NSImage *s = [(AZFile*)_objectRep image];
//	s.size = [self bounds].size;

//	if  (_objectRop)
//	[self.color set];

//	[s drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeDestinationAtop fraction:1];


//	[tt set];
//	[s drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1];

			//	operation:NSCompositeDestinationIn fraction:1];
//	else
//	[self.string.firstLetter
//	[$(@"%i",2)	drawInRect:[self bounds] withFont:self.font andColor:self.color];

//	[self.string  drawWithFont:self.font];

}



@end
