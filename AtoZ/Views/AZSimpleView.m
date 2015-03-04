

#import <AtoZ/AtoZ.h>
#import "AZSimpleView.h"

#pragma mark - TableRowView ... see Id in IB of "NSTableViewRowViewKey"


@implementation NSTableRowView (AtoZ)

SYNTHESIZE_ASC_OBJ_BLOCK(color, setColor, ^{ if (!value) value = AtoZ.globalPalette.nextNormalObject ?:  self.backgroundColor; }, ^{})
SYNTHESIZE_ASC_OBJ_BLOCK(altColor, setAltColor, ^{ if (!value) value = self.color.darker.darker.darker; }, ^{})

- (NSC*) colorForAlternation { return self.isAlternate ? self.altColor: self.color; }

-(BOOL) isAlternate { return [self.backgroundColor isEqualTo:NSC.controlBackgroundColor]; }

- object { return /**ISA(self.enclosingView, NSOV) ?*/ [self objectAtColumn:0]; }

- objectAtColumn:(int)c               { NSTableView * table = self.enclosingView;

  id rowObj = ISA(table, NSOV) ? [(NSOV*)table itemAtRow:self.index] : [[self viewAtColumn:c] objectValue];

  return rowObj;
    //[table.delegate tableView:table objectValueForTableColumn: row:(NSInteger)row {

//   : self objectValue;

//  return !rowObj ? nil : [rowObj respondsToStringThenDo:@"representedObject"] ?: [rowObj respondsToStringThenDo:@"objectValue"] ?: rowObj;

}
- (NSUI) index         { return [self.enclosingView.subviews indexOfObject:self]; }
- (NSV*) enclosingView {

  NSView* ov = self.superview;  																								 // Sneaky object finder
	while (ov  && ![ov isKindOfAnyClass:@[NSOV.class,NSTV.class]] && !!ov.superview)  ov = ov.superview;
	return ov;	
}
@end

@implementation ColorTableRowView  @synthesize  xObjectValue = _objectValue;

- (id) initWithFrame:(NSR)f { SUPERINITWITHFRAME(f);

  self.zLayer.delegate = self;
  self.zLayer.borderWidth = 5;
  self.zLayer.borderColor = cgGREY;
//  self.layer.needsDisplay  = YES;
  return self;
}

//- (void) setRepresentedObject:(id)x {
//
//  [self.layer bind:@"colored" toObject:self.representedObject withKeyPath:@"selected" options:nil];
//  [super setRepresentedObject:x];
//}
- (id<CAAction>) actionForLayer:(CALayer*)l forKey:(NSString*)e {

  if (!SameString(@"colored", e)) return nil;
  CABA * ca = [CABA animationWithKeyPath:kBGC];  //		NSLog(@"self.x.parent::%@", self.x.parent);
  NSC  * c1 =	$RGBA(.78,.77,0,1),
       * c2	= $RGBA(.78,.26,0,1);
		ca.fromValue 	= self.selected ? idCG(c1) : idCG(c2);
		ca.toValue 		= self.selected ? idCG(c2) : idCG(c1);
		ca.duration 	= 2;
		ca.fillMode 	= kCAFillModeForwards;
		ca.removedOnCompletion  = NO;
		return ca;
}
//(self.x.parent == nil) ?[NSColor colorWithDeviceHue:0.168 saturation:0.942 brightness:0.612 alpha:1.000]:
//- (void) drawBackgroundInRect { }
@end


@implementation AZSimpleView

+ (instancetype) vWF:(NSR)f c:(NSC*)c { return [[self.class viewWithFrame:f] wVsfKs:c,@"backgroundColor", nil]; }

+ (instancetype)withFrame:(NSRect)frame color:(NSC*)c	{

return [[self.class.alloc initWithFrame:frame] wVsfKs:c,@"backgroundColor", nil];

}

- (id)initWithFrame:(NSRect)f	{ 	if (!(self = [super initWithFrame:f])) return nil;

  self.arMASK                       = NSViewHeightSizable|NSViewWidthSizable;
  _backgroundColor                  = RANDOMGRAY;
	_glossy = _checkerboard = _clear  = NO;
  self.needsDisplayForKeys          = @[@"backgroundColor"]; return self;
}

