	//
	//  iCarouselWindowController.m
	//  iCarouselMac
	//
	//  Created by Nick Lockwood on 11/06/2011.
	//  Copyright 2011 Charcoal Design. All rights reserved.
	//

#import "iCarouselViewController.h"

@interface iCarouselViewController ()
@property (NATOM, ASS) iCarouselOption spacing;
@property (nonatomic, assign) BOOL wrap;
	//@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) NSUInteger scalar;

@end
@implementation iCarouselViewController
@synthesize form;
@synthesize size = _size, space = _space, multi = _multi;
@synthesize carousel = _carousel;
@synthesize wrap;
@synthesize scalar; //items
	//- (id)initWithWindow:(NSWindow *)window
	//{
	//    if ((self = [super ini initWithWindow:window]))
	//    {
	//        //set up data
	//        wrap = YES;
	////        self.items = [AtoZ dock];
	//		scalar = 1;
	////        for (int i = 0; i < 1000; i++)
	////        {
	////            [items addObject:[NSNumber numberWithInt:i]];
	////        }
	//    }
	//    return self;
	//}

- (void)awakeFromNib
{

		// Setup core animation
//	[self setView :_carousel];//setWantsLayer:true];
							  //	CALayer* rootLayer = [[self view] layer];

		// Create our container layer
		//	starfieldLayer = [CALayer layer];
		//        //set up data
	wrap = YES;
		////        self.items = [AtoZ dock];
	scalar = 1;

		//configure carousel
		//    _carousel.type = iCarouselTypeLinear;
		//		[[_carousel allSubviews] each:^(id obj, NSUInteger index, BOOL *stop) {
		//			[obj trackFullView];
		//		}];
	[self setDefs];
//	[[NSThread mainThread]performBlock:^{
//		[self orient:[[self view]layer] WithX:0 andY:0.3];
//		NSBeep();
//	}afterDelay:5];
}

- (void)orient:(CALayer*)layer WithX:(float)x andY:(float)y
{
	CATransform3D transform = CATransform3DMakeRotation(x, 0, 1, 0);
	transform = CATransform3DRotate(transform, y, 1, 0, 0);
	float zDistance = -450;
	transform.m34 = 1.0 / -zDistance;
		//	starfieldLayer.sublayerTransform = transform;
}
-(void)setVScale:(NSNumber *)vScale {
	_vScale = vScale;
	_carousel.viewpointOffset = (CGSize){0, _vScale.floatValue};
	[_carousel reloadData];
}

-(void)setCScale:(NSNumber *)cScale {

	_cScale = cScale;
	_carousel.contentOffset = (CGSize){0, _cScale.floatValue};
	[_carousel reloadData];
}

