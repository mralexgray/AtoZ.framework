#import "AZInfiniteCell.h"


@implementation AZInfiniteCell
@synthesize backgroundColor, selected, uniqueID, hovered, file;
@synthesize cellIdentifier, dynamicStroke;//, index;
@synthesize inset, radius, representedObject;


- (void)setFile:(AZFile *)aFile {
	file = aFile;
	[self setRepresentedObject:aFile];
}
//- (void)setRepresentedObject:(id)anObjectRep {
//	representedObject = anObjectRep;
//	if ( [representedObject isKindOfClass:[AZFile class]] ){
//		AZFile *c = representedObject;
		//		gradient = [[NSGradient alloc] initWithStartingColor:c.color.brighter.brighter endingColor:c.color.darker.darker];
//		color = c.color;
//		image = [ c.image coloredWithColor:c.color.contrastingForegroundColor];

		//		NSImage *ci =  (selected_ ? [ c.image tintedWithColor:c.color] : c.image);
//		[image setScalesWhenResized: YES];
//	}

//	dynamicStroke = 5;
//	inset = dynamicStroke;
//	radius = dynamicStroke;

	//		self.color = [representedObject_ valueForKey:@"color"];
	//	} else { NSColor *r = RANDOMCOLOR;
	//		while ( (![r isRedish]) || ([r isBoring]) ) r = RANDOMCOLOR;
	//		self.color = r;
	//	}
	//	if ([representedObject_ isKindOfClass:[NSImage class]]) self.image = representedObject_;
	//	if ([representedObject_ valueForKeyPath:@"dictionary.color"] )
	//		self.color = [representedObject_ valueForKeyPath:@"dictionary.color"];
	//	tv = self.tv;//	[self makeTv];
	//	[self addSubview:tv];
//}


- (void)handleAntAnimationTimer:(NSTimer*)timer {
	mPhase = (mPhase < [self halfwayWithInset] ? mPhase + [self halfwayWithInset]/128 : 0);
	[self setNeedsDisplayInRect:NSInsetRect([self bounds], self.inset, self.inset)];
}
//- (float) dynamicStroke {
//	//	NSBezierPath *bez = [self pathWithInset:self.inset];
//	//	if (bez.bounds) {
//	//		NSLog(@"BEZ: %@", NSStringFromRect( bez.bounds));
//	//		return (.1 * MIN((int)bez.bounds.size.width, (int)bez.bounds.size.height) );
//	//	} else
//	return 5;
//}

- (float) halfwayWithInset {
	NSRect dim = NSInsetRect(self.bounds, self.inset, self.inset);
	return ( (2*dim.size.width) + (2*dim.size.height) - (( 8 - ((2 * pi) * self.radius))));
}

- (NSBezierPath*) pathWithInset:(float)anInset {

	//	if (MIN(self.bounds.size.width, self.bounds.size.height) < anInset * 2) return nil; else
	return [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds, anInset, anInset) xRadius:self.radius yRadius:self.radius];
}