-(void)	setFrameSizePinnedToTopLeft: (NSSize)siz	{

	NSR	theBox     = self.frame;
	NSP	topLeft 	 = theBox.origin;
	topLeft.y 	  += theBox.size.height;
	[self.superview setNeedsDisplayInRect: theBox];	// Inval old box.
	theBox.size 	 = siz;
	topLeft.y 	  -= siz.height;
	theBox.origin  = topLeft;
	self.frame     = theBox; [self setNeedsDisplay: YES];
}

- (void) drawRect:(NSRect)rect {

	if (_glossy) {
//		DrawGlossGradient([AZGRAPHICSCTXgraphicsPort],self.backgroundColor, [self bounds]);
		return;
	}
	else if (_gradient) {
		NSBezierPath *p =[NSBezierPath bezierPathWithRect: [self bounds]];// cornerRadius:0];
		[p fillGradientFrom:_backgroundColor.darker.darker.darker to:_backgroundColor.brighter.brighter angle:270];
		return;
	}
	else if (_checkerboard)	[[NSColor checkerboardWithFirstColor:_backgroundColor
												 secondColor:_backgroundColor.contrastingForegroundColor squareWidth:10]set];
	else [_clear ? CLEAR :  _backgroundColor ? _backgroundColor : RANDOMCOLOR set];
	NSRectFill( [self bounds] );

//		[[NSColor colorWithCalibratedRed:0.f green:0.5f blue:0.f alpha:0.5f] set];
//		[AZGRAPHICSCTX
//		 setCompositingOperation:NSCompositeClear];
//		[[NSBezierPath bezierPathWithRect:rect] fill];
//	}
//	else	{	[self.backgroundColor ? self.backgroundColor : [NSColor clearColor]   set];		NSRectFill(rect);	}

}
@end
@implementation AZSimpleGridView
//@synthesize //rows, cols,
//  grid,
//  dimensions;

- (void) viewWillMoveToWindow:(NSWindow *)newWindow {

	self.wantsLayer = YES;
	self.grid = self.layer;

	self.grid.backgroundColor = cgRANDOMCOLOR;
	self.dimensions = (NSSize){8,8};
	self.grid.layoutManager = self;
  [self.layer disableResizeActions];

//  [self setSizeChanged:^(NSSize oldSz, NSSize newSz) {

//    NSArray *subs = self.layer.sublayers;
//    [self iterateGrid:^(NSInteger r1, NSInteger r2) {
//
//      CALayer *cell = [CALayer layer];
//			cell.borderColor = cgGREY;
//			cell.borderWidth = 1;
//			cell.cornerRadius = 4;
//			cell.name = [NSString stringWithFormat:@"%u@%u", c, r];
//
//
//    }];
//  }];
}

//-(void) setDimensions:(NSSize)dims {
//	dimensions = dims;
//  rows = dimensions.width; 	columns = _dimensions.height;

