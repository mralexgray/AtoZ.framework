

@interface NSFont (AtoZ)
@prop_RO CGF size;
- (NSFont*)fontWithSize:(CGFloat)fontSize;
@end

@interface NSFont (AMFixes)

- (float)fixed_xHeight;
- (float)fixed_capHeight;
@end

@interface NSCharacterSet (EmojisAddition)
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
- (BOOL) isMatchedByRegex:(NSS*) regex;
- (BOOL) isMatchedByRegex:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range error:(NSERR*__autoreleasing*) error;
- (NSRange) rangeOfRegex:(NSS*) regex inRange:(NSRange) range;
- (NSRange) rangeOfRegex:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range capture:(NSInteger) capture error:(NSERR*__autoreleasing*) error;
- (NSS*) stringByMatching:(NSS*) regex capture:(NSInteger) capture;
- (NSS*) stringByMatching:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range capture:(NSInteger) capture error:(NSERR*__autoreleasing*) error;
- (NSArray *) captureComponentsMatchedByRegex:(NSS*) regex options:(NSRegularExpressionOptions) options range:(NSRange) range error:(NSERR*__autoreleasing*) error;
- (NSS*) stringByReplacingOccurrencesOfRegex:(NSS*) regex withString:(NSS*) replacement;
- (NSS*) stringByReplacingOccurrencesOfRegex:(NSS*) regex withString:(NSS*) replacement options:(NSRegularExpressionOptions) options range:(NSRange) searchRange error:(NSERR*__autoreleasing*) error;
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
@end


@interface NSRegularExpression (Additions)
+ (NSRegularExpression *) cachedRegularExpressionWithPattern:(NSString *) pattern options:(NSRegularExpressionOptions) options error:(NSError *__autoreleasing*) error;
@end


