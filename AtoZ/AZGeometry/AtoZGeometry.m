//
//  THGeometricFunctions.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AtoZGeometry.h"
#import "AtoZ.h"
#import <Quartz/Quartz.h>

@implementation AtoZGeometry
@end


BOOL AZEqualRects(NSR r1, NSR r2){ return NSEqualRects(r1,r2); }

const CGP AZAnchorTop		  = (CGP) { .5, 1 };
const CGP AZAnchorBottom	  = (CGP) { .5, 0 };
const CGP AZAnchorRight		  = (CGP) {  1,.5 };
const CGP AZAnchorLeft 		  = (CGP) {  0,.5 };
const CGP AZAnchorTopLeft	  = (CGP) { .5,.5 };  //  0, 1 };
const CGP AZAnchorBottomLeft  = (CGP) { .5,.5 };  // 0, 0 };
const CGP AZAnchorTopRight    = (CGP) { .5,.5 };  // 1, 1 };
const CGP AZAnchorBottomRight = (CGP) { .5,.5 };  //1, 0 };


AZPOS AZPositionAtPerimeterInRect(NSR edgeBox, NSR outer)
{
//	CGF max, left, right, top, bttom

	AZOrient vORh = (edgeBox.origin.x == outer.origin.x || (edgeBox.origin.x + edgeBox.size.width) == outer.size.width)
				  ? AZOrientVertical : AZOrientHorizontal;
	AZPOS p;
	if ( vORh == AZOrientHorizontal ) p = edgeBox.origin.y == 0 ? AZPositionBottom : AZPositionTop;
	else 				              p = edgeBox.origin.x == 0 ? AZPositionLeft : AZPositionRight;
	return p;
}

CGP AZAnchorPointForPosition( AZPOS pos){

	return pos == AZPositionLeft  		? AZAnchorLeft
		 : pos == AZPositionTop    		? AZAnchorTop
		 : pos == AZPositionBottom 		? AZAnchorBottom
		 : pos == AZPositionRight  		? AZAnchorRight
		 : pos == AZPositionTopLeft		? AZAnchorTopLeft
		 : pos == AZPositionBottomLeft 	? AZAnchorBottomLeft
	 	 : pos == AZPositionTopRight	? AZAnchorTopRight
		 : 								  AZAnchorBottomRight;  //pos == AZPositionRight


}

NSR	AZRandomRectinRect(CGRect rect){

	NSR r = AZRectFromDim(RAND_FLOAT_VAL(0, AZMinDim(rect.size)));
	r.origin = AZRandomPointInRect(AZRectFromDim(AZMinDim(rect.size) - r.size.width));
	return r;
}


CGP AZRandomPointInRect(CGRect rect)
{
	CGP point = CGPointZero;
	NSInteger max = rect.size.width;
	NSInteger min = 0;
	point.x = (random() % (max-min+1)) + min;

	max = rect.size.height;
	point.y = (random() % (max-min+1)) + min;

	return point;
}

NSNumber *iNum(NSInteger i) {
  return [NSNumber numberWithInt:i];
}

NSNumber *uNum(NSUInteger ui) {
  return [NSNumber numberWithUnsignedInt:ui];
}

NSNumber *fNum(CGFloat f) {
  return [NSNumber numberWithFloat:f];
}

NSNumber *dNum(double d) {
  return @(d);
}

NSRange AZMakeRange(NSUInteger min, NSUInteger max) {
  NSUInteger loc = MIN(min, max);
  NSUInteger len = MAX(min, max) - loc;
  return NSMakeRange(loc, len);
}

NSR nanRectCheck(NSR rect) {
		rect.origin = nanPointCheck(rect.origin);
		rect.size 	= nanSizeCheck(rect.size);
		return rect;
}
NSSize nanSizeCheck(NSSize size) {
	size.width  = isinf(size.width)  ? 0 : size.width;
	size.height = isinf(size.height) ? 0 : size.height;
	return  size;
}
NSPoint nanPointCheck(NSPoint origin) {
	origin.x = isinf(origin.x) ? 0 : origin.x;
	origin.y = isinf(origin.y) ? 0 : origin.y;
	return origin;
}

//id nanCheck(NSValue* point) {
//	id behind;
//	if ( [point respondsToSelector:@selector(recttValue)] ) behind = (__bridge_transfer NSR)nanRectCheck( [point rectValue]);
//		:   [point respondsToSelector:@selector(sizeValue)]  ? nanSizeCheck(  [point pointValue])
//		:   					 							   nanPointCheck( [point pointValue]);
//}
NSPoint AZPointOffset (NSPoint p, NSPoint size) {
	p.x += size.x;
	p.y += size.y;
	return p;
}
NSPoint AZPointOffsetY (NSPoint p, CGFloat distance) {
	p.y += distance;
	return p;
}
NSPoint AZPointOffsetX (NSPoint p, CGFloat distance) {
	p.x += distance;
	return p;
}

