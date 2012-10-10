
#import <AppKit/AppKit.h>

@interface NUVolumesPopUpButton : NSPopUpButton

/**
 
 \brief     Value of the URL associated with the current selection.
 
 */
@property (copy,nonatomic) NSURL *selectedURL;

- (void) addSeparator;
- (void) addItemWithURL:(NSURL*)aURL title:(NSString*) aTitle image:(NSImage*) anImage andAction:(SEL)aSelector forTarget:(id) aTarget;
- (void) removeURL:(NSURL*)aURL;
- (NSMenuItem*) itemWithURL:(NSURL*)aURL;

@end
