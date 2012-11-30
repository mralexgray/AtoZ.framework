//
//  PCProgressCirlceView.m
//  ProgressBar
//  Created by Patrick Chamelo on 8/26/12.

#import "Atoz.h"
#import "AZPropellerView.h"

@interface AZPropellerView()
@property (NATOM, ASS) NSIMG* badge;
- (CAAnimation*)rotateAnimation;
@end

@implementation AZPropellerView

- (NSIMG*) badge {

	NSIMG* b = [NSImage imageNamed:@"AZPropellerBadge"];
	return _badge = _color ? [b tintedWithColor:_color] : b;
}

- (id)initWithFrame:(NSRect)frame
{
	return [self initWithFrame:frame andColor:RANDOMCOLOR];
}
- (id)initWithFrame:(NSRect)frame andColor:(NSColor*)color
{
    if (self != [super initWithFrame:frame]) return nil;
	self.color = color;
	// create the NSImage view
	self.badgeView = [[NSImageView alloc] initWithFrame:frame];//NSMakeRect(0, 0,
																	//   badge.size.width,
																	  // badge.size.height)];
		
		// set it on the center of the parent container
		[self.badgeView setCenter:[self getCenter]];


		// set the badge iamge
		[self.badgeView setImage:self.badge];
		
		
		// spinner image
		NSImage *spinner = [NSImage imageNamed:@"Bar"];
		
		// create the progress image view
		self.progressImage = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0,
																		spinner.size.width,
																		spinner.size.height)];
		
		// enable its layer for the core animation
		self.progressImage.wantsLayer = YES;
				
		// set the center of the progress image
		// to the center of the badge
		[self.progressImage setCenter:[self.badgeView getCenterOnFrame]];
		
		// set the spinner image in the NSImage View
		[self.progressImage setImage:spinner];

		// first add the progress image in the container
		[self addSubview:self.progressImage];
		
		// then add the badge view
		[self addSubview:self.badgeView];

		// spin
		[self spin];

	return self;
}


// -----------------------
#pragma mark - Spinning
// -----------------------
- (void)spin
{
	// ensure the acnhor point is the center
	// so it animates with respect to the center
	self.progressImage.layer.anchorPoint = CGPointMake(0.5, 0.5);
	
	// add the animation to the layer
	[self.progressImage.layer addAnimation:[self rotateAnimation] forKey:@"rotate"];
}


- (void)stop
{
	// remove the animations from the layer
	[self.progressImage.layer removeAllAnimations];
}


// -----------------------
#pragma mark - Rotate Animation
// -----------------------
- (CAAnimation*)rotateAnimation;
{
	// create a CABasic animation
	CABasicAnimation *animation = [CABasicAnimation
								   animationWithKeyPath:@"transform.rotation.z"];
	
	// set the values for the rotation
	animation.fromValue = DegreesToNumber(359);
	animation.toValue = DegreesToNumber(0);
	animation.removedOnCompletion = NO;
	
	// set the speed and the fill mode
	animation.speed = 0.5f;
	animation.fillMode = kCAFillModeBackwards;
	
	// set the repeat count
	animation.repeatCount = HUGE_VALF;
	
	return animation;
}


@end
