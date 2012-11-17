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
@property (strong, nonatomic) CALayer *root, *contentLayer;
@property (nonatomic, strong) AZSizer *ss;
@end

@interface LayerCell : CALayer
@end

@implementation LayerCell

//+ (BOOL)needsDisplayForKey:(NSString *)key {
//	return [key isEqualToString:@"radius"]	|| [key isEqualToString:@"strokeWidth"] ? [super needsDisplayForKey:key];
//}
//- (id)initWithLayer:(id)layer {
//
//	if (self = [super initWithLayer:layer]) {
//
//		if ([layer isKindOfClass:[AGPieSliceLayer class]]) {
//
//			AGPieSliceLayer *other = (AGPieSliceLayer *)layer;
//			self.startAngle = other.startAngle;
//			self.endAngle 	= other.endAngle;
//			self.fillColor 	= other.fillColor;
//
//			self.strokeColor = other.strokeColor;
//			self.strokeWidth = other.strokeWidth;
//		}
//	}	return self;
//}


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
- (void)setContentSubLayers
{
	NSA*rects  = _ss.rects;
	self.contentLayer.sublayers = [_content nmap:^id(id obj, NSUInteger index) {
		NSS* objClass 		= [obj isKindOfClass:[NSImage class]] ? @"img"
							: [obj isKindOfClass:[AZFile  class]] ? @"file" : @"else";

		CALayer *fileLayer 	= [CALayer layer];
		fileLayer.name		= obj[@"name"] ?: $(@"%ld", index);

		if ( areSame(objClass, @"img") ) fileLayer.bgC = ((NSC*)[obj quantize][0]).CGColor;

		if ( areSame(objClass, @"file")) fileLayer.bgC =  obj[@"color"] ? ((AZFile*)obj).color.CGColor
														 : [[obj[@"image"] quantize][0]CGColor ];

														 // ?: cgRANDOMCOLOR;
								
		fileLayer.contents 	= areSame(objClass, @"img")  ? obj
							: areSame(objClass, @"file") ? [[(AZFile*)obj image]scaledToMax:512]
							: [[NSImage systemIcons]randomElement];
		fileLayer.bounds = AZRectFromDim(100);
		fileLayer.position = AZRandomPointInRect(self.frame);
		AZLOG(fileLayer.debugDescription);
		return fileLayer;
	}];
}
-(void) awakeFromNib
{
	__block __typeof(self) selfish = self;
	self.postsBoundsChangedNotifications = YES;
	[self addObserverForKeyPaths:@[@"content" ] task:^(id obj, NSD *change) { [selfish setContentSubLayers];}];//
	[self addObserverForKeyPaths:@[@"contentLayer",NSViewBoundsDidChangeNotification ] task:^(id obj, NSD *change) { [selfish setSs:nil];	}];
//	[self addObserverForKeyPaths:@[@"ss"] task:^(id obj, NSD *change) { AZLOG(@"notified SS changed");	 [selfish.contentLayer setNeedsLayout]; }];
//	[AZNOTCENTER addObserver:self forKeyPaths:@[@"content"]];
//	[self addObserver:self forKeyPath:@"content" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	self.root 				= [self setupHostViewNamed:@"root"];
	self.contentLayer 		= [CALayer      layerNamed:@"content"];
	[@[_root, _contentLayer] eachWithIndex: ^(id obj, NSInteger idx) {
		obj[@"arMask"] 		= @(CASIZEABLE);
		obj[@"borderColor"] = idx ? (id)cgWHITE : (id) cgGREEN;
	}];
//	_contentLayer.nDoBC				= YES;
//	_contentLayer.layoutManager = self;
//	_contentLayer.delegate 	= self;
	[_root addSublayer:_contentLayer];
	[_contentLayer addConstraintsSuperSize];
	self.content 			= [AZFolder samplerWithCount:RAND_INT_VAL(12, 48)];
	//
}



//+ (BOOL)needsDisplayForKey:(NSString *)key {
//	if ([key isEqualToString:@"radius"] || [key isEqualToString:@"strokeWidth"]) {
//        return YES;
//    }
//	else {
//        return [super needsDisplayForKey:key];
//    }
//}
- (void) viewDidEndLiveResize {	[_contentLayer setNeedsLayout];	}



- (void) layoutSublayersOfLayer:(CALayer *)layer {

	AZLOG($(@"laying out sublayers of %@", layer));
//	structForQuantity:content.count inRect:[self frame]];
//				   contentLayer.sublayers.count inRect:[self frame]];
//	NSLog(@"Sizer rect: %@", NSStringFromRect(r));
//	int columns =  10;//r.origin.y;
//	int rows 	= 10;  //r.origin.x;
//	NSSize s 	= NSMakeSize(40, 40);//r.size.width, r.size.height);
	_ss = [AZSizer forQuantity:_content.count inRect:_root.frame];


	[_contentLayer.sublayers enumerateObjectsUsingBlock:^(CALayer* obj, NSUInteger idx, BOOL *stop) {
//		[CATransaction immediately:^{
		obj.position = [[_ss.positions normal:idx]pointValue];//
//										 /]AZCenterOfRect([[_ss.rects objectAtNormalizedIndex:idx]rectValue]));
			obj.bounds = AZMakeRectFromSize(_ss.size);//(CGRect){0,0,_ss.width, _ss.height};
		}];
//	}]; //		AZMakeRect( (NSPoint) {	s.width * columnindex,
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
