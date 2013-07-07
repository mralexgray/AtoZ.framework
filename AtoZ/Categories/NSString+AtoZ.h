
//  NSString+AtoZ.h
//  AtoZ

@interface NSParagraphStyle (AtoZ)
+ (NSParagraphStyle*) defaultParagraphStyleWithDictionary:(NSD*)d;
@end

@interface NSImage(ASCII)
- (NSString *)asciiArtWithWidth:(NSInteger)width height:(NSInteger)height;
@end

@class AZDefinition;
@interface NSString (AtoZ)

@property (RONLY) BOOL isInteger;
@property 			NSRNG	subRange;

- (void) openInTextMate;

- (NSComparisonResult) compareNumberStrings:(NSS*)str;
- (NSS*) justifyRight:(NSUI)col;
- (NSS*) withString:	(NSS*)string;

+ (NSS*) stringFromArray:(NSA*)a;
+ (NSS*) stringFromArray:(NSA*)a withSpaces:(BOOL)spaces onePerline:(BOOL)newl;
+ (NSS*) stringFromArray:(NSA*)a withDelimeter:(NSS*)del last:(NSS*)last;

#pragma mark - Parsing / Cleaning
@property (RONLY) NSS * JSONRepresentation,
							 *	stringByDecodingXMLEntities,
							 *	stringByCleaningJSONUnicode,
							 *	stringByStrippingHTML,
							 *	unescapeQuotes,
							 *	stripHtml,
							 *	decodeHTMLCharacterEntities,
							 *	encodeHTMLCharacterEntities,
							 *	escapeUnicodeString,
							 *	unescapeUnicodeString,
							 *	decodeAllAmpersandEscapes,
							 *	urlEncoded,
							 *	urlDecoded,
							 * MD5String;

- (NSS*) parseXMLTag:(NSS*) tag;
//- (NSS*)decodeAllPercentEscapes;

#pragma mark - LEXICONS

+ (NSS*) newUniqueIdentifier;
+ (NSS*) randomAppPath;
+ (NSA*) testDomains;

+ (NSS*) dicksonBible;
+ (NSA*) dicksonisms;
+ (NSS*) randomDicksonism;
+ (NSA*) dicksonPhrases;
+ (NSS*) dicksonParagraphWith:(NSUI)sentences;

+ (NSA*) badWords;
+ (NSS*) randomBadWord;

+ (NSA*) properNames;

+ (NSS*) randomWiki;
- (NSS*) wikiDescription;

+ (NSS*) randomWord;
+ (AZDefinition *)randomUrbanD;
+ (void)randomUrabanDBlock:(void (^)(AZDefinition *definition))block;
+ (NSS*) randomWords:(NSI)number;
+ (NSS*) randomSentences:(NSI)number;


+ (NSS*) spaces:(NSUI)ct;
- (NSS*) paddedTo:(NSUI)count;
- (NSUI) longestWordLength;



+ (NSS*) clipboard;
- (void)copyToClipboard;

- (NSS*) withPath:(NSS*)path;
- (NSS*) withExt:	(NSS*)ext;

- (BOOL) loMismo:	(NSS*)s;

- (unichar)lastCharacter;
- (void) copyFileAtPathTo:(NSS*) path;

- (CGF) pointSizeForFrame:(NSR)frame withFont:(NSS*) fontName;
+ (CGF) pointSizeForFrame:(NSR)frame withFont:(NSS*) fontName forString:(NSS*) string;

- (NSS*) stringByReplacingAllOccurancesOfString:(NSS*) search withString:(NSS*) replacement;

- (NSS*)	substringToLastCharacter;
- (NSN*) numberValue;

AZPROPERTY(NSS, RONLY, *firstLetter, *lastLetter);

- (NSSZ)sizeWithFont:(NSFont *)font;
- (NSSZ)sizeWithFont:(NSFont *)font margin:(NSSZ)size;

- (CGF)widthWithFont:(NSF *)font;
- (NSR)frameWithFont:(NSF *)font;

//@property (RONLY) NSC *colorValue;
- (void)drawInRect:(NSR)r withFontNamed:(NSS*) fontName andColor:(NSC *)color;
// new way
- (void)drawInRect:(NSR)r withFont:(NSFont *)font andColor:(NSC *)color;
//- (void) drawCenteredInRect: (NSR)rect withFontNamed: (NSS*) font;
- (void)drawCenteredInRect:(NSR)rect withFont:(NSF *)font;