CGFloat AZAspectRatioForSize(NSSize size){
	return	size.height == size.width	? 1.0 :
	size.width / size.height;
}
CGFloat AZAspectRatioOf(CGFloat width, CGFloat height){
	return AZAspectRatioForSize(NSMakeSize(width, height));
}

NSI AZLowestCommonDenominator(int a, int b){
	int i;
	for(i = 2; (a % i != 0) || (b%i != 0); ++i)
		{
		if( i > a || i > b)//a and b are prime
			return 1;
		}
	return i;
}

BOOL isWhole(CGFloat fl) {
	return fmod(fl, 1.0) == 0.0 ? YES : NO;
}

int GCD(int a, int b) {
    while (a != 0 && b != 0)	 if (a > b) a %= b; else  b %= a;
	return a == 0 ? b : a;
}

// Using Konrad's code:

//var gcd = GCD(A, B);
//return string.Format("{0}:{1}", A / gcd, B / gcd)

NSString* AZAspectRatioString(CGFloat ratio)
{
	CGFloat a, b; int newRatio, m; m =10;
	if (ratio != 1.0) {
		while (	isWhole(m * ratio) == NO) m = m *10;

		newRatio = GCD(m, (int)m*ratio );
	}

	return	ratio == 1.0 ?	@"** 1 : 1 **" : $(@"%i : %i", (int)(m*ratio/newRatio),(int)(m/newRatio));
//	size.height > _size.width  ?	$(@"1 : %0.1f", (float)(_size.height/_size.width))
//	//	: 	$(@"%0.1f : 1", (float)(_size.width/_size.height));
//	return
// @"poop";
}

//CGSize AZAspectRatio(NSR rect ){

// CGFloat aspectRatio = ( rect.width / rect.height );
//}
CGFloat AZPerimeter (NSR rect) {
	return ( (2* rect.size.width) + (2 * rect.size.height) );
}

CGFloat AZPermineterWithRoundRadius (NSR rect, CGFloat radius) {
	return  ( AZPerimeter(rect) - ( ( 8 - (   (2 * pi) * radius)   )));
}
NSR AZScreenFrameUnderMenu(void) { return AZRectTrimmedOnTop( [[NSScreen mainScreen]frame], AZMenuBarThickness()); }
NSR AZScreenFrame (void) {		  return [[NSScreen mainScreen]frame];	}
NSSize AZScreenSize  (void) {		  return AZScreenFrame().size; }

// 2D Functions

CGFloat AZMinDim(NSSize sz) {	return MIN(sz.width, sz.height); }
CGFloat AZMaxDim(NSSize sz) {	return MAX(sz.width, sz.height); }
CGFloat AZMaxEdge(NSR r) { 	return AZMaxDim(r.size); }
CGFloat AZMinEdge(NSR r) {	return AZMinDim(r.size); }

CGFloat AZLengthOfPoint(NSPoint pt) {
  return sqrt(pt.x * pt.x + pt.y * pt.y);
  //return ABS(pt.x) + ABS(pt.y);
}

CGFloat AZAreaOfSize(NSSize size) {
  return size.width * size.height;
}

CGFloat AZAreaOfRect(NSR rect) {
  return AZAreaOfSize(rect.size);
}
CGFloat AZPointDistance(CGP p1, CGP p2) {
	return sqrtf(powf(p1.x - p2.x, 2.) + powf(p1.y - p2.y, 2.));
}

CGFloat AZPointAngle(CGP p1, CGP p2) {
	return atan2f(p1.x - p2.x, p1.y - p2.y);
}

CGFloat AZDistanceFromPoint (NSPoint p1,NSPoint p2) {
	return distanceFromPoint(p1, p2);
}
CGFloat distanceFromPoint (NSPoint p1, NSPoint p2) {
	CGFloat temp;
	temp = pow(p1.x - p2.x, 2);
	temp += pow(p1.y - p2.y, 2);
	return (CGFloat)sqrt(temp);
}
//
// NSPoint result functions
//
NSPoint AZOriginFromMenubarWithX(CGFloat yOffset, CGFloat xOffset) {

	NSPoint topLeft = NSMakePoint(0,[[NSScreen mainScreen]frame].size.height);
	topLeft.x += xOffset;
	topLeft.y -= yOffset;
	topLeft.y -= 22;
	return topLeft;
}

NSPoint AZPointFromSize(NSSize size) {
  return NSMakePoint(size.width, size.height);
}

NSPoint AZAbsPoint(NSPoint point) {
  return NSMakePoint(ABS(point.x), ABS(point.y));
}

NSPoint AZFloorPoint(NSPoint point) {
  return NSMakePoint(floor(point.x), floor(point.y));
}

NSPoint AZCeilPoint(NSPoint point) {
  return NSMakePoint(ceil(point.x), ceil(point.y));
}

NSPoint AZRoundPoint(NSPoint point) {
  return NSMakePoint(round(point.x), round(point.y));
}

NSPoint AZNegatePoint(NSPoint point) {
  return NSMakePoint(-point.x, -point.y);
}

