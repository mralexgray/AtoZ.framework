
#import <AtoZUniversal/AtoZUniversal.h>

#pragma mark - GRIDLIKE   //GridIteratorStep step,

//_Void _IterateGridWithBlockStep(RNG *r1, RNG *r2, id block, BOOL sendIndex){
//
//  __block _UInt overAllIndex = 0;
//
//  [[@(r1.location) to:@(r1.max)] each:^(_Numb range1) {
//    [[@(r2.location) to:@(r2.max)] each:^(_Numb range2) {
//
//      sendIndex ? ((RowColBlkIdx)block)( range1.iV, range2.iV,overAllIndex )
//                :    ((RowColBlk)block)( range1.iV, range2.iV );
//
//      overAllIndex++;
//    }];
//  }];
//}
//    if (step) step(range1);
//  for (int range1 = r1.location; range1 < r1.max; range1++)
//  {
//    for (int range2 = r2.location; range2 < r2.max; range2++)
//    {
//      sendIndex ? ((GridIteratorIdx)block)(range1,range2,idx)
//                :    ((GridIterator)block)(range1,range2);
//      idx++;
//    }
//    idx++;
//  }
//}

//_Void      IterateGridWithBlock(RNG *r1, RNG *r2,    RowColBlk b) { _IterateGridWithBlockStep(r1, r2, b,  NO); }
//_Void IterateGridWithBlockIndex(RNG *r1, RNG *r2, RowColBlkIdx b) { _IterateGridWithBlockStep(r1, r2, b, YES); }
//
//@concreteprotocol(GridLike)

//@dynamic rows, cols;
//
//- _Void_ setRows:_UInt_ r { self.dimensions = _Size_{self.cols,r}; }
//- _Void_ setCols:_UInt_ c { self.dimensions = _Size_{c,self.rows}; }
//
//- _UInt_ rows { return self.dimensions.height; } SetKPfVA( Rows, @"dimensions" );
//- _UInt_ cols { return self.dimensions.width;  } SetKPfVA( Cols, @"dimensions" );
//
//SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO( dimensions, setDimensions, _Size, ^{}, ^{
//
//  (NSEqualSizes(value, self.dimensions) || !self.onChangeDimensions) ?: // else
//                                            self.onChangeDimensions(self.dimensions, value)_
//})
//
//SYNTHESIZE_ASC_OBJ_ASSIGN_BLOCK(colSpan, setColSpan, ^{}, ^{})
//SYNTHESIZE_ASC_OBJ_ASSIGN_BLOCK(rowSpan, setRowSpan, ^{}, ^{})


//- _Void_ iterate:            (RowColBlk)b { _IterateGridWithBlockStep($RNG(self.minX,self.maxX),$RNG(self.minY,self.maxY), b,  NO); }
//- _Void_ iterateWithIndex:(RowColBlkIdx)b { _IterateGridWithBlockStep($RNG(self.minX,self.maxX),$RNG(self.minY,self.maxY), b, YES); }
//
//SYNTHESIZE_ASC_CAST_BLOCK(sizeChanged, setSizeChanged, SizeChange, ^{},^{})
//￭


@implementation NSO (AZAZA) @dynamic owner, hovered, selected, orientation;

      SYNTHESIZE_ASC_PRIMITIVE_KVO(     hovered,     setHovered, BOOL );
SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO(    selected,    setSelected, BOOL ,
                                            ^{},            ^{
    NSLog(@"%@ was %@", self, value ? @"selected." : @"DEselected");
                                            });
      SYNTHESIZE_ASC_PRIMITIVE_KVO(    expanded,    setExpanded, BOOL );
SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO( orientation, setOrientation,  NSUI,
                                            ^{},            ^{});
- (NSO*) owner { return FETCH; }
- (void) setOwner:(NSO*)o { SAVEREFERENCE(o); }
@end

#define WARN_NONCONFORMANT(p) if (![self conformsToProtocol:@protocol(p)]) printf("Warning: %s doesn't \"technically\" conform to %s", [self cDesc], NSStringFromProtocol(@protocol(p)))

@implementation NSObject (Drawable)