@property (RONLY)	NSS * trim,				/*** Returns the string cleaned from leading and trailing whitespaces */
							 * reversed,		/*** Returns the reverse version of the string */
							 *	shifted,			/*** Returns the substring after the first character in this string */
							 * popped,			/*** Returns the substring not containing the last character of this string */
							 * chopped,			/*** Combination of shifted and popped, removes the first and last character */
							 * camelized,		/*** Returns a CamelCase Version of this string */
							 * hyphonized,
							 * underscored;
@property (RONLY) BOOL   isEmpty;		/*** Returns YES if this string is nil or contains nothing but whitespaces */
@property (RONLY) NSUI   indentationLevel;									/*** Counts the whitespace chars that prefix this string */
- (NSUI)count:(NSS*)aString;														/*** Counts occurrences of a given string */
- (NSUI)count:(NSS*)aString options:(NSStringCompareOptions)flags; 	/*** Cunts occurrences of a given string with sone compare options */

/* NOTICE nil and @"" are never part of any compared string */
- (BOOL) contains:		(NSS*)aString; /*** Returns YES when aString is part of the this string. */
- (BOOL) containsAnyOf:	(NSA*)array;	/*** Returns YES when this string contains ANY of the strings defined in the array */
- (BOOL) containsAllOf:	(NSA*)array; 	/*** Returns YES when this string contains ALL of the strings defined in the array */
- (BOOL) startsWith:		(NSS*)aString;	/*** Returns YES when this string starts with aString, just a synonym for hasPrefix */
- (BOOL) endsWith:		(NSS*)aString;	/*** Returns YES when this string ends with aString, just a synonym for hasSuffix */
- (BOOL)hasPrefix:(NSS*) prefix andSuffix:(NSS*) suffix;  /*** Returns YES when this string has both given prefix and suffix */
/*** Substring between prefix and suffix. If either prefix or suffix cannot be matched nil will be returned */
- (NSS*) substringBetweenPrefix:(NSS*) prefix andSuffix:(NSS*) suffix;
/*** Oldscool indexOf, if you do not want to handle NSRange objects will return -1 instead of NSNotFound */
-  (NSI) indexOf:		(NSS*)aString;
-  (NSI) indexOf:		(NSS*)aString afterIndex:(NSI)index;
/*** Oldscool lastIndexOf, if you do not want to handle NSRange objects will return -1 instead of NSNotFound */
-  (NSI) lastIndexOf:(NSS*)aString;
/*** Returns the first NSRange of any matching substring in this string that is part of the strings set */
- (NSRNG) rangeOfAny:(SET*)strings;
/*** Returns this string splitted by lines. * Shortcut for componentsSeperatedByString:@"\n" */
@property (RONLY) NSA * lines;

/*** Returns this string splitted by whitespaces.  Shortcut for componentsSeperatedByString:@" " Empty elements will not be part of the array */
@property (RONLY) NSA * words;
@property (RONLY) NSA * wordsWithRanges;
/*** Returns a set with all unique elements of this String, separated by whitespaces */
@property (RONLY) NSSet *wordSet;

- (NSA*) trimmedComponentsSeparatedByString:(NSS*) delimiter;

@property (RONLY) NSArray *decolonize;
@property (RONLY) NSArray *splitByComma;

- (NSS*) substringBefore:	(NSS*)delimiter;
- (NSS*) substringAfter:	(NSS*)delimiter;
// The difference between the splitBy and splitAt groups is that splitAt will return an array containing one or two elements
- (NSA*) splitAt:(NSS*)delimiter;
- (BOOL) splitAt:(NSS*)delimiter head:(NSS**)head tail:(NSS**)tail;

// excuse the pun, but it divides the string into a head and body word, trimmed
@property (RONLY) NSArray *decapitate;
// TBD whether they belong here or elsewhere
@property (RONLY)  NSP pointValue;
@property (RONLY) NSUI minutesValue;
@property (RONLY) NSUI secondsValue;

@property (RONLY) NSURL *url;
@property (RONLY) NSURL *fileURL;