NSPoint AZInvertPoint(NSPoint point) {
  return NSMakePoint(1 / point.x, 1 / point.y);
}

NSPoint AZSwapPoint(NSPoint point) {
  return NSMakePoint(point.y, point.x);
}

NSPoint AZAddPoints(NSPoint one, NSPoint another) {
  return NSMakePoint(one.x + another.x, one.y + another.y);
}

NSPoint AZSubtractPoints(NSPoint origin, NSPoint subtrahend) {
  return NSMakePoint(origin.x - subtrahend.x, origin.y - subtrahend.y);
}

NSPoint AZSumPoints(NSUInteger count, NSPoint point, ...) {
  NSPoint re = point;
  
  va_list pts;
  va_start(pts, point);
  
  for (int i = 0; i < count; i++) {
    NSPoint pt = va_arg(pts, NSPoint);
    re.x += pt.x;
    re.y += pt.y;
  }
  
  va_end(pts);
  
  return re;
}

NSPoint AZMultiplyPoint(NSPoint point, CGFloat multiplier) {
  return NSMakePoint(point.x * multiplier, point.y * multiplier);
}

NSPoint AZMultiplyPointByPoint(NSPoint one, NSPoint another) {
  return NSMakePoint(one.x * another.x, one.y * another.y);
}

NSPoint AZMultiplyPointBySize(NSPoint one, NSSize size) {
  return NSMakePoint(one.x * size.width, one.y * size.height);
}

NSPoint AZRelativeToAbsolutePoint(NSPoint relative, NSR bounds) {
  return NSMakePoint(relative.x * bounds.size.width  + bounds.origin.x,
                     relative.y * bounds.size.height + bounds.origin.y
                     );
}

NSPoint AZAbsoluteToRelativePoint(NSPoint absolute, NSR bounds) {
  return NSMakePoint((absolute.x - bounds.origin.x) / bounds.size.width, 
                     (absolute.y - bounds.origin.y) / bounds.size.height
                     );
}

NSPoint AZDividePoint(NSPoint point, CGFloat divisor) {
  return NSMakePoint(point.x / divisor, point.y / divisor);
}

NSPoint AZDividePointByPoint(NSPoint point, NSPoint divisor) {
  return NSMakePoint(point.x / divisor.x, point.y / divisor.y);
}

NSPoint AZDividePointBySize(NSPoint point, NSSize divisor) {
  return NSMakePoint(point.x / divisor.width, point.y / divisor.height);
}
NSPoint AZMovePoint(NSPoint origin, NSPoint target, CGFloat p) {
  // delta = distance fom target to origin
  NSPoint delta = AZSubtractPoints(target, origin);
  // multiply that with the relative distance
  NSPoint way   = AZMultiplyPoint(delta, p);
  // add it to the origin to move along the way
  return AZAddPoints(origin, way);
}

NSPoint AZMovePointAbs(NSPoint origin, NSPoint target, CGFloat pixels) {
  // Distance from target to origin
  NSPoint delta = AZSubtractPoints(target, origin);
  // normalize that by x to recieve the x2y-ratio
  // but wait, if x is 0 already it can not be normalized
  if (delta.x == 0) {
    // in this case check whether y is empty too
    if (delta.y == 0) {
      // cannot move anywhere
      return origin;
    }
    return NSMakePoint(origin.x, 
                       origin.y + pixels * (delta.y > 0 ? 1.0 : -1.0));
  }
  // now, grab the normalized way
  CGFloat ratio = delta.y / delta.x;
  CGFloat x = pixels / sqrt(1.0 + ratio * ratio);
  if (delta.x < 0) x *= -1;
  NSPoint move = NSMakePoint(x, x * ratio);
  return AZAddPoints(origin, move);
}

NSPoint AZCenterOfRect(NSR rect) {
  // simple math, just the center of the rect
  return NSMakePoint(rect.origin.x + rect.size.width  * 0.5, 
                     rect.origin.y + rect.size.height * 0.5);
}

NSPoint AZCenterOfSize(NSSize size) {
  return NSMakePoint(size.width  * 0.5, 
                     size.height * 0.5);
}

NSPoint AZEndOfRect(NSR rect) {
  return NSMakePoint(rect.origin.x + rect.size.width,
                     rect.origin.y + rect.size.height);
}
/*
 *   +-------+
 *   |       |   
 *   |   a   |   +-------+
 *   |       |   |       |
 *   +-------+   |   b   |
 *               |       |
 *               +-------+
 */
NSPoint AZCenterDistanceOfRects(NSR a, NSR b) {
  return AZSubtractPoints(AZCenterOfRect(a),
                          AZCenterOfRect(b));
}

