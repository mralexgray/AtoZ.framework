

#import "AtoZ.h"
#import "AZSimpleView.h"

#pragma mark - TableRowView ... see Id in IB of "NSTableViewRowViewKey"


@implementation NSTableRowView (AtoZ)
- (id) object {  id table = self.enclosingView;  return [[table itemAtRow:self.index] representedObject]; }

- (NSUI) index { return [[self.enclosingView subviews] indexOfObject:self]; }

- (NSV*)enclosingView { 
	NSView* ov = self.superview;  																								 // Sneaky object finder
	while ((![ov ISKINDA:NSOV.class] || ![ov ISKINDA:NSTV.class]) && [ov superview]) { ov = [ov superview]; }
	return ov;	
}
@end

@implementation ColorTableRowView  @synthesize  xObjectValue = _objectValue;


- (void) awakeFromNib {		self.zLayer.delegate = self; 	

	[self.layer bind:@"colored" toObject:self withKeyPath:@"selected" options:nil]; 
}

//- (id<CAAction>) actionForLayer:(CALayer*)l forKey:(NSString*)e { 		CABasicAnimation *ca;
//
//	objswitch(@"colored") 
//		ca = [CABasicAnimation animationWithKeyPath:kBGC];  //		NSLog(@"self.x.parent::%@", self.x.parent);
//		NSColor  *c1 	=	(self.x.parent == nil) ?
//								[NSColor colorWithDeviceHue:0.168 saturation:0.942 brightness:0.612 alpha:1.000]:
//								[NSColor colorWithCalibratedRed:.78  green:0.772 blue:0.020 alpha:1.000],
//					*c2 	= 	[NSColor colorWithCalibratedRed:0.779 green:0.247 blue:0.020 alpha:1.000];
//		ca.fromValue 	= self.selected ?(id) c1.CGColor : (id)c2.CGColor;
//		ca.toValue 		= self.selected ?  (id)c2.CGColor :(id) c1.CGColor;
//		ca.duration 	= 2;
//		ca.fillMode 	= kCAFillModeForwards;
//		ca.removedOnCompletion  = NO;
//		return ca;
//	}
//	return ca;
//}
@end


@implementation AZSimpleView

+(instancetype)withFrame:(NSRect)frame color:(NSC*)c	{
	AZSimpleView *u = [AZSimpleView.alloc initWithFrame:frame];
	u.backgroundColor = c;
	return  u;
}
- (id)initWithFrame:(NSRect)frame	{ 	if (self != [super initWithFrame:frame]) return nil;
	_backgroundColor  = RANDOMGRAY;
	_glossy 	= _checkerboard = _clear = NO;  return  self;
}

-(void)	setFrameSizePinnedToTopLeft: (NSSize)siz	{

	NSR	theBox 	= self.frame;
	NSP	topLeft 	= theBox.origin;
	topLeft.y 	  += theBox.size.height;
	[self.superview setNeedsDisplayInRect: theBox];	// Inval old box.
	theBox.size 	= siz;
	topLeft.y 	  -= siz.height;
	theBox.origin 	= topLeft;
	[self setFrame:     theBox];
	[self setNeedsDisplay: YES];
}

- (void)drawRect:(NSRect)rect {

	if (_glossy) {
//		DrawGlossGradient([AZGRAPHICSCTXgraphicsPort],self.backgroundColor, [self bounds]);
		return;
	}
	else if (_gradient) {
		NSBezierPath *p =[NSBezierPath bezierPathWithRect: [self bounds]];// cornerRadius:0];
		[p fillGradientFrom:_backgroundColor.darker.darker.darker to:_backgroundColor.brighter.brighter angle:270];
		return;
	}
	else if (_checkerboard)	[[NSColor checkerboardWithFirstColor:_backgroundColor
												 secondColor:_backgroundColor.contrastingForegroundColor squareWidth:10]set];
	else [_clear ? CLEAR :  _backgroundColor ? _backgroundColor : RANDOMCOLOR set];
	NSRectFill( [self bounds] );

//		[[NSColor colorWithCalibratedRed:0.f green:0.5f blue:0.f alpha:0.5f] set];
//		[AZGRAPHICSCTX
//		 setCompositingOperation:NSCompositeClear];
//		[[NSBezierPath bezierPathWithRect:rect] fill];
//	}
//	else	{	[self.backgroundColor ? self.backgroundColor : [NSColor clearColor]   set];		NSRectFill(rect);	}

}
@end
@implementation AZSimpleGridView
@synthesize rows, columns, grid;

- (void)awakeFromNib {

	self.wantsLayer = YES;
	self.grid = self.layer;
	self.grid.backgroundColor = cgRANDOMCOLOR;
	self.grid.layoutManager = [CAConstraintLayoutManager layoutManager];

	[self setDimensions:(NSSize){8,8}];
}

-(void) setDimensions:(NSSize)dims {
	_dimensions = dims;
	rows = _dimensions.width; 	columns = _dimensions.height;

	for (int r = 0; r < rows; r++) {
		for (int c = 0; c < columns; c++) {
			CALayer *cell = [CALayer layer];
			cell.borderColor = cgGREY;
			cell.borderWidth = 1;
			cell.cornerRadius = 4;
			cell.name = [NSString stringWithFormat:@"%u@%u", c, r];
			cell.constraints = @[[CAConstraint constraintWithAttribute: kCAConstraintWidth
										relativeTo: @"superlayer"
										 attribute: kCAConstraintWidth
											 scale: 1.0 / columns  offset: 0],
			 [CAConstraint constraintWithAttribute: kCAConstraintHeight
										relativeTo: @"superlayer"
										 attribute: kCAConstraintHeight
											 scale: 1.0 / rows   offset: 0],
			 [CAConstraint constraintWithAttribute: kCAConstraintMinX
										relativeTo: @"superlayer"
										 attribute: kCAConstraintMaxX
											 scale: c / (float)columns   offset: 0],
			 [CAConstraint constraintWithAttribute: kCAConstraintMinY
										relativeTo: @"superlayer"
										 attribute: kCAConstraintMaxY
											 scale: r / (float)rows	offset: 0]];
			[grid addSublayer:cell];
		}
	}
}
@end