//	for (int r = 0; r < rows; r++) {
//		for (int c = 0; c < columns; c++) {
//			CALayer *cell = [CALayer layer];
//			cell.borderColor = cgGREY;
//			cell.borderWidth = 1;
//			cell.cornerRadius = 4;
//			cell.name = [NSString stringWithFormat:@"%u@%u", c, r];
//			cell.constraints = @[[CAConstraint constraintWithAttribute: kCAConstraintWidth
//										relativeTo: @"superlayer"
//										 attribute: kCAConstraintWidth
//											 scale: 1.0 / columns  offset: 0],
//			 [CAConstraint constraintWithAttribute: kCAConstraintHeight
//										relativeTo: @"superlayer"
//										 attribute: kCAConstraintHeight
//											 scale: 1.0 / rows   offset: 0],
//			 [CAConstraint constraintWithAttribute: kCAConstraintMinX
//										relativeTo: @"superlayer"
//										 attribute: kCAConstraintMaxX
//											 scale: c / (float)columns   offset: 0],
//			 [CAConstraint constraintWithAttribute: kCAConstraintMinY
//										relativeTo: @"superlayer"
//										 attribute: kCAConstraintMaxY
//											 scale: r / (float)rows	offset: 0]];
//			[grid addSublayer:cell];
//		}
//	}
//}
- (void) layoutSublayersOfLayer:(CALayer *)layer {

  
//  			cell.constraints = @[[CAConstraint constraintWithAttribute: kCAConstraintWidth
//										relativeTo: @"superlayer"
//										 attribute: kCAConstraintWidth
//											 scale: 1.0 / columns  offset: 0],
//			 [CAConstraint constraintWithAttribute: kCAConstraintHeight
//										relativeTo: @"superlayer"
//										 attribute: kCAConstraintHeight
//											 scale: 1.0 / rows   offset: 0],
//			 [CAConstraint constraintWithAttribute: kCAConstraintMinX
//										relativeTo: @"superlayer"
//										 attribute: kCAConstraintMaxX
//											 scale: c / (float)columns   offset: 0],
//			 [CAConstraint constraintWithAttribute: kCAConstraintMinY
//										relativeTo: @"superlayer"
//										 attribute: kCAConstraintMaxY
//											 scale: r / (float)rows	offset: 0]];


}
@end
//
//@interface @implementation (D2Row)
//- (NSTableRowView*(^)(id item, int row)) row
//- (void) setRowViewBlock:(NSTableRowView*(^)(id item, int row))b;
//@end
//

//  ImageTextCell.m   SofaControl  Created by Martin Kahr on 10.10.06.
//migratedf®om ~/Downloads/TreeTest/TreeTest.xcodeproj

#pragma mark - AZOutlineView


@implementation  AZOutlineView

-(void) outlineView:(NSOutlineView *)outlineView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {


}
- (NSTableRowView*) outlineView:(NSOutlineView*)v rowViewForItem:(id)x {

    NSTableRowView* z = [v makeViewWithIdentifier:@"row" owner:v];
     z = [z isKindOfClass:ColorTableRowView.class] ? z : ({

  ColorTableRowView *a = [ColorTableRowView.alloc initWithFrame:NSZeroRect]; a.identifier = @"row"; a; });
  [z setColor:[AtoZ.globalPalette normal:[v rowForItem:x]]];
  return z;

}

//- (void) awakeFromNib 									{ self.delegate = self; AZLOGCMD; }

//+ (Class) cellClass 										{ return ImageTextCell.class;  	}

- (void) highlightSelectionInClipRect:	(NSR)r	{

	NSRNG visibleRows = [self rowsInRect:r];
	NSUI  selectedRow	= self.selectedRowIndexes.firstIndex;
	while (selectedRow != NSNotFound)
	{
		if (selectedRow != -1 && NSLocationInRange(selectedRow, visibleRows))
			// determine if this is a group row or not
		[((NSTreeNode*)[self itemAtRow:selectedRow]).isLeaf ? GRAY2 : ORANGE set];
		NSRectFill([self rectOfRow:selectedRow]);
		selectedRow = [self.selectedRowIndexes indexGreaterThanIndex:selectedRow];
	}
}

//- (void) drawBackgroundInClipRect:(NSR)f { static NSC* r; r = r ?: RANDOMCOLOR;
//    [r.gradient drawInRect:f angle:-90]; }

//- (void) drawRow:(NSI)r clipRect:		(NSR)c	{
//	//	[self objectValueForTableColumn:(NSTableColumn *) byItem:(id) acceptDrop:(id<NSDraggingInfo>) item:(id) childIndex:(NSInteger)]
//	NSRectFillWithColor([self rectOfRow:r], RANDOMCOLOR);
//	[super drawRow:r clipRect:c];
//}
/*
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {

	NSTableCellView *view = nil;
	NSTreeNode *node = item;
	XX(node.representedObject);
	[[node vFKP:@"children"] each:^(id sender) {
		[(NSO*)[sender representedObject]log];
	}];
	//	if ([node.representedObject isKindOfClass:[Group class]]) {
	//    view = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
	//} else {
	//    view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
	//}
//return view;
	view  = [self makeViewWithIdentifier:@"" owner:self];
	NSRect col = [self rectOfColumn:[self.tableColumns indexOfObject:tableColumn]];
	NSInteger row = [self rowForItem:item];
	NSRect cellRect = NSUnionRect([self rectOfRow:row],col);
	AZSimpleView*v = [AZSimpleView withFrame:AZRectFromSize(cellRect.size) color:RANDOMCOLOR];
	[view addSubview:v];
	return view;
}
*/


