//
//  AZFileGridView.m
//  AtoZ
//
//  Created by Alex Gray on 8/26/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZFileGridView.h"
#import <QuartzCore/QuartzCore.h>
//
//@interface GridLayoutManager : CALayer
//@end
//@implementation GridLayoutManager
//
//
//@end
@implementation AZFileGridView

- (id)initWithFrame:(NSRect)frame
{
	if (!(self = [super initWithFrame:frame])) return nil;
	self.root	= [self setupHostView];
//	self.root.delegate = self;
//	[self.root setNeedsDisplay];
	NSArray *c = [NSC randomPalette];
	_root.sublayers = [[NSA from:0 to: 10]nmap:^id(id obj, NSUInteger index) {
		CAL *l = [CAL layerNamed:[obj stringValue]];
		[l setAssociatedValue:[c normal:index] forKey:@"color" policy:OBJC_ASSOCIATION_RETAIN];
		l.delegate = self;
		[l setNeedsDisplay];
		return l;
	}];  //(_root,[NSImage monoIcons].randomElement, 1)]; }];
	_root.layoutManager = self;
	[_root setNeedsLayout];
  	return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSLog(@"key;%@, obj: %@  changeL %@", keyPath, object, change);
}
-(void) drawRect:(NSRect)dirtyRect { //		NSRectFillWithColor(self.bounds,GREEN);
}

- (void) layoutSublayersOfLayer:(CALayer *)layer {

//	if ( layer != _root) {
		[_root.sublayers do:^(id obj) {
		NSI i = [[(CAL*)obj  name] integerValue];
		NSLog(@"supposed to layout index of subs : %d",i);
		[obj setFrame:[[_sizer.rects normal:i]rectValue]];
		[obj setNeedsDisplay];
	}];
}
- (void) mouseDown:(NSEvent *)theEvent { NSLog(@"mdown :%@", AZString(theEvent.locationInWindow));
	[_root setNeedsLayout];}
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)cgContext
{
	// DEBUG
	NSLog(@"Drawing layer: %@  ... %@", layer.name, layer.debugLayerTree);

	[NSGraphicsContext drawInContext:cgContext flipped:NO actions:^{
		NSRectFillWithColor(layer.bounds,RANDOMCOLOR);//[layer associatedValueForKey:@"color"]);
	}];
//	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:cgContext flipped:NO]];
//
//	// NSRect theRect = NSRectFromCGRect(CGContextGetClipBoundingBox(cgContext));
//
//	if ( [layer.name isEqualToString:@"mainLayer"] )
//	{
//		// draw a basic gradient for the view background
//		float r = (float)(random() % 100) * 0.01;
//		float g = (float)(random() % 100) * 0.01;
//		float b = (float)(random() % 100) * 0.01;
//		NSColor *gradientBottom = [NSColor colorWithCalibratedWhite:0.10 alpha:1.0];
//		NSColor *gradientTop = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0];
//
//		NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:gradientBottom endingColor:gradientTop];
//		[gradient drawInRect:self.bounds angle:90.0];
//		[gradient release];
//	}
//	else
//	{
//		// draw all other layers normally
//		[super drawLayer:layer inContext:cgContext];
//	}
//
//	[NSGraphicsContext restoreGraphicsState];
}
@end

