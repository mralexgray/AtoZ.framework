//
//  AZLayer.h
//  AtoZ
//
//  Created by Alex Gray on 10/8/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"
#import <QuartzCore/QuartzCore.h>


#define AZTL AZTLayer
#define AZL  AZLayer


@interface AZLayer : CAL
@property (nonatomic, retain) CATransformLayer *tLayer;
@end

/*{
@private
	NSMutableArray *_activeContentAnimations;
	NSTimer *_updateTimer;
}

+ (NSSet *)keyPathsForValuesAffectingContent;

- (BOOL)isContentAnimation:(CAAnimation *)anim;
- (CABasicAnimation *)basicAnimationForKey:(NSString *)key;
- (id <CAAction>)actionForContents;

#define CurrentAnimationValue(field) ({ __typeof__(self) p = (id)self.presentationLayer; p.field; })

+ (BOOL)	 needsDisplayForKey: (NSS*) key;
+ (AZLayer*) layerAtIndex: (NSI)idx inRange:(RNG)rng withFrame:(CGR)frame;

//- (id) initWithLayer: (id) layer;

//+ (AZLayer*)withFrame:(NSRect)frame forObject:(id)file atIndex:(NSUInteger)index;
//- (void)orientWithX: (CGFloat)x andY: (CGFloat)y;

@property (NATOM, ASS) AZPOS 	orient;

@property (NATOM, ASS) RNG 		range;
@property (NATOM, ASS) NSI 		index;

@property (NATOM, ASS) CGF		offset;
//								unit;

@property (NATOM, ASS) BOOL 		flipped,
								hovered,
								selected;

//@property (retain, nonatomic) CALayer*			front;
//@property (retain, nonatomic) CALayer*			back;
//@property (retain, nonatomic) CALayer*			iconL;
//@property (retain, nonatomic) CATextLayer*		labelL;

//@property (retain, nonatomic) NSString*			string;
//@property (retain, nonatomic) NSImage*			image;
//
//@property (retain, nonatomic) NSString*			stringToDraw;
//@property (retain, nonatomic) NSFont*			font;
*/
