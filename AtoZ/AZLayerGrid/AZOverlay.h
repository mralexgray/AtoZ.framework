//
//  AZOverlayView.h
//  AZOverlayView
//
//  Created by Mikkel Eide Eriksen on 25/01/12.
//  Copyright (c) 2012 Mikkel Eide Eriksen. All rights reserved.
//

#import <Quartz/Quartz.h>

//Model this after NSTableView

#pragma mark -
#pragma mark Overlay View

/** AZState
 TODO
 */
enum {
    AZIdleState,
    AZCreatingState,
    AZModifyingState,
    AZDeletingState
};
typedef NSUInteger AZState;

/** The overlay view.
 
 An AZOverlayView object displays a series of overlays for an image.
 
 An overlay view does not store its own data, instead it retrieves data values as needed from a data source to which it has a weak reference. You should not, therefore, try to directly set data values programmatically in the table view; instead you should modify the values in the data source and allow the changes to be reflected in the table view.
 
 See the AZOverlayViewDelegate informal protocol, which declares methods that return views for rows and columns as well as enable selectable cell editing, custom tracking, custom views and cells for individual columns and rows, and selection control. Additional functionality is also available through the use of delegate methods.
 
 See the AZOverlayViewDataSource informal protocol, declares the methods that an NSTableView object uses to provide and access the contents of its data source object.
 
 
 */
@interface AZOverlayView : IKImageView


/// ---------------------------------
/// @name Setting the Overlay Data Source
/// ---------------------------------
/** Sets the receiver’s data source to a given object.
 
 In a managed memory environment, the receiver maintains a weak reference to the 
 data source.
 
 Setting the data source will implicitly reload the overlay view.
 
 @see NSObject(AZOverlayViewDataSource)
 */
@property (weak) IBOutlet id overlayDataSource;

/// ---------------------------------
/// @name Setting the Overlay Delegate
/// ---------------------------------
/** Sets the receiver’s overlay delegate to a given object.
 
 In a managed memory environment, the receiver maintains a weak reference to the 
 delegate.
 
 Setting the delegate will implicitly reload the overlay view.
 
 @see NSObject(AZOverlayViewDelegate)
 */
@property (weak) IBOutlet id overlayDelegate;

/// ---------------------------------
/// @name Loading Data
/// ---------------------------------
/** Marks the receiver as needing redisplay, so it will reload the data for 
 visible cells and draw the new values.
 
 This method forces redraw of all overlays in the receiver. 
 */
- (void)reloadData;

/// ---------------------------------
/// @name Managing State
/// ---------------------------------
/** Attempt to enter new state.
 
 Discussion about allowances here.
 
 @param theState The state that should be entered.
 @return `YES` if the state could be changed; otherwise `NO`.
 */
- (BOOL)enterState:(AZState)theState;

/// ---------------------------------
/// @name Target-action Behavior
/// ---------------------------------

/** Specifies the target object to receive action messages from the receiver.
 
 In a managed memory environment, the receiver maintains a weak reference to the 
 target.
 
 @see action
 @see doubleAction
 @see rightAction
 @see clickedOverlay
 */
@property (weak) IBOutlet id target;

/** Specifies the message selector sent to the target when the user single-clicks
 an overlay.
 
 @see target
 @see clickedOverlay
 */
@property SEL action;

/** Specifies the message selector sent to the target when the user double-clicks
 an overlay.
 
 @see target
 @see clickedOverlay
 */
@property SEL doubleAction;

/** Specifies the message selector sent to the target when the user right-clicks
 an overlay.
 
 @see target
 @see clickedOverlay
 */
@property SEL rightAction;

/** Specifies the index of the overlay the user clicked to trigger an action message.
 
 @see target
 */
@property (readonly) NSInteger clickedOverlay;

/// ---------------------------------
/// @name Selecting Overlays
/// ---------------------------------

/** Specifies whether receiver should allow overlay selection.
 
 Defaults to `YES`.
 */
@property BOOL allowsOverlaySelection;