- (BOOL) outlineView:(NSOV*)v isGroupItem:(id)i 	{ return !((NSTreeNode*)i).isLeaf; 	}
- (void) outlineView:(NSOV*)v willDisplayOutlineCell:(id)c forTableColumn:(NSTC*)t item:(id)item{
	AZLOGCMD;
}
//- (void)highlightSelectionInClipRect:(NSRect)clipRect
//{
//  NSRange visibleRows = [self rowsInRect:clipRect];
//
//  NSUInteger selectedRow = self.selectedRowIndexes.firstIndex;
//  while (selectedRow != NSNotFound)
//	{
//		 if (selectedRow == -1 || !NSLocationInRange(selectedRow, visibleRows)) {
//			selectedRow = [self.selectedRowIndexes indexGreaterThanIndex:selectedRow]; continue;
//		 }
//
//		 // determine if this is a group row or not
//	  ([self.delegate respondsToSelector:@selector(outlineView:isGroupItem:)]
//	  ? [self.delegate outlineView:self isGroupItem:[self itemAtRow:selectedRow]]
//	  : NO) ? [GRAY3 set] : [RED set];
//
//	  NSRectFill([self rectOfRow:selectedRow]);
//	  selectedRow = [self.selectedRowIndexes indexGreaterThanIndex:selectedRow];
//  } 
//}
@end

@implementation ImageTextCell

//-   (id) copyWithZone:(NSZone*)z {  ImageTextCell *d = [super copyWithZone:z]; return d;	}

- (void) highlight:(BOOL)f withFrame:(NSR)r inView:(NSV*)v	{	AZLOGCMD;

	NSLog(@"represented in hightlight:  %@", self.objectValue);
//	NSRectFillWithColor(r, [self highlightColorWithFrame:r inView:v]);
}
- (NSC*) highlightColorWithFrame:	 (NSR)r inView:(NSV*)v	{  return nil; }  // Returning nil circumvents the standard row highlighting.
- (void) drawWithFrame:			 		 (NSR)r inView:(NSV*)v	{

	//	if ([self.objectValue ISKINDA: NSS.class])
//	[super drawWithFrame:r inView:v];
	if ([self.objectValue ISKINDA: NSC.class])
		NSRectFillWithColor(r, YELLOW);
	//		[[(NSColor*)self. x  objectValue gradient]drawInRect:rect angle:-90];
}
- (void) drawInteriorWithFrame:		 (NSR)r inView:(NSV*)v	{
//	NSLog(@"rep: %@, objV: %@", self.representedObject, self.objectValue);

	if ([self.objectValue ISKINDA: NSIMG.class])
		//	NSR cell = NSUnionRect(cellFrame,controlView.bounds);
		[(NSIMG*)self.objectValue drawInRect:AZRectExceptWide(r, r.size.height)];
	else if ([self.objectValue ISKINDA:NSS.class])
		[self.objectValue	drawAtPoint:AZPointOffset(r.origin,(NSP){r.size.height + 10, r.size.height/2})
							withAttributes:@{	NSForegroundColorAttributeName: BLACK,
					 NSFontAttributeName:AtoZ.controlFont, NSFontSizeAttribute:@33}];


	/*
	 NSO* data = self.representedObject; if (!data) return;
	 BOOL elementDisabled; __block NSAT* xform;
	 NSRectFillWithColor(cellFrame, self.isHighlighted ? self.color.darker : [self.color.brighter alpha:.4]);

	 if ([(NSS*)[data vFK:_secondaryTextKeyPath] endsWith:@"(null)"]) [self setSelectable:NO];
	 elementDisabled   = NO;
	 //	LOG_EXPR(cellFrame);
	 //	LOG_EXPR(controlView.frame);
	 //	LOG_EXPR(controlView.visibleRect);
	 //	[zNL log];
	 [[self.representedObject vFK:@"name"] //;// displayName]
	 drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y)
	 withAttributes:@{
	 NSForegroundColorAttributeName : self.isHighlighted ? RED : elementDisabled ? YELLOW : GRAY9,
	 NSFontAttributeName : AtoZ.controlFont}];

	 [[self.representedObject vFK:_secondaryTextKeyPath]
	 drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y+cellFrame.size.height/2)
	 withAttributes:@{	NSForegroundColorAttributeName: self.isHighlighted ? PINK : GRAY4,
	 NSFontAttributeName: [NSFont systemFontOfSize:10]}];
	 //	[NSGraphicsContext state:^{
	 CGF yOffset = cellFrame.origin.y;
	 //		if (controlView.isFlipped) {
	 //			xform = [NSAffineTransform transform];
	 //			[xform translateXBy:0.0 yBy: cellFrame.size.height];
	 //			[xform scaleXBy:1.0 yBy:-1.0];
	 //			[xform concat];
	 //			yOffset = 0-cellFrame.origin.y;
	 //		}

	 //		NSImageInterpolation interpolation = AZGRAPHICSCTX.imageInterpolation;
	 //		AZGRAPHICSCTX.imageInterpolation = NSImageInterpolationHigh;
	 //		NSImage *icon;
	 //		[icon =
	 [(NSIMG*)[self vFK:@"icon"]  // [self.dataDelegate iconForCell:self data: data]
	 drawInRect:(NSRect) {cellFrame.origin.x+5,yOffset+3,cellFrame.size.height-6, cellFrame.size.height-6}];
	 //			fromRect:NSZeroRect//AZRectFromSize(icon.size)
	 //			operation:NSCompositeSourceOver
	 //			fraction:1.0];

	 //		AZGRAPHICSCTX.imageInterpolation = interpolation;

	 //	}];
	 */
}
- (NSC*) color 															{ return RED;} //  [[self vFK:@"icon"]quantized]; }