NSPoint AZBorderDistanceOfRects(NSR a, NSR b) {
  // 
  // +------------ left
  // |
  // |     +------ right  
  // v     v
  // +-----+ <---- top
  // |     |
  // +-----+ <---- bottom
  //
  
  // distances, always from ones part to anothers counterpart
  // a zero x or y indicated that the rects overlap in that dimension
  NSPoint re = NSZeroPoint;
  
  NSPoint oa = a.origin;
  NSPoint ea = AZEndOfRect(a);
  
  NSPoint ob = b.origin;
  NSPoint eb = AZEndOfRect(b);
  
  // calculate the x and y separately

  // left / right check
  if (ea.x < ob.x) {
    // [a] [b] --- a left of b
    // positive re.x
    re.x = ob.x - ea.x;
  } else if (oa.x > eb.x) {
    // [b] [a] --- a right of b
    // negative re.x
    re.x = eb.x - oa.x;
  }
  
  // top / bottom check
  if (ea.y < ob.y) {
    // [a] --- a above b
    // [b]
    // positive re.y
    re.y = ob.y - ea.y;
  } else if (oa.y > eb.y) {
    // [b] --- a below b
    // [a]
    // negative re.y
    re.y = eb.y - oa.y;
  }
  
  return re;
}

NSPoint AZNormalizedDistanceOfRects(NSR from, NSR to) {
  NSSize mul = AZInvertSize(AZBlendSizes(from.size, to.size, 0.5));
  NSPoint re = AZCenterDistanceOfRects(to, from);
          re = AZMultiplyPointBySize(re, mul);

  return re;
}

NSPoint AZNormalizedDistanceToCenterOfRect(NSPoint point, NSR rect) {
  NSPoint center = AZCenterOfRect(rect);
  NSPoint half   = AZMultiplyPoint(AZPointFromSize(rect.size), 0.5);
  NSPoint re     = AZSubtractPoints(point, center);
          re     = AZMultiplyPointByPoint(re, half);
  
  return re;
}

NSPoint AZPointDistanceToBorderOfRect(NSPoint point, NSR rect) {
  NSPoint re = NSZeroPoint;
  
  NSPoint o = rect.origin;
  NSPoint e = AZEndOfRect(rect);
  
  if (point.x < o.x) {
    re.x = point.x - re.x;
  } else if (point.x > e.x) {
    re.x = e.x - point.x;
  }
  
  if (point.y < o.y) {
    re.y = point.y - re.y;
  } else if (point.y > e.y) {
    re.y = e.y - point.y;
  }

  return re;
}
NSPoint AZPointFromDim(CGFloat val){
	return (NSPoint){val,val};
}
//
// NSSize functions
//


NSR AZRectBy(CGFloat boundX, CGFloat boundY)
{
	return NSMakeRect(0,0,boundX, boundY);
}

NSR AZRectFromDim(CGFloat dim) {
	return (NSR){0,0,dim,dim};
}
NSSize AZSizeFromDimension(CGFloat dim) {
	return NSMakeSize(dim, dim);
}

NSSize AZSizeFromPoint(NSPoint point) {
  return NSMakeSize(point.x, point.y);
}

NSSize AZAbsSize(NSSize size) {
  return NSMakeSize(ABS(size.width), ABS(size.height));
}

NSSize AZAddSizes(NSSize one, NSSize another) {
  return NSMakeSize(one.width + another.width, 
                    one.height + another.height);
}

NSSize AZInvertSize(NSSize size) {
  return NSMakeSize(1 / size.width, 1 / size.height);
}

NSSize AZRatioOfSizes(NSSize inner, NSSize outer) {
  return NSMakeSize (inner.width / outer.width,
                    inner.height / outer.height);
}

NSSize AZMultiplySize( NSSize size, CGFloat multiplier) {
  return (NSSize) { size.width * multiplier, size.height * multiplier };
}

NSSize AZMultiplySizeBySize(NSSize size, NSSize another) {
  return NSMakeSize(size.width * another.width, 
                    size.height * another.height);
}

NSSize AZMultiplySizeByPoint(NSSize size, NSPoint point) {
  return NSMakeSize(size.width * point.x, 
                    size.height * point.y);
}

NSSize AZBlendSizes(NSSize one, NSSize another, CGFloat p) {
  NSSize way;
  way.width  = another.width - one.width;
  way.height = another.height - one.height;
  
  return NSMakeSize(one.width + p * way.width, 
                    one.height + p * way.height);
}

NSSize AZSizeMax(NSSize one, NSSize another) {
  return NSMakeSize(MAX(one.width, another.width),
                    MAX(one.height, another.height));
}

NSSize AZSizeMin(NSSize one, NSSize another) {
  return NSMakeSize(MIN(one.width, another.width),
                    MIN(one.height, another.height));
  
}

NSSize AZSizeBound(NSSize preferred, NSSize minSize, NSSize maxSize) {
  NSSize re = preferred;
  
  re.width  = MIN(MAX(re.width,  minSize.width),  maxSize.width);
  re.height = MIN(MAX(re.height, minSize.height), maxSize.height);
  
  return re;
}
//
// NSR result functions
//
NSR AZRectVerticallyOffsetBy(CGRect rect, CGFloat offset) {
	rect.origin.y += offset;
	return  rect;
}