- (void)setDefs {
	_multi = 1;
	_size = 200;
	_space = 0;
	_carousel.type = RAND_INT_VAL(1,11);//iCarouselTypeCylinder;
	_iconStyle = RAND_INT_VAL(1,3);
		//	_carousel set÷ = [[AtoZ dockSorted]count];
//	_spacing = 1.0;
	_carousel.scrollEnabled = YES;
	_carousel.bounces = YES;
	/**This property is used to adjust the offset of the carousel item views relative to the center of the carousel. It defaults to CGSizeZero, meaning that the carousel items are centered. Changing this value moves the carousel items without changing their perspective, i.e. the vanishing point moves with the carousel items, so if you move the carousel items down, it does not appear as if you are looking down on the carousel.*/
//	_carousel.contentOffset = CGSizeMake(0.,50.0);
	/**This property is used to adjust the user viewpoint relative to the carousel items. It has the opposite effect to adjusting the contentOffset, i.e. if you move the viewpoint up then the carousel appears to move down. Unlike the contentOffset, moving the viewpoint also changes the perspective vanishing point relative to the carousel items, so if you move the viewpoint up, it will appear as if you are looking down on the carousel.*/
//	_carousel.viewpointOffset = CGSizeMake(0., 190.);
	/**Used to tweak the perspective foreshortening effect for the various 3D carousel views. Should be a negative value, less than 0 and greater than -0.01. Values outside of this range will yield very strange results. The default is -1/500, or -0.005;*/
	_carousel.perspective = -1.0f/1400.0f;
	_carousel.scrollSpeed = 6.0f;
	_carousel.ignorePerpendicularSwipes = YES;
	[_carousel reloadData];
		//	self.items = [AtoZ dockSorted];
		//	carousel.vertical = YES;
		//    [self.window makeFirstResponder:_carousel];

		//	[NSEvent addGlobalMonitorForEventsMatchingMask:NSScrollWheelMask handler:^(NSEvent *e) {
		//		NSInteger delt = floor(e.scrollingDeltaX + e.scrollingDeltaY);
		//		NSLog(@"delt: %@", e.description);
		//		[self.carousel scrollByNumberOfItems:delt duration:1];
		//	}];

}
- (IBAction)readFormAndReload:(id)sender {
	_carousel.perspective = -1.0f/[sender floatValue];
		//	_carousel.scrollSpeed = [[self.form selectTextAtRow:2 column:1] integerValue];//2.0f;
	[_carousel reloadData];
}
- (IBAction)setOffsets:(id)sender
{

	AZOffsetFields x =  (AZOffsetFields)[sender tag];

	NSSize viewp = self.carousel.viewpointOffset;
	NSSize cont = self.carousel.contentOffset;

	switch (x) {
		case AZOffsetFieldsCx:
			cont.width = [sender floatValue];
			break;
		case AZOffsetFieldsCy:
			cont.height = [sender floatValue];
			break;
		case AZOffsetFieldsVx:
			viewp.width = [sender floatValue];
			break;
		case AZOffsetFieldsVy:
			viewp.height = [sender floatValue];
			break;

		default:
			break;
	}
	_carousel.viewpointOffset = viewp;// CGSizeMake([[self.form selectTextAtRow:1 column:2] floatValue],[[self.form selectTextAtRow:2 column:2] floatValue]);
	_carousel.contentOffset = cont;//CGSizeMake([[self.form selectTextAtRow:1 column:3] floatValue],[[self.form selectTextAtRow:2 column:3] floatValue]);

	[_carousel reloadData];
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

	NSView *v = [_carousel itemViewAtIndex:index];
		//	[AtoZiTunes searchForFile:[[AtoZ currentScope]objectAtIndex:index]];
		// [[[AtoZ dockSorted]objectAtIndex:index]valueForKey:@"name"]];
		//	NSLog(@"response: %@", r);
	NSLog(@"selected allsubvs: %@", v.allSubviews);
	AZLassoView *lassie = [v.allSubviews filterOne:^BOOL(id object) {
		return  ([object isKindOfClass:[AZLassoView class]] ? YES : NO);
	}];
	lassie.selected= YES;
	[[[carousel allSubviews] filter:^BOOL(id object) {

		if ([object isEqualTo:lassie]) return  NO;
		else if ([object isKindOfClass:[AZLassoView class]]) return YES;
		else return NO;
	}] az_each:^(AZLassoView* obj, NSUInteger index, BOOL *stop) {
		AZLOG(@"Ridem cowboy")
		obj.selected = NO;
	}];

	self.attacheView = [AZBlockView viewWithFrame:AZSquareFromLength(200)  opaque:YES drawnUsingBlock: ^(AZBlockView *view, NSRect dirtyRect) {
		NSBezierPath *path = [NSBezierPath bezierPathWithRect:[view bounds]];
		[RANDOMCOLOR set];
		[path fill];
	}];
	self.attache = [[AZAttachedWindow alloc] initWithView:self.attacheView attachedToPoint:AZCenterOfRect(lassie.frame)];
	[_attache setLevel:NSFloatingWindowLevel];
	[_attache orderFrontRegardless];

//	[ attachedToPoint:  attachedToPoint: AZCenteredRect( [[_carousel itemViewAtIndex:index]frame]) inWindow:[self.carousel window] onSide:AZPositionBottom atDistance:0];
//	[[_carousel window]
//	[addChildWindow:_attache ordered:NSWindowAbove];

//	[_attache makeKeyAndOrderFront:_attache];
	NSString *url = $(@"http://api.alternativeto.net/software/%@/?count=5&platform=mac", [[[AtoZ dockSorted]objectAtIndex:index]valueForKey: @"name"]);// urlEncoded];

	NSLog(@"%@", [AtoZ jsonReuest:url]);

		//	AZBox *b = [[AZBox alloc]initWithFrame:v.frame];
		//	[v addSubview:b];
		//	[b setSelected:YES];
		//	[b setHovered:YES];
		//	[v setNeedsDisplay:YES];

}