@property (RONLY) NSS *ucfirst;
@property (RONLY) NSS *lcfirst;

+ (id)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;
+ (NSS*)   stringWithCGFloat: (CGF)f		 maxDigits: (NSUI)numDigits;
//- (NSAS*) attributedWithSize: (NSUI)size andColor: (NSC*)color;
- (NSAS *)attributedWithFont:(NSF *)font andColor:(NSC *)color;
- (NSMAS *)attributedParagraphWithSpacing:(CGF)spacing;
- (NSS*) truncatedForRect:(NSR)frame withFont:(NSF *)font;
//-(NSMutableAttributedString *) attributedParagraphWithSpacing:(CGF)spacing



- (NSS*) truncateInMiddleForWidth:(CGF)overall;
- (NSS*) truncateInMiddleToCharacters:(NSUI)chars;

@end
// Truncate a string by inserting an ellipsis ("..."). truncateMode can be NSLineBreakByTruncatingHead, NSLineBreakByTruncatingMiddle or NSLineBreakByTruncatingTail.
NSS *   StringByTruncatingStringWithAttributesForWidth(NSS *s, NSD *attrs, float wid, NSLineBreakMode truncateMode);

@interface NSMutableString (AtoZ)

-  (NSS*) shift;
-  (NSS*) pop;

-  (BOOL) removePrefix:(NSS*)prefix;
-  (BOOL) removeSuffix:(NSS*)suffix;
-  (BOOL) removePrefix:(NSS*)prefix andSuffix:(NSS*)suffix;
- (NSMS*) camelize;
- (NSMS*) hyphonize;
- (NSMS*) underscorize;
- (NSMS*) replaceAll:(NSS*)needle withString:(NSS*)replacement;
@end
@interface NSString (RuntimeReporting)
- (BOOL) hasSubclasses;
- (NSA*) subclassNames;
- (NSA*) methodNames;
- (NSA*) ivarNames;
- (NSA*) propertyNames;
- (NSA*) protocolNames;
@end
@interface NSAttributedString (AtoZ)
+ (NSD*) defaults;
@end


