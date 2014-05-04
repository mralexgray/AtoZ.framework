//  ContentsView.m
//  CoreAnimationToggleLayer
//  Created by Tomaz Kragelj on 8.12.09.
//  Copyright (C) 2009 Gentle Bytes. All rights reserved.

#import "AtoZ.h"
#import "AZToggleArrayView.h"

//	Change to YES to enable colored frames - useful for debugging layers layout
#define kGBEnableLayerDebugging NO
#define kGBDebugLayerBorderColor kGBEnableLayerDebugging ? CGColorCreateGenericRGB(1.0f, 0.0f, 1.0f, 0.3f) : cgRED
#define kGBDebugLayerBorderWidth kGBEnableLayerDebugging ? 3.0f : 1.0f

NSString *const AZToggleLabel 	= @"AZToggleLabel";
NSString *const AZToggleRel 		= @"AZToggleRelativeTo";
NSString *const AZToggleOff 		= @"AZToggleOff";
NSString *const AZToggleOn			= @"AZToggleOn";
NSString *const AZToggleState		= @"AZToggleState";

@interface AZToggleArrayView ()	//(UserInteraction)
@property (STRNG, NATOM) CAL *containerLayer, *rootLayer;
- (AZToggleControlLayer*) toggleLayerForEvent:(NSE*)event;
- (CGP) layerLocationForEvent:(NSE*)event;
@end

//@implementation AZToggleArrayView
//- (id) layerForToggle:(AZToggle*)toggle {	[[toggle codableKeys]	CALayer *l = [CALayer layer];	return  itemW]	}
//@end

@implementation AZToggleArrayView

#pragma mark Initialization & disposal

- (void) awakeFromNib 	{
	self.layer = self.rootLayer;
	self.wantsLayer = YES;
//	[[self window] makeFirstResponder:self];
}
- (BOOL) acceptsFirstResponder { return YES; }

- (AZOrient) orientation {
	return _orientation = [(NSO*)_datasource respondsToString:@"orientationOfToggleView:"]
							  ? [_datasource toggleOrientationForView:self] : _orientation ?: AZOrientHorizontal;
}
- (CAL*) rootLayer			{
	if (_rootLayer) return _rootLayer;
	_rootLayer = [CALayer layerNamed:@"root"];
	_rootLayer.arMASK = CASIZEABLE;
	_rootLayer.bounds = self.bounds;
	_rootLayer.backgroundColor 	=  cgRED;
	_rootLayer.layoutManager = AZLAYOUTMGR;
	_rootLayer.sublayers = @[self.containerLayer];
	return _rootLayer;
}
- (CAL*) containerLayer	{
	if (_containerLayer) return _containerLayer;
	_containerLayer = [CALayer layerNamed: @"container"];
	_containerLayer.backgroundColor 	=  [[WHITE alpha:.4]CGColor];											// CGColorCreateGenericRGB(0.,0.,0.,1.);
	_containerLayer.borderColor	 	= cgPURPLE;
	_containerLayer.borderWidth	 	= 2.0;
	_containerLayer.arMASK 				= CASIZEABLE;
	_containerLayer.layoutManager   	= AZLAYOUTMGR;
	_containerLayer.constraints	 	= @[	AZConstRelSuper(kCAConstraintMidX),
														AZConstRelSuperScaleOff(kCAConstraintWidth, .5, 0), 		//-20f
														AZConstRelSuper(kCAConstraintMidY),
														AZConstRelSuperScaleOff(kCAConstraintHeight, 1, 0) ];  	//-20.0f
	
//	if ([_datasource respondsToSelector:@selector(toggleForView:atIndex:)] &&
//		 [_datasource respondsToSelector:@selector( toggleCountforView:)] ) 
//	{	
	NSUI ct = [_datasource toggleCountForView:self];
	AZOrient oreo = [_datasource toggleOrientationForView:self];
	_containerLayer.sublayers = [[@0 to:@(ct)] nmap:^id(id obj, NSUInteger i) {
			NSS* relativeName = $(@"toggleUnit%ld", i);
			CAL *toggleUnit = [CAL layerNamed:relativeName];
//			toggleUnit.arMASK = CASIZEABLE;
			toggleUnit.bgC = cgRANDOMCOLOR;
			NSR r = self.bounds;
			r.size.height = r.size.height / (float)ct;
			r.origin.y = i * r.size.height;
			toggleUnit.frame = r;
			toggleUnit.loM = AZLAYOUTMGR; 
			CGF miny = i/(float)ct;
		AZLOG($(@"ct:  %ld, vertrel: %f",ct, miny));
			NSLog(@"rect:%@", AZStringFromRect([obj rectValue]));
			
			
			AZTCL *toggle 	= [_datasource toggleForView:self atIndex:i];
			toggle.onStateText = @"poop";
			toggle.name = [obj stringValue];
//			toggle.backgroundColor = cgRANDOMCOLOR;
			toggle.constraints = @[ 		AZConstRelSuperScaleOff	(kCAConstraintMaxX,1,-5.0f),
												  AZConstRelSuper				(kCAConstraintMidY)	];
			toggle.size = (NSSZ) { 80, 24 };
			
			NSS	*label 			= [_datasource toggleLabelForView:self atIndex:i] ?: @"";
			CATXTL *labelLayer   = [self itemTextLayerWithName:label];
			labelLayer.constraints	= 	@[ 	AZConstRelSuper(kCAConstraintMidX),
		 								AZConstRelSuperScaleOff( kCAConstraintWidth, 1, -10.0 )];//,
			labelLayer.height = 30;// forKeyPath:@"frame.size.height"];
			toggleUnit.sublayers	 = @[ labelLayer, toggle]; 
//			AddTextLayer(toggleUnit, @"hello", AtoZ.controlFont, CASIZEABLE);
			return toggleUnit;
	}]; 
	return _containerLayer;
}	
		
