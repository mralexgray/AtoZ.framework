
#import "AtoZ.h"
#include <math.h>
#import "AZMacTrackBall.h"

static const float kTol = 0.001;

@implementation AZMacTrackBall   { CGFloat trackBallRadius; CGPoint trackBallCenter; CGFloat trackBallStartPoint[3]; }

+ (INST)trackBallWithLocation:(CGPoint)location inRect:(CGRect)bounds { return [self.alloc initWithLocation:location inRect:bounds];}
- (id)initWithLocation:		 (CGPoint)location inRect:(CGRect)bounds { SUPERINIT;
   _baseTransform = CATransform3DIdentity;
   trackBallRadius = AZMinDim(bounds.size)*.5;  // radius is half the smaller of width or height
	trackBallCenter = AZCenter(bounds); 			// trackball center is center of bounds
	[self setStartPointFromLocation:location];		return self;
}

- (void) setStartPointFromLocation:(CGPoint)location {
	// start point is the location from the center and calculated z point
	trackBallStartPoint[0] = location.x - trackBallCenter.x;
	trackBallStartPoint[1] = location.y - trackBallCenter.y;
	CGFloat dist = trackBallStartPoint[0] * trackBallStartPoint[0] + trackBallStartPoint[1] * trackBallStartPoint[1];
	trackBallStartPoint[2] = dist > trackBallRadius * trackBallRadius  ? 0.0f :  // outside the center of the sphere so make it zero
									   sqrt(trackBallRadius * trackBallRadius - dist);	// in the sphere so the z is the other side of the triangle
}
- (void) finalizeTrackBallForLocation:(CGPoint)location {	self.baseTransform = [self rotationTransformForLocation:location];	}
- (CATransform3D)rotationTransformForLocation:(CGPoint)location {
	CGFloat trackBallCurrentPoint[3] = {location.x - trackBallCenter.x, location.y - trackBallCenter.y, 0.0f};
	if(fabs(trackBallCurrentPoint[0] - trackBallStartPoint[0]) < kTol &&	fabs(trackBallCurrentPoint[1] - trackBallStartPoint[1]) < kTol)
		return CATransform3DIdentity;
	CGFloat dist = trackBallCurrentPoint[0] * trackBallCurrentPoint[0] + trackBallCurrentPoint[1] * trackBallCurrentPoint[1];
	trackBallCurrentPoint[2] = dist > trackBallRadius * trackBallRadius ? 0.0f :// outside the center of the sphere so make it zero
										  sqrt(trackBallRadius * trackBallRadius - dist);
	CGFloat rotationVector[3];		// cross product yields the rotation vector
	rotationVector[0] =  trackBallStartPoint[1] * trackBallCurrentPoint[2] - trackBallStartPoint[2] * trackBallCurrentPoint[1];
	rotationVector[1] = -trackBallStartPoint[0] * trackBallCurrentPoint[2] + trackBallStartPoint[2] * trackBallCurrentPoint[0];
	rotationVector[2] =  trackBallStartPoint[0] * trackBallCurrentPoint[1] - trackBallStartPoint[1] * trackBallCurrentPoint[0];
	// calc the angle between the current point vector and the starting point vector
	// use arctan so we get all eight quadrants instead of just the positive one
	// cos(a) = (start . current) / (||start|| ||current||)
	// sin(a) = (||start X current||) / (||start|| ||current||)
	// a = atan2(sin(a), cos(a))
	CGFloat startLength 		= sqrt(  trackBallStartPoint[0] *   trackBallStartPoint[0] +   trackBallStartPoint[1] *   trackBallStartPoint[1] +   trackBallStartPoint[2] *   trackBallStartPoint[2]);
	CGFloat currentLength 	= sqrt(trackBallCurrentPoint[0] * trackBallCurrentPoint[0] + trackBallCurrentPoint[1] * trackBallCurrentPoint[1] + trackBallCurrentPoint[2] * trackBallCurrentPoint[2]);
	CGFloat startDotCurrent =        trackBallStartPoint[0] * trackBallCurrentPoint[0] +   trackBallStartPoint[1] * trackBallCurrentPoint[1] +   trackBallStartPoint[2] * trackBallCurrentPoint[2]; // (start . current)
	CGFloat rotationLength 	= sqrt(       rotationVector[0] *        rotationVector[0] +        rotationVector[1] *        rotationVector[1] +        rotationVector[2] *        rotationVector[2]);

	CGFloat angle = atan2( rotationLength / (startLength * currentLength ), startDotCurrent / ( startLength * currentLength ));

	// normalize the rotation vector
	rotationVector[0] = rotationVector[0] / rotationLength;
	rotationVector[1] = rotationVector[1] / rotationLength;
	rotationVector[2] = rotationVector[2] / rotationLength;
	return CATransform3DConcat(self.baseTransform, CATransform3DMakeRotation(angle, rotationVector[0], rotationVector[1], rotationVector[2]));  //CATransform3D rotationTransform = ;
}

@end