/* SUMMARY

   The methods in these @interfaces are typically used to dynamically size an NSTextView or NSTextField to fit their strings.  They return the ^used^ size, width or height of the given string/attributes, constrained by the maximum dimensions passed in the 'width' and 'height' arguments.

 * RENDERING IN NSTextView VS. NSTextField

 Text rendered in a multiline line-wrapped NSTextField leaves much more space between lines than text rendered in an NSTextView.  
 The total points per line is typically 10-20% higher.
 
 Because most apps use NSTextView to render multiline text, using a line-wrapped NSTextField looks funny, and obviously it wastes useful screen area.  
 But there are more subtle disadavantages if you wish to estimate the size of the rendered text, typically done in order to size the view.
 First of all, you cannot get a perfect estimate of the height. Although using the proper typesetterBehavior in the NSLayoutManager providing the estimate fixes the severe 10-20% underestimation which you'd get from using the default NSTypesetterLatestBehavior, it still usually gives results that are a little inaccurate. The error depends on the font and the size. For Arial and Helvetica, the calculated height is usually underestimated by the measure of one glyph descender; i.e. the measurement extends only to the baseline of the last line. For Lucida Grande smaller-sized fonts (9-10 pt), and for most sizes of Goudy Old Style, the calculated height is overestimated, by about one line. For Stencil, the calculated height is accurate. For Zapfino, the calculated height is usually underrestimated by 1-3 pixels. These are the only fonts that I looked at the results for.
 Finally, although the typesetterBehavior seems to be, at this time, equal to NSTypesetterBehavior_10_2_WithCompatibility, I suppose that this could change in the future.  This will change the vertical size of the rendered text.
 For these reasons, using a wrapped NSTextField to render multiline text is therefore discouraged in favor of using an NSTextView.

 * THE GLOBAL VARIABLE gNSStringGeometricsTypesetterBehavior

 The estimate of line spacing is controlled by the NSTypesetterBehavior setting in NSLayoutManager used in these methods.  Therefore, you must specify the NSTypsetterBehavior you desire when using one of these methods to get a measurement.
 Rather than providing a 'typsetterBehavior' argument in each of the methods in this category, which would make them really messy just to support a discouraged usage, a global variable, gNSStringGeometricsTypesetterBehavior, is initialized with the value NSTypesetterLatestBehavior.  This value is appropriate to estimating height of text to be rendered in an NSTextView. This is also the default behavior in NSLayoutManager.
 Therefore, if you want to get measurements for text to be rendered in an NSTextView, these methods will "just work".
 Also, if you want to get the dimensions for text which will render in a single line, even in NSTextField, these methods will "just work".
 However, if you want to get dimensions of a string as rendered in the discouraged NSTextField with line wrapping, set the global variable gNSStringGeometricsTypesetterBehavior to NSTypesetterBehavior_10_2_WithCompatibility before invoking these methods. Invoking any of these methods will automatically set it back to the default value of NSTypesetterLatestBehavior.

 * ARGUMENTS width and height
 In the sizeFor... methods, pass either a width or height which is known to be larger than the width or height that is required.  Usually, one of these should be the "unlimited" value of FLT_MAX. If text will be drawn on one line, you may pass FLT_MAX for width.

 * ARGUMENT attributes, NSAttributedString attributes
 The dictionary 'attributes', or for NSAttributedString (Geometrics), the attributes of the receiver, must contain at least one key: NSFontAttributeName, with value an NSFont object. Other keys in 'attributes' are ignored.

 * DEGENERATE ARGUMENT CASES
 If the receiver has 0 -length, all of these methods will return 0.0. If 'font' argument is nil, will log error to console and return 0.0 x 0.0.
 It is sometimes useful to know that, according to Douglas Davidson, http://www.cocoabuilder.com/archive/message/cocoa/2002/2/13/66379, "The default font for text that has no font attribute set is 12-pt Helvetica." Can't find any official documentation on this, but it seems to be still true today, as of Mac OS 10.5.2, for NSTextView.  For NSTextField, however, the default font is 12-pt Lucida Grande.
 If you pass a nil 'font' argument, these methods will log an error and return 0.0.  But if you pass an NSAttributedString with no font attribute for a run, these methods will calculate assuming 12-pt regular Helvetica.

 * INTERNAL DESIGN   -[NSAttributedString sizeForWidth:height] is the primitive workhorse method.
 	All other methods in these @interfaces invoke this method under the hood. Basically, it stuffs your string into an NSTextContainer, stuffs this into an NSLayout Manager, and then gets the answer by invoking -[NSLayoutManager usedRectForTextContainer:].  The idea is copied from here: http://developer.apple.com/documentation/Cocoa/Conceptual/TextLayout/Tasks/StringHeight.html

 * AUTHOR -   Please send bug reports or other comments to Jerry Krinock, jerry@ieee.org Updates may be available at http://sheepsystems.com/sourceCode

 * ACKNOWLEDGEMENTS -   Thanks very much to Steve Nygard for taking the project one night, recognizing the importance of the line fragment padding and hyphenation factor, and the idea of generalizing to support NSAttributedString.
*/
extern int gNSStringGeometricsTypesetterBehavior;

@interface NSAttributedString (Geometrics)

- (void)drawCenteredVerticallyInRect:(NSRect)rect;

// Measuring Attributed Strings
- (NSSize)sizeForWidth:	(float)width height:(float)height;
- (float)heightForWidth:(float)width;
- (float)widthForHeight:(float)height;

@end

@interface NSString (Geometrics)

// Measuring a String With Attributes
- (NSSize)sizeForWidth: (float)width
					 height: (float)height attributes:(NSD*)attributes;
- (float)heightForWidth:(float)width  attributes:(NSD*)attributes;
- (float)widthForHeight:(float)height attributes:(NSD*)attributes;

// Measuring a String with a constant Font
//- (NSSize)sizeInSize: (NSSize)size      font: (NSFont*)font;

- (NSSize)sizeForWidth:(float)width height:(float)height font:(NSFont *)font;
- (float)heightForWidth:(float)width font:(NSFont *)font;
- (float)widthForHeight:(float)height font:(NSFont *)font;

@end