//	NSA* rects = [[NSA from:0 to:ct]nmap:^id(id obj, NSUInteger index) {
//		NSR r;
//		r.size.width 	= oreo == AZOrientHorizontal ? _rootLayer.boundsWidth /ct : _rootLayer.boundsWidth;
//		r.size.height 	= oreo == AZOrientHorizontal ? _rootLayer.boundsWidth	 : _rootLayer.boundsWidth / ct;
////		r.origin.x 		= oreo == AZOrientHorizontal ? index * r.size.width  : 0;
////		r.origin.y 		= oreo == AZOrientHorizontal ? 0 : _rootLayer.boundsHeight - (( index+1 ) *  r.size.height);
//		return AZVrect(r);
//	}];
//			toggleUnit.boundsHeight = _containerLayer.boundsHeight / ct;
//			toggleUnit.position = CGPointMake(_containerLayer.boundsMidX, (_containerLayer.boundsHeight / ct) * i);

//			[toggleUnit addConstraintsSuperSize];
//			toggleUnit.frame = _rootLayer.bounds;
//			[toggleUnit addConstraints:@[
//			AZConstRelSuper(kCAConstraintWidth), AZConstRelSuperScaleOff(kCAConstraintHeight, .3, 0),
//			kCAConstraintHeight),
//			AZConstRelSuperScaleOff(kCAConstraintMinY, .25 * i ,0),
//			AZConstRelSuper(kCAConstraintMidY), 
//			AZConstRelSuper(kCAConstraintMidX) ]];//,
//						AZConstRelSuperScaleOff(kCAConstraintHeight, 1/3,0)]];//,
//						AZConstRelSuperScaleOff(kCAConstraintMinY,miny , 0)]];