/** Specifies whether receiver should allow empty overlay selections.
 
 Defaults to `YES`.
 */
@property BOOL allowsEmptyOverlaySelection;

/** Specifies whether receiver should allow multiple overlay selection.
 
 Defaults to `YES`.
 */
@property BOOL allowsMultipleOverlaySelection;

/** Sets the overlay selection using _indexes_ possibly extending the selection.
 
 @param indexes The indexes to select.
 @param extend `YES` if the selection should be extended, `NO` if the current selection should be changed.
 */
- (void)selectOverlayIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend;

/** Returns the index of the last overlay selected or added to the selection.
 
 @return The index of the last overlay selected or added to the selection, or –1 if no overlay is selected.
 */
- (NSInteger)selectedOverlayIndex;

/** Returns an index set containing the indexes of the selected overlays.
 
 @return An index set containing the indexes of the selected overlays.
 */
- (NSIndexSet *)selectedOverlayIndexes;

/** Returns an array containing the selected overlays.
 
 @return An array containing the selected overlays.
 */
- (NSArray *)selectedOverlays;

/** Deselects the overlay at overlayIndex if it’s selected, regardless of whether empty selection 
 is allowed.
 
 If the indicated overlay was the last overlay selected by the user, the overlay selected
 prior to this one effectively becomes the last selected overlay.
 
 This method doesn’t check with the delegate before changing the selection.
 
 @param overlayIndex The index of the overlay to deselect.
 */
- (void)deselectOverlay:(NSInteger)overlayIndex;

/** Returns the number of selected overlays.
 
 @return The number of selected overlays.
 */
- (NSInteger)numberOfSelectedOverlays;

/** Returns a Boolean value that indicates whether the overlay at a given index is selected.
 
 @param overlayIndex The index of the overlay to test.
 @return `YES` if the overlay at overlayIndex is selected, otherwise `NO`.
 */
- (BOOL)isOverlaySelected:(NSInteger)overlayIndex;

/** Select all overlays.
 
 @param sender Typically the object that sent the message.
 */
- (IBAction)selectAllOverlays:(id)sender;

/** Deselect all overlays.
 
 @param sender Typically the object that sent the message.
 */
- (IBAction)deselectAllOverlays:(id)sender;

/// ---------------------------------
/// @name Setting Display Attributes
/// ---------------------------------

/** The color used to fill an overlay.
 
 Defaults to transparent blue.
 */
@property CGColorRef overlayFillColor;

/** The color used for the border of an overlay.
 
 Defaults to opaque blue.
 */
@property CGColorRef overlayBorderColor;

/** The color used to fill a selected overlay.
 
 Defaults to transparent green.
 */
@property CGColorRef overlaySelectionFillColor;

/** The color used for the border of a selected overlay.
 
 Defaults to opaque green.
 */
@property CGColorRef overlaySelectionBorderColor;

/** Specifies the border width of an overlay.
 
 Defaults to 3 points.
 */
@property CGFloat overlayBorderWidth;

/// ---------------------------------
/// @name Configuring Behavior
/// ---------------------------------

/** Specifies whether receiver should allow creating overlays.
 
 Defaults to `YES`.
 */
@property BOOL allowsCreatingOverlays;

/** Specifies whether receiver should allow modifying overlays.
 
 Defaults to `YES`.
 */
@property BOOL allowsModifyingOverlays;

/** Specifies whether receiver should allow deleting overlays.
 
 Defaults to `YES`.
 */
@property BOOL allowsDeletingOverlays;

/** Specifies whether receiver should allow overlapping overlays. This will affect creating, moving, and resizing overlays.
 
 Defaults to `NO`.
 */
@property BOOL allowsOverlappingOverlays;

@property (strong) id contents;

@end

#pragma mark Notifications

/**
 Posted when an NSOverlayView object's selection changes. The notification object 
 is the overlay view whose selection changed. This notification does not contain 
 a userInfo dictionary.
 */