- (NSTextView*) tv {
	NSColor *theColor = [self.representedObject valueForKey:@"color"];
	if (theColor == nil) return nil;
	float hue = [theColor hueComponent];
	float sat = [theColor saturationComponent];
	float lum = [theColor luminance];
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: $(@"H:%0.1f\nS:%0.1f\nL:%0.1f", hue,sat,lum) attributes:$map(
																																						[NSFont fontWithName:@"Ubuntu Mono Bold" size:15],
																																						NSFontAttributeName, BLACK, NSForegroundColorAttributeName)];
	NSMutableParagraphStyle *theStyle =[[NSMutableParagraphStyle alloc] init];
	[theStyle setLineSpacing:12];
	NSTextView *atv = [[NSTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
	[atv setDefaultParagraphStyle:theStyle];
	[atv setBackgroundColor:CLEAR];
	[[atv textStorage] setForegroundColor:BLACK];
	[[atv textStorage] setAttributedString:string];
	return atv;
}

- (void)drawRect:(NSRect)dirtyRect
{
	standard =[NSBezierPath bezierPathWithRect: [self bounds]];// cornerRadius:0];
	[standard fillGradientFrom:file.color.darker.darker.darker to:file.color.brighter.brighter angle:270];
//	[backgroundColor set];
//	NSRectFill([self frame]);

//	standard = [self pathWithInset:self.inset];
//	[NSShadow setShadowWithOffset:NSMakeSize(3,-3) blurRadius:self.inset color:BLACK];
//	[standard stroke];
//	[NSShadow clearShadow];
/*	if ( [self.representedObject isKindOfClass:[AZFile class]] ){
		AZFile *c = self.representedObject;
		NSLog(@"hhoray.. %@ passed the drawrect test", c.name);
		if (c.colors) {
			__block int totes = c.colors.count;
			__block float boxWide = (self.bounds.size.width - 4*self.inset) / totes ;
			[[c.colors valueForKeyPath:@"color"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				NSColor *x = obj;
				[x set];
				NSRectFillUsingOperation( NSMakeRect(
													 ( 2 * inset)+ (idx*boxWide), self.bounds.size.height - boxWide - (3 * inset), boxWide, boxWide) , NSCompositeSourceOver);
			}];
		}
		float halfW = self.bounds.size.width/2;
		float halfH = self.bounds.size.height/2;
		float smallest = MIN(halfH,halfW);
		[image setSize: NSMakeSize(smallest, smallest)];
		[image compositeToPoint:AZCenterOfRect([self bounds]) operation:NSCompositeSourceOver];
	}
//	if(hovered)
//		[standard fillGradientFrom: RANDOMCOLOR to:RANDOMCOLOR angle:270];
//	else
*/
	if(selected) {
		[standard setLineWidth: AZMinDim(self.bounds.size)*.04];
		[standard setLineJoinStyle:NSBevelLineJoinStyle];
		[standard setLineCapStyle:NSButtLineCapStyle];//NSSquareLineCapStyle];//NSRoundLineCapStyle];//
		[WHITE set];
		[standard strokeInside];
		// strokeInsideWithinRect:NSInsetRect([self bounds], inset_*2, inset_*2)];
		float slice = ([self halfwayWithInset]/32);
		CGFloat dashArray[2] = { slice, slice};
		[standard setLineDash:dashArray count:2 phase:mPhase];
		[BLACK set];
		[standard strokeInside];
		//WithinRect:NSInsetRect([self bounds], inset_*2, inset_*2)];
//		DrawLabelAtCenterPoint([representedObject valueForKey:@"name"], NSMakePoint(NSMidX(self.bounds),NSMidY(self.bounds)));
	}
//	else {
//		if (!color) color = RANDOMCOLOR;
//		[color set];
//		[standard setClip];
//		NSRectFill(NSZeroRect);
//	}
//*/
}
- (void)setInset:(float)anInset {
	self.inset = anInset;
	[self setNeedsDisplay:YES];
}

- (void) mouseEntered:(NSEvent *)theEvent {
	self.hovered = YES;
	if ([[NSApp delegate] respondsToSelector:@selector(simpleHovered:)])
		[[NSApp delegate] performSelector:@selector(simpleHovered:) withObject:self];
	NSLog(@"do I, bar for %@, listen to Mentered?", file.name);
	[[self nextResponder] mouseMoved:theEvent];

}
- (void) :(NSEvent *)theEvent {	self.hovered = NO;
	[[self nextResponder] mouseMoved :theEvent];
}

- (void) mouseDown:(NSEvent *)theEvent {
	self.selected =! selected;
	if (!selected) { [timer invalidate]; [self setNeedsDisplay:YES]; }
	else { mPhase = 0; timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handleAntAnimationTimer:) userInfo:nil repeats:YES];
	}
	[[self nextResponder] mouseDown:theEvent];

}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	NSLog(@"nibawakening, not. init");
	self.autoresizingMask =  NSViewHeightSizable;
    }
    return self;
}

- (void) updateTrackingAreas {
	if (tArea) {
		[self removeTrackingArea:tArea];
		tArea = nil;
	}
	tArea = [[NSTrackingArea alloc]initWithRect:[self bounds] options: NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways 	 owner:self userInfo:nil];
	[self addTrackingArea:tArea];

}

- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super initWithCoder:coder])) {
		NSLog(@"initing with that darn coder");
		backgroundColor = [coder decodeObjectForKey: @"backgroundColor"];
		if	(!backgroundColor) backgroundColor = [NSColor redColor];
		uniqueID = [coder decodeObjectForKey: @"uniqueID"];
		file = [coder decodeObjectForKey:@"file"];
		[self updateTrackingAreas];
		//		image = [coder decodeObjectForKey: @"image"];
		//		atv = [coder decodeObjectForKey:@"atv"];
		//		hasText = [coder decodeBoolForKey:@"hasText"];
		//		if (atv)  [self addSubview:atv];
	}	return self;	}

- (id)copyWithZone:(NSZone *)zone;
{
    return self;// retain];
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:backgroundColor forKey:@"backgroundColor"];
    [aCoder encodeObject:uniqueID forKey:@"uniqueID"];
    [aCoder encodeObject:file forKey:@"file"];
	//	[aCoder encodeObject:image forKey:@"image"];	[aCoder encodeObject:atv forKey:@"atv"];		[aCoder encodeBool:hasText forKey:@"hasText"];
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


