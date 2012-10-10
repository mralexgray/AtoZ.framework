/**
 
 NUSegmentedView
 
 \brief    Simulates a segmented control using a view. 
 
 \details  NUSegmentedView is not a subclass of NSControl so it does not offer
           many of the facilities of NSControl. What it does provide is a means
           to display an array of "buttons" or "tabs" or "sheets" for which
           drawing can be customized and the contents bound. 
 
           The class handles mouse tracking and clicks and leaves drawing to
           the user through the use of dedicated methods. Each button is
           represented by a NUSegmentInfo object. Setting the selected 
           property of the info object to YES has the same effect as clicking
           on it. It will work even if selectionIndexes is bounds. 
 
 \author     Eric Methot
 \date       April 2012
 
 \copyright  Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <Cocoa/Cocoa.h>


// -----------------------------------------------------------------------------
   #pragma mark - NUSegmentInfo
// -----------------------------------------------------------------------------

@interface NUSegmentInfo :NSObject

- (id) initWithObject:(id)anObject;
+ (id) segmentWithObject:(id)anObject;
+ (id) segment;

@property (copy)   NSString *name;
@property (copy)   NSString *label;
@property (retain) NSImage  *image;

@property (retain) id representedObject;

@property (assign) BOOL enabled;
@property (assign) BOOL active;
@property (assign) BOOL pushed;
@property (assign) BOOL selected;
@property (assign) BOOL selectable;

@property (copy) void(^selectAction)(NUSegmentInfo* segment);

/// Block to call when the button rect has been clicked.
@property (copy) void(^buttonAction)(NUSegmentInfo* segment);

@end



// -----------------------------------------------------------------------------
   #pragma mark - NUSegmentedView
// -----------------------------------------------------------------------------

@interface NUSegmentedView : NSView {
    CGRect    *_selectRects;
    CGRect    *_actionRects;
    CGRect    *_imageRects;
    CGRect    *_textRects;
    CGRect    *_badgeRects;
}


// -----------------------------------------------------------------------------
   #pragma mark Properties
// -----------------------------------------------------------------------------

/** 
 
 \brief   Indicates whether many segments may be in the selected state at once.
 
 \details The default value is NO, which means that clicking on a segment will 
          select it and deselect the previously selected segment. When set to 
          YES then clicking on a segment simply toggles its selection state. 
          The default value is NO.
 */
@property (assign) BOOL allowsMultipleSelection;


/**
 
 \brief   Indicates whether multiple selection is even possible.
 
 \details When YES then the user can set allowsMultipleSelection to any value.
          When NO then allowsMultipleSelection is always NO even if the user
          tries to set it to YES.
 
 */
@property (readonly) BOOL supportsMultipleSelection;


/** 
 
 \brief   Indicates whether the selection may be empty.
 
 \details When multiple selection is allowed empty selection is often a 
          possibility because it often means that "selection" means toggling
          the state of a button. When multiple selection is NO often empty
          selection should not be possible because "selection" means "choosing"
          one amongst many. By default this value is NO.
 
 */
@property (readonly) BOOL supportsEmptySelection;


/**
 
 \brief   Array of button state wrapers.
 
 \details Often this value is bound to the arrangedObjects of some array
          controller containing the NUSegmentInfo objects.
 
 */
@property (copy,nonatomic) NSArray *segments;

/**
   
 \brief   Where within the view bounds do the segments appear.
 
 \details If the segments span the entire width of the view view then the 
          property can be ignored. Otherwise can be used to position the 
          individual segment rects. You should use one of the following values:
 
          NSLeftTextAlignment      = Hug the left side of the view,
          NSRightTextAlignment     = Hug the right side of the view,
          NSCenterTextAlignment    = Center the segments in the view,
          NSJustifiedTextAlignment = Make the segments span the entire view
 
          The default value is NSCenterTextAlignment.
 */
@property (assign,nonatomic) int alignment;

/**
 
 \brief     Returns or sets the index of the selected segment.
 
 \details   Setting a value for `selectedIndex` effectively ignores 
            `allowMultipleSelection` by assuming its value is NO. So changing
            the index will always lead to having only one selected index.
            Setting the value to NSNotFound has the side-effect of changing
            selectionIndexes to an empty index set. Use `selectedIndexes` 
            for multiple selection. 
 
            Setting the value to an index that is out of range has the effect
            of de-selecting all segments but will not raise an exception.
 
 \return    Index of the selected segment or the first selected segment in the 
            case where multiple segments are selected.
             
 */
