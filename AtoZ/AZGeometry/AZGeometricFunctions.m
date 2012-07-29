//
//  THGeometricFunctions.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AZGeometricFunctions.h"

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
  return [NSNumber numberWithDouble:d];
}

NSRange AZMakeRange(NSUInteger min, NSUInteger max) {
  NSUInteger loc = MIN(min, max);
  NSUInteger len = MAX(min, max) - loc;
  return NSMakeRange(loc, len);
}

//
// 2D Functions
//

CGFloat AZLengthOfPoint(NSPoint pt) {
  return sqrt(pt.x * pt.x + pt.y * pt.y);
  //return ABS(pt.x) + ABS(pt.y);
}

CGFloat AZAreaOfSize(NSSize size) {
  return size.width * size.height;
}

CGFloat AZAreaOfRect(NSRect rect) {
  return AZAreaOfSize(rect.size);
}


NSPoint NSMakeRandomPointInRect(NSRect rect) {
    CGPoint point = CGPointZero;
    NSInteger max = rect.size.width;
    NSInteger min = 0;
    point.x = (random() % (max-min+1)) + min;

    max = rect.size.height;
    point.y = (random() % (max-min+1)) + min;

    return point;
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

NSPoint AZRelativeToAbsolutePoint(NSPoint relative, NSRect bounds) {
  return NSMakePoint(relative.x * bounds.size.width  + bounds.origin.x,
                     relative.y * bounds.size.height + bounds.origin.y
                     );
}

NSPoint AZAbsoluteToRelativePoint(NSPoint absolute, NSRect bounds) {
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

NSPoint AZCenterOfRect(NSRect rect) {
  // simple math, just the center of the rect
  return NSMakePoint(rect.origin.x + rect.size.width  * 0.5, 
                     rect.origin.y + rect.size.height * 0.5);
}

NSPoint AZCenterOfSize(NSSize size) {
  return NSMakePoint(size.width  * 0.5, 
                     size.height * 0.5);
}

NSPoint AZEndOfRect(NSRect rect) {
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
NSPoint AZCenterDistanceOfRects(NSRect a, NSRect b) {
  return AZSubtractPoints(AZCenterOfRect(a),
                          AZCenterOfRect(b));
}

NSPoint AZBorderDistanceOfRects(NSRect a, NSRect b) {
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

NSPoint AZNormalizedDistanceOfRects(NSRect from, NSRect to) {
  NSSize mul = AZInvertSize(AZBlendSizes(from.size, to.size, 0.5));
  NSPoint re = AZCenterDistanceOfRects(to, from);
          re = AZMultiplyPointBySize(re, mul);

  return re;
}

NSPoint AZNormalizedDistanceToCenterOfRect(NSPoint point, NSRect rect) {
  NSPoint center = AZCenterOfRect(rect);
  NSPoint half   = AZMultiplyPoint(AZPointFromSize(rect.size), 0.5);
  NSPoint re     = AZSubtractPoints(point, center);
          re     = AZMultiplyPointByPoint(re, half);
  
  return re;
}

NSPoint AZPointDistanceToBorderOfRect(NSPoint point, NSRect rect) {
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

//
// NSSize functions
//

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
  return NSMakeSize(inner.width / outer.width, 
                    inner.height / outer.height);
}

NSSize AZMultiplySize(NSSize size, CGFloat multiplier) {
  return NSMakeSize(size.width * multiplier, 
                    size.height * multiplier);
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
// NSRect result functions
//


NSRect AZMakeRectMaxXUnderMenuBarY(CGFloat distance) {
	NSRect rect;
	rect.origin = AZOriginFromMenubarWithX(distance,0);
	rect.size = NSMakeSize( [[NSScreen mainScreen]frame].size.width-10, distance);
	return rect;
}



NSRect AZMakeRectFromPoint(NSPoint point) {
  return NSMakeRect(point.x, point.y, 0, 0);
}

NSRect AZMakeRectFromSize(NSSize size) {
  return NSMakeRect(0, 0, size.width, size.height);
}

NSRect AZMakeRect(NSPoint point, NSSize size) {
  return NSMakeRect(point.x, 
                    point.y, 
                    size.width, 
                    size.height);
}

NSRect AZMakeSquare(NSPoint center, CGFloat radius) {
  return NSMakeRect(center.x - radius, 
                    center.y - radius, 
                    2 * radius, 
                    2 * radius);
}


NSRect AZMultiplyRectBySize(NSRect rect, NSSize size) {
  return NSMakeRect(rect.origin.x    * size.width,
                    rect.origin.y    * size.height,
                    rect.size.width  * size.width,
                    rect.size.height * size.height
                    );
}

NSRect AZRelativeToAbsoluteRect(NSRect relative, NSRect bounds) {
  return NSMakeRect(relative.origin.x    * bounds.size.width  + bounds.origin.x,
                    relative.origin.y    * bounds.size.height + bounds.origin.y,
                    relative.size.width  * bounds.size.width,
                    relative.size.height * bounds.size.height
                    );
}

NSRect AZAbsoluteToRelativeRect(NSRect a, NSRect b) {
  return NSMakeRect((a.origin.x - b.origin.x) / b.size.width,
                    (a.origin.y - b.origin.y) / b.size.height,
                    a.size.width  / b.size.width,
                    a.size.height / b.size.height
                    );
}


NSRect AZPositionRectOnRect(NSRect inner, NSRect outer, NSPoint position) {
  return NSMakeRect(outer.origin.x 
                    + (outer.size.width - inner.size.width) * position.x, 
                    outer.origin.y 
                    + (outer.size.height - inner.size.height) * position.y, 
                    inner.size.width, 
                    inner.size.height
                    );
}

NSRect AZCenterRectOnPoint(NSRect rect, NSPoint center) {
  return NSMakeRect(center.x - rect.size.width  / 2, 
                    center.y - rect.size.height / 2, 
                    rect.size.width, 
                    rect.size.height);
}

NSRect AZCenterRectOnRect(NSRect inner, NSRect outer) {
  return AZPositionRectOnRect(inner, outer, AZHalfPoint);
}

NSRect AZSquareAround(NSPoint center, CGFloat distance) {
  return NSMakeRect(center.x - distance, 
                    center.y - distance, 
                    2 * distance, 
                    2 * distance
                    );
}

NSRect AZBlendRects(NSRect from, NSRect to, CGFloat p) {
  NSRect re;

  CGFloat q = 1 - p;
  re.origin.x    = from.origin.x    * q + to.origin.x    * p;
  re.origin.y    = from.origin.y    * q + to.origin.y    * p;
  re.size.width  = from.size.width  * q + to.size.width  * p;
  re.size.height = from.size.height * q + to.size.height * p;

  return re;
}

NSRect AZLeftEdge(NSRect rect, CGFloat width) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y, 
                    width, 
                    rect.size.height);
}

NSRect AZRightEdge(NSRect rect, CGFloat width) {
  return NSMakeRect(rect.origin.x + rect.size.width - width, 
                    rect.origin.y, 
                    width, 
                    rect.size.height);
}

NSRect AZLowerEdge(NSRect rect, CGFloat height) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y, 
                    rect.size.width, 
                    height);
}

NSRect AZUpperEdge(NSRect rect, CGFloat height) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y + rect.size.height - height, 
                    rect.size.width, 
                    height);
}

