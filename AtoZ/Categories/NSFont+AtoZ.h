
#import <Cocoa/Cocoa.h>
#import "AtoZUmbrella.h"

@interface NSFont (AtoZ)
@property (RONLY) CGF size;
- (NSFont*)fontWithSize:(CGFloat)fontSize;
@end

@interface NSFont (AMFixes)

- (float)fixed_xHeight;
- (float)fixed_capHeight;
@end

@interface NSCharacterSet (EmojisAddition)

+ (NSCharacterSet*) emojiCharacterSet;
- (void) log;

+ (void) logCharacterSet:(NSCharacterSet*)characterSet;
+ (NSCharacterSet *) illegalXMLCharacterSet;
@end

@interface NSScanner (NSScannerAdditions)
- (BOOL) scanCharactersFromSet:(NSCharacterSet *) scanSet maxLength:(NSUInteger) length intoString:(NSS**) stringValue;
@end

BOOL isValidUTF8( const char *string, NSUInteger length );

#define is7Bit(ch) (((ch) & 0x80) == 0)
#define isUTF8Tupel(ch) (((ch) & 0xE0) == 0xC0)
#define isUTF8LongTupel(ch) (((ch) & 0xFE) == 0xC0)
#define isUTF8Triple(ch) (((ch) & 0xF0) == 0xE0)
#define isUTF8LongTriple(ch1,ch2) (((ch1) & 0xFF) == 0xE0 && ((ch2) & 0xE0) == 0x80)
#define isUTF8Quartet(ch) (((ch) & 0xF8) == 0xF0)
#define isUTF8LongQuartet(ch1,ch2) (((ch1) & 0xFF) == 0xF0 && ((ch2) & 0xF0) == 0x80)
#define isUTF8Quintet(ch) (((ch) & 0xFC) == 0xF8)
#define isUTF8LongQuintet(ch1,ch2) (((ch1) & 0xFF) == 0xF8 && ((ch2) & 0xF8) == 0x80)
#define isUTF8Sextet(ch) (((ch) & 0xFE) == 0xFC)
#define isUTF8LongSextet(ch1,ch2) (((ch1) & 0xFF) == 0xFC && ((ch2) & 0xFC) == 0x80)
#define isUTF8Cont(ch) (((ch) & 0xC0) == 0x80)

@interface NSString (NSStringAdditions)
+ (NSS*) locallyUniqueString;
+ (NSD*) emojiDictionary;
+ (NSA*) emoji;
+ (NSArray *) knownEmoticons;
+ (NSSet *) knownEmojiWithEmoticons;
- (id) initWithChatData:(NSData *) data encoding:(NSStringEncoding) encoding;
- (BOOL) isCaseInsensitiveEqualToString:(NSS*) string;
- (BOOL) hasCaseInsensitivePrefix:(NSS*) prefix;
- (BOOL) hasCaseInsensitiveSuffix:(NSS*) suffix;
- (BOOL) hasCaseInsensitiveSubstring:(NSS*) substring;
- (NSS*) stringByEncodingXMLSpecialCharactersAsEntities;
- (NSS*) stringByDecodingXMLSpecialCharacterEntities;
- (NSS*) stringByEscapingCharactersInSet:(NSCharacterSet *) set;
- (NSS*) stringByReplacingCharactersInSet:(NSCharacterSet *) set withString:(NSS*) string;
- (NSS*) stringByEncodingIllegalURLCharacters;
- (NSS*) stringByDecodingIllegalURLCharacters;
- (NSS*) stringByStrippingIllegalXMLCharacters;
- (NSS*) stringByStrippingXMLTags;

+ (NSS*) stringByReversingString:(NSS*) normalString;
- (NSS*) stringWithDomainNameSegmentOfAddress;
- (NSS*) fileName;
- (BOOL) isValidIRCMask;
- (NSS*) IRCNickname;
- (NSS*) IRCUsername;
- (NSS*) IRCHostname;
- (NSS*) IRCRealname;
- (BOOL) containsEmojiCharacters;
- (BOOL) containsEmojiCharactersInRange:(NSRange) range;
- (NSRange) rangeOfEmojiCharactersInRange:(NSRange) range;
- (BOOL) containsTypicalEmoticonCharacters;
- (NSS*) stringBySubstitutingEmojiForEmoticons;
- (NSS*) stringBySubstitutingEmoticonsForEmoji;
- (BOOL) isMatchedByRegex:(NSS*) regex;
- (BOOL) isMatchedByRegex:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range error:(NSError **) error;
- (NSRange) rangeOfRegex:(NSS*) regex inRange:(NSRange) range;
- (NSRange) rangeOfRegex:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range capture:(NSInteger) capture error:(NSError **) error;
- (NSS*) stringByMatching:(NSS*) regex capture:(NSInteger) capture;
- (NSS*) stringByMatching:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range capture:(NSInteger) capture error:(NSError **) error;
- (NSArray *) captureComponentsMatchedByRegex:(NSS*) regex options:(NSRegularExpressionOptions) options range:(NSRange) range error:(NSError **) error;
- (NSS*) stringByReplacingOccurrencesOfRegex:(NSS*) regex withString:(NSS*) replacement;
- (NSS*) stringByReplacingOccurrencesOfRegex:(NSS*) regex withString:(NSS*) replacement options:(NSRegularExpressionOptions) options range:(NSRange) searchRange error:(NSError **) error;
- (NSUInteger) levenshteinDistanceFromString:(NSS*) string;
@end

@interface NSMutableString (NSMutableStringAdditions)
- (void) encodeXMLSpecialCharactersAsEntities;
- (void) decodeXMLSpecialCharacterEntities;
- (void) escapeCharactersInSet:(NSCharacterSet *) set;
- (void) replaceCharactersInSet:(NSCharacterSet *) set withString:(NSS*) string;
- (void) encodeIllegalURLCharacters;
- (void) decodeIllegalURLCharacters;
- (void) stripIllegalXMLCharacters;
- (void) stripXMLTags;
- (void) substituteEmoticonsForEmoji;
- (void) substituteEmoticonsForEmojiInRange:(NSRangePointer) range;
- (void) substituteEmoticonsForEmojiInRange:(NSRangePointer) range withXMLSpecialCharactersEncodedAsEntities:(BOOL) encoded;
- (void) substituteEmojiForEmoticons;
- (void) substituteEmojiForEmoticonsInRange:(NSRangePointer) range;
- (void) substituteEmojiForEmoticonsInRange:(NSRangePointer) range encodeXMLSpecialCharactersAsEntities:(BOOL) encode;
@end


@interface NSRegularExpression (Additions)
+ (NSRegularExpression *) cachedRegularExpressionWithPattern:(NSString *) pattern options:(NSRegularExpressionOptions) options error:(NSError *__autoreleasing*) error;
@end


/**
 Offers programmatic access to emojis as organized in the 
 emoji-cheat-sheet.com website.
 */
@interface Emoji : NSObject

/**
 Returns the list of the emoji groups found on the emoji-cheat-sheet.com
 website in the same order.
 */
+ (NSArray*)groups;

/**
 Returns a dictionary where the keys are the names of the groups and the values
 are the lists of the emoji aliases associated with that group.
 */
+ (NSDictionary*)byGroups;

/**
 Returns a dictionary which maps the aliases to the emoji characters.
 */
+ (NSDictionary*)byAlias;

/**
 Replaces the aliases surrounded by colons with the emoji characters.
 */
+ (NSString*)stringByReplacingEmojiAliasesInString:(NSString*)string;

+ (NSA*) all;
+ (NSS*) random;


@end
