//
//  ZWEmoji.h
//  ZWEmoji
//
//  Created by Zach Waugh on 8/31/12.
//  Copyright (c) 2012 Zach Waugh. All rights reserved.
//

@import AtoZUniversal;

@interface AZEmoji : NSString
_RO NSS * alias, * group, *code;
@end


@interface AtoZEmoji : AtoZSingleton @end

@interface AtoZEmoji  (Methods)

+ (NSD*) codes;                      // Dictionary keyed by :<code>:
+ (NSD*) emojis;                     // Dictionary keyed by unicode emoji character

/*! unicode character for emoji :<code>: */
+ (AZEmoji*) emojiForCode:(NSS*)c;

/*! @c :<code>: for emoji unicode character */
+ (NSS*) codeForEmoji:(NSS*)e;

/*! Replace codes with emoji unicode characters */
+ (NSS*) emojify:(NSS*)s;

/*! @return a dictionary that holds a string and array of emojis that were replaced useful if you need the ranges of all the replacements */
+ (NSD*) emojifyAndReturnData:(NSS*)s;

/*! Replace emoji unicode characters with codes, allows users to input emoji directly without having to worry about the code */
+ (NSS*) unemojify:(NSS*)s;

/*! Replace emoji unicode characters with codes, ignoring anything in ignore
    This is useful when you don't want to replace characters like TM with their emoji equivalent */
+ (NSS*) unemojify:(NSS*)s ignore:(NSSet*)ignore;

/**
 IRFEmojiCheatSheet Created by Fabio Pelosin on 08/11/13. Copyright (c) 2013 Fabio Pelosin. All rights reserved.
 Offers programmatic access to emojis as organized in the
 emoji-cheat-sheet.com website.
*/
/**
 Returns the list of the emoji groups found on the emoji-cheat-sheet.com
 website in the same order. People,Nature,Objects,Places,Symbols
 */
+ (NSA*) groups;

/**
 Returns a dictionary where the keys are the names of the groups and the values
 are the lists of the emoji aliases associated with that group.
 */
+ (NSD*) byGroups;

/**
 Returns a dictionary which maps the aliases to the emoji characters.
 */
+ (NSD*) byAlias;

/**
 Replaces the aliases surrounded by colons with the emoji characters.
 */
+ (NSS*) stringByReplacingEmojiAliasesInString:(NSS*)string;

+ (NSA*) all;
+ (NSS*) random;

@end

/*! Convenience category for emojifying a string */
@interface NSString (AtoZEmoji)

/*! new string with all emoji codes replaced with their unicode equivalent */

+ (NSD*) emojiDictionary;
+ (NSA*) emoji;
+ (NSA*) knownEmoticons;
+ (NSSet*) knownEmojiWithEmoticons;

_RO  NSS * emojify, * stringWithEmoticons4Emoji, * stringWithEmoji4Emoticons;
_RO  NSA * emojiColors;
_RO NSIMG * emojiColorPreview;
_RO BOOL   isEmoji,
                 containsEmoji,
                 containsEmoticon;

-   (BOOL) containsEmojiInRange:(NSRNG)r;
-  (NSRNG)  rangeOfEmojiInRange:(NSRNG)r;


@end
@interface NSMS (AtoZEmoji)
- (void) swapEmoticons4Emoji;
- (void) swapEmoticons4EmojiInRange:(NSRangePointer)r;
- (void) swapEmoticons4EmojiInRange:(NSRangePointer)r withXMLSpecialCharactersEncodedAsEntities:(BOOL)e;
- (void) swapEmoji4Emoticons;
- (void) swapEmoji4EmoticonsInRange:(NSRangePointer)r;
- (void) swapEmoji4EmoticonsInRange:(NSRangePointer)r encodeXMLSpecialCharactersAsEntities:(BOOL)e;
@end
//extern NSString * const ZWEmojiStringKey, * const ZWEmojiReplacedEmojiKey;

@interface NSCharacterSet (AtoZEmoji)

+ (NSCharacterSet*) emojiCharacterSet;
@end
