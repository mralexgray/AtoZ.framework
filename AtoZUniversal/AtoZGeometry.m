
//  THGeometricFunctions.m   Lumumba   Created by Benjamin Schüttler on 19.11.09.  Copyright 2011 Rogue Coding. All rights reserved.
//  #import <DrawKit/DrawKit.h> import <Quartz/Quartz.h>/#import <Zangetsu/Zangetsu.h>

#import <AtoZUniversal/AtoZUniversal.h>
#import <AtoZUniversal/AtoZGeometry.h>
#import <AtoZUniversal/Rectlike.h>


//@concreteprotocol( AZScalar ) @dynamic min, max;- (id) valueForUndefinedKey:(NSS*)key {} @end
#define NONSENSERECT (NSRect){NSNotFound, NSNotFound, NSNotFound,NSNotFound}
#define ISNULLRECT(X) NSEqualRects(X,NONSENSERECT)

BOOL _AZAllAreEqualRects(int count, ...) {

    va_list args;
    va_start(args, count);
    NSR a = NONSENSERECT, b = NONSENSERECT;
    BOOL same = YES;
    for( int i = 0; i < count; i++ ) {
      if (!same) continue;

//      if (!same) printf("%s is different than %s at index %i\n\n", NSStringFromRect(a).UTF8String, NSStringFromRect(b).UTF8String,i);

      if (ISNULLRECT(a)) a = va_arg(args, NSRect);
      else b = va_arg(args, NSRect);
      if (!ISNULLRECT(a) && !ISNULLRECT(b)) same = NSEqualRects(a,b);
      a = b;
  }
 va_end(args);
  return same;
}

/*
  printf("comparing %i rects!\n\n", ct);
  NSR a = r1;
  BOOL same = YES;

	va_list rects; va_start(rects, r1);
	
	for (int i = 0; i < ct; i++) {  NSR b = va_arg(rects, NSR);
    if (same) {
      same = NSEqualRects(a,b); if (!same) printf("%s is different than %s at index %i\n\n", NSStringFromRect(a).UTF8String, NSStringFromRect(b).UTF8String,i);
      a = b;
    }
  }
	va_end(rects);
	return same;
}
*/

NSR AZRectOffsetLikePoints(NSR r, NSP p1, NSP p2) { return AZRectOffsetBySize(r,AZSizeFromPoint(AZSubtractPoints(p1,p2))); }    //	frame.origin.x += point2.x - point1.x;	frame.origin.y += point2.y - point1.y; return frame; }

NSR AZRectResizedLikePointsInQuad(NSR frame, NSP point1, NSP point2, AZQuad quadrant) {

	int xMod = (quadrant == (AZQuad)3 || quadrant == (AZQuad)4) ? -1 : 1;
	int yMod = (quadrant == (AZQuad)2 || quadrant == (AZQuad)3) ? -1 : 1;
	
	frame.size.width += xMod * (point2.x - point1.x);
	frame.size.height += yMod * (point2.y - point1.y);
	
	if (xMod < 0) frame.origin.x -= xMod * (point2.x - point1.x);
	if (yMod < 0) frame.origin.y -= yMod * (point2.y - point1.y);
	return frame; 
}

NSR	AZTransformRect (NSR target, NSR model) {	NSR r	= target; return ({   r.origin.x   += model.origin.x;   r.origin.y    += model.origin.y;
                                                                          r.size.width += model.size.width; r.size.height += model.size.height; r; });
}
BOOL   AZIsZeroSize (NSSZ   s)              { return NSEqualSizes(NSZeroSize, s); }
BOOL   AZIsZeroRect (NSR rect)              { return SameRect(rect, NSZeroRect); }
BOOL       SameRect (NSR r1, NSR r2)        { return NSEqualRects(r1,r2); }

NSP AZAnchorPointInRect(CGP anch, NSR rect) { return (NSP){ (rect.size.width  * anch.x) + rect.origin.x,
                                                            (rect.size.height * anch.y) + rect.origin.y}; }

AZAnchorPt AZAnchorPointOfActualRect(NSR rect, AZPOS pos) { return AZMultiplyPointBySize(AZAnchorPtAligned(pos), rect.size);

//	newP.x = rect.size.width *p.x;	newP.y = rect.size.height *p.y;	return newP;
}

const AZAnchorPt         AZAnchorCenter = (CGP) {  .5,  .5 },
                            AZAnchorTop = (CGP) {  .5, 1.  },
                         AZAnchorBottom = (CGP) {  .5, 0.  },
                          AZAnchorRight = (CGP) { 1. ,  .5 },
                           AZAnchorLeft = (CGP) { 0. ,  .5 },
                        AZAnchorTopLeft = (CGP) { 0. , 1.  },
                     AZAnchorBottomLeft = (CGP) { 0. , 0.  },
                       AZAnchorTopRight = (CGP) { 1. , 1.  },
                    AZAnchorBottomRight = (CGP) { 1. , 0.  };

AZPOS AZPositionAtPerimeterInRect(NSR edgeBox, NSR outer)	{	//	CGF max, left, right, top, bttom

	AZOrient vORh = (edgeBox.origin.x == outer.origin.x || (edgeBox.origin.x + edgeBox.size.width) == outer.size.width)
					  ? AZOrientVertical : AZOrientHorizontal;
	AZPOS p;
	if ( vORh == AZOrientHorizontal ) 	p = edgeBox.origin.y == 0 ? AZBtm : AZTop;
	else 										  	p = edgeBox.origin.x == 0 ? AZLft : AZRgt;
	return p;
}
AZAnchorPt AZAnchorPtAligned(AZA pos)	{	AZAnchorPt a = NSZeroPoint;

if (pos == AZBtmLft) return a; else a.y += .5;
if (pos == AZLft)    return a; else a.y += .5;
if (pos == AZTopLft) return a; else a.x += .5;
if (pos == AZTop)    return a; else a.x += .5;
if (pos == AZTopRgt) return a; else a.y -= .5;  
if (pos == AZRgt)    return a; else a.y -= .5;  
if (pos == AZBtmRgt) return a; else a.x -= .5;  
if (pos == AZBtm)    return a; else a.y += .5; return a;  // else center.

//  if (pos == AZTopLft)		? AZAnchorTopLeft     : pos == AZTop ? 	AZAnchorTop     : pos == AZTopRgt ?	AZAnchorTopRight :
//  pos == AZLft      ? AZAnchorLeft                                          : pos == AZRgt		? AZAnchorRight :
//  pos == AZBtmLft   ?	AZAnchorBottomLeft  : pos == AZBtm ? AZAnchorBottom                     : AZAnchorBottomRight;
}
NSR 	AZRandomRectInFrame			(CGR     r) { return AZRandomRectInRect(r); }
NSR 	AZRandomRectInRect			(CGR  rect)	{
	NSR r = AZRectFromDim(RAND_FLOAT_VAL(0, AZMinDim(rect.size)));
	r.origin = AZRandomPointInRect(AZRectBy(rect.size.width-r.size.width,rect.size.height-r.size.height));
	return r;
}
CGP 	AZRandomPointInRect			(CGR  rect)	{
	CGP point = CGPointZero;
	NSI max = rect.size.width;
	NSI min = 0;
	point.x = (random() % (max-min+1)) + min;
	max = rect.size.height;
	point.y = (random() % (max-min+1)) + min;
	return point;
}
NSN	*iNum	(NSI    i) { return [NSN numberWithInt:			  i];	}
NSN	*uNum	(NSUI  ui) { return [NSN	numberWithUnsignedInt:ui];	}
NSN	*fNum	(CGF 	  f) { return [NSN	numberWithFloat:		  f];	}
NSN	*dNum	(double d) {
	return @(d);
}

NSR  AZRectCheckWithMinSize(NSR r, NSSZ z){ return AZRectExceptSize(r,(NSSZ){MAX(z.width,r.size.width),MAX(z.height, r.size.height)}); }
//	NSRange AZMakeRange(NSUI min, NSUI max) {  NSUI loc = MIN(min, max);  NSUI len = MAX(min, max) - loc;  return NSMakeRange(loc, len);	}
NSR 	nanRectCheck	(NSR   rect) {
	rect.origin = nanPointCheck(rect.origin);
	rect.size 	= nanSizeCheck(rect.size);
	return rect;
}
NSSZ 	nanSizeCheck	(NSSZ  size) {
	size.width  = isinf(size.width)  ? 0 : size.width;
	size.height = isinf(size.height) ? 0 : size.height;
	return  size;
}
NSP 	nanPointCheck	(NSP origin) {
	origin.x = isinf(origin.x) ? 0 : origin.x;
	origin.y = isinf(origin.y) ? 0 : origin.y;
	return origin;
}

NSP	AZPointOffsetBy	(NSP p, CGF x, CGF y)	{ p.x += x; p.y += y; return p; }