- (void)carousel:(iCarousel *)carousel shouldHoverItemAtIndex:(NSInteger)index{
	NSView *v = [carousel itemViewAtIndex:index];
	AZLassoView *lassie = [v.allSubviews filterOne:^BOOL(id object) {
		return  ([object isKindOfClass:[AZLassoView class]] ? YES : NO);
	}];
	lassie.hovered = YES;
	[[[carousel allSubviews] filter:^BOOL(id object) {

		if ([object isEqualTo:lassie]) return  NO;
		else if ([object isKindOfClass:[AZLassoView class]]) return YES;
		else return NO;
	}] az_each:^(AZLassoView* obj, NSUInteger index, BOOL *stop) {
		AZLOG(@"remove the rope");  obj.hovered = NO;
	}];

}

- (void)dealloc
{
		//it's a good idea to set these to nil here to avoid
		//sending messages to a deallocated window or view controller
	_carousel.delegate = nil;
	_carousel.dataSource = nil;

		//    [self.carousel release];
		//    [super dealloc];
}

-(void)setSize:(float)size {

	_size = size;
	[self setDefs];

}

-(void)setSpace:(float)space{
	_space = space;
	[_carousel reloadData];
}

-(void)setMulti:(float)multi{
	_multi = multi;
	[_carousel reloadData];
}
- (IBAction)setScaleFactor:(id)sender {
	self.scalar = floor([sender floatValue]);
	[self setDefs];
		//	[_carousel reloadData];
}

/*- (IBAction)switchCarouselType:(id)sender
{
		//restore view opacities to normal
    for (NSView *view in _carousel.visibleItemViews)
    {
        view.layer.opacity = 1.0;
    }

    self.carousel.type = (iCarouselType)[sender tag];
}
*/
- (void) setType:(iCarouselType)type {

	_type = type;
	self.carousel.type = _type;
	[_carousel reloadData];
}
- (IBAction)toggleVertical:(id)sender
{
    self.carousel.vertical = !_carousel.vertical;
//    [sender setState:_carousel.vertical? NSOnState: NSOffState];
}

- (IBAction)toggleWrap:(id)sender
{
    wrap = !wrap;
//    [sender setState:wrap? NSOnState: NSOffState];
    [_carousel reloadData];
}

- (IBAction)insertItem:(id)sender
{
    [_carousel insertItemAtIndex:_carousel.currentItemIndex animated:YES];
}

- (IBAction)removeItem:(id)sender
{
    [_carousel removeItemAtIndex:_carousel.currentItemIndex animated:YES];
}
#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSUInteger c = [[AtoZ dockSorted] count];
//	NSLog(@"number of ites in carousel (docksorted class  %ld", c);
	return c;
}

