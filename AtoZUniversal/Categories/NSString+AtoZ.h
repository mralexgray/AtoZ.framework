

#import <AtoZUniversal/AtoZMacroDefines.h>

@interface NSAttributedString (NTExtensions)

+ (INST) stringWithString:_Text_ inString attributes:_Dict_ attributes;

@end

/// @see NSString-Utilities.h in CocoaTechCore!!

@class AZDefinition;
@interface NSString (AtoZ)


@prop_RO Class classified;

+ _List_ alphabet;
+ _List_ digits;
+ _List_ lettersAndNumbers; /// A-Z + 1-9

@prop_RO  BOOL    isInteger,
                  isValidURL;

@prop_   NSRNG	  subRange;
@prop_RO NSRNG    range;

- _Void_ openInTextMate;

- _Comp_ compareNumberStrings: _Text_ str;
- _Text_ justifyRight: _UInt_ col;
- _Text_   withFormat: _Text_ format,...;


#pragma mark - Parsing / Cleaning
@prop_RO _Text JSONRepresentation,
							 stringByDecodingXMLEntities,
							 stringByCleaningJSONUnicode,
							 stringByStrippingHTML,
							 unescapeQuotes,
							 stripHtml,
							 decodeHTMLCharacterEntities,
							 encodeHTMLCharacterEntities,
							 escapeUnicodeString,
							 unescapeUnicodeString,
							 decodeAllAmpersandEscapes,
							 urlEncoded,
							 urlDecoded,
							 MD5String,
               humanReadableEncoding;

@prop_RO const char * ASCIIString;

@prop_RO _Data UTF8Data;

- _Text_ parseXMLTag: _Text_ tag;

//- (NSS*)decodeAllPercentEscapes;

#pragma mark - LEXICONS

+ _Text_ newUniqueIdentifier;
+ _Text_ randomAppPath;
+ _List_ testDomains;
+ _List_ weirdUnicodes;

@property (readonly) NSA* letters;

- _Text_ times:(int)count;
- _Text_ tidyHTML;
- _Text_ decodeHTMLCharacterEntities;
- _Text_ encodeHTMLCharacterEntities;

+ _Text_ dicksonBible;
+ _List_ dicksonisms;
+ _Text_ randomDicksonism;
+ _List_ dicksonPhrases;
+ _Text_ dicksonParagraphWith:(NSUI)sentences;

+ _List_ gaySlang;
+ _Text_ randomGaySlang;

+ _List_ badWords;
+ _Text_ randomBadWord;

+ _Dict_ properNamesByLetter;
+ _List_ properNames;
/** A "random" Wiipedia definition.. from some list of words I rustle up, from somewhere..
  * @exception Still gives you a string, but it will say something like "No Wikipedia Entry for adenomyxosarcoma!"

    NSString.randomWiki ->
    subinfeudation: In English law, subinfeudation is the practice by which tenants, holding land under the king or other superior lord, carved out new and distinct tenures in their turn by sub-letting or alienating a part of their lands. The tenants were termed "mesne-lords," with regard to those holding from them, the immediate tenant being tenant in capite. The lowest tenant of all was the freeholder, or, as he was sometimes termed tenant paravail. The Crown, who in theory owned all lands, was lord paramount.
*/
+ _Text_ randomWiki;

/** A smartly parsed + concise "Wikipedia" "definition" of an NSString instance.
 *  @see NSString wikiDescription
    @"apple".wikiDescription ->
    Apple Inc. is an American multinational corporation that designs and sells consumer electronics, computer software, and personal computers. The company's best-known hardware products are the Macintosh line of computers, the iPod, the iPhone and the iPad.
*/
@prop_RO _Text wikiDescription;

/** @return A "random" word, like _dehydrogenate_ fetched from the kind folks at http://randomword.setgetgo.com/get.php */
+ _Text_ randomWord;


/** Provides a limitless bountry of nonsense words!
    @param The number of words you want.
    [NSString randomWords:10] -> neque lacus morbi a lacinia nonummy bibendum cras iaculis nunc mollis
*/


