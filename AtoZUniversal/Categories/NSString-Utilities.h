#import <Foundation/Foundation.h>

@interface NSString (Utilities)
+ (NSString*)stringWithFileSystemRepresentation:(const char*)path;
//+ (NSString*)stringWithPString:(Str255)pString;
//+ stringWithUTF8String:(const void *)bytes length:(unsigned)length;
//+ stringWithMacOSRomanString:(const char *)nullTerminatedCString;
+ stringWithBytes:(const void *)bytes length:(unsigned)len encoding:(NSStringEncoding)encoding;

//- (void)getPString:(Str255)outString;
- (void)getUTF8String:(char*)outString maxLength:(int)maxLength;


- (NSString*)stringByReplacing:(NSString *)value with:(NSString *)newValue;
- (NSString*)stringByReplacingValuesInArray:(NSArray *)values withValuesInArray:(NSArray *)newValues;
- (NSString*)stringByDeletingSuffix:(NSString *)suffix;
- (NSString*)stringByDeletingPrefix:(NSString *)prefix;
- (BOOL)stringContainsValueFromArray:(NSArray *)theValues;
- (BOOL)isEqualToStringCaseInsensitive:(NSString *)str;

// variants with caseSensitive option
- (BOOL)isEqualToString:(NSString *)str caseSensitive:(BOOL)caseSensitive;
- (BOOL)hasPrefix:(NSString *)str caseSensitive:(BOOL)caseSensitive;
- (BOOL)hasSuffix:(NSString *)str caseSensitive:(BOOL)caseSensitive;
- (NSString*)stringByDeletingSuffix:(NSString *)suffix caseSensitive:(BOOL)caseSensitive;
- (NSString*)stringByDeletingPrefix:(NSString *)prefix caseSensitive:(BOOL)caseSensitive;

- (NSString*)stringInStringsFileFormat;
- (NSString*)stringFromStringsFileFormat;  // reverse of above
- (NSString*)stringPairInStringsFileFormat:(NSString*)right addNewLine:(BOOL)addNewLine;

- (NSArray*)linesFromString:(NSString**)outRemainder;
- (NSString*)getFirstLine;
// notInQuotes YES if your not going to quote the string for the terminal
- (NSString*)stringWithShellCharactersEscaped:(BOOL)notInQuotes;
- (NSString*)stringWithRegularExpressionCharactersQuoted;

    // converts a POSIX path to an HFS path
- (NSString*)HFSPath;
    // converts a HFS path to a POSIX path
- (NSString*)POSIXPath;

- (NSString*)stringByTrimmingWhiteSpace;
+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;
- (NSString *)stringByRemovingReturns;
- (NSString *)stringByRemovingCharactersInCharacterSet:(NSCharacterSet *)removeSet;

- (NSString *)stringByRemovingPrefix:(NSString *)prefix;
- (NSString *)stringByRemovingSuffix:(NSString *)suffix;

// converts a POSIX path to a Windows path
- (NSString*)windowsPath;

- (BOOL)isEndOfWordAtIndex:(unsigned)index;
- (BOOL)isStartOfWordAtIndex:(unsigned)index;

- (NSString*)stringByTruncatingToLength:(unsigned)length;

- (NSString*)stringByDecryptingString;
- (NSString*)stringByEncryptingString;


- (NSString*)URLEncodedString;

// excludes extensions with spaces
- (NSString*)strictPathExtension;
- (NSString*)strictStringByDeletingPathExtension;

- (NSString*)stringByDeletingPercentEscapes;

- (NSComparisonResult)filenameCompareWithString:(NSString *)string;

- (NSString*)slashToColon;
- (NSString*)colonToSlash;

// a unique string
+ (NSString*)unique;

	// Split on slashes and chop out '.' and '..' correctly.
- (NSString *)normalizedPath;

@end

// =======================================================================================

@interface NSMutableString(Utilities)
- (void)replace:(NSString *)value with:(NSString *)newValue;
- (void)appendChar:(unichar)aCharacter;
@end;

