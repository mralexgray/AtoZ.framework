
#import <Foundation/Foundation.h>
#import "NUSegmentedView.h"

@class NUUserInterface;

typedef void(^NUScenarioBlock)(void);

@interface NUUserInterface : NSObject

// -----------------------------------------------------------------------------
   #pragma mark Designated Initializer
// -----------------------------------------------------------------------------

- (id) initWithRunLoop:(NSRunLoop*)runLoop;
+ (id) userInterfaceWithRunLoop:(NSRunLoop*)runLoop;
+ (id) userInterfaceWithCurrentRunLoop;

/// Are we recording live action?
@property (assign) BOOL interactive;

/// Are we recording at all?
@property (assign) BOOL recording;

/// Do doMouseXXX methods generate live NSEvents?
@property (assign) BOOL silent;

/// Speedup playback by this amount. Defaults to 1.0.
@property (assign) double speedup;

/// Total duration of the recorded user interaction.
@property (readonly) NSTimeInterval duration;

/// Duration of meta-events doXXX where no duration parameter is supplied.
@property (assign) NSTimeInterval defaultDuration;



// -----------------------------------------------------------------------------
   #pragma mark Helper Functions
// -----------------------------------------------------------------------------

/// Converts a point in a view to cocoa screen coordinate. Flip to get carbon coordinates.
- (NSPoint) convertPointToScreen:(CGPoint)p fromView:(NSView*)aView flipY:(BOOL)shouldFlipY;

/// Converts a rect in a view to cocoa screen coordinates.
- (NSRect) convertRectToScreen:(CGRect)r fromView:(NSView*)aView;

/// Returns an AXUIElementRef for the given view from which we can use the accessibility API.
- (AXUIElementRef) AXElementForView:(NSView*)aView;


/// Runs the script using the applications event loop.
/// This would be used within an application.
+ (void) runScript:(void(^)(NUUserInterface *userInterface))script;

/// Creates an event loop and runs the script within that event loop.
/// This would be used within unit tests.
+ (void) runUsingEventLoopForModalWindow:(NSWindow*)aWindow script:(void(^)(NUUserInterface *userInterface))script;


// -----------------------------------------------------------------------------
   #pragma mark Programmatic Recording
// -----------------------------------------------------------------------------

- (void) recordEvent:(NSEvent*)event withDuration:(NSTimeInterval)duration;

- (void) doMouseEventOfType:(NSEventType)type atScreenLocation:(NSPoint)p withModifier:(int)modFlags duration:(NSTimeInterval)secs;
- (void) doMouseEventOfType:(NSEventType)type inView:(NSView*)viewA atPosition:(NSPoint)p withModifier:(int)modFlags duration:(NSTimeInterval)secs;
- (void) doMouseDragFromView:(NSView*)viewA atPosition:(NSPoint)a toView:(NSView*)viewB atPosition:(NSPoint)b withModifier:(int)modFlags duration:(NSTimeInterval)secs;
- (void) doMouseMoveToView:(NSView*)viewA atPosition:(NSPoint)a duration:(NSTimeInterval)secs;
- (void) doMouseClickInView:(NSView*)viewA atPosition:(NSPoint)a duration:(NSTimeInterval)secs;
- (void) doMouseDoubleClickInView:(NSView*)viewA atPosition:(NSPoint)a duration:(NSTimeInterval)secs;
- (void) pause:(NSTimeInterval)secs;

- (void) playbackWithCompletionBlock:(NUScenarioBlock)completionBlock;
- (void) clear;

- (void) doButtonClick:(NSButton*)button;
- (void) doButtonDoubleClick:(NSButton*)button;
- (void) doMenu:(NSMenu*)menu clickItemPath:(NSString*)menuPath;
- (void) doPopup:(NSPopUpButton*)popup clickMenuWithPath:(NSString*)menuPath;
- (void) doTextField:(NSTextField*)textfiled writeText:(NSString*)text;
- (void) doTextView:(NSTextField*)textfiled writeText:(NSString*)text;
- (void) doSegmentedView:(NUSegmentedView*)view clickSegmentWithTitle:(NSString*)title;
- (void) doSendKeys:(NSString*)chars withModifierFlags:(int)modFlags;
- (void) doUndo:(NSInteger)ntimes;
- (void) doRedo:(NSInteger)ntimes;


// -----------------------------------------------------------------------------
   #pragma mark Interactive Recording
// -----------------------------------------------------------------------------

- (void) recordInteractiveEvent:(NSEvent*)event;

- (IBAction)startInteractiveRecording:(id)sender;
- (IBAction)stopInteractiveRecording:(id)sender;
- (IBAction)toggleInteractiveRecording:(id)sender;
- (IBAction)playback:(id)sender;

@end