@end


//- (id) valueForUndefinedKey:(NSS*)key {
//	NSD* d = [NSD dictionaryWithObjects:@[_iconKeyPath, _primaryTextKeyPath, _secondaryTextKeyPath]
//	  									 forKeys:@[@"icon", @"string", @"substring"]];
//	return [d.allKeys containsObject:key] ? [self.representedObject vFK:d[key]]
//													  : [super valueForUndefinedKey:key];
//}


#pragma mark Delegate methods
/**
 - (NSImage*) iconForCell: (ImageTextCell*) cell data: (NSObject*) data {
 if (iconKeyPath) {
 return [data valueForKeyPath: iconKeyPath];
 }
 return nil;
 }
 - (NSString*) primaryTextForCell: (ImageTextCell*) cell data: (NSObject*) data {
 if (primaryTextKeyPath) {
 return [data valueForKeyPath: primaryTextKeyPath];
 }
 return nil;
 }
 - (NSString*) secondaryTextForCell: (ImageTextCell*) cell data: (NSObject*) data {
 if (primaryTextKeyPath) {
 return [data valueForKeyPath: secondaryTextKeyPath];
 }
 return nil;
 }
 */
// setDataDelegate: dataDelegate], cell;
//	cell->delegate = nil;
// in case there is no delegate we try to resolve values by using key paths
//- (id) dataDelegate {  return dataDelegate ?: self; }
//- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//    if ([self isHighlighted]) {
//        // Draw highlight background here
//    }
//
//    [super drawInteriorWithFrame:cellFrame inView:controlView];
//}

//TODO: Selection with gradient and selection color in white with shadow
// check out http://www.cocoadev.com/index.pl?NSTableView
//	if ([[self dataDelegate] respondsToSelector: @selector(disabledForCell:data:)])	elementDisabled = [[self dataDelegate] disabledForCell: self data: data];
//	 [NSColor alternateSelectedControlTextColor] : (elementDisabled? [NSColor disabledControlTextColor] : [NSColor textColor]);

//PRIMARY
//	[[self.dataDelegate primaryTextForCell:self data: data]
//	NSColor* secondaryColor =
//	[self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor disabledControlTextColor];

//	[[[self dataDelegate] secondaryTextForCell:self data: data]