NSR AZRectHorizontallyOffsetBy(CGRect rect, CGFloat offset) {
	rect.origin.x += offset;
	return  rect;
}

NSR AZFlipRectinRect(CGRect local, CGRect dest)
{
	NSPoint a = NSZeroPoint;
	a.x = dest.size.width - local.size.width;
	a.y = dest.size.height - local.size.height;
	return AZMakeRect(a,local.size);
}

NSR AZSquareFromLength(CGFloat length) {
	return  AZMakeRectFromSize(NSMakeSize(length,length));
}

NSR AZZeroHeightBelowMenu(void) {
	NSR e = AZScreenFrame();
	e.origin.y += (e.size.height - 22);
	e.size.height = 0;
	return e;
}
NSR AZMenuBarFrame(void) {
	return AZUpperEdge( AZScreenFrame(), AZMenuBarThickness());
}

CGFloat AZMenuBarThickness (void) { return [[NSStatusBar systemStatusBar] thickness]; }

NSR AZMenulessScreenRect(void) {
	NSR e = AZScreenFrame();
	e.size.height -= 22;
	return e;
}
CGFloat AZHeightUnderMenu (void) {
	return ( [[NSScreen mainScreen]frame].size.height - [[NSStatusBar systemStatusBar] thickness] );
}
NSR AZMakeRectMaxXUnderMenuBarY(CGFloat distance) {
	NSR rect = [[NSScreen mainScreen]frame];
	rect.origin = NSMakePoint(0,rect.size.height - 22 - distance);
	rect.size.height = distance;
	return rect;
}

NSR AZMakeRectFromPoint(NSPoint point) {
  return NSMakeRect(point.x, point.y, 0, 0);
}

NSR AZMakeRectFromSize(NSSize size) {
  return NSMakeRect(0, 0, size.width, size.height);
}

NSR AZMakeRect(NSPoint point, NSSize size) {
  return  nanRectCheck( NSMakeRect(point.x,	point.y, size.width, size.height));
}

NSR AZMakeSquare(NSPoint center, CGFloat radius) {
  return NSMakeRect(center.x - radius, 
                    center.y - radius, 
                    2 * radius, 
                    2 * radius);
}
NSR AZMultiplyRectBySize(NSR rect, NSSize size) {
  return NSMakeRect(rect.origin.x    * size.width,
                    rect.origin.y    * size.height,
                    rect.size.width  * size.width,
                    rect.size.height * size.height
                    );
}

NSR AZRelativeToAbsoluteRect(NSR relative, NSR bounds) {
  return NSMakeRect(relative.origin.x    * bounds.size.width  + bounds.origin.x,
                    relative.origin.y    * bounds.size.height + bounds.origin.y,
                    relative.size.width  * bounds.size.width,
                    relative.size.height * bounds.size.height
                    );
}

NSR AZAbsoluteToRelativeRect(NSR a, NSR b) {
  return NSMakeRect((a.origin.x - b.origin.x) / b.size.width,
                    (a.origin.y - b.origin.y) / b.size.height,
                    a.size.width  / b.size.width,
                    a.size.height / b.size.height
                    );
}
NSR AZPositionRectOnRect(NSR inner, NSR outer, NSPoint position) {
  return NSMakeRect(outer.origin.x 
                    + (outer.size.width - inner.size.width) * position.x, 
                    outer.origin.y 
                    + (outer.size.height - inner.size.height) * position.y, 
                    inner.size.width, 
                    inner.size.height
                    );
}

NSR AZCenterRectOnPoint(NSR rect, NSPoint center) {
  return NSMakeRect(center.x - rect.size.width  / 2, 
                    center.y - rect.size.height / 2, 
                    rect.size.width, 
                    rect.size.height);
}

NSR AZCenterRectOnRect(NSR inner, NSR outer) {
  return AZPositionRectOnRect(inner, outer, AZHalfPoint);
}

NSR AZSquareAround(NSPoint center, CGFloat distance) {
  return NSMakeRect(center.x - distance, 
                    center.y - distance, 
                    2 * distance, 
                    2 * distance
                    );
}

NSR AZBlendRects(NSR from, NSR to, CGFloat p) {
  NSR re;

  CGFloat q = 1 - p;
  re.origin.x    = from.origin.x    * q + to.origin.x    * p;
  re.origin.y    = from.origin.y    * q + to.origin.y    * p;
  re.size.width  = from.size.width  * q + to.size.width  * p;
  re.size.height = from.size.height * q + to.size.height * p;

  return re;
}

NSR AZRectTrimmedOnRight(NSR rect, CGFloat width) {
	return NSMakeRect(	rect.origin.x, 					rect.origin.y,
					  	rect.size.width - width,  		rect.size.height	);
}

