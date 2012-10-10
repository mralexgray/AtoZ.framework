
#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

enum {
	kGlyphForTabRight       = 0x21E5,
	kGlyphForTabLeft        = 0x21E4,
	kGlyphForCommand        = kCommandUnicode,
	kGlyphForOption         = kOptionUnicode,
	kGlyphForShift          = kShiftUnicode,
	kGlyphForControl        = kControlUnicode,
	kGlyphForReturn         = 0x2305,
	kGlyphForReturnR2L      = 0x21A9,
	kGlyphForDeleteLeft     = 0x232B,
	kGlyphForDeleteRight    = 0x2326,
	kGlyphForPadClear       = 0x2327,
    kGlyphForLeftArrow      = 0x2190,
	kGlyphForRightArrow     = 0x2192,
	kGlyphForUpArrow        = 0x2191,
	kGlyphForDownArrow      = 0x2193,
    kGlyphForPageDown       = 0x21DF,
	kGlyphForPageUp         = 0x21DE,
	kGlyphForNorthwestArrow = 0x2196,
	kGlyphForSoutheastArrow = 0x2198,
	kGlyphForEscape         = 0x238B,
	kGlyphForHelp           = 0x003F,
	kGlyphForUpArrowhead    = 0x2303,
};

enum {
	kKeyCodeForF1 = 122,
	kKeyCodeForF2 = 120,
	kKeyCodeForF3 = 99,
	kKeyCodeForF4 = 118,
	kKeyCodeForF5 = 96,
	kKeyCodeForF6 = 97,
	kKeyCodeForF7 = 98,
	kKeyCodeForF8 = 100,
	kKeyCodeForF9 = 101,
	kKeyCodeForF10 = 109,
	kKeyCodeForF11 = 103,
	kKeyCodeForF12 = 111,
	kKeyCodeForF13 = 105,
	kKeyCodeForF14 = 107,
	kKeyCodeForF15 = 113,
	kKeyCodeForF16 = 106,
	kKeyCodeForF17 = 64,
	kKeyCodeForF18 = 79,
	kKeyCodeForF19 = 80,
	kKeyCodeForSpace = 49,
	kKeyCodeForDeleteLeft = 51,
	kKeyCodeForDeleteRight = 117,
	kKeyCodeForPadClear = 71,
	kKeyCodeForLeftArrow = 123,
	kKeyCodeForRightArrow = 124,
	kKeyCodeForUpArrow = 126,
	kKeyCodeForDownArrow = 125,
	kKeyCodeForSoutheastArrow = 119,
	kKeyCodeForNorthwestArrow = 115,
	kKeyCodeForEscape = 53,
	kKeyCodeForPageDown = 121,
	kKeyCodeForPageUp = 116,
	kKeyCodeForReturnR2L = 36,
	kKeyCodeForReturn = 76,
	kKeyCodeForTabRight = 48,
	kKeyCodeForHelp = 114
};


@interface NUKeyboardUtils : NSObject

- (uint16_t) virtualKeyCodesForKey:(unichar)key;
- (NSString*) stringForKeyCode:(uint16_t)code;
- (NSString*) shortcutStringForKeyCode:(uint16_t)key withModifierFlags:(uint32_t)flags;

+ (NUKeyboardUtils*)sharedInstance;
+ (uint16_t) virtualKeyCodesForKey:(unichar)key;
+ (NSString*) stringForKeyCode:(uint16_t)code;
+ (NSString*) shortcutStringForKeyCode:(uint16_t)code withModifierFlags:(uint32_t)flags;
+ (id) keyboardUtils;

@end