+ _Text_ randomWords:(NSI)number;
/** A gramatically-sound, entirely incompreghensible number of complete "phrases".
    @param The number of "sentences" you want.
    [NSString randomSentences:2] = Lacus morbi a lacinia nonummy bibendum cras iaculis nunc mollis ac nec et sem. Nibh cum vitae leo tellus in eget penatibus neque sed taciti velit ipsum integer in augue sapien.
*/
+ _Text_ randomSentences:(NSI)number;


+ _Text_        spaces: _UInt_ ct;
- _Text_      paddedTo: _UInt_ ct;
- _Text_ paddedRightTo: _UInt_ ct;
- _UInt_ longestWordLength;

+ _Text_ clipboard;
- _Void_ copyToClipboard;

- _Text_ withExtIfMissing:(NSS*)ext;

@prop_RO _Text sansComponent, sansExtension;

- _IsIt_ loMismo:	_Text_ s;

- (unichar)lastCharacter;
- _Void_ copyFileAtPathTo: _Text_ path;

- (CGF) pointSizeForFrame:(NSR)frame withFont: font;
+ (CGF) pointSizeForFrame:(NSR)frame withFont: font forString:(NSS*) string;

- _Text_ stringByReplacingAnyOf:(NSA*)strings withString:(NSS*)fix;
- _Text_ stringByReplacingAllOccurancesOfString: _Text_ search withString: _Text_ replacement;

- _Text_ substringToLastCharacter;
- (NSN*) numberValue;

AZPROPERTY(NSS, RO, *firstLetter, *lastLetter, *language);

- _Size_ sizeWithFont: _Font_ font;
- _Size_ sizeWithFont: _Font_ font margin: _Size_ size;

- (CGF)widthWithFont: _Font_ font;
- (NSR)frameWithFont: _Font_ font;

//@prop_RO NSC *colorValue;
- _Void_ drawInRect:(NSR)r withFontNamed:(NSS*) fontName andColor: _Colr_ color;
// new way
- _Void_ drawInRect:(NSR)r withFont: _Font_ font andColor: _Colr_ color;
//- _Void_ drawCenteredInRect: (NSR)rect withFontNamed: (NSS*) font;
- _Void_ drawCenteredInRect:(NSR)rect withFont: _Font_ font;

@prop_RO	NSS * trim,				/*** Returns the string cleaned from leading and trailing whitespaces */
							 * reversed,		/*** Returns the reverse version of the string */
							 *	shifted,			/*** Returns the substring after the first character in this string */
							 * popped,			/*** Returns the substring not containing the last character of this string */
							 * chopped,			/*** Combination of shifted and popped, removes the first and last character */
							 * camelized,		/*** Returns a CamelCase Version of this string */
							 * hyphonized,
							 * underscored;
@prop_RO BOOL   isHexString,
                         isEmpty;		/*** Returns YES if this string is nil or contains nothing but whitespaces */
@prop_RO NSUI   indentationLevel;									/*** Counts the whitespace chars that prefix this string */
- (NSUI)count:(NSS*)aString;														/*** Counts occurrences of a given string */
- (NSUI)count:(NSS*)aString options:(NSStringCompareOptions)flags; 	/*** Cunts occurrences of a given string with sone compare options */

/* NOTICE nil and @"" are never part of any compared string */
- (BOOL)      contains:(NSS*)s; /*! YES when aString is part of the this string. */
- (BOOL) containsAnyOf:(NSA*)a;	/*! YES when this string contains ANY of the strings defined in the array */
- (BOOL) containsAllOf:(NSA*)a; /*! YES when this string contains ALL of the strings defined in the array */
- (BOOL)    startsWith:(NSS*)s;	/*! YES when this string starts with aString, just a synonym for hasPrefix */
- (BOOL)      endsWith:(NSS*)s;	/*! YES when this string ends with aString, just a synonym for hasSuffix */
- (BOOL)     hasPrefix:(NSS*)p
             andSuffix:(NSS*)s; /*! YES when this string has both given prefix and suffix */

