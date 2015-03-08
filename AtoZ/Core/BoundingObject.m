
#import <AtoZ/AtoZ.h>
#import <AtoZ/AtoZGeometry.h>
#import "BoundingObject.h"



#define SHOULDBERECTLIKEALREADY if(EQUAL2ANYOF(self.class,CAL.class,NSV.class,nil)) COMPLAIN;
#define SHOULDBESIZEABLE if(EQUAL2ANYOF(self.class,CAL.class,NSV.class,nil)) COMPLAIN;

@implementation NSIMG   (RectLike) @dynamic bounds; // /*! @todo */ anchorPoint;
- (NSR)      frame              { return AZRectFromSize(self.size); }
- (void)  setFrame:(NSR)f       { [self isSmallerThanRect:f] ? [self scaleToFillSize:f.size] : nil; }
- (void) setOrigin:(CGP)origin  {}
@end

@implementation NSWindow   (RectLike) // @dynamic /*! @todo */ anchorPoint;
//- (NSR) frame; Provided by NWINdow
-  (NSR)      bounds            { return AZRectFromSizeOfRect(self.frame); }

- (void) setFrame:(NSR)f    { [self setContentSize:f.size]; } // display:YES]; } //self.isVisible animate:NO]; }

//- (void)   setBounds:(NSR)b { NSR r = self.frame; }

// [ setFramesize = AZSizeFromRect(b); }

@end
//-  (NSP)    position            { return AZCenter(self.frame); }  // (NSP){self.originX + (self.width/2), self.originY + (self.height/2));
//- (void) setPosition:(NSP)p     { /*! @todo */ NSAssertFail(@"neeed to fix");  }        //	frame.origin = NSMakePoint(midpoint.x - (frame.size.width/2), midpoint.y - (frame.size.height/2));
@implementation CALayer   (RectLike) //@dynamic alignment;

//-  (NSP)     origin {return self.frame.origin; }
//- (void) setOrigin:(NSP)p { self.frame = (NSR){p, self.bounds.size}; }

@end

@implementation NSV   (RectLike) //@dynamic alignment, position,anchorPoint;

//-  (NSP)    origin        {return self.frame.origin; }
//- (void) setOrigin:(NSP)p { self.frame = (NSR){p, self.bounds.size}; }
//-  (NSR) superframe       { return self.superview.bounds; }
@end

@implementation NSIMG (SizeLike)
- (void) setBounds:(NSR)b { self.size = AZSizeFromRect(b); }
-  (NSR)    bounds        { return AZRectFromSize(self.size); }
@end

@concreteprotocol(RectLike) /*! required */ //@dynamic bounds;


//+ (void) initialize {
//
//  unsigned count = 0;
//  Class *classes = ext_copyClassListConformingToProtocol (@protocol(RectLike),&count);
//  NSLog(@"what a delight.. there are %u RectLike Classes!", count);
//  free(classes);
////  for (int i = 0; i < count; i++ ) {
////    Class c = classes[i];
////
//}

- (void) setSuperframe:(NSR)r { SAVE(@selector(superframe), AZVrect(r)); }
-  (NSR) superframe { id x = FETCH;  return x ? [x rV] :

  ISA(self, NSW) ? AZScreenFrameUnderMenu()       : ISA(self,NSV) ? ((NSV*)self).superview.bounds :
  ISA(self,CAL)  ? ((CAL*)self).superlayer.bounds : self.r; }

//-(id) valueForUndefinedKey:(NSS*)key{
//
//  printf("requested %s's undefined key:%s", self.cDesc,key.UTF8String); return nil;
//}
//SetKPfVA(Origin, @"x", @"y") SetKPfVA(X,@"origin") SetKPfVA(Y,@"origin")
//SetKPfVA(Size, @"bounds", @"width", @"height") SetKPfVA(Width, @"size") SetKPfVA(Height, @"size")

-  (CGR)         r          { return self.frame; }
- (void)      setR:(NSR)r   { self.frame = r; }

