//
//  BBMeshView.m
//  BBMeshTest
//
//  Created by ben smith on 8/11/08.
//
//  This file is part of BBMeshTest.
//
//  BBMeshTest is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  BBMeshTest is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.

//  You should have received a copy of the GNU Lesser General Public License
//  along with BBMeshTest.  If not, see <http://www.gnu.org/licenses/>.
// 
//  Copyright 2008 Ben Britten Smith ben@benbritten.com .
//

#import "BBMeshView.h"

@implementation BBMeshView
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

//- (void) wakeFromNib
//{
	// add layer backing to my NSView
	self.wantsLayer = YES;
	CALayer* mainLayer = self.layer;
	mainLayer.name = @"mainLayer";
	mainLayer.delegate = self;

	int xVerts = XVERTS;
	int yVerts = YVERTS;
	
	// generate all the CALayers that are the vertext images 
	int layerIndex = 0;
	for (layerIndex = 0; layerIndex < (xVerts * yVerts); layerIndex++) {
		[self addMeshVertexLayer];		
	}

	[mainLayer setNeedsDisplay];
	// this is just some eyecandy
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(setupGrid:) userInfo:nil repeats:NO];

	// look for hit notifications from other views
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meshHitNotification:) name:@"BBMeshHitNotification" object:nil];

  }
 return self;
}
-(void)setupGrid:(id)sender {
	// here we will set all the layers positions to make a nice animation
		
	int xVerts = XVERTS;
	int yVerts = YVERTS;
	
	int layerIndex = 0;

	// grab the bounds frame, use that for my initial positions
	NSRect projectionFrame = NSInsetRect([self bounds], 20, 20);
	
	// set up my increments (ie how far apart each vertex is)
	float xincrement = projectionFrame.size.width/5.0;
	float yincrement = projectionFrame.size.height/4.0;
	float xcurrent = NSMinX(projectionFrame);
	float ycurrent = NSMinY(projectionFrame);
	
	NSArray * layers = [self.layer sublayers];
	layerIndex = 0;
	int ix,iy;
	for (ix = 0 ; ix < xVerts; ix++) {
		ycurrent = NSMinY(projectionFrame);
		for (iy = 0 ; iy < yVerts; iy++) {
			// now set the specific layer position
			CGPoint p = CGPointMake(xcurrent, ycurrent);
			CALayer * layer = [layers objectAtIndex:layerIndex++];
			layer.position = p;
			ycurrent += yincrement;
		}
		xcurrent += xincrement;
	}		
	
	// refresh the display
	[self setNeedsDisplay:YES];
}
- (void) drawRect:(NSRect)rect {
	// fill the background with white
	[[NSColor whiteColor] set];
	NSRectFill([self bounds]);
	// draw the vertex edges
	[self drawGridLines];
	// draw the triange that the current point is inside
	[self drawTriangleA:hitVertexA b:hitVertexB c:hitVertexC];

	// draw the current point
	[[NSColor redColor] set];
	[[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(hitPoint.x - 2, hitPoint.y - 2, 4, 4)] stroke];
}
-(void)drawGridLines  {
	// this draws the lines between all the vertexes to make the 'grid'
	// note: this isnt the best way to do this, it draws most lines twice
	// but it is good enough for our purposes here
	int xVerts = XVERTS;
	int yVerts = YVERTS;
	NSArray * layers = [self.layer sublayers];
	[[NSColor lightGrayColor] set];
	
	int ix,iy;
	for (ix = 0 ; ix < xVerts; ix++) {
		for (iy = 0 ; iy < yVerts; iy++) {
			int layerIndex = ix * yVerts + iy;
			// get the current layer
			CALayer* thisLayer = [layers objectAtIndex:layerIndex];
			// draw the four connecting points
			// draw from the current to the one to the right
			if (layerIndex + yVerts < [layers count] - 1) {
				CALayer * otherlayer = [layers objectAtIndex:layerIndex + yVerts];
				[NSBezierPath strokeLineFromPoint:NSPointFromCGPoint(otherlayer.position) toPoint:NSPointFromCGPoint(thisLayer.position)];				
			}
			// draw from the current to the one above, but only if I am not on the edge already
			if ((layerIndex + 1 < [layers count] - 1) && (iy != yVerts - 1)) {
				CALayer * otherlayer = [layers objectAtIndex:layerIndex + 1];
				[NSBezierPath strokeLineFromPoint:NSPointFromCGPoint(otherlayer.position) toPoint:NSPointFromCGPoint(thisLayer.position)];				
			}
			// draw from the current to the one to the left
			if (layerIndex - yVerts >= 0) {
				CALayer * otherlayer = [layers objectAtIndex:layerIndex - yVerts];
				[NSBezierPath strokeLineFromPoint:NSPointFromCGPoint(otherlayer.position) toPoint:NSPointFromCGPoint(thisLayer.position)];				
			}
			// draw from the current to the one below, but not if i am on the edge
			if ((layerIndex - 1 >= 0) && (iy != 0)) {
				CALayer * otherlayer = [layers objectAtIndex:layerIndex - 1];
				[NSBezierPath strokeLineFromPoint:NSPointFromCGPoint(otherlayer.position) toPoint:NSPointFromCGPoint(thisLayer.position)];				
			}
		}
	}		
}
-(NSImage*)meshVertextImage{
	// this just draws a nice little image of a circle with a cross-hair inside.
	// use this instead of drawing them every time, saves lots of cycles during the
	// drawing
	NSSize vertSize = NSMakeSize(20,20);
	NSRect vertRect = NSMakeRect(0, 0, vertSize.width, vertSize.height);
	NSRect targetRect = NSMakeRect(NSMidX(vertRect) - 5, NSMidY(vertRect) - 5,10,10);
	
	NSImage* vertImage = [[NSImage alloc] initWithSize:vertSize];
	[vertImage lockFocus];
	
	[[NSColor blackColor] set];
	[[NSBezierPath bezierPathWithOvalInRect:targetRect] stroke];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(vertRect), NSMidY(vertRect)) toPoint:NSMakePoint(NSMaxX(vertRect), NSMidY(vertRect))];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMidX(vertRect), NSMinY(vertRect)) toPoint:NSMakePoint(NSMidX(vertRect), NSMaxY(vertRect))];
	
	[vertImage unlockFocus];
	return vertImage;// autorelease];
}
- (CALayer*)addMeshVertexLayer {
	// here we add a vertex layer to the graph
	NSImage * vertImage = [self meshVertextImage];
//	CGImageRef cgImage = [self cgImageFromNSImage:vertImage];

	// make a new layer, set up all the defaults
	// put it at the center of the view for now
	CALayer* vertexLayer           = [CALayer layer];
	vertexLayer.bounds              = CGRectMake ( 0, 0, [vertImage size].width, [vertImage size].height );
	vertexLayer.contents            = vertImage;
	vertexLayer.contentsGravity     = kCAGravityCenter;
	vertexLayer.delegate            = self;    
	vertexLayer.opacity             = 1.0;  
	vertexLayer.position            = CGPointMake(NSMidX([self bounds]), NSMidY([self bounds]));  

	// add it to my main layer
	[self.layer addSublayer:vertexLayer];   
	// release the image since the layer 'owns' it now
//	CGImageRelease ( cgImage );
	return vertexLayer;
}
// this should really be inside an NSImage additions category, but oh well.
- (CGImageRef)cgImageFromNSImage:(NSImage*)anImage {
	NSData* data = [anImage TIFFRepresentation];
	return [self createCGImageFromData:data];
}
// this should really be inside an NSImage additions category, but oh well.
// from http://developer.apple.com/technotes/tn2005/tn2143.html
-(CGImageRef)createCGImageFromData:(NSData*)data {
	// just convert an NSImage to a cgimageref so that it is all layer compatible
	CGImageRef        imageRef = NULL;
	CGImageSourceRef  sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

	if(sourceRef) {
		imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
		CFRelease(sourceRef);
	}	
	return imageRef;
}
-(void)findHitTriangle:(CGPoint)p {
	// need to iterate through all the triangles formed by our
	// mesh and find the one that contains this point
	// for any given vertex, there are 4 quads that it is a part of
	// so for any given vertex, there are 8 triangles to check
	// however, this is a bounded graph, so if we start on
	// the left then we will only need to check 4 triangles on the right per
	// vertex because the ones on the left will have been checked already
	int xVerts = XVERTS;
	int yVerts = YVERTS;
	NSArray * layers = [self.layer sublayers];
	
	int ix,iy;
	for (ix = 0 ; ix < xVerts; ix++) {
		for (iy = 0 ; iy < yVerts; iy++) {
			int layerIndex = ix * yVerts + iy;
			CALayer* thisLayer = [layers objectAtIndex:layerIndex];
			// find the 4 triangles
			// one up and one over
			// one over and one up
			// one over and one down
			// one down and one over

			// first setup my locals
			CALayer* oneUp = nil;
			CALayer* oneOver = nil;
			CALayer* oneDown = nil;
			CALayer* oneUpOneOver = nil;
			CALayer* oneDownOneOver = nil;
			
			// check my bounds and assign the locals accordingly
			if (layerIndex + yVerts < [layers count]) {
				oneOver = [layers objectAtIndex:layerIndex + yVerts];
			}
			if ((layerIndex + 1 < [layers count]) && (iy != yVerts - 1)) {
				oneUp = [layers objectAtIndex:layerIndex + 1];				
			}
			if ((layerIndex + yVerts + 1 < [layers count]) && (iy != yVerts - 1)) {
				oneUpOneOver = [layers objectAtIndex:layerIndex + yVerts + 1];				
			}
			if ((layerIndex - 1 >= 0) && (iy != 0)) {
				oneDown = [layers objectAtIndex:layerIndex - 1];
			}
			if ((layerIndex + yVerts - 1 < [layers count]) && (iy != 0)) {
				oneDownOneOver = [layers objectAtIndex:layerIndex + yVerts - 1];				
			}
			
			// now, check each triangle if it is inside the mesh 
			// (ie) the layers are not nil
			if ((oneUp != nil) && (oneUpOneOver != nil)) {
				if ([self point:p inTriangleA:thisLayer.position b:oneUp.position c:oneUpOneOver.position]) {
					hitVertexA = thisLayer.position;
					hitVertexB = oneUp.position;
					hitVertexC = oneUpOneOver.position;
					vertexIndexA = layerIndex;
					vertexIndexB = layerIndex + 1;
					vertexIndexC = layerIndex + yVerts + 1;
					return;
				}
			}
			if ((oneOver != nil) && (oneUpOneOver != nil)) {
				if ([self point:p inTriangleA:thisLayer.position b:oneOver.position c:oneUpOneOver.position]) {
					hitVertexA = thisLayer.position;
					hitVertexB = oneOver.position;
					hitVertexC = oneUpOneOver.position;
					vertexIndexA = layerIndex;
					vertexIndexB = layerIndex + yVerts;
					vertexIndexC = layerIndex + yVerts + 1;
					return;
				}
			}
			
			if ((oneOver != nil) && (oneDown != nil)) {
				if ([self point:p inTriangleA:thisLayer.position b:oneOver.position c:oneDown.position]) {
					hitVertexA = thisLayer.position;
					hitVertexB = oneOver.position;
					hitVertexC = oneDown.position;
					vertexIndexA = layerIndex;
					vertexIndexB = layerIndex + yVerts;
					vertexIndexC = layerIndex - 1;
					return;
				}
			}
			if ((oneDownOneOver != nil) && (oneDown != nil)) {
				if ([self point:p inTriangleA:thisLayer.position b:oneDownOneOver.position c:oneDown.position]) {
					hitVertexA = thisLayer.position;
					hitVertexB = oneDownOneOver.position;
					hitVertexC = oneDown.position;
					vertexIndexA = layerIndex;
					vertexIndexB = layerIndex + yVerts - 1;
					vertexIndexC = layerIndex - 1;
					return;
				}
			}			
		}
	}		
	// point is not in the mesh, just set some defaults
	hitVertexA = CGPointMake(0, 0);
	hitVertexB = CGPointMake(0, 0);
	hitVertexC = CGPointMake(0, 0);
	vertexIndexA = -1;
	vertexIndexB = -1;
	vertexIndexC = -1;
}
-(void)meshHitNotification:(NSNotification*)note {
	if ([note object] == self) return;
	// got a mesh hit, need to draw the distorted point in my mesh
	//first grab all the important info into some easy to use
	// local vars
	CGPoint hit = NSPointToCGPoint(NSPointFromString([[note userInfo] objectForKey:@"hitPoint"]));
	CGPoint vertA = NSPointToCGPoint(NSPointFromString([[note userInfo] objectForKey:@"hitVertexA"]));
	CGPoint vertB = NSPointToCGPoint(NSPointFromString([[note userInfo] objectForKey:@"hitVertexB"]));
	CGPoint vertC = NSPointToCGPoint(NSPointFromString([[note userInfo] objectForKey:@"hitVertexC"]));
	
	int indexA = [[[note userInfo] objectForKey:@"vertexIndexA"] intValue];
	int indexB = [[[note userInfo] objectForKey:@"vertexIndexB"] intValue];
	int indexC = [[[note userInfo] objectForKey:@"vertexIndexC"] intValue];

	// now grab my local values for the vertexes at the specified indexes
	NSArray * layers = [self.layer sublayers];
	CGPoint myVertA = [(CALayer*)[layers objectAtIndex:indexA] position];
	CGPoint myVertB = [(CALayer*)[layers objectAtIndex:indexB] position];
	CGPoint myVertC = [(CALayer*)[layers objectAtIndex:indexC] position];
	
	CGPoint bang = [self destinationPointFromSourcePoint:hit 
																	sourceTrianglePointA:vertA 
																	sourceTrianglePointB:vertB 
																	sourceTrianglePointC:vertC 
														 destinationTrianglePointA:myVertA 
														 destinationTrianglePointB:myVertB 
														 destinationTrianglePointC:myVertC];
	hitPoint = bang;
	hitVertexA = myVertA;
	hitVertexB = myVertB;
	hitVertexC = myVertC;
	[self setNeedsDisplay:YES];
}
-(void)postHitNotification {
	// here we just post the relevant info so that another mesh can generate
	// a point
	NSDictionary * hitDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
																	[NSNumber numberWithInt:vertexIndexA],@"vertexIndexA",
																	[NSNumber numberWithInt:vertexIndexB],@"vertexIndexB",
																	[NSNumber numberWithInt:vertexIndexC],@"vertexIndexC",
																	NSStringFromPoint(NSPointFromCGPoint(hitVertexA)),@"hitVertexA",
																	NSStringFromPoint(NSPointFromCGPoint(hitVertexB)),@"hitVertexB",
																	NSStringFromPoint(NSPointFromCGPoint(hitVertexC)),@"hitVertexC",
																	NSStringFromPoint(NSPointFromCGPoint(hitPoint)),@"hitPoint",
																	nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BBMeshHitNotification" object:self userInfo:hitDictionary];
}
-(void)mouseDown:(NSEvent*)theEvent{
	NSPoint mousePointInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
	// find the layer that we hit
	hitPoint = NSPointToCGPoint(mousePointInView);
	CALayer* hitLayer = [self.layer hitTest:hitPoint];

	draggingLayer = hitLayer;
	// if we are in the main layer, then do the triangle calcs n stuff
	if (draggingLayer == self.layer) {
		[self findHitTriangle:hitPoint];
		[self postHitNotification];		
		[self setNeedsDisplay:YES];
	}
}
-(void)mouseDragged:(NSEvent*)theEvent{

	// if we are in the 'background layer' then do the hit calc and find the point
	if (draggingLayer == self.layer) {
		NSPoint mousePointInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
		hitPoint = NSPointToCGPoint(mousePointInView);
		[self findHitTriangle:hitPoint];
		[self postHitNotification];
		[self setNeedsDisplay:YES];		
		return;
	}
	
	// we are inside one of the vertext layers, so move it
	CGPoint position = draggingLayer.position;
	position.x += [theEvent deltaX];
	position.y -= [theEvent deltaY];
	
	[CATransaction begin];
	
	// make sure the dragging happens immediately, if we dont do this
	// then the dragging is all nice and animated and slooooow and lame
	[CATransaction setValue: [NSNumber numberWithBool:0.0]
									 forKey: kCATransactionAnimationDuration];
	
	[draggingLayer removeAllAnimations];	
	draggingLayer.position = position;
	[CATransaction commit];
	[self setNeedsDisplay:YES];
}
-(BOOL)point:(CGPoint)p inTriangleA:(CGPoint)a b:(CGPoint)b c:(CGPoint)c {
	// using barycentric math, calculate the U,V coords and see if
	// this point is inside the triangle
	// good explanation found here:
	// http://www.blackpawn.com/texts/pointinpoly/default.html

	// Compute vectors relative to a       
	CGPoint v0 = CGPointMake(c.x - a.x, c.y - a.y);
	CGPoint v1 = CGPointMake(b.x - a.x, b.y - a.y);
	CGPoint v2 = CGPointMake(p.x - a.x, p.y - a.y);
	
	// Compute dot products
	float dot00 = [self dotA:v0 b:v0];
	float dot01 = [self dotA:v0 b:v1];
	float dot02 = [self dotA:v0 b:v2];
	float dot11 = [self dotA:v1 b:v1];
	float dot12 = [self dotA:v1 b:v2];
	
	// Compute barycentric coordinates
	float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
	float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
	float v = (dot00 * dot12 - dot01 * dot02) * invDenom;
	
	// Check if point is in triangle
	return ((u > 0) && (v > 0) && (u + v < 1));
}
// the dot product
-(float)dotA:(CGPoint)a b:(CGPoint)b {
	return (a.x * b.x) + (a.y * b.y);
}
// draws a triangle between the three points and fills it
-(void)drawTriangleA:(CGPoint)a b:(CGPoint)b c:(CGPoint)c {
	NSBezierPath * tri = [NSBezierPath bezierPath];
	[tri moveToPoint:NSPointFromCGPoint(a)];
	[tri lineToPoint:NSPointFromCGPoint(b)];
	[tri lineToPoint:NSPointFromCGPoint(c)];
	[tri lineToPoint:NSPointFromCGPoint(a)];
	[[NSColor greenColor] set];
	[tri fill];
	[[NSColor blackColor] set];
	[tri stroke];
}

