#import "AZInfiniteCell.h"
#import "AtoZ.h"

@implementation AZInfiniteCell
@synthesize backgroundColor, selected, uniqueID, hovered, file;

- (void)drawRect:(NSRect)rect {
	//	NSBezierPath *p =[NSBezierPath bezierPathWithRect: [self bounds]];// cornerRadius:0];
	//	[p fillGradientFrom:backgroundColor.darker.darker.darker to:backgroundColor.brighter.brighter angle:270];
	[backgroundColor set];
	NSRectFill(rect);
}

- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super initWithCoder:coder])) {
		backgroundColor = [coder decodeObjectForKey: @"backgroundColor"];
		if	(!backgroundColor) backgroundColor = [NSColor redColor];
		uniqueID = [coder decodeObjectForKey: @"uniqueID"];
		file = [coder decodeObjectForKey:@"file"];
//		image = [coder decodeObjectForKey: @"image"];
//		atv = [coder decodeObjectForKey:@"atv"];
//		hasText = [coder decodeBoolForKey:@"hasText"];
//		if (atv)  [self addSubview:atv];
}	return self;	}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:backgroundColor forKey:@"backgroundColor"];
    [aCoder encodeObject:uniqueID forKey:@"uniqueID"];
    [aCoder encodeObject:file forKey:@"file"];
//	[aCoder encodeObject:image forKey:@"image"];	[aCoder encodeObject:atv forKey:@"atv"];		[aCoder encodeBool:hasText forKey:@"hasText"];
}
- (void) mouseEntered:(NSEvent *)theEvent {
	self.hovered = YES;
	if ([[NSApp delegate] respondsToSelector:@selector(simpleHovered:)])
		[[NSApp delegate] performSelector:@selector(simpleHovered:) withObject:self];
	NSLog(@"do I, bar for %@, listen to Mentered?", file.name);
}
- (void) mouseExited:(NSEvent *)theEvent {	self.hovered = NO;	}

- (void) mouseDown:(NSEvent *)theEvent {
	self.selected =! selected;		NSLog(@"%@", file);
}
@end


//- (NSAttributedString *) string {
//	string = nil;
//	string = [[NSAttributedString alloc] initWithString:
//			  [NSString stringWithFormat:@"NOT SO UNIQUE ID:\n%@\n\nSELECTED: %@ ", uniqueID,									StringFromBOOL(selected)]
//											 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
//														 [NSFont fontWithName:@"Ubuntu Mono Bold" size:15],
//														 NSFontAttributeName, backgroundColor.contrastingForegroundColor, NSForegroundColorAttributeName,nil]];
//	return string;
//}
//- (BOOL)isOpaque { return YES; }
//- (void)drawRect:(NSRect)rect {


	//	[backgroundColor set];//÷
	//	NSGradient *rrr = [[NSGradient alloc]initWithStartingColor:backgroundColor.darker.darker e/ndingColor:backgroundColor.brighter.brighter ];
	//	initWithColorsAndLocations:
	/*
	 backgroundColor.darker.darker,  	 0,
	 backgroundColor, 					.1,
	 backgroundColor, 					.9,
	 backgroundColor.darker.darker,		 1,nil]; */
	//	NSBezierPath *p =[NSBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:5 inCorners:OSBottomRightCorner];


	//angle:270];
	//    NSRectFill(rect);
	/*	if (image) {
	 NSRect r = self.bounds;
	 float max = (r.size.width > r.size.height ? r.size.height : r.size.width) * .8;
	 r.size = NSMakeSize(max, max);
	 [image setSize:r.size];
	 [image drawAtPoint:NSMakePoint(self.frame.size.width - (max*1.2), max*.1) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	 }
	 if (hasText) {
	 if (!atv) [self makeTextView];
	 [self addSubview:atv];
	 [[atv textStorage] setAttributedString:self.string];
	 }*/
//}

/*
 - (void) setSelected:(BOOL)isselected {

 selected = isselected;
 NSRect now = [self frame];
 now.size.height += 100;
 now.size.width += 100;
 now.origin.y -= 100;
 now.origin.x -= 100;
 [[self animator] setFrame:now];
 [self.itunesApi searchMediaWithType:kAJSiTunesAPIMediaTypeSoftware searchTerm:self.file.name countryCode:@"US" limit:1];

 //	self.backgroundColor = backgroundColor.complement;
 //	NSRect temp = [self frame];
 //	temp = AZScaleRect( temp, (isselected ? 15 : 1/15));
 //	[[self animator] setFrame:temp];
 //	[self setNeedsDisplay:YES];
 }*/

	//	id aView = self.superview;
	//	while (! [ aView isKindOfClass:[AZInfiniteScrollView class]])
	//		aView = [aView superview];
	//	[(AZInfiniteScrollView*)aView popItForView:self];
	//
	//	[self performSelector:@selector(makeThatWindowGirl) afterDelay:1];
	//}
	//- (void)makeThatWindowGirl {
	//
	//	if (!self.hovered) { self.selected = NO; return; }
	//	NSLog(@"makin windy for: %@", self.file.name);
	//	self.selected = YES;
	//
	////	self.windy = nil;
	////	[self.windy makeKeyAndOrderFront:self];
	////	AZTalker *f = [[AZTalker alloc]init];
	////	[f say:$(@"%@", self.file.name)];

	//	AZTalker *f = [[AZTalker alloc]init];
	//	[f say:$(@"%@", self.file.name)];
	//	id aView = self.superview;
	//	while (! [ aView isKindOfClass:[AZInfiniteScrollView class]])
	//		aView = [aView superview];
	//	[(AZInfiniteScrollView*)aView stack];
	//	self.windy = nil;