-  (CGF)         w          { GETALIASF(width);           }  // ALIASES
-  (CGF)         h          { GETALIASF(height);          }
- (void)      setW:(CGF)w   { SETALIAS(width, @(ABS(w))); }
- (void)      setH:(CGF)h   { SETALIAS(height,@(ABS(h))); }

-  (CGF)         x          { return self.r.origin.x; }
-  (CGF)         y          { return self.r.origin.y; }
- (void)      setX:(CGF)x   { self.r = AZRectExceptOriginX(self.r, x); }// (NSP){x, self.y}; }
- (void)      setY:(CGF)y   { self.r = AZRectExceptOriginX(self.r, y); } // self.position = (NSP){self.x, y}; }


- (NSSZ)      size          {	return self.r.size;          }
-  (CGF)     width          { return self.size.width;    }
-  (CGF)    height          { return self.size.height;   }
- (void)   setSize:(NSSZ)sz { self.frame = AZRectExceptSize(self.frame, sz);  }
- (void)  setWidth:(CGF)w   { self.frame = AZRectExceptWide(self.frame, w);   }
- (void) setHeight:(CGF)h   { self.frame = AZRectExceptHigh(self.frame, h);   }

-  (CGF)      midX        { return self.x + (self.h/2.);            }
-  (CGF)      maxX        { return self.x +  self.w;                }
-  (CGF)      midY        { return self.y + (self.h/2.);            }
-  (CGF)      maxY        { return self.y +  self.h;                }
- (void)   setMidX:(CGF)x { self.centerPt = (NSP){x, self.midY};    }
- (void)   setMidY:(CGF)y { self.centerPt = (NSP){self.midX, y};    }
- (void)   setMaxX:(CGF)w { self.x = w - self.width;                }
- (void)   setMaxY:(CGF)h { self.y = h - self.height;               }

-  (CGP)      minXmaxY        { return AZPt(self.x,    self.maxY); }
-  (CGP)      midXmaxY        { return AZPt(self.midX, self.maxY); }
-  (CGP)      maxXmaxY        { return AZPt(self.maxX, self.maxY); }

-  (CGP)      minXmidY        { return AZPt(self.x, self.midY);    }
-  (CGP)      midXmidY        { return AZPt(self.midX, self.midY); }
-  (CGP)      maxXmidY        { return AZPt(self.maxX, self.midY); }

-  (CGP)      minXminY        { return AZPt(self.x,    self.y);     }
-  (CGP)      midXminY        { return AZPt(self.midX, self.y);     }
-  (CGP)      maxXminY        { return AZPt(self.maxX, self.y);     }

-  (CGP)     bOrigin          { return self.bounds.origin; }
-  (CGP)      origin          { return self.minXminY; }
- (void)  setBOrigin:(NSP)o   { self.bounds = AZRectExceptOrigin(self.bounds,o); }
- (void)   setOrigin:(NSP)o   { self.r = AZRectExceptOrigin(self.r,o); }

-  (CGP)      apex            { return self.maxXmaxY; }
-  (CGP)      centerPt        { return self.midXmidY; }
- (void)   setCenterPt:(NSP)c { self.r = AZCenterRectOnPoint(self.r, c);  }

      SYNTHESIZE_ASC_PRIMITIVE_KVO(  position,  setPosition,  NSP)
SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO( alignment, setAlignment, NSAlignmentOptions, ^{}, ^{ })      
SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO( supersize, setSupersize, NSSZ, ^{ if (!AZIsZeroSize(value)) return; 

  value = ISA(self,NSW) ?  ((NSW*)self).screen.frame.size : ISA(self,CAL) ? ((CAL*)self).superlayer.size : 
          ISA(self,NSV) ?  ({NSV* x = ((NSV*)self).superview; x ? x.size : value; }) : value;

},^{})

//- (void) setBounds:(NSRect)bounds   { if ([self isKindOfAnyClass:@[CALayer.class, NSView.class]]) YOU_DONT_BELONG;
//
//  self.frame = AZCenterRectOnPoint(AZRectFromSizeOfRect(bounds), self.centerPt); }
//
//-  (NSR)    bounds                  { if ([self isKindOfAnyClass:@[CALayer.class, NSView.class]]) YOU_DONT_BELONG,NSZeroRect;

