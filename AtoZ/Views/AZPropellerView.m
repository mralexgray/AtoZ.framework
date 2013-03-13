//
//  PCProgressCirlceView.m
//  ProgressBar
//  Created by Patrick Chamelo on 8/26/12.

#import "AtoZ.h"
#import "AZPropellerView.h"


@interface AZPropellerView()
@property (ASS) BOOL isSpinning;
@property (NATOM, strong) NSIMG* badge, *spinner;
- (CAAnimation*)rotateAnimation;
@end

@implementation AZPropellerView

- (void) setColor:(NSColor *)color
{
	_badge =	_badgeView.image = [_badge tintedWithColor: color];
	_color = color;
}

- (id)initWithFrame:(NSRect)frame andColor:(NSColor*)color;
{
	if (self != [super initWithFrame:frame]) return nil;
	{
		_badge =	_badgeView.image = [_badge tintedWithColor: color];
		_color = color;
	}
	return self;
}

- (NSIMG*) badge {  return _badge = _badge ?: [NSImage frameworkImageNamed:@"AZPropellerBadge.png"]; }

- (id)initWithFrame:(NSRect)frame
{
    if (self != [super initWithFrame:frame]) return nil;

	
	// create the NSImage view
	self.badgeView = [[NSImageView alloc] initWithFrame:frame];
	
	// set it on the center of the parent container
	_badgeView.center = self.getCenter;
	_badgeView.image  = self.badge;

	NSImage *spinner = [NSImage frameworkImageNamed:@"AZPropellerBar.png"];
	
	// create the progress image view
	self.progressImage = [[NSImageView alloc] initWithFrame:frame];
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
    // ensure the acnhor point is the center so it animates with respect to the center
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

/**
@interface AZPropellerView()
@property (ASS) BOOL isSpinning;
@property (NATOM, ASS) NSIMG* badge;
- (CAAnimation*)rotateAnimation;
@end

@implementation AZPropellerView

- (NSIMG*) badge {

	NSIMG* b = [NSImage imageNamed:@"AZPropellerBadge"];
	return _badge = _color ? [b tintedWithColor:_color] : b;
}
- (NSColor*) color { return  _color =  _color ?: RANDOMCOLOR; }

- (void) awakeFromNib { [self initWithFrame:self.frame andColor:self.color]; }

- (id)initWithFrame:(NSRect)frame andColor:(NSColor*)color
{
    if (self != [super initWithFrame:frame]) return nil;

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

//+ (NSSet*) keyPathsForValuesAffectingIsSpinning { return $SET( @")

- (void)toggle { _isSpinning ? [self stop] : [self spin]; _isSpinning = !_isSpinning;	}

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

*/