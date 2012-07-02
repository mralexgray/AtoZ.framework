//
//  NSString+AtoZ.h
//  AtoZ
//
#import <Foundation/Foundation.h>

@interface NSString (AtoZ)


@property (readonly) NSColor *colorValue;

- (void)drawCenteredInRect:(CGRect)rect withFont:(NSFont *)font;
/*** Returns the string cleaned from leading and trailing whitespaces */
@property (readonly) NSString *trim;

/*** Returns the reverse version of the string */
@property (readonly) NSString *reversed;

/*** Returns the substring after the first character in this string */
@property (readonly) NSString *shifted;

/*** Returns the substring not containing the last character of this string */
@property (readonly) NSString *popped;

/*** Combination of shifted and popped, removes the first and last character */
@property (readonly) NSString *chopped;

/*** Returns a CamelCase Version of this string */
@property (readonly) NSString *camelized;

@property (readonly) NSString *hyphonized;

@property (readonly) NSString *underscored;

/*** Returns YES if this string is nil or contains nothing but whitespaces */
@property (readonly) BOOL isEmpty;

/*** Counts occurrences of a given string */
- (NSUInteger)count:(NSString *)aString;

/*** Cunts occurrences of a given string with sone compare options */
- (NSUInteger)count:(NSString *)aString options:(NSStringCompareOptions)flags;

/*** Counts the whitespace chars that prefix this string */
@property (readonly) NSUInteger indentationLevel;

/*** Returns YES when aString is part of the this string.
 * nil and @"" are never part of any compared string */
- (BOOL)contains:(NSString *)aString;

/*** Returns YES when this string contains ANY of the strings defined in the array */
- (BOOL)containsAnyOf:(NSArray *)array;

/*** Returns YES when this string contains ALL of the strings defined in the array */
- (BOOL)containsAllOf:(NSArray *)array;

/*** Returns YES when this string starts with aString, just a synonym for hasPrefix */
- (BOOL)startsWith:(NSString *)aString;

/*** Returns YES when this string ends with aString, just a synonym for hasSuffix */
- (BOOL)endsWith:(NSString *)aString;

/*** Returns YES when this string has both given prefix and suffix */
- (BOOL)hasPrefix:(NSString *)prefix andSuffix:(NSString *)suffix;

/*** Will return the substring between prefix and suffix.
 * If either prefix or suffix cannot be matched nil will be returned */
- (NSString *)substringBetweenPrefix:(NSString *)prefix 
                           andSuffix:(NSString *)suffix;

/*** Oldscool indexOf, if you do not want to handle NSRange objects
 * will return -1 instead of NSNotFound */
- (NSInteger)indexOf:(NSString *)aString;
- (NSInteger)indexOf:(NSString *)aString 
		  afterIndex:(NSInteger)index;

/*** Oldscool lastIndexOf, if you do not want to handle NSRange objects
 * will return -1 instead of NSNotFound */
- (NSInteger)lastIndexOf:(NSString *)aString;

/*** Returns the first NSRange of any matching substring in this string
 * that is part of the strings set */
- (NSRange)rangeOfAny:(NSSet *)strings;

/*** Returns this string splitted by lines.
 * Shortcut for componentsSeperatedByString:@"\n" */
@property (readonly) NSArray *lines;

/*** Returns this string splitted by whitespaces.
 * Shortcut for componentsSeperatedByString:@" "
 * Empty elements will not be part of the resulting array */
@property (readonly) NSArray *words;

/*** Returns a set with all unique elements of this String,
 * separated by whitespaces */
@property (readonly) NSSet *wordSet;

- (NSArray *)trimmedComponentsSeparatedByString:(NSString *)delimiter;

@property (readonly) NSArray *decolonize;
@property (readonly) NSArray *splitByComma;

- (NSString *)substringBefore:(NSString *)delimiter;
- (NSString *)substringAfter:(NSString *)delimiter;

//
// The difference between the splitBy and splitAt groups is
// that splitAt will return an array containing one or two elements
//
- (NSArray *)splitAt:(NSString *)delimiter;
- (BOOL)splitAt:(NSString *)delimiter 
           head:(NSString **)head 
           tail:(NSString **)tail;

// excuse the pun, but it divides the string into a head and body word, trimmed
@property (readonly) NSArray *decapitate;

//
// TBD whether they belong here or elsewhere
//
@property (readonly) NSPoint pointValue;
@property (readonly) NSUInteger minutesValue;
@property (readonly) NSUInteger secondsValue;

@property (readonly) NSURL *url;
@property (readonly) NSURL *fileURL;

@property (readonly) NSString *ucfirst;
@property (readonly) NSString *lcfirst;

+ (id)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;
+ (NSString *)stringWithCGFloat:(CGFloat)f maxDigits:(NSUInteger)numDigits;
@end


// Truncate a string by inserting an ellipsis ("..."). truncateMode can be NSLineBreakByTruncatingHead, NSLineBreakByTruncatingMiddle or NSLineBreakByTruncatingTail.
NSString*   StringByTruncatingStringWithAttributesForWidth( NSString* s,
                                                                NSDictionary* attrs,
                                                                float wid,
                                                                NSLineBreakMode truncateMode );



@interface NSMutableString (AtoZ)

- (NSString *)shift;
- (NSString *)pop;

- (BOOL)removePrefix:(NSString *)prefix;
- (BOOL)removeSuffix:(NSString *)suffix;
- (BOOL)removePrefix:(NSString *)prefix andSuffix:(NSString *)suffix;

- (NSMutableString *)camelize;
- (NSMutableString *)hyphonize;
- (NSMutableString *)underscorize;
- (NSMutableString *)replaceAll:(NSString *)needle 
                     withString:(NSString *)replacement;

@end