//  return AZCenterRectOnPoint(self.frame, self.centerPt); }

- (BOOL)  isLargerThan:(id<RectLike>)r { return self.area  >   r.area; }
- (BOOL) isSmallerThan:(id<RectLike>)r { return self.area   <  r.area; }
- (BOOL)     isRectLke:(id<RectLike>)r { return self.area  ==  r.area; }
- (BOOL)  isLargerThanRect:(NSR)r      { return self.area  >   $AZR(r).area; }
- (BOOL) isSmallerThanRect:(NSR)r      { return self.area   <  $AZR(r).area; }
- (BOOL)        isSameRect:(NSR)r      { return self.area  ==  $AZR(r).area; }


SetKPfVA(InsideEdge, @"frame", @"superframe");

- (AZA) insideEdge {

  AZA oldEdge = ({ id x = FETCH; x ? [x uIV] : AZUnset; }),
      newEdge = AZOutsideEdgeOfRectInRect(self.frame, self.superframe);

  if (oldEdge == newEdge) return oldEdge;
  SAVE(_cmd, @(newEdge)); [self triggerChangeForKeys:@[AZSELSTR]]; return newEdge;
}

- (NSS*) insideEdgeHex { return AZEnumToBinary(self.insideEdge); }

//  if (value != AZAlignUnset) return; if (ISA(self,CAL)) value = AZAlignmentInsideRect(((CAL*)self).frame, self.superframe);
//objswitch(self.class)
//
//  objcase(CAL.class)
//    CAL* _self = (id)self;
//    _self.arMASK       = AZPositionToAutoresizingMask(value);
//    _self.anchorPoint  = AZAnchorPtAligned(value);
//    _self.position     = AZAnchorPointOfActualRect(_self.superlayer.bounds, value);
//  endswitch
//-  (CGR) frame            { return (NSR){self.origin,self.size}; }
//- (void) setFrame:(CGR)f  { self.bounds = AZRectFromSizeOfRect(f); self.origin = f.origin;  }  //(NSR){self.origin,self.size}; }

+ (INST) withDims:(NSN*)d1, ...     { AZVA_ARRAY(d1,dims); return [self withRect:[NSN rectBy:dims]]; }

+ (INST) rectLike:(NSNumber *)d1, ... {

  AZVA_ARRAY(d1, rectParts);
  return [self.class withRect:[NSNumber rectBy:rectParts]];
}

+ (INST) withRect:(NSR)r            { return [self.new wVsfKs:AZVrect(r),@"frame", nil]; }
+ (INST)        x:(CGF)x y:(CGF)y
                w:(CGF)w h:(CGF)h   { return [self withRect:(NSR){x,y,w,h}]; }


-  (CGF)           area    { return self.w * self.h; }
-  (CGF)      perimeter    { return (self.h + self.w) * 2; }
- (NSSZ)  scaleWithSize:(NSSZ)z { self.w *= z.width; self.h *= z.height; return self.size; }
- (NSSZ) resizeWithSize:(NSSZ)z { self.w += z.width; self.h += z.height; return self.size; }

@end

//  NSSZ superRect = NSZeroSize;
//  if (!SameChar([sizes.lastObject objCType], @encode(NSSZ))) {

//        superRect = [sizes.lastObject sizeValue]; [sizes removeLastObject];
//  }
//  id new =
//  if (!AZIsZeroSize(superRect)) [new setSize:superRect forKey:@"supersize"];  return (id)new;

//@pcategoryimplementation(SizeLike, Aliases)
//
//-  (CGF)           w  { GETALIAS(width);      }  // ALIASES
//- (void) setW:(CGF)w  { SETALIAS(width, @(w));  }
//-  (CGF)           h  { GETALIAS(height);     }
//- (void) setH:(CGF)h  { SETALIAS(height,@(h));  }
//@end