NSR AZRectTrimmedOnBottom(NSR rect, CGFloat height) {
	return NSMakeRect(	rect.origin.x, 					(rect.origin.y + height),
						rect.size.width,  				(rect.size.height - height)	);
}
NSR AZRectTrimmedOnLeft(NSR rect, CGFloat width) {
	return NSMakeRect( 	rect.origin.x + width, 					rect.origin.y,
						rect.size.width - width,  		rect.size.height	);
}
NSR AZRectTrimmedOnTop(NSR rect, CGFloat height) {
	return NSMakeRect(	rect.origin.x, 					rect.origin.y,
						rect.size.width,  				(rect.size.height - height)	);
}
NSR AZRectExceptWide(NSR rect, CGFloat wide) {
	return NSMakeRect(	rect.origin.x, 	rect.origin.y, wide, rect.size.height);
}

NSR AZRectExceptHigh(NSR rect, CGFloat high){
	return NSMakeRect(rect.origin.x, 	rect.origin.y, rect.size.width, high);
}

NSR AZRectExceptOriginX(NSR rect, CGFloat x)
{
	return NSMakeRect ( x, rect.origin.y, rect.size.width, rect.size.height);
}
NSR AZRectExceptOriginY(NSR rect, CGFloat y)
{
	return NSMakeRect(rect.origin.x, y, rect.size.width, rect.size.height);
}

NSR AZInsetRect(NSR rect, CGFloat inset){
	return NSInsetRect(rect, inset,inset);
}

NSR AZLeftEdge(NSR rect, CGFloat width) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y, 
                    width, 
                    rect.size.height);
}

NSR AZRightEdge(NSR rect, CGFloat width) {
  return NSMakeRect(rect.origin.x + rect.size.width - width, 
                    rect.origin.y, 
                    width, 
                    rect.size.height);
}

NSR AZLowerEdge(NSR rect, CGFloat height) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y, 
                    rect.size.width, 
                    height);
}

NSR AZUpperEdge(NSR rect, CGFloat height) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y + rect.size.height - height, 
                    rect.size.width, 
                    height);
}

//
// Comparison Methods
//

BOOL AZIsPointLeftOfRect(NSPoint point, NSR rect) {
  return AZPointDistanceToBorderOfRect(point, rect).x < 0;
}

BOOL AZIsPointRightOfRect(NSPoint point, NSR rect) {
  return AZPointDistanceToBorderOfRect(point, rect).x > 0;
}

BOOL AZIsPointAboveRect(NSPoint point, NSR rect) {
  return AZPointDistanceToBorderOfRect(point, rect).y < 0;
}

BOOL AZIsPointBelowRect(NSPoint point, NSR rect) {
  return AZPointDistanceToBorderOfRect(point, rect).y > 0;
}

BOOL AZIsRectLeftOfRect(NSR rect, NSR compare) {
  return AZNormalizedDistanceOfRects(rect, compare).x <= -1;
}

BOOL AZIsRectRightOfRect(NSR rect, NSR compare) {
  return AZNormalizedDistanceOfRects(rect, compare).x >= 1;
}

BOOL AZIsRectAboveRect(NSR rect, NSR compare) {
  return AZNormalizedDistanceOfRects(rect, compare).y <= -1;
}

BOOL AZIsRectBelowRect(NSR rect, NSR compare) {
  return AZNormalizedDistanceOfRects(rect, compare).y >= 1;
}

//
// EOF
//

#import "math.h"

//BTFloatRange BTMakeFloatRange(float value,float location,float length){
//    BTFloatRange fRange;
//    fRange.value=value;
//    fRange.location=location;
//    fRange.length=length;
//    return fRange;
//}
//float BTFloatRangeMod(BTFloatRange range){
//    return fmod(range.value-range.location,range.length)+range.location;
//}
//
//float BTFloatRangeUnit(BTFloatRange range){
//    return (range.value-range.location)/range.length;
//}

NSPoint offsetPoint(NSPoint fromPoint, NSPoint toPoint){
    return NSMakePoint(toPoint.x-fromPoint.x,toPoint.y-fromPoint.y);
}
/*
int oppositeQuadrant(int quadrant){
    quadrant=quadrant+2;
    quadrant%=4;
    if (!quadrant)quadrant=4;
    return quadrant;
}
*/
NSPoint rectOffset(NSR innerRect,NSR outerRect, QUAD quadrant){
    if (quadrant )
        return NSMakePoint((quadrant == 2 || quadrant == 1) ? NSMaxX(outerRect)-NSMaxX(innerRect) : NSMinX(outerRect)-NSMinX(innerRect),
                           (quadrant == 3 || quadrant == 2) ? NSMaxY(outerRect)-NSMaxY(innerRect) : NSMinY(outerRect)-NSMinY(innerRect));
    return NSMakePoint( NSMidX(outerRect)-NSMidX(innerRect), NSMidY(outerRect)-NSMidY(innerRect) ); //Center Rects
}

int oppositeQuadrant(int quadrant){
    quadrant = quadrant + 2;
    quadrant%=3;
    return !quadrant ? 3 : quadrant;
}