/*** Substring between prefix and suffix. If either prefix or suffix cannot be matched nil will be returned */
- (NSS*) substringBetweenPrefix:(NSS*)p andSuffix:(NSS*)s;
/*** Oldscool indexOf, if you do not want to handle NSRange objects will return -1 instead of NSNotFound */
-  (NSI) indexOf:(NSS*)s;
-  (NSI) indexOf:(NSS*)s afterIndex:(NSI)i;
/*** Oldscool lastIndexOf, if you do not want to handle NSRange objects will return -1 instead of NSNotFound */
-  (NSI) lastIndexOf:(NSS*)aString;
/*** Returns the first NSRange of any matching substring in this string that is part of the strings set */
- (NSRNG) rangeOfAny:(NSSet*)strings;
/*** Returns this string splitted by lines. * Shortcut for componentsSeperatedByString:@"\n" */
@prop_RO NSA * lines;
/*** Returns this string splitted by carriage return + newline. * Shortcut for componentsSeperatedByString:@"\r\n" */
@prop_RO NSA *eolines;



/*** Returns this string splitted by whitespaces.  Shortcut for componentsSeperatedByString:@" " Empty elements will not be part of the array */
@prop_RO NSA * words;
@prop_RO NSA * wordsWithRanges;
/*** Returns a set with all unique elements of this String, separated by whitespaces */
@prop_RO NSSet *wordSet;

- _List_ trimmedComponentsSeparatedByString:(NSS*) delimiter;

@prop_RO NSA *decolonize, *splitByComma;

+ (INST) fromFile:_Text_ file;

- _Text_ substringBefore:(NSS*)delimiter;
- _Text_  substringAfter:(NSS*)delimiter;
// The difference between the splitBy and splitAt groups is that splitAt will return an array containing one or two elements
- _List_ splitAt:(NSS*)delimiter;
- _IsIt_ splitAt:(NSS*)delimiter head:(NSS**)head tail:(NSS**)tail;

// excuse the pun, but it divides the string into a head and body word, trimmed
@prop_RO  NSA * decapitate;
// TBD whether they belong here or elsewhere
@prop_RO  NSP   pointValue;
@prop_RO NSUI   minutesValue, secondsValue;

@prop_RC NSURL * url, * fileURL;

@prop_RO NSS * ucfirst, * lcfirst,  *fileContents;

@prop_RO NSAS * attributedWithDefaults;


+ (INST)   stringWithCGFloat: (CGF)f		 maxDigits: (NSUI)numDigits;
//- (NSAS*) attributedWithSize: (NSUI)size andColor: (NSC*)color;
- (NSAS*) attributedWith:(NSD*)attrs;
- (NSAS*) attributedWithFont:(NSF *)font andColor:(NSC *)color;
- (NSMAS*) attributedParagraphWithSpacing:(CGF)spacing;
- _Text_ truncatedForRect:(NSR)frame withFont:(NSF *)font;
//-(NSMutableAttributedString *) attributedParagraphWithSpacing:(CGF)spacing

- _Text_ truncateInMiddleForWidth:(CGF)overall;
- _Text_ truncateInMiddleToCharacters:(NSUI)chars;

@end
// Truncate a string by inserting an ellipsis ("..."). truncateMode can be NSLineBreakByTruncatingHead, NSLineBreakByTruncatingMiddle or NSLineBreakByTruncatingTail.
NSS *   StringByTruncatingStringWithAttributesForWidth(NSS *s, NSD *attrs, float wid, NSLineBreakMode truncateMode);

@interface NSMutableString (AtoZ)

@prop_RC _Text shift, pop;

- _IsIt_ removePrefix:(NSS*)prefix;
- _IsIt_ removeSuffix:(NSS*)suffix;
- _IsIt_ removePrefix:(NSS*)prefix andSuffix:(NSS*)suffix;
- (NSMS*) camelize;
- (NSMS*) hyphonize;
- (NSMS*) underscorize;
- (NSMS*) replaceAll:(NSS*)needle withString:(NSS*)replacement;
@end
/**
@interface NSString (RuntimeReporting)
- (BOOL) hasSubclasses;
- (NSA*) subclassNames;
- (NSA*) methodNames;
- (NSA*) ivarNames;
- (NSA*) propertyNames;
- (NSA*) protocolNames;
@end
*/