//
// Comparison Methods
//

BOOL AZIsPointLeftOfRect(NSPoint point, NSRect rect) {
  return AZPointDistanceToBorderOfRect(point, rect).x < 0;
}

BOOL AZIsPointRightOfRect(NSPoint point, NSRect rect) {
  return AZPointDistanceToBorderOfRect(point, rect).x > 0;
}

BOOL AZIsPointAboveRect(NSPoint point, NSRect rect) {
  return AZPointDistanceToBorderOfRect(point, rect).y < 0;
}

BOOL AZIsPointBelowRect(NSPoint point, NSRect rect) {
  return AZPointDistanceToBorderOfRect(point, rect).y > 0;
}

BOOL AZIsRectLeftOfRect(NSRect rect, NSRect compare) {
  return AZNormalizedDistanceOfRects(rect, compare).x <= -1;
}

BOOL AZIsRectRightOfRect(NSRect rect, NSRect compare) {
  return AZNormalizedDistanceOfRects(rect, compare).x >= 1;
}

BOOL AZIsRectAboveRect(NSRect rect, NSRect compare) {
  return AZNormalizedDistanceOfRects(rect, compare).y <= -1;
}

BOOL AZIsRectBelowRect(NSRect rect, NSRect compare) {
  return AZNormalizedDistanceOfRects(rect, compare).y >= 1;
}

//
// EOF
//

#import "math.h"

BTFloatRange BTMakeFloatRange(float value,float location,float length){
    BTFloatRange fRange;
    fRange.value=value;
    fRange.location=location;
    fRange.length=length;
    return fRange;
}
float BTFloatRangeMod(BTFloatRange range){
    return fmod(range.value-range.location,range.length)+range.location;
}

float BTFloatRangeUnit(BTFloatRange range){
    return (range.value-range.location)/range.length;
}

NSPoint offsetPoint(NSPoint fromPoint, NSPoint toPoint){
    return NSMakePoint(toPoint.x-fromPoint.x,toPoint.y-fromPoint.y);
}

int oppositeQuadrant(int quadrant){
    quadrant=quadrant+2;
    quadrant%=4;
    if (!quadrant)quadrant=4;
    return quadrant;
}