//  NSLog(@"%@", [@"Hello" : @", " : [NSC redColor] : @"World!" : @"  " : [NSNumber numberWithInt:42]]);
@interface NSString (JASillyString)
/**
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- :a;
- :a:b;
- :a:b:c;
- :a:b:c:d;
- :a:b:c:d:e;
- :a:b:c:d:e:f;
- :a:b:c:d:e:f:g;
- :a:b:c:d:e:f:g:h;
- :a:b:c:d:e:f:g:h:i;
- :a:b:c:d:e:f:g:h:i:j;
- :a:b:c:d:e:f:g:h:i:j:k;
- :a:b:c:d:e:f:g:h:i:j:k:l;
- :a:b:c:d:e:f:g:h:i:j:k:l:m;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t:u;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t:u:v;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t:u:v:w;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t:u:v:w:x;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t:u:v:w:x:y;
- :a:b:c:d:e:f:g:h:i:j:k:l:m:n:o:p:q:r:s:t:u:v:w:x:y:z;

#pragma clang diagnostic pop
*/
@end



@interface NSString (Extensions)

-  (BOOL) hasCaseInsensitivePrefix:(NSS*) prefix;
-  (NSS*) urlEscapedString;                      // Uses UTF-8 encoding and also escapes characters that can confuse the parameter string part of the URL
-  (NSS*) unescapeURLString;                     // Uses UTF-8 encoding
-  (NSS*) extractFirstSentence;
-  (NSA*) extractAllSentences;
- (NSIS*) extractSentenceIndices;
-  (NSS*) stripParenthesis;                      // Remove all parenthesis and their content
-  (BOOL) containsString:(NSS*) string;
-  (NSA*) extractAllWords;
- (NSRNG) rangeOfWordAtLocation:(NSUI)location;
- (NSRNG) rangeOfNextWordFromLocation:(NSUI)location;
-  (NSS*) stringByDeletingPrefix:(NSS*) prefix;
-  (NSS*) stringByDeletingSuffix:(NSS*) suffix;
-  (NSS*) stringByReplacingPrefix:(NSS*) prefix withString:(NSS*) string;
-  (NSS*) stringByReplacingSuffix:(NSS*) suffix withString:(NSS*) string;
-  (BOOL) isIntegerNumber;

@end

@interface NSMutableString (Extensions)
- (void)trimWhitespaceAndNewlineCharacters;   // From both ends
@end

// Utility function to convert KVC values into property-style values
@interface NSString (AQPropertyKVC)
- (NSS*) propertyStyleString;
@end

@interface NSString (SGSAdditions)

- (NSS*) truncatedToWidth:(CGF)width withAttributes:(NSD *)attributes;

@end

//
//  NSString.h
//  FoundationExtension
//
//  Created by Jeong YunWon on 10. 10. 17..
//  Copyright 2010 youknowone.org All rights reserved.
//

/*!
 *  @file
 *  @brief [NSString][0] and [NSMutableString][1] extension category collection
 *	  [0]: https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html
 *	  [1]: https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSMutableString_Class/Reference/Reference.html
 */

/*!
 *  @brief NSString creation method extension
 */
@interface NSString (Creations)

/*! @name Initilizing a String */

/*!
 *  @brief Initialize an NSString from integer value.
 *  @details Implemented with [NSString initWithFormat:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/initWithFormat:
 */
- (id)initWithInteger:(NSInteger)value;

/*!
 *  @brief Initialize an NSString object with concatnating given arguments.
 *  @details Appends all arguments to first string one by one by order.
 */
- (id)initWithConcatnatingStrings:(NSS*)first, ...NS_REQUIRES_NIL_TERMINATION;

/*! @name Creating a String */

/*!
 *  @brief Creates and returns an NSString from integer value.
 *  @see initWithInteger:
 */
+ (id)stringWithInteger:(NSInteger)value;

/*!
 *  @brief Creates and returns an NSString object initialized by using a given format string as a template into which the remaining argument values are substituted according to the user’s default locale.
 *  @see [initWithFormat:arguments:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/initWithFormat:arguments:
 */
+ (id)stringWithFormat:(NSS*)format arguments:(va_list)argList NS_FORMAT_FUNCTION(1, 0);

/*!
 *  @brief Creates and returns an NSString object initialized by converting given data into Unicode characters using a given encoding.
 *  @see [initWithData:encoding:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/initWithData:encoding:
 */
+ (id)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

/*!
 *  @brief Creates and returns an NSString object with concatnating given arguments.
 */