@interface NSMutableAttributedString (AtoZ)
- _Void_ resizeTo:(CGFloat)size;
- _Void_ setFont:(NSFont*)f;
@end
@interface NSAttributedString (AtoZ)
@prop_RO NSRNG range;
- (CGF) pointSizeForSize:(NSSZ)z;
- _Void_ drawInRect:(NSR)r withBackground:(NSC*)c;
- _Void_ drawInRect:(NSR)r withContrastingBackground:(NSC*)c;
- _Void_ drawInRect:(NSR)r aligned:(AZA)a bgC:(NSC*)c;
- _Void_ draw;
@prop_RO NSFont *font;
@prop_RO NSMD* attributes;
+ (NSD*) defaults;
- (NSAS*) stringBySettingAttributes:(NSD*)attr;
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

- _Void_ drawCenteredVerticallyInRect:(NSRect)rect;

// Measuring Attributed Strings
- (NSSize)sizeForWidth:	(CGF)width height:(CGF)height;
- (CGF)heightForWidth:(CGF)width;
- (CGF)widthForHeight:(CGF)height;

@end

@interface NSString (Geometrics)

// Measuring a String With Attributes
- (NSSize)sizeForWidth: (CGF)width
					 height: (CGF)height attributes:(NSD*)attributes;
- (CGF)heightForWidth:(CGF)width  attributes:(NSD*)attributes;
- (CGF)widthForHeight:(CGF)height attributes:(NSD*)attributes;

// Measuring a String with a constant Font
//- (NSSize)sizeInSize: (NSSize)size      font: (NSFont*)font;

- (NSSize)sizeForWidth:(CGF)width height:(CGF)height font:(NSFont *)font;
- (CGF)heightForWidth:(CGF)width font:(NSFont *)font;
- (CGF)widthForHeight:(CGF)height font:(NSFont *)font;

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

@prop_RO NSA *sentences;
@prop_RO NSS *firstSentence;
@end

@interface NSMutableString (Extensions)
- _Void_ trimWhitespaceAndNewlineCharacters;   // From both ends
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

+ (INST) stringWithFormat:(NSS*)format array:(NSA*)arguments;

/*! @name Initilizing a String */

/*!
 *  @brief Initialize an NSString from integer value.
 *  @details Implemented with [NSString initWithFormat:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/initWithFormat:
 */
- initWithInteger:(NSInteger)value;

/*!
 *  @brief Initialize an NSString object with concatnating given arguments.
 *  @details Appends all arguments to first string one by one by order.
 */
- initWithConcatnatingStrings:(NSS*)first, ...NS_REQUIRES_NIL_TERMINATION;

/*! @name Creating a String */

/*!
 *  @brief Creates and returns an NSString from integer value.
 *  @see initWithInteger:
 */
+ (INST) stringWithInteger:(NSInteger)value;

/*!
 *  @brief Creates and returns an NSString object initialized by using a given format string as a template into which the remaining argument values are substituted according to the user’s default locale.
 *  @see [initWithFormat:arguments:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/initWithFormat:arguments:
 */
+ (INST) stringWithFormat:(NSS*)format arguments:(va_list)argList NS_FORMAT_FUNCTION(1, 0);

/*!
 *  @brief Creates and returns an NSString object initialized by converting given data into Unicode characters using a given encoding.
 *  @see [initWithData:encoding:][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instm/NSString/initWithData:encoding:
 */
// IN CocosTechCore
//+ (INST) stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

- (NSString *)stringByRemovingCharactersInCharacterSet:(NSCharacterSet *)removeSet;
- (NSString *)stringByRemovingReturns;

/*!
 *  @brief Creates and returns an NSString object with concatnating given arguments.
 */