SYNTHESIZE_ASC_CAST         ( drawObjectBlock, setDrawObjectBlock, ObjRectBlock);
SYNTHESIZE_ASC_PRIMITIVE_KVO(    spanExpanded,    setSpanExpanded,             CGF);
SYNTHESIZE_ASC_PRIMITIVE_KVO(   spanCollapsed,   setSpanCollapsed,             CGF);

- (void) setSpanCollapsed:(CGF)c 
                 expanded:(CGF)x  { self.spanCollapsed = c; self.spanExpanded = x; }
-  (CGF) span                     { return self.expanded ? self.spanExpanded : self.spanCollapsed; }
-  (CGF) expansionDelta           { CGF delta = self.spanExpanded - self.spanCollapsed; return self.expanded ? delta : -delta; }

@end

@concreteprotocol(Drawable) SetKPfVA( Span, @"spanCollapsed", @"spanExpanded", @"expanded") @end



//^{ ({
//  NSSZ truesize; if(!NSEqualSizes(value,truesize=(NSSZ){self.rows, self.cols})) [self setDimensions:value = truesize]; });},

//+ (BOOL) instancesRespondToSelector:(SEL)s { return YES; }

/*
- (void) setValue:(id)v forUndefinedKey:(NSString *)k { AZLOGCMD;

  [k isEqualToString:@"rows"] ? [self setDimensions:(NSSZ){self.cols,[v unsignedIntegerValue]}] :
  [k isEqualToString:@"cols"] ? [self setDimensions:(NSSZ){[v unsignedIntegerValue], self.rows}] : ({
    struct objc_super superInfo = { self, [self superclass]  };
    objc_msgSendSuper(&superInfo, _cmd, v, k); });
}

- (id) valueForUndefinedKey:(NSString *)k { AZLOGCMD; // AZSTACKTRACE;

  return  SameString(k, @"rows") ? @(self.dimensions.height) :
          SameString(k, @"cols") ? @(self.dimensions.width)  :
          ({
    struct objc_super superInfo = { self, [self superclass]  };
    objc_msgSendSuper(&superInfo, _cmd, k); });
}
*/

 // if dims not set, but rows and cols are..

//});},^{ ({ self.cols = value.width; self.rows = (NSUI)(value.height); });});

//SYNTHESIZE_ASC_PRIMITIVE_KVO(rows,setRows,NSUI);//,^{({ value = value ?: ((id<GridLike>)self).dimenensions.width;  });},
//                                                     ^{({ self.dimensions = (NSSZ){self.cols,value}; }); });
//SYNTHESIZE_ASC_PRIMITIVE_KVO(cols,setCols,NSUI);//,^{ value = value ?: (NSUI)self.dimenensions.height;  },^{ self.dimensions = (NSSZ){self.rows,value}; });

//SetKPfVA(Dimensions, @"rows", @"cols");




//- (void)   setOriginX:(CGF)x  {	self.frameMinX = x; }
//- (void)   setOriginY:(CGF)y  {	self.frameMinY = y; }

//                            CONFORMS(BoundingObject) ? ISA(self,NSW) ? ((NSW*)self).frame.size.width  : ((id<BoundingObject>)self).bounds.size.width : self.size.width;   }
//                              CONFORMS(BoundingObject) ? ISA(self,NSW) ? [((NSW*)self) setFrame:AZRectExceptWide(((NSW*)self).frame, w) display:YES animate:YES] : [(id<BoundingObject>)self setBoundsWidth:w]  : [self setSize:(NSSZ){w, self.height}]; }
//-  (CGF)    height        { return CONFORMS(BoundingObject) ? ISA(self,NSW) ? ((NSW*)self).frame.size.height : ((id<BoundingObject>)self).bounds.size.height : self.size.height; }
//b- (void) setHeight:(CGF)h { CONFORMS(BoundingObject) ? ISA(self,NSW) ? [((NSW*)self) setFrame:AZRectExceptHigh(((NSW*)self).frame, h) display:YES animate:YES] : [(id<BoundingObject>)self setBoundsHeight:h] : [self setSize:(NSSZ){self.width,  h}]; }
//- (BOOL) isVertical  { return self.orientation == AZOrientVertical; }
//- (void) setVertical:(BOOL)x { [self sV:@(AZOrientVertical) fK:@"orientation"]; }