+ (id)stringWithConcatnatingStrings:(NSS*)first, ...NS_REQUIRES_NIL_TERMINATION;

@end

/*!
 *  @brief NSString method shortcuts
 */
@interface NSString (Shortcuts)

/*!
 *  @brief Returns a Boolean value that indicates whether a given string is contained in the receiver.
 *  @param aString A string.
 *  @returns YES if aString is contained in the receiver, otherwise NO. Returns NO if aString is empty.
 *  @see [rangeOfString:][1]
 *	  [1]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/rangeOfString:
 */
- (BOOL)hasSubstring:(NSS*)aString;

/*! @name Format */

/*!
 *  @brief Returns a string made by using self as a format string template into which the argument values are substituted.
 *  @param first, ... A comma-separated list of arguments to substitute into format. first should be id type.
 *  @return A string created by using self as a template into which the argument values are substituted according to the canonical locale.
 *  @details This requires first argument type to be id. To avoid this problems, use @link format0: @endlink.
 *  @warning Implementation of this method is not optimized enough so this is slow for some case.
 *  @see format0:
 *  @see [stringWithFormat:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/clm/NSString/stringWithFormat:
 */
- (NSS*)format:(id)first, ...;
/*!
 *  @brief Returns a string made by using self as a format string template into which the remaining argument values are substituted.
 *  @param dummyLikeNil Do nothing. Value will be ignored. This is placeholder
 *  @param ... A comma-separated list of arguments to substitute into format.
 *  @return A string created by using self as a template into which the remaining argument values are substituted according to the canonical locale.
 *  @details This ignores first argument. Pass anything.
 *  @see format:
 *  @see [stringWithFormat:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/clm/NSString/stringWithFormat:
 */
- (NSS*)format0:(id)dummyLikeNil, ...;

/*! @name Range */

/*!
 *  @brief Returns range of string.
 *  @see [NSRangeFromString][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Functions/Reference/reference.html#//apple_ref/c/func/NSRangeFromString
 */
- (NSRange)range;

/*!
 *  @brief Returns a new string containing the characters of the receiver from the one at a given index with a given length.
 *  @param from An index. The value must lie within the bounds of the receiver, or be equal to the length of the receiver.
 *  @param length A length. The summation of this value and from index must lie within the bounds of the receiver, or be equal to the length of the receiver.
 *  @return new string containing the characters of the receiver from the one at from index with given length.
 *  @see [substringWithRange:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/substringWithRange:
 */
- (NSS*)substringFromIndex:(NSUInteger)from length:(NSUInteger)length;
/*!
 *  @brief Returns a new string containing the characters of the receiver from the one at a given index to the other given index.
 *  @param from An index. The value must lie within the bounds of the receiver, or be equal to the length of the receiver.
 *  @param to An index. The value must lie within the bounds of the receiver, or be equal to the length of the receiver.
 *  @return new string containing the characters of the receiver from the one at from index to to index.
 *  @see [substringWithRange:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/substringWithRange:
 */
- (NSS*)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end

/*!
 *  @brief Shortcut for UTF8
 *  @see [NSUTF8StringEncoding][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/c/econst/NSUTF8StringEncoding
 */
@interface NSString (NSUTF8StringEncoding)

/*!
 *  @brief Creates and returns an NSString object initialized by converting given data into Unicode characters using UTF8 encoding.
 *  @see @ref NSString(Creations)::stringWithData:encoding:
 */
+ (NSS*)stringWithUTF8Data:(NSData *)data;

/*!
 *  @brief Returns a representation of the receiver using UTF8 encoding to determine the percent escapes necessary to convert the receiver into a legal URL string.
 *  @see [stringByAddingPercentEscapesUsingEncoding:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/stringByAddingPercentEscapesUsingEncoding:
 */
- (NSS*)stringByAddingPercentEscapesUsingUTF8Encoding;
/*!
 *  @brief Returns a new string made by replacing in the receiver all percent escapes with the matching characters as determined by UTF8 encoding.
 *  @see [stringByReplacingPercentEscapesUsingEncoding:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/stringByAddingPercentEscapesUsingEncoding:
 */
- (NSS*)stringByReplacingPercentEscapesUsingUTF8Encoding;

