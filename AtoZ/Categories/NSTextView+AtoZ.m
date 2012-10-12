//
//  NSTextView+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/16/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import "NSTextView+AtoZ.h"

@implementation AZTextViewResponder
- (void) mouseDown:(NSEvent *)theEvent {
	[[self nextResponder] mouseDown:theEvent];
}
@end


@implementation NSTextView (AtoZ)


+ (AZTextViewResponder*)  textViewForFrame:(NSRect)frame withString:(NSAttributedString*)s {

	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];//
		// alloc] init];
		//	[theStyle setLineSpacing:[s enumerateAttributesInRange:[s length] options:nil usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		//	}]  floor((int)(.8 * s.font.pointSize)];
	AZTextViewResponder *anAtv = [[AZTextViewResponder alloc]initWithFrame:frame];
	anAtv.selectable					= NO;
	anAtv.defaultParagraphStyle	   		= style;
	anAtv.backgroundColor			 	= CLEAR;
	anAtv.textStorage.attributedString 	= s;
	style.lineSpacing = (anAtv.textStorage.font.pointSize * .8);
	anAtv.defaultParagraphStyle	   		= style;
//	[anAtv textStorage].foregroundColor = [NSColor blackColor]];
	return  anAtv;
}

- (IBAction)increaseFontSize:(id)sender
{
    NSTextStorage *textStorage = [self textStorage];
    [textStorage beginEditing];
    [textStorage enumerateAttributesInRange: NSMakeRange(0, [textStorage length])
									options: 0
								 usingBlock: ^(NSDictionary *attributesDictionary,
											   NSRange range,
											   BOOL *stop)
	{
#pragma unused(stop)
	NSFont *font = attributesDictionary[NSFontAttributeName];
         if (font) {
             [textStorage removeAttribute:NSFontAttributeName range:range];
             font = [[NSFontManager sharedFontManager] convertFont:font toSize:[font pointSize] + 1];
             [textStorage addAttribute:NSFontAttributeName value:font range:range];
         }
     }];
    [textStorage endEditing];
    [self didChangeText];

}

- (void)changeFontSize:(CGFloat)delta;
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSTextStorage * textStorage = [self textStorage];
    [textStorage beginEditing];
    [textStorage enumerateAttribute:NSFontAttributeName
                            inRange:NSMakeRange(0, [textStorage length])
                            options:0
                         usingBlock:^(id value,
                                      NSRange range,
                                      BOOL * stop)
     {
         NSFont * font = value;
         font = [fontManager convertFont:font
                                  toSize:[font pointSize] + delta];
         if (font != nil) {
             [textStorage removeAttribute:NSFontAttributeName
                                    range:range];
             [textStorage addAttribute:NSFontAttributeName
                                 value:font
                                 range:range];
         }
     }];
    [textStorage endEditing];
    [self didChangeText];
}

-  (IBAction)decrementFontSize:(id)sender;
{
    [self changeFontSize:-1.0];
}

-  (IBAction)incrementFontSize:(id)sender;
{
    [self changeFontSize:1.0];
}

@end