//	id nanCheck(NSValue* point) {	id behind;	if ( [point respondsToSelector:@selector(recttValue)] ) behind = (__bridge_transfer NSR)nanRectCheck( [point rectValue]);	:   [point respondsToSelector:@selector(sizeValue)]  ? nanSizeCheck(  [point pointValue])	:   nanPointCheck( [point pointValue]);/}
NSP	AZPointOffset  		(NSP p, NSP     size)	{
	p.x += size.x;
	p.y += size.y;
	return p;
}
NSP 	AZPointOffsetY 		(NSP p, CGF distance)	{
	p.y += distance;
	return p;
}
NSP 	AZPointOffsetX 		(NSP p, CGF distance)	{
	p.x += distance;
	return p;
}
CGF 	AZAspectRatioForSize (NSSZ  		    size)	{
	return	size.height == size.width	? 1.0 :
	size.width / size.height;
}
CGF 	AZAspectRatioOf		(CGF w, CGF h		  )	{	return AZAspectRatioForSize(NSMakeSize(w, h));
}
NSI 	AZLowestCommonDenominator (int a,   int b)	{
	int i;
	for(i = 2; (a % i != 0) || (b%i != 0); ++i)
	{
	if( i > a || i > b)//a and b are prime
		return 1;
	}
	return i;
}
BOOL 	isWhole					(CGF fl) 					{
	return fmod(fl, 1.0) == 0.0 ? YES : NO;
}
int 	GCD							    (int a, int b)	{
	while (a != 0 && b != 0)	 if (a > b) a %= b; else  b %= a;
	return a == 0 ? b : a;
}
// Using Konrad's code:	var gcd = GCD(A, B);	return string.Format("{0}:{1}", A / gcd, B / gcd)
NSS* 	AZAspectRatioString(CGF ratio)	{
	CGF __unused a, b; int newRatio, m; m =10;
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
//CGSZ AZAspectRatio(NSR rect ){ CGF aspectRatio = ( rect.width / rect.height );	}

AZPOS                            AZPositionOpposite (AZPOS position)                      {
	switch (position) {
	case AZBtm:		return AZTop;			break;
	case AZTop:			return AZBtm;		break;
	case AZLft:			return AZRgt;			break;
	case AZRgt:		return AZLft;			break;
	case AZPositionBottomLeft:	return AZPositionTopRight;		break;
	case AZPositionTopLeft:		return AZPositionBottomRight;	break;
	case AZPositionBottomRight:	return AZPositionTopLeft;		break;
	case AZPositionTopRight:	return AZPositionBottomLeft;	break;
	default:					return 99;						break;
	}
}
AZPOS AZPositionOfRectAtOffsetInsidePerimeterOfRect (NSR  inner, CGF offset, NSR outer) 	{
		NSSZ outsz = outer.size; AZPOS anchor;
	anchor =
	outsz.width == offset 								? AZPositionBottomRight :
	offset == 0 || offset == AZPerimeter(outer) 	? AZPositionBottomLeft	:
	outsz.width + outsz.height == offset				? AZPositionTopRight				   :
	offset == AZPerimeter(outer) - outsz.height  ? AZPositionTopLeft	 :
	outsz.width > offset //? offset < inner.size.width 
							//? AZPositionBottomLeft 
							//: offset > outsz.width - inner.size.width 
							//? AZPositionBottomRight 
							? AZBtm 
							:
	outsz.width + outsz.height > offset //? offset < outsz.width + inner.size.height 
												//? AZPositionBottomRight 
												//: offset > AZPerimeter(outer)/2 - inner.size.height 
												//? AZPositionTopRight 
												? AZRgt
												:
	AZPerimeter(outer) - outsz.height > offset //? AZPerimeter(outer)/2 + inner.size.width > offset 
													  //? AZPositionTopRight 
													  //: AZPerimeter(outer) - outsz.height - inner.size.width > offset 
													  //? AZPositionTopLeft
													  ? AZTop
													  :
	AZPerimeter(outer) - inner.size.height > offset //? AZPositionBottomLeft
																//: AZPerimeter(outer) - outsz.height + inner.size.height > offset 
																//? AZPositionTopLeft
																? AZLft : AZPositionAutomatic;
	return anchor;
}
AZPOS  AZPositionOfEdgeAtOffsetAlongPerimeterOfRect (CGF offset, NSR r)                   {
	NSSZ rsz = r.size; AZPOS anchor;
		if 		  ( rsz.width > offset ) 					anchor = AZBtm;
	else if ( rsz.width + rsz.height > offset ) 		anchor = AZRgt;
	else if ( AZPerimeter(r) - rsz.height > offset ) anchor = AZTop;
	else 											anchor = AZLft;
	return anchor;
}
CGP           	AZPointAtOffsetAlongPerimeterOfRect	(CGF offset, NSR r)                   {
	NSSZ sz = r.size; 
	NSP anchor;
	CGF __unused offsetOnSide;
	if 		  ( sz.width > offset )						anchor = (NSP) { offset,	  0};   // along bottom;
	else if ( sz.width + sz.height > offset ) 		anchor = (NSP) { sz.width, 	offset - sz.width}; // along right
	else if ( AZPerimeter(r) - sz.height > offset ) anchor = (NSP) { ABS( sz.width - (offset - sz.width - sz.height)),  sz.height};
	else 											anchor = (NSP) { 0,				   AZPerimeter(r) - offset};
	return anchor;
}
CGP    AZPointAtOffsetAlongPerimeterWithRoundRadius	(CGF offset, NSR r, CGF radius)       {  return NSZeroPoint; }

/**
	CGF totes = AZPermineterWithRoundRadius( r, radius);
	CGF totalNoRad = AZPerimeter(r);
	CGF Di	ameter = totalNoRad = tot
	NSSZ sz = r.size; 
	NSP anchor; 
	CGF offsetOnSide;
	if 		  ( sz.width > offset )						anchor = (NSP) { offset,	  0};   // along bottom;
else if ( sz.width + sz.height > offset ) 		anchor = (NSP) { sz.width, 	offset - sz.width}; // along right
else if ( AZPerimeter(r) - sz.height > offset ) anchor = (NSP) { ABS( sz.width - (offset - sz.width - sz.height)),  sz.height};
else 											anchor = (NSP) { 0,				   AZPerimeter(r) - offset};
return anchor;
	CG totes = AZPerimeter (r);  //  for example 60 ... 10 x 20 box
	CGF cross = offset / totes;  //  offset of 10.   .16;
	CGF xRat  = r.size.width / (totes/2);
	CGF yRat  = ( 1 - (2*xRat)) / 2;;
	CGF bott  = cross < ;
	CGF right = cross < r.size.width + r.size.height / totes;
	CGF top   = intersect < totes - r.size.height;
*/

CGF 	AZPerimeter 					(NSR rect)				 	{	return (2. * rect.size.width) + (2. * rect.size.height); }
CGF 	AZPerimeterWithRoundRadius (NSR rect, CGF radius)	{
	return  ( AZPerimeter(rect) - ( ( 8 - (   (2 * M_PI/*was pi */) * radius)   )));
}
NSR 	AZScreenFrameUnderMenu	(void)	{ return AZRectTrimmedOnTop( AZScreenFrame() , AZMenuBarThickness()); }
NSR 	AZScreenFrame 				(void)	{		  return [[NSScreen.mainScreen valueForKey:@"frame" orKey:@"bounds"] rV]; }
NSSZ 	AZScreenSize  				(void) 	{		  return AZScreenFrame().size; }
// 2D Functions
CGF AZMinDim			(NSSZ   sz)			{	return MIN(sz.width, sz.height); }
CGF AZMaxDim			(NSSZ   sz)		 	{	return MAX(sz.width, sz.height); }
CGF AZMaxEdge			(NSR     r)			{ 	return AZMaxDim(r.size); }
CGF AZMinEdge			(NSR     r)			{	return AZMinDim(r.size); }

CGF AZLengthOfPoint	(NSP    pt)			{
	return sqrt(pt.x * pt.x + pt.y * pt.y);
	//return ABS(pt.x) + ABS(pt.y);
}
CGF AZAreaOfSize		(NSSZ size)			{
	return size.width * size.height;
}
CGF AZAreaOfRect		(NSR  rect)			{
	return AZAreaOfSize(rect.size);
}
CGF AZPointDistance	(CGP p1, CGP p2) 	{
	return sqrtf(powf(p1.x - p2.x, 2.) + powf(p1.y - p2.y, 2.));
}
CGF AZPointAngle		(CGP p1, CGP p2) 	{
	return atan2f(p1.x - p2.x, p1.y - p2.y);
}
CGF AZDistanceFromPoint (NSP p1,NSP p2){
	CGF temp;
	temp = pow(p1.x - p2.x, 2);
	temp += pow(p1.y - p2.y, 2);
	return (CGF)sqrt(temp);
}
// NSP result functions
CGF AZMenuBarH (void) {
#if MAC_ONLY
  return  [[(NSApplication*)NSApp mainMenu] menuBarHeight];
#else 
  return UIApplication.sharedApplication.statusBarFrame.size.height;
#endif
}
NSP  AZOriginFromMenubarWithX (CGF yOffset, CGF xOffset) 	{
	NSP topLeft = NSMakePoint(0,[[NSScreen.mainScreen valueForKey:@"frame" orKey:@"bounds"] rV].size.height);
	topLeft.x += xOffset;
	topLeft.y -= yOffset;
	topLeft.y -= 22;
	return topLeft;
}
NSP           AZPointFromSize	(NSSZ size) {
	return NSMakePoint(size.width, size.height);
}
NSP                AZAbsPoint	(NSP point) {
	return NSMakePoint(ABS(point.x), ABS(point.y));
}
NSP              AZFloorPoint (NSP point) {
	return NSMakePoint(floor(point.x), floor(point.y));
}
NSP               AZCeilPoint (NSP point) {
	return NSMakePoint(ceil(point.x), ceil(point.y));
}
NSP              AZRoundPoint (NSP point) {
	return NSMakePoint(round(point.x), round(point.y));
}
NSP             AZNegatePoint (NSP point) {
	return NSMakePoint(-point.x, -point.y);
}
NSP             AZInvertPoint (NSP point) {
	return NSMakePoint(1 / point.x, 1 / point.y);
}
NSP               AZSwapPoint (NSP point) {
	return NSMakePoint(point.y, point.x);
}
NSP               AZAddPoints (NSP one, 	 NSP another   ) 	{
	return NSMakePoint(one.x + another.x, one.y + another.y);
}
NSP          AZSubtractPoints	(NSP origin, NSP subtrahend)	{
	return NSMakePoint(origin.x - subtrahend.x, origin.y - subtrahend.y);
}
NSP               AZSumPoints	(NSUI count, NSP point, ...)	{
	NSP re = point;
	
	va_list pts;
	va_start(pts, point);
	
	for (int i = 0; i < count; i++) {
	NSP pt = va_arg(pts, NSP);
	re.x += pt.x;
	re.y += pt.y;
	}
	
	va_end(pts);
	
	return re;
}
NSP           AZMultiplyPoint (NSP point,  CGF multiplier)	{
	return NSMakePoint(point.x * multiplier, point.y * multiplier);
}
NSP    AZMultiplyPointByPoint	(NSP one, 	 NSP another   )	{
	return NSMakePoint(one.x * another.x, one.y * another.y);
}
NSP     AZMultiplyPointBySize	(NSP one, 	 NSSZ size	   )	{
	return NSMakePoint(one.x * size.width, one.y * size.height);
}
NSP AZRelativeToAbsolutePoint	(NSP relative, NSR bounds  ) 	{
	return NSMakePoint(relative.x * bounds.size.width  + bounds.origin.x,
				 relative.y * bounds.size.height + bounds.origin.y
				 );
}
NSP AZAbsoluteToRelativePoint	(NSP absolute, NSR bounds  ) 	{
	return NSMakePoint((absolute.x - bounds.origin.x) / bounds.size.width, 
				 (absolute.y - bounds.origin.y) / bounds.size.height
				 );
}
NSP          AZDividePoint (NSP point,  CGF divisor   ) 	{
	return NSMakePoint(point.x / divisor, point.y / divisor);
}
NSP AZDividePointByPoint		(NSP point,  NSP divisor   ) 	{
	return NSMakePoint(point.x / divisor.x, point.y / divisor.y);
}
NSP AZDividePointBySize			(NSP point,  NSSZ divisor  )	{
	return NSMakePoint(point.x / divisor.width, point.y / divisor.height);
}
NSP AZMovePoint (NSP origin, NSP target, CGF p	  ) {
	// delta = distance fom target to origin
	NSP delta = AZSubtractPoints(target, origin);
	// multiply that with the relative distance
	NSP way   = AZMultiplyPoint(delta, p);
	// add it to the origin to move along the way
	return AZAddPoints(origin, way);
}
NSP AZMovePointAbs				(NSP origin, NSP target, CGF pixels) {
	// Distance from target to origin
	NSP delta = AZSubtractPoints(target, origin);
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
	CGF ratio = delta.y / delta.x;
	CGF x = pixels / sqrt(1.0 + ratio * ratio);
	if (delta.x < 0) x *= -1;
	NSP move = NSMakePoint(x, x * ratio);
	return AZAddPoints(origin, move);
}
NSP AZCenterOfRect				(NSR  rect) {
	// simple math, just the center of the rect
	return NSMakePoint(rect.origin.x + rect.size.width  * 0.5, 
				 rect.origin.y + rect.size.height * 0.5);
}

NSP AZCenterOfSize				(NSSZ size) {	return (NSP){ size.width / 2., size.height / 2.}; }

NSP AZEndOfRect					(NSR  rect) {
	return NSMakePoint(rect.origin.x + rect.size.width,
				 rect.origin.y + rect.size.height);
}
/*!  +-------+
     |	     |
     |   a   |   +-------+
     |	     |   |	     |
     +-------+   |   b   |
    		         |	     |
 		  	         +-------+    
*/
NSP 	AZCenterDistanceOfRects					(NSR a, NSR b) 			{
	return AZSubtractPoints(AZCenterOfRect(a),
					  AZCenterOfRect(b));
}
NSP 	AZBorderDistanceOfRects					(NSR a, NSR b) 			{
	// 
	// +------------ left
	// |
	// |	 +------ right  
	// v	 v
	// +-----+ <---- top
	// |	 |
	// +-----+ <---- bottom
		
	// distances, always from ones part to anothers counterpart
	// a zero x or y indicated that the rects overlap in that dimension
	NSP re = NSZeroPoint;
	
	NSP oa = a.origin;
	NSP ea = AZEndOfRect(a);
	
	NSP ob = b.origin;
	NSP eb = AZEndOfRect(b);
	
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
NSP 	AZNormalizedDistanceOfRects			(NSR from, NSR to) 		{
	NSSZ mul = AZInvertSize(AZBlendSizes(from.size, to.size, 0.5));
	NSP re = AZCenterDistanceOfRects(to, from);
	  re = AZMultiplyPointBySize(re, mul);
	return re;
}
NSP	AZNormalizedDistanceToCenterOfRect	(NSP point, NSR rect)	{
	NSP center = AZCenterOfRect(rect);
	NSP half   = AZMultiplyPoint(AZPointFromSize(rect.size), 0.5);
	NSP re	 = AZSubtractPoints(point, center);
	  re	 = AZMultiplyPointByPoint(re, half);
	
	return re;
}
NSP AZPointClosestOnRect ( NSP point, NSR rect) {

  AZA __unused c = AZClosestCorner(rect, point);
//  AZA dir = AZ, <#AZAlign position#>
  return NSZeroPoint;

}

NSP 	AZPointDistanceToBorderOfRect			(NSP point, NSR rect)	{
	NSP re = NSZeroPoint;
	
	NSP o = rect.origin;
	NSP e = AZEndOfRect(rect);
	
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
NSP 	AZPointFromDim (CGF val) { return _Cord_ {val,val}; }

NSP AZPt(CGF x, CGF y) { return _Cord_ {x,y}; }

#pragma mark - NSSZ Functions

NSP AZRectApex(NSR r) {

#if TARGET_OS_IPHONE
return _Cord_ { r.origin.x + r.size.width, r.origin.y + r.size.height};
#else
return _Cord_ {  NSMaxX(r),NSMaxY(r)};
#endif
}
NSR 	AZRectBy						(CGF boundX, CGF boundY)	{
	return NSMakeRect(0,0,boundX, boundY);
}
NSR	AZRectFromDim				(CGF   dim) {	return CGRectMake(0,0,dim,dim); }

NSSZ	AZSizeFromDim (CGF   dim) {
	return NSMakeSize(dim, dim);
}
NSSZ 	AZSizeFromPoint			(NSP point) {
	return NSMakeSize(point.x, point.y);
}
NSSZ 	AZSizeFromRect				(NSR rect) {	return NSMakeSize(rect.size.width, rect.size.height);	}
NSSZ 	AZAbsSize					(NSSZ size) {
	return NSMakeSize(ABS(size.width), ABS(size.height));
}
NSSZ 	AZAddSizes					(NSSZ one,  NSSZ    another) 		{
	return NSMakeSize(one.width + another.width, 
				one.height + another.height);
}
NSSZ 	AZSubtractSizes 			(NSSZ size, NSSZ subtrahend)		{
	return NSMakeSize( size.width - subtrahend.width,
				   size.height - subtrahend.height);
}
NSSZ 	AZInvertSize				(NSSZ size) 							{
	return NSMakeSize(1 / size.width, 1 / size.height);
}
NSSZ 	AZRatioOfSizes				(NSSZ inner, NSSZ     outer)		{
	return NSMakeSize (inner.width / outer.width,
				inner.height / outer.height);
}
NSSZ 	AZMultiplySize				(NSSZ size,  CGF multiplier)		{
	return (NSSZ) { size.width * multiplier, size.height * multiplier };
}
NSSZ 	AZMultiplySizeBySize		(NSSZ size,  NSSZ   another) 		{
	return NSMakeSize(size.width * another.width, 
				size.height * another.height);
}
NSSZ 	AZMultiplySizeByPoint	(NSSZ size,  NSP      point) 		{
	return NSMakeSize(size.width * point.x, 
				size.height * point.y);
}
NSSZ 	AZBlendSizes				(NSSZ one, NSSZ another, CGF p) 	{
	NSSZ way;
	way.width  = another.width - one.width;
	way.height = another.height - one.height;
	
	return NSMakeSize(one.width + p * way.width, 
				one.height + p * way.height);
}
NSSZ	AZSizeMax					(NSSZ one, NSSZ another) 			{
	return NSMakeSize(MAX(one.width, another.width),
				MAX(one.height, another.height));
}
NSSZ 	AZSizeMin					(NSSZ one, NSSZ another) 			{
	return NSMakeSize(MIN(one.width, another.width),
				MIN(one.height, another.height));
	
}
NSSZ 	AZSizeBound					(NSSZ preferred, NSSZ minSize, NSSZ maxSize) {
	NSSZ re = preferred;
	
	re.width  = MIN(MAX(re.width,  minSize.width),  maxSize.width);
	re.height = MIN(MAX(re.height, minSize.height), maxSize.height);
	
	return re;
}
#pragma mark - NSRect Functions
NSR	AZRectOffsetFromDim		(CGR r, CGF xyDistance) { return AZRectOffsetBy(r, xyDistance, xyDistance); }
NSR	AZRectOffsetBy				(CGR r, CGF x, CGF y) 	{ return AZRectExceptOriginX(AZRectExceptOriginY(r, r.origin.y + y), r.origin.x + x); }
NSR	AZRectOffsetBySize		(CGR r, CGSZ sz) 				{ return AZRectOffsetBy(r, sz.width, sz.height); }
NSR	AZRectResizedBySize		(CGR r, CGSZ sz) 				{

  NSR newR = AZRectExceptHigh(r,    r.size.height + sz.height);
      newR = AZRectExceptWide(newR, r.size.width  + sz.width); return newR;
}

NSR	AZRectOffsetByPt			(CGR rect, NSP pt) 					{ return AZRectOffsetBy(rect, pt.x, pt.y); }
NSR	AZRectVerticallyOffsetBy(CGR rect, CGF offset)				{
	rect.origin.y += offset;
	return  rect;
}
NSR	AZRectHorizontallyOffsetBy(CGR rect, CGF offset) 			{
	rect.origin.x += offset;
	return  rect;
}
NSR	AZFlipRectinRect			(CGR local, CGR dest)				{
	NSP a = NSZeroPoint;
	a.x = dest.size.width - local.size.width;
	a.y = dest.size.height - local.size.height;
	return AZMakeRect(a,local.size);
}
NSR	AZSquareFromLength		(CGF length) 							{
	return  AZMakeRectFromSize(NSMakeSize(length,length));
}
NSR	AZZeroHeightBelowMenu	(void) 									{
	NSR e = AZScreenFrame();
	e.origin.y += (e.size.height - 22);
	e.size.height = 0;
	return e;
}
NSR	AZMenuBarFrame				(void) 									{
	return AZUpperEdge( AZScreenFrame(), AZMenuBarThickness());
}
CGF 	AZMenuBarThickness 		(void) 									{
#if MAC_ONLY
  return [[NSStatusBar systemStatusBar] thickness];
#else
  return UIApplication.sharedApplication.statusBarFrame.size.height;
#endif
}
NSR	AZMenulessScreenRect		(void) 									{
	NSR e = AZScreenFrame();
	e.size.height -= 22;
	return e;
}
#if MAC_ONLY
CGF 	AZHeightUnderMenu 		(void) 									{
	return ( [[NSScreen mainScreen]frame].size.height - [[NSStatusBar systemStatusBar] thickness] );
}
#endif
NSR	AZMakeRectMaxXUnderMenuBarY(CGF distance)	 					{
	NSR rect = [[NSScreen.mainScreen valueForKey:@"frame" orKey:@"bounds"] rV];
	rect.origin = NSMakePoint(0,rect.size.height - 22 - distance);
	rect.size.height = distance;
	return rect;
}
NSR	AZMakeRectFromPoint		(NSP point) 							{
	return NSMakeRect(point.x, point.y, 0, 0);
}
NSR	AZMakeRectFromSize		(NSSZ size) 							{
	return NSMakeRect(0, 0, size.width, size.height);
}
NSR	AZMakeRect (NSP point,	NSSZ size)		 		{
	return  nanRectCheck( NSMakeRect(point.x,	point.y, size.width, size.height));
}
NSR	AZMakeSquare				(NSP center,CGF radius) 			{
	return NSMakeRect(center.x - radius, 
				center.y - radius, 
				2 * radius, 
				2 * radius);
}
NSR	AZMultiplyRectBySize		(NSR rect, 	NSSZ size) 				{
	return NSMakeRect(rect.origin.x	* size.width,
				rect.origin.y	* size.height,
				rect.size.width  * size.width,
				rect.size.height * size.height
				);
}
NSR	AZRelativeToAbsoluteRect(NSR relative, NSR bounds) 		{
	return NSMakeRect(relative.origin.x	* bounds.size.width  + bounds.origin.x,
				relative.origin.y	* bounds.size.height + bounds.origin.y,
				relative.size.width  * bounds.size.width,
				relative.size.height * bounds.size.height
				);
}
NSR	AZAbsoluteToRelativeRect(NSR a,		NSR b) 					{
	return NSMakeRect((a.origin.x - b.origin.x) / b.size.width,
				(a.origin.y - b.origin.y) / b.size.height,
				a.size.width  / b.size.width,
				a.size.height / b.size.height
				);
}
#if MAC_ONLY
enum CAAutoresizingMask AZPositionToAutoresizingMask (AZA p) {
  return  p == AZPositionTopLeft      ? kCALayerMaxXMargin|kCALayerMinYMargin :
          p == AZPositionTopRight     ? kCALayerMinXMargin | kCALayerMinYMargin :
          p == AZPositionBottomRight  ? kCALayerMinXMargin | kCALayerMaxYMargin : kCALayerMaxXMargin | kCALayerMaxYMargin;
}
#endif
NSR	AZPositionRectOnRect		(NSR inner, NSR outer, NSP position) {

	return NSMakeRect(outer.origin.x + (outer.size.width - inner.size.width) * position.x, 
				outer.origin.y 
				+ (outer.size.height - inner.size.height) * position.y, 
				inner.size.width, 
				inner.size.height
				);
}

NSR AZRectWithDimsCenteredOnPoints(CGF width, CGF height, CGF cx, CGF cy){ return (NSR){cx - (width/2), cy - (height/2), width, height}; }
NSR	AZCenterRectOnPoint		(NSR rect, 	NSP center)			 	{

	NSR r = (NSR){ center.x - (rect.size.width  / 2.), center.y - (rect.size.height / 2.), rect.size}; return r;
}
NSR	AZCenterRectOnRect		(NSR inner, NSR outer)				{
	return AZPositionRectOnRect(inner, outer, AZHalfPoint);
}
NSR	AZSquareAround				(NSP center,CGF distance)			{
	return NSMakeRect(center.x - distance, 
				center.y - distance, 
				2 * distance, 
				2 * distance
				);
}
NSR	AZBlendRects				(NSR from, NSR to, CGF p)			{
	NSR re;
	CGF q = 1 - p;
	re.origin.x	= from.origin.x	* q + to.origin.x	* p;
	re.origin.y	= from.origin.y	* q + to.origin.y	* p;
	re.size.width  = from.size.width  * q + to.size.width  * p;
	re.size.height = from.size.height * q + to.size.height * p;
	return re;
}
NSR	AZRectTrimmedOnRight		(NSR rect, CGF width) 				{
	return NSMakeRect(	rect.origin.x, 					rect.origin.y,
				  	rect.size.width - width,  		rect.size.height	);
}
NSR	AZRectTrimmedOnBottom	(NSR rect, CGF height) 				{
	return NSMakeRect(	rect.origin.x,    rect.origin.y + height,
                      rect.size.width,  rect.size.height - height);
}
NSR	AZRectTrimmedOnLeft		(NSR rect, CGF width)	 			{
	return NSMakeRect( 	rect.origin.x + width, 					rect.origin.y,
					rect.size.width - width,  		rect.size.height	);
}
NSR	AZRectTrimmedOnTop		(NSR rect, CGF height) 				{
	return NSMakeRect(	rect.origin.x, 					rect.origin.y,
					rect.size.width,  				(rect.size.height - height)	);
}
NSSZ  AZSizeExceptWide  		(NSSZ sz, CGF wide ) 				{	return NSMakeSize(wide, sz.height); }
NSSZ  AZSizeExceptHigh  		(NSSZ sz, CGF high ) 				{  return NSMakeSize(sz.width, high);  }
NSR 	AZRectExceptSize			(NSRect r, NSSZ z) { r.size.width = z.width;  r.size.height = z.height; return r; }
NSR	AZRectExtendedOnLeft		(NSR rect, CGF amount) 	{
	NSR newRect = rect;
	rect.origin.x -= amount;
	rect.size.width += amount;
	return newRect;
}
NSR	AZRectExtendedOnBottom	(NSR rect, CGF amount) 	{
	NSR newRect = rect;
	rect.origin.y -= amount;
	rect.size.height += amount;
	return newRect;
}
NSR	AZRectExtendedOnTop		(NSR rect, CGF amount) 	{
	NSR newRect = rect;
	rect.size.height += amount;
	return newRect;
}
NSR	AZRectExtendedOnRight	(NSR rect, CGF amount) 	{
	NSR newRect = rect;
	rect.size.width += amount;
	return newRect;
}
NSR	AZRectExceptWide		(NSR r, CGF wide)  { return (NSR){r.origin.x, r.origin.y,         wide, r.size.height}; }
NSR	AZRectExceptHigh    (NSR r, CGF high)  { return (NSR){r.origin.x, r.origin.y, r.size.width,          high}; }
NSR	AZRectExceptOriginX (NSR r, CGF x)     { return (NSR){         x, r.origin.y, r.size.width, r.size.height}; }
NSR	AZRectExceptOriginY	(NSR r, CGF y)     { return (NSR){r.origin.x,          y, r.size.width, r.size.height}; }
NSR	AZRectExceptOrigin	(NSR r, NSP p)     { return (NSR){       p.x,        p.y, r.size.width, r.size.height}; }
NSR	AZInsetRect         (NSR r, CGF inset) { return CGRectInset(r, inset, inset); }
NSR	AZRightEdge         (NSR r, CGF inset) { return (NSR){r.origin.x + r.size.width - inset, r.origin.y,                         inset,        r.size.height}; }
NSR	AZUpperEdge					(NSR r, CGF inset) { return (NSR){r.origin.x,                        r.origin.y + r.size.height - inset, r.size.width, inset};         }
NSR	AZLowerEdge         (NSR r, CGF inset) { return (NSR){r.origin.x, r.origin.y, r.size.width,         inset}; }
NSR	AZLeftEdge          (NSR r, CGF inset) { return (NSR){r.origin.x, r.origin.y,        inset, r.size.height}; }

NSR	AZRectFlippedOnEdge		(NSR r, AZPOS position) {
	return  position == AZTop 		? 	AZRectExceptOriginY(r, r.size.height)
	:		position == AZRgt		?	AZRectExceptOriginX(r, r.size.width )
	:		position == AZBtm	?	AZRectExceptOriginY(r, -r.size.height)
	:											AZRectExceptOriginX(r, -r.size.width );
}
NSR	AZRectOutsideRectOnEdge	(NSR center, NSR outer, AZPOS position) 	{
	return  position == AZTop 		? 	AZRectExceptOriginY(outer, center.size.height)
	:		position == AZRgt		?	AZRectExceptOriginX(outer, center.size.width )
	:		position == AZBtm	?	AZRectExceptOriginY(outer, -outer.size.height)
	:											AZRectExceptOriginX(outer, -outer.size.width );
}
NSR	AZRectInsideRectOnEdge	(NSR inner, NSR outer, AZPOS p)	{ NSR newR =

    p == AZTop    ? (NSR){ inner.origin.x, outer.size.height - inner.size.height, inner.size}
  :	p == AZRgt    ?	(NSR){ outer.size.width - inner.size.width, inner.origin.y, inner.size}
  :	p == AZBtm    ?	(NSR){ inner.origin.x, outer.origin.y, inner.size}
/*  :	p == AZLft    ? */:	(NSR){ outer.origin.x, inner.origin.y, inner.size};
//  :	p == AZBtmLft ?	AZRectExceptOrigin(inner,outer.origin)
//  : p == AZTopLft ?	AZRectExceptOrigin(inner,(NSP){ outer.origin.x,outer.origin.y + outer.size.height - inner.size.height})
//  :	p == AZTopRgt ?	AZRectExceptOrigin(inner,(NSP){ outer.size.width - inner.size.width, outer.origin.y + outer.size.height - inner.size.height})
//    /*AZBtmRgt */ : AZRectExceptOrigin(inner,outer.origin);
  if (p == AZLft) newR.origin.x = MAX(newR.origin.x, outer.origin.x);
  if (p == AZTop) newR.origin.y = MIN(newR.origin.y, outer.size.height - inner.size.height);
  if (p == AZBtm) newR.origin.y = MAX(newR.origin.y, outer.origin.y);
  if (p == AZRgt) newR.origin.x = MIN(newR.origin.x, outer.size.width - inner.size.width);
  return newR;



//    p == AZTop    ? (NSR){ outer.size.width/2.- (inner.size.width/2.), outer.size.height - inner.size.height, inner.size}
//  :	p == AZRgt    ?	(NSR){ outer.size.width - inner.size.width, (outer.size.height/2.) - (inner.size.height/2.), inner.size}
//  :	p == AZBtm    ?	(NSR){ outer.size.width/2.- (inner.size.width/2.), outer.origin.y, inner.size}
//  :	p == AZLft    ?	(NSR){ outer.origin.x, (outer.size.height/2.) - (inner.size.height/2.), inner.size}
//  :	p == AZBtmLft ?	AZRectExceptOrigin(inner,outer.origin)
//  : p == AZTopLft ?	AZRectExceptOrigin(inner,(NSP){ outer.origin.x,outer.origin.y + outer.size.height - inner.size.height})
//  :	p == AZTopRgt ?	AZRectExceptOrigin(inner,(NSP){ outer.size.width - inner.size.width, outer.origin.y + outer.size.height - inner.size.height})
//    /*AZBtmRgt */ : AZRectExceptOrigin(inner,outer.origin);
}

BOOL  AZPointIsInInsetRects	(NSP point,  NSR outside,NSSZ inset ) 		{

  NSCAssert(inset.width < (outside.size.width/2) && inset.height < (outside.size.height/2), @"inset too big!, rect is only %@",NSStringFromCGRect(outside));
	AZInsetRects e =  AZMakeInsideRects(outside, inset);
	return  NSPInRect(point, e.top) 	?:
		      NSPInRect(point, e.right) 	?:
		      NSPInRect(point, e.bottom) 	?:
		      NSPInRect(point, e.left) 	?:	NO;
}
//FOUNDATION_EXPORT 
//AZPOS AZPositionOnOutsideEdgeOfRect(NSP point, NSR rect, NSSZ size) {
AZPOS AZPosOfPointInInsetRects ( NSP point, NSR outside, NSSZ inset ) 	{

	AZInsetRects e =  AZMakeInsideRects(outside, inset);
	return  NSPInRect(point, e.top) 	? AZTop	 	:
		NSPInRect(point, e.right) 	? AZRgt  	:
		NSPInRect(point, e.bottom) 	? AZBtm 	:
		NSPInRect(point, e.left) 	? AZLft 	:	AZPositionAutomatic;
}
NSR	AZInsetRectInPosition ( NSR outside, NSSZ inset, AZPOS pos ) 		{

  inset = (NSSZ){ MIN(inset.width, outside.size.width/2), MIN(inset.height, outside.size.height/2)};
//  NSCAssert(inset.width < (outside.size.width/2) && inset.height < (outside.size.height/2), @"inset too big!, rect is only %@",AZString(outside));

  if (pos == AZPositionOutside) return NSZeroRect;
  if (pos == AZPositionCenter)  return CGRectInset(outside, inset.width, inset.height);
	BOOL scaleX = pos ==  AZBtm || pos == AZTop ? NO: YES;
	CGR  scaled = scaleX ? AZRectExceptWide(outside, inset.width)
                       : AZRectExceptHigh(outside, inset.height);
	scaled.origin.y += pos == AZTop   ? outside.size.height - inset.height : 0;
	scaled.origin.x += pos == AZRgt ? outside.size.width  - inset.width : 0;
	return scaled;
}
//AZOutsideEdges AZOutsideEdgesSized(NSR rect, NSSZ size) {		return (AZOutsideEdges) { AZUpperEdge(rect, size.height),
//								  AZRightEdge(rect, size.width ), AZLowerEdge(rect, size.height), AZLeftEdge (rect, size.width ) 	}; }

// Comparison Methods
BOOL AZIsPointLeftOfRect	(NSP point, NSR rect)	{
	return AZPointDistanceToBorderOfRect(point, rect).x < 0;
}
BOOL AZIsPointRightOfRect	(NSP point, NSR rect) 	{
	return AZPointDistanceToBorderOfRect(point, rect).x > 0;
}
BOOL AZIsPointAboveRect		(NSP point, NSR rect)	{
	return AZPointDistanceToBorderOfRect(point, rect).y < 0;
}
BOOL AZIsPointBelowRect		(NSP point, NSR rect)	{
	return AZPointDistanceToBorderOfRect(point, rect).y > 0;
}
BOOL AZIsRectLeftOfRect		(NSR rect, NSR compare) {
	return AZNormalizedDistanceOfRects(rect, compare).x <= -1;
}
BOOL AZIsRectRightOfRect	(NSR rect, NSR compare) {
	return AZNormalizedDistanceOfRects(rect, compare).x >= 1;
}
BOOL AZIsRectAboveRect		(NSR rect, NSR compare) {
	return AZNormalizedDistanceOfRects(rect, compare).y <= -1;
}
BOOL AZIsRectBelowRect		(NSR rect, NSR compare) {
	return AZNormalizedDistanceOfRects(rect, compare).y >= 1;
}
#import "math.h"
//BTFloatRange BTMakeFloatRange(float value,float location,float length){	BTFloatRange fRange;	fRange.value=value;	fRange.location=location;	fRange.length=length;	return fRange;	}	float BTFloatRangeMod(BTFloatRange range){	return fmod(range.value-range.location,range.length)+range.location;	}
//float BTFloatRangeUnit(BTFloatRange range){	return (range.value-range.location)/range.length;	}
NSP AZOffsetPoint(NSP fromPoint, NSP toPoint){
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
NSR	AZRectOffset(NSR rect, NSP offset)			{
	rect.origin.x += offset.x;
	rect.origin.y += offset.y;
	return rect;
}
#if MAC_ONLY
NSP 	AZOffsetOfRects(NSR innerRect,NSR outerRect){ //, QUAD quadrant){
//	if (quadrant )
//		return NSMakePoint((quadrant == 2 || quadrant == 1) ? NSMaxX(outerRect)-NSMaxX(innerRect) : NSMinX(outerRect)-NSMinX(innerRect),
//						   (quadrant == 3 || quadrant == 2) ? NSMaxY(outerRect)-NSMaxY(innerRect) : NSMinY(outerRect)-NSMinY(innerRect));
	return NSMakePoint( NSMidX(outerRect)-NSMidX(innerRect), NSMidY(outerRect)-NSMidY(innerRect) ); //Center Rects
}
#endif
int 	oppositeQuadrant(int quadrant){
	quadrant = quadrant + 2;
	quadrant%=3;
	return !quadrant ? 3 : quadrant;
}
/*
NSR sectionPositioned(NSR r, AZPOS p){	NSUI quad 	= 	p == AZPositionBottomLeft 	? 0
																	:	p == AZLft 		? 1
																	:	p == AZPositionTopRight 		? 2
																	:	p == AZPositionBottomRight 	? 3 : 3;
return quadrant(r, (NSUInteger)quadrant);
}
*/
NSR	AZRectOfQuadInRect(NSR originalRect, AZQuad quad) { return quadrant(originalRect, quad); }
NSR 	quadrant(NSR r, AZQuad quad)	{
	NSSZ half = AZMultiplySize(r.size, .5);
	NSR newR  = AZRectBy(half.width, half.height);
	NSP p 	  = quad == AZQuadTopLeft  ? (NSP) { 0, 			 half.height }
		  : quad == AZQuadTopRight ? (NSP) { half.width, half.height }
		  : quad == AZQuadBotRight ? (NSP) { half.width,		   0 }
		  :	NSZeroPoint;
		 
	return AZRectOffset(newR, p);
}
CGF 	quadrantsVerticalGutter(NSR r)	{
	NSR aQ = quadrant(r, 1);
	return r.size.width - (aQ.size.width *2);
}
CGF 	quadrantsHorizontalGutter(NSR r)	{
	NSR aQ = quadrant(r, 1);
	return r.size.height - (aQ.size.height *2);
}
//NSR alignRectInRect(NSR innerRect, NSR outerRect, int quadrant)
//{
////	NSP offset= AZRectOffset(innerRect,outerRect,quadrant);
//	return NSOffsetRect(innerRect,offset.x,offset.y);
//}
NSR rectZoom(NSR rect,float zoom,int quadrant){
	NSSZ newSize=NSMakeSize(NSWidth(rect)*zoom,NSHeight(rect)*zoom);
	NSR newRect=rect;
	newRect.size=newSize;
	return newRect;
}
NSR	AZSizeRectInRect(NSR innerRect,NSR outerRect,bool expand){
	float proportion=NSWidth(innerRect)/NSHeight(innerRect);
	NSR xRect=NSMakeRect(0,0,outerRect.size.width,outerRect.size.width/proportion);
	NSR yRect=NSMakeRect(0,0,outerRect.size.height*proportion,outerRect.size.height);
	NSR newRect;
	if (expand) newRect = CGRectUnion(xRect,yRect);
	else newRect = CGRectIntersection(xRect,yRect);
	return newRect;
}
NSR	AZFitRectInRect(NSR innerRect,NSR outerRect,bool expand){
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
NSR	AZSquareInRect(NSR rect) {
	return AZCenterRectInRect(AZSquareFromLength(AZMinDim(rect.size)), rect);
}
NSR	AZCenterRectInRect(NSR rect, NSR mainRect){
	return CGRectOffset(rect,
  NSMidX(mainRect)-NSMidX(rect),NSMidY(mainRect)-NSMidY(rect));
}
NSR	AZConstrainRectToRect(NSR innerRect, NSR outerRect){
	NSP offset=NSZeroPoint;
	if (NSMaxX(innerRect) > NSMaxX(outerRect))
	offset.x+= NSMaxX(outerRect) - NSMaxX(innerRect);
	if (NSMaxY(innerRect) > NSMaxY(outerRect))
	offset.y+= NSMaxY(outerRect) - NSMaxY(innerRect);
	if (NSMinX(innerRect) < NSMinX(outerRect))
	offset.x+= NSMinX(outerRect) - NSMinX(innerRect);
	if (NSMinY(innerRect) < NSMinY(outerRect))
	offset.y+= NSMinY(outerRect) - NSMinY(innerRect);
	return CGRectOffset(innerRect,offset.x,offset.y);
}
/*
NSR expelRectFromRect(NSR innerRect, NSR outerRect,float peek){
	NSP offset=NSZeroPoint;
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
	NSP offset=NSZeroPoint;
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
AZPOS AZPosAtCGRectEdge ( CGRectEdge edge ){
	return edge == CGRectMinXEdge ? AZLft 
			:edge == CGRectMinYEdge ? AZBtm
			:edge == CGRectMaxXEdge ? AZRgt
			:								  AZTop;
}
CGRectEdge CGRectEdgeAtPosition ( AZPOS pos ){
	return pos == AZLft 		? CGRectMinXEdge
			:pos == AZBtm 	? CGRectMinYEdge
			:pos == AZRgt 	? CGRectMaxXEdge
			:								 	  CGRectMaxYEdge;
}
CGRectEdge AZEdgeTouchingEdgeForRectInRect( NSR innerRect, NSR outerRect ){
		return 	NSMaxX(innerRect)  >= NSMaxX(outerRect) ? NSMaxXEdge :
		NSMinX(innerRect)  <= NSMinX(outerRect) ? NSMinXEdge :
		NSMaxY(innerRect)  >= NSMaxY(outerRect) ? NSMaxYEdge :
		NSMinY(innerRect)  <= NSMinY(outerRect) ? NSMinYEdge : -1;
}
NSR	AZRectFromSizeOfRect(NSR aRect){ return (NSR){0,0,aRect.size.width,aRect.size.height}; }

NSR	AZRectFromSize(NSSZ size){
	return NSMakeRect(0,0,size.width,size.height);
}

NSR AZCornerRectPositionedWithSize(NSR outerRect, AZPOS pos, NSSZ sz) {

	return pos == AZPositionTopLeft ? (NSR){outerRect.origin.x, outerRect.size.height - sz.height, sz.width, sz.height} 
	:		 pos == AZPositionTopRight ? (NSR){ outerRect.size.width - sz.width, outerRect.size.height - sz.height, sz.width, sz.height}
	:		 pos == AZPositionBottomRight ? (NSR){ outerRect.size.width - sz.width,outerRect.origin.y, sz.width, sz.height}
	:												(NSR) {outerRect.origin.x,outerRect.origin.y, sz.width, sz.height };
}

static float AZDistanceFromOrigin(NSP point){
	return hypot(point.x, point.y);
}
NSP AZTopLeftPoint  ( NSR rect ){	 return (NSP){rect.origin.x,rect.origin.y+NSHeight(rect)}; }
NSP AZTopRightPoint( NSR rect ){ return (NSP){NSWidth(rect)  + rect.origin.x, NSHeight(rect) + rect.origin.y}; }
NSP AZBotLeftPoint  ( NSR rect ){ return rect.origin; }
NSP AZBotRightPoint ( NSR rect ){ return (NSP){rect.origin.x + NSWidth(rect), rect.origin.y}; }
AZPOS AZClosestCorner (NSR r,NSP pt) { if (NSEqualPoints(pt, AZCenterOfRect(r))) return (AZAmbiguous|AZAlignCenter);

  AZA corner = AZUnset;
  float distance = HUGE_VALF, test;
  if ((test = AZDistanceBetweenPoints(pt, (NSP){NSMinX(r),NSMaxY(r)})) < distance) { corner = AZTopLft; distance = test; }
  if ((test = AZDistanceBetweenPoints(pt, (NSP){NSMaxX(r),NSMaxY(r)})) < distance) { corner = AZTopRgt; distance = test; }
  if ((test = AZDistanceBetweenPoints(pt, (NSP){NSMaxX(r),NSMinY(r)})) < distance) { corner = AZBtmRgt; distance = test; }
  if ((test = AZDistanceBetweenPoints(pt, (NSP){NSMinX(r),NSMinY(r)})) < distance) { corner = AZBtmLft; distance = test; }
  if (pt.x == NSMidX(r) || pt.y == NSMidY(r)) corner |= AZAmbiguous;
  return corner;
  
//		if (distance < bestDistance || bestDistance<0){
//			bestDistance=distance;
//			closestCorner=i;
//		}
//	}
//	return closestCorner;
}
//void logRect(NSR rect){
//	LOG_EXPR(rect);
////QSLog(@"(%f,%f) (%fx%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
//}
AZOrient deltaDirectionOfPoints(NSP a, NSP b){
	return a.x != b.x ? AZOrientHorizontal : AZOrientVertical;
}
AZPOS AZPositionOfQuadInRect(NSR rect, NSR outer ) {
	return NSEqualPoints( rect.origin, outer.origin) 			? AZPositionBottomLeft 	:
	   	 NSEqualPoints( AZTopLeftPoint(rect), AZTopLeftPoint(outer)) ||
						  (rect.origin.x == outer.origin.x && (rect.origin.y +NSHeight(rect) ) == NSHeight(outer))
	   	? AZPositionTopLeft		:
	   NSEqualPoints( AZTopRightPoint(rect), AZTopRightPoint(outer))	? AZPositionTopRight	:
	   NSEqualPoints( AZBotRightPoint(rect), AZBotRightPoint(outer))	? AZPositionBottomRight :
	  ^{ return AZOutsideEdgeOfRectInRect(rect, outer); }();
}
AZPOS AZPositionOfRectPinnedToOutisdeOfRect(NSR box, NSR innerBox  )	{
	NSR tIn  = AZRectFromSize(innerBox.size);
	box.origin.y -= innerBox.origin.y;
	box.origin.x -= innerBox.origin.x;
	NSLog(@"Testing attached: %@.. inner: %@", AZStringFromRect(box), AZStringFromRect(tIn));
	AZPOS winner; NSSZ bS, iS; bS = box.size; iS = tIn.size;
	winner = box.origin.x == -bS.width		? AZRgt
	   : box.origin.y == iS.height	  	? AZBtm
	   : box.origin.x == iS.width		? AZLft
	   : box.origin.y == 0	  		? AZTop : 97;
	return winner;// AZTop : winner;
}
AZA AZAlignNext(AZA a) {

  return (AZA)({  a == AZBtm    ? AZTopLft : a == AZTopLft ? AZBtmLft : a == AZBtmLft ? AZTopRgt : 
                  a == AZTopRgt ? AZBtmRgt : a == AZBtmRgt ? AZCntr   : a & (AZUnset|AZTop|AZRgt|AZLft) ? a << 1 : AZUnset; });   //  a == AZCntr             ? AZOutside :  a == AZOutside          ? AZAAuto   :  a&AZAUnset|AZAAuto      ? AZLft       // Unset/Auto goes to back to 1AZAlignUnset); // return r;
}  

// + bS.width == innerBox.origin.x	 	? AZLft
//		   : box.origin.y  == innerBox.origin.y + iS.height	  	? AZBtm
//		   : box.origin.x  == innerBox.origin.y + iS.width		? AZRgt
//		   : box.origin.y + bS.height == innerBox.origin.y		? AZTop : 97;
//	  , outer.origin) 			? AZPositionBottomLeft 	:
//	NSEqualPoints( AZTopLeft(rect), AZTopLeft(outer)) ||
//	(rect.origin.x == outer.origin.x && (rect.origin.y +NSHeight(rect) ) == NSHeight(outer))
//	? AZPositionTopLeft		:
//	NSEqualPoints( AZTopRightPoint(rect), AZTopRightPoint(outer))	? AZPositionTopRight	:
//	NSEqualPoints( AZBotRightPoint(rect), AZBotRightPoint(outer))	? AZPositionBottomRight :
//	^{ return AZOutsideEdgeOfRectInRect(rect, outer); }();

AZA AZAlignmentInsideRect(NSR edgeBox, NSR outerBox) {

	AZRect *edge = $AZR(edgeBox), *outer = $AZR(outerBox);
	AZA e = 0;
	e |= 	edge.maxY == outer.maxY ? AZAlignTop 	: 	edge.y == outer.y ? AZAlignBottom	:
			edge.x == outer.x ? AZAlignLeft	:	edge.maxX == outer.maxX ? AZAlignRight 	: e;
	if (e != 0) return e;
	NSP myCenter = edge.centerPt;
	CGF test = HUGE_VALF;
	CGF minDist = AZMaxDim(outer.size);
	test = AZDistanceFromPoint( myCenter, (NSP) { outer.x, myCenter.y }); //testleft
	if  ( test < minDist) { 	minDist = test; e = AZAlignLeft;}
	test = AZDistanceFromPoint( myCenter, (NSP) { myCenter.x,  0 }); //testbottom  OK
	if  ( test < minDist) { 	minDist = test; e = AZAlignBottom; }
	test = AZDistanceFromPoint( myCenter, (NSP) {outer.width, myCenter.y }); //testright
	if  ( test < minDist) { 	minDist = test; e = AZAlignRight; }
	test = AZDistanceFromPoint( myCenter, (NSP) { myCenter.x, outer.height }); //testright
	if  ( test < minDist) { 	minDist = test; e = AZAlignTop; }
	return  e;
}
//	if (NSEqualPoints(edge.origin, outer.origin))   e |= AZAlignBottomLeft;
//	if (NSEqualPoints(edge.apex, 	 outer.apex)) 	 	e |= AZAlignTopRight;
//	edge = edgeBox.origin.x == outer.origin.x ? edge | AZAlignLeft 	: edge;
//	edge = edgeBox.origin.y == outer.origin.y ? edge | AZAlignRight 	: edge;
//	edge = edgeBox.origin.x == outer.origin.x ? edge | AZAlignLeft 	: edge;
// edge = edgeBox.origin.x == outer.origin.x ? edge | AZAlignLeft 	: edge;
//	NSP myCenter = edge.center;// AZCenterOfRect(rect);
//	CGF test;
////	AZPOS winner = AZPositionAutomatic;
//	CGF minDist = AZMaxDim(outer.size);
//	winner 	= NSEqualPoints(.origin, outer.origin) ? AZPositionBottomLeft
//	: NSEqualPoints(AZTopLeftPoint(rect), AZTopLeftPoint(outer)) ? AZPositionTopLeft
//	: NSEqualPoints(AZTopRightPoint(rect), AZTopRightPoint(outer)) ? AZPositionTopRight
//	: NSEqualPoints(AZBotRightPoint(rect), AZBotRightPoint(outer)) ? AZPositionBottomRight : AZPositionAutomatic;
//	if (winner != AZPositionAutomatic) goto finishline;
//	test = AZDistanceFromPoint( myCenter, (NSP) { outer.origin.x, myCenter.y }); //testleft
//	if  ( test < minDist) { 	minDist = test; winner = AZLft;}
//	test = AZDistanceFromPoint( myCenter, (NSP) { myCenter.x,  0 }); //testbottom  OK
//	if  ( test < minDist) { 	minDist = test; winner = AZBtm; }
//	test = AZDistanceFromPoint( myCenter, (NSP) {NSWidth(outer), myCenter.y }); //testright
//	if  ( test < minDist) { 	minDist = test; winner = AZRgt; }
//	test = AZDistanceFromPoint( myCenter, (NSP) { myCenter.x, NSHeight(outer) }); //testright
//	if  ( test < minDist) { 	minDist = test; winner = AZTop; }
//finishline:
//	return  winner;

AZPOS AZOutsideEdgeOfPointInRect (NSP inside, NSR outer ) {   	NSN* u, *d, *l, *r, *mini;

		   u = @(outer.size.height - inside.y);		r	= @(outer.size.width - inside.x);
	      d = @(inside.y - outer.origin.y);			l 	= @(inside.x - outer.origin.x);
		mini = [@[u, r, d, l]minNumberInArray];
	AZPOS c =	mini == u ? AZTop 		: mini == r ?  AZRgt 
				: 	mini == d ? AZBtm 	: 					AZLft;
	return c;
}

NSR AZRectInsideRectOnEdgeInset (NSR rect, AZA side, CGF inset ) {

return side == AZRgt ? AZRectTrimmedOnLeft(rect, rect.size.width-inset) :
       side == AZLft ? AZRectTrimmedOnRight(rect, rect.size.width-inset) :
       side == AZTop ? AZRectTrimmedOnBottom(rect, rect.size.height-inset) :
                        AZRectTrimmedOnTop(rect, rect.size.height-inset);

//AZPOS	win 	= NSEqualPoints(rect.origin, 				  			 outer.origin) ? AZBtmLft
//				: NSEqualPoints(AZTopLeftPoint (rect),  AZTopLeftPoint(outer)) ? AZTopLft
//				: NSEqualPoints(AZTopRightPoint(rect), AZTopRightPoint(outer)) ? AZTopRgt
//			 	: NSEqualPoints(AZBotRightPoint(rect), AZBotRightPoint(outer)) ? AZBtmRgt
//																									: AZPositionAutomatic;
//	if (win != AZPositionAutomatic) goto finishline;
//	t = NSMinX (rect) - NSMinX(outer); if (min > t) { win =   AZLft; min = t; }
//	t = NSMaxY(outer) - NSMaxY (rect); if (min > t) { win =    AZTop; min = t; }
//	t = NSMaxX(outer) - NSMaxX (rect); if (min > t) { win =  AZRgt; min = t; }
//	t = NSMinY (rect) - NSMinY(outer); if (min > t) { win = AZBtm; min = t; }
//	finishline:	return win;
}

AZPOS AZOutsideEdgeOfRectInRect (NSR rect, NSR outer ) {   			 CGF min = HUGE_VALF, t = HUGE_VALF;
			
AZPOS	win 	= NSEqualPoints(rect.origin, 				  			 outer.origin) ? AZBtmLft
				: NSEqualPoints(AZTopLeftPoint (rect),  AZTopLeftPoint(outer)) ? AZTopLft
				: NSEqualPoints(AZTopRightPoint(rect), AZTopRightPoint(outer)) ? AZTopRgt
			 	: NSEqualPoints(AZBotRightPoint(rect), AZBotRightPoint(outer)) ? AZBtmRgt
																									: AZPositionAutomatic;
	if (win != AZPositionAutomatic) goto finishline;
	t = NSMinX (rect) - NSMinX(outer); if (min > t) { win =   AZLft; min = t; }
	t = NSMaxY(outer) - NSMaxY (rect); if (min > t) { win =    AZTop; min = t; }
	t = NSMaxX(outer) - NSMaxX (rect); if (min > t) { win =  AZRgt; min = t; }
	t = NSMinY (rect) - NSMinY(outer); if (min > t) { win = AZBtm; min = t; }
	finishline:	return win;
}
//	test = minDist > test = NSMinX(rect) - NSMinX(outer)) ? 
//	NSP myCenter 	= AZCenterOfRect(rect);	
//	if  ( < minDist) { 	minDist = test; winner = AZLft;}
//	test = AZDistanceFromPoint( myCenter, (NSP){ outer.origin.x, myCenter.y }); //testleft
//	if  ( test < minDist) { 	minDist = test; winner = AZLft;}
//	test = AZDistanceFromPoint( myCenter, (NSP){ myCenter.x,  0 }); //testbottom  OK
//	if  ( test < minDist) { 	minDist = test; winner = AZBtm; }
//	test = AZDistanceFromPoint( myCenter, (NSP){NSWidth(outer), myCenter.y }); //testright
//	if  ( test < minDist) { 	minDist = test; winner = AZRgt; }
//	test = AZDistanceFromPoint( myCenter, (NSP){ myCenter.x, NSHeight(outer) }); //testright
//	if  ( test < minDist) { 	minDist = test; winner = AZTop; }
//finishline:
//	return  winner;
//}
NSSZ AZDirectionsOffScreenWithPosition(NSR rect, AZPOS position )	{
	CGF deltaX = position == AZLft 	?  -NSMaxX(rect)
	: position == AZRgt 	? 	NSMaxX(rect)	: 0;
	CGF deltaY = position == AZTop 		?  NSMaxY(rect)
	: position == AZBtm 	? -NSMaxY(rect)		: 0;
	return (NSSZ){deltaX,deltaY};
}
// this point constant is arbitrary but it is intended to be very unlikely to arise by chance. It can be used to signal "not found" when
// returning a point value from a function.
const NSP		NSNotFoundPoint = {-10000000.2,-999999.6};
/// function:		NSRectFromTwoPoints( a, b )
/// description:	forms a rectangle from any two corner points
/// parameters:		<a, b> a pair of points
/// result:			the rectangle formed by a and b at the opposite corners
/// notes:			the rect is normalised, in that the relative positions of a and b do not affect the result - the rect always extends in the positive x and y directions.
NSR NSRectFromTwoPoints( const NSP a, const NSP b)	{
	NSR  r;
		r.size.width = ABS( b.x - a.x );
	r.size.height = ABS( b.y - a.y );
		r.origin.x = MIN( a.x, b.x );
	r.origin.y = MIN( a.y, b.y );
	return r;
}
/// function:		NSRectCentredOnPoint( p, size )
/// description:	forms a rectangle of the given size centred on p
/// parameters:		<p> a point
///					<size> the rect size
/// result:			the rectangle
/// notes:			
NSR				NSRectCentredOnPoint( const NSP p, const NSSZ size )	{
	NSR r;
		r.size = size;
	r.origin.x = p.x - (size.width * 0.5f);
	r.origin.y = p.y - (size.height * 0.5f);
	return r;
}
/// function:		UnionOfTwoRects( a, b )
/// description:	returns the smallest rect that encloses both a and b
/// parameters:		<a, b> a pair of rects
/// result:			the rectangle that encloses a and b
/// notes:			unlike NSUnionRect, this is practical when either or both of the input rects have a zero
///					width or height. For convenience, if either a or b is EXACTLY NSZeroRect, the other rect is
///					returned, but in all other cases it correctly forms the union. While NSUnionRect might be
///					considered mathematically correct, since a rect of zero width or height cannot "contain" anything
///					in the set sense, what's more practically required for real geometry is to allow infinitely thin
///					lines and points to push out the "envelope" of the rectangular space they define. That's what this does.
NSR				AZUnionOfTwoRects( const NSR a, const NSR b )	{
	if ( NSEqualRects( a, NSZeroRect ))
	return b;
	else if ( NSEqualRects( b, NSZeroRect ))
	return a;
	else
	{
	NSP tl, br;
	
	tl.x = MIN( NSMinX( a ), NSMinX( b ));
	tl.y = MIN( NSMinY( a ), NSMinY( b ));
	br.x = MAX( NSMaxX( a ), NSMaxX( b ));
	br.y = MAX( NSMaxY( a ), NSMaxY( b ));
	
	return NSRectFromTwoPoints( tl, br );
	}
}
/// function:		UnionOfRectsInSet( aSet )
/// description:	returns the smallest rect that encloses all rects in the set
/// parameters:		<aSet> a set of NSValues containing rect values
/// result:			the rectangle that encloses all rects
/// notes:			
NSR				AZUnionOfRectsInSet( const NSSet* aSet )	{
	NSEnumerator*	iter = [aSet objectEnumerator];
	NSValue*		val;
	NSR			ur = NSZeroRect;
		while(( val = [iter nextObject]))
	ur = AZUnionOfTwoRects( ur, [val rV]);
		return ur;
}
/// function:		DifferenceOfTwoRects( a, b )
/// description:	returns the area that is different between two input rects, as a list of rects
/// parameters:		<a, b> a pair of rects
/// result:			an array of rect NSValues
/// notes:			this can be used to optimize upates. If a and b are "before and after" rects of a visual change,
///					the resulting list is the area to update assuming that nothing changed in the common area,
///					which is frequently so. If a and b are equal, the result is empty. If a and b do not intersect,
///					the result contains a and b.
NSSet*			AZDifferenceOfTwoRects( const NSR a, const NSR b )	{
	NSMutableSet* result = [NSMutableSet set];
		// if a == b, there is no difference, so return the empty set
		if( ! NSEqualRects( a, b ))
	{
	NSR ir = CGRectIntersection( a, b );
	
	if( NSEqualRects( ir, NSZeroRect ))
	{
		// no intersection, so result is the two input rects
		
		[result addObject:AZVrect(a)];
		[result addObject:AZVrect(b)];
	}
	else
	{
		// a and b do intersect, so collect all the pieces by subtracting <ir> from each
		
		[result unionSet:AZSubtractTwoRects( a, ir )];
		[result unionSet:AZSubtractTwoRects( b, ir )];
	}
	}
	return result;
}
NSSet*				AZSubtractTwoRects( const NSR a, const NSR b )	{
	// subtracts <b> from <a>, returning the pieces left over. If a and b don't intersect the result is correct
	// but unnecessary, so the caller should test for intersection first.
	NSMutableSet* result = [NSMutableSet set];
		CGF rml, lmr, upb, lwt, mny, mxy;
		rml = MAX( NSMaxX( b ), NSMinX( a ));
	lmr = MIN( NSMinX( b ), NSMaxX( a ));
	upb = MAX( NSMaxY( b ), NSMinY( a ));
	lwt = MIN( NSMinY( b ), NSMaxY( a ));
	mny = MIN( NSMaxY( a ), NSMaxY( b ));
	mxy = MAX( NSMinY( a ), NSMinY( b ));
		NSR		rr, rl, rt, rb;
		rr = NSMakeRect( rml, mxy, NSMaxX( a ) - rml, mny - mxy );
	rl = NSMakeRect( NSMinX( a ), mxy, lmr - NSMinX( a ), mny - mxy );
	rt = NSMakeRect( NSMinX( a ), upb, NSWidth( a ), NSMaxY( a ) - upb );
	rb = NSMakeRect( NSMinX( a ), NSMinY( a ), NSWidth( a ), lwt - NSMinY( a ));
		// add any non empty rects to the result
		if ( rr.size.width > 0 && rr.size.height > 0 )
	[result addObject:AZVrect(rr)];
	
	if ( rl.size.width > 0 && rl.size.height > 0 )
	[result addObject:AZVrect(rl)];
	
	if ( rt.size.width > 0 && rt.size.height > 0 )
	[result addObject:AZVrect(rt)];
	
	if ( rb.size.width > 0 && rb.size.height > 0 )
	[result addObject:AZVrect(rb)];
	return result;
}
BOOL	AZAreSimilarRects( const NSR a, const NSR b, const CGF epsilon )	{
	// return YES if the rects a and b are within <epsilon> of each other.
		if ( ABS( a.origin.x - b.origin.x ) > epsilon )
	return NO;
	
	if( ABS( a.origin.y - b.origin.y ) > epsilon )
	return NO;
	
	if( ABS( a.size.width - b.size.width ) > epsilon )
	return NO;
	
	if( ABS( a.size.height - b.size.height ) > epsilon )
	return NO;
		return YES;
}
/// return the distance that <inPoint> is from a line defined by two points a and b
CGF		AZPointFromLine( const NSP inPoint, const NSP a, const NSP b )	{
	NSP cp = AZNearestPointOnLine( inPoint, a, b );
		return hypotf(( inPoint.x - cp.x ), ( inPoint.y - cp.y ));
}
/// return the distance of <inPoint> from a line segment drawn from a to b.
NSP		AZNearestPointOnLine( const NSP inPoint, const NSP a, const NSP b )	{
	CGF mag = hypotf(( b.x - a.x ), ( b.y - a.y ));
		if( mag > 0.0 )
	{
	CGF u = ((( inPoint.x - a.x ) * ( b.x - a.x )) + (( inPoint.y - a.y ) * ( b.y - a.y ))) / ( mag * mag );
	
	if( u <= 0.0 )
		return a;
	else if ( u >= 1.0 )
		return b;
	else
	{
		NSP cp;
	
		cp.x = a.x + u * ( b.x - a.x );
		cp.y = a.y + u * ( b.y - a.y );
	
		return cp;
	}
	}
	else
	return a;
}
NSI AZPointInLineSegment( const NSP inPoint, const NSP a, const NSP b )	{
	// returns 0 if <inPoint> falls within the region defined by the line segment a-b, -1 if it's beyond the point a, 1 if beyond b. The "region" is an
	// infinite plane defined by all possible lines parallel to a-b.
		CGF mag = hypotf(( b.x - a.x ), ( b.y - a.y ));
		if( mag > 0.0 )
	{
	CGF u = ((( inPoint.x - a.x ) * ( b.x - a.x )) + (( inPoint.y - a.y ) * ( b.y - a.y ))) / ( mag * mag );
	return ( u >= 0 && u <= 1.0 )? 0 : ( u < 0 )? -1 : 1;
	}
	else
	return -1;
}
/// given a point on a line a,b, returns the relative distance of the point from 0..1 along the line.
CGF		AZRelPoint( const NSP inPoint, const NSP a, const NSP b )	{
	CGF d1, d2;
		d1 = AZLineLength( a, inPoint );
	d2 = AZLineLength( a, b );
		if( d2 != 0.0 )
	return d1/d2;
	else
	return 0.0;
}
/// return a point halfway along a line defined by two points
NSP		AZBisectLine( const NSP a, const NSP b )	{
	NSP p;
		p.x = ( a.x + b.x ) * 0.5f;
	p.y = ( a.y + b.y ) * 0.5f;
	return p;
}
/// return a point at some proportion of a line defined by two points. <proportion> goes from 0 to 1.
NSP		AZInterpolate( const NSP a, const NSP b, const CGF proportion )	{
	NSP p;
		p.x = a.x + ((b.x - a.x) * proportion);
	p.y = a.y + ((b.y - a.y) * proportion);
	return p;
}
CGF		AZLineLength( const NSP a, const NSP b )	{
	return hypotf( b.x - a.x, b.y - a.y );
}
CGF		AZSquaredLength( const NSP p )	{
	return( p.x * p.x) + ( p.y * p.y );
}
NSP		AZDiffPoint( const NSP a, const NSP b )	{
	// returns the difference of two points
		NSP c;
		c.x = a.x - b.x;
	c.y = a.y - b.y;
		return c;
}
CGF		AZDiffPointSquaredLength( const NSP a, const NSP b )	{
	// returns the square of the distance between two points
		return AZSquaredLength( AZDiffPoint( a, b ));
}
NSP		AZSumPoint( const NSP a, const NSP b )	{
	// returns the sum of two points
		NSP pn;
		pn.x = a.x + b.x;
	pn.y = a.y + b.y;
		return pn;
}
NSP		AZEndPoint( NSP origin, CGF angle, CGF length )	{
	// returns the end point of a line given its origin, length and angle relative to x axis
		NSP		ep;
		ep.x = origin.x + ( cosf( angle ) * length );
	ep.y = origin.y + ( sinf( angle ) * length );
	return ep;
}
CGF		AZSlope( const NSP a, const NSP b )	{
	// returns the slope of a line given its end points, in radians
		return atan2f( b.y - a.y, b.x - a.x );
}
CGF		AZAngleBetween( const NSP a, const NSP b, const NSP c )	{
	// returns the angle formed between three points abc where b is the vertex.
		return AZSlope( a, b ) - AZSlope( b, c );
}
CGF		AZDotProduct( const NSP a, const NSP b )	{
	return (a.x * b.x) + (a.y * b.y);
}
NSP		AZIntersection( const NSP aa, const NSP ab, const NSP ba, const NSP bb )	{
	// return the intersecting point of two lines a and b, whose end points are passed in. If the lines are parallel,
	// the result is undefined (NaN)
		NSP		i;
	CGF		sa, sb, ca, cb;
		sa = AZSlope( aa, ab );
	sb = AZSlope( ba, bb );
		ca = aa.y - sa * aa.x;
	cb = ba.y - sb * ba.x;
		i.x = ( cb - ca ) / ( sa - sb );
	i.y = sa * i.x + ca;
		return i;
}
NSP		AZIntersection2( const NSP p1, const NSP p2, const NSP p3, const NSP p4 )	{
	// return the intersecting point of two lines SEGMENTS p1-p2 and p3-p4, whose end points are passed in. If the lines are parallel,
	// the result is NSNotFoundPoint. Uses an alternative algorithm from Intersection() - this is faster and more usable. This only returns a
	// point if the two segments actually intersect - it doesn't project the lines.
		CGF d = (p4.y - p3.y)*(p2.x - p1.x) - (p4.x - p3.x)*(p2.y-p1.y);
		// if d is 0, then lines are parallel and don't intersect
		if ( d == 0.0 )
	return NSNotFoundPoint;
	
	CGF ua = ((p4.x - p3.x)*(p1.y - p3.y) - (p4.y - p3.y)*(p1.x - p3.x))/d;
	//float ub = ((p2.x - p1.x)*(p1.y - p3.y) - (p2.y - p1.y)*(p1.x - p3.x))/d;
		if( ua >= 0.0 && ua <= 1.0 )
	{
	// segments do intersect
		NSP ip;
		ip.x = p1.x + ua*(p2.x - p1.x);
	ip.y = p1.y + ua*(p2.y - p1.y);
		return ip;
	}
	else
	return NSNotFoundPoint;
}
NSR		AZCentreRectOnPoint( const NSR inRect, const NSP p )	{
	// relocates the rect so its centre is at p. Does not change the rect's size
		NSR r = inRect;
		r.origin.x = p.x - ( inRect.size.width * 0.5f );
	r.origin.y = p.y - ( inRect.size.height * 0.5f );
	return r;
}
NSP		AZMapPointFromRect( const NSP p, const NSR rect )	{
	// given a point <p> within <rect> this returns it mapped to a 0..1 interval
	NSP pn;
		pn.x = ( p.x - rect.origin.x ) / rect.size.width;
	pn.y = ( p.y - rect.origin.y ) / rect.size.height;
		return pn;
}
NSP		AZMapPointToRect( const NSP p, const NSR rect )	{
	// given a point <p> in 0..1 space, maps it to <rect>
	NSP pn;
		pn.x = ( p.x * rect.size.width ) + rect.origin.x;
	pn.y = ( p.y * rect.size.height ) + rect.origin.y;
		return pn;
}
NSP		AZMapPointFromRectToRect( const NSP p, const NSR srcRect, const NSR destRect )	{
	// maps a point <p> in <srcRect> to the same relative location within <destRect>
		return AZMapPointToRect( AZMapPointFromRect( p, srcRect ), destRect );
}
NSR	AZMapRectFromRectToRect	(const NSR  inRect, const NSR srcRect, const NSR destRect )	{
	// maps a rect from <srcRect> to the same relative position within <destRect>
		NSP p1, p2;
		p1 = inRect.origin;
	p2.x = NSMaxX( inRect );
	p2.y = NSMaxY( inRect );
		p1 = AZMapPointFromRectToRect( p1, srcRect, destRect );
	p2 = AZMapPointFromRectToRect( p2, srcRect, destRect );
		return NSRectFromTwoPoints( p1, p2 );
}
NSSZ	AZScaleSize   (const NSSZ  sz, const CGF scale)	{

  return  NSMakeSize(!sz.width ? 0 : sz.width * scale, !sz.height ? 0 : sz.height * scale);
}
NSR	AZScaleRect					(const NSR  inRect, const CGF scale  )	{
	// multiplies the width and height of <inrect> by <scale> and offsets the origin by half the difference, which
	// keeps the original centre of the rect at the same point. Values > 1 expand the rect, < 1 shrink it.
  NSR r = inRect;
	if (r.size.width)   r.size.width  *= scale;
  if (r.size.height)  r.size.height *= scale;
	r.origin.x -= 0.5 * (r.size.width  - inRect.size.width );
	r.origin.y -= 0.5 * (r.size.height - inRect.size.height);
	return r;
}

NSR AZRectExceptSpanAnchored(NSR r1, CGF span, AZA anchor) {

//  AZR * self = [AZR withRect:r1];

  return anchor == AZTop ?      AZUpperEdge(r1,span) : // (NSR) { self.x,           self.maxY - span, self.w,   span } :
         anchor == AZBtm ? AZRectExceptHigh(r1,span) : //(NSR) { self.x,           self.y,           self.w,   span } :
         anchor == AZLft ? AZRectExceptWide(r1,span) : // (NSR) { self.x,           self.y,           span,     self.h } :
         anchor == AZRgt ?      AZRightEdge(r1,span) : r1;//(r1,span) : // (NSR) { self.maxX - span, self.y,           span,     self.h } : self.r;
}

NSR AZRectScaledToRect(NSR resizeRect, NSR fitRect) {

  NSSZ inSize = resizeRect.size;
//  return
//}
//NSR	AZRectSca			(const NSSZ inSize, const NSR fitRect)	{
	// returns a rect having the same aspect ratio as <inSize>, scaled to fit within <fitRect>. The shorter side is centred
	// within <fitRect> as appropriate
		CGF   ratio = inSize.width / inSize.height;
	NSR  r;
		CGF hxs, vxs;
		hxs = inSize.width / fitRect.size.width;
	vxs = inSize.height / fitRect.size.height;
		if ( hxs >= vxs )
	{
	// fitting width, centering height
		r.size.width = fitRect.size.width;
	r.size.height = r.size.width / ratio;
	r.origin.x = fitRect.origin.x;
	r.origin.y = fitRect.origin.y + ((fitRect.size.height - r.size.height) / 2.0);
	}
	else
	{
	// fitting height, centering width
		r.size.height = fitRect.size.height;
	r.size.width = r.size.height * ratio;
	r.origin.y = fitRect.origin.y;
	r.origin.x = fitRect.origin.x + ((fitRect.size.width - r.size.width) / 2.0);
	}
	return r;
}
NSR	AZCentreRectInRect		(const NSR r,		  const NSR cr 	 )	{
	// centres <r> over <cr>, returning a rect the same size as <r>
		NSR	nr;
		nr.size = r.size;
		nr.origin.x = NSMinX( cr ) + (( cr.size.width - r.size.width ) / 2.0 );
	nr.origin.y = NSMinY( cr ) + (( cr.size.height - r.size.height ) / 2.0 );
		return nr;
}
NSBP*	RotatedRect					(const NSR r, 		  const CGF radians)	{
	// turns the rect into a path, rotated about its centre by <radians>
		NSBezierPath* path = [NSBezierPath bezierPathWithRect:r];
	return path;// rotatedPath:radians];
}
NSR	AZNormalizedRect			(const NSR r )									{
	// returns the same rect as the input, but adjusts any -ve width or height to be +ve and
	// compensates the origin.
		NSR	nr = r;
		if ( r.size.width < 0 )
	{
	nr.size.width = -r.size.width;
	nr.origin.x -= nr.size.width;
	}
		if ( r.size.height < 0 )
	{
	nr.size.height = -r.size.height;
	nr.origin.y -= nr.size.height;
	}
		return nr;
}
#if MAC_ONLY
NSAffineTransform*	RotationTransform			(const CGF angle,   const NSP cp 	 )	{
	// return a transform that will cause a rotation about the point given at the angle given
	NSAffineTransform*	xfm = [NSAffineTransform transform];
	[xfm translateXBy:cp.x yBy:cp.y];
	[xfm rotateByRadians:angle];
	[xfm translateXBy:-cp.x yBy:-cp.y];
	return xfm;
}
#endif

#pragma mark - bezier curve utils
static NSP*		ConvertToBezierForm		(const NSP inp, 		 const NSP bez[4]     );
static NSI		FindRoots					(NSP* w, NSI degree, double* t, NSI depth );
static NSI		CrossingCount				(NSP* v, NSI degree );
static NSI		ControlPolygonFlatEnough(NSP* v, NSI degree );
static double	ComputeXIntercept			(NSP* v, NSI degree );
#define MAXDEPTH	64
#define	EPSILON	(ldexp(1.0,-MAXDEPTH-1))
#define   SGN(a)	(((a)<0) ? -1 : 0)
//	AZConvertToBezierForm :	Given a point and a Bezier curve, generate a 5th-degree Bezier-format equation whose solution finds the point on the curve nearest the user-defined point.	
static NSP*	ConvertToBezierForm		( const NSP inp, const NSP bez[4] )	{
	NSI				i, j, k, m, n, ub, lb;	
	NSI				row, column;		// Table indices
	NSP			c[4];				// V(i)'s - P
	NSP			d[3];				// V(i+1) - V(i)
	NSP*		w;					// Ctl pts of 5th-degree curve
	double			cdTable[3][4];		// Dot product of c, d
		static double z[3][4] = {	/* Precomputed "z" for cubics	*/
	{1.0, 0.6, 0.3, 0.1},
	{0.4, 0.6, 0.6, 0.4},
	{0.1, 0.3, 0.6, 1.0},
	};
	/*Determine the c's -- these are vectors created by subtracting*/
	/* point P from each of the control points				*/
	for (i = 0; i <= 3; i++)
	{
	c[i] = AZDiffPoint( bez[i], inp );
	}
		/* Determine the d's -- these are vectors created by subtracting*/
	/* each control point from the next					*/
	for (i = 0; i < 3; i++)
	{ 
	d[i].x = ( bez[ i + 1 ].x - bez[i].x ) * 3.0;
	d[i].y = ( bez[ i + 1 ].y - bez[i].y ) * 3.0;
	}
	/* Create the c,d table -- this is a table of dot products of the */
	/* c's and d's							*/
		for ( row = 0; row < 3; row++ )
	{
	for (column = 0; column <= 3; column++)
	{
		cdTable[row][column] = AZDotProduct( d[row], c[column] );
	}
	}
	/* Now, apply the z's to the dot products, on the skew diagonal*/
	/* Also, set up the x-values, making these "points"		*/
		w = (NSP*)	malloc(6 * sizeof(NSP));
		for (i = 0; i <= 5; i++)
	{
	w[i].y = 0.0;
	w[i].x = (double)(i) / 5;
	}
	n = 3;
	m = 2;
		for (k = 0; k <= n + m; k++)
	{
	lb = MAX(0, k - m);
	ub = MIN(k, n);
	
	for (i = lb; i <= ub; i++)
	{
		j = k - i;
		w[i+j].y += cdTable[j][i] * z[j][i];
	}
	}
	return w;
}
//	AZFindRoots :	Given a 5th-degree equation in Bernstein-Bezier form, find all of the roots in the interval [0, 1].  Return the number	of roots found.	
static NSI FindRoots						( NSP* w, NSI degree, double* t, NSI depth )	{  
	NSI			i;
	NSP 	Left[6], Right[6];	// control polygons
	NSI			left_count,	 right_count;
	double		left_t[6], right_t[6];
	switch ( CrossingCount( w, degree ))
	{
	  	default:
		break;
		
	case 0:	// No solutions here
		return 0;	
	case 1:	// Unique solution
		// Stop recursion when the tree is deep enough
		// if deep enough, return 1 solution at midpoint
	
		if (depth >= MAXDEPTH)
		{
			t[0] = ( w[0].x + w[5].x) / 2.0;
			return 1;
		}
		
		if ( ControlPolygonFlatEnough( w, degree ))
		{
			t[0] = ComputeXIntercept( w, degree );
			return 1;
		}
		break;
	}
	// Otherwise, solve recursively after
	// subdividing control polygon
		AZBezier( w, degree, 0.5, Left, Right );
	left_count  = FindRoots( Left,  degree, left_t, depth+1 );
	right_count = FindRoots( Right, degree, right_t, depth+1 );
	// Gather solutions together
	for (i = 0; i < left_count; i++)
	{
	t[i] = left_t[i];
	}
	for (i = 0; i < right_count; i++)
	{
		t[i+left_count] = right_t[i];
	}
	// Send back total number of solutions
		return (left_count + right_count);
}
// AZCrossingCount :	Count the number of times a Bezier control polygon crosses the 0-axis. This number is >= the number of roots.
static NSI CrossingCount				( NSP* v, NSI degree )	{
	NSI 	i;	
	NSI 	n_crossings = 0;	/*  Number of zero-crossings	*/
	NSI		sign, old_sign;		/*  Sign of coefficients	*/
	old_sign = SGN( v[0].y );
		for ( i = 1; i <= degree; i++ )
	{
	sign = SGN( v[i].y );
	
	if (sign != old_sign)
		n_crossings++;
	old_sign = sign;
	}
	return n_crossings;
}
//	ControlPolygonFlatEnough : 	Check if the control polygon of a Bezier curve is flat enough for recursive subdivision to bottom out	
static NSI ControlPolygonFlatEnough	(NSP* v, NSI degree )	{
	NSI			i;					// Index variable
	double*		distance;			// Distances from pts to line
	double		max_distance_above;	// maximum of these
	double		max_distance_below;
	double		error;				// Precision of root
	double		intercept_1,
			intercept_2,
			left_intercept,
			right_intercept;
	double		a, b, c;			// Coefficients of implicit
								// eqn for line from V[0]-V[deg]
	/* Find the  perpendicular distance		*/
	/* from each interior control point to 	*/
	/* line connecting V[0] and V[degree]	*/
	distance = (double*) malloc((NSUInteger)(degree + 1) * sizeof(double));
	double	abSquared;
	/* Derive the implicit equation for line connecting first */
	/*  and last control points */
		a = v[0].y - v[degree].y;
	b = v[degree].x - v[0].x;
	c = v[0].x * v[degree].y - v[degree].x * v[0].y;
	abSquared = (a * a) + (b * b);
	for (i = 1; i < degree; i++)
	{
	// Compute distance from each of the points to that line
	distance[i] = a * v[i].x + b * v[i].y + c;
	if (distance[i] > 0.0)
	{
		distance[i] = (distance[i] * distance[i]) / abSquared;
	}
	if (distance[i] < 0.0)
	{
		distance[i] = - ((distance[i] * distance[i]) / abSquared);
	}
	}
	/* Find the largest distance	*/
	max_distance_above = 0.0;
	max_distance_below = 0.0;
	for (i = 1; i < degree; i++)
	{
	if (distance[i] < 0.0)
	{
		max_distance_below = MIN(max_distance_below, distance[i]);
	}
	if (distance[i] > 0.0)
	{
		max_distance_above = MAX(max_distance_above, distance[i]);
	}
	}
	free((char*) distance);
	double	det, dInv;
	double	a1, b1, c1, a2, b2, c2;
	/*  Implicit equation for zero line */
	a1 = 0.0;
	b1 = 1.0;
	c1 = 0.0;
	/*  Implicit equation for "above" line */
	a2 = a;
	b2 = b;
	c2 = c + max_distance_above;
	det = a1 * b2 - a2 * b1;
	dInv = 1.0/det;
		intercept_1 = (b1 * c2 - b2 * c1) * dInv;
	/*  Implicit equation for "below" line */
	a2 = a;
	b2 = b;
	c2 = c + max_distance_below;
		det = a1 * b2 - a2 * b1;
	dInv = 1.0/det;
		intercept_2 = (b1 * c2 - b2 * c1) * dInv;
	/* Compute intercepts of bounding box	*/
	left_intercept = MIN(intercept_1, intercept_2);
	right_intercept = MAX(intercept_1, intercept_2);
	error = 0.5 * (right_intercept - left_intercept);	
	if (error < EPSILON)
	{
	return 1;
	}
	else
	{
	return 0;
	}
}
//	AZComputeXIntercept :Compute intersection of chord from first control point to last with 0-axis.
static double ComputeXIntercept		(NSP* v, NSI degree)	{
	double	XLK, YLK, XNM, YNM, XMK, YMK;
	double	det, detInv;
	double	S;
	double	X;
	XLK = 1.0;
	YLK = 0.0;
	XNM = v[degree].x - v[0].x;
	YNM = v[degree].y - v[0].y;
	XMK = v[0].x;
	YMK = v[0].y;
	det = XNM*YLK - YNM*XLK;
	detInv = 1.0/det;
	S = (XNM*YMK - YNM*XMK) * detInv;
	X = XLK * S;
	return X;
}
//	AZNearestPointOnCurve :	Compute the parameter value of the point on a Bezier curve segment closest to some arbtitrary, user-input point.	Return the point on the curve at that parameter value.
NSP	AZNearestPointOnCurve			( const NSP inp, const NSP bez[4], double* tValue )	{
	NSP*	w;						// Ctl pts for 5th-degree eqn
	double		t_candidate[5];			// Possible roots	
	NSI			n_solutions;			// Number of roots found
	double		t;						// Parameter value of closest pt
	// Convert problem to 5th-degree Bezier form
		w = ConvertToBezierForm( inp, bez );
	// Find all possible roots of 5th-degree equation
		n_solutions = FindRoots( w, 5, t_candidate, 0 );
	free((char*) w);
	// Compare distances of P to all candidates, and to t=0, and t=1
	double		dist, new_dist;
	NSP 	p;
	NSI			i;
	// Check distance to beginning of curve, where t = 0
		dist = AZDiffPointSquaredLength( inp, bez[0] );
	t = 0.0;
	// Find distances for candidate points
		for (i = 0; i < n_solutions; i++)
	{
	p = AZBezier( bez, 3, t_candidate[i], NULL, NULL );
	
	new_dist = AZDiffPointSquaredLength( inp, p );
	if ( new_dist < dist )
	{
		dist = new_dist;
		t = t_candidate[i];
	}
	}
	// Finally, look at distance to end point, where t = 1.0
		new_dist = AZDiffPointSquaredLength( inp, bez[3]);
	if (new_dist < dist)
	{
	t = 1.0;
	}
		/*  Return the point on the curve at parameter value t */
//	LogEvent_(kInfoEvent, @"t : %4.12f", t);
		if ( tValue )
	*tValue = t;
	
	return AZBezier( bez, 3, t, NULL, NULL);
}
//	AZBezier : Evaluate a Bezier curve at a particular parameter value Fill in control points for resulting sub-curves if "Left" and	"Right" are non-null.
NSP	AZBezier( const NSP* v, const NSI degree, const double t, NSP* Left, NSP* Right )	{
	NSI			i, j;		/* Index variables	*/
	NSP 	Vtemp[6][6];
	/* Copy control points	*/
	for (j =0; j <= degree; j++)
	{
	Vtemp[0][j] = v[j];
	}
	/* Triangle computation	*/
	for (i = 1; i <= degree; i++)
	{	
	for (j =0 ; j <= degree - i; j++)
	{
		Vtemp[i][j].x = (1.0 - t) * Vtemp[i-1][j].x + t * Vtemp[i-1][j+1].x;
		Vtemp[i][j].y = (1.0 - t) * Vtemp[i-1][j].y + t * Vtemp[i-1][j+1].y;
	}
	}
		if ( Left )
	{
	for (j = 0; j <= degree; j++)
	{
		Left[j]  = Vtemp[j][0];
	}
	}
	if ( Right)
	{
	for (j = 0; j <= degree; j++)
	{
		Right[j] = Vtemp[degree-j][j];
	}
	}
	return (Vtemp[degree][0]);
}
CGF	AZBezierSlope( const NSP bez[4], const CGF t )	{
	// returns the slope of the curve defined by the bezier control points <bez[0..3]> at the t value given. This slope can be used to determine
	// the angle of something placed at that point tangent to the curve, such as a text character, etc. Add 90 degrees to get the normal to any
	// point. For text on a path, you also need to calculate t based on a linear length along the path.
	double			x, y, tt;
	double			ax, bx, cx;			// coefficients for cubic in x 
	double			ay, by, cy;			// coefficients for cubic in y
		// compute the coefficients of the bezier function:
		cx = 3.0 * (bez[1].x - bez[0].x);
	bx = 3.0 * (bez[2].x - bez[1].x) - cx;
	ax = bez[3].x - bez[0].x - cx - bx;
		cy = 3.0 * (bez[1].y - bez[0].y);
	by = 3.0 * (bez[2].y - bez[1].y) - cy;
	ay = bez[3].y - bez[0].y - cy - by;
	
	tt = LIMIT( t, 0.0, 1.0 );
		// tangent is first derivative, i.e. quadratic differentiated from cubic:
		x = ( 3.0 * ax * tt * tt ) + ( 2.0 * bx * tt ) + cx; 
	y = ( 3.0 * ay * tt * tt ) + ( 2.0 * by * tt ) + cy; 
		return atan2( y, x );
}

AZINTERFACEIMPLEMENTED(AtoZGeometry)


NSInteger fitToPowerOfTwo(NSInteger value)
{
    int shift = 0;
    while ((value >>= 1) != 0) shift++;
    return 2 << shift;
}

CGFloat aspectRatioOfSize(NSSize size)
{
	return (size.height) ? (size.width / size.height) : 0.0f;
}

NSP integralPoint(NSP point)
{
    return NSMakePoint(roundf(point.x), roundf(point.y));
}

NSSize integralSize(NSSize size)
{
	//To match behaviour of NSIntegralRect
	if (size.width <= 0 || size.height <= 0) return NSZeroSize;
	return NSMakeSize(ceilf(size.width), ceilf(size.height));
}

NSSize sizeToMatchRatio(NSSize size, CGFloat aspectRatio, BOOL preserveHeight)
{
	//Calculation is impossible - perhaps we should assert here instead
	if (aspectRatio == 0) return NSZeroSize;
	
	if (preserveHeight) return NSMakeSize(size.height * aspectRatio, size.height);
	else				return NSMakeSize(size.width, size.width / aspectRatio);
}

BOOL sizeFitsWithinSize(NSSize innerSize, NSSize outerSize)
{
	return (innerSize.width <= outerSize.width) && (innerSize.height <= outerSize.height);
}

NSSize sizeToFitSize(NSSize innerSize, NSSize outerSize)
{
	NSSize finalSize = outerSize;
	CGFloat ratioW = outerSize.width / innerSize.width;
	CGFloat ratioH = outerSize.height / innerSize.height;
	
	if (ratioW < ratioH)	finalSize.height	= (innerSize.height * ratioW);
	else					finalSize.width		= (innerSize.width * ratioH);
	return finalSize;
}

NSSize constrainToFitSize(NSSize innerSize, NSSize outerSize)
{
	if (sizeFitsWithinSize(innerSize, outerSize)) return innerSize;
	else return sizeToFitSize(innerSize, outerSize);
}

NSRect resizeRectFromPoint(NSRect theRect, NSSize newSize, NSP anchor)
{	
	CGFloat widthDiff	= newSize.width		- theRect.size.width;
	CGFloat heightDiff	= newSize.height	- theRect.size.height;
	
	NSRect newRect		= theRect;
	newRect.size		= newSize;
	newRect.origin.x	-= widthDiff	* anchor.x;
	newRect.origin.y	-= heightDiff	* anchor.y;
	
	return newRect;
}

NSP pointRelativeToRect(NSP thePoint, NSRect theRect)
{
	NSP anchorPoint = NSZeroPoint;
	anchorPoint.x = (theRect.size.width > 0.0f)		? ((thePoint.x - theRect.origin.x) / theRect.size.width)	: 0.0f;
	anchorPoint.y = (theRect.size.height > 0.0f)	? ((thePoint.y - theRect.origin.y) / theRect.size.height)	: 0.0f;
	return anchorPoint;
}

NSRect alignInRectWithAnchor(NSRect innerRect, NSRect outerRect, NSP anchor)
{
	NSRect alignedRect = innerRect;
	alignedRect.origin.x = outerRect.origin.x + (anchor.x * (outerRect.size.width - innerRect.size.width));
	alignedRect.origin.y = outerRect.origin.y + (anchor.y * (outerRect.size.height - innerRect.size.height));
	return alignedRect;	
}

NSRect centerInRect(NSRect innerRect, NSRect outerRect)
{
	return alignInRectWithAnchor(innerRect, outerRect, NSMakePoint(0.5f, 0.5f));
}

NSRect fitInRect(NSRect innerRect, NSRect outerRect, NSP anchor)
{
	NSRect fittedRect = NSZeroRect;
	fittedRect.size = sizeToFitSize(innerRect.size, outerRect.size);
	return alignInRectWithAnchor(fittedRect, outerRect, anchor);
}

NSRect constrainToRect(NSRect innerRect, NSRect outerRect, NSP anchor) {
	return sizeFitsWithinSize(innerRect.size, outerRect.size) ? alignInRectWithAnchor(innerRect, outerRect, anchor) : fitInRect(innerRect, outerRect, anchor);
}

NSP clampPointToRect(NSP point, NSRect rect)
{
	NSP clampedPoint = NSZeroPoint;
	clampedPoint.x = fmaxf(fminf(point.x, NSMaxX(rect)), NSMinX(rect));
	clampedPoint.y = fmaxf(fminf(point.y, NSMaxY(rect)), NSMinY(rect));
	return clampedPoint;
}

NSP deltaFromPointToPoint(NSP pointA, NSP pointB)
{
	return NSMakePoint(pointB.x - pointA.x,
					   pointB.y - pointA.y);
}

NSP pointWithDelta(NSP point, NSP delta)
{
	return NSMakePoint(point.x + delta.x,
					   point.y + delta.y);
}
NSP pointWithoutDelta(NSP point, NSP delta)
{
	return NSMakePoint(point.x - delta.x,
					   point.y - delta.y);
}

#pragma mark - CG functions

BOOL CGSizeFitsWithinSize(CGSZ innerSize, CGSZ outerSize)
{
	return (innerSize.width <= outerSize.width) && (innerSize.height <= outerSize.height);	
}

CGSZ CGSizeToFitSize(CGSZ innerSize, CGSZ outerSize)
{
	CGSZ finalSize = outerSize;
	CGFloat ratioW = outerSize.width / innerSize.width;
	CGFloat ratioH = outerSize.height / innerSize.height;
	
	if (ratioW < ratioH)	finalSize.height	= (innerSize.height * ratioW);
	else					finalSize.width		= (innerSize.width * ratioH);
	return finalSize;
}

CGPoint CGPointIntegral(CGPoint point)
{
    return CGPointMake(round(point.x), round(point.y));
}

CGSZ CGSizeIntegral(CGSZ size)
{
	//To match behaviour of CGRectIntegral
	if (size.width <= 0 || size.height <= 0) return CGSizeZero;
	return CGSizeMake(ceil(size.width), ceil(size.height));
}



static const CGFloat FBPointClosenessThreshold = 1e-10;


CGFloat AZDistanceBetweenPoints(NSPoint point1, NSPoint point2)
{
    CGFloat xDelta = point2.x - point1.x;
    CGFloat yDelta = point2.y - point1.y;
    return sqrtf(xDelta * xDelta + yDelta * yDelta);
}

CGFloat AZDistancePointToLine(NSPoint point, NSPoint lineStartPoint, NSPoint lineEndPoint)
{
    CGFloat lineLength = AZDistanceBetweenPoints(lineStartPoint, lineEndPoint);
    if ( lineLength == 0 )
        return 0;
    CGFloat u = ((point.x - lineStartPoint.x) * (lineEndPoint.x - lineStartPoint.x) + (point.y - lineStartPoint.y) * (lineEndPoint.y - lineStartPoint.y)) / (lineLength * lineLength);
    NSPoint intersectionPoint = NSMakePoint(lineStartPoint.x + u * (lineEndPoint.x - lineStartPoint.x), lineStartPoint.y + u * (lineEndPoint.y - lineStartPoint.y));
    return AZDistanceBetweenPoints(point, intersectionPoint);
}

NSPoint FBAddPoint(NSPoint point1, NSPoint point2)
{
    return NSMakePoint(point1.x + point2.x, point1.y + point2.y);
}

NSPoint FBUnitScalePoint(NSPoint point, CGFloat scale)
{
    NSPoint result = point;
    CGFloat length = FBPointLength(point);
    if ( length != 0.0 ) {
        result.x *= scale/length;
        result.y *= scale/length;
    }
    return result;
}

NSPoint FBScalePoint(NSPoint point, CGFloat scale)
{
    return NSMakePoint(point.x * scale, point.y * scale);
}

CGFloat FBDotMultiplyPoint(NSPoint point1, NSPoint point2)
{
    return point1.x * point2.x + point1.y * point2.y;
}

NSPoint FBSubtractPoint(NSPoint point1, NSPoint point2)
{
    return NSMakePoint(point1.x - point2.x, point1.y - point2.y);
}

CGFloat FBPointLength(NSPoint point)
{
    return sqrtf((point.x * point.x) + (point.y * point.y));
}

CGFloat FBPointSquaredLength(NSPoint point)
{
    return (point.x * point.x) + (point.y * point.y);
}

NSPoint FBNormalizePoint(NSPoint point)
{
    NSPoint result = point;
    CGFloat length = FBPointLength(point);
    if ( length != 0.0 ) {
        result.x /= length;
        result.y /= length;
    }
    return result;
}

NSPoint FBNegatePoint(NSPoint point)
{
    return NSMakePoint(-point.x, -point.y);
}

NSPoint FBRoundPoint(NSPoint point)
{
    NSPoint result = { roundf(point.x), roundf(point.y) };
    return result;
}

NSPoint AZLineNormal(NSPoint lineStart, NSPoint lineEnd)
{
    return FBNormalizePoint(NSMakePoint(-(lineEnd.y - lineStart.y), lineEnd.x - lineStart.x));
}

NSPoint AZLineMidpoint(NSPoint lineStart, NSPoint lineEnd) {

    CGFloat distance = AZDistanceBetweenPoints(lineStart, lineEnd);
    NSPoint tangent = FBNormalizePoint(FBSubtractPoint(lineEnd, lineStart));
    return FBAddPoint(lineStart, FBUnitScalePoint(tangent, distance / 2.0));
}

BOOL AZArePointsClose(NSPoint point1, NSPoint point2)
{
    return AZArePointsCloseWithOptions(point1, point2, FBPointClosenessThreshold);
}

BOOL AZArePointsCloseWithOptions(NSPoint point1, NSPoint point2, CGFloat threshold)
{
    return AZAreValuesCloseWithOptions(point1.x, point2.x, threshold) && AZAreValuesCloseWithOptions(point1.y, point2.y, threshold);
}

BOOL AZAreValuesClose(CGFloat value1, CGFloat value2) {

  return AZAreValuesCloseWithOptions(value1, value2, FBPointClosenessThreshold);
}

BOOL AZAreValuesCloseWithOptions(CGFloat value1, CGFloat value2, CGFloat threshold)
{
    CGFloat delta = value1 - value2;    
    return (delta <= threshold) && (delta >= -threshold);
}