//oreo == AZOrientHorizontal ? 1 : 1/ct, 0),
//				AZConstRelSuperScaleOff(kCAConstraintWidth, oreo == AZOrientHorizontal ? 1/ct : 1, 0),AZConstAttrRelNameAttrScaleOff(kCAConstraintMinX, @"superlayer", kCAConstraintMaxX, 
//			oreo == AZOrientHorizontal ? i / ct : 0, 0),
//			AZConstAttrRelNameAttrScaleOff(kCAConstraintMinY, @"superlayer", kCAConstraintMaxY, 
//														 oreo == AZOrientHorizontal ? 0 : ((ct - i) -1) / ct, 0)]];
//														 (kCAConstraintMinX, oreo == AZOrientHorizontal ? _rootLayer.boundsWidth /ct : _rootLayer.boundsWidth;)
//				[self itemLayerWithName:label relativeTo:i == 0 ? @"superlayer" : $(@"layer%i", i-1) onText:@"Onnn"	 offText:@"off" state:NO index:i]];
//	 lastRelative = @";
//- (CAL*) itemLayerWithName:(NSS*)name relativeTo:(NSS*)relative onText:(NSS*)onText  offText:(NSS*)offText
//							state:(BOOL)state			 index:(NSUI)index   labelPositioned:(AZPOS)position 
//{
//	AZConstAttrRelNameAttrScaleOff( kCAConstraintMaxY, relative, index == 0 ? kCAConstraintMaxY :																																	  kCAConstraintMinY, 
//																		1,
//											 											index == 0 ? -7.0f : -5.0f) ];
//	
//	result.borderColor 	= kGBDebugLayerBorderColor;
//	result.borderWidth 	= kGBDebugLayerBorderWidth;
//	[result setValue:@30.0f forKeyPath:@"frame.size.height"];
//	[result addSublayers:@[[self itemTextLayerWithName:name], 
//	 [self toggleLayerWithOnText:onText offText:offText initialState:state title:name index:index]]];
//	return result;
//}
- (AZTCL*) toggleLayerWithOnText:(NSS*)on offText:(NSS*)off initialState:(BOOL)state 
									title:(NSS*)title		index:(NSUI)index 
{
	AZToggleControlLayer* result = [AZToggleControlLayer toggleWithOn:on off:off];
	result.name = $(@"toggle%ld", index); //title
	result.toggleState = state;
	result.constraints = @[ 		AZConstRelSuperScaleOff	(kCAConstraintMaxX,1,-5.0f),
									AZConstRelSuper				(kCAConstraintMidY)	];
	[result setValue:@80.0f forKeyPath:@"frame.size.width"];
	[result setValue:@24.0f forKeyPath:@"frame.size.height"];
	return result;
}
				/*	This is a bit of fast hacking; it would be better to use array of item names or similar.
	 Or in a real-world situation, the layers would be added by binding to a data source and responding to changes. */
	 
//	if ([_delegate respondsToSelector:@selector(numberOfTogglesInView:)]) {
//		NSUI numItems = [_delegate numberOfTogglesInView:self];
//		self.questions 		= [[NSArray arrayFromto:numItems] arrayUsingIndexedBlock:^id(id obj, NSUI idx) {
//			NSString *toggleQuestion = [_delegate toggleView:self questionAtIndex:idx];
//			AZPOS where = [_delegate respondsToSelector:@selector(positionForQuestion:)]
//								   ? [_delegate positionForQuestion:obj]
//								   : AZLft;
//			NSS* rel = index == 0 ? @"superlayer" : [_delegate toggleView:self questionAtIndex: (idx-1) ]	;
//			[self itemLayerWithName:toggleQuestion relativeTo:rel index:idx];
//			return toggleQuestion;
//		}];
//	}
//	- (NSA*)itemsForToggleView:(AZToggleArrayView *)view {  return 	@[												
//	 	[view itemTextLayerWithName:@"Sort:" ],
//		[view itemLayerWithName:	@"Color" relativeTo:@"superlayer" index:0],
//		[view itemLayerWithName:	@"A-Z" relativeTo:@"Color" 	index:1]	];			}
//	NSString *lastRelative = @"superlayer";

