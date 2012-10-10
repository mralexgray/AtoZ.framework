
#import <AppKit/AppKit.h>

@interface NUFontFamilyMenu : NSMenu

- (id) initWithTitle:(NSString *)aTitle andFilterPredicate:(NSPredicate*)filter;
- (id) initWithTitle:(NSString *)aTitle;

+ (id) fontFamilyMenuWithFilterPredicate:(NSPredicate*)filter;
+ (id) fontFamilyMenu;

@end