/*!
 *  @brief Returns an NSData object containing a representation of the receiver encoded using UTF8 encoding.
 *  @see [dataUsingEncoding:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/dataUsingEncoding:
 */
- (NSData *)dataUsingUTF8Encoding;

@end


/*!
 *  @brief Numeric value evaluation
 */
@interface NSString (Evaluation)
/*!
 *  @brief Returns the NSInteger value of the receiver’s text by given base radix.
 *  @param radix Base radix of text reperesentation.
 *  @return The [NSInteger][0] value of the receiver’s text with given base radix.
 *  @see [integerValue][1]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_DataTypes/Reference/reference.html#//apple_ref/doc/c_ref/NSInteger
 *	  [1]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/integerValue
 */
- (NSInteger)integerValueBase:(NSInteger)radix;
/*!
 *  @brief Returns the NSInteger value of the receiver’s text by 16 base.
 *  @return The [NSInteger][0] value of the receiver’s text with 16 base.
 *  @see [integerValue][1]
 *  @see integerValueBase:
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_DataTypes/Reference/reference.html#//apple_ref/doc/c_ref/NSInteger
 *	  [1]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/integerValue
 */
- (NSInteger)hexadecimalValue;

@end





@interface NSString (SNRAdditions)
- (NSS*)stringByRemovingExtraneousWhitespace;
- (NSS*)stringByFilteringToCharactersInSet:(NSCharacterSet *)set;
- (NSS*)stringByRemovingNonAlphanumbericCharacters;
+ (NSS*)stringFromFileSize:(NSUInteger)theSize;
- (NSS*)MD5;
- (NSS*)URLEncodedString;
- (NSS*)URLEncodedStringForCharacters:(NSS*)characters;
- (NSS*)normalizedString;
- (NSS*)upperBoundsString;
+ (NSS*)timeStringForTimeInterval:(NSTimeInterval)interval;
+ (NSS*)humanReadableStringForTimeInterval:(NSTimeInterval)interval;
- (NSA*)spaceSeparatedComponents;
+ (NSS*)randomUUID;
+ (NSData *)HMACSHA256EncodedDataWithKey:(NSS*)key data:(NSS*)data;
@end

@interface NSAttributedString (SNRAdditions)
- (NSAttributedString *)attributedStringWithColor:(NSColor *)color;
- (NSColor *)color;
@end

@interface NSString (IngredientsUtilities)

- (BOOL)startsWith:(NSS*)s;
- (BOOL)containsString:(NSS*)s;
- (BOOL)caseInsensitiveContainsString:(NSS*)s;
- (BOOL)caseInsensitiveHasPrefix:(NSS*)s;
- (BOOL)caseInsensitiveHasSuffix:(NSS*)s;
- (BOOL)isCaseInsensitiveEqual:(NSS*)s;

@end



/** Convenience NSString functions. */
@interface NSString (additions)

/** Count lines.
 * @returns The number of lines in the string.
 */
- (NSInteger)numberOfLines;

/** Count occurrences of a character.
 * @param ch The character to search for.
 * @returns The number of occurrences of the character.
 */
- (NSUInteger)occurrencesOfCharacter:(unichar)ch;

/** Return the string representation of a key code.
 * @param keyCode The key code to make into a string.
 * @returns The string representation of the key code.
 */
+ (NSS*)stringWithKeyCode:(NSInteger)keyCode;

/** Return the string representation of a key sequence.
 * @param keySequence An array of NSNumbers representing key codes.
 * @returns The string representation of the key codes.
 */
+ (NSS*)stringWithKeySequence:(NSA*)keySequence;

/**
 * @returns YES if the string is in uppercase.
 */
- (BOOL)isUppercase;

/*** @returns YES if the string is in lowercase */
- (BOOL)isLowercase;
- (NSA*)keyCodes;
+ (NSS*)visualStringWithKeySequence:(NSA*)keySequence;
@end


/** This catagory provides some method aliases and extension to existing method set for NSString class. */

/**
 @enum HFSplitRule
 String seperate rules.
 */
enum {
	/** Whole string as seperator */
	HFSplitRuleWhole = 0,
	/** Any charater in string as seperator */
	HFSplitRuleAny
};
typedef int HFSplitRule;

