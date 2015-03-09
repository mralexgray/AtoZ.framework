//
//  DSSyntaxTheme.h
//  DSSyntaxKit
//
//  Created by Fabio Pelosin on 26/09/12.
//  Copyright (c) 2012 Discontinuity s.r.l. All rights reserved.
//

#if TARGET_OS_IPHONE
  #define UINSColor   UIColor
#else
  #import <AppKit/AppKit.h>
  #define UINSColor   NSColor
#endif


@interface AZSyntaxThemes : NSArrayController

@end

/** A DSSyntaxTheme provides color information for syntax coloring. It's 
 properties striclty match the possbile values of DSSyntaxTypeAttribute
 defined by DSSyntaxDefinition. */
@interface AZSyntaxTheme : NSObject

/// @name Background & Context
@property (nonatomic, copy) UINSColor	* backgroundColor,
													* cursorColor,
													* selectionColor;
/// @name Basic Values
@property (nonatomic, copy) UINSColor	* plainTextColor,
													* commentColor,
													* stringColor,
													* keywordColor;
/// @name Advanced Values
@property (nonatomic, copy) UINSColor	* typeColor, 
													* classColor, 
													* constantColor, 
													* variableColor, 
													* attributeColor, 
													* functionColor, 
													* characterColor,
													* numberColor, 
													* macroColor;
/// @name Domain Specific Languages Values

@property (nonatomic, copy) UINSColor* DSLKeywordColor;
/* Returns a barebone theme. */
- (id)init;

@property (strong) NSString *name;

/* @return a default theme (similar to the default theme of Xcode). */

+ defaultTheme;

/* @return a theme initialized with an Xcode theme (.dvtcolortheme files) */
+ themeWithXcodeTheme:(NSString*)path;

///-----------------------------------------------------------------------------
/// @name Integration with DSSyntaxDefinition
///-----------------------------------------------------------------------------

/* @return a color for a given DSSyntaxTypeAttribute. Even if the theme doesn't
 specifies a color for the given key, one is always returned. */
- (UINSColor*)colorForType:(NSString*)type;

/* Convert a string with DSSyntaxDefinitionAttribute to attributed string with
 the theme foreground colors. */
//- (NSAttributedString*)syntaxHighlightedStringForString:(NSAttributedString*);

@end
