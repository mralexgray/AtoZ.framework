//  Created by Alex Gray on 7/29/12.


#define AZSV AZSimpleView

@interface AZSimpleView : NSV

_PR _IsIt  clear
__         glossy
__         gradient
__         checkerboard ___

_NA _Colr  backgroundColor ___

+ _Kind_       vWF __Rect_ r     c __Colr_ c ___
+ _Kind_ withFrame __Rect_ r color __Colr_ c ___
_VD    setFrameSizePinnedToTopLeft __Size_ z ___

@end

@interface AZSimpleGridView : NSView 
//_NA               NSSZ   dimensions;
//_NA               NSUI   rows, columns;
_NA                CAL * grid;

@end


//@interface NSOutlineView (D2Row)
//_NC NSTableRowView*(^rowViewBlock)(id item, int row);
//- (void) setRowViewBlock:(NSTableRowView*(^)(id item, int row))b;
//@end

@interface NSTableRowView (AtoZ)

_RO  NSC * colorForAlternation;
@prop_     NSC * color,
               * altColor;
_RO BOOL   isAlternate;
_RO   id   object;
_RO NSUI   index;
_RO NSOV * enclosingView;
@end

@interface 		ImageTextCell : NSTableCellView
@end

@interface AZOutlineView : NSOutlineView <NSOutlineViewDelegate>
//@propvoid(^rowBlock)(NSTableRowView*);
@end

/*! #@note This should get made in - (NSV*) tableView:(NSTV*)t rowViewForRow:(NSI)r;  OR
                                   - (NSTableRowView*) outlineView:(NSOV*)o rowViewForItem:(id)i

  ColorTableRowView *rowView = [t makeViewWithIdentifier:NSTableViewRowViewKey owner:self];
  
OR @see NSTableViewRowViewKey

 "Set the identifier of the @c NSTableViewRow subclass to @c NSTableViewRowViewKey
  Dequeuing will then be automatic."

  Apple says ... Specifying a Custom Row View In a NIB
  The NSTableViewRowViewKey is the key that NSView-based table view instances use to identify the NIB containing the template row view. You can specify a custom row view (without any code) by associating this key with the appropriate NIB name in Interface Builder.

  @param NSTableViewRowViewKey The key associated with the identifier in the NIB containing the template row view.


∂i!!(1)/sd/AtoZ.framework/screenshots/AtoZ.Views.AZSimpleView.ColorTableRowView.pngƒi


  */


@interface ColorTableRowView : NSTableRowView
@property (readonly) id xObjectValue;
@end