//-(BOOL)isOpaque { return YES; }


//- (void) iTunesApi:(AJSiTunesAPI *)api didCompleteWithResults:(NSArray *)results {
//	if ([api isEqualTo: self.itunesApi]) {
//		[results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//			NSLog(@"extra, extra: %@", [obj propertiesPlease] );
//		}];
//	} else NSLog(@"Yes I delegate, but not me, this time");
//
//}




//image, hasText, tArea, file, hovered;

/*
 - (void) animate {
 dispatch_queue_t queue = dispatch_queue_create("drawing", NULL);
 dispatch_async(queue, ^{
 [self drawInBackground];
 });
 }

 - (void)drawInBackground
 {
 while (1) {
 //		[NSThread sleepForTimeInterval:0.0000000001];
 if (![self lockFocusIfCanDraw]) { NSLog(@"no can draw"); continue;	}
 //		NSColor *color = rand() % 2 ? [NSColor greenColor] : [NSColor yellowColor];
 //		[color set];
 NSGradient *s = [[NSGradient alloc]initWithStartingColor:RANDOMCOLOR endingColor:RANDOMCOLOR];
 NSRect bounds = [self bounds];
 CGFloat x = rand() % (int)NSWidth(bounds);
 CGFloat y = rand() % (int)NSHeight(bounds);
 CGFloat w = rand() % (int)NSWidth(bounds) - x;
 CGFloat h = rand() % (int)NSHeight(bounds) - y;
 //		NSRectFill(
 float rando = RAND_FLOAT_VAL(50 ,20);
 NSSize rSize = NSMakeSize(rando, rando);
 [s drawInRect: NSMakeRect(x, y, w, h) angle:RAND_FLOAT_VAL(0,360)];
 //		NSImageView * iv = [[NSImageView alloc]initWithFrame:AZMakeRectFromSize(rSize)];
 //		[iv setImage:		[[[NSImage systemImages]  randomElement]
 //							 imageByScalingProportionallyToSize:rSize ]];
 //		[self addSubview:iv];
 //		[[[[NSImage systemImages]
 //			randomElement]
 //		 		imageByScalingProportionallyToSize:
 //				NSMakeSize(rando, rando) ]
 //					compositeToPoint:randomPointInRect([self frame]) operation:NSCompositeSourceOver];
 [self unlockFocus];
 NSThread *thread = [NSThread currentThread];
 //		NSLog(@"thread %@ ismainthread?: %d, concurrently %d", thread,[thread  isMainThread], [self canDrawConcurrently]);

 [[[self window] graphicsContext] flushGraphics];
 }
 }
 
 - (id)initWithFrame:(NSRect)frame {
 if (self = [super initWithFrame:frame]) {

 l = [CALayer layer];
 [self setLayer:l];
 [self setWantsLayer:YES];
 l.backgroundColor = cgRANDOMCOLOR;

 }
 return self;
 }

 if (self = [super initWithFrame:frame]) {
 tArea = [[NSTrackingArea alloc] initWithRect:[self frame]
 options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect |
 NSTrackingMouseMoved
 )
 owner:self
 userInfo:nil];
 [self addTrackingArea:tArea];
 file = nil;
 backgroundColor = nil;
 uniqueID = nil;
 //		atv = nil;
 //		hasText = NO;
 //		backgroundColor = [NSColor randomColor];
 //		self.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
 uniqueID = [NSString newUniqueIdentifier];
 //		self.itunesApi = [[AJSiTunesAPI alloc] init];
 //		self.itunesApi.delegate = self;
 */

//- (void)updateTrackingAreas
//{
//    if(!NSIntersectsRect([self frame], [[self superview] visibleRect]))
//    {
//        return;
//    }
//
//    // ...
//}
//- (void) makeTextView {
//
//	NSMutableParagraphStyle *theStyle =[[NSMutableParagraphStyle alloc] init];
//	[theStyle setLineSpacing:12];
//	atv = [[AZTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
//	[atv setSelectable:NO];
//	[atv setDefaultParagraphStyle:theStyle];
//	[atv setBackgroundColor:[NSColor clearColor]];
//	[[atv textStorage] setForegroundColor:[NSColor blackColor]];
//	//	[self addSubview: atv];
//}