//-  (NSR) frame              { COMPLAIN; }
//- (void) setFrame:(NSR)r    { COMPLAIN; }
//-  (NSR) bounds             { COMPLAIN; }
//- (void) setBounds:(NSR)r   { COMPLAIN; }
//-  (NSP) position           { COMPLAIN; }
//- (void) setPosition:(NSP)p { COMPLAIN; }

//- (void) w:(CGF)x h:(CGF)y        { self.boundsWidth = x;  self.boundsHeight = y;     }

//-  (CGF) positionX  { return self.position.x; }
//-  (CGF) positionY  { return self.position.y; }
//- (void) setPositionX:(CGF)x  { self.position = (NSP){x, self.positionY}; }
//- (void) setPositionY:(CGF)y  { self.position = (NSP){self.positionX, y}; }

//-  (CGF) boundsWidth  {	return self.bounds.size.width;  }
//-  (CGF) boundsHeight {	return self.bounds.size.height; }
//-  (CGF) frameWidth   {	return self.frame.size.width;   }
//-  (CGF) frameHeight  {	return self.frame.size.height;  }

//- (void)   setFrameSize:(CGSZ)b   { self.frame  = AZRectExceptSize(self.frame,b);  }
//- (void)  setFrameWidth:(CGF)w    { self.frame  = AZRectExceptWide(self.frame,w);  }
//- (void) setFrameHeight:(CGF)h    { self.frame  = AZRectExceptHigh(self.frame,h);  }
//
//- (void)   setBoundsSize:(CGSZ)b  { self.bounds = AZRectExceptSize(self.bounds,b); }
//- (void)  setBoundsWidth:(CGF)w   { self.bounds = AZRectExceptWide(self.bounds,w); }
//- (void) setBoundsHeight:(CGF)h   {	self.bounds = AZRectExceptHigh(self.bounds,h); }

//+ (NSSet*) keyPathsForValuesAffectingBoundsHeight { return NSSET(@"bounds"); }

/* ORIGIN 

-  (CGP) boundsOrigin {	return self.bounds.origin;  }
-  (CGP) frameOrigin  { return self.frame.origin;   }
//-  (CGF) originX      {	return self.frameMinX; }
//-  (CGF) originY      {	return self.frameMinY; }

- (void)  setFrameOrigin:(CGP)o { self.frame  = AZRectExceptOrigin(self.frame, o); }
- (void) setBoundsOrigin:(CGP)o {	self.bounds = AZRectExceptOrigin(self.bounds,o); }

/ * CENTER * /

-  (CGP) boundsCenter { return AZCenterOfRect(self.bounds); }
-  (CGP) frameCenter  { return AZCenterOfRect(self.frame);  }

- (void) setBoundsCenter:(NSP)p { self.bounds = AZCenterRectOnPoint(self.bounds,p); }
- (void)  setFrameCenter:(NSP)p { self.frame  = AZCenterRectOnPoint(self.frame, p); }
*/
//- (void) setFrameMaxY:(CGF)y  { self.frameMinY = y - self.height;               }
//-  (CGF) boundsMinX { return NSMinX(self.bounds);  }
//-  (CGF) boundsMidX { return NSMidX(self.bounds);  }
//-  (CGF) boundsMaxX {	return NSMaxX(self.bounds);  }
//-  (CGF) boundsMinY {	return NSMinY(self.bounds);  }
//-  (CGF) boundsMidY {	return NSMidY(self.bounds);  }
//-  (CGF) boundsMaxY {	return NSMaxY(self.bounds);  }
//-  (NSR) bounds             { return AZRectFromSizeOfRect(self.frame); }
//- (void) setBounds:(NSR)b   { self.frame = AZRectExceptSize(self.frame, b.size); }



