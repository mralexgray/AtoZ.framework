//
//  NSButton+AtoZ.m
//  AtoZAppKit
//
//  Created by Alex Gray on 4/6/13.
//  Copyright (c) 2013 mrgray.com. All rights reserved.
//

#import "NSButton+AtoZ.h"

@implementation NSButton (AtoZ)
- (NSColor *)textColor
{
	NSAttributedString *attrTitle = [self attributedTitle];
	int len = [attrTitle length];
	NSRange range = NSMakeRange(0, MIN(len, 1)); // get the font attributes from the first character
	NSDictionary *attrs = [attrTitle fontAttributesInRange:range];
	NSColor *textColor = [NSColor controlTextColor];
	if (attrs)
	{
		textColor = [attrs objectForKey:NSForegroundColorAttributeName];
	}
	
	return textColor;
}

- (void)setTextColor:(NSColor *)textColor
{
	NSMutableAttributedString *attrTitle =
	[[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
	int len = [attrTitle length];
	NSRange range = NSMakeRange(0, len);
	[attrTitle addAttribute:NSForegroundColorAttributeName value:textColor range:range];
	[attrTitle fixAttributesInRange:range];
	[self setAttributedTitle:attrTitle];

}


@end
