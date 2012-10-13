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
@property (strong, nonatomic) CALayer *root;
@property (strong, nonatomic) CALayer *contentLayer;
@property (nonatomic, strong) AZSizer *ss;
@end

@implementation AZGridView
//    if ([keyPath isEqual:@"content"]) {	[self setSs:nil]; AZLOG(change); }
//    /* Be sure to call the superclass's implementation *if it implements it*. NSObject does not implement the method. */
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//}
//+ (NSSet *)keyPathsForValuesAffectingContent{
//    return [NSSet setWithObject:@"ss"];
//}
//- (void) update{

//	[self addObserverForKeyPat:@"content" task:^(id obj, NSDictionary *change) {
//		AZLOG(@"content changed");
//		[selfish setSs:nil];
- (void)setContentLayer:(CALayer *)contentLayer
{
	NSA*rects  = _ss.rects;
	_contentLayer.sublayers = [_content nmap:^id(id obj, NSUInteger index) {
		NSS* objClass 		= [obj isKindOfClass:[NSImage class]] ? @"img" 	:
		[obj isKindOfClass:[AZFile  class]] ? @"file" : @"else";
		CALayer *fileLayer 	= [CALayer layer];
//		fileLayer.arMASK	=  CASIZEABLE;
		fileLayer.bgC 		= areSame(objClass, @"img")  ? [[obj quantize][0]CGColor]
							: areSame(objClass, @"file") ? obj[@"color"] ? [[(AZFile*)obj color]CGColor]
														 : ^{ 	NSColor*q = [obj[@"image"] quantize][0];
																return  q ? [q CGColor] : cgRANDOMCOLOR; }()
							: cgRANDOMCOLOR;
		fileLayer.contents 	= areSame(objClass, @"img")  ? obj
							: areSame(objClass, @"file") ? [[(AZFile*)obj image]scaledToMax:512]
							: [[NSImage systemIcons]randomElement];
		fileLayer.bounds = AZRectFromDim(100);
		fileLayer.position = randomPointInRect(self.frame);
		return LogAndReturn( fileLayer );
	}];	[_contentLayer setNeedsDisplay];// setNeedsLayout];
}
-(void) awakeFromNib
{
	__block __typeof(self) selfish = self;
	[self addObserverForKeyPath:@"content" task:^(id obj, NSD *change) { [selfish setSs:nil];	}];
	[self addObserverForKeyPath:@"ss" task:^(id obj, NSD *change) { 	 [selfish setContentLayer:nil]; }];
//	[AZNOTCENTER addObserver:self forKeyPaths:@[@"content"]];
//	[self addObserver:self forKeyPath:@"content" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	self.postsBoundsChangedNotifications = YES;
	self.root 				= [self setupHostView];
	self.contentLayer 		= [CALayer layer];

//	_root.position 			= [self center];
//	_contentLayer.position 	= [self center];
//	_root.name 				= @"root";
//	_contentLayer.name 		= @"con1tent";
//	_root.bounds 			= [self bounds];
//	_contentLayer.bounds 	= [self bounds];
	_root.layoutManager 	= AZLAYOUTMGR;
	_root.arMASK		 	= CASIZEABLE;
	_root.nDoBC				= YES;
	_contentLayer.delegate 	= self;
	[_root addSublayer:_contentLayer];
	[_contentLayer addConstraintsSuperSize];
	self.content 			= [AZFolder samplerWithCount:5];
	//
}

- (void) viewDidEndLiveResize {	[_contentLayer setNeedsLayout];	}


- (void)setSs:(AZSizer *)ss {  AZLOG(@"SetSizer Called");
	_ss = [AZSizer forQuantity:_content.count inRect:[[[self window]contentView]frame]];
}

- (void) layoutSublayersOfLayer:(CALayer *)layer {

//	AZLOG(ss);
//	structForQuantity:content.count inRect:[self frame]];
//				   contentLayer.sublayers.count inRect:[self frame]];
//	NSLog(@"Sizer rect: %@", NSStringFromRect(r));
//	int columns =  10;//r.origin.y;
//	int rows 	= 10;  //r.origin.x;
//	NSSize s 	= NSMakeSize(40, 40);//r.size.width, r.size.height);
//	_ss = self.ss;


	[_contentLayer.sublayers enumerateObjectsUsingBlock:^(CALayer* obj, NSUInteger idx, BOOL *stop) {
		[CATransaction immediately:^{
			obj.position = nanPointCheck(AZCenterOfRect([[_ss.rects objectAtNormalizedIndex:idx]rectValue]));
			obj.bounds = nanRectCheck((CGRect){0,0,_ss.width, _ss.height});
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