NSPoint rectOffset(NSRect innerRect,NSRect outerRect,int quadrant){
    if (quadrant)
        return NSMakePoint((quadrant == 3 || quadrant == 2) ? NSMaxX(outerRect)-NSMaxX(innerRect) : NSMinX(outerRect)-NSMinX(innerRect),
                           (quadrant == 4 || quadrant == 3) ? NSMaxY(outerRect)-NSMaxY(innerRect) : NSMinY(outerRect)-NSMinY(innerRect));
    return NSMakePoint(NSMidX(outerRect)-NSMidX(innerRect),NSMidY(outerRect)-NSMidY(innerRect)); //Center Rects
}

NSRect alignRectInRect(NSRect innerRect,NSRect outerRect,int quadrant){
    NSPoint offset=rectOffset(innerRect,outerRect,quadrant);
    return NSOffsetRect(innerRect,offset.x,offset.y);
}




NSRect rectZoom(NSRect rect,float zoom,int quadrant){
    NSSize newSize=NSMakeSize(NSWidth(rect)*zoom,NSHeight(rect)*zoom);
    NSRect newRect=rect;
    newRect.size=newSize;
    return newRect;
}


NSRect sizeRectInRect(NSRect innerRect,NSRect outerRect,bool expand){
    float proportion=NSWidth(innerRect)/NSHeight(innerRect);
    NSRect xRect=NSMakeRect(0,0,outerRect.size.width,outerRect.size.width/proportion);
    NSRect yRect=NSMakeRect(0,0,outerRect.size.height*proportion,outerRect.size.height);
    NSRect newRect;
    if (expand) newRect = NSUnionRect(xRect,yRect);
    else newRect = NSIntersectionRect(xRect,yRect);
    return newRect;
}

NSRect fitRectInRect(NSRect innerRect,NSRect outerRect,bool expand){
    return centerRectInRect(sizeRectInRect(innerRect,outerRect,expand),outerRect);
}

NSRect rectWithProportion(NSRect innerRect,float proportion,bool expand){
    NSRect xRect=NSMakeRect(0,0,innerRect.size.width,innerRect.size.width/proportion);
    NSRect yRect=NSMakeRect(0,0,innerRect.size.height*proportion,innerRect.size.height);
    NSRect newRect;
    if (expand) newRect = NSUnionRect(xRect,yRect);
    else newRect = NSIntersectionRect(xRect,yRect);
    return newRect;
}

NSRect centerRectInRect(NSRect rect, NSRect mainRect){
    return NSOffsetRect(rect,NSMidX(mainRect)-NSMidX(rect),NSMidY(mainRect)-NSMidY(rect));
}

NSRect constrainRectToRect(NSRect innerRect, NSRect outerRect){
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

NSRect expelRectFromRect(NSRect innerRect, NSRect outerRect,float peek){
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

NSRect expelRectFromRectOnEdge(NSRect innerRect, NSRect outerRect,NSRectEdge edge,float peek){
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
NSRectEdge touchingEdgeForRectInRect(NSRect innerRect, NSRect outerRect){
    
    if (NSMaxX(innerRect)>=NSMaxX(outerRect)) return NSMaxXEdge;
    else if (NSMinX(innerRect)<=NSMinX(outerRect)) return NSMinXEdge;
    else if (NSMaxY(innerRect)>=NSMaxY(outerRect)) return NSMaxYEdge;
    else if (NSMinY(innerRect)<=NSMinY(outerRect)) return NSMinYEdge;
    return -1;
}



NSRect rectFromSize(NSSize size){
    return NSMakeRect(0,0,size.width,size.height);
}

float distanceFromOrigin(NSPoint point){
    return hypot(point.x, point.y);
}
int closestCorner(NSRect innerRect,NSRect outerRect){
    float bestDistance=-1;
    int closestCorner=0;
    int i;
    for(i=0;i<5;i++){
        float distance = distanceFromOrigin(rectOffset(innerRect,outerRect,i));
        if (distance < bestDistance || bestDistance<0){
            bestDistance=distance;
            closestCorner=i;
        }
    }
    return closestCorner;
}





NSRect blendRects(NSRect start, NSRect end,float b){
    
    return NSMakeRect(  round(NSMinX(start)*(1-b) + NSMinX(end)*b),
                        round(NSMinY(start)*(1-b) + NSMinY(end)*b),
                        round(NSWidth(start)*(1-b) + NSWidth(end)*b),
                        round(NSHeight(start)*(1-b) + NSHeight(end)*b));
}

void logRect(NSRect rect){
//QSLog(@"(%f,%f) (%fx%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}


CGPoint randomPointInRect(CGRect rect) {

CGPoint point = CGPointZero;
NSInteger max = rect.size.width;
NSInteger min = 0;
point.x = (random() % (max-min+1)) + min;

max = rect.size.height;
point.y = (random() % (max-min+1)) + min;

return point;
}