//	 	if ( [toggle isKindOfClass:NSD.class]) {
//	 	NSDictionary *response = toggle;
//	 	NSS* label = response[AZToggleLabel] ? response[AZToggleLabel] : @"";
//	 	NSS* rel = i == 0
//	 	? @"superlayer"
//	 	: lastRelative;
//	 	//[[_delegate toggleForView:self atIndex:i-1] valueForKey:AZToggleRel];
//		 NSString *on = response[AZToggleOn] ? response[AZToggleOn] : @"ON";
//	 	NSString *off = response[AZToggleOff] ? response[AZToggleOff] : @"OFF";
//		 //			BOOL state = response[AZToggleState] ? [response boolForKey:AZToggleState] : YES;
//	 	BOOL state = [response[AZToggleState]booleanValue];// ? YES;
//	}

	
	//	else if ([_delegate respondsToSelector:@selector(itemsForToggleView:)]){
	//		NSArray *yesno = [_delegate itemsForToggleView:self];
	//		[yesno az_each:^(id obj, NSUI index, BOOL *stop) {
	//
	//	[containerLayer addSublayer:[self itemLayerWithName:@"Click these 'buttons' to change state ->"
	//											 relativeTo:@"Item 2"
	//												 onText:@"1"
	//												offText:@"0"
	//												  state:YES
	//												  index:1]];
	
	//	[containerLayer addSublayer:[self itemLayerWithName:@"BIG first Initial?"
	//											 relativeTo:@"Click these 'buttons' to change state ->"
	//												 onText:@"YES!"
	//												offText:@"NO!"
	//												  state:YES
	//												  index:1]];
	
	//			NSS* rel = (index == 0 ? @"superlayer" : yesno[index-1]);
	//			[_containerLayer addSublayer:obj];
	//		}];
	//	} else {
	//
	//		NSArray *yesno = [_delegate questionsForToggleView:self];
	//
	//		[yesno az_each:^(id obj, NSUI index, BOOL *stop) {
	//			NSS* rel = (index == 0 ? @"superlayer" : yesno[index-1]);
	//			[_containerLayer addSublayer:[self itemLayerWithName:obj relativeTo:rel index:index]];
	//		}];
	//	}
	/*	} else if ([_delegate respondsToSelector:@selector(questionsForToggleView:)]) {
	 
	 self.questions = [_delegate questionsForToggleView:self];
	 
	 } else if ([_delegate respondsToSelector:@selector(itemsForToggleView:)]){
	 
	 //	[self itemTextLayerWithName:@"Sort:" ];
	 //	[self itemLayerWithName:	@"Color" relativeTo:@"superlayer" index:0];
	 //	[self itemLayerWithName:	@"A-Z" relativeTo:@"Color" 	index:1];
	 
	 NSArray *yesno = [_delegate itemsForToggleView:self];
	 [yesno each:^(id obj, NSUI index, BOOL *stop) {
	 
	 NSS* rel = (index == 0 ? @"superlayer" : yesno[index-1]);
	 [_containerLayer addSublayer:obj];
	 }];
	 
	 [yesno each:^(id obj, NSUI index, BOOL *stop) {
	 AZPOS where = [_delegate respondsToSelector:@selector(positionForQuestion:)]
	 ? [_delegate positionForQuestion:obj]
	 : AZLft;
	 
	 NSS* rel = where == AZLft	 ? (index == 0 ? @"superlayer" : yesno[index-1])
	 : where == AZRgt ? (index == 0 ? @"superlayer" : yesno[index-1])
	 : @"superlayer";
	 [_containerLayer addSublayer:[self itemLayerWithName:obj relativeTo:rel index:index]];
	 }];
	 }
	 */		//	[containerLayer addSublayer:[self itemLayerWithName:@"Item 2" relativeTo:index:1]];
	//	[containerLayer addSublayer:[self itemLayerWithName:@"Click these 'buttons' to change state ->"
	//											 relativeTo:@"Item 2"
	//												 onText:@"1"
	//												offText:@"0"
	//												  state:YES
	//												  index:1]];
	
	//	[containerLayer addSublayer:[self itemLayerWithName:@"BIG first Initial?"
	//											 relativeTo:@"Click these 'buttons' to change state ->"
	//												 onText:@"YES!"
	//												offText:@"NO!"
	//												  state:YES
	//												  index:1]];


#pragma mark NSView overrides
- (void) setFrame:(NSR)frameRect	{
	// 	Disable animations whie resizing view; this makes the behavior more consistent.
	[CATransaction immediately:^{	[super setFrame:frameRect]; }]; 
}

- (void) mouseDown:(NSE*)event
{
	AZTCL	*hit = [self toggleLayerForEvent:event];
	if (hit)  {
		BOOL stateNow =! hit.toggleState;
		if ([_delegate respondsToSelector:@selector(toggleStateDidChangeTo:inToggleViewArray:withName:)])
			[_delegate toggleStateDidChangeTo:stateNow inToggleViewArray:self withName:hit.name];
		[hit reverseToggleState];
	}
}