extern NSString *AZOverlayViewSelectionDidChangeNotification;
extern NSString *AZOverlayViewOverlayDidMoveNotification;
extern NSString *AZOverlayViewOverlayDidResizeNotification;
extern NSString *AZOverlayViewOverlayDidDeleteNotification;

#pragma mark -
#pragma mark Overlay Data Source

/** An informal protocol.
 
 TODO
 
 See [AZOverlayView overlayDataSource]
 */
@interface NSObject (AZOverlayViewDataSource)

/// ---------------------------------
/// @name Required
/// ---------------------------------

/** Returns the number of overlays managed for anOverlayView by the data source object.
 
 An instance of AZOverlayView uses this method to determine how many overlays it should create 
 and display. Your numberOfOverlaysInOverlayView: implementation can be called very frequently, 
 so it must be efficient.
 
 @param anOverlayView The overlay view that sent the message.
 @return The number of overlays in anOverlayView.
 */
- (NSUInteger)numberOfOverlaysInOverlayView:(AZOverlayView *)anOverlayView;


/** Invoked by the overlay view to return the data object associated with the specified index.
 
 @param anOverlayView The overlay view that sent the message.
 @param num The overlay view that sent the message.
 @return An item in the data source at the specified index of the view. Must respond to -(NSRect)rect
 or -(NSRect)rectValue.
 */
- (id)overlayView:(AZOverlayView *)anOverlayView overlayObjectAtIndex:(NSUInteger)num; 

@end 

#pragma mark -
#pragma mark Overlay Delegate

/** An informal protocol.
 
 TODO
 
 See [AZOverlayView overlayDelegate]
 */
@interface NSObject (AZOverlayViewDelegate)


/// ---------------------------------
/// @name Events
/// ---------------------------------

/** Informs the delegate that the overlay view’s selection has changed.
 
 @param aNotification A notification named AZOverlayViewSelectionDidChangeNotification.
 */
- (void)overlayDidMove:(NSNotification *)aNotification;

- (void)overlayDidResize:(NSNotification *)aNotification;

- (void)overlayDidDelete:(NSNotification *)aNotification;

/// ---------------------------------
/// @name Changing Overlays
/// ---------------------------------

/** Invoked by the overlay view when the user has created a new overlay.
 
 The delegate should create an object and expect to return it to the overlay when asked.
 
 @param anOverlayView The overlay view that sent the message.
 @param rect The frame for the new overlay, expressed in the coordinate system of the image.
 */
- (void)overlayView:(AZOverlayView *)anOverlayView didCreateOverlay:(NSRect)rect;

/** Invoked by the overlay view when the user has modified an overlay.
 
 The delegate should change the frame of the stored rect. Alternately, the new frame can be discarded if the frame is not satisfactory due to some constraint defined in the data source.
 
 @param anOverlayView The overlay view that sent the message.
 @param overlayObject The object that was modified.
 @param rect The new frame for the overlay, expressed in the coordinate system of the image.
 
 @see overlayView:didDeleteOverlay:
 */
- (void)overlayView:(AZOverlayView *)anOverlayView didModifyOverlay:(id)overlayObject newRect:(NSRect)rect;

/** Invoked by the overlay view when the user has deleted an overlay.
 
 The data source should delete the object in its storage. To prevent deletion, see [AZOverlayView allowsDeletingOverlays]. Alternately, the data source may choose not to delete the object based on some internal criteria.
 
 @param anOverlayView The overlay view that sent the message.
 @param overlayObject The object that was deleted.
 
 @see overlayView:didModifyOverlay:newRect:
 */
- (void)overlayView:(AZOverlayView *)anOverlayView didDeleteOverlay:(id)overlayObject;


/// ---------------------------------
/// @name Events
/// ---------------------------------

/** Informs the delegate that the overlay view’s selection has changed.
 
 @param aNotification A notification named AZOverlayViewSelectionDidChangeNotification.
 */
- (void)overlaySelectionDidChange:(NSNotification *)aNotification;

@end