// this is the big distortion calculation
// it takes the 4 known points from the source mesh and 3 known points from the destination mesh
// and finds the wanted point in the destination ugly method sig, oh well.
-(CGPoint)destinationPointFromSourcePoint:(CGPoint)srcP
										 sourceTrianglePointA:(CGPoint)sa
										 sourceTrianglePointB:(CGPoint)sb
										 sourceTrianglePointC:(CGPoint)sc
								destinationTrianglePointA:(CGPoint)da
								destinationTrianglePointB:(CGPoint)db
								destinationTrianglePointC:(CGPoint)dc
{
	// this algorithm is inspired by the CTouchScreen::cameraToScreenSpace
	// method in touchlib
	//  it is a standard barycentric position calc using the 
	// ration of the areas of the inner triangles formed by the 
	// three vertices and the hit point
	float areaT = [self areaOfTriangleWithPoints:sa b:sb c:sc]; // total area of source
	
	// area1 is the area of the triangle opposite the A vertex, or the area between 2,3,4 and so on
	// find the source area and normalize them
	float area1 = [self areaOfTriangleWithPoints:sb b:sc c:srcP]/areaT;
	float area2 = [self areaOfTriangleWithPoints:sa b:sc c:srcP]/areaT;
	float area3 = [self areaOfTriangleWithPoints:sb b:sa c:srcP]/areaT;
	
	// now using the normalized areas, we can 'walk' the three vectors to
	// get the wanted point in the destination mesh
	CGPoint p1 = CGPointMake(da.x * area1, da.y * area1);
	CGPoint p2 = CGPointMake(db.x * area2, db.y * area2);
	CGPoint p3 = CGPointMake(dc.x * area3, dc.y * area3);
	
	return CGPointMake(p1.x + p2.x + p3.x, p1.y + p2.y + p3.y);
}

