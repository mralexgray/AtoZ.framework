//  Created by Alex Gray on 7/29/12.


#define AZSV AZSimpleView

@interface AZSimpleView : NSV

@prop_  BOOL clear, glossy, gradient, checkerboard;
_NA NSC *backgroundColor;

+ (instancetype) vWF:(NSR)f c:(NSC*)c;
+ (instancetype) withFrame:(NSR)f      color:(NSC*)c;
-         (void) setFrameSizePinnedToTopLeft:(NSSZ)size;

@end

@interface AZSimpleGridView : NSView 
//@prop_NA               NSSZ   dimensions;
//@prop_NA               NSUI   rows, columns;
_NA                CAL * grid;

@end


//@interface NSOutlineView (D2Row)
//@prop_NC NSTableRowView*(^rowViewBlock)(id item, int row);
//- (void) setRowViewBlock:(NSTableRowView*(^)(id item, int row))b;
//@end

@interface NSTableRowView (AtoZ)

@prop_RO   NSC * colorForAlternation;
@prop_     NSC * color,
               * altColor;
@prop_RO  BOOL   isAlternate;
@prop_RO    id   object;
@prop_RO  NSUI   index;
@prop_RO  NSOV * enclosingView;
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


∂i!!(1)/Volumes/2T/ServiceData/AtoZ.framework/screenshots/AtoZ.Views.AZSimpleView.ColorTableRowView.pngƒi


  */


@interface ColorTableRowView : NSTableRowView
@property (readonly) id xObjectValue;
@end