//-(void) layoutSublayersOfLayer:(CALayer *)layer
////-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//	AZSizer * d = [AZSizer forQuantity:layer.sublayers.count inRect:layer.bounds];
//#ifdef DEBUG
//	NSLog(@"constraining with sizer %@", d.propertiesPlease);
//#endif
//	[CATransaction begin];
//	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//	//	[self constrainLayersInContentLayer];
//	[layer.sublayers az_eachConcurrentlyWithBlock:^(NSInteger index, CALayer* obj, BOOL *stop) {
//
//		obj.anchorPoint = [[d.rects objectAtNormalizedIndex:index] rectValue].origin;
//		obj.bounds = AZMakeRectFromSize(d.size);
//	}];
//	[CATransaction commit];
//
//	//	NSUInteger index = 0;
//	//	for (NSUInteger r = 0; r < _sizer.rows; r++) {		for (NSUInteger c = 0; c < _sizer.columns; c++) {
//}
//
//
//-(void) awakeFromNib {
//	CALayer *mainLayer = [CALayer layer];
//	mainLayer.name = @"mainLayer";
//	mainLayer.frame = NSRectToCGRect(self.frame);
//	mainLayer.delegate = self;
//	mainLayer.layoutManager = self;
//	[self setLayer:mainLayer];
//	[self setWantsLayer:YES];
//	// call drawing delegate to make background
//	[mainLayer setNeedsDisplay];
//
//	CALayer *back = [CALayer greyGradient];
//	back.frame = NSRectToCGRect(self.frame);
//	[mainLayer addSublayer:back];
//	self.contentLayer = [CALayer layer];
//	self.contentLayer.name = @"letterLayer";
//	//	self.contentLayer.anchorPoint = CGPointMake(0.5, 0.5);
//	//	_contentLayer.string = theLetter;
//	//	_contentLayer.font = @"Arial Rounded MT Bold";
//	//	_contentLayer.fontSize = mainLayer.frame.size.height/1.5;
//	//	_contentLayer.alignmentMode = kCAAlignmentCenter;
//	self.contentLayer.shadowOpacity = 0.75;
//	self.contentLayer.shadowOffset = CGSizeMake(2, -2);
//	[mainLayer addSublayer:self.contentLayer];
//
//	//	extraLayer = [CATextLayer layer];
//	//	extraLayer.name = @"extraLayer";
//	//	extraLayer.anchorPoint = CGPointMake(0.0, 0.0);
//	//	extraLayer.string = extraInfo;
//	//	extraLayer.font = @"Arial Rounded MT Bold";
//	//	extraLayer.fontSize = mainLayer.frame.size.height/50.0;
//	//	extraLayer.alignmentMode = kCAAlignmentLeft;
//	//	[mainLayer addSublayer:extraLayer];
//
//	// force layout of layers
//	[mainLayer layoutIfNeeded];
//
//	// register to see changes to theString and extraInfo
//	[self addObserver:self forKeyPath:@"content" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
//	[self addObserver:self forKeyPath:@"extraInfo" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
//
//	// force layout of layers on bounds change (w/o changing the background color by redrawing background on bounds change)
//	[self setPostsFrameChangedNotifications:YES];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSViewFrameDidChangeNotification object:self];
//
//	//	self.root = [CALayer layer];
//	//	_root.name = @"root";
//	//	_root.frame = [self bounds];
//	//	_root.backgroundColor = cgRED;
//	//	[self setLayer:_root];
//	//	[self setWantsLayer:YES];
//	//	self.contentLayer = [CALayer layer];
//	//	_contentLayer.position = [self center];
//	//	if (_content)	[self doLayout];
//
//}
//
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//	// DEBUG
//	// NSLog(@"value updated for keypath: %@ with change: %@", keyPath, [change description]);
//
//	if ( [keyPath isEqualToString:@"content"] )
//	{
//		// update letter refresh the background display
//		//		_conte = theLetter;
//		[[self layer] setNeedsDisplay];
//	}
//	else if ( [keyPath isEqualToString:@"extraInfo"] )
//	{
//		// update extra info
//		//		extraLayer.string = extraInfo;
//	}
//	else
//	{
//		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//	}
//}
//
//- (void)frameDidChange:(NSNotification *)notification
//{
//	[_contentLayer layoutSublayers];
//}
//
//#pragma mark -
//#pragma mark CALayoutManager Protocol Methods
//
////- (void)layoutSublayersOfLayer:(CALayer *)layer
////{
//// DEBUG
//// NSLog(@"Laying out sublayers of %@...", layer.name);
////	CATextLayer *tempLayer;
////	CGRect tempBounds;
////
////		// layout letterLayer
////	tempLayer = [[layer sublayers] objectAtIndex:0];
////	tempBounds = tempLayer.bounds;
////	tempLayer.fontSize = [self layer].bounds.size.height/1.5;
////		// set the width of the layer to the width of the window so that letters are never cut off by accident
////	tempBounds.size = CGSizeMake([self bounds].size.width, [tempLayer preferredFrameSize].height);
////	tempLayer.bounds = tempBounds;
////	tempLayer.position = CGPointMake(NSMidX([self bounds]), NSMidY([self bounds]));
////
////		// layout extraLayer
////	tempLayer = [[layer sublayers] objectAtIndex:1];
////	tempBounds = tempLayer.bounds;
////	tempLayer.fontSize = [self layer].bounds.size.height/50.0;
////	tempBounds.size = [tempLayer preferredFrameSize];
////	tempLayer.bounds = tempBounds;
////	tempLayer.position = CGPointMake(10.0, 10.0);
////}
//
////	*/
//
////	-(void) viewWillStartLiveResize {
////	NSImage * i = [[NSImage alloc] initWithData:[[self getCurrentFrame] TIFFRepresentation]]; //Size:[self frame].size];
//
////	[i lockFocus];
////	if ([self lockFocusIfCanDrawInContext:[NSGraphicsContext currentContext]]) {
////		[self displayRectIgnoringOpacity:[self frame] inContext:[NSGraphicsContext currentContext]];
////		[self unlockFocus];
////	}
////	[i unlockFocus];
////	[[_contentLayer sublayers] each:^(CALayer* obj, NSUInteger index, BOOL *stop) {
////		[obj setBackgroundColor:cgRANDOMCOLOR];
////	}];
////	_contentLayer.shouldRasterize = YES;
////	NSImage *u = [self snapshot];
//
////	self.veil = [CALayer veilForView:_root];
////	[_root addSublayer:_veil];
////	NSLog(@"veil: %@", _veil.debugDescription);////	_veil.opaque = YES;
////	[_contentLayer addSublayer:_veil];
////	[CATransaction begin];
////	_contentLayer.layoutManager = self;
////	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
////	[aLayer removeFromSuperlayer];
////	[_contentLayer setLayoutManager:self];
////	[_contentLayer ];
//
////	}
//-(void) viewDidEndLiveResize {
//	//	[_contentLayer setLayoutManager:self];
//	//	[self doLayout];
//
//	//	CALayer *i = [[_contentLayer sublayers] filterOne:^BOOL(id object) {
//	//		return [[object valueForKey:@"name"] isEqualToString:@"bed"] ? YES : NO ;
//	//	}];
//	//	[_veil removeFromSuperlayer];
//	//	[CATransaction commit];
//	[_contentLayer setNeedsLayout];
//}
///*
// NSUInteger index = 0;
// for (NSUInteger r = 0; r < _sizer.rows; r++) {		for (NSUInteger c = 0; c < _sizer.columns; c++) {
// //		if ([layer sublayers].count > index) {
// CALayer *cell = [[_contentLayer sublayers]objectAtNormalizedIndex:index];
// cell.frame = AZMakeRectFromSize(_sizer.size);
// cell.name = [NSString stringWithFormat:@"%ld@%ld", c, r];
// cell.constraints = @[
// AZConstRelSuperScaleOff(kCAConstraintWidth, (1.0/ (CGFloat)_sizer.columns), 0),
// AZConstRelSuperScaleOff(kCAConstraintHeight,  (1.0 / (CGFloat)_sizer.rows), 0),
// AZConstAttrRelNameAttrScaleOff(	kCAConstraintMinX, @"superlayer",
// kCAConstraintMaxX, (c / (CGFloat)_sizer.columns), 0),
// AZConstAttrRelNameAttrScaleOff( kCAConstraintMinY, @"superlayer",
// kCAConstraintMaxY, (r / (CGFloat)_sizer.rows), 0)
// ];
// index++;
// }
// }
// }
//
// */
//- (void)setContent:(NSMutableArray *)content {
//
//	_content  = content;
//	NSLog(@"making layers!");
//	//	[[_contentLayer sublayers]each:^(CALayer *obj, NSUInteger index, BOOL *stop) {
//	//		[obj removeFromSuperlayer];
//	//	}];
//	//	[_gridLayer removeFromSuperlayer];
//	//	self.gridLayer = [CALayer layer];
//	[CATransaction begin];
//	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//	[_content enumerateObjectsUsingBlock:^(AZFile* file, NSUInteger idx, BOOL *stop) {
//		//		if ([imageLayer valueForKey:@"locked"]) continue;
//		CALayer *fileLayer = [CALayer layer];
//		fileLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
//		fileLayer.backgroundColor = file.color.CGColor;
//		//			fileLayer.frame = AZMakeRectFromSize(_sizer.size);
//		//			fileLayer.frame = [[_sizer.rects objectAtIndex:idx]rectValue];
//		//			NSLog(@"setframe for: %@ to %@", file.name,  NSStringFromRect([[_sizer.rects objectAtIndex:idx]rectValue]));
//		[_gridLayer addSublayer:fileLayer];
//		//		[_contentLayer]
//		//		[_contentLayer addSublayer:_gridLayer];
//	}];
//	[CATransaction commit];
//	[_contentLayer setNeedsLayout];
//	//	[self doLayout];
//}
//
////- (void) doLayout
///**
// - (void) layoutSublayersOfLayer:(CALayer*)layer {
// //	NSRect sizer 	= [AZSizer structForQuantity:_content.count inRect:[self bounds]];
// //				   contentLayer.sublayers.count inRect:[self frame]];
// //	NSLog(@"Sizer rect: %@", NSStringFromRect(r));
// //	int columns =  r.origin.y;
// //	int rows 	=  r.origin.x;
// //	NSUInteger rowindex,  columnindex;
// //	rowindex = columnindex = 0;
// //	for (AZFile *file in _content) {
// //	if ([[self window]inLiveResize]) { [self performSelector:@selector(drawLayer:inContext:) afterDelay:.5]; return;}
// NSLog(@"dolayout called");
// NSLog(@"constraining with sizer %@", _sizer.propertiesPlease);
// self.sizer = [AZSizer forQuantity:_content.count inRect:[self bounds]];
// //	[CATransaction begin];
// //	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
// [_gridLayer.sublayers eachConcurrentlyWithBlock:^(NSInteger index, CALayer* obj, BOOL *stop) {
// obj.frame = [[_sizer.rects objectAtNormalizedIndex:index ] rectValue];
// }];
// //	[CATransaction commit];
// //	[_gridLayer setNeedsDisplay];
// //	[self needsLayout];
// */
///*	NSUInteger index = 0;
// _gridLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
// for (NSUInteger r = 0; r < _sizer.rows; r++) {		for (NSUInteger c = 0; c < _sizer.columns; c++) {
// //		if ([layer sublayers].count > index) {
// CALayer *cell = [[_gridLayer sublayers]objectAtNormalizedIndex:index];
// cell.frame = AZMakeRectFromSize(_sizer.size);
// cell.name = [NSString stringWithFormat:@"%ld@%ld", c, r];
// cell.constraints = @[
// AZConstRelSuperScaleOff(kCAConstraintWidth, (1.0/ (CGFloat)_sizer.columns), 0),
// AZConstRelSuperScaleOff(kCAConstraintHeight,  (1.0 / (CGFloat)_sizer.rows), 0),
// AZConstAttrRelNameAttrScaleOff(	kCAConstraintMinX, @"superlayer",
// kCAConstraintMaxX, (c / (CGFloat)_sizer.columns), 0),
// AZConstAttrRelNameAttrScaleOff( kCAConstraintMinY, @"superlayer",
// kCAConstraintMaxY, (r / (CGFloat)_sizer.rows), 0)
// ];
// index++;
// }
// }
// */
//
////}
////	[self constrainLayersInContentLayer];
//
////	[_sizer performSelectorOnMainThread:@selector(constrainLayersInLayer:) withObject:_contentLayer waitUntilDone:YES];
//// else {
//
////		fileLayer.contents = file.image;
////	//		fileLayer.contentsGravity = kCAGravityResizeAspect;
////	[_contentLayer.sublayers enumerateObjectsUsingBlock:^(CALayer* obj, NSUInteger idx, BOOL *stop) {
//
////		NSRect *f = AZMakeRect(	(NSPoint) {	sizerSize.width * columnindex,
////											_root.frame.size.height - ( (rowindex + 1) * sizerSize.height) },
////												sizerSize);
////		fileLayer.frame =
////		columnindex++;
////		if ( ! ((columnindex + 1) <= columns) ) { columnindex = 0; rowindex++; }
///////		obj.frame = [[_sizer.rects objectAtIndex:idx]rectValue];
//
////		CATransform3D rot = [self makeTransformForAngle:270];
////	  imageLayer.transform = rot;
////		box.identifier = $(@"%ldx%ld", rowindex, columnindex);
////	}];
////	}
////NSLog(@"root sublayer: %ld ", _contentLayer.sublayers.count);
////	[self setNeedsDisplay:YES];
//
////}
//
////- (CALayer*)layerAt:(NSUInteger)idx;
////{
////	return [_contentLayer.sublayers objectAtIndex:idx];
////}
////- (void) viewWillDraw {
////	[self doLayout];
////}
//
//- (id)initWithFrame:(NSRect)frame andFiles:(NSA*)files
//{
//	self = [super initWithFrame:frame];
//	if (self) {
//		self.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
//		//		self.layoutManager = self;
//
//		self.root = [CALayer layer];
//		self.contentLayer = [CALayer layer];
//		self.gridLayer = [CALayer layer];
//		[_contentLayer addSublayer:_gridLayer];
//		[_root addSublayer:_contentLayer];
//		[@[_root, _contentLayer, _gridLayer] az_each:^(CALayer* obj, NSUInteger index, BOOL *stop) {
//			obj.frame = [self bounds];
//			obj.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
//			obj.zPosition = 100 * index;
//		}];
//		self.layer = _root;
//		[self setWantsLayer: YES];
//		self.gridManager = [GridLayoutManager new];
//		[_contentLayer setLayoutManager:_gridManager];
//		self.content = files;
//		//		[_contentLayer setNeedsLayout];
//
//	}
//
//	return self;
//}
////
////- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
////	NSLog(@"context!");
////}
//- (void)drawRect:(NSRect)dirtyRect
//{
////	[self doLayout];
//}
//
//- (void) mouseDown:(NSEvent *)theEvent {
//	NSLog(@"click");
//	//	[self doLayout];
//	//	[_contentLayer setLayoutManager:self];
//	[_contentLayer setNeedsLayout];
//}
//@end
//
//@implementation GridLayer
//
////- (id) init
////{
////	self = [super init];
////	if (self != nil)
////	{
//////		self.layoutManager = self;
////	}
////	return self;
////}
//
//- (void) setSizer:(AZSizer *)sizer
//{
//	_sizer = sizer;
//	//	[self layoutSublayersOfLayer:<#(CALayer *)#>
//}
//- (void) layoutSublayersOfLayer:(CALayer*)layer
//{
//	//	CGFloat contentsHeight = self.contentsHeight;
//	//	CGFloat stateWidth = self.bounds.size.width - contentsHeight;
//	//	CGFloat stateDrawExtra = self.thumbLayer.cornerRadius / 2.0f;
//	//
//	//	CGFloat left = self.toggleState ? 0.0f : -stateWidth;
//	//	CGFloat middle = self.bounds.size.height / 2.0f;
//	//
//	//	self.onBackLayer.bounds = CGRectMake(0.0f, 0.0f, stateWidth + stateDrawExtra, contentsHeight);
//	//	self.onBackLayer.position = CGPointMake(left, middle);
//	//	left += stateWidth;
//	//	self.thumbLayer.bounds = CGRectMake(0.0f, 0.0f, contentsHeight, contentsHeight);
//	//	self.thumbLayer.position = CGPointMake(left, middle);
//	//	left += contentsHeight - stateDrawExtra;
//	//	self.offBackLayer.bounds = CGRectMake(0.0f, 0.0f, stateWidth + stateDrawExtra, contentsHeight);
//	//	self.offBackLayer.position = CGPointMake(left, middle);
//	//}
//	//
//	/*	NSLog(@"constraining with sizer %@", _sizer.propertiesPlease);
//	 //	[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
//	 //	[self constrainLayersInContentLayer];
//
//	 NSUInteger index = 0;
//	 for (NSUInteger r = 0; r < _sizer.rows; r++) {		for (NSUInteger c = 0; c < _sizer.columns; c++) {
//	 */
//	//		if ([layer sublayers].count > index) {
//	//		CALayer *cell = [[self sublayers]objectAtNormalizedIndex:index];
//	//		cell.frame = AZMakeRectFromSize(_sizer.size);
//	//		cell.name = [NSString stringWithFormat:@"%ld@%ld", c, r];
//	//		cell.constraints = @[
//	//		AZConstRelSuperScaleOff(kCAConstraintWidth, (1.0/ (CGFloat)_sizer.columns), 0),
//	//		AZConstRelSuperScaleOff(kCAConstraintHeight,  (1.0 / (CGFloat)_sizer.rows), 0),
//	//		AZConstAttrRelNameAttrScaleOff(	kCAConstraintMinX, @"superlayer",
//	//									   kCAConstraintMaxX, (c / (CGFloat)_sizer.columns), 0),
//	//		AZConstAttrRelNameAttrScaleOff( kCAConstraintMinY, @"superlayer",
//	//									   kCAConstraintMaxY, (r / (CGFloat)_sizer.rows), 0)
//	//		];
//	//		index++;
//	//	}
//}
////	[CATransaction setValue:[NSNumber numberWithBool:NO] forKey:kCATransactionDisableActions];
//
////}
//@end