-(float)areaOfTriangleWithPoints:(CGPoint)p1 b:(CGPoint)p2 c:(CGPoint)p3
{
	// got this area calculation from
	// http://www.btinternet.com/~se16/hgb/triangle.htm
	
	// the points need to be clockwise for this to work properly
	// instead of requiring that they come in the proper order
	// we will just make sure here
	
	// make the higest point the start
	CGPoint A,B,C;
	A = p1;
	if (p2.y > A.y) A = p2;
	if (p3.y > A.y) A = p3;
	
	// now find the next point that is 'on the right', ie clockwise from A
	// if A is p1, then check the other 2
	if (CGPointEqualToPoint(A, p1)) {
		if (p2.x > p3.x) {
			B = p2;
			C = p3;
		} else {
			B = p3;
			C = p2;
		}
	}
	
	// if A is p2 then .. you get the idea
	if (CGPointEqualToPoint(A, p2)) {
		if (p1.x > p3.x) {
			B = p1;
			C = p3;
		} else {
			B = p3;
			C = p1;
		}
	}
	
	// if A is p3 yadda yadda
	if (CGPointEqualToPoint(A, p3)) {
		if (p1.x > p2.x) {
			B = p1;
			C = p2;
		} else {
			B = p2;
			C = p1;
		}
	}
	
	// do the area calculation
	// what we are basically doing, tho it is not very obvious is
	// we are taking the area of the bounding rectangle and 
	// subtracting the outer right triangles which are easy
	// to find instead of trying to make two right triangles inside the
	// source triangle. if that makes no sense, see the link above
	float f = A.x - B.x;
	float g = A.y - C.y;
	float w = A.y - B.y;
	float v = A.x - C.x;
	return fabs(((f * g)/2.0) - ((v * w)/2.0));
}
@end