//@property         NSP   origin,       // This is inherited, but can be affected by superframe, alignment.
//                        apex;         // origin + size (same as size unless effected)
                        
//@property        NSSZ   size;         // This is inherited, but supplies a ddefault implementation.                                    
//- (void) setMinX:(CGF)x  {	self.frame = AZRectExceptOriginX(self.frame,x); }
//- (void) setMinY:(CGF)y  {	self.frame = AZRectExceptOriginY(self.frame,y); }
//- (void) setBoundsCenter:(NSP)p { self.bounds = AZCenterRectOnPoint(self.bounds,p); }
//- (void)  setFrameCenter:(NSP)p { self.frame  = AZCenterRectOnPoint(self.frame, p); }
//- (void) moveBy:(NSP)distance { if (ISA(self,CAL)||ISA(self,NSV)) self.frame = AZRectOffset(self.frame,distance);   }

//SetKPfVA( Frame,      @"center", @"size", @"position")
//SetKPfVA( Center,     @"frame", @"origin")
//SetKPfVA( Alignment,  @"position", @"frame", @"bounds", @"size", @"orientation")

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


#pragma mark - GRIDLIKE

void _IterateGridWithBlockStep(RNG *r1, RNG *r2, id block, GridIteratorStep step, BOOL sendIndex){

  NSUI idx = 0;
  for (int range1 = r1.location; range1 < r1.max; range1++)
  {
    for (int range2 = r2.location; range2 < r2.max; range2++)
    {
      sendIndex ? ((GridIteratorIdx)block)(range1,range2,idx)
                :    ((GridIterator)block)(range1,range2);
      idx++;
    }
    idx++;
    if (step) step(range1);
  }
}

void      IterateGridWithBlock(RNG *r1, RNG *r2, GridIterator block)    { _IterateGridWithBlockStep(r1, r2, block,nil, NO); }
void IterateGridWithBlockIndex(RNG *r1, RNG *r2, GridIteratorIdx block) { _IterateGridWithBlockStep(r1, r2, block,nil, YES); }

@concreteprotocol(GridLike) @dynamic rows, cols;

- (void) iterateGrid:(GridIterator)b { _IterateGridWithBlockStep($RNG(0,self.rows),$RNG(0,self.cols),b,nil,NO); }

- (void) iterateGridWithIndex:(GridIteratorIdx)b { _IterateGridWithBlockStep($RNG(0,self.rows),$RNG(0,self.cols),b,nil,YES); }


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
- (void) setRows:(NSUInteger)rows { self.dimensions = (NSSZ){self.cols,rows}; }
- (void) setCols:(NSUInteger)cols { self.dimensions = (NSSZ){cols,self.rows}; }

- (NSUInteger)rows { return self.dimensions.height; }
- (NSUInteger)cols { return self.dimensions.width; }

 // if dims not set, but rows and cols are..

//});},^{ ({ self.cols = value.width; self.rows = (NSUI)(value.height); });});

//SYNTHESIZE_ASC_PRIMITIVE_KVO(rows,setRows,NSUI);//,^{({ value = value ?: ((id<GridLike>)self).dimenensions.width;  });},
//                                                     ^{({ self.dimensions = (NSSZ){self.cols,value}; }); });
//SYNTHESIZE_ASC_PRIMITIVE_KVO(cols,setCols,NSUI);//,^{ value = value ?: (NSUI)self.dimenensions.height;  },^{ self.dimensions = (NSSZ){self.rows,value}; });

SetKPfVA(Rows, @"dimensions");
SetKPfVA(Cols, @"dimensions");
//SetKPfVA(Dimensions, @"rows", @"cols");


SYNTHESIZE_ASC_PRIMITIVE_BLOCK_KVO(dimensions,setDimensions,NSSZ, ^{},^{

  if (NSEqualSizes(value, self.dimensions)) return;
  !self.onChangeDimensions ?: self.onChangeDimensions(self.dimensions, value);
})

SYNTHESIZE_ASC_CAST_BLOCK(sizeChanged, setSizeChanged, SizeChange, ^{},^{})

@end


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