/*
- (NSW*) window        { return self.hostView.window;

	return [[NSW.appWindow vFKP:@"contentView.layer"] filterOne:^BOOL(id object) {return [[object sublayersRecursive] containsObject:self]; }]; * /
}   
-  (NSR) superframe    { return self.superlayer.bounds; }

 [[x backingStore] isNotEqualTo:self.storage]) { //    objc_setAssociatedObject(x,__backingStore,self.storage,OBJC_ASSOCIATION_ASSIGN);
[x triggerKVO:@"backingStore" block:^(id _self) {  ASSIGN_WEAK(_self,backingStore,self.storage); }];

    objc_setAssociatedObject(x,@selector(backingStore),self.storage,OBJC_ASSOCIATION_ASSIGN);
    [x b:@"index" tO:self wKP:@"storage" t:^id(id value) { return @([value indexOfObject:x]); }];

    [x sV:self.storage fK:@"backingStore"];
    [self addObserverForKeyPath:@"storage" task:^(id<ArrayLike>sender) {
      [x sV:@([sender.storage indexOfObject:x]) fK:@"index"];
      NSUI idx = !sender.storage.count ? 0 : sender.storage.count - 1;
      [x sV:@(idx) fK:@"indexMax"];
    }];
  }

    [x b:@"index" tO:self.storage wKP:nil t:^id(id value) { return @([value containsObject:x] ?[value indexOfObject:x] : NSNotFound); }];
    [x addObserver:x forKeyPath:@"backingStore.@count" options:0 context:NULL];
  x[] = self.storage;
  objc_setAssociatedObject(x,@selector(backingStore),self.storage,OBJC_ASSOCIATION_ASSIGN);
  class_addProtocol([x class],@protocol(Indexed));
  class_addMethod([x class], @selector(backingStore), _index(id _self, SEL _cmd))
  setBackingStore(x,self.storage);
  return (id<Indexed>)x;

- (void) setCenter:(NSP)center  {
	[self setFrameOrigin:NSMakePoint(floorf(center.x - (NSWidth([self bounds])) / 2),
												floorf(center.y - (NSHeight([self bounds])) / 2))];
}
-  (NSP) center                 {
	return NSMakePoint(floorf(self.bounds.origin.x + (self.bounds.size.width / 2)),
							 floorf(self.bounds.origin.y + (self.bounds.size.height / 2)));

//    return AZCenterOfRect ([self frame]);
}
-  (NSP) getCenterOnFrame       {
	return NSMakePoint(floorf(self.frame.origin.x + (self.frame.size.width / 2)),
							 floorf(self.frame.origin.y + (self.frame.size.height / 2)));
}
- (void) maximize{
	NSR r = [self.window.contentView bounds];
	self.autoresizesSubviews = YES;
	self.autoresizingMask = NSSIZEABLE;
	[self setFrame:r];
	[self setNeedsDisplay:YES];
	
}
-  (NSR) centerRect:(NSR)aRect onPoint:(NSP)pt {

  CGF height = NSHeight(aRect), width = NSWidth(aRect);

	return NSMakeRect(pt.x-(width/2.0), pt.y - (height/2.0), width, height);
}

- (void) centerOriginInBounds { [self centerOriginInRect:[self bounds]];  }
- (void) centerOriginInFrame { [self centerOriginInRect:[self convertRect:[self frame] fromView:[self superview]]];  }
- (void) centerOriginInRect:(NSR) aRect  { [self translateOriginToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect))]; }
- (void) slideDown    {
	
	NSR newViewFrame;
	if ([self valueForKeyPath:@"dictionary.visibleRect"] ) {
		newViewFrame = 	[[self valueForKeyPath:@"dictionary.visibleRect"]rectValue];
	} else {
		/ 
    
    
    *		id aView = [ @[ self, [ self superview], [self window]] filterOne:^BOOL(id object) {
		 return  [object respondsToSelector:@selector(orientation)] ? YES : NO ;
		 }];
		 if  (aView) { 	AZOrient b = (AZOrient)[aView valueForKey:@"orientation"];
		 //		NSLog(@"computed orentation  %ld", b);
		 NSLog(@"computed orentation %@", AZOrientName[b]);
		 }
  * /
  
      		newViewFrame = AZMakeRectFromSize([[self superview]frame].size);
		//		AZRectVerticallyOffsetBy( [self frame], -[self frame].size.height);
	}
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"frame"];
	[animation setFromValue:AZVrect([self frame])];
	[animation setToValue:	AZVrect(newViewFrame)];
	
	//	CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
	//	[fader setFromValue:@0.f];
	//	[fader setToValue:@1.f];
	[self setAnimations:	@{ @"frame" : animation}];
	
	[[self animator] setFrame:newViewFrame];
}
*/