- (NSView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(NSView *)view {
if (!view) {
		//    NSTextField *label = nil;
	if (view == nil)     //create new view if no view is available for recycling
	{
		AZFile* f = [[AtoZ dockSorted]objectAtIndex:index];   NSColor *c = f.color;
		if (!c) { 		NSLog(@"no colore! reload! (idx:%ld)",index); [carousel reloadData]; }
		NSLog(@"view nil, making it (idx:%ld), again", index);
		NSImage *ico = 	f.image;
		NSSize icosize = AZSizeFromDimension(self.size);
		NSRect icorect = AZSquareFromLength(self.size);
		NSString *desc = $(@"%@: %ld",[[[AtoZ dockSorted]objectAtIndex:index]valueForKey:@"name"], index);
		NSImage *swatch = [NSImage swatchWithGradientColor:c size:icosize];
		NSMutableParagraphStyle *theStyle =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[theStyle setLineBreakMode:NSLineBreakByWordWrapping];
		[theStyle setAlignment:NSCenterTextAlignment];

		switch (_iconStyle) {
			case 1: {
					//		if (c) image = [image tintedWithColor:c];

					//[self carouselItemWidth:_carousel], _carousel.frame.size.height)];
				[swatch lockFocus];
				[NSShadow setShadowWithOffset:AZSizeFromDimension(6) blurRadius:10 color:c.contrastingForegroundColor];
				[[ico filteredMonochromeEdge] drawCenteredinRect:icorect operation:NSCompositeSourceOver fraction:1];
				[NSShadow clearShadow];
				[desc drawAtPoint:NSZeroPoint withAttributes:@{ NSParagraphStyleAttributeName: theStyle, NSForegroundColorAttributeName: WHITE, NSFontSizeAttribute: @55 } ];
				[swatch unlockFocus];
				swatch = [swatch addReflection:.5];
				view = [[NSImageView alloc] initWithFrame:AZMakeRectFromSize(swatch.size)];
				view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
				[(NSImageView *)view setImage:swatch];
				[(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
				break;
			}
			case 2: {
					//		if (c) image = [image tintedWithColor:c];
					//[self carouselItemWidth:_carousel], _carousel.frame.size.height)];
				[swatch lockFocus];
				[ico drawInRect:icorect fromRect:NSZeroRect operation:NSCompositeDestinationIn fraction:1];
					//	[[ico filteredMonochromeEdge] drawCenteredinRect:icorect/*AZRightEdge(AZUpperEdge(icorect, 40), 40) */ operation:NSCompositeDestinationIn fraction:1];
					//	[[ico filteredMonochromeEdge] drawCenteredinRect:AZRightEdge(AZUpperEdge(icorect, 40), 40) operation:NSCompositeSourceOver fraction:1];
				NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: desc.firstLetter attributes:@{ NSFontAttributeName: [NSFont fontWithName:@"Ubuntu Mono Bold" size:190],
																	  NSForegroundColorAttributeName :WHITE} ];
					//			[theStyle setLineSpacing:12];
					//			NSTextView *atv = [[NSTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
					//			[atv setDefaultParagraphStyle:theStyle];
					//			[atv setBackgroundColor:CLEAR];
					//			[[atv textStorage] setForegroundColor:BLACK];
					//			[[atv textStorage] setAttributedString:string];
				[NSShadow setShadowWithOffset:AZSizeFromDimension(3) blurRadius:10 color:c.contrastingForegroundColor];
				[string drawAtPoint:NSMakePoint(10,8)];
				[NSShadow clearShadow];
					//			[string drawAtPoint:NSZeroPoint withAttributes:@{ NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: WHITE, NSFontSizeAttribute: @200 } ];// withAttributes:att];
				[swatch unlockFocus];
				swatch = [swatch addReflection:.5];
				view = [[NSImageView alloc] initWithFrame:AZMakeRectFromSize(swatch.size)];
					//			view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
				[(NSImageView *)view setImage:swatch];
					//			[(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
				break;
			}
			case 3:
			default: {
					//		if (c) image = [image tintedWithColor:c];

					//[self carouselItemWidth:_carousel], _carousel.frame.size.height)];
				[swatch lockFocus];
				[NSShadow setShadowWithOffset:AZSizeFromDimension(6) blurRadius:10 color:BLACK];
				[[ico filteredMonochromeEdge] drawInRect:icorect fromRect:NSZeroRect operation:NSCompositeDestinationIn fraction:1];
					//			[[ico coloredWithColor:c.contrastingForegroundColor] drawCenteredinRect:icorect operation:NSCompositeSourceOver fraction:1];
				[NSShadow clearShadow];
				[desc drawAtPoint:NSZeroPoint withAttributes:@{ NSParagraphStyleAttributeName: theStyle, NSForegroundColorAttributeName: WHITE, NSFontSizeAttribute: @55 } ];
				[swatch unlockFocus];
				swatch = [swatch addReflection:.5];
				view = [[NSImageView alloc] initWithFrame:AZMakeRectFromSize(swatch.size)];
				view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
				[(NSImageView *)view setImage:swatch];
				[(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
				break;
			}
		}
			//        label = [[[NSTextField alloc] init] autorelease];
			//        [label setBackgroundColor:[NSColor clearColor]];
			//        [label setBordered:NO];
			//        [label setSelectable:NO];
			//        [label setAlignment:NSCenterTextAlignment];
			//        [label setFont:[NSFont fontWithName:[[label font] fontName] size:10]];
			//        label.tag = 1;
			//        [view addSubview:label];

		AZLassoView *b = [[AZLassoView alloc]initWithFrame:AZUpperEdge(view.frame, 200)];
		[view addSubview:b];

	}
		//	else
		//	{
		//get a reference to the label in the recycled view
		//		label = (NSTextField *)[view viewWithTag:1];
		//	}

		//set item label
		//remember to always set any properties of your carousel item
		//views outside of the `if (view == nil) {...}` check otherwise
		//you'll get weird issues with carousel item content appearing
		//in the wrong place in the carousel
		//	[label setStringValue:(NSString*)[[AtoZ dockSorted][index] valueForKey:@"name"]];//]firstLetter]];//[NSString stringWithFormat:@"%lu", index]];
		//    [label sizeToFit];
		//    [label setFrameOrigin:NSMakePoint((view.bounds.size.width - label.frame.size.width)/2.0,
		//                                      (view.bounds.size.height - label.frame.size.height)/2.0)];
		//	NSRect exist = view.frame;
		//	exist.size.width = [self carouselItemWidth:carousel];
		//	view.frame = exist;
	} 
	[view setNeedsDisplay:YES];
	return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
		//note: placeholder views are only displayed if wrapping is disabled
	return 0;
}
/*
 - (NSView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(NSView *)view
 {
 NSTextField *label = nil;

 //create new view if no view is available for recycling
 if (view == nil)
 {
 NSImage *image = [NSImage imageNamed:@"page.png"];
 view = [[[NSImageView alloc] initWithFrame:NSMakeRect(0,0,image.size.width,image.size.height)] autorelease];
 [(NSImageView *)view setImage:image];
 [(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];

 label = [[[NSTextField alloc] init] autorelease];
 [label setBackgroundColor:[NSColor clearColor]];
 [label setBordered:NO];
 [label setSelectable:NO];
 [label setAlignment:NSCenterTextAlignment];
 [label setFont:[NSFont fontWithName:[[label font] fontName] size:50]];
 label.tag = 1;
 [view addSubview:label];
 }
 else
 {
 //get a reference to the label in the recycled view
 label = (NSTextField *)[view viewWithTag:1];
 }

 //set item label
 //remember to always set any properties of your carousel item
 //views outside of the `if (view == nil) {...}` check otherwise
 //you'll get weird issues with carousel item content appearing
 //in the wrong place in the carousel
 [label setStringValue:[self.items[index] valueForKey:@"name"]];//(index == 0)? @"[": @"]"];
 [label sizeToFit];
 [label setFrameOrigin:NSMakePoint((view.bounds.size.width - label.frame.size.width)/2.0,
 (view.bounds.size.height - label.frame.size.height)/2.0)];

 return view;
 }
 */
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
		//set correct view size
		//because the background image on the views makes them too large
    return _carousel.itemWidth;// size;// _scalar * 30;//[[self window]frame].size.width/([[AtoZ dockSorted] count]/self.scalar);// 200.0f;
}

	//- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
	//{
	//    //implement 'flip3D' style carousel
	//    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
	//    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
	//}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
		//customize carousel display
    switch (option)
    {

//        case 	iCarouselOptionVisibleItems:
//			return 	[self ];
			//		This is the maximum number of item views (including placeholders) that should be visible in the carousel at once. Half of this number of views will be displayed to either side of the currently selected item index. Views beyond that will not be loaded until they are scrolled into view. This allows for the carousel to contain a very large number of items without adversely affecting performance. iCarousel chooses a suitable default value based on the carousel type, however you may wish to override that value using this property (e.g. if you have implemented a custom carousel type).

//		case 	iCarouselOptionOffsetMultiplier:
//			return 	self.multi;//value;
//			return 4;// 	RAND_INT_VAL(0,5);//, <#double end#>).multi;//value;
		 //		The offset multiplier to use when the user drags the carousel with their finger. It does not affect programmatic scrolling or deceleration speed. This defaults to 1.0 for most carousel types, but defaults to 2.0 for the CoverFlow-style carousels to compensate for the fact that their items are more closely spaced and so must be dragged further to move the same distance.

		case 	iCarouselOptionCount:
			return  [[AtoZ dockSorted] count];//);RAND_INT_VAL(3,
//		The number of items to be displayed in the Rotary, Cylinder and Wheel transforms. Normally this is calculated automatically based on the view size and number of items in the carousel, but you can override this if you want more precise control of the carousel appearance. This property is used to calculate the carousel radius, so another option is to manipulate the radius directly.

		case 	iCarouselOptionWrap:
			return 	YES;//RAND_BOOL();
						//		boolean indicating whether the carousel should wrap when it scrolls to the end. Return YES if you want the carousel to wrap around when it reaches the end, and NO if you want it to stop. Generally, circular carousel types will wrap by default and linear ones won't. Don't worry that the return type is a floating point value - any value other than 0.0 will be treated as YES.*/

        case 	iCarouselOptionSpacing:
			return 1;//	RAND_FLOAT_VAL(0, 2*self.carousel.itemWidth);//.space;
					 // 		The spacing between  item views. This value is multiplied by the item width (or height, if the carousel is vertical) to get the total space between each item, so a value of 1.0 (the default) means no space between views (unless the views already include padding, as they do in many of the example projects).
					 // 	Reduce item spacing to compensate for drop shadow and reflection around views

        case	iCarouselOptionShowBackfaces:
			return  YES;
				//		For some carousel types, e.g. iCarouselTypeCylinder, the rear side of some views can be seen (iCarouselTypeInvertedCylinder now hides the back faces by default). If you wish to hide the backward-facing views you can return NO for this option. To override the default back-face hiding for the iCarouselTypeInvertedCylinder, you can return YES. This option may also be useful for custom carousel transforms that cause the back face of views to be displayed.*/

		case	iCarouselOptionArc:
				//			return 	RAND_FLOAT_VAL(.3, 2*M_PI);
			return value;
				//		The arc of the Rotary, Cylinder and Wheel transforms (in radians). Normally this defaults to 2*M_PI (a complete circle) but you can specify a smaller value, so for example a value of M_PI will create a half-circle or cylinder. This property is used to calculate the carousel radius and angle step, so another option is to manipulate those values directly.

		case	iCarouselOptionAngle:
			return 	value;
				//		The angular step between each item in the Rotary, Cylinder and Wheel transforms (in radians). Manipulating this value without changing the radius will cause a gap at the end of the carousel or cause the items to overlap.

		case	iCarouselOptionRadius:
			return 	value;
				//		The radius of the Rotary, Cylinder and Wheel transforms in pixels/points. This is usually calculated so that the number of visible items exactly fits into the specified arc. You can manipulate this value to increase or reduce the item spacing (and the radius of the circle).

		case	iCarouselOptionTilt:
			return 	value;
				//		The tilt applied to the non-centered items in the CoverFlow, CoverFlow2 and TimeMachine carousel types. This value should be in the range 0.0 to 1.0.

        case iCarouselOptionFadeMax:
				//			if (self.carousel.type == iCarouselTypeCustom)
				//		return 	1.0f;                 //set opacity based on distance from camera
			return 	value;
		case	iCarouselOptionFadeMin:
			return 	value;
		case	iCarouselOptionFadeRange:
			return 	value;
				// These three options control the fading out of carousel item views based on their offset from the currently centered item. FadeMin is the minimum negative offset an item view can reach before it begins to fade. FadeMax is the maximum positive offset a view can reach before if begins to fade. FadeRange is the distance the item can move between the point at which it begins to fade and the point at which it becomes completely invisible.
			
		default:
			return 	value;
			
    }
}
@end