//NSR sectionPositioned(NSR r, AZPOS p){
//
//	NSUInteger quad 	= 	p == AZPositionBottomLeft 	? 0
//						:	p == AZPositionLeft 		? 1
//						:	p == AZPositionTopRight 		? 2
//						:	p == AZPositionBottomRight 	? 3 : 3;
//
//	return quadrant(r, (NSUInteger)quadrant);
//}
NSR quadrant(NSR r, AZQuadrant quad) {
	return alignRectInRect (AZRectFromDim(AZMinEdge(r)/2),r, quad);
}

CGFloat quadrantsVerticalGutter(NSR r)
{
	NSR aQ = quadrant(r, 1);
	return NSWidth(r) - (NSWidth(aQ) *2);
}

CGFloat quadrantsHorizontalGutter(NSR r)
{
	NSR aQ = quadrant(r, 1);
	return NSHeight(r) - (NSHeight(aQ) *2);
}


NSR alignRectInRect(NSR innerRect, NSR outerRect, int quadrant){
    NSPoint offset=rectOffset(innerRect,outerRect,quadrant);
    return NSOffsetRect(innerRect,offset.x,offset.y);
}


NSR rectZoom(NSR rect,float zoom,int quadrant){
    NSSize newSize=NSMakeSize(NSWidth(rect)*zoom,NSHeight(rect)*zoom);
    NSR newRect=rect;
    newRect.size=newSize;
    return newRect;
}
NSR AZSizeRectInRect(NSR innerRect,NSR outerRect,bool expand){
    float proportion=NSWidth(innerRect)/NSHeight(innerRect);
    NSR xRect=NSMakeRect(0,0,outerRect.size.width,outerRect.size.width/proportion);
    NSR yRect=NSMakeRect(0,0,outerRect.size.height*proportion,outerRect.size.height);
    NSR newRect;
    if (expand) newRect = NSUnionRect(xRect,yRect);
    else newRect = NSIntersectionRect(xRect,yRect);
    return newRect;
}

NSR AZFitRectInRect(NSR innerRect,NSR outerRect,bool expand){
    return AZCenterRectInRect(AZSizeRectInRect(innerRect,outerRect,expand),outerRect);
}
/*
NSR rectWithProportion(NSR innerRect,float proportion,bool expand){
    NSR xRect=NSMakeRect(0,0,innerRect.size.width,innerRect.size.width/proportion);
    NSR yRect=NSMakeRect(0,0,innerRect.size.height*proportion,innerRect.size.height);
    NSR newRect;
    if (expand) newRect = NSUnionRect(xRect,yRect);
    else newRect = NSIntersectionRect(xRect,yRect);
    return newRect;
}
*/

NSR AZSquareInRect(NSR rect) {
	return AZCenterRectInRect(AZSquareFromLength(AZMinDim(rect.size)), rect);
}

NSR AZCenterRectInRect(NSR rect, NSR mainRect){
    return NSOffsetRect(rect,NSMidX(mainRect)-NSMidX(rect),NSMidY(mainRect)-NSMidY(rect));
}

NSR AZConstrainRectToRect(NSR innerRect, NSR outerRect){
    NSPoint offset=NSZeroPoint;
    if (NSMaxX(innerRect) > NSMaxX(outerRect))
        offset.x+= NSMaxX(outerRect) - NSMaxX(innerRect);
    if (NSMaxY(innerRect) > NSMaxY(outerRect))
        offset.y+= NSMaxY(outerRect) - NSMaxY(innerRect);
    if (NSMinX(innerRect) < NSMinX(outerRect))
        offset.x+= NSMinX(outerRect) - NSMinX(innerRect);
    if (NSMinY(innerRect) < NSMinY(outerRect))
        offset.y+= NSMinY(outerRect) - NSMinY(innerRect);
    return NSOffsetRect(innerRect,offset.x,offset.y);
}
/*
NSR expelRectFromRect(NSR innerRect, NSR outerRect,float peek){
    NSPoint offset=NSZeroPoint;
    
    float leftDistance=NSMaxX(innerRect) - NSMinX(outerRect);
    float rightDistance=NSMaxX(outerRect)-NSMinX(innerRect);
    float topDistance=NSMaxY(outerRect)-NSMinY(innerRect);
    float bottomDistance=NSMaxY(innerRect) - NSMinY(outerRect);
    float minDistance=MIN(MIN(MIN(leftDistance,rightDistance),topDistance),bottomDistance);
    
    if (minDistance==leftDistance)
        offset.x-=leftDistance-peek;
    else if (minDistance==rightDistance)
        offset.x+=rightDistance-peek;
    else if (minDistance==topDistance)
        offset.y+=topDistance-peek;
    else if (minDistance==bottomDistance)
        offset.y-=bottomDistance-peek;
    
    return NSOffsetRect(innerRect,offset.x,offset.y);
}

NSR expelRectFromRectOnEdge(NSR innerRect, NSR outerRect,NSREdge edge,float peek){
    NSPoint offset=NSZeroPoint;
    
    switch(edge){
        case NSMaxXEdge:
            
            offset.x+=NSMaxX(outerRect)-NSMinX(innerRect)-peek;
            break;
        case NSMinXEdge:
            offset.x-=NSMaxX(innerRect) - NSMinX(outerRect) - peek;
            break;
        case NSMaxYEdge:
            offset.y+=NSMaxY(outerRect)-NSMinY(innerRect)-peek;
            break;
        case NSMinYEdge:
            offset.y-=NSMaxY(innerRect) - NSMinY(outerRect)-peek;
            break;
    }

    return NSOffsetRect(innerRect,offset.x,offset.y);
}
*/
CGRectEdge AZEdgeTouchingEdgeForRectInRect( NSR innerRect, NSR outerRect ){
    
    return 	NSMaxX(innerRect)  >= NSMaxX(outerRect) ? NSMaxXEdge :
			NSMinX(innerRect)  <= NSMinX(outerRect) ? NSMinXEdge :
    		NSMaxY(innerRect)  >= NSMaxY(outerRect) ? NSMaxYEdge :
			NSMinY(innerRect)  <= NSMinY(outerRect) ? NSMinYEdge : -1;
}