@interface NSString (HFExtension)
/** @name Method Aliases */

/** Method alias for method `uppercaseString`.
 */
- (NSS*)toUpper;

/** Method alias for method `lowercaseString`.
 */
- (NSS*)toLower;

/** Method alias for method `uppercaseString`.
 */
- (NSS*)upCase;

/** Method alias for method `lowercaseString`.
 */
- (NSS*)downCase;

/** Method alias for method `capitalizedString`.
 */
- (NSS*)capitalize;

/** Method alias for method `length`.
 */
- (NSUInteger)size;

/** Method alias for method `length`.
 */
- (NSUInteger)count;

/** @name Convinent Methods */

/** This method is used to seperate a string into parts by some seperator characters.

 @param separator A string of separators. **ALL** the charactors in the string will be used as a separator.
 @return An array of NSString objects.

 This method is a convinient method for split:rule: which use HFSplitRuleAny for parameter rule.
 */
- (NSA*)split:(NSS*)separator;

/** This method is used to seperate a string into parts by seperator characters or a fixed string as seperator.

 @param separator A string of separators or a separator string, depending on the value passed to parameter rule.
 @param rule The rule to decide whether the seperator string is used as a whole or independent charators in the string will be used as seperator(s) to split the original string.
 @return An array of NSString objects.

 - When `HFSplitRuleWhole` is passed, the separetor will be used as the separator as a whole.
 - When `HFSplitRuleAny` is passed, **ALL** the charactors in the string will be used as a separator.
 */
- (NSA*)split:(NSS*)separator rule:(HFSplitRule)rule;

/** Method alias for `lastPathComponent`.

 This is also a convenient method for baseNameWithExtension: when `YES` is passed to parameter `ext`.
 */
- (NSS*)baseName;

/** Return the last path component with or without the file extension.

 @param ext A `BOOL` value which decide whether show the file extension or not.
 */
- (NSS*)baseNameWithExtension:(BOOL)ext;

/** Return the containing directory for a specific path. */
- (NSS*)dirName;

/** Return the character at the index of a string.

 If `index` is beyond the range of the string, `nil` will be returned.

 @param index The index inside a string.
 @return A string containing the characer at the specific `index`, or return `nil`.
 */
- (NSS*)charStringAtIndex:(NSUInteger)index;

/** This method is used to found out whether the string only contains blank characers or nothing(a blank string).

 Since `nil` is not a `NSString` instance, this method can not be used to judge whether a string object is `nil`.
 */
- (BOOL)isBlank;

/** Get rid of blank characters at the beginning and the end of a string object. */
- (NSS*)strip;

/** Get rid of blank characters at the beginning of a string object. */
- (NSS*)lstrip;

/** Get rid of blank characters at the end of a string object. */
- (NSS*)rstrip;

@end

@interface NSScanner (additions)
- (unichar)peek;
- (void)inc;
- (BOOL)expectCharacter:(unichar)ch;
- (BOOL)scanCharacter:(unichar *)ch;
- (BOOL)scanUpToUnescapedCharacterFromSet:(NSCharacterSet *)toCharSet
			   appendToString:(NSMutableString *)string
			     stripEscapes:(BOOL)stripEscapes;
- (BOOL)scanUpToUnescapedCharacterFromSet:(NSCharacterSet *)toCharSet
			       intoString:(NSString **)string
			     stripEscapes:(BOOL)stripEscapes;
- (BOOL)scanUpToUnescapedCharacter:(unichar)toChar
                        intoString:(NSString **)string
                      stripEscapes:(BOOL)stripEscapes;
- (BOOL)scanUpToUnescapedCharacter:(unichar)toChar
                        intoString:(NSString **)string;
- (BOOL)scanShellVariableIntoString:(NSString **)intoString;
- (BOOL)scanString:(NSS*)aString;
- (BOOL)scanKeyCode:(NSInteger *)intoKeyCode;
- (void)skipWhitespace;
@end

/*
Implements fuzzy matching for strings.
*/
@interface NSString (Similiarity)

/*
 Returns 0.0 <= x <= 1.0.  0.0 == not equal (or error), 1.0 == equal.
 Uses Search Kit (a.k.a. AIAT, V-Twin) technology.
 */
- (float)isSimilarToString:(NSS*)aString;

@end


