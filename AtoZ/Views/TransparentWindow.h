//
//  TransparentWindow.h
//  RoundedFloatingPanel
//
//  Created by Matt Gemmell on Thu Jan 08 2004.
//  <http://iratescotsman.com/>
//

@import AppKit.NSWindow;

@interface TransparentWindow : NSWindow
{
	NSPoint initialLocation;
	BOOL flipRight;
	double duration;
	NSWindow *mAnimationWindow;// окна, создаваемые для анимации
	NSWindow *mTargetWindow;
}
// разворот activeWindow окна к targetWindow
- (void) flip:(NSWindow *)activeWindow to:(NSWindow *)targetWindow;

@property BOOL flipRight; // YES -поворот вправо
@property double duration; // время анимации, по умолчанию 2.0

@property  NSRect upFrame, downFrame;
@property BOOL draggable;
@end