/*
//  BBMeshView.m
//  BBMeshTest
//  Created by ben smith on 8/11/08.
//  This file is part of BBMeshTest.
//  BBMeshTest is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  BBMeshTest is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.

//  You should have received a copy of the GNU Lesser General Public License
//  along with BBMeshTest.  If not, see <http://www.gnu.org/licenses/>.
// 
//  Copyright 2008 Ben Britten Smith ben@benbritten.com .
//

@import AppKit;
#import <QuartzCore/QuartzCore.h>
#import "BBMeshView.h"


#define XVERTS 6
#define YVERTS 5

//@interface BBMeshView  ()

//- (BOOL)point:(CGPoint)p inTriangleA:(CGPoint)a b:(CGPoint)b c:(CGPoint)c;
//- (CALayer*)addMeshVertexLayer;;
//- (CGImageRef)cgImageFromNSImage:(NSImage*)anImage;
//- (CGImageRef)createCGImageFromData:(NSData*)data;
//- (CGPoint)destinationPointFromSourcePoint:(CGPoint)srcP
//											sourceTrianglePointA:(CGPoint)sa
//											sourceTrianglePointB:(CGPoint)sb
//											sourceTrianglePointC:(CGPoint)sc
//								 destinationTrianglePointA:(CGPoint)da
//								 destinationTrianglePointB:(CGPoint)db
//								 destinationTrianglePointC:(CGPoint)dc;
//- (NSImage*)meshVertextImage;
//- (float)areaOfTriangleWithPoints:(CGPoint)p1 b:(CGPoint)p2 c:(CGPoint)p3;
//- (float)dotA:(CGPoint)a b:(CGPoint)b;
//- (id)initWithFrame:(NSRect)frame ;
//- (void) wakeFromNib;
//- (void) drawGridLines;
//- (void) drawRect:(NSRect)rect ;
//- (void) drawTriangleA:(CGPoint)a b:(CGPoint)b c:(CGPoint)c;
//- (void) indHitTriangle:(CGPoint)p;
//- (void) eshHitNotification:(NSNotification*)note;
//- (void) mouseDown:(NSEvent*)theEvent;
//- (void) mouseDragged:(NSEvent*)theEvent;
//- (void) ostHitNotification;
//- (void) setupGrid:(id)sender;

// 19 methods


//@end


@implementation BBMeshView {

	CALayer * draggingLayer;
	CGPoint hitPoint;
	CGPoint hitVertexA;
	CGPoint hitVertexB;
	CGPoint hitVertexC;
	int vertexIndexA;
	int vertexIndexB;
	int vertexIndexC;
}

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code here.
	}
	return self;
}

- (void) wakeFromNib
{
	// add layer backing to my NSView
	self.wantsLayer = YES;
	CALayer* mainLayer = self.layer;
	mainLayer.name = @"mainLayer";
	mainLayer.delegate = self;

	int xVerts = XVERTS;
	int yVerts = YVERTS;
	
	// generate all the CALayers that are the vertext images 
	int layerIndex = 0;
	for (layerIndex = 0; layerIndex < (xVerts * yVerts); layerIndex++) {
		[self addMeshVertexLayer];		
	}

	[mainLayer setNeedsDisplay];
	// this is just some eyecandy
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(setupGrid:) userInfo:nil repeats:NO];

	// look for hit notifications from other views
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meshHitNotification:) name:@"BBMeshHitNotification" object:nil];
}

-(void)setupGrid:(id)sender
{
	// here we will set all the layers positions to make a nice animation
		
	int xVerts = XVERTS;
	int yVerts = YVERTS;
	
	int layerIndex = 0;

	// grab the bounds frame, use that for my initial positions
	NSRect projectionFrame = NSInsetRect([self bounds], 20, 20);
	
	// set up my increments (ie how far apart each vertex is)
	float xincrement = projectionFrame.size.width/5.0;
	float yincrement = projectionFrame.size.height/4.0;
	float xcurrent = NSMinX(projectionFrame);
	float ycurrent = NSMinY(projectionFrame);
	
	NSArray * layers = [self.layer sublayers];
	layerIndex = 0;
	int ix,iy;
	for (ix = 0 ; ix < xVerts; ix++) {
		ycurrent = NSMinY(projectionFrame);
		for (iy = 0 ; iy < yVerts; iy++) {
			// now set the specific layer position
			CGPoint p = CGPointMake(xcurrent, ycurrent);
			CALayer * layer = [layers objectAtIndex:layerIndex++];
			layer.position = p;
			ycurrent += yincrement;
		}
		xcurrent += xincrement;
	}		
	
	// refresh the display
	[self setNeedsDisplay:YES];
}

- (void) drawRect:(NSRect)rect {
	// fill the background with white
	[[NSColor whiteColor] set];
	NSRectFill([self bounds]);
	// draw the vertex edges
	[self drawGridLines];
	// draw the triange that the current point is inside
	[self drawTriangleA:hitVertexA b:hitVertexB c:hitVertexC];

	// draw the current point
	[[NSColor redColor] set];
	[[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(hitPoint.x - 2, hitPoint.y - 2, 4, 4)] stroke];
}

-(void)drawGridLines
{
	// this draws the lines between all the vertexes to make the 'grid'
	// note: this isnt the best way to do this, it draws most lines twice
	// but it is good enough for our purposes here
	int xVerts = XVERTS;
	int yVerts = YVERTS;
	NSArray * layers = [self.layer sublayers];
	[[NSColor lightGrayColor] set];
	
	int ix,iy;
	for (ix = 0 ; ix < xVerts; ix++) {
		for (iy = 0 ; iy < yVerts; iy++) {
			int layerIndex = ix * yVerts + iy;
			// get the current layer
			CALayer* thisLayer = [layers objectAtIndex:layerIndex];
			// draw the four connecting points
			// draw from the current to the one to the right
			if (layerIndex + yVerts < [layers count] - 1) {
				CALayer * otherlayer = [layers objectAtIndex:layerIndex + yVerts];
				[NSBezierPath strokeLineFromPoint:NSPointFromCGPoint(otherlayer.position) toPoint:NSPointFromCGPoint(thisLayer.position)];				
			}
			// draw from the current to the one above, but only if I am not on the edge already
			if ((layerIndex + 1 < [layers count] - 1) && (iy != yVerts - 1)) {
				CALayer * otherlayer = [layers objectAtIndex:layerIndex + 1];
				[NSBezierPath strokeLineFromPoint:NSPointFromCGPoint(otherlayer.position) toPoint:NSPointFromCGPoint(thisLayer.position)];				
			}
			// draw from the current to the one to the left
			if (layerIndex - yVerts >= 0) {
				CALayer * otherlayer = [layers objectAtIndex:layerIndex - yVerts];
				[NSBezierPath strokeLineFromPoint:NSPointFromCGPoint(otherlayer.position) toPoint:NSPointFromCGPoint(thisLayer.position)];				
			}
			// draw from the current to the one below, but not if i am on the edge
			if ((layerIndex - 1 >= 0) && (iy != 0)) {
				CALayer * otherlayer = [layers objectAtIndex:layerIndex - 1];
				[NSBezierPath strokeLineFromPoint:NSPointFromCGPoint(otherlayer.position) toPoint:NSPointFromCGPoint(thisLayer.position)];				
			}
		}
	}		
}

-(NSImage*)meshVertextImage
{
	// this just draws a nice little image of a circle with a cross-hair inside.
	// use this instead of drawing them every time, saves lots of cycles during the
	// drawing
	NSSize vertSize = NSMakeSize(20,20);
	NSRect vertRect = NSMakeRect(0, 0, vertSize.width, vertSize.height);
	NSRect targetRect = NSMakeRect(NSMidX(vertRect) - 5, NSMidY(vertRect) - 5,10,10);
	
	NSImage* vertImage = [NSImage.alloc initWithSize:vertSize];
	[vertImage lockFocus];
	
	[[NSColor blackColor] set];
	[[NSBezierPath bezierPathWithOvalInRect:targetRect] stroke];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(vertRect), NSMidY(vertRect)) toPoint:NSMakePoint(NSMaxX(vertRect), NSMidY(vertRect))];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMidX(vertRect), NSMinY(vertRect)) toPoint:NSMakePoint(NSMidX(vertRect), NSMaxY(vertRect))];
	
	[vertImage unlockFocus];
	return vertImage;
}


- (CALayer*)addMeshVertexLayer;
{
	// here we add a vertex layer to the graph
	NSImage * vertImage = [self meshVertextImage];
//	CGImageRef cgImage = [self cgImageFromNSImage:];

	// make a new layer, set up all the defaults
	// put it at the center of the view for now
	CALayer* vertexLayer		   = [CALayer layer];
	vertexLayer.bounds			  = CGRectMake ( 0, 0, [vertImage size].width, [vertImage size].height );
	vertexLayer.contents			= vertImage;//(id)cgImage;
	vertexLayer.contentsGravity	 = kCAGravityCenter;
	vertexLayer.delegate			= self;	
	vertexLayer.opacity			 = 1.0;  
	vertexLayer.position			= CGPointMake(NSMidX([self bounds]), NSMidY([self bounds]));  

	// add it to my main layer
	[self.layer addSublayer:vertexLayer];   
	// release the image since the layer 'owns' it now
//	CGImageRelease ( cgImage );

	return vertexLayer;
}


// this should really be inside an NSImage additions category, but oh well.
//- (CGImageRef)cgImageFromNSImage:(NSImage*)anImage
//{
//	NSData* data = [anImage TIFFRepresentation];
//	return [self createCGImageFromData:data];
//}


// this should really be inside an NSImage additions category, but oh well.
// from http://developer.apple.com/technotes/tn2005/tn2143.html
//-(CGImageRef)createCGImageFromData:(NSData*)data
//{
//	// just convert an NSImage to a cgimageref so that it is all layer compatible
//	CGImageRef		imageRef = NULL;
//	CGImageSourceRef  sourceRef;
//	
//	sourceRef = CGImageSourceCreateWithData((CFDataRef)data, NULL);
//	if(sourceRef) {
//		imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
//		CFRelease(sourceRef);
//	}	
//	return imageRef;
//}


-(void)findHitTriangle:(CGPoint)p
{
	// need to iterate through all the triangles formed by our
	// mesh and find the one that contains this point
	// for any given vertex, there are 4 quads that it is a part of
	// so for any given vertex, there are 8 triangles to check
	// however, this is a bounded graph, so if we start on
	// the left then we will only need to check 4 triangles on the right per
	// vertex because the ones on the left will have been checked already
	int xVerts = XVERTS;
	int yVerts = YVERTS;
	NSArray * layers = [self.layer sublayers];
	
	int ix,iy;
	for (ix = 0 ; ix < xVerts; ix++) {
		for (iy = 0 ; iy < yVerts; iy++) {
			int layerIndex = ix * yVerts + iy;
			CALayer* thisLayer = [layers objectAtIndex:layerIndex];
			// find the 4 triangles
			// one up and one over
			// one over and one up
			// one over and one down
			// one down and one over

			// first setup my locals
			CALayer* oneUp = nil;
			CALayer* oneOver = nil;
			CALayer* oneDown = nil;
			CALayer* oneUpOneOver = nil;
			CALayer* oneDownOneOver = nil;
			
			// check my bounds and assign the locals accordingly
			if (layerIndex + yVerts < [layers count]) {
				oneOver = [layers objectAtIndex:layerIndex + yVerts];
			}
			if ((layerIndex + 1 < [layers count]) && (iy != yVerts - 1)) {
				oneUp = [layers objectAtIndex:layerIndex + 1];				
			}
			if ((layerIndex + yVerts + 1 < [layers count]) && (iy != yVerts - 1)) {
				oneUpOneOver = [layers objectAtIndex:layerIndex + yVerts + 1];				
			}
			if ((layerIndex - 1 >= 0) && (iy != 0)) {
				oneDown = [layers objectAtIndex:layerIndex - 1];
			}
			if ((layerIndex + yVerts - 1 < [layers count]) && (iy != 0)) {
				oneDownOneOver = [layers objectAtIndex:layerIndex + yVerts - 1];				
			}
			
			// now, check each triangle if it is inside the mesh 
			// (ie) the layers are not nil
			if ((oneUp != nil) && (oneUpOneOver != nil)) {
				if ([self point:p inTriangleA:thisLayer.position b:oneUp.position c:oneUpOneOver.position]) {
					hitVertexA = thisLayer.position;
					hitVertexB = oneUp.position;
					hitVertexC = oneUpOneOver.position;
					vertexIndexA = layerIndex;
					vertexIndexB = layerIndex + 1;
					vertexIndexC = layerIndex + yVerts + 1;
					return;
				}
			}
			if ((oneOver != nil) && (oneUpOneOver != nil)) {
				if ([self point:p inTriangleA:thisLayer.position b:oneOver.position c:oneUpOneOver.position]) {
					hitVertexA = thisLayer.position;
					hitVertexB = oneOver.position;
					hitVertexC = oneUpOneOver.position;
					vertexIndexA = layerIndex;
					vertexIndexB = layerIndex + yVerts;
					vertexIndexC = layerIndex + yVerts + 1;
					return;
				}
			}
			
			if ((oneOver != nil) && (oneDown != nil)) {
				if ([self point:p inTriangleA:thisLayer.position b:oneOver.position c:oneDown.position]) {
					hitVertexA = thisLayer.position;
					hitVertexB = oneOver.position;
					hitVertexC = oneDown.position;
					vertexIndexA = layerIndex;
					vertexIndexB = layerIndex + yVerts;
					vertexIndexC = layerIndex - 1;
					return;
				}
			}
			if ((oneDownOneOver != nil) && (oneDown != nil)) {
				if ([self point:p inTriangleA:thisLayer.position b:oneDownOneOver.position c:oneDown.position]) {
					hitVertexA = thisLayer.position;
					hitVertexB = oneDownOneOver.position;
					hitVertexC = oneDown.position;
					vertexIndexA = layerIndex;
					vertexIndexB = layerIndex + yVerts - 1;
					vertexIndexC = layerIndex - 1;
					return;
				}
			}			
		}
	}		
	// point is not in the mesh, just set some defaults
	hitVertexA = CGPointMake(0, 0);
	hitVertexB = CGPointMake(0, 0);
	hitVertexC = CGPointMake(0, 0);
	vertexIndexA = -1;
	vertexIndexB = -1;
	vertexIndexC = -1;
}


-(void)meshHitNotification:(NSNotification*)note
{
	if ([note object] == self) return;
	// got a mesh hit, need to draw the distorted point in my mesh
	//first grab all the important info into some easy to use
	// local vars
	CGPoint hit = NSPointToCGPoint(NSPointFromString([[note userInfo] objectForKey:@"hitPoint"]));
	CGPoint vertA = NSPointToCGPoint(NSPointFromString([[note userInfo] objectForKey:@"hitVertexA"]));
	CGPoint vertB = NSPointToCGPoint(NSPointFromString([[note userInfo] objectForKey:@"hitVertexB"]));
	CGPoint vertC = NSPointToCGPoint(NSPointFromString([[note userInfo] objectForKey:@"hitVertexC"]));
	
	int indexA = [[[note userInfo] objectForKey:@"vertexIndexA"] intValue];
	int indexB = [[[note userInfo] objectForKey:@"vertexIndexB"] intValue];
	int indexC = [[[note userInfo] objectForKey:@"vertexIndexC"] intValue];

	// now grab my local values for the vertexes at the specified indexes
	NSArray * layers = [self.layer sublayers];
	CGPoint myVertA = [(CALayer*)[layers objectAtIndex:indexA] position];
	CGPoint myVertB = [(CALayer*)[layers objectAtIndex:indexB] position];
	CGPoint myVertC = [(CALayer*)[layers objectAtIndex:indexC] position];
	
	CGPoint bang = [self destinationPointFromSourcePoint:hit 
																	sourceTrianglePointA:vertA 
																	sourceTrianglePointB:vertB 
																	sourceTrianglePointC:vertC 
														 destinationTrianglePointA:myVertA 
														 destinationTrianglePointB:myVertB 
														 destinationTrianglePointC:myVertC];
	hitPoint = bang;
	hitVertexA = myVertA;
	hitVertexB = myVertB;
	hitVertexC = myVertC;
	[self setNeedsDisplay:YES];
}

-(void)postHitNotification
{
	// here we just post the relevant info so that another mesh can generate
	// a point
	NSDictionary * hitDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
																	[NSNumber numberWithInt:vertexIndexA],@"vertexIndexA",
																	[NSNumber numberWithInt:vertexIndexB],@"vertexIndexB",
																	[NSNumber numberWithInt:vertexIndexC],@"vertexIndexC",
																	NSStringFromPoint(NSPointFromCGPoint(hitVertexA)),@"hitVertexA",
																	NSStringFromPoint(NSPointFromCGPoint(hitVertexB)),@"hitVertexB",
																	NSStringFromPoint(NSPointFromCGPoint(hitVertexC)),@"hitVertexC",
																	NSStringFromPoint(NSPointFromCGPoint(hitPoint)),@"hitPoint",
																	nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BBMeshHitNotification" object:self userInfo:hitDictionary];
}


-(void)mouseDown:(NSEvent*)theEvent
{
	NSPoint mousePointInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
	// find the layer that we hit
	hitPoint = NSPointToCGPoint(mousePointInView);
	CALayer* hitLayer = [self.layer hitTest:hitPoint];

	draggingLayer = hitLayer;
	// if we are in the main layer, then do the triangle calcs n stuff
	if (draggingLayer == self.layer) {
		[self findHitTriangle:hitPoint];
		[self postHitNotification];		
		[self setNeedsDisplay:YES];
	}
}


-(void)mouseDragged:(NSEvent*)theEvent
{

	// if we are in the 'background layer' then do the hit calc and find the point
	if (draggingLayer == self.layer) {
		NSPoint mousePointInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
		hitPoint = NSPointToCGPoint(mousePointInView);
		[self findHitTriangle:hitPoint];
		[self postHitNotification];
		[self setNeedsDisplay:YES];		
		return;
	}
	
	// we are inside one of the vertext layers, so move it
	CGPoint position = draggingLayer.position;
	position.x += [theEvent deltaX];
	position.y -= [theEvent deltaY];
	
	[CATransaction begin];
	
	// make sure the dragging happens immediately, if we dont do this
	// then the dragging is all nice and animated and slooooow and lame
	[CATransaction setValue: [NSNumber numberWithBool:0.0]
									 forKey: kCATransactionAnimationDuration];
	
	[draggingLayer removeAllAnimations];	
	draggingLayer.position = position;
	[CATransaction commit];
	[self setNeedsDisplay:YES];
}

-(BOOL)point:(CGPoint)p inTriangleA:(CGPoint)a b:(CGPoint)b c:(CGPoint)c
{
	// using barycentric math, calculate the U,V coords and see if
	// this point is inside the triangle
	// good explanation found here:
	// http://www.blackpawn.com/texts/pointinpoly/default.html

	// Compute vectors relative to a	   
	CGPoint v0 = CGPointMake(c.x - a.x, c.y - a.y);
	CGPoint v1 = CGPointMake(b.x - a.x, b.y - a.y);
	CGPoint v2 = CGPointMake(p.x - a.x, p.y - a.y);
	
	// Compute dot products
	float dot00 = [self dotA:v0 b:v0];
	float dot01 = [self dotA:v0 b:v1];
	float dot02 = [self dotA:v0 b:v2];
	float dot11 = [self dotA:v1 b:v1];
	float dot12 = [self dotA:v1 b:v2];
	
	// Compute barycentric coordinates
	float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
	float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
	float v = (dot00 * dot12 - dot01 * dot02) * invDenom;
	
	// Check if point is in triangle
	return ((u > 0) && (v > 0) && (u + v < 1));
}

// the dot product
-(float)dotA:(CGPoint)a b:(CGPoint)b
{
	return (a.x * b.x) + (a.y * b.y);
}

// draws a triangle between the three points and fills it
-(void)drawTriangleA:(CGPoint)a b:(CGPoint)b c:(CGPoint)c
{
	NSBezierPath * tri = [NSBezierPath bezierPath];
	[tri moveToPoint:NSPointFromCGPoint(a)];
	[tri lineToPoint:NSPointFromCGPoint(b)];
	[tri lineToPoint:NSPointFromCGPoint(c)];
	[tri lineToPoint:NSPointFromCGPoint(a)];
	[[NSColor greenColor] set];
	[tri fill];
	[[NSColor blackColor] set];
	[tri stroke];
}


// this is the big distortion calculation
// it takes the 4 known points from the source mesh
// and 3 known points from the destination mesh
// and finds the wanted point in the destination
// ugly method sig, oh well.
-(CGPoint)destinationPointFromSourcePoint:(CGPoint)srcP
										 sourceTrianglePointA:(CGPoint)sa
										 sourceTrianglePointB:(CGPoint)sb
										 sourceTrianglePointC:(CGPoint)sc
								destinationTrianglePointA:(CGPoint)da
								destinationTrianglePointB:(CGPoint)db
								destinationTrianglePointC:(CGPoint)dc
{
	// this algorithm is inspired by the CTouchScreen::cameraToScreenSpace
	// method in touchlib
	//  it is a standard barycentric position calc using the 
	// ration of the areas of the inner triangles formed by the 
	// three vertices and the hit point
	float areaT = [self areaOfTriangleWithPoints:sa b:sb c:sc]; // total area of source
	
	// area1 is the area of the triangle opposite the A vertex, or the area between 2,3,4 and so on
	// find the source area and normalize them
	float area1 = [self areaOfTriangleWithPoints:sb b:sc c:srcP]/areaT;
	float area2 = [self areaOfTriangleWithPoints:sa b:sc c:srcP]/areaT;
	float area3 = [self areaOfTriangleWithPoints:sb b:sa c:srcP]/areaT;
	
	// now using the normalized areas, we can 'walk' the three vectors to
	// get the wanted point in the destination mesh
	CGPoint p1 = CGPointMake(da.x * area1, da.y * area1);
	CGPoint p2 = CGPointMake(db.x * area2, db.y * area2);
	CGPoint p3 = CGPointMake(dc.x * area3, dc.y * area3);
	
	return CGPointMake(p1.x + p2.x + p3.x, p1.y + p2.y + p3.y);
}

-(float)areaOfTriangleWithPoints:(CGPoint)p1 b:(CGPoint)p2 c:(CGPoint)p3
{
	// got this area calculation from
	// http://www.btinternet.com/~se16/hgb/triangle.htm
	
	// the points need to be clockwise for this to work properly
	// instead of requiring that they come in the proper order
	// we will just make sure here
	
	// make the higest point the start
	CGPoint A,B,C;
	A = p1;
	if (p2.y > A.y) A = p2;
	if (p3.y > A.y) A = p3;
	
	// now find the next point that is 'on the right', ie clockwise from A
	// if A is p1, then check the other 2
	if (CGPointEqualToPoint(A, p1)) {
		if (p2.x > p3.x) {
			B = p2;
			C = p3;
		} else {
			B = p3;
			C = p2;
		}
	}
	
	// if A is p2 then .. you get the idea
	if (CGPointEqualToPoint(A, p2)) {
		if (p1.x > p3.x) {
			B = p1;
			C = p3;
		} else {
			B = p3;
			C = p1;
		}
	}
	
	// if A is p3 yadda yadda
	if (CGPointEqualToPoint(A, p3)) {
		if (p1.x > p2.x) {
			B = p1;
			C = p2;
		} else {
			B = p2;
			C = p1;
		}
	}
	
	// do the area calculation
	// what we are basically doing, tho it is not very obvious is
	// we are taking the area of the bounding rectangle and 
	// subtracting the outer right triangles which are easy
	// to find instead of trying to make two right triangles inside the
	// source triangle. if that makes no sense, see the link above
	float f = A.x - B.x;
	float g = A.y - C.y;
	float w = A.y - B.y;
	float v = A.x - C.x;
	return fabs(((f * g)/2.0) - ((v * w)/2.0));
}

@end
*/