NSR AZRectFromSize(NSSize size){
    return NSMakeRect(0,0,size.width,size.height);
}

static float AZDistanceFromOrigin(NSPoint point){
    return hypot(point.x, point.y);
}

NSP AZTopLeft  ( NSR rect ){	 return (NSP){rect.origin.x,rect.origin.y+NSHeight(rect)}; }
NSP AZTopRight ( NSR rect ){ return (NSP){NSWidth(rect)  + rect.origin.x, NSHeight(rect) + rect.origin.y}; }
NSP AZBotLeft  ( NSR rect ){ return rect.origin; }
NSP AZBotRight ( NSR rect ){ return (NSP){rect.origin.x + NSWidth(rect), rect.origin.y}; }

//AZPOS AZClosestCorner(NSR innerRect,NSR outerRect){
//	CGF bl, br, tl, tr;
//	NSP blP, brP, tlP, trP;        float distance = AZDistanceFromOrigin(rectOffset(innerRect,outerRect,i));
//        if (distance < bestDistance || bestDistance<0){
//            bestDistance=distance;
//            closestCorner=i;
//        }
//    }
//    return closestCorner;
//}

 
void logRect(NSR rect){
	LOG_EXPR(rect);
//QSLog(@"(%f,%f) (%fx%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}


AZOrient deltaDirectionOfPoints(NSPoint a, NSPoint b){

	return a.x != b.x ? AZOrientHorizontal : AZOrientVertical;
}

AZPOS AZPositionOfRectInRect(NSR rect, NSR outer ) {

	return NSEqualPoints( rect.origin, outer.origin) 			? AZPositionBottomLeft 	:
		   NSEqualPoints( AZTopLeft(rect), AZTopLeft(outer)) ||
		   (rect.origin.x == outer.origin.x && (rect.origin.y +NSHeight(rect) ) == NSHeight(outer))
		   	? AZPositionTopLeft		:
		   NSEqualPoints( AZTopRight(rect), AZTopRight(outer))	? AZPositionTopRight	:
		   NSEqualPoints( AZBotRight(rect), AZBotRight(outer))	? AZPositionBottomRight :
		  ^{ return AZOutsideEdgeOfRectInRect(rect, outer); }();
}

AZPOS AZOutsideEdgeOfRectInRect (NSR rect, NSR outer ) {
	NSPoint myCenter = AZCenterOfRect(rect);
	CGF test;
	AZPOS winner;
	CGF minDist = AZMaxDim(outer.size);

	test = AZDistanceFromPoint( myCenter, (NSPoint) { outer.origin.x, myCenter.y }); //testleft
	if  ( test < minDist) { 	minDist = test; winner = AZPositionLeft;}

	test = AZDistanceFromPoint( myCenter, (NSPoint) { myCenter.x,  0 }); //testbottom  OK
	if  ( test < minDist) { 	minDist = test; winner = AZPositionBottom; }

	test = AZDistanceFromPoint( myCenter, (NSPoint) {NSWidth(outer), myCenter.y }); //testright
	if  ( test < minDist) { 	minDist = test; winner = AZPositionRight; }

	test = AZDistanceFromPoint( myCenter, (NSPoint) { myCenter.x, NSHeight(outer) }); //testright
	if  ( test < minDist) { 	minDist = test; winner = AZPositionTop; }

	return  winner;
}

NSSize AZDirectionsOffScreenWithPosition(NSR rect, AZPOS position )
{
	CGFloat deltaX = position == AZPositionLeft 	?  -NSMaxX(rect)
	: position == AZPositionRight 	? 	NSMaxX(rect)	: 0;
	CGFloat deltaY = position == AZPositionTop 		?  NSMaxY(rect)
	: position == AZPositionBottom 	? -NSMaxY(rect)		: 0;

	return (NSSize){deltaX,deltaY};
}

