
#import "AZScrollPaneLayer.h"
#import "AZTimeLineLayout.h"
#import "AZSnapShotLayer.h"

//#import "MiscUtils.h"

@interface AZScrollPaneLayer (PrivateMethods)
- (void)scrollToSelected;
- (NSInteger)selectedIndex;
- (void)zoomAnimation:(AZSnapShotLayer*)layer;
- (void)moveScrollView:(CGFloat)dx;
@end

@implementation AZScrollPaneLayer

@synthesize contentController=_contentController;

- (void)layoutSublayers {

	// save the center point of the visible
	CGFloat relativeCenterPoint = ([self visibleRect].origin.x + [self visibleRect].size.width * 0.5)
	/ contentWidth;
	[super layoutSublayers];


	if ( contentWidth != [self contentWidth] || visibleWidth != [self visibleWidth] ) {
		contentWidth = [self contentWidth];
		visibleWidth = [self visibleWidth];
		stepSize = contentWidth / [[self sublayers] count];
		[_contentController scrollContentResized];
	}

	if ( ! [_contentController isRepositioning] ) {
		[self scrollToPoint:CGPointMake(contentWidth * relativeCenterPoint - visibleWidth * 0.5, 0)];
	}
}


- (void)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint {
	CGPoint point = [self convertPoint:inputPoint fromLayer:self.superlayer];

	for ( CALayer* sublayer in [self sublayers] ) {
		if ( CGRectContainsPoint ( sublayer.frame, point ) ) {
			NSInteger layerIndex = [[self sublayers] indexOfObject:sublayer];
			[self selectSnapShot:layerIndex];

		}
	}

}

- (void)selectSnapShot:(NSInteger)index {
	// -- check that integer is within bounds
	if( index < 0 || index >= [[self sublayers] count] )		return;
	NSInteger selectedIndex = [self selectedIndex];
	AZSnapShotLayer* snapShot = [ [self sublayers] objectAtIndex:selectedIndex];
	AZFile *f = snapShot.objectRep;
	CGColorRef rrr = f.color.CGColor;
	NSLog(@"selected:%@",f);
	snapShot.backgroundColor = rrr;
	snapShot.selected = NO;
	snapShot = [ [self sublayers] objectAtIndex:index];
	snapShot.selected =YES;
	[self setValue:@(index) forKey:selectedSnapShot];
	[self zoomAnimation:snapShot];
//	[self startWiggling:snapS `hot];
	// This will override the shift key...This should be moved to view logic
	[CATransaction setValue:@0.9f forKey:@"animationDuration"];
	[self scrollToSelected];
}

- (void)zoomAnimation:(AZSnapShotLayer*)layer {

	CGRect currentBounds = layer.bounds;
	CGFloat currentWidth = currentBounds.size.width;
	CGFloat expansion = XMARGIN * 0.25;
	CGRect newBounds = CGRectMake(0, 0, currentWidth + expansion, currentBounds.size.height + expansion);
	CGFloat duration = 0.2;

	CABasicAnimation *boundsAnimation;

	boundsAnimation=[CABasicAnimation animationWithKeyPath:@"bounds"];
	boundsAnimation.duration=duration;
	boundsAnimation.repeatCount=1;
	boundsAnimation.autoreverses=YES;
	boundsAnimation.fromValue= AZVrect(currentBounds);
	boundsAnimation.toValue = AZVrect(newBounds);
	[layer addAnimation:boundsAnimation forKey:@"animateBounds"];


	CABasicAnimation *positionAnimation;

	NSPoint animationOrigin = NSMakePoint(layer.frame.origin.x - expansion * 0.5,
											layer.frame.origin.y - expansion * 0.5);

	positionAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.duration=duration;
	positionAnimation.repeatCount=1;
	positionAnimation.autoreverses=YES;
	positionAnimation.fromValue= AZVpoint(layer.frame.origin);
	positionAnimation.toValue= AZVpoint(animationOrigin);
	[layer addAnimation:positionAnimation forKey:@"animatePosition"];

}

- (void)moveSelection:(NSInteger)dx {
	[self selectSnapShot: [self selectedIndex] + dx];
}

- (void)scrollToSelected {
	AZTimeLineLayout* layout = [self layoutManager];
	[self scrollToPoint:[layout scrollPointForSelected:self]];
}

- (NSInteger)selectedIndex {
	NSNumber *number = [self valueForKey:selectedSnapShot];
	return number != nil ? [number integerValue] : 0;
}



#pragma mark -
#pragma mark CAScrollLayer Methods

- (void)scrollToPoint:(CGPoint)thePoint {
	[super scrollToPoint:thePoint];
	[_contentController scrollPositionChanged:thePoint.x];
}


#pragma mark -
#pragma mark SFScrollerContent Protocol Methods


- (CGFloat)contentWidth {
	return [ self.layoutManager preferredSizeOfLayer:self].width;
}

- (CGFloat)visibleWidth {
	return [self visibleRect].size.width;
}

- (void)scrollToPosition:(CGFloat)position {
	CGFloat positionPercentage = position;
	if(position < 0 ) {
		positionPercentage = 0;
	}

	if( position > 1 ) {
		positionPercentage = 1;
	}


	CGFloat newX = [self contentWidth] * positionPercentage;
	if (newX > contentWidth - visibleWidth ) newX = contentWidth - visibleWidth;
	[self scrollToPoint:CGPointMake(newX, 0)];
}

- (void)moveScrollView:(CGFloat)dx {
	CGPoint scrollPoint = CGPointMake(self.visibleRect.origin.x + dx, self.visibleRect.origin.y);
	if (scrollPoint.x < 0 ) scrollPoint.x = 0;
	if (scrollPoint.x > contentWidth - visibleWidth ) scrollPoint.x = contentWidth - visibleWidth;

	[CATransaction setValue:@0.8f forKey:@"animationDuration"];
	[self scrollToPoint:scrollPoint]; 
}

- (CGFloat)stepSize {
	return stepSize;
}




- (void)startWiggling:(CALayer*)laylay {

	laylay.position = CGPointMake(.5,.5);
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
	anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.05],
					 [NSNumber numberWithFloat:0.05],
					 nil];
	anim.duration = RAND_FLOAT_VAL(.2,.7);
	anim.autoreverses = YES;
	anim.repeatCount = HUGE_VALF;
	[laylay addAnimation:anim forKey:@"wiggleRotation"];

	anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
	anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1],
					 [NSNumber numberWithFloat:1],
					 nil];
	anim.duration = RAND_FLOAT_VAL(.1,.3);//0.07f + ((tileIndex % 10) * 0.01f);
	anim.autoreverses = YES;
	anim.repeatCount = HUGE_VALF;
	anim.additive = YES;
	[laylay addAnimation:anim forKey:@"wiggleTranslationY"];
}
- (void)stopWiggling:(CALayer*)laylay {
	[laylay removeAnimationForKey:@"wiggleRotation"];
	[laylay removeAnimationForKey:@"wiggleTranslationY"];
}



@end
