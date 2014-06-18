

@interface NSTextView (SyntaxColoring)

- (void)colorizeWithKeywords:(NSA*)keywords classes:(NSA*)classes;

@end
@interface NSString (SyntaxColoring)

- (NSAS*)colorizeWithKeywords:(NSA*)keywords classes:(NSA*)classes;

@end
@interface NSMutableAttributedString (RTB)

- (void)setTextColor:(NSC*)color font:(NSFont*)font range:(NSRNG)range;

@end


//#if TARGET_OS_IPHONE
//#import <UIKit/UIKit.h>
//#else
//@compatibility_alias UIColor NSColor;
//@compatibility_alias UIFont NSFont;
//#endif
//
//
//  NSTextView+SyntaxColoring.h
//  RuntimeBrowser
//
//  Created by Nicolas Seriot on 04.08.08.
//  Copyright 2008 seriot.ch. All rights reserved.
//
