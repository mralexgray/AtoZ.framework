//
//  CoreAnimationView.m
//  CoreAnimationUpdateOnMainThread
//
//  Created by Patrick Geiller on 08/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <AtoZ/AtoZ.h>
#import "IsometricView.h"

#define MAX_GRID_SIZE 30
#define MIN_GRID_SIZE 10

//NSBP * BezierGridInRectWithScale
void DrawBluePrintInRectWithScale(NSR rect, CGF _grid){

 NSRectFillWithColor(rect, WHITE);

  static NSC * a, *b, * c;
  a = a ?: [NSC r:.39 g:.584 b:.93 a:.3];
  b = b ?: [NSC r:.39 g:.584 b:.93 a:.2];
  c = c ?: [NSC r:.39 g:.584 b:.93 a:.1];

  for (int i = 1; i < rect.size.height / 10.; i++) {
    NSC *setter = i % 10 == 0 ? a : i % 10 == 0 ? b : c; [setter set];
    NSP pointFrom = (NSP){ 0,   (i * _grid - 0.5f)};
    NSP pointTo   = (NSP){rect.size.width, (i * _grid - 0.5f)};
    [NSBP strokeLineFromPoint:pointFrom toPoint:pointTo];
  }
	for (int i = 1; i < rect.size.width / 10.; i++) {
    NSC *setter = i % 10 == 0 ? a : i % 10 == 0 ? b : c; [setter set];
    NSP pointFrom = (NSP){(i * _grid - 0.5f),0},
          pointTo = (NSP){(i * _grid - 0.5f),rect.size.height};

    [NSBP strokeLineFromPoint:pointFrom toPoint:pointTo];
  }
}
@implementation  BlueprintView

- (void) setGridSize:(CGFloat)gridSize { if (gridSize == _gridSize) return;

  gridSize = gridSize >= MIN_GRID_SIZE ? gridSize : MIN_GRID_SIZE;
  gridSize = gridSize <= MAX_GRID_SIZE ? gridSize : MAX_GRID_SIZE;
  _gridSize = gridSize;
  [self setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)rect{ DrawBluePrintInRectWithScale(rect, _gridSize = _gridSize ?: 15); }

@end


@implementation IsometricView

//
//	awakeFromNib
//		setup our background gradient, create our text layers
//
@synthesize rootLayer;
@synthesize editorField,editorSelector;
- (void)awakeFromNib
{
	// Gradient
	size_t num_locations = 3;
	CGFloat locations[3] = { 0.0, 0.7, 1.0 };
	CGFloat components[12] = {	0.0, 0.0, 0.0, 1.0,
		0.5, 0.7, 1.0, 1.0,
		1.0, 1.0, 1.0, 1.0 };

	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	backgroundGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);

	// CA setup
	[rootLayer setWantsLayer:YES];

	// Our container layer
	containerLayer = [CALayer layer];
	containerLayer.anchorPoint = CGPointMake(0, 0);
	[[self layer] addSublayer:containerLayer];

	NSDictionary* textStyle = [NSDictionary dictionaryWithObjectsAndKeys:
							   @"Futura-MediumItalic", @"font",
							   kCAAlignmentLeft, @"alignmentMode",
							   nil];

	int i, numLayers = 10;
	for (i=0; i<numLayers; i++)
	{
		CATextLayer* layer = [CATextLayer layer];
		layer.fontSize = 40;
		layer.style = textStyle;
		layer.foregroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
		layer.position = CGPointMake(50, 20+i*50);
		layer.anchorPoint = CGPointMake(0, 0);

		layer.string = [NSString stringWithFormat:@"Layer with some text %d", i+1];
		CGSize s = [layer preferredFrameSize];
		layer.bounds = CGRectMake(0, 0, s.width, s.height);
		[containerLayer addSublayer:layer];
	}

	[self enableShadows:YES];
}

//
//	drawRect
//		draw our background gradient, Core Animation handles the rest
//
- (void)drawRect:(NSRect)rect
{
	float width = [self frame].size.width;
	float height = [self frame].size.height;
	CGContextRef ctx = [AZGRAPHICSCTX graphicsPort];
	CGContextDrawRadialGradient(ctx, backgroundGradient,
								CGPointMake(width/2, height), width,
								CGPointMake(width/2, -height/2), 0,
								kCGGradientDrawsAfterEndLocation);
}
//
//	enableShadows
//		enable/disable shadows of text layers
//
- (IBAction)new:(id)sender {
}

- (void)enableShadows:(BOOL)hasShadows
{
	for (CALayer* layer in containerLayer.sublayers)
	{
		layer.shadowRadius = 3.0;
		layer.shadowOffset = CGSizeMake(0, -3);
		layer.shadowOpacity = hasShadows ? 1 : 0;
	}
}
//
//	IB : toggle shadows
//
- (IBAction)toggleShadows:(id)sender
{
	[self enableShadows:[(NSButton*)sender state]];
}

/*

 Appear effects
 Same strategy for all 3 effects : first, we hide layers by setting their opacity to 0.
 We then force redraw with [CATransaction commit], this gives us a blank screen.

 We pause between each layer for the sake of demonstrating redraw while blocking on the main thread.
 In the real world, we would either set up a keyframe animation with custom times or
 call the next update with performSelector:withObject:afterDelay:

 We then set a new position, scale, or orientation to interpolate from.
 To do this, we use kCATransactionAnimationDuration with a value of 0 to force Core Animation to set our new value NOW.
 Finally, we reset transform to identity and opacity to 1.0 : this is where the transition happens.
	*/
- (IBAction)appearWithRotation:(id)sender
{
	// Hide layers
	for (CALayer* layer in containerLayer.sublayers)	layer.opacity = 0.0;

	// Redraw now - with layers hidden, this will erase our view
	[CATransaction commit];

	// Show layers
	for (CALayer* layer in containerLayer.sublayers)
	{
		sleep(1);

		[CATransaction setValue:[NSNumber numberWithFloat:0.0] forKey:kCATransactionAnimationDuration];
		layer.transform = CATransform3DMakeRotation(1.57, 0, 0, 1);
		[CATransaction commit];

		layer.opacity = 1.0;
		layer.transform = CATransform3DIdentity;
		[CATransaction commit];
	}
}

- (IBAction)appearWithTranslation:(id)sender
{
	// Hide layers
	for (CALayer* layer in containerLayer.sublayers)	layer.opacity = 0.0;

	// Redraw now - with layers hidden, this will erase our view
	[CATransaction commit];

	// Show layers
	for (CALayer* layer in containerLayer.sublayers)
	{
		sleep(1);

		CGPoint originalPosition = layer.position;

		[CATransaction setValue:[NSNumber numberWithFloat:0.0] forKey:kCATransactionAnimationDuration];
		layer.position = CGPointMake(-300, originalPosition.y);
		[CATransaction commit];

		layer.opacity = 1.0;
		layer.position = originalPosition;
		[CATransaction commit];
	}
}
- (IBAction)appearWithScale:(id)sender
{
	// Hide layers
	for (CALayer* layer in containerLayer.sublayers)	layer.opacity = 0.0;

	// Redraw now - with layers hidden, this will erase our view
	[CATransaction commit];

	// Show layers
	for (CALayer* layer in containerLayer.sublayers)
	{
		sleep(1);

		[CATransaction setValue:[NSNumber numberWithFloat:0.0] forKey:kCATransactionAnimationDuration];
		float s = 10;
		layer.transform = CATransform3DMakeScale(s, s, s);
		[CATransaction commit];

		layer.opacity = 1.0;
		layer.transform = CATransform3DIdentity;
		[CATransaction commit];
	}
}

@end
