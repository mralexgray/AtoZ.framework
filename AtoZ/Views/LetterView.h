#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface LetterView : NSView {
	CATextLayer *letterLayer;
	NSString *theLetter;
	CATextLayer *extraLayer;
	NSString *extraInfo;
}

@property (retain) CATextLayer *letterLayer;
@property (copy) NSString *theLetter;
@property (retain) CATextLayer *extraLayer;
@property (copy) NSString *extraInfo;

@end
