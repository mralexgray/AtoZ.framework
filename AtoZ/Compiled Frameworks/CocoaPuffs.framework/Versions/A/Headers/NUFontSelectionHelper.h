
#import <Foundation/Foundation.h>

@interface NUFontSelectionHelper : NSObject

@property (retain,nonatomic) NSFont *font;

@property (retain,nonatomic) NSString *fontFamily;
@property (assign,nonatomic) float     fontSize;
@property (assign,nonatomic) BOOL      isBold;
@property (assign,nonatomic) BOOL      isItalic;
@property (readonly)         BOOL      fontInFamilyExistsInBold;
@property (readonly)         BOOL      fontInFamilyExistsInItalic;

@end