/*
-  (CGP)    frameTopLeftPt         {	return (NSP){ self.frameMinX, self.frameMinY}; }
- (void) setFrameTopLeftPt: (CGP)p {	self.frameMinX = p.x; self.frameMinY = p.y;    }
-  (CGP)    frameTopMidPt          {	return (NSP){ self.frameMidX, self.frameMinY}; }
- (void) setFrameTopMidPt:  (CGP)p { self.frameMidX = p.x;	self.frameMinY = p.y;    }
-  (CGP)    frameTopRightPt        {	return (NSP){ self.frameMaxX, self.frameMinY}; }
- (void) setFrameTopRightPt:(CGP)p {	self.frameMaxX = p.x;	self.frameMinY = p.y;    }
-  (CGP)    frameMidRightPt        {	return (NSP){ self.frameMaxX, self.frameMidY}; }
- (void) setFrameMidRightPt:(CGP)p {	self.frameMaxX = p.x;	self.frameMidY = p.y;    }
-  (CGP)    frameBotRightPt        {	return (NSP){ self.frameMaxX, self.frameMaxY}; }
- (void) setFrameBotRightPt:(CGP)p {	self.frameMaxX = p.x;	self.frameMaxY = p.y;    }
-  (CGP)    frameBotMidPt          {	return (NSP){ self.frameMidX, self.frameMaxY}; }
- (void) setFrameBotMidPt:  (CGP)p { self.frameMidX = p.x;	self.frameMaxY = p.y;    }
-  (CGP)    frameBotLeftPt         {	return (NSP){ self.frameMinX, self.frameMaxY}; }
- (void) setFrameBotLeftPt: (CGP)p {	self.frameMinX = p.x; self.frameMaxY = p.y;    }
-  (CGP)    frameMidLeftPt         { return (NSP){ self.frameMinX, self.frameMidY}; }
- (void) setFrameMidLeftPt: (CGP)p { self.frameMinX = p.x; self.frameMidY = p.y;    }

-  (CGP)    boundsTopLeftPt            {	return CGPointMake(self.boundsMinX, self.boundsMinY);   }
- (void) setBoundsTopLeftPt:   (CGP)p  { self.boundsMinX = p.x; self.boundsMinY = p.y;           }
-  (CGP)    boundsTopMidPt             {	return CGPointMake(self.boundsMidX, self.boundsMinY);   }
- (void) setBoundsTopMidPt:    (CGP)p  { self.boundsMidX = p.x; self.boundsMinY = p.y;           }
-  (CGP)    boundsTopRightPt           {	return CGPointMake(self.boundsMaxX, self.boundsMinY);   }
- (void) setBoundsTopRightPt:  (CGP)p  { self.boundsMaxX = p.x; self.boundsMinY = p.y;           }
-  (CGP)    boundsMidRightPt           {	return CGPointMake(self.boundsMaxX, self.boundsMidY);   }
- (void) setBoundsMidRightPt:  (CGP)p  { self.boundsMaxX = p.x; self.boundsMidY = p.y;           }
-  (CGP)    boundsBotRightPt           {	return CGPointMake(self.boundsMaxX, self.boundsMaxY);   }
- (void) setBoundsBotRightPt:  (CGP)p  {	self.boundsMaxX = p.x; self.boundsMaxY = p.y;           }
-  (CGP)    boundsBotMidPt             {	return CGPointMake(self.boundsMidX, self.boundsMaxY);   }
- (void) setBoundsBotMidPt:    (CGP)p  {	self.boundsMidX = p.x; self.boundsMaxY = p.y;           }
-  (CGP)    boundsBotLeftPt            {	return CGPointMake(self.boundsMinX, self.boundsMaxY);   }
- (void) setBoundsBotLeftPt:   (CGP)p  {	self.boundsMinX = p.x; self.boundsMaxY = p.y;           }
-  (CGP)    boundsMidLeftPt            { return CGPointMake(self.boundsMinX, self.boundsMidY);   }
- (void) setBoundsMidLeftPt:   (CGP)p  {	self.boundsMinX = p.x; self.boundsMidY = p.y;           }
*/