+ (INST) stringWithConcatnatingStrings:(NSS*)first, ...NS_REQUIRES_NIL_TERMINATION;

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
- (NSS*)format: first, ...;
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
- (NSS*)format0: dummyLikeNil, ...;

/*! @name Range */

/*!
 *  @brief Returns range of string.
 *  @see [NSRangeFromString][0]
 *	  [0]: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Functions/Reference/reference.html#//apple_ref/c/func/NSRangeFromString
 */
@property (readonly) NSRange range;

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
@prop_RO NSS * stringWithoutSpaces,  * stringByRemovingExtraneousWhitespace, * MD5, * URLEncodedString,
                      * normalizedString,     * upperBoundsString,                    * spaceSeparatedComponents;

- (NSS*)stringByFilteringToCharactersInSet:(NSCharacterSet *)set;
- (NSS*)stringByRemovingNonAlphanumbericCharacters;
+ (NSS*)stringFromFileSize:(NSUInteger)theSize;
- (NSS*)URLEncodedStringForCharacters:(NSS*)characters;
+ (NSS*)timeStringForTimeInterval:(NSTimeInterval)interval;
+ (NSS*)humanReadableStringForTimeInterval:(NSTimeInterval)interval;
+ (NSS*)randomUUID;
+ (NSData*)HMACSHA256EncodedDataWithKey:(NSS*)key data:(NSS*)data;
@end

@interface NSAttributedString (SNRAdditions)
- (NSAttributedString *)attributedStringWithColor:(NSColor *)color;
- (NSColor *)color;
@end

@interface NSString (IngredientsUtilities)

- (BOOL) startsWith:(NSS*)s;
- (BOOL) containsString:(NSS*)s;
- (BOOL) caseInsensitiveContainsString:(NSS*)s;
- (BOOL) caseInsensitiveHasPrefix:(NSS*)s;
- (BOOL) caseInsensitiveHasSuffix:(NSS*)s;
- (BOOL) isCaseInsensitiveEqual:(NSS*)s;

@end

/** Convenience NSString functions. */
@interface NSString (additions)

+ (INST) stringWithCharacter:(unichar)c;

/** Count lines.
 * @returns The number of lines in the string.
 */
@prop_RO NSI numberOfLines;

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
@prop_RO BOOL isUppercase,

/*** @returns YES if the string is in lowercase */
                        isLowercase;

@prop_RO NSA * keyCodes;

+ (NSS*) visualStringWithKeySequence:(NSA*)keySequence;
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

/** Method decapitalies FIRST letter. useful for getting the getter from a setter!
 */
- (NSS*)decapitalized;

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

/*! Method alias for `lastPathComponent`. This is also a convenient method for baseNameWithExtension: when `YES` is passed to parameter `ext`.
 */ @prop_RO NSS * baseName;
/*! Return the containing directory for a specific path. 
 */ @prop_RO NSS * dirName;

/*
*/ @prop_RO NSS *stringByDeletingPathComponentsWithoutExtensions;
@prop_RO NSIMG * iconForFile;

/** Return the last path component with or without the file extension.
 @param ext A `BOOL` value which decide whether show the file extension or not.
 */
- (NSS*) baseNameWithExtension:(BOOL)ext;


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
- _Void_ inc;
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
- _Void_ skipWhitespace;
@end

/*
Implements fuzzy matching for strings.
*/
@interface NSString (Similiarity)

/*
 Returns 0.0 <= x <= 1.0.  0.0 == not equal (or error), 1.0 == equal.
 Uses Search Kit (a.k.a. AIAT, V-Twin) technology.
 */
- (CGF)isSimilarToString:(NSS*)aString;

@end


@interface NSMutableString (DSCategory)
/// @name White spaces
- _Void_ stripTrailingWhiteSpaces;
@end

@interface NSString (DSCategory)
/// @name General
@property (nonatomic, readonly) NSRange range;
-(BOOL)isValid;
/// @name White spaces
- (NSString*)indentation;
/// @name Regular Expressions
/** Returns the substring matched by a regular expression pattern.
 @param pattern The pattern to use for the match.
 @return Returns the substring of the pattern.
 @exception NSException Thrown if the pattern is `nil` or empty.
 */