- (CATextLayer*) itemTextLayerWithName:(NSS*)name  {

	CATextLayer* result = [CATextLayer layerNamed:@"label%ld"];
	result.string = name;
	//	result.foregroundColor =  CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, .89f);
	//	result.fontSize = 18;//[NSFont systemFontSize];

	result.fontSize = ([_containerLayer respondsToSelector:@selector(fontSize)]
					? (CGFloat)[[_containerLayer valueForKey:@"fontSize"]floatValue]
					: 18);	// [NSFont smallSystemFontSize];
	result.font = (__bridge CFStringRef) @"UbuntuMono-Bold";
	//	result.font = (__bridge CFTypeRef)[NSFont fontWithName:@"Ubuntu Mono Bold" size:18];
	//	[NSFont systemFontOfSize:result.fontSize];(__bridge CFTypeRef)((id)
	result.alignmentMode  = kCAAlignmentLeft;
	result.truncationMode = kCATruncationEnd;
//	result.borderColor 	  = kGBDebugLayerBorderColor;
//	result.borderWidth 	  = kGBDebugLayerBorderWidth;
//	CAConstraint *left 	  =
	result.constraints	  = @[ AZConstRelSuperScaleOff(kCAConstraintMinX, 1, 5),
							AZConstRelSuper(kCAConstraintMidY), AZConstRelSuper(kCAConstraintWidth), AZConstRelSuper(kCAConstraintHeight)	];
							//	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"toggle" attribute:kCAConstraintMinX offset:-5.0f]];
	return result;
}

- (CAL*) itemLayerWithName:(NSS*)name relativeTo:(NSS*)relative	index:(NSUI)index
{
  return (id)nil;
//	return [self itemLayerWithName:name relativeTo:relative onText:nil offText:nil state:NO index:index];
}


//- (CAL*) itemLayerWithName:(NSS*)name	relativeTo:(NSS*)relative onText:(NSS*)onText offText:(NSS*)offText
//						 	state:(BOOL)state 		  index:(NSUI)index
//{
//	return [self itemLayerWithName:name relativeTo:relative onText:onText offText:offText state:state index:index labelPositioned:99];
//}


- (AZToggleControlLayer*) toggleLayerForEvent:(NSEvent*)event
{
// Returns the first toggle layer for the given event.[self convertPoint:[NSEvent mouseLocation] fromView:nil];
	CAL* hitLayer = [self.containerLayer hitTest:self.windowPoint forClass:AZTCL.class];
//	NSLog(@"hitlayer: %@", hitLayer);
	while (hitLayer)
	{
//		if ([hitLayer isMemberOfClass:AZToggleControlLayer.class])
//		{
			NSLog(@"toggled: %@", hitLayer.name);
			return (AZToggleControlLayer*)hitLayer;
//		}
		hitLayer = hitLayer.superlayer;
	}
	return nil;
}

- (CGPoint) layerLocationForEvent:(NSEvent*)event
{
		// Returns the mouse location of the given event. This is where flipped view
		// coordinates should be considered for example, so instead of simply returning
		// the CGPoint, the result should be converted like this:
		//   NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
		//   point.y = self.bounds.size.height - point.y;
		//   return NSPointToCGPoint(point);
	return NSPointToCGPoint([self convertPoint:[event locationInWindow] fromView:nil]);
}

@end

//  GBToggleLayer.m Created by Tomaz Kragelj on 9.12.09.	Copyright (C) 2009 Gentle Bytes. All rights reserved.

@interface AZToggleControlLayer ()
@property (NATOM,STRNG)	CAL		*thumbLayer, 		*onBackLayer,		*offBackLayer;
@property (NATOM,STRNG)	CATXTL 	*onTextLayer, 		*offTextLayer;
@property (RONLY) CGF 				contentsHeight;
@end

@implementation AZToggleControlLayer