/*
/ *    NSVIEW METHODS * /

-  (CGF) leftEdge {	return [self frame].origin.x ;	}

-  (CGF) rightEdge {	return [self frame].origin.x + [self width] ;	}

-  (CGF) centerX {	return ([self frame].origin.x + [self width]/2) ;	}

- (void) setLeftEdge:(CGF)t {	NSR frame = [self frame] ;	frame.origin.x = t ;	[self setFrame:frame] ;	}

- (void) setRightEdge:(CGF)t {	NSR frame = [self frame] ;	frame.origin.x = t - [self width] ;	[self setFrame:frame];	}

- (void) setCenterX:(CGF)t {	float center = [self centerX] ;	float adjustment = t - center ;
	NSR frame = [self frame] ;	frame.origin.x += adjustment ;	[self setFrame:frame];
}

-  (CGF) bottom   {	return self.frame.origin.y ;	}
-  (CGF) top      {	return self.frame.origin.y + self.height;	}
-  (CGF) centerY  {	return (self.frame.origin.y + (self.height/2)); }

- (void) setBot:(CGF)t {	NSR frame = [self frame] ;	frame.origin.y = t ;	[self setFrame:frame] ;	}
- (void) setTop:(CGF)t {	NSR frame = [self frame] ;	frame.origin.y = t - [self height] ;	[self setFrame:frame] ;	}

- (void) setCenterY:(CGF)t {		float center = [self centerY] ;		float adjustment = t - center ;
	NSR frame = [self frame] ;	frame.origin.y += adjustment ;		[self setFrame:frame] ;
}



@implementation CALayer (BoundingObject)
-  (CGF)  perimeter{  return ([self bounds].size.height + [self bounds].size.width) * 2.; }
@end
@implementation NSView  (BoundingObject)  @end




- (void) setSize:(NSSZ)z {

	NSR frame = self.frame ;
	frame.size.width  = size.width ;
	frame.size.height = size.height ;
	self.frame = frame;
}
- (NSSZ) frameSize             { return self.frame.size; }

-  (CGF)    frameX                {	return self.frame.origin.x; }
- (void) setFrameX:     (CGF)x    { self.frame = AZRectExceptOriginX(self.frame,x); }
-  (CGF)    frameY                {	return self.frame.origin.y; }
- (void) setFrameY:     (CGF)y    { self.frame = AZRectExceptOriginY(self.frame,y); }

-  (CGF) boundsX  {	return self.bounds.origin.x; }
- (void) setBoundsX:(CGF)boundsX { CGR bounds = self.bounds; bounds.origin.x = boundsX;	self.bounds = bounds; }
-  (CGF) boundsY  {	return self.bounds.origin.y;}
- (void) setBoundsY:(CGF)boundsY { CGR bounds = self.bounds; bounds.origin.y = boundsY; self.bounds = bounds; }
-  (CGF) boundsWidth      { return self.bounds.size.width; }
-  (CGF) boundsHeight           { return self.bounds.size.height; }
-  (CGF)    frameWidth            {	return self.frame.size.width; }
- (void) setBoundsMinX:   (CGF)x  {	self.boundsOrigin = (NSP){x, self.boundsMinY}; }
- (void) setBoundsMidX:   (CGF)x  { self.boundsMinX = (x - (self.width / 2.0f));   }
- (void) setBoundsMaxX:   (CGF)x  {	self.boundsMinX = (x - self.boundsWidth); }
- (void) setBoundsMinY:(CGF)boundsMinY   {	self.boundsY = boundsMinY; }
- (void) setBoundsMidY:(CGF)boundsMidY   { self.boundsY = (boundsMidY - (self.boundsHeight / 2.0f)); }
- (void) setBoundsMaxY:(CGF)boundsMaxY   {	self.boundsY = (boundsMaxY - self.boundsHeight); }
-  (CGF)    frameHeight           {	return self.frame.size.height; }



- (void) setWidth:(CGF)w {
	if (w != self.width) [self setFrame:AZRectExceptWide(self.frame,w)], ISA(self,NSV) ? [[(NSV*)self superview] setNeedsDisplay:YES]: nil;
//	NSR frame = [self frame] ;
//	frame.size.width = t ;
//	[self setFrame:frame] ;
//   [[self superview] setNeedsDisplay:YES];
}
- (void) setHeight:(CGF)t 	{
//self.frame = AZRectExceptHigh(self.frame, t); [[self superview] setNeedsDisplay:YES];}
	if (t != self.height) [self setFrame:AZRectExceptHigh(self.frame,t)], ISA(self,NSV) ? [[(NSV*)self superview] setNeedsDisplay:YES]: nil;
}
-  (CGF) originX { return self.frame.origin.x; }
-  (CGF) originY { return self.frame.origin.y; }
- (void) setOriginX:(CGF)x {

	if (x != self.originX) [self setFrame:AZRectExceptOriginX(self.frame,x)], ISA(self,NSV) ? [[(NSV*)self superview] setNeedsDisplay:YES]: nil;
//    if (aFloat != [self originX]) {
//        NSR frame = [self frame];
//        frame.origin.x = aFloat;
//        [self setFrame:frame];
//        [self setNeedsDisplay:YES];
//    }
}
- (void) setOriginY:(CGF)y {
	if (y != self.originY) [self setFrame: AZRectExceptOriginY(self.frame,y)], ISA(self,NSV) ? [[(NSV*)self superview] setNeedsDisplay:YES]: nil;

@implementation NSO (ExtendWithProtocol)

NSSet *RXConcreteProtocolsNamesOfProtocols(Protocol **protocols, unsigned int protocolCount) { Protocol *protocol;

	NSMutableSet *protocolNames = NSMutableSet.set;
	for(unsigned int i = 0; i < protocolCount; i++) {
    [protocolNames addObject: NSStringFromProtocol(protocol = protocols[i])];
    unsigned int count;
				Protocol **protocols;
				Protocol *aProtocol;
				protocols = protocol_copyProtocolList(protocol, &count);
				for (int i = 0; i < count; i++) {
					aProtocol = protocols[i];
					[incorporatedProtocolNames addObject:NSStringFromProtocol(aProtocol)];
				}

    unsigned int *nestedProtocolCount = 0;
    Protocol *nestedProtocols = protocol_copyProtocolList(protocol,&nestedProtocolCount);
    [protocolNames unionSet: RXConcreteProtocolsNamesOfProtocols(&nestedProtocols, nestedProtocolCount)];
    free(nestedProtocols);
	}
	return protocolNames;
}

+(NSSet*) implementedProtocolNames {
	unsigned int protocolCount = 0;
	Protocol **protocols = class_copyProtocolList([self class], &protocolCount);
	NSSet *protocolNames = RXConcreteProtocolsNamesOfProtocols(protocols, protocolCount);
	free(protocols);

	return protocolNames;
}


void RXConcreteProtocolExtendClassWithProtocol(Class self, Class targetClass, Protocol *protocol) {
	struct RXConcreteProtocolMethodList {
		unsigned int count;
		struct objc_method_description *methods;
		BOOL required;
		BOOL instance;
	} methodLists[4] = {
		{0, NULL, NO, NO},
		{0, NULL, YES, NO},
		{0, NULL, NO, YES},
		{0, NULL, YES, YES}
	};

	for(uint8_t i = 0; i < 4; i++) {
		struct RXConcreteProtocolMethodList methodList = methodLists[i];
		methodList.methods = protocol_copyMethodDescriptionList(protocol, methodList.required, methodList.instance, &methodList.count);
		for(unsigned int j = 0; j < methodList.count; j++) {
			struct objc_method_description methodDescription = methodList.methods[j];
			Method method = methodList.instance? class_getInstanceMethod(self, methodDescription.name) : class_getClassMethod(self, methodDescription.name);
			class_addMethod(methodList.instance? targetClass : object_getClass(targetClass), methodDescription.name, method_getImplementation(method), methodDescription.types); // this skips methods that already exist on the target class
		}
		free(methodList.methods);
	}

	class_addProtocol(targetClass, protocol);
}

+(void)extendClass:(Class)targetClass {
	for(NSString *protocolName in [self implementedProtocolNames]) {
		Protocol *protocol = NSProtocolFromString(protocolName);

		RXConcreteProtocolExtendClassWithProtocol(self, targetClass, protocol);
	}
}

@end

const char __storageConst;
NSMA*__storage(id _self){  return ({ id x; if(!(x = objc_getAssociatedObject(_self,__storageConst))) objc_setAssociatedObject(_self, __storageConst, NSMA.new, OBJC_ASSOCIATION_RETAIN_NONATOMIC); x; }); }

void setBackingStore(id _self, id backer) { Protocol *p = @protocol(Indexed); [
  objc_setAssociatedObject(_self,@selector(backingStore),backer,OBJC_ASSOCIATION_ASSIGN);
  [_self addProperty:@"index" getter:^id(id _self, NSString *key) {
    
  } setter:]
  struct objc_method *myMethod;
  myMethod.method_name = sel_registerName("index");
//  myMethod.method_imp  = _index;

  NSLog($(@"%@  BEFORE: %@ ", _self, StringFromBOOL([_self conformsToProtocol:p])));
  class_addProtocol([_self class],p);
  NSLog($(@"%@  AFTER: %@  FULL:%@ ", _self, StringFromBOOL([_self implementsProtocol:p]),StringFromBOOL([_self implementsFullProtocol:p])));
  self.backingStore ? [self.backingStore indexOfObject:self] : NSNotFound; }

NSUI _index ( id _self, SEL _cmd) { id x = [_self backingStore]; return x ? [x indexOfObject:_self] : NSNotFound; }
NSUI _indexMax ( id _self, SEL _cmd){   NSUI max = NSNotFound; id x; return !(x = [_self backingStore]) ? max : (!(max = [x count])) ?: max - 1; }
SYNTHESIZE_ASC_PRIMITIVE_KVO(indexMax,setIndexMax,NSUI);
SYNTHESIZE_ASC_PRIMITIVE_KVO(index,setIndex,NSUI);
-   (id) backingStore { id x = self[@"__backingStore"]; return x ?: (self[@"__backingStore"] = NSMA.new); }
@implementation NSO (DrawableObject)                      @end
@interface NSO (DrawableObject) @property CGF spanExpanded, spanCollapsed; @property (CP) DrawObjectBlock drawBlock; @end

 _index(self, _cmd); } // id x = [self backingStore]; return x ? [x indexOfObject:self] : NSNotFound; }
- (NSUI) indexMax { return ![self.backingStore count] ?: [[self backingStore] count] -1; }//NSUI max = NSNotFound; id x; return !(x = [self backingStore]) ? max : (!(max = [x count])) ?: max - 1; }
@concreteprotocol(Indexed)
@end
SYNTHESIZE_ASC_OBJ_LAZY(getter, class)(, setter)(storage, NSMA);
SYNTHESIZE_ASC_CAST(onInsert, setOnInsert,MutationBlock);

@prop_RO NSMA<Indexed>*storage;



@pcategoryimplementation(ArrayLike,FastEnumeration)
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
  return [((id<ArrayLike>)self).storage countByEnumeratingWithState:state objects:buffer count:len];
}
@end
- (void) setWidth: (CGF)t 				{ NSR f = self.frame;	f.size.width  	= t; 	[self setFrame:f display:YES animate:YES] ;	}
- (void) setHeight:(CGF)t				{ NSR f = self.frame;	f.size.height 	= t; 	[self setFrame:f display:YES animate:YES] ; 	}
*/

//@property NSR   bounds, frame; @property  CGP   position, anchorPoint;  NSSZ   supersize;
//- (NSR) bounds {[NSA arrayWithObjects:(id), ..., nil] COMPLAIN; }  /*! @note should be OK! */
//void d(){ NSV* c  = NSV.new; v.bounds; }

//@concreteprotocol(PointLike) /*! required */ -  (NSP) origin { COMPLAIN; }  /*! @note should be OK! */

//@concreteprotocol(SizeLike) /*! required */ 