@property (assign,nonatomic) NSUInteger selectionIndex;


/**
 
 \brief     Returns or sets the selected object, which is always a NUSegmentInfo.
 
 \details   Setting a value for `selectedObject` is effectively the same as
            calling setSeletionIndex: with the index of the segment. Sitting 
            `selectedObject` to `nil` has the side-effect of changing 
            `selectionIndex` to NSNotFound and `selectionIndexes` to an empty
            index set.
 
 \return    Returns the first selected segment or nil if there is no selection.
 
 */
@property (retain,nonatomic) NUSegmentInfo* selectedObject;

/**
 
 \brief     Returns or sets the indexes of selected segments.
 
 \details   Setting a value for `selectedIndexes` effectively ignores 
            `allowMultipleSelection` by assuming its value is YES. So changing
            the indexes can lead to having many selected segments.
            use `selectedIndex` for single segment selections.
 
            Indexes that are out of range are ignored and will not raise an exception.
 
 \return    Indexes of the selected indexes and will never be nil.
 
 */
@property (retain,nonatomic) NSIndexSet *selectionIndexes;


/**
 
 \brief     Returns or sets the indexes of selected segments, which is always an array of NUSegmentInfo.
 
 \details   Setting a value for `selectedObjects` is effectively the same as
            calling setSelectionIndexes with the indexes for the objects.
            Setting selectedObjects to nil is equivalent to setting it to an
            or an empty array and has the side-effect of changing selectionIndex 
            to NSNotFound and `selectionIndexes` to an empty index set.
 
 \return    Array of selected segments and will never be nil.
 
 */
@property (retain,nonatomic) NSArray *selectedObjects;

/**
 
 \brief     Use this segment width when the alignment is not `NSJustifiedTextAlignment`.

 \details   This value can be used to create fixed-width segments. If this
            value is zero then the width of each segment will be equal to the 
            height of the view multiplied by 1.618 (golden ration) to make 
            nice looking rectangles. The default value is 0.

            Depending on the alignment either the origin, the view center or 
            topRight corner will remain fixed relative to the super view.
 
 */
@property (assign) double segmentWidth;





// -----------------------------------------------------------------------------
   #pragma mark Drawing
// -----------------------------------------------------------------------------

/**
 
 Sets the value of the various rectangles that describe a segment.
 
 \details   There are many rectangles that affect the drawing and behavior of 
            a segment: `selectRects`, `actionRects`, `imageRects`, `textRects` 
            and `badgeRect` are c-arrays of CGRect structures that are created
            for this purpose. The size of these arrays is equal to the number
            of segments.
 
            `selectRects` establishes the rectangular region in which the
            segment is drawn and for which it will responnd to clicks with
            its selectAction.
 
            `actionRects` is optional and establishes another region for which
            the segment will respond to clicks but using its button action
            instead of the selectAction.
 
            `imageRects` are the regions in which the `image` of each segment
            can be drawn. If the rectangle is CGRectNull then no image is drawn.
 
            `textRects` are the regions in which the `name` of each segment
            can be drawn. If the rectangle is CGRectNull then no text is drawn.
 
            `badgeRect` are other regions where a badge image can be drawn.
            If the rectangle is CGRectNull then no badge is drawn.
 
            The default implementation will generate the following rects
            when the alignment is `NSJustifiedTextAlignment`.
            
            +--------+--------------- Select ---------------------+--------+
            |        |                                            |        |
            | Image  | Text                                       | Action |
            |        |                                            |        |
            +--------+--------------------------------------------+--------+

            It will generate the following rects when alignment is something else.

            +--- Select ---+
            |              |
            |  Image/Text  |
            |              |
            +--------------+
 
            You should override this method to compute the rects as needed 
            but you would normally not need to call this method. 
            Call `updateRects` instead.
 
 */
- (void) updateSegmentRects;


/// Calls updateCachedRects and performs other maintenance tasks.
- (void) updateRects;



/// Draws the background of the entire view. The default behavior is to draw 
/// a gray background.
- (void) drawBackground;

/// Draws an individual segment at the specified index.
- (void) drawSegment:(id)segment atIndex:(NSUInteger)index;

/// Draws over the segments if needed. The default behavior does nothing.
- (void) drawOverlay;

/// Returns the selection rect for the segment at the specified index or CGRectNull.
- (CGRect) selectionRectAtIndex:(NSInteger)index;

/// Returns the action rect for the segment at the specified index or CGRectNull.
- (CGRect) actionRectAtIndex:(NSInteger)index;

@end