+ (AZToggleControlLayer*)toggleWithOn:(NSS*)on off:(NSS*)off	{
	return [self.alloc initWithOn:on ?: @"On" off:off ?: @"Off"];
}
- (id) init 																		{ return [self.class toggleWithOn:nil off:nil]; }
- (id) initWithOn:(NSS*)on off:(NSS*)off								{
	if (self != super.init ) return nil;
	self.masksToBounds = YES;
	self.cornerRadius = 3.0f;
	self.borderWidth = .30f;
	self.borderColor = GRAY9.cgColor;
		//CGColorCreateGenericRGB(0.45f, 0.45f, 0.45f, 0.9f);
	self.layoutManager = self;

	[self addSublayers:@[self.onBackLayer, self.thumbLayer, self.offBackLayer]];
	[@[self.onBackLayer, self.offBackLayer] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
	return self;
}

#pragma mark Toggle state handling

- (void) reverseToggleState				{	self.toggleState = !self.toggleState;	}
- (void) setToggleState:(BOOL)value	{	if (value != _toggleState)	{	_toggleState = value; 	[self setNeedsLayout];	}
}
- (NSS*) onStateText						{	return self.onTextLayer.string;				}
- (void) setOnStateText:(NSS*)value	{	self.onTextLayer.string = value;	}
- (NSS*) offStateText						{	return self.offTextLayer.string;		}
- (void) setOffStateText:(NSS*)value	{	self.offTextLayer.string = value;	}

#pragma mark CALayoutManager handling

- (void) layoutSublayersOfLayer:(CAL*)layer
{
// Prepare common values. Note that we want to extend the state background layers below the thumb rounded corner; if not, the background would become visible.
	CGF contentsHeight 	= self.contentsHeight;
	CGF stateWidth 			= self.bounds.size.width - contentsHeight;
	CGF stateDrawExtra 	= self.thumbLayer.cornerRadius / 2.0f;
// This is the actual part that toggles the state. It works because we mask to bounds. Note that the coordinates are calculated regarding the anchor points specified when the layers were created.
	CGF left 		= self.toggleState ? 0.0f : -stateWidth;
	CGF middle 	= self.bounds.size.height / 2.0f;
// The positioning part is very simple once we determined the layout. Note that this part also updates state background and thumb layer sizes when the parent layer is resized (layout is automatically invoked in such case).
	self.onBackLayer.bounds 		= CGRectMake(0.0f, 0.0f, stateWidth + stateDrawExtra, contentsHeight);
	self.onBackLayer.position 	= CGPointMake(left, middle);
	left += stateWidth;
	self.thumbLayer.bounds 		= CGRectMake(0.0f, 0.0f, contentsHeight*1.3, contentsHeight);
	self.thumbLayer.position 	= CGPointMake(left, middle);
	left += contentsHeight - stateDrawExtra;
	self.offBackLayer.bounds 	= CGRectMake(0.0f, 0.0f, stateWidth + stateDrawExtra, contentsHeight);
	self.offBackLayer.position = CGPointMake(left, middle);
}

#pragma mark Drawing handling

- (void) drawLayer:(CAL*)layer inContext:(CGContextRef)context
{
	[NSGraphicsContext drawInContext:context flipped:NO	 actions:^{
		if (layer == self.onBackLayer)			[self.onBackGradient drawInRect:layer.bounds angle:270.0f];
		else if (layer == self.offBackLayer)	[self.offBackGradient drawInRect:layer.bounds angle:270.0f];
	}];
}

#pragma mark - Visuals

- (CGF) contentsHeight 		{ 	return self.bounds.size.height - self.borderWidth * 2.0f;		}
- (NSG*) onBackGradient		{
	if (_onBackGradient) return _onBackGradient;
	NSC* top 		= GREEN.darker;// [NSColor colorWithDeviceRed:0.14f green:0.25f blue:0.90f alpha:0.85f];
	NSC* bottom	= GREEN.brighter;//[NSColor colorWithDeviceRed:0.00f green:0.52f blue:0.89f alpha:0.85f];
	_onBackGradient = [NSG.alloc initWithColorsAndLocations:top, 0.0f, bottom, 0.6f, nil];
	return _onBackGradient;
}
- (NSG*) offBackGradient 	{
	if (_offBackGradient) return _offBackGradient;
	NSColor* top = [NSColor colorWithDeviceRed:0.65f green:0.65f blue:0.65f alpha:0.85f];
	NSColor* bottom = [NSColor colorWithDeviceRed:0.85f green:0.85f blue:0.85f alpha:0.85f];
	_offBackGradient = [NSGradient.alloc initWithColorsAndLocations:top, 0.0f, bottom, 0.6f, nil];
	return _offBackGradient;
}

#pragma mark - CoreAnimation

- (CAL*) thumbLayer		{
	return _thumbLayer = _thumbLayer ?: ^{
		_thumbLayer = [CALayer layer];
		_thumbLayer.name = @"thumb";

		_thumbLayer.cornerRadius = 5.0f;
		_thumbLayer.borderWidth = 1.f;
		_thumbLayer.borderColor = GRAY2.cgColor;
		_thumbLayer.backgroundColor = GRAY9.cgColor;

		_thumbLayer.anchorPoint = CGPointMake(0.0f, 0.5f);	// This makes layout easier.
		_thumbLayer.zPosition = 50.0f;	// Make this layer top-most within the sublayers.
		return _thumbLayer;
	}();
}
- (CAL*) onBackLayer		{
	if (_onBackLayer) return _onBackLayer;
	_onBackLayer = [CALayer layer];
	_onBackLayer.name = @"onback";
	_onBackLayer.delegate = self;
	_onBackLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	_onBackLayer.anchorPoint = CGPointMake(0.0f, 0.5f);	// This makes layout easier.
	[_onBackLayer addSublayer:self.onTextLayer];
	return _onBackLayer;
}
- (CAL*) offBackLayer		{
	if (_offBackLayer) return _offBackLayer;
	_offBackLayer = [CALayer layer];
	_offBackLayer.delegate = self;
	_offBackLayer.name = @"offback";
	_offBackLayer.layoutManager = AZLAYOUTMGR;
	_offBackLayer.anchorPoint = CGPointMake(0.0f, 0.5f);	// This makes layout easier.
	[_offBackLayer addSublayer:	self.offTextLayer];
	return _offBackLayer;
}
- (CATXTL*)onTextLayer	{
	if (_onTextLayer) return _onTextLayer;
	_onTextLayer = CATextLayer.layer;
	_onTextLayer.name = @"ontext";
	_onTextLayer.string = @"ON";
	_onTextLayer.fontSize = 20;  // [NSFont smallSystemFontSize];
	_onTextLayer.font =	(__bridge CFStringRef) @"Ubuntu Mono Bold";	
	_onTextLayer.alignmentMode = kCAAlignmentCenter;
	_onTextLayer.truncationMode 	= 	kCATruncationEnd;
	_onTextLayer.foregroundColor = 	cgWHITE;
	_onTextLayer.shadowColor 		= 	cgBLACK;
	_onTextLayer.shadowOffset 	= 	(CGSize){0,0};
	_onTextLayer.shadowRadius 	= 	1. ;
	_onTextLayer.shadowOpacity 	= 	.8 ;
	_onTextLayer.constraints		=   @[	AZConstRelSuper(kCAConstraintMidX),AZConstRelSuper(kCAConstraintMidY) ];
	return _onTextLayer;
}
- (CATXTL*)offTextLayer	{
	if (_offTextLayer) return _offTextLayer;
	_offTextLayer = [CATextLayer layer];
	_offTextLayer.name = @"offtext";
	_offTextLayer.string = @"OFF";

	_offTextLayer.fontSize = 19;//[NSFont smallSystemFontSize];
	_offTextLayer.font = (__bridge CFStringRef) @"Ubuntu Mono Bold";
	_offTextLayer.alignmentMode 		= kCAAlignmentCenter;
	_offTextLayer.truncationMode 	= kCATruncationEnd;
	_offTextLayer.foregroundColor 	= GRAY1.CGColor;// CGColorCreateGenericRGB(0.2f, 0.2f, 0.2f, 1.0f);
	_offTextLayer.shadowColor 		= cgBLACK;
	_offTextLayer.shadowOffset 		= (CGSize){0, 0};
	_offTextLayer.shadowRadius 		= 1.0f;
	_offTextLayer.shadowOpacity 		= 0.9f;
	_offTextLayer .constraints		=   @[	AZConstRelSuper(kCAConstraintMidX),AZConstRelSuper(kCAConstraintMidY) ];
	return _offTextLayer;
}

@end
