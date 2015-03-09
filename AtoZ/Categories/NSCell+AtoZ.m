//
//  NSCell+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 11/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSCell+AtoZ.h"
#import <AtoZ/AtoZ.h>
//@implementation NSButton (TextColor)
//
//- (NSColor *)textColor
//{
//    NSAttributedString *attrTitle = [self attributedTitle];
//    int len = [attrTitle length];
//    NSRange range = NSMakeRange(0, MIN(len, 1)); // take color from first char
//    NSDictionary *attrs = [attrTitle fontAttributesInRange:range];
//    NSColor *textColor = [NSColor controlTextColor];
//    if (attrs) {
//        textColor = [attrs objectForKey:NSForegroundColorAttributeName];
//    }
//    return textColor;
//}
//
//- _Void_ setTextColor:(NSColor *)textColor
//{
//    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] 
//                                            initWithAttributedString:[self attributedTitle]];
//    int len = [attrTitle length];
//    NSRange range = NSMakeRange(0, len);
//    [attrTitle addAttribute:NSForegroundColorAttributeName 
//                      value:textColor 
//                      range:range];
//    [attrTitle fixAttributesInRange:range];
//    [self setAttributedTitle:attrTitle];
//}
//
//@end

@implementation NSButton (SNRAdditions)
- (NSColor *)textColor
{
	return [[self attributedTitle] color];
}

- (void) setTextColor:(NSColor *)textColor
{
	[self setAttributedTitle:[[self attributedTitle] attributedStringWithColor:textColor]];
}

- (NSColor *)alternateTextColor
{
	return [[self attributedAlternateTitle] color];
}

- (void) setAlternateTextColor:(NSColor *)alternateTextColor
{
	NSAttributedString *string = self.attributedAlternateTitle ?: self.attributedTitle;
	[self setAttributedAlternateTitle:[string attributedStringWithColor:alternateTextColor]];
}
@end


@implementation NSCell (AtoZ)

@end

static NSColor *highlightColor;

@implementation RNAddListItemCell

@synthesize favorite = favorite_;
//@synthesize category = category_;
@synthesize titleAttributes = titleAttributes_;
@synthesize selectedTitleAttributes = selectedTitleAttributes_;
@synthesize categoryAttributes = categoryAttributes_;
@synthesize selectedCategoryAttributes = selectedCategoryAttributes_;

+(void)initialize {
	highlightColor = [NSColor colorWithCalibratedRed:0.17 green:0.409 blue:0.793 alpha:1.0f];
}

-(void)setObjectValue: obj {
	if (![obj ISADICT])
		return;
//	[self setCategory:[obj valueForKey:@"category"]];
	[self setFavorite:[obj valueForKey:@"favorite"]];
	[super setObjectValue:[obj valueForKey:@"title"]];
}

-(NSD*)titleAttributes {
	if (!titleAttributes_) {
		NSMutableDictionary *attributes = @{}.mutableCopy;
		[attributes setValue:[NSFont controlContentFontOfSize:12.0f] forKey:NSFontAttributeName];
		[attributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
		titleAttributes_ = attributes;
	}
	return titleAttributes_;
}

-(NSD*)selectedTitleAttributes {
	if (!selectedTitleAttributes_) {
		NSMutableDictionary *attributes = @{}.mutableCopy;
		[attributes setValue:[NSFont fontWithName:@"LucidaGrande-Bold" size:12.0f] forKey:NSFontAttributeName];
		[attributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
		selectedTitleAttributes_ = attributes;
	}
	return selectedTitleAttributes_;
}

//-(NSD*)categoryAttributes {
//	if (!categoryAttributes_) {
//		NSMutableDictionary *attributes = @{}.mutableCopy;
//		[attributes setValue:[NSFont controlContentFontOfSize:10.0f] forKey:NSFontAttributeName];
//		[attributes setValue:[NSColor darkGrayColor] forKey:NSForegroundColorAttributeName];
//		categoryAttributes_ = attributes;
//	}
//	return categoryAttributes_;
//}
//
//-(NSD*)selectedCategoryAttributes {
//	if (!selectedCategoryAttributes_) {
//		NSMutableDictionary *attributes = @{}.mutableCopy;
//		[attributes setValue:[NSFont controlContentFontOfSize:10.0f] forKey:NSFontAttributeName];
//		[attributes setValue:[NSColor colorWithCalibratedWhite:0.9f alpha:1.0f] forKey:NSForegroundColorAttributeName];
//		selectedCategoryAttributes_ = attributes;
//	}
//	return selectedCategoryAttributes_;
//}

-(NSAttributedString *)attributedStringValue {
	return [NSAttributedString.alloc initWithString:[self stringValue] attributes:[self isHighlighted] ? [self selectedTitleAttributes] : [self titleAttributes]];
}

-(NSAttributedString *)categoryAttributedString {
	id myCategory;// = [self category];
	return [NSAttributedString.alloc initWithString:myCategory == [NSNull null] ? @"No category assigned" : [myCategory title] attributes:[self isHighlighted] ? [self selectedCategoryAttributes] : [self categoryAttributes]];
}


static CGFloat titleLeftPadding = 14.0f;

-(NSRect)titleRectForBounds:(NSRect)cellFrame {
	return NSMakeRect(NSMinX(cellFrame) + titleLeftPadding, NSMinY(cellFrame), NSWidth(cellFrame) - titleLeftPadding, [[self attributedStringValue] size].height);
}

-(NSRect)categoryRectForBounds:(NSRect)cellFrame {
	NSRect titleRect = [self titleRectForBounds:cellFrame];
	NSRect categoryRect = NSMakeRect(NSMinX(titleRect), NSMaxY(titleRect), NSWidth(titleRect), NSHeight(cellFrame) - NSHeight(titleRect));
	return categoryRect;
}

-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	if ([self isHighlighted]) {
		NSRect highlightRect = NSInsetRect(cellFrame, 4.0f, 0.0f);
		NSBezierPath *highlightPath = [NSBezierPath bezierPathWithRoundedRect:highlightRect xRadius:10 yRadius:10];//RNDetailViewCellCornerRadius yRadius:RNDetailViewCellCornerRadius];
		[highlightColor setFill];
		[highlightPath fill];
	}
	[[self attributedStringValue] drawInRect:[self titleRectForBounds:cellFrame]];
	//	NSAttributedString *categoryString = [NSAttributedString.alloc initWithString:[[self category] title] attributes:[self categoryAttributes]];
	[[self categoryAttributedString] drawInRect:[self categoryRectForBounds:cellFrame]];
}

@end


@implementation NSValueTransformer (SRAdditions)

-(void)registerTransformerWithClassName {
	[NSValueTransformer setValueTransformer:self forName:[NSString stringWithFormat:@"%@Name", [self className]]];
}

@end