- (NSString*)matchForPattern:(NSString*)pattern;

/** Returns an array contianing the matches of a regular expression pattern.
 @param pattern The pattern to use for the match.
 @return An array of NSTextCheckingResult.
 @exception NSException Thrown if the pattern is `nil` or empty.
 */
- (NSArray*)matchesForPattern:(NSString*)pattern;
/// @name Derived from Ruby
@end


@interface NSCharacterSet (GetCharacters)

@prop_RO NSS * name;
@prop_RO NSA * characters;

+ (NSA*) alphanumericCharacters;
+ (NSA*) capitalizedLetterCharacters;
+ (NSA*) controlCharacters;
+ (NSA*) decimalDigitCharacters;
+ (NSA*) decomposableCharacters;
+ (NSA*) illegalCharacters;
+ (NSA*) letterCharacters;
+ (NSA*) lowercaseLetterCharacters;
+ (NSA*) newlineCharacters;
+ (NSA*) nonBaseCharacters;
+ (NSA*) punctuationCharacters;
+ (NSA*) symbolCharacters;
+ (NSA*) uppercaseLetterCharacters;
+ (NSA*) whitespaceAndNewlineCharacters;
+ (NSA*) whitespaceCharacters;

/** Print out all characters of any of these sets:
 + alphanumericCharacterSet
 + capitalizedLetterCharacterSet
 + controlCharacterSet
 + decimalDigitCharacterSet
 + decomposableCharacterSet
 + illegalCharacterSet
 + letterCharacterSet
 + lowercaseLetterCharacterSet
 + newlineCharacterSet
 + nonBaseCharacterSet
 + punctuationCharacterSet
 + symbolCharacterSet
 + uppercaseLetterCharacterSet
 + whitespaceAndNewlineCharacterSet
 + whitespaceCharacterSet
 */

@end


@interface NSCharacterSet (EmojisAddition)
- _Void_ log;

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
- (BOOL) isMatchedByRegex:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range error:(_Errr __autoreleasing*) error;
- (NSRange) rangeOfRegex:(NSS*) regex inRange:(NSRange) range;
- (NSRange) rangeOfRegex:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range capture:(NSInteger) capture error:(_Errr __autoreleasing*) error;
- (NSS*) stringByMatching:(NSS*) regex capture:(NSInteger) capture;
- (NSS*) stringByMatching:(NSS*) regex options:(NSRegularExpressionOptions) options inRange:(NSRange) range capture:(NSInteger) capture error:(_Errr __autoreleasing*) error;
- (NSArray *) captureComponentsMatchedByRegex:(NSS*) regex options:(NSRegularExpressionOptions) options range:(NSRange) range error:(_Errr __autoreleasing*) error;
- (NSS*) stringByReplacingOccurrencesOfRegex:(NSS*) regex withString:(NSS*) replacement;
- (NSS*) stringByReplacingOccurrencesOfRegex:(NSS*) regex withString:(NSS*) replacement options:(NSRegularExpressionOptions) options range:(NSRange) searchRange error:(_Errr __autoreleasing*) error;
- (NSUInteger) levenshteinDistanceFromString:(NSS*) string;
@end

@interface NSMutableString (NSMutableStringAdditions)
- _Void_ encodeXMLSpecialCharactersAsEntities;
- _Void_ decodeXMLSpecialCharacterEntities;
- _Void_ escapeCharactersInSet:(NSCharacterSet *) set;
- _Void_ replaceCharactersInSet:(NSCharacterSet *) set withString:(NSS*) string;
- _Void_ encodeIllegalURLCharacters;
- _Void_ decodeIllegalURLCharacters;
- _Void_ stripIllegalXMLCharacters;
- _Void_ stripXMLTags;
@end


@interface NSRegularExpression (Additions)
+ (NSRegularExpression *) cachedRegularExpressionWithPattern:(NSString *) pattern options:(NSRegularExpressionOptions) options error:(NSError *__autoreleasing*) error;
@end